Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CEF34E75E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602486; cv=fail; b=eh2uXVOkDAPl3rdHcklixi1BGLpSVKFNcet3oh46rpwzrLwCwo9TlqUb8/8q1NCV92011bM49rEeKolvqNniuZbxx/jpkhV5W8KwPhOXad+qN3hpbrvzhtIe7d5oW/n9YHyGnC7VECw9DmkXGZtV4P1EDnt7jhrmyDgjhda7AKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602486; c=relaxed/simple;
	bh=gGrS5gbeRuvRuEZ1nVM1+1OL3RmAoIR6ZE0nlapyQZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mk99PA7Sho1aNliv95ckwkYJJkpyV7UYKyasTaXPRej0di5vgdKAH/MffSR5hEapNgSiJoBBHt4phH1ExaMGkKffysJFCbi8O4fx4UL/fiD/xmTcAignQ4TdC1+pD3ut1sGEfgsRV59lp5yTXXyCjqo1yORZyJyCKv/zG/awMls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JXghPBmi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mu/CT/Q/; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JXghPBmi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mu/CT/Q/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602485; x=1801138485;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gGrS5gbeRuvRuEZ1nVM1+1OL3RmAoIR6ZE0nlapyQZI=;
  b=JXghPBmifVGbu7sH+T9UXspDs243kKK96po4tsO4U6Z7nrW/qviu+kQX
   3gwq9P61o1gOwbh9tVBuaAZCbCRhkeyyDj+FlnsqtNsuSIrB3EoaQ0Rvt
   PH6jC6YeE/eOYr+wALzBEhkQLJDRA/nrgIhd32YLlcWn/uxJZ4xu2cLnj
   o0Mwo+UQK+I1Hcxaq7+8ZnHKxZx/DCuGnn1VBWi/+4S/z0smfPdTfitKZ
   PxMOWwSQdTHEDBH2gGGlG8ZsrzJU0ZL7YN6fHDar2YemLAeTmVVQM2u7h
   Ra0K01LtMl3Y3At3n50EgdZfIQfhLFwFbfRW2CHnMKai2cddCLKzctV2a
   Q==;
