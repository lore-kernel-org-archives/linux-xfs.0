Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E8BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344391AbiCUFWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344395AbiCUFWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC353B556
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:08 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KIsrEH027768;
        Mon, 21 Mar 2022 05:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gocZ8cPBuLCGMXoH/Yz4evyEOk8q9Id5JVG61dH1xcA=;
 b=cJHl0LcY/ELB6dN6jE4O2xzIcytCi2reo9KXvoR1+BHir63aX+Zt48FSrFpmmSRN81yy
 UuphFKyZ9HWqMukmLw5qqHnEpqZHPXie0hMl91bgIEwS/dB/qwJJuZYRh1yYk+HpCPAP
 p7YgCVXOE2rFNfmyVdUIIFAJRkMx1iljrQbNM8ZeL0Hove6VkJo6qqvkmHI5M0q/Rp7g
 ZvuG/C2YuI8u5ABO/0U7/NsmA79spExoAId1JDPRZwDtJMVoLtz4vbQR7ECv/ZKC3NVL
 ZL6WMh+DOovsO1jAmvzMM8ArOYI8QV1hQFQDYBOSTyvG4cxc4VQUQ0ApVznMgQfCwA1m mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1t4sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KI4e163091;
        Mon, 21 Mar 2022 05:21:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 3ew7009784-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6c9d0J6KM3sidMVQ9QemczTsvC0lwh7ne6rv1uB93ls8hXVtsgatOrkl2ZhzwONqrRRrqCXyGJMwPQaLD82S6m9XXC3foIdugkVobF+66aLOlfT0IBH5RdlEzkwlKkjt+lMXTqXzarOGYsgC00aMQXwHrrGjYyH1JpnueRRBfVGHQwCDNzUNKTgkVaKHZDrtuAPClLK0l/LxPLMDMstoiXi5XvBgTskoXab5uq4opmfv0cswFkJqTRtEdLOnNfaTwWWdVimfWEqCbLfZbZmAY8GlvY/1LyIrm+WIFfc+q6njGbjf9pXrkULF+CNkJrJJ6MlZQt8OPo1cTd1Ev9nmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gocZ8cPBuLCGMXoH/Yz4evyEOk8q9Id5JVG61dH1xcA=;
 b=og4rFSdoVazSkEdyIguh4YmcJj3VvnOowtsUNWVJlz+rFBJRtbgsILd3EeRnGq0SDQDc89Rq1OdxFJwFDTx07zxbdH6VA0GqSE7wFd8h74RRHhN8JU666SUBoRkdxpXSUZq2a6w/jz60GQBHDkWggBK7fooP3T4n4noRoXsKInHST6aG8TaK0PZvYCELeaD+y7otflyA97nVykq4h5CuT/7cIE5lwcpI8hu4KNmB9DyxWWC+7GhyghwM2gMYnOisbZmRrtmdDhL8TszumoC3BF3E1N1E1RWT+erkspcNPvVwhcrxAOizdRHj8DC9vvdHGTYFtVVmx2yie6mNYlqkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gocZ8cPBuLCGMXoH/Yz4evyEOk8q9Id5JVG61dH1xcA=;
 b=I4KEuNUDQrl53+O5QduyF2JHPm0SDiVmXSLvvRF7IaF/UxDEfbijh0joTeSnUu0M//Va2Xm7ZJq1rBx2repCJ00FHpWTTEYu62oAZVlAUpTMvUfZvYqfDjZ7fN31jjnDa42Z+OcdEwGYOPDcbp1JWdV2MsOzCPWw15MI73vhGa4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:21:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 10/18] xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Mon, 21 Mar 2022 10:50:19 +0530
