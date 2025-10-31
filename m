Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB3E33374E;
	Fri, 31 Oct 2025 10:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761905072; cv=fail; b=H/GxsqDcYlmCCE72DP5QiBhmvWa6sfjQrU4jgpk+Z3DbI2lIeLSxvaJ7AX5Aj80yq8TIbRCNtSOKKR/mV7wznjfn0RwKXoGfwuhDK0vF7WGGandUaAMkDyrzMENTwvY1Kfadq3lOJSAfLjHzcLHgvetLndI5EiFCR/AhvVOT+j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761905072; c=relaxed/simple;
	bh=BHt6+cIoAmKszSeQoBUohMAO6Ejx5brvmT86NaCTEjk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VUFqz8qIt3A5ep6cJcog2ecU4P3LQvvjw2E0h1BcAkO6O1RDRKJfLBeY2cTIzmgUVz1iKdTrqZ4lB99OMF4ONl1fydugq3c8MxU1QUdVxfM10iwcEqllQeDsJzKNHUmhNj4U0NTwpvEj9vvgFfTkSwxuWKvkMgvi3Ee752zhJ3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XojdbY4O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TkPuVU0J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XojdbY4O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TkPuVU0J"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59V9tNXM011590;
	Fri, 31 Oct 2025 10:04:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BHt6+cIoAmKszSeQoBUohMAO6Ejx5brvmT86NaCTEjk=; b=
	XojdbY4O/PrV5LxuUdczPkfWP1LEcnAvGXv3vZgJ+dj1//tRqhgFo4RbpDsTtmSb
	aTLxMDoZ/380LBNoz0yPUoTFFcElU8H9S01aJQXUAc0Xe4nyWJgJjwKmDJD33QRM
	aF/6StHK/Qx7vzQQBiq6YpUMJHSd9leXxDlUOgHKpzFrJ/3XQYW7nPtFwUwIR0mI
	EaYszVMpoIq/+QAEDDgaq/C44VQVUiX8ctYXjYde9ouqaJG7qFSFuN9/HyprV5nu
	6t20t7tdLD6TdexzAdIZnbWgcjNHYZeORM0/SXNLMNF6w81zx8+gs0lK6yAVSefo
	g5w3ZdG+UvNHdp2zI0t3Pg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4tvyr0qf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 10:04:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59V8HGU8017434;
	Fri, 31 Oct 2025 10:04:23 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y1tf33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 10:04:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kbw0UD/wgg7mzZgSmm2kLiIvimPUHXiY1uDkY0+CnjUtSq92L20Ted654Z23AjaE7W81TJVrTCX4BLJECywUfvDUZnPxL3qKvcG4K5M4ICwXsifEnmrUSAaIzEDrCcQRR8M2/7DoEV2U5SN/yRVHwDm1zZ39sGSGcmSnj8sUHN4QJeVJxiTVYXemS5OuMSb+fTbl3GOfwAasZsYYM6iR/vgqxvmk7k2gGhQf2xJdgmudAZees7hK/d3ZslRcA1jCfmQ8Npe+oELHO/CcbyXQZhEfvnUmvKmO26It1TAwWPQHpQgyiQpHxOt9R68zNmbWDtrjaqDvcjW+2OHxztJ6+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHt6+cIoAmKszSeQoBUohMAO6Ejx5brvmT86NaCTEjk=;
 b=BaLwMuhd1ufawzE+Nh0PADLL6tjlZs2DSFuvgZhAaRq7ZZoR/hlyvX8Sx6yyhAQxaaDuv3plMS+/Yz6wbiO9J/fWWGmijQmPFdEiAwQSK+8nAaKInCDLhTSdDG53vrYTvg8EMKJ/TTsn/CchwNleF2pC+0FPuVm4GmFenPGT4Ye6JmEaO7OIPb90/VCqgzW7/OvxgF4SkCEtrdHYzJyBvPvgR8rLqk0rvjrN2jXmpTCSpohIpgJ06znFGvNAyYUNA9pyEHh0gFO3tNHfH1P+Dxy4PLcnX935ExJnb/4262Q7aIaT2ivUBaRSj3cAU2AbXOMgXOxZSYU1xtc2HAg6VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHt6+cIoAmKszSeQoBUohMAO6Ejx5brvmT86NaCTEjk=;
 b=TkPuVU0JsDvUbA4jE8dfqRd31ZVKX/6Fe+g5LqA0cwXh/WZ7fBt2ZA/irUDrj4XMSrpdJSOG29iZhKH6BR/qrB89V1dRaa+K/JUUiY7F+7no1s5RpREe9uR6AwaVDFUNn19fxSUUgAeseByfAe1wn63BtgEoaI/zti15GD+yLbg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SN7PR10MB6617.namprd10.prod.outlook.com (2603:10b6:806:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 10:04:18 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 10:04:18 +0000
Message-ID: <62ce2a39-ea12-4ef8-9a13-5d33562eff4b@oracle.com>
Date: Fri, 31 Oct 2025 10:04:15 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
 <aQRuGS13PtCu4Cyd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aQRuGS13PtCu4Cyd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0091.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SN7PR10MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: dfcbcfd6-3209-4501-2a23-08de1864daf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3FBeGhxaEFXM0lVZnZUNnJWVzllNXh1dDZsalRDL2k5WHRNRkJjc0l6ZzQ2?=
 =?utf-8?B?SDZXMUtVaTdtWDZGb3BrTWZ6aWE2ZmxUMUhpTUFaQkdUcDQwNExuMU4yVUtO?=
 =?utf-8?B?Vk5WR0xtN1BWM0JwVUt4ZXZ0dnE2UTZtY3dpV2IxeTZIcWVvbkZURGZLSFc2?=
 =?utf-8?B?VUJTU2ZUNTZUV1hHZjhaY0o2am1HbFZsM01NRWpqa2ZuTHEyMlp1ejRXSE1a?=
 =?utf-8?B?NWxmOFkzSG1PRC94YVZJNVd3S21UbUhsMEdMN05UN0dVMFk4UmJYZXF0ck9r?=
 =?utf-8?B?WThBbUhuNlJLUmRRUTFsRU1LUitvM2tjL01XMjJLRE8yOGNuTW1LYU1JRXN5?=
 =?utf-8?B?NVdNemdHVFYyZjc3b0Z5OHNjR0dmdUI4T3dtbi9uSDA0dEt1bjFNa2lXZTFo?=
 =?utf-8?B?b0VnWEM1d3A1VENHZlg0L25wRDFybnUxd1hMc1FjbzlZelJsUFV2bncxTGN4?=
 =?utf-8?B?bGZmZUNZWmtHdDhvL1V4NnFtRWdzTUZZekRnTG0zQjhYSk5mM3FpdHdVUjFs?=
 =?utf-8?B?YUFXYVJYSXZGaVYxaUhSdDRQckJmdnRZTFJhd3pmMjEveUJYVWpnZURPY0tV?=
 =?utf-8?B?dHEzVzJUUzh1b2FlaHlMakNqcWQ0L20vV1BvbW1xWnB6SC93Q1NlU2x2dTdV?=
 =?utf-8?B?NFF3Qk5TN2VqT1FQZFRiZ05iQ1BmNlhOSVNuTm1JUHRKUDM5ZlorR3BadXlH?=
 =?utf-8?B?aDRMVzVRT0Y0Nmg2ZWdGQlErNXdtK0JrOWpuZURFRUs0Sjh1SllQWTJFZ1JG?=
 =?utf-8?B?N29BNGp3T1MrUkZ6ZTczbThGeXRCU1JmMHdSZVI4QWdOYlhwMVNQMXNTOTFL?=
 =?utf-8?B?dHpXZnVIYlhRVnJGclFNbVRrQTJjeDFhSEtuMzNvWW5RZHR5cWJtYU1ScmNC?=
 =?utf-8?B?eHhyQlBCN2R1MEVIQytzKy93dlBvZm5WMjFIREt1R3ZNTXVhaVI4blN3Z1RE?=
 =?utf-8?B?SzhZV1dGaEZVOVd2YThqenNXcG5EbndDNHNqSVdTZ3ZGU1NNSk1tRGJGYzNR?=
 =?utf-8?B?K0xWNGNmTjd4NE5UckJQRWtMSmRNRGE5VFUzcFJrS0llenV5cWk1SlF3ZzFF?=
 =?utf-8?B?UnczMWd0c0NGczdVSXM3VWpJQ3VTbmFTa05Cck5LSVZHRW05YTFBMDFickZN?=
 =?utf-8?B?YVV5cThMaThhSHdLelBLRGpMcXRiL3BsUGNzaTA3c3VJUVJ1eENIUVBqMS9T?=
 =?utf-8?B?V2hJdkE1Uzh5ZXJ2YVRLY2lxYzRRNWUxRnBhS0JNOTNTZ3Q4Q2I2T0QrOEZa?=
 =?utf-8?B?MlpSb2trak1WQXlvUEM2VWd4aytuTmZnL3dHTFAyS1czZXdVTm1zRm1UUUlr?=
 =?utf-8?B?ZFJMVGJaSDRWdXRMUGNOSHowWk50THQ0NGZxRGxsTWdMSFZkMVg3bDY1V3pQ?=
 =?utf-8?B?SzBTS2JwT004YkdHQU5kRzBKakhQRkdYTkxGMFZVaTJBZXJNMXByTW9WQ0lz?=
 =?utf-8?B?QUQzUTlrVG5mTXZ3a1ZmU0FGeU5PemY0cldqdzUxdzRxSXlIY1laZ0VZaU9o?=
 =?utf-8?B?RDQ1R0lvUk5IRXZtcGR2SllWUlNJODVYRGk1UTMvcG4ySys0cFVjQmluamZW?=
 =?utf-8?B?ekM1aTRnK0ZtNWNDVTd5T0ZjZnpZOGgrSVVrVTZDTkFLVkx6TDZtNTJ1SXRH?=
 =?utf-8?B?RXJRdXQ5R1FVcGRxYzg3VU9JcHF4aStjU281ME5jWVFxaTRvRU0zNy81Z0hJ?=
 =?utf-8?B?aW4yTjFVSVlwZnlTUlpCeDJWZUFZQnVvNFlYTmJIdHFhUHVxT3JrNHZzdWFW?=
 =?utf-8?B?OEFjZHk5VnByK1RseXNkL3lKcWlqclJOenZhYmJ0VnlrdzQrME1TcTBERHBI?=
 =?utf-8?B?ZEN0TU9FbGFTaDc2azBSK3lvSUdSTXEyaHNMaDdmRVhmOHEyb2pmOUR6L29K?=
 =?utf-8?B?ZTBMVHY0ZHV3RHVIK2p3c25hNkx6MEh2R0xuMXlFSm9FOTdMSldtbHdwU0k1?=
 =?utf-8?Q?HLItJ1PpMzsRUF8a9A8ICtKqvpJeqrz4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amREc3Z6ZlF3UlJUa2dRVi8xbVFhUFR6SjZ2aFNtK2xoK0pXN05UUDdkOUJX?=
 =?utf-8?B?eCt6MEVINU9tUkI5aEpjV2xGNExvMHprb0FNQXpwMTBzeW1VcmhHdTNFUUhy?=
 =?utf-8?B?QzluUFlYcVl0RDFlbVlrTzhNTTVrb2pYQ3Vac21uN0pCZlNKSmEzd1N0R2Rm?=
 =?utf-8?B?ZTlkWjNvOEtQdjRYS29OQ0ExYU5OK3hPU25UQ2lWb0JLYm4xZDMvanl0OVJ4?=
 =?utf-8?B?dXlhVHM0a1EzazRuRXFCQkFZK3dZRFlWanJlcXZGQzlYZVJhZVJrSXpoZlla?=
 =?utf-8?B?S2NOdHZzS3NHLzdmZTltRWltdGg1d2F4R0ZUWkM2aXZQT0h4ejlTMlU5RFIx?=
 =?utf-8?B?aGtBOVVsYnZwU0N3Q1VWZkZJdHltMHk5ZVB5bmxUZ0dyVkc1OWtNZ3Y4R2xJ?=
 =?utf-8?B?aWgvWjhBaWdoc01oYmU4b2JiQzNvRUVpV1piUHFQb0dheTBXa0NTdEwvS1pE?=
 =?utf-8?B?VXBRUFlvU0V5UmpiV3JaN2t2cFFsWVh5dDJQR0NabnZJYXBMclBhYlU4Q3M5?=
 =?utf-8?B?RnF1eVRMNVVzeHFmVllOV0JzNkFwb2cyRHRSZ0x1R043R1V5aUdreVVxa2Jr?=
 =?utf-8?B?ejRaRHNOSEJsY2RkcFBNRFoxWTcrSFgrZjdBUFJ0T0FiK2JHN0xFbkFXNzdF?=
 =?utf-8?B?WnlhSmRwNlZBdWFaMHIwa09MQ1pGK3UxakJHSVBoZ1hSSnFCNjRsVHJtUTcw?=
 =?utf-8?B?WDE3Nk9BYTVBTm1pcDFjcktvTGlqRmZyMnU2VlJYRGJnazBYV251UWlCL2dX?=
 =?utf-8?B?MFlkblZUa1JGOVBReHFPdko0U2NtSFpiNW8yYkIrNlJBd1BVTWFOQml0RDRy?=
 =?utf-8?B?d2hnb2dNelRjME9MTGRSQUhRVkNDbkhBNEllWldHK2NMMDZkZFJLcWk4Z0Nk?=
 =?utf-8?B?YTJkTktyKzBxTEtwb3VmVE51OVlqZzJoNDdRd2JBN2lQUjhrRTlHOGkwVVgx?=
 =?utf-8?B?N2k0eGdCQ2hNVE5zWnJuN2dOczdmakZpaU1aQXVjMmZqRUt2SzRhMFFEZlZ0?=
 =?utf-8?B?SmhxbzJYWlZ1Q0F6VnhpUnFDd2pQTFFZTmxYbHpQKzNvcFhZWnA0aVJwNGpo?=
 =?utf-8?B?R2ZBUkdKWWNndUtFa2QyNEREREhCa2tOZ2s5Tmc2V3c2b0hodGt1SU95UmYv?=
 =?utf-8?B?QXAzbWN1cEtRR0dhK3NaL21xQThoSTVFdTBOZkpNbEg2UTVpV1lrUkN6ZW5E?=
 =?utf-8?B?UndWTjRTN1BRZVBFbFpUWnVzb2ZORmhXNWdkZVlVTDJVTkE2MTNkTXVRbXM5?=
 =?utf-8?B?RG03Mm9JUWJ6SnpLaVVXRUFsek9aUzFBeVI2UWxPTzh4OVYwdUcrc251ZUZO?=
 =?utf-8?B?RGJ4WC8xRFc4ODEyNFl3akM0NEUwaEFkcXdiTmpkOVk3UkZTVERDeHRlQ1l1?=
 =?utf-8?B?eDdQdFhxMzZtbVNXMGZvaDZ2QTFGVmtTU0lwUTg1am13dmtNSDRVK0U4cGVh?=
 =?utf-8?B?cGpUejZhZEhFVzRLV2lBN21peThUbEoxNUZ0c1hBWW95eDQzVmQwTkRFeVln?=
 =?utf-8?B?V1JPNTdHU0JYWFZIdURVb1o3NVJUaVZRTzZ5cXYzUGIwL1Vjdk9XanRFMERE?=
 =?utf-8?B?RHpJYXlxVFNNaXJ3M1pJTitOblJvUXJJUmxESlg1dFZacmRCS1d1Q3FJL0JN?=
 =?utf-8?B?SUx3ZHpxQlB4d1UvQ0Jlb3RoZEpWNzhUTCt2dE13dEpQNVhUOTZ0d1B5Mlp1?=
 =?utf-8?B?eVV1SjJtQ3hUaFZmNFhRNWZqd0p1b1VueTIvYzhJR29uaTVxQnRtQ1lRcXVn?=
 =?utf-8?B?aEg0dUVaMWFVSHVjTDY3d1J4VUtZTzg0Z1RBZEw1OW9BMTEwRlBhMDUvb3lp?=
 =?utf-8?B?TVFhWHRCVDNzQ05selA3cjdnTmxnd3BTUHVCQ2hpRjVJSHhUaFhyVVRuanNa?=
 =?utf-8?B?dnR2TlRtUXRTVWo0MHE4NStLTzJsSTMrUDk1U3o3c0dPN0lUSG5tZ0FMVnZu?=
 =?utf-8?B?THFQWnNrZXBOUWZvdGQ2RFRtRkdiaVpGWDc4ZTNSbUgrSG5Ed21vU2g4WU1i?=
 =?utf-8?B?TEZ3em1KUGFvNGdJaWJXYmFUaE1sWDBsMDJpbEZMTFFkakFTTjNRVXZlNXI5?=
 =?utf-8?B?ai9mdmpRREZoVjkyN1dYMFNUMTBwUW9MQWdmQWUxNHVCdEZKR3Flb255U0F1?=
 =?utf-8?Q?RysqHLB3T9ToIGA0Q1TJhdwo2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fuA5lQm71MvwgVpbYNXRFq29a+0rz+f6Fee0mk2XawPxsCF9tmqIqafcD1KfkUvJKNJUdlKdS02WmyUBeCCP0O1QrPFz70LOd5HvsdO/RfbMQeGNsiEXFwADPYNR0ZUgPs8HYM+4OTl2Kqf/Tp85XeXUWuaHAkSyfMTyj0dtJynxCraWKZ3q+4/Em44K7KRB4RL+GsisIFNT9KYkHPLpytF4T+NW7pK70M1oZjFvLsYmca45cqCXO3dS2apH1HXulhaKSNpVtcZMkhJItQls3AP5GGNDHSQFMmGI2TYWpch5mSDycKVrwwix+KR17J3Qp/9Z9l4h4hla4K63Y4UbLUgv1zsv35JEZYDFN+8kg/nk2Tahhc5ETUpILPgUGlM3zwUH9W1AHiiAT+KGAPSegpeI3vC9KKw4GQ+E/QWhpv0Yq/P8HS66simxrhjj+UzhfYrESjUCyrzD5T9CCqkcy3hhwJg4sRtb9OMinrtLyE4Hq34LdQ+FbF5p/UDn5oE9Tp098VsVsXUyEbgYmgK01A9v/W27GancjND+9Pqbf/KPJ0xX5+pLsBjMj/qhtEWE4OaPd76KAKmJ3xYi8JaHVB7Pux5Dn9V1qoXm1c2VtXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcbcfd6-3209-4501-2a23-08de1864daf7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 10:04:18.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/Hq0AvEosfiH72tFBgvwZbCZs8Zjqw+f16ya6qpAPLSWnXwQfnFfn0FHtIm27hzDgoj1iiVy8sKWtv5epG4wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6617
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=902 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510310091
X-Authority-Analysis: v=2.4 cv=PLkCOPqC c=1 sm=1 tr=0 ts=690489a8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=-Fy7_ZKMIPtSSKo9R2MA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDA5MCBTYWx0ZWRfX7IsPzap603iB
 YLWkgqt6fkipskjkzNqMVTwODfJqrotqcAQTUw0/boD0JBf3Ltub4jdJYWyPtmFrqEqQnVVzyry
 hZJuRAdo75/cqaNnsNwDeT8d2goB1Roiq/x4s+LNWT/pVVbOr0OPJjkWkNEjpWtosL0osOZE6dv
 wLheWjWntGTDN9yOH0S1xM+7TOAgHeKV1uSGKBHZRb79IfB7jUVJFqMNnn+d3JLe60C/CMa8F5L
 +N+QMnAUTeCS4pSZtlpd2kOH5TX7wowkHFS3JZMGwFslFbkVKV4Vs7773lC0vzix8mgkJBfKkUd
 InCFBkCx6lkaBVeEzRh9daB1ZKAn5NcAPcw+RcVqe/TC+W+QS1UNckkVkUMQ5i80m1wgOVPFBQ8
 msyZyY39+Bosh3cqyCY5pV5Q18o+EQ==
X-Proofpoint-ORIG-GUID: AVKNoeH6ID6nv59dwJ1dyE4DTw4wjnfq
X-Proofpoint-GUID: AVKNoeH6ID6nv59dwJ1dyE4DTw4wjnfq

On 31/10/2025 08:08, Ojaswin Mujoo wrote:
>> I think that the problem may be that we were converting an inappropriate
>> number of blocks from unwritten to real allocations (but never writing to
>> the excess blocks). Does it look ok?
> Hi John, this seems to be fixing the issue for me.

Thanks for checking!

I'll discuss posting an updated patch with Darrick.
