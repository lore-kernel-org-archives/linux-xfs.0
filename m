Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A462D3229
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 14:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750776408; cv=fail; b=gNC66gec1yKTTKeqOAmSHTpjO3Pc4TZABPb7fxPNLH39G8570IlyogZq5na7R1uL/Pj9mnB3HxtrWBjzo3cfKfkrnElegRGrxcIsAz+/uSHMFbzQXIb6auc17VbODO5GXcruXqpLejO6odY10IeWAaE6o9vGWzKUrSZWt9REIWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750776408; c=relaxed/simple;
	bh=CfBOBPH2xN1q+Oz1Ef5on265Ip2WEuA2E+tZJFnEeSQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eEE2q3Hg3Qn8KSaqV9k5Y27hK7mHgVJ3xuOr0n0aldLalkk2jyLqwvJ1T4VDVMNvWgTOCjIPzCldshdq5VYwY6aWTuV/pyCFGQwj6T5ARreogcCD2v/6TotDz7wzkZUFQgDc345UbtNSjw0gNP4Te65lBx4f0tCsQeiQbZDhL94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dgb4mbea; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d7yZn+0t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dgb4mbea";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d7yZn+0t"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OCiGJG002248;
	Tue, 24 Jun 2025 14:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BA4kcJb1AZx/KwVHWIjimJBKnhwnsmbOKZqbdEFf8eA=; b=
	dgb4mbeaAB2b/1YkwF+d1utJe9hy1JYrc2i4hwsD5hV2BICkeeq3hyUBThRb1o0V
	AFZ2bGEmi9r089TbWdd3XnNdRlJp8AtHOErRoBvUCF7j7ida9muek2fxUSFVDSPj
	etaMNqinS+qhq8cfSENHWRUxIvh3CMLSTTsT67Fjib+LbFMyQtiwR4xY0ia7NPTs
	o5/u7ZxtaC6cpwpNrSrbbl3P2WrXKLtUDtRaO9rr+oK9eHHGhD19zooQ4LuN84VG
	lWc7N5TqxCPiuksI7HgvmkNiVV33ltIHVKhlZP3GWLi4EMTus3d7/j1x86fitNXm
	1zCNlwYuNvbHOgQFQ9ZAYg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds87wb17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 14:46:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55OEYbUo001354;
	Tue, 24 Jun 2025 14:46:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehr4qpn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 14:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HhMg4noii5NogCf4Y1N0nYliQVgltRW/U4LAfNOi8QEvDH5cL0Gb16e537wEzv+EBKOoiA1rE7smWemeAKZXkd9BkBZvK3B91XooFzFK49nMZHNMiVojPIBCJrLpLdEEks7pkX3D+oD09ClvDf/e9k7G6dcbeXNm0NmZc/v3kDTj/wcFi2ppJoZGStDhcfH5Arn1dx/nKneTx5TwOz9OWmU1NktwrGarSDV0X9V9uwfbsOX7tptndt3ajS3ctxftlkmQ+c2LD2YtmXpK80xTYzEZ8Yk1U2W8YllHqqgSd6GzYnXKyOyEcu94yGwTqykiQaVhb24Z5+fIfEyOJ76QfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BA4kcJb1AZx/KwVHWIjimJBKnhwnsmbOKZqbdEFf8eA=;
 b=nninh4fIH4roiRZuoB4YekImem0riUORAe7XlNCws3N8C3hZNc8Ea5o0DxRxL+bROQXO5gR3TvhlK83LRFvXe/8l+IzmExOyCu8POiSdWCRGELt04P+d5DQ4H/JA5Vzh8uBmSOaEgglU676NILHW8Lz9te7XnOFQlhKSJLTIThbcMX90QnWzrhczBAtaWA2ipatBipKuDMi8hQ6b2uJhVb/sFpeLrmFvJ0lSQfhY+3aAd4EhV034MdHLGkjL8IdEZNqTQU9XccmP9gxQGozsW2padrSWvoStCT7p49Udcszw2midZQ9wF8jKN7of19d6SNtLXgB/XHIV6QXYaUbP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BA4kcJb1AZx/KwVHWIjimJBKnhwnsmbOKZqbdEFf8eA=;
 b=d7yZn+0tV4iHrIS/mppxKCiaAtvqU86kzWp4lKR83XkBZZ+r8zTHMQlnR1q3eCzeazjxnHjVB7dcPuroRXbUksJIdlof8634LPr03mkMfiz5vuZnArVkIIAKIyf4BTQLzXfARehyWYoApkPRgLpjULFGKCoyq4RIn3S3d0QyiDw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 24 Jun
 2025 14:46:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8857.022; Tue, 24 Jun 2025
 14:46:35 +0000
