Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5M8odUH257104 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 03:50:39 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jHC3o69rCH3nY6Qy for <xfs@oss.sgi.com>;
	Fri, 22 Jun 2012 01:50:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ShzZK-0005S4-Jk
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:18 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ShzZK-0006qS-Fh
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: remove struct xfs_dabuf and infrastructure
Date: Fri, 22 Jun 2012 18:50:14 +1000
Message-Id: <1340355015-26250-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1340355015-26250-1-git-send-email-david@fromorbit.com>
References: <1340355015-26250-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The struct xfs_dabuf now only tracks a single xfs_buf and all the
information it holds can be gained directly from the xfs_buf. Hence
we can remove the struct dabuf and pass the xfs_buf around
everywhere.

Kill the struct dabuf and the associated infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c       |   78 +++++------
 fs/xfs/xfs_attr_leaf.c  |  255 +++++++++++++++++++----------------
 fs/xfs/xfs_attr_leaf.h  |   21 ++-
 fs/xfs/xfs_da_btree.c   |  337 +++++++++++++++++------------------------------
 fs/xfs/xfs_da_btree.h   |   32 +----
 fs/xfs/xfs_dir2.c       |    4 +-
 fs/xfs/xfs_dir2_block.c |  118 +++++++----------
 fs/xfs/xfs_dir2_data.c  |   50 +++----
 fs/xfs/xfs_dir2_leaf.c  |  191 +++++++++++++--------------
 fs/xfs/xfs_dir2_node.c  |  236 ++++++++++++++-------------------
 fs/xfs/xfs_dir2_priv.h  |   46 +++----
 fs/xfs/xfs_dir2_sf.c    |    4 +-
 fs/xfs/xfs_super.c      |    9 +-
 13 files changed, 602 insertions(+), 779 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index a17ff01..0ca1f0b 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -893,7 +893,7 @@ STATIC int
 xfs_attr_leaf_addname(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int retval, error, committed, forkoff;
 
 	trace_xfs_attr_leaf_addname(args);
@@ -915,11 +915,11 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 */
 	retval = xfs_attr_leaf_lookup_int(bp, args);
 	if ((args->flags & ATTR_REPLACE) && (retval == ENOATTR)) {
-		xfs_da_brelse(args->trans, bp);
+		xfs_trans_brelse(args->trans, bp);
 		return(retval);
 	} else if (retval == EEXIST) {
 		if (args->flags & ATTR_CREATE) {	/* pure create op */
-			xfs_da_brelse(args->trans, bp);
+			xfs_trans_brelse(args->trans, bp);
 			return(retval);
 		}
 
@@ -937,7 +937,6 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 * if required.
 	 */
 	retval = xfs_attr_leaf_add(bp, args);
-	xfs_da_buf_done(bp);
 	if (retval == ENOSPC) {
 		/*
 		 * Promote the attribute list to the Btree format, then
@@ -1065,8 +1064,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			 */
 			if (committed)
 				xfs_trans_ijoin(args->trans, dp, 0);
-		} else
-			xfs_da_buf_done(bp);
+		}
 
 		/*
 		 * Commit the remove and start the next trans in series.
@@ -1092,7 +1090,7 @@ STATIC int
 xfs_attr_leaf_removename(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error, committed, forkoff;
 
 	trace_xfs_attr_leaf_removename(args);
@@ -1111,7 +1109,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	ASSERT(bp != NULL);
 	error = xfs_attr_leaf_lookup_int(bp, args);
 	if (error == ENOATTR) {
-		xfs_da_brelse(args->trans, bp);
+		xfs_trans_brelse(args->trans, bp);
 		return(error);
 	}
 
@@ -1141,8 +1139,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		 */
 		if (committed)
 			xfs_trans_ijoin(args->trans, dp, 0);
-	} else
-		xfs_da_buf_done(bp);
+	}
 	return(0);
 }
 
@@ -1155,7 +1152,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 STATIC int
 xfs_attr_leaf_get(xfs_da_args_t *args)
 {
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 
 	args->blkno = 0;
@@ -1167,11 +1164,11 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 
 	error = xfs_attr_leaf_lookup_int(bp, args);
 	if (error != EEXIST)  {
-		xfs_da_brelse(args->trans, bp);
+		xfs_trans_brelse(args->trans, bp);
 		return(error);
 	}
 	error = xfs_attr_leaf_getvalue(bp, args);
-	xfs_da_brelse(args->trans, bp);
+	xfs_trans_brelse(args->trans, bp);
 	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
 		error = xfs_attr_rmtval_get(args);
 	}
@@ -1186,23 +1183,23 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 {
 	xfs_attr_leafblock_t *leaf;
 	int error;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 
 	context->cursor->blkno = 0;
 	error = xfs_da_read_buf(NULL, context->dp, 0, -1, &bp, XFS_ATTR_FORK);
 	if (error)
 		return XFS_ERROR(error);
 	ASSERT(bp != NULL);
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	if (unlikely(leaf->hdr.info.magic != cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
 		XFS_CORRUPTION_ERROR("xfs_attr_leaf_list", XFS_ERRLEVEL_LOW,
 				     context->dp->i_mount, leaf);
-		xfs_da_brelse(NULL, bp);
+		xfs_trans_brelse(NULL, bp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
 	error = xfs_attr_leaf_list_int(bp, context);
-	xfs_da_brelse(NULL, bp);
+	xfs_trans_brelse(NULL, bp);
 	return XFS_ERROR(error);
 }
 
@@ -1489,7 +1486,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	xfs_da_state_t *state;
 	xfs_da_state_blk_t *blk;
 	xfs_inode_t *dp;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int retval, error, committed, forkoff;
 
 	trace_xfs_attr_node_removename(args);
@@ -1601,14 +1598,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		 */
 		ASSERT(state->path.active == 1);
 		ASSERT(state->path.blk[0].bp);
-		xfs_da_buf_done(state->path.blk[0].bp);
 		state->path.blk[0].bp = NULL;
 
 		error = xfs_da_read_buf(args->trans, args->dp, 0, -1, &bp,
 						     XFS_ATTR_FORK);
 		if (error)
 			goto out;
-		ASSERT((((xfs_attr_leafblock_t *)bp->data)->hdr.info.magic) ==
+		ASSERT((((xfs_attr_leafblock_t *)bp->b_addr)->hdr.info.magic) ==
 		       cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
@@ -1635,7 +1631,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			if (committed)
 				xfs_trans_ijoin(args->trans, dp, 0);
 		} else
-			xfs_da_brelse(args->trans, bp);
+			xfs_trans_brelse(args->trans, bp);
 	}
 	error = 0;
 
@@ -1665,8 +1661,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->bp) {
-			blk->disk_blkno = xfs_da_blkno(blk->bp);
-			xfs_da_buf_done(blk->bp);
+			blk->disk_blkno = XFS_BUF_ADDR(blk->bp);
 			blk->bp = NULL;
 		} else {
 			blk->disk_blkno = 0;
@@ -1681,8 +1676,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->bp) {
-			blk->disk_blkno = xfs_da_blkno(blk->bp);
-			xfs_da_buf_done(blk->bp);
+			blk->disk_blkno = XFS_BUF_ADDR(blk->bp);
 			blk->bp = NULL;
 		} else {
 			blk->disk_blkno = 0;
@@ -1792,7 +1786,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	 * If not in a transaction, we have to release all the buffers.
 	 */
 	for (i = 0; i < state->path.active; i++) {
-		xfs_da_brelse(args->trans, state->path.blk[i].bp);
+		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
 		state->path.blk[i].bp = NULL;
 	}
 
@@ -1808,7 +1802,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	xfs_da_intnode_t *node;
 	xfs_da_node_entry_t *btree;
 	int error, i;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 
 	cursor = context->cursor;
 	cursor->initted = 1;
@@ -1825,30 +1819,30 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		if ((error != 0) && (error != EFSCORRUPTED))
 			return(error);
 		if (bp) {
-			node = bp->data;
+			node = bp->b_addr;
 			switch (be16_to_cpu(node->hdr.info.magic)) {
 			case XFS_DA_NODE_MAGIC:
 				trace_xfs_attr_list_wrong_blk(context);
-				xfs_da_brelse(NULL, bp);
+				xfs_trans_brelse(NULL, bp);
 				bp = NULL;
 				break;
 			case XFS_ATTR_LEAF_MAGIC:
-				leaf = bp->data;
+				leaf = bp->b_addr;
 				if (cursor->hashval > be32_to_cpu(leaf->entries[
 				    be16_to_cpu(leaf->hdr.count)-1].hashval)) {
 					trace_xfs_attr_list_wrong_blk(context);
-					xfs_da_brelse(NULL, bp);
+					xfs_trans_brelse(NULL, bp);
 					bp = NULL;
 				} else if (cursor->hashval <=
 					     be32_to_cpu(leaf->entries[0].hashval)) {
 					trace_xfs_attr_list_wrong_blk(context);
-					xfs_da_brelse(NULL, bp);
+					xfs_trans_brelse(NULL, bp);
 					bp = NULL;
 				}
 				break;
 			default:
 				trace_xfs_attr_list_wrong_blk(context);
-				xfs_da_brelse(NULL, bp);
+				xfs_trans_brelse(NULL, bp);
 				bp = NULL;
 			}
 		}
@@ -1873,7 +1867,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 						 context->dp->i_mount);
 				return(XFS_ERROR(EFSCORRUPTED));
 			}
-			node = bp->data;
+			node = bp->b_addr;
 			if (node->hdr.info.magic ==
 			    cpu_to_be16(XFS_ATTR_LEAF_MAGIC))
 				break;
@@ -1883,7 +1877,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 						     XFS_ERRLEVEL_LOW,
 						     context->dp->i_mount,
 						     node);
-				xfs_da_brelse(NULL, bp);
+				xfs_trans_brelse(NULL, bp);
 				return(XFS_ERROR(EFSCORRUPTED));
 			}
 			btree = node->btree;
@@ -1898,10 +1892,10 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 				}
 			}
 			if (i == be16_to_cpu(node->hdr.count)) {
-				xfs_da_brelse(NULL, bp);
+				xfs_trans_brelse(NULL, bp);
 				return(0);
 			}
-			xfs_da_brelse(NULL, bp);
+			xfs_trans_brelse(NULL, bp);
 		}
 	}
 	ASSERT(bp != NULL);
@@ -1912,24 +1906,24 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 * adding the information.
 	 */
 	for (;;) {
-		leaf = bp->data;
+		leaf = bp->b_addr;
 		if (unlikely(leaf->hdr.info.magic !=
 			     cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_node_list(4)",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, leaf);
-			xfs_da_brelse(NULL, bp);
+			xfs_trans_brelse(NULL, bp);
 			return(XFS_ERROR(EFSCORRUPTED));
 		}
 		error = xfs_attr_leaf_list_int(bp, context);
 		if (error) {
-			xfs_da_brelse(NULL, bp);
+			xfs_trans_brelse(NULL, bp);
 			return error;
 		}
 		if (context->seen_enough || leaf->hdr.info.forw == 0)
 			break;
 		cursor->blkno = be32_to_cpu(leaf->hdr.info.forw);
-		xfs_da_brelse(NULL, bp);
+		xfs_trans_brelse(NULL, bp);
 		error = xfs_da_read_buf(NULL, context->dp, cursor->blkno, -1,
 					      &bp, XFS_ATTR_FORK);
 		if (error)
@@ -1941,7 +1935,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			return(XFS_ERROR(EFSCORRUPTED));
 		}
 	}
-	xfs_da_brelse(NULL, bp);
+	xfs_trans_brelse(NULL, bp);
 	return(0);
 }
 
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 7d89d80..d330111 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -54,10 +54,10 @@
  * Routines used for growing the Btree.
  */
 STATIC int xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t which_block,
-				    xfs_dabuf_t **bpp);
-STATIC int xfs_attr_leaf_add_work(xfs_dabuf_t *leaf_buffer, xfs_da_args_t *args,
-					      int freemap_index);
-STATIC void xfs_attr_leaf_compact(xfs_trans_t *trans, xfs_dabuf_t *leaf_buffer);
+				struct xfs_buf **bpp);
+STATIC int xfs_attr_leaf_add_work(struct xfs_buf *leaf_buffer,
+				  xfs_da_args_t *args, int freemap_index);
+STATIC void xfs_attr_leaf_compact(xfs_trans_t *tp, struct xfs_buf *leaf_buffer);
 STATIC void xfs_attr_leaf_rebalance(xfs_da_state_t *state,
 						   xfs_da_state_blk_t *blk1,
 						   xfs_da_state_blk_t *blk2);
@@ -71,9 +71,9 @@ STATIC int xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
  * Routines used for shrinking the Btree.
  */
 STATIC int xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
-				  xfs_dabuf_t *bp, int level);
+				  struct xfs_buf *bp, int level);
 STATIC int xfs_attr_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
-				  xfs_dabuf_t *bp);
+				  struct xfs_buf *bp);
 STATIC int xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 				   xfs_dablk_t blkno, int blkcnt);
 
@@ -480,7 +480,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	char *tmpbuffer;
 	int error, i, size;
 	xfs_dablk_t blkno;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	xfs_ifork_t *ifp;
 
 	trace_xfs_attr_sf_to_leaf(args);
@@ -550,8 +550,6 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	error = 0;
 
 out:
-	if(bp)
-		xfs_da_buf_done(bp);
 	kmem_free(tmpbuffer);
 	return(error);
 }
@@ -737,14 +735,16 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
  * a shortform attribute list.
  */
 int
-xfs_attr_shortform_allfit(xfs_dabuf_t *bp, xfs_inode_t *dp)
+xfs_attr_shortform_allfit(
+	struct xfs_buf	*bp,
+	struct xfs_inode *dp)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_entry_t *entry;
 	xfs_attr_leaf_name_local_t *name_loc;
 	int bytes, i;
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 	entry = &leaf->entries[0];
@@ -774,7 +774,10 @@ xfs_attr_shortform_allfit(xfs_dabuf_t *bp, xfs_inode_t *dp)
  * Convert a leaf attribute list to shortform attribute list
  */
 int
-xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
+xfs_attr_leaf_to_shortform(
+	struct xfs_buf	*bp,
+	xfs_da_args_t	*args,
+	int		forkoff)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_entry_t *entry;
@@ -791,10 +794,10 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
 	ASSERT(tmpbuffer != NULL);
 
 	ASSERT(bp != NULL);
-	memcpy(tmpbuffer, bp->data, XFS_LBSIZE(dp->i_mount));
+	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(dp->i_mount));
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	memset(bp->data, 0, XFS_LBSIZE(dp->i_mount));
+	memset(bp->b_addr, 0, XFS_LBSIZE(dp->i_mount));
 
 	/*
 	 * Clean out the prior contents of the attribute list.
@@ -855,7 +858,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	xfs_attr_leafblock_t *leaf;
 	xfs_da_intnode_t *node;
 	xfs_inode_t *dp;
-	xfs_dabuf_t *bp1, *bp2;
+	struct xfs_buf *bp1, *bp2;
 	xfs_dablk_t blkno;
 	int error;
 
@@ -877,10 +880,9 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	if (error)
 		goto out;
 	ASSERT(bp2 != NULL);
-	memcpy(bp2->data, bp1->data, XFS_LBSIZE(dp->i_mount));
-	xfs_da_buf_done(bp1);
+	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(dp->i_mount));
 	bp1 = NULL;
-	xfs_da_log_buf(args->trans, bp2, 0, XFS_LBSIZE(dp->i_mount) - 1);
+	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(dp->i_mount) - 1);
 
 	/*
 	 * Set up the new root node.
@@ -888,21 +890,17 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	error = xfs_da_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
 	if (error)
 		goto out;
-	node = bp1->data;
-	leaf = bp2->data;
+	node = bp1->b_addr;
+	leaf = bp2->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	/* both on-disk, don't endian-flip twice */
 	node->btree[0].hashval =
 		leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
 	node->btree[0].before = cpu_to_be32(blkno);
 	node->hdr.count = cpu_to_be16(1);
-	xfs_da_log_buf(args->trans, bp1, 0, XFS_LBSIZE(dp->i_mount) - 1);
+	xfs_trans_log_buf(args->trans, bp1, 0, XFS_LBSIZE(dp->i_mount) - 1);
 	error = 0;
 out:
-	if (bp1)
-		xfs_da_buf_done(bp1);
-	if (bp2)
-		xfs_da_buf_done(bp2);
 	return(error);
 }
 
@@ -916,12 +914,15 @@ out:
  * or a leaf in a node attribute list.
  */
 STATIC int
-xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t blkno, xfs_dabuf_t **bpp)
+xfs_attr_leaf_create(
+	xfs_da_args_t	*args,
+	xfs_dablk_t	blkno,
+	struct xfs_buf	**bpp)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_hdr_t *hdr;
 	xfs_inode_t *dp;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 
 	trace_xfs_attr_leaf_create(args);
@@ -933,7 +934,7 @@ xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t blkno, xfs_dabuf_t **bpp)
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	memset((char *)leaf, 0, XFS_LBSIZE(dp->i_mount));
 	hdr = &leaf->hdr;
 	hdr->info.magic = cpu_to_be16(XFS_ATTR_LEAF_MAGIC);
@@ -947,7 +948,7 @@ xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t blkno, xfs_dabuf_t **bpp)
 	hdr->freemap[0].size = cpu_to_be16(be16_to_cpu(hdr->firstused) -
 					   sizeof(xfs_attr_leaf_hdr_t));
 
-	xfs_da_log_buf(args->trans, bp, 0, XFS_LBSIZE(dp->i_mount) - 1);
+	xfs_trans_log_buf(args->trans, bp, 0, XFS_LBSIZE(dp->i_mount) - 1);
 
 	*bpp = bp;
 	return(0);
@@ -1014,7 +1015,9 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
  * Add a name to the leaf attribute list structure.
  */
 int
-xfs_attr_leaf_add(xfs_dabuf_t *bp, xfs_da_args_t *args)
+xfs_attr_leaf_add(
+	struct xfs_buf		*bp,
+	struct xfs_da_args	*args)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_hdr_t *hdr;
@@ -1023,7 +1026,7 @@ xfs_attr_leaf_add(xfs_dabuf_t *bp, xfs_da_args_t *args)
 
 	trace_xfs_attr_leaf_add(args);
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT((args->index >= 0)
 		&& (args->index <= be16_to_cpu(leaf->hdr.count)));
@@ -1085,7 +1088,10 @@ xfs_attr_leaf_add(xfs_dabuf_t *bp, xfs_da_args_t *args)
  * Add a name to a leaf attribute list structure.
  */
 STATIC int
-xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
+xfs_attr_leaf_add_work(
+	struct xfs_buf	*bp,
+	xfs_da_args_t	*args,
+	int		mapindex)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_hdr_t *hdr;
@@ -1096,7 +1102,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 	xfs_mount_t *mp;
 	int tmp, i;
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr = &leaf->hdr;
 	ASSERT((mapindex >= 0) && (mapindex < XFS_ATTR_LEAF_MAPSIZE));
