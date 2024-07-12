Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C74517623C
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720805965; cv=fail; b=DceqX2cflzrp9a5R82zXKZAQEEe89/guuwKiCDnDUBqHRfooZ0tAHXgzKi2UTWb/wdL0xC1po+xmOFMsblY8lrcSnb2Tr7LExXbpycj6zbQEH3lp3FlBlTeOA8jiv3ADIhKUZwcwFsHLJTCLieWC2a6kuFAJMf4fTuVYg14/Bms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720805965; c=relaxed/simple;
	bh=jniVMgpMCpePKNwPI16nVE3xqM4yD6p/pB4cqjFTzLQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KRxpRR4qFu844jLn2AtWPLXbAeQJovmlUNvrh1e8/hzjoRVEkXfSjT78fESaL7pSR4igzkWkpvTzfxNVNWpPkzKXdydeUAmn40T5SxjIrcQ1YiblKV/4GJEXBEUVTwLnqvJOXFsCJt1w8XIQf9+1LqBKuEv0xxQbd3QWhf5xyuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZZPCYVdh; arc=fail smtp.client-ip=40.107.102.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZZPCYVdh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MVTGFKdhumDr8/3wfNv8Zc9+Hbojd78rvMLXElkfIfU3S2yiLxjuDwFeaQMfWCYzbnSt05Ef9dSihn9ogTjOuTmB0cINOx/XOODHY8iaP8m2ZKn/rt9WfQpP/y8taNqGQ1rKjOyAPScBQPgiXm2bitxlY5Yhwy3H8a3A4igBEpFKsGgbEPu+04AnS+Y+e0JnwgnXIg4dkR6d4UshFBDbzlTt4L0ticX3uO26ssIm+mCMi4WtrSXU+kzwWCrmYfmaCUlfx2NL3Gx3tyBKPxiqDTiI2CIkFUzGfABg1MQ//ci3ut1Dfg/rC9p3+YX46LNVwUmZBbynMEsk2pXZ6rdhhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jniVMgpMCpePKNwPI16nVE3xqM4yD6p/pB4cqjFTzLQ=;
 b=VE1CkUEc+E0LkxVMSNWyBaQb78IzOSWtjLsAXqIkEwkFanhIF9beO2Q8lS7GYaLoWRGsbA/oUsC2lLWm/qX7SRScPoTIHq4GB3T6sR1DOv74DaN+uuGcZQPpqN92NyazxZ57Gg0syJdQ9Y2oMknoCy77oOLbxKbz2Kg4/AJlWQuMCZVbX88nshbd4QZlbOrIBD9RCPsPVAJOQ71izEMXiEBzRnMgDuK0DvL1Ur6oa6b27tIGsGlBVHqFyO9wCU0auAZSlcVrQabxfTAX430oJ+qWcSYYMZ7osx00GOBulGtObemZvzOTeEvtGZbCACfu8JdMeopGD4HtMNXWbZqiSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jniVMgpMCpePKNwPI16nVE3xqM4yD6p/pB4cqjFTzLQ=;
 b=ZZPCYVdhQnARmLX9lE6sCPoQqaWHpyxAjRkqQMzhRqRXXFE01q39QEhzAESKrmA029c/MyfCeY6S9F1ugitHrIwPqOg2Tywc2JIum/btIhp394nEh7Ti8Vzg0G/x5LKe9E2GK9nUWkrVk/212A3Hun7cjtcv6TAetpHhcP6eKR/PAIQ36e3j4Jr/gbnx/BBFxoh5lFlHReqeir5oMApsui7Nzo1l5NgIP8Z1rH7l1A7bQ+ZeB31tURozPW770kLfIvBk3sizf8wqnvXPq56JBxL24jWeDPreCsmEPt/RX14KyidF9CejHsRy699AhiZczAayeKAlFXn97M30/2/+mQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS7PR12MB5815.namprd12.prod.outlook.com (2603:10b6:8:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19; Fri, 12 Jul
 2024 17:39:17 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 17:39:12 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: John Garry <john.g.garry@oracle.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"chandan.babu@oracle.com" <chandan.babu@oracle.com>, "djwong@kernel.org"
	<djwong@kernel.org>
Subject: Re: [PATCH] xfs: Use xfs set and clear mp state helpers
Thread-Topic: [PATCH] xfs: Use xfs set and clear mp state helpers
Thread-Index: AQHa0rUCLKsDtCjxQU+KJwWPAMCgWLHzX2gA
Date: Fri, 12 Jul 2024 17:39:12 +0000
Message-ID: <d3362032-e334-4e75-baf0-90e992c7314f@nvidia.com>
References: <20240710103119.854653-1-john.g.garry@oracle.com>
In-Reply-To: <20240710103119.854653-1-john.g.garry@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS7PR12MB5815:EE_
x-ms-office365-filtering-correlation-id: 27588881-4c91-4696-7527-08dca2998afc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MTBQL3ZRSFh1T3lBRTBHOGV6ZEoxYzBOSk8yREgvazJ0R3VtVVlOdWZYeWVz?=
 =?utf-8?B?bzNhc0VQZEJpNUFkaFZKelE0YkxKMmp4Y0pzRDZnVHNmekFTZFlzbkxZNDkv?=
 =?utf-8?B?aSt5U29uMUdUVkNhWFdZd0M0Vi9WNUdndGZXaEF4djY2VHRPbEw3SHFxQ2RW?=
 =?utf-8?B?d0hFTTdrSTBINXJycUdxOVh3MG5NcmZxMFlxM2ZZMmxXWVFzcEYrbENBc0FT?=
 =?utf-8?B?cVVncU1qN2JrSWtXOXQ5RDI4L3FlcEtXZXE2VTJDZG03QmJGV1J6U2FXNWEw?=
 =?utf-8?B?bG00ZjR4NERuVEh3ZjM2cXZxTHQ2amRUN1dkTjZNanZlRlR0cVB1ZktRcmFt?=
 =?utf-8?B?cXRjczhNSEREWldmbWtPT3VwVGRXL1NTTFBGVmZKUFFOSjh0SlM1eHhRRVd2?=
 =?utf-8?B?NUdGR3NucGp1ZWJ6S0tEOFZQZEZUUmdNRWk1VTdFd0lmMVV5bDdVV2VIUHpo?=
 =?utf-8?B?ZEtQb0h3Q3F2ZUcwS1FnMmp3U0VhNlFlUE1CU2pKN1BaSVl0TUFkZDNuVis2?=
 =?utf-8?B?QldhcUdjQ2hXcTlZczdNOS8xUnVicUhEWGVpMXZRenNqbVZZNSt1UlR1aWt6?=
 =?utf-8?B?MG8rRXB6SzlwOTVKSXBMenEvTXcySXFHMGsrRGFpM2FVK29FTEdGV3E5QzVI?=
 =?utf-8?B?QkE0U20xakJwRGNGUUg5MVhwUXlQc1g2cE9CUXlFTUhRa3k3THRPOE1BNkls?=
 =?utf-8?B?QXFuaUpTSlR3UXNZaWRGUEtpT0Y4dDl6cWhtd0tudys0VStYa3hmeUEvRGIx?=
 =?utf-8?B?MkhGSDN5MHdFVkJ2UzBvaVFPU1JYTVBnRkppRTkxc0dxcER0OFhyMmJxc2k2?=
 =?utf-8?B?cmhKcm5lNkFtUnQzUzQ4RllwUVdlR0lXZEthZDI5N0NqUHg5ZEZhcDJMM2cx?=
 =?utf-8?B?WTBjU3VoYy92aHo1Lzlhd2NCUUdNYmlZaEx3NG9nc1ZrVHErc2dkVDV3bi9y?=
 =?utf-8?B?cHhkYXp4UURHWVN5U2Z3WmFxQ1g2SjUxT3h3eUF4QkgrMWFDaDJtVWlrTHhU?=
 =?utf-8?B?THRSdDYza3pPUU1VdnJHS1R3VDkydkZOeDF4aFBBQmdwSUhpNWtyeUlFbnpS?=
 =?utf-8?B?Mk1oVGx3akJIcmdUUk5mYm5mZTRTT05kWWdpVkhuRDh3SXgxQ3h5cTZVV2tH?=
 =?utf-8?B?bVNnRG9WZlB3bWV1ckxiWGs5VHovZmdHRTFEYVFwU0FhNC9VMFF4VkZMdThZ?=
 =?utf-8?B?NUNYZVdlNSthcjFiS3g3MmZ6NjlHVjE1djRpU0o0dmpka01ZL1dNZnMrVXRI?=
 =?utf-8?B?RXFBUm9TcUNMU3VpMmFPcVVPZ1k5L3pMY1FPTW1SQU5JQ1ZHdGkxUm52MFNI?=
 =?utf-8?B?bld4amM4Ulcza2pFaDZPU0xQYU40QkdSUXZKbmVyancwcitmYzE2MElOeXQy?=
 =?utf-8?B?dTcydnZ3dXFqeE1GNVU1dUhNNWZ1VTZoUzB0VnZSaUVXc0pyTXpESGd5bXIr?=
 =?utf-8?B?cDAxZXJyZnRWQ0Y4OUpBU0kvQ05mdkh2QjdRYW1ONVVIT0FLbnVjRUlUR2Zo?=
 =?utf-8?B?UjE4Wm9ZNDN6akZGSWZnb0J1bzNJcWYwNmVnSSs2ZXZVTUFYYm1Icmhmb1Bo?=
 =?utf-8?B?ZzRpRDA2U0RtYm55SDlmV3I1UHVMRzFTOXNnMVhJTlY1M1FnT0NqYXlvbXhj?=
 =?utf-8?B?UjVoR1ZkVDZLdkZzdVlvZW9pYnVzdzZCaW5yUmRMYzFHWUpRbGpmeUthSklP?=
 =?utf-8?B?Yi83aFZ3SEQ3dkY3cHpXM0Y1VVRKR1pvZTFKWFZEK2xpak1tM2IwSDZHMkJJ?=
 =?utf-8?B?d2NCejRSS3FEdUh2eDNITkx4bUJ3OXpuVFdYdGo5aWdzTFEzK25NMXhtbzV0?=
 =?utf-8?B?azN4U1NMcEhjM0ZtNC9MUGZ2Y0hETFdaSHc0WFBMcEV2K0hBbzQwcU1CLzhI?=
 =?utf-8?B?S2RrZ2xYZFRFaTFidWJQTEV1bTRMbU9xTlJuYlY3emVyN0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFVWd2QrSlR6Y1FIZnZvWWRrT0hPLytJTEg5cHlmV1p4eXZVNlM4cEEyTy94?=
 =?utf-8?B?WkJyaUszSXR1cmtxMTFpby8xRUEyeVdNbTdxUXFyRkZycG5FYUhaZVZHOEpt?=
 =?utf-8?B?Rnl3QzdFWW82UVF0ZXRtalpINEJwTEVsVVVMalRBWktuV1JsQzJnSlFkNXV5?=
 =?utf-8?B?U1JFZThSbVVsZHB0RkhBbkx2MjBEOVdydk1RV3FTeEdGaVV6VGxpM00wckFa?=
 =?utf-8?B?ZExuTk1LbkxWSDhkMWJsU0I2d1pvenJJNitKUzNVQ2FENHJqODhMS0JyZXl2?=
 =?utf-8?B?Z2JNT1J3cmM3aTloZVlRM2MxRlVYK05ibFZ2Z3Q3a2hsZ21YK0VQY2RZSTFI?=
 =?utf-8?B?MG5lcnlOc0ppRWxCVTNGbWN6eG5YSUxuU1lhR25CNUhkb0VuUVVzQWxFemsr?=
 =?utf-8?B?WWpvM2tKUWxWNmFXQzQ5b0loZ2VQbHFWeExJYllNUVlTQXBkMG1PQi9RL3V0?=
 =?utf-8?B?SUF0dDJ5dmgzNjQycXo1UDlFTmgvRGQ0RkFRWXZidWY3WUlEQkFBb2gwblZ2?=
 =?utf-8?B?dzBwWm05U0s4MXhNNWxtOE9MTG9ua0xscXNSOUJBeDhSTjZaS1hUa2NzTFJ5?=
 =?utf-8?B?NFN2Q2FFWlpyUHhsQmdQa0UwK3Uva1hKbkJ1KzdqOE1jQ28wNUlqRFNqTlpJ?=
 =?utf-8?B?NWFwaHZsanVPNHJwaHZvQ0RDb0FhcGRYbWhjbFlFSVhsRVR5MWd4VVUwUG5v?=
 =?utf-8?B?WDNXcDl3clVXQ1FLTWZMamtaTWVMMDF5OGNNczZoT2lTOHhNS29jUWlTbTgx?=
 =?utf-8?B?RGtyeDJHeUQwSFRaWEtwcVVKUTNzajlCVjJhQ25qRUtWZmtrR3RoODdSSDdk?=
 =?utf-8?B?UGZmNXkvRGRzTG1HQnBQdVEvSERtam1yYUR6ZUlIRDlNT04zKyt0bVhsdkVx?=
 =?utf-8?B?ZUNWcEp6QUJmeDcrMVpxN2dmRXo5bjhpSFNvMHQ2VWNXNVlEaGdPWVpJY1pS?=
 =?utf-8?B?akZWeW5vbGRkc200SGJoMkxKNVRQbGhyQ2tzbk5LMGlNQ0xzTzkwRnZkbTJC?=
 =?utf-8?B?dHk1cGVtbGIySDNSQkxIOU0xM3pKMUkybC82M3A5bHcraTloTUU2dGR5Tlln?=
 =?utf-8?B?bmdTMkRpTS94Z2M3U1FyQXh0VG85NmMrN1M4eno4WDJMYlRFb1Ywa2MyelFK?=
 =?utf-8?B?dzlWSUMvMFBPNHRiWjhrSlo2M2VUQU5WN09acTI4Qm1BWUJBMmZNT3MrMEJE?=
 =?utf-8?B?VVZHVzI2VG9kK2cxMzVhZ0c1a25DMWN2T0xFMXdJMHZqNWNNVmtEaUZXTG10?=
 =?utf-8?B?dHVJS2JIdHRtYVdVRXkyU085OE5OVU1SdzRoTUNNWnFjY0t5U3BRT2p0ODJF?=
 =?utf-8?B?VDNKbHpxUmZaZHJoS2hyMmZzTjNFSlorUlZtQWY3YUk3OHpkaGFzWUVNWGRL?=
 =?utf-8?B?c0hpbDdOU256Y1RWeUMrNzVSSjBqVWZza28vOUFqdDROQ1cxblkrMk5VcDdl?=
 =?utf-8?B?QjVaczZWMm0vRHhwZDBsMy85eEpYaVYzbXN1WTlPOGd0T00wb1FlSzZaYUg1?=
 =?utf-8?B?OElacUFKc2NDanl4MkQzN1FONk1ub2JRUkRINTk1Q3lOYnhpUENhTkJpOHpW?=
 =?utf-8?B?QXFzNmxFS0l3Y2pxS2plV3hVVTI3OWlKZmZjNHpyWUZPbTBIRzhjQVVYcGRa?=
 =?utf-8?B?Skxyb1VBQzB5TXlwRGwwWEhweWJJUlJIMXRvWDEyUDBBSnM4c0NPbGFYK3BC?=
 =?utf-8?B?WHZvem9sMnhCcGk3enRYSk9jY0FhazB1Mmt1bW14U0UwRTZRdlJGNDNCbldx?=
 =?utf-8?B?aHR6cDVrdC9FdWIyOVlNYVpVMldEaUdyTWtxS0JMUEV0M09OL0FVNThwSVBJ?=
 =?utf-8?B?RHF4RkF0UmhrN1RDOFRYbksyZlM2d3JGMXFhZ1VXTG1yWkZsRlBNVTNoTzlO?=
 =?utf-8?B?TUhnNDQvN25jN0QxcytCd3RReVJNbjJrSDI4QjJ2d01BVTVRSFF0V1NyNjk5?=
 =?utf-8?B?cWx4VUpqRkoyZzVUN1NxYndvUFc3Y2tscXV0MGQ2RUswNHdnR1ZKVUpHczJn?=
 =?utf-8?B?NyszKzJBU2FPdzR3V25GOCtlY3pTTCsvOGk5UkdGRjREYUp3MEZlMU85dXdE?=
 =?utf-8?B?V1E5VWxhZzVlRXJvZkdXV2xzeDczaURKMHVnTGhwNDZYY2JPUXd2WmFpLzlC?=
 =?utf-8?Q?C3WlR4tgMnhGxg0w/cEc9Qu8T?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C10C0711820DE248B169E8E2DE6A3075@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 27588881-4c91-4696-7527-08dca2998afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 17:39:12.4757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rbQUhUCjf/FSDPhx9G5tvHOKeIrAamqzNIKGiS4GV2lUMaP4DQXjjoLfsglXL+7n7fhj55MZlNBf2WK5ZptehQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5815

T24gNy8xMC8yMDI0IDM6MzEgQU0sIEpvaG4gR2Fycnkgd3JvdGU6DQo+IFVzZSB0aGUgc2V0IGFu
ZCBjbGVhciBtcCBzdGF0ZSBoZWxwZXJzIGluc3RlYWQgb2Ygb3Blbi1jb2RpbmcuDQo+IA0KPiBJ
dCBpcyBub3RlZCB0aGF0IGluIHNvbWUgaW5zdGFuY2VzIGNhbGxzIHRvIGF0b21pYyBvcGVyYXRp
b24gc2V0X2JpdCgpIGFuZA0KPiBjbGVhcl9iaXQoKSBhcmUgYmVpbmcgcmVwbGFjZWQgd2l0aCB0
ZXN0X2FuZF9zZXRfYml0KCkgYW5kDQo+IHRlc3RfYW5kX2NsZWFyX2JpdCgpLCByZXNwZWN0aXZl
bHksIGFzIHRoZXJlIGlzIG5vIHNwZWNpZmljIGhlbHBlcnMgZm9yDQo+IHNldF9iaXQoKSBhbmQg
Y2xlYXJfYml0KCkgb25seS4gSG93ZXZlciBzaG91bGQgYmUgb2ssIGFzIHdlIGFyZSBqdXN0DQo+
IGlnbm9yaW5nIHRoZSByZXR1cm5lZCB2YWx1ZSBmcm9tIHRob3NlICJ0ZXN0IiB2YXJpYW50cy4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvaG4gR2Fycnk8am9obi5nLmdhcnJ5QG9yYWNsZS5jb20+
DQoNClRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZSwgaG93ZXZlciBmb3JtYXR0aW5nIG9mIHRo
ZSBwYXRjaCBzZWVtcw0KbGl0dGxlIG9kZCB0byBtZSwgd2hhdCBJIG1lYW50IGlzIHNlY3Rpb24g
ZGVzY3JpYmluZyB0aGUgbnVtYmVyIG9mIGZsaWVzDQpjaGFuZ2VzIGFuZCBsaW5lcyBwZXIgZmls
ZSBzZWVtcyB0byBiZSBtaXNzaW5nLCBlLmcuIChmcm9tIGRpZmZlcmVudA0KcGF0Y2gpIDotDQoN
CiINCi0tLQ0KICBmcy94ZnMvc2NydWIvdHJhY2UuaCB8ICAgMTAgKysrKy0tLS0tLQ0KICBmcy94
ZnMveGZzX3RyYWNlLmggICB8ICAgMTAgKysrKy0tLS0tLQ0KICAyIGZpbGVzIGNoYW5nZWQsIDgg
aW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQoiDQoNClJldmlld2VkLWJ5OiBDaGFpdGFu
eWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
