Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A3A2A;
	Wed, 27 Mar 2024 00:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498380; cv=fail; b=ApkyPTQ0MBH4NlrHa4PghM8Ngo5yWIW114ngb+7doBuMlbn6EB+IVoIgewRv0m40lz86yGSb7895gVZQ5/uvGF1VtVPUiJSHw3m14PQeINHN3zRdpdYZAwPlW3SQimLkSg6lKxzI0vAbBQM1EvgrGg60l+v1ZFzbw4eTh5qTlaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498380; c=relaxed/simple;
	bh=K4VEPWyCjYXgm75BykDysv8p6zCe9SmjzsiGQ7uAnaE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VKvqtuvdA0/03gozQ279oq+sWjiWbXQ6jAYxXR9US3GUb8O2BodApQrYDYJhtbd1BFC44tXsPNtKnQW1ENj8O93TPJ75qRvsXz4VneR2nL5NwZReWpE9ovnAQRgfF00tZATfM86YBnNELn9bKISbWxqZ5P77pzdkivKk3waPCAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N8D0Hfjk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eETNo2p5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N8D0Hfjk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eETNo2p5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLhxNG016381;
	Wed, 27 Mar 2024 00:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=gQKp2SlKEmGMEVFmO4lsTfsdDISGzX48XToaX+mvqug=;
 b=N8D0HfjkG1kaTUVHsxjgb8yioJkNaVgAv4gROrfA456u2XBt9m8YXvpBy22Lq7sG58HG
 /ErIE7Klr3T12suF53u0uKUVExHn11dAGfOa6P181IE+OQXQv0LTV8bedhekD8Os55Dr
 wXLmPRu21BOsYSgiEULEfvXq91WnOqF7mPLP4fRgetmD216s7LolozAGoGUmOp/7pLmM
 RWTBD8QbvN1C1BKDcTzcTOfoLiD/7G+tjGglzuV69TRPeFOuPUY8OpvscM2FHKutxpY4
 l6cXm4BCQbLE6FrVeciOUVlc0SU7zhgaiAKGvDwZx6OD2HEnUy42ccbXM1y4DSUDVZeo sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dxc0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:56 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R03ovD020681;
	Wed, 27 Mar 2024 00:12:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhe1a9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKKAUEuuVJJ493hGVfSwATP/2LfEPqNYXMCjYhSZU/c/DQx+4m+lakTStSN2yXtFU21HMNIia3UAQiObBGieyv1TwHTbKWW0HtPWT9EWm++8KUjl2xhQP6O9Fq/uz3Y9FuEQCVWv7hSmkr6OUgJl70wLZH1Y5Ymntd0Cpo1FCeGj6LFwfOAmFoRrbpXvYDKE+sfhL+0C4BamQK8+Ob6t2Lr5hO5Y08vQSaNRkVTRWVyBu8EPgcvnJKaEqUI+LY3ZuoUd7W4hKAN6PnIOJf8sad8rbpMH9uGlAYUCyhimdB494ap7cGrVqqBQvIhIk1D+UiX5T1MQOb4RwQkEwqlMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQKp2SlKEmGMEVFmO4lsTfsdDISGzX48XToaX+mvqug=;
 b=QQ2K7xze6v7ZehjZi6ApFL50ra5NZFNA8lqHgmQm1vHHUqiR99rZsmVvxGhGzvAuNFXOZBxyY8+duHL9CXiV7zq4Ud2hNTHCdm3wVHzvzxkjdvaWbFcdRe0RMScvNlxy+mOp1YeZCFrDTzXoStjkgMeTmTwFxHIaB7fOsxYp7zOEV9I+xFEZHSjEsUQRxTQBAVkeJZL4uwfR50wnqhtAECnWsPJyzgME0eqfjp83PXdgLlGsxO7/9epg/yNaXoYCOBT+iLoSECZVngzO5AFqjYCaiD76vRRK6xdrxaZsNu8W9d5AGajSg9FTCxWuHBeaX8BZg4jwkioXaMoZnKzzzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQKp2SlKEmGMEVFmO4lsTfsdDISGzX48XToaX+mvqug=;
 b=eETNo2p5Jc8XZckURse36P0Ff3dvmeG9kKrKv2Ox6oMNXggOT7Iq0YPdL/NHneuXbjkCla4ib5WJ291mK6EmDBjoClS+l4UJvyYAQZX966nGgGSV0u7oW4ztFBQn/DF94DIWSYIM+rbfHYOFeGStpNELeKT3SxxSrwmOBis69J0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:53 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:53 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 05/24] xfs: use xfs_defer_pending objects to recover intent items
