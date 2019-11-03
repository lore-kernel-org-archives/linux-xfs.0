Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C8ACA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66362190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VjGlH361"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfKCWYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfKCWYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MODN1086398
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ikD1M8wupUP35BYOIGGP7IBZIR/fkfuZa0eFHWY9OVI=;
 b=VjGlH361gcMINQR6w6ontVidKP2ntT3QMpZ3QZ2g78m5Mt5NZNA+TIu6yxNsgXukAPtT
 K78GDoYXn9nekzixj0aoED8C2DJHVB/iNtifFtRIt4oM55hFqKEVhh0EoGK8vjcs/urS
 nguBrBItWGouGpABFqQAqSIcHlLYSw+BQePs9vo7xa/PG2VS47kIzFhwMoAtgGGzk//v
 CT3jfg91R5fiNF1Nihfjm/zjqnyc6//eNhUE/a/t19t+vyIgVSB/Dt9u03fDR/QAmvMi
 U1ZGfTS32GsDX0VlaZfcV61PCln/MzjnhwDTML4I8KA324SN4SMDDGXFqVaKla0L4P1a NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w117tm5xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOAU8071436
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w1ka8e3k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:09 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MO4Ig016246
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:24:03 -0800
Subject: [PATCH 3/3] xfs: always log corruption errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:02 -0800
Message-ID: <157281984206.4150947.1055637710223922715.stgit@magnolia>
In-Reply-To: <157281982341.4150947.10288936972373805803.stgit@magnolia>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we log something to dmesg whenever we return -EFSCORRUPTED up
the call stack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |    9 +++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c  |   12 +++++++++---
 fs/xfs/libxfs/xfs_bmap.c       |    8 +++++++-
 fs/xfs/libxfs/xfs_btree.c      |    5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c   |   24 ++++++++++++++++++------
 fs/xfs/libxfs/xfs_dir2.c       |    4 +++-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    4 +++-
 fs/xfs/libxfs/xfs_dir2_node.c  |   12 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.c |    6 ++++++
 fs/xfs/libxfs/xfs_refcount.c   |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c   |    6 ++++--
 fs/xfs/xfs_acl.c               |   15 ++++++++++++---
 fs/xfs/xfs_attr_inactive.c     |    6 +++++-
 fs/xfs/xfs_attr_list.c         |    5 ++++-
 fs/xfs/xfs_bmap_item.c         |    3 ++-
 fs/xfs/xfs_error.c             |   21 +++++++++++++++++++++
 fs/xfs/xfs_error.h             |    1 +
 fs/xfs/xfs_extfree_item.c      |    3 ++-
 fs/xfs/xfs_inode.c             |   15 ++++++++++++---
 fs/xfs/xfs_inode_item.c        |    5 ++++-
 fs/xfs/xfs_iops.c              |   10 +++++++---
 fs/xfs/xfs_log_recover.c       |   23 ++++++++++++++++++-----
 fs/xfs/xfs_qm.c                |   13 +++++++++++--
 fs/xfs/xfs_refcount_item.c     |    3 ++-
 fs/xfs/xfs_rmap_item.c         |    7 +++++--
 25 files changed, 179 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b8d48d5fa6a5..f7a4b54c5bc2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -702,8 +702,10 @@ xfs_alloc_update_counters(
 
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
-		     be32_to_cpu(agf->agf_length)))
+		     be32_to_cpu(agf->agf_length))) {
+		xfs_buf_corruption_error(agbp);
 		return -EFSCORRUPTED;
+	}
 
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FREEBLKS);
 	return 0;
@@ -1048,6 +1050,7 @@ xfs_alloc_ag_vextent_small(
 
 		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno);
 		if (!bp) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->mp);
 			error = -EFSCORRUPTED;
 			goto error;
 		}
@@ -2215,8 +2218,10 @@ xfs_free_agfl_block(
 		return error;
 
 	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
-	if (!bp)
+	if (!bp) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp);
 		return -EFSCORRUPTED;
+	}
 	xfs_trans_binval(tp, bp);
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 56e62b3d9bb7..dca8840496ea 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2346,8 +2346,10 @@ xfs_attr3_leaf_lookup_int(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
-	if (ichdr.count >= args->geo->blksize / 8)
+	if (ichdr.count >= args->geo->blksize / 8) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
@@ -2363,10 +2365,14 @@ xfs_attr3_leaf_lookup_int(
 		else
 			break;
 	}
-	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count)))
+	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
-	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval))
+	}
+	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Since we may have duplicate hashval's, find the first matching
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bbabbb41e9d8..64f623d07f82 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -730,6 +730,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
 	if (!abp) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out_unreserve_dquot;
 	}
