//
//  File.swift
//  
//
//  Created by Soramitsu on 25.09.2023.
//

import Foundation
#if !Web3CocoaPods
    import Web3
#endif

public protocol ERC1155Contract: StaticContract {
    static var Transfer: SolidityEvent { get }
    
    func safeTransferFrom(
        from: EthereumAddress,
        to: EthereumAddress,
        tokenId: BigUInt,
        value: BigUInt,
        data: [UInt8]
    ) -> SolidityInvocation

    func setApprovalForAll(
        operator user: EthereumAddress,
        approved: Bool
    ) -> SolidityInvocation
}

public extension ERC1155Contract {
    static var Transfer: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "_from", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_to", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_id", type: .uint256, indexed: false),
            SolidityEvent.Parameter(name: "_amount", type: .uint256, indexed: false),
            SolidityEvent.Parameter(name: "_data", type: .bytes(length: nil), indexed: false)
        ]
        return SolidityEvent(name: "safeTransferFrom", anonymous: false, inputs: inputs)
    }
    
    func safeTransferFrom(
        from: EthereumAddress,
        to: EthereumAddress,
        tokenId: BigUInt,
        value: BigUInt,
        data: [UInt8]
    ) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_from", type: .address),
            SolidityFunctionParameter(name: "_to", type: .address),
            SolidityFunctionParameter(name: "_id", type: .uint256),
            SolidityFunctionParameter(name: "_value", type: .uint256),
            SolidityFunctionParameter(name: "_data", type: .bytes(length: nil))
        ]
        let method = SolidityNonPayableFunction(name: "safeTransferFrom", inputs: inputs, handler: self)
        return method.invoke(from, to, tokenId, value, data)
    }
    
    func setApprovalForAll(
        operator user: EthereumAddress,
        approved: Bool
    ) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "operator", type: .address),
            SolidityFunctionParameter(name: "approved", type: .bool)
        ]
        let method = SolidityNonPayableFunction(name: "setApprovalForAll", inputs: inputs, handler: self)
        return method.invoke(user, approved)
    }
}

open class GenericERC1155Contract: ERC1155Contract {
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    
    open var constructor: SolidityConstructor?
    
    open var events: [SolidityEvent] {
        return [GenericERC1155Contract.Transfer]
    }
    
    public required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
}
