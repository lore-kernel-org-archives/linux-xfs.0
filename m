Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794480543;
	b=tKVGija4uxPn9RFrqzBly9O7kDp83JTYp1Ugaoek0XuVtH/SUWV8Fwavu2VtZ8pV8/II
	 rR3hehqjU5/5RFZFfxPLhhUAkWpigOBVgrzGCpnspNQk3PP9NOOOVdEbp6Hqoj29XALoT
	 CNny3mgkI94UNnp7UDPcMVLHDTD7YoU3wA5w2f9sowJB6PyLtkT4gJaPvQXfySyJO34+M
	 GTOQMSXHJjgMVuNQ2o1AXaUamK5buHC9O4lvzdIg1fJXzwxBcdgMJXqkCrLJv9e9iUNJt
	 5ALeVrSr3XL5BrU3C1PKgwCyw1C8rdyOqB8aYtSeffYyv8kA5i26Z6OFeLEGHLFE6ZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480543;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=E9pg6Y+1A/pgwaD9T34kkDoFAqAgeVPE90hxa5z34Ms=;
	b=Cldg+VDo/437ndz1zZSHnugJeYivEpWGmsvaVkU7mUB5HX8UGx46GNsGMx295U3W++4/
	 /2+OBwVr8iE1+abnXkLg5JDzpDyt3Nt6u7v4itTTreD0caDJlxJMbvrFqeTKEPzrXKPPG
	 hNTldt5OQWmkYy5eEoW12etUq4ZZt7bB9GyWuOWKlXHQ7L+WohBjcV8NfpToeGIzAERq5
	 Nt1uOGypWWujoCLFPtrKr+XisICMdOl/OzDfYyCVQhHJAiTu57gI29e6QZeYNf8mtY8la
	 FEH884HeCCn7+VvBqUA8hGZJPtDueAWwh8+nBoDc/7hGwKCo5oleIV6LMsAKm/6YUdQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=FZDfJjFf;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IujRh92g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A75606A323;
	Thu, 12 Nov 2026 10:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81A75606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=FZDfJjFf;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=IujRh92g
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794480549; x=1826016549;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hpThEk9ef/WXhoTS5ird8G/F9CsF0/hhnWpVIUYs8sQ=;
  b=FZDfJjFfwwFfOCTtpoj9ozK0mqipNUkBL8Ksux4enwKgQKiEz/aD6LwT
   KINEaX1aWMkse13MBC9pEPYLOKJV00IIJyl2rBZ6AIx/orkHK2XZ/KjUU
   6LGSciQpidzKlOaaVOUch8oRd347KWlZ7MNod07ZT/288SUys55YDT76G
   +pscsQ+WoQybW8eV5mNrrXFpsvazufqdqGiBZhxoBpe7Gfzosww7DvJ/p
   xL/UI/pkrPHkG6k1/3vQwxqO4ys8amCkWER3NmrnLSjOMrYMB7XEat8KZ
   S6E9/tcO7AwlAW8j2O2TPrIVn5JfDlXkrYvlgUvw5Dgr/VxCEzmFVJ+IV
   Q==;
X-CSE-ConnectionGUID: fxjqg1NSQi+yHDbAhbUmKA==
X-CSE-MsgGUID: oQ1Kz6haR7+NbDLZ/QDLWA==
X-IronPort-AV: E=Sophos;i="6.27,209,1786982400"; 
   d="scan'208";a="159112779"
