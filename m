Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A5228A72B;
	Mon,  9 Feb 2026 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770620274; cv=fail; b=GuelU0UqXuo7IGh3WgoDC4XkfIvAdYIhgbKF7QDQb2Abisq6j74nVi8R7O34J5HNAEY6plhEfXSgAKwguaaXwnbnACTPyMr0QiKc51q5+6KYqNfwwUCeLXz22MdoDsjoDNDZy6AdYOgMcMhifyFcvEkyYMFr4BWmypZk2LkZTp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770620274; c=relaxed/simple;
	bh=IplC3AEhaO0UewZ/prFvwHz4edTRshDIU63ED26xhw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LDtrxdUhkmxt+oIz60vyU2OYPrf73x0msmZHyuq+NGdM6d5ldaSLr9xN3nzEW+cwnzE6PSR43ytwyShYMd9iIKxEtG02xP2HfzYgnT40l2Ivhz8c2cpd+pwstMW7C3mjNGydqjmxNBm4NUf3gWIQBW4jz4hgb/hP8EOxzuhAnFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jgXX3zKd; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UPN0LbnT; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jgXX3zKd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UPN0LbnT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770620274; x=1802156274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IplC3AEhaO0UewZ/prFvwHz4edTRshDIU63ED26xhw8=;
  b=jgXX3zKdvL5gloauWPMlZ4Be9sHPjnW4ut0kH1Qqbh9dtlpYZq1zLOw/
   Vi+PHG5HUHBXMPvM1S80hoZSb9ZHlFR82WUYkJbzRhQnZQtIX8V1Cif7d
   DwXbU3j1bJv4wDLuYBlBB5TPmbqTGsgqkZEwZcZpJGVSU8Cw8SleomaaN
   X/ZolqlzcpDuI48ZrRgCqRZW9fnImF/SBXcPPqDZORPt14SIQCNXbdhyM
   tCyNbnu/hXcFBDWMhb2arfJ5MJq1racR2xlPBiD1wRZIiSi+U31BHLoGO
   hoixXigiuZon1ufwPl8M+f+BphFN+kw6N0ndEisaMR0u5JMcoAWbNZdT5
   g==;
X-CSE-ConnectionGUID: C3ghi8N1SYOCoZgcT9yQJA==
X-CSE-MsgGUID: 5r9rOZvgQ+CfOyRM+ZBv8w==
X-IronPort-AV: E=Sophos;i="6.21,281,1763395200"; 
   d="scan'208";a="140363317"
Received: from mail-eastusazon11012058.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Feb 2026 14:57:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=umrUP/UQ0vSvIdngPvFTLTXwZEwbRSWUel9WQ29KAis6vzLXXr6vVMGOkmdsFqYgpnaPV4GOS1fEVvpMyMfL7CrUuXxvpDjzFK+cnDZpSh5aNAObIzJefYEw5fjSGkLoRbSCzNzOo9eczLp2QfI+gTF97Z5QjYf++EL3InZ5f97uX2Pgr0nlueybm/Y6HIxOHjC/9ftKhQThFsEh4WREsZ5y0tCEtwa4GVd+wfc5ThIPo5xodyQ++Vgsb1GyHpK8i0gPUxwyCuMuIYcht3JamfxCz/sr6B8ggvYo0YjqC/fNncvt+B/eLCm2Llbt1Fkplp4Ui1PePplB8Ta/NmAKdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IplC3AEhaO0UewZ/prFvwHz4edTRshDIU63ED26xhw8=;
 b=hOQaapM51vp6QfYXrD3G/wSRvkZU8AnDizqCn5mwyQdn1zkOYhr6HLBKv/1CIdKd1/gJFMZiVl4zzVInYHKegJZGM3dOuAiAxVuKsXme6oR+rxrWzW77ohSJEoVlsEyHFtGSbDYEFvt8ngGKLpKyykzoGR2mXV1qMv4sC0FVpQPjiNaJTiS2HsKqUS24a69/FaKFELlt+zqk7ULdwZGeCSTpkfmA9kj9REXl1nfuGAONiLRWzWWYYH1zA8N7l3qmt095zA4+VTfp/uZIQciWVqhurvyI9wQCbvqSu7we2dxLESgo9qgTmz4d4F8ogxHQy5t2UVhESp2aAGDDZIprWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IplC3AEhaO0UewZ/prFvwHz4edTRshDIU63ED26xhw8=;
 b=UPN0LbnTogG+tZy3yXUniE0QgwW5l6QThh21gWWlQsqUErpQDQU0VxiBp8qjs3T1DCDX6TW/jl88LQNXVhpEe7kaXCmuYhrBIebzAsYvsf7UHNQlWYW/Bp4dpdh/NwT3QSVIH673TXrVvpLzQFk+py+iqUvZNrFBf1GrwSH/RPE=