@@ -1110,7 +1116,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 		tmp  = be16_to_cpu(hdr->count) - args->index;
 		tmp *= sizeof(xfs_attr_leaf_entry_t);
 		memmove((char *)(entry+1), (char *)entry, tmp);
-		xfs_da_log_buf(args->trans, bp,
+		xfs_trans_log_buf(args->trans, bp,
 		    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(*entry)));
 	}
 	be16_add_cpu(&hdr->count, 1);
@@ -1142,7 +1148,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 			args->index2++;
 		}
 	}
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 			  XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	ASSERT((args->index == 0) ||
 	       (be32_to_cpu(entry->hashval) >= be32_to_cpu((entry-1)->hashval)));
@@ -1174,7 +1180,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 		args->rmtblkno = 1;
 		args->rmtblkcnt = XFS_B_TO_FSB(mp, args->valuelen);
 	}
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
 				   xfs_attr_leaf_entsize(leaf, args->index)));
 
@@ -1198,7 +1204,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 		}
 	}
 	be16_add_cpu(&hdr->usedbytes, xfs_attr_leaf_entsize(leaf, args->index));
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, hdr, sizeof(*hdr)));
 	return(0);
 }
@@ -1207,7 +1213,9 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
  * Garbage collect a leaf attribute list block by copying it to a new buffer.
  */
 STATIC void
-xfs_attr_leaf_compact(xfs_trans_t *trans, xfs_dabuf_t *bp)
+xfs_attr_leaf_compact(
+	struct xfs_trans *trans,
+	struct xfs_buf	*bp)
 {
 	xfs_attr_leafblock_t *leaf_s, *leaf_d;
 	xfs_attr_leaf_hdr_t *hdr_s, *hdr_d;
@@ -1217,14 +1225,14 @@ xfs_attr_leaf_compact(xfs_trans_t *trans, xfs_dabuf_t *bp)
 	mp = trans->t_mountp;
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(mp), KM_SLEEP);
 	ASSERT(tmpbuffer != NULL);
-	memcpy(tmpbuffer, bp->data, XFS_LBSIZE(mp));
-	memset(bp->data, 0, XFS_LBSIZE(mp));
+	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(mp));
+	memset(bp->b_addr, 0, XFS_LBSIZE(mp));
 
 	/*
 	 * Copy basic information
 	 */
 	leaf_s = (xfs_attr_leafblock_t *)tmpbuffer;
-	leaf_d = bp->data;
+	leaf_d = bp->b_addr;
 	hdr_s = &leaf_s->hdr;
 	hdr_d = &leaf_d->hdr;
 	hdr_d->info = hdr_s->info;	/* struct copy */
@@ -1247,7 +1255,7 @@ xfs_attr_leaf_compact(xfs_trans_t *trans, xfs_dabuf_t *bp)
 	 */
 	xfs_attr_leaf_moveents(leaf_s, 0, leaf_d, 0,
 				be16_to_cpu(hdr_s->count), mp);
-	xfs_da_log_buf(trans, bp, 0, XFS_LBSIZE(mp) - 1);
+	xfs_trans_log_buf(trans, bp, 0, XFS_LBSIZE(mp) - 1);
 
 	kmem_free(tmpbuffer);
 }
@@ -1279,8 +1287,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	 */
 	ASSERT(blk1->magic == XFS_ATTR_LEAF_MAGIC);
 	ASSERT(blk2->magic == XFS_ATTR_LEAF_MAGIC);
-	leaf1 = blk1->bp->data;
-	leaf2 = blk2->bp->data;
+	leaf1 = blk1->bp->b_addr;
+	leaf2 = blk2->bp->b_addr;
 	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	args = state->args;
@@ -1298,8 +1306,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		tmp_blk = blk1;
 		blk1 = blk2;
 		blk2 = tmp_blk;
-		leaf1 = blk1->bp->data;
-		leaf2 = blk2->bp->data;
+		leaf1 = blk1->bp->b_addr;
+		leaf2 = blk2->bp->b_addr;
 		swap = 1;
 	}
 	hdr1 = &leaf1->hdr;
@@ -1346,8 +1354,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		xfs_attr_leaf_moveents(leaf1, be16_to_cpu(hdr1->count) - count,
 				leaf2, 0, count, state->mp);
 
-		xfs_da_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
-		xfs_da_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
+		xfs_trans_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
+		xfs_trans_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
 	} else if (count > be16_to_cpu(hdr1->count)) {
 		/*
 		 * I assert that since all callers pass in an empty
@@ -1378,8 +1386,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		xfs_attr_leaf_moveents(leaf2, 0, leaf1,
 				be16_to_cpu(hdr1->count), count, state->mp);
 
-		xfs_da_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
-		xfs_da_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
+		xfs_trans_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
+		xfs_trans_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
 	}
 
 	/*
@@ -1448,8 +1456,8 @@ xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
 	/*
 	 * Set up environment.
 	 */
-	leaf1 = blk1->bp->data;
-	leaf2 = blk2->bp->data;
+	leaf1 = blk1->bp->b_addr;
+	leaf2 = blk2->bp->b_addr;
 	hdr1 = &leaf1->hdr;
 	hdr2 = &leaf2->hdr;
 	foundit = 0;
@@ -1551,7 +1559,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	xfs_da_blkinfo_t *info;
 	int count, bytes, forward, error, retval, i;
 	xfs_dablk_t blkno;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 
 	/*
 	 * Check for the degenerate case of the block being over 50% full.
@@ -1559,7 +1567,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	 * to coalesce with a sibling.
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
-	info = blk->bp->data;
+	info = blk->bp->b_addr;
 	ASSERT(info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	leaf = (xfs_attr_leafblock_t *)info;
 	count = be16_to_cpu(leaf->hdr.count);
@@ -1622,13 +1630,13 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 		count  = be16_to_cpu(leaf->hdr.count);
 		bytes  = state->blocksize - (state->blocksize>>2);
 		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
-		leaf = bp->data;
+		leaf = bp->b_addr;
 		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 		count += be16_to_cpu(leaf->hdr.count);
 		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
 		bytes -= count * sizeof(xfs_attr_leaf_entry_t);
 		bytes -= sizeof(xfs_attr_leaf_hdr_t);
-		xfs_da_brelse(state->args->trans, bp);
+		xfs_trans_brelse(state->args->trans, bp);
 		if (bytes >= 0)
 			break;	/* fits with at least 25% to spare */
 	}
@@ -1666,7 +1674,9 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
  * If two leaves are 37% full, when combined they will leave 25% free.
  */
 int
-xfs_attr_leaf_remove(xfs_dabuf_t *bp, xfs_da_args_t *args)
+xfs_attr_leaf_remove(
+	struct xfs_buf	*bp,
+	xfs_da_args_t	*args)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_hdr_t *hdr;
@@ -1676,7 +1686,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	int tablesize, tmp, i;
 	xfs_mount_t *mp;
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	hdr = &leaf->hdr;
 	mp = args->trans->t_mountp;
@@ -1769,7 +1779,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	 */
 	memset(xfs_attr_leaf_name(leaf, args->index), 0, entsize);
 	be16_add_cpu(&hdr->usedbytes, -entsize);
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
 				   entsize));
 
@@ -1777,7 +1787,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xfs_da_args_t *args)
 					* sizeof(xfs_attr_leaf_entry_t);
 	memmove((char *)entry, (char *)(entry+1), tmp);
 	be16_add_cpu(&hdr->count, -1);
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 	    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(*entry)));
 	entry = &leaf->entries[be16_to_cpu(hdr->count)];
 	memset((char *)entry, 0, sizeof(xfs_attr_leaf_entry_t));
@@ -1807,7 +1817,7 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	} else {
 		hdr->holes = 1;		/* mark as needing compaction */
 	}
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 			  XFS_DA_LOGRANGE(leaf, hdr, sizeof(*hdr)));
 
 	/*
@@ -1840,8 +1850,8 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	mp = state->mp;
 	ASSERT(drop_blk->magic == XFS_ATTR_LEAF_MAGIC);
 	ASSERT(save_blk->magic == XFS_ATTR_LEAF_MAGIC);
-	drop_leaf = drop_blk->bp->data;
-	save_leaf = save_blk->bp->data;
+	drop_leaf = drop_blk->bp->b_addr;
+	save_leaf = save_blk->bp->b_addr;
 	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	drop_hdr = &drop_leaf->hdr;
@@ -1906,7 +1916,7 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		kmem_free(tmpbuffer);
 	}
 
-	xfs_da_log_buf(state->args->trans, save_blk->bp, 0,
+	xfs_trans_log_buf(state->args->trans, save_blk->bp, 0,
 					   state->blocksize - 1);
 
 	/*
@@ -1934,7 +1944,9 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
  * Don't change the args->value unless we find the attribute.
  */
 int
-xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
+xfs_attr_leaf_lookup_int(
+	struct xfs_buf	*bp,
+	xfs_da_args_t	*args)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_entry_t *entry;
@@ -1945,7 +1957,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
 
 	trace_xfs_attr_leaf_lookup(args);
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count)
 					< (XFS_LBSIZE(args->dp->i_mount)/8));
@@ -2041,7 +2053,9 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
  * list structure.
  */
 int
-xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, xfs_da_args_t *args)
+xfs_attr_leaf_getvalue(
+	struct xfs_buf	*bp,
+	xfs_da_args_t	*args)
 {
 	int valuelen;
 	xfs_attr_leafblock_t *leaf;
@@ -2049,7 +2063,7 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	xfs_attr_leaf_name_local_t *name_loc;
 	xfs_attr_leaf_name_remote_t *name_rmt;
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count)
 					< (XFS_LBSIZE(args->dp->i_mount)/8));
@@ -2247,12 +2261,14 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
  * Return 0 unless leaf2 should go before leaf1.
  */
 int
-xfs_attr_leaf_order(xfs_dabuf_t *leaf1_bp, xfs_dabuf_t *leaf2_bp)
+xfs_attr_leaf_order(
+	struct xfs_buf	*leaf1_bp,
+	struct xfs_buf	*leaf2_bp)
 {
 	xfs_attr_leafblock_t *leaf1, *leaf2;
 
-	leaf1 = leaf1_bp->data;
-	leaf2 = leaf2_bp->data;
+	leaf1 = leaf1_bp->b_addr;
+	leaf2 = leaf2_bp->b_addr;
 	ASSERT((leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) &&
 	       (leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)));
 	if ((be16_to_cpu(leaf1->hdr.count) > 0) &&
@@ -2272,11 +2288,13 @@ xfs_attr_leaf_order(xfs_dabuf_t *leaf1_bp, xfs_dabuf_t *leaf2_bp)
  * Pick up the last hashvalue from a leaf block.
  */
 xfs_dahash_t
-xfs_attr_leaf_lasthash(xfs_dabuf_t *bp, int *count)
+xfs_attr_leaf_lasthash(
+	struct xfs_buf	*bp,
+	int		*count)
 {
 	xfs_attr_leafblock_t *leaf;
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	if (count)
 		*count = be16_to_cpu(leaf->hdr.count);
@@ -2337,7 +2355,9 @@ xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize, int *local)
  * Copy out attribute list entries for attr_list(), for leaf attribute lists.
  */
 int
-xfs_attr_leaf_list_int(xfs_dabuf_t *bp, xfs_attr_list_context_t *context)
+xfs_attr_leaf_list_int(
+	struct xfs_buf		*bp,
+	xfs_attr_list_context_t	*context)
 {
 	attrlist_cursor_kern_t *cursor;
 	xfs_attr_leafblock_t *leaf;
@@ -2345,7 +2365,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, xfs_attr_list_context_t *context)
 	int retval, i;
 
 	ASSERT(bp != NULL);
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	cursor = context->cursor;
 	cursor->initted = 1;
 
@@ -2463,7 +2483,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_entry_t *entry;
 	xfs_attr_leaf_name_remote_t *name_rmt;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 #ifdef DEBUG
 	xfs_attr_leaf_name_local_t *name_loc;
@@ -2482,7 +2502,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	}
 	ASSERT(bp != NULL);
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
 	ASSERT(args->index >= 0);
@@ -2505,7 +2525,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 #endif /* DEBUG */
 
 	entry->flags &= ~XFS_ATTR_INCOMPLETE;
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 			 XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 
 	if (args->rmtblkno) {
@@ -2513,10 +2533,9 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
-		xfs_da_log_buf(args->trans, bp,
+		xfs_trans_log_buf(args->trans, bp,
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
-	xfs_da_buf_done(bp);
 
 	/*
 	 * Commit the flag value change and start the next trans in series.
@@ -2533,7 +2552,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_entry_t *entry;
 	xfs_attr_leaf_name_remote_t *name_rmt;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 
 	trace_xfs_attr_leaf_setflag(args);
@@ -2548,7 +2567,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	}
 	ASSERT(bp != NULL);
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
 	ASSERT(args->index >= 0);
@@ -2556,16 +2575,15 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 
 	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
 	entry->flags |= XFS_ATTR_INCOMPLETE;
-	xfs_da_log_buf(args->trans, bp,
+	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	if ((entry->flags & XFS_ATTR_LOCAL) == 0) {
 		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
-		xfs_da_log_buf(args->trans, bp,
+		xfs_trans_log_buf(args->trans, bp,
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
-	xfs_da_buf_done(bp);
 
 	/*
 	 * Commit the flag value change and start the next trans in series.
@@ -2586,7 +2604,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	xfs_attr_leafblock_t *leaf1, *leaf2;
 	xfs_attr_leaf_entry_t *entry1, *entry2;
 	xfs_attr_leaf_name_remote_t *name_rmt;
-	xfs_dabuf_t *bp1, *bp2;
+	struct xfs_buf *bp1, *bp2;
 	int error;
 #ifdef DEBUG
 	xfs_attr_leaf_name_local_t *name_loc;
@@ -2620,13 +2638,13 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 		bp2 = bp1;
 	}
 
-	leaf1 = bp1->data;
+	leaf1 = bp1->b_addr;
 	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf1->hdr.count));
 	ASSERT(args->index >= 0);
 	entry1 = &leaf1->entries[ args->index ];
 
-	leaf2 = bp2->data;
+	leaf2 = bp2->b_addr;
 	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index2 < be16_to_cpu(leaf2->hdr.count));
 	ASSERT(args->index2 >= 0);
@@ -2660,30 +2678,27 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	ASSERT((entry2->flags & XFS_ATTR_INCOMPLETE) == 0);
 
 	entry1->flags &= ~XFS_ATTR_INCOMPLETE;
-	xfs_da_log_buf(args->trans, bp1,
+	xfs_trans_log_buf(args->trans, bp1,
 			  XFS_DA_LOGRANGE(leaf1, entry1, sizeof(*entry1)));
 	if (args->rmtblkno) {
 		ASSERT((entry1->flags & XFS_ATTR_LOCAL) == 0);
 		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
-		xfs_da_log_buf(args->trans, bp1,
+		xfs_trans_log_buf(args->trans, bp1,
 			 XFS_DA_LOGRANGE(leaf1, name_rmt, sizeof(*name_rmt)));
 	}
 
 	entry2->flags |= XFS_ATTR_INCOMPLETE;
-	xfs_da_log_buf(args->trans, bp2,
+	xfs_trans_log_buf(args->trans, bp2,
 			  XFS_DA_LOGRANGE(leaf2, entry2, sizeof(*entry2)));
 	if ((entry2->flags & XFS_ATTR_LOCAL) == 0) {
 		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
-		xfs_da_log_buf(args->trans, bp2,
+		xfs_trans_log_buf(args->trans, bp2,
 			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
 	}
-	xfs_da_buf_done(bp1);
-	if (bp1 != bp2)
-		xfs_da_buf_done(bp2);
 
 	/*
 	 * Commit the flag value change and start the next trans in series.
@@ -2706,7 +2721,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 {
 	xfs_da_blkinfo_t *info;
 	xfs_daddr_t blkno;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 
 	/*
@@ -2718,20 +2733,20 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	error = xfs_da_read_buf(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
 	if (error)
 		return(error);
-	blkno = xfs_da_blkno(bp);
+	blkno = XFS_BUF_ADDR(bp);
 
 	/*
 	 * Invalidate the tree, even if the "tree" is only a single leaf block.
 	 * This is a depth-first traversal!
 	 */
-	info = bp->data;
+	info = bp->b_addr;
 	if (info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
 		error = xfs_attr_node_inactive(trans, dp, bp, 1);
 	} else if (info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) {
 		error = xfs_attr_leaf_inactive(trans, dp, bp);
 	} else {
 		error = XFS_ERROR(EIO);
-		xfs_da_brelse(*trans, bp);
+		xfs_trans_brelse(*trans, bp);
 	}
 	if (error)
 		return(error);
@@ -2742,7 +2757,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	error = xfs_da_get_buf(*trans, dp, 0, blkno, &bp, XFS_ATTR_FORK);
 	if (error)
 		return(error);
-	xfs_da_binval(*trans, bp);	/* remove from cache */
+	xfs_trans_binval(*trans, bp);	/* remove from cache */
 	/*
 	 * Commit the invalidate and start the next transaction.
 	 */
@@ -2756,34 +2771,37 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
  * We're doing a depth-first traversal in order to invalidate everything.
  */
 STATIC int
-xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
-				   int level)
+xfs_attr_node_inactive(
+	struct xfs_trans **trans,
+	struct xfs_inode *dp,
+	struct xfs_buf	*bp,
+	int		level)
 {
 	xfs_da_blkinfo_t *info;
 	xfs_da_intnode_t *node;
 	xfs_dablk_t child_fsb;
 	xfs_daddr_t parent_blkno, child_blkno;
 	int error, count, i;
-	xfs_dabuf_t *child_bp;
+	struct xfs_buf *child_bp;
 
 	/*
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_da_brelse(*trans, bp);	/* no locks for later trans */
+		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return(XFS_ERROR(EIO));
 	}
 
-	node = bp->data;
+	node = bp->b_addr;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	parent_blkno = xfs_da_blkno(bp);	/* save for re-read later */
+	parent_blkno = XFS_BUF_ADDR(bp);	/* save for re-read later */
 	count = be16_to_cpu(node->hdr.count);
 	if (!count) {
-		xfs_da_brelse(*trans, bp);
+		xfs_trans_brelse(*trans, bp);
 		return(0);
 	}
 	child_fsb = be32_to_cpu(node->btree[0].before);
-	xfs_da_brelse(*trans, bp);	/* no locks for later trans */
+	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 
 	/*
 	 * If this is the node level just above the leaves, simply loop
@@ -2803,12 +2821,12 @@ xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
 			return(error);
 		if (child_bp) {
 						/* save for re-read later */
-			child_blkno = xfs_da_blkno(child_bp);
+			child_blkno = XFS_BUF_ADDR(child_bp);
 
 			/*
 			 * Invalidate the subtree, however we have to.
 			 */
-			info = child_bp->data;
+			info = child_bp->b_addr;
 			if (info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
 				error = xfs_attr_node_inactive(trans, dp,
 						child_bp, level+1);
@@ -2817,7 +2835,7 @@ xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
 						child_bp);
 			} else {
 				error = XFS_ERROR(EIO);
-				xfs_da_brelse(*trans, child_bp);
+				xfs_trans_brelse(*trans, child_bp);
 			}
 			if (error)
 				return(error);
@@ -2830,7 +2848,7 @@ xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
 				&child_bp, XFS_ATTR_FORK);
 			if (error)
 				return(error);
