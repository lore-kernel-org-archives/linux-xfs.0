Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5561EEA5A
	for <linux-xfs@vger.kernel.org>; Wed, 12 Mar 2025 20:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741812174; cv=fail; b=TxYJv1NwbQ0E/pL/+5AAlabnindOer8lY6SPwx50DaRJdI159Ygh8Z3uVMHDnbwM+xaCd71i4Qshtk7ArzojttMqy68HVIiuOyD9yQaQPkT5RU4z3ljLlvViJRvtRpfqr8M9vZ5MdrxIMWJqCvb/NOxalL90ETAeCsxjN5vBNA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741812174; c=relaxed/simple;
	bh=MMO20QTU2vjV7gn0wx2CoGVuzDOtWriLe0YFSOyu1is=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XADQPxOkW9Y4tddSCxHeTy8NL9ze3fGhKXHk6il5JTZ80H9sKMr82TqCXnsOsl8metg2i4V0ALfMOQC6l8XWfOQcQFj8rrLRa34cS1tSBxxnOCEsMZi4tlVeEO5Vj472HYKA+QBRqFvPV7f8a8s+EyGlD8sVQX/ZLtEimX+tZQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e00aLMbL; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e00aLMbL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bV27QMHOprsxyBa0p1EOOAM4hAOlnjxPMOSvTqUCryenIRGfDU1ZByxtQ6l01fdKBbtlTbSvMamt+jAiQTOewYaeoNsatq/kRMeqoKV7+QbsMWnmxa3zIqmruahQEasYiXDaHxpqd6Nl82II4y2nmOiBWXQFt565CkbC5hp3OKf2XGe9+R5eMMNaCMtrMrj1ks1BkPXn4h5Vo3fTrJ66VJOC8Bh1k9r9oSl/VwMwRR0tPehKwHBO/Lz3atHBM9mB8t5o8WgMXwzPuQW7bR9eJjXF7zTGvhhWpiFK/hHrDebTzH/v5lfNvP2FBpkjzkk+7gAnO+Wttng1+pIPjGEwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMO20QTU2vjV7gn0wx2CoGVuzDOtWriLe0YFSOyu1is=;
 b=rhKIbZ5adx+tC7bfeu0Rh2GR04NzsSWihKxHXnLowB8ONa/KFvRB2Jy7A/a1c0VwU3IclyAkCMsuv5ZK+NlscmAnBhuKhMJ+CxymXMI0jdHqP26jsO/pjvyCMPdTdhaN6zXTWFS7YrGUNT7ZPs2R1MIlHfzC2LPR97Si4NZbngg2Ol1nXluRbAMQVInULIfFgRVn82JymYQKkG3V++MfriefnIC/tMxlWm6zHkeYsk63krhPWpVlZ/GnyefUEI5j2HeV0Ml3zDIpgEzSMTdcvnIi3fxUvEQF+9AuUqWiIq0n8UwIvbU8pzRUnSYq2nD78SL0g9vLNho1Yw+ESDDnaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMO20QTU2vjV7gn0wx2CoGVuzDOtWriLe0YFSOyu1is=;
 b=e00aLMbLQEo7pnbQ+8h7RxfotgYjMK21jPCjsi8O0DYDb25Vk87MGv4LdkcvafF2oKSlXrnHGClZmZWWmEjYfJ0pon+FQSEuWFslPWUeLontPA8dzIMQ8Yl9YuloR+e3rap2wLpZDmYIQc0MUysrIZ5iAkMDGXBGu+a3p1Dg2KrLhOmA8bf2HEQKEAG2vr30gt83xA3V+3d0i4Jt5cDLn2Py6ezBhBfA+HR/1tLZZlxQQDAc/NqrNN7VndwTN1dALiWzQrqKpafx1qDjYAG5XWYBkZpa3L8RTeQzKWbkL+WEBVLC6Gt07a2ovsJn9HzhC6/ke3IUAhR/caku4Xljng==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 20:42:47 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 20:42:47 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, "cem@kernel.org" <cem@kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: flag as supporting FOP_DONTCACHE
