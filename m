Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC26B79953
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658290; cv=fail; b=ABjQxrDS/7reHwOihTUIOi4N2pSGs6Nn0MAEqtcyfiFKoLoHJQl6zki7bxuKXtTDxo45NY9VcDyL1gGF+dTebGrQO0QrAJPnySRcRrpeKA0JhHwnCLwhkZskrEqinu1t36P7Z/HeTSYK+6HSUOY/TXA6tGZHIqME/tUAopkq18w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658290; c=relaxed/simple;
	bh=FfGCslGG52T4ySOOOLSL19+i5snGO4w1YfMvs7VtihU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IxfRu1hWQBGwQIN5als2srbUggGQYkppQvVTJcGVigYXF2Mtvh32/ZwVQtXgKkXmtwJQ1001/7Vd3cbKteHt8WHtlg4Dm+w+J4DCDt+o+Kq49TvGm+OuEGUtX/k2414+5tKi9SdnNcnOUv7FSRLwko1ai4XtdAISVgqd8VDlHfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k62lkUyU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SMtpbTYN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k62lkUyU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SMtpbTYN"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxjje030547
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=SpuJ2ko1Ml0rNMMvgSg/q5UB5W9Vmf/u4ej6IV6Vq8s=;
 b=k62lkUyUvna4oL+1Ft3R5QF1Ac6HXbDeVvLn257I3pvoqLzJDD+nsIJIN8wP1Wg5/7GV
 O2b4U5QYsHKz7i+IeixJeylgp2YVDmRUGHsieffsjZiJt9eF4uyvCfCIrKwf1dM9yA78
 sxlzq01LFfsF6ak1xiw+25/3ZxCtBKewh1MbNR0oBIjgXRaEMt1uycy8DIBlnVIiMDjZ
 BPmCxl+mJIfz6bh9JlFMBZ2nKiws+WIu33/pbl2KAPOlxIm0VHmA8/0wDnTr8O0/hMXR
 hqwp3C0qkVBFt9ecBn3YeUS+aBE1V88FakGrdEKdtQmRVX6EOmV/FUPeTQQ7bSnpov2L 5A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0d1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UNH4sT014555
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98010v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbLVHkQ4L0gDDcvwcy25Zf5mA9wARYaizY4Tq8USQ17MTa1o3agsvqLjqjRUsDJa+q/YoZo6idICgrtqIVTkht58fqVwXZon04oUGNkYMsPZBY4s43Xr+LhYj29fro5sak0XzCgjq+IXhQGghIsn3sK05pe+h/9mPES0zsJCIksGTDwsTQPgA+IC7sSz4CBlO21lWgkBCBvzfsPu0mEy9MhQ/Ldsg8wMTyPMfI9uWT+8WxKKSox+iYaiaZFD4Wb9yShUtBvqREtljJQGnT1f5QZmCihH0uCCwsh/YQpel72diwYtlr02L7T1Ii7RjGq0QncpYeFi1MIdxPiKckBHAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpuJ2ko1Ml0rNMMvgSg/q5UB5W9Vmf/u4ej6IV6Vq8s=;
 b=SmxknNIRgeQyeRya6aXDwNlE5SFmvj3+Qn3tzCd7L1jsV81zxZEeds3cmnR6BE4KJsfsb0dYFSoaX9X/Dy1NTGKh1LIqDKLqbWrIW5arT9nMjjCSQjuBMFxSm/y5l03XJsR66lrw3WQj8xCRDuUlBqitrSYmKrIsqRwockC16Vt+1dPSeaoeNePsb/QG+pTyuzTnr+QHn0iyYb7PWtFSQcpG/E0VNbenS/8bCWVNvn3EvWtnpCS0irprVAQvh3lUZGluRYhnQl6a3vyvoU7RmxHQrcW+KZRKMBVbzAU8UgJNXx7/oD4X/BE4Li3Ro+WVaNRpAqx+454JzJ9CeENQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpuJ2ko1Ml0rNMMvgSg/q5UB5W9Vmf/u4ej6IV6Vq8s=;
 b=SMtpbTYNWEowm/YGeEm2wHwd+kExK1eQIInRsN+fzJRrjsrqfDXF2cI+K+WZOR5WxK3z2zvOyKhCh5WQCv4ko9X6r/8sRa+Eoa5xbgw2j/a3yo/9dh/CKWtYF2yFG4RuXO5bDvHYu2gGSeqE6c86uSulEFj3igp7rWViIb23ctg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 11/21] xfs: abort intent items when recovery intents fail
