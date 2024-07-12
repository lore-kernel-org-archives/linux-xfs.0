Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B1143AA9;
	Fri, 12 Jul 2024 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720806021; cv=fail; b=nr5/91qDT6kEi3Td67+ArJaSzDUU5PBqpbuCvhSlWR9mvp/Xsc1D9AMi0VwW1g99xV0vGAgp9GMlvo3DwdoC8i0vuEowcVCE2GKkx2xIFUYFyshCS29pyjplSmB8bu3fA4mmGPTBmL6AhjoeXhJcoeMm8DABSHKYqe32f0WavkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720806021; c=relaxed/simple;
	bh=bYlJAsXUkcgQ0RRNgtEmUaqiJpCp+UdZucjiHS0kv+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dj9D3y4rFyvEhca4WdJaAJqPRAX6cWNRFSJcuYly79dPlNYAsDld4o0EUW3yHATe4VYuwFEgfLIGXl9cOaMfnz56eHdUdWSf06xzSxmuIfrZQ6wHuFc0fIHXJewIRtGMloO/hhgaCYUPjnIPEs8McuBww80kAR27vfBRGy/WwFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rR/HIt/F; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rR/HIt/F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIPObLdeoSqXJUykNd71vvdJqMzJuIrdjRiljGfVBiglB0im6tBnGHSWXY9Ay3ErjpRdtquS+Qy/B2Ez7bh7qmuM2ZSU920hAmVnacc/MPNSm3tWeWRENS5Aus8HaMJwX/FK/slr1R/2hhsfDYElT85G4A5/8m2SvHm31oigjiD2ObBrJweomvBGtQ48QYub9/qcrDNwpl7e9OSPXKnGamCc/ur2sTsT+dB6oSZUftM7boO1NZOSbQsOeOJAoH6WnsQsomLr862gzixSBtysPW7tREMRqs64vxNGoqpbCpwxXjr0lj7YbBk9QSylTccfJIGXTKAqZxrEQWan+O4bPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYlJAsXUkcgQ0RRNgtEmUaqiJpCp+UdZucjiHS0kv+0=;
 b=gUj5ATpMgU9BqpkeO28aGN1NiqvIehhHFcNwx4Tu5SzwVlq1/kd9HihF5bhE4WEkPf7WoE77/l9bJqmXfe5j/c1GW2/lMit221B8VFDMSfhCda96pJfAvHchnaDhjL25RW2joq7h/mHiQRg3Z6f3K0QUA5E5erx+8SopnkizH8MZgphWdJOZogwSXT7IosQXuiwl55Qq+JGUwexLJojPyr8S/YzQfcnd578mAw277RF6SR0iWLTeYIneon/GU8wIL2J/GMLFIT/efOxgjf6FZ+PYHqu5PL17QR9S6vdRVqhvfd+C2Afmwpe697eIStty6LIIhEl/og2hHcbnjM6d5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYlJAsXUkcgQ0RRNgtEmUaqiJpCp+UdZucjiHS0kv+0=;
 b=rR/HIt/FU0jNmMDKOW+Vv7t/BWDBQAqMWz7AxNWoc+aHuK2exF3PXDDf5sRq+u2NGVzt//5wMzGOUOqnrJhREwm4S69fwMO3AHEO2SGfaObuzRQcpLwlhpBYk8q6WcvpSzrK94I+QaxkUgZ/rGyQCAyZVAvL0x9/MQfCBHERmB0QpPj+iUt50GcIKHNjTARQmQGDO3yf89JaQpwpxtypNh/G/84qoB70Bv5kRkoCDa+kjjtpCkHUgQ3DPwimOAPGvEVePr7HE2aymeliqp/3OFLM4yf8UwRo/FcjKEZE551gQ/V7R0sbBWiJ4KCoTxfHDk046e3xIeKc0bev3ut8iQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by PH8PR12MB6890.namprd12.prod.outlook.com (2603:10b6:510:1ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.21; Fri, 12 Jul
 2024 17:40:15 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 17:40:13 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Chen Ni <nichen@iscas.ac.cn>, "chandan.babu@oracle.com"
	<chandan.babu@oracle.com>, "djwong@kernel.org" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: convert comma to semicolon