X-CSE-ConnectionGUID: GwzPh5wkRaSi07iqHPn6Sg==
X-CSE-MsgGUID: mYMYEhucRBucxJgNPG+0Cw==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="139349015"
Received: from mail-southcentralusazon11013012.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:14:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uvH4PDXS3Idz772RqP0EvOJWrkXrc+jx2pON0cIOKWE0XIi8FY1I2Tw29xponRJ7lODD3CbiNrhtPdiD7yCpU6kKYiHXEauwt/GtS0ggZN85b0VexK3+J+4WxwQaLqWBaJmR58xwqxfJFpQt07EJwbnxnlJR836zqicmRS1//K1ntDpYsT64MBW8soXK9zZc2GiWZ3pbqO5J0vj42ZzlNtGWGW6/575LZqY5ordyNfZzywnJksep6JKmhVWJTXbJ+zIdpTBQbuv44ZTYFGpoivdutM/oUIxTWYPZN7nfzZ2FuOSLCNKcbNbLVcsRepxzR42xDnJwzorCe95jnMkIDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGrS5gbeRuvRuEZ1nVM1+1OL3RmAoIR6ZE0nlapyQZI=;
 b=WGxJ1hdc8g2wqwySBOffZ8z8ZhV7j+0yf19xhO+1FafSP5xzrpRPjeZWc1g6uLBI/14YqIS2+kGpvsWDmSdaDWi3x/2r7ziRUvjVzQ6Ex91aaNJkKKVPPd2vMRS4gU3qfr00pQN7XB/OcgPy33yP6VckAT/SQgcg6u2KUW1b5uPi8tl6fo4nc538b+gDQiwaR3eGHn8o8UFOob5bgFWT8qvtpNvToiauEgVf9OQ0jIsv++eTiK+tbfDtFm7vXRkcpJL+bn9ZoXLe/CcU1sCo+/JiRNrufWMOY4olQKGiQjuGe6COqWK0PBnugnhR5xzgbbVyVYldpf6Y0Jq6hXKiGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGrS5gbeRuvRuEZ1nVM1+1OL3RmAoIR6ZE0nlapyQZI=;
 b=mu/CT/Q/vNOaNH4FZ2X6NoW+ECywiH2iyQYBnah2lhhcV91A8bE+EuJ7eZ4w6IT4g+r/3/Rb/sdI2YNn51Vj2MMDkg9v6QdBV44LgJtSvOGN7FKTFIVnsfb92C+wMZVaLqeusIxMfOFWl/kxoUEvPznJtK2BOVEgJCzeT0knPSM=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN6PR04MB9381.namprd04.prod.outlook.com (2603:10b6:208:4f7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 12:14:42 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:14:42 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Thread-Topic: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Thread-Index: AQHcj6bx8Wiev2qk/UulnqLd7QO6eLVngA6A
Date: Wed, 28 Jan 2026 12:14:41 +0000
Message-ID: <c6fb80a1-d8dd-420f-bde6-cc9d29bff323@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
In-Reply-To: <20260127160619.330250-5-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN6PR04MB9381:EE_
x-ms-office365-filtering-correlation-id: ae4eb7b1-861b-4dbd-fe41-08de5e66d10f
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?UXVjK2VES0R6SzE1ZERSMW02UXFhY1NtTGNHVUVuSkRrdjluT0k1aGp2dUZP?=
 =?utf-8?B?ejNJZk5uV2Q5dWZJaUZ2L0Q5Z2oyL2NDc3JFV240TUlTVnliKzZrS25uYlNP?=
 =?utf-8?B?UlNacTZhTlFETXprN0Fubm9PejRyR3FidHpsM1JRY0JSd3JNbWt6N3BQajFC?=
 =?utf-8?B?aldweE9rK3QvQ3JXYkM2eU9FNk8wU0RMVnQrWkIwRE1LSG1zM3JXSjFndWIx?=
 =?utf-8?B?V0JwNjdpa3RWanduTHdzQ3ZST0gxcnVoYjZxWlVVSTJMbFZVOW5uNTRZOW5O?=
 =?utf-8?B?QnluZ2s4c1Y0RFU3dWFyRnBOMzV3VTd2Y2ZMRURRVG05dFRhWWl4cHdpUzVG?=
 =?utf-8?B?SnIxVlRJQXBjak1iaW5GYmtjcmhCMHBybCtGWmhhM215MXcrZUFxNHFZaTYv?=
 =?utf-8?B?a0JzVm9rZHdOczVYbS9GOG0yU2dNdmprWmFhOVpyTkhXSCtrbWZlSTNSSnlW?=
 =?utf-8?B?NnE5SjBlaWt1NW82ZFFrS2J6NXo5UTJtRDhmQmJuRFhMMmhyNjFYelVLMTJD?=
 =?utf-8?B?R3RlTDBJUE1hQ3FkTjZYckY3K3Y5eU94dEZGcGIwVDhxQW9XbU45K2FtRVpx?=
 =?utf-8?B?azR6MlpmZnRCb2VpU1FpQW8yNzlrREdzSzQzZEJGNXRGZWpyL0NldXkvY05R?=
 =?utf-8?B?QXpZZFRoOHVCV3BDWmpFYkIxYlhhWFlHRmlEdVZ3VmVzRWtqREY5TFlzVXVP?=
 =?utf-8?B?ZGoxTnRxVU04dkhQZ2NIK2pEOEIzV0RsZEdEMWlxdHlaNWRhaU91cGJwdWox?=
 =?utf-8?B?LzJsOGVFMC9rSkhYMm14SE5naHZVdDNXSmRQMXkwa0Q1dE1oQUpKbjdUVmNF?=
 =?utf-8?B?M09GeWFQMWttbDhWYlBDWEpSUkpBc1hvNDQzUzdrQTN0TkVIdDBBR3I1Yk8v?=
 =?utf-8?B?N1czekVJVEZjK1QwQk42eFh6Z0g0elQ5cXdnUVFQcGh1dVYzY1pPbXBSM0sx?=
 =?utf-8?B?Z2FDd1NoblN5aHRIdE1pUWF6S3ZSd2wwK3VaK0hNVVkvWGYrUW5TbDlFSXJZ?=
 =?utf-8?B?VzRFUVdVT2ZhRVU5TVNFWk5RZk5LdUQ0V3FNUEpXUFk4elFmVEdlN3VBbXFV?=
 =?utf-8?B?aFQzMjVLYUh3NmlZV215Uk5Pek9vN3M2NmtXenVieWhDbmNYbzdqeXltZ1pm?=
 =?utf-8?B?dHJJMjFOdnF5WERGNVBNUUVSOFlhdXJVYTYraGtPZkhnMGxWUFZoZEh3amJp?=
 =?utf-8?B?V0tLWEhWWGFoNkp2RzVoZG82WXdDd2hiVk8yNUJKRW11cVJ4a1VxZWdCK2hO?=
 =?utf-8?B?MGFleXdheWUzRWVxQXlFbnlnSTk1M09oWTQyTEVYOE5kVER5ZHhTRnpyWlZq?=
 =?utf-8?B?VDVLNFpmc1pWdkxmOTJxRVl4NGkwYmVUYnpKQ1l1UmlybGs4eGJpaGhBMjM2?=
 =?utf-8?B?dS9OUyt4b0l0Yno0L21zVTRISjJpUmNtbjR1VFZwREdZOElJQW43UzAyRHJB?=
 =?utf-8?B?VEZTT0lqUWJzWndBblJ0VHluR1MvMDVWM1gwTVNuWDdPNEo1ck96NmhCRVNq?=
 =?utf-8?B?M3dmSU50OVhYdk5KR2FKQzBiTDdwSWxrSVYvNU5NMDVxSjRMeHlqd3o4L2ZO?=
 =?utf-8?B?bG80K0pWWE5nQUlCOUVodFV2TFhYbDJkSmZuQjkyM3Yxa3VhNDBUUHBuV0l6?=
 =?utf-8?B?UXNYOTA3aUp6TkdDRmxzdVBDSlY5bTBTV3Q4N2VUQk5HZ0JkeEFhd3VmbG41?=
 =?utf-8?B?OEFCMXpqdzBkZ2xYZGxCV1pYWkpRbWJ1U2VpdDZPKzNGWUZmcGZmNnVWcEJl?=
 =?utf-8?B?cDdYN3JKVSs4citBTGkzQzFLSzlJakNKTUN2TFhVbHlUOWRSR0dlNzJuRlA3?=
 =?utf-8?B?ME9uUDgwcmxoRFkxeHJDSkx4cWZYOWQyT2p2dHJ6MTZDQmVtUUFpdlBDbjhm?=
 =?utf-8?B?UnZmTnh3ZWtBSDZzVUl6M1hxVUVzUzNEWjJNakxOL2gyUDhkTFc4d1NUY1U5?=
 =?utf-8?B?KzFMOFV6anc0MjVHUVpVNDN4ZmQrU0ZSOHN3alF4UVB1QkVMZXNCN0c0YWRY?=
 =?utf-8?B?ckJTYjM0TTlvTnhtL1l2clExeE5KOE4xbWJNb3gvRzZjQkcwbWxUdytFSlN5?=
 =?utf-8?B?ZUlKaVFlUlpkOWtOUVh1d2xOcnNNVEJoTG5ycDlpU0hXSjhxMkpKbUtDRHhK?=
 =?utf-8?B?T1RUZ01XVS82dkdscEZRdE1HOGF3MUw2TXVXbHpVZ2VyR25yRlBpYm9nR2NB?=
 =?utf-8?Q?YE3+ob2yd7geotzDCHOLYa0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Tk1aN2hBQ3lScDhUay9DbmlHTy9QSFNDZmF6YmUxYTVwcUhiVVIrR2RPVk1N?=
 =?utf-8?B?aE1LNzFmdkRpNllJdkpGWWtXdHpNbm04dXhjV3p5Ylo5K0tJZktUYzJPaDFP?=
 =?utf-8?B?VVNiZ0tUMWN1YldBY3JOVmtzSEhmcXA5ckFWTlNXQUQwNTBYQUxLcHlMQXJj?=
 =?utf-8?B?emoxbUxHbnVrTjdWalNFODRoSzdEZlF1VDVIWHJld1BueER5RUdrSVBWSWNN?=
 =?utf-8?B?U21GeDlJcStYdjFBQXJSVklrcXVSa1I2dC9hUmU2UkRTKyt2U1hmalR6MEl5?=
 =?utf-8?B?dTkraTQrVEo4elA1ckZnM3BHZkpCYUtob1o5bGprNDZwdk5PQ0RFWlNFWG16?=
 =?utf-8?B?eHFDZmNsZmFFVVdyTUtjV3JRc0tRcGhXRFZITlBBRVBFQ2U3Q0RvSFVETmFE?=
 =?utf-8?B?VjlLMVRzbkhUcDV1NVBvcHVvczJBQ1IrYzE5ZHdBcWEydThiRFp6c2hibzUr?=
 =?utf-8?B?SFd2UXkzcytjZkhoeEl1U1dBc3RyQ0ZVZi9YRVFhZld6K0dwSGl2MjZSMFg2?=
 =?utf-8?B?aWRSY2I3N25yb2lxVE5UeGhjN21JMUQ1am9SbnFyR3A1YndXYmxiTUw2VWIr?=
 =?utf-8?B?TWNockUwU29aakY2YTRkSHY1c0x0UXVGS3UvYlZ4YjRuODRKU2kyK1VvdWcx?=
 =?utf-8?B?M21mRXU1LytqKzhhbmR2OXJ4cEpPUFpva2JNTmtBL25NQXhtcFZkM0NKVGNk?=
 =?utf-8?B?cmhycnA3ekUxaXMxMDlob3lTUDJXNnFyVmtIc2lyMDd2RzIvWTF3NkRSNWxJ?=
 =?utf-8?B?NGlGZHo3Sjl3cjV2VlptK2x0NzFYUHhiZTJqRFNINWM1QjdTeHdSSklxdnNi?=
 =?utf-8?B?Mzc2Y3Y3Y0M1SWV3OHVwaW5rcTJVMDRhSVhuUzNhQ3JodGgwWlR0N25HbHVw?=
 =?utf-8?B?U3ZxVlpFZUFMWFJJZnJ0bzZwd2FQT1FYc0ZsSXBaeVFUVjZtYzRIMjZRYkR1?=
 =?utf-8?B?N0hrOTMwSE1KUS9tMkNHN2NXYmozMWIwNCs2N2I4dTZ4SjVJNnVnV2lqVkdD?=
 =?utf-8?B?cEx2QlJCNXpQRGhZQW9vWk56cHMxZHZhUGpKSTc0czdocVNoOHEvSEV1M3lD?=
 =?utf-8?B?cTAySGVrT21FREVlcHVQTWVNWk1XcUoxejhCUlVMNG5aWXJWcmVaMkdUNDR3?=
 =?utf-8?B?TUZnbUI0RWVRQlo4ZllXNldUL3hONXFrZTQyQnVCZHpPQnRDZ1FGU29HZEF3?=
 =?utf-8?B?dDN2amtycTk3TkEwTVlPRktBeVAxb0hFRmsyNTk1SzI4N3piY3NFMnpWblRZ?=
 =?utf-8?B?RjA2MkF2eGs0Z1Jna0d4Mk5TOUZ6ZUxhWitmZitiOGhLZHRxcythQW1pdTZa?=
 =?utf-8?B?bkQ1ZmlMU0RhWGZBUU1rbmUyd25NZGxxK3pSSE40SU9iejF5WHdSNXhaRmg3?=
 =?utf-8?B?ZG9YcEtYNzI4aGNUT0pGdytYd3hsMktidUFaMlBkb004blBId0lSdlc4b2RL?=
 =?utf-8?B?QnpSUGQ0Nm1RdjFLL1lpcUIxZXZOZGhSTlJHajQ1ZnJkWGpucXpJSmRmbTdP?=
 =?utf-8?B?UzBXNTc0TTJkT3d3aCtxUEwwUi91cVpKRWUvVXp3ZFZOWlNRbFpBell3VzVi?=
 =?utf-8?B?TjVWN2d0VjVlMnFUQWZ5bXZqeEdNYWlVNzJ4eWowVnJFQ1lveldGOXh6ckQv?=
 =?utf-8?B?V3J0aE9ka0hRNVhSUTUxaFk2TTI3SzhPTE9OTkJ5Ujd4THdJRDFEZk9ZK3Ni?=
 =?utf-8?B?VE9NNzV5MHBVSGZ4aUY0aFdHdVlPS1ZTcHI2aTlXcWtGVDk5enkySVJtNUIv?=
 =?utf-8?B?ZU5DTjcvaWkwTWJOdGUwK3VDMWY1UWxWb1RoV2FSR2ltRGxocDE1NGdvM0ZF?=
 =?utf-8?B?TnVCOGlRaUJDUkpZb1YreG9FSFRQbTAxNjBzaXBQaE9qSlV5bnlkS1hadUxS?=
 =?utf-8?B?VzdEM08vY2Zyb3pGUHM4ZURKQktmcCttcnhsM1k5ZUFNVmJMeG5pS3lCQVd5?=
 =?utf-8?B?M0E4MXZPdDdmejE5eGVZWnEvSDhMM3pteXdCd1hRakMvbVRzSU52djRzZ0JL?=
 =?utf-8?B?Y0tNUGp2ZEtQbm81WkhsOXFncTl3cVplNk9FaHljOVZuWFIrRGRvRDlaamVW?=
 =?utf-8?B?TENPUmN5ZWhrL2I5d21laWcxMzg0ZG16MEhBdHdZanZ3VjBqY1o0L0JmSTZy?=
 =?utf-8?B?cXdaaElSenBHTWVXNjlieG9vUENycnpZbFdlRnI4dEdaNzFxcXc5TWlWYWFl?=
 =?utf-8?B?QXRkSDltVStNQzVQY05ldXprUEdaS2VTYnNxOW8xS0gyRlFHWEhld1d0R2M2?=
 =?utf-8?B?L3ZycHZhclhJaW82ODEyVTNiRzBFcGRnRWx4anl2Tkg5Y0ZGSlpTbDIyOTFW?=
 =?utf-8?B?d2ZWWFRjM1M2SU9UWEhsTDVvL0Y0bE1Jb0U5MkdSWE9pTkdQNE9zRFZoQUZJ?=
 =?utf-8?Q?PIVfJB38Vm57L+Tw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5290C40C3CE68408C04C3CDFF775BC8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dpmaNS7jfaOeqFszZDx20mwuO7IEqW1sPTHJWvdPvHKgiA7hRKn030Gi/NN/DT4810/8BlZV/7EOO4Qj1P3TrU9wMPUzdOamoBinzRfRlsxGTqyhFe7L2tBPqzJFMGYIPij9ZTfhpP4Cvt6En5QAiJoX26SHuIoPTYceTWegbnotjSaV8jIQQhsSqYpDTyusxQFSWU/+q6qj9Kh5HxJXbwXLqnI8XDDve4KYqEMWTJm8ykVZK5ovrzM5ERPrIJrR7HG9LsAAZQJ8JR3aQw1RT/XX53SremYJGtjwn6zziX6UZXWbfqCqm8470cQus+2BTQb6qbPTpOXToWC5qEw5+8WmbwxE6w8Yu8Xx1BPpy9Tti4+A8oPA+3AuZfEBHllghTt9XHdz3eBYKCs45tY+9lgqxBv2otYZebIMncAAAFAobgnNesGbLGDfsLoMfpNQ1nt0t5yB2HL94c/BtWXqeBteE2uUT9WJjAmZ90N7RwYq5iZy1sjvsgJf7yuzdl8RrqYgUEkGoxqbP2aNaE6urjsjUgiZStn3cPXR7d1dC8d/xLiGB8tjmboIw9CkCIdiv+SMenltcCQzUs0i8Kp/eXGHp6k/WT5mrgKSk8Z0qiz5tegWpwPPr8QIt4GKUi8s
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4eb7b1-861b-4dbd-fe41-08de5e66d10f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:14:41.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iPxU2aaZUs5vaiPR/pUqeddq6i3jcgH4O4gj0aRh7uZE0MDL0+YaRPVRY3ew0rnbV6q57+4+jrul+x9BWb9tBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9381

T24gMjcvMDEvMjAyNiAxNzowNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE1pcnJvciB3
aGF0IGlzIGRvbmUgZm9yIHRoZSBtb3JlIGNvbW1vbiBYRlNfRVJST1JUQUdfVEVTVCB2ZXJzaW9u
LA0KPiBhbmQgYWxzbyBvbmx5IGxvb2sgYXQgdGhlIGVycm9yIHRhZyB2YWx1ZSBvbmNlIG5vdyB0
aGF0IHdlIGNhbg0KPiBlYXNpbHkgaGF2ZSBhIGxvY2FsIHZhcmlhYmxlLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgZnMveGZz
L3hmc19lcnJvci5jIHwgMjEgKysrKysrKysrKysrKysrKysrKysrDQo+ICBmcy94ZnMveGZzX2Vy
cm9yLmggfCAxNSArKystLS0tLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0
aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19l
cnJvci5jIGIvZnMveGZzL3hmc19lcnJvci5jDQo+IGluZGV4IDUyYTFkNTExMjZlMy4uYTZmMTYw
YTRkMGU5IDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX2Vycm9yLmMNCj4gKysrIGIvZnMveGZz
L3hmc19lcnJvci5jDQo+IEBAIC0xNDQsNiArMTQ0LDI3IEBAIHhmc19lcnJvcnRhZ190ZXN0KA0K
PiAgCXJldHVybiB0cnVlOw0KPiAgfQ0KPiAgDQo+ICt2b2lkDQo+ICt4ZnNfZXJyb3J0YWdfZGVs
YXkoDQo+ICsJc3RydWN0IHhmc19tb3VudAkqbXAsDQo+ICsJY29uc3QgY2hhcgkJKmZpbGUsDQo+
ICsJaW50CQkJbGluZSwNCj4gKwl1bnNpZ25lZCBpbnQJCWVycm9yX3RhZykNCj4gK3sNCj4gKwl1
bnNpZ25lZCBpbnQJCWRlbGF5ID0gbXAtPm1fZXJyb3J0YWdbZXJyb3JfdGFnXTsNCj4gKw0KPiAr
CW1pZ2h0X3NsZWVwKCk7DQo+ICsNCj4gKwlpZiAoIWRlbGF5KQ0KPiArCQlyZXR1cm47DQo+ICsN
Cj4gKwl4ZnNfd2Fybl9yYXRlbGltaXRlZChtcCwNCj4gKyJJbmplY3RpbmcgJXVtcyBkZWxheSBh
dCBmaWxlICVzLCBsaW5lICVkLCBvbiBmaWxlc3lzdGVtIFwiJXNcIiIsDQo+ICsJCWRlbGF5LCBm
aWxlLCBsaW5lLA0KPiArCQltcC0+bV9zdXBlci0+c19pZCk7DQo+ICsJbWRlbGF5KGRlbGF5KTsN
Cj4gK30NCj4gKw0KPiAgaW50DQo+ICB4ZnNfZXJyb3J0YWdfYWRkKA0KPiAgCXN0cnVjdCB4ZnNf
bW91bnQJKm1wLA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19lcnJvci5oIGIvZnMveGZzL3hm
c19lcnJvci5oDQo+IGluZGV4IGVjMjI1NDZhOGNhOC4uYjQwZTdjNjcxZDJhIDEwMDY0NA0KPiAt
LS0gYS9mcy94ZnMveGZzX2Vycm9yLmgNCj4gKysrIGIvZnMveGZzL3hmc19lcnJvci5oDQo+IEBA
IC00MCwxOSArNDAsMTAgQEAgYm9vbCB4ZnNfZXJyb3J0YWdfdGVzdChzdHJ1Y3QgeGZzX21vdW50
ICptcCwgY29uc3QgY2hhciAqZmlsZSwgaW50IGxpbmUsDQo+ICAJCXVuc2lnbmVkIGludCBlcnJv
cl90YWcpOw0KPiAgI2RlZmluZSBYRlNfVEVTVF9FUlJPUihtcCwgdGFnKQkJXA0KPiAgCXhmc19l
cnJvcnRhZ190ZXN0KChtcCksIF9fRklMRV9fLCBfX0xJTkVfXywgKHRhZykpDQo+IC1ib29sIHhm
c19lcnJvcnRhZ19lbmFibGVkKHN0cnVjdCB4ZnNfbW91bnQgKm1wLCB1bnNpZ25lZCBpbnQgdGFn
KTsNCj4gK3ZvaWQgeGZzX2Vycm9ydGFnX2RlbGF5KHN0cnVjdCB4ZnNfbW91bnQgKm1wLCBjb25z
dCBjaGFyICpmaWxlLCBpbnQgbGluZSwNCj4gKwkJdW5zaWduZWQgaW50IGVycm9yX3RhZyk7DQo+
ICAjZGVmaW5lIFhGU19FUlJPUlRBR19ERUxBWShtcCwgdGFnKQkJXA0KPiAtCWRvIHsgXA0KPiAt
CQltaWdodF9zbGVlcCgpOyBcDQo+IC0JCWlmICghbXAtPm1fZXJyb3J0YWdbdGFnXSkgXA0KPiAt
CQkJYnJlYWs7IFwNCj4gLQkJeGZzX3dhcm5fcmF0ZWxpbWl0ZWQoKG1wKSwgXA0KPiAtIkluamVj
dGluZyAldW1zIGRlbGF5IGF0IGZpbGUgJXMsIGxpbmUgJWQsIG9uIGZpbGVzeXN0ZW0gXCIlc1wi
IiwgXA0KPiAtCQkJCShtcCktPm1fZXJyb3J0YWdbKHRhZyldLCBfX0ZJTEVfXywgX19MSU5FX18s
IFwNCj4gLQkJCQkobXApLT5tX3N1cGVyLT5zX2lkKTsgXA0KPiAtCQltZGVsYXkoKG1wKS0+bV9l
cnJvcnRhZ1sodGFnKV0pOyBcDQo+IC0JfSB3aGlsZSAoMCkNCj4gLQ0KPiArCXhmc19lcnJvcnRh
Z19kZWxheSgobXApLCBfX0ZJTEVfXywgX19MSU5FX18sICh0YWcpKQ0KPiAgaW50IHhmc19lcnJv
cnRhZ19hZGQoc3RydWN0IHhmc19tb3VudCAqbXAsIHVuc2lnbmVkIGludCBlcnJvcl90YWcpOw0K
PiAgaW50IHhmc19lcnJvcnRhZ19jbGVhcmFsbChzdHJ1Y3QgeGZzX21vdW50ICptcCk7DQo+ICAj
ZWxzZQ0KDQoNCkxvb2tzIGdvb2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5z
LmhvbG1iZXJnQHdkYy5jb20+DQoNCg==