-			xfs_da_binval(*trans, child_bp);
+			xfs_trans_binval(*trans, child_bp);
 		}
 
 		/*
@@ -2843,7 +2861,7 @@ xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
 			if (error)
 				return(error);
 			child_fsb = be32_to_cpu(node->btree[i+1].before);
-			xfs_da_brelse(*trans, bp);
+			xfs_trans_brelse(*trans, bp);
 		}
 		/*
 		 * Atomically commit the whole invalidate stuff.
@@ -2863,7 +2881,10 @@ xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp,
  * caught holding something that the logging code wants to flush to disk.
  */
 STATIC int
-xfs_attr_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp)
+xfs_attr_leaf_inactive(
+	struct xfs_trans **trans,
+	struct xfs_inode *dp,
+	struct xfs_buf	*bp)
 {
 	xfs_attr_leafblock_t *leaf;
 	xfs_attr_leaf_entry_t *entry;
@@ -2871,7 +2892,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp)
 	xfs_attr_inactive_list_t *list, *lp;
 	int error, count, size, tmp, i;
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 	/*
@@ -2892,7 +2913,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp)
 	 * If there are no "remote" values, we're done.
 	 */
 	if (count == 0) {
-		xfs_da_brelse(*trans, bp);
+		xfs_trans_brelse(*trans, bp);
 		return(0);
 	}
 
@@ -2919,7 +2940,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp, xfs_dabuf_t *bp)
 			}
 		}
 	}
-	xfs_da_brelse(*trans, bp);	/* unlock for trans. in freextent() */
+	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
 
 	/*
 	 * Invalidate each of the "remote" value extents.
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 9c7d22f..dea1772 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -31,7 +31,6 @@
 struct attrlist;
 struct attrlist_cursor_kern;
 struct xfs_attr_list_context;
-struct xfs_dabuf;
 struct xfs_da_args;
 struct xfs_da_state;
 struct xfs_da_state_blk;
@@ -215,7 +214,7 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_list(struct xfs_attr_list_context *context);
-int	xfs_attr_shortform_allfit(struct xfs_dabuf *bp, struct xfs_inode *dp);
+int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
 
 
@@ -223,7 +222,7 @@ int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
  * Internal routines when attribute fork size == XFS_LBSIZE(mp).
  */
 int	xfs_attr_leaf_to_node(struct xfs_da_args *args);
-int	xfs_attr_leaf_to_shortform(struct xfs_dabuf *bp,
+int	xfs_attr_leaf_to_shortform(struct xfs_buf *bp,
 				   struct xfs_da_args *args, int forkoff);
 int	xfs_attr_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr_leaf_setflag(struct xfs_da_args *args);
@@ -235,14 +234,14 @@ int	xfs_attr_leaf_flipflags(xfs_da_args_t *args);
 int	xfs_attr_leaf_split(struct xfs_da_state *state,
 				   struct xfs_da_state_blk *oldblk,
 				   struct xfs_da_state_blk *newblk);
-int	xfs_attr_leaf_lookup_int(struct xfs_dabuf *leaf,
+int	xfs_attr_leaf_lookup_int(struct xfs_buf *leaf,
 					struct xfs_da_args *args);
-int	xfs_attr_leaf_getvalue(struct xfs_dabuf *bp, struct xfs_da_args *args);
-int	xfs_attr_leaf_add(struct xfs_dabuf *leaf_buffer,
+int	xfs_attr_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
+int	xfs_attr_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
-int	xfs_attr_leaf_remove(struct xfs_dabuf *leaf_buffer,
+int	xfs_attr_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);
-int	xfs_attr_leaf_list_int(struct xfs_dabuf *bp,
+int	xfs_attr_leaf_list_int(struct xfs_buf *bp,
 				      struct xfs_attr_list_context *context);
 
 /*
@@ -257,9 +256,9 @@ int	xfs_attr_root_inactive(struct xfs_trans **trans, struct xfs_inode *dp);
 /*
  * Utility routines.
  */
-xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_dabuf *bp, int *count);
-int	xfs_attr_leaf_order(struct xfs_dabuf *leaf1_bp,
-				   struct xfs_dabuf *leaf2_bp);
+xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
+int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
+				   struct xfs_buf *leaf2_bp);
 int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
 					int *local);
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 76e5dba..7bfb7dd 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -83,9 +83,9 @@ STATIC void xfs_da_node_unbalance(xfs_da_state_t *state,
 /*
  * Utility routines.
  */
-STATIC uint	xfs_da_node_lasthash(xfs_dabuf_t *bp, int *count);
-STATIC int	xfs_da_node_order(xfs_dabuf_t *node1_bp, xfs_dabuf_t *node2_bp);
-STATIC xfs_dabuf_t *xfs_da_buf_make(xfs_buf_t *bp);
+STATIC uint	xfs_da_node_lasthash(struct xfs_buf *bp, int *count);
+STATIC int	xfs_da_node_order(struct xfs_buf *node1_bp,
+				  struct xfs_buf *node2_bp);
 STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *drop_blk,
 				  xfs_da_state_blk_t *save_blk);
@@ -100,10 +100,10 @@ STATIC void	xfs_da_state_kill_altpath(xfs_da_state_t *state);
  */
 int
 xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
-				 xfs_dabuf_t **bpp, int whichfork)
+				 struct xfs_buf **bpp, int whichfork)
 {
 	xfs_da_intnode_t *node;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 	xfs_trans_t *tp;
 
@@ -114,7 +114,7 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
-	node = bp->data;
+	node = bp->b_addr;
 	node->hdr.info.forw = 0;
 	node->hdr.info.back = 0;
 	node->hdr.info.magic = cpu_to_be16(XFS_DA_NODE_MAGIC);
@@ -122,7 +122,7 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
 	node->hdr.count = 0;
 	node->hdr.level = cpu_to_be16(level);
 
-	xfs_da_log_buf(tp, bp,
+	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
 	*bpp = bp;
@@ -138,7 +138,7 @@ xfs_da_split(xfs_da_state_t *state)
 {
 	xfs_da_state_blk_t *oldblk, *newblk, *addblk;
 	xfs_da_intnode_t *node;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int max, action, error, i;
 
 	trace_xfs_da_split(state->args);
@@ -203,7 +203,6 @@ xfs_da_split(xfs_da_state_t *state)
 		case XFS_DA_NODE_MAGIC:
 			error = xfs_da_node_split(state, oldblk, newblk, addblk,
 							 max - i, &action);
-			xfs_da_buf_done(addblk->bp);
 			addblk->bp = NULL;
 			if (error)
 				return(error);	/* GROT: dir is inconsistent */
@@ -221,13 +220,6 @@ xfs_da_split(xfs_da_state_t *state)
 		 * Update the btree to show the new hashval for this child.
 		 */
 		xfs_da_fixhashpath(state, &state->path);
-		/*
-		 * If we won't need this block again, it's getting dropped
-		 * from the active path by the loop control, so we need
-		 * to mark it done now.
-		 */
-		if (i > 0 || !addblk)
-			xfs_da_buf_done(oldblk->bp);
 	}
 	if (!addblk)
 		return(0);
@@ -239,8 +231,6 @@ xfs_da_split(xfs_da_state_t *state)
 	oldblk = &state->path.blk[0];
 	error = xfs_da_root_split(state, oldblk, addblk);
 	if (error) {
-		xfs_da_buf_done(oldblk->bp);
-		xfs_da_buf_done(addblk->bp);
 		addblk->bp = NULL;
 		return(error);	/* GROT: dir is inconsistent */
 	}
@@ -252,7 +242,7 @@ xfs_da_split(xfs_da_state_t *state)
 	 * and the original block 0 could be at any position in the list.
 	 */
 
-	node = oldblk->bp->data;
+	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) == addblk->blkno) {
 			bp = addblk->bp;
@@ -260,13 +250,13 @@ xfs_da_split(xfs_da_state_t *state)
 			ASSERT(state->extravalid);
 			bp = state->extrablk.bp;
 		}
-		node = bp->data;
+		node = bp->b_addr;
 		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
-		xfs_da_log_buf(state->args->trans, bp,
+		xfs_trans_log_buf(state->args->trans, bp,
 		    XFS_DA_LOGRANGE(node, &node->hdr.info,
 		    sizeof(node->hdr.info)));
 	}
-	node = oldblk->bp->data;
+	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) == addblk->blkno) {
 			bp = addblk->bp;
@@ -274,14 +264,12 @@ xfs_da_split(xfs_da_state_t *state)
 			ASSERT(state->extravalid);
 			bp = state->extrablk.bp;
 		}
-		node = bp->data;
+		node = bp->b_addr;
 		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
-		xfs_da_log_buf(state->args->trans, bp,
+		xfs_trans_log_buf(state->args->trans, bp,
 		    XFS_DA_LOGRANGE(node, &node->hdr.info,
 		    sizeof(node->hdr.info)));
 	}
-	xfs_da_buf_done(oldblk->bp);
-	xfs_da_buf_done(addblk->bp);
 	addblk->bp = NULL;
 	return(0);
 }
@@ -298,7 +286,7 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	xfs_da_intnode_t *node, *oldroot;
 	xfs_da_args_t *args;
 	xfs_dablk_t blkno;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error, size;
 	xfs_inode_t *dp;
 	xfs_trans_t *tp;
@@ -323,8 +311,8 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
-	node = bp->data;
-	oldroot = blk1->bp->data;
+	node = bp->b_addr;
+	oldroot = blk1->bp->b_addr;
 	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
 		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
 			     (char *)oldroot);
@@ -335,8 +323,7 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 			     (char *)leaf);
 	}
 	memcpy(node, oldroot, size);
-	xfs_da_log_buf(tp, bp, 0, size - 1);
-	xfs_da_buf_done(blk1->bp);
+	xfs_trans_log_buf(tp, bp, 0, size - 1);
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
@@ -348,7 +335,7 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		be16_to_cpu(node->hdr.level) + 1, &bp, args->whichfork);
 	if (error)
 		return(error);
-	node = bp->data;
+	node = bp->b_addr;
 	node->btree[0].hashval = cpu_to_be32(blk1->hashval);
 	node->btree[0].before = cpu_to_be32(blk1->blkno);
 	node->btree[1].hashval = cpu_to_be32(blk2->hashval);
@@ -365,10 +352,9 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 #endif
 
 	/* Header is already logged by xfs_da_node_create */
-	xfs_da_log_buf(tp, bp,
+	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, node->btree,
 			sizeof(xfs_da_node_entry_t) * 2));
-	xfs_da_buf_done(bp);
 
 	return(0);
 }
@@ -389,7 +375,7 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 
 	trace_xfs_da_node_split(state->args);
 
-	node = oldblk->bp->data;
+	node = oldblk->bp->b_addr;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 
 	/*
@@ -436,7 +422,7 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 *
 	 * If we had double-split op below us, then add the extra block too.
 	 */
-	node = oldblk->bp->data;
+	node = oldblk->bp->b_addr;
 	if (oldblk->index <= be16_to_cpu(node->hdr.count)) {
 		oldblk->index++;
 		xfs_da_node_add(state, oldblk, addblk);
@@ -477,8 +463,8 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 
 	trace_xfs_da_node_rebalance(state->args);
 
-	node1 = blk1->bp->data;
-	node2 = blk2->bp->data;
+	node1 = blk1->bp->b_addr;
+	node2 = blk2->bp->b_addr;
 	/*
 	 * Figure out how many entries need to move, and in which direction.
 	 * Swap the nodes around if that makes it simpler.
@@ -532,7 +518,7 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		btree_d = &node1->btree[be16_to_cpu(node1->hdr.count)];
 		memcpy(btree_d, btree_s, tmp);
 		be16_add_cpu(&node1->hdr.count, count);
-		xfs_da_log_buf(tp, blk1->bp,
+		xfs_trans_log_buf(tp, blk1->bp,
 			XFS_DA_LOGRANGE(node1, btree_d, tmp));
 
 		/*
@@ -549,9 +535,9 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	/*
 	 * Log header of node 1 and all current bits of node 2.
 	 */
-	xfs_da_log_buf(tp, blk1->bp,
+	xfs_trans_log_buf(tp, blk1->bp,
 		XFS_DA_LOGRANGE(node1, &node1->hdr, sizeof(node1->hdr)));
-	xfs_da_log_buf(tp, blk2->bp,
+	xfs_trans_log_buf(tp, blk2->bp,
 		XFS_DA_LOGRANGE(node2, &node2->hdr,
 			sizeof(node2->hdr) +
 			sizeof(node2->btree[0]) * be16_to_cpu(node2->hdr.count)));
@@ -560,8 +546,8 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	 * Record the last hashval from each block for upward propagation.
 	 * (note: don't use the swapped node pointers)
 	 */
-	node1 = blk1->bp->data;
-	node2 = blk2->bp->data;
+	node1 = blk1->bp->b_addr;
+	node2 = blk2->bp->b_addr;
 	blk1->hashval = be32_to_cpu(node1->btree[be16_to_cpu(node1->hdr.count)-1].hashval);
 	blk2->hashval = be32_to_cpu(node2->btree[be16_to_cpu(node2->hdr.count)-1].hashval);
 
@@ -587,7 +573,7 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 
 	trace_xfs_da_node_add(state->args);
 
-	node = oldblk->bp->data;
+	node = oldblk->bp->b_addr;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
 	ASSERT(newblk->blkno != 0);
@@ -606,10 +592,10 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	}
 	btree->hashval = cpu_to_be32(newblk->hashval);
 	btree->before = cpu_to_be32(newblk->blkno);
-	xfs_da_log_buf(state->args->trans, oldblk->bp,
+	xfs_trans_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, btree, tmp + sizeof(*btree)));
 	be16_add_cpu(&node->hdr.count, 1);
-	xfs_da_log_buf(state->args->trans, oldblk->bp,
+	xfs_trans_log_buf(state->args->trans, oldblk->bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
 	/*
@@ -735,7 +721,7 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	xfs_da_intnode_t *oldroot;
 	xfs_da_args_t *args;
 	xfs_dablk_t child;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 
 	trace_xfs_da_root_join(state->args);
@@ -743,7 +729,7 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	args = state->args;
 	ASSERT(args != NULL);
 	ASSERT(root_blk->magic == XFS_DA_NODE_MAGIC);
-	oldroot = root_blk->bp->data;
+	oldroot = root_blk->bp->b_addr;
 	ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT(!oldroot->hdr.info.forw);
 	ASSERT(!oldroot->hdr.info.back);
@@ -765,11 +751,11 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
-	xfs_da_blkinfo_onlychild_validate(bp->data,
+	xfs_da_blkinfo_onlychild_validate(bp->b_addr,
 					be16_to_cpu(oldroot->hdr.level));
 
-	memcpy(root_blk->bp->data, bp->data, state->blocksize);
-	xfs_da_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
+	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
+	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
 	return(error);
 }
@@ -791,7 +777,7 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	xfs_da_blkinfo_t *info;
 	int count, forward, error, retval, i;
 	xfs_dablk_t blkno;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 
 	/*
 	 * Check for the degenerate case of the block being over 50% full.
@@ -799,7 +785,7 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	 * to coalesce with a sibling.
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
-	info = blk->bp->data;
+	info = blk->bp->b_addr;
 	ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	node = (xfs_da_intnode_t *)info;
 	count = be16_to_cpu(node->hdr.count);
@@ -859,10 +845,10 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 		count  = state->node_ents;
 		count -= state->node_ents >> 2;
 		count -= be16_to_cpu(node->hdr.count);
-		node = bp->data;
+		node = bp->b_addr;
 		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		count -= be16_to_cpu(node->hdr.count);
-		xfs_da_brelse(state->args->trans, bp);
+		xfs_trans_brelse(state->args->trans, bp);
 		if (count >= 0)
 			break;	/* fits with at least 25% to spare */
 	}
@@ -934,14 +920,14 @@ xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
 		break;
 	}
 	for (blk--, level--; level >= 0; blk--, level--) {
-		node = blk->bp->data;
+		node = blk->bp->b_addr;
 		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		btree = &node->btree[ blk->index ];
 		if (be32_to_cpu(btree->hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
 		btree->hashval = cpu_to_be32(lasthash);
-		xfs_da_log_buf(state->args->trans, blk->bp,
+		xfs_trans_log_buf(state->args->trans, blk->bp,
 				  XFS_DA_LOGRANGE(node, btree, sizeof(*btree)));
 
 		lasthash = be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1].hashval);
@@ -960,7 +946,7 @@ xfs_da_node_remove(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk)
 
 	trace_xfs_da_node_remove(state->args);
 
-	node = drop_blk->bp->data;
+	node = drop_blk->bp->b_addr;
 	ASSERT(drop_blk->index < be16_to_cpu(node->hdr.count));
 	ASSERT(drop_blk->index >= 0);
 
@@ -972,15 +958,15 @@ xfs_da_node_remove(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk)
 		tmp  = be16_to_cpu(node->hdr.count) - drop_blk->index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
 		memmove(btree, btree + 1, tmp);
-		xfs_da_log_buf(state->args->trans, drop_blk->bp,
+		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 		    XFS_DA_LOGRANGE(node, btree, tmp));
 		btree = &node->btree[be16_to_cpu(node->hdr.count)-1];
 	}
 	memset((char *)btree, 0, sizeof(xfs_da_node_entry_t));
-	xfs_da_log_buf(state->args->trans, drop_blk->bp,
+	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, btree, sizeof(*btree)));
 	be16_add_cpu(&node->hdr.count, -1);
-	xfs_da_log_buf(state->args->trans, drop_blk->bp,
+	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
 	/*
@@ -1005,8 +991,8 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 
 	trace_xfs_da_node_unbalance(state->args);
 
-	drop_node = drop_blk->bp->data;
-	save_node = save_blk->bp->data;
+	drop_node = drop_blk->bp->b_addr;
+	save_node = save_blk->bp->b_addr;
 	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT(save_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	tp = state->args->trans;
@@ -1023,13 +1009,13 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		tmp = be16_to_cpu(save_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
 		memmove(btree, &save_node->btree[0], tmp);
 		btree = &save_node->btree[0];
-		xfs_da_log_buf(tp, save_blk->bp,
+		xfs_trans_log_buf(tp, save_blk->bp,
 			XFS_DA_LOGRANGE(save_node, btree,
 				(be16_to_cpu(save_node->hdr.count) + be16_to_cpu(drop_node->hdr.count)) *
 				sizeof(xfs_da_node_entry_t)));
 	} else {
 		btree = &save_node->btree[be16_to_cpu(save_node->hdr.count)];
-		xfs_da_log_buf(tp, save_blk->bp,
+		xfs_trans_log_buf(tp, save_blk->bp,
 			XFS_DA_LOGRANGE(save_node, btree,
 				be16_to_cpu(drop_node->hdr.count) *
 				sizeof(xfs_da_node_entry_t)));
@@ -1042,7 +1028,7 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	memcpy(btree, &drop_node->btree[0], tmp);
 	be16_add_cpu(&save_node->hdr.count, be16_to_cpu(drop_node->hdr.count));
 
-	xfs_da_log_buf(tp, save_blk->bp,
+	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
 			sizeof(save_node->hdr)));
 
@@ -1100,7 +1086,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 			state->path.active--;
 			return(error);
 		}
-		curr = blk->bp->data;
+		curr = blk->bp->b_addr;
 		blk->magic = be16_to_cpu(curr->magic);
 		ASSERT(blk->magic == XFS_DA_NODE_MAGIC ||
 		       blk->magic == XFS_DIR2_LEAFN_MAGIC ||
@@ -1110,7 +1096,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		 * Search an intermediate node for a match.
 		 */
 		if (blk->magic == XFS_DA_NODE_MAGIC) {
-			node = blk->bp->data;
+			node = blk->bp->b_addr;
 			max = be16_to_cpu(node->hdr.count);
 			blk->hashval = be32_to_cpu(node->btree[max-1].hashval);
 
@@ -1216,15 +1202,15 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 	xfs_da_blkinfo_t *old_info, *new_info, *tmp_info;
 	xfs_da_args_t *args;
 	int before=0, error;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 
 	/*
 	 * Set up environment.
 	 */
 	args = state->args;
 	ASSERT(args != NULL);
-	old_info = old_blk->bp->data;
-	new_info = new_blk->bp->data;
+	old_info = old_blk->bp->b_addr;
+	new_info = new_blk->bp->b_addr;
 	ASSERT(old_blk->magic == XFS_DA_NODE_MAGIC ||
 	       old_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 	       old_blk->magic == XFS_ATTR_LEAF_MAGIC);
@@ -1261,12 +1247,11 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
-			tmp_info = bp->data;
+			tmp_info = bp->b_addr;
 			ASSERT(be16_to_cpu(tmp_info->magic) == be16_to_cpu(old_info->magic));
 			ASSERT(be32_to_cpu(tmp_info->forw) == old_blk->blkno);
 			tmp_info->forw = cpu_to_be32(new_blk->blkno);
-			xfs_da_log_buf(args->trans, bp, 0, sizeof(*tmp_info)-1);
-			xfs_da_buf_done(bp);
+			xfs_trans_log_buf(args->trans, bp, 0, sizeof(*tmp_info)-1);
 		}
 		old_info->back = cpu_to_be32(new_blk->blkno);
 	} else {
@@ -1283,18 +1268,17 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
-			tmp_info = bp->data;
+			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == old_info->magic);
 			ASSERT(be32_to_cpu(tmp_info->back) == old_blk->blkno);
 			tmp_info->back = cpu_to_be32(new_blk->blkno);
-			xfs_da_log_buf(args->trans, bp, 0, sizeof(*tmp_info)-1);
-			xfs_da_buf_done(bp);
+			xfs_trans_log_buf(args->trans, bp, 0, sizeof(*tmp_info)-1);
 		}
 		old_info->forw = cpu_to_be32(new_blk->blkno);
 	}
 