Date: Tue, 26 Mar 2024 17:12:14 -0700
Message-Id: <20240327001233.51675-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	tnNmQ5x15sQQaenBdWTkp0RBa6xrX06huz7pDbCMFJp2K63dik2DlPvNpXKk7cNb470U6oa43Jk9OXmp6BjZl3JIgUCjo5v+0uDOiUNlphiqIlSRzhQ8P3fpi3qIohqzdcqLHvu9pcOCXDZSZrPCjo/ATIw6jbmOieJv6hTx/eei1yStX0WjiKAm6i4FKlSa24LnpTURUD4yPXKn8sEEyBjHhWN/5OXbuWrT3eQAEKd1O5dn2UK/8j8vCvW+CH93lXgjfV/QOSsbR9PNkV4/c+2H+iMEmtLkPzsLGHipPlZbTI/7FLc9HiQuX9BeLZQBdgheeDybAl5de9ftI4g0cIv5dSm0EANDTHo5NzySZUx7mdSQ0U9hhxpWX8pFuNldFjfYgeOcuQ+0xP8vHYUt8ivhvEdpenYbtpeRPMos0cOcjsFai2wrR7wQO/jRpk3rcIukY9sWIq4gIIr+OypThfe5cymv3WwoqeSrYtphwAJNItjsdpnZboR+M2Ku9iNwpvSN/znpG0seSqpPHupZU6ikZfUw8nyVQ5+nGTbCEqUjeGX2NS5rmYGhz+yvOwfhh/EHhJ4pVTb34T7DZt37YuCIW6xosbdq4V+xf2FhU5SW/dED8aiyGVV1BV80r2aGvP++I81irqVm0rdS9Dq/qL/Xq8VSxgpGA98Osxe1zTk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NN5igR3xMT3bnTBOPTh1TkA1EyIwCW74yRDBhRPDBRWDcyYsLx+Tb0TdldR3?=
 =?us-ascii?Q?krL/Cfdg7htV5Jk5vfYKbAqOq7mUKn02+dEV1czBZi8AYvo2IzkxOOcezOhh?=
 =?us-ascii?Q?kDLT51I08+chZNzzGVOdUhkq52DssGp7KoNCSfTBaAkuFcqj98BwXBnCSzaL?=
 =?us-ascii?Q?fM9/9NlvSSXc/HsbNW9qcjJqSZo7/mC4iXKtZACesYBiQg4gN7RNefNQW5p1?=
 =?us-ascii?Q?J2ZWfdlf/VvtfxG6aYVf5N9OlXu36qooY8Qn8QFPHXZKvKG398tanoM9Kszx?=
 =?us-ascii?Q?63GbgZI4rtiRYxCTDfpt6ydZx0HuBnzWMXlZ2L/UcGsRXxJjQaYWm37sjk79?=
 =?us-ascii?Q?1rd1+6k0gGLKw+bm9/LhnZSNlI2alXTApiF30rCuTujpJaDAAYsPE7n1pxYR?=
 =?us-ascii?Q?PXE05LAxkufiSguQr2mqXPbi1roH+dC0K5CaeKUx5eR6iam09CQkNM/6W32l?=
 =?us-ascii?Q?yjMLJ5VOgJPWf77Kw0bccV3eqUN643RUMYTgeW4nxyJxxW+PsuQStyiI+xQK?=
 =?us-ascii?Q?01RnRLSSuXwegsZ3NEqJrbojg7xHI8lHE75i45g1Fp9lMQ+9g8afyQ2y9ITa?=
 =?us-ascii?Q?X1o5px+8g+8KHjvPxvOVPvpsDp/qvKw7wl87UPqC8yTqNYST+KosjizTaD1G?=
 =?us-ascii?Q?913XNTGPKgEmC58PsDOkzK0l5Qf/Qdu37KmcC3xIZH3zaw6N1eceZ+2OzAs6?=
 =?us-ascii?Q?vRHHJL1uA3EpDZ54975FWEAejSajxRxOXCYsy84bDt/n919N2/O9lWPWt87n?=
 =?us-ascii?Q?1e1Z85l5noY17AX5kOWFpLKG3535WWaYEUEqkZ8rInDOSxpTui7NSnRbeBVE?=
 =?us-ascii?Q?VGDWnbYv2elMTrOZNHDn44yEFXeWV5/B0JBAI2L2mFIRZDvxclE74E/Z3KO6?=
 =?us-ascii?Q?hRCF/z7+anj939dQ16qqq7UfdBdHaFyI9FOGvjINwxCP7FoIRbaJQMZ40X03?=
 =?us-ascii?Q?Za8WkSIuxOvOycwzNT16Z/m7FiKs8n9lWcIvcTYun+DkmDFAVTHA2ToqYEUY?=
 =?us-ascii?Q?o+min7HoENLQiuUY26PJmdHs46WtNbUQlpRjWUyRqirbYqPN/CWF5hpVwko/?=
 =?us-ascii?Q?oCKN3B+E5QvTN0gHhlOlPjEboCl7Si/72IUdQMjy90i7Yp/Oc4mc37p0tgtJ?=
 =?us-ascii?Q?NeSVK+0lOnrjbwQol4q+tMqxOw8fdGGYkPBAYNqrFdT2cdDVlDQ4B2d4eVx9?=
 =?us-ascii?Q?DszNN0H0tqleEFRmPQJ0xlT7zFsZZToSbcgYUVWaKWFP5MFZ5i789xIAvwrU?=
 =?us-ascii?Q?7wxEdtQu09MEfF+sBoqx5iEvVYf0NUHWliCT5eeq/FdbZtUT1L4DKVGtCAWY?=
 =?us-ascii?Q?HtqGTlnt17wZw9ZK32fqOu/48NS8FBUy7qIes+Qynl2mpQno8Yqa391ELDKc?=
 =?us-ascii?Q?uhvtKKb59cnA80D3vLemnzwpEts6xfpy1d0lJSTt+7vpxBDVlR2DVR7IIVlz?=
 =?us-ascii?Q?yg3jI+N9GIpDxg75i16eZtydrPL1K1SGb+yEq2alaEjIlS9KcpYMoOSXRISu?=
 =?us-ascii?Q?Wf1cDQoI4Cw4G1Mzy7aj+6TMu1xe97Im5tR+zGwFWxrkBrLonF4dVSEdNbWG?=
 =?us-ascii?Q?u2IUFSgLbE6W6z4UbX89MNK9lkz3cbHnmAf5Gy7t1PdXucso1gGOPldwCixM?=
 =?us-ascii?Q?RwioW9IUpXrsxUwK99RhI01ROP8tHEK34ACCOqPCNWku3+E1Ev6eTwrlAK2e?=
 =?us-ascii?Q?z+XMDw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bS0oUyy1xKwWNjct/c7+Q2GiEOV3A4Uaa1a+as6VJcGa+ul8CWs5ibA7FKAXmDKdJo74y9cJoWehluP7D7cj6eIGnCFLsJ2GEKSAa2xhGCoAIiYy6kXXlnrGzq5KHJl4i58DiSsiQMtEakqO5Zc/XtPKV0CUejkySnMfC5X/Oe1wA86u6NlUcEEJXPjzhz/J4nCnBLgSx2UJxGna8HrBolTex/NRqjhx0wxDYppAFYPbUfcyLRH1whb04abfcSdIgiXjttpM6cywzJfjjFIG+eLd57MYpurNrPE9jym8xIM5sztXPlUP7QC498blDABwkVZVwKu9qG5biyzcYBoJ695E8oLhE2FiMlO6egqqEd8douEazyl4MjdnPm9hVMRa5I2l2bnZh6N419rb6duKjG7kGaPP/07YSibwPRfOu/It+LnU1+H9S3qKv+NcCV3XeHZwhIsdQSwn4AiNcihYk4/6vcIaijdmxmqZFj5bqrdt/DeIYJQEW16+z7w6LtJIFUkSh+xIbUdSCUeBMDkXSC9ZgmY82w7nPaExujVS4mXNhLQrIthsof2w8BuTxm2fxHcgfvMTtPwggaNjWxv43S4ZmnlYAneBowx+iDY117k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416f2e21-d785-4e8f-de8b-08dc4df2a530
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:53.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ov6ME1dyJ5GyKVlTkus8F/7uqmSZA8d1qxgGc8t4TvadiYtFaYOZjNIBZAL71baI71KwRTSXijVltXMx2Tu8+SUVKJspIGRvc9iDUI5KVvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270000
X-Proofpoint-ORIG-GUID: w5WW_hkrQKjnzUDscPSX2FGVcnaOMaqL
X-Proofpoint-GUID: w5WW_hkrQKjnzUDscPSX2FGVcnaOMaqL

