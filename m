Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B14C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhLNIrI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:08 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53354 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231845AbhLNIrH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:07 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7snM1004121;
        Tue, 14 Dec 2021 08:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gKAmdu110oQ+coPbvgYsIZ/NixdyJ8kWd6ax5XS1/yY=;
 b=MaUEKHjxJ/u7TpF5xicBfLSIjPSu8n+3l1loBrXEQ9EKVx/nstx3y9jAas9ims4e953v
 HT+M7hocjqCRsdCHoybpAeIjjAJrpcF1dB+7bt8kTcfO9Gwrkw6qpk+GwCbt4VgSFhR5
 oZGeHR3Bi++IqC50umelKcKCHbNEA57K8NJmRNTKKU2+2E40hNCCMjDKkfR4iKDjbit6
 f3yVSoIzGziCVt35hQMuFJ41ljxj9890pxDoV6j6iNn2S4dAon85f5sMKWLLPOtlfeYC
 lrP8W129s9Ud5C5OXJJVrQxjgGdsRHnVIWGjHBWal64lgVllSJ47xARoUcqJXvGekhGa FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py336x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f6TH107933;
        Tue, 14 Dec 2021 08:47:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3020.oracle.com with ESMTP id 3cvnepkyra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fh4oQpb/Tm15go2TI/+Gkjvz4AeWjhOiXkCnysfysh1/gTQj+kEvRYH+y8zsp0ZPEQ8S6kBfttWwvn3jCaFRFZ2Do4pAKGfX+Hl0qNizlex4H82j5JNrdQPCBXMx8om0UxMGGpNaEHM8AWQyJp1f7HWI9ketyGgifffI82SfDrgFiOZA1SJOElIfmCf5jTCb9UlihXXMw1W4fN58pnSVU+jFD5d60U46Oo0EWWrHfpuv762z/0BE5cDsUE3P+ALL81Cxr58Ai9Aomr8KAbpM46V4qBQlDeVgMKdkkEun0PufX0nF6VPDzY/48udXI9tg6IY/MIratZpSNZ0qePycaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKAmdu110oQ+coPbvgYsIZ/NixdyJ8kWd6ax5XS1/yY=;
 b=Wb8jtxLGh7dddxLzj384E62qrZqnFlj44Uvag6vERsLdfJaWzDMJoe2JpLHSsjBzOVsRIwcmZrQykMA+HdlGWaKhorMsJptgY70YPAO5M6D2+1DNrewXogQp3e68KFj57AHAkflb1/BwgEzvpJ5tLzX1Un+R93SEOOEkheAYI6Kl5bNpUCU88M/WBc3HMbNOg/X1kzymoOwE6YlgxpKt+Ba+zoZsMfdCb1PsDegtveJYwXULTV2O/OrH6I/f2OjznpqrEiEmvNR7mboHUh86pkyNVf+pzgf+wEyhO2RR3muXSZto+1BYvxYVMtR7Z0coJ0cu+UJJyKkrhMah+uOjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKAmdu110oQ+coPbvgYsIZ/NixdyJ8kWd6ax5XS1/yY=;
 b=NzZDFZEH/6lBNKbsAdFq496HRZiCc6NxBHlgx/dqRhCdDF9v0q05KBj5rklN64rIPDcNsn9EVBcE5vJcTXTevOa5YCUMqxbw0UT1S233hIo3brX6p6lDOR8axzbhD3nsGv+58npuVUJrJ0/T5Kn0XWObuW9Ny4DNmlUViS05oF4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:01 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 03/16] xfs: Use xfs_extnum_t instead of basic data types
