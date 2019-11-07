Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2E7FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F0A2077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FxxJsF3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbfKGDDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:03:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:03:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x4DB023964
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nwnhyh8vvlvtxE5emdf03PnRbpyr41t9Ag0z1khGsSg=;
 b=FxxJsF3VrtOZVQc0C2WRCAsV+xwogVs3MkVL9EJGsm0M7DRy1/bw/LhJYvajiqls6Zfd
 m1ZJLBRSvVVs5OvDy0eegvZ9I3dZuLfpAFv0ocvU8XC+oHvlKmZGAWqPa6AHf2jGqamV
 2AdJJlHi8eL1CWyFe8aRFvYtuaYhhxBt28ihKDLMZtzrP40DH5n2QZID3YsoqzktwxTt
 yIKQknJLZzOqpuMRuA+4vx4u2BW73UqZaICGyzwNwnPFnd1eJniT+axQq9mLe3o6/n2U
 i5bSZXG2y0HI2rACXV3QBRC+Cl+4hFO+lXywGvAlzl+IQQHZp1xxpYurYZrRbkPXqQvD Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w0u0pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA733gM1180341
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w41wds6qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA733aJW018228
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:03:36 -0800
Subject: [PATCH 05/10] xfs: report dir/attr block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:03:35 -0800
Message-ID: <157309581515.46704.3352604033299805891.stgit@magnolia>
In-Reply-To: <157309578380.46704.8292405543138526332.stgit@magnolia>
References: <157309578380.46704.8292405543138526332.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
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
 fs/xfs/libxfs/xfs_da_btree.c    |   20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.c        |    2 ++
 fs/xfs/libxfs/xfs_dir2_data.c   |    2 ++
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +++
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 +++++++
 fs/xfs/libxfs/xfs_health.h      |    3 +++
 fs/xfs/xfs_attr_inactive.c      |    4 ++++
 fs/xfs/xfs_attr_list.c          |   13 +++++++++++--
 fs/xfs/xfs_dir2_readdir.c       |    6 +++++-
 fs/xfs/xfs_health.c             |   39 +++++++++++++++++++++++++++++++++++++++
 12 files changed, 116 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index dca8840496ea..78c2bd639fc6 100644
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
@@ -2348,6 +2348,7 @@ xfs_attr3_leaf_lookup_int(
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -2367,10 +2368,12 @@ xfs_attr3_leaf_lookup_int(
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
index ed9e09626204..2845f2da8771 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * xfs_da_btree.c
@@ -310,6 +311,7 @@ xfs_da3_node_read(
 					tp->t_mountp, info, sizeof(*info));
 			xfs_trans_brelse(tp, *bpp);
 			*bpp = NULL;
+			xfs_dirattr_mark_sick(dp, which_fork);
 			return -EFSCORRUPTED;
 		}
 		xfs_trans_buf_set_type(tp, *bpp, type);
@@ -505,6 +507,7 @@ xfs_da3_split(
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
 			xfs_buf_corruption_error(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -518,6 +521,7 @@ xfs_da3_split(
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
 			xfs_buf_corruption_error(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1545,6 +1549,7 @@ xfs_da3_node_lookup_int(
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
 			xfs_buf_corruption_error(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1560,6 +1565,7 @@ xfs_da3_node_lookup_int(
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
 			xfs_buf_corruption_error(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1568,6 +1574,7 @@ xfs_da3_node_lookup_int(
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
 			xfs_buf_corruption_error(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
@@ -1620,11 +1627,13 @@ xfs_da3_node_lookup_int(
 
 		/* We can't point back to the root. */
 		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk)) {
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 	}
 
 	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -1644,6 +1653,7 @@ xfs_da3_node_lookup_int(
 			args->blkno = blk->blkno;
 		} else {
 			ASSERT(0);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 		if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
@@ -2223,6 +2233,7 @@ xfs_da3_swap_lastblock(
 	if (error)
 		return error;
 	if (XFS_IS_CORRUPT(mp, lastoff == 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 	/*
@@ -2272,6 +2283,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 		    be32_to_cpu(sib_info->forw) != last_blkno ||
 		    sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2292,6 +2304,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 		    be32_to_cpu(sib_info->back) != last_blkno ||
 		    sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2314,6 +2327,7 @@ xfs_da3_swap_lastblock(
 		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp,
 		    level >= 0 && level != par_hdr.level + 1)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2325,6 +2339,7 @@ xfs_da3_swap_lastblock(
 		     entno++)
 			continue;
 		if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2350,6 +2365,7 @@ xfs_da3_swap_lastblock(
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2359,6 +2375,7 @@ xfs_da3_swap_lastblock(
 		par_node = par_buf->b_addr;
 		dp->d_ops->node_hdr_from_disk(&par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2576,6 +2593,7 @@ xfs_dabuf_map(
 					irecs[i].br_state);
 			}
 		}
+		xfs_dirattr_mark_sick(dp, whichfork);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2668,6 +2686,8 @@ xfs_da_read_buf(
 	error = xfs_trans_read_buf_map(dp->i_mount, trans,
 					dp->i_mount->m_ddev_targp,
 					mapp, nmap, 0, &bp, ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error)
 		goto out_free;
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 26ddc979d981..0659d3b82796 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -18,6 +18,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -602,6 +603,7 @@ xfs_dir2_isblock(
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
 	if (XFS_IS_CORRUPT(args->dp->i_mount,
 	    rval != 0 && args->dp->i_d.di_size != args->geo->blksize)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 	*vp = rval;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c79be4c3153..9876c34c18c0 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -17,6 +17,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -1145,6 +1146,7 @@ xfs_dir2_data_use_free(
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
 			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
+	xfs_da_mark_sick(args);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 388b5da12228..a2e192a55e58 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_health.h"
 
 /*
  * Local function declarations.
@@ -1345,8 +1346,10 @@ xfs_dir2_leaf_removename(
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
index f6d16cd3004d..227c17058caa 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Function declarations.
@@ -210,6 +211,7 @@ __xfs_dir3_free_read(
 	if (fa) {
 		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
 		xfs_trans_brelse(tp, *bpp);
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -375,6 +377,7 @@ xfs_dir2_leaf_to_node(
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
 		xfs_buf_corruption_error(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -449,6 +452,7 @@ xfs_dir2_leafn_add(
 	 */
 	if (index < 0) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -674,6 +678,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			    bests[fi] == cpu_to_be16(NULLDATAOFF))) {
 				if (curfdb != newfdb)
 					xfs_trans_brelse(tp, curbp);
+				xfs_da_mark_sick(args);
 				return -EFSCORRUPTED;
 			}
 			curfdb = newfdb;
@@ -744,6 +749,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
 		xfs_buf_corruption_error(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -1685,6 +1691,7 @@ xfs_dir2_node_add_datablk(
 			} else {
 				xfs_alert(mp, " ... fblk is NULL");
 			}
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 2049419e9555..d9404cd3d09b 100644
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
index 43ae392992e7..c2f885173343 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -23,6 +23,7 @@
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -211,6 +212,7 @@ xfs_attr3_node_inactive(
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		xfs_buf_corruption_error(bp);
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -260,6 +262,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			xfs_buf_corruption_error(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
 			error = -EFSCORRUPTED;
@@ -344,6 +347,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		error = -EFSCORRUPTED;
 		xfs_buf_corruption_error(bp);
 		xfs_trans_brelse(*trans, bp);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 265207bbef18..b34613a3b1f6 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_attr_shortform_compare(const void *a, const void *b)
@@ -87,8 +88,10 @@ xfs_attr_shortform_list(
 	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-			    !xfs_attr_namecheck(sfe->nameval, sfe->namelen)))
+			    !xfs_attr_namecheck(sfe->nameval, sfe->namelen))) {
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
+			}
 			context->put_listent(context,
 					     sfe->flags,
 					     sfe->nameval,
@@ -130,6 +133,7 @@ xfs_attr_shortform_list(
 					     context->dp->i_mount, sfe,
 					     sizeof(*sfe));
 			kmem_free(sbuf);
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}
 
@@ -179,6 +183,7 @@ xfs_attr_shortform_list(
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
 		    !xfs_attr_namecheck(sbp->name, sbp->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -267,6 +272,7 @@ xfs_attr_node_list_lookup(
 
 		/* We can't point back to the root. */
 		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0)) {
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}
 	}
@@ -280,6 +286,7 @@ xfs_attr_node_list_lookup(
 out_corruptbuf:
 	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(tp, bp);
+	xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -470,8 +477,10 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-		    !xfs_attr_namecheck(name, namelen)))
+		    !xfs_attr_namecheck(name, namelen))) {
+			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
+		}
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
 		if (context->seen_enough)
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 17f883c212f3..56407c982e04 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Directory file type support functions
@@ -117,8 +118,10 @@ xfs_dir2_sf_getdents(
 		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
 		if (XFS_IS_CORRUPT(dp->i_mount,
-		    !xfs_dir2_namecheck(sfep->name, sfep->namelen)))
+		    !xfs_dir2_namecheck(sfep->name, sfep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			return -EFSCORRUPTED;
+		}
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
 			return 0;
@@ -466,6 +469,7 @@ xfs_dir2_leaf_getdents(
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
 		if (XFS_IS_CORRUPT(dp->i_mount,
 		    !xfs_dir2_namecheck(dep->name, dep->namelen))) {
+			xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 			error = -EFSCORRUPTED;
 			break;
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