From: "Darrick J. Wong" <djwong@kernel.org>

commit 03f7767c9f6120ac933378fdec3bfd78bf07bc11 upstream.

One thing I never quite got around to doing is porting the log intent
item recovery code to reconstruct the deferred pending work state.  As a
result, each intent item open codes xfs_defer_finish_one in its recovery
method, because that's what the EFI code did before xfs_defer.c even
existed.

This is a gross thing to have left unfixed -- if an EFI cannot proceed
due to busy extents, we end up creating separate new EFIs for each
unfinished work item, which is a change in behavior from what runtime
would have done.

Worse yet, Long Li pointed out that there's a UAF in the recovery code.
The ->commit_pass2 function adds the intent item to the AIL and drops
the refcount.  The one remaining refcount is now owned by the recovery
mechanism (aka the log intent items in the AIL) with the intent of
giving the refcount to the intent done item in the ->iop_recover
function.

However, if something fails later in recovery, xlog_recover_finish will
walk the recovered intent items in the AIL and release them.  If the CIL
hasn't been pushed before that point (which is possible since we don't
force the log until later) then the intent done release will try to free
its associated intent, which has already been freed.

This patch starts to address this mess by having the ->commit_pass2
functions recreate the xfs_defer_pending state.  The next few patches
will fix the recovery functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c       | 105 +++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_defer.h       |   5 ++
 fs/xfs/libxfs/xfs_log_recover.h |   3 +
 fs/xfs/xfs_attr_item.c          |  10 +--
 fs/xfs/xfs_bmap_item.c          |   9 +--
 fs/xfs/xfs_extfree_item.c       |   9 +--
 fs/xfs/xfs_log.c                |   1 +
 fs/xfs/xfs_log_priv.h           |   1 +
 fs/xfs/xfs_log_recover.c        | 113 ++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c      |   9 +--
 fs/xfs/xfs_rmap_item.c          |   9 +--
 11 files changed, 158 insertions(+), 116 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f71679ce23b9..363da37a8e7f 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,23 +245,53 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-STATIC void
