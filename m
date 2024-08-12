Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054FF17BB03;
	Mon, 12 Aug 2024 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723474223; cv=fail; b=dK/mWNlD1r6cYGordlVjGjI/3HL3104lsx2hm4V3wD0dpwDTbKijj2irsc9RdkQGOpYVsxfecVxQUUkGFoKH8jXRR93HOS38S69/nnBaVKcRhyBIESsstNmREZ6vY94DgRQb30ehmXjgVy1XtX37GSf0t8aJuFfJvcaWeWd7Bdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723474223; c=relaxed/simple;
	bh=r+L1q2QwBBKqiYZ9MnPH+6QIRBq0sa1iEfPH4iHwPls=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WaU0mJRgcHXLEpSI0/XDHLvGDB2klTGBKYmMiaVEcbTCy1nFIeBTQ51KvNRMqKfVYEctArdxuI4Fq48rIQ1vLpngvz20btJzuOTheMXQLMsan0oGK7NcZeeS+PlfGaf2yjaPNQ5aDKb4FJLfB5RyL+nzwu5Q+56Vm6zF5boDb60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e35Ahc0P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fEcjVBQQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e35Ahc0P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fEcjVBQQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47C8wms1002478;
	Mon, 12 Aug 2024 14:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:from:to:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ISJ1+B1yUZo7/h9QGI1mHyWdYlH2nlkpqzyO2/8RqRY=; b=
	e35Ahc0Pn45qw7sWMu/kQNE9ir4qZ6Qm/hVJ0BJ5wSMgww/CP0oCprTMh1GIfShz
	FGkk2YuB0Hb5qCjRN6c/ZpT4ge7ZJrfmHRuL5hjZYJ69//+F7IoHga5fMfyyVq7O
	pc3yfgAjQpcl8EniQj79yXKaI4yWzqqXiAbaaRaiB/3odMtQvyxfK3OswqOp7Bh9
	T4u43h2fDIymtniQpDGWitSVcmCx7Q1TAFZCiAIDcBFKF0UoGOV5u6M4XuyP56Cq
	MYCIjHjUC571HVNlHKdcdwbzL00m0DgS4QuhWQ7WxPWZn2vFYT5hZyaVezFGKECi
	zCMG+pPKxwZdhT+5mk5Fkw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bau8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 14:50:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CDo3vJ003324;
	Mon, 12 Aug 2024 14:50:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn76ys8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 14:50:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7bDn1E+cArCLiOseMNcAuP5CXFMzuj2ndwK+YIzxWUTRz5AvvxSFmezbRcwCKaOLp2zyq47LUJBom/88gjmFR7H99uEI6vqQhO32/GBDJcvWCrtJHitNnLBeXTPSLBz7s0pzqwvo9e++sgC5Sie/c90FZ+vgK8PRbr1fqCSn9TxMieBdp3ZjhMVZ4tTICIxnEURAuNOYkmAM3NuPGr/CkxOi7bMzLdS3gpcRcSK/gxQkzBVD/iVxe2Jc0Vcjmh8QWIxqPEjJgNG//YoU0WQ2RJQinesaulc96wnA7wWbDvhE2y3ivqNe6+wCtN9jMhhIJSgXtDVCKXa1Edu0fctjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISJ1+B1yUZo7/h9QGI1mHyWdYlH2nlkpqzyO2/8RqRY=;
 b=N7RJXIJHYzeENDuvfSqUjsp57CIqDtcTZd5+wuP+eb0QorbFnCzcYklt3imXnIYqrYzJsHBCcFTrOhBXn6Vi3YlzBU+YrpDHiEorFHlcWH/w3irib3h0yaTGhn50AK0RVLVv+/O8QIXG16VXzZRROTCEUwLnskgtLthxBYBRtv6h7e2u2L+zcXOku7gNKURyvgrw6qbQKNLS8q7ppBvNfGrq0Bnbm22L62HD4xtF+QyA0NEhB05sKgK6yuHLHgy24zds+xplyQaPixkDkZZa4zosRlETL/3pYEfXHq6q9i7DGTJL9MFrsdQ4WciL3D9bNXRtDCmD+T8C3OPLM6sx5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISJ1+B1yUZo7/h9QGI1mHyWdYlH2nlkpqzyO2/8RqRY=;
 b=fEcjVBQQBea0gflk8iv9CIDMf5zLzVkyN5XxL+F94hfJjajGBNlR6cdLpQxjcAng4SWNdC3KWzwLsxVrq3tuxwM2bGo0crRN0g6BVUjWEVGYYExDDpa8qDgaftthUly/I6V4ZvwkEDYuc2VTDErFtwd+L+n7iofnjrdMkNgJCqk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5195.namprd10.prod.outlook.com (2603:10b6:610:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.12; Mon, 12 Aug
 2024 14:50:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.015; Mon, 12 Aug 2024
 14:50:16 +0000
Message-ID: <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com>
Date: Mon, 12 Aug 2024 15:50:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] raid0 array mkfs.xfs hang
From: John Garry <john.g.garry@oracle.com>
To: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5195:EE_
X-MS-Office365-Filtering-Correlation-Id: 19ad0807-29ce-42a7-b88d-08dcbade13e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDJnYVJpcnh2Unpla1k3dG9ZdEFWZkNUUGhrcDNQdWxkZkNocGJhNUFIYjdN?=
 =?utf-8?B?MkppQjBYQ0NvWmRCaWFseHhjY3RMV0ZiR05Fdk1qWVRRajR3Unk5SVRmWFcr?=
 =?utf-8?B?clVGaVZOcnZJdmY1WFZtWUgwT2tlZWszUWp2UjZ3TksxWUgvM1BjbldTRjR3?=
 =?utf-8?B?dHVZSURWVHIyZ1NIVUFmTG03MnA0OEdpNWM3MFdZbGpab2NyWmlEeGVWRTBZ?=
 =?utf-8?B?amVMd1B4UzR5SnI2STJJKzkyd1dZdzVUQ0tPODIwOVk0NVRKdTMzcVh0YWdP?=
 =?utf-8?B?U1dZaHEyZzE4ZHc1YWVRQ05qa2ZHbTd5QjdNaWZFNkVFMHJaekFBUGZEa2Vk?=
 =?utf-8?B?cE5NY2Y0aWx1KytaR0N0NTU3NnZNeFFxbVRrVS95aCtQdGcvM3JsTHFvNFRi?=
 =?utf-8?B?WkJWZzMyN0F3NXhTcHFFRHpmaE1iWi81REZHVUJtOFg4Vi9ha1Nrd3hDNVN5?=
 =?utf-8?B?R29wSEhMVDZyTTd4cGZwTXNMbnQ2THQ0VlNqcFBhRzZkSGZFeWZ6bXdxODlS?=
 =?utf-8?B?dmVDVCtmYytkRDZJVnVBZ2UyNldKSmhsamlMYVdnWHdnY29tR3VaWkMxTVJw?=
 =?utf-8?B?K3ErT2dIRnNxbTFmRmxFSGE2MmZtU0FTV2dJcmlSdlRSSEFvcHFVK3NwTmpL?=
 =?utf-8?B?YkptYXdQT0JKRzNWS0RMc1V3SGI0aUxzakY2bWg1VTlKL243TXJYUFYwUWRN?=
 =?utf-8?B?SkJQNWZwUlRyU3JJWllWaTNpczYrV2Y1b2Nnc3doUmdHLys4bzFtemtTR0xa?=
 =?utf-8?B?RElRSDRMM1hDV0xXd2s2VU5lUVd2OXJMMTVYYUkzS1cvNUl1bkpGTU96Znpo?=
 =?utf-8?B?RnllLy9PK3VwYmw4cFg0aEhQWlRhcDZqUDVyV1RzMHM3dVRoODBGeW1lR3hX?=
 =?utf-8?B?YXZLZENsYzQxbUY5ZmRwMzRoWjYwSzBvd1ZWVkNTTEdIMjdGZFo2YWJYTG1P?=
 =?utf-8?B?R051aEdLcFRta1J5TXo3ZWQ2QmpKRG1GL09SUUZWTDZKYW16MFNOOVZXbDdJ?=
 =?utf-8?B?NHBqaG1iMXhuanFMS2dybzl2QS9JcWp5dStZMHFsUGk4MWV1czkyM3BRc2xN?=
 =?utf-8?B?dzQwNVFPMXZreFJjMmw3U05BdnRyWmNXYzRyVnM3dXlCMjdNU2tXNEkrcjdI?=
 =?utf-8?B?MTlTaGxzUVpkeTdxWkZUT2d4UWFUanFrM2VJYVRiUEV0SUxXZGpuSW1raDY0?=
 =?utf-8?B?ZTNPME9aQmszWHFwYTJGeGo5bGtka0lBbEFOSlpQZ2dVcVZZa1I5UGVaaWYy?=
 =?utf-8?B?NEtycDhRMkxUNEc5M2hlTG9sbjBsR2F3UVkwOEx4S3JqTzVFLzB3dGlveU05?=
 =?utf-8?B?QjFSbzE2bG91bzhPSVp6U0Mveks5UW1ybThPWFVkb3hocjh5T2RmN004UzlV?=
 =?utf-8?B?WGxSR053dzhPRzdTMmlOUUxxRGNTNUN3L3dneHU2YlU2QXdCVi9FcTN2T2lw?=
 =?utf-8?B?Sjc5Qm8xNll2SEl6V1puMTU5aXJOZjFPWlZQOWVjS3k2K1VLMW14UFJvbmFQ?=
 =?utf-8?B?blBEbzZKdzQ1dmQ2ejJSbFhsNlYvN0MvWEdZWExWd3J0MnJiR0xiSXF0cjJS?=
 =?utf-8?B?RjZTdWcwOHRUSzcxYW8yMm1QdUkxUk9BZThVR2tZK2txaUd2MDR5VWxHcU9n?=
 =?utf-8?B?MHNoTkRvdE5qNlUvVWROWG1VdkNsWkdZUkprT0d5azRUMjl3OHZFc3RxRVhR?=
 =?utf-8?B?b1FJTThxR1RQZkQxajRudlF2ekVtTXlpc1NtU1kremhRRm92NzZSV2RJU1Rq?=
 =?utf-8?B?bnFxSTl4YTRMZDFVNWdCMHBGZm0ydlJLTlVQTW9VL2FhMmlzNGIyUVUvaEFS?=
 =?utf-8?B?UUwwZU1mR2IyRTJJTnNYZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0FhajF5bjRGN1FHS0lDMjhHNGtEL3JkRDY4ZEs3Vjc3YXJPTkYyNFRlY2xS?=
 =?utf-8?B?VmxjWWhMYVAvNWpyb3VaSzBtUEtROVhQU0RHKzIzRU5yQldlOFc5eE5yaW5Q?=
 =?utf-8?B?RFEzeGJkNmF6WWo2eDViamtnd1M4N1hRd3pZb09IeXowRzZ2NFBFVlJuQ283?=
 =?utf-8?B?dmRPTGNhQVU5WndSTW1NVFdrYWdPZ2MvL1VuTlB6SjZGdkhMcWhNWHBocit2?=
 =?utf-8?B?dzdLYk5IbHB1S3U3OEVXbGpFS0RheE5jZ1o0SmRmbGVrZGV2NmdNTW9TcDRK?=
 =?utf-8?B?NjJZV0xIazA5L3oxMFNZVjFPRmt2b2hXZzJPK0RlNlJWLzhKMUJJM1pZdjRJ?=
 =?utf-8?B?Qmk3Nk5tNmQyU2pCQ2w5ZWRBUnorNG02SWxpVG9MeHlLTDlhWm9aWDdMT2Nn?=
 =?utf-8?B?Z3F6bmhrT1dRSXJIck1DZXMwdTZvc0Z1SlF1S2xXRjE2VFU5TWpWeEkyNTBE?=
 =?utf-8?B?TVk0blR4aGNXN0gvbzRrNmlTbHp5R0dLOHFLVFJEa0pPb0NhZDRRSGVUczl1?=
 =?utf-8?B?VG1FZG1SQTdRVU91NjFja0VRZFY3SUdQYmVUS0swRm56U2JVRWQ0WlpmWnZm?=
 =?utf-8?B?ZVM2L3ZiTnlCQ3VlVWR1UHF3TUFNeG1jU0ptRjdlYlF4U0ZFV1psbVFSb2RV?=
 =?utf-8?B?M2hBMEZwM2gyU0xvbHdVc3NFMXlTODBEZkRiM3h6MTFBZEdyM0EvMW4xREcr?=
 =?utf-8?B?dEdEZm5ab2NIY1dVaE9KVnVQcC82SUFqcjlqV2k0TnZZNXpBZEtUamIxSS9u?=
 =?utf-8?B?SEowRlNpVlFrcmlrYzNObjlWRy9ZVWxiU0xLWm5CZURtc0t4b2Rkc2Y3d3VZ?=
 =?utf-8?B?bGdmbzdzcWRvR3FDdXd5T3JIVThhY0dOdUFhbytacjRpcTJpNWpTWk9icDNv?=
 =?utf-8?B?bXhPQUN5ZHR6Mlk1SGhXb0k5bXVVWFNNT1hTOG5UV1M5cmJXMGVpemdsWVZ1?=
 =?utf-8?B?VmZxWklWOGUrT1NxUWRsZDhLMTM2WExvU3JCVUxObm5OVFdkUFNPL21tVmVW?=
 =?utf-8?B?ZU9sZW00N2hkY1Z3TnlQZ1lJK2RxZzBjSm5KK3FjV1FSbU9EZ045R2tsZmpK?=
 =?utf-8?B?VWxhd2FpSi8wdUdqWjByNDZuMUNJZ2JSYjhLRDNCL0RHVUw0Q05GbHRHNWln?=
 =?utf-8?B?RFRPMHB1NFc4VmltS1RwVUdFRzV4K0pHM1l0T2JhMjhCdlJsMWp6ZkxhMzB6?=
 =?utf-8?B?N0ZmQUFWSlFNZUwwTWlmZmNJRk53L3BtTk4xQzdLMlRNM2tWMU1BYnB3dkl0?=
 =?utf-8?B?M2tsUXRiYzIrenBPZS9EcGl0anhmLzBpUXhKajRjMklTZzRtL3o5eWJmVGVk?=
 =?utf-8?B?NmdsVWQwMUJ3K1l1UkFObXo5LzNjbjFGckJaU252UUR6YkdGUWoya0FZMFF5?=
 =?utf-8?B?NFNSNjIvbDRiODZscDB5M3pGUCtXZ2FMVTJpdGtKTkN4TGNmSTVKWnh4Tkpr?=
 =?utf-8?B?Rms5YlRGS1Q0OWRMdmdacCs3QUt5RkRGQzNZL1BjZkpuaStWMDNaQzFNSTl4?=
 =?utf-8?B?Z3dBTWlMcWpWeVphOHAzTGYrbXR4NzFDYVNzekU5NG5Ec3VYQ3djZFJnUXBL?=
 =?utf-8?B?SGVJMnhkbDFrcmhDdW1WaVh4L1VJQS9OSytQQU1yTHBWK21FNXl0ck8yaFUy?=
 =?utf-8?B?emlGdUVKbXZOczNJcXRzVVNDRDFoWmUwZ0tyb3VmNjdRMStNeVV6cXI2d200?=
 =?utf-8?B?U1ZXVmcrTlFWTExVUWtWa0dpNUdBT1pleld1SlF0Q0NKNWh0SVFwT0xUdk1Y?=
 =?utf-8?B?dUZBdy91UkVMNmVla2JCdWQ5ZldqbHF0K2s2YmpTb1RsWHd4Wk5pTkhocm1Z?=
 =?utf-8?B?QTFEc2tGblRibnhPQ0YybEUxQ2htRXd1VEpSdTdlcUxjbExTc1BMWWMwQzlv?=
 =?utf-8?B?TWJlbEtEbGZVcWlSaUFkZERYTGVaVnhLampsYmpvQ1gySnd0dmM5TkwyWGt6?=
 =?utf-8?B?U2lzMEJETkNVUU5GcGJRdERKWnhHTjdFcHN2L2lzR0pMbU95dzN3RjJGSk03?=
 =?utf-8?B?MlZqUzVoTHpyZlFPSW5najBKMEFoVmFkZzdIK1RLSllFMldrbzF3S3hmMTVJ?=
 =?utf-8?B?SmhZWlloM2V4clhENmtiWCtFVEtHK2ZDb29kSFFHT1hpazVIYmFxTWtCN2hF?=
 =?utf-8?Q?pZnBQmMH+FZhWGBdm8JaD1ibx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/diZNJxsj1KmgKqX3KQroYWZXXo1pthlzCkJADCtVONui2pusHQSpDieon+7T4DAkOpCB02I/UaRfHphz9BDMd1o8u2WsKIHxCcdOY/Iq83cH8EE3N+kZhoN05NQBwYlg9x7qP19CKXanmONuQHulUTftG+L4805+MIKb1NKCoaUqG38/EDBQdbnmVlaqQNOqHMjYtwpZEzYpXns53rLukMyMo5+601coTcbvFHQKI+HJNy4WmI4u1W6n4jb+8tg1qeN5vd84MslFhhkPXoO2cueoVnv9W+4d+NMkJMa2R/qNzruE1hV4xsMx2TauyVLpENIuA15fUNjOTx0EMMijjrUAcSw7aA1xm4Zv8siZB6yA09D8mijYdXwexPfdnYs5soY7wr+dJs+UDOG1uwZ4+BPlEQj3BqmRzZWIJqsU56ZE1g47h3Zfl2fIgvUutrZkoi+uJ4tOYMMgnjSq0aGVLKpwPhYEYNzRKUSf7JvnXxBDqYtjQLx6kZve2ea+ycr3gWCIU9c36w5plNsFIddIy4VaJILt5ZDyVciF65G+n4wriIon4SFc1JvnEE5ZDbQ67fhtin7ajmIqfGLyHHUyed5gUjSUU2YcvxueGhd4Fk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ad0807-29ce-42a7-b88d-08dcbade13e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 14:50:16.1162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VU7yw0VENPEOyDZKhTa/EoCa1S8xbsObRg5SWGNyo7Vf5aB9FWdj9Xi1NmSlCNjD2PRRVg3hV4Hz1bsvNUVi7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_04,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=944 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408120110
