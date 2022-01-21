Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C45EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiAUFT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:56 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58006 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbiAUFT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L042lZ017774;
        Fri, 21 Jan 2022 05:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=q39737gsC3QYFuDpHX64S9UR73mdulO0VNCkjKd4fJc=;
 b=cogesHc54ibjuDZatYRrrZnzJIY38SEuj7yfdO5p9DRF4vtcUwQ0ba0t2MNojbWAUP4R
 Zg4A6rQrfJ2qg+Z52c3U6URtFpebTyak4nkblbpvMwWchdZEVkffDMkfMtQGbdkJ+GEm
 vBf6yPPS4FVs2t/VeeFux6xaQAePDSFvJvkd1IRNg1FHwFOoaEfL/k/Us5lnU0n5x7Kd
 V2lrqI8mm/tgQRlVvGu1YjDjRblvk9+/NmIgA4CPjsohQDPYGGmNlq8MUSO2OSKrQrxc
 RaxZPJCEAKpzXY72Bj/k+7wgGnRRZjPKh0bdYFNArDCgpX0L3M/5Ae4PPBfNdzLNiqCG 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GUIN190228;
        Fri, 21 Jan 2022 05:19:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh06j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MN9RWdfp1obvghk9WcV/1F0g5ZffPNuZWGr0RW+lfWCG01uV7HkbI0zbwRYkY4yL7E1m5Biu8sRHO73w6pw2trQi4/EpxkFGRuPkdxdjGMFjoFFoOJCZnhi7c1fm4t+OtgdxmlzwSAzE0JsGJqMCd3WQppksPU/RC1ZtSprFrp3hjwGEGlzk+J+aDtUHUsjEwe6kjl69ZmdEg0n/9I1L1KsxR25/4SUh22lxS8I0Tur1j8rONiI8MbZAcOP0Ybx6B/Hpdes8tPeMUcu7f2NYxPTHfBl4krdBF73llABpNjgXFQGbLa1qOZxeuW90MWhxm/7xwLixK47TGUgvg1tNig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q39737gsC3QYFuDpHX64S9UR73mdulO0VNCkjKd4fJc=;
 b=kvyVOrw36GNbRBO9BZuOfyduvk6L/P9JJl4cb+Ufw1vDcb6wP/W9ZG9svKfgUF1i61YJ9VdfJgA0pJHj5Tz0KEpympU2mJP8PeV4fbbIcNjFnbzGCBhB48nRJzIEXv0DrsUo9HRnUVVa8a3g2cQBEIhyuFJXxO8h8G2JyTHU0G4KdEBFBL1LqBZEQV2AE13sIlLm25glCy5piplv6Nyt7YoQFn5r2hdQ+7Fn7Mb5roWi0rNn3CEbG1DIByygbvafTcG1gR0LKbs0QM+U53QVpBpvm6JmA/2m+YEqcM7vu9UCo4gt/S1YTvJy8z0VfjL4msVjgTsJV6L2KvJs1B/a4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q39737gsC3QYFuDpHX64S9UR73mdulO0VNCkjKd4fJc=;
 b=M3YrzcAbvVCnfCtYyVDxxt9MTj3VPt2jYaf/pqv+9rxpaYVVPIvzEMGIyL2cdS4w6+PP0wZAq7IPCszKF9kCKC9dZX+8CStlJ5sRn6LNldLFT9/SXfxdse225R4LOx9dxrRFua/TIaDuB/VfllW/ZcZTbZJeHurbPvEtY/fAvzs=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:19:51 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 11/16] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Fri, 21 Jan 2022 10:48:52 +0530