Date: Tue, 30 Jan 2024 15:44:09 -0800
Message-Id: <20240130234419.45896-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0228.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 0039a277-cb64-4980-f382-08dc21ed7011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zE/Ax3XJMn/2qY/PW+M9qPT/t9wu9p/dRPCDWuqRcr+T3u92KPqyuvGfKflOoPZjpISYu2Ve0Mzdu24RWBdrYus44zVD1Dc/5ZMsh/+XEW//xIe5nNMWUp0ryVyof2cSoRfHupxuKDNQBU9r244GZeYGMTTORs0aZTuDxwtbA+M98IfWB2fVp5NxMy2dK7wPMjt0//wihWbaHcz+1wrG+7b/tLg4F6Ta7A40DIk0rGu9l2XspnMj74yyJaNkkhUGoVxtacUFPy3AwLCxC4gsiai5N9JYQimXMwTCrmPxrGl5/7OXe7oBh9/pGnuMLHBnTMiUrgJeRsK+q1vgIykaeMT/aHHZv9oRN6Skk5t+z/M+BYCqZUeLrFgvDl9Otn+SMopiqf0C53T+jjrpsfKiMP8cPLEavYmYILdRBqGh6ejtmX8O2WmAjEqnV58Xae7R/Li1zxmPA/QeTesXRwDhnDCBsSpV7Gk0AaV3KDl3mbKtuiWDFxWBPtDb2xUMD0xW3BrEQJC8eGq+Krm3xzC+5gCDVwNqCc1jG0Jl62BWL5Che/5YCPkdYLa0bYIkUFDb
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wyKr6C3Q0owOObOFWs8xouW8ZF/NwdfHPTPARhftOyetu/AqRkDuDJySYsQ1?=
 =?us-ascii?Q?F2Y0BrrYNbephYyIXkqn3Sj9vZxsZt0qP0PEKVw0MaRNuEkrXwuMUxGiHaxk?=
 =?us-ascii?Q?A/o74WaqlRZuJC+N7S/l8NGGNAwwj9//Q5lsa6em0AVMnGcbzzGeDTEUgxrw?=
 =?us-ascii?Q?JMgEV1R0HE4yCQuQ3Gearow12tw0kuOKlrawUkqsNu0eylYCRrsB5Q7mROMr?=
 =?us-ascii?Q?fR4FdEyUIW3h6y6Y/Wp0yDHlzSRU04Eo3x0bmxZ/g+YMTAqjJcuHtZO8BCtJ?=
 =?us-ascii?Q?yEuUmwFhcJ/pzvkWTwuZNV4gegP6yeMyNp1L3m22bbLUFCTG3hjkj2amz2/M?=
 =?us-ascii?Q?u7U1UkmlWz0je+NyE4d48NXXrf5BpcIoIqW9HFZrzVk6ePFt6eLmcm0fNhs/?=
 =?us-ascii?Q?tJxN/o/aLzqUOOKR1MOkJzctKfSN23VN0uMXVWsAkwHQh6mowvKCpG8jJ4qb?=
 =?us-ascii?Q?Tld9jQs1ijmXst4a5JeSb4RVvHEJvzYUPjqOFVJ3OibflsQZtuoBN/ilmy5h?=
 =?us-ascii?Q?AvX1vxPM3nyDanaxNUqjBgep7CqH8qcU8k4uexcEnGq2f4WfxJFeWXov9FQT?=
 =?us-ascii?Q?rXUkkW0g6i6W7tt74OAXxJ8ygkkEzRLXAnfu5HhzTV989JneQnoKCHkIp3WS?=
 =?us-ascii?Q?VXzZLbXZl3jXmiZyb5+HqbWOePjt2aRkmphXd7fuu3IWSu3pCfzJG0fVUCbk?=
 =?us-ascii?Q?KAGAIxkGJcwXA7gLawNFKytAwaGjvNMZF9fUwPYo3ZkNyj1JirAE2S0Hqdgf?=
 =?us-ascii?Q?uFx0vqUZhBtHIrCh3iBuzTVCOMVMkPTiNucjFSzsFtpl9Nzj9Lzc+tiM+7EY?=
 =?us-ascii?Q?iIr4AKW4JKucHCFGBk9SkvO9Wbi0vqfxiVpPllQHTAwaCwZz1uprkOWVqgtw?=
 =?us-ascii?Q?bPlwUUHB314k3hpJm/9VyEn9ef1W3XtVvlwXS1QRrQ535w/ivRL4c8fZX0Ek?=
 =?us-ascii?Q?h69NV4/ILYh42PNmBrLTBtqsWYBcWZnxhpR7/Hd7td8B2RQNQW/iiQ1GjaA1?=
 =?us-ascii?Q?ZI6YCEcB6ngyRE+lTv0hFLZMoubKeivwQWMhntuZSjzWNNAK95PFSm9tY9mv?=
 =?us-ascii?Q?QekfabcWeuP7Oe8V5DT9JxjWRJPWE3+cHb6ExBqdffIY7sgQ9+gKUMLAg1nb?=
 =?us-ascii?Q?kANEFwxi5bq74aXg9JUC4qKiVVtjVK8U6zt3yg6X+NQZIHrCirbwC5731Tds?=
 =?us-ascii?Q?O/DqVIwEQXAQ7j2nyS46e8ct3Q8NiPvhTN+6rDRv9qHE3vCLRtRgZXZlpYck?=
 =?us-ascii?Q?mheZosZdzlGuJMc5aCrL1gU8Hg775l7mPYYRUjaKqn8AklOGOGFlq4FS/h+N?=
 =?us-ascii?Q?s12W9DRSekJI37QwUT7sfTlttt4+ptHayut2qkUp+Ck8GTPeZ58GDdb7Dyaw?=
 =?us-ascii?Q?1RcHGoHQGeJRJX52NhTkzQRKKVOtFTy1emvf1MpU6a1cYFxmTp8FKBgv60mi?=
 =?us-ascii?Q?xX4LUTmILTM7USKvSv5a4ljSQTBN2+j1wA/H0L2DtJ9ZxudJWA5rzibvw8nu?=
 =?us-ascii?Q?l/b0WtaSY4NGvIqefSmkSjgp3m/bqmljB+laX9UKCkRNaZm48J8WztgOeRAb?=
 =?us-ascii?Q?teVta8kWxK2LDJi/XxaiB2M2KEie3wYKjwDuNt2mn/vwJS3JOckSVbCHnikU?=
 =?us-ascii?Q?T1rTb8ZR0+8IgIuY3qY9lOuu+XAJIiXSEi4XlWwgFmtTh68MlgKOmKNIMl3g?=
 =?us-ascii?Q?//c4Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jg9UBRImCzrwKEJ5fM1ItR2AEaGRi6+FuucxSgwj1ZnSeXVBI4a+TQb80pN7CXM5UFPUr3K4J2YommhuckmUPzR/h787vwZe3NLZW6Mci8JJo9rWvFbBVUbIRv2hpq/om9btXSGxo6m/m+gUlLKzABNWVF0sLtrofPidUmml9u0uNv37mz8hyjDxSLvv5+FMfGqZ/PMhgI8l4mRaowMIhU8Xpr/LSyMgBiNj8ErgZdzqKaBCGatR9RfkgPFyGyENwuKFq+WRrkWo83CEHP/QuC4mkgLoAdlxZfex8azrR/HwM0OERc+ycxnLSx0o33tPguQnaIcF7gEEs35YMOtnKsck3zBNXcQvtJNTL6Roy9shY+i1Y2gJQeF9GcTw4dvPu08rF6JQgBxT2dNkBcr4lsSJsiqn48Ug3YzTjYGNc10TRvp8+ycz7lslzCcuz1AcqqhZtKozd+yqF4QZITynowtgXtxdcIP6G+WRdOW4Frm+jJ2IuXwxCxL5ZT/CVMSGmXK9CM1QV7w+o7U9+vmkYYyg/imekm01sCw6UBLK6LYVcpHtDI9rXP7jV/VXWdBvV977onOCWpAwbq0clCw/7oB4Kcd+isrtJHeNoxXt2Ho=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0039a277-cb64-4980-f382-08dc21ed7011
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:45.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFFsY413/KqLBUZ1LhpZwJ9GplLt8plL0UV9R55sPklxb5O2/NsTuOZd7sF0E72ZCH1b6oUBws61n7BpTXA81bw8OXlP1RLWpOM+wLZB5H4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: oKgbEIK80MCDjKA5TQEmIbSgwuiodK3U
X-Proofpoint-ORIG-GUID: oKgbEIK80MCDjKA5TQEmIbSgwuiodK3U

