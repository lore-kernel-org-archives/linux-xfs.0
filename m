Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A412D9EF1
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 12:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162555; cv=fail; b=QaOOUbqfOymYWQJ0et3o5ZKlvBooJ5ZaP0x/na500AwbgkXPtXI9dibsxUxItbl+n2TNHknnWEoeKaIfO4cA9u8mCYsQb8UTWEl47ABpR0dZrwbv4HIpCLvIMzJ+JsYUhjPew8ihQv3tpzQDa1Xhy0lIVV1YAssBc1GrtLJf98U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162555; c=relaxed/simple;
	bh=AmOIH1nisjlCpxoWiYg9inZo46LPO7TQ73PPLNaj3nw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KGDbU7cxIHsHEpOGS+viaRSjbEKHtYJ5VAKcUPxhHpA6Fz0bE8LnA8auqHeLcByJ//y9YyldOKc06VGW599J7JwfPUGsr/VsRnfyv2f0hkk2y01ufJKX+jSOmwuLtIVFr5tHp+3alm0/uHBjYBUhwiHQQa/zUhE4HRy17QKjVJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VMLlf0ck; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RXgB0nTD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VMLlf0ck";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RXgB0nTD"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8tZhv023883;
	Tue, 17 Jun 2025 12:15:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7SJ4XTxzG6x61azu6jxLkI79pcfpUTvsWIYSIWWkbWk=; b=
	VMLlf0ckNSIZibWXWyaetzyawTJYqgmPsx1TYDuc8MDh/Y/0hpSFcdotI/lufJ6f
	XkNVU+mrdY1PV8A8E22kvqA1sh2XpcxbMVOBdH2U03FNZSGCEoH+mdm9Ie/jI1bj
	u0AnWefIt7Sd/oqBmuUJlTKh0XTPMszkeYaA/p8SgikKebIzD58xsEg7Tn7U5+/B
	pNGxSe+5/t4oAw8V5grxltkXjnjDeqVEkHAIiC2yM0BcWwrLx6h7jV1Vpimeg1eA
	I6GfGCV/qXie2QbkYmdWd8hwEX26i6hL6Kevdrz6hO7QNqc9Hw7xQEonx6AZzV0u
	ELQk90bcPTDoVCtj/20HMw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yv553c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:15:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55HApMjI031022;
	Tue, 17 Jun 2025 12:15:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh8wd64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:15:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EnUqMtzbOsPBoD6BDg5YIf8fsJ8GMCQ7nt4nGmW6Uh2rIxc9bXA40la2zAmQ7vABVef36/zsDJ8J5lKLQaP9RdebSy7iIcunYXGtsbZoovR347OsV4ueTR9BHD2o/rBq9sAq391issUWYvWu+He6wZ5BlvG9y0JBpQBCocxxwIC2IX3GKEdJm2kI5JVZJHuG3LoCUzjFPkeRA2HYjCd2xmjTho+tkHGudLcje0kFUg31DmZt1PEksNu9MsxBeRXIB05t2VZmYXNJjchBhBW5bUQ0p/yPW9Kngrh2XWcXFn62YoY9e+wcn1Ftf6IyiQ1huuwguBbrGGASBWUG62WvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SJ4XTxzG6x61azu6jxLkI79pcfpUTvsWIYSIWWkbWk=;
 b=VkU0rInDs5Zf08vufVLiLIzOLBHuR4IWEiMGVlqe7lnyzGE8x2HdjYaGXnuKXI3kjGGjXQCMefIHFPJZrMmTvD1a2sikTlU6eGYbnASqZ54Bq8i18PWh9MaPz4FHoq0GxK/emkIcEzsIwN8fRO50mWQ3GhunRhkVB5/xxvtJu9G2AxOPrg+9/8+uJUdaoPO8K/2yHXdvtNi1EOWqiBYQms7jTygEjshMBMieeMduh//7pfH84/CuauAgdXbdxDwTVPFmIEI/ShRjiO82gK3SsOu1uRsAyRh8++SFmgTnSGk7bsSCEk9IF8M50LvSyQ9QjZa6sa5o4vdpUBBd9SlJ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SJ4XTxzG6x61azu6jxLkI79pcfpUTvsWIYSIWWkbWk=;
 b=RXgB0nTDC3MwjvHMdszC3mqTZ1tPfy6MM+qtbyFoo776CxHFTxTy9qrbR/iuIuxy6cTD3M7oTSc7axB0xeBdRDqD30i1I4EPJkq57u0k86CY5Hr68QuLyBtU+gHElN7xV4p9wlEr50UBvnoLHjY53wXlODk/eNIDfIHesSmXd64=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4302.namprd10.prod.outlook.com (2603:10b6:208:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 17 Jun
 2025 12:15:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 12:15:44 +0000
Message-ID: <ca7663ee-f6a7-412a-96b6-605e9e0e967d@oracle.com>
Date: Tue, 17 Jun 2025 13:15:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-8-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250617105238.3393499-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0138.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d2bf7f-f640-46d4-6d37-08ddad98ae83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk1UaGtyT1ltb3FCdEtncHdOM09heTFrV3JhU1Z3TG1nRW01cUlacENPOXph?=
 =?utf-8?B?ZGo3NlZTZFlJQjJza3lmMVdiT0NRci9YMUxCVEEwRm5DUDl5Q3R2NDV4ZHdJ?=
 =?utf-8?B?bTF2MHFVdWswdDMxTDJjQk5DUWxuKzVFRDkvZjRiRVlsZEcrRHkxZmwrY2RF?=
 =?utf-8?B?V2VDSm56QmtQdmM2N2JhbUtTT3F2c01sZHJOT3I1ZVNCVnlCZ1lvUTZtL3A3?=
 =?utf-8?B?anhPM0x3QW9URTVVUTBURTVsY3JmRE96Y0NxOVV2bWhXYUZFUHJLemZNLy81?=
 =?utf-8?B?RC9LSy8wdkhpTG9JUGtLY2FxYzRTNThKK1J1OHNlQU9wb21lVmZlWVFwL0hZ?=
 =?utf-8?B?cHF0MHJabkdneDN4UjIvS210eVJ1VCt4cm5ydU9nMGJub09oN3dDR25SZ2sy?=
 =?utf-8?B?Mk00T2ZOYlJZNFpQZHM4VElpbXJjR3gyZGw0NEdTNVpFTFExOE5yaEYxbElJ?=
 =?utf-8?B?WlRHdDFiS1RqU3dIeEpjV0ZkQmRFMFlqV2JMQkIyeUxZTFVrM2VWY3B6cXFQ?=
 =?utf-8?B?UzhxdlhjR2ZSQnpWK1h0SzdhMHdYMm9BdC9NcVZnMFNueW1LYy9hL2xlbC93?=
 =?utf-8?B?TTVSaVRJaXRnemtaVWdIMjJzYW5TY3IvcXpUMEQ2M2Ezc3RmeFVoREpoL3ox?=
 =?utf-8?B?V2JTd0E4UWpPOXNXOWIydGJudkpsNjVUWjk1eHFmTU1EQXRXa1BENmFxS25G?=
 =?utf-8?B?djZOZHdlbktieTcySGYwWTdHYXp3bUxmOGt0RkI4UVRmWVlkbXgxZ0pGK2Vm?=
 =?utf-8?B?MHEyckp4WXJlYlVIUHh6TU5yVXBNTmVxUHd5eHJUQmpaSWlFbXhCWlM0dDJS?=
 =?utf-8?B?aTdYdjludm03a2VXZFF3dmg4ZDVhZU4zMTFScjl0alJKazUxYnBqVktqcWFX?=
 =?utf-8?B?dWo3aVNtUmhjMVR3WjhTVUVEVjRnYmY1THBFSWI2NHNoN1hjaFlXczNKUkdI?=
 =?utf-8?B?UzdqSWRIWW5yOWVacVlCQmF3VTB4ekI1aS9RMUo2Z3BFZUNxVjByZWlSYlpY?=
 =?utf-8?B?S05qSDBFeUpjeVh3L0FTWXVBV2doRHI5Uk1CdWhWQTVtNWZUbXdyYktJd2pR?=
 =?utf-8?B?b3JadWtZa1I4RkdvV3Ztd2ZLVFU1K3M3dHFaY3V1UUROV09GTmU3QjR2SEN3?=
 =?utf-8?B?Vld5bGRFNytkRTN3d0lTcys3TEs2N3NiR0YyYy9BM1VaT09Ob05xRjlWNkZO?=
 =?utf-8?B?Z2RuZWIvQ2E4V0hSVWh3OXlIZW0yOHg3Nmhoc1ZiMlkwaGUwRk45eTA5cmtw?=
 =?utf-8?B?aklyTGxDeTRNSXIzeWVRZzZ5Y2tVZklUekxMbmM4dWsrbnU5M2wxZkh1SFpY?=
 =?utf-8?B?cWVta0pFSWlNbGhXWm81K2l1NFgybzh3a3VTdCt3ejdmckI1UnRXWmNHcUxZ?=
 =?utf-8?B?OG01V3luVkVlOGtaODg2TXlPK3VlNHpieGlENlJ1cXo2eUJMYWxhVDBKNDF3?=
 =?utf-8?B?SWJ4eHUrVC9MUTlSTVJ4SDdGR1h2dzAzckg0NndWRE5mSWxpcDBrVU1CL3hE?=
 =?utf-8?B?a1FkMWEwNWZCQmIrMXdlMXZ4OVhsQUJTUDFIL1I0RjIwTS90WG5QR3pma0dp?=
 =?utf-8?B?bUZhelV2R0EyZDg3ZUo2SVJPOExyUjBMcWZVTXpIeGJxMmFBbWRucEVvV1Va?=
 =?utf-8?B?dnJLY0FRSjIvcU4yWnhDcWtyUjhxNEJubjJGTVp2MW1zSXk4OWdNSFNnUEV1?=
 =?utf-8?B?T3ZpYWhWdkh1NllsVGZ0b1VQcmxENE9ZOXhIYjQvUHdGR3F5cU9QZlRIbHNK?=
 =?utf-8?B?Rit3QWIwRjFZank2c0pwZlNYWEY5WmVHYlRWSEdQZWJ4MTNoTWZaeC9Ob1B0?=
 =?utf-8?B?N2dPZDg3Y01sTXpITDBaS2Q5ZmlzVDJTaVVkOVJocGdVUGZKbThIRm1FVFVr?=
 =?utf-8?B?bzBkWG5OeklSc0xhTVcyZW9FSUJyazltOXFTZFJLZzdQZC9aSGRHTXYvcHlx?=
 =?utf-8?Q?JJBLlST5YO8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFNrbit5K20xYWVLY3pZNGlzU0pvSzcyVUREYXRuVVpJMGtDc1lWMjA5UXl4?=
 =?utf-8?B?cDBZWVZ3a0lPcDZZdEFHS2t6d1kyZFlLb3JHcUw0WWsxNytpV05CSGtLeC93?=
 =?utf-8?B?aFZNUVU1RlNIWWJPWTBSVSt1Zmt5cTlCN0duMzBuYmRxc1Y5WC9kMkxEUEV5?=
 =?utf-8?B?ODBUSXBoWjZDYUhsemQzdGtNRFJxVVl2L2pkN2x3UDRkUnpxNkFFZEVoNzdu?=
 =?utf-8?B?QTlLakw3WlJWRDZkT3V3UThhaDIzOTAyMEZDOVhzdnpiRmk0Sm5XZGdTNWox?=
 =?utf-8?B?em9iOForT2dFaFNoSU1IaVhWR3dzNDJRTTFXYlVvZjNyZVFuWlRjU1hVdkF0?=
 =?utf-8?B?aG5UK3pqUFVUM0RwSjBORC9ERHdQTmQ4WGttKzlqU2dCUXJhSkZEclVXdDg3?=
 =?utf-8?B?TTFiZG9lRHZ5UVRUM0svMnBPWlIwT2lXenB4ZGhZVlVGT1l1TEQ5SDdSeUlx?=
 =?utf-8?B?ZmRkRWs3MWp1VUFSci9oek8rc0l3NkFrRGVUZWZTRWxxQUM1U0E4UTJVOE54?=
 =?utf-8?B?OC9UNUpreTVzRXpMQWZoZ2lvZXdaWUo5Mm4zcjdtTElYT2JNc2daaDZGYTNv?=
 =?utf-8?B?eG9YVzdqNGhwWjJyUHNvb1p3SHVVTkNtMHI2VEhhZlJsd0E3NTZLT29WVnpV?=
 =?utf-8?B?WUh3YW9xYmc0TUx5VWZVdzBFdU9qZjBQVkFIbWphS2kzeTlrMXNuSlJZMXE3?=
 =?utf-8?B?bnJmZXVaVE1KU2dJQVVwS1VTZEVuUlR3OFRwZm1QQy9vb3JERzVnZ3U0WVpq?=
 =?utf-8?B?RUh1Qk9Dd0pHVVkzV0JyTlFNTnlQb3ZLdytZdm9JOUlrQmpLWEJCSlQ1ZUN3?=
 =?utf-8?B?KytkZDFhTTVQVmsyZ0w2SmUvcG1TaXJCN2xhLy9FSFhSY1d5TCtsOC91MVBH?=
 =?utf-8?B?NExVRTEwcUEyWjBCSmpUVUNuRmxYMHdQUDFxSkYzbGJDVzlDZnoyQ1dObVVq?=
 =?utf-8?B?c1FNWGdjbi8vRnV3dXZoRXZUTDlkd1M0YXFyOHNmYWUwTUpQcmJnb0tsbzlQ?=
 =?utf-8?B?bmc1ZjNFOWtRNGZuWE5TbDN5Wndvd1hPREFYRGhmK2JXeG1zN0pWQ2I5K1RU?=
 =?utf-8?B?d2NhcnhxbzRLWHZYRFNnSHZJSndjYlk0ZTY1RmxRbzU2TW8rcGUwdWdUeXNp?=
 =?utf-8?B?VElBTVJKdFpmY1hOQjA4bUw3b05lN3lvcURySU9hUC9kNXVocm5hanJ4VmJB?=
 =?utf-8?B?SHdLNVZWYUFpQjg1U1VKU0JsMWhXV2JuejFrZzNnVWw0QXorMitYd3NmNG0v?=
 =?utf-8?B?dWJrTXM2U0tKV1E4cm9QZUdTREtEbUd6bDVEZEMvbkE5T3JiMXVVK0h4bUtm?=
 =?utf-8?B?T0xYQ2Q2OVFOL0cwZXZLNFBmamYyQlNqZVc2VTBGK0Ntdi91TWJEcGNqemsy?=
 =?utf-8?B?VjhBSWFiVUZ0TFByelFvWk04LytXM2YxNE1QcTFPNTRzalJwUlpLbHVkbm0x?=
 =?utf-8?B?d0s3ZklDMmRLUzloSWtCZVdqajhIM2xFL0FYT0Y5YlEwKzU4b1ZnWTJHWTMx?=
 =?utf-8?B?RTYySm1tSStDYTZQMUxDZlV3bndISjBZclYzc0hNazMraGNZcHE5aytOemNU?=
 =?utf-8?B?NVZKQjlhSnA1RzRDMmtvaHdKOFpGS0FQeUg4cmU4cFc5QXZ0RW02a2ltWUFz?=
 =?utf-8?B?TExJd3BSR3VsTGRsSjNWQWFmNUtFODZDS0IvUGMvNU9hUHNGWXBhcU1wNXlW?=
 =?utf-8?B?cDZZT1JIRHROUWt5WCs1TnFyOU9nQ09SdE9ZUHkxSVZEM0ZCOFcySGdpYnVM?=
 =?utf-8?B?TVZCNnlBL2dJaWdZamVpZm0xWkFpQlBmY3N3NVFLLzRaQXRYQjZ0OVJsMnMw?=
 =?utf-8?B?NWZWcE90N3JvaG80cWRCZC96ck43aGpKcjFDanRiN1FRRGtKWUYvYzluRnpX?=
 =?utf-8?B?WkNVQkhKMVA5aVZSc1Z3Uk04cjBXT2J3SEFUMGJkMDVxTXlkcjc5cVA3MEM4?=
 =?utf-8?B?UGNBYkZOd3RJVUkwd09OOS94WEdvUndQeGhITWJrVE1tQjZiUWhmK3g2ZU5C?=
 =?utf-8?B?Z1FEbUJmQ25SVFUrNmcrUHZPZ1lsdWt1OWhac0Zic2tiVzNyblZ2cUZNZU5S?=
 =?utf-8?B?d1cxTjhYQXEzTU1JNi9yRWloOEs0aWdiam9iOWpiZUJaeWFTRHM1RnN1OEh4?=
 =?utf-8?B?Q1lPaWdxdXZncVVIb2lFU3ljYTdKb3dsazhpcE43bHZVSU5uMGRNYlJmbVdS?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0eIEzOh1eMV2zFwwPMXKAb2Fng1sPqPnr7Dgy6HOBS3qMmhQDzsn/xM5U8qD8nk6Kqn3AmLYGi2XYke3gOCD8WjcgJ5aZmLP7hTiXP3zG1ySTFc5V5EE0g4HTvAYk3RGgQoWMLw2gj8QdXz92g2W3Bem7LszQ0s0K60v/fz5cza+UuMRTri4+4ggSoUZP/ZLQ82oPHPDFg1kv6NA8FsmeTxgRjYczdPO6/EYxyV+A90E7n6XdbuiROD6ClaOJbnsujnple1JZZMkw87tKtWnhCmaIZe4MPrSGTuYOfVvn4+uLSCVsDocSywUMCn2CSuTgIwCZurvHyJDO4y9UHfNOaCJihzuHAyf0YQ6ZumyjH2GNG9s7u8dgLjUKWH9aX/n6lqau9lyLbwty0CQhWysRxU3IVdXYQRFZ2Hg/4kTViX/Wd3nVPPMQyUMMfgHmKIptZz7aw1UEFf+JcrCDsQyC4ESl74PB7+fAeTpOgehcTHWW5uFGDhAKAAR8uYCZgAXBBXAjhYxJaghVcv9KPPkwD6rXt8A3OLlvzzY2bIUl9D1X4TxA/Nu2ONO5FB/efa+mMcGoFPKETN7uXqJAI6cg8N+8TcjP+PgkaRvMnmLzo8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d2bf7f-f640-46d4-6d37-08ddad98ae83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 12:15:43.9942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5rsqqsg/Bla2PnHl5o9h1IngqMa9exzwAKbL/DPco1AZBCK7AJ8VWMlcfDhxrZlZm1a3UOBLH0kCbeR7SV3jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506170097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA5NiBTYWx0ZWRfX+xDhuSNGzWN+ btYGtUL3HIks2tYs6j7C4xx1vtqPxqjajT03J9kBRr9NOItAdnlprF2dZHBetYscJwoIN9QLxVL 5VZW0VQu552Qsy5RAB21+Td8anjn/X5HMW+Kgit9MXwAY++AzF5KkW9pNQ4zL6LglPQDFreei8S
 lOHDRLbUnYQ/wqitd0m4aMNhjBIWnOOh/qID/3MNluCEoZTYFJV4HeFehIVXU2nEFZeVUk8aIdp 2lEcsLUzCWY2oNZEhomUuV7OSpUk8JfoDZSBUJqo6bu+UK8gJDPOs7SvQtAG0ypDoKKnvSoAhWV CrwPRI/DiSIXkRfcIn9npcR6lXgQ4OMrSsBQkxqL+A+yri9Amo5su4ej43phseEeDUDBsJsrkBX
 /0RVOuVKN0JbSWMeQxJQqUIa0GYPQa7mymXgLO+qjVPP9ku5BcfKV9RRiPrmeCAk3gjzMSOK
X-Proofpoint-GUID: peBqnzCOS2AZIBKyoW9T9ZKgrFrVxmtx
X-Proofpoint-ORIG-GUID: peBqnzCOS2AZIBKyoW9T9ZKgrFrVxmtx
X-Authority-Analysis: v=2.4 cv=W9c4VQWk c=1 sm=1 tr=0 ts=68515c73 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=DcApo9xH9RCj_5p9h8cA:9 a=QEXdDO2ut3YA:10

On 17/06/2025 11:52, Christoph Hellwig wrote:
>   xfs_configure_buftarg(
> -	struct xfs_buftarg	*btp,
> -	unsigned int		sectorsize)
> +	struct xfs_buftarg	*btp)
>   {

This is now just really a wrapper for calling 
xfs_configure_buftarg_atomic_write() - is that ok?
