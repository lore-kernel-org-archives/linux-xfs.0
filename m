Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F13821421A;
	Wed, 30 Apr 2025 08:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746001567; cv=fail; b=o9Li4/wtibvxjEGsrh5vzEGipYqdiKKlkgieJ8Nqb34viRz+UzFSiFL0jQNT9Nsq5XltuFoTltCZ7f/ozdOokYZyPINbnlXg7Bde1IlG5fW10F0f0wS+Tr0UbOGiYC83oKM9lYceXVyQcoYmK09H8WXfJ330AoIpuNa0ZJcZnpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746001567; c=relaxed/simple;
	bh=U9EH6aseBN2h51FygN/ZnqLC+4Ig7eahAHQX2VXtpAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O3DIG4dwijN7NDru/pi1LSdKfMytFwawhIQRjTIpaQwiQijFLfqS9iQOF4qzEDNLjQaTUvXd/SBg5gt/rgrFEqFRrpD/qCAOevtOXj1M6KZPWmzoBmZhzHORLAdpxbKQDZMhzA9yNyYCB/OorbyWGYb3IjZwP5LanpR/fnOTMg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gwJlf911; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tQRwXS77; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gwJlf911";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tQRwXS77"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746001563; x=1777537563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U9EH6aseBN2h51FygN/ZnqLC+4Ig7eahAHQX2VXtpAk=;
  b=gwJlf911Cxpi3EDSktbawqjqeGfWPXxhrWXLZadTiTRxQF9PxhpxB4V4
   z3skpQrHVQwDEyuvi9REqqqnBscV4m8/9m7djDK7ukNvn0jnBwrwL7q5R
   Um0OGJ1mouY33ErAriXePL/n/MdqZEOpco4NZhBOjpNU48MWX/QTnJuPS
   ggqG3Y+PsHMtns6B517OH1ZhV2vkrpPxh0z22vvz5AgyxOR2VLZFknhm1
   EtwOSpbtZOGBBp0Wvb968bghHbNissFxKxS3r3dgMzai/88rfpAv01opr
   1rZe8p+SE44VKvTId1dXAsOdMuLW/pI6OnP0rk9VwkGpnT2nFr2d5HSN9
   Q==;