Message-Id: <20220121051857.221105-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a971b841-8e2e-422b-4d53-08d9dc9da64d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287CCC59BE4601F166F9673F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Gk3GPptTSQdf/nwJG5qpMBrOndOvgIS/aZKrOcmfnJBETWU0yUNCasXrraLDVdm3QzOKjog41v5GsaMtJhgEK/SQxCoGdKPAL0CEDsrhXJpYzzyAgnP3tEQvNu/4c2SgpOXZITgnzpbFlzd2ZeW2/bvuBdBDihMP8DaX/NIvh190lJ/iegQb5kV8e6kT9NazjxpWakw4tuhuc6OQtjrFGeZ2/uUI2AGODL5bHh6L8/9KjKjQlJqsABPHe0N3b2lxEILOOZn3GD2SWSb71IOQzjBNxUr5v4K9eh9y2FN26MzV6zylj+ERszwn3tcazJzvWKMB7lNHawdH3Zdq9JWWDOQO/38tgZncGFycxrRckpkKar1X1JnswgCtBMArlFL3qTcEUej7sD08CN4cQzdGQ4JDrafTYBzeWHR/VndAEUcpGfMHwXfmGMHSSpOkwjPVR6b1T+frQNW8THn45oaINX1nZeO3y1X488ZPKYKSZWZKmQ+uA+p6/RTpVM7OwPn5C1PLlo9r9IrX4CW71ozoZgS+wev9JmZlO27m6QrovDqdnrNFlAEJFM6njGU/eTq9QCY8XFLzQhmdjFzuNmBdlD+jESVo2gKMtVRUtcM7h0naalTgw9w5tV9CEnaUgden40nhcm5qneTa0x23SgKZWZIYTXjgJIE9mRjU52aSk82TlZiIBoNneJ0pyDvlLhn8oHxE78r2eFXvrZezOcg/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E0yGsX7yp63T5FgNgrthpewQIqTeH9n7eeFlrqZLf/PP03nYPi7RSiVup285?=
 =?us-ascii?Q?x0sjiy37I+FdMR1IQq/o0fztBd6096XA5bdBZj0q/lJJmoAstinoYrIyQlQT?=
 =?us-ascii?Q?B7KERlkC6rztrXC/P8VSjxkywArO3k7DY/74twOv1CmeJv/O2eTjECERsn72?=
 =?us-ascii?Q?nQGIZhTRJq6PYxkt5W+hkujcisLaoqynoMzDkl2C2kiNO+eaunxc7n9ayLpC?=
 =?us-ascii?Q?v6saI2KyM3LyZge7b6n4GXjuNFcjBVR+QzhiHUhvV+TJyXUoX++WnPCvt/Xs?=
 =?us-ascii?Q?vcRVdNH5OizEOqF9ipH/seQwBC29UIOwc9SbNXGS4CBIWXVgU3sDtDPxaDgW?=
 =?us-ascii?Q?jntqThxPqAaJln3/hUI6aS0wEWtPQH99az2hH2EMUopGfACmcBe328iC0Bn6?=
 =?us-ascii?Q?0evj/ohdln4xPqUKCHu/UoqPnEHGjIFAJpsitKypkOm4N259bk0zTPekyhRy?=
 =?us-ascii?Q?Ytm+utPNPRPklIhTzR/TOZZTaq3gwcJpfAg63M2HJYvsn4K6BwhzB3+7u0m0?=
 =?us-ascii?Q?9la2b+SweKrFVAIMClIGh3w/SblAquVOD5TbOf8S7SV8BNz0YC+D0W6uhebN?=
 =?us-ascii?Q?NO2hrTeF2hRE16L6EQB1Qyugs86CnniHz95HG0+kTY+ZCOHGYRgIQxCGGePd?=
 =?us-ascii?Q?4FWjcu5KZnnQ/zLygggaI+GfxhlO6Nm+K3856UAkXUyjJQSKlb8q7H+qtmP0?=
 =?us-ascii?Q?GZN5/TYe9Jz7HnyEe91pzDxfFin5JEj2w8SQ/37if3nNsFF3rXeuov3UGkAq?=
 =?us-ascii?Q?jjNmEM+sQ2R9gH5a/AhkfkpoygYZ/lBWbCLmSWd/CxuYhPUleKReWmxKMatf?=
 =?us-ascii?Q?krhrkloWZZyiTUw4JKtDv0XotWpkGeYFKczt4K2GtQH5vf9Wi6m6bnlcNVly?=
 =?us-ascii?Q?BMKykZ5yj9VBTqsDB1yJMSZpS9seosFXDsIthWyfgou2Dsg2pcfeccOWGr2A?=
 =?us-ascii?Q?ozWB8QSbJSgTj7VyZzgKax8n4xwmKvQ2YpRI8hIKUaUznSUr42/gUdVsbSB/?=
 =?us-ascii?Q?pkSTZ5UwPN5reTi/cs3bLCynxovJEOEdn4GT22UeEE1Y2qAu+sn3wkEikGSs?=
 =?us-ascii?Q?rGBTepJj3Zm7eCTKyS2Oe4/7kyp0W6Ild+o4/JNy4FOPIw9UWP8LgkAlPGNQ?=
 =?us-ascii?Q?wJVSQY2y6R272mJVFaW4ilWV+w74isOTUBeufIxJ/2rcpj+C41gqSQmX51Xs?=
 =?us-ascii?Q?sxs5ekUxsf0pJlbZEDu+dKypQVXmZy3DoSYADQLMyyVVSd9Zge1DQ3YTOzts?=
 =?us-ascii?Q?Wbgk8sRjH96YFPAJ+O7GP7CS8DUpMsfh3PHw0BnYRwAUho5f6kVYLqb/XwZd?=
 =?us-ascii?Q?/Tb4q8XCZ39WBWQSlmFVAXXB4wsRJNvXnnZYexWqS5CPj+gzlcRQ5MFOsFqI?=
 =?us-ascii?Q?c8nPHgreeSBxHFWCGM6HABn+l2SsV3DONdlli7VoP2/7dtn7yqmfqtFTqLkQ?=
 =?us-ascii?Q?h6gaax4seSuJfiFWF5C+uorR7Bp7VIhEjUMGyWzRoAtGjippyIuyXXHyZNP6?=
 =?us-ascii?Q?f+nc22uCgdRHEkxbsvskGYg2wu87Ne79mZ2LPid/QK7teFY4utr9pwiGlaWW?=
 =?us-ascii?Q?77f5YgeesyM3U5I+L7BOf6hl1beqL0qdPGBsEN+07DD0cvn51a3wBTW650Hf?=
 =?us-ascii?Q?Bpu3+1H39wxj0baGVqp0Ou8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a971b841-8e2e-422b-4d53-08d9dc9da64d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:51.0664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUvP1uw+ZyTydR6wtMVVVQXNZqfVyNb8X0pnGxoDRK0i0dbvr4zjsI7p9EnFhg+Raw9yroFkO3FUX0Sq5U0uCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: kIacoMeAU8qYi-NcsVCxojBvEY2hK9Bc
X-Proofpoint-GUID: kIacoMeAU8qYi-NcsVCxojBvEY2hK9Bc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_format.h     | 20 ++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 6 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1948af000c97..384532aac60a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
@@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..e8d21d69b9ff 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9934c320bf01..d3dfd45c39e0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,10 +872,22 @@ enum xfs_dinode_fmt {
 
 /*
  * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+ *
+ * The newly introduced data fork extent counter is a 64-bit field. However, the
+ * maximum number of extents in a file is limited to 2^54 extents (assuming one
+ * blocks per extent) by the 54-bit wide startoff field of an extent record.
+ *
+ * A further limitation applies as shown below,
+ * 2^63 (max file size) / 64k (max block size) = 2^47
+ *
+ * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
+ * 2^48 was chosen as the maximum data fork extent count.
+ */
+#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
+#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
+#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1)) /* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 860d32816909..34f360a38603 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ce690abe5dce..a3a3b54f9c55 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..e56803436c61 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_nrext64,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_nrext64 ? XFS_MAX_EXTCNT_DATA_FORK
+			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+	case XFS_ATTR_FORK:
+		return has_nrext64 ? XFS_MAX_EXTCNT_ATTR_FORK
+			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

