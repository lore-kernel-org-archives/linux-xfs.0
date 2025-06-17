Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2040C2DE1E1
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162912; cv=fail; b=EYGROyazUcq1Dy6NViMO6Ui/gV0zBrqvIfBpoMnkCHFiaylBgDZo+1tJTk1go3Qe2vTnb407AiwQ/W4KCy+MkAvWPLfIgqgkYf5TAjdSq46KlgmZhyaXy6CLumeATWjFT11WExatc8flBRi1vKoX/XNiYarNvBOWZwvFS0NUJi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162912; c=relaxed/simple;
	bh=BzhcmIqf8/JazoCElLH5zuFjcbFxS6+HFj2Zi+YoGzo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kNSU2VP1HRaCIuPXiXdPDPGiYx7L43rq7pjE2D5UYHnCmiaClbeXN1z1pV0gNk5R1dZTFi8yIVQ8fSX2uDbUl4GhrWXDQ3VWObRzQFda2O6Pf2OJe4IYT8HrzfROD+ZWQeIqK+uUWtGRRYAeIPkUSI1Le/vsAvJExypK7oaBQO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OGmszJz8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GkIeAxld; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OGmszJz8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GkIeAxld"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H8tZQN026743;
	Tue, 17 Jun 2025 12:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UKvPVhmFn74xaaCqiGrdUyafMcjjnylzjqujaV97NzQ=; b=
	OGmszJz8MjcyZohR6VOYAO4J42a+s/9pDT4NoWs+KkCHSBpcsk0XdTGlQJdzZC/c
	hv0zjlyrZeVZ/OGDGmsEK7ZoSzfEsM355VbfIjqfi4dfWVzjM8hleRz5UpFCGlU4
	aA3byLx2xMcgKXFJrA/knF9A3U6t9uLTePxpVR9WgZ0ZK+WBToqB6GvtSFU/dfGU
	Qf01OSTaHzieCuysR6yCNRMo7sjMDsJsXoq6dtKFWHu3EVmps3sW2dH9B7uHzf+q
	F8Kf6WIATT6Zmnbn+tdctJ0kZaSfCzzGwM4qTSXIb3Lm7KO39JgmeVrfuZoWGnQw
	1iStXhoDRZBIn9U+OX7Z6g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914en486-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:21:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55HAKodo026854;
	Tue, 17 Jun 2025 12:21:43 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhfdxek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 12:21:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QVrH9YCzsunobH3JrbFHEUrvJkHzpIoA23iN0nwiZY8v5damrBemlNpDFYXp0/8oXJHZV2kR9yexSkVyjFlcY2YJEgn/roL6mnT3jwoCa2aziaKa8Npbf6uyXYOPTchxgX04Ptb2L3HPItcZHDB0eoso4OK+UCDxwX7jIASDr0e4fEjMmrvRTP1gSWrvo0pIcLFoTYRCkRjeg3C0/z9aRdibMd1fdgASAxfhKg2KjBq6EgsA5J1/lYW2gem5r6A2gUAyk4OLzy8smLOIrbBr6H56+tHpkYaINa5hQsfvV0bJOKBnGCmS3a52e8VKB3HfkWPnzwqFCL3cydX9xLkvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKvPVhmFn74xaaCqiGrdUyafMcjjnylzjqujaV97NzQ=;
 b=P+7DRcD8UHolomp0dJkLfM3DhSYPcsUirNsrWgE0cED8CUZLcVCOZQnm9JX7xHv0UJ853yVGE361oAjddIur3YITSWvvX88LXeQ9Fc8c2dXAtmBLhJE/ev0L3H3gwVmjIALvqr+TnLembNN1cxie2yIo/+HYFWGykmT2TD9w8JvO80xbvgvpDJ4XEO/M63H3j+6ASCSIs2IZI1Vi7qggKYpqyoOViD48IrRccAOgiqrlDguSPGZmG2EvIc8ZJlT+YPJru8PdEio3HzHv88ovoNf6TM3mliQMUDusneMwRMeyPd5Ixh/j/VRWQn048S5ZohXtGFyZl5pV6CqR2t/BFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKvPVhmFn74xaaCqiGrdUyafMcjjnylzjqujaV97NzQ=;
 b=GkIeAxldd7gWs6xdEBB8o7mMfioq03lG5Mfk123luDpV0SYmK5wQAaquRR+Wmj4UfFVVuQKPSk52AJaGpdTlFSbYDndPZDAQecKcmMkGrPn1psu9/gr6I7wvn110JlbeOioqhzuAN6xW8b500We6lBiNPLAIlgLWk22nkZqT/FU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7780.namprd10.prod.outlook.com (2603:10b6:610:1b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Tue, 17 Jun
 2025 12:21:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 12:21:41 +0000
Message-ID: <fde4bac6-c8ec-4e6c-881e-abf7bde406ff@oracle.com>
Date: Tue, 17 Jun 2025 13:21:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
From: John Garry <john.g.garry@oracle.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-8-hch@lst.de>
 <ca7663ee-f6a7-412a-96b6-605e9e0e967d@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <ca7663ee-f6a7-412a-96b6-605e9e0e967d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1b18e7-e51e-4b65-622f-08ddad9983aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTluVmRyY3RYUER3Ym44MkJYU1pVWWpLd0NYK3hWb0s5aFlYY2RabUFlNHlx?=
 =?utf-8?B?UFpiOW1XaEs2N29XN3JHaG96WHVOUkRhM1RRcWdxbnBnYW5Ia1FwR2VWOTBR?=
 =?utf-8?B?OUU1bXIrQ0VwRkN1Rm9vcTliUXBacnIyQnhkS3B2c01TbUEyQSt6RVBkWGRP?=
 =?utf-8?B?TzFQd3dvNGN3aDNoNzNFNmZ2SGtnd2RUZ2VwRnNKVEFBK3lHNVJWSWg2ZkZs?=
 =?utf-8?B?TDVqUmtuZW1YZWhoYm1iZmxEWmhSdW5RYUlmamM5cGVVeVF3Nzk2R2lKK1JW?=
 =?utf-8?B?eHZGMGc4eW1EZkJKZFpyU0tkYlBFTEJtSUwxUitONjlvK1d6YjdsN0JrR1FG?=
 =?utf-8?B?RW1OMEhEbjZIcWtoT0NqeG9oYW5lZXZMUXdpZTVjWlpjVHgybmQ5TEJmcTJC?=
 =?utf-8?B?LytzT3piaXNZSnIzTHdPL09aS1hydDgrZEIyYWtCZzB2V3NqektMeWlaeUY4?=
 =?utf-8?B?YXc5bnlaT3NhdzBaazluUnRHZG9rRTRYMjdqMkhmenUxbXV6ZnR2WE5FMi9z?=
 =?utf-8?B?WjZCRERrcEVwUjJsaGhYUzZrWmROekRrK0NFUHh5QzRTaUFVR0MvUHQ5bDh1?=
 =?utf-8?B?Q0lma2ZsaHpJZjl5enBTSzZtZk0wL2xsU2JuTWJrdTU3alBHTmtSOU1nbEZD?=
 =?utf-8?B?a2g5djhXTlltVVNuejNub2dzZDdWdlJGZXQrV3RINTFLNzU4WitrS295czBY?=
 =?utf-8?B?bzNZT0FpU3ltd3dqQ2RjWGNoUU5hTVRSWEFRbUxpaDlsaFdmS093czJjUjFN?=
 =?utf-8?B?Zk1pUjVDVjJ3Snp4cmY4YVlnTTVaaGo4UUpFblE3THR6aUliaXlCOGVxSmIx?=
 =?utf-8?B?MnNPaWROaUxEVTIrUDZySXdrc0pKcHo2OCtLUFVtRDdzalo3aCsyeXlnRXJS?=
 =?utf-8?B?S2Z5QVBZM0hUTGM3MWRqcUZoZVQ4TXN3NGdyZjNLMEZ0NTNSeVZ2M01xcFNk?=
 =?utf-8?B?L0N1d1pFRXkxVXN0c3FrTTV3UmpTYXRjeFFjUzB2UzRKa2E4blBjN0N2TWpW?=
 =?utf-8?B?cEMxZW9Ub2gwS0x6N1pkVVVGaHZ6ZmNIRzhnWEwzWndTbExreTZnUGtEUHRv?=
 =?utf-8?B?OTJNQm4zcFJpSXVWNzhiTit0VUFGTHVucDB0NHFLVW1QSk9ub0RXMVhFVVV3?=
 =?utf-8?B?aFlXUThqWkpJUDVJWjNNd2Q5M0JwNm5Ud2pDQkhrdXU1L0JKcGJ5dSs4eWh5?=
 =?utf-8?B?a1c2VEM3cEVKeWk2b0k5YzUzYVZXTURZODZVWjd0RnNTQlJnZGN1RGNpSHli?=
 =?utf-8?B?cm1pb0F3RlpHQnZlNTlVLys3VUJwVW1SYUlUcWY3NXB2cnlaU1d2Q2hod3po?=
 =?utf-8?B?Tk5CZVZDbEtZYThDeGxIMHovcVNFSnV1d3FBZWNQczkvL0VyZ2ZxbEZWcThy?=
 =?utf-8?B?S2pBT1h0a0ozVE1zMUY1aTVFam5OYVZaS1RsNUh6MEJKbHJXY1MrdlU2TVRV?=
 =?utf-8?B?QitSRks2TVZYb0g5ZTlrak5KSUw3SGpJalNaY0xLaDNXV3R3NmpNdXRHNE56?=
 =?utf-8?B?ZFVKeUpRMEVhd0w3M0pyR3ZuNXpmZGZOMmZFTmhYQTNDZVVvL2E3dTdmVGx5?=
 =?utf-8?B?akg0eVNOZDNwNkRPaGhXVWVENjYxd0FncEF3TFFjZ01GOU9OT09YZnp5RTVF?=
 =?utf-8?B?WFhtbGY2UGhJc0R5dlh3TVdWNWhhbGF3M3U3MHZSbStBYnpTeEExT1NPeVJ3?=
 =?utf-8?B?Qk5nS1AyY1MydElmL1hBQ2lhNEhIZFVtVFNTOEtOOUg5UkFHTG4xVGJFVklz?=
 =?utf-8?B?blFzNG1vSnJnRlRxaHZ6d3B3TWNVeVlVWWYyaVdLQVBsckhOTEs2c3QyWFF0?=
 =?utf-8?B?dUQ0UVcwbHVwZjc4Tkg1a203a1RFNmpRMm9mS0lESk9sc3NSTW1rWkdyZjRJ?=
 =?utf-8?B?YytjYnlSYk1NYzhtZWY4NkMwZ3RvbXYzdEkvTndLUVI4ak1aQVRWSW1GRjIy?=
 =?utf-8?Q?V/Q2DW1rxgU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDlHUUhWWlpHbGtERXB0RER0MHJVM1RoTVk0ZHVNZXJGcCt1UjJ3U1lSMGZR?=
 =?utf-8?B?RHJvcE9TQ1M0bXBuOXhiMFJkeWtPbE04dWtiMlVlc2x5VzkxS0xsVjkvUkxK?=
 =?utf-8?B?eFFJTGhuUkV3VG05c1NkMHdrMTFLS3JhZmFCbDdmSFhSNWVEb2RPdG1UcWRq?=
 =?utf-8?B?dUxscWUzT2loK1AxTm9ZWktjVStrc0tBNGtMVVZBUS9jbVRCSmExYWUrNC9I?=
 =?utf-8?B?aG1OV1A0SVRReHJYd1krS0V2b3o1QjRJV09BVW16TmZJNVBFbXJKdVhzWjd3?=
 =?utf-8?B?K1ZBZGRUT2o5cVU2ZzZJVno3RjZlZ2RNakF2U2t1aHp2RlV0RktSVnJUWE91?=
 =?utf-8?B?MHBYWmlsckthYjZzeCtiaGFQQTJTeUQ1dllZZ0lwcURTakZ2UENXMDFISmZS?=
 =?utf-8?B?UVJtVFJzSmZqTEZTQkx0bjdEdFM0VVRqVnBLbkNObjlWOG9JNmtCTjQxbUVC?=
 =?utf-8?B?MGl1TFU5REtMaWUxeE9xb2tRL05aV1dWN2NsOTVCZ2tnbmNSTGovZ3d1WFRx?=
 =?utf-8?B?d2d5NkN2eWdpUGtjTEdhR0lTVVExdllJcmZHQ2pMMStnUG5OZmdSUEh0THgy?=
 =?utf-8?B?U0VrNFR1TXh6VWRWNERLdDk0ai8wSUk1MXcvYktDZGdsUnpMUThYM0RMQWNR?=
 =?utf-8?B?MEN1SW00cGcvVU5RdWlEakg3ZitiTUNLelQ3MWkvMDg0c2hPZUNaV01rVWlr?=
 =?utf-8?B?NXEzY2hJODgvTjhkWG9POWFIa0haWG5JNXdRUUZHYk5wTXgwRU01NzA4OHI3?=
 =?utf-8?B?M2cvT09mNFYwYmxYeU5ia1FwTXE1b1FVM3huOGE0SFBoTG9HQmxuZHg5STJB?=
 =?utf-8?B?cUtnclR0WXpTS1dqUmtzemlhdDFvajBJS2tlV0RKUEt3eHVtUWJTWDR2RzBL?=
 =?utf-8?B?NmZKWkZOa0dmcSszaVhuVjVhTFd5SWFydlMwRkwxNzlDYldoR3RKWElMV1R2?=
 =?utf-8?B?SVRIMHJVRDZIRnpjUzZoZzhLUEp6RkNjZVFpa2FmZXE2RWxrYkE2a252U0lH?=
 =?utf-8?B?SGtPRVlwSzBoWWF3VTd0ZkNXYUNWckZmeDc4MGg4QjhtSENEeE1Wdk9FNXRw?=
 =?utf-8?B?N0t2K0tMMlEvVFgwU2N4SVNMR0piUFBHdEJhK3FkSlJ1RUJyQVVuTnBleks4?=
 =?utf-8?B?NkpoanB5TTBqdHFCYlBYYWt3NlgyNUQ5MWVDWkNkM3JDaGtCRW9vbzFxeVBM?=
 =?utf-8?B?cG4vSkRIdllKeHY2UHZrN0VCQXpqeWlMaXBLNXlPK3lmMGhjeThFWHA0WExE?=
 =?utf-8?B?eGZFdUFSMVpEcWppZTFUWWZzYm92MHU4WjVUUm1uQlhnRGM0MHBFMUZFaktC?=
 =?utf-8?B?MVZqZnRQRFA2bFQxZE0vRTRhN2JzdU1NRkpWMzZqa1dVMHlrdnVKMEp2Yjhq?=
 =?utf-8?B?ZHVvZjdBK3dUY1JJR0FwbkRnU2lGZWZ1SkdLTmx4V2xlZk5zaDBtMVpHUFdV?=
 =?utf-8?B?VGZycE0zeUZjZTdaM1gvR3VQbVVqOUwvREszTGlhSmxVMVphSDRyam0vZmdt?=
 =?utf-8?B?S1oxWldTUXpRTWtNMzVDWHBsMDh3RlVjdE00T0pBTDZvWDR0K0VrbnNpSSt0?=
 =?utf-8?B?L0pQempFeDBXMkRsbmFLZzVjYStLZ253cGM1Y2EyT0J0cVEzWUR6MVNnc2VY?=
 =?utf-8?B?T0VmbSsrWTZFWjIwQkhhLzZTd3BGQncvQy9xeE5RVzNpeldnQ2RSeXpMYloy?=
 =?utf-8?B?ZlR0c0FwYWRzU3ZjdXFjMTNxRzRMMlJwL3hqekdxZ3p4M01uNTc4K3RSODNV?=
 =?utf-8?B?MjlHa2pDNmRna1VkZjR4dGErRDlxNTY5UUErVDRVdTZ6V1hsUTZoM1R1aFEy?=
 =?utf-8?B?SFJGS3ZkaSt3TEh3bEdMeEVuUFpKOXA2bXZwcnNtOWtQUXZwczB4UUVZVjFa?=
 =?utf-8?B?cldGTkhvY0p5b3lGeGorbjFyQW9lYVIwbkdyckE4UGdPV1MyeVFTVkQ0RjlQ?=
 =?utf-8?B?K0NraHJLcmFZR1B4eGlEMWVPNXYzaHJhaVozc3B5RUVQVlBNRHM1bk41Y1V3?=
 =?utf-8?B?Y3ErdDRrRzM3Q00yMTR4MS9LWGN1Q3g1WWtaSjk5NEFObmFCVytFdnJSOGxM?=
 =?utf-8?B?Y0VKTllGR2hDeUloZVEzSHNMSXcwQnhGZ3g4RFJkd1BUejc2bnRVK2VPZ0Rl?=
 =?utf-8?B?MXNQc1N1dTZtYy83Yit2c044SUgzNXVsY3ptZTZCcCtRSlBtSnNvRnlVME9N?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OJKtKy9hQLY6kp74FbmqNRoOknwgHj9xkv7FL3jzHKmOq2/ECQHf3V/YbPxAN4vzOKbG8CjKOgL08IHm9PTA3lhup6qrl50bb1083apn6lywsavhDOcflN29o3BLvOWd4t8E5A6e4YUNVLQL/BTtts91HWwg6g739o998bDiyUlfvtoiQDgLNrNItE2WPwIYcPrwavJyPWmYyWRYIAB3JLaxZoDEh3dqQnMoeGPigyOEqRr1POpZLa72ydJlN1Z2Cs3rdWnWlm1Vm13itm09oEj2/g+p4PC9lB5QnvOKBYF5tetdUhNr6XQYGIbjMOksFXOkxQOUPELPOAXmKTlz7kpHhBr5dmh/IeKwvHOgF0u4FHpVjX9Zz3gXB/QUizF5Rx3lV8h9gJt2qFW54N1JQ9BGYsxprtqlsInHyFUQSLv2+8CV6+nPbPQzujP4WzVGrIB3zoIBO7Sz2VS4wAQ4FvV2ScHRhIzwkBdgsKcLojxadXkoyJLjcgK5u/Ipy9nqmgwzBdKgjVwslZoEZrRo4rKaTtnG5YkdXHObtWbxLLertz8JQ6HWhQ97i43sIJ5yFADusrdaFH/93SNdkqQ870oDtWHm5EFXEUDkwItzrH8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1b18e7-e51e-4b65-622f-08ddad9983aa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 12:21:41.1066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYYXOZeRj4fr+Gc+H4Az7y3qPSF9RLCQK1U39U2uDcut5+U2fpvYjil+vi01l4xwAkUzowFdjHc3TOhxhM5VQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506170098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA5OCBTYWx0ZWRfX+PKR7yUNVz78 CwAG+dcAcyNHraoZ6x6acboadTup6GZjeoBspt3bm74C9XVTf0vXlNsp0wO9Plqpml+9qODk5Yv XNXWwk9KCBRNiTtJqUVWEYHq1jzmw01bTG7A7WCn2N80sx5ovkoYMDC9M5xN2Gm6P0oNiLP9bXv
 iICb1Z/d1JTgDY9owgG2gVBIr9ZGxWn+QZe6+FSWPtf9ll8aUQAgM8wbYagn/oKKhgaY6W9SvJy tv4uru9L0nG5N1oiSGxr4lSdYPg4umYFZ0Vm0jkCJo0RKKNMCFaXaPQ/PA3DI9Nngfdwp+W5xf6 4JFw083IAyw4T4UME9mTo/gn6haRpFUyL79hSpXLYK1Po9pEMneJ8pSURfALhKB2t1G+g7v8J1W
 7PgoGejiKgznpPzstImF9fH5qYWoi/7ogaE/dQ6iybzsxgYEU94RXMSqAUSZMjBHzJLbxo8K
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=68515dd8 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cIeXAiqDQuWc0z7KJ9gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: 5DRoE8EEufEQiG5B3BlPGCCxL00ZB1xV
X-Proofpoint-ORIG-GUID: 5DRoE8EEufEQiG5B3BlPGCCxL00ZB1xV

On 17/06/2025 13:15, John Garry wrote:
> On 17/06/2025 11:52, Christoph Hellwig wrote:
>>   xfs_configure_buftarg(
>> -    struct xfs_buftarg    *btp,
>> -    unsigned int        sectorsize)
>> +    struct xfs_buftarg    *btp)
>>   {
> 
> This is now just really a wrapper for calling 
> xfs_configure_buftarg_atomic_write() - is that ok?

And the bdev_can_atomic_write() call [not shown] is superfluous already, 
as we have that same check in bdev_atomic_write_unit_{min,max}_bytes()