X-CSE-ConnectionGUID: LXoqftWfTgWc4hIT3gKo2w==
X-CSE-MsgGUID: Pg1FVsKCTN+3QsRCYNz0eg==
X-IronPort-AV: E=Sophos;i="6.15,251,1739808000"; 
   d="scan'208";a="77564576"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2025 16:26:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzZbwE2+EhLubaz2iOFK9EkDYP2VMcIZ1I82Mmo4ngEUwd9n6Pgi0VAlkUg/SweZhh7N2fkymg4aWAmbzJ4/ZN9xMQ6Zw2ZQONboGu0cT9t6dG8keJEBR6K4S20051SQBAkaawJNKZ4LIKP3iDllW4qhxoN8TyTHfLWlB5FoYmHaklth/6zJFsG1tbOif/m4USLyaIyd0vw+gPoNSlt4BuI6lx5X/Ul/Nve4lbFkk4xxxOEKC2/ASMhC+/Il5vyeS2gM8fwlRHQ8c30tLJ/or5Lqb4Q66CwVOIBRmjiMsot2zkeNNRmlGE8w909ErssLhkmkIKD6+J/bNZ64aywA+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9EH6aseBN2h51FygN/ZnqLC+4Ig7eahAHQX2VXtpAk=;
 b=UfN0ZEm/+t/AmKX4QX34ZBzSgJyURffvuMGTXhSiczwvnipW8RQSWdYGIsZVab5EElrVoIVD7AH29s+VI1dzoNl0/9uTRVx7GV8Vl8lqFsfYiar+/agxMi80/85FfjVWEtgttkD4IAOEl8eqKcvoZOWkwkPy49HF8xo50u018elCNslwY7D60nCSyXa6bpVIWp9qM7jdzmUKMAZgZChRK8pQrVe8Ku6RsQ6KOIg8ysmstCOb+gMRJP+xfoCdg38BwOebMfzfK2Xu0t8siLw1ykKgCBaNrxMRU0mIaqf3/9E9Y//KgPT0nLC2PaKdp6mN4PaTLLYvyO+2eZRkSBNedA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9EH6aseBN2h51FygN/ZnqLC+4Ig7eahAHQX2VXtpAk=;
 b=tQRwXS77gX7Z4L2ZrUMxuC67cIc7JsWWw88+VBQ70MR+NWbvqHLP9Z5W8YiDR0TWsNikE+7H8NnkwkZM6W4ipFPle1M6B7uy6K8YBcQwntuqkJJ9r8sOCivb4BV2c+3a5PJFtbQcFwoFxqgy6+xwC5mlyLpK6+QVMgRENP57DpA=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6440.namprd04.prod.outlook.com (2603:10b6:a03:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Wed, 30 Apr
 2025 08:26:00 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 08:26:00 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "zlang@kernel.org"
	<zlang@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, "david@fromorbit.com"
	<david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Topic: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Index: AQHbtcDlALwMj9CgvEO6QaqlIzHfhrO0e1cAgASH6gCAAD4QAIACpi2A
Date: Wed, 30 Apr 2025 08:26:00 +0000
Message-ID: <99b99047-a24d-4a75-aa5c-066b92b3a940@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-3-hans.holmberg@wdc.com>
 <20250425150504.GH25667@frogsfrogsfrogs>
 <1c313919-f6ca-4f53-be69-21fe93e97b0e@wdc.com>
 <20250428155842.GR25675@frogsfrogsfrogs>
In-Reply-To: <20250428155842.GR25675@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6440:EE_
x-ms-office365-filtering-correlation-id: cfe8ec09-bc21-4130-f220-08dd87c0a362
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OVVRM3lzQUJFR25iVlZCNFMyb2tOdXVXbFM4YXdiSW1SVzlsR1VWRytaVXQr?=
 =?utf-8?B?THpQbjF4c0FaaHJXZldaK1ZUQmkzVndUcnZSWFZDQUNqNjBZdXFYNW83SmNt?=
 =?utf-8?B?ZWNOaStoNFhlcGZiam5Sb29lMVVOdGprQWJLUHV0eFZtT3VzeWJ6M2NmV2l4?=
 =?utf-8?B?aHBuekpJcWlHVDExNjdId2o1dTlydDZEQlNSSTRjYm1uS0lBUW9SbnV3NWR5?=
 =?utf-8?B?RVJmU3kzTXVqV256c09VbFlna1dpNlJQREJ0MkRXemM1eWtRQ1BBMTcxckoy?=
 =?utf-8?B?aHFkeWtkdUxNN2NHOHJLNml3VVlzZ2p2c2tNdmhxQ3Zvc2laeTZ2QVMyNWVV?=
 =?utf-8?B?NHp1RjZsb1dwNVFWVkJRMkhjVFRuc0FuQW9HSFlFNHZOUGFmT293MS9SQ3hF?=
 =?utf-8?B?aGd5Tm40NHhwWG9LbkxyZmJkbEhKRlJVVTFJeDEra3lJV3YxY3ljWWpkeW94?=
 =?utf-8?B?K2F0R0Fvb21YVEEwaU1MclNHU0JvWC9OenMwL2EvYU9UcVR5S1U2OGRmSEdH?=
 =?utf-8?B?eVlJclJlUDU0VEZwVzMrWW5ZaVZ6TldYbWViSzdnK3BjTUtiVkdkOXRNZEVH?=
 =?utf-8?B?Ry9Ha3BTQ2xKMjNMRys4NHhjL3lqK1N2R1ZEQzBlQjQralYwR3lnOTV6bUQ3?=
 =?utf-8?B?YktSUElzT3RXVE16U1dqa1hkWEh5TW5mUVVXYldUaUJYc3Vtd3VsVG9BSUtw?=
 =?utf-8?B?cW9xM2t1T3djMWtrQzhRWnFFOUZ3c0xadGJTZTdBL0VIOWNyZzluL0FQeDNQ?=
 =?utf-8?B?cVdpWHNYaTlZb3I2YS9CbW9rbkxMVFBzVy9TYTh4Y3hlRDQySzZWd1hPZ0hJ?=
 =?utf-8?B?VExnY0dRUnRmYkdWMUFwcysvVk5GSGZCaWZWc3R0NmMwUnlna3p2U25zMEh4?=
 =?utf-8?B?SWNYV1p0SmpkT1kzZGhMU0JjR29YU0JNaHdQT094cUhXSmJLSXFKK3ltSFBy?=
 =?utf-8?B?OEowekdCMExLa21Sd2pLM2MzTXpjSHpMVWxib3NVWXd3djFGdG9nZ3lhbmJW?=
 =?utf-8?B?V1RjN2RhT0Y0dGhSL0VhaUQ0M0NOSjM1TEcyS09sY3FGaVVrRkhCNFhjVXF1?=
 =?utf-8?B?QXFackhrUFV5R3lnbU9sanlqc3BRb0NqTnJjNDFCZmtTWUl1SWRicWV3RFZU?=
 =?utf-8?B?VHRteHBVckRQVjk1c3ZnU05xQVdNSW1hemdMdk12WUdrM1BEdVBqYmlVUTRx?=
 =?utf-8?B?djNxSis4dmI2SDVlb3R3R09kSzNhUHlaRnRiNkt4WUdReVZIaXpIUGE2WlVi?=
 =?utf-8?B?MkJBcjFmbytpaVArRkRONmh0emFNK2pOTzhTVWVTaUNaeXZWMWg4TEZ6ZWdP?=
 =?utf-8?B?Q212SXZmS0tZdTl4QmsvdGx3UHhqL0lkaFRjdGtENjd2N3o2eGJBcDZFZlhq?=
 =?utf-8?B?b0VmT3lEN3lFR2xlbkd5cDBKWjByckUrR0V5aXUxYzc3N1ljRU1NQnI3dTRE?=
 =?utf-8?B?bjl4R3VhbXdnVHdRVC9jMmF6RCs3cUp6L0pXeVVOVzdCRXlHSUFpWTFKNTV4?=
 =?utf-8?B?azNDSVlmcGNoNXRMK1ZsM005NUhzUjVHNklCck5yUllYNXFueElhbFhyNXU2?=
 =?utf-8?B?Z3JVY1MvWlpibmgrV2Z0ZXg1LytPdk90OGVySjZnTHBnK0RablZYejhjRXdp?=
 =?utf-8?B?RXd3WXFINEF4QXBaZzNCdnNGUHFRWUh2TkQzbEhENlBPQ3NhckRYRHM0V0Jv?=
 =?utf-8?B?cUd3MXREcXhPV3pqaEhINUJ4dW4yVmFIbmF4bUF5YzJxYzBDSEc4NG5KVjZi?=
 =?utf-8?B?aWh5OE5xYUdFV0dGN3Vnc0ZhNE1JNmgvRnlwTWJUNWU4UmpSZXgva3N5eElO?=
 =?utf-8?B?WHhESWFNY1pMcmZRcllnVjAzaHVBTDNBUVFxTFRwNVlZdSsxZU45eC9CYjlO?=
 =?utf-8?B?eXowYWlqTUp6SEZuSHVQMHFRZEZpekJGbVNWR25UWC8wQnpUdU1BbWVJeWN2?=
 =?utf-8?B?RTdNWnhZTUJLNnVRYllGaGN6YnU5TXNGNS90VGpYUnkxSHlYbzVFcnhwZHZM?=
 =?utf-8?Q?CkjfS0Qfs4pU2LFe/Tad5RTPoCoozA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bVJMcWd4R2tZRG5ZczR5ZjM2VzJob1hkWGJvVXVpeWlwa0RzNndzcmlqd1Fo?=
 =?utf-8?B?RW44eElUK0lKaXNSWGY0SXQ5VXdaaGhFSjRUeGxLTEdBcDZmVjNseXRzTTFx?=
 =?utf-8?B?Yy82aVlVWSsvcitXaUhqQU8zRlFDd3d4eVdwZ3phZHhacHpKTlFuemtRc1RP?=
 =?utf-8?B?YXJyTHNrek05dlZ3aUFDVXVpUnhWMjgrMmwwK0E5RGorTU9XQVlnRSt6RExZ?=
 =?utf-8?B?YlhiSE1Ia3lEZG1vdnc0MEloUVJsUTlUcGdoVk5PZ0tQcTArUG9wTFJyazJD?=
 =?utf-8?B?YW9WM0FkY1YrMzkwRzlGZW0wR1ZrRU5MZitXTXFMTEV0ZG1XRkVGaDhhcjZC?=
 =?utf-8?B?eTN1Q2FCUjZxQzdYRVh4ZEhUOWNSbFU3c29pVzBad2FORkwvZnhOMmIrenNT?=
 =?utf-8?B?RnF4dWZCeVJLd2w4ZWYrY1RWQ3ZCaGVPYUUramRBcmh4bXp2Vk9tbTYxM1Rr?=
 =?utf-8?B?cDAxVGVrTGg1UHBkWXRkNElpTk1FcCtCMU1idm9rRTNraVFSN1J0R08wTHdS?=
 =?utf-8?B?cVA0QldBY0xuaGxaSEZ2V1g0U01Oa25iek1way9oTzl3cWxyMWdYaEU1emVN?=
 =?utf-8?B?djRXbk9QNnhMLzNyNHE4RXFWSm1VMjA4VlZUUkxaM3dZYXZPUDU1bnFmYWJS?=
 =?utf-8?B?dUNrY01lWXkxd3VDcjdYM0Jwd3I3dzM2QnoxVVptdmdrODJ2QmF3RE5tMEFm?=
 =?utf-8?B?SDZKZ0x3SkFGT1FVUGZaTkpHU005Q3hEa3pXM2VTblVlU2pMcGx5d0kxODIy?=
 =?utf-8?B?SmZGUFB1RkUyUE5YQURqaFRlcHE2SmljUGJMbTAyd1Y2d21UVDVITnFvV1Zy?=
 =?utf-8?B?UlJmM0pBMnlUUWZoQmNkWU8wbGJScWozV0x1NldoMk91N0JyZXNJeVVSQTk1?=
 =?utf-8?B?cnFBTXFFN0haN3hPakZZVkxmNlhVNXRyVjVZMlFzQ1lNbFdEa0ttWUlaQkJG?=
 =?utf-8?B?OURHWXZxOCtKNEUxd0tGZlJ3Z1JqVHBweE9taGF4K0hIMVVkeXk3YnBFSFNv?=
 =?utf-8?B?U3hoMzNFbHdZeW9zWHdhbmE3UHd2bjNLMXYxRWlqZlpET2RESmZuWFp5VFN5?=
 =?utf-8?B?ODE3K3JiaU9FVWhJU0pKVC9nZk5UZXQyb3F1L0xzVVlxd20zSDZ5UkJYUWxa?=
 =?utf-8?B?Z1N4SnRld0ZjVmtwcmdZMWl3OUlwUXdPbTNqTkp3WnpQZlJaY3dIS29peU5W?=
 =?utf-8?B?TTF5ZVlWYU9QTUFUMjZLUVcwK1phZDdZOC9lMGg4TmxmUHdna2RzZkxkRkJt?=
 =?utf-8?B?cTkwd2kvMHlxMXNIaUIvaDVNLzdLcFhlQzJqWXpkUHBuc3J3cUloQWpUM1Bp?=
 =?utf-8?B?MS8ybW15YlJVMWNTS2YxN245Yk45WDlPQWZmN3hvcFo3Zmlwb0pFcVhRdks0?=
 =?utf-8?B?YUZvWk9OeURmc1N0WFNKTzJUL1V4TTNqRm5xZG02YytQcElwZzYvdmxEVE5R?=
 =?utf-8?B?RVVKKzlPTEtOYWhGUGVmN0RFUFEwdldWeWlEWGtMeWNVNTlrRDlUNU9SbWhG?=
 =?utf-8?B?QnhKR09SSVNMNFpETG1aN1NNakd1OFRJRnE2WlVPdXBPeXJ1K0N1VUV5QXpY?=
 =?utf-8?B?M0loV1lyV2NYSHZaWG5ZeFpFWnlMNUpoY2xQdDdnbE5WdzhjcU94cWQ5NUVz?=
 =?utf-8?B?SkFPWE42bTR1V3NicUgzdlRoY1hjK0xLTGNvU3l6RDIwR3czcjVaSUpBOXBD?=
 =?utf-8?B?UVlRWW1XbVczT1c3d2YyYTlFRXRsSTk4aFdnenZxYmYwd2xFOCtWVnlWdjI4?=
 =?utf-8?B?NUloa0grenV4N1ViQjE4TmFvZjNQOEtyRzZmeTAvZGtSRk8wZHE3WlM4NHZh?=
 =?utf-8?B?Q295cGgybEJoQzBkWktQUnRMcjh0TEJGdDZsNlRkVU55eWtGUTI0OXhZcTl1?=
 =?utf-8?B?NWxMNGYwSFVtTmZCamV6THlMMHphQjZZRXdBYlBINmR6cmxDNEVuV05yb0Fr?=
 =?utf-8?B?enhlSjJDcFVOVTNGN3ArV3RKUXE4ZkpocHVzUnovNy9yWnoxUVVmMmExdm5k?=
 =?utf-8?B?UG81SlB0THZqWTdQOG9FM0ViT1ExbExqTHRmcHh4OGdqYkNHOFp0Z0o4WnU0?=
 =?utf-8?B?dEtERGZOSVBuU00wUi82TlFxdGltYTgyZndnQ05QUURCR3FJSFRsMmFrdnlz?=
 =?utf-8?B?TjAwT201czZ3cGYrRGdtbEtSdXBpYWFUSXFsOXh2YTcrNFgxcDlFVXpseDR5?=
 =?utf-8?B?QkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2ECC766273E7A49B713B6EB228C58BB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UnLASYsXoRZLejLUA1R1lhtPCLruq2w2TmljEARo+cdasG/Rv6Qh+8F4SOUexafUvP3TIa5ZQQfAlvfr5r1+yrctvYi5Qqy94yXhpg7p1S61IGhaHGqkeKLw4nwsbjp9/HjSs20lKiTf1lU1eSXF0lYUSyVCmtLfy/Xk0A9feoWb9DF2Xrv9VC/t8J1iFjf0YmtfFuzv74cipOFcLGBXyh1TSu+rwg55mbbL4o/EsvigTPY/M2WlLvRS1dDGfVRIxs2Lic1k1mC3sVBMiN9bnoxtRfRQTOfCa8SzIV8YTLu+NDgmN7QtT8E8vC52tqMUDRN4Qzn1/to2upZ9gX8IGg+2o9vzWR70G0yBu+MBZgmpWQOphbDMLTiZPv29V5NZ4l1oPO0rlDfRd8Z1PO/q4HXgs0fLDSNB/blYjfzpZ2wh0Ky5VI3AaG6XS25/cRf8dl/wZlqr+cOjeDonS9XiF1kExJFIuXHTf9D51ti89/agyGxEVI4vWUIHbAd/PFTdg24IQUY3B/OXmBP6HiqJBYMEXCtJeZ4qnBOiWhXT9geBY+OX/MfbMgtzqzSZ1eX4xfvz31dIDJx8PRAbl5lhzZmqY0Tr/dGrgC8KDf2Wz9K4r/VgfX3GNIROh9s3BNOe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe8ec09-bc21-4130-f220-08dd87c0a362
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 08:26:00.0835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OO2ZMS56/SIypGp/W5LyeM1PYlnpxez8t/KKVEOJI8inkWxTztnaWKjvQIhNzVvEUjpx4DhA1q4prLuwggsGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6440

T24gMjgvMDQvMjAyNSAxNzo1OCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBNb24sIEFw
ciAyOCwgMjAyNSBhdCAxMjoxNjozNFBNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
T24gMjUvMDQvMjAyNSAxNzowNSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPj4+IHBzIHRoaXMg
dGVzdCBzaG91bGQgY2hlY2sNCj4+PiB0aGF0IGEgcmVhZG9ubHkgbG9nIGRldmljZSByZXN1bHRz
IGluIGEgbm9yZWNvdmVyeSBtb3VudCBhbmQgdGhhdA0KPj4+IHBlbmRpbmcgY2hhbmdlcyBkb24n
dCBzaG93IHVwIGlmIHRoZSBtb3VudCBzdWNjZWVkcz8NCj4+Pg0KPj4+IEFsc28sIGV4dDQgc3Vw
cG9ydHMgZXh0ZXJuYWwgbG9nIGRldmljZXMsIHNob3VsZCB0aGlzIGJlIGluDQo+Pj4gdGVzdHMv
Z2VuZXJpYz8NCj4+DQo+PiBEb2ghLCBhY3R1YWxseSBleHQ0IGhhcyBhIHRlc3QgZm9yIHRoaXMg
YWxyZWFkeSwgZXh0NC8wMDINCj4+IChhbHNvIGJhc2VkIG9uIGdlbmVyaWMvMDUwKQ0KPj4NCj4+
IFdpdGggbXkgZml4LCBleHQ0LzAwMiBwYXNzZXMgZm9yIHhmcyBTaG91bGQvY2FuIHdlIHR1cm4g
dGhhdCBpbnRvIGENCj4+IGdlbmVyaWMgdGVzdD8NCj4gDQo+IFllYWgsIGl0IGxvb2tzIGxpa2Ug
ZXh0NC8wMDIgYWxyZWFkeSBkb2VzIG1vc3Qgb2Ygd2hhdCB5b3Ugd2FudC4gIFRob3VnaA0KPiBJ
J2QgYW1lbmQgaXQgdG8gY2hlY2sgdGhhdCBTQ1JBVENIX01OVC8wMC05OSBhcmVuJ3QgdmlzaWJs
ZSBpbiB0aGUNCj4gbm9yZWNvdmVyeSBtb3VudHMgYW5kIG9ubHkgYXBwZWFyIGFmdGVyIHJlY292
ZXJ5IGFjdHVhbGx5IHJ1bnMuDQo+IA0KDQpTbyBJIGFkZGVkIHRoaXMgY2hlY2sgdG8gZXh0NC8w
MDIgYW5kIHdoaWxlIHRoaXMgd29ya3MgZm9yIHhmcyAtIHRoZQ0KdG91Y2hlZCBmaWxlcyBhcmUg
bm90IHZpc2libGUgdW50aWwgbG9nIHJlY292ZXJ5IGhhcyBjb21wbGV0ZWQsIGl0IGRvZXMNCm5v
dCBmb3IgZXh0My80Lg0KDQpGb3IgZXh0My80IHRoZSBmaWxlcyBhcmUgdmlzaWJsZSBhZnRlciB0
aGUgZmlyc3Qgc3VjY2Vzc2Z1bCAobm9yZWNvdmVyeSkNCm1vdW50LCBzbyBldmVuIHRob3VnaCB3
ZSBkaWQgYSBzaHV0ZG93biwgYSBsb2cgcmVjb3ZlcnkgZG9lcyBub3Qgc2VlbQ0KcmVxdWlyZWQg
KGRtZXNnIHRlbGxzIG1lIHRoYXQgdGhlIGxvZyByZWNvdmVyeSBpcyBkb25lIGluIHRoZSBlbmQg
YWZ0ZXINCnRoZSBsb2cgZGV2aWNlIGlzIHNldCBiYWNrIHRvIHJ3KQ0KDQouLmFuZCBJIHByZXN1
bWUgdGhpcyBpcyBmaW5lIC0gZm9yIGEgZ2VuZXJpYyB0ZXN0IGNhbiB3ZSByZWFsbHkgYXNzdW1l
DQp0aGF0IGEgbG9nIHJlY292ZXJ5IGlzIHJlcXVpcmVkIHRvIHNlZSB0aGUgZmlsZXM/DQoNCg0K
DQo=