-	xfs_da_log_buf(args->trans, old_blk->bp, 0, sizeof(*tmp_info) - 1);
-	xfs_da_log_buf(args->trans, new_blk->bp, 0, sizeof(*tmp_info) - 1);
+	xfs_trans_log_buf(args->trans, old_blk->bp, 0, sizeof(*tmp_info) - 1);
+	xfs_trans_log_buf(args->trans, new_blk->bp, 0, sizeof(*tmp_info) - 1);
 	return(0);
 }
 
@@ -1302,12 +1286,14 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
  * Compare two intermediate nodes for "order".
  */
 STATIC int
-xfs_da_node_order(xfs_dabuf_t *node1_bp, xfs_dabuf_t *node2_bp)
+xfs_da_node_order(
+	struct xfs_buf	*node1_bp,
+	struct xfs_buf	*node2_bp)
 {
 	xfs_da_intnode_t *node1, *node2;
 
-	node1 = node1_bp->data;
-	node2 = node2_bp->data;
+	node1 = node1_bp->b_addr;
+	node2 = node2_bp->b_addr;
 	ASSERT(node1->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) &&
 	       node2->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	if ((be16_to_cpu(node1->hdr.count) > 0) && (be16_to_cpu(node2->hdr.count) > 0) &&
@@ -1324,11 +1310,13 @@ xfs_da_node_order(xfs_dabuf_t *node1_bp, xfs_dabuf_t *node2_bp)
  * Pick up the last hashvalue from an intermediate node.
  */
 STATIC uint
-xfs_da_node_lasthash(xfs_dabuf_t *bp, int *count)
+xfs_da_node_lasthash(
+	struct xfs_buf	*bp,
+	int		*count)
 {
 	xfs_da_intnode_t *node;
 
-	node = bp->data;
+	node = bp->b_addr;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	if (count)
 		*count = be16_to_cpu(node->hdr.count);
@@ -1346,7 +1334,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 {
 	xfs_da_blkinfo_t *drop_info, *save_info, *tmp_info;
 	xfs_da_args_t *args;
-	xfs_dabuf_t *bp;
+	struct xfs_buf *bp;
 	int error;
 
 	/*
@@ -1354,8 +1342,8 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	 */
 	args = state->args;
 	ASSERT(args != NULL);
-	save_info = save_blk->bp->data;
-	drop_info = drop_blk->bp->data;
+	save_info = save_blk->bp->b_addr;
+	drop_info = drop_blk->bp->b_addr;
 	ASSERT(save_blk->magic == XFS_DA_NODE_MAGIC ||
 	       save_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 	       save_blk->magic == XFS_ATTR_LEAF_MAGIC);
@@ -1380,13 +1368,12 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
-			tmp_info = bp->data;
+			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == save_info->magic);
 			ASSERT(be32_to_cpu(tmp_info->forw) == drop_blk->blkno);
 			tmp_info->forw = cpu_to_be32(save_blk->blkno);
-			xfs_da_log_buf(args->trans, bp, 0,
+			xfs_trans_log_buf(args->trans, bp, 0,
 						    sizeof(*tmp_info) - 1);
-			xfs_da_buf_done(bp);
 		}
 	} else {
 		trace_xfs_da_unlink_forward(args);
@@ -1398,17 +1385,16 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
-			tmp_info = bp->data;
+			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == save_info->magic);
 			ASSERT(be32_to_cpu(tmp_info->back) == drop_blk->blkno);
 			tmp_info->back = cpu_to_be32(save_blk->blkno);
-			xfs_da_log_buf(args->trans, bp, 0,
+			xfs_trans_log_buf(args->trans, bp, 0,
 						    sizeof(*tmp_info) - 1);
-			xfs_da_buf_done(bp);
 		}
 	}
 
-	xfs_da_log_buf(args->trans, save_blk->bp, 0, sizeof(*save_info) - 1);
+	xfs_trans_log_buf(args->trans, save_blk->bp, 0, sizeof(*save_info) - 1);
 	return(0);
 }
 
@@ -1443,7 +1429,7 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
 	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
 		ASSERT(blk->bp != NULL);
-		node = blk->bp->data;
+		node = blk->bp->b_addr;
 		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		if (forward && (blk->index < be16_to_cpu(node->hdr.count)-1)) {
 			blk->index++;
@@ -1471,7 +1457,7 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 		 * (if it's dirty, trans won't actually let go)
 		 */
 		if (release)
-			xfs_da_brelse(args->trans, blk->bp);
+			xfs_trans_brelse(args->trans, blk->bp);
 
 		/*
 		 * Read the next child block.
@@ -1482,7 +1468,7 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 		if (error)
 			return(error);
 		ASSERT(blk->bp != NULL);
-		info = blk->bp->data;
+		info = blk->bp->b_addr;
 		ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
@@ -1702,11 +1688,13 @@ xfs_da_grow_inode(
  * a bmap btree split to do that.
  */
 STATIC int
-xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
-		      xfs_dabuf_t **dead_bufp)
+xfs_da_swap_lastblock(
+	xfs_da_args_t	*args,
+	xfs_dablk_t	*dead_blknop,
+	struct xfs_buf	**dead_bufp)
 {
 	xfs_dablk_t dead_blkno, last_blkno, sib_blkno, par_blkno;
-	xfs_dabuf_t *dead_buf, *last_buf, *sib_buf, *par_buf;
+	struct xfs_buf *dead_buf, *last_buf, *sib_buf, *par_buf;
 	xfs_fileoff_t lastoff;
 	xfs_inode_t *ip;
 	xfs_trans_t *tp;
@@ -1744,9 +1732,9 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	/*
 	 * Copy the last block into the dead buffer and log it.
 	 */
-	memcpy(dead_buf->data, last_buf->data, mp->m_dirblksize);
-	xfs_da_log_buf(tp, dead_buf, 0, mp->m_dirblksize - 1);
-	dead_info = dead_buf->data;
+	memcpy(dead_buf->b_addr, last_buf->b_addr, mp->m_dirblksize);
+	xfs_trans_log_buf(tp, dead_buf, 0, mp->m_dirblksize - 1);
+	dead_info = dead_buf->b_addr;
 	/*
 	 * Get values from the moved block.
 	 */
@@ -1767,7 +1755,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
 		if ((error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w)))
 			goto done;
-		sib_info = sib_buf->data;
+		sib_info = sib_buf->b_addr;
 		if (unlikely(
 		    be32_to_cpu(sib_info->forw) != last_blkno ||
 		    sib_info->magic != dead_info->magic)) {
@@ -1777,10 +1765,9 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 			goto done;
 		}
 		sib_info->forw = cpu_to_be32(dead_blkno);
-		xfs_da_log_buf(tp, sib_buf,
+		xfs_trans_log_buf(tp, sib_buf,
 			XFS_DA_LOGRANGE(sib_info, &sib_info->forw,
 					sizeof(sib_info->forw)));
-		xfs_da_buf_done(sib_buf);
 		sib_buf = NULL;
 	}
 	/*
@@ -1789,7 +1776,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
 		if ((error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w)))
 			goto done;
-		sib_info = sib_buf->data;
+		sib_info = sib_buf->b_addr;
 		if (unlikely(
 		       be32_to_cpu(sib_info->back) != last_blkno ||
 		       sib_info->magic != dead_info->magic)) {
@@ -1799,10 +1786,9 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 			goto done;
 		}
 		sib_info->back = cpu_to_be32(dead_blkno);
-		xfs_da_log_buf(tp, sib_buf,
+		xfs_trans_log_buf(tp, sib_buf,
 			XFS_DA_LOGRANGE(sib_info, &sib_info->back,
 					sizeof(sib_info->back)));
-		xfs_da_buf_done(sib_buf);
 		sib_buf = NULL;
 	}
 	par_blkno = mp->m_dirleafblk;
@@ -1813,7 +1799,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	for (;;) {
 		if ((error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w)))
 			goto done;
-		par_node = par_buf->data;
+		par_node = par_buf->b_addr;
 		if (unlikely(par_node->hdr.info.magic !=
 		    cpu_to_be16(XFS_DA_NODE_MAGIC) ||
 		    (level >= 0 && level != be16_to_cpu(par_node->hdr.level) + 1))) {
@@ -1837,7 +1823,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 		par_blkno = be32_to_cpu(par_node->btree[entno].before);
 		if (level == dead_level + 1)
 			break;
-		xfs_da_brelse(tp, par_buf);
+		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 	}
 	/*
@@ -1853,7 +1839,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 		if (entno < be16_to_cpu(par_node->hdr.count))
 			break;
 		par_blkno = be32_to_cpu(par_node->hdr.info.forw);
-		xfs_da_brelse(tp, par_buf);
+		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (unlikely(par_blkno == 0)) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(6)",
@@ -1863,7 +1849,7 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 		}
 		if ((error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w)))
 			goto done;
-		par_node = par_buf->data;
+		par_node = par_buf->b_addr;
 		if (unlikely(
 		    be16_to_cpu(par_node->hdr.level) != level ||
 		    par_node->hdr.info.magic != cpu_to_be16(XFS_DA_NODE_MAGIC))) {
@@ -1878,20 +1864,18 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	 * Update the parent entry pointing to the moved block.
 	 */
 	par_node->btree[entno].before = cpu_to_be32(dead_blkno);
-	xfs_da_log_buf(tp, par_buf,
+	xfs_trans_log_buf(tp, par_buf,
 		XFS_DA_LOGRANGE(par_node, &par_node->btree[entno].before,
 				sizeof(par_node->btree[entno].before)));
-	xfs_da_buf_done(par_buf);
-	xfs_da_buf_done(dead_buf);
 	*dead_blknop = last_blkno;
 	*dead_bufp = last_buf;
 	return 0;
 done:
 	if (par_buf)
-		xfs_da_brelse(tp, par_buf);
+		xfs_trans_brelse(tp, par_buf);
 	if (sib_buf)
-		xfs_da_brelse(tp, sib_buf);
-	xfs_da_brelse(tp, last_buf);
+		xfs_trans_brelse(tp, sib_buf);
+	xfs_trans_brelse(tp, last_buf);
 	return error;
 }
 
@@ -1899,8 +1883,10 @@ done:
  * Remove a btree block from a directory or attribute.
  */
 int
-xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
-		    xfs_dabuf_t *dead_buf)
+xfs_da_shrink_inode(
+	xfs_da_args_t	*args,
+	xfs_dablk_t	dead_blkno,
+	struct xfs_buf	*dead_buf)
 {
 	xfs_inode_t *dp;
 	int done, error, w, count;
@@ -1935,7 +1921,7 @@ xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 			break;
 		}
 	}
-	xfs_da_binval(tp, dead_buf);
+	xfs_trans_binval(tp, dead_buf);
 	return error;
 }
 
@@ -2099,7 +2085,7 @@ xfs_da_get_buf(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
-	xfs_dabuf_t		**bpp,
+	struct xfs_buf		**bpp,
 	int			whichfork)
 {
 	struct xfs_buf		*bp;
@@ -2128,7 +2114,7 @@ xfs_da_get_buf(
 		goto out_free;
 	}
 
-	*bpp = xfs_da_buf_make(bp);
+	*bpp = bp;
 
 out_free:
 	if (mapp != &map)
@@ -2146,7 +2132,7 @@ xfs_da_read_buf(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
-	xfs_dabuf_t		**bpp,
+	struct xfs_buf		**bpp,
 	int			whichfork)
 {
 	struct xfs_buf		*bp;
@@ -2178,16 +2164,14 @@ xfs_da_read_buf(
 	else
 		xfs_buf_set_ref(bp, XFS_DIR_BTREE_REF);
 
-	*bpp = xfs_da_buf_make(bp);
-
 	/*
 	 * This verification code will be moved to a CRC verification callback
 	 * function so just leave it here unchanged until then.
 	 */
 	{
-		xfs_dir2_data_hdr_t	*hdr = (*bpp)->data;
-		xfs_dir2_free_t		*free = (*bpp)->data;
-		xfs_da_blkinfo_t	*info = (*bpp)->data;
+		xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
+		xfs_dir2_free_t		*free = bp->b_addr;
+		xfs_da_blkinfo_t	*info = bp->b_addr;
 		uint			magic, magic1;
 		struct xfs_mount	*mp = dp->i_mount;
 
@@ -2207,11 +2191,11 @@ xfs_da_read_buf(
 			XFS_CORRUPTION_ERROR("xfs_da_do_buf(2)",
 					     XFS_ERRLEVEL_LOW, mp, info);
 			error = XFS_ERROR(EFSCORRUPTED);
-			xfs_da_brelse(trans, *bpp);
+			xfs_trans_brelse(trans, bp);
 			goto out_free;
 		}
 	}
-
+	*bpp = bp;
 out_free:
 	if (mapp != &map)
 		kmem_free(mapp);
@@ -2259,7 +2243,6 @@ out_free:
 }
 
 kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
-kmem_zone_t *xfs_dabuf_zone;		/* dabuf zone */
 
 /*
  * Allocate a dir-state structure.
@@ -2279,13 +2262,8 @@ xfs_da_state_kill_altpath(xfs_da_state_t *state)
 {
 	int	i;
 
-	for (i = 0; i < state->altpath.active; i++) {
-		if (state->altpath.blk[i].bp) {
-			if (state->altpath.blk[i].bp != state->path.blk[i].bp)
-				xfs_da_buf_done(state->altpath.blk[i].bp);
-			state->altpath.blk[i].bp = NULL;
-		}
-	}
+	for (i = 0; i < state->altpath.active; i++)
+		state->altpath.blk[i].bp = NULL;
 	state->altpath.active = 0;
 }
 
@@ -2295,88 +2273,9 @@ xfs_da_state_kill_altpath(xfs_da_state_t *state)
 void
 xfs_da_state_free(xfs_da_state_t *state)
 {
-	int	i;
-
 	xfs_da_state_kill_altpath(state);
-	for (i = 0; i < state->path.active; i++) {
-		if (state->path.blk[i].bp)
-			xfs_da_buf_done(state->path.blk[i].bp);
-	}
-	if (state->extravalid && state->extrablk.bp)
-		xfs_da_buf_done(state->extrablk.bp);
 #ifdef DEBUG
 	memset((char *)state, 0, sizeof(*state));
 #endif /* DEBUG */
 	kmem_zone_free(xfs_da_state_zone, state);
 }
-
-/*
- * Create a dabuf.
- */
-/* ARGSUSED */
-STATIC xfs_dabuf_t *
-xfs_da_buf_make(xfs_buf_t *bp)
-{
-	xfs_dabuf_t	*dabuf;
-
-	dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_NOFS);
-	dabuf->bbcount = bp->b_length;
-	dabuf->data = bp->b_addr;
-	dabuf->bp = bp;
-	return dabuf;
-}
-
-/*
- * Release a dabuf.
- */
-void
-xfs_da_buf_done(xfs_dabuf_t *dabuf)
-{
-	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
-	kmem_zone_free(xfs_dabuf_zone, dabuf);
-}
-
-/*
- * Log transaction from a dabuf.
- */
-void
-xfs_da_log_buf(xfs_trans_t *tp, xfs_dabuf_t *dabuf, uint first, uint last)
-{
-	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
-	ASSERT(dabuf->data == dabuf->bp->b_addr);
-	xfs_trans_log_buf(tp, dabuf->bp, first, last);
-}
-
-/*
- * Release dabuf from a transaction.
- * Have to free up the dabuf before the buffers are released,
- * since the synchronization on the dabuf is really the lock on the buffer.
- */
-void
-xfs_da_brelse(xfs_trans_t *tp, xfs_dabuf_t *dabuf)
-{
-	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
-	xfs_trans_brelse(tp, dabuf->bp);
-	xfs_da_buf_done(dabuf);
-}
-
-/*
- * Invalidate dabuf from a transaction.
- */
-void
-xfs_da_binval(xfs_trans_t *tp, xfs_dabuf_t *dabuf)
-{
-	ASSERT(dabuf->data && dabuf->bbcount && dabuf->bp);
-	xfs_da_buf_done(dabuf);
-	xfs_trans_binval(tp, dabuf->bp);
-}
-
-/*
- * Get the first daddr from a dabuf.
- */
-xfs_daddr_t
-xfs_da_blkno(xfs_dabuf_t *dabuf)
-{
-	ASSERT(dabuf->data);
-	return XFS_BUF_ADDR(dabuf->bp);
-}
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 0b64c4a..9f37aa0 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -133,20 +133,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }
 
 /*
- * Structure to describe buffer(s) for a block.
- * This is needed in the directory version 2 format case, when
- * multiple non-contiguous fsblocks might be needed to cover one
- * logical directory block.
- * If the buffer count is 1 then the data pointer points to the
- * same place as the b_addr field for the buffer, else to kmem_alloced memory.
- */
-typedef struct xfs_dabuf {
-	short		bbcount;	/* how large is data in bbs */
-	void		*data;		/* pointer for buffers' data */
-	struct xfs_buf	*bp;		/* actually nbuf of these */
-} xfs_dabuf_t;
-
-/*
  * Storage for holding state during Btree searches and split/join ops.
  *
  * Only need space for 5 intermediate nodes.  With a minimum of 62-way
@@ -154,7 +140,7 @@ typedef struct xfs_dabuf {
  * which is slightly more than enough.
  */
 typedef struct xfs_da_state_blk {
-	xfs_dabuf_t	*bp;		/* buffer containing block */
+	struct xfs_buf	*bp;		/* buffer containing block */
 	xfs_dablk_t	blkno;		/* filesystem blkno of buffer */
 	xfs_daddr_t	disk_blkno;	/* on-disk blkno (in BBs) of buffer */
 	int		index;		/* relevant index into block */
@@ -207,7 +193,7 @@ struct xfs_nameops {
  * Routines used for growing the Btree.
  */
 int	xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
-					 xfs_dabuf_t **bpp, int whichfork);
+					 struct xfs_buf **bpp, int whichfork);
 int	xfs_da_split(xfs_da_state_t *state);
 
 /*
@@ -237,14 +223,14 @@ int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
 			      int count);
 int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			      xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			      xfs_dabuf_t **bp, int whichfork);
+			      struct xfs_buf **bp, int whichfork);
 int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			       xfs_dabuf_t **bpp, int whichfork);
+			       struct xfs_buf **bpp, int whichfork);
 xfs_daddr_t	xfs_da_reada_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			xfs_dablk_t bno, int whichfork);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
-					  xfs_dabuf_t *dead_buf);
+					  struct xfs_buf *dead_buf);
 
 uint xfs_da_hashname(const __uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
@@ -254,15 +240,7 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
 
-void xfs_da_buf_done(xfs_dabuf_t *dabuf);
-void xfs_da_log_buf(struct xfs_trans *tp, xfs_dabuf_t *dabuf, uint first,
-			   uint last);
-void xfs_da_brelse(struct xfs_trans *tp, xfs_dabuf_t *dabuf);
-void xfs_da_binval(struct xfs_trans *tp, xfs_dabuf_t *dabuf);
-xfs_daddr_t xfs_da_blkno(xfs_dabuf_t *dabuf);
-
 extern struct kmem_zone *xfs_da_state_zone;
-extern struct kmem_zone *xfs_dabuf_zone;
 extern const struct xfs_nameops xfs_default_nameops;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 67a250c..b26a50f 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -592,7 +592,7 @@ int
 xfs_dir2_shrink_inode(
 	xfs_da_args_t	*args,
 	xfs_dir2_db_t	db,
-	xfs_dabuf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	xfs_fileoff_t	bno;		/* directory file offset */
 	xfs_dablk_t	da;		/* directory file offset */