@@ -1085,6 +1086,7 @@ xfs_bmap_add_attrfork(
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 	if (ip->i_d.di_anextents != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto trans_cancel;
 	}
@@ -1338,6 +1340,7 @@ xfs_bmap_last_before(
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 
@@ -1438,8 +1441,10 @@ xfs_bmap_last_offset(
 		return 0;
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS) {
+		ASSERT(0);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -5830,6 +5835,7 @@ xfs_bmap_insert_extents(
 				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
+		ASSERT(0);
 		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4fd89c80c821..98843f1258b8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1820,6 +1820,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
+	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
@@ -1867,8 +1868,10 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (cur->bc_nlevels == 0)
+	if (cur->bc_nlevels == 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
 		return -EFSCORRUPTED;
+	}
 
 	block = NULL;
 	keyno = 0;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 4fd1223c1bd5..1e2dc65adeb8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -504,6 +504,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
+			xfs_buf_corruption_error(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -516,6 +517,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
+			xfs_buf_corruption_error(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1541,8 +1543,10 @@ xfs_da3_node_lookup_int(
 			break;
 		}
 
-		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC)
+		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
+		}
 
 		blk->magic = XFS_DA_NODE_MAGIC;
 
@@ -1554,15 +1558,18 @@ xfs_da3_node_lookup_int(
 		btree = dp->d_ops->node_tree_p(node);
 
 		/* Tree taller than we can handle; bail out! */
-		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
+		}
 
 		/* Check the level from the root. */
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
-		else if (expected_level != nodehdr.level)
+		else if (expected_level != nodehdr.level) {
+			xfs_buf_corruption_error(blk->bp);
 			return -EFSCORRUPTED;
-		else
+		} else
 			expected_level--;
 
 		max = nodehdr.count;
@@ -1612,12 +1619,17 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (blkno == args->geo->leafblk)
+		if (blkno == args->geo->leafblk) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+					dp->i_mount);
 			return -EFSCORRUPTED;
+		}
 	}
 
-	if (expected_level != 0)
+	if (expected_level != 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, dp->i_mount);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5dee0751..452d04ae10ce 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -600,8 +600,10 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize)
+	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount);
 		return -EFSCORRUPTED;
