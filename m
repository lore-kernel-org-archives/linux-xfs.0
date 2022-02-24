Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B76C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiBXND3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBXND2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6898420DB21
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:56 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYR9Y023280;
        Thu, 24 Feb 2022 13:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qGY+q+M1B3ote7wFWawZmN2dTASqaiTz5oj5r5FWE4A=;
 b=ugExdb2YuR97Y6/AH7HMGAxfXEO/i958ZP0EAcXAkvegXUav7Nkk0hpFWkhXByyLYW/t
 6CUbzOikjHr+nS21wpMD7gVC+EMjqRKsm1VBlXNcGlaNIiiCLNdzuR0nLxmXIHz7cgxq
 AlCZitUUXdScBzgxj2Rp6JDiylI0pswmqsNU+BacfH+I3EjUlHm9fqlelZndQBaempxI
 6DzXaIjrrBNukG7BIDSTtwe8eEeIbywY1SpKLYEOrVPE6XNn/JVPku5CU7LEQKpzBDvs
 W95YpvnVVx3MToVUwatmvt7B0Aps4MVgWaf2VidKm0ds3cLIv9C9fKzXySbPuLY5V0Xw zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wJf002434;
        Thu, 24 Feb 2022 13:02:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3eapkk41jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF13lUNVmyrUU3IWiFYHkAB6CNfFnbxIU01UHTaVP5kmfPOUsQZ3kuYhNslLz1OXxjgFmJW/DHEwBiU4qTbJu08cBs7FSAQe+OA7sbi2vs+smaiXuZ/1efkWgawYEsRw/N8X1uC+qVjMJ2Q5eUElK5j455eovvCMAok8bwX22na6R9b27sDiwOYilR5hD5RbOgPQdPhWt5LRxUBU6h1/zZBWoL8aogZt5TZDkiA9tcBn7/PDjSsaPVpJ1XCjfs41ox0iOQTXpLNGxET4/BvnqrgpECmdhD3cYAKoM+aAWkjBtIDxChKBUcxadFV5ckozcOLbPZlFPJEIyFJLwcQKYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGY+q+M1B3ote7wFWawZmN2dTASqaiTz5oj5r5FWE4A=;
 b=ZtTijIWDkYTvMGwxhCVqrovOmZJKz5Nmxrtr7LNaRJTr1Ic5pOVUMyn9xPDNw3SpRtTzXxBMlQz709obUU61IgjiGorBEiggAVA6/Qj4Jum/wyaf9nHnzKhCrbb8x28UpQKgo1DU5/WfjQXWZDDEoKi6N/upOQJi2BKxbkL/l7ZusxZFAVKD1/QX0c8fFBwDW9pZNdn5V2jkyb5PN5hz5CpgCKvxy34ER3nnpSTPFABlPfIg5mK9PI01BQt3WwzZ2qAqSW3iaZD4hX/OXLQL5RoaX+SALzDqIswAPRcDjBD0zt6hauBCsdw20jhslM1ZmNBfowt4HOtuvNCUeh+WBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGY+q+M1B3ote7wFWawZmN2dTASqaiTz5oj5r5FWE4A=;
 b=iGbYRcjw4+5yJhMkfeeUPugD11TtxI/BOGvDsFIWJq+FAIkI3f8km+d/h1iIfK1Bj5jJb5T1X0jypbAavz8iJjbND3zzt0uIJw05nhG1bPYu9m3oylpg+VaS/AckF60aRSlqEwIDJM9o+LHA4qV3iTJi1TsEhCUzp0sWiW4oTHo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:48 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V6 06/17] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Thu, 24 Feb 2022 18:32:00 +0530