Message-ID: <fadff398-9b5c-493b-a372-c64e7202d465@oracle.com>
Date: Tue, 24 Jun 2025 15:46:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] xfs: remove the call to sync_blockdev in
 xfs_configure_buftarg
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-3-hch@lst.de>
 <a9a266b8-526d-4aac-aad5-503a05911df7@oracle.com>
 <20250624140746.GD24420@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250624140746.GD24420@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 41592ceb-bf59-4af2-fab2-08ddb32deaaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTNiakpXV2VPWGdXM0JjWWhxNU41YTYyUjY4Nm8rVndVZ05XcHVOWmNxVmNo?=
 =?utf-8?B?TG9pemFNYURWMjdKUzZaeC9VejBVWmp6SmY1NlU1QnVtNVkzWTRrUzQvcjJI?=
 =?utf-8?B?MStHYmFlY3N5U0dIQVVST3VrOTkxRE5PVVRKMnlZb1ZTaExxV2hNaGFtQ0tU?=
 =?utf-8?B?eXJSL1cweDFhczFrSDVUTWM5R1JCSnFJb3Uydk9nZHBhZjdXelJlQnNwU0hE?=
 =?utf-8?B?QXFLd3NxeUdvdVVOS3ZtNzZyRlQ0Q2ROUVpNUjNuSFFDL1Z6aHNyMWlpa2tZ?=
 =?utf-8?B?OGZEYmU0MUZ1STVkWkpLUXFHNmpzQVN3TGZ1TFZVdGJGK3k2L3l2TVNGd05l?=
 =?utf-8?B?eFVMZXdXYXZVbG1RRFhLUmJNTzhDWGhtbWdEMFJkYWtlSkxPejN4bTdnU1Jr?=
 =?utf-8?B?L29LWVlyMk1VaDJWcmpJYjZsZVAyRGk3dFJyblUzQkxoT2hlT2drMStyWm1z?=
 =?utf-8?B?NHRvQVhCSlpNZWEvalVsa2JFdHB1K2xmeWQ3ZUZhU2tUWnh3Wm9hekRXbHlE?=
 =?utf-8?B?NEtxTStkVitPNXlrMlR4R0ZDdVd4Tjd0QXRRNDIzSTIwTnNyUkd3UDNxa2lP?=
 =?utf-8?B?MDd1dnpxMXVKUUxCYlJmRWhtYjQyU1IxQlJaME04M25OQ3NIUHFCZ05xMFRL?=
 =?utf-8?B?SzhBT05kZ3hQaVUxVGRoM2o5NkNGellacVNaT0ZZa3RDR1pvVVdQS3dTSDY0?=
 =?utf-8?B?SHVNMVJldGFhY0w2ZFphYTlCWVVGVVhzSGN0NUJIYURkSzRkc0N5V0lSUDJ0?=
 =?utf-8?B?UHc3Q0JBWnVuaE44cG9TZndJTEJZTk53anlJL2J0VkRlYVBmTjdNM0x6bE1C?=
 =?utf-8?B?QzJraWpJa2s5K1U0bWYzVFNrMTBqK0RUTHI4bUtaWUQ4dzRDV2xxWC81cjEx?=
 =?utf-8?B?WGtxQyt0RURJRXVjT1lzSndxbTA1R3JHaTl1di9qcGJLZkhOVUh2OENVNnNx?=
 =?utf-8?B?UW9XYkIzY1RQTmFTMDRUTjE1enNiL2toT0ZubG1rVTcxVmlkdG9QYkVpTkxx?=
 =?utf-8?B?SW9aWWY5aXF1RS93L2pEL1g1VHAzeGhNbzRKazVoRHJvVkgrRlZTN1ZpKzI4?=
 =?utf-8?B?Ni8zS1BXL2cya2c5QWw0VEIwcDl1TjBRWVJsSUZQcGQ1RXVCS01zV1BleGNt?=
 =?utf-8?B?T1lnWXQrVU1kdDN3Z0c0a0Z4OUV2eERYQkEzanNZaklTb0lkWjNQQnBGTVhi?=
 =?utf-8?B?NDJXUEE0YTFQWDB6Nm5KUVJyRDFXdW9RMHIrQjVNQ2cyVk5STitaRXcwYmpl?=
 =?utf-8?B?NVVRTEY0Nm5MOHpac2RKZHNmblJ1NDhjam9lZkYvTDFNMDROczF3WEFEWVJK?=
 =?utf-8?B?K1hDc2lrQnVHcnNoMGF5S3ZkUVJXTlRLM0pBamhuMnlTN3JSNHJoWDh3cDB5?=
 =?utf-8?B?Z21PenBaSXJaYzRBSjl1NFJjTEVTL3pCOGtWSm1WOHhQNWpoRVFNdlIrbmdX?=
 =?utf-8?B?dWtDNUxoejBLUXk3dTVVeUlIWlRwLzB3S3RqamZkdDV0RTgrbXlxaXprM1NB?=
 =?utf-8?B?aHVEclAxaXBNMWptTGh4cDJSOGZqZUVoRHNvTm9kMCtnWlYwR2x0TzZCZm1I?=
 =?utf-8?B?UEpWd1ZsWEVldElOOFdLMUkzaGhrUHlKSUZBbFN0M0ZhUnNhQnJkSFBTNXNx?=
 =?utf-8?B?NWQ2cU9JU2VNZ3NhdHBlSmVFRG04RE9iUmJRdnRNUDJOREZPUXBaZm9ROU9W?=
 =?utf-8?B?Y2cyam5VWldmS3RkWWlHUElweFlpbk5nUWQ0RkZ1azRnUGpxcEtaREJzNC9S?=
 =?utf-8?B?NkZFZXVidHg3aFZIZmhCcnBVa0ZGM1ZiajBjRG5PVGx5c3RrMlVUNm43aTl1?=
 =?utf-8?B?TDFEVTJ6dGc5Y3RPdExXcVRkdTNUQjljRVdicC9vZkVsekxQVG1KY3gvSnRZ?=
 =?utf-8?B?TGNnanhnYlR4bEhwRm1Md1hIUzBsc0RoSHdWb2NWQUtlY2xqdFlhcFkzUUlt?=
 =?utf-8?Q?2DiW4EZIMVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1JhR3dLaWFZN2crT2JuVktaelJvWmtwYi9VNkN4YkNuQlBrSjEvMGdueVJj?=
 =?utf-8?B?RFJBUXpFajA5Um9oU0ZDTmMrRW1pelJOMmNOeVZjcmQ3TURmWFV3clY2ajNn?=
 =?utf-8?B?NHcyaWIzTzc2clF0T09OQysvczNaYkNCUUhhWW9penJrY1NrUEtQbzNIcEo0?=
 =?utf-8?B?QzNpUGdYTjUzd29ydzY2eVBuTFN5RzB2c2gzOFpZMmx2R3phZS9ZZ2ZIcWd5?=
 =?utf-8?B?TlN1eXkrR0hOc1ZINXFFaXNndGtYQmp4SzJ6V2FjMTd1S0RwUWhwYVNqd2tE?=
 =?utf-8?B?RERlcXBoWVFzVm1PNittanNjY1NrQ1BzeTJ0dElyTGVIN0ZKeGZHZ215ZFls?=
 =?utf-8?B?QUN4R0FxS2g3ZnBpbWJxcHZHYlJPRnB5OUFZNFZySlNVVldmQlo4L1FMcmpV?=
 =?utf-8?B?WHN6eGw5ZWVJM090OFBxOFRqNVFRTXdYVkJoZGM5aXN4MTk0TXJJNmo5WERy?=
 =?utf-8?B?YmlKVmx3UEc4cHNrb213YWhjYW42OUlJazRPK3dHcTBhM2VlcFVHOWFiczJw?=
 =?utf-8?B?SUlNWVk0WHRIa1lBSUl4dnpQdkYxbnlkOWpCQjhncGFlYzRWZTl4bVd2Z3hv?=
 =?utf-8?B?ZHVQR0IzVWxOTjJLeENVZ2ZhWTVKTFJkbzl4Sk1JT1pLdkdodDI2dmQ5NFph?=
 =?utf-8?B?K1RCcCtOOUo5K3c2b3J6OEpLQ0JSbVpuSmFZMjBwZUhxZWR6NnBqRG92alBU?=
 =?utf-8?B?Q2MzYmRId0NOa29lc3lLVGN6RjIwT3BTaVpWTjJKOXlVdzVJTVp1OE9hbXc3?=
 =?utf-8?B?MDBMSUNEUmRTWXFuOGd4czd3ZFhGT0VDUGwvN0x2V1MzSzhkSXlyazBJMU5m?=
 =?utf-8?B?anJNdUJDbkJXRTRVZ2YxYzR0dUh1QkMwdzE4SUZrV3FtOXh2b0tmOGNxNHlI?=
 =?utf-8?B?Um9KM2pVTXVaMWxKQlp0eGY3bFIzTmFFdUNyUXk5R0lKcmFHZHE3YjRhc1ZX?=
 =?utf-8?B?Z2tIbndQdmtnN1N4L2RPNzZud3ZhT3AzMSs0VjJRaXMwZ1o4REl6U0tQS0Zk?=
 =?utf-8?B?Z2wyMVFPTE90WkszdFlwNk5DTHhaTkF2NG1lZlg0UEp4ZkpySDRiWUoyZDl4?=
 =?utf-8?B?b2lyNUxCc2pETTBwTmMrQjIwbUZ5ZmdpUk5BQUZ6V3MzbWlYZGptbXoxcXh5?=
 =?utf-8?B?cFZtNkJTWm95ZmE5MWtyZStsYk9paHZ0WTBqUnRLVWV0Yi9GZVhCck9yNkQy?=
 =?utf-8?B?RzY3Wm1ZUEVxYVduTVJYeWNkcDBQRFIxcEVKaHZYQ1lLai9HRGhmWnJSenlO?=
 =?utf-8?B?RWx6c3h6djhlSXlIem9Da2xWRSsyeTdkTFJxUllnYWN6UUhRTjFabVNacnhn?=
 =?utf-8?B?cXBFMEc4bmZOdlFSTTZRZU1JelZtdXVtWFU4bElBTVkxTXhVRWw2MjIzRkVo?=
 =?utf-8?B?R05waUpvaEpTWkg2b2VUQi9wUTZva1Nwa2YwQmlkQnJVUDlPTW1lMHo4MkFD?=
 =?utf-8?B?UXZydkkvSWJJalg2TXBIVHVKZnlOcmVsejF3RzJ6VGYySTQreGtIOHNvQjV3?=
 =?utf-8?B?dUlVaUFqOThJR280cExHQ3I3TnZSRFRPMTYvcERSWG5LOUNKN1RLNUtFZlJZ?=
 =?utf-8?B?eWU3WmF4V3UvdStZZkpuUktLQlhUYTJiYjZqdWI3RUhFK2pnZlZsNDU5K25Q?=
 =?utf-8?B?OTQ1OExMT2FGaVJLWmhROEF6UHVYZzNOUGp0NGYzeHBUVTU1eUdCdElLZzBq?=
 =?utf-8?B?a3VRb3c2RWxjcnRmanR2Qnh4UG1GenlZVUVGVDdac041ZytRdit3R0tld3Qr?=
 =?utf-8?B?QS9URWFjUmwrLzE5QUx6OHdqYkdwRy9wMmdnNnBXUHZmVWtFMzZ2VkVhajlY?=
 =?utf-8?B?VGJuclFBZzJKREtHaEF6SXNKL0dkTTRFQ0VEaGsvR1gxSVh5S29XNHdPUjEw?=
 =?utf-8?B?VC9Cb3ZnSzhuT0Y4dGFTVTdGRDRGb0Q2ay9BQWpPT2dTUXZOODYzdVNicjRv?=
 =?utf-8?B?K1h3bUNNRk1ScXlqNTFHbHB4VlFwejBrNFdGSEQwdHcyb2UzWGpBMUxqNzg1?=
 =?utf-8?B?QTcraElWSE1yMU9zenF6bzl1VkFCdDg4ZGhTV3B5YmV6Zloyam1vUE82blJG?=
 =?utf-8?B?Smp5STVwUitIWk5XYWVxL2x3NC9IL0ZydWQrcllUSTVrL3NmYStycHRLdEhi?=
 =?utf-8?Q?x9NbOqmia+t+m+xnkwPosXgU5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RYSdVCRNjcQjTAIUpQJPEelKg+R2e6R9oMQBaSf+HWBFqRqRBNDrqe4pZAeLVYpRgXNn/ZuiWHEiRwdNJsTHVR/C5/hiVE8hBTHmJXI177xT8n/7VNH0Av9OwKEkGjY88Actmn60L7W8+zoedZHlJBNe6r2GcUQ+P1IIYish9l/QEW2+g0s0a7klw4EWEgeV/glfMjhIyLFI5ki2GIY8CIRP6a7MhYX7jnpsOwaE5p7E31g5KToYPTFeb8P3lsVsj3XnP6yi7ws56uvIr5vDNcDEhfha76fQeF3erbJpCNDDal6yYyRM038V6QAGf3+8Zubum2YfJbDsveQBGz5rBArggdPQWuB8qgwwYe1zhmfXe3zun66eNXtPSby198eYOr1qzoH5v6uOdM4QKwj/UbtKtLHWtKRRzmWwSMDT+R+vL4aQ3VX1Jhh2E9MRIUn2CE/q4tV3bbecpZy0898UFpxBCRNylU+/2SjHsWNEpqsPc8nQTcWdPjybF4VgmMwb4XaREOkAXi9d+Lh/kgNIuf4e0D9lH7qHg1cc99QcfRzN442QuhYEt8RBaPPr7kPjt6lS29+TW++UoDYtOUbxNbTuT/RRXDsphbSdyubmZQ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41592ceb-bf59-4af2-fab2-08ddb32deaaf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 14:46:35.4701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihhZ8IwQq1F9tRhACZ/5LmrEcMCHP523XV3Xh1wTj0eaBH83myFc6/JnRVt5GIBMwEgHtCDGjJKUzruH6n13MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_05,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506240123