Thread-Topic: [PATCH 2/2] xfs: flag as supporting FOP_DONTCACHE
Thread-Index: AQHbdzReBCuHCH6pOUioKPE45taft7NwMDeA
Date: Wed, 12 Mar 2025 20:42:47 +0000
Message-ID: <89864a6f-ba2e-4b09-820d-6eda6aa54c6c@nvidia.com>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <20250204184047.356762-3-axboe@kernel.dk>
In-Reply-To: <20250204184047.356762-3-axboe@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MN0PR12MB6296:EE_
x-ms-office365-filtering-correlation-id: 71a072e1-6f7a-447a-153c-08dd61a67301
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RXRBaTBUcit4MzZZTFJVTTFwZjhwZ3VLN2pRZFgxNDdBTWJxYWRFdm0wR0U0?=
 =?utf-8?B?Vk45Z2g2S3g4dVpFUVRnMjk4YVVuY0U4K0VXTFUvbEZyNGtNMWkzc0JqVXJk?=
 =?utf-8?B?eFBRUWNnekhaYU41VXJxK2JUeSt4Vy9FZUlkZElteDhyK3RETENjUnA1ZldW?=
 =?utf-8?B?L0FtVUlaVTB4MjlnOXZzRk1sTXFlL3RYUExCU0p6M2lCVFIwWDE2UnFad0JJ?=
 =?utf-8?B?WEVmbEZrWlA4SUZ0NWd1Ulo2dmJlWjRXSXFnNjBmdWdJYlRYd1p3L1BMUDc2?=
 =?utf-8?B?SmlpUnREK291NGRBQlU4TFFyZTZnamU1SHIzOXdzcGlCZk9sa0Z0clZjRGlk?=
 =?utf-8?B?eXducTIwMlptdEZVY2tBVzFHc1ZqNGdIM1lNMWs5cVBFVHNYaUYzWEVQSjE3?=
 =?utf-8?B?YndQSzB4TXN3S3d3VC9TUklBbWxLSjBhT3FsV0kvdE03bmd6amhRSDVKM2Zh?=
 =?utf-8?B?NmcybE9XMHZ4bkVjOTVpcEZidDJyakZ3eDUxQWJHMFFUZjZVQzFpOG11Q0tM?=
 =?utf-8?B?Y1REOVlrSCtWS0h6eVZrOG0rY3VVVnJySzlxMXE2NFJpNXpoVisxcm1zOWpF?=
 =?utf-8?B?K2pBSVkzUXRTQmMvclovK0FLUUVJSkk5S0pUaU0xNFZEL0dDMFpmVVA1OVdn?=
 =?utf-8?B?VC9xdzlhT0I0Umg5NVFGeWFQejZZa2o3QkdqcmZMb3JZQnljbnVKZ3pZdlE4?=
 =?utf-8?B?ODk1bnhvMlBLK0RIVHpOYXM5dXdpcUMxREJTVWU3TjNuQzJiRHRFa2J4Vk9K?=
 =?utf-8?B?RFc4K0I1Q3loU0lQcW1LLzRtbFlkRTJ2bTdCUXRWcFh5Z1NVa3NZTHJjcTRQ?=
 =?utf-8?B?TjFFUFFKcjJqWFF6RWowc2ViMEdyZWI4OVVZS09oeDA4ZnJPUmF6Q1drbDcy?=
 =?utf-8?B?Yks5aXNZSUJiM3hzNCtIRWhxMTRpYWlyMHZlb0xCdkxzMEgvR2JPZkhBMWxI?=
 =?utf-8?B?cVJqR3VSZ1JWQkppa2piNjRRci9keVBCRkxmcFdObXZQdnhFSUZrNkVrREdO?=
 =?utf-8?B?WlkzVUJ3eFlJcDluZDcxQjhNQ3c2cWx1N1MrRjRlRCtXdVRnSCtWNFZGR00r?=
 =?utf-8?B?N0hsVWtLL2JnOGdxaWk5c2t0OXlhanBBY2xnaDVlb2Z5aTR4cVFMY2hHVVVJ?=
 =?utf-8?B?ajREeTJtcnVjamErUUMyVjlWeDFWMjN2QjlDcDdlZzhEZUtRczhPZExYZHhh?=
 =?utf-8?B?UWZwcTl4ZWU4OWVmS2RyYjdwbDNKRmVwTHZ6azZZZkJxR2k3Vm1HSGJrUUZt?=
 =?utf-8?B?UThuVG8raDU2REZoM1d0bVVqMkJmNDJRM00yZWhhVEZYNGI1Z2M3dzJ5MHVw?=
 =?utf-8?B?KzdFTkt0cWsyTzQxYUszd29YR3d6QnkrRXdkem5TZzMxV1lvcElhbmJjT0pT?=
 =?utf-8?B?bkVqalVqbmk0SlVMK1hPMTNBajFFNmlwWlpMalh2dVR1N0p4eE1kakVNQ0Jk?=
 =?utf-8?B?TS9DK0hONmtNLzcwSzM4bHU3WnpaeHp3UnlxRDh5M1dyaXlnTkxXRGpmVHp0?=
 =?utf-8?B?NlFmUS9wV1NlTGdWSDJHTm9VVXNITnRQaG1ONVNWK0VVeU9tYkFKaUM1UElm?=
 =?utf-8?B?SlF4REhGODVXYnJKRmI3Qk5aQWp5V3JBVnJEQTVnbHFIelczZW5MYnM5T0V0?=
 =?utf-8?B?cFVkOVNUNW9kMm5ZZ1puOGdXZXFMVXhhNEs5aEplcWVVLzdsTHhsUERiVDc1?=
 =?utf-8?B?MTkzWk1xaTNscmFPME9lSytsb1NTRHV0dEU4bEg2Vis5eXZMR3VqeFFsQjFE?=
 =?utf-8?B?N1Y1RzJqM2hac3ppRTN3RDdyaG9EdFd1Qi9BQzZUOHFXTUJma1Q3V1h3QW5h?=
 =?utf-8?B?VjRTdW01MnlKS1J2Q2VUUTZVWjRPb3VjcWhFQWY0MTJHSUNzSFR4ZUpEKzFO?=
 =?utf-8?B?TFhlMUdka2dzb2gwTnBmRzh6dHl4bTA1WlpHakRJcjVqcmhWejRZb2NrV1dZ?=
 =?utf-8?Q?zEjbm71Y+NzqQ5ZTq8nrB1PIPg2Co7X4?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SXRVRFo4Zk11bW9nRXNqSk9hMmM5NW8yaHJLM3FZM01ZWGQ3MlNJTjllUXJ5?=
 =?utf-8?B?MXNHdlRDUHM1ZGdhK2ZxZEFIcWlkaXZJc1JzQU84a0E2OFhvOUl4UkFPMlFK?=
 =?utf-8?B?ZVJ1cUJEbngzYWhrVGVTZ2RvcW9CVk53cWhCSklmSER6d1hKQ0VOOTBUSEJN?=
 =?utf-8?B?YWk4TFljTzVmWXJtTWFUK1pIL0xFQ2JuMTlUZUd6eW96Wk10alNXZjlXRW0x?=
 =?utf-8?B?ZVZ0YkFWSFVQaEZFNGlOVmhEQ1BBVGNWNk5xWllPRFBMSnk3eGtuWVVxZTRV?=
 =?utf-8?B?RHAvQnpvcHNKYlIwWlZ2S0NvTG84TGt3OFRoNm5JOVVHOU9OT1dzVk9xWHM4?=
 =?utf-8?B?Q3dPRm5XSG9NRG1kMzk0aTIreUphTnYxczlkQmZDaDRGS2lJQm44ekRWZ291?=
 =?utf-8?B?aWNoWmt2Rk9pT2pDTDhkdS9sNEVCRk0rZkVlc2VtaFg1MDZDQ3lvMDRqOG1O?=
 =?utf-8?B?WWhUbnd2RlVLejRNUDZtTG0rN0ROQy9Nc3FNMmJKZnZkUk5yUTVDNUpTNUhu?=
 =?utf-8?B?enlCdk1JTGU0K1ZYRGgrMnorcHErS0FEd2tvTE1BKzRTMHlhbTBHdkFFL3R2?=
 =?utf-8?B?S3VxWGIzeDBBczlZd00xZzFKVS9IRHdtWmdJbEhHTE43N2ZYVWE0UWJiQm9m?=
 =?utf-8?B?dTNXRER1ZVhnbmlIQlZkZGpEMFFBRTZnOGpVejJBNjY1YnJRc012cWoydEFu?=
 =?utf-8?B?MjNIenl1Wk81VnkrK2V0eWFXcmFMMUVmeVdjRHNhT0JCaitOY21OZjNYcDJV?=
 =?utf-8?B?cms1VEt4WW82N1NNTTRBOUdYbmhBZGpMajFXZW43WGZHS1FoNnFNN3NPNWc2?=
 =?utf-8?B?YmtGTUZMNGxORkNHM3BPUVQ2dytQQnBhc0EwUG1QV0tpdG8vWEJlZ0ZzdVpR?=
 =?utf-8?B?QXY0R2pSUG9qTUJNT3VIZEJXY0VFMDF0THdBNW9sMlZuaGU5SXY0TEd1b3o2?=
 =?utf-8?B?R2hsSDBmYmpZKzZ3QXRhTUpUbC9adytiQTJMYkNmV1dUZGdIT1pybFhhc1Ft?=
 =?utf-8?B?UC91UXhJanpNWlovOEdVblZFZElZaC8xbjVaMlZMSmo2ZzBTVG05aGJHSmdh?=
 =?utf-8?B?RE1DbnlpQXM2TkVMNVBwM3FPUGc4d1B6dnJlYWRVTjZVOVMrcUt0VE5yWGNt?=
 =?utf-8?B?U3Q3bXpuV3p4UFJjZHQ3cXlvMDRNbnpYamRZSTdhRFZMV0ROcGNvTFcwcWV4?=
 =?utf-8?B?NklNYU1VU2U0Zks3MWdTYTlNaFh1ZlBVYWZtY0gzUWI2YThTWDM1cmRiaTZy?=
 =?utf-8?B?eUkyU0hJTWVvSURHQjVkbjh2YjVIeTNiakxtczJNaWUxa3BwM2lJZ3Y4QkRp?=
 =?utf-8?B?U1h0MXZ4dHlZeUN3RWZ6VUhIVy9ySHFXTDIxbFJrZUowbFBvZlc0Y1lpb2Ru?=
 =?utf-8?B?azYwOHFEUFRLR1pQU1RHdTBWc0tjdktDb2VjUjkzbjNNT3FpWWdJSFUrQlcy?=
 =?utf-8?B?c2UwSmZ2UzhDZk5ON3JTbjhUcjdyYkNzRTdvRk9nSDgweWNMUm5BMGZLYkJx?=
 =?utf-8?B?NjZ2TlVtSzRYdjR1a1h4bFR2MFdzMjcwS0Y5ODdRRjdncUNxVVlzOHc5MmlJ?=
 =?utf-8?B?Qi93T3NRemNoUVBEQkRzQmw0dG9OOWk4UlZ2UVMxc1YxdHcybUpUN3RLb2ZQ?=
 =?utf-8?B?UnZZTlBtMkd1VVBORE8ycjlUQ3lFQUtQQkhwa1NlRGI5RnhxRjZWNTRRWVh2?=
 =?utf-8?B?TXZlT2FZV3Fwa3Z1LzBYYjF5RlNaVTlySElwd2tpSkp0Qnl2L2xDZThvSGlF?=
 =?utf-8?B?NVhTSitGdjBkTzlmWmJ2M3d6OEl2R1poVG8zYzJMZG9GejdxNmxvUFZ5c3lo?=
 =?utf-8?B?VTc0N2t5R0FRS09VdHpFSDFpYWdWS3pMUnZqWlF0U2FxZ1ZoY3Zyb21XVW1w?=
 =?utf-8?B?bWhDN0F5WlBOQlcyK3ptRkdHTURVUkNXZWlRU2hlYnhyeXVkaEVjR040QXMz?=
 =?utf-8?B?dXA3L293a1QycTY1NStGVCtjaFZ6SFBEUUpsc2l5Z0VsdWJSQTZsSWVIRlh0?=
 =?utf-8?B?K1JBaFRnbmsyRktxMFlQeW4yY0xHeHJPQVJjNE8va282OUhEODM3REV5NVZp?=
 =?utf-8?B?Y2U5RldnbG5GaUJlQ1U4SzlxMFZHa2trR1JVTEllTEFwVjFyZHBpRXNySHVl?=
 =?utf-8?B?U0ZiK1JKWUFJc1B4R3p0VGEralRXZFp5OWdjdUsrajhYQktZNDhzblFDTXNJ?=
 =?utf-8?Q?7LWqh+SGEMAMEmyItexvj1jK3oxLIQLh//o2Zmgx95b2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3130E5B377FE2B489B121CECCF4AED24@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a072e1-6f7a-447a-153c-08dd61a67301
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 20:42:47.8322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HOmOTa4CKlEqJ0eqp5/Rv6V8XqhAuKdUC/WTEcIotggFsEX5nUP66z6BbfQRscHd4lRrV1tRr/2ClpxfSDVdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