Message-Id: <20220224130211.1346088-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8f22df3-d5bd-4f2e-5713-08d9f795f52d
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB36650E8F19782F0245F1AA72F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /H+a8TZ5UU/ddtQQbvRr0rlZr86FoP7YURHD1bhBxxiGFU/9ATdg57zvpQ1UBYFYMBGemZ6GBeCANHClFIhG2kxuQJXL1vGMLVds0umeQR2o++nArz5CjU1hM985ZULcQM8umzj6GceReEiY6DgMz43O0QcM9e+wdWFgq4EQ+WmLiorfxZcNZJBvQEMd8fQ7NjJ36YQG68ZGgSFLH8Tk2RlJ9EOwLNgjTMXpnCKaIZq7RMzOf2fmFIppKs2CvU5E1F84r48Lqrmkzs+e5INwXMyEbslAgywcBgWJ4ZJkH0vk7jB9TLm9l8ZoOGxVEFFzwA6blLSb5yXd/pURJ6tyfG68x94eQR3IWtRgHACtD3Vs9lQe68qsCqcLCLseLeAfaDw0PWkU7IhHEfXJjS1MBZsKHww0L9S+2mRy5tNQbX2HEtVWpWOTN/e/HnCs86jHKiZbwOz7/f9GmoN8VJ/FaXN024T+8hsoKsA+UL89KYQHDwjmzcZMIWpo/IcJchiMLnwkpkXoiJPWL7pye/lY4VZlry8Ci5lskkparq//DpuFUMBnkb9pzS7a7nuZTMyNEQITzLc9tY2qzW0noisHzfjIU3rPnvEIE6rnGNSPiqNWgZnBwROQjVZjtxNyLynfV5Gfd7smd6uwnfpSBZuGlII1beOwxz7n2bwrXpmq656S39lBfEZAUJu8mCJoQ3z54F3z+vlZ9n+H/og/LiLNKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TGVRzSxK/k6BTgKGWwTNyzVqYJFtr1WWII3cufuJVcTVQGhW5SnGv91givhH?=
 =?us-ascii?Q?LpPbqTqxbUpJJc61YOy27EUsvz56HLr3l2D8HRwyWOXpIxHv+YLXtOsjtp54?=
 =?us-ascii?Q?tSC7gsFD59L/PfBsBeldraoKyjM6XvMAmwwg5qIEcvclZwJgCyJZEfnmrWk+?=
 =?us-ascii?Q?YjZ0YURqrDdgNbdcnO89zTP2iVMEBxN3nPg10MsqyOfO+rszHDwLI/ZT9vPe?=
 =?us-ascii?Q?9yeGDbU/46k6QyzPu+qP2eBbSYDQfkHhllwsDIIlyoEi2M2YQgJXE9Yq44L+?=
 =?us-ascii?Q?g+gwKu9wRUJQNWLk68vVjEpLU9p7xtNjEV10ptInhOS8sIjLRX9wq5u1XwLj?=
 =?us-ascii?Q?Tw96BGkk9VdBbWT34k80CcRHw0pPPG197n3nl8emD9HXGOeCVj19lgyt/74v?=
 =?us-ascii?Q?BXzO29eNh1ggb4v2noVeEz/4jPXboS56CIFleNK0r5Qx/zDcyh1xnQHCZCqM?=
 =?us-ascii?Q?q/QkrUiNrOIJ2lzVcghcqzOeWcimxsIDRvpYvXpAhWNFjpBD1jbzFEl8/1/g?=
 =?us-ascii?Q?m3izHS53F1DJODsAZFTCLyoyxebYXXrBt1GsaRcpROVrQti2zb0QABCAAUK1?=
 =?us-ascii?Q?vNosxYZzu3bTAFPE2VH3uYUQAsR6bN39fcumKY9pXQgGaBeh/znhi+O7P3Fg?=
 =?us-ascii?Q?e7Se+RJEcDS9cN8xSmnDOqH8g5U6DYkOXpvcYAHaj0K+jzWvQufYELvDHszQ?=
 =?us-ascii?Q?3ZeKwoAoGKy3R8FQK1uaXzhjttRNaW8hOhZDb/GuRjXVx3dYGsS3+Vb2uIXw?=
 =?us-ascii?Q?CaN7KvyW0sr7dCCByE+aQG29m1SEgEXvOlnfT9/uroPZ9OOGNlkbPKQoAJX8?=
 =?us-ascii?Q?7JDuuViRpdI9sDjYgr+7xLLeQ7Kiqn7k42kz3acr2TGmLDxK+aAl6tc45aQ/?=
 =?us-ascii?Q?GZGD6CdxsSeWxcUyi7/WpGuR6S86Y9ya15gRwKcIqnVGgQ97VR6FE1AfrIkS?=
 =?us-ascii?Q?JAthEVDer9MiG3EiXg4xKkEVZa1dXntKgLdcJLTkpdgQogRizIDx0cLu5aef?=
 =?us-ascii?Q?+Q3brJhg3jsxSHQtw9su6MJlzUDQe5vlLFoGgZqhE9rQ91MtPbXra7l4QONb?=
 =?us-ascii?Q?oNRt8zT7ldRjnsBsk0nTTkn8vJoLM7IYtDnmxvy60NFNhjEtIk1EXV2FpCtA?=
 =?us-ascii?Q?z7dBmDCT2hbTXJJRu3Z4HzJ1wIKpjq3ikcQo7ROCZp0AFsE+14nCzUpkPLal?=
 =?us-ascii?Q?3VX4XWNuL9e+g3rXbTY7+C7uzxcDYppEEavM6/o7YVUmfm6MKnxooXe77npE?=
 =?us-ascii?Q?qnMSU9HmH8M8DKT89nnLa/wmXnN6oraue7hPxXgGBkzP84P9sPChq0uGkwxM?=
 =?us-ascii?Q?cBwqLyR4m2mql/QuVckGDD+J6vRzqGYntZcBOnAuoiP6P0ciO2zWhvhquFTZ?=
 =?us-ascii?Q?f2FZp9zdAhLmXAI2G5fFS3H7+QMuOvavtfcQDs9eO27lpTOvvEx5IgAhkDI5?=
 =?us-ascii?Q?/R9aoq2CayIM48R0hdmvyJhpYRHvrmNaOnLZy7QRjl1Fs85xs+Dg7Tl1yfg5?=
 =?us-ascii?Q?O+C8IKHEGb0bSnFIcacuy37qPsJTEePXiXAHvPuRKupnQXwURdI3erLjwBXD?=
 =?us-ascii?Q?e8knN5iJ3H5t36LmXNo9QHYWR35OHQFDzv8kCyVXtxOIcbiS2uGEHw9i/4cH?=
 =?us-ascii?Q?gsT2dIhMMWO40xiv79q4ayE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f22df3-d5bd-4f2e-5713-08d9f795f52d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:48.7742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRMQKrUGtXu5lmAqUgGwoUbBxnSWe7wTuvC0IxvMkRPSwk4lxkd9wMGrteBalkLN/CguNldITJtL9l9H/cirJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: vwmHdcdSR8G7TEBvf9po4_DF_5ynCdg6
X-Proofpoint-ORIG-GUID: vwmHdcdSR8G7TEBvf9po4_DF_5ynCdg6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 98541be873d8..9df98339a43a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
+	maxblocks = howmany_64(maxleafents, minleafrecs);
 	for (level = 1; maxblocks > 1; level++) {
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
@@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 829739e249b6..ce690abe5dce 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -117,7 +117,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7ed2ecb51bca..4a8b77d425df 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 794a54cbd0de..373f64a492a4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04bf467b1090..6810c4feaa45 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3495,8 +3495,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3153db29de40..6b4a7f197308 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.30.2