X-Authority-Analysis: v=2.4 cv=a8gw9VSF c=1 sm=1 tr=0 ts=685aba4f b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=2urXbhIM2JPko5f4P7wA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDEyMyBTYWx0ZWRfX0yBl9gaBLgW9 AAkSAV5bGEkIohtqR7/KC+ZV5n0yXFQRrfxVo2YyF6h8Z0PhobzkRipU4A8JzYeGr8cEYUkRtwv QTmt41AAkO9OAz7T1J6Lp5q14jZ8foujMelvbm3ECn5bzDc85R31UlJlIiF7qNTo+rQu4YuNShL
 AcCjsdjsROwuoH+c3RNmxkBDDwd3qBWZF6YGd40d0oO7coeTAmWL+1Rx861MaP0eO5Q0PXsXn6O g9QQqCL+JLMTSj8YpnuwDo1H1B3yxIM9IgSzun59leUPRhB3jBK1+UqxeXJ8zQSpCMOnCGJkY/Y 9nV4VOtUIDtkIAAdzh/hNJehWXGBZmF3zGpZztJsLU0d0VYK8y8K+PO3O6KyhWIQQBSO1KsZ1az
 Bb74dYxxQ4VRrT/RkppWDio7nxdWbETqEMgIRvBcgt8sIHhXdxHeCf9ko1LSg6r3GhCRqgB1
