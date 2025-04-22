Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88834280CEE;
	Tue, 22 Apr 2025 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745326731; cv=fail; b=ncu7A8ABMzpj6U4DQL4+ZsR+OF93/BwfUmHBYoAW9SXl26r6OGNoI+GtvkPK9JhTvfEyRzwe6X/SnQEBTGcjqmPuO8FErlG95KVErmGNVHVpVnqod1LJ/xkHtWZ6x7KYVz85d3HaSHEkdzVec1rOpV8NGk6VFKJOprMXRUfyHng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745326731; c=relaxed/simple;
	bh=+Uj8Z6yt5ev3Q0H1Ju2VPSiLo8Bp4zZt8u/wre3pa9w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AIgAdcTgjBdxMbUjOee30BryJcZeQNnxP1NceQGNBnonURl69WN9qk/bDCiKkyQseMXSPg8LhOnyJwgI1y3MKH78/3SVr0Gn1D+UgW6yFseC+EktvtQ5MiPaqC8MacMtyhbTgvxT+k7+S9kMNreRCTgynkP1q+9kyHklYY+0fNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UeStAL0V; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wB/qKXhK; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UeStAL0V";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wB/qKXhK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745326729; x=1776862729;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+Uj8Z6yt5ev3Q0H1Ju2VPSiLo8Bp4zZt8u/wre3pa9w=;
  b=UeStAL0VERJNQw4/B/0kITkpzVsXzqZen/e9rOlnAH7OzRCV2RUIzAyY
   vMqsFLMqZ3rT08e/V4vW8lvWKrGCNP1YdhsPwgUSwgmpAR/ewS5+G7FF9
   HkeTDiG2gLANqIUdEQ8YVJYOVmpVjDm9NrSqaPulc4BtIypnDANiDfwCo
   NFyYyPTbU/OX08M3anDynBoUS143igUpdeqbaA9mJgE8xpXyXlGV7Fisd
   3trCtpjdeQ7S0Ab8sbHXbM/MqjhyeakuygNczykFDd5yklKAC50yhIMSX
   alYnV1kz2bqA2Uqgdpu6SYDg8HHRkhrmK65ZFIlnhiEaE93ZggIX1Ei7X
   Q==;