T24gMi80LzI1IDEwOjQwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBSZWFkIHNpZGUgd2FzIGFscmVh
ZHkgZnVsbHkgc3VwcG9ydGVkLCBhbmQgd2l0aCB0aGUgd3JpdGUgc2lkZQ0KPiBhcHByb3ByaWF0
ZWx5IHB1bnRlZCB0byB0aGUgd29ya2VyIHF1ZXVlLCBhbGwgdGhhdCdzIG5lZWRlZCBub3cgaXMN
Cj4gc2V0dGluZyBGT1BfRE9OVENBQ0hFIGluIHRoZSBmaWxlX29wZXJhdGlvbnMgc3RydWN0dXJl
IHRvIGVuYWJsZSBmdWxsDQo+IHN1cHBvcnQgZm9yIHJlYWQgYW5kIHdyaXRlIHVuY2FjaGVkIElP
Lg0KPg0KPiBUaGlzIHByb3ZpZGVzIHNpbWlsYXIgYmVuZWZpdHMgdG8gdXNpbmcgUldGX0RPTlRD
QUNIRSB3aXRoIHJlYWRzLiBUZXN0aW5nDQo+IGJ1ZmZlcmVkIHdyaXRlcyBvbiAzMiBmaWxlczoN
Cj4NCj4gd3JpdGluZyBicyA2NTUzNiwgdW5jYWNoZWQgMA0KPiAgICAxczogMTk2MDM1TUIvc2Vj
DQo+ICAgIDJzOiAxMzIzMDhNQi9zZWMNCj4gICAgM3M6IDEzMjQzOE1CL3NlYw0KPiAgICA0czog
MTE2NTI4TUIvc2VjDQo+ICAgIDVzOiAxMDM4OThNQi9zZWMNCj4gICAgNnM6IDEwODg5M01CL3Nl
Yw0KPiAgICA3czogOTk2NzhNQi9zZWMNCj4gICAgOHM6IDEwNjU0NU1CL3NlYw0KPiAgICA5czog
MTA2ODI2TUIvc2VjDQo+ICAgMTBzOiAxMDE1NDRNQi9zZWMNCj4gICAxMXM6IDExMTA0NE1CL3Nl
Yw0KPiAgIDEyczogMTI0MjU3TUIvc2VjDQo+ICAgMTNzOiAxMTYwMzFNQi9zZWMNCj4gICAxNHM6
IDExNDU0ME1CL3NlYw0KPiAgIDE1czogMTE1MDExTUIvc2VjDQo+ICAgMTZzOiAxMTUyNjBNQi9z
ZWMNCj4gICAxN3M6IDExNjA2OE1CL3NlYw0KPiAgIDE4czogMTE2MDk2TUIvc2VjDQo+DQo+IHdo
ZXJlIGl0J3MgcXVpdGUgb2J2aW91cyB3aGVyZSB0aGUgcGFnZSBjYWNoZSBmaWxsZWQsIGFuZCBw
ZXJmb3JtYW5jZQ0KPiBkcm9wcGVkIGZyb20gdG8gYWJvdXQgaGFsZiBvZiB3aGVyZSBpdCBzdGFy
dGVkLCBzZXR0bGluZyBpbiBhdCBhcm91bmQNCj4gMTE1R0Ivc2VjLiBNZWFud2hpbGUsIDMyIGtz
d2FwZHMgd2VyZSBydW5uaW5nIGZ1bGwgc3RlYW0gdHJ5aW5nIHRvDQo+IHJlY2xhaW0gcGFnZXMu
DQo+DQo+IFJ1bm5pbmcgdGhlIHNhbWUgdGVzdCB3aXRoIHVuY2FjaGVkIGJ1ZmZlcmVkIHdyaXRl
czoNCj4NCj4gd3JpdGluZyBicyA2NTUzNiwgdW5jYWNoZWQgMQ0KPiAgICAxczogMTk4OTc0TUIv
c2VjDQo+ICAgIDJzOiAxODk2MThNQi9zZWMNCj4gICAgM3M6IDE5MzYwMU1CL3NlYw0KPiAgICA0
czogMTg4NTgyTUIvc2VjDQo+ICAgIDVzOiAxOTM0ODdNQi9zZWMNCj4gICAgNnM6IDE4ODM0MU1C
L3NlYw0KPiAgICA3czogMTk0MzI1TUIvc2VjDQo+ICAgIDhzOiAxODgxMTRNQi9zZWMNCj4gICAg
OXM6IDE5Mjc0ME1CL3NlYw0KPiAgIDEwczogMTg5MjA2TUIvc2VjDQo+ICAgMTFzOiAxOTM0NDJN
Qi9zZWMNCj4gICAxMnM6IDE4OTY1OU1CL3NlYw0KPiAgIDEzczogMTkxNzMyTUIvc2VjDQo+ICAg
MTRzOiAxOTA3MDFNQi9zZWMNCj4gICAxNXM6IDE5MTc4OU1CL3NlYw0KPiAgIDE2czogMTkxMjU5
TUIvc2VjDQo+ICAgMTdzOiAxOTA2MTNNQi9zZWMNCj4gICAxOHM6IDE5MTk1MU1CL3NlYw0KPg0K
PiBhbmQgdGhlIGJlaGF2aW9yIGlzIGZ1bGx5IHByZWRpY3RhYmxlLCBwZXJmb3JtaW5nIHRoZSBz
YW1lIHRocm91Z2hvdXQNCj4gZXZlbiBhZnRlciB0aGUgcGFnZSBjYWNoZSB3b3VsZCBvdGhlcndp
c2UgaGF2ZSBmdWxseSBmaWxsZWQgd2l0aCBkaXJ0eQ0KPiBkYXRhLiBJdCdzIGFsc28gYWJvdXQg
NjUlIGZhc3RlciwgYW5kIHVzaW5nIGhhbGYgdGhlIENQVSBvZiB0aGUgc3lzdGVtDQo+IGNvbXBh
cmVkIHRvIHRoZSBub3JtYWwgYnVmZmVyZWQgd3JpdGUuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEpl
bnMgQXhib2U8YXhib2VAa2VybmVsLmRrPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTog
Q2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