X-Proofpoint-GUID: 9mcFr41cLhgbMSeuYRGULyrnicrkWBgw
X-Proofpoint-ORIG-GUID: 9mcFr41cLhgbMSeuYRGULyrnicrkWBgw

On 24/06/2025 15:07, Christoph Hellwig wrote:
> On Tue, Jun 17, 2025 at 01:09:43PM +0100, John Garry wrote:
>>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>>> index 8af83bd161f9..91647a43e1b2 100644
>>> --- a/fs/xfs/xfs_buf.c
>>> +++ b/fs/xfs/xfs_buf.c
>>> @@ -1744,8 +1744,7 @@ xfs_configure_buftarg(
>>>    	 */
>>>    	if (bdev_can_atomic_write(btp->bt_bdev))
>>>    		xfs_configure_buftarg_atomic_writes(btp);
>>> -
>>> -	return sync_blockdev(btp->bt_bdev);
>>> +	return 0;
>>
>> we only ever return 0 now, so we can get rid of the return code
> 
> The call to bdev_validate_blocksize above the diff context can still
> return an error.
> 

Right, but I think that my comment would be correct after the next 
patch. I just noticed this when I applied your series, but commented on 
the incorrect patch.

But I also did mention that maybe we can get rid of 
xfs_configure_buftarg() since it is effectively a wrapper now. The 
ASSERT (call in that function) looks pointless to me.