From: Long Li <leo.lilong@huawei.com>

commit f8f9d952e42dd49ae534f61f2fa7ca0876cb9848 upstream.

When recovering intents, we capture newly created intent items as part of
committing recovered intent items.  If intent recovery fails at a later
point, we forget to remove those newly created intent items from the AIL
and hang:

    [root@localhost ~]# cat /proc/539/stack
    [<0>] xfs_ail_push_all_sync+0x174/0x230
    [<0>] xfs_unmount_flush_inodes+0x8d/0xd0
    [<0>] xfs_mountfs+0x15f7/0x1e70
    [<0>] xfs_fs_fill_super+0x10ec/0x1b20
    [<0>] get_tree_bdev+0x3c8/0x730
    [<0>] vfs_get_tree+0x89/0x2c0
    [<0>] path_mount+0xecf/0x1800
    [<0>] do_mount+0xf3/0x110
    [<0>] __x64_sys_mount+0x154/0x1f0
    [<0>] do_syscall_64+0x39/0x80
    [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

When newly created intent items fail to commit via transaction, intent
recovery hasn't created done items for these newly created intent items,
so the capture structure is the sole owner of the captured intent items.
We must release them explicitly or else they leak:

unreferenced object 0xffff888016719108 (size 432):
  comm "mount", pid 529, jiffies 4294706839 (age 144.463s)
  hex dump (first 32 bytes):
    08 91 71 16 80 88 ff ff 08 91 71 16 80 88 ff ff  ..q.......q.....
    18 91 71 16 80 88 ff ff 18 91 71 16 80 88 ff ff  ..q.......q.....
  backtrace:
    [<ffffffff8230c68f>] xfs_efi_init+0x18f/0x1d0
    [<ffffffff8230c720>] xfs_extent_free_create_intent+0x50/0x150
    [<ffffffff821b671a>] xfs_defer_create_intents+0x16a/0x340
    [<ffffffff821bac3e>] xfs_defer_ops_capture_and_commit+0x8e/0xad0
    [<ffffffff82322bb9>] xfs_cui_item_recover+0x819/0x980
    [<ffffffff823289b6>] xlog_recover_process_intents+0x246/0xb70
    [<ffffffff8233249a>] xlog_recover_finish+0x8a/0x9a0
    [<ffffffff822eeafb>] xfs_log_mount_finish+0x2bb/0x4a0
    [<ffffffff822c0f4f>] xfs_mountfs+0x14bf/0x1e70
    [<ffffffff822d1f80>] xfs_fs_fill_super+0x10d0/0x1b20
    [<ffffffff81a21fa2>] get_tree_bdev+0x3d2/0x6d0
    [<ffffffff81a1ee09>] vfs_get_tree+0x89/0x2c0
    [<ffffffff81a9f35f>] path_mount+0xecf/0x1800
    [<ffffffff81a9fd83>] do_mount+0xf3/0x110
    [<ffffffff81aa00e4>] __x64_sys_mount+0x154/0x1f0
    [<ffffffff83968739>] do_syscall_64+0x39/0x80

Fix the problem above by abort intent items that don't have a done item
when recovery intents fail.

Fixes: e6fff81e4870 ("xfs: proper replay of deferred ops queued during log recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 5 +++--
 fs/xfs/libxfs/xfs_defer.h | 2 +-
 fs/xfs/xfs_log_recover.c  | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 88388e12f8e7..f71679ce23b9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -763,12 +763,13 @@ xfs_defer_ops_capture(
 
 /* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_ops_capture_free(
+xfs_defer_ops_capture_abort(
 	struct xfs_mount		*mp,
 	struct xfs_defer_capture	*dfc)
 {
 	unsigned short			i;
 
+	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
@@ -809,7 +810,7 @@ xfs_defer_ops_capture_and_commit(
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 		return error;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..8788ad5f6a73 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -121,7 +121,7 @@ int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
 		struct list_head *capture_list);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
 		struct xfs_defer_resources *dres);
-void xfs_defer_ops_capture_free(struct xfs_mount *mp,
+void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13b94d2e605b..a1e18b24971a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2511,7 +2511,7 @@ xlog_abort_defer_ops(
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 	}
 }
 
-- 
2.39.3

