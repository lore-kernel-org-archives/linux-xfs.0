Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA521DFD0
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346455; cv=none; b=p1Eck4CVLLp0fqq64o7Y46ys70Dj1PyOnnCsf+R6UULrHgdyhmdtSqR4pZrTOMaJbrzn2yG7ujGGFKKbpEm6A1nl2auvTHurQThtPg0X0M9CFAjT9E1VRm9MbEKtbtX9LRfDN00J/uK9JpouUt5KSvS2pL3k8ivB6GiXw/9uDHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346455; c=relaxed/simple;
	bh=gXLSeHlXS7cb87iQhKHz51k4nwIWF7GqV6Sy+3oyp8Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gkO0DzPQKUwUlHxNToO57grT+a2DdSerKS4vhE33yO21JEIf7hq8AsUHXEa7uVLNQSAfGKkhBaN5Fv3B+JjyaDvzeU9/2UCF1ij2wnVzYQ6nBvVnmPs5xg7a6uYoL4yrEF1ehVr9KXCs3/rCOx2XpxPcN+ps+LntRHQR138xy8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhDj39E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhDj39E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048A1C2BD11;
	Wed, 22 May 2024 02:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346455;
	bh=gXLSeHlXS7cb87iQhKHz51k4nwIWF7GqV6Sy+3oyp8Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DhDj39E3I/1vX5J4xkq6sqbQE38B/RX9dgsDgXEKMTmmde6BkwSCk/5MG2rP4i4Ic
	 Axtakcdb3Qh2yl70+itoTAGpvX1KR6BKzwmaB3yidPGoF4RpeKCvFa8HxkNT68tAoO
	 eJjDWaMOR4FbR+prnNWYssyJP3BPVSdUlGlb3xssDZCqtXCZKkSpW4lk90QG/7EHPn
	 mEpXutMR1VHFUbC/iRv466SF+uVX7tTC/BM1gvPx2QBhJzruvEUaXWfG+b6CvAG1vn
	 oY9VVTrmCKp7jHkKnyky/0zLgDEyMwMA9RrX+XzkldQltKk8weXp2BoNb50ziuPPEt
	 BFsZvsCQsaqRg==
Date: Tue, 21 May 2024 19:54:14 -0700
Subject: [PATCH 021/111] xfs: report dir/attr block corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532026.2478931.14133508831527496709.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ca14c0968c1f693ab4bcb5368c800c33e7a2ad7e

Whenever we encounter corrupt directory or extended attribute blocks, we
should report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c            |    2 ++
 libxfs/xfs_attr_leaf.c   |    4 ++++
 libxfs/xfs_attr_remote.c |   27 ++++++++++++++++-----------
 libxfs/xfs_da_btree.c    |   37 ++++++++++++++++++++++++++++++++-----
 libxfs/xfs_dir2.c        |    5 ++++-
 libxfs/xfs_dir2_block.c  |    2 ++
 libxfs/xfs_dir2_data.c   |    3 +++
 libxfs/xfs_dir2_leaf.c   |    3 +++
 libxfs/xfs_dir2_node.c   |    7 +++++++
 libxfs/xfs_health.h      |    3 +++
 10 files changed, 76 insertions(+), 17 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index b45d67065..6c326e84a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -734,3 +734,5 @@ void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
