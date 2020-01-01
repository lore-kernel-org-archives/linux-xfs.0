Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B350C2D0DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5D4C20718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hDa4QMVR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:05:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46632 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgAABFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:05:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115JgQ089325
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=V9YMukvvnT7Wg3oj0hDG8+2Pq1VzzoXCjVo2zvaG1HE=;
 b=hDa4QMVRiX+V7cqcS9cbK86Gb1ITSwVFyEtzstoE9QYDjGcUu5fx/yYowzyShz9lLclX
 q39KlYh27WSrDp6WiWb1E/a5PX24qhDNGjBtqf3IfwnHrQDli4gTwcqdiaY/J846EAL+
 9WnwkrsT3TBXPe2d44oJR2nTShzU077JX9D8Tqc1v0/DWrKMQKVhIR2XsnipptN9K6eF
 Rj6KGiCbNDOWK0FmT/qwICvHeM8D8q1aTY1QZm3rklqsjUG21yt0ZdotcB+k5OlihrG5
 zMUREdlpiR9DJTP3EX1VaHNyxUolQY4ALSqBT5IwK5tSQWDRQkPfz/BS45nXXsf1b974 QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011594o183756
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrfvxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00115INF026133
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:18 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:05:17 -0800
Subject: [PATCH 05/10] xfs: report dir/attr block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:05:15 -0800
Message-ID: <157784071558.1360095.5833103652518516086.stgit@magnolia>
In-Reply-To: <157784067947.1360095.12276226432994685051.stgit@magnolia>
References: <157784067947.1360095.12276226432994685051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt directory or extended attribute blocks, we
should report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c   |    5 ++++-
 fs/xfs/libxfs/xfs_attr_remote.c |   27 ++++++++++++++++-----------
 fs/xfs/libxfs/xfs_da_btree.c    |   35 ++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2.c        |    5 ++++-
 fs/xfs/libxfs/xfs_dir2_data.c   |    2 ++
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +++
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 +++++++
 fs/xfs/libxfs/xfs_health.h      |    3 +++
 fs/xfs/xfs_attr_inactive.c      |    4 ++++
 fs/xfs/xfs_attr_list.c          |    7 ++++++-
 fs/xfs/xfs_health.c             |   39 +++++++++++++++++++++++++++++++++++++++
 11 files changed, 118 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 7d14589ba8d1..322454aedabd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -27,7 +27,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_dir2.h"
 #include "xfs_log.h"