X-CSE-ConnectionGUID: 5RI8tdd8RNO9tnHRe8bD2w==
X-CSE-MsgGUID: E/0ENYwVRNO0th67F/WgzA==
X-IronPort-AV: E=Sophos;i="6.15,231,1739808000"; 
   d="scan'208";a="76141412"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2025 20:58:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwHl6/aXXwndh1wuII2WC1KvG0hVSiXhnHpMVwQYvWwnr3/M4VyPDfOo5YYigQGby53TFdfDRx60nDZO+os4kCcRIujEEXxf6pdFaL2efx/2+Q65OTqTehcgnjJTHmNW85dMwkckEEYOQdYumw6L2Y5wx9TMMlzS2CF0wQE+LjNAOAeLs3Id5srAq+JxfDT/It3A7539il36FUXytoyluf/x/v7WEiUDmN4i+/8rkaRUcthnwJexNbrlivalg1iT0lma4/geNf8G3GjcXbCS5v5O2GmadIkwcH9WP4imnMV0rSTs6UD70DFXIzZP4Bv8UoU/7/891e+jZp2uRxaJTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Uj8Z6yt5ev3Q0H1Ju2VPSiLo8Bp4zZt8u/wre3pa9w=;
 b=Cq43NjhcLG6nDYPs6t4+l/M2Gg2h7Oz5uE8fiFv5NZ13TKsORAHe/VeCEyzfhXf95/RR6m/nWb4K1LXwMI/s6Wg03yR/1bxAtf9oTiQ57s+uFRjbT+Bw20bu4xk7KkVoy/5/gUakhVCCtukCCIl5mxMpcwkdqpUyAtIqpcDTmFriPweq7kztBrdNHwZPQEprIGLZoruL5hphyOcabri83rR7N4LA33fwKUyoX2G0i+g3lIiW2d1rQaGu+WfVa+1w2UJgkCT+/ELqPdZAfu0mqHGKTm2YiwOE0IAmL2TcRyBE+BaSU2latqpznjQI6m4SzRJ7KFhOCmfJUwFXovB4Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Uj8Z6yt5ev3Q0H1Ju2VPSiLo8Bp4zZt8u/wre3pa9w=;
 b=wB/qKXhK39QP+h2h7WwlM/vHiTgNCO7LGt3lwOwRs45f0N2DJLKfMHh7xFEmXnuGutpxF2zeHvzhlllZeyjKohDNrmH7zg5IGphf5UbU/Fw+SeRO9SjioFD4npBW25H/x7dS21Dl4is2kWr4/6VOg7FjFVLIzhdkdHOpme425eE=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by PH0PR04MB7446.namprd04.prod.outlook.com (2603:10b6:510:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Tue, 22 Apr
 2025 12:58:37 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 12:58:37 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
CC: hch <hch@lst.de>, "linux@roeck-us.net" <linux@roeck-us.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH V2] XFS: fix zoned gc threshold math for 32-bit arches
Thread-Topic: [PATCH V2] XFS: fix zoned gc threshold math for 32-bit arches
Thread-Index: AQHbs4XLuLHbxnXdZkC2yPQajGi9G7OvpXkA
Date: Tue, 22 Apr 2025 12:58:37 +0000
Message-ID: <153446a2-13c3-45c9-8735-6b5630feca17@wdc.com>
References: <20250422125501.1016384-1-cem@kernel.org>
In-Reply-To: <20250422125501.1016384-1-cem@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|PH0PR04MB7446:EE_
x-ms-office365-filtering-correlation-id: e931791a-f73e-4c00-efc3-08dd819d659d
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ckNQb1k1Q2VDT2lLSWNoalIxaXdQSG92elpaVmVvdGZDWm8ydy9ocUx2NHda?=
 =?utf-8?B?aGVNaXZvaG41ZzVlQWVmQjRLSFo2Zmlsb25XUHMzeUFqKzk2UldMNnVleTJ3?=
 =?utf-8?B?NDFBZzdBN1hxbTZHazV0UHFEWEg1aVlJVzdnYVN6eXRnVUo1Qk54WGcrMlhF?=
 =?utf-8?B?WFVqSUJWejlsVmZVdjV0VmJobFo1bi9LcjFXeWRUdHJsQnhtRXk5S2tUQ0Vx?=
 =?utf-8?B?c21PQnNBZjdOYS8xMFRocWk4ZzZVVnVsK2RlYVRmSzZpZHllSGpNeTRTYTly?=
 =?utf-8?B?UmNMeTFLY3hYNzNzMDZON2dobklxbVI2aVFwSlZOb3cyaTA1RUpEaitDQVZK?=
 =?utf-8?B?c3J5bkJJM2FXNURlTHEreDcyQi9Db013SWxVS29aSy9zYWwwSlZUSzJnbkxQ?=
 =?utf-8?B?clNmQlF4VFkySHc0REZxQjRBVGt2Rmtlbm8vRit4WnFGTnZ4ZVN2a2VQVk43?=
 =?utf-8?B?TUFzRkxYak1vdG5DWEtDc200dWVmejlaV3NPYWhNNHpnMGlIclBMd2tKeThK?=
 =?utf-8?B?UTFWN2xobHdXRzlRNm84M3MxODA3OEFuZDZBclRsV0tNS1QyRmsxdURzNU1k?=
 =?utf-8?B?Rm4yTTRwejd6aFVPY2ZPYVM2QmhSY2k4ZnFSalZtQ3l0QVNFc3BobEVPVWlO?=
 =?utf-8?B?UlYrYm5vQit5YndzMG9QamNUK2FRMCtISWRWVGMzNGxPTWx6ZnVVanBLa1E4?=
 =?utf-8?B?OC93SmxMNG93NkdJTlA3UGkyTlM2bVloWnZhRHVSZDFQeUZEUjNONVlQcGJt?=
 =?utf-8?B?clUvanpoTmVIQnNtNmUzN3FsQXhlRitORkdRY2c2bmNEcnJUK3dhcFd1MlRn?=
 =?utf-8?B?UHV0WmF6c0FkVzV3ZC9vRDQrNTlEYWtRODk4ZU5XRmRPWTFSQzhGQ3QveGRq?=
 =?utf-8?B?MDJPeWk5UGZCbVpEWWRHYW5kUzBnSTRCL0NnRmRPMG93dEFxWlRXSG5COTFn?=
 =?utf-8?B?Zjl3WHBMOW82UHpDL1ErWGtxSTFIaEpBeEtuK2w2T3ZMZEpkQUdDaS92Q3FQ?=
 =?utf-8?B?TlR5bzVCYWJ0N2tvaUlCZGFMZW1PZm9xRzJpZnVlUUgzU2kxR2Vsek9kbVYv?=
 =?utf-8?B?RFJ3dGxYNWJPdUNhcTJIMzVRdG96KzU0aUF5c21laVBuQVhwdGZTLzJrUUxX?=
 =?utf-8?B?eVJKMEpDK0Fab3FEQS9sSTFTeHY1Qmt5YUozWkJaalVvaHhzWDg3SUgwdEk0?=
 =?utf-8?B?cmVlMEFvTGxNOUsvT2lCU1U1bWV3TGNONVBiN2FJTWhsNGlMWEJ0WGwxMjhz?=
 =?utf-8?B?cllxQkpVK2gvSkoxL3hydGd0LzBuQ2g0bWx2TmxSU3BRMTBDbjVTSDBhZGxk?=
 =?utf-8?B?YlhCSko5cnRPSFpDZDdpQ3VaZlg0TTc1TVFsRmMrTU1iZ2M5SmdCdXh1K2VG?=
 =?utf-8?B?UVh5QzQxLzc0ZGY3K0NlalJMTm1Ob1lzVTRvQUI5ZkcwNGpXbW5MYk8waTJt?=
 =?utf-8?B?SjBTVGpsQ05NQTh5V3VXWHJUWjhzcE1iWU0yeVFPQzJUZGhmdHJKWDJJellR?=
 =?utf-8?B?Tmo1dm1LRFBETWhBNUJWRWNNVXpFSlRHU2hFWExUUjl5UjdSem94VndHUXo4?=
 =?utf-8?B?emh0bnFkMldEaWRSRmtsZFprUytuaXdEQjM5OWd4dHhSRUt1NkpkaEhxeFMr?=
 =?utf-8?B?VU5rMDc0YzIveTBBdzkxUXJMWFd5MnNpNnlZTU8yemZGOHJqRytvbmpEK2xP?=
 =?utf-8?B?VzVEY0htc3NIb21UOEhienU1NGtyRTlrdjBIVjd4azErVm91cmREZUFCSGhU?=
 =?utf-8?B?RVBMaUJ6ZndsbmdyZDRrN0lqK1ErQXBCK3BpZ0RZa0RHNWh6bk5iMjNPUHFj?=
 =?utf-8?B?bmNNc29JVG1FOC85UU9jZFAyUFZEU0FPT2NtamdTd3FOZDJ6eVNoZENmU2d5?=
 =?utf-8?B?eVRFaWhzcEkzS2tHbW9xelJwUDVORmd2a0ZWajdFK2t0b29WNU5MaDBIam56?=
 =?utf-8?B?MGlKc0JpQ1plLzQvcHFMRUFiZmM2d1ZiU3RlWFh4RFdhTEJGSWpBQk9hcno1?=
 =?utf-8?Q?7yIAtCduBEirCcPaNDGJ10c7a5gTmU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Vnc1NU1VZGtwR2prbGkvZ21XRElpa3QxWW9acmhyTlpoVUZsUmlGS1Z6cHd2?=
 =?utf-8?B?c3hkTzcwQlFaZ0pLWkd4VzNnWVNBTld3Lyt4TWxNcjFqU1lTUld3YXNENGQx?=
 =?utf-8?B?bERKQVRub1dtdUF4aFRmZzJSMk93UXlVRXp3LzgwT0U1MThGVHFpazVkNUt1?=
 =?utf-8?B?NXYrTCtmME5mZXNXTEliS1l5cVJLMmFzQWkrTEFLWVpUTVpVWCtPcytGNE9B?=
 =?utf-8?B?azVweHJldVZpc094R1dWalJOSG1uckdadCtsUWhiZW1WK0lCeXRrSUxuY0hQ?=
 =?utf-8?B?WmRqMnpXdlZDUVlITjRWdGhWd3ZPQWdhZit3MGRTRVp6VzNOeHhKYzhiY3lz?=
 =?utf-8?B?RGFDREVINDVKVlV4elFLSjVBUWo1dzh0Unl1R0xETGJXYXZVSU9KNDB0M0s4?=
 =?utf-8?B?WXR4bzRCZEcxSjJwb1V2STZKYlo5bk4xZ3NyeU9Ha0lSM0xROVhmTWZuZnFP?=
 =?utf-8?B?T2lTbWkvWStWdGxVQytaSEF4aUlOOXk0a3lnRXpEb0w1ZGZNOThVVjMzazRX?=
 =?utf-8?B?TlE4UTVEU21QZXMvUDdQU3VQZlBEY0JpT1E1MFZsdmtYVWRIeS9vaHk4OUVk?=
 =?utf-8?B?WVEvUk5FejgwMTNYVUNrTWd0NTE4WFBBZ2k2cUZZVmxwUFlGRXJNNVAyeHVv?=
 =?utf-8?B?V2doUExFc3dBN3Ayckt4VkVCcEM5WnhScjNjY1VHTzdQZWgweGtMeFJScSt0?=
 =?utf-8?B?ME9BK0k2TktOMitTNEdWazIrRWJHR0FYRHNEMGNzTHUxTkV2dHJOQzlaeVNn?=
 =?utf-8?B?MWFIVWpOVE4wZ25FNERkd3RESmREdkdXUTBqc3Iwb1piZDlzNkcxRmVLaVFo?=
 =?utf-8?B?SnIwWEs2Y2ZWS2U2ZWxTL2RSSkFiM2FuU3dNUmQxbHN2c2NQWFpCVlFnNzZ0?=
 =?utf-8?B?dWNudm8xZldjSHg3SFAwN0F2alh6L28zYzZoTmMzWDZqdjJHRXhEMTR5VVdn?=
 =?utf-8?B?aytmaFBVdFFQK2d5QzZxenZ6T040d3M5L1F2SlpoTzRpaGJRRFMyR2NWcDhs?=
 =?utf-8?B?UDVRUEFtbUgxR1R5QWtWK0ZPcWNvM24xYSt2N0ZlS0ZOaTFGY3Q2TmFvYWRy?=
 =?utf-8?B?K2R3dU1NbVlzMkhUWE50bk51TVA5NEhMWWdVcTczckthTis5L0gzQzlRRW5x?=
 =?utf-8?B?emZYYTllK1FXajNxYStqVjJEV3V1RTBJZXdqZFFzU1RXQ2xKNEpIdGhHWFpI?=
 =?utf-8?B?ems0OGpucHk2c3Y3QWRMQ2ZxdmNzczhqUnpHWlhZZlRCRTZIYmFRWDhMQ1Yv?=
 =?utf-8?B?a2syZlA5R0x6OVFVWW9qV3p1SDUrTmhZQ09EU3BHSU9MdVV1TEZsZmxDKzJr?=
 =?utf-8?B?djZuZXc1Si8zMDV6b2M2UEp5K1UvWDExMDVxTzhmcEFqOU9hb29tNncvSjJE?=
 =?utf-8?B?UWgxOGxBb2ZmWlJFcloxUjBBclluS3B4OERLL21uNkhxdGJ3a2xlcFk5WUcv?=
 =?utf-8?B?dGVveVd4TnJPa1NXVFRMUGRSUkU2bVF6eUttd1JIUjJWaFFycXo4ZmJKWUZY?=
 =?utf-8?B?aVczN0hheE5jd0hLWkZiNU1haTRZaDdDbXVMQTk3amF0eDFQN2tNd1B3QkpQ?=
 =?utf-8?B?UitxYlRGM1JEVkdOVWpUMW8xTFlNWW5zNHdVbFFrcXZoQWppSXphWm1KSUtq?=
 =?utf-8?B?V2xMZS9Fci9LTmk2K2wxY0VCelhEVjR2MVFaSjhPNjQ3bTJ1ZmlxdHFHYU9k?=
 =?utf-8?B?azVkaTJWRStEdWxvUjJJb2RkTXZManRjNzVvUjRRekhPZlNCQWxpM2oxdzRK?=
 =?utf-8?B?T1dRcHVQSEFLcmNBNnhTcDBHcnB0OUFWWVM4LzdnN3FCaUVhM3owWDdMaThO?=
 =?utf-8?B?VWdZQkpoN1JrcVZJOTNZdGNDRlZ6Y3cxUnZQZ0pQNWpiOHNVaFRSNzRKYUtQ?=
 =?utf-8?B?RHUwaHBqZDN5dFYrQndHNVc1dlZxN3I1T3RVTWxiYlpxRU9jVUFPd2pQN2NE?=
 =?utf-8?B?S3JqTThmRDhQTnhWeXVaWC9OeXlkVDFxNEhHQlUzdHViWnNlbjBsMTJFQ3FP?=
 =?utf-8?B?emV0OVRwQ2REdUlJSnZZeVVGM3RWcHIyMDh2ZXVlaXNtWGlZenBtSy9yNFdj?=
 =?utf-8?B?b3JuNVZTR1d0cytMMDE5VVljYmp6Yks0ekNHVGZnSGgwTnY2cVlVVSs2cUo3?=
 =?utf-8?B?c0UwZGxaaVZTKys0eG51d0gwMUNaSmlDV0QzSG94NFo1bVFRVDRwRmh4dFhN?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29F1ECBFE95D6844AB0DFC1EC82A6CC6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4a+hBUTlRCsUSxdtjx0zjFTH+toWDve1GqDnWs3v5xvlCUA/dLN+wYDSMiDWDI5ESlDrPIGutt9yrkMFHqnLLovqE0jIVQNuzwseUc9o26hSRoQBhDFlvAoavvDbNYidT5nkoCv6+t82lKoqINMpu6XGFD3BkRj/nkmi6mxlnlfeo0iYKtuSE7w1G56o0VJ5md5eymYEFYkg26fTYtdGUSn3qN2Z/KpbN5N4nUByENshz066dfZHwa7lkR9tqLDjCclh3VT2sItwSFozdHBoXxrk+67WPpHTnFch2d3nn/iniDBh3HU6oMIVl97HNhZEYookpe2CMSwa6IYL7q4lWefDTZyQVEgfs2XR/TjYBph9nswgFFNlZJbgL25U41iE/6PrvAoYfHcF0ToD2y2fm20AT1z+mJOOkvshuSbu4RD3xOPB71zG4a306ffw7yN/1i4eUgcF5uGE332Mx1vHjbdgbycu5pUQefqnLcUrgdAnmFxOsDNQeaHHc9Sbpuk6bCNWvqOrSM7scq3MiTJc71C3XMxw828cGjUJNb55m6G/EARe+gTZNHGNAUqapZ8ddOEIGP53lGzk29OBMrAsXmGQRThYpyUOgq56Jp2UbhUeqGnms0oDaJs4QmsNL79P
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e931791a-f73e-4c00-efc3-08dd819d659d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 12:58:37.0627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qMZsOgfoW4NAhHY41KUi8jp9MTx3CONF+oazPWEQeJz3Mr6AGghkXmWJ7XQTX4mciumZuxmxTlrdMi2S1w4nlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7446