Thread-Topic: [PATCH] xfs: convert comma to semicolon
Thread-Index: AQHa0dLNZOQMoRnJZkCdz3Fm1jlPk7HzYXQA
Date: Fri, 12 Jul 2024 17:40:13 +0000
Message-ID: <1fd834f9-3b9b-4326-9f03-7deb888b764e@nvidia.com>
References: <20240709073632.1152995-1-nichen@iscas.ac.cn>
In-Reply-To: <20240709073632.1152995-1-nichen@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|PH8PR12MB6890:EE_
x-ms-office365-filtering-correlation-id: 6fe6d5ed-a5c7-40b6-78b8-08dca299af3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eEhjUUJMUFVzS2FMakV3VHNSdnBaK2xrZy9yUnlJcVlha0pNbFpXUm9YUHZB?=
 =?utf-8?B?Sy8vQzZXcldqbmJkaEhGTHZBaGFsek10aW13RHdxMkhmWnRBWlZCOE1uLzM1?=
 =?utf-8?B?ZlZHeG1ybFBSbUhoa0E5NXpYZStSQ3lqcUM1UUpCa3lRdGxia2xVOVZzT2t3?=
 =?utf-8?B?N0VYTExQOUc0L3I1ZVQvaVhIc0lVZi9wQWV0Q3ZvNVpjWStTMG9MdnoyZlFM?=
 =?utf-8?B?cGplTWs4R2dXczBrSCsxK25aTzlZSDJ4VUlvVXRBQjRqaVpJK2VKT3IxZy8z?=
 =?utf-8?B?ckNyaHRlRGlqTytRSStiMlAyakUrNXlxQmhCWmxCdW41aTdsTDVIZjdHVlA0?=
 =?utf-8?B?MXViQTZGN0V6TVEvOVJyTnIxa043QThMaVkwZFBFenV4S3gvaGJJbEErMzhS?=
 =?utf-8?B?ME5HUGdibitzWGVVVHhHZTJWckJFVHdNNFhYV1dpaVg4bnhUbU9HKzRzL3lz?=
 =?utf-8?B?SGxPUERyOFd5QjJpMHcyUnFLbHJVSkhFQnpUVVdodXV6T0lpYVBOVXdkaXE1?=
 =?utf-8?B?Qy9lbzFpWmZNdHVUVHlRVXgvMERBenpzM2xoQm9qejQwaFFZMFRNN2REL2VD?=
 =?utf-8?B?TkM0cERXZTE0WEI4MG5TdXMyeUNnRjBQY2FFQjN4RXJIZFZEelU5SWEwZDgz?=
 =?utf-8?B?RUJ2Zk5EbFBsUHVuODU2RStQR3V4QXlIaEx0MnZIQ1lhaStaNGlVbTRRVy9O?=
 =?utf-8?B?WWUyZEtaMEVMdmxpYlZBcktuREpERDFWOXRka0lnT2o4UGx3WldDenp1dGhv?=
 =?utf-8?B?OGFHRjRPWExjc3ptOWRkM3NMWGc4R0JpNkNTNGRtRFcvTWpjRW14TmhYTUdq?=
 =?utf-8?B?U05WVE5LMFpmWFROL0dERDZYR0pmYVZIWXk3elFYVUkwRWRVVnRFNlViYXpK?=
 =?utf-8?B?UDZOM2lQRTZQK2U3Zzg0alBmdXJvMFpQaTUvWGl5K09GdlBRWTVlOWdkek1a?=
 =?utf-8?B?TWVOMFpVU3I1OTJBNlZRL3lZSXpudnBRUnJLZVNhTVZTRmdYMzJUbjE2M0J6?=
 =?utf-8?B?K1VwTE52TE1vb0VxOFNoYkM0VUVKS21BNy9kTE05TWRUL0Y3Sk1MMldma0Vl?=
 =?utf-8?B?aWhRc2o4S1B4S0gzZUFud051MmlQWGpsd0tqVDNIckx5eHI3UlUveFkvWDIx?=
 =?utf-8?B?U3ErV3hMR0x3dldWakRGV2p2eWJQdDdqNWVjRjZRRWIxN3BpcGlCS09KZWV6?=
 =?utf-8?B?c25HZ3YrcFRQYWxpTTJ1dHBDYkMwY1FwTWtZeWo4cURldTVqTHZvMklwYlJT?=
 =?utf-8?B?YVN4dnl5UWI0ZnN2WVpQMXhVTHFoRkNRN1Y2T3AxR1lHN0l5SnJpN3AweDhQ?=
 =?utf-8?B?V3pUUWsyUVNNRWF5aU41Y1NrMUNLUjB6dnQ3eE92U2FURE5ST2VXbzNsSmMy?=
 =?utf-8?B?bmEzaDZ3cGt3M0RPZ3NxOEFzdWVKVjlkTlFEUSsyNXAzcEd2bG43T0Z0cE5Y?=
 =?utf-8?B?MDhGcnNrYUNkRVEwNEsxNnVOb2dvUTloWVpJeXZXem16dmZkdE1UczlGbXFM?=
 =?utf-8?B?Zjhid3huR1M0YW5IaHRhQ2hOOHVJVDhtaTJCSVFNMml5ek82NGkwdGJ4Umhy?=
 =?utf-8?B?M2ZkU0FQMEdBZk5KRklkeXQ4UlJxWTZ5QWt0Wk16WUo2a1kyRUY1WUc1T1Qy?=
 =?utf-8?B?L3o5bHppU0FFakZlbCtpbWtOUGRnUzRId0ZQK0RSVWtsQU9Jdzk1Qnd0UzhC?=
 =?utf-8?B?SjhJVUs2UFJEVUpGMnpTcUVKY3ZiNmJ3WWNRb29oYVMyVHQzS255R3ljMU5l?=
 =?utf-8?B?OG00akxJMWFoOFdiM2k4ZWZycVZNakRXbzMvTld5L2hKTFZiOVlnd3lPMENQ?=
 =?utf-8?B?SlNtTHMvMTBzSUlrSFpLU2tRbkl1R0RVQXh4VkhSVjU3SkF5d1BjakFkYmpi?=
 =?utf-8?B?Um5QM1RxYmRvQXZnVzhnRHFPUTJ6Y0JIRFlmaS9oTnY2RHc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?czJmWkhhQkpqQ09zc01xTy95YUNya3J4aDhqamhLV21sNXNoQ2pYWkl3ZlZr?=
 =?utf-8?B?UDViWkpaRndVTW01M25RRFMrYUFqeHVJWms3Q3AwbW9NanBhaTZ5R3kxN3JC?=
 =?utf-8?B?NTArY3lFZ3ovQWZYOWFIZElZYkVJZ3N0dTRJVS91VjhVZzJsRlUvNTk2dlNG?=
 =?utf-8?B?YWo3MUZBUDZhRHNRYlZHMDNLMjBqcjE3R0swa3VaWDhZeVdTS0xienMwa24w?=
 =?utf-8?B?bmk5d3htaktzM2gwTkZWQlhGN2RCTjlOQWc4N0MxZWlnVTUvSEFPUERiczZU?=
 =?utf-8?B?Ym00SG5peSszaE9DL0xWQUNiL2VJY1lFTURFN1ozS2I5ZXNHY25kR0FVSWtZ?=
 =?utf-8?B?b1dOYnAxYjdtYmc3UjJUc3M5Ymk0T3d5TWkxVVJ4UC9kTE5jbCtkWGpneHlH?=
 =?utf-8?B?R0RjL0dNNXpBd0w3WVRGcURRMVNUc0FUcWd4OFVFTlNvOG9NOWVBMFhLNnZ6?=
 =?utf-8?B?U0ZTaFUzdEZwTWN0ZDh1WW1LYTJCTjd0UmhmYno1TElxVzhUL3FocHAwbG1N?=
 =?utf-8?B?R05HeXJPUTN5V1hDZ0JZbGZCS3QzZGNUSVphRVpCTjlCUzNFWk1GdlVnMzgw?=
 =?utf-8?B?SWZ1cHhqalQ2MVd1dTNZdVc2QTlvL2d1ODNZL0pydXFjYitJYUZRbWJWVWli?=
 =?utf-8?B?bkpJTHp0UCtSdzNXZklyZzEwczV3M0tjQXYyMm5uaGNDK2tYYjloWDVEKzg0?=
 =?utf-8?B?Z3h1TURIRUo2UlQ3SFRnMlk4dm5GNUJrZkZCelBKQkd4QkdBcHVZMnhmTEFY?=
 =?utf-8?B?TkhzRWhCbXJiRXNTZTdTSFZZOVJVc2c3L1dHQmxYL2tqVURWcTZWZjMyeDRj?=
 =?utf-8?B?UjVOc2xnNWM1a2grYS8wbWpWZHE5dlZaRmkwS2g4TVZBNWdzR3lPdzNIUnFZ?=
 =?utf-8?B?TTNZZHJiMGZidlJ2VGVtT1NwV0Zha3dLMlFGVjJzM3JzSHR2NEo2VFJsYy81?=
 =?utf-8?B?aVdEV3oyeTB1ZTZZQzVwV2MxN1dpQ1h3d3VsaU5LaDNDcjExMGh5UWhvWHVK?=
 =?utf-8?B?MlNSVVpKVGxQU0ZaeE1TTjRraXF4VTZuWEQ4Q09HdTB4N0VJeGtoOWdKMXdw?=
 =?utf-8?B?STFlSS9NT3EyMExiSnJkSUZPZTdFbkVwb28wOWlxalRyaFpaUExudW4xdEpn?=
 =?utf-8?B?QWhiKzhscC8yeEx2aU9SMzl4c09lNmY5U1hvaWt5MzFSMzJCTUIvK3hDVmtX?=
 =?utf-8?B?SVB0U0F2Wmx1MzRScGdaQ2VXRHdEVmw5SmxreUUwNVY3TkFmelU3TkNVd2VF?=
 =?utf-8?B?OHM0QXdzaGg2NFBiSmRtSm1YajN2dlNjbDhhQlhvUkdEUlZxdi92Mmo5bytR?=
 =?utf-8?B?emRkNkl6SWNVblZPbXFNdng5VkJkT3ZjMG4yS1liMDdVUXRuaXhLRzAvYUJw?=
 =?utf-8?B?ZXVNeEpLRUdVT0wzb1d0V2dsZkZsb3pxNnIrNzQyRTdWN0tBOWV4S3p2a3dn?=
 =?utf-8?B?UUx2alh5Y0RPQWFyNWlzUGFyUXB5SjFOb3dMRnhMZUs5bDlQZTZ5aU16emF6?=
 =?utf-8?B?T2hxY1FuemdDVGFSa0pTOEVIcUdEa0xTNWo4eW41bVJ2YXplVHQyRFNRb3hv?=
 =?utf-8?B?c05zVyt2N1B0WC9FN2Z4RDlNS0Z3bUFzejdsUmg5SkZLc3R2VTdhZjhPeUFP?=
 =?utf-8?B?Ykwzb1M0NzR2T3VHYmU2QVV4a3dYR2FBQkhnaEFCL1ZlUEFjdm5JOVBDT0xK?=
 =?utf-8?B?ZUttQmhpMUdFR0IzVkJISVR1QjI0cFZLMkV6RE9OamoxQUlUTWdnV0pmay9V?=
 =?utf-8?B?SWlpZXlIcE9zQmhONExONE5SY2g1MEFjSkZFUTRic0tLZGhWSXd5YS9hMVZ2?=
 =?utf-8?B?MXVNYnRkR0IrWWVjRVgyaE5GVitBQzl6aUJQZS9NeHBXWUd2U0M2UzNDa2hy?=
 =?utf-8?B?bG4rRWNoY1pWN0pDS0JOQlFFMDF2cWV6eG9CYW9sN1phZHZNalBUSDJaOWJ0?=
 =?utf-8?B?eDBoelBFUDNNbzVxWGlvSjhLVkp4NHlvZEZWUHZXYWE3bTdGdHQvVjdRRFV5?=
 =?utf-8?B?VUFWL2NGSDhaNFRqQXhOakQrOVBsY1UwWjZzVFQ2WWs5ZE1VUXF1UVRMYnVn?=
 =?utf-8?B?Z0QwTktvVVkrT3ZzRmVYTy91Z1REYjlWR1FhdFBNRWJrcG5lS1AwMDdVTm5x?=
 =?utf-8?Q?/SIOhJbl4pktFdjH6KEScdsbc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BC154DF3DBB7B48A04C2BDAB35912C1@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe6d5ed-a5c7-40b6-78b8-08dca299af3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 17:40:13.3065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VjlG1eGSE0jZrn3OmPvHDpirgWhj0kM2p8vK3bRXJrFUB4+9GqOqsAg6wutPV/omeKjdILfWDMzRPlO4o3yziA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6890

T24gNy85LzIwMjQgMTI6MzYgQU0sIENoZW4gTmkgd3JvdGU6DQo+IFJlcGxhY2UgYSBjb21tYSBi
ZXR3ZWVuIGV4cHJlc3Npb24gc3RhdGVtZW50cyBieSBhIHNlbWljb2xvbi4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IENoZW4gTmk8bmljaGVuQGlzY2FzLmFjLmNuPg0KDQpMb29rcyBnb29kLg0KDQpS
ZXZpZXdlZC1ieSA6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0K
DQo=