+void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
+void xfs_da_mark_sick(struct xfs_da_args *args) { }
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index fdc53451c..a44312cdc 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -26,6 +26,7 @@
 #include "xfs_dir2.h"
 #include "xfs_ag.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 
 /*
@@ -2340,6 +2341,7 @@ xfs_attr3_leaf_lookup_int(
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -2359,10 +2361,12 @@ xfs_attr3_leaf_lookup_int(
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 12d1ba9c3..a400a22d3 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -21,6 +21,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -275,17 +276,18 @@ xfs_attr3_rmt_hdr_set(
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
-	xfs_daddr_t	bno = xfs_buf_daddr(bp);
-	int		len = BBTOB(bp->b_length);
-	int		blksize = mp->m_attr_geo->blksize;
+	char			*src = bp->b_addr;
+	xfs_ino_t		ino = dp->i_ino;
+	xfs_daddr_t		bno = xfs_buf_daddr(bp);
+	int			len = BBTOB(bp->b_length);
+	int			blksize = mp->m_attr_geo->blksize;
 
 	ASSERT(len >= blksize);
 
@@ -301,6 +303,7 @@ xfs_attr_rmtval_copyout(
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
 					bno, *offset, byte_cnt, ino);
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
 			hdr_size = sizeof(struct xfs_attr3_rmt_hdr);
@@ -417,10 +420,12 @@ xfs_attr_rmtval_get(
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
 					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 
-			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
+			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
 							&offset, &valuelen,
 							&dst);
 			xfs_buf_relse(bp);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 0fea72f33..8ace7622a 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_bmap.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 /*
  * xfs_da_btree.c
@@ -349,6 +350,8 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 static int
 xfs_da3_node_set_type(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	int			whichfork,
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -370,6 +373,7 @@ xfs_da3_node_set_type(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp,
 				info, sizeof(*info));
 		xfs_trans_brelse(tp, bp);
+		xfs_dirattr_mark_sick(dp, whichfork);
 		return -EFSCORRUPTED;
 	}
 }
@@ -388,7 +392,7 @@ xfs_da3_node_read(
 			&xfs_da3_node_buf_ops);
 	if (error || !*bpp || !tp)
 		return error;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 int
@@ -405,6 +409,8 @@ xfs_da3_node_read_mapped(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, mappedbno,
 			XFS_FSB_TO_BB(mp, xfs_dabuf_nfsb(mp, whichfork)), 0,
 			bpp, &xfs_da3_node_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error || !*bpp)
 		return error;
 
@@ -415,7 +421,7 @@ xfs_da3_node_read_mapped(
 
 	if (!tp)
 		return 0;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 /*
@@ -628,6 +634,7 @@ xfs_da3_split(
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
 			xfs_buf_mark_corrupt(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -641,6 +648,7 @@ xfs_da3_split(
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
 			xfs_buf_mark_corrupt(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1632,6 +1640,7 @@ xfs_da3_node_lookup_int(
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1647,6 +1656,7 @@ xfs_da3_node_lookup_int(
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1655,6 +1665,7 @@ xfs_da3_node_lookup_int(
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
@@ -1706,12 +1717,16 @@ xfs_da3_node_lookup_int(
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
@@ -1729,6 +1744,7 @@ xfs_da3_node_lookup_int(
 			args->blkno = blk->blkno;
 		} else {
 			ASSERT(0);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 		if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
@@ -2295,8 +2311,10 @@ xfs_da3_swap_lastblock(
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
@@ -2346,6 +2364,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->forw) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2366,6 +2385,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->back) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2388,6 +2408,7 @@ xfs_da3_swap_lastblock(
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp,
 				   level >= 0 && level != par_hdr.level + 1)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2399,6 +2420,7 @@ xfs_da3_swap_lastblock(
 		     entno++)
 			continue;
 		if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2424,6 +2446,7 @@ xfs_da3_swap_lastblock(
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2433,6 +2456,7 @@ xfs_da3_swap_lastblock(
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2563,6 +2587,7 @@ xfs_dabuf_map(
 invalid_mapping:
 	/* Caller ok with no mapping. */
 	if (XFS_IS_CORRUPT(mp, !(flags & XFS_DABUF_MAP_HOLE_OK))) {
+		xfs_dirattr_mark_sick(dp, whichfork);
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
@@ -2644,6 +2669,8 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error)
 		goto out_free;
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index ac372bf2a..530c3e22a 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_errortag.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -625,8 +626,10 @@ xfs_dir2_isblock(
 		return 0;
 
 	*isblock = true;
-	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
+	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	return 0;
 }
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index aed3c14a8..9d87735e7 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 /*
  * Local function prototypes.
@@ -149,6 +150,7 @@ xfs_dir3_block_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 4e207986b..aaf3f62af 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -15,6 +15,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_trans.h"
+#include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -430,6 +431,7 @@ xfs_dir3_data_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -1195,6 +1197,7 @@ xfs_dir2_data_use_free(
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
 			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
+	xfs_da_mark_sick(args);
 	return -EFSCORRUPTED;
 }
 
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 5da66006c..80cea8a27 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_health.h"
 
 /*
  * Local function declarations.
@@ -1391,8 +1392,10 @@ xfs_dir2_leaf_removename(
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
 		xfs_buf_mark_corrupt(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
+
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index c0eb335c3..44c8f3f2b 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -17,6 +17,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_health.h"
 
 /*
  * Function declarations.
@@ -228,6 +229,7 @@ __xfs_dir3_free_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -440,6 +442,7 @@ xfs_dir2_leaf_to_node(
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_disk_size / args->geo->blksize) {
 		xfs_buf_mark_corrupt(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -514,6 +517,7 @@ xfs_dir2_leafn_add(
 	 */
 	if (index < 0) {
 		xfs_buf_mark_corrupt(bp);
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
 		xfs_buf_mark_corrupt(bp);
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
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 8f566a787..ff98c0321 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -38,6 +38,7 @@ struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
+struct xfs_da_args;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -162,6 +163,8 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
+void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_da_mark_sick(struct xfs_da_args *args);
 
 /* Now some helpers. */
 