Received: from mail-centralusazon11011042.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 18:49:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXPc4V+jpihDYY8lA95GJTCQSfqXe1UaF6GMCzqua90QzglgsHAt8taGjgW3FmX7plc1eohito1mop1rc6mniQVPu8/HuSQcclOp+4FY/pIDAGuS3z48XYnClFuEZuzRPoHSGtDOvuUA/VRwjhCfy395Y/ddO9GnxAQTSXunSCMppNaXHVDlygSIwUaBzx7VR5siiU0OtUrFeXw1s82Nf28X/SwZ/XSvOrIfPCbqG52/I6P/dPe25+qjvZSFreDi4qaTmK0v1EvEbofpW8gvlEU9jhAvb+faYpejfhaCgD5cXdktzurVlpWTDnTnGZcvd2wMakCYUOshef+BI9CGbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E9pg6Y+1A/pgwaD9T34kkDoFAqAgeVPE90hxa5z34Ms=;
 b=rUS+sYb8InLOp93qyXi6P1DHKaKh1estYLNRgrssiEpPlL00yc+Y+yrv3FUDY/oqAmXYD9lHge3P+WBtMkYB4QMXeDjmEsP0iHDxC8wiVecq42wVgRYc5Ttf+R8h+NwbkoAZNfocuhF74+DkfJp/siZifg7Wl0lKEMzxjEsF2q+7mdLJ0Y7I/xf0dIQA9J9KZNwMyfZK7xrbmPaPr+uy+/UUv+T33fF1k6+xf7MIhp/LhJpR6yphDgZ37kFBF2DV7Powto1L3matE18uekNuQCBbandUbB9HOdjH3FrxyPvANJkR3HnTJqWCUDVmFaYC7pYINyAtDzb1BFWqsD8lnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9pg6Y+1A/pgwaD9T34kkDoFAqAgeVPE90hxa5z34Ms=;
 b=IujRh92gO5058GR1kwEicGW3PYkwFKt8h5AhvUg4ayJQh7BG2e446lhcOiSU5ubmfJYpacYvZHf2Vo4SDHcX1pyyvDKLo26fYbWx/sC3v1FEe817RXI2iSSznh/CB/AmeMWI4zc/wpyVXPH4nXwIVnCJOSXFh/nJXyuAL8QItjc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CH8PR04MB994190.namprd04.prod.outlook.com (2603:10b6:610:373::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 10:48:48 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0592.010; Thu, 12 Nov 2026
 10:48:48 +0000
Message-ID: <896f049c-ca48-4c2e-9c2a-934f106b465c@wdc.com>
Date: Thu, 12 Nov 2026 11:48:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/8] xfs write streams
To: Anuj Gupta <anuj20.g@samsung.com>, brauner@kernel.org, hch@lst.de,
 djwong@kernel.org, dgc@kernel.org, cem@kernel.org, jack@suse.cz,
 axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com
References: <CGME20261103111022epcas5p4df6a10b70dd9a92992c117669c7227fc@epcas5p4.samsung.com>
 <20261103110640.1000095-1-anuj20.g@samsung.com>
