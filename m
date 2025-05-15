Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E626B256C9C;
	Thu, 15 May 2025 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747331860; cv=fail; b=t+/mL98s8iAntLBu6GU7u3GHlgkV/Oe867IaBTbUC5sKFlN1AG8xHbRUN8vE80OBgEBpitc6Vgc7sAGJn4PtnFBmo+jnlqT+vMBqgRoaYJC9zgcJ+Mfa7ey8LFqdwypHfQlKfvz0Uv3guabt7gOXqy4jiFmQzH+NyxcKMVKUeFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747331860; c=relaxed/simple;
	bh=PYBqPBAEzIOhNMKhTw2N8mQ+nzp6RIs28xOAlQPEADw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S0A5Q0kXbuvQTZISl21HmaU109gh0gOSV0OrBUgtOcOxu2QOYFjoT7jYLMvde9XSLxqbK+s5CpNqlogEIqq80Bd3wT9YVC7Wd7QdFPWu5vBQ4ETXIa22gCOUSXGyfVc1dkA04/POgHctq/2umBkxaUzk0zjrBnd1m9fsYdoCtgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mp4OA4zP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GtEpDjrS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mp4OA4zP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GtEpDjrS"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FF1oQ4006316;
	Thu, 15 May 2025 17:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cM5SwalVwj6yrp6b6l5X60Ii4ZLRig16Hf3i7wU1/2Y=; b=
	mp4OA4zPAfk2xo+8LvbCszr5dhGU8RVsxIGRyrgDX0NL1F04DUVyzMx/cy51jqp0
	c2HC6dwm3664Uv/pKVQjYQsf1lVPSJlXVJ5lvzQjhCkdb8eLmyS1sAAB0VdqPkjE
	1LIBsBXLS91uUrcc+LYfX8ALEur8jgqTnsBYJDwCRPjQ7pB7S7CkNmdveAYBV7NS
	6GeVvEx89RowVmrRZjwdkO2zOfwuc/aWjqh4zAU6y3JJPcrWfdl/EeNweo2Iiw1i
	2B10zaAdevo5l7aOe4gfpDV/nrQIvbbOU/TTgo9k5lGW1IIMVKT+YLk3M/XUliFk
	pwkg4Vg0fBWDbmBWDknOog==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcgvs1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 17:57:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FGnh7E026189;
	Thu, 15 May 2025 17:57:27 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010006.outbound.protection.outlook.com [40.93.13.6])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbt9p0dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 17:57:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPbLyYYAGq5CTcZl9R2m34MPPDxRqSf9vSLYIGgh60f5zIOnlgjsZpKk1Wa2lln6gLNm46z/cae7vkeFWBuABQ+3XY3kLMRigheIO8LkoqU63NY4EbfYusY8s9WN8aSJHCFku4M1g5fpqC49HnJXIjZsbmjZWDl2OsT3FMbsj5pfdWT8fv9C6ibDs/bpTJJ+/GSVWgnqVNFWMT3b9+4oHpcLJJgm2aS78Hjk2mOAdcFJ5L/VpWeg6pauC13Jsmc8s+ipykXXQUOeJ7ZPEakw4yB5mIgPA4M/AR0ojtWmW/B0d1pZowGvjnEIRwFikUmo2gJUMM/jYSGmYvHta9+c9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cM5SwalVwj6yrp6b6l5X60Ii4ZLRig16Hf3i7wU1/2Y=;
 b=ROfRufQqJl4MZly4El5SY0Max2ZGL+9VMaLd6fPjuX7c85D8dtdK+mKVSbnJA0fMOKa4s47/wf0uvGmkdZFFcDLSX83R1VpG8KGP0aTKLpLhqEC7qMNAJUt//fm9QlKxXnUaAaTnpUVICN1epFfShWXcjuq3Q9/sZwn+OgyZz0g9dczhGmBagzBdNFEqCnq6WSP2OINffw2YdDvqgsz17xDTSt7N2kFZufjAKYs83sJVcA2sEu3NaRcWndihyi2weiWL/uHUzXZJr8g4WIHz26pXNBUAjNde7XbNLIaG73OmjqZ1W+LGTLcUkc9KV9Vb494ld3gQn+85oIP8vUCXOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cM5SwalVwj6yrp6b6l5X60Ii4ZLRig16Hf3i7wU1/2Y=;
 b=GtEpDjrS2Mm5EMcS1Kix3qPtTZax/5ZRc4JjfhvFIMbUu5DD+iLOKzvjnxgAq0KjeiPXwDob6EVSWu8XAUo1/tlhrg/Kjqvj/YgcWQhjgGhQD3aBMUN744wQozx5ZGyqq85kfmoYWtodWuRSMAMie+3bTmv0JUkmmtyjCqRc3Fk=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by IA1PR10MB7166.namprd10.prod.outlook.com (2603:10b6:208:3f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 17:57:25 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8722.031; Thu, 15 May 2025
 17:57:25 +0000
Message-ID: <cb1bce71-854e-478b-82eb-8a65ccfaf979@oracle.com>
Date: Thu, 15 May 2025 18:57:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
 <4ad2be95-5af8-4041-99d5-1c9dcaa9df7c@oracle.com>
 <20250515145441.GY25667@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250515145441.GY25667@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0618.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::20) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|IA1PR10MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: 45da83a7-9734-4754-ae9d-08dd93d9f2d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUdkUDZ5ME9rMDVYVG1zZEtTRm9PYWNyalE3MDl0bmNyRCswNXNxS1ZQNkVu?=
 =?utf-8?B?TUZ3QXNLVVhaVUVuRzFRMStvTzRlTkswdkdOUGNaZ0dnZWxCS3hHTmc2dDc5?=
 =?utf-8?B?YVVvSkN5enpvTVI4ZGFtd2NDTXdUaWFnOHhjZXdFWG1HVHB0M0Ivc24wNDUv?=
 =?utf-8?B?eU1FbFE2NUZPZEtYbkxjMDg1UFpYWmJMUVVEaVVUNHhCRU9LNHNpbkJGVXI3?=
 =?utf-8?B?cEdXdWFyYVVTdUFDRHRIdm1jNCtpeXE1T0UvMDZIRGk2b2hXSCtXUlZ0VEdU?=
 =?utf-8?B?N21uUERLK1VGK1hFbERHSUxHOFZxV1J6SkxEOTMvNklzUEJwWkpLNDI0OTZv?=
 =?utf-8?B?dGtLa3BXSEY1N3ZCV0NjVEI5cWhOY1grYmMwcDRSOTRhWHdpdWVySjN3NktC?=
 =?utf-8?B?RjhJZ3RwcjE4NlFJTGhINDlGZHVrb1UxQWUwVTBGeklQQXhZZHN5YWUzSGxk?=
 =?utf-8?B?NWNQaVdMZ3lLUWYxTVg5eUdlYlpwVnNqVDhFUTgrVks1blpFK3dCWUlmZ2xV?=
 =?utf-8?B?ekoxUnkrZWZ4WmFib2t5c3ZMZnBubFN1eTA1bVZwL2xiWThKa2JvcnhVb0VT?=
 =?utf-8?B?dmNZbE82VXhpeTJXeHp1bzNJNENrYzNaVEd1dGRQdFV5N0xMbS84ZkhMR0Jh?=
 =?utf-8?B?TDJOeXdkSmpYOGVVR1M2eXFiVlU0czJ5eFJOZmlSZTJaRjJKNklQS1lIOUs1?=
 =?utf-8?B?amZld1RDa1VBaFIwOTlydkdIcHBDaU1FY0M1NXRodVZNYWt2aHRya0k1WkN2?=
 =?utf-8?B?UjY0QjFKTXZWWGtjZGJJL3B1cVZ4MlhHOWRGWWFCWUpHT2JVRDFROHBoN1dt?=
 =?utf-8?B?VnM3a1M3ZmVjU1RiQ21ua0xxMnlWUHhFai84Z3cycklQc0JWRjVVSGJzQWE1?=
 =?utf-8?B?Q2p2ZnVsMjJ1S0dBRnFlRVMxYklYMTQzcWI5K1B0cGxMeEVyVUFnYmpHdDlI?=
 =?utf-8?B?M29VWlhrUWZhSlJsdERONVlOU0NZZGVsbnBoNUFoZGtpQ2FkSUNtL3RpNHVh?=
 =?utf-8?B?T0t0NFpiMlJxWnQzcXdJaXBsSFg4YXdRNDkvbDFlcW1rYTloOW5Ed2NnNmw3?=
 =?utf-8?B?TEdGUlZGZ0w2VmN2dHVydHdGVEhCdnBUM0ZzTE0xV2RydHFhZGQ2OEFMZjhW?=
 =?utf-8?B?b2lEVDFXeG1CTEc4ekZvQ0hVK1R6T1RrNFFzQzdzQjArd3RmMU5adjhPYlov?=
 =?utf-8?B?dmcvdFF0d09EMDJQZGM3WUdxb1BCUUVkQ0J0emZvaDlYY0JpOXU0WUtHS2lH?=
 =?utf-8?B?bnlkZWFld2pRMlVnbTgxa24vS2RiSE56NkNmUmNSMTFCVWdGV3RkRHhxSDAr?=
 =?utf-8?B?S2FCMVE0clFEamhkbFY3Y01BbWFxMXIwUGtMQWxWaVo3TTlGdk1nc1ZIM2xI?=
 =?utf-8?B?QjZGMU5HR2Q2YzFZQTBHNlVDY1Via1RTZWRIVHFSb0x6cmhGbmdjbzEweEF4?=
 =?utf-8?B?Sktva2FIVTllcmtOV1MxWEsrYW1VeHRLRGNMa1AwbWhDN0s5NVZzUHUwaTJi?=
 =?utf-8?B?THpOdTAzZjNsQUFPc3E3VUVKb05FY2NVcjlPbU1CSlVydjkzNGRORmRsRlpM?=
 =?utf-8?B?SC90V3EvZndCOGdPalFkUEk2NkhMWlM5dC91aHBqYk1vVFhicUNCZTJETDZr?=
 =?utf-8?B?NlBxQzZ2ditVSEMzaGo1ZUhFVjQrMHE3U3NpY2JXUWZFSVcrYmtzNGlnWDh1?=
 =?utf-8?B?Qi9ta2JUZE9SYzV6eUV3Q0Z5UGVEVGpOVFFrVUFCaUlxN25Td1FNTFpkdmo5?=
 =?utf-8?B?dUFsYXQ0aExSUVlYYUFVd2tReThSN1h5bWh6VXdOVllrWXlrV0ZXa1ZBUy9T?=
 =?utf-8?B?OTVwNlJCMjhJRVoxZ3ZXbnRuWFIrNndOR2diMXd6bEV1U0ptWThsUjB2eHBy?=
 =?utf-8?B?V0EwNXp1dE1mak56ZXdaVGVkTk9jb1NzdXZ2QlVMTENwNUQrS3Y5K1l0YVFo?=
 =?utf-8?Q?44nBuiss6Yk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TENua202K0dOMUUzYUVEUWUxNVlOY3FkY0I1THlDb3lVaVdhYlNVT3hyaTgx?=
 =?utf-8?B?SmM2ZmdsMHN4R3Y1SXlMWkRrUDdsWWdRaG5hb1dYVGpPOXQwK1pqVzRzNVlk?=
 =?utf-8?B?cUJMQWNQaXVQSlpnQTdWTXp6Tk5wZlczZWpWdXVtL25FTXZ4U3ZoS1dBRzNs?=
 =?utf-8?B?YXR2bHFxQXpxc0ZVQXJFZkk2MEJlcnpIRkpybjhyaFkwMWs3d2ppUzltNDAw?=
 =?utf-8?B?Yk1HclN2RS92WCtXM3FwUmVhMEhsZFBvOWNIVXhGU01mM2svTHl6b0gxTC9j?=
 =?utf-8?B?ZzhHdG5VL1crbm9wcnBiWFJlMHZPNGNEWGFYT3dIR0c2aFh3ejZxRGV4MlVi?=
 =?utf-8?B?S2VzbXovZzE4VlJQV2RLeEs4Vk52dGNXc0M3TW1MeVhzNktseExzR3QwTmlO?=
 =?utf-8?B?c0E5K2E1VjlKOFY4SUxtZnYvdXNRcC9wWGNXNmx5dDVBUzZmWTdjb0ZYQUJa?=
 =?utf-8?B?aXBCRnlSWkF1eVNUb2R1VHFJd0l1eXlac2U3THA5ZERndjBhWWJpekUwNzdp?=
 =?utf-8?B?bS8yeitJZjZXTEVZcjU4YUpyQkFIRmtaa0UvWER0TUI3SjYwMGJRU002Q2Yv?=
 =?utf-8?B?UXgrNTEwOWt2VEhqTWl1d2VPZUJQRVpBR2hCbG9UcmZ1cExiblFLK1JaZHFi?=
 =?utf-8?B?WGYxQ01TL2lleXFOU1c1am9vNGg4b3Qzb0oxNDcvVGFjbWJlU1BvN1RNdHZK?=
 =?utf-8?B?ek5RM2tzRVhPMlJPZ1gxT0lhK2JuU3JZUDNGOXpGM2U3OUE1Z01YNlZaUERh?=
 =?utf-8?B?Uit1N3kzVjVubnU5WTd1WnQwSzUrbGFLNENvQzk4Mk8zbUwxdTZhbC9ycWF0?=
 =?utf-8?B?YlloZDN4d0pLSnBEWDl1RklJN0M2cWFLSEhCRlc5VGw0dnlJaTNYR1JHZ3ls?=
 =?utf-8?B?Y2tUU25hM2NTQU5NTFVrUUcwcGV5Mm1tOUNiNFcrNS9jVmR5VWVzbU5vVG9Z?=
 =?utf-8?B?djBxMnpiYjE1UEo1SWlUU2FWYUdBZFlkYjNoRTBUajlvRCtqaHk2UVFKME5i?=
 =?utf-8?B?TDJiVHhmRFJXQ0plQ2FQeHIvbFVoN3hDczZyZnphOW5QWGtRbW40Tko3bkpT?=
 =?utf-8?B?R1IxUnB1V3hsMFZRRUp2eXkzbXI5MmlvR01HM0lYdnREdkZBUzJiRDRIOC9M?=
 =?utf-8?B?TUYrMzJ2SlVqTGdkNG1Kc0VGTjV5NndTZWtzcVcyTUd4Nzh0K1BDMmZkS0dQ?=
 =?utf-8?B?N2FRT1BnWXJReENma1lNZ3VFS2NmcGU5VTE3U1NnYVJ3STVNVFQwYTVkbWts?=
 =?utf-8?B?NUpxakVIdFFQcTdXUVArK1hzTFROOWRJRldxVU5kUFFaK0lZQzk2WExkbXhQ?=
 =?utf-8?B?UWk0aXhWTlpPNkJrWXBLSWJvRDZZZk1ZV3g2RGtHcUpXOHJrRE1XTnlRdWN1?=
 =?utf-8?B?YTR5cHVRWHRqcWtFTmU4ZXFIbGJaMkR6TllPRHVoOUhPa29WOWJuQVlmNGZm?=
 =?utf-8?B?VVNxbTRpMnV2RDJNbDZaREd4YUNTenpBQU1MeExWdTNibzNCKy9teDR2R1V5?=
 =?utf-8?B?YVpLN1NJV2NscytEN0lsRGZsNy9MOFl0NG14aVFnWU44aDNEQk5kdWIzdFZJ?=
 =?utf-8?B?ektvV0VlUzI1YklOL2gwR2k5bEpzcmlHM3pkcDRoRVNha1VqM0hqTldKNXJw?=
 =?utf-8?B?eWNFRWlBR25ZT3p5ejhTc09sdG9RTlM3UjRNUm50ZnpuRUxJSWJLTGNlQmcz?=
 =?utf-8?B?OFVKdUYvSEdEaFhPL00zMFlmQTJ2ZHdoSUZhbG9OSjQ1NWdHa0Nod2NCbmpn?=
 =?utf-8?B?c0RsbTBUMXh1UFFkc1dLUFh3SmJ5MlZRUXkvYnJQd2sxYTNuZHk1cDdjcTZk?=
 =?utf-8?B?ZTliZ3dyd1NzME9ZaWZvdHFxOWtHa0VwVHVsQlNDS01TbWRCaHVjYU0yOXpv?=
 =?utf-8?B?M1pYZ09UYUliZ1hVcm5MUTYyNmFuQUx1WGZkWGQyZFV0U3BqeTd1VDlZM3hN?=
 =?utf-8?B?TWF4QVVlWEN5M285MVRKU2JwU1lVWnFUV3ovMXU1T0Z3ZjdGTjVMUTV5cVh0?=
 =?utf-8?B?bCs4Ny9zNXc0QkZjWTQzY0hJbVlGdGF6YkxROHRvRVcvWVlja2xlN09kZi9F?=
 =?utf-8?B?bVBPVHY5eFRFdlZKaWFKYzlWRGJOOE5oeXN6b0VPMFB0czRERmlYUUROdSt6?=
 =?utf-8?Q?ik3smaHZG5BWSbzAF5OVPgdSY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VTkaNS0a9JVSR4ndlFDSSMj8H3zCcP1MH7tOnbZfmDQfNu22c+mUaWZ3AfmtibW/vdEvMjwNA8aDKtUEsz5L9fhAtixM3m6X1xcSXjHb4aLDQVeWjRc8xFeK6AHZNTqW90Wr7AuIoTCy3UYyfqo+T4FA8A6tjpSKb3b1BsMTymBzfgFd8Q95ay7nTQa5ds9EJO8dOQ7ScPIsq0wvwXuH+Byhqz6eoIJo6HpGZ2ckKtD+q6LCcyu/FXsBW11V5h4hizXbroPfSjR0nuDJXpuVlyXW9ABPNWXNWz6TIpoTMFtqgA7dJocm2NdFD02Aou0U8qnDTcTm0iC3InqfQ9CH176bbHzjphcXVd4LoP7Y8t0VvbRta5UVX3ZrDcy1gOj+c/12ttVlOiF8hUuMRZ8JjTC4Y+conv/i0YtmOnDzhWNkWBbP6W9aJ7iQ9M07wupU1yIbH+5OOd0AAyjbJIQvzuEW+cLPupK3j8yIx8nzMgVjgOqBgZO8k9KqJLhltwJmEa68MpUibJhoNfTmfAxg8VxI8eOHeAGZafG2CBrXOyU4mJJXvDrpF2WLJF3bEA3l3qh/PwSQMwjcS4BtTU28vmHbzgiCW+jEK/oXIBK1vwQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45da83a7-9734-4754-ae9d-08dd93d9f2d7
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 17:57:25.0109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2jm3q2+/gocasQE57OguHumeSMzcYtFbjKfynOKtP2ipX8g2NMKpyVDz5C/d8S4pGln9Xg1PWwik/PnkfkiuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_07,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505150177
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE3NyBTYWx0ZWRfX+MqrS80H/+QQ eC+qRatWE2MWomjZbz9LcGc+QDfOiV6tl3HdFbxlO9y/PyXYreovTMcbSjhTscOU7A+/OXuqgxJ xdf70yomyVE9h44O6YMdBXnyx4b/KoyYRUisUZq4gaRPNdIYW9hsZ8YBVvVCY9o6QyZAMcv3Mmt
 FDdvBGHoTXU0mKoKVDu448apfYyfy0EeWqtiR+iATDgxhHwyf37lRfrsbYL6CbHG++0dftEeoze ZVtQOX9yxqvWparapksFsm4DP9zQn1CzFYG5+MY3pMMgaR1sMgdtxYGECaVr1fSrqIXPVtxecYF x4Pb1H+thRRh+xNShXT9D26jzIU0Ir4Vcx9F3NeMNgO0f/twLqqBkNnozKXZkcwNSdQ5agdwXT8
 JVnRa0UfSNHpiYrbfPp6a9LXjK8y1KgTu08fJT1ENtmZwZ9idVMUBFf73EyVSaZgOLqyyUQE