+	}
 	*vp = rval;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a53e4585a2f3..388b5da12228 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1343,8 +1343,10 @@ xfs_dir2_leaf_removename(
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	if (be16_to_cpu(bestsp[db]) != oldbest)
+	if (be16_to_cpu(bestsp[db]) != oldbest) {
+		xfs_buf_corruption_error(lbp);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 705c4f562758..72d7ed17eef5 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -373,8 +373,10 @@ xfs_dir2_leaf_to_node(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
-				(uint)dp->i_d.di_size / args->geo->blksize)
+				(uint)dp->i_d.di_size / args->geo->blksize) {
+		xfs_buf_corruption_error(lbp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Copy freespace entries from the leaf block to the new block.
@@ -445,8 +447,10 @@ xfs_dir2_leafn_add(
 	 * Quick check just to make sure we are not going to index
 	 * into other peoples memory
 	 */
-	if (index < 0)
+	if (index < 0) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If there are already the maximum number of leaf entries in
@@ -739,8 +743,10 @@ xfs_dir2_leafn_lookup_for_entry(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
-	if (leafhdr.count <= 0)
+	if (leafhdr.count <= 0) {
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Look up the hash value in the leaf entries.
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 8fdd0424070e..15d6f947620f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -75,11 +75,15 @@ xfs_iformat_fork(
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
 		default:
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
 			return -EFSCORRUPTED;
 		}
 		break;
 
 	default:
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
 		return -EFSCORRUPTED;
 	}
 	if (error)
@@ -110,6 +114,8 @@ xfs_iformat_fork(
 		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
 		break;
 	default:
+		xfs_inode_verifier_error(ip, error, __func__, dip,
+				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		break;
 	}
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 9a7fadb1361c..78236bd6c64f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1591,8 +1591,10 @@ xfs_refcount_recover_extent(
 	struct list_head		*debris = priv;
 	struct xfs_refcount_recovery	*rr;
 
-	if (be32_to_cpu(rec->refc.rc_refcount) != 1)
+	if (be32_to_cpu(rec->refc.rc_refcount) != 1) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, cur->bc_mp);
 		return -EFSCORRUPTED;
+	}
 
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 8ea1efc97b41..d8aaa1de921c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -15,7 +15,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
-
+#include "xfs_error.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -70,8 +70,10 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
+	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 96d7071cfa46..3f2292c7835c 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -12,6 +12,7 @@
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 #include <linux/posix_acl_xattr.h>
 
 
@@ -23,6 +24,7 @@
 
 STATIC struct posix_acl *
 xfs_acl_from_disk(
+	struct xfs_mount	*mp,
 	const struct xfs_acl	*aclp,
 	int			len,
 	int			max_entries)
@@ -32,11 +34,18 @@ xfs_acl_from_disk(
 	const struct xfs_acl_entry *ace;
 	unsigned int count, i;
 
-	if (len < sizeof(*aclp))
+	if (len < sizeof(*aclp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	count = be32_to_cpu(aclp->acl_cnt);
-	if (count > max_entries || XFS_ACL_SIZE(count) != len)
+	if (count > max_entries || XFS_ACL_SIZE(count) != len) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, aclp,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
@@ -145,7 +154,7 @@ xfs_get_acl(struct inode *inode, int type)
 		if (error != -ENOATTR)
 			acl = ERR_PTR(error);
 	} else  {
-		acl = xfs_acl_from_disk(xfs_acl, len,
+		acl = xfs_acl_from_disk(ip->i_mount, xfs_acl, len,
 					XFS_ACL_MAX_ENTRIES(ip->i_mount));
 		kmem_free(xfs_acl);
 	}
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f83f11d929e4..43ae392992e7 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
+#include "xfs_error.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -209,6 +210,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+		xfs_buf_corruption_error(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -258,8 +260,9 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			error = -EFSCORRUPTED;
+			xfs_buf_corruption_error(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
+			error = -EFSCORRUPTED;
 			break;
 		}
 		if (error)
@@ -342,6 +345,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
+		xfs_buf_corruption_error(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index c02f22d50e45..64f6ceba9254 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -269,8 +269,10 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (cursor->blkno == 0)
+		if (cursor->blkno == 0) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (expected_level != 0)
@@ -280,6 +282,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
+	xfs_buf_corruption_error(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 83d24e983d4c..26c87fd9ac9f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -21,7 +21,7 @@
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -525,6 +525,7 @@ xfs_bui_recover(
 		type = bui_type;
 		break;
 	default:
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto err_inode;
 	}
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 0b156cc88108..d8cdb27fe6ed 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -341,6 +341,27 @@ xfs_corruption_error(
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
 
+/*
+ * Complain about the kinds of metadata corruption that we can't detect from a
+ * verifier, such as incorrect inter-block relationship data.  Does not set
+ * bp->b_error.
+ */
+void
+xfs_buf_corruption_error(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
+		  "Metadata corruption detected at %pS, %s block 0x%llx",
+		  __return_address, bp->b_ops->name, bp->b_bn);
+
+	xfs_alert(mp, "Unmount and run xfs_repair");
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
+
 /*
  * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
  * values, and omit the stack trace unless the error level is tuned high.
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index e6a22cfb542f..c319379f7d1a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,6 +15,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
+void xfs_buf_corruption_error(struct xfs_buf *bp);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e44efc41a041..a6f6acc8fbb7 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -21,7 +21,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
@@ -228,6 +228,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 		}
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e9e4f444f8ce..a92d4521748d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2136,8 +2136,10 @@ xfs_iunlink_update_bucket(
 	 * passed in because either we're adding or removing ourselves from the
 	 * head of the list.
 	 */
-	if (old_value == new_agino)
+	if (old_value == new_agino) {
+		xfs_buf_corruption_error(agibp);
 		return -EFSCORRUPTED;
+	}
 
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
 	offset = offsetof(struct xfs_agi, agi_unlinked) +
@@ -2200,6 +2202,8 @@ xfs_iunlink_update_inode(
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
 	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2211,8 +2215,11 @@ xfs_iunlink_update_inode(
 	 */
 	*old_next_agino = old_value;
 	if (old_value == next_agino) {
-		if (next_agino != NULLAGINO)
+		if (next_agino != NULLAGINO) {
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
 			error = -EFSCORRUPTED;
+		}
 		goto out;
 	}
 
@@ -2263,8 +2270,10 @@ xfs_iunlink(
 	 */
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino))
+	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+		xfs_buf_corruption_error(agibp);
 		return -EFSCORRUPTED;
+	}
 
 	if (next_agino != NULLAGINO) {
 		struct xfs_perag	*pag;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bb8f076805b9..726aa3bfd6e8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 #include <linux/iversion.h>
 
@@ -828,8 +829,10 @@ xfs_inode_item_format_convert(
 {
 	struct xfs_inode_log_format_32	*in_f32 = buf->i_addr;
 
-	if (buf->i_len != sizeof(*in_f32))
+	if (buf->i_len != sizeof(*in_f32)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
+	}
 
 	in_f->ilf_type = in_f32->ilf_type;
 	in_f->ilf_size = in_f32->ilf_size;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 18e45e3a3f9f..4c7962ccb0c4 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -20,6 +20,7 @@
 #include "xfs_symlink.h"
 #include "xfs_dir2.h"
 #include "xfs_iomap.h"
+#include "xfs_error.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
@@ -470,17 +471,20 @@ xfs_vn_get_link_inline(
 	struct inode		*inode,
 	struct delayed_call	*done)
 {
+	struct xfs_inode	*ip = XFS_I(inode);
 	char			*link;
 
-	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
 
 	/*
 	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
 	 * if_data is junk.
 	 */
-	link = XFS_I(inode)->i_df.if_u1.if_data;
-	if (!link)
+	link = ip->i_df.if_u1.if_data;
+	if (!link) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, ip->i_mount);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 	return link;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1a514ffff55..648d5ecafd91 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3537,6 +3537,7 @@ xfs_cui_copy_format(
 		memcpy(dst_cui_fmt, src_cui_fmt, len);
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
@@ -3601,8 +3602,10 @@ xlog_recover_cud_pass2(
 	struct xfs_ail			*ailp = log->l_ailp;
 
 	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format))
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	cui_id = cud_formatp->cud_cui_id;
 
 	/*
@@ -3654,6 +3657,7 @@ xfs_bui_copy_format(
 		memcpy(dst_bui_fmt, src_bui_fmt, len);
 		return 0;
 	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
 
@@ -3677,8 +3681,10 @@ xlog_recover_bui_pass2(
 
 	bui_formatp = item->ri_buf[0].i_addr;
 
-	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	buip = xfs_bui_init(mp);
 	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
 	if (error) {
@@ -3720,8 +3726,10 @@ xlog_recover_bud_pass2(
 	struct xfs_ail			*ailp = log->l_ailp;
 
 	bud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format))
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
+	}
 	bui_id = bud_formatp->bud_bui_id;
 
 	/*
@@ -5172,8 +5180,10 @@ xlog_recover_process(
 		 * If the filesystem is CRC enabled, this mismatch becomes a
 		 * fatal log corruption failure.
 		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+		if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	xlog_unpack_data(rhead, dp, log);
@@ -5296,8 +5306,11 @@ xlog_do_recovery_pass(
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
 					 h_size, log->l_mp->m_logbsize);
 				h_size = log->l_mp->m_logbsize;
-			} else
+			} else {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						log->l_mp);
 				return -EFSCORRUPTED;
+			}
 		}
 
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ecd8ce152ab1..66ea8e4fca86 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -22,6 +22,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_error.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -754,11 +755,19 @@ xfs_qm_qino_alloc(
 		if ((flags & XFS_QMOPT_PQUOTA) &&
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
-			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
+			if (mp->m_sb.sb_pquotino != NULLFSINO) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						mp);
+				return -EFSCORRUPTED;
+			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
-			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
+			if (mp->m_sb.sb_gquotino != NULLFSINO) {
+				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
+						mp);
+				return -EFSCORRUPTED;
+			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2328268e6245..576f59fe370e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -17,7 +17,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_log.h"
 #include "xfs_refcount.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
@@ -536,6 +536,7 @@ xfs_cui_recover(
 			type = refc_type;
 			break;
 		default:
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8939e0ea09cd..1d72e4b3ebf1 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -17,7 +17,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
-
+#include "xfs_error.h"
 
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
@@ -171,8 +171,10 @@ xfs_rui_copy_format(
 	src_rui_fmt = buf->i_addr;
 	len = xfs_rui_log_format_sizeof(src_rui_fmt->rui_nextents);
 
-	if (buf->i_len != len)
+	if (buf->i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
+	}
 
 	memcpy(dst_rui_fmt, src_rui_fmt, len);
 	return 0;
@@ -581,6 +583,7 @@ xfs_rui_recover(
 			type = XFS_RMAP_FREE;
 			break;
 		default:
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}