Content-Language: en-US
From: Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0067.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::34) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9269:EE_|CH8PR04MB994190:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c18121-920c-40ba-41fe-08df40aa87eb
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|7416014|23010399003|22082099003|18002099003|17002099007|261009221227099003|261009223027099003|56012099006|4143699003|11063799006|5023799004|261028144727099003|261021121427099003|261102123227099003|261026140227099003|261026121527099003|261021123027099003|261022113327099003|261022105027099003|261021135927099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Vsd/vdN1lH0HOwU27TA8ZqPUPoOaV6tBpbczgpMdzv5/r/GsccBzPqDsyWm29k2E3b6e+IFoYreHEBon01v8nTUbdQJ1aiPFMDLcBpj7oh5mZuVBhMzGIs9vFx0ScVVDVQs0JH+wF6tKJsBefmuvtk30hTnivV1acf/riiRYUyah+rSZJ2NCivwNQLxMjb5VvrPCXlUf8sPf2IyRDqhIlA9iqNvXdtUu4xiprHexlZ5CVw2xZU9oJFIR2B7zmdBsxoMujVAzBJfwmDtycJmzLuBGPD0mKKTTmQWTH/VOY45X1UEEBwrvRA9LN/3cpTIjnPcMSnzfuPD/ZAoSf2QSKa1R/ZtpOHYhLobL0963gVAOkW8GeGvAa90HGA4kA5/UgtNt8sNdrKEM9LQJcfbQ1h7WySZXKnAeoXE8vdbyqU6gEDKsxxKqaa7FYN4X+g2x5D5n8TcI5/PIh7kHaZRnzo8rmMOBX8D+XyDxElyytYb40HgSMC5F0aAFMUL1vqHmlDt38j21px53/CEZRUZK5rWWAt57jWrRNjTKZPE5l5F3V3ASh9QqjxujSL2/vhG4fHLL8UqM16DvXS1nLzvJSxvGKZn+0ONYw9zxbsPeVQiu1MPXFVqt2JlpNDON/kin
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(7416014)(23010399003)(22082099003)(18002099003)(17002099007)(261009221227099003)(261009223027099003)(56012099006)(4143699003)(11063799006)(5023799004)(261028144727099003)(261021121427099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021123027099003)(261022113327099003)(261022105027099003)(261021135927099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzRyRThBWXlGYlorOExUNDVidzk4OEV2ZU1LYU51REg1Zm5NOTNnYmx1NlBQ?=
 =?utf-8?B?R0dzczRuKzV0bGZoeTNlNUIxY3hzWkZIQWg5cGQrODdVaUVtRmlUOXk4bkxH?=
 =?utf-8?B?eDBDNG1VWUlUTWd4aDNkS3lmOTViM1NPclpIc3cvYjZ6TVZaMXpuNVh1Vlc3?=
 =?utf-8?B?Q3lvbTdlb0xuNkFSN2hrUmZIeVVEMlBLMVVreStxVG5iVTg5YjF6dzNkTXNJ?=
 =?utf-8?B?THNqbEtBWTNxamVNZ2lnL1dxYzFaNUlNWks5K0lUQUhvVGVNeHg4MTNrenFy?=
 =?utf-8?B?K0RCcENlYUJtYU1PQ2x3WVJNanR3V3lLMTMrR0tpY0QySTN5UHA1cEZ1blBx?=
 =?utf-8?B?T0pDSHlUOFFXZDlmTjhKUi9SMzl6UU1mdVdxaFNnSnNrS1FMZUZ0TU5VZ09n?=
 =?utf-8?B?ankydkhnMjBuaTYyeHNnUXQvdzA4SzQ5dXc0QnB4Zld4cjN4WGF6Unp2Vlpw?=
 =?utf-8?B?Rk9KYlFyT0Y2bDlpbnZ1T08xZ0ZaVkhlRkRNU3Z4ZHJGWWQyNFBTTGRYWlJG?=
 =?utf-8?B?c1hqME9SVUptN1ZOc0hZSTVHZ2FYWVUxbmNlM2tMVk1wNHpaVy84SzduNzZr?=
 =?utf-8?B?bGJGUWlzRTFjV0hGdlpmWHRtdlBMT3dEcTg1UWFvamhGWUIxUkhpMm4veG9G?=
 =?utf-8?B?Mk8vYTBRU0g2Y3YyZEI4Q0RrWHNIRjJuSENiQUhWakU0RGNwdEZTMHBQUi8w?=
 =?utf-8?B?MnQ4b2JYaTd6RnFsQVora042TkUrL0hJbW1zY0lUMitodWV5MGJaSU5DY1JQ?=
 =?utf-8?B?WThNZ1hSd1I1cGFFTUFMeVlLZE5Ec0NObERLaERFR1FQTSszWWFOemRQUHNn?=
 =?utf-8?B?YTdzRDBuS0NQOHVYMUl5Q0dNQkxRaHlVOXpNOWZ2NFdPU2NLNDh3Z2hnK2Ft?=
 =?utf-8?B?WktVMnRFL3JxQ05OOXZqZTlpZzhDbVlnaFY5bHl5M251WWRibmJkbis0OFFF?=
 =?utf-8?B?b0MwVXg3aFBYa2s0S0JNQ2VWWGVUS001eTBDWnVSQlhjalI3Nkhvblh0YVpF?=
 =?utf-8?B?c2lRcE9HKzVxME5NdWV6QVRmc2JLR3JzNS9qSWs2cmlPR3JIQWNQR1BuK20x?=
 =?utf-8?B?a2VHdEp0UnhJTWYxSVpNRGtaRHFua0FZVWlPZVIyVU9PMVliWkp0M2FGQnNh?=
 =?utf-8?B?OUpIbDh4OVdHbGFyYUE1NWdKRkZnT2VRa2VhdTJoR1RSNEVZdlBKMzZhRVVU?=
 =?utf-8?B?NGZaMjYrZ3YwRVZhRHFoeEtXTlVZNFI2N05aSmtJbFFYczVCeFlNRWM1dU1I?=
 =?utf-8?B?d3pteTA4MGFHeGlsTS9zRFRDaStLTjBPc2FOS2U3Q0liSVB3NFFKdnhQQTlI?=
 =?utf-8?B?OWxBUUp6aGdyYXRsMnY2dHZLQUxicFFYYmFyQUdtcmVDeHA4blBOdXdtM25s?=
 =?utf-8?B?NkhiVTlrNGNaWG5iT0UzYndrby9YTW81MWhpVXhrZGlFVVVOWXBtUlhxelFX?=
 =?utf-8?B?VmNPaEVDUDkxTkJYemFhakxGT09DTGt6NG52YlQwVjUxZ0pmYk13c0VkR3Fz?=
 =?utf-8?B?U1lOVFhDeFhOV0FuSnNmL2o2Qkk4N1A5ZnRIVkVIOFhzaGk2ZFhiTUxmcW5m?=
 =?utf-8?B?SG4yK1hCOXE5NWtuRVYxaTc0NmVpUWhDWWEwaGw0SmhpQnhvN2lxeEhndTFs?=
 =?utf-8?B?NVVzaDkybFd4WEg2ZEVMcXlwbmlaMGp0Rm0yU1o2SGUrdFdIbHJNdnJaMm52?=
 =?utf-8?B?Z0lkNzVaWFZEenNwM2Zzc2h3LytEdENWdk9lT0pCeEZ0d1NqTTBaVWJtZmNz?=
 =?utf-8?B?Z0Y0NWswM1pHR002M3R0VUlqM2hJTzZJZTZwR29OdnNIU28rSzd6SVR3a1cy?=
 =?utf-8?B?VkZKY20zbUNUZHRQcDFodExWTlBBRWlXeHozeWQ2NEZyQTgrNVEwYitEMlpD?=
 =?utf-8?B?NXBDTUx2dWJaak1CVWhib2EyTWRoZ3EvdU52d1BBRVFaSnJJN3NQWFVaUHRK?=
 =?utf-8?B?YUlUL0xaMkNLV0IwaWN0elhCUDFVSmZWNzFoN2FRVmRyVG4vOGpRUlVjU1Ar?=
 =?utf-8?B?TTNvR3BiMmYxSjBWK0Y2bW5QTCtxc09vcDFzWHJXbldTWXFNK2dNNm9zdzYx?=
 =?utf-8?B?STdlZG9Ub1BwdHYwUTlkT29Sb3hMbVhhc2QwaHpabXoxWVRRMEpFWmJWQncx?=
 =?utf-8?B?amluVlV6YlpraGF2V0dMbjc1a0EwbFpsQXVpOTI3a3UzSW5pOHllejNGcFVB?=
 =?utf-8?B?YWNFWnlJaTl4dkt5aXgvVG5FcGpUUzcxV1JLMS9WTWRaU3BVVXJWUXF4ZkxL?=
 =?utf-8?B?MVE2cmcvUDRwUkdCKzNDRUpmYnJPdlM1T0tKV2RFNU5RVC9naTBwQzgyeW10?=
 =?utf-8?B?QW5STVNhOTEzWCtKZ1BnaUhyQ0ZxQnlmZ3M5Tkk1RGNkNmViemNjUT09?=
X-Exchange-RoutingPolicyChecked:
	uaxj7TfmU615S+n+JHTpVZ4GAYQZXCrrXIDLjqBzSrt+iPTKvBDoYO2EJy8bPabzCZMdsq1tdckzwMV2obdBsrKPcUrlEUZffosiFLqCn2W4YpoTLZKjxcIYCU3XBtGuel54E1OztsRv15vHhNXBCGuNiiGYYjL1tCAAA/ZvmqM72AFxdC1Oz+aYS30GoNhdG6fxJ+0OUQop6hMgfcOeSBQNTCnsY1jL8bPqXxdx1YXOSx0/hZQ6D6YfqW76Qsi4nOQyhDRVc8W+w9+6OT9wXDG86YiWfH/bKWGuGlxhx9VBXZASbqQreWHQxxNoL19eTrCx7pNgxd1a0KPlzZ2LPQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uh6XcvOSEhV7E4YJeT/GRtWnRE9wtcISUL7W0w83dDJ7TYLm1lTM8HxxiXrXjLgTChjpgl2rlvHCFyK01cKlcCsKSAth1Toh3f6VQeK4JzIEVvO9RTVrp2mjq16YiwzZbGOUCGwXjXNo+qAiDf7e61ee6E0rFxUezQem1EI9q/IMrSkmJeWkjrqYQELZWvYriZhL2lvi+BTaAO4Gy91cGQd+1qXc2jVpoPcJHBJc2wqn+xTD82TTRr+BYZB+32reszAbGB0GruzdUbFS1w4D1LUmEb790UCDXtDQyT5M2mQ+/jQ5MPB68KQGQhTz4lwpQ+4nFBcu0A23n3GOLvx/b70qm0g5FjOqlunzOfMBS3sGVRwPaPw0plgEKOqhPj+05QFYDXanAtq8zRm/ElW6nEKBDlnUz/3tiZDO9rHbw5jilxsPJcjL/0i2G4T5bOu49FtEcLV7RBseaAKytyCMTl6y2FVgH11ARfMWKGnE9Hyg5bmPzKBQF83gVO797Aq5qNyQXxM7DWuLjka+N85q5nOwS2nRCfSrbPp9RhE9LBRVNBJhzC1sS66z9C4oTNDgKbgaRzTauWeuT5X+dzmBgvISR572mMWBkp9lgL4f2EpMzRl+jKNYJrCmihtYy6xN
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c18121-920c-40ba-41fe-08df40aa87eb
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 10:48:47.9912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUsDn2jl+2+e3NZJOaNx/96wCXzIV5UYCi/ztsltKxAfAQaqsAxGT2hUN0JskdkltibIXYxoFYB2O5NjsL9HTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB994190

On 03/11/2026 12:06, Anuj Gupta wrote:
> This series introduces a generic interface [2,3] for write stream management on
> files.
> It enables spatial isolation (at sw and hw level) and concurrency improvments [1]
> in xfs by
> (a) steering each write stream to its own set of allocation groups (patch #5)
>     and realtime groups (patch #6).
> (b) connecting xfs write streams to block write streams (FDP capable NVMe).
> 
> Write streams allow the abstraction provider (fs, block, raid etc.) to
> leverage application's intent (file relationships/lifecycle).
> - application: reserves a stream and sets it on the files it wants
>   placed together.
> - xfs: maps streams to AGs/RGs; allocates without interleaving; gains
>   higher concurrency due to reduced lock contention.
> - hardware: maps streams to underlying allocation unit; reduces device
>   internal write amplification, improved life, predictable QoS.
> 
> Also
> - A stream is handed out using an fd. The filesystem is free to map streams
>   onto its own geometry, and the reservation/fd machinery is generic
>  (fs/write_streams.c) so other filesystems can reuse it.
> 
> - Since high-level write stream (in xfs) and logical placement can work
>   without the low-level write streams (in block device), series has a general
>   value beyond the hardware that provides spatial isolation. Patches 1-7 are
>   software only and work on any block device; patch 8 aligns the stream
>   count to the hardware streams when the device has them.
> 
> - write-stream is different from existing 'filestream' allocator which
>   maintains directory-to-AG associations in a global MRU cache. That
>   requires state managment and memory (and its reclaim). Proposed AG-set
>   based steering relies on simple, statless/lockless airthmatic that aligns
>   more with the default allocator heuristics.
> 
> [1]
> ### Performance
> 
> 1. On regular NVMe
> 
> a. Inter-stream concurrency
> ---------------------------
> fio: 4k write, direct IO, 16 jobs, 1 directory, 16 files * 8GiB, iodepth 32
> xfs: 16 AGs, 4 write-streams
> 
> base: 41 KIOPS
> write-stream AG-set: 227 KIOPS (+453%)
> here, 16 files are assigned 4 distinct write-streams (4 files/stream)
> 
> b. Intra-stream concurrency
> ----------------------------
> fio: 4k write, direct IO, 4 jobs, 1 directory, 4 files * 8GiB, iodepth 32
> xfs: 16 AGs, 4 write-streams, write-stream AG-set size = 4
> 
> base: 59 KIOPS
> write-stream AG-set: 112 KIOPS (+89%)
> here, 4 files are assigned single write-stream
> 
> 2. On FDP-capable NVMe:
> RocksDB YCSB
> WAF (base vs write-stream): 35% Reduction

Is the base using write life time hints?

I had to cherry-pick this upstream patch on top of your stream branch
to be able compare against life time hints (as it was broken before)

 b8400c9fa Make linux file write life time hinting work (#12595)


> 
> [2]
> ### Application interface
> 
> Three new ioctls:
>       FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
>       FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns fd for that
>       FS_IOC_WRITE_STREAM_SET      set stream, given its fd, on a file
> 
> ### Comparison with Write Hints (RWH_WRITE_LIFE_*)
> 
> - Semantics: Write Hints describe 'data temperature' (e.g.,short/long/extreme),
>   implying a lifetime. Write Streams describe 'data placement'
>   (e.g., Bin 1/Bin 2), implying only separation.
> 
> - Scalability: Write Hints are limited to a small, fixed enum (6 values).
>   Write streams are dynamic, provider-dependent values that can scale much
>   higher.
> 
> - Discovery: The existing write-hint interface is advisory and decoupled
>   from underlying capabilties; application has no way to probe support
>   and cannot deterministically know which hints are valid. OTOH, write-streams
>   provide explicit discovery.
> 
> - Usage model: application needs to get a handle (fd) for a write stream
>   before being able to use it. This avoids two unrelated applications
>   ending up on the same stream.


I think it's worth highlighting that CAP_SYS_ADMIN is required for
allocating streams. CAP_SYS_ADMIN is very limiting, so are you
planning follow-up work to relax this? Christoph suggested a per-user
rlimit on the number of streams as the nicer long-term option back in
v4: https://lore.kernel.org/all/20260819071137.GD1541@lst.de/


> 
> Note: within the kernel, the separation between two constructs
> (write-hint and write-stream) had started from 6.16 itself.
> 
> ### Changelog
> 
> since v6:
> https://lore.kernel.org/linux-xfs/20261015063246.103433-1-joshi.k@samsung.com/
> 
> - add a VFS helper for write-stream/write-hint exclusion (Darrick)
> - use WRITE_STREAM_NOT_SET for an unset stream (Darrick)
> - do not pass software stream ids to devices without hardware streams
>   (Sashiko)
> - rebase on 7.4-rc1
> 
> since v5:
> https://lore.kernel.org/linux-xfs/20260921093147.59935-1-joshi.k@samsung.com/
> 
> Fixes for issues found by Sashiko review; no changes in UAPI
> - fix 32-bit build: use do_div() for the inode-number hash in AG and
>   rtgroup selection
> - bound the stream pool to U16_MAX, the range of the stream id
> - cap the hardware stream count at U8_MAX, the most streams the block
>   layer can tag
> - tag the iomap_dio_zero() bio with the write stream, so sub-block
>   direct writes are not split across streams
> - document that the stream pool must outlive the mount a stream pins;
>   kernel-doc fixes
> - rebase on 7.3-rc7
> 
> since v4:
> https://lore.kernel.org/linux-xfs/20260717125538.508925-1-joshi.k@samsung.com/
> 
> - stream reservation and fd handling moved to generic code, and the
>   stream id moved to struct inode from xfs inode (Darrick, Christoph)
> - stream id no longer shows in uapi: OPEN becomes ALLOC and returns
>   fd for any (unreserved) stream; OPEN_EXACT and GET are gone (Christoph)
> - ALLOC requires CAP_SYS_ADMIN (Christoph)
> - write stream and write life time hint are mutually exclusive at both
>   setters
> - stream pool lives on the buftarg (Christoph), which gives the realtime
>   device streams of its own: new patch to enable RT support (Christoph, Darrick)
> - software streams come first and work on any device; hardware streams
>   are enabled in the last (Christoph)
> 
> since v3:
> https://lore.kernel.org/linux-block/20260616180555.33338-1-joshi.k@samsung.com/
> - add fd-based interface to open/set the write stream (Christoph)
> - move from single multiplexed ioctl to 4 distinct ioctls (Christoph)
> - add mutual exclusion checks against existing write-hint, filestream (Christoph)
> - uint16_t for write-stream within iomap and other streamlining (Darrick)
> 
> since v2:
> https://lore.kernel.org/linux-fsdevel/20260309052944.156054-1-joshi.k@samsung.com/
> - xfs default allocator optimization using fixed-size generic AG set (Dave)
> - reuse the above to simplify the write-stream AG set handling
> - streamline the uapi; Use union for GET_MAX and GET/SET (Darrick)
> - uint16_t for write-stream within xfs inode and other cleanups (Darrick)
> 
> since v1:
> https://lore.kernel.org/linux-fsdevel/20260216052540.217920-1-joshi.k@samsung.com/
> - swich from fcntl based to ioctl-based interface (Christian)
> - new patch (#4) that makes xfs allocator use the write streams for AG
>   selection
> - new patch (#5) that introduces software write streams in xfs.
> 
> [3]
> ### Interface example
> /*
>  * Minimal write-stream example.
>  *
>  *      cc -Wall -o ws-example ws-example.c
>  *      sudo ./ws-example /mnt/xfs        # data device
>  *      sudo ./ws-example /mnt/xfs rt     # realtime volume
>  *
>  * Reserves two streams.  a.dat gets the first; b.dat and c.dat share the
>  * second.  Each file then takes one 4K write, so a.dat is placed apart from
>  * b.dat and c.dat, which are placed together.
>  *
>  * With "rt" the files are made realtime first.
>  */
> 
> #include <sys/ioctl.h>
> #include <err.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <linux/fs.h>
> 
> struct fs_write_stream_set {
>         __s32   stream_fd;      /* IN: stream to set, -1 to clear */
>         __u32   flags;          /* IN: FS_WRITE_STREAM_SET_* */
> };
> 
> #define FS_WRITE_STREAM_SET_CLEAR       (1U << 0)
> 
> #define FS_IOC_WRITE_STREAM_GET_MAX     _IOR(0x15, 3, __u32)
> #define FS_IOC_WRITE_STREAM_ALLOC       _IO(0x15, 4)    /* returns an fd */
> #define FS_IOC_WRITE_STREAM_SET         _IOW(0x15, 5, struct fs_write_stream_set)
> 
> static char buf[4096];
> 
> /* create @name; with @rt, put it on the realtime volume */
> static int create_file(const char *dir, const char *name, int rt)
> {
>         struct fsxattr fa;
>         char path[512];
>         int fd;
> 
>         snprintf(path, sizeof(path), "%s/%s", dir, name);
> 
>         fd = open(path, O_CREAT | O_TRUNC | O_RDWR, 0644);
>         if (fd < 0)
>                 err(1, "%s", path);
>         if (!rt)
>                 return fd;
> 
>         if (ioctl(fd, FS_IOC_FSGETXATTR, &fa))
>                 err(1, "FSGETXATTR %s", name);
>         fa.fsx_xflags |= FS_XFLAG_REALTIME;
>         if (ioctl(fd, FS_IOC_FSSETXATTR, &fa))
>                 err(1, "FSSETXATTR %s (no realtime volume?)", name);
>         return fd;
> }
> 
> /* set @stream_fd on @fd, write 4K */
> static void write_on_stream(int fd, const char *name, int stream_fd)
> {
>         struct fs_write_stream_set set = { .stream_fd = stream_fd, .flags = 0 };
> 
>         if (ioctl(fd, FS_IOC_WRITE_STREAM_SET, &set))
>                 err(1, "SET %s", name);
>         if (write(fd, buf, sizeof(buf)) != sizeof(buf))
>                 err(1, "write %s", name);
>         fsync(fd);
>         close(fd);
> }
> 
> int main(int argc, char **argv)
> {
>         __u32 max = 0;
>         int rt, fa, fb, fc, s1, s2;
> 
>         if (argc < 2 || argc > 3 || (argc == 3 && strcmp(argv[2], "rt")))
>                 errx(2, "usage: %s <dir-on-xfs> [rt]", argv[0]);
>         rt = argc == 3;
> 
>         fa = create_file(argv[1], "a.dat", rt);
>         fb = create_file(argv[1], "b.dat", rt);
>         fc = create_file(argv[1], "c.dat", rt);
> 
>         /* query and reserve through a file on the device being placed on */
>         if (ioctl(fa, FS_IOC_WRITE_STREAM_GET_MAX, &max))
>                 err(1, "GET_MAX");
>         printf("max streams: %u\n", max);
>         if (max < 2)
>                 errx(1, "need at least 2 streams");
> 
>         /* ALLOC returns the stream fd as the ioctl return value */
>         s1 = ioctl(fa, FS_IOC_WRITE_STREAM_ALLOC);
>         if (s1 < 0)
>                 err(1, "ALLOC");
>         s2 = ioctl(fa, FS_IOC_WRITE_STREAM_ALLOC);
>         if (s2 < 0)
>                 err(1, "ALLOC");

Having to create a file just to issue GET_MAX and ALLOC looks like
unneeded extra work to me. Beyond selecting the pool, the stream
allocation is not tied to the file in any way. I don't think it is
*wrong* to use a file fd for this, but wouldn't it be much more
convenient to use the target directory instead?

(just like you do in the rocksdb implementation)

That already works for the data device. The only thing missing seems to
be that GET_MAX/ALLOC on a directory with rtinherit=1 should use the rt
pool in stead of using the data device pool.

> 
>         write_on_stream(fa, "a.dat", s1);
>         write_on_stream(fb, "b.dat", s2);
>         write_on_stream(fc, "c.dat", s2);
> 
>         /* closing a stream fd releases the stream */
>         close(s1);
>         close(s2);
> 
>         puts("a.dat on stream 1; b.dat and c.dat on stream 2");
>         puts("confirm AG/RG steering using xfs_bmap");
>         return 0;
> }
> 
> Anuj Gupta (4):
>   fs: add write-stream management ioctls
>   fs: add generic write-stream management
>   xfs: implement software write-stream management
>   xfs: support write streams on realtime volumes
> 
> Kanchan Joshi (4):
>   fs: add i_write_stream, exclusive with the write life time hint
>   xfs: write stream based AG placement
>   iomap: introduce and propagate write_stream
>   xfs: support hardware write streams
> 
>  fs/Makefile                   |   2 +-
>  fs/fcntl.c                    |   7 ++
>  fs/inode.c                    |   2 +
>  fs/iomap/direct-io.c          |   2 +
>  fs/iomap/ioend.c              |   3 +
>  fs/write_streams.c            | 165 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_bmap.c      |  59 +++++++++++-
>  fs/xfs/xfs_buf.c              |  37 ++++++++
>  fs/xfs/xfs_buf.h              |   6 ++
>  fs/xfs/xfs_inode.c            |  61 +++++++++++++
>  fs/xfs/xfs_inode.h            |   4 +
>  fs/xfs/xfs_ioctl.c            |  80 +++++++++++++++++
>  fs/xfs/xfs_iomap.c            |   5 ++
>  fs/xfs/xfs_rtalloc.c          |  28 ++++++
>  fs/xfs/xfs_super.c            |  12 +++
>  include/linux/fs.h            |   2 +-
>  include/linux/iomap.h         |   1 +
>  include/linux/write_streams.h |  39 ++++++++
>  include/uapi/linux/fs.h       |  15 ++++
>  19 files changed, 526 insertions(+), 4 deletions(-)
>  create mode 100644 fs/write_streams.c
>  create mode 100644 include/linux/write_streams.h
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
