Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCAE23EA85
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769604813; cv=fail; b=rNqpd5dygIPy8BOZLBOmizCv7dTZrZeK7fVPSb+Zznt6Ajzkt434KrUIuwfpfDjT9AW1sDXSBjLp6YM5dIN+bJhpYfjh4piqc8M5BJZqr/kHL19o5Nk7x5xtQqNuPaOoshC7OYhsd5JvBfJosBMVq1YX6czde5OJxCAQ4z1sIEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769604813; c=relaxed/simple;
	bh=vDL1S8kSJqryy+ZSyOCVTryJwBHNy9NsjqoWTm9YpVU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=npzpXBQ8s7R8XgUNozknb0UuomR8GegWom7Kw/Yo24LTnfT9IQqjnFkhyL24wnOWJIKKbMe+vn4YmMEFVQMnhLrLJykSA+KLTyppgRtpVqUCTpOoRigLJcjT6dlaASqvyVaUKhfBjnU0g/flNgyvmYGMAOBrclwxhadseD4agmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YAd7+btw; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vw0jKZmq; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YAd7+btw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vw0jKZmq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769604811; x=1801140811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vDL1S8kSJqryy+ZSyOCVTryJwBHNy9NsjqoWTm9YpVU=;
  b=YAd7+btwpciHOtWfX9cISWGHlsOSlt5U5qU6/ua8hO8+GgS0vQVxyKMQ
   I6RHFNM8hVKx0vj6JB40Lf6NYAB+9fc27rA/HjdbXbMRix6WzVXgFgfZm
   7e8/HySk6PxN3MAYNLUo8GpJ/v6ZKpDI7csSEYQLnHTiBhPFPqOvqf1Iq
   bsO/CWaZgvUyvUbB/ixnrYPnelXiT0QvsAo+h8CVffxSe2M3e8LaffYKg
   DVCfo6P0PVA+EaLs1/q+d4NewkWtNm+fVlNBtGDzsAA2qu7QzcZQP+j+p
   fcS+Prq3MbE8HpZu8TIricooXbt1vjX1sWmZXJDj3wtRZfQRsectJlM0m
   w==;