T24gMjIvMDQvMjAyNSAxNDo1NSwgY2VtQGtlcm5lbC5vcmcgd3JvdGU6DQo+IEZyb206IENhcmxv
cyBNYWlvbGlubyA8Y2VtQGtlcm5lbC5vcmc+DQo+IA0KPiB4ZnNfem9uZWRfbmVlZF9nYyBtYWtl
cyB1c2Ugb2YgbXVsdF9mcmFjKCkgdG8gY2FsY3VsYXRlIHRoZSB0aHJlc2hvbGQNCj4gZm9yIHRy
aWdnZXJpbmcgdGhlIHpvbmVkIGdhcmJhZ2UgY29sbGVjdG9yLCBidXQsIHR1cm5zIG91dCBtdWx0
X2ZyYWMoKQ0KPiBkb2Vzbid0IHByb3Blcmx5IHdvcmsgd2l0aCA2NC1iaXQgZGF0YSB0eXBlcyBh
bmQgdGhpcyBjYXVzZWQgYnVpbGQNCj4gZmFpbHVyZXMgb24gc29tZSAzMi1iaXQgYXJjaGl0ZWN0
dXJlcy4NCj4gDQo+IEZpeCB0aGlzIGJ5IGVzc2VudGlhbGx5IG9wZW4gY29kaW5nIG11bHRfZnJh
YygpIGluIGEgNjQtYml0IGZyaWVuZGx5DQo+IHdheS4NCj4gDQo+IE5vdGljZSB3ZSBkb24ndCBu
ZWVkIHRvIGJvdGhlciB3aXRoIGNvdW50ZXJzIHVuZGVyZmxvdyBoZXJlIGJlY2F1c2UNCj4geGZz
X2VzdGltYXRlX2ZyZWVjb3VudGVyKCkgd2lsbCBhbHdheXMgcmV0dXJuIGEgcG9zaXRpdmUgdmFs
dWUsIGFzIGl0DQo+IGxldmVyYWdlcyBwZXJjcHVfY291bnRlcl9yZWFkX3Bvc2l0aXZlIHRvIHJl
YWQgc3VjaCBjb3VudGVycy4NCj4gDQo+IEZpeGVzOiA4NDVhYmViMWYwNmEgKCJ4ZnM6IGFkZCB0
dW5hYmxlIHRocmVzaG9sZCBwYXJhbWV0ZXIgZm9yIHRyaWdnZXJpbmcgem9uZSBHQyIpDQo+IFJl
cG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gQ2xvc2VzOiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjUwNDE4MTIzMy5GN0Q5QXRy
YS1sa3BAaW50ZWwuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBDYXJsb3MgTWFpb2xpbm8gPGNtYWlv
bGlub0ByZWRoYXQuY29tPg0KPiAtLS0NCj4gVjI6DQo+IAktIHRocmVzaG9sZCBzaG91bGQgYmUg
YSBzNjQsIG5vdCBzMzINCj4gDQo+ICBmcy94ZnMveGZzX3pvbmVfZ2MuYyB8IDEwICsrKysrKysr
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMveGZzX3pvbmVf
Z2MuYw0KPiBpbmRleCA4YzU0MWNhNzE4NzIuLjgxYzk0ZGQxZDU5NiAxMDA2NDQNCj4gLS0tIGEv
ZnMveGZzL3hmc196b25lX2djLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gQEAg
LTE3MCw3ICsxNzAsOCBAQCBib29sDQo+ICB4ZnNfem9uZWRfbmVlZF9nYygNCj4gIAlzdHJ1Y3Qg
eGZzX21vdW50CSptcCkNCj4gIHsNCj4gLQlzNjQJCQlhdmFpbGFibGUsIGZyZWU7DQo+ICsJczY0
CQkJYXZhaWxhYmxlLCBmcmVlLCB0aHJlc2hvbGQ7DQo+ICsJczMyCQkJcmVtYWluZGVyOw0KPiAg
DQo+ICAJaWYgKCF4ZnNfZ3JvdXBfbWFya2VkKG1wLCBYR19UWVBFX1JURywgWEZTX1JUR19SRUNM
QUlNQUJMRSkpDQo+ICAJCXJldHVybiBmYWxzZTsNCj4gQEAgLTE4Myw3ICsxODQsMTIgQEAgeGZz
X3pvbmVkX25lZWRfZ2MoDQo+ICAJCXJldHVybiB0cnVlOw0KPiAgDQo+ICAJZnJlZSA9IHhmc19l
c3RpbWF0ZV9mcmVlY291bnRlcihtcCwgWENfRlJFRV9SVEVYVEVOVFMpOw0KPiAtCWlmIChhdmFp
bGFibGUgPCBtdWx0X2ZyYWMoZnJlZSwgbXAtPm1fem9uZWdjX2xvd19zcGFjZSwgMTAwKSkNCj4g
Kw0KPiArCXRocmVzaG9sZCA9IGRpdl9zNjRfcmVtKGZyZWUsIDEwMCwgJnJlbWFpbmRlcik7DQo+
ICsJdGhyZXNob2xkID0gdGhyZXNob2xkICogbXAtPm1fem9uZWdjX2xvd19zcGFjZSArDQo+ICsJ
CSAgICByZW1haW5kZXIgKiBkaXZfczY0KG1wLT5tX3pvbmVnY19sb3dfc3BhY2UsIDEwMCk7DQo+
ICsNCj4gKwlpZiAoYXZhaWxhYmxlIDwgdGhyZXNob2xkKQ0KPiAgCQlyZXR1cm4gdHJ1ZTsNCj4g
IA0KPiAgCXJldHVybiBmYWxzZTsNCg0KDQpUaGFua3MgZm9yIGZpeGluZyB0aGlzIHVwIQ0KDQpS
ZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
