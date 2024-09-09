Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248F1BAEC1
	for <linux-xfs@vger.kernel.org>; Mon,  9 Sep 2024 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725892535; cv=fail; b=HoKytAaETv/aysja9pyYV+8qXcNFuzfXCxGQqhS3mIu+hiIKFFBV4P4aB6uozfVq6hsQwcg5sM6U7vv5tsHL1c8p3s5IF+uFoUeJzVgRJmu6Tg+aP8L6+f4nhgEtZhACmiGPQS93TiPf/TG8AWPwpe24OVjJnD/1OZPN55cY9cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725892535; c=relaxed/simple;
	bh=xjgC3nPXQhdqwcd717Z5Ms9Ze1XDBerT3MOSXEun7I4=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mkl4j8KA4Q3djlMlO3YgnKotywMjoMHWozGN0rJZc+jImg/4L/qIpPgXPCZpC/nQpWzoOcNJFTKvMc7p1B03NawPFknhGZHDU9T11d5wu9TQ1t8TDKf7fD0ckCwTwsPEMUatjlYJlVzDjFX8mzQkgRrzv+g4Fy1mrWHEQvG5GR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WxtdSGcS; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WxtdSGcS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUY53+atA2Y2SOgc9Lgt8Wm3fqXo54lF2YZiC8WhfIQcQEPGSrSZpQV6V4FrcOSMx1DAW1ra4zCY4n7iwkou6ZKFhznKmkZoicvsGxO0u0NNRS6D5lfclhsCf/1CdhJaomyCVdXh7oi5FVQrYjxILhXIl97ugfVQqa6mkRU3ZZWKRTv/69u8D2syBOowlzXTfwsL2qw6i9MmO+hgn4OpglFGWXmuics+IiIa1h3KPP3ITb3duEU0iBORRBzDUYLz0pqYXPffEvV0p/C8G+RJhJi2yvHPn7HQ0g+m+QQWFlnuYR57QqRvmDm0ga8ACwu/UVDxYq2S3Y0UC/5b0B+e/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjgC3nPXQhdqwcd717Z5Ms9Ze1XDBerT3MOSXEun7I4=;
 b=vDlPKVbvaSA4hEcP9oT5fXAf20HBfRKTcS/UtNtadVjnsyRIPXbHYGCZqQb886cPGxNqRDzpFDNyhbS3B+gZ43qpixGURj4vbn8Qxnn6QM4tr19ayFQzXdOpPpEFkEHwZpCLwN1Nlb6Li87fWrtYgkhTPZatQRqoCxnxS1BuraeOR9NTmCKndB2ed/tM4lHTu5LapBINwrMtbQwvnKJy6cuzubizTS/8D383Mofwqjws01pWtSGJwNYKs1jxy6DeqDnGMnld6Yc9ek/LhefojTzRgM7nMlK6gNP5Zbl8RnBZB1pywFfH1tu/QWi63oDv+55NI/5swpyBEO4AUJ4Z4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjgC3nPXQhdqwcd717Z5Ms9Ze1XDBerT3MOSXEun7I4=;
 b=WxtdSGcSnZKrO8AqCf3RG6d7Ul7ff+bY2iSJq3TIe4exI7sgQH614rhvjgjZPXB3DNr1pNQKHsC5UEIIyQPdS3idMvX6aB19KKNeTeu8QYtIf1zsrzxpWRzaslpV/bRDVVjXJDByqBIWMlvrz2tNX2hw48Qp88GDeVkU0ih3n0zMRHDM9q4A5ZaKP92nUb8z9zAS+knB5SacHPWcswDBesFCro920GzQVCVdnrmxq2TTLMW5UE0n/epoGuBRa7fMSXMuJmSo1/aejhOxBOlj6c8lULNgYajeYUVKKIvvAs/kH3XeIBvojMgtdH+WnO8dbifAcl6WK3a7KnkjgmeRVA==