X-Proofpoint-GUID: FmFoRGAlnQgbEC8NH3xbrMrefa9SLba8
X-Proofpoint-ORIG-GUID: FmFoRGAlnQgbEC8NH3xbrMrefa9SLba8

On 08/08/2024 18:12, John Garry wrote:

Update for anyone interested:

xfsprogs 5.3.0 does not have this issue for v6.11-rc. xfsprogs 5.15.0 
and later does.

For xfsprogs on my modestly recent baseline, mkfs.xfs is getting stuck 
in prepare_devices() -> libxfs_log_clear() -> libxfs_device_zero() -> 
libxfs_device_zero() -> platform_zero_range() -> 
fallocate(start=2198746472448 len=2136997888), and this never returns 
AFAICS. With v6.10 kernel, that fallocate with same args returns promptly.

That code path is just not in xfsprogs 5.3.0

> After upgrading from v6.10 to v6.11-rc1/2, I am seeing a hang when 
> attempting to format a software raid0 array:
> 
> $sudo mkfs.xfs -f -K  /dev/md127
> meta-data=/dev/md127             isize=512    agcount=32, 
> agsize=33550272 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>           =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=1073608704, imaxpct=5
>           =                       sunit=64     swidth=256 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ^C^C^C^C
> 
> 
> I'm using mkfs.xfs -K to avoid discard-related lock-up issues which I 
> have seen reported when googling - maybe this is just another similar 
> issue.
> 
> The kernel lockup callstack is at the bottom.
> 
> Some array details:
> $sudo mdadm --detail /dev/md127
> /dev/md127:
>             Version : 1.2
>       Creation Time : Thu Aug  8 13:23:59 2024
>          Raid Level : raid0
>          Array Size : 4294438912 (4.00 TiB 4.40 TB)
>        Raid Devices : 4
>       Total Devices : 4
>         Persistence : Superblock is persistent
> 
>         Update Time : Thu Aug  8 13:23:59 2024
>               State : clean
>      Active Devices : 4
>     Working Devices : 4
>      Failed Devices : 0
>       Spare Devices : 0
> 
>              Layout : -unknown-
>          Chunk Size : 256K
> 
> Consistency Policy : none
> 
>                Name : 0
>                UUID : 3490e53f:36d0131b:7c7eb913:0fd62deb
>              Events : 0
> 
>      Number   Major   Minor   RaidDevice State
>         0       8       16        0      active sync   /dev/sdb
>         1       8       64        1      active sync   /dev/sde
>         2       8       48        2      active sync   /dev/sdd
>         3       8       80        3      active sync   /dev/sdf
> 
> 
> 
> $lsblk
> NAME               MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
> sda                  8:0    0 46.6G  0 disk
> ├─sda1               8:1    0  100M  0 part  /boot/efi
> ├─sda2               8:2    0    1G  0 part  /boot
> └─sda3               8:3    0 45.5G  0 part
>    ├─ocivolume-root 252:0    0 35.5G  0 lvm   /
>    └─ocivolume-oled 252:1    0   10G  0 lvm   /var/oled
> sdb                  8:16   0    1T  0 disk
> └─md127              9:127  0    4T  0 raid0
> sdc                  8:32   0    1T  0 disk
> sdd                  8:48   0    1T  0 disk
> └─md127              9:127  0    4T  0 raid0
> sde                  8:64   0    1T  0 disk
> └─md127              9:127  0    4T  0 raid0
> sdf                  8:80   0    1T  0 disk
> └─md127              9:127  0    4T  0 raid0
> 
> I'll start to look deeper, but any suggestions on the problem are welcome.
> 
> Thanks,
> John
> 
> 
> ort_iscsi aesni_intel crypto_simd cryptd
> [  396.110305] CPU: 0 UID: 0 PID: 321 Comm: kworker/0:1H Not tainted 
> 6.11.0-rc1-g8400291e289e #11
> [  396.111020] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 1.5.1 06/16/2021
> [  396.111695] Workqueue: kblockd blk_mq_run_work_fn
> [  396.112114] RIP: 0010:bio_endio+0xa0/0x1b0
> [  396.112455] Code: 96 9a 02 00 48 8b 43 08 48 85 c0 74 09 0f b7 53 14 
> f6 c2 80 75 3b 48 8b 43 38 48 3d e0 a3 3c b2 75 44 0f b6 43 19 48 8b 6b 
> 40 <84> c0 74 09 80 7d 19 00 75 03 88 45 19 48 89 df 48 89 eb e8 58 fe
> [  396.113962] RSP: 0018:ffffa3fec19fbc38 EFLAGS: 00000246
> [  396.114392] RAX: 0000000000000001 RBX: ffff97a284c3e600 RCX: 
> 00000000002a0001
> [  396.114974] RDX: 0000000000000000 RSI: ffffcfb0f1130f80 RDI: 
> 0000000000020000
> [  396.115546] RBP: ffff97a284c41bc0 R08: ffff97a284c3e3c0 R09: 
> 00000000002a0001
> [  396.116185] R10: 0000000000000000 R11: 0000000000000000 R12: 
> ffff9798216ed000
> [  396.116766] R13: ffff97975bf071c0 R14: ffff979751be4798 R15: 
> 0000000000009000
> [  396.117393] FS:  0000000000000000(0000) GS:ffff97b5ff600000(0000) 
> knlGS:0000000000000000
> [  396.118122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  396.118709] CR2: 00007f2477a45f68 CR3: 0000000107998005 CR4: 
> 0000000000770ef0
> [  396.119398] PKRU: 55555554
> [  396.119627] Call Trace:
> [  396.119905]  <IRQ>
> [  396.120078]  ? watchdog_timer_fn+0x1e2/0x260
> [  396.120457]  ? __pfx_watchdog_timer_fn+0x10/0x10
> [  396.120900]  ? __hrtimer_run_queues+0x10c/0x270
> [  396.121276]  ? hrtimer_interrupt+0x109/0x250
> [  396.121663]  ? __sysvec_apic_timer_interrupt+0x55/0x120
> [  396.122197]  ? sysvec_apic_timer_interrupt+0x6c/0x90
> [  396.122640]  </IRQ>
> [  396.122815]  <TASK>
> [  396.123009]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  396.123473]  ? bio_endio+0xa0/0x1b0
> [  396.123794]  ? bio_endio+0xb8/0x1b0
> [  396.124082]  md_end_clone_io+0x42/0xa0
> [  396.124406]  blk_update_request+0x128/0x490
> [  396.124745]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  396.125554]  ? scsi_dec_host_busy+0x14/0x90
> [  396.126290]  blk_mq_end_request+0x22/0x2e0
> [  396.126965]  blk_mq_dispatch_rq_list+0x2b6/0x730
> [  396.127660]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  396.128386]  __blk_mq_sched_dispatch_requests+0x442/0x640
> [  396.129152]  blk_mq_sched_dispatch_requests+0x2a/0x60
> [  396.130005]  blk_mq_run_work_fn+0x67/0x80
> [  396.130697]  process_scheduled_works+0xa6/0x3e0
> [  396.131413]  worker_thread+0x117/0x260
> [  396.132051]  ? __pfx_worker_thread+0x10/0x10
> [  396.132697]  kthread+0xd2/0x100
> [  396.133288]  ? __pfx_kthread+0x10/0x10
> [  396.133977]  ret_from_fork+0x34/0x40
> [  396.134613]  ? __pfx_kthread+0x10/0x10
> [  396.135207]  ret_from_fork_asm+0x1a/0x30
> [  396.135863]  </TASK>
> 