X-CSE-ConnectionGUID: Jw3V2NXJQ6+vkph0i3rijw==
X-CSE-MsgGUID: I3fQEqWEQuuu7ajQyb2P4Q==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="139350474"
Received: from mail-eastus2azon11010060.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.60])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:53:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMIiJQvVDzj72UqFR10joNDHOqWi8Dn/lKScgRSspflvsSTX/juqRDwEA/JuPuYj0pbT0NKmvgZgruhhSQAal8/TN61Wr52Mt6mh+OVkJYTs04L5Q8Tz+Y1K416+D/WSJLzlGZZP6Yu9m+QPNdFUFz7olBKV6Yrg6chqPWdehnvG8pm9logBD6G32EiAn1RGwPXiQy/fN8D17Z+uHlKA3yWIftGDgroJdwTCGpAEUS9qTvzod2NweUV2n0BL/LJiWeKNN7Njmie4XNehqcjIQa+v6qSKm28c8EDuePscuM1QVDT7b8xtM6CAl/jDuYEEGzKSKiMJa0Ul1tyDrdpNxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDL1S8kSJqryy+ZSyOCVTryJwBHNy9NsjqoWTm9YpVU=;
 b=BIQl3lTuuGM3uhUs2sx5V07Go+Y5wACirscZ4SlX9oa0ije5poOiymaWixy7Q/JBUex3kiD6fQ7WzIGv1HM7UM93SEaIsRfkakKc2t451Q2mHSgqvmF8MnnNWDBp8S08yaXIXv9wsbgatynfuH0VXgg9q+qjQx9kFYWacfkVKzaY3LsaIVB9X4AQwVqFR3lh7KUp2yVCgPiVBADR3iWsVxH2Fffi4yghGitmY78ZEErdxit0vKBACMHd72yl8zfKHe1Rlps1ntVkm+0uuwQT5sLDeDJfsP8jTHkKV3/ZfrDZdtPLAEY+RYrYjLamilw0KwRh85KR2C8CepQAyGz0vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDL1S8kSJqryy+ZSyOCVTryJwBHNy9NsjqoWTm9YpVU=;
 b=vw0jKZmq0MPe94NYxqkQWVSJg6JDuMC5Mwmi/JAW27QAmhZqS0j5osjrriJA2bPpXwm1vvzKKInqQML1JYL3qirDZIJP2VUNxJEohnj376/N7usoDGMAJ2VNOIrtsCEBwBtZkTccMf7U6OGchcbEuRT2d5VsVKBXVNOSBrrDrO8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6474.namprd04.prod.outlook.com (2603:10b6:5:1e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 12:53:25 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:53:25 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Thread-Topic: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Thread-Index: AQHcj6cE1kXUGEYG50iEjqwY9phDHbVnit8A
Date: Wed, 28 Jan 2026 12:53:24 +0000
Message-ID: <8df94cf5-20d0-40ea-8658-d24769faf7fd@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-11-hch@lst.de>
In-Reply-To: <20260127160619.330250-11-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6474:EE_
x-ms-office365-filtering-correlation-id: 489e4529-9543-4d9f-eb02-08de5e6c39a2
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bHVsQjJlRlNWYkZ0TlU1T3hFUFF3K2dXaGtlY291QzFIczgyaXgzdzJna3N6?=
 =?utf-8?B?YktWbXdxVHpXYStjcnJiNHQyNjVXTWJnVWVEd0xHN0g5cXlSRkhzRHZ5elpy?=
 =?utf-8?B?MThiblJrWjhNaGVWLzlab3BSQWFFSU11NWNGSDVjNXc5TWZ1Yzlad3VCcHFQ?=
 =?utf-8?B?YzU3bGU0NjJZNlVDa0c2ZDlTRnQ3THJDMGpWMUxPUGc2TGNMQVFKa3NRZ3Aw?=
 =?utf-8?B?WVFVRnZLOE5XMjRmYUZyTzJtcjFzMVVhK2ZvT1ZUa3IrTmY1T0M3UjNBWkg1?=
 =?utf-8?B?NUlURmgrdHRWU0V4SEw3T0ZIbkxNUVJXUlhvdXVmeHQ3SG9acVc2S1hueGJW?=
 =?utf-8?B?QnY0VnArcmNVL21MRm92M29ha2Z3Vko0MXBleWZXUEJTNE1rOEVkakprSWg2?=
 =?utf-8?B?eTV6Z2FKZEcxTWErbU5kSCtaMTM4R1A0SUZRbDlBNkoxblBEUjU2bTJwK1Ax?=
 =?utf-8?B?Yzd5TTRuYWpMUkFkQmJ4V2c4VWVZaS9yYUNGdURVSytEQXRWa0tsNzZGQ0Mx?=
 =?utf-8?B?OStnQUJpc2FrVUd6Y3YxM0o1ZWZIck5pdTFHVkd0Q0Urcmk2ZEttaDlobGxS?=
 =?utf-8?B?aFF5eGU3MGhIaGt3TlFrbHp1RmdNM1lKWmttdjl1K0d2aGtEUjhRZTdyN2Vs?=
 =?utf-8?B?S20xb243YysrbnN5OE5IMGNqRDJ0UVpsc0hYTkRmQXkyOU9kMG9XTnljNC80?=
 =?utf-8?B?cC9vRDhBWmY0cGVRRlN2ZHp3YU1VT0hEd3F2dlEvaWNGVlhoNFRCYjFSU3k5?=
 =?utf-8?B?d1VLT01kL3R1ZEpyMGhuckdoNmJEOUxFOHZzQlFvd2RnK2R0NlRoc3NpeUF1?=
 =?utf-8?B?NjBLNFNBTVBwYlZuNzlYU3lZZVhxelY4bFpwMVBoTFJhb1IyOEUyTm9DejNF?=
 =?utf-8?B?QS9QcjRmVzVaS3NmaXM5NjFMeURlcDkyMlBJeWNvYy9aZzBwUWtMaHlxOTdL?=
 =?utf-8?B?azMxVmRJbVZ0dEloYnpBV0duTDMvczZiUkVtbFJEUkxBazFJQnQ1ZU0zM0V5?=
 =?utf-8?B?WWQwSVltTEtzV1E3dTd3VE01OUNxOStPVEh4Z1JoOVFOUllDK3ltSjdpcllR?=
 =?utf-8?B?K1hNcjlRand5cWU3SmFEUU1ra05QQVBmSmJTRXV6MDFEREdGWlhMUTg5aS9G?=
 =?utf-8?B?SzRoMUlabEpVTzZiT0R0Ujc0WjAwVWYvMmd4b1hnSWVmZkZJc0l6YmhHS0cx?=
 =?utf-8?B?TEt3RDlEMDFwSUltR2JsQ1BBc1FJWkZWdHc4bkhDY2JLR2JxbXE3Wm1tSWls?=
 =?utf-8?B?ZVFqRmZkL2tHUVBhV0V2eHV4RStqRTdNVGxUSGszaUF3bEQ4TUFrVEVLZGJs?=
 =?utf-8?B?b1NUdjljSFk3V0djN0FacUNTU1hYNndBVjRkejJuc0NRSHVGTXByRjV2bHBW?=
 =?utf-8?B?ampPOHBtaTJMVWhkY2JIbEI0UEtZcUxTWDZTV1YwSzd6aU9zWU9OOGF6VzBx?=
 =?utf-8?B?SXpqMWcwMDIvQTVMa015RmcwNzU0Q0hNaUhXRXIrN0RKNDg1dTZGMjFBdW9j?=
 =?utf-8?B?TmgveHdkRW9pRytKSlE1MlVwRXJYQ1YzTXNkMEJURlpoUjExQkc5V0todStm?=
 =?utf-8?B?SUQyMFhzQTB5QXZML05jK2txM2RvSkd2REd2K0xwanpYN04vQlRLYlRvSGZK?=
 =?utf-8?B?YUY1WUlnSmExaWk1cjdsejF2NkduT2JybW5wTkhsR1IwY3djbS9oMHg0Rzly?=
 =?utf-8?B?TWhxbk5jZitwVXFLVTNvdjhPaC85OTEyQlhwOFYxeStJaHpROFE1dXJDbklJ?=
 =?utf-8?B?dEZsSEZKNFhjd012OEUrUmJGOWQwRFdzOWRDVExsbmFOS3IyMHRoK2JVT0ti?=
 =?utf-8?B?eTBtcjd3MmRxdHBsVUdmaTVNMGdMaUd5NzcyN3V5T1RrN1MvcFBPa0YwOENR?=
 =?utf-8?B?K1JwZmpOOFc1eEVsZkMyVTdmWkthVDRNNi9zMGNQbGVBUjhYVlFUYjhVa3p5?=
 =?utf-8?B?NTFlaXBEL3pOSVN1QnNEdlg2dlhNUzRsL0prdWdndEh6aDhmRm1TQ1RLcC9J?=
 =?utf-8?B?RUh5YnpONU9Vd0tySzNSVWtSMXlxL050eldxdEVWVklYbUZ0VU83blVQL0Uv?=
 =?utf-8?B?V1BBVWt3eTZXRzV3bDFsdCt0cktTVG1tbTkvNEZ1RnFBSHhad0N5cndlaWxu?=
 =?utf-8?B?V0pTWUZkRmpST2tqY0Exa3RNOTZvRWNJWTVxV0U4SHREZC9OdnRBSXNUSHBT?=
 =?utf-8?Q?8fL39mC19TokmiUyhGpQes4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnZHNk1Nd2VKZ2t6N3F1UHhQa1g1QTF3eUgrOWpNenFSV0lyNFh3cVBYQytC?=
 =?utf-8?B?dit4RHd4bUl3ZUgrV01ZZjA5S0w2Z3Ewa2dyaWhTaWlRZFFTNUdxb1BTbXBY?=
 =?utf-8?B?WmJvUy9meWF2R2lLL0NwK0xrVTJNZkU0WHV2a2dSaHZpZ0N5RFFuVEZuczY4?=
 =?utf-8?B?ejVmZHc0MXR6UFZ6S3dGVXRuVzV6Y3hsM01SZ09PUjdESmFvb2puVlk5a3Nx?=
 =?utf-8?B?cXN4dWMraE5OekorSGtUK2c0MEpFUXBtUEc5TS95bkdiS2tSVXpwN3NpTjM1?=
 =?utf-8?B?U05sSDRvUFBtUStLSmFDc1VjQitvQTNFd2M0Z3poZFNDb3dRNnF0eVE0N0Ur?=
 =?utf-8?B?d2wvREsrWFdkWWptMFBhaXRWSHgvUnFocjJaTXJVakVEUEhoWDJjeWE1RkQ4?=
 =?utf-8?B?NUZLeDlpUnFOaWx6ejhxeEJQbGtwejBiYWwybmFtWS9TbytyQkpJRUpIeGVK?=
 =?utf-8?B?UmFmbHpBeTYwbTdaMUpQSUM5WEJuUk9uazZMZEM2QjFzOVI5ZEhqdk40dVB4?=
 =?utf-8?B?VnczL2Vzc1RvSG5BUmVFeEJKdmhMNTFvMUs5RVR6SlMrTFZBck5QVm8wQkx4?=
 =?utf-8?B?SW9TbTJuWWtrbFcyVGcwZmY5YkZtNVBVRXpWdlhOTXFIaGJ0YjdpSENwTHk5?=
 =?utf-8?B?S0N1R1EwT1JMSExlSHg3TmFWcEkwUEJLSmNueGJ2Q0MxUDVaZHJobVBSbXpQ?=
 =?utf-8?B?c2FQNk9jaHRCRnhrVzdCQmFmYlc3V0VIaXZyUTFxZDMrU0V6R1hoVCtzNzJD?=
 =?utf-8?B?c05oVWxlRXVRcWZLL1BSL21EZDZ1MVpnV2NGbWNOREZVdzZEWndsV1pnQzJF?=
 =?utf-8?B?Q1RSQVdaQy81RTdQMkpvWDNxOTBIOGxmaFpBeTMxcFhmQk8zMlg4cWZSSVpF?=
 =?utf-8?B?ZkFLUWhEd0dBRkNTL3BuU2hXYS82L1kvWS9QLzdBVGFXQjRGYUw0SU1GZWZh?=
 =?utf-8?B?dFh3ckJ4VVlJY2Q1cGh6aC9hT0ZNbm1IY1YyR1pGeXFWWFhFQnRubytSMmVS?=
 =?utf-8?B?ZWtpMUxYWmRxeFRTRWtLRGE2RkJodWVqN1ozcjF5elZwSWVMdENYaDRnY2ZI?=
 =?utf-8?B?NUxpWE04ei9kRndXWXo2M1hZL3ZJSm01bDZDMFdicGJLV1JrNFBaZTFleHdR?=
 =?utf-8?B?SGZycDM5N1FYVmRaYTYxRFVOSXVjdUZyNEQ5dEppMko2YWtEb2xCMmFOK3BV?=
 =?utf-8?B?RXgrQUZkWGNVTFpmWjZqdXZ1Y2xpVDQyYm53aTF5WDI0dERCdVlTRXJzSFdU?=
 =?utf-8?B?bytob2kwR2lReWNmdlFMbmhnNEd2c0xWWmNBcEpyWUNVZUpXSHhROU1ZT0px?=
 =?utf-8?B?OStjNUJvK2d0Q29PYVhCSUxIY2ZRMGplVE42a0YwQ3BURUFTTEZWaXJPVHRB?=
 =?utf-8?B?Z0IxdmpsZC9RSU5QYTRiamRHVHl5Z2VCZnB5RWgvcjY4Yk1kOXJyV2piVnRr?=
 =?utf-8?B?Y2JhUHVlNUtjZmR5ZHFXWDcxcExqbFBOd3B5VEZjbU5ocWZleTFDZlQxb3JI?=
 =?utf-8?B?b0NPM2dlL0MwK0NERlhReC82WU9ha0tLUkpvdDBEUWhBRCtBOEpnSmd4SmZC?=
 =?utf-8?B?Qkw2MDFocjFSaXgyS3RmWGRQcTN3bGUvQUpmc3hHeTlNbVc1cmpHYTRIdmMx?=
 =?utf-8?B?bzFNRzlFTU4xOEtTMDR1L204Z2R4QTQzZEdTZnkwY1NOeTBCVU5DWStaRXdE?=
 =?utf-8?B?bWJxSTgwQW03a3NPWjJxN0VhVHFxbEUvSFN3SE0xTDVFNDR4Z2Vaa21hdGxx?=
 =?utf-8?B?UHZUSTZZYmQzKytGVkRNSDVTTEoydk55U2VrSEdoUmtubGZuOHlTSGZIbEFD?=
 =?utf-8?B?YmoxeUF6aHhOQ1g4SWIyc01uSmJUaGtsci9ScXh5RHNxb3BENmpGN09wNkhr?=
 =?utf-8?B?TWpBd1I2SmxGWlVmd0VVenFOTzBsWUk1bXJrWDJYUjRiOGpFNnNSaHBWdkhr?=
 =?utf-8?B?Q01TWkFVZ0tEbUdoblZqUVVoMkpTcXZnQSt1Y3lXenNDOUZ1SFBmUmFSTzVX?=
 =?utf-8?B?VFI2WEtPL2lXMisvcnM4Q1NYbjVJdkU1VEVHdnRNNXRhZWxvYjJVRk5OWm81?=
 =?utf-8?B?K1dpRWxKQVZmb1BtTEZGbXM2M1owRFFuZlVrWFdmOGc0RlZuV1RjaUpmVEo0?=
 =?utf-8?B?VzErb1MyY0ZCUEMya3NndjI4dmpkTU50NlVvbnpyeW14QzZOekpXMXAvWmNi?=
 =?utf-8?B?ZG43WEJid0x4RUoyWC9KcVBmdytRWS9qZ3hQTXNDV1F0RlRyTXpIQUt4ZVBm?=
 =?utf-8?B?STNSMW1aRjVkcUZOTjA5cXVIQkNkazV5R0VBZEFPV1JZQldBSUh4TGpwdWRI?=
 =?utf-8?B?TElxZmlTZDhKU1hSWjVQM2dRVENOUHVOVWVXdUNyRDRwUnRNNXgvQmlmcEQ0?=
 =?utf-8?Q?avkhuULl2ofb1swo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A6F398E0D62794E8DF024AAD19145E2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 mYw9zr/WZJ+bWdwhvQT9siOMVXtIL7/Lc4j+gh6HaFmJXSiCyBhrji+qEKIVOFA6FjTuSZvtALD1SkZ6iDNFjko1q7dCxcpLGan8nU0Csmx7BYtRfb7Nx19121WajlNUzSpfT56Y1Wz161/dmjR808bsn9RCCUMLsz4yvowkMBklHOGitvZJklP0RVlvBvdYGYi3yr7+i9v4Y665y+nybzqMEVIvMIMw2IGQ+4qSf2aYHrJSYdzhTc47oGpADZwv9U5pwB0DO4dNM08lC+28Fm+nfG/I7Lz3MfaAX2pm7aRg9MPVNkpVtifPgb0jhCmyyGsIs2qCZuWLfIpeYM/qMAQ3r6qsDbfQMJdvOwqmzXeyyHl6+SlxP27OEsRmboYWo76GEgDn3sibKLy9UWMH7mqX4yOeePXKKn/h7iE3zoFuhyPs/72H9V7y1zttj2RmJYB/A0EYs3/rPZmwyaEaWul/zl3SUWgC+OLWLfb41fbdeNwiIiDK5ThkhRbY7fJ8Vx01MxeJUeoT3D7LC7DXGi5wO/HKMQk+4aHrU4o5xAcECq8kntJyVO7hylAmImphMdAwGnjl08s9MBqtm30qqVhCkXNGye5vkVlYVIwPwa4GMK/T7Fcs/hHEwkt3TEtO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 489e4529-9543-4d9f-eb02-08de5e6c39a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:53:24.6782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ZMQysLzb3sGAYdq4z9uADNCgLO4uyP7LRhTNGH0DtoZaSsPILlQNFhcibBBJG5JZhdRqNcyvvk5NIEGJSTDVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6474

T24gMjcvMDEvMjAyNiAxNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBjb3Vu
dGVycyBvZiByZWFkLCB3cml0ZSBhbmQgem9uZV9yZXNldCBvcGVyYXRpb25zIGFzIHdlbGwgYXMN
Cj4gR0Mgd3JpdHRlbiBieXRlcyB0byBzeXNmcy4gIFRoaXMgd2F5IHRoZXkgY2FuIGJlIGVhc2ls
eSB1c2VkIGZvcg0KPiBtb25pdG9yaW5nIHRvb2xzIGFuZCB0ZXN0IGNhc2VzLg0KDQpUaGlzIGlz
IGdyZWF0LCBidXQgSSByZWFkIHRoaXMgYXMgImFkZCBhbGwgb2YgdGhlc2UgY291bnRlcnMgdG8g
c3lzZnMiLCBzbyBjbGFyaWZ5aW5nDQp0aGF0IGl0IGlzIG9ubHkgZ2MgYnl0ZXMgd3JpdHRlbiB0
aGF0IGlzIGFkZGVkIHRvIHN5c2ZzIHdvdWxkIGJlIGdvb2QuDQoNCllvdSBkaWQgbm90IGFkZCBh
IGNvdW50ZXIgZm9yIGdjIGJ5dGVzIHJlYWQsIGJlY2F1c2UgdGhhdCBpcyBlcXVhbCB0byBnYyBi
eXRlcyB3cml0dGVuPw0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3N0YXRzLmMgICB8IDcgKysrKysrLQ0K
PiAgZnMveGZzL3hmc19zdGF0cy5oICAgfCA2ICsrKysrKw0KPiAgZnMveGZzL3hmc196b25lX2dj
LmMgfCA3ICsrKysrKysNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfc3RhdHMuYyBiL2ZzL3hm
cy94ZnNfc3RhdHMuYw0KPiBpbmRleCA5NzgxMjIyZTA2NTMuLjZkN2Y5OGFmYTMxYSAxMDA2NDQN
Cj4gLS0tIGEvZnMveGZzL3hmc19zdGF0cy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfc3RhdHMuYw0K
PiBAQCAtMjQsNiArMjQsNyBAQCBpbnQgeGZzX3N0YXRzX2Zvcm1hdChzdHJ1Y3QgeGZzc3RhdHMg
X19wZXJjcHUgKnN0YXRzLCBjaGFyICpidWYpDQo+ICAJdWludDY0X3QJeHNfd3JpdGVfYnl0ZXMg
PSAwOw0KPiAgCXVpbnQ2NF90CXhzX3JlYWRfYnl0ZXMgPSAwOw0KPiAgCXVpbnQ2NF90CWRlZmVy
X3JlbG9nID0gMDsNCj4gKwl1aW50NjRfdAl4c19nY193cml0ZV9ieXRlcyA9IDA7DQo+ICANCj4g
IAlzdGF0aWMgY29uc3Qgc3RydWN0IHhzdGF0c19lbnRyeSB7DQo+ICAJCWNoYXIJKmRlc2M7DQo+
IEBAIC01Nyw3ICs1OCw4IEBAIGludCB4ZnNfc3RhdHNfZm9ybWF0KHN0cnVjdCB4ZnNzdGF0cyBf
X3BlcmNwdSAqc3RhdHMsIGNoYXIgKmJ1ZikNCj4gIAkJeyAicnRybWFwYnRfbWVtIiwJeGZzc3Rh
dHNfb2Zmc2V0KHhzX3J0cmVmY2J0XzIpCX0sDQo+ICAJCXsgInJ0cmVmY250YnQiLAkJeGZzc3Rh
dHNfb2Zmc2V0KHhzX3FtX2RxcmVjbGFpbXMpfSwNCj4gIAkJLyogd2UgcHJpbnQgYm90aCBzZXJp
ZXMgb2YgcXVvdGEgaW5mb3JtYXRpb24gdG9nZXRoZXIgKi8NCj4gLQkJeyAicW0iLAkJCXhmc3N0
YXRzX29mZnNldCh4c194c3RyYXRfYnl0ZXMpfSwNCj4gKwkJeyAicW0iLAkJCXhmc3N0YXRzX29m
ZnNldCh4c19nY19yZWFkX2NhbGxzKX0sDQo+ICsJCXsgInpvbmVkIiwJCXhmc3N0YXRzX29mZnNl
dChfX3BhZDEpfSwNCj4gIAl9Ow0KPiAgDQo+ICAJLyogTG9vcCBvdmVyIGFsbCBzdGF0cyBncm91
cHMgKi8NCj4gQEAgLTc3LDYgKzc5LDcgQEAgaW50IHhmc19zdGF0c19mb3JtYXQoc3RydWN0IHhm
c3N0YXRzIF9fcGVyY3B1ICpzdGF0cywgY2hhciAqYnVmKQ0KPiAgCQl4c193cml0ZV9ieXRlcyAr
PSBwZXJfY3B1X3B0cihzdGF0cywgaSktPnMueHNfd3JpdGVfYnl0ZXM7DQo+ICAJCXhzX3JlYWRf
Ynl0ZXMgKz0gcGVyX2NwdV9wdHIoc3RhdHMsIGkpLT5zLnhzX3JlYWRfYnl0ZXM7DQo+ICAJCWRl
ZmVyX3JlbG9nICs9IHBlcl9jcHVfcHRyKHN0YXRzLCBpKS0+cy5kZWZlcl9yZWxvZzsNCj4gKwkJ
eHNfZ2Nfd3JpdGVfYnl0ZXMgKz0gcGVyX2NwdV9wdHIoc3RhdHMsIGkpLT5zLnhzX3JlYWRfYnl0
ZXM7DQoNCm9oISB0aGlzIHNob3VsZCBiZToNCg0KeHNfZ2Nfd3JpdGVfYnl0ZXMgKz0gcGVyX2Nw
dV9wdHIoc3RhdHMsIGkpLT5zLnhzX2djX3dyaXRlX2J5dGVzOw0KDQpyaWdodD8NCg0KDQo+ICAJ
fQ0KPiAgDQo+ICAJbGVuICs9IHNjbnByaW50ZihidWYgKyBsZW4sIFBBVEhfTUFYLWxlbiwgInhw
YyAlbGx1ICVsbHUgJWxsdVxuIiwNCj4gQEAgLTg5LDYgKzkyLDggQEAgaW50IHhmc19zdGF0c19m
b3JtYXQoc3RydWN0IHhmc3N0YXRzIF9fcGVyY3B1ICpzdGF0cywgY2hhciAqYnVmKQ0KPiAgI2Vs
c2UNCj4gIAkJMCk7DQo+ICAjZW5kaWYNCj4gKwlsZW4gKz0gc2NucHJpbnRmKGJ1ZiArIGxlbiwg
UEFUSF9NQVgtbGVuLCAiZ2MgeHBjICVsbHVcbiIsDQo+ICsJCQl4c19nY193cml0ZV9ieXRlcyk7
DQo+ICANCj4gIAlyZXR1cm4gbGVuOw0KPiAgfQ0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19z
dGF0cy5oIGIvZnMveGZzL3hmc19zdGF0cy5oDQo+IGluZGV4IDE1YmExYWJjZjI1My4uMTZkYmJj
MGI3MmRiIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3N0YXRzLmgNCj4gKysrIGIvZnMveGZz
L3hmc19zdGF0cy5oDQo+IEBAIC0xMzgsMTAgKzEzOCwxNiBAQCBzdHJ1Y3QgX194ZnNzdGF0cyB7
DQo+ICAJdWludDMyX3QJCXhzX3FtX2Rxd2FudHM7DQo+ICAJdWludDMyX3QJCXhzX3FtX2RxdW90
Ow0KPiAgCXVpbnQzMl90CQl4c19xbV9kcXVvdF91bnVzZWQ7DQo+ICsvKiBab25lIEdDIGNvdW50
ZXJzICovDQo+ICsJdWludDMyX3QJCXhzX2djX3JlYWRfY2FsbHM7DQo+ICsJdWludDMyX3QJCXhz
X2djX3dyaXRlX2NhbGxzOw0KPiArCXVpbnQzMl90CQl4c19nY196b25lX3Jlc2V0X2NhbGxzOw0K
PiArCXVpbnQzMl90CQlfX3BhZDE7DQo+ICAvKiBFeHRyYSBwcmVjaXNpb24gY291bnRlcnMgKi8N
Cj4gIAl1aW50NjRfdAkJeHNfeHN0cmF0X2J5dGVzOw0KPiAgCXVpbnQ2NF90CQl4c193cml0ZV9i
eXRlczsNCj4gIAl1aW50NjRfdAkJeHNfcmVhZF9ieXRlczsNCj4gKwl1aW50NjRfdAkJeHNfZ2Nf
d3JpdGVfYnl0ZXM7DQo+ICAJdWludDY0X3QJCWRlZmVyX3JlbG9nOw0KPiAgfTsNCj4gIA0KPiBk
aWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0K
PiBpbmRleCA1NzAxMDIxODQ5MDQuLjRiYjY0N2QzYmU0MSAxMDA2NDQNCj4gLS0tIGEvZnMveGZz
L3hmc196b25lX2djLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gQEAgLTcxMiw2
ICs3MTIsOCBAQCB4ZnNfem9uZV9nY19zdGFydF9jaHVuaygNCj4gIAlkYXRhLT5zY3JhdGNoX2hl
YWQgPSAoZGF0YS0+c2NyYXRjaF9oZWFkICsgbGVuKSAlIGRhdGEtPnNjcmF0Y2hfc2l6ZTsNCj4g
IAlkYXRhLT5zY3JhdGNoX2F2YWlsYWJsZSAtPSBsZW47DQo+ICANCj4gKwlYRlNfU1RBVFNfSU5D
KG1wLCB4c19nY19yZWFkX2NhbGxzKTsNCj4gKw0KPiAgCVdSSVRFX09OQ0UoY2h1bmstPnN0YXRl
LCBYRlNfR0NfQklPX05FVyk7DQo+ICAJbGlzdF9hZGRfdGFpbCgmY2h1bmstPmVudHJ5LCAmZGF0
YS0+cmVhZGluZyk7DQo+ICAJeGZzX3pvbmVfZ2NfaXRlcl9hZHZhbmNlKGl0ZXIsIGlyZWMucm1f
YmxvY2tjb3VudCk7DQo+IEBAIC04MTUsNiArODE3LDkgQEAgeGZzX3pvbmVfZ2Nfd3JpdGVfY2h1
bmsoDQo+ICAJCXJldHVybjsNCj4gIAl9DQo+ICANCj4gKwlYRlNfU1RBVFNfSU5DKG1wLCB4c19n
Y193cml0ZV9jYWxscyk7DQo+ICsJWEZTX1NUQVRTX0FERChtcCwgeHNfZ2Nfd3JpdGVfYnl0ZXMs
IGNodW5rLT5sZW4pOw0KPiArDQo+ICAJV1JJVEVfT05DRShjaHVuay0+c3RhdGUsIFhGU19HQ19C
SU9fTkVXKTsNCj4gIAlsaXN0X21vdmVfdGFpbCgmY2h1bmstPmVudHJ5LCAmZGF0YS0+d3JpdGlu
Zyk7DQo+ICANCj4gQEAgLTkxMSw2ICs5MTYsOCBAQCB4ZnNfc3VibWl0X3pvbmVfcmVzZXRfYmlv
KA0KPiAgCQlyZXR1cm47DQo+ICAJfQ0KPiAgDQo+ICsJWEZTX1NUQVRTX0lOQyhtcCwgeHNfZ2Nf
em9uZV9yZXNldF9jYWxscyk7DQo+ICsNCj4gIAliaW8tPmJpX2l0ZXIuYmlfc2VjdG9yID0geGZz
X2dibm9fdG9fZGFkZHIoJnJ0Zy0+cnRnX2dyb3VwLCAwKTsNCj4gIAlpZiAoIWJkZXZfem9uZV9p
c19zZXEoYmlvLT5iaV9iZGV2LCBiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yKSkgew0KPiAgCQkvKg0K
DQo=