Received: from SA1PR04MB8303.namprd04.prod.outlook.com (2603:10b6:806:1e4::17)
 by CH2PR04MB6790.namprd04.prod.outlook.com (2603:10b6:610:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.5; Mon, 9 Feb
 2026 06:57:43 +0000
Received: from SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1]) by SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1%5]) with mapi id 15.20.9611.006; Mon, 9 Feb 2026
 06:57:43 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "david@fromorbit.com" <david@fromorbit.com>
CC: hch <hch@lst.de>, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Thread-Topic: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Thread-Index: AQHclxW65B7KzMvbt0CIJI16Abrfu7V2QUiAgAOzUgA=
Date: Mon, 9 Feb 2026 06:57:43 +0000
Message-ID: <b1a2d202d6ee94fb484ebdb50d8737490177c3d8.camel@wdc.com>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
	 <aYZquyDjPqZIcKe4@dread.disaster.area>
In-Reply-To: <aYZquyDjPqZIcKe4@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR04MB8303:EE_|CH2PR04MB6790:EE_
x-ms-office365-filtering-correlation-id: 90749903-ca36-4b58-3909-08de67a8863a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TEpZT0NRMWZIWWtSRE9jWlFBTjNtcWtoRFBRQjZFN2JZL0NSbzJBeGt2NnRj?=
 =?utf-8?B?a1FLbHZQM1o3akh2UkZMOVFPZ2h0T3gxSi9mN1hjSEVRV25veHd5T0prdnlm?=
 =?utf-8?B?NTRIM201TUtZWHB5UzNCWkhXaHRXMXB4SURyTlZDaWN5VFpKa1JxUWFRL2hN?=
 =?utf-8?B?WkxXYWI0Zm9nNm1qTVBmT3FGS2RhVU9xWEFqV29PR3dRTlAzOVJqRXhQY1Zq?=
 =?utf-8?B?ckN4ZzVWaUsxWXo2WXkzWEJNcmUyUXRzblM5ZDcvbGowOVpkcEE1TE50NVJV?=
 =?utf-8?B?QWY2SUpJcVExYXBoZUZmbmIyd0VmQTdUeWVZT0oxdlU1NVR3ekgrSDZRSnQ1?=
 =?utf-8?B?OE4zRFJyK2tOWlpyOCtxYkdpZWo2OXhGUzNaLzZZd2pDUEVZKzJjV3hWS3pq?=
 =?utf-8?B?NnVKVi9mblJBczd6MmdZckdmdWxTNWRnQzlwMldXSFp3TG1HbVVsdmIyMFlk?=
 =?utf-8?B?VDRqUHY3dTJBeUdDU2tPM0RCQzVWQmdjdWsvSnVaVHNqc2R2czB0UVY0KytX?=
 =?utf-8?B?RUIydzQrc1JjTVBPT2F1amdBdVUwRGk4aGo1Um9rOHlQT05NRFg1eTVvTnVO?=
 =?utf-8?B?RFphcGxWMmpWTHNPNmcyYTAvRnNaNm9aMWovNksxdVZFWEdXeGVLSUhBMG5L?=
 =?utf-8?B?VDNwSjBoQ1RkRHZqSVp1bHUvQ3FIOWtmWXhHMFJicEY0ZTVRZFIxcmZVemg3?=
 =?utf-8?B?cklVRTI0djg0MzB3Z0tFRUY3cnE4L1R6NTJ3U09QbGRDQm1iQVh0ZThyTzJG?=
 =?utf-8?B?ZHV0MzRBVzYvTEcyaEl6TmduTEpQV2RXL00xaUFhU0d4ZUYxNy9XYnpLU3hs?=
 =?utf-8?B?d2xiL0tOazBOYTJLbG9SYlYySks3Sno1VkdmTHRaRXR1T25KQkVrQTh5cldo?=
 =?utf-8?B?T3ljKzJySEZnRUNBNG9nWFZuNmt6cTB5UnRmZDJiS1RweWdvUFJIakJCMHlo?=
 =?utf-8?B?RndkUHFyWFl4Q3ZudFhiVHA3Zmt6WWUzNDlrWE5ROTJxVTJCVmk1SFhRTUg1?=
 =?utf-8?B?bTd1SjlNeU5YclpLQXdIQ1dLaUZMQ2RNUHdyU1RESVlISEZrRXZEZW90OVl6?=
 =?utf-8?B?SExoc01TeU5ERlZySmdtL1ZZbWZpQXdiZ3U2aTRCNGJ0N0RnQ2preDFIVnNt?=
 =?utf-8?B?V2lvVU1LYVJLQi9aYldOTzd4VXBYQ09BZjdvcmh6Z2RsSmkweHRNSFBRaGxW?=
 =?utf-8?B?bkEvVWVuTG5maUVldi9rQk13VWR6dkkwbTNQUHBwZEorVlVzRzVWTXB6YW5u?=
 =?utf-8?B?R1F4b3lYV213SndKU3lZWmdqT1ZWMzhHSnRQSXBWUU9DTUdjbE91Z0s1SVFl?=
 =?utf-8?B?UVlyZm1adGU2bWl3U1FseXdEanNIdmlnSGFFWWxRdndxUUtJK3FlOHlBLzdo?=
 =?utf-8?B?S1RCdHZwVXY4dFNFcjlvZVNxOWRHOHFOdGlUcnRFMHBNZGFEOURDVEhaRkF1?=
 =?utf-8?B?TnlEYjc5RXpTY0ZqUHhPQVM4d0cwT0FpNUFhM0YyWEowRzNqNG1sVmhmOVpx?=
 =?utf-8?B?aFRrZUlOTFVzanVKZFJqa2s5dWdlNWVRMzVabXV5NGk1dHFpQVlNc0xvckl4?=
 =?utf-8?B?alJTMWpOOVhTOXFjUk1RZEMzY3hmVktUcDFhNjBhN0RHdi9Yc0NvTXdSUTcy?=
 =?utf-8?B?M2VDU1lTSjZhNUJhVHlIVkpzVGdyK2lVNmRMUmg0WWtXRmIzdWlqMExmdHBW?=
 =?utf-8?B?Mi9Uckh1VXFKTlRLZWdsQWU1VEN3NUN6MGdPbTc1V0Rxb2xDclR2QTUrTGlI?=
 =?utf-8?B?R3BoUk1XR0NCVi9ydVJPeWdkWG0zQnlrVU9TR043bjF0Z3NzMVNlZEVDQjJQ?=
 =?utf-8?B?LzhVeituUlhwTzI3cGFVbDZyWkZFK2pXSnRVRlp6UnZ3Zm5hZ0t4RWkxZUZB?=
 =?utf-8?B?ZFkvNVJ0bHROY1JBell4N1JNWGFsc2Fva1MvQ0luZXB1QU1Lcnc2VHZXa1B1?=
 =?utf-8?B?QzlkY0VFRWU2K3BQNjcwb05UYXE5SnErVXl3dk5WMkxqemFXWG9FRFBUcWRo?=
 =?utf-8?B?OWlYbTRVano1Z3VLQ3BCRHRFdVc5alhBb2ExcmJ0TGFmTFFpbzhBZEhwZ1Fo?=
 =?utf-8?B?S1Rld0xzcWhRU3hjdjQ1MG80WGVMM25IQzNxeEFaU1NqR2FTWFc4ZkJoY3FE?=
 =?utf-8?B?TW9JQmNWSS9SRTB0eldETDBVRkhObFVHU0srR0J3alJyNlRrTWlOR2RldTJw?=
 =?utf-8?Q?Jd4f3IJdI+gVEX3m8m58Bz8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB8303.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUQ0TmFTMGtoUDVBbEJXZnVlNHNvdnRXS2lvRFViNjdpbVIxRHpoeUtJTkI3?=
 =?utf-8?B?VlhTdXRTdUJrUm82QjQxRTF5UnJlbFBFU3FZeXlZcjVXdW5vZktCRVliRnJo?=
 =?utf-8?B?UE4waFQ1UkxGM3dPdFZocGMwVk1YZTIrRFNGT1Qxcnp1K3diZ3VrS1drN0pI?=
 =?utf-8?B?cGRzMThIZFhwNkZudzNtdCt4cFRheUVKNFFmVmxXR0JncUxLUEVWNk9XN2VN?=
 =?utf-8?B?QkNwNDlxdWdqTXJmQWp2QXN4YXJjcTZiMnRwV2wvS1NqNFV3NUU3YUFCYmQy?=
 =?utf-8?B?STBxQnhZY3h4b2NVZElwcE9ReG9jVHcxWlVWa2QrSklZaXhhRWZvOW1RRTFX?=
 =?utf-8?B?SlJGMjhkZ0F3eTYrWFRjejYvMTl0YjJUQjI1YWRab2crZy9pL3FnL00rdEJj?=
 =?utf-8?B?YTZOU1VzQ2RWUW8vOHdxUFIxZ21EL3dsM3NhNGpockF2OVBsd0JtaUkvT2do?=
 =?utf-8?B?VVJYL2dnMlM2eW5JVTBKUnBzTnczNWZrc3ZJWHpZMVFCU1FyWi80cWFWVUNU?=
 =?utf-8?B?cnhLT1dOYmRWaUJRYzByQ0lZT0QwYzFSZnNVSDdRbExJR0JSUVlqU1ZGb0Zm?=
 =?utf-8?B?bHJEYXlrUFlKRFpHUldTMlVhT2p1Q2JSeXpYS2FuVXM3dlJIVVRoSTMyTXFh?=
 =?utf-8?B?SnVqdUYxQzBMMUVpUTRENjNlVTBHblNWek5RNmtRejAwaWo4aXBjOUJUMkRa?=
 =?utf-8?B?U0dBNXVaZVRjUHBoVjltdEVJMTBLNXV2d2NvLzVjWGFZZmF1K2s4bUJQVlVY?=
 =?utf-8?B?aDQzaGpPTk4yNEpmRjd6NFF5VkVDYnNlcVpJTm9tY2J0bkZreE5ydDdkUkRa?=
 =?utf-8?B?UlFtWUpKdzUvOFprU3FIV0lMcFl6b3ZoblZIL3N4REtQeWJzaTNtaVhBN0RI?=
 =?utf-8?B?b3d0M3Jjbm5pS3JBbWFvZUxjMktyU2dYRXprT2pqNVJwNkltSXBLcjZyQU1I?=
 =?utf-8?B?V041Q0NWczZrc0xkclBaY05NZk80WHZpZFBKck83MVZJS2xMbXFlbmtYckNQ?=
 =?utf-8?B?S20xMkwrcWs0bmdrVmNQQWZZZXhXVGxSaW13ZHZiMTZVbEpSNWJyTWtPL1BZ?=
 =?utf-8?B?RGtNVGMzUUN0ejI3djZxYW1jYTV5VVlxejVmN0RpVlFhb2h0Y1ZDWTRSZnBw?=
 =?utf-8?B?UWsrNS9JcTRYNEVoaTkyaFEvZXNMSHN2UmtWLzF6R2grUmduR0VoR1A1MTc0?=
 =?utf-8?B?UnpzM2xaQW4zRTBzNDdrQUs2VVhCd3Y2eFZ1QUhPVkFKMGNlOUREK3ExSWcx?=
 =?utf-8?B?QXlxV2E4bnR1MS90Y3prRFRtQ3daeUZVWHd2dEF3dEYweGdHVjI2Mk9CM3dL?=
 =?utf-8?B?aGxXSUxmSDJKdmZoQ2RtNEpFQnZFV05TQ2JIbjVHUkZsSDhiakpacENnRkVy?=
 =?utf-8?B?UkNPVXhVZ2U5U0ZYWEE0aHZ5ZWVVU2NzYU1pZllVWnhML09WcTF6Y0phZUxY?=
 =?utf-8?B?M0U2VW9UTDVzakF6QVpmSkJ6YUl1U3VzT3BDN2tGa2VXbTJ2NnRxMG53RU1F?=
 =?utf-8?B?VFVrdFFxRXREWlhETlI1UkRHengvSDg2MVN6YjZHaGxOZVNaWmd4cmdqbE56?=
 =?utf-8?B?MnZtc29yd0RSaFBFVEp5bmphK2FIMVNweVpzVFJzNVgxakJRWkZoSlpVeVVP?=
 =?utf-8?B?Yzh1R3hzUkVFek9VSXBkWkxGdjVCZkFkNytUR1QrSFNEWk5CYWdwalI2S1Zs?=
 =?utf-8?B?cEJUeWp6TlBlYVJEcWtLWEVpckNHUjU1TVZCRVdaemFJdjZEZHNXWkgrNkFx?=
 =?utf-8?B?dVY1Nkd2aG05VEpyRWVGQ0NXb2RRcldvQXNDQ2dTb0JtM3RnSzdocUMxaG1F?=
 =?utf-8?B?cktUR090eWsrSi9RMWtLSUt6d0xaZTJiNTRwdFg4MUd2bkRaTWQ2cTZFQlVV?=
 =?utf-8?B?Z2VobC9iNm9oNkxMV1ZjbVFTVFJGc0d4d3QxaVdRT05rQUVtSzN5aHA3azQv?=
 =?utf-8?B?SGFBUFdQY3V2aXBRMllVSHRWSnRRTkd4UlFoTWNmMjdtd01KOGhKZ2tLTTJJ?=
 =?utf-8?B?SWxHbzhtSUxCcU9IRHZveWFYZXYzOXFIcXpOdGQrVndUUmpxZXhESk1QSlJo?=
 =?utf-8?B?U0hIeVdDSjFvdXdIbzFIQ1NKM1I1ck5QVzdkUXRKbGNraEg1WGx3aUttMVkr?=
 =?utf-8?B?Z2diQzVpT1YxTzR3cU43bTM2SERTNmhXbnFQc29pNjZCaFlxQVFlandVN0Q2?=
 =?utf-8?B?MERGaFhvWnFnR3FYdnBKY1o3aGJ4MUNLSHQ1anBDU1lueW9CY2xrUFZQbUVj?=
 =?utf-8?B?YVJPMSsyNXprOTFZazVMYnczd0FtVjV2Snp4b2psNC81VHVTSHB3VlVjM2h4?=
 =?utf-8?B?UDZsRE1paEF0cnRZZDBJcjJITWEwcmNtYnRZT3ZEdENQS293OEVFQ1d3MU1Y?=
 =?utf-8?Q?+aRYqLaUIfMGGd7Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FF41153AC62E54A837C8305C142CE7C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7HeLnvJV+/dQKjX7egmgCu8VKB7JYhrdPOorl91Evboe4gf3W8QgYdms2ffoeg0CLRofCVhphdZh6Ky6kJRL6iF/Ls2HrWCvW0y9wsDWBe6XAeoUYNX6tkkoDs8FME2wusklwtTRdv85IDSmGk71LMhxJjiwK9E9ekJUbFf1Xs10hZsCsZastvKyW+jgbTA+z001fMFTFIWvON86HOX9dgHJ8A/i64hmEaTT/ojz9UWx8YpY5pujLCDDYJLieF0etUnbVPSZQq5sEb6usVX9K9RiFNELnhDfmj9CZA4fyT/R5ZvvoRr+YO+N2lwAJs/6otXFfMm+lePke6BK91YuJtznCrPKjrdTM7CZ9tJwMDov+frmmS44eqVH0pC/GDvzheXm+1uTPLTJN4moH0eiOwH01L64ZcW5cpgp79AbXodb0yFXv0aupjC/xH9m70xbh30x1NMRsKMjSOcaivAMFcc3bC4DQtHWRFA9piCYZNVO2amcezfarCy2MvatpwuxfRKPDRad+jMC/yH7qCDmqN9GYETjRFQdD/m9C/aXsty2RBGUgYIsvOBcitBkbBjCNOiooFVpg/zLjGZO0aXnKA0hsHmHrmzpQvdXDkQDZbNo2bwTJzctaOLjxPNgvqtV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB8303.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90749903-ca36-4b58-3909-08de67a8863a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 06:57:43.6904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3GZ//u6qbq01swnjZyAUKng5ulgRvn2ruYhIqO+KOMYflG00DQR2jxGwjbY/saDf7KwQGueA0hrazOsGBb2etw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6790