Date:   Tue, 14 Dec 2021 14:15:06 +0530
Message-Id: <20211214084519.759272-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d9673ed-3fa9-4623-f588-08d9bede4bcc
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054CBEE3CF6945140F7BEDAF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgnJtnh7SimET7U8cYcnA2GNp56P7FwfCjZ4BbAFiH98j29H29QdSyiNnjjh3nESS3pOrqmjX34RYVkoICXiWQQISrTTITsLHrK8HdfTgfg//YzCHr1+Yyc4FNTdzCEzyghF8BJOzwEb9eeaBanrOqDvJBeuxg8yjvDKN7s/GZ7WP44KfgXX6Dc0QYtzIixPyhriCTe9i/FOk2ewAl697f8TThetnynJke7vO3QdyhMbtFpyogVuC2OHu2LhBsBSpBI6Y1i38DVbvmBgT3dH0KFq/3eIDr1Z4dtgu+XfIPfBLNq88CUaEzM7lYtMoiTNZ9Yi3AMP/b8wontLSISuP/Vf9KVXbsiAxg70WgvAzIMII9IKa41izZue1AZSAGygsDfPiAnVw71bZWwCwD7BqALtQY3feqLI0S8ONhqJ9ow9bsJrDY5Bk+ayu3lV6Z6jL+dS6t4Hrx3v0kmPb6ml6KLI0gFocyPP+CpROAj3euvsAU95SDHmD/YwzL4otpKjkH6hh11wUFRectgBCd0jtcy+A4ywykUByIWbGb3zW5R5Ckr/sTwDGnQ4SdbKpU3KDu/c+VrPK1AlO4DPJcQ9ldmi3iXsptxr+frQkl7nW6XMIcoYZ6IXsSh/a6eYGcCnuaG6UdFJsBaS/LBFzgcFW5qFreuE+52gTxojzmdUqfGGtnpAdo7AHJsdkPy+LnHsW3tR9sKEVRP5+Bhr2uPS/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jfd0ZqMw/hySwbwC7amRoj4errp4ciHQKB+obhbyMg3gRYwFhrkoUVOaymsP?=
 =?us-ascii?Q?yiymuEDnQq1447yvRQq69hXqoWReoL5a0+3QOs7ViZrjksIMm8h9m/6+rhnO?=
 =?us-ascii?Q?W3nKCqQlQFOl9Na6iuMI5ftBb62j7ck5Ae87ceYGh7wTUmH9uj8I0P6t8Vtt?=
 =?us-ascii?Q?tl7Ur9Hs3a0alhnk2ENzCL4pQqSj8qflZrnXHjafvso6bmKAyxjzqvw6g6Y1?=
 =?us-ascii?Q?8yTFvd35bh7RtDlXTDJH5rtjnXQc1pETAd5wJ1Qm+l3Gq4xHi2Q4BEBcNN3s?=
 =?us-ascii?Q?JtjlcBEdHyzlMO64fnh78R3Q6wTYbVd40JgGM6TkX+Vd3Gk8Ydswe6LcPYMm?=
 =?us-ascii?Q?9eQCgee9pA7LnFQ4spmGw+e5cD9NXw0yxMRPkE7TNqfkcypPpOTiiPs92Xkf?=
 =?us-ascii?Q?h9Haue2DE7jb1UfCxYAyKWr5bDtzc8qhEJE7yigTCQ5ke2pRpFip000gUjbb?=
 =?us-ascii?Q?LBNJKFYp2SSRuQYaJ8IqdLu++nT3/cvTpu5Th4JBDdDGw3B6I75aXZ32P701?=
 =?us-ascii?Q?ogB6vYw9kRaSeiBC5NbFbvyJrF51gHPPnUBep5LNCg5LNAH4chq6XNoz3RzQ?=
 =?us-ascii?Q?lzv1uyYcv3G9rZjWbmBAjLGii0EoCBsPYmCduLU4REsHkoARKuu+gaOM4woX?=
 =?us-ascii?Q?/wNlm5NDymAo2nXvVHtoNYZeJbNDy3ndjKbEb0pMo7ZaZiirT1RpQiGJga11?=
 =?us-ascii?Q?L0wS/km/dC9BET1sn4AeOjYKS7nn+0fxr9BiCYSZfdX+kSH1hV1gnHuI79SN?=
 =?us-ascii?Q?UxILU4QLyxqyzVm2+HljjD36VUNV2l7EZpWoE6ea/0kou/SOELmRrGABkLYk?=
 =?us-ascii?Q?mXJYOotPxu61OlG9L07pvhNM/sfUEvHoaVlghy/i7+Cjz6uGL7Rfz+qHQKVL?=
 =?us-ascii?Q?0324o3tEyUWoLVPOt7qRqIgv3DpVSdAWqMgkUM0ikESoGGZsmRB72lBKoGq0?=
 =?us-ascii?Q?4EeX0aDSjFHqxIz6QxFFGfdB+VtbOAVcunjUplVAY4fMpagNIB5tc7z51hhO?=
 =?us-ascii?Q?2BXo2F1OEyVL1H5DLvTaKdCRiiffaMR8RABbN0e5beK6+rjEbVk8CYp+6wcJ?=
 =?us-ascii?Q?lEhRQf7BZNvmiqwP8C4MePS72hdVBf7ulvU/Lv7UEcKtRRRf//jiIb4E8ido?=
 =?us-ascii?Q?U3XxQtsuVyt7WkHo7gv2RLUhY3Dcj3Nd+AKlbUrcrDYK0boSZokoY44swUjV?=
 =?us-ascii?Q?O5xswn346SQHKHyt1q4w2WnEyalK1crbvnVmNikfwy8VXvkdo22AH/nnMpO0?=
 =?us-ascii?Q?gkVYmJ54B+jnGtD/39g5LcBvQeKsGaerPfUlBz/y585SF77Hfk142eabiiHb?=
 =?us-ascii?Q?ka38cjE8JjkThg6o/mPPTDG99ro2gBOu49sqoofAxxxocUdpLjiN36ZIxlPS?=
 =?us-ascii?Q?2EMUy0HQpiGA7thmgp5vXBjZj8fRteJagtQ1T2Saslm0Ms7yFZSIeIQsa65m?=
 =?us-ascii?Q?YNOsNmqupwemD+Xku7O5CMcDz/U5s+ky2xhIulfsOCjBtucekxHieLASFPy9?=
 =?us-ascii?Q?YvRRxncaarUeaHyPwEfPSWnwOt0Z4scqH+2tUEDHlht2U9i4UTSvaIT2mWWe?=
 =?us-ascii?Q?Xd9Ce70jlO/VNOAWoay+ypU+HHhRkgSAelOvJFkjr+t5V0s5ztr76SoydXSR?=
 =?us-ascii?Q?unuvQlUojvDHkjf1AxPD560=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9673ed-3fa9-4623-f588-08d9bede4bcc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:01.6741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HWsw8M9eJP3P/eyn2B/S/ck+cxJYCpX4qEjn8w+5bqSlNlevkbo9oSaRSyMC6RXrydj3KWIOXW2ZUYnMExeRUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: APkfXp35t4fkKwKxNRerWpn5cL9rO7Ns
X-Proofpoint-GUID: APkfXp35t4fkKwKxNRerWpn5cL9rO7Ns
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 75e8e8a97568..6a0da0a2b3fd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e6f9bdc4558f..5c95a5428fc7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e136c29a0ec1..a17c4d87520a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 2405b09d03d0..aefdf8fe1372 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	uint16_t		flags;
 	uint16_t		mode;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..3153db29de40 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2169,7 +2169,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