+static inline void
 xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+
+	trace_xfs_defer_pending_abort(mp, dfp);
+
+	if (dfp->dfp_intent && !dfp->dfp_done) {
+		ops->abort_intent(dfp->dfp_intent);
+		dfp->dfp_intent = NULL;
+	}
+}
+
+static inline void
+xfs_defer_pending_cancel_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*pwi;
+	struct list_head		*n;
+
+	trace_xfs_defer_cancel_list(mp, dfp);
+
+	list_del(&dfp->dfp_list);
+	list_for_each_safe(pwi, n, &dfp->dfp_work) {
+		list_del(pwi);
+		dfp->dfp_count--;
+		trace_xfs_defer_cancel_item(mp, dfp, pwi);
+		ops->cancel_item(pwi);
+	}
+	ASSERT(dfp->dfp_count == 0);
+	kmem_cache_free(xfs_defer_pending_cache, dfp);
+}
+
+STATIC void
+xfs_defer_pending_abort_list(
 	struct xfs_mount		*mp,
 	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(mp, dfp);
-		if (dfp->dfp_intent && !dfp->dfp_done) {
-			ops->abort_intent(dfp->dfp_intent);
-			dfp->dfp_intent = NULL;
-		}
-	}
+	list_for_each_entry(dfp, dop_list, dfp_list)
+		xfs_defer_pending_abort(mp, dfp);
 }
 
 /* Abort all the intents that were committed. */