Received: from SA0PR12MB4590.namprd12.prod.outlook.com (2603:10b6:806:93::11)
 by LV2PR12MB5896.namprd12.prod.outlook.com (2603:10b6:408:172::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Mon, 9 Sep
 2024 14:35:30 +0000
Received: from SA0PR12MB4590.namprd12.prod.outlook.com
 ([fe80::b38d:b70e:8f4:42e5]) by SA0PR12MB4590.namprd12.prod.outlook.com
 ([fe80::b38d:b70e:8f4:42e5%4]) with mapi id 15.20.7939.022; Mon, 9 Sep 2024
 14:35:30 +0000
From: Michal Dulko <mdulko@nvidia.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfs_quotas error handling
Thread-Topic: xfs_quotas error handling
Thread-Index: AQHbAsWFRsAPvKpX1U2v97wFJunRxQ==
Date: Mon, 9 Sep 2024 14:35:30 +0000
Message-ID: <3ca7f9e9524f6d485e5fd23ac4c63920f5b934d7.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR12MB4590:EE_|LV2PR12MB5896:EE_
x-ms-office365-filtering-correlation-id: 0691da9e-8805-4e86-7119-08dcd0dca7b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?U3BnNHpOeHVxQ25NRVJsSnZ4b1dHaUpIbElGQXlkakVzSXRYSElZdy92TXha?=
 =?utf-8?B?cU53OUVpNnhqTW5GbzF4RTUveW1MK0Q1bU44ckhhc280OVZORnN4SDN1SWhR?=
 =?utf-8?B?OE9NVi85Y0RQSUZ5enNXQTVkeHIwRTBPeFJXVGF4dFNTUm9OZzVjb0Z5MG0z?=
 =?utf-8?B?ZmxiWW5UOVBScHgxVnpFVk1QaXhHak1Vb2ExeGo3akN6VDhIYVhqYkpxR0c5?=
 =?utf-8?B?aFBDS2IvVmg5c0RNdUxOc2h2LzlpaEdKQUY0S3Bnd01uZ2o1ZmxPL2JRRWcr?=
 =?utf-8?B?TTJaUHlPd0hHNFErUmMwWUYyaEZnMml1UVovNm8yY01WaHFRcUVCcURpdEFW?=
 =?utf-8?B?MmtJSmNSMHNrbm1kWGh3R0VBNUE1V2g5cW03SHlWZzBGUjBTOWVLTTVLak15?=
 =?utf-8?B?MjQ3RjJGNHBKRGpDTzFhOXh6NzRGTU5NMW5HV0p4L2xZZnU0Y3UzcEdpRWV4?=
 =?utf-8?B?dTFuQ3JrN2hhTkZwKzUzVWJQU09xdSswWTFNRG1MWFlZMU05RXZiMmQxNFRR?=
 =?utf-8?B?RGdNSHU1R09QQnNpM2hSL2tNVFZ3ekw2cmdzWnNZWkI2OW9BeEhFNkxTVDY1?=
 =?utf-8?B?MVE1OHM1ejZOZ1IycU5uamFFakx0SnpSb3VReTdRdVFwSC9VWnRHRG1iUFdw?=
 =?utf-8?B?Q3ludjRvN3BISkJXNVpiNjcvOW5kMmZxeThRZUxIVFp1bE4rTGd3NTludkFy?=
 =?utf-8?B?SHRTRDlTek1MeW4yVXpKZ2M3d1UvcFBqbHpGZmlIcUdDSmZTZHJPb0Yza2J2?=
 =?utf-8?B?bFZWdlBjL0lYaFR5T21rQUx5enhwYWMrdFFSVUlpVENYRjZRcmVUUkNuUkJs?=
 =?utf-8?B?Q1R2ajRDaVgrMW4yaUhZN0w3UUkyNVBKTHhMajhZWjUvWnk0UFN2WnJabFBr?=
 =?utf-8?B?bkhMRDdBcGNnVzZFTHRqYnhVVXl5UXdCZStRTXdqSDV6blh6T01ZWDBXRng1?=
 =?utf-8?B?K3F6NUN5VVg5dDFVTHE2Z1YyUDdMbmVWUU5qUVRUandESHF3M1gvbU1yZEdY?=
 =?utf-8?B?Yzcxa0tOY01FU3FWYjh5TTIwVTczOTJ3Vi9KSWF5ZFF0QUVtcFZHV3N4RGFY?=
 =?utf-8?B?R2drbFhmSlB6V1QzUW1RSmpmNGxNZDJSZ0xabUZmTE9jYTVkSGRMMStpb09s?=
 =?utf-8?B?cnVSMEVlWDA3V3ppVy80UlZ4QVV5cDYxYjBLVHlpVkxpZm85WHF5VFN4MWov?=
 =?utf-8?B?aE9QS0ZUaGYrMXlYazZlUmtPdUlBUzg0RUt0U0lnYjFCSkJDVjF3b1ZYUUU2?=
 =?utf-8?B?ei9MNS9iSXNIak8xS2tMUFRWQW4xNHZnWmFhSnpKTCtXamdYVUNrMk5DbXFp?=
 =?utf-8?B?dXFhOUY2U2RoUkNLQkZpZjlMMWZxWVFFbzZrRWZSS1BGUm9wam5JYlNsN3N1?=
 =?utf-8?B?M3ZVeDFKYXF4ZHFLOEc0MUl0RWNrcWR4Ry84WEdydUtINURBWVpxTVFTQ0NQ?=
 =?utf-8?B?S3hFVzZTQW1CV2pyWG1jb2J3YnU5NVlOd1NnNDdJOUVBQ3ZPUUowRTkrNVJl?=
 =?utf-8?B?cS9qYTRwcWIwdi80WVU3OFdxOG9WdW9xWkJjVGFtcElkRC9Ud2VkRWxmNVk1?=
 =?utf-8?B?cTFrYWRmdGZQeFkzQTZNVm5VbXZNdlZ1MGljamRpUnJBT3dJbi9KL1J3TmI2?=
 =?utf-8?B?aTAzbmo2WmtSMWdTK01KOGJlR09WVklkSFVqSG9uaG1oT0FNbFJGVytvck9T?=
 =?utf-8?B?K3BNNXdMY01VVkJOcVBBaGtpa3FISXFlRGw3dSt6cjFmbFR6aTJZcUp4UHFY?=
 =?utf-8?B?bUFydlI0dU1kaTBkak5nVDJLM1h5Q0lFUk1FNHRKNVRKNHVCa1R2Uyt5TE5m?=
 =?utf-8?B?c3VNVmFzdEhybnV6dVVFUzc4eFB3RzM5UUU5KzRTNU1TcWs4VlROekd3Z0Rn?=
 =?utf-8?B?WURzZm9VSkxTZENWTWxXZ0tHNzgxYk1GekZmQWVyOTFGOUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0IvZTF3QXlmN0piUU5VY0FvRS9mR0tDMlc4N21TZFdZWFExVkdNQ3JBNnZs?=
 =?utf-8?B?c2JoQ1VsT05jd29CUmcvS1BPNlpuaEZnZ2FEelZzdmpDRllLL21EVHRzTnpv?=
 =?utf-8?B?QW53YnU2WG4waEE0NmFmUHhTd2J0c1REUEpEYTljQldJVWNFSjVwTDdYTWsr?=
 =?utf-8?B?TzVXUWs2Q0lEMmNpeXdhR2RnU0N5b3RWVUovdnYwWk5KVGVITzl0NW91ZXkv?=
 =?utf-8?B?SE5Zamp3dUx0djFKelRWVXJrM01iMk5tNjY1cFRsYkFrZ3VGQmdldHl3QS9j?=
 =?utf-8?B?Y0NuZit6QUFqQ1pZa2MrTWxhSllEamUvS0ZTNDJrRHpxVWtQaWV3ejBrVFhY?=
 =?utf-8?B?bnk3aUh4eWoxekZDcWtTZ0MvY0RjMGltK0kxR05wNFhTUURTejBkTjhYeFZj?=
 =?utf-8?B?cXJVeFBESXhWREdabDJ0ZUFXRldjWHY0dTdjSHArdmU5OEMxRTBJZUllYVc5?=
 =?utf-8?B?MWc2UUsvZzFCajB1VUp3cU1FRVVIWlFiWDBiQWFwK2ZJM3ZnWlZKWERqbExm?=
 =?utf-8?B?MUpXTzU2NXowa0lucXU3SnFtcGxWNnJoUWFqWnZJdG5reW9OYWY5UFl5QU5u?=
 =?utf-8?B?cFpib3Z4S2pBWEh3Smg0KzhJQm5uSEQ1aHV6eU1wVGljVVIzSERlVDhtbWd5?=
 =?utf-8?B?RCszaTlBV3Y1MzF0M2Jjd2U4M0V0bUFsMzdpNFFpaFpJd1BzYVJpT2hSeXh6?=
 =?utf-8?B?cnRlcFhxUWJ0b1V3c1hHTE45TmUyQW44V1dsaHVGSDFCTkdQcElkeGVPeFRz?=
 =?utf-8?B?Y1cvWmNWcmZSTXB3c21CV1lySVRSdjFPRUlnay9qUE9NNjZwRDdSN3RCc1Nw?=
 =?utf-8?B?N3JvQ3VRT1RmSTNlbXV2SzZ1NTdRMVRlcGFPTDVBTnloRnJ0OFUxTWJqZkZJ?=
 =?utf-8?B?bU5pbXhqNHlpbTl6UTMycVNCRTZoVzFjMm9qMlE0VFExOGcxbkVUU1RnUmJh?=
 =?utf-8?B?VlppN0cvNFJ2TzNncUFoazdwbDJrK3lEaUlDUnpYTTZmUi9jS20wVXptbzZJ?=
 =?utf-8?B?eG1DaUl6ZGxHYVJsSUcraGpRUTY1NzByanNwVDlkTVpWV0htVzdzOW1MV2Nj?=
 =?utf-8?B?NDFYMWlKY3JhNExnak9IZmJ5U29vOVhKUXhRMWhzTlVlZnQzQkR3Y3BsU2g1?=
 =?utf-8?B?YjhmU3ZyRkxRYU1zZVg1MUNoQ0NYbGI2UVVqY01FZ2dSV2ozd1NudHZabHRi?=
 =?utf-8?B?dUR3Tk8xTjA5RU1FN1U3bW1NcnpKV1paVkFlUEpTN1BpcU1HM0h1YWFPcGxL?=
 =?utf-8?B?VUg2bGdjbC9HZXJvODFYSEMvamZWYnpTUDJYVWZmZFBpL2ExTTFUR2VoaHVC?=
 =?utf-8?B?QmlMZzhqYjd2cnZVVGpKeDFwUFpIRG43bnQya1BWd3djMHJzTjZJVnFZZk1Q?=
 =?utf-8?B?Q3prNXljME5sOGsxYTNKV2RUd1Y2ZEwrNDNhU2kzdUErMGtOWk5NMGUrLzYy?=
 =?utf-8?B?VDgraGNEd3Mxckx2OFdwNmNWNkV2b01pZDBsQUw2b1JjWUwwb0xPVUdXbkFa?=
 =?utf-8?B?NlZlQXpIdWlxL0pZTk91a21JYkozZFJlNzZGQXM2dWo3ZzZaT3l3TmRGU1VO?=
 =?utf-8?B?M2t0Wi9sWGJJM0dhOTJzanlXbUh3Q01Wd2FqWkNlaDhFc0tCcUZOSjlLeldz?=
 =?utf-8?B?UTkwN2VNcldyekpQMFAvVkJHMDRTTlBHVmxXV1MraWdLNDVhWUFXeG1NUmdB?=
 =?utf-8?B?TlJRSU93UU1vd091MWVTWjVQc2cvZTFEeHVKdTkxaWpMdHdXV2FCRHhQMTZz?=
 =?utf-8?B?REFoSXFqNUE1c29OVzdLa2d4UHphaEtFaVFrNUJ5bUhFVEEyVW13YnYzY25x?=
 =?utf-8?B?UUlwa0hqS1cxdzRvL0VjYnQyWHJzR0ZwY0hFSGpNOU52L2NQUWlzK3UweHFX?=
 =?utf-8?B?aWQxSkxlbWxSN2J5a0VzN3dCaVpCbHJTZlB5VG0wd2JHY0w3RTNtZUc1M0FR?=
 =?utf-8?B?cTFrNXZJYkFlQngzOTVYQ2FGKzJFbjNzeWllZG9mU1MwbjA2TUhPVzYvMU11?=
 =?utf-8?B?bGtwTVVKaXF4WFVienErV0pZY25PaHJIYVl3bHk5Z2ZraENtRDBSQlNEZzFs?=
 =?utf-8?B?OFJuVElJVmdZaUdFc0pOdk1FeXA0ZDdyM2txR29qQlNOU1ozZGp1eTBUUi9H?=
 =?utf-8?Q?Ut4JeCIMBbpW19jnobSC3Caby?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <590B7AE27C6FD04B80F54B0615B9D1E2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0691da9e-8805-4e86-7119-08dcd0dca7b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 14:35:30.4370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H8zO9T5XcfbTW30t07PjYahfqNv51kYhgYlZfxvFEWXVYXM/U7gwupJ4wuwq69pqVwRaj+ubU2ZJKdbl9wzPWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5896

SGksDQoNCkkgaGF2ZSB0cm91YmxlcyBmaWd1cmluZyBvdXQgaG93IHRvIHByb3Blcmx5IGhhbmRs
ZSBlcnJvcnMgb2YNCmB4ZnNfcXVvdGFzYCBjb21tYW5kLiBTZWVtcyBsaWtlIGl0IG5ldmVyIHJl
dHVybnMgYSBub24temVybyBlcnJvcg0KY29kZToNCg0KPiBtZHVsa286dG1wLyAkIHhmc19xdW90
YSAteCAtYyAicmVwb3J0IC1wIiAvZGF0YQ0KPiB4ZnNfcXVvdGE6IGNhbm5vdCBzZXR1cCBwYXRo
IGZvciBtb3VudCAvZGF0YTogTm8gc3VjaCBmaWxlIG9yDQo+IGRpcmVjdG9yeQ0KPiBtZHVsa286
dG1wLyAkIGVjaG8gJD8NCj4gMA0KDQpJIHRyaWVkIHJlYWRpbmcgc3RkZXJyIGFuZCBhc3N1bWlu
ZyBhIGZhaWx1cmUgd2hlbiBhbnl0aGluZyBpcyB3cml0dGVuDQp0aGVyZSwgYnV0IHRoYXQgZG9l
c24ndCByZWFsbHkgd29yayBlaXRoZXIgLSB3YXJuaW5ncyBnbyB0byBzdGRlcnIgdG9vLg0KDQpE
b2VzIGFueW9uZSBrbm93IGhvdyB0byBzb2x2ZSB0aGlzPw0KDQpUaGFua3MsDQpNaWNoYcWCDQoN
Cg==