X-Proofpoint-GUID: 8Zp3QTmPkIMYqaiUn4OrJPxcqlP91hTQ
X-Authority-Analysis: v=2.4 cv=fvDcZE4f c=1 sm=1 tr=0 ts=68262b0e b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=sxkzxhyOdJ96LEYcBdUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14694
X-Proofpoint-ORIG-GUID: 8Zp3QTmPkIMYqaiUn4OrJPxcqlP91hTQ

On 15/05/2025 15:54, Darrick J. Wong wrote:
> On Thu, May 15, 2025 at 09:16:12AM +0100, John Garry wrote:
>> On 14/05/2025 16:38, Darrick J. Wong wrote:
>>>>> --- a/common/rc
>>>>> +++ b/common/rc
>>>>> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
>>>>>     		fi
>>>>>     		if [ "$param" == "-A" ]; then
>>>>>     			opts+=" -d"
>>>>> -			pwrite_opts+="-D -V 1 -b 4k"
>>>>> +			pwrite_opts+="-d -V 1 -b 4k"
>>>> according to the documentation for -b, 4096 is the default (so I don't think
>>>> that we need to set it explicitly). But is that flag even relevant to
>>>> pwritev2?
>>> The documentation is wrong -- on XFS the default is the fs blocksize.
>>> Everywhere else is 4k.
>>
>> Right, I see that in init_cvtnum()
>>
>> However, from checking write_buffer(), we seem to split writes on this
>> blocksize - that does not seem proper in this instance.
>>
>> Should we really be doing something like:
>>
>> xfs_io -d -C "pwrite -b $SIZE -V 1 -A -D 0 $SIZE" file
> 
> In _require_xfs_io_command?  That only writes the first 4k of a file, so
> matching buffer size is ok.

right, I missed that. The usage in _require_xfs_io_command looks ok.

> 
> Are you asking if _require_xfs_io_command should seek out the filesystem
> block size, and use that for the buffer and write size arguments instead
> of hardcoding 4k?  For atomic writes, maybe it should be doing this,
> since the fs blocksize could be 64k.
> 

I was just a bit thrown by how we need to specify -b $size with -A to 
actually write $size atomically.

Thanks,
John