@@ -271,7 +301,7 @@ xfs_defer_trans_abort(
 	struct list_head		*dop_pending)
 {
 	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+	xfs_defer_pending_abort_list(tp->t_mountp, dop_pending);
 }
 
 /*
@@ -389,27 +419,13 @@ xfs_defer_cancel_list(
 {
 	struct xfs_defer_pending	*dfp;
 	struct xfs_defer_pending	*pli;
-	struct list_head		*pwi;
-	struct list_head		*n;
-	const struct xfs_defer_op_type	*ops;
 
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
-	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_cancel_list(mp, dfp);
-		list_del(&dfp->dfp_list);
-		list_for_each_safe(pwi, n, &dfp->dfp_work) {
-			list_del(pwi);
-			dfp->dfp_count--;
-			trace_xfs_defer_cancel_item(mp, dfp, pwi);
-			ops->cancel_item(pwi);
-		}
-		ASSERT(dfp->dfp_count == 0);
-		kmem_cache_free(xfs_defer_pending_cache, dfp);
-	}
+	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list)
+		xfs_defer_pending_cancel_work(mp, dfp);
 }
 
 /*
@@ -665,6 +681,39 @@ xfs_defer_add(
 	dfp->dfp_count++;
 }
 
+/*
+ * Create a pending deferred work item to replay the recovered intent item
+ * and add it to the list.
+ */
+void
+xfs_defer_start_recovery(
+	struct xfs_log_item		*lip,
+	enum xfs_defer_ops_type		dfp_type,
+	struct list_head		*r_dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = dfp_type;
+	dfp->dfp_intent = lip;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, r_dfops);
+}
+
+/*
+ * Cancel a deferred work item created to recover a log intent item.  @dfp
+ * will be freed after this function returns.
+ */
+void
+xfs_defer_cancel_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	xfs_defer_pending_abort(mp, dfp);
+	xfs_defer_pending_cancel_work(mp, dfp);
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
@@ -769,7 +818,7 @@ xfs_defer_ops_capture_abort(
 {
 	unsigned short			i;
 
-	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
+	xfs_defer_pending_abort_list(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 8788ad5f6a73..5dce938ba3d5 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -125,6 +125,11 @@ void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
+void xfs_defer_start_recovery(struct xfs_log_item *lip,
+		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
+void xfs_defer_cancel_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp);
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index a5100a11faf9..271a4ce7375c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -153,4 +153,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 	return ret;
 }
 
+void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn, unsigned int dfp_type);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 11e88a76a33c..a32716b8cbbd 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -772,14 +772,8 @@ xlog_recover_attri_commit_pass2(
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
 
-	/*
-	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
-	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
-	 * directly and drop the ATTRI reference. Note that
-	 * xfs_trans_ail_update() drops the AIL lock.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
-	xfs_attri_release(attrip);
+	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
+			XFS_DEFER_OPS_TYPE_ATTR);
 	xfs_attri_log_nameval_put(nv);
 	return 0;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e736a0844c89..6cbae4fdf43f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -681,12 +681,9 @@ xlog_recover_bui_commit_pass2(
 	buip = xfs_bui_init(mp);
 	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &buip->bui_item, lsn);
-	xfs_bui_release(buip);
+
+	xlog_recover_intent_item(log, &buip->bui_item, lsn,
+			XFS_DEFER_OPS_TYPE_BMAP);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3fa8789820ad..cf0ddeb70580 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -820,12 +820,9 @@ xlog_recover_efi_commit_pass2(
 		return error;
 	}
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &efip->efi_item, lsn);
-	xfs_efi_release(efip);
+
+	xlog_recover_intent_item(log, &efip->efi_item, lsn,
+			XFS_DEFER_OPS_TYPE_FREE);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ee206facf0dc..a1650fc81382 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1542,6 +1542,7 @@ xlog_alloc_log(
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
 	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
+	INIT_LIST_HEAD(&log->r_dfops);
 
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index fa3ad1d7b31c..e30c06ec20e3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -407,6 +407,7 @@ struct xlog {
 	long			l_opstate;	/* operational state */
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
+	struct list_head	r_dfops;	/* recovered log intent items */
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a1e18b24971a..b9d2152a2bad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1723,30 +1723,24 @@ xlog_clear_stale_blocks(
  */
 void
 xlog_recover_release_intent(
-	struct xlog		*log,
-	unsigned short		intent_type,
-	uint64_t		intent_id)
+	struct xlog			*log,
+	unsigned short			intent_type,
+	uint64_t			intent_id)
 {
-	struct xfs_ail_cursor	cur;
-	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp = log->l_ailp;
+	struct xfs_defer_pending	*dfp, *n;
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
 
-	spin_lock(&ailp->ail_lock);
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		if (lip->li_type != intent_type)
 			continue;
 		if (!lip->li_ops->iop_match(lip, intent_id))
 			continue;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		break;
-	}
+		ASSERT(xlog_item_is_intent(lip));
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 }
 
 int
@@ -1939,6 +1933,29 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
+/*
+ * Create a deferred work structure for resuming and tracking the progress of a
+ * log intent item that was found during recovery.
+ */
+void
+xlog_recover_intent_item(
+	struct xlog			*log,
+	struct xfs_log_item		*lip,
+	xfs_lsn_t			lsn,
+	unsigned int			dfp_type)
+{
+	ASSERT(xlog_item_is_intent(lip));
+
+	xfs_defer_start_recovery(lip, dfp_type, &log->r_dfops);
+
+	/*
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
+	 */
+	xfs_trans_ail_insert(log->l_ailp, lip, lsn);
+	lip->li_ops->iop_unpin(lip, 0);
+}
+
 STATIC int
 xlog_recover_items_pass2(
 	struct xlog                     *log,
@@ -2533,29 +2550,22 @@ xlog_abort_defer_ops(
  */
 STATIC int
 xlog_recover_process_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
 	LIST_HEAD(capture_list);
-	struct xfs_ail_cursor	cur;
-	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp;
-	int			error = 0;
+	struct xfs_defer_pending	*dfp, *n;
+	int				error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
-	xfs_lsn_t		last_lsn;
-#endif
+	xfs_lsn_t			last_lsn;
 
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-#if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	     lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
-		const struct xfs_item_ops	*ops;
 
-		if (!xlog_item_is_intent(lip))
-			break;
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
+		const struct xfs_item_ops *ops = lip->li_ops;
+
+		ASSERT(xlog_item_is_intent(lip));
 
 		/*
 		 * We should never see a redo item with a LSN higher than
@@ -2573,19 +2583,22 @@ xlog_recover_process_intents(
 		 * The recovery function can free the log item, so we must not
 		 * access lip after it returns.
 		 */
-		spin_unlock(&ailp->ail_lock);
-		ops = lip->li_ops;
 		error = ops->iop_recover(lip, &capture_list);
-		spin_lock(&ailp->ail_lock);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
 					ops->iop_recover);
 			break;
 		}
-	}
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		/*
+		 * XXX: @lip could have been freed, so detach the log item from
+		 * the pending item before freeing the pending item.  This does
+		 * not fix the existing UAF bug that occurs if ->iop_recover
+		 * fails after creating the intent done item.
+		 */
+		dfp->dfp_intent = NULL;
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 	if (error)
 		goto err;
 
@@ -2606,27 +2619,15 @@ xlog_recover_process_intents(
  */
 STATIC void
 xlog_recover_cancel_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
-	struct xfs_log_item	*lip;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp;
-
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (!xlog_item_is_intent(lip))
-			break;
+	struct xfs_defer_pending	*dfp, *n;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
-	}
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		ASSERT(xlog_item_is_intent(dfp->dfp_intent));
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2d4444d61e98..b88cb2e98227 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -696,12 +696,9 @@ xlog_recover_cui_commit_pass2(
 	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
 	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
-	xfs_cui_release(cuip);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			XFS_DEFER_OPS_TYPE_REFCOUNT);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0e0e747028da..c30d4a4a14b2 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -702,12 +702,9 @@ xlog_recover_rui_commit_pass2(
 	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &ruip->rui_item, lsn);
-	xfs_rui_release(ruip);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			XFS_DEFER_OPS_TYPE_RMAP);
 	return 0;
 }
 
-- 
2.39.3