@@ -634,7 +634,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * Invalidate the buffer from the transaction.
 	 */
-	xfs_da_binval(tp, bp);
+	xfs_trans_binval(tp, bp);
 	/*
 	 * If it's not a data block, we're done.
 	 */
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 586732f..e93ca8f 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -37,10 +37,10 @@
 /*
  * Local function prototypes.
  */
-static void xfs_dir2_block_log_leaf(xfs_trans_t *tp, xfs_dabuf_t *bp, int first,
-				    int last);
-static void xfs_dir2_block_log_tail(xfs_trans_t *tp, xfs_dabuf_t *bp);
-static int xfs_dir2_block_lookup_int(xfs_da_args_t *args, xfs_dabuf_t **bpp,
+static void xfs_dir2_block_log_leaf(xfs_trans_t *tp, struct xfs_buf *bp,
+				    int first, int last);
+static void xfs_dir2_block_log_tail(xfs_trans_t *tp, struct xfs_buf *bp);
+static int xfs_dir2_block_lookup_int(xfs_da_args_t *args, struct xfs_buf **bpp,
 				     int *entno);
 static int xfs_dir2_block_sort(const void *a, const void *b);
 
@@ -66,7 +66,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_free_t	*bf;		/* bestfree table in block */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
-	xfs_dabuf_t		*bp;		/* buffer for block */
+	struct xfs_buf		*bp;		/* buffer for block */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	int			compact;	/* need to compact leaf ents */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
@@ -102,14 +102,14 @@ xfs_dir2_block_addname(
 		return error;
 	}
 	ASSERT(bp != NULL);
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	/*
 	 * Check the magic number, corrupted if wrong.
 	 */
 	if (unlikely(hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))) {
 		XFS_CORRUPTION_ERROR("xfs_dir2_block_addname",
 				     XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_da_brelse(tp, bp);
+		xfs_trans_brelse(tp, bp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	len = xfs_dir2_data_entsize(args->namelen);
@@ -212,7 +212,7 @@ xfs_dir2_block_addname(
 	 * If this isn't a real add, we're done with the buffer.
 	 */
 	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
-		xfs_da_brelse(tp, bp);
+		xfs_trans_brelse(tp, bp);
 	/*
 	 * If we don't have space for the new entry & leaf ...
 	 */
@@ -228,7 +228,6 @@ xfs_dir2_block_addname(
 		 * Then add the new entry in that format.
 		 */
 		error = xfs_dir2_block_to_leaf(args, bp);
-		xfs_da_buf_done(bp);
 		if (error)
 			return error;
 		return xfs_dir2_leaf_addname(args);
@@ -422,7 +421,6 @@ xfs_dir2_block_addname(
 	xfs_dir2_block_log_tail(tp, bp);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	xfs_dir2_data_check(dp, bp);
-	xfs_da_buf_done(bp);
 	return 0;
 }
 
@@ -437,7 +435,7 @@ xfs_dir2_block_getdents(
 	filldir_t		filldir)
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
-	xfs_dabuf_t		*bp;		/* buffer for block */
+	struct xfs_buf		*bp;		/* buffer for block */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
 	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
@@ -469,7 +467,7 @@ xfs_dir2_block_getdents(
 	 * We'll skip entries before this.
 	 */
 	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	xfs_dir2_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
@@ -514,7 +512,7 @@ xfs_dir2_block_getdents(
 			    cook & 0x7fffffff, be64_to_cpu(dep->inumber),
 			    DT_UNKNOWN)) {
 			*offset = cook & 0x7fffffff;
-			xfs_da_brelse(NULL, bp);
+			xfs_trans_brelse(NULL, bp);
 			return 0;
 		}
 	}
@@ -525,7 +523,7 @@ xfs_dir2_block_getdents(
 	 */
 	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
 			0x7fffffff;
-	xfs_da_brelse(NULL, bp);
+	xfs_trans_brelse(NULL, bp);
 	return 0;
 }
 
@@ -535,17 +533,17 @@ xfs_dir2_block_getdents(
 static void
 xfs_dir2_block_log_leaf(
 	xfs_trans_t		*tp,		/* transaction structure */
-	xfs_dabuf_t		*bp,		/* block buffer */
+	struct xfs_buf		*bp,		/* block buffer */
 	int			first,		/* index of first logged leaf */
 	int			last)		/* index of last logged leaf */
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 	xfs_dir2_leaf_entry_t	*blp;
 	xfs_dir2_block_tail_t	*btp;
 
 	btp = xfs_dir2_block_tail_p(tp->t_mountp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
-	xfs_da_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)hdr),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)hdr),
 		(uint)((char *)&blp[last + 1] - (char *)hdr - 1));
 }
 
@@ -555,13 +553,13 @@ xfs_dir2_block_log_leaf(
 static void
 xfs_dir2_block_log_tail(
 	xfs_trans_t		*tp,		/* transaction structure */
-	xfs_dabuf_t		*bp)		/* block buffer */
+	struct xfs_buf		*bp)		/* block buffer */
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 	xfs_dir2_block_tail_t	*btp;
 
 	btp = xfs_dir2_block_tail_p(tp->t_mountp, hdr);
-	xfs_da_log_buf(tp, bp, (uint)((char *)btp - (char *)hdr),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)btp - (char *)hdr),
 		(uint)((char *)(btp + 1) - (char *)hdr - 1));
 }
 