T24gU2F0LCAyMDI2LTAyLTA3IGF0IDA5OjI3ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+
IE9uIEZyaSwgRmViIDA2LCAyMDI2IGF0IDAxOjA1OjU4UE0gKzEwMDAsIFdpbGZyZWQgTWFsbGF3
YSB3cm90ZToNCj4gPiBGcm9tOiBXaWxmcmVkIE1hbGxhd2EgPHdpbGZyZWQubWFsbGF3YUB3ZGMu
Y29tPg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBzdGF0aWMgc2l6ZSBjaGVja3MgZm9yIHRo
ZSBzdHJ1Y3R1cmVzIGluDQo+ID4gbGlieGZzL3hmc19mcy5oLiBUaGUgc3RydWN0dXJlcyB3aXRo
IGFyY2hpdGVjdHVyZSBkZXBlbmRlbnQgc2l6ZQ0KPiA+IGZvcg0KPiA+IGZpZWxkcyBhcmUgb21t
aXRlZCBmcm9tIHRoaXMgcGF0Y2ggKHN1Y2ggYXMgeGZzX2JzdGF0IHdoaWNoIGRlcGVuZHMNCj4g
PiBvbg0KPiA+IF9fa2VybmVsX2xvbmdfdCkuDQo+IA0KPiBUaGVyZSdzIG1vcmUgdGhhbiB0aGF0
Lg0KPiANCj4gRGlmZmVyZW50IGFyY2hpdGVjdHVyZXMgd2lsbCBoYXZlIGRpZmZlcmVudCBwYWRk
aW5nLCBhbGlnbm1lbnQgYW5kDQo+IGhvbGVzIGZvciB0aGUgc2FtZSBzdHJ1Y3R1cmUgKGUuZy4g
MzIgYml0IHZzIDY0IGJpdCkgcmVzdWx0aW5nIGluDQo+IGRpZmZlcmVudCBzaXplcyBmb3IgdGhl
IHNhbWUgc3RydWN0dXJlIGFjcm9zcyBkaWZmZXJlbnQgcGxhdGZvcm1zLg0KPiANCg0KQWggSSBz
ZWUuIEFzIHlvdSBtZW50aW9uZWQgSSBkbyBzZWUgYnVpbGQgZmFpbHVyZXMgZnJvbSB0ZXN0Ym90
IGZvcg0KMzJiaXQgY29uZmlncy4gRmFpbHVyZSBvbiB0aGUgZm9sbG93aW5nIHN0cnVjdHVyZXMg
KHNpemUgd2FzIGNhbGN1bGF0ZWQNCmZvciA2NGIpLg0KDQp4ZnNfZmxvY2s2NA0KeGZzX2Zzb3Bf
Z2VvbV92MQ0KeGZzX2dyb3dmc19kYXRhX3QNCnhmc19ncm93ZnNfcnRfdA0KeGZzX2lub2dycA0K
DQpXaGljaCBjaGVja3Mgb3V0IHdpdGggaGF2aW5nIGRpZmZlcmVudCBhbGlnbm1lbnQgcmVxdWly
ZW1lbnRzLiBpLmUNCnhmc19ncm93ZnNfZGF0YV90IHdvdWxkIGJlIDE2QiBmb3IgNjRiIGFuZCAx
MkIgZm9yIDMyYi4NCg0KPiBUaGlzIGlzIG5vdCBhY3R1YWxseSBhIGJ1ZyBpbiB0aGUgVUFQSSAt
IGFzIGxvbmcgYXMgdGhlDQo+IGFyY2hpdGVjdHVyZSdzIHVzZXJzcGFjZSBhbmQgdGhlIGtlcm5l
bCBhcmUgdXNpbmcgdGhlIHNhbWUgc3RydWN0dXJlDQo+IGxheW91dCwgdmFyaWF0aW9ucyBpbiBz
dHJ1Y3R1cmUgc2l6ZSBhbmQgbGF5b3V0IGJldHdlZW4gYXJjaGl0ZWN0dXJlcw0KPiBkb24ndCBt
YXR0ZXIuDQoNClRoZSBtYWluIHJlYXNvbiBmb3IgdGhpcyBwYXRjaCB3YXMgdG8gaGF2ZSBhcyBt
YW55IG9mIHRoZSBVQVBJDQpzdHJ1Y3R1cmVzIGNvdmVyZWQgYnkgc2l6ZSBjaGVja3Mgc3VjaCB0
aGF0IHdlIHdvdWxkIGNhdGNoIHNpemUgY2hhbmdlcw0KKHBhZGRpbmcgZXRjLi4uKSB3aGVuIHRo
ZXNlIHN0cnVjdHMgYXJlIG1vZGlmaWVkLg0KDQpXb3VsZCBvbWl0dGluZyB0aGUgYWJvdmUgbGlz
dGVkIGFuZCBrZWVwaW5nIHRoZSByZXN0IG9mIHRoZSBuZXcNCmFkZGl0aW9uIGJlIHN1ZmZpY2ll
bnQ/IG9yIGFyZSB0aGVyZSBkaWZmZXJlbnQgY29uZmlncyB0aGF0IHRoaXMgd291bGQNCmNhdXNl
IGlzc3VlcyBmb3IgcmVnYXJkbGVzcz8NCg0KSW4gYW55IGNhc2UsIEkgd2lsbCBzcGxpdCBvdXQg
dGhlIGRlbGV0aW9ucyBvZiB0aGUgZHVwbGljYXRlcyBhbmQgc2VuZA0KdGhhdCBwYXRjaCBzZXBh
cmF0ZWx5IGFzIENocmlzdG9waCBzdWdnZXN0ZWQuDQoNClJlZ2FyZHMsDQpXaWxmcmVkDQoNCg==