Message-Id: <20220321052027.407099-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 454f2647-3b9e-45c7-0fd3-08da0afa976b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563CFE51D797DBEBF090DB1F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wRwQ3UpZfYhgpAVHDDvIFxStx3vaTaurgCPLnPBax+zcm400yq39/VfN48zAhw/e+pSDU5E3wt5viPb1R6+MrrOU0P9bJTIYIZRxm2jshkO4TXr93XEPlLjAEzlN0yF6t3Rj3WWsMk9Mpwu2EV/nXp4bfwJVm0o2Ea2gPN6ZOZPfAU8DOS0s0ChmpISiYPczLtIA1Rbq4ebzkK6WQypaU7lmFuASHyy0RxBSIytrmFbMXhMdT0stjTQmCaB8dfia7W6h8c8pJ6rHzu4g6xjcF7fKjYI0yqkES4NJiQKp0nGrMWmfw2mw8vmQ1JuU9LtGbiSkTX9uj4cw22pSstCLs0+J8My4e9sDuEZrLyE9GYDH0L7b4Q1ytlFS2IFjV1UI6df34LOSbqbHCDlc6wJsh8hZBgB2HgUzvevIuYS1lT06gz561Pk87p82iPaUv9EJzdWHRfv80nD8WfRkpMtz5G+uiVlqlGeK6Trdcdxclv4qVe/gAaoPN53L2k9BkwE4npC9N+ARmxJQdE4T6K+u745YZwB4OqT2tGsJUi3etO4wnHyjaOe109Kd9/FRcoQcCid2BNMRva8Yjzdz1SrFH5tHe2mExrjIb39JLN6BrdVhtmB+t26tgtLZd8O8ata7R7oYihJ4Rq03oBmz1awGtcQ9l6MpuTpRBatI+Uc9DxCiexBK1NlfoXVTItn8QE1sXPN8uPxUUWN+eB6ub8C2yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NfLKntoG3l6ymRKH5Dv7nx5bZEo3kj0L7+WlvgM9sjif/wy6JhvbYxoeovqX?=
 =?us-ascii?Q?2LV66wm6qEr08i53YDECgOlIaJv8JY8atJnYVVEpr/rA0huLRhItjwr+Vqkb?=
 =?us-ascii?Q?UYJUD2D26cFiYJNiMw2bWjS7s2wXwj9PNazJFhEzpGxpEqRVU+hPIfbRbDEw?=
 =?us-ascii?Q?5B4jXJpJNOVhXxNG8drquXQY4b7cwFNL49+VKWYJqspdQaA6F6/YuI7NCLV6?=
 =?us-ascii?Q?ppV5oB1CEObewm3Zo4vdEzU8cQF9lIygvLAfTURnzROy3P4MYyRBvXaHL/9j?=
 =?us-ascii?Q?eBYca5S8R7uSv2YXz6IBN2qiLheImwNbJ8OwzGIW9aXE9LGpg9IZZDqRaO6w?=
 =?us-ascii?Q?JPOi55+EBYWOtDnvvHkcF0NCBykF+lqkTp+yqc0g5QZH07u+voO0xkzMv3yS?=
 =?us-ascii?Q?VD8vApyipsb/dBUTM1QFsGLjpphshctoAjkf1FciMy7v0nE0SOOkB2ZUa25g?=
 =?us-ascii?Q?b0UYIFK6GtnIA/jtQK3cK+G/530pTIvhG6vFGgJWR/kHGJ4rUWcJD7qsVXlS?=
 =?us-ascii?Q?IbxL22AzGr2fHQlGFtceH8K+xDsp2SbfatRlxx50zcaypfhiWCzZRv8N5WTJ?=
 =?us-ascii?Q?1GNJlC+ipnhMiUNsur+TJXeKTQjNYnKEBkcM3gvGE//RvIKmWt7E+ApICvxB?=
 =?us-ascii?Q?Flj0cbsEnPT8bmfZqXUQZcaQCKRMM/ueZG9ZMoOroyBCZ3XB1Ahaceby3fiE?=
 =?us-ascii?Q?hEyXWwLp0PfQLdqBek+99MkAr9LO4GLQanmeMHaPsRinm+5LEGLlOqgysOQv?=
 =?us-ascii?Q?cNBEIzonK5Jyp8J9GZOHNdKGw6U1HGMgYsXWzoBA+USwAfVZEJtjsUdHRlCA?=
 =?us-ascii?Q?I/mVAo+vTEMy2VgyN/BVS5UWXWeEfKiHon+YL/AU4EXQ6Qqab2H1oA9/Zj4X?=
 =?us-ascii?Q?51cwOgk4IxEBaS2uulzD1iyWcCu15t1be2zGqwBQ9/QLB8sT1TsAL9GHWYbc?=
 =?us-ascii?Q?1WBMvm8n0y2VDlxKb+u2dl5VwWg9WYrWW55hOpmyzHqujV7TRv6kf+bIyKF1?=
 =?us-ascii?Q?Qi42UjgB920ZEcIicC59vwF7zgZS+onbsFGziLkpObyaizNqlkHtsEY1RItX?=
 =?us-ascii?Q?kNRg66GgoI1BvRRXcWpL8qPcWslNcVtfs6lG9b7i2/FXetDQipexjyjGdG+s?=
 =?us-ascii?Q?fr8mpeHvzRi3GhjgYpskXwByHNSWY62Q1xpi/Ac6afJNiJo4/N3XRZk2aI0l?=
 =?us-ascii?Q?o4BgTfPJL9ym/4lTm7J6rSMv4PNgUHvXIDKn+OEAmsTaEN/Z2aRlR9vUyyAC?=
 =?us-ascii?Q?FzLgWOcS1PI4VwRGL4IxWZlbTNKSGpHFaazy1T49p7pZpV2uDKESIrjAXCVo?=
 =?us-ascii?Q?bVEoEbAtQiZo44m3hnrLP6ybj0GvHtDOhmSbar965My7P2Yhh1v4p9gVJJhD?=
 =?us-ascii?Q?B09bwNgErB7bllLSwTWMyHznEoZCSq+f8YDJzxg5+7HwhUu3VNm/7f19h9V8?=
 =?us-ascii?Q?Qqk9L69OGwODFqLX5tWgCq60VcdzsHz/008uvphIIfOGDM/qw8Hiaw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454f2647-3b9e-45c7-0fd3-08da0afa976b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:02.7636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4OVuUCA7d5MB0NQ1VEqcgdqRs0r7yK0jAD0r8yBk0yG+qFh1hvScqL9Cr088/k+WvYex0wwlyfTDETCK5/N8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: JU6Ji97HcssMp2I1ppDkZT6nQldFEeZp
X-Proofpoint-ORIG-GUID: JU6Ji97HcssMp2I1ppDkZT6nQldFEeZp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/inode.c          |  3 +++
 include/xfs_inode.h |  5 +++++
 libxfs/xfs_format.h | 13 +++++++++++--
 libxfs/xfs_ialloc.c |  2 ++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/db/inode.c b/db/inode.c
index 57cc127b..a9e6cc70 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -178,6 +178,9 @@ const field_t	inode_v3_flds[] = {
 	{ "bigtime", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "nrext64", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 08a62d83..b2aa30d0 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -164,6 +164,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index cae7ffd5..7b08e07c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -372,7 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
-#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -991,15 +991,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1007,6 +1009,13 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_large_extent_counts(
+	const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 82d6a3e8..bea943f6 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2767,6 +2767,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_large_extent_counts(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-- 
2.30.2