@@ -575,7 +573,7 @@ xfs_dir2_block_lookup(
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
-	xfs_dabuf_t		*bp;		/* block buffer */
+	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
 	xfs_inode_t		*dp;		/* incore inode */
@@ -593,7 +591,7 @@ xfs_dir2_block_lookup(
 		return error;
 	dp = args->dp;
 	mp = dp->i_mount;
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	xfs_dir2_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
@@ -607,7 +605,7 @@ xfs_dir2_block_lookup(
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
-	xfs_da_brelse(args->trans, bp);
+	xfs_trans_brelse(args->trans, bp);
 	return XFS_ERROR(error);
 }
 
@@ -617,13 +615,13 @@ xfs_dir2_block_lookup(
 static int					/* error */
 xfs_dir2_block_lookup_int(
 	xfs_da_args_t		*args,		/* dir lookup arguments */
-	xfs_dabuf_t		**bpp,		/* returned block buffer */
+	struct xfs_buf		**bpp,		/* returned block buffer */
 	int			*entno)		/* returned entry number */
 {
 	xfs_dir2_dataptr_t	addr;		/* data entry address */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
-	xfs_dabuf_t		*bp;		/* block buffer */
+	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
 	xfs_inode_t		*dp;		/* incore inode */
@@ -647,7 +645,7 @@ xfs_dir2_block_lookup_int(
 		return error;
 	}
 	ASSERT(bp != NULL);
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	xfs_dir2_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
@@ -666,7 +664,7 @@ xfs_dir2_block_lookup_int(
 			high = mid - 1;
 		if (low > high) {
 			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
-			xfs_da_brelse(tp, bp);
+			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(ENOENT);
 		}
 	}
@@ -714,7 +712,7 @@ xfs_dir2_block_lookup_int(
 	/*
 	 * No match, release the buffer and return ENOENT.
 	 */
-	xfs_da_brelse(tp, bp);
+	xfs_trans_brelse(tp, bp);
 	return XFS_ERROR(ENOENT);
 }
 
@@ -728,7 +726,7 @@ xfs_dir2_block_removename(
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf pointer */
-	xfs_dabuf_t		*bp;		/* block buffer */
+	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
 	xfs_inode_t		*dp;		/* incore inode */
@@ -753,7 +751,7 @@ xfs_dir2_block_removename(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
@@ -790,10 +788,9 @@ xfs_dir2_block_removename(
 	 * See if the size as a shortform is good enough.
 	 */
 	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
-	if (size > XFS_IFORK_DSIZE(dp)) {
-		xfs_da_buf_done(bp);
+	if (size > XFS_IFORK_DSIZE(dp))
 		return 0;
-	}
+
 	/*
 	 * If it works, do the conversion.
 	 */
@@ -810,7 +807,7 @@ xfs_dir2_block_replace(
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
-	xfs_dabuf_t		*bp;		/* block buffer */
+	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
 	xfs_inode_t		*dp;		/* incore inode */
@@ -829,7 +826,7 @@ xfs_dir2_block_replace(
 	}
 	dp = args->dp;
 	mp = dp->i_mount;
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
@@ -844,7 +841,6 @@ xfs_dir2_block_replace(
 	dep->inumber = cpu_to_be64(args->inumber);
 	xfs_dir2_data_log_entry(args->trans, bp, dep);
 	xfs_dir2_data_check(dp, bp);
-	xfs_da_buf_done(bp);
 	return 0;
 }
 
@@ -871,8 +867,8 @@ xfs_dir2_block_sort(
 int						/* error */
 xfs_dir2_leaf_to_block(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*lbp,		/* leaf buffer */
-	xfs_dabuf_t		*dbp)		/* data buffer */
+	struct xfs_buf		*lbp,		/* leaf buffer */
+	struct xfs_buf		*dbp)		/* data buffer */
 {
 	__be16			*bestsp;	/* leaf bests table */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
@@ -898,7 +894,7 @@ xfs_dir2_leaf_to_block(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	/*
@@ -914,11 +910,9 @@ xfs_dir2_leaf_to_block(
 			if ((error =
 			    xfs_dir2_leaf_trim_data(args, lbp,
 				    (xfs_dir2_db_t)(be32_to_cpu(ltp->bestcount) - 1))))
-				goto out;
-		} else {
-			error = 0;
-			goto out;
-		}
+				return error;
+		} else
+			return 0;
 	}
 	/*
 	 * Read the data block if we don't already have it, give up if it fails.
@@ -926,9 +920,9 @@ xfs_dir2_leaf_to_block(
 	if (dbp == NULL &&
 	    (error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &dbp,
 		    XFS_DATA_FORK))) {
-		goto out;
+		return error;
 	}
-	hdr = dbp->data;
+	hdr = dbp->b_addr;
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
 	/*
 	 * Size of the "leaf" area in the block.
@@ -944,10 +938,9 @@ xfs_dir2_leaf_to_block(
 	 * If it's not free or is too short we can't do it.
 	 */
 	if (be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG ||
-	    be16_to_cpu(dup->length) < size) {
-		error = 0;
-		goto out;
-	}
+	    be16_to_cpu(dup->length) < size)
+		return 0;
+
 	/*
 	 * Start converting it to block form.
 	 */
@@ -989,25 +982,17 @@ xfs_dir2_leaf_to_block(
 	 * Pitch the old leaf block.
 	 */
 	error = xfs_da_shrink_inode(args, mp->m_dirleafblk, lbp);
-	lbp = NULL;
-	if (error) {
-		goto out;
-	}
+	if (error)
+		return error;
+
 	/*
 	 * Now see if the resulting block can be shrunken to shortform.
 	 */
 	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
-	if (size > XFS_IFORK_DSIZE(dp)) {
-		error = 0;
-		goto out;
-	}
+	if (size > XFS_IFORK_DSIZE(dp))
+		return 0;
+
 	return xfs_dir2_block_to_sf(args, dbp, size, &sfh);
-out:
-	if (lbp)
-		xfs_da_buf_done(lbp);
-	if (dbp)
-		xfs_da_buf_done(dbp);
-	return error;
 }
 
 /*
@@ -1020,7 +1005,7 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
-	xfs_dabuf_t		*bp;		/* block buffer */
+	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -1088,7 +1073,7 @@ xfs_dir2_sf_to_block(
 		kmem_free(sfp);
 		return error;
 	}
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	/*
 	 * Compute size of block "tail" area.
@@ -1217,6 +1202,5 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_block_log_leaf(tp, bp, 0, be32_to_cpu(btp->count) - 1);
 	xfs_dir2_block_log_tail(tp, bp);
 	xfs_dir2_data_check(dp, bp);
-	xfs_da_buf_done(bp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 2046988..44ffd4d 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -42,8 +42,8 @@ xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
  */
 void
 xfs_dir2_data_check(
-	xfs_inode_t		*dp,		/* incore inode pointer */
-	xfs_dabuf_t		*bp)		/* data block's buffer */
+	struct xfs_inode	*dp,		/* incore inode pointer */
+	struct xfs_buf		*bp)		/* data block's buffer */
 {
 	xfs_dir2_dataptr_t	addr;		/* addr for leaf lookup */
 	xfs_dir2_data_free_t	*bf;		/* bestfree table */
@@ -65,7 +65,7 @@ xfs_dir2_data_check(
 	struct xfs_name		name;
 
 	mp = dp->i_mount;
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	bf = hdr->bestfree;
 	p = (char *)(hdr + 1);
 
@@ -389,9 +389,9 @@ int						/* error */
 xfs_dir2_data_init(
 	xfs_da_args_t		*args,		/* directory operation args */
 	xfs_dir2_db_t		blkno,		/* logical dir block number */
-	xfs_dabuf_t		**bpp)		/* output block buffer */
+	struct xfs_buf		**bpp)		/* output block buffer */
 {
-	xfs_dabuf_t		*bp;		/* block buffer */
+	struct xfs_buf		*bp;		/* block buffer */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
@@ -417,7 +417,7 @@ xfs_dir2_data_init(
 	/*
 	 * Initialize the header.
 	 */
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	hdr->bestfree[0].offset = cpu_to_be16(sizeof(*hdr));
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
@@ -449,16 +449,16 @@ xfs_dir2_data_init(
  */
 void
 xfs_dir2_data_log_entry(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* block buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 
-	xfs_da_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
 		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
 		       (char *)hdr - 1));
 }
@@ -468,15 +468,15 @@ xfs_dir2_data_log_entry(
  */
 void
 xfs_dir2_data_log_header(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp)		/* block buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 
-	xfs_da_log_buf(tp, bp, 0, sizeof(*hdr) - 1);
+	xfs_trans_log_buf(tp, bp, 0, sizeof(*hdr) - 1);
 }
 
 /*
@@ -484,11 +484,11 @@ xfs_dir2_data_log_header(
  */
 void
 xfs_dir2_data_log_unused(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* block buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
 	xfs_dir2_data_unused_t	*dup)		/* data unused pointer */
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
@@ -496,13 +496,13 @@ xfs_dir2_data_log_unused(
 	/*
 	 * Log the first part of the unused entry.
 	 */
-	xfs_da_log_buf(tp, bp, (uint)((char *)dup - (char *)hdr),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)dup - (char *)hdr),
 		(uint)((char *)&dup->length + sizeof(dup->length) -
 		       1 - (char *)hdr));
 	/*
 	 * Log the end (tag) of the unused entry.
 	 */
-	xfs_da_log_buf(tp, bp,
+	xfs_trans_log_buf(tp, bp,
 		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)hdr),
 		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)hdr +
 		       sizeof(xfs_dir2_data_off_t) - 1));
@@ -514,8 +514,8 @@ xfs_dir2_data_log_unused(
  */
 void
 xfs_dir2_data_make_free(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* block buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
 	xfs_dir2_data_aoff_t	offset,		/* starting byte offset */
 	xfs_dir2_data_aoff_t	len,		/* length in bytes */
 	int			*needlogp,	/* out: log header */
@@ -531,7 +531,7 @@ xfs_dir2_data_make_free(
 	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
 
 	mp = tp->t_mountp;
-	hdr = bp->data;
+	hdr = bp->b_addr;
 
 	/*
 	 * Figure out where the end of the data area is.
@@ -696,8 +696,8 @@ xfs_dir2_data_make_free(
  */
 void
 xfs_dir2_data_use_free(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* data block buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
 	xfs_dir2_data_unused_t	*dup,		/* unused entry */
 	xfs_dir2_data_aoff_t	offset,		/* starting offset to use */
 	xfs_dir2_data_aoff_t	len,		/* length to use */
@@ -713,7 +713,7 @@ xfs_dir2_data_use_free(
 	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
 	int			oldlen;		/* old unused entry's length */
 
-	hdr = bp->data;
+	hdr = bp->b_addr;
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 397ffbc..69accf6 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -38,15 +38,15 @@
  * Local function declarations.
  */
 #ifdef DEBUG
-static void xfs_dir2_leaf_check(xfs_inode_t *dp, xfs_dabuf_t *bp);
+static void xfs_dir2_leaf_check(struct xfs_inode *dp, struct xfs_buf *bp);
 #else
 #define	xfs_dir2_leaf_check(dp, bp)
 #endif
-static int xfs_dir2_leaf_lookup_int(xfs_da_args_t *args, xfs_dabuf_t **lbpp,
-				    int *indexp, xfs_dabuf_t **dbpp);
-static void xfs_dir2_leaf_log_bests(struct xfs_trans *tp, struct xfs_dabuf *bp,
+static int xfs_dir2_leaf_lookup_int(xfs_da_args_t *args, struct xfs_buf **lbpp,
+				    int *indexp, struct xfs_buf **dbpp);
+static void xfs_dir2_leaf_log_bests(struct xfs_trans *tp, struct xfs_buf *bp,
 				    int first, int last);
-static void xfs_dir2_leaf_log_tail(struct xfs_trans *tp, struct xfs_dabuf *bp);
+static void xfs_dir2_leaf_log_tail(struct xfs_trans *tp, struct xfs_buf *bp);
 
 
 /*
@@ -55,7 +55,7 @@ static void xfs_dir2_leaf_log_tail(struct xfs_trans *tp, struct xfs_dabuf *bp);
 int						/* error */
 xfs_dir2_block_to_leaf(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*dbp)		/* input block's buffer */
+	struct xfs_buf		*dbp)		/* input block's buffer */
 {
 	__be16			*bestsp;	/* leaf's bestsp entries */
 	xfs_dablk_t		blkno;		/* leaf block's bno */
@@ -64,7 +64,7 @@ xfs_dir2_block_to_leaf(
 	xfs_dir2_block_tail_t	*btp;		/* block's tail */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
-	xfs_dabuf_t		*lbp;		/* leaf block's buffer */
+	struct xfs_buf		*lbp;		/* leaf block's buffer */
 	xfs_dir2_db_t		ldb;		/* leaf block's bno */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf's tail */
@@ -95,8 +95,8 @@ xfs_dir2_block_to_leaf(
 		return error;
 	}
 	ASSERT(lbp != NULL);
-	leaf = lbp->data;
-	hdr = dbp->data;
+	leaf = lbp->b_addr;
+	hdr = dbp->b_addr;
 	xfs_dir2_data_check(dp, dbp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
@@ -143,7 +143,6 @@ xfs_dir2_block_to_leaf(
 	xfs_dir2_leaf_check(dp, lbp);
 	xfs_dir2_data_check(dp, dbp);
 	xfs_dir2_leaf_log_bests(tp, lbp, 0, 0);
-	xfs_da_buf_done(lbp);
 	return 0;
 }
 
@@ -282,7 +281,7 @@ xfs_dir2_leaf_addname(
 	__be16			*bestsp;	/* freespace table in leaf */
 	int			compact;	/* need to compact leaves */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* data unused entry */
@@ -291,7 +290,7 @@ xfs_dir2_leaf_addname(
 	int			highstale;	/* index of next stale leaf */
 	int			i;		/* temporary, index */
 	int			index;		/* leaf table position */
-	xfs_dabuf_t		*lbp;		/* leaf's buffer */
+	struct xfs_buf		*lbp;		/* leaf's buffer */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	int			length;		/* length of new entry */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry table pointer */
@@ -328,7 +327,7 @@ xfs_dir2_leaf_addname(
 	 * But if there are dup hash values the index is of the first of those.
 	 */
 	index = xfs_dir2_leaf_search_hash(args, lbp);
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = xfs_dir2_data_entsize(args->namelen);
@@ -402,14 +401,13 @@ xfs_dir2_leaf_addname(
 		 */
 		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) ||
 							args->total == 0) {
-			xfs_da_brelse(tp, lbp);
+			xfs_trans_brelse(tp, lbp);
 			return XFS_ERROR(ENOSPC);
 		}
 		/*
 		 * Convert to node form.
 		 */
 		error = xfs_dir2_leaf_to_node(args, lbp);
-		xfs_da_buf_done(lbp);
 		if (error)
 			return error;
 		/*
@@ -427,7 +425,7 @@ xfs_dir2_leaf_addname(
 	 * a new data block.
 	 */
 	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
-		xfs_da_brelse(tp, lbp);
+		xfs_trans_brelse(tp, lbp);
 		return use_block == -1 ? XFS_ERROR(ENOSPC) : 0;
 	}
 	/*
@@ -435,7 +433,7 @@ xfs_dir2_leaf_addname(
 	 * changed anything.
 	 */
 	if (args->total == 0 && use_block == -1) {
-		xfs_da_brelse(tp, lbp);
+		xfs_trans_brelse(tp, lbp);
 		return XFS_ERROR(ENOSPC);
 	}
 	/*
@@ -466,14 +464,14 @@ xfs_dir2_leaf_addname(
 		 */
 		if ((error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE,
 				&use_block))) {
-			xfs_da_brelse(tp, lbp);
+			xfs_trans_brelse(tp, lbp);
 			return error;
 		}
 		/*
 		 * Initialize the block.
 		 */
 		if ((error = xfs_dir2_data_init(args, use_block, &dbp))) {
-			xfs_da_brelse(tp, lbp);
+			xfs_trans_brelse(tp, lbp);
 			return error;
 		}
 		/*
@@ -493,7 +491,7 @@ xfs_dir2_leaf_addname(
 		 */
 		else
 			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
-		hdr = dbp->data;
+		hdr = dbp->b_addr;
 		bestsp[use_block] = hdr->bestfree[0].length;
 		grown = 1;
 	}
@@ -505,10 +503,10 @@ xfs_dir2_leaf_addname(
 		if ((error =
 		    xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, use_block),
 			    -1, &dbp, XFS_DATA_FORK))) {
-			xfs_da_brelse(tp, lbp);
+			xfs_trans_brelse(tp, lbp);
 			return error;
 		}
-		hdr = dbp->data;
+		hdr = dbp->b_addr;
 		grown = 0;
 	}
 	xfs_dir2_data_check(dp, dbp);
@@ -570,9 +568,7 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_leaf_log_header(tp, lbp);
 	xfs_dir2_leaf_log_ents(tp, lbp, lfloglow, lfloghigh);
 	xfs_dir2_leaf_check(dp, lbp);
-	xfs_da_buf_done(lbp);
 	xfs_dir2_data_check(dp, dbp);
-	xfs_da_buf_done(dbp);
 	return 0;
 }
 
@@ -583,8 +579,8 @@ xfs_dir2_leaf_addname(
  */
 STATIC void
 xfs_dir2_leaf_check(
-	xfs_inode_t		*dp,		/* incore directory inode */
-	xfs_dabuf_t		*bp)		/* leaf's buffer */
+	struct xfs_inode	*dp,		/* incore directory inode */
+	struct xfs_buf		*bp)		/* leaf's buffer */
 {
 	int			i;		/* leaf index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
@@ -592,7 +588,7 @@ xfs_dir2_leaf_check(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			stale;		/* count of stale leaves */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	mp = dp->i_mount;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	/*
@@ -628,14 +624,14 @@ xfs_dir2_leaf_check(
 void
 xfs_dir2_leaf_compact(
 	xfs_da_args_t	*args,		/* operation arguments */
-	xfs_dabuf_t	*bp)		/* leaf buffer */
+	struct xfs_buf	*bp)		/* leaf buffer */
 {
 	int		from;		/* source leaf index */
 	xfs_dir2_leaf_t	*leaf;		/* leaf structure */
 	int		loglow;		/* first leaf entry to log */
 	int		to;		/* target leaf index */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	if (!leaf->hdr.stale) {
 		return;
 	}
@@ -677,7 +673,7 @@ xfs_dir2_leaf_compact(
  */
 void
 xfs_dir2_leaf_compact_x1(
-	xfs_dabuf_t	*bp,		/* leaf buffer */
+	struct xfs_buf	*bp,		/* leaf buffer */
 	int		*indexp,	/* insertion index */
 	int		*lowstalep,	/* out: stale entry before us */
 	int		*highstalep,	/* out: stale entry after us */
@@ -693,7 +689,7 @@ xfs_dir2_leaf_compact_x1(
 	int		newindex=0;	/* new insertion index */
 	int		to;		/* destination copy index */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(be16_to_cpu(leaf->hdr.stale) > 1);
 	index = *indexp;
 
@@ -775,7 +771,7 @@ xfs_dir2_leaf_getdents(
 	xfs_off_t		*offset,
 	filldir_t		filldir)
 {
-	xfs_dabuf_t		*bp;		/* data block buffer */
+	struct xfs_buf		*bp;		/* data block buffer */
 	int			byteoff;	/* offset in current block */
 	xfs_dir2_db_t		curdb;		/* db for current block */
 	xfs_dir2_off_t		curoff;		/* current overall offset */
@@ -839,13 +835,13 @@ xfs_dir2_leaf_getdents(
 		 * If we have no buffer, or we're off the end of the
 		 * current buffer, need to get another one.
 		 */
-		if (!bp || ptr >= (char *)bp->data + mp->m_dirblksize) {
+		if (!bp || ptr >= (char *)bp->b_addr + mp->m_dirblksize) {
 			/*
 			 * If we have a buffer, we need to release it and
 			 * take it out of the mapping.
 			 */
 			if (bp) {
-				xfs_da_brelse(NULL, bp);
+				xfs_trans_brelse(NULL, bp);
 				bp = NULL;
 				map_blocks -= mp->m_dirblkfsbs;
 				/*
@@ -1035,7 +1031,7 @@ xfs_dir2_leaf_getdents(
 			else if (curoff > newoff)
 				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
 				       curdb);
-			hdr = bp->data;
+			hdr = bp->b_addr;
 			xfs_dir2_data_check(dp, bp);
 			/*
 			 * Find our position in the block.
@@ -1119,7 +1115,7 @@ xfs_dir2_leaf_getdents(
 		*offset = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
 	kmem_free(map);
 	if (bp)
-		xfs_da_brelse(NULL, bp);
+		xfs_trans_brelse(NULL, bp);
 	return error;
 }
 
@@ -1130,10 +1126,10 @@ int
 xfs_dir2_leaf_init(
 	xfs_da_args_t		*args,		/* operation arguments */
 	xfs_dir2_db_t		bno,		/* directory block number */
-	xfs_dabuf_t		**bpp,		/* out: leaf buffer */
+	struct xfs_buf		**bpp,		/* out: leaf buffer */
 	int			magic)		/* magic number for block */
 {
-	xfs_dabuf_t		*bp;		/* leaf buffer */
+	struct xfs_buf		*bp;		/* leaf buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
@@ -1156,7 +1152,7 @@ xfs_dir2_leaf_init(
 		return error;
 	}
 	ASSERT(bp != NULL);
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	/*
 	 * Initialize the header.
 	 */
@@ -1186,7 +1182,7 @@ xfs_dir2_leaf_init(
 static void
 xfs_dir2_leaf_log_bests(
 	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
 {
@@ -1195,12 +1191,12 @@ xfs_dir2_leaf_log_bests(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp, leaf);
 	firstb = xfs_dir2_leaf_bests_p(ltp) + first;
 	lastb = xfs_dir2_leaf_bests_p(ltp) + last;
-	xfs_da_log_buf(tp, bp, (uint)((char *)firstb - (char *)leaf),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)firstb - (char *)leaf),
 		(uint)((char *)lastb - (char *)leaf + sizeof(*lastb) - 1));
 }
 
@@ -1210,7 +1206,7 @@ xfs_dir2_leaf_log_bests(
 void
 xfs_dir2_leaf_log_ents(
 	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
 {
@@ -1218,12 +1214,12 @@ xfs_dir2_leaf_log_ents(
 	xfs_dir2_leaf_entry_t	*lastlep;	/* pointer to last entry */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	firstlep = &leaf->ents[first];
 	lastlep = &leaf->ents[last];
-	xfs_da_log_buf(tp, bp, (uint)((char *)firstlep - (char *)leaf),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)firstlep - (char *)leaf),
 		(uint)((char *)lastlep - (char *)leaf + sizeof(*lastlep) - 1));
 }
 
@@ -1232,15 +1228,15 @@ xfs_dir2_leaf_log_ents(
  */
 void
 xfs_dir2_leaf_log_header(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp)		/* leaf buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	xfs_da_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
 		(uint)(sizeof(leaf->hdr) - 1));
 }
 
@@ -1249,18 +1245,18 @@ xfs_dir2_leaf_log_header(
  */
 STATIC void
 xfs_dir2_leaf_log_tail(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp)		/* leaf buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 
 	mp = tp->t_mountp;
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
-	xfs_da_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
 		(uint)(mp->m_dirblksize - 1));
 }
 
@@ -1273,12 +1269,12 @@ int
 xfs_dir2_leaf_lookup(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	int			index;		/* found entry index */
-	xfs_dabuf_t		*lbp;		/* leaf buffer */
+	struct xfs_buf		*lbp;		/* leaf buffer */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
@@ -1294,7 +1290,7 @@ xfs_dir2_leaf_lookup(
 	tp = args->trans;
 	dp = args->dp;
 	xfs_dir2_leaf_check(dp, lbp);
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	/*
 	 * Get to the leaf entry and contained data entry address.
 	 */
@@ -1303,15 +1299,15 @@ xfs_dir2_leaf_lookup(
 	 * Point to the data entry.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)dbp->data +
+	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
 	/*
 	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
-	xfs_da_brelse(tp, dbp);
-	xfs_da_brelse(tp, lbp);
+	xfs_trans_brelse(tp, dbp);
+	xfs_trans_brelse(tp, lbp);
 	return XFS_ERROR(error);
 }
 
@@ -1324,17 +1320,17 @@ xfs_dir2_leaf_lookup(
 static int					/* error */
 xfs_dir2_leaf_lookup_int(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		**lbpp,		/* out: leaf buffer */
+	struct xfs_buf		**lbpp,		/* out: leaf buffer */
 	int			*indexp,	/* out: index in leaf block */
-	xfs_dabuf_t		**dbpp)		/* out: data buffer */
+	struct xfs_buf		**dbpp)		/* out: data buffer */
 {
 	xfs_dir2_db_t		curdb = -1;	/* current data block number */
-	xfs_dabuf_t		*dbp = NULL;	/* data buffer */
+	struct xfs_buf		*dbp = NULL;	/* data buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	int			index;		/* index in leaf block */
-	xfs_dabuf_t		*lbp;		/* leaf buffer */
+	struct xfs_buf		*lbp;		/* leaf buffer */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_mount_t		*mp;		/* filesystem mount point */
@@ -1354,7 +1350,7 @@ xfs_dir2_leaf_lookup_int(
 	if (error)
 		return error;
 	*lbpp = lbp;
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	xfs_dir2_leaf_check(dp, lbp);
 	/*
 	 * Look for the first leaf entry with our hash value.
@@ -1382,12 +1378,12 @@ xfs_dir2_leaf_lookup_int(
 		 */
 		if (newdb != curdb) {
 			if (dbp)
-				xfs_da_brelse(tp, dbp);
+				xfs_trans_brelse(tp, dbp);
 			error = xfs_da_read_buf(tp, dp,
 						xfs_dir2_db_to_da(mp, newdb),
 						-1, &dbp, XFS_DATA_FORK);
 			if (error) {
-				xfs_da_brelse(tp, lbp);
+				xfs_trans_brelse(tp, lbp);
 				return error;
 			}
 			xfs_dir2_data_check(dp, dbp);
@@ -1396,7 +1392,7 @@ xfs_dir2_leaf_lookup_int(
 		/*
 		 * Point to the data entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)((char *)dbp->data +
+		dep = (xfs_dir2_data_entry_t *)((char *)dbp->b_addr +
 			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
 		 * Compare name and if it's an exact match, return the index
@@ -1424,12 +1420,12 @@ xfs_dir2_leaf_lookup_int(
 	if (args->cmpresult == XFS_CMP_CASE) {
 		ASSERT(cidb != -1);
 		if (cidb != curdb) {
-			xfs_da_brelse(tp, dbp);
+			xfs_trans_brelse(tp, dbp);
 			error = xfs_da_read_buf(tp, dp,
 						xfs_dir2_db_to_da(mp, cidb),
 						-1, &dbp, XFS_DATA_FORK);
 			if (error) {
-				xfs_da_brelse(tp, lbp);
+				xfs_trans_brelse(tp, lbp);
 				return error;
 			}
 		}
@@ -1441,8 +1437,8 @@ xfs_dir2_leaf_lookup_int(
 	 */
 	ASSERT(cidb == -1);
 	if (dbp)
-		xfs_da_brelse(tp, dbp);
-	xfs_da_brelse(tp, lbp);
+		xfs_trans_brelse(tp, dbp);
+	xfs_trans_brelse(tp, lbp);
 	return XFS_ERROR(ENOENT);
 }
 
@@ -1456,13 +1452,13 @@ xfs_dir2_leaf_removename(
 	__be16			*bestsp;	/* leaf block best freespace */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry structure */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	xfs_dir2_db_t		i;		/* temporary data block # */
 	int			index;		/* index into leaf entries */
-	xfs_dabuf_t		*lbp;		/* leaf buffer */
+	struct xfs_buf		*lbp;		/* leaf buffer */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
@@ -1483,8 +1479,8 @@ xfs_dir2_leaf_removename(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	leaf = lbp->data;
-	hdr = dbp->data;
+	leaf = lbp->b_addr;
+	hdr = dbp->b_addr;
 	xfs_dir2_data_check(dp, dbp);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
@@ -1541,12 +1537,9 @@ xfs_dir2_leaf_removename(
 			 * Just go on, returning success, leaving the
 			 * empty block in place.
 			 */
-			if (error == ENOSPC && args->total == 0) {
-				xfs_da_buf_done(dbp);
+			if (error == ENOSPC && args->total == 0)
 				error = 0;
-			}
 			xfs_dir2_leaf_check(dp, lbp);
-			xfs_da_buf_done(lbp);
 			return error;
 		}
 		dbp = NULL;
@@ -1577,10 +1570,9 @@ xfs_dir2_leaf_removename(
 	/*
 	 * If the data block was not the first one, drop it.
 	 */
-	else if (db != mp->m_dirdatablk && dbp != NULL) {
-		xfs_da_buf_done(dbp);
+	else if (db != mp->m_dirdatablk)
 		dbp = NULL;
-	}
+
 	xfs_dir2_leaf_check(dp, lbp);
 	/*
 	 * See if we can convert to block form.
@@ -1595,12 +1587,12 @@ int						/* error */
 xfs_dir2_leaf_replace(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	int			index;		/* index of leaf entry */
-	xfs_dabuf_t		*lbp;		/* leaf buffer */
+	struct xfs_buf		*lbp;		/* leaf buffer */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
@@ -1614,7 +1606,7 @@ xfs_dir2_leaf_replace(
 		return error;
 	}
 	dp = args->dp;
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	/*
 	 * Point to the leaf entry, get data address from it.
 	 */
@@ -1623,7 +1615,7 @@ xfs_dir2_leaf_replace(
 	 * Point to the data entry.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)dbp->data +
+	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
 	ASSERT(args->inumber != be64_to_cpu(dep->inumber));
 	/*
@@ -1632,9 +1624,8 @@ xfs_dir2_leaf_replace(
 	dep->inumber = cpu_to_be64(args->inumber);
 	tp = args->trans;
 	xfs_dir2_data_log_entry(tp, dbp, dep);
-	xfs_da_buf_done(dbp);
 	xfs_dir2_leaf_check(dp, lbp);
-	xfs_da_brelse(tp, lbp);
+	xfs_trans_brelse(tp, lbp);
 	return 0;
 }
 
@@ -1646,7 +1637,7 @@ xfs_dir2_leaf_replace(
 int						/* index value */
 xfs_dir2_leaf_search_hash(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*lbp)		/* leaf buffer */
+	struct xfs_buf		*lbp)		/* leaf buffer */
 {
 	xfs_dahash_t		hash=0;		/* hash from this entry */
 	xfs_dahash_t		hashwant;	/* hash value looking for */
@@ -1656,7 +1647,7 @@ xfs_dir2_leaf_search_hash(
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	int			mid=0;		/* current leaf index */
 
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 #ifndef __KERNEL__
 	if (!leaf->hdr.count)
 		return 0;
@@ -1699,11 +1690,11 @@ xfs_dir2_leaf_search_hash(
 int						/* error */
 xfs_dir2_leaf_trim_data(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*lbp,		/* leaf buffer */
+	struct xfs_buf		*lbp,		/* leaf buffer */
 	xfs_dir2_db_t		db)		/* data block number */
 {
 	__be16			*bestsp;	/* leaf bests table */
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
@@ -1722,12 +1713,12 @@ xfs_dir2_leaf_trim_data(
 		return error;
 	}
 
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 
 #ifdef DEBUG
 {
-	struct xfs_dir2_data_hdr *hdr = dbp->data;
+	struct xfs_dir2_data_hdr *hdr = dbp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
 	ASSERT(be16_to_cpu(hdr->bestfree[0].length) ==
@@ -1741,7 +1732,7 @@ xfs_dir2_leaf_trim_data(
 	 */
 	if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 		ASSERT(error != ENOSPC);
-		xfs_da_brelse(tp, dbp);
+		xfs_trans_brelse(tp, dbp);
 		return error;
 	}
 	/*
@@ -1781,10 +1772,10 @@ xfs_dir2_node_to_leaf(
 	xfs_da_args_t		*args;		/* operation arguments */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
-	xfs_dabuf_t		*fbp;		/* buffer for freespace block */
+	struct xfs_buf		*fbp;		/* buffer for freespace block */
 	xfs_fileoff_t		fo;		/* freespace file offset */
 	xfs_dir2_free_t		*free;		/* freespace structure */
-	xfs_dabuf_t		*lbp;		/* buffer for leaf block */
+	struct xfs_buf		*lbp;		/* buffer for leaf block */
 	xfs_dir2_leaf_tail_t	*ltp;		/* tail of leaf structure */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_mount_t		*mp;		/* filesystem mount point */
@@ -1838,7 +1829,7 @@ xfs_dir2_node_to_leaf(
 	if (XFS_FSB_TO_B(mp, fo) > XFS_DIR2_LEAF_OFFSET + mp->m_dirblksize)
 		return 0;
 	lbp = state->path.blk[0].bp;
-	leaf = lbp->data;
+	leaf = lbp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	/*
 	 * Read the freespace block.
@@ -1847,7 +1838,7 @@ xfs_dir2_node_to_leaf(
 			XFS_DATA_FORK))) {
 		return error;
 	}
-	free = fbp->data;
+	free = fbp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	ASSERT(!free->hdr.firstdb);
 
@@ -1857,7 +1848,7 @@ xfs_dir2_node_to_leaf(
 	 */
 	if (xfs_dir2_leaf_size(&leaf->hdr, be32_to_cpu(free->hdr.nvalid)) >
 			mp->m_dirblksize) {
-		xfs_da_brelse(tp, fbp);
+		xfs_trans_brelse(tp, fbp);
 		return 0;
 	}
 
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index b0f2678..6c70524 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -36,20 +36,20 @@
 /*
  * Function declarations.
  */
-static void xfs_dir2_free_log_header(xfs_trans_t *tp, xfs_dabuf_t *bp);
-static int xfs_dir2_leafn_add(xfs_dabuf_t *bp, xfs_da_args_t *args, int index);
+static int xfs_dir2_leafn_add(struct xfs_buf *bp, xfs_da_args_t *args,
+			      int index);
 #ifdef DEBUG
-static void xfs_dir2_leafn_check(xfs_inode_t *dp, xfs_dabuf_t *bp);
+static void xfs_dir2_leafn_check(struct xfs_inode *dp, struct xfs_buf *bp);
 #else
 #define	xfs_dir2_leafn_check(dp, bp)
 #endif
-static void xfs_dir2_leafn_moveents(xfs_da_args_t *args, xfs_dabuf_t *bp_s,
-				    int start_s, xfs_dabuf_t *bp_d, int start_d,
-				    int count);
+static void xfs_dir2_leafn_moveents(xfs_da_args_t *args, struct xfs_buf *bp_s,
+				    int start_s, struct xfs_buf *bp_d,
+				    int start_d, int count);
 static void xfs_dir2_leafn_rebalance(xfs_da_state_t *state,
 				     xfs_da_state_blk_t *blk1,
 				     xfs_da_state_blk_t *blk2);
-static int xfs_dir2_leafn_remove(xfs_da_args_t *args, xfs_dabuf_t *bp,
+static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 				 int index, xfs_da_state_blk_t *dblk,
 				 int *rval);
 static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
@@ -60,16 +60,16 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
  */
 STATIC void
 xfs_dir2_free_log_bests(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp,		/* freespace buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
 {
 	xfs_dir2_free_t		*free;		/* freespace structure */
 
-	free = bp->data;
+	free = bp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
-	xfs_da_log_buf(tp, bp,
+	xfs_trans_log_buf(tp, bp,
 		(uint)((char *)&free->bests[first] - (char *)free),
 		(uint)((char *)&free->bests[last] - (char *)free +
 		       sizeof(free->bests[0]) - 1));
@@ -80,14 +80,14 @@ xfs_dir2_free_log_bests(
  */
 static void
 xfs_dir2_free_log_header(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_dabuf_t		*bp)		/* freespace buffer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
 	xfs_dir2_free_t		*free;		/* freespace structure */
 
-	free = bp->data;
+	free = bp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
-	xfs_da_log_buf(tp, bp, (uint)((char *)&free->hdr - (char *)free),
+	xfs_trans_log_buf(tp, bp, (uint)((char *)&free->hdr - (char *)free),
 		(uint)(sizeof(xfs_dir2_free_hdr_t) - 1));
 }
 
@@ -99,11 +99,11 @@ xfs_dir2_free_log_header(
 int						/* error */
 xfs_dir2_leaf_to_node(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*lbp)		/* leaf buffer */
+	struct xfs_buf		*lbp)		/* leaf buffer */
 {
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
-	xfs_dabuf_t		*fbp;		/* freespace buffer */
+	struct xfs_buf		*fbp;		/* freespace buffer */
 	xfs_dir2_db_t		fdb;		/* freespace block number */
 	xfs_dir2_free_t		*free;		/* freespace structure */
 	__be16			*from;		/* pointer to freespace entry */
@@ -136,8 +136,8 @@ xfs_dir2_leaf_to_node(
 		return error;
 	}
 	ASSERT(fbp != NULL);
-	free = fbp->data;
-	leaf = lbp->data;
+	free = fbp->b_addr;
+	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	/*
 	 * Initialize the freespace block header.
@@ -164,7 +164,6 @@ xfs_dir2_leaf_to_node(
 	xfs_dir2_leaf_log_header(tp, lbp);
 	xfs_dir2_free_log_header(tp, fbp);
 	xfs_dir2_free_log_bests(tp, fbp, 0, be32_to_cpu(free->hdr.nvalid) - 1);
-	xfs_da_buf_done(fbp);
 	xfs_dir2_leafn_check(dp, lbp);
 	return 0;
 }
@@ -175,7 +174,7 @@ xfs_dir2_leaf_to_node(
  */
 static int					/* error */
 xfs_dir2_leafn_add(
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	xfs_da_args_t		*args,		/* operation arguments */
 	int			index)		/* insertion pt for new entry */
 {
@@ -195,7 +194,7 @@ xfs_dir2_leafn_add(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	leaf = bp->data;
+	leaf = bp->b_addr;
 
 	/*
 	 * Quick check just to make sure we are not going to index
@@ -261,15 +260,15 @@ xfs_dir2_leafn_add(
  */
 void
 xfs_dir2_leafn_check(
-	xfs_inode_t	*dp,			/* incore directory inode */
-	xfs_dabuf_t	*bp)			/* leaf buffer */
+	struct xfs_inode *dp,
+	struct xfs_buf	*bp)
 {
 	int		i;			/* leaf index */
 	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
 	xfs_mount_t	*mp;			/* filesystem mount point */
 	int		stale;			/* count of stale leaves */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	mp = dp->i_mount;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count) <= xfs_dir2_max_leaf_ents(mp));
@@ -291,12 +290,12 @@ xfs_dir2_leafn_check(
  */
 xfs_dahash_t					/* hash value */
 xfs_dir2_leafn_lasthash(
-	xfs_dabuf_t	*bp,			/* leaf buffer */
+	struct xfs_buf	*bp,			/* leaf buffer */
 	int		*count)			/* count of entries in leaf */
 {
 	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
 
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	if (count)
 		*count = be16_to_cpu(leaf->hdr.count);
@@ -311,12 +310,12 @@ xfs_dir2_leafn_lasthash(
  */
 STATIC int
 xfs_dir2_leafn_lookup_for_addname(
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	xfs_da_args_t		*args,		/* operation arguments */
 	int			*indexp,	/* out: leaf entry index */
 	xfs_da_state_t		*state)		/* state to fill in */
 {
-	xfs_dabuf_t		*curbp = NULL;	/* current data/free buffer */
+	struct xfs_buf		*curbp = NULL;	/* current data/free buffer */
 	xfs_dir2_db_t		curdb = -1;	/* current data block number */
 	xfs_dir2_db_t		curfdb = -1;	/* current free block number */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -335,7 +334,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 #ifdef __KERNEL__
 	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
@@ -352,7 +351,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		/* If so, it's a free block buffer, get the block number. */
 		curbp = state->extrablk.bp;
 		curfdb = state->extrablk.blkno;
-		free = curbp->data;
+		free = curbp->b_addr;
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	}
 	length = xfs_dir2_data_entsize(args->namelen);
@@ -394,7 +393,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				 * If we had one before, drop it.
 				 */
 				if (curbp)
-					xfs_da_brelse(tp, curbp);
+					xfs_trans_brelse(tp, curbp);
 				/*
 				 * Read the free block.
 				 */
@@ -403,7 +402,7 @@ xfs_dir2_leafn_lookup_for_addname(
 						-1, &curbp, XFS_DATA_FORK);
 				if (error)
 					return error;
-				free = curbp->data;
+				free = curbp->b_addr;
 				ASSERT(be32_to_cpu(free->hdr.magic) ==
 					XFS_DIR2_FREE_MAGIC);
 				ASSERT((be32_to_cpu(free->hdr.firstdb) %
@@ -424,7 +423,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
 							XFS_ERRLEVEL_LOW, mp);
 				if (curfdb != newfdb)
-					xfs_da_brelse(tp, curbp);
+					xfs_trans_brelse(tp, curbp);
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 			curfdb = newfdb;
@@ -459,12 +458,12 @@ out:
  */
 STATIC int
 xfs_dir2_leafn_lookup_for_entry(
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	xfs_da_args_t		*args,		/* operation arguments */
 	int			*indexp,	/* out: leaf entry index */
 	xfs_da_state_t		*state)		/* state to fill in */
 {
-	xfs_dabuf_t		*curbp = NULL;	/* current data/free buffer */
+	struct xfs_buf		*curbp = NULL;	/* current data/free buffer */
 	xfs_dir2_db_t		curdb = -1;	/* current data block number */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -480,7 +479,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 #ifdef __KERNEL__
 	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
@@ -525,7 +524,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			 */
 			if (curbp && (args->cmpresult == XFS_CMP_DIFFERENT ||
 						curdb != state->extrablk.blkno))
-				xfs_da_brelse(tp, curbp);
+				xfs_trans_brelse(tp, curbp);
 			/*
 			 * If needing the block that is saved with a CI match,
 			 * use it otherwise read in the new data block.
@@ -547,7 +546,7 @@ xfs_dir2_leafn_lookup_for_entry(
 		/*
 		 * Point to the data entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)((char *)curbp->data +
+		dep = (xfs_dir2_data_entry_t *)((char *)curbp->b_addr +
 			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
 		 * Compare the entry and if it's an exact match, return
@@ -559,7 +558,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			/* If there is a CI match block, drop it */
 			if (args->cmpresult != XFS_CMP_DIFFERENT &&
 						curdb != state->extrablk.blkno)
-				xfs_da_brelse(tp, state->extrablk.bp);
+				xfs_trans_brelse(tp, state->extrablk.bp);
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
 			*indexp = index;
@@ -567,7 +566,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.bp = curbp;
 			state->extrablk.blkno = curdb;
 			state->extrablk.index = (int)((char *)dep -
-							(char *)curbp->data);
+							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
@@ -586,7 +585,7 @@ xfs_dir2_leafn_lookup_for_entry(
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
-				xfs_da_brelse(tp, curbp);
+				xfs_trans_brelse(tp, curbp);
 		}
 	} else {
 		state->extravalid = 0;
@@ -602,7 +601,7 @@ xfs_dir2_leafn_lookup_for_entry(
  */
 int
 xfs_dir2_leafn_lookup_int(
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	xfs_da_args_t		*args,		/* operation arguments */
 	int			*indexp,	/* out: leaf entry index */
 	xfs_da_state_t		*state)		/* state to fill in */
@@ -620,9 +619,9 @@ xfs_dir2_leafn_lookup_int(
 static void
 xfs_dir2_leafn_moveents(
 	xfs_da_args_t	*args,			/* operation arguments */
-	xfs_dabuf_t	*bp_s,			/* source leaf buffer */
+	struct xfs_buf	*bp_s,			/* source leaf buffer */
 	int		start_s,		/* source leaf index */
-	xfs_dabuf_t	*bp_d,			/* destination leaf buffer */
+	struct xfs_buf	*bp_d,			/* destination leaf buffer */
 	int		start_d,		/* destination leaf index */
 	int		count)			/* count of leaves to copy */
 {
@@ -640,8 +639,8 @@ xfs_dir2_leafn_moveents(
 		return;
 	}
 	tp = args->trans;
-	leaf_s = bp_s->data;
-	leaf_d = bp_d->data;
+	leaf_s = bp_s->b_addr;
+	leaf_d = bp_d->b_addr;
 	/*
 	 * If the destination index is not the end of the current
 	 * destination leaf entries, open up a hole in the destination
@@ -702,14 +701,14 @@ xfs_dir2_leafn_moveents(
  */
 int						/* sort order */
 xfs_dir2_leafn_order(
-	xfs_dabuf_t	*leaf1_bp,		/* leaf1 buffer */
-	xfs_dabuf_t	*leaf2_bp)		/* leaf2 buffer */
+	struct xfs_buf	*leaf1_bp,		/* leaf1 buffer */
+	struct xfs_buf	*leaf2_bp)		/* leaf2 buffer */
 {
 	xfs_dir2_leaf_t	*leaf1;			/* leaf1 structure */
 	xfs_dir2_leaf_t	*leaf2;			/* leaf2 structure */
 
-	leaf1 = leaf1_bp->data;
-	leaf2 = leaf2_bp->data;
+	leaf1 = leaf1_bp->b_addr;
+	leaf2 = leaf2_bp->b_addr;
 	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	if (be16_to_cpu(leaf1->hdr.count) > 0 &&
@@ -757,8 +756,8 @@ xfs_dir2_leafn_rebalance(
 		blk1 = blk2;
 		blk2 = tmp;
 	}
-	leaf1 = blk1->bp->data;
-	leaf2 = blk2->bp->data;
+	leaf1 = blk1->bp->b_addr;
+	leaf2 = blk2->bp->b_addr;
 	oldsum = be16_to_cpu(leaf1->hdr.count) + be16_to_cpu(leaf2->hdr.count);
 #ifdef DEBUG
 	oldstale = be16_to_cpu(leaf1->hdr.stale) + be16_to_cpu(leaf2->hdr.stale);
@@ -834,14 +833,14 @@ xfs_dir2_leafn_rebalance(
 static int					/* error */
 xfs_dir2_leafn_remove(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*bp,		/* leaf buffer */
+	struct xfs_buf		*bp,		/* leaf buffer */
 	int			index,		/* leaf entry index */
 	xfs_da_state_blk_t	*dblk,		/* data block */
 	int			*rval)		/* resulting block needs join */
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
@@ -858,7 +857,7 @@ xfs_dir2_leafn_remove(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	leaf = bp->data;
+	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	/*
 	 * Point to the entry we're removing.
@@ -884,7 +883,7 @@ xfs_dir2_leafn_remove(
 	 * in the data block in case it changes.
 	 */
 	dbp = dblk->bp;
-	hdr = dbp->data;
+	hdr = dbp->b_addr;
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
 	longest = be16_to_cpu(hdr->bestfree[0].length);
 	needlog = needscan = 0;
@@ -905,7 +904,7 @@ xfs_dir2_leafn_remove(
 	 */
 	if (longest < be16_to_cpu(hdr->bestfree[0].length)) {
 		int		error;		/* error return value */
-		xfs_dabuf_t	*fbp;		/* freeblock buffer */
+		struct xfs_buf	*fbp;		/* freeblock buffer */
 		xfs_dir2_db_t	fdb;		/* freeblock block number */
 		int		findex;		/* index in freeblock entries */
 		xfs_dir2_free_t	*free;		/* freeblock structure */
@@ -920,7 +919,7 @@ xfs_dir2_leafn_remove(
 				-1, &fbp, XFS_DATA_FORK))) {
 			return error;
 		}
-		free = fbp->data;
+		free = fbp->b_addr;
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		ASSERT(be32_to_cpu(free->hdr.firstdb) ==
 		       xfs_dir2_free_max_bests(mp) *
@@ -948,9 +947,7 @@ xfs_dir2_leafn_remove(
 			 * In this case just drop the buffer and some one else
 			 * will eventually get rid of the empty block.
 			 */
-			else if (error == ENOSPC && args->total == 0)
-				xfs_da_buf_done(dbp);
-			else
+			else if (!(error == ENOSPC && args->total == 0))
 				return error;
 		}
 		/*
@@ -1018,11 +1015,6 @@ xfs_dir2_leafn_remove(
 		 */
 		if (logfree)
 			xfs_dir2_free_log_bests(tp, fbp, findex, findex);
-		/*
-		 * Drop the buffer if we still have it.
-		 */
-		if (fbp)
-			xfs_da_buf_done(fbp);
 	}
 	xfs_dir2_leafn_check(dp, bp);
 	/*
@@ -1114,7 +1106,7 @@ xfs_dir2_leafn_toosmall(
 {
 	xfs_da_state_blk_t	*blk;		/* leaf block */
 	xfs_dablk_t		blkno;		/* leaf block number */
-	xfs_dabuf_t		*bp;		/* leaf buffer */
+	struct xfs_buf		*bp;		/* leaf buffer */
 	int			bytes;		/* bytes in use */
 	int			count;		/* leaf live entry count */
 	int			error;		/* error return value */
@@ -1130,7 +1122,7 @@ xfs_dir2_leafn_toosmall(
 	 * to coalesce with a sibling.
 	 */
 	blk = &state->path.blk[state->path.active - 1];
-	info = blk->bp->data;
+	info = blk->bp->b_addr;
 	ASSERT(info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	leaf = (xfs_dir2_leaf_t *)info;
 	count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
@@ -1189,7 +1181,7 @@ xfs_dir2_leafn_toosmall(
 		leaf = (xfs_dir2_leaf_t *)info;
 		count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
 		bytes = state->blocksize - (state->blocksize >> 2);
-		leaf = bp->data;
+		leaf = bp->b_addr;
 		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 		count += be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
 		bytes -= count * (uint)sizeof(leaf->ents[0]);
@@ -1198,7 +1190,7 @@ xfs_dir2_leafn_toosmall(
 		 */
 		if (bytes >= 0)
 			break;
-		xfs_da_brelse(state->args->trans, bp);
+		xfs_trans_brelse(state->args->trans, bp);
 	}
 	/*
 	 * Didn't like either block, give up.
@@ -1207,11 +1199,7 @@ xfs_dir2_leafn_toosmall(
 		*action = 0;
 		return 0;
 	}
-	/*
-	 * Done with the sibling leaf block here, drop the dabuf
-	 * so path_shift can get it.
-	 */
-	xfs_da_buf_done(bp);
+
 	/*
 	 * Make altpath point to the block we want to keep (the lower
 	 * numbered block) and path point to the block we want to drop.
@@ -1247,8 +1235,8 @@ xfs_dir2_leafn_unbalance(
 	args = state->args;
 	ASSERT(drop_blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	ASSERT(save_blk->magic == XFS_DIR2_LEAFN_MAGIC);
-	drop_leaf = drop_blk->bp->data;
-	save_leaf = save_blk->bp->data;
+	drop_leaf = drop_blk->bp->b_addr;
+	save_leaf = save_blk->bp->b_addr;
 	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	/*
@@ -1356,13 +1344,13 @@ xfs_dir2_node_addname_int(
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		dbno;		/* data block number */
-	xfs_dabuf_t		*dbp;		/* data block buffer */
+	struct xfs_buf		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* data unused entry pointer */
 	int			error;		/* error return value */
 	xfs_dir2_db_t		fbno;		/* freespace block number */
-	xfs_dabuf_t		*fbp;		/* freespace buffer */
+	struct xfs_buf		*fbp;		/* freespace buffer */
 	int			findex;		/* freespace entry index */
 	xfs_dir2_free_t		*free=NULL;	/* freespace block structure */
 	xfs_dir2_db_t		ifbno;		/* initial freespace block no */
@@ -1390,7 +1378,7 @@ xfs_dir2_node_addname_int(
 		 * Remember initial freespace block number.
 		 */
 		ifbno = fblk->blkno;
-		free = fbp->data;
+		free = fbp->b_addr;
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		findex = fblk->index;
 		/*
@@ -1474,7 +1462,7 @@ xfs_dir2_node_addname_int(
 			if (unlikely(fbp == NULL)) {
 				continue;
 			}
-			free = fbp->data;
+			free = fbp->b_addr;
 			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 			findex = 0;
 		}
@@ -1492,7 +1480,7 @@ xfs_dir2_node_addname_int(
 				/*
 				 * Drop the block.
 				 */
-				xfs_da_brelse(tp, fbp);
+				xfs_trans_brelse(tp, fbp);
 				fbp = NULL;
 				if (fblk && fblk->bp)
 					fblk->bp = NULL;
@@ -1507,36 +1495,23 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Not allowed to allocate, return failure.
 		 */
-		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) ||
-							args->total == 0) {
-			/*
-			 * Drop the freespace buffer unless it came from our
-			 * caller.
-			 */
-			if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
-				xfs_da_buf_done(fbp);
+		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
 			return XFS_ERROR(ENOSPC);
-		}
+
 		/*
 		 * Allocate and initialize the new data block.
 		 */
 		if (unlikely((error = xfs_dir2_grow_inode(args,
 							 XFS_DIR2_DATA_SPACE,
 							 &dbno)) ||
-		    (error = xfs_dir2_data_init(args, dbno, &dbp)))) {
-			/*
-			 * Drop the freespace buffer unless it came from our
-			 * caller.
-			 */
-			if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
-				xfs_da_buf_done(fbp);
+		    (error = xfs_dir2_data_init(args, dbno, &dbp))))
 			return error;
-		}
+
 		/*
 		 * If (somehow) we have a freespace block, get rid of it.
 		 */
 		if (fbp)
-			xfs_da_brelse(tp, fbp);
+			xfs_trans_brelse(tp, fbp);
 		if (fblk && fblk->bp)
 			fblk->bp = NULL;
 
@@ -1547,10 +1522,9 @@ xfs_dir2_node_addname_int(
 		fbno = xfs_dir2_db_to_fdb(mp, dbno);
 		if (unlikely(error = xfs_da_read_buf(tp, dp,
 				xfs_dir2_db_to_da(mp, fbno), -2, &fbp,
-				XFS_DATA_FORK))) {
-			xfs_da_buf_done(dbp);
+				XFS_DATA_FORK)))
 			return error;
-  		}
+
 		/*
 		 * If there wasn't a freespace block, the read will
 		 * return a NULL fbp.  Allocate and initialize a new one.
@@ -1598,7 +1572,7 @@ xfs_dir2_node_addname_int(
 			 * Initialize the new block to be empty, and remember
 			 * its first slot as our empty slot.
 			 */
-			free = fbp->data;
+			free = fbp->b_addr;
 			free->hdr.magic = cpu_to_be32(XFS_DIR2_FREE_MAGIC);
 			free->hdr.firstdb = cpu_to_be32(
 				(fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
@@ -1606,7 +1580,7 @@ xfs_dir2_node_addname_int(
 			free->hdr.nvalid = 0;
 			free->hdr.nused = 0;
 		} else {
-			free = fbp->data;
+			free = fbp->b_addr;
 			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		}
 
@@ -1639,7 +1613,7 @@ xfs_dir2_node_addname_int(
 		 * We haven't allocated the data entry yet so this will
 		 * change again.
 		 */
-		hdr = dbp->data;
+		hdr = dbp->b_addr;
 		free->bests[findex] = hdr->bestfree[0].length;
 		logfree = 1;
 	}
@@ -1650,22 +1624,17 @@ xfs_dir2_node_addname_int(
 		/*
 		 * If just checking, we succeeded.
 		 */
-		if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
-			if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
-				xfs_da_buf_done(fbp);
+		if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 			return 0;
-		}
+
 		/*
 		 * Read the data block in.
 		 */
-		if (unlikely(
-		    error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, dbno),
-				-1, &dbp, XFS_DATA_FORK))) {
-			if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
-				xfs_da_buf_done(fbp);
+		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, dbno),
+				-1, &dbp, XFS_DATA_FORK);
+		if (error)
 			return error;
-		}
-		hdr = dbp->data;
+		hdr = dbp->b_addr;
 		logfree = 0;
 	}
 	ASSERT(be16_to_cpu(hdr->bestfree[0].length) >= length);
@@ -1714,16 +1683,10 @@ xfs_dir2_node_addname_int(
 	if (logfree)
 		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
 	/*
-	 * If the caller didn't hand us the freespace block, drop it.
-	 */
-	if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
-		xfs_da_buf_done(fbp);
-	/*
 	 * Return the data block and offset in args, then drop the data block.
 	 */
 	args->blkno = (xfs_dablk_t)dbno;
 	args->index = be16_to_cpu(*tagp);
-	xfs_da_buf_done(dbp);
 	return 0;
 }
 
@@ -1761,22 +1724,23 @@ xfs_dir2_node_lookup(
 		/* If a CI match, dup the actual name and return EEXIST */
 		xfs_dir2_data_entry_t	*dep;
 
-		dep = (xfs_dir2_data_entry_t *)((char *)state->extrablk.bp->
-						data + state->extrablk.index);
+		dep = (xfs_dir2_data_entry_t *)
+			((char *)state->extrablk.bp->b_addr +
+						 state->extrablk.index);
 		rval = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	}
 	/*
 	 * Release the btree blocks and leaf block.
 	 */
 	for (i = 0; i < state->path.active; i++) {
-		xfs_da_brelse(args->trans, state->path.blk[i].bp);
+		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
 		state->path.blk[i].bp = NULL;
 	}
 	/*
 	 * Release the data block if we have it.
 	 */
 	if (state->extravalid && state->extrablk.bp) {
-		xfs_da_brelse(args->trans, state->extrablk.bp);
+		xfs_trans_brelse(args->trans, state->extrablk.bp);
 		state->extrablk.bp = NULL;
 	}
 	xfs_da_state_free(state);
@@ -1893,13 +1857,13 @@ xfs_dir2_node_replace(
 		 */
 		blk = &state->path.blk[state->path.active - 1];
 		ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
-		leaf = blk->bp->data;
+		leaf = blk->bp->b_addr;
 		lep = &leaf->ents[blk->index];
 		ASSERT(state->extravalid);
 		/*
 		 * Point to the data entry.
 		 */
-		hdr = state->extrablk.bp->data;
+		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
@@ -1916,14 +1880,14 @@ xfs_dir2_node_replace(
 	 * Didn't find it, and we're holding a data block.  Drop it.
 	 */
 	else if (state->extravalid) {
-		xfs_da_brelse(args->trans, state->extrablk.bp);
+		xfs_trans_brelse(args->trans, state->extrablk.bp);
 		state->extrablk.bp = NULL;
 	}
 	/*
 	 * Release all the buffers in the cursor.
 	 */
 	for (i = 0; i < state->path.active; i++) {
-		xfs_da_brelse(args->trans, state->path.blk[i].bp);
+		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
 		state->path.blk[i].bp = NULL;
 	}
 	xfs_da_state_free(state);
@@ -1940,7 +1904,7 @@ xfs_dir2_node_trim_free(
 	xfs_fileoff_t		fo,		/* free block number */
 	int			*rvalp)		/* out: did something */
 {
-	xfs_dabuf_t		*bp;		/* freespace buffer */
+	struct xfs_buf		*bp;		/* freespace buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return code */
 	xfs_dir2_free_t		*free;		/* freespace structure */
@@ -1965,13 +1929,13 @@ xfs_dir2_node_trim_free(
 	if (bp == NULL) {
 		return 0;
 	}
-	free = bp->data;
+	free = bp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	/*
 	 * If there are used entries, there's nothing to do.
 	 */
 	if (be32_to_cpu(free->hdr.nused) > 0) {
-		xfs_da_brelse(tp, bp);
+		xfs_trans_brelse(tp, bp);
 		*rvalp = 0;
 		return 0;
 	}
@@ -1987,7 +1951,7 @@ xfs_dir2_node_trim_free(
 		 * pieces.  This is the last block of an extent.
 		 */
 		ASSERT(error != ENOSPC);
-		xfs_da_brelse(tp, bp);
+		xfs_trans_brelse(tp, bp);
 		return error;
 	}
 	/*
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 067f403..3523d3e 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -25,7 +25,7 @@ extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
-				struct xfs_dabuf *bp);
+				struct xfs_buf *bp);
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
@@ -37,11 +37,11 @@ extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
 extern int xfs_dir2_block_replace(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
-		struct xfs_dabuf *lbp, struct xfs_dabuf *dbp);
+		struct xfs_buf *lbp, struct xfs_buf *dbp);
 
 /* xfs_dir2_data.c */
 #ifdef DEBUG
-extern void xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_dabuf *bp);
+extern void xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 #else
 #define	xfs_dir2_data_check(dp,bp)
 #endif
@@ -51,43 +51,43 @@ xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
 extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern int xfs_dir2_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
-		struct xfs_dabuf **bpp);
-extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		struct xfs_buf **bpp);
+extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_dir2_data_entry *dep);
 extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
-		struct xfs_dabuf *bp);
-extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		struct xfs_buf *bp);
+extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_dir2_data_unused *dup);
-extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_dabuf *bp,
+extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
 		int *needlogp, int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_dabuf *bp,
+extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
-		struct xfs_dabuf *dbp);
+		struct xfs_buf *dbp);
 extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
 extern void xfs_dir2_leaf_compact(struct xfs_da_args *args,
-		struct xfs_dabuf *bp);
-extern void xfs_dir2_leaf_compact_x1(struct xfs_dabuf *bp, int *indexp,
+		struct xfs_buf *bp);
+extern void xfs_dir2_leaf_compact_x1(struct xfs_buf *bp, int *indexp,
 		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
 extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
 		size_t bufsize, xfs_off_t *offset, filldir_t filldir);
 extern int xfs_dir2_leaf_init(struct xfs_da_args *args, xfs_dir2_db_t bno,
-		struct xfs_dabuf **bpp, int magic);
-extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_dabuf *bp,
+		struct xfs_buf **bpp, int magic);
+extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_buf *bp,
 		int first, int last);
 extern void xfs_dir2_leaf_log_header(struct xfs_trans *tp,
-		struct xfs_dabuf *bp);
+		struct xfs_buf *bp);
 extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_replace(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_search_hash(struct xfs_da_args *args,
-		struct xfs_dabuf *lbp);
+		struct xfs_buf *lbp);
 extern int xfs_dir2_leaf_trim_data(struct xfs_da_args *args,
-		struct xfs_dabuf *lbp, xfs_dir2_db_t db);
+		struct xfs_buf *lbp, xfs_dir2_db_t db);
 extern struct xfs_dir2_leaf_entry *
 xfs_dir2_leaf_find_entry(struct xfs_dir2_leaf *leaf, int index, int compact,
 		int lowstale, int highstale,
@@ -96,13 +96,13 @@ extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
 /* xfs_dir2_node.c */
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
-		struct xfs_dabuf *lbp);
-extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_dabuf *bp, int *count);
-extern int xfs_dir2_leafn_lookup_int(struct xfs_dabuf *bp,
+		struct xfs_buf *lbp);
+extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_buf *bp, int *count);
+extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,
 		struct xfs_da_args *args, int *indexp,
 		struct xfs_da_state *state);
-extern int xfs_dir2_leafn_order(struct xfs_dabuf *leaf1_bp,
-		struct xfs_dabuf *leaf2_bp);
+extern int xfs_dir2_leafn_order(struct xfs_buf *leaf1_bp,
+		struct xfs_buf *leaf2_bp);
 extern int xfs_dir2_leafn_split(struct xfs_da_state *state,
 	struct xfs_da_state_blk *oldblk, struct xfs_da_state_blk *newblk);
 extern int xfs_dir2_leafn_toosmall(struct xfs_da_state *state, int *action);
@@ -122,7 +122,7 @@ extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
 		struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
-extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_dabuf *bp,
+extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
 		int size, xfs_dir2_sf_hdr_t *sfhp);
 extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
 extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 19bf0c5..1b9fc3e 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -222,7 +222,7 @@ xfs_dir2_block_sfsize(
 int						/* error */
 xfs_dir2_block_to_sf(
 	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dabuf_t		*bp,		/* block buffer */
+	struct xfs_buf		*bp,
 	int			size,		/* shortform directory size */
 	xfs_dir2_sf_hdr_t	*sfhp)		/* shortform directory hdr */
 {
@@ -249,7 +249,7 @@ xfs_dir2_block_to_sf(
 	 * and add local data.
 	 */
 	hdr = kmem_alloc(mp->m_dirblksize, KM_SLEEP);
-	memcpy(hdr, bp->data, mp->m_dirblksize);
+	memcpy(hdr, bp->b_addr, mp->m_dirblksize);
 	logflags = XFS_ILOG_CORE;
 	if ((error = xfs_dir2_shrink_inode(args, mp->m_dirdatablk, bp))) {
 		ASSERT(error != ENOSPC);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 425f6e9..07f70e1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1491,13 +1491,9 @@ xfs_init_zones(void)
 	if (!xfs_da_state_zone)
 		goto out_destroy_btree_cur_zone;
 
-	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
-	if (!xfs_dabuf_zone)
-		goto out_destroy_da_state_zone;
-
 	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
 	if (!xfs_ifork_zone)
-		goto out_destroy_dabuf_zone;
+		goto out_destroy_da_state_zone;
 
 	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
 	if (!xfs_trans_zone)
@@ -1560,8 +1556,6 @@ xfs_init_zones(void)
 	kmem_zone_destroy(xfs_trans_zone);
  out_destroy_ifork_zone:
 	kmem_zone_destroy(xfs_ifork_zone);
- out_destroy_dabuf_zone:
-	kmem_zone_destroy(xfs_dabuf_zone);
  out_destroy_da_state_zone:
 	kmem_zone_destroy(xfs_da_state_zone);
  out_destroy_btree_cur_zone:
@@ -1589,7 +1583,6 @@ xfs_destroy_zones(void)
 	kmem_zone_destroy(xfs_log_item_desc_zone);
 	kmem_zone_destroy(xfs_trans_zone);
 	kmem_zone_destroy(xfs_ifork_zone);
-	kmem_zone_destroy(xfs_dabuf_zone);
 	kmem_zone_destroy(xfs_da_state_zone);
 	kmem_zone_destroy(xfs_btree_cur_zone);
 	kmem_zone_destroy(xfs_bmap_free_item_zone);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