-
+#include "xfs_health.h"
 
 /*
  * xfs_attr_leaf.c
@@ -2357,6 +2357,7 @@ xfs_attr3_leaf_lookup_int(
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -2376,10 +2377,12 @@ xfs_attr3_leaf_lookup_int(
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a6ef5df42669..ef34d90501a7 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -261,17 +262,18 @@ xfs_attr3_rmt_hdr_set(
  */
 STATIC int
 xfs_attr_rmtval_copyout(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_ino_t	ino,
-	int		*offset,
-	int		*valuelen,
-	uint8_t		**dst)
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*dp,
+	int			*offset,
+	int			*valuelen,
+	uint8_t			**dst)
 {
-	char		*src = bp->b_addr;
-	xfs_daddr_t	bno = bp->b_bn;
-	int		len = BBTOB(bp->b_length);
-	int		blksize = mp->m_attr_geo->blksize;
+	char			*src = bp->b_addr;
+	xfs_ino_t		ino = dp->i_ino;
+	xfs_daddr_t		bno = bp->b_bn;
+	int			len = BBTOB(bp->b_length);
+	int			blksize = mp->m_attr_geo->blksize;
 
 	ASSERT(len >= blksize);
 
@@ -287,6 +289,7 @@ xfs_attr_rmtval_copyout(
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
 					bno, *offset, byte_cnt, ino);
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
 			hdr_size = sizeof(struct xfs_attr3_rmt_hdr);
@@ -405,10 +408,12 @@ xfs_attr_rmtval_get(
 						   mp->m_ddev_targp,
 						   dblkno, dblkcnt, 0, &bp,
 						   &xfs_attr3_rmt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_da_mark_sick(args);
 			if (error)
 				return error;
 
-			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
+			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
 							&offset, &valuelen,
 							&dst);
 			xfs_trans_brelse(args->trans, bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 8c3eafe280ed..90854f161c08 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * xfs_da_btree.c
@@ -334,6 +335,8 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 static int
 xfs_da3_node_set_type(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	int			whichfork,
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -355,6 +358,7 @@ xfs_da3_node_set_type(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp,
 				info, sizeof(*info));
 		xfs_trans_brelse(tp, bp);
+		xfs_dirattr_mark_sick(dp, whichfork);
 		return -EFSCORRUPTED;
 	}
 }
@@ -373,7 +377,7 @@ xfs_da3_node_read(
 			&xfs_da3_node_buf_ops);
 	if (error || !*bpp || !tp)
 		return error;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 int
@@ -400,7 +404,7 @@ xfs_da3_node_read_mapped(
 
 	if (!tp)
 		return 0;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 /*========================================================================
@@ -591,6 +595,7 @@ xfs_da3_split(
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
 			xfs_buf_corruption_error(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -604,6 +609,7 @@ xfs_da3_split(
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
 			xfs_buf_corruption_error(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1625,6 +1631,7 @@ xfs_da3_node_lookup_int(
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
 			xfs_buf_corruption_error(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1640,6 +1647,7 @@ xfs_da3_node_lookup_int(
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
 			xfs_buf_corruption_error(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1648,6 +1656,7 @@ xfs_da3_node_lookup_int(
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
 			xfs_buf_corruption_error(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
@@ -1699,12 +1708,16 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk))
+		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk)) {
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
+		}
 	}
 
-	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0))
+	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
@@ -1722,6 +1735,7 @@ xfs_da3_node_lookup_int(
 			args->blkno = blk->blkno;
 		} else {
 			ASSERT(0);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 		if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
@@ -2286,8 +2300,10 @@ xfs_da3_swap_lastblock(
 	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, lastoff == 0))
+	if (XFS_IS_CORRUPT(mp, lastoff == 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Read the last block in the btree space.
 	 */
@@ -2336,6 +2352,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->forw) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2356,6 +2373,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->back) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2378,6 +2396,7 @@ xfs_da3_swap_lastblock(
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp,
 				   level >= 0 && level != par_hdr.level + 1)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2389,6 +2408,7 @@ xfs_da3_swap_lastblock(
 		     entno++)
 			continue;
 		if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2414,6 +2434,7 @@ xfs_da3_swap_lastblock(
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2423,6 +2444,7 @@ xfs_da3_swap_lastblock(
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2549,6 +2571,7 @@ xfs_dabuf_map(
 invalid_mapping:
 	/* Caller ok with no mapping. */
 	if (XFS_IS_CORRUPT(mp, !(flags & XFS_DABUF_MAP_HOLE_OK))) {
+		xfs_dirattr_mark_sick(dp, whichfork);
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
@@ -2634,6 +2657,8 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error)
 		goto out_free;
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index dd6fcaaea318..e18f248a08a9 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -18,6 +18,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -608,8 +609,10 @@ xfs_dir2_isblock(
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
 	if (XFS_IS_CORRUPT(args->dp->i_mount,
 			   rval != 0 &&
-			   args->dp->i_d.di_size != args->geo->blksize))
+			   args->dp->i_d.di_size != args->geo->blksize)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	*vp = rval;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index b9eba8213180..f167aff266fb 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -1170,6 +1171,7 @@ xfs_dir2_data_use_free(
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
 			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
+	xfs_da_mark_sick(args);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a131b520aac7..9c2443152fa0 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_health.h"
 
 /*
  * Local function declarations.
@@ -1384,8 +1385,10 @@ xfs_dir2_leaf_removename(
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
 		xfs_buf_corruption_error(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
+
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index a0cc5e240306..692db3ed64b2 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Function declarations.
@@ -228,6 +229,7 @@ __xfs_dir3_free_read(
 	if (fa) {
 		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
 		xfs_trans_brelse(tp, *bpp);
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -440,6 +442,7 @@ xfs_dir2_leaf_to_node(
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
 		xfs_buf_corruption_error(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -514,6 +517,7 @@ xfs_dir2_leafn_add(
 	 */
 	if (index < 0) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -733,6 +737,7 @@ xfs_dir2_leafn_lookup_for_addname(
 					   cpu_to_be16(NULLDATAOFF))) {
 				if (curfdb != newfdb)
 					xfs_trans_brelse(tp, curbp);
+				xfs_da_mark_sick(args);
 				return -EFSCORRUPTED;
 			}
 			curfdb = newfdb;
@@ -801,6 +806,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -1736,6 +1742,7 @@ xfs_dir2_node_add_datablk(
 			} else {
 				xfs_alert(mp, " ... fblk is NULL");
 			}
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 8e3247a192c1..b7ffcabf5d81 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -38,6 +38,7 @@ struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
+struct xfs_da_args;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -141,6 +142,8 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
+void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_da_mark_sick(struct xfs_da_args *args);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5ff49523d8ea..0926c18c3e52 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -23,6 +23,7 @@
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -210,6 +211,7 @@ xfs_attr3_node_inactive(
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		xfs_buf_corruption_error(bp);
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -257,6 +259,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			xfs_buf_corruption_error(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
 			error = -EFSCORRUPTED;
@@ -350,6 +353,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		error = -EFSCORRUPTED;
 		xfs_buf_corruption_error(bp);
 		xfs_trans_brelse(*trans, bp);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d37743bdf274..c2e79b537de8 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_attr_shortform_compare(const void *a, const void *b)
@@ -131,6 +132,7 @@ xfs_attr_shortform_list(
 					     context->dp->i_mount, sfe,
 					     sizeof(*sfe));
 			kmem_free(sbuf);
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}
 
@@ -268,8 +270,10 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0))
+		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0)) {
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (expected_level != 0)
@@ -281,6 +285,7 @@ xfs_attr_node_list_lookup(
 out_corruptbuf:
 	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(tp, bp);
+	xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 1f09027c55ad..c1b6e8fb72ec 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -15,6 +15,8 @@
 #include "xfs_trace.h"
 #include "xfs_health.h"
 #include "xfs_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -517,3 +519,40 @@ xfs_btree_mark_sick(
 
 	xfs_agno_mark_sick(cur->bc_mp, cur->bc_private.a.agno, mask);
 }
+
+/*
+ * Record observations of dir/attr btree corruption with the health tracking
+ * system.
+ */
+void
+xfs_dirattr_mark_sick(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	unsigned int		mask;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		mask = XFS_SICK_INO_DIR;
+		break;
+	case XFS_ATTR_FORK:
+		mask = XFS_SICK_INO_XATTR;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_inode_mark_sick(ip, mask);
+}
+
+/*
+ * Record observations of dir/attr btree corruption with the health tracking
+ * system.
+ */
+void
+xfs_da_mark_sick(
+	struct xfs_da_args	*args)
+{
+	xfs_dirattr_mark_sick(args->dp, args->whichfork);
+}

