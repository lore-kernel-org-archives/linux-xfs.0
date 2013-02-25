Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A71C7F58
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 19:32:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A46D8F8033
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:32:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sRWs9DGp4d70V5k8 for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 17:32:36 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U9mvE-0002u6-La
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:32:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U9mv3-0003Iq-D0
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/16] xfs: add CRCs to attr leaf blocks
Date: Mon, 25 Feb 2013 12:31:40 +1100
Message-Id: <1361755901-12453-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1361755901-12453-1-git-send-email-david@fromorbit.com>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c      |  125 ++--
 fs/xfs/xfs_attr_leaf.c | 1738 +++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_attr_leaf.h |  121 +++-
 fs/xfs/xfs_da_btree.c  |   18 +-
 fs/xfs/xfs_da_btree.h  |    1 +
 5 files changed, 1163 insertions(+), 840 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index e03128c..de4093f 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -819,7 +819,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
 		error = 0;
 		goto out;
 	}
-	error = xfs_attr_root_inactive(&trans, dp);
+	error = xfs_attr3_root_inactive(&trans, dp);
 	if (error)
 		goto out;
 
@@ -905,7 +905,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
 		return error;
 
@@ -913,14 +913,14 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 * Look up the given attribute in the leaf block.  Figure out if
 	 * the given flags produce an error or call for an atomic rename.
 	 */
-	retval = xfs_attr_leaf_lookup_int(bp, args);
+	retval = xfs_attr3_leaf_lookup_int(bp, args);
 	if ((args->flags & ATTR_REPLACE) && (retval == ENOATTR)) {
 		xfs_trans_brelse(args->trans, bp);
-		return(retval);
+		return retval;
 	} else if (retval == EEXIST) {
 		if (args->flags & ATTR_CREATE) {	/* pure create op */
 			xfs_trans_brelse(args->trans, bp);
-			return(retval);
+			return retval;
 		}
 
 		trace_xfs_attr_leaf_replace(args);
@@ -936,7 +936,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 * Add the attribute to the leaf block, transitioning to a Btree
 	 * if required.
 	 */
-	retval = xfs_attr_leaf_add(bp, args);
+	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == ENOSPC) {
 		/*
 		 * Promote the attribute list to the Btree format, then
@@ -944,7 +944,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * can manage its own transactions.
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
-		error = xfs_attr_leaf_to_node(args);
+		error = xfs_attr3_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
@@ -1009,7 +1009,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr_leaf_flipflags(args);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return(error);
 
@@ -1031,19 +1031,19 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Read in the block containing the "old" attr, then
 		 * remove the "old" attr from that block (neat, huh!)
 		 */
-		error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno,
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
 					   -1, &bp);
 		if (error)
 			return error;
 
-		xfs_attr_leaf_remove(bp, args);
+		xfs_attr3_leaf_remove(bp, args);
 
 		/*
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
 			xfs_bmap_init(args->flist, args->firstblock);
-			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1075,9 +1075,9 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr_leaf_clearflag(args);
+		error = xfs_attr3_leaf_clearflag(args);
 	}
-	return(error);
+	return error;
 }
 
 /*
@@ -1100,24 +1100,24 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
 		return error;
 
-	error = xfs_attr_leaf_lookup_int(bp, args);
+	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error == ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
-		return(error);
+		return error;
 	}
 
-	xfs_attr_leaf_remove(bp, args);
+	xfs_attr3_leaf_remove(bp, args);
 
 	/*
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
 		xfs_bmap_init(args->flist, args->firstblock);
-		error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
+		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1127,7 +1127,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
-			return(error);
+			return error;
 		}
 
 		/*
@@ -1137,7 +1137,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 		if (committed)
 			xfs_trans_ijoin(args->trans, dp, 0);
 	}
-	return(0);
+	return 0;
 }
 
 /*
@@ -1155,21 +1155,21 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	trace_xfs_attr_leaf_get(args);
 
 	args->blkno = 0;
-	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
 		return error;
 
-	error = xfs_attr_leaf_lookup_int(bp, args);
+	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error != EEXIST)  {
 		xfs_trans_brelse(args->trans, bp);
-		return(error);
+		return error;
 	}
-	error = xfs_attr_leaf_getvalue(bp, args);
+	error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
 	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
 		error = xfs_attr_rmtval_get(args);
 	}
-	return(error);
+	return error;
 }
 
 /*
@@ -1184,11 +1184,11 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor->blkno = 0;
-	error = xfs_attr_leaf_read(NULL, context->dp, 0, -1, &bp);
+	error = xfs_attr3_leaf_read(NULL, context->dp, 0, -1, &bp);
 	if (error)
 		return XFS_ERROR(error);
 
-	error = xfs_attr_leaf_list_int(bp, context);
+	error = xfs_attr3_leaf_list_int(bp, context);
 	xfs_trans_brelse(NULL, bp);
 	return XFS_ERROR(error);
 }
@@ -1257,7 +1257,7 @@ restart:
 		args->rmtblkcnt = 0;
 	}
 
-	retval = xfs_attr_leaf_add(blk->bp, state->args);
+	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == ENOSPC) {
 		if (state->path.active == 1) {
 			/*
@@ -1267,7 +1267,7 @@ restart:
 			 */
 			xfs_da_state_free(state);
 			xfs_bmap_init(args->flist, args->firstblock);
-			error = xfs_attr_leaf_to_node(args);
+			error = xfs_attr3_leaf_to_node(args);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
@@ -1369,7 +1369,7 @@ restart:
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr_leaf_flipflags(args);
+		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
 
@@ -1408,7 +1408,7 @@ restart:
 		 */
 		blk = &state->path.blk[ state->path.active-1 ];
 		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-		error = xfs_attr_leaf_remove(blk->bp, args);
+		error = xfs_attr3_leaf_remove(blk->bp, args);
 		xfs_da3_fixhashpath(state, &state->path);
 
 		/*
@@ -1449,7 +1449,7 @@ restart:
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
-		error = xfs_attr_leaf_clearflag(args);
+		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
 	}
@@ -1523,7 +1523,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		 * Mark the attribute as INCOMPLETE, then bunmapi() the
 		 * remote value.
 		 */
-		error = xfs_attr_leaf_setflag(args);
+		error = xfs_attr3_leaf_setflag(args);
 		if (error)
 			goto out;
 		error = xfs_attr_rmtval_remove(args);
@@ -1544,7 +1544,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr_leaf_remove(blk->bp, args);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
 	xfs_da3_fixhashpath(state, &state->path);
 
 	/*
@@ -1590,13 +1590,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		ASSERT(state->path.blk[0].bp);
 		state->path.blk[0].bp = NULL;
 
-		error = xfs_attr_leaf_read(args->trans, args->dp, 0, -1, &bp);
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
 		if (error)
 			goto out;
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
 			xfs_bmap_init(args->flist, args->firstblock);
-			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1768,7 +1768,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 		/*
 		 * Get the value, local or "remote"
 		 */
-		retval = xfs_attr_leaf_getvalue(blk->bp, args);
+		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
 		if (!retval && (args->rmtblkno > 0)
 		    && !(args->flags & ATTR_KERNOVAL)) {
 			retval = xfs_attr_rmtval_get(args);
@@ -1793,7 +1793,9 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	attrlist_cursor_kern_t *cursor;
 	xfs_attr_leafblock_t *leaf;
 	xfs_da_intnode_t *node;
-	xfs_da_node_entry_t *btree;
+	struct xfs_attr3_icleaf_hdr leafhdr;
+	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_da_node_entry *btree;
 	int error, i;
 	struct xfs_buf *bp;
 
@@ -1814,22 +1816,28 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		if ((error != 0) && (error != EFSCORRUPTED))
 			return(error);
 		if (bp) {
+			struct xfs_attr_leaf_entry *entries;
+
 			node = bp->b_addr;
 			switch (be16_to_cpu(node->hdr.info.magic)) {
 			case XFS_DA_NODE_MAGIC:
+			case XFS_DA3_NODE_MAGIC:
 				trace_xfs_attr_list_wrong_blk(context);
 				xfs_trans_brelse(NULL, bp);
 				bp = NULL;
 				break;
 			case XFS_ATTR_LEAF_MAGIC:
+			case XFS_ATTR3_LEAF_MAGIC:
 				leaf = bp->b_addr;
-				if (cursor->hashval > be32_to_cpu(leaf->entries[
-				    be16_to_cpu(leaf->hdr.count)-1].hashval)) {
+				xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+				entries = xfs_attr3_leaf_entryp(leaf);
+				if (cursor->hashval > be32_to_cpu(
+						entries[leafhdr.count - 1].hashval)) {
 					trace_xfs_attr_list_wrong_blk(context);
 					xfs_trans_brelse(NULL, bp);
 					bp = NULL;
-				} else if (cursor->hashval <=
-					     be32_to_cpu(leaf->entries[0].hashval)) {
+				} else if (cursor->hashval <= be32_to_cpu(
+						entries[0].hashval)) {
 					trace_xfs_attr_list_wrong_blk(context);
 					xfs_trans_brelse(NULL, bp);
 					bp = NULL;
@@ -1851,27 +1859,31 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	if (bp == NULL) {
 		cursor->blkno = 0;
 		for (;;) {
+			__uint16_t magic;
+
 			error = xfs_da3_node_read(NULL, context->dp,
 						      cursor->blkno, -1, &bp,
 						      XFS_ATTR_FORK);
 			if (error)
 				return(error);
 			node = bp->b_addr;
-			if (node->hdr.info.magic ==
-			    cpu_to_be16(XFS_ATTR_LEAF_MAGIC))
+			magic = be16_to_cpu(node->hdr.info.magic);
+			if (magic == XFS_ATTR_LEAF_MAGIC ||
+			    magic == XFS_ATTR3_LEAF_MAGIC)
 				break;
-			if (unlikely(node->hdr.info.magic !=
-				     cpu_to_be16(XFS_DA_NODE_MAGIC))) {
+			if (magic != XFS_DA_NODE_MAGIC &&
+			    magic != XFS_DA3_NODE_MAGIC) {
 				XFS_CORRUPTION_ERROR("xfs_attr_node_list(3)",
 						     XFS_ERRLEVEL_LOW,
 						     context->dp->i_mount,
 						     node);
 				xfs_trans_brelse(NULL, bp);
-				return(XFS_ERROR(EFSCORRUPTED));
+				return XFS_ERROR(EFSCORRUPTED);
 			}
+
+			xfs_da3_node_hdr_from_disk(&nodehdr, node);
 			btree = xfs_da3_node_tree_p(node);
-			for (i = 0; i < be16_to_cpu(node->hdr.count);
-								btree++, i++) {
+			for (i = 0; i < nodehdr.count; btree++, i++) {
 				if (cursor->hashval
 						<= be32_to_cpu(btree->hashval)) {
 					cursor->blkno = be32_to_cpu(btree->before);
@@ -1880,9 +1892,9 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 					break;
 				}
 			}
-			if (i == be16_to_cpu(node->hdr.count)) {
+			if (i == nodehdr.count) {
 				xfs_trans_brelse(NULL, bp);
-				return(0);
+				return 0;
 			}
 			xfs_trans_brelse(NULL, bp);
 		}
@@ -1896,22 +1908,23 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 */
 	for (;;) {
 		leaf = bp->b_addr;
-		error = xfs_attr_leaf_list_int(bp, context);
+		error = xfs_attr3_leaf_list_int(bp, context);
 		if (error) {
 			xfs_trans_brelse(NULL, bp);
 			return error;
 		}
-		if (context->seen_enough || leaf->hdr.info.forw == 0)
+		xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+		if (context->seen_enough || leafhdr.forw == 0)
 			break;
-		cursor->blkno = be32_to_cpu(leaf->hdr.info.forw);
+		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(NULL, bp);
-		error = xfs_attr_leaf_read(NULL, context->dp, cursor->blkno, -1,
+		error = xfs_attr3_leaf_read(NULL, context->dp, cursor->blkno, -1,
 					   &bp);
 		if (error)
 			return error;
 	}
 	xfs_trans_brelse(NULL, bp);
-	return(0);
+	return 0;
 }
 
 
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 54b0dc8..25bc98c 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -39,6 +39,9 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_buf_item.h"
+#include "xfs_cksum.h"
+
 
 /*
  * xfs_attr_leaf.c
@@ -53,77 +56,213 @@
 /*
  * Routines used for growing the Btree.
  */
-STATIC int xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t which_block,
-				struct xfs_buf **bpp);
-STATIC int xfs_attr_leaf_add_work(struct xfs_buf *leaf_buffer,
-				  xfs_da_args_t *args, int freemap_index);
-STATIC void xfs_attr_leaf_compact(struct xfs_da_args *args,
-				  struct xfs_buf *leaf_buffer);
-STATIC void xfs_attr_leaf_rebalance(xfs_da_state_t *state,
+STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
+				 xfs_dablk_t which_block, struct xfs_buf **bpp);
+STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
+				   struct xfs_attr3_icleaf_hdr *ichdr,
+				   struct xfs_da_args *args, int freemap_index);
+STATIC void xfs_attr3_leaf_compact(struct xfs_da_args *args,
+				   struct xfs_attr3_icleaf_hdr *ichdr,
+				   struct xfs_buf *leaf_buffer);
+STATIC void xfs_attr3_leaf_rebalance(xfs_da_state_t *state,
 						   xfs_da_state_blk_t *blk1,
 						   xfs_da_state_blk_t *blk2);
-STATIC int xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
-					   xfs_da_state_blk_t *leaf_blk_1,
-					   xfs_da_state_blk_t *leaf_blk_2,
-					   int *number_entries_in_blk1,
-					   int *number_usedbytes_in_blk1);
+STATIC int xfs_attr3_leaf_figure_balance(xfs_da_state_t *state,
+			xfs_da_state_blk_t *leaf_blk_1,
+			struct xfs_attr3_icleaf_hdr *ichdr1,
+			xfs_da_state_blk_t *leaf_blk_2,
+			struct xfs_attr3_icleaf_hdr *ichdr2,
+			int *number_entries_in_blk1,
+			int *number_usedbytes_in_blk1);
 
 /*
  * Routines used for shrinking the Btree.
  */
-STATIC int xfs_attr_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
+STATIC int xfs_attr3_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
 				  struct xfs_buf *bp, int level);
-STATIC int xfs_attr_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
+STATIC int xfs_attr3_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
 				  struct xfs_buf *bp);
-STATIC int xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
+STATIC int xfs_attr3_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 				   xfs_dablk_t blkno, int blkcnt);
 
 /*
  * Utility routines.
  */
-STATIC void xfs_attr_leaf_moveents(xfs_attr_leafblock_t *src_leaf,
-					 int src_start,
-					 xfs_attr_leafblock_t *dst_leaf,
-					 int dst_start, int move_count,
-					 xfs_mount_t *mp);
+STATIC void xfs_attr3_leaf_moveents(struct xfs_attr_leafblock *src_leaf,
+			struct xfs_attr3_icleaf_hdr *src_ichdr, int src_start,
+			struct xfs_attr_leafblock *dst_leaf,
+			struct xfs_attr3_icleaf_hdr *dst_ichdr, int dst_start,
+			int move_count, struct xfs_mount *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
-static void
-xfs_attr_leaf_verify(
+void
+xfs_attr3_leaf_hdr_from_disk(
+	struct xfs_attr3_icleaf_hdr	*to,
+	struct xfs_attr_leafblock	*from)
+{
+	int	i;
+
+	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC) ||
+	       from->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC));
+
+	if (from->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
+		struct xfs_attr3_leaf_hdr *hdr3 = (struct xfs_attr3_leaf_hdr *)from;
+
+		to->forw = be32_to_cpu(hdr3->info.hdr.forw);
+		to->back = be32_to_cpu(hdr3->info.hdr.back);
+		to->magic = be16_to_cpu(hdr3->info.hdr.magic);
+		to->count = be16_to_cpu(hdr3->count);
+		to->usedbytes = be16_to_cpu(hdr3->usedbytes);
+		to->firstused = be16_to_cpu(hdr3->firstused);
+		to->holes = hdr3->holes;
+
+		for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+			to->freemap[i].base = be16_to_cpu(hdr3->freemap[i].base);
+			to->freemap[i].size = be16_to_cpu(hdr3->freemap[i].size);
+		}
+		return;
+	}
+	to->forw = be32_to_cpu(from->hdr.info.forw);
+	to->back = be32_to_cpu(from->hdr.info.back);
+	to->magic = be16_to_cpu(from->hdr.info.magic);
+	to->count = be16_to_cpu(from->hdr.count);
+	to->usedbytes = be16_to_cpu(from->hdr.usedbytes);
+	to->firstused = be16_to_cpu(from->hdr.firstused);
+	to->holes = from->hdr.holes;
+
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		to->freemap[i].base = be16_to_cpu(from->hdr.freemap[i].base);
+		to->freemap[i].size = be16_to_cpu(from->hdr.freemap[i].size);
+	}
+}
+
+void
+xfs_attr3_leaf_hdr_to_disk(
+	struct xfs_attr_leafblock	*to,
+	struct xfs_attr3_icleaf_hdr	*from)
+{
+	int	i;
+
+	ASSERT(from->magic == XFS_ATTR_LEAF_MAGIC ||
+	       from->magic == XFS_ATTR3_LEAF_MAGIC);
+
+	if (from->magic == XFS_ATTR3_LEAF_MAGIC) {
+		struct xfs_attr3_leaf_hdr *hdr3 = (struct xfs_attr3_leaf_hdr *)to;
+
+		hdr3->info.hdr.forw = cpu_to_be32(from->forw);
+		hdr3->info.hdr.back = cpu_to_be32(from->back);
+		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
+		hdr3->count = cpu_to_be16(from->count);
+		hdr3->usedbytes = cpu_to_be16(from->usedbytes);
+		hdr3->firstused = cpu_to_be16(from->firstused);
+		hdr3->holes = from->holes;
+		hdr3->pad1 = 0;
+
+		for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+			hdr3->freemap[i].base = cpu_to_be16(from->freemap[i].base);
+			hdr3->freemap[i].size = cpu_to_be16(from->freemap[i].size);
+		}
+		return;
+	}
+	to->hdr.info.forw = cpu_to_be32(from->forw);
+	to->hdr.info.back = cpu_to_be32(from->back);
+	to->hdr.info.magic = cpu_to_be16(from->magic);
+	to->hdr.count = cpu_to_be16(from->count);
+	to->hdr.usedbytes = cpu_to_be16(from->usedbytes);
+	to->hdr.firstused = cpu_to_be16(from->firstused);
+	to->hdr.holes = from->holes;
+	to->hdr.pad1 = 0;
+
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		to->hdr.freemap[i].base = cpu_to_be16(from->freemap[i].base);
+		to->hdr.freemap[i].size = cpu_to_be16(from->freemap[i].size);
+	}
+}
+
+static bool
+xfs_attr3_leaf_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_attr_leaf_hdr *hdr = bp->b_addr;
-	int			block_ok = 0;
+	struct xfs_attr_leafblock *leaf = bp->b_addr;
+	struct xfs_attr3_icleaf_hdr ichdr;
 
-	block_ok = hdr->info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC);
-	if (!block_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
+
+		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
+			return false;
+
+		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
+			return false;
+		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
+			return false;
+	} else {
+		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
+			return false;
 	}
+	if (ichdr.count == 0)
+		return false;
+
+	/* XXX: need to range check rest of attr header values */
+	/* XXX: hash order check? */
+
+	return true;
 }
 
 static void
-xfs_attr_leaf_read_verify(
+xfs_attr3_leaf_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_attr_leaf_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
+
+	if (!xfs_attr3_leaf_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_ATTR3_LEAF_CRC_OFF);
 }
 
+/*
+ * leaf/node format detection on trees is sketchy, so a node read can be done on
+ * leaf level blocks when detection identifies the tree as a node format tree
+ * incorrectly. In this case, we need to swap the verifier to match the correct
+ * format of the block being read.
+ */
 static void
-xfs_attr_leaf_write_verify(
-	struct xfs_buf	*bp)
+xfs_attr3_leaf_read_verify(
+	struct xfs_buf		*bp)
 {
-	xfs_attr_leaf_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  XFS_ATTR3_LEAF_CRC_OFF)) ||
+	    !xfs_attr3_leaf_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
-const struct xfs_buf_ops xfs_attr_leaf_buf_ops = {
-	.verify_read = xfs_attr_leaf_read_verify,
-	.verify_write = xfs_attr_leaf_write_verify,
+const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
+	.verify_read = xfs_attr3_leaf_read_verify,
+	.verify_write = xfs_attr3_leaf_write_verify,
 };
 
 int
-xfs_attr_leaf_read(
+xfs_attr3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
@@ -131,7 +270,7 @@ xfs_attr_leaf_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-				XFS_ATTR_FORK, &xfs_attr_leaf_buf_ops);
+				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
 }
 
 /*========================================================================
@@ -559,7 +698,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	}
 
 	ASSERT(blkno == 0);
-	error = xfs_attr_leaf_create(args, blkno, &bp);
+	error = xfs_attr3_leaf_create(args, blkno, &bp);
 	if (error) {
 		error = xfs_da_shrink_inode(args, 0, bp);
 		bp = NULL;
@@ -588,9 +727,9 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
-		error = xfs_attr_leaf_lookup_int(bp, &nargs); /* set a->index */
+		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == ENOATTR);
-		error = xfs_attr_leaf_add(bp, &nargs);
+		error = xfs_attr3_leaf_add(bp, &nargs);
 		ASSERT(error != ENOSPC);
 		if (error)
 			goto out;
@@ -803,7 +942,7 @@ xfs_attr_shortform_allfit(
 			continue;		/* don't copy partial entries */
 		if (!(entry->flags & XFS_ATTR_LOCAL))
 			return(0);
-		name_loc = xfs_attr_leaf_name_local(leaf, i);
+		name_loc = xfs_attr3_leaf_name_local(leaf, i);
 		if (name_loc->namelen >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return(0);
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
@@ -823,29 +962,34 @@ xfs_attr_shortform_allfit(
  * Convert a leaf attribute list to shortform attribute list
  */
 int
-xfs_attr_leaf_to_shortform(
-	struct xfs_buf	*bp,
-	xfs_da_args_t	*args,
-	int		forkoff)
+xfs_attr3_leaf_to_shortform(
+	struct xfs_buf		*bp,
+	struct xfs_da_args	*args,
+	int			forkoff)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_local_t *name_loc;
-	xfs_da_args_t nargs;
-	xfs_inode_t *dp;
-	char *tmpbuffer;
-	int error, i;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_local *name_loc;
+	struct xfs_da_args	nargs;
+	struct xfs_inode	*dp = args->dp;
+	char			*tmpbuffer;
+	int			error;
+	int			i;
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	dp = args->dp;
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(dp->i_mount), KM_SLEEP);
-	ASSERT(tmpbuffer != NULL);
+	if (!tmpbuffer)
+		return ENOMEM;
 
-	ASSERT(bp != NULL);
 	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(dp->i_mount));
+
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	/* XXX (dgc): buffer is about to be marked stale - why zero it? */
 	memset(bp->b_addr, 0, XFS_LBSIZE(dp->i_mount));
 
 	/*
@@ -875,14 +1019,14 @@ xfs_attr_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
-	entry = &leaf->entries[0];
-	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
+
+	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
 			continue;	/* don't copy partial entries */
 		if (!entry->nameidx)
 			continue;
 		ASSERT(entry->flags & XFS_ATTR_LOCAL);
-		name_loc = xfs_attr_leaf_name_local(leaf, i);
+		name_loc = xfs_attr3_leaf_name_local(leaf, i);
 		nargs.name = name_loc->nameval;
 		nargs.namelen = name_loc->namelen;
 		nargs.value = &name_loc->nameval[nargs.namelen];
@@ -895,43 +1039,50 @@ xfs_attr_leaf_to_shortform(
 
 out:
 	kmem_free(tmpbuffer);
-	return(error);
+	return error;
 }
 
 /*
  * Convert from using a single leaf to a root node and a leaf.
  */
 int
-xfs_attr_leaf_to_node(xfs_da_args_t *args)
+xfs_attr3_leaf_to_node(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_da_intnode_t *node;
-	xfs_inode_t *dp;
-	struct xfs_buf *bp1, *bp2;
-	xfs_dablk_t blkno;
-	int error;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr icleafhdr;
+	struct xfs_attr_leaf_entry *entries;
 	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr icnodehdr;
+	struct xfs_da_intnode	*node;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp1 = NULL;
+	struct xfs_buf		*bp2 = NULL;
+	xfs_dablk_t		blkno;
+	int			error;
 
 	trace_xfs_attr_leaf_to_node(args);
 
-	dp = args->dp;
-	bp1 = bp2 = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_attr_leaf_read(args->trans, args->dp, 0, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, dp, 0, -1, &bp1);
 	if (error)
 		goto out;
 
-	bp2 = NULL;
-	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp2,
-					    XFS_ATTR_FORK);
+	error = xfs_da_get_buf(args->trans, dp, blkno, -1, &bp2, XFS_ATTR_FORK);
 	if (error)
 		goto out;
+
+	/* copy leaf to new buffer, update identifiers */
 	bp2->b_ops = bp1->b_ops;
-	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(dp->i_mount));
-	bp1 = NULL;
-	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(dp->i_mount) - 1);
+	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(mp));
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
+		hdr3->blkno = cpu_to_be64(bp2->b_bn);
+	}
+	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(mp) - 1);
 
 	/*
 	 * Set up the new root node.
@@ -940,17 +1091,22 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	if (error)
 		goto out;
 	node = bp1->b_addr;
+	xfs_da3_node_hdr_from_disk(&icnodehdr, node);
+	btree = xfs_da3_node_tree_p(node);
+
 	leaf = bp2->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	xfs_attr3_leaf_hdr_from_disk(&icleafhdr, leaf);
+	entries = xfs_attr3_leaf_entryp(leaf);
+
 	/* both on-disk, don't endian-flip twice */
-	btree = xfs_da3_node_tree_p(node);
-	btree[0].hashval = leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
+	btree[0].hashval = entries[icleafhdr.count - 1].hashval;
 	btree[0].before = cpu_to_be32(blkno);
-	node->hdr.count = cpu_to_be16(1);
-	xfs_trans_log_buf(args->trans, bp1, 0, XFS_LBSIZE(dp->i_mount) - 1);
+	icnodehdr.count = 1;
+	xfs_da3_node_hdr_to_disk(node, &icnodehdr);
+	xfs_trans_log_buf(args->trans, bp1, 0, XFS_LBSIZE(mp) - 1);
 	error = 0;
 out:
-	return(error);
+	return error;
 }
 
 
@@ -963,52 +1119,62 @@ out:
  * or a leaf in a node attribute list.
  */
 STATIC int
-xfs_attr_leaf_create(
-	xfs_da_args_t	*args,
-	xfs_dablk_t	blkno,
-	struct xfs_buf	**bpp)
+xfs_attr3_leaf_create(
+	struct xfs_da_args	*args,
+	xfs_dablk_t		blkno,
+	struct xfs_buf		**bpp)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_hdr_t *hdr;
-	xfs_inode_t *dp;
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp;
+	int			error;
 
 	trace_xfs_attr_leaf_create(args);
 
-	dp = args->dp;
-	ASSERT(dp != NULL);
 	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
 					    XFS_ATTR_FORK);
 	if (error)
-		return(error);
-	bp->b_ops = &xfs_attr_leaf_buf_ops;
+		return error;
+	bp->b_ops = &xfs_attr3_leaf_buf_ops;
 	leaf = bp->b_addr;
-	memset((char *)leaf, 0, XFS_LBSIZE(dp->i_mount));
-	hdr = &leaf->hdr;
-	hdr->info.magic = cpu_to_be16(XFS_ATTR_LEAF_MAGIC);
-	hdr->firstused = cpu_to_be16(XFS_LBSIZE(dp->i_mount));
-	if (!hdr->firstused) {
-		hdr->firstused = cpu_to_be16(
-			XFS_LBSIZE(dp->i_mount) - XFS_ATTR_LEAF_NAME_ALIGN);
-	}
+	memset(leaf, 0, XFS_LBSIZE(mp));
 
-	hdr->freemap[0].base = cpu_to_be16(sizeof(xfs_attr_leaf_hdr_t));
-	hdr->freemap[0].size = cpu_to_be16(be16_to_cpu(hdr->firstused) -
-					   sizeof(xfs_attr_leaf_hdr_t));
+	memset(&ichdr, 0, sizeof(ichdr));
+	ichdr.firstused = XFS_LBSIZE(mp);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
+
+		ichdr.magic = XFS_ATTR3_LEAF_MAGIC;
+
+		hdr3->blkno = cpu_to_be64(bp->b_bn);
+		hdr3->owner = cpu_to_be64(dp->i_ino);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+
+		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
+	} else {
+		ichdr.magic = XFS_ATTR_LEAF_MAGIC;
+		ichdr.freemap[0].base = sizeof(struct xfs_attr_leaf_hdr);
+	}
+	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
 
-	xfs_trans_log_buf(args->trans, bp, 0, XFS_LBSIZE(dp->i_mount) - 1);
+	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
+	xfs_trans_log_buf(args->trans, bp, 0, XFS_LBSIZE(mp) - 1);
 
 	*bpp = bp;
-	return(0);
+	return 0;
 }
 
 /*
  * Split the leaf node, rebalance, then add the new entry.
  */
 int
-xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
-				   xfs_da_state_blk_t *newblk)
+xfs_attr3_leaf_split(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*oldblk,
+	struct xfs_da_state_blk	*newblk)
 {
 	xfs_dablk_t blkno;
 	int error;
@@ -1022,7 +1188,7 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	error = xfs_da_grow_inode(state->args, &blkno);
 	if (error)
 		return(error);
-	error = xfs_attr_leaf_create(state->args, blkno, &newblk->bp);
+	error = xfs_attr3_leaf_create(state->args, blkno, &newblk->bp);
 	if (error)
 		return(error);
 	newblk->blkno = blkno;
@@ -1032,7 +1198,7 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * Rebalance the entries across the two leaves.
 	 * NOTE: rebalance() currently depends on the 2nd block being empty.
 	 */
-	xfs_attr_leaf_rebalance(state, oldblk, newblk);
+	xfs_attr3_leaf_rebalance(state, oldblk, newblk);
 	error = xfs_da3_blk_link(state, oldblk, newblk);
 	if (error)
 		return(error);
@@ -1046,10 +1212,10 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 */
 	if (state->inleaf) {
 		trace_xfs_attr_leaf_add_old(state->args);
-		error = xfs_attr_leaf_add(oldblk->bp, state->args);
+		error = xfs_attr3_leaf_add(oldblk->bp, state->args);
 	} else {
 		trace_xfs_attr_leaf_add_new(state->args);
-		error = xfs_attr_leaf_add(newblk->bp, state->args);
+		error = xfs_attr3_leaf_add(newblk->bp, state->args);
 	}
 
 	/*
@@ -1064,22 +1230,23 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
  * Add a name to the leaf attribute list structure.
  */
 int
-xfs_attr_leaf_add(
+xfs_attr3_leaf_add(
 	struct xfs_buf		*bp,
 	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_hdr_t *hdr;
-	xfs_attr_leaf_map_t *map;
-	int tablesize, entsize, sum, tmp, i;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	int			tablesize;
+	int			entsize;
+	int			sum;
+	int			tmp;
+	int			i;
 
 	trace_xfs_attr_leaf_add(args);
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT((args->index >= 0)
-		&& (args->index <= be16_to_cpu(leaf->hdr.count)));
-	hdr = &leaf->hdr;
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	ASSERT(args->index >= 0 && args->index <= ichdr.count);
 	entsize = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
 			   args->trans->t_mountp->m_sb.sb_blocksize, NULL);
 
@@ -1087,25 +1254,23 @@ xfs_attr_leaf_add(
 	 * Search through freemap for first-fit on new name length.
 	 * (may need to figure in size of entry struct too)
 	 */
-	tablesize = (be16_to_cpu(hdr->count) + 1)
-					* sizeof(xfs_attr_leaf_entry_t)
-					+ sizeof(xfs_attr_leaf_hdr_t);
-	map = &hdr->freemap[XFS_ATTR_LEAF_MAPSIZE-1];
-	for (sum = 0, i = XFS_ATTR_LEAF_MAPSIZE-1; i >= 0; map--, i--) {
-		if (tablesize > be16_to_cpu(hdr->firstused)) {
-			sum += be16_to_cpu(map->size);
+	tablesize = (ichdr.count + 1) * sizeof(xfs_attr_leaf_entry_t)
+					+ xfs_attr3_leaf_hdr_size(leaf);
+	for (sum = 0, i = XFS_ATTR_LEAF_MAPSIZE - 1; i >= 0; i--) {
+		if (tablesize > ichdr.firstused) {
+			sum += ichdr.freemap[i].size;
 			continue;
 		}
-		if (!map->size)
+		if (!ichdr.freemap[i].size)
 			continue;	/* no space in this map */
 		tmp = entsize;
-		if (be16_to_cpu(map->base) < be16_to_cpu(hdr->firstused))
+		if (ichdr.freemap[i].base < ichdr.firstused)
 			tmp += sizeof(xfs_attr_leaf_entry_t);
-		if (be16_to_cpu(map->size) >= tmp) {
-			tmp = xfs_attr_leaf_add_work(bp, args, i);
-			return(tmp);
+		if (ichdr.freemap[i].size >= tmp) {
+			tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
+			goto out_log_hdr;
 		}
-		sum += be16_to_cpu(map->size);
+		sum += ichdr.freemap[i].size;
 	}
 
 	/*
@@ -1113,82 +1278,90 @@ xfs_attr_leaf_add(
 	 * and we don't have enough freespace, then compaction will do us
 	 * no good and we should just give up.
 	 */
-	if (!hdr->holes && (sum < entsize))
-		return(XFS_ERROR(ENOSPC));
+	if (!ichdr.holes && sum < entsize)
+		return XFS_ERROR(ENOSPC);
 
 	/*
 	 * Compact the entries to coalesce free space.
 	 * This may change the hdr->count via dropping INCOMPLETE entries.
 	 */
-	xfs_attr_leaf_compact(args, bp);
+	xfs_attr3_leaf_compact(args, &ichdr, bp);
 
 	/*
 	 * After compaction, the block is guaranteed to have only one
 	 * free region, in freemap[0].  If it is not big enough, give up.
 	 */
-	if (be16_to_cpu(hdr->freemap[0].size)
-				< (entsize + sizeof(xfs_attr_leaf_entry_t)))
-		return(XFS_ERROR(ENOSPC));
+	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
+		tmp = ENOSPC;
+		goto out_log_hdr;
+	}
+
+	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
 
-	return(xfs_attr_leaf_add_work(bp, args, 0));
+out_log_hdr:
+	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
+	xfs_trans_log_buf(args->trans, bp,
+		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
+				xfs_attr3_leaf_hdr_size(leaf)));
+	return tmp;
 }
 
 /*
  * Add a name to a leaf attribute list structure.
  */
 STATIC int
-xfs_attr_leaf_add_work(
-	struct xfs_buf	*bp,
-	xfs_da_args_t	*args,
-	int		mapindex)
+xfs_attr3_leaf_add_work(
+	struct xfs_buf		*bp,
+	struct xfs_attr3_icleaf_hdr *ichdr,
+	struct xfs_da_args	*args,
+	int			mapindex)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_hdr_t *hdr;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_local_t *name_loc;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	xfs_attr_leaf_map_t *map;
-	xfs_mount_t *mp;
-	int tmp, i;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_local *name_loc;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_attr_leaf_map *map;
+	struct xfs_mount	*mp;
+	int			tmp;
+	int			i;
 
 	trace_xfs_attr_leaf_add_work(args);
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	hdr = &leaf->hdr;
-	ASSERT((mapindex >= 0) && (mapindex < XFS_ATTR_LEAF_MAPSIZE));
-	ASSERT((args->index >= 0) && (args->index <= be16_to_cpu(hdr->count)));
+	ASSERT(mapindex >= 0 && mapindex < XFS_ATTR_LEAF_MAPSIZE);
+	ASSERT(args->index >= 0 && args->index <= ichdr->count);
 
 	/*
 	 * Force open some space in the entry array and fill it in.
 	 */
-	entry = &leaf->entries[args->index];
-	if (args->index < be16_to_cpu(hdr->count)) {
-		tmp  = be16_to_cpu(hdr->count) - args->index;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+	if (args->index < ichdr->count) {
+		tmp  = ichdr->count - args->index;
 		tmp *= sizeof(xfs_attr_leaf_entry_t);
-		memmove((char *)(entry+1), (char *)entry, tmp);
+		memmove(entry + 1, entry, tmp);
 		xfs_trans_log_buf(args->trans, bp,
 		    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(*entry)));
 	}
-	be16_add_cpu(&hdr->count, 1);
+	ichdr->count++;
 
 	/*
 	 * Allocate space for the new string (at the end of the run).
 	 */
-	map = &hdr->freemap[mapindex];
 	mp = args->trans->t_mountp;
-	ASSERT(be16_to_cpu(map->base) < XFS_LBSIZE(mp));
-	ASSERT((be16_to_cpu(map->base) & 0x3) == 0);
-	ASSERT(be16_to_cpu(map->size) >=
+	ASSERT(ichdr->freemap[mapindex].base < XFS_LBSIZE(mp));
+	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
+	ASSERT(ichdr->freemap[mapindex].size >=
 		xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
 					 mp->m_sb.sb_blocksize, NULL));
-	ASSERT(be16_to_cpu(map->size) < XFS_LBSIZE(mp));
-	ASSERT((be16_to_cpu(map->size) & 0x3) == 0);
-	be16_add_cpu(&map->size,
-		-xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
-					  mp->m_sb.sb_blocksize, &tmp));
-	entry->nameidx = cpu_to_be16(be16_to_cpu(map->base) +
-				     be16_to_cpu(map->size));
+	ASSERT(ichdr->freemap[mapindex].size < XFS_LBSIZE(mp));
+	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
+
+	ichdr->freemap[mapindex].size -=
+			xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
+						 mp->m_sb.sb_blocksize, &tmp);
+
+	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
+				     ichdr->freemap[mapindex].size);
 	entry->hashval = cpu_to_be32(args->hashval);
 	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
 	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
@@ -1203,7 +1376,7 @@ xfs_attr_leaf_add_work(
 			  XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	ASSERT((args->index == 0) ||
 	       (be32_to_cpu(entry->hashval) >= be32_to_cpu((entry-1)->hashval)));
-	ASSERT((args->index == be16_to_cpu(hdr->count)-1) ||
+	ASSERT((args->index == ichdr->count - 1) ||
 	       (be32_to_cpu(entry->hashval) <= be32_to_cpu((entry+1)->hashval)));
 
 	/*
@@ -1214,14 +1387,14 @@ xfs_attr_leaf_add_work(
 	 * as part of this transaction (a split operation for example).
 	 */
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
+		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
 		name_loc->namelen = args->namelen;
 		name_loc->valuelen = cpu_to_be16(args->valuelen);
 		memcpy((char *)name_loc->nameval, args->name, args->namelen);
 		memcpy((char *)&name_loc->nameval[args->namelen], args->value,
 				   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
 		name_rmt->namelen = args->namelen;
 		memcpy((char *)name_rmt->name, args->name, args->namelen);
 		entry->flags |= XFS_ATTR_INCOMPLETE;
@@ -1232,44 +1405,41 @@ xfs_attr_leaf_add_work(
 		args->rmtblkcnt = XFS_B_TO_FSB(mp, args->valuelen);
 	}
 	xfs_trans_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
+	     XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
 				   xfs_attr_leaf_entsize(leaf, args->index)));
 
 	/*
 	 * Update the control info for this leaf node
 	 */
-	if (be16_to_cpu(entry->nameidx) < be16_to_cpu(hdr->firstused)) {
-		/* both on-disk, don't endian-flip twice */
-		hdr->firstused = entry->nameidx;
-	}
-	ASSERT(be16_to_cpu(hdr->firstused) >=
-	       ((be16_to_cpu(hdr->count) * sizeof(*entry)) + sizeof(*hdr)));
-	tmp = (be16_to_cpu(hdr->count)-1) * sizeof(xfs_attr_leaf_entry_t)
-					+ sizeof(xfs_attr_leaf_hdr_t);
-	map = &hdr->freemap[0];
+	if (be16_to_cpu(entry->nameidx) < ichdr->firstused)
+		ichdr->firstused = be16_to_cpu(entry->nameidx);
+
+	ASSERT(ichdr->firstused >= ichdr->count * sizeof(xfs_attr_leaf_entry_t)
+					+ xfs_attr3_leaf_hdr_size(leaf));
+	tmp = (ichdr->count - 1) * sizeof(xfs_attr_leaf_entry_t)
+					+ xfs_attr3_leaf_hdr_size(leaf);
+
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
-		if (be16_to_cpu(map->base) == tmp) {
-			be16_add_cpu(&map->base, sizeof(xfs_attr_leaf_entry_t));
-			be16_add_cpu(&map->size,
-				 -((int)sizeof(xfs_attr_leaf_entry_t)));
+		if (ichdr->freemap[i].base == tmp) {
+			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
+			ichdr->freemap[i].size -= sizeof(xfs_attr_leaf_entry_t);
 		}
 	}
-	be16_add_cpu(&hdr->usedbytes, xfs_attr_leaf_entsize(leaf, args->index));
-	xfs_trans_log_buf(args->trans, bp,
-		XFS_DA_LOGRANGE(leaf, hdr, sizeof(*hdr)));
-	return(0);
+	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
+	return 0;
 }
 
 /*
  * Garbage collect a leaf attribute list block by copying it to a new buffer.
  */
 STATIC void
-xfs_attr_leaf_compact(
+xfs_attr3_leaf_compact(
 	struct xfs_da_args	*args,
+	struct xfs_attr3_icleaf_hdr *ichdr_d,
 	struct xfs_buf		*bp)
 {
 	xfs_attr_leafblock_t	*leaf_s, *leaf_d;
-	xfs_attr_leaf_hdr_t	*hdr_s, *hdr_d;
+	struct xfs_attr3_icleaf_hdr ichdr_s;
 	struct xfs_trans	*trans = args->trans;
 	struct xfs_mount	*mp = trans->t_mountp;
 	char			*tmpbuffer;
@@ -1286,34 +1456,69 @@ xfs_attr_leaf_compact(
 	 */
 	leaf_s = (xfs_attr_leafblock_t *)tmpbuffer;
 	leaf_d = bp->b_addr;
-	hdr_s = &leaf_s->hdr;
-	hdr_d = &leaf_d->hdr;
-	hdr_d->info = hdr_s->info;	/* struct copy */
-	hdr_d->firstused = cpu_to_be16(XFS_LBSIZE(mp));
-	/* handle truncation gracefully */
-	if (!hdr_d->firstused) {
-		hdr_d->firstused = cpu_to_be16(
-				XFS_LBSIZE(mp) - XFS_ATTR_LEAF_NAME_ALIGN);
-	}
-	hdr_d->usedbytes = 0;
-	hdr_d->count = 0;
-	hdr_d->holes = 0;
-	hdr_d->freemap[0].base = cpu_to_be16(sizeof(xfs_attr_leaf_hdr_t));
-	hdr_d->freemap[0].size = cpu_to_be16(be16_to_cpu(hdr_d->firstused) -
-					     sizeof(xfs_attr_leaf_hdr_t));
+	ichdr_s = *ichdr_d;	/* struct copy */
+	ichdr_d->firstused = XFS_LBSIZE(mp);
+	ichdr_d->usedbytes = 0;
+	ichdr_d->count = 0;
+	ichdr_d->holes = 0;
+	ichdr_d->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_s);
+	ichdr_d->freemap[0].size = ichdr_d->firstused - ichdr_d->freemap[0].base;
 
 	/*
 	 * Copy all entry's in the same (sorted) order,
 	 * but allocate name/value pairs packed and in sequence.
 	 */
-	xfs_attr_leaf_moveents(leaf_s, 0, leaf_d, 0,
-				be16_to_cpu(hdr_s->count), mp);
+	xfs_attr3_leaf_moveents(leaf_s, &ichdr_s, 0, leaf_d, ichdr_d, 0,
+				ichdr_s.count, mp);
+	/*
+	 * this logs the entire buffer, but the caller must write the header
+	 * back to the buffer when it is finished modifying it.
+	 */
 	xfs_trans_log_buf(trans, bp, 0, XFS_LBSIZE(mp) - 1);
 
 	kmem_free(tmpbuffer);
 }
 
 /*
+ * Compare two leaf blocks "order".
+ * Return 0 unless leaf2 should go before leaf1.
+ */
+static int
+xfs_attr3_leaf_order(
+	struct xfs_buf	*leaf1_bp,
+	struct xfs_attr3_icleaf_hdr *leaf1hdr,
+	struct xfs_buf	*leaf2_bp,
+	struct xfs_attr3_icleaf_hdr *leaf2hdr)
+{
+	struct xfs_attr_leaf_entry *entries1;
+	struct xfs_attr_leaf_entry *entries2;
+
+	entries1 = xfs_attr3_leaf_entryp(leaf1_bp->b_addr);
+	entries2 = xfs_attr3_leaf_entryp(leaf2_bp->b_addr);
+	if (leaf1hdr->count > 0 && leaf2hdr->count > 0 &&
+	    ((be32_to_cpu(entries2[0].hashval) <
+	      be32_to_cpu(entries1[0].hashval)) ||
+	     (be32_to_cpu(entries2[leaf2hdr->count - 1].hashval) <
+	      be32_to_cpu(entries1[leaf1hdr->count - 1].hashval)))) {
+		return 1;
+	}
+	return 0;
+}
+
+int
+xfs_attr_leaf_order(
+	struct xfs_buf	*leaf1_bp,
+	struct xfs_buf	*leaf2_bp)
+{
+	struct xfs_attr3_icleaf_hdr ichdr1;
+	struct xfs_attr3_icleaf_hdr ichdr2;
+
+	xfs_attr3_leaf_hdr_from_disk(&ichdr1, leaf1_bp->b_addr);
+	xfs_attr3_leaf_hdr_from_disk(&ichdr2, leaf2_bp->b_addr);
+	return xfs_attr3_leaf_order(leaf1_bp, &ichdr1, leaf2_bp, &ichdr2);
+}
+
+/*
  * Redistribute the attribute list entries between two leaf nodes,
  * taking into account the size of the new entry.
  *
@@ -1326,14 +1531,23 @@ xfs_attr_leaf_compact(
  * the "new" and "old" values can end up in different blocks.
  */
 STATIC void
-xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
-				       xfs_da_state_blk_t *blk2)
+xfs_attr3_leaf_rebalance(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*blk1,
+	struct xfs_da_state_blk	*blk2)
 {
-	xfs_da_args_t *args;
-	xfs_da_state_blk_t *tmp_blk;
-	xfs_attr_leafblock_t *leaf1, *leaf2;
-	xfs_attr_leaf_hdr_t *hdr1, *hdr2;
-	int count, totallen, max, space, swap;
+	struct xfs_da_args	*args;
+	struct xfs_attr_leafblock *leaf1;
+	struct xfs_attr_leafblock *leaf2;
+	struct xfs_attr3_icleaf_hdr ichdr1;
+	struct xfs_attr3_icleaf_hdr ichdr2;
+	struct xfs_attr_leaf_entry *entries1;
+	struct xfs_attr_leaf_entry *entries2;
+	int			count;
+	int			totallen;
+	int			max;
+	int			space;
+	int			swap;
 
 	/*
 	 * Set up environment.
@@ -1342,9 +1556,9 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	ASSERT(blk2->magic == XFS_ATTR_LEAF_MAGIC);
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
-	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT(leaf2->hdr.count == 0);
+	xfs_attr3_leaf_hdr_from_disk(&ichdr1, leaf1);
+	xfs_attr3_leaf_hdr_from_disk(&ichdr2, leaf2);
+	ASSERT(ichdr2.count == 0);
 	args = state->args;
 
 	trace_xfs_attr_leaf_rebalance(args);
@@ -1356,16 +1570,23 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	 * second block, this code should never set "swap".
 	 */
 	swap = 0;
-	if (xfs_attr_leaf_order(blk1->bp, blk2->bp)) {
+	if (xfs_attr3_leaf_order(blk1->bp, &ichdr1, blk2->bp, &ichdr2)) {
+		struct xfs_da_state_blk	*tmp_blk;
+		struct xfs_attr3_icleaf_hdr tmp_ichdr;
+
 		tmp_blk = blk1;
 		blk1 = blk2;
 		blk2 = tmp_blk;
+
+		/* struct copies to swap them rather than reconverting */
+		tmp_ichdr = ichdr1;
+		ichdr1 = ichdr2;
+		ichdr2 = tmp_ichdr;
+
 		leaf1 = blk1->bp->b_addr;
 		leaf2 = blk2->bp->b_addr;
 		swap = 1;
 	}
-	hdr1 = &leaf1->hdr;
-	hdr2 = &leaf2->hdr;
 
 	/*
 	 * Examine entries until we reduce the absolute difference in
@@ -1375,41 +1596,39 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	 * "inleaf" is true if the new entry should be inserted into blk1.
 	 * If "swap" is also true, then reverse the sense of "inleaf".
 	 */
-	state->inleaf = xfs_attr_leaf_figure_balance(state, blk1, blk2,
-							    &count, &totallen);
+	state->inleaf = xfs_attr3_leaf_figure_balance(state, blk1, &ichdr1,
+						      blk2, &ichdr2,
+						      &count, &totallen);
 	if (swap)
 		state->inleaf = !state->inleaf;
 
 	/*
 	 * Move any entries required from leaf to leaf:
 	 */
-	if (count < be16_to_cpu(hdr1->count)) {
+	if (count < ichdr1.count) {
 		/*
 		 * Figure the total bytes to be added to the destination leaf.
 		 */
 		/* number entries being moved */
-		count = be16_to_cpu(hdr1->count) - count;
-		space  = be16_to_cpu(hdr1->usedbytes) - totallen;
+		count = ichdr1.count - count;
+		space  = ichdr1.usedbytes - totallen;
 		space += count * sizeof(xfs_attr_leaf_entry_t);
 
 		/*
 		 * leaf2 is the destination, compact it if it looks tight.
 		 */
-		max  = be16_to_cpu(hdr2->firstused)
-						- sizeof(xfs_attr_leaf_hdr_t);
-		max -= be16_to_cpu(hdr2->count) * sizeof(xfs_attr_leaf_entry_t);
+		max  = ichdr2.firstused - xfs_attr3_leaf_hdr_size(leaf1);
+		max -= ichdr2.count * sizeof(xfs_attr_leaf_entry_t);
 		if (space > max)
-			xfs_attr_leaf_compact(args, blk2->bp);
+			xfs_attr3_leaf_compact(args, &ichdr2, blk2->bp);
 
 		/*
 		 * Move high entries from leaf1 to low end of leaf2.
 		 */
-		xfs_attr_leaf_moveents(leaf1, be16_to_cpu(hdr1->count) - count,
-				leaf2, 0, count, state->mp);
+		xfs_attr3_leaf_moveents(leaf1, &ichdr1, ichdr1.count - count,
+				leaf2, &ichdr2, 0, count, state->mp);
 
-		xfs_trans_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
-		xfs_trans_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
-	} else if (count > be16_to_cpu(hdr1->count)) {
+	} else if (count > ichdr1.count) {
 		/*
 		 * I assert that since all callers pass in an empty
 		 * second buffer, this code should never execute.
@@ -1420,36 +1639,37 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		 * Figure the total bytes to be added to the destination leaf.
 		 */
 		/* number entries being moved */
-		count -= be16_to_cpu(hdr1->count);
-		space  = totallen - be16_to_cpu(hdr1->usedbytes);
+		count -= ichdr1.count;
+		space  = totallen - ichdr1.usedbytes;
 		space += count * sizeof(xfs_attr_leaf_entry_t);
 
 		/*
 		 * leaf1 is the destination, compact it if it looks tight.
 		 */
-		max  = be16_to_cpu(hdr1->firstused)
-						- sizeof(xfs_attr_leaf_hdr_t);
-		max -= be16_to_cpu(hdr1->count) * sizeof(xfs_attr_leaf_entry_t);
+		max  = ichdr1.firstused - xfs_attr3_leaf_hdr_size(leaf1);
+		max -= ichdr1.count * sizeof(xfs_attr_leaf_entry_t);
 		if (space > max)
-			xfs_attr_leaf_compact(args, blk1->bp);
+			xfs_attr3_leaf_compact(args, &ichdr1, blk1->bp);
 
 		/*
 		 * Move low entries from leaf2 to high end of leaf1.
 		 */
-		xfs_attr_leaf_moveents(leaf2, 0, leaf1,
-				be16_to_cpu(hdr1->count), count, state->mp);
-
-		xfs_trans_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
-		xfs_trans_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
+		xfs_attr3_leaf_moveents(leaf2, &ichdr2, 0, leaf1, &ichdr1,
+					ichdr1.count, count, state->mp);
 	}
 
+	xfs_attr3_leaf_hdr_to_disk(leaf1, &ichdr1);
+	xfs_attr3_leaf_hdr_to_disk(leaf2, &ichdr2);
+	xfs_trans_log_buf(args->trans, blk1->bp, 0, state->blocksize-1);
+	xfs_trans_log_buf(args->trans, blk2->bp, 0, state->blocksize-1);
+
 	/*
 	 * Copy out last hashval in each block for B-tree code.
 	 */
-	blk1->hashval = be32_to_cpu(
-		leaf1->entries[be16_to_cpu(leaf1->hdr.count)-1].hashval);
-	blk2->hashval = be32_to_cpu(
-		leaf2->entries[be16_to_cpu(leaf2->hdr.count)-1].hashval);
+	entries1 = xfs_attr3_leaf_entryp(leaf1);
+	entries2 = xfs_attr3_leaf_entryp(leaf2);
+	blk1->hashval = be32_to_cpu(entries1[ichdr1.count - 1].hashval);
+	blk2->hashval = be32_to_cpu(entries2[ichdr2.count - 1].hashval);
 
 	/*
 	 * Adjust the expected index for insertion.
@@ -1463,12 +1683,12 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	 * inserting.  The index/blkno fields refer to the "old" entry,
 	 * while the index2/blkno2 fields refer to the "new" entry.
 	 */
-	if (blk1->index > be16_to_cpu(leaf1->hdr.count)) {
+	if (blk1->index > ichdr1.count) {
 		ASSERT(state->inleaf == 0);
-		blk2->index = blk1->index - be16_to_cpu(leaf1->hdr.count);
+		blk2->index = blk1->index - ichdr1.count;
 		args->index = args->index2 = blk2->index;
 		args->blkno = args->blkno2 = blk2->blkno;
-	} else if (blk1->index == be16_to_cpu(leaf1->hdr.count)) {
+	} else if (blk1->index == ichdr1.count) {
 		if (state->inleaf) {
 			args->index = blk1->index;
 			args->blkno = blk1->blkno;
@@ -1480,8 +1700,7 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 			 * is already stored in blkno2/index2, so don't
 			 * overwrite it overwise we corrupt the tree.
 			 */
-			blk2->index = blk1->index
-				    - be16_to_cpu(leaf1->hdr.count);
+			blk2->index = blk1->index - ichdr1.count;
 			args->index = blk2->index;
 			args->blkno = blk2->blkno;
 			if (!state->extravalid) {
@@ -1509,42 +1728,40 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
  * GROT: Do a double-split for this case?
  */
 STATIC int
-xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
-				    xfs_da_state_blk_t *blk1,
-				    xfs_da_state_blk_t *blk2,
-				    int *countarg, int *usedbytesarg)
+xfs_attr3_leaf_figure_balance(
+	struct xfs_da_state		*state,
+	struct xfs_da_state_blk		*blk1,
+	struct xfs_attr3_icleaf_hdr	*ichdr1,
+	struct xfs_da_state_blk		*blk2,
+	struct xfs_attr3_icleaf_hdr	*ichdr2,
+	int				*countarg,
+	int				*usedbytesarg)
 {
-	xfs_attr_leafblock_t *leaf1, *leaf2;
-	xfs_attr_leaf_hdr_t *hdr1, *hdr2;
-	xfs_attr_leaf_entry_t *entry;
-	int count, max, index, totallen, half;
-	int lastdelta, foundit, tmp;
-
-	/*
-	 * Set up environment.
-	 */
-	leaf1 = blk1->bp->b_addr;
-	leaf2 = blk2->bp->b_addr;
-	hdr1 = &leaf1->hdr;
-	hdr2 = &leaf2->hdr;
-	foundit = 0;
-	totallen = 0;
+	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
+	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
+	int				count;
+	int				max;
+	int				index;
+	int				totallen = 0;
+	int				half;
+	int				lastdelta;
+	int				foundit = 0;
+	int				tmp;
 
 	/*
 	 * Examine entries until we reduce the absolute difference in
 	 * byte usage between the two blocks to a minimum.
 	 */
-	max = be16_to_cpu(hdr1->count) + be16_to_cpu(hdr2->count);
-	half  = (max+1) * sizeof(*entry);
-	half += be16_to_cpu(hdr1->usedbytes) +
-		be16_to_cpu(hdr2->usedbytes) +
-		xfs_attr_leaf_newentsize(
-				state->args->namelen,
-				state->args->valuelen,
-				state->blocksize, NULL);
+	max = ichdr1->count + ichdr2->count;
+	half = (max + 1) * sizeof(*entry);
+	half += ichdr1->usedbytes + ichdr2->usedbytes +
+			xfs_attr_leaf_newentsize(state->args->namelen,
+						 state->args->valuelen,
+						 state->blocksize, NULL);
 	half /= 2;
 	lastdelta = state->blocksize;
-	entry = &leaf1->entries[0];
+	entry = xfs_attr3_leaf_entryp(leaf1);
 	for (count = index = 0; count < max; entry++, index++, count++) {
 
 #define XFS_ATTR_ABS(A)	(((A) < 0) ? -(A) : (A))
@@ -1567,9 +1784,9 @@ xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
 		/*
 		 * Wrap around into the second block if necessary.
 		 */
-		if (count == be16_to_cpu(hdr1->count)) {
+		if (count == ichdr1->count) {
 			leaf1 = leaf2;
-			entry = &leaf1->entries[0];
+			entry = xfs_attr3_leaf_entryp(leaf1);
 			index = 0;
 		}
 
@@ -1600,7 +1817,7 @@ xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
 
 	*countarg = count;
 	*usedbytesarg = totallen;
-	return(foundit);
+	return foundit;
 }
 
 /*========================================================================
@@ -1619,14 +1836,20 @@ xfs_attr_leaf_figure_balance(xfs_da_state_t *state,
  * GROT: allow for INCOMPLETE entries in calculation.
  */
 int
-xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
+xfs_attr3_leaf_toosmall(
+	struct xfs_da_state	*state,
+	int			*action)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_da_state_blk_t *blk;
-	xfs_da_blkinfo_t *info;
-	int count, bytes, forward, error, retval, i;
-	xfs_dablk_t blkno;
-	struct xfs_buf *bp;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_buf		*bp;
+	xfs_dablk_t		blkno;
+	int			bytes;
+	int			forward;
+	int			error;
+	int			retval;
+	int			i;
 
 	trace_xfs_attr_leaf_toosmall(state->args);
 
@@ -1636,13 +1859,11 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	 * to coalesce with a sibling.
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
-	info = blk->bp->b_addr;
-	ASSERT(info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	leaf = (xfs_attr_leafblock_t *)info;
-	count = be16_to_cpu(leaf->hdr.count);
-	bytes = sizeof(xfs_attr_leaf_hdr_t) +
-		count * sizeof(xfs_attr_leaf_entry_t) +
-		be16_to_cpu(leaf->hdr.usedbytes);
+	leaf = blk->bp->b_addr;
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	bytes = xfs_attr3_leaf_hdr_size(leaf) +
+		ichdr.count * sizeof(xfs_attr_leaf_entry_t) +
+		ichdr.usedbytes;
 	if (bytes > (state->blocksize >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
 		return(0);
@@ -1654,12 +1875,12 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	 * coalesce it with a sibling block.  We choose (arbitrarily)
 	 * to merge with the forward block unless it is NULL.
 	 */
-	if (count == 0) {
+	if (ichdr.count == 0) {
 		/*
 		 * Make altpath point to the block we want to keep and
 		 * path point to the block we want to drop (this one).
 		 */
-		forward = (info->forw != 0);
+		forward = (ichdr.forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
 		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
@@ -1670,7 +1891,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 		} else {
 			*action = 2;
 		}
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -1681,28 +1902,28 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	 * to shrink an attribute list over time.
 	 */
 	/* start with smaller blk num */
-	forward = (be32_to_cpu(info->forw) < be32_to_cpu(info->back));
+	forward = ichdr.forw < ichdr.back;
 	for (i = 0; i < 2; forward = !forward, i++) {
+		struct xfs_attr3_icleaf_hdr ichdr2;
 		if (forward)
-			blkno = be32_to_cpu(info->forw);
+			blkno = ichdr.forw;
 		else
-			blkno = be32_to_cpu(info->back);
+			blkno = ichdr.back;
 		if (blkno == 0)
 			continue;
-		error = xfs_attr_leaf_read(state->args->trans, state->args->dp,
+		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
 					blkno, -1, &bp);
 		if (error)
 			return(error);
 
-		leaf = (xfs_attr_leafblock_t *)info;
-		count  = be16_to_cpu(leaf->hdr.count);
-		bytes  = state->blocksize - (state->blocksize>>2);
-		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
-		leaf = bp->b_addr;
-		count += be16_to_cpu(leaf->hdr.count);
-		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
-		bytes -= count * sizeof(xfs_attr_leaf_entry_t);
-		bytes -= sizeof(xfs_attr_leaf_hdr_t);
+		xfs_attr3_leaf_hdr_from_disk(&ichdr2, bp->b_addr);
+
+		bytes = state->blocksize - (state->blocksize >> 2) -
+			ichdr.usedbytes - ichdr2.usedbytes -
+			((ichdr.count + ichdr2.count) *
+					sizeof(xfs_attr_leaf_entry_t)) -
+			xfs_attr3_leaf_hdr_size(leaf);
+
 		xfs_trans_brelse(state->args->trans, bp);
 		if (bytes >= 0)
 			break;	/* fits with at least 25% to spare */
@@ -1741,32 +1962,35 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
  * If two leaves are 37% full, when combined they will leave 25% free.
  */
 int
-xfs_attr_leaf_remove(
-	struct xfs_buf	*bp,
-	xfs_da_args_t	*args)
+xfs_attr3_leaf_remove(
+	struct xfs_buf		*bp,
+	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_hdr_t *hdr;
-	xfs_attr_leaf_map_t *map;
-	xfs_attr_leaf_entry_t *entry;
-	int before, after, smallest, entsize;
-	int tablesize, tmp, i;
-	xfs_mount_t *mp;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_mount	*mp = args->trans->t_mountp;
+	int			before;
+	int			after;
+	int			smallest;
+	int			entsize;
+	int			tablesize;
+	int			tmp;
+	int			i;
 
 	trace_xfs_attr_leaf_remove(args);
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	hdr = &leaf->hdr;
-	mp = args->trans->t_mountp;
-	ASSERT((be16_to_cpu(hdr->count) > 0)
-		&& (be16_to_cpu(hdr->count) < (XFS_LBSIZE(mp)/8)));
-	ASSERT((args->index >= 0)
-		&& (args->index < be16_to_cpu(hdr->count)));
-	ASSERT(be16_to_cpu(hdr->firstused) >=
-	       ((be16_to_cpu(hdr->count) * sizeof(*entry)) + sizeof(*hdr)));
-	entry = &leaf->entries[args->index];
-	ASSERT(be16_to_cpu(entry->nameidx) >= be16_to_cpu(hdr->firstused));
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+
+	ASSERT(ichdr.count > 0 && ichdr.count < XFS_LBSIZE(mp) / 8);
+	ASSERT(args->index >= 0 && args->index < ichdr.count);
+	ASSERT(ichdr.firstused >= ichdr.count * sizeof(*entry) +
+					xfs_attr3_leaf_hdr_size(leaf));
+
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+
+	ASSERT(be16_to_cpu(entry->nameidx) >= ichdr.firstused);
 	ASSERT(be16_to_cpu(entry->nameidx) < XFS_LBSIZE(mp));
 
 	/*
@@ -1775,30 +1999,28 @@ xfs_attr_leaf_remove(
 	 *    find smallest free region in case we need to replace it,
 	 *    adjust any map that borders the entry table,
 	 */
-	tablesize = be16_to_cpu(hdr->count) * sizeof(xfs_attr_leaf_entry_t)
-					+ sizeof(xfs_attr_leaf_hdr_t);
-	map = &hdr->freemap[0];
-	tmp = be16_to_cpu(map->size);
+	tablesize = ichdr.count * sizeof(xfs_attr_leaf_entry_t)
+					+ xfs_attr3_leaf_hdr_size(leaf);
+	tmp = ichdr.freemap[0].size;
 	before = after = -1;
 	smallest = XFS_ATTR_LEAF_MAPSIZE - 1;
 	entsize = xfs_attr_leaf_entsize(leaf, args->index);
-	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
-		ASSERT(be16_to_cpu(map->base) < XFS_LBSIZE(mp));
-		ASSERT(be16_to_cpu(map->size) < XFS_LBSIZE(mp));
-		if (be16_to_cpu(map->base) == tablesize) {
-			be16_add_cpu(&map->base,
-				 -((int)sizeof(xfs_attr_leaf_entry_t)));
-			be16_add_cpu(&map->size, sizeof(xfs_attr_leaf_entry_t));
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		ASSERT(ichdr.freemap[i].base < XFS_LBSIZE(mp));
+		ASSERT(ichdr.freemap[i].size < XFS_LBSIZE(mp));
+		if (ichdr.freemap[i].base == tablesize) {
+			ichdr.freemap[i].base -= sizeof(xfs_attr_leaf_entry_t);
+			ichdr.freemap[i].size += sizeof(xfs_attr_leaf_entry_t);
 		}
 
-		if ((be16_to_cpu(map->base) + be16_to_cpu(map->size))
-				== be16_to_cpu(entry->nameidx)) {
+		if (ichdr.freemap[i].base + ichdr.freemap[i].size ==
+				be16_to_cpu(entry->nameidx)) {
 			before = i;
-		} else if (be16_to_cpu(map->base)
-			== (be16_to_cpu(entry->nameidx) + entsize)) {
+		} else if (ichdr.freemap[i].base ==
+				(be16_to_cpu(entry->nameidx) + entsize)) {
 			after = i;
-		} else if (be16_to_cpu(map->size) < tmp) {
-			tmp = be16_to_cpu(map->size);
+		} else if (ichdr.freemap[i].size < tmp) {
+			tmp = ichdr.freemap[i].size;
 			smallest = i;
 		}
 	}
@@ -1809,36 +2031,30 @@ xfs_attr_leaf_remove(
 	 */
 	if ((before >= 0) || (after >= 0)) {
 		if ((before >= 0) && (after >= 0)) {
-			map = &hdr->freemap[before];
-			be16_add_cpu(&map->size, entsize);
-			be16_add_cpu(&map->size,
-				 be16_to_cpu(hdr->freemap[after].size));
-			hdr->freemap[after].base = 0;
-			hdr->freemap[after].size = 0;
+			ichdr.freemap[before].size += entsize;
+			ichdr.freemap[before].size += ichdr.freemap[after].size;
+			ichdr.freemap[after].base = 0;
+			ichdr.freemap[after].size = 0;
 		} else if (before >= 0) {
-			map = &hdr->freemap[before];
-			be16_add_cpu(&map->size, entsize);
+			ichdr.freemap[before].size += entsize;
 		} else {
-			map = &hdr->freemap[after];
-			/* both on-disk, don't endian flip twice */
-			map->base = entry->nameidx;
-			be16_add_cpu(&map->size, entsize);
+			ichdr.freemap[after].base = be16_to_cpu(entry->nameidx);
+			ichdr.freemap[after].size += entsize;
 		}
 	} else {
 		/*
 		 * Replace smallest region (if it is smaller than free'd entry)
 		 */
-		map = &hdr->freemap[smallest];
-		if (be16_to_cpu(map->size) < entsize) {
-			map->base = cpu_to_be16(be16_to_cpu(entry->nameidx));
-			map->size = cpu_to_be16(entsize);
+		if (ichdr.freemap[smallest].size < entsize) {
+			ichdr.freemap[smallest].base = be16_to_cpu(entry->nameidx);
+			ichdr.freemap[smallest].size = entsize;
 		}
 	}
 
 	/*
 	 * Did we remove the first entry?
 	 */
-	if (be16_to_cpu(entry->nameidx) == be16_to_cpu(hdr->firstused))
+	if (be16_to_cpu(entry->nameidx) == ichdr.firstused)
 		smallest = 1;
 	else
 		smallest = 0;
@@ -1846,20 +2062,20 @@ xfs_attr_leaf_remove(
 	/*
 	 * Compress the remaining entries and zero out the removed stuff.
 	 */
-	memset(xfs_attr_leaf_name(leaf, args->index), 0, entsize);
-	be16_add_cpu(&hdr->usedbytes, -entsize);
+	memset(xfs_attr3_leaf_name(leaf, args->index), 0, entsize);
+	ichdr.usedbytes -= entsize;
 	xfs_trans_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
+	     XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
 				   entsize));
 
-	tmp = (be16_to_cpu(hdr->count) - args->index)
-					* sizeof(xfs_attr_leaf_entry_t);
-	memmove((char *)entry, (char *)(entry+1), tmp);
-	be16_add_cpu(&hdr->count, -1);
+	tmp = (ichdr.count - args->index) * sizeof(xfs_attr_leaf_entry_t);
+	memmove(entry, entry + 1, tmp);
+	ichdr.count--;
 	xfs_trans_log_buf(args->trans, bp,
-	    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(*entry)));
-	entry = &leaf->entries[be16_to_cpu(hdr->count)];
-	memset((char *)entry, 0, sizeof(xfs_attr_leaf_entry_t));
+	    XFS_DA_LOGRANGE(leaf, entry, tmp + sizeof(xfs_attr_leaf_entry_t)));
+
+	entry = &xfs_attr3_leaf_entryp(leaf)[ichdr.count];
+	memset(entry, 0, sizeof(xfs_attr_leaf_entry_t));
 
 	/*
 	 * If we removed the first entry, re-find the first used byte
@@ -1869,130 +2085,130 @@ xfs_attr_leaf_remove(
 	 */
 	if (smallest) {
 		tmp = XFS_LBSIZE(mp);
-		entry = &leaf->entries[0];
-		for (i = be16_to_cpu(hdr->count)-1; i >= 0; entry++, i--) {
-			ASSERT(be16_to_cpu(entry->nameidx) >=
-			       be16_to_cpu(hdr->firstused));
+		entry = xfs_attr3_leaf_entryp(leaf);
+		for (i = ichdr.count - 1; i >= 0; entry++, i--) {
+			ASSERT(be16_to_cpu(entry->nameidx) >= ichdr.firstused);
 			ASSERT(be16_to_cpu(entry->nameidx) < XFS_LBSIZE(mp));
 
 			if (be16_to_cpu(entry->nameidx) < tmp)
 				tmp = be16_to_cpu(entry->nameidx);
 		}
-		hdr->firstused = cpu_to_be16(tmp);
-		if (!hdr->firstused) {
-			hdr->firstused = cpu_to_be16(
-					tmp - XFS_ATTR_LEAF_NAME_ALIGN);
-		}
+		ichdr.firstused = tmp;
+		if (!ichdr.firstused)
+			ichdr.firstused = tmp - XFS_ATTR_LEAF_NAME_ALIGN;
 	} else {
-		hdr->holes = 1;		/* mark as needing compaction */
+		ichdr.holes = 1;	/* mark as needing compaction */
 	}
+	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
-			  XFS_DA_LOGRANGE(leaf, hdr, sizeof(*hdr)));
+			  XFS_DA_LOGRANGE(leaf, &leaf->hdr,
+					  xfs_attr3_leaf_hdr_size(leaf)));
 
 	/*
 	 * Check if leaf is less than 50% full, caller may want to
 	 * "join" the leaf with a sibling if so.
 	 */
-	tmp  = sizeof(xfs_attr_leaf_hdr_t);
-	tmp += be16_to_cpu(leaf->hdr.count) * sizeof(xfs_attr_leaf_entry_t);
-	tmp += be16_to_cpu(leaf->hdr.usedbytes);
-	return(tmp < mp->m_attr_magicpct); /* leaf is < 37% full */
+	tmp = ichdr.usedbytes + xfs_attr3_leaf_hdr_size(leaf) +
+	      ichdr.count * sizeof(xfs_attr_leaf_entry_t);
+
+	return tmp < mp->m_attr_magicpct; /* leaf is < 37% full */
 }
 
 /*
  * Move all the attribute list entries from drop_leaf into save_leaf.
  */
 void
-xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
-				       xfs_da_state_blk_t *save_blk)
+xfs_attr3_leaf_unbalance(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk,
+	struct xfs_da_state_blk	*save_blk)
 {
-	xfs_attr_leafblock_t *drop_leaf, *save_leaf, *tmp_leaf;
-	xfs_attr_leaf_hdr_t *drop_hdr, *save_hdr, *tmp_hdr;
-	xfs_mount_t *mp;
-	char *tmpbuffer;
+	struct xfs_attr_leafblock *drop_leaf = drop_blk->bp->b_addr;
+	struct xfs_attr_leafblock *save_leaf = save_blk->bp->b_addr;
+	struct xfs_attr3_icleaf_hdr drophdr;
+	struct xfs_attr3_icleaf_hdr savehdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_mount	*mp = state->mp;
 
 	trace_xfs_attr_leaf_unbalance(state->args);
 
-	/*
-	 * Set up environment.
-	 */
-	mp = state->mp;
-	ASSERT(drop_blk->magic == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(save_blk->magic == XFS_ATTR_LEAF_MAGIC);
 	drop_leaf = drop_blk->bp->b_addr;
 	save_leaf = save_blk->bp->b_addr;
-	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	drop_hdr = &drop_leaf->hdr;
-	save_hdr = &save_leaf->hdr;
+	xfs_attr3_leaf_hdr_from_disk(&drophdr, drop_leaf);
+	xfs_attr3_leaf_hdr_from_disk(&savehdr, save_leaf);
+	entry = xfs_attr3_leaf_entryp(drop_leaf);
 
 	/*
 	 * Save last hashval from dying block for later Btree fixup.
 	 */
-	drop_blk->hashval = be32_to_cpu(
-		drop_leaf->entries[be16_to_cpu(drop_leaf->hdr.count)-1].hashval);
+	drop_blk->hashval = be32_to_cpu(entry[drophdr.count - 1].hashval);
 
 	/*
 	 * Check if we need a temp buffer, or can we do it in place.
 	 * Note that we don't check "leaf" for holes because we will
 	 * always be dropping it, toosmall() decided that for us already.
 	 */
-	if (save_hdr->holes == 0) {
+	if (savehdr.holes == 0) {
 		/*
 		 * dest leaf has no holes, so we add there.  May need
 		 * to make some room in the entry array.
 		 */
-		if (xfs_attr_leaf_order(save_blk->bp, drop_blk->bp)) {
-			xfs_attr_leaf_moveents(drop_leaf, 0, save_leaf, 0,
-			     be16_to_cpu(drop_hdr->count), mp);
+		if (xfs_attr3_leaf_order(save_blk->bp, &savehdr,
+					 drop_blk->bp, &drophdr)) {
+			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+						save_leaf, &savehdr, 0,
+						drophdr.count, mp);
 		} else {
-			xfs_attr_leaf_moveents(drop_leaf, 0, save_leaf,
-				  be16_to_cpu(save_hdr->count),
-				  be16_to_cpu(drop_hdr->count), mp);
+			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+						save_leaf, &savehdr,
+						savehdr.count, drophdr.count, mp);
 		}
 	} else {
 		/*
 		 * Destination has holes, so we make a temporary copy
 		 * of the leaf and add them both to that.
 		 */
-		tmpbuffer = kmem_alloc(state->blocksize, KM_SLEEP);
-		ASSERT(tmpbuffer != NULL);
-		memset(tmpbuffer, 0, state->blocksize);
-		tmp_leaf = (xfs_attr_leafblock_t *)tmpbuffer;
-		tmp_hdr = &tmp_leaf->hdr;
-		tmp_hdr->info = save_hdr->info;	/* struct copy */
-		tmp_hdr->count = 0;
-		tmp_hdr->firstused = cpu_to_be16(state->blocksize);
-		if (!tmp_hdr->firstused) {
-			tmp_hdr->firstused = cpu_to_be16(
-				state->blocksize - XFS_ATTR_LEAF_NAME_ALIGN);
-		}
-		tmp_hdr->usedbytes = 0;
-		if (xfs_attr_leaf_order(save_blk->bp, drop_blk->bp)) {
-			xfs_attr_leaf_moveents(drop_leaf, 0, tmp_leaf, 0,
-				be16_to_cpu(drop_hdr->count), mp);
-			xfs_attr_leaf_moveents(save_leaf, 0, tmp_leaf,
-				  be16_to_cpu(tmp_leaf->hdr.count),
-				  be16_to_cpu(save_hdr->count), mp);
+		struct xfs_attr_leafblock *tmp_leaf;
+		struct xfs_attr3_icleaf_hdr tmphdr;
+
+		tmp_leaf = kmem_alloc(state->blocksize, KM_SLEEP);
+		memset(tmp_leaf, 0, state->blocksize);
+		memset(&tmphdr, 0, sizeof(tmphdr));
+
+		tmphdr.magic = savehdr.magic;
+		tmphdr.forw = savehdr.forw;
+		tmphdr.back = savehdr.back;
+		tmphdr.firstused = state->blocksize;
+		if (xfs_attr3_leaf_order(save_blk->bp, &savehdr,
+					 drop_blk->bp, &drophdr)) {
+			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+						tmp_leaf, &tmphdr, 0,
+						drophdr.count, mp);
+			xfs_attr3_leaf_moveents(save_leaf, &savehdr, 0,
+						tmp_leaf, &tmphdr, tmphdr.count,
+						savehdr.count, mp);
 		} else {
-			xfs_attr_leaf_moveents(save_leaf, 0, tmp_leaf, 0,
-				be16_to_cpu(save_hdr->count), mp);
-			xfs_attr_leaf_moveents(drop_leaf, 0, tmp_leaf,
-				be16_to_cpu(tmp_leaf->hdr.count),
-				be16_to_cpu(drop_hdr->count), mp);
+			xfs_attr3_leaf_moveents(save_leaf, &savehdr, 0,
+						tmp_leaf, &tmphdr, 0,
+						savehdr.count, mp);
+			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+						tmp_leaf, &tmphdr, tmphdr.count,
+						drophdr.count, mp);
 		}
-		memcpy((char *)save_leaf, (char *)tmp_leaf, state->blocksize);
-		kmem_free(tmpbuffer);
+		memcpy(save_leaf, tmp_leaf, state->blocksize);
+		savehdr = tmphdr; /* struct copy */
+		kmem_free(tmp_leaf);
 	}
 
+	xfs_attr3_leaf_hdr_to_disk(save_leaf, &savehdr);
 	xfs_trans_log_buf(state->args->trans, save_blk->bp, 0,
 					   state->blocksize - 1);
 
 	/*
 	 * Copy out last hashval in each block for B-tree code.
 	 */
-	save_blk->hashval = be32_to_cpu(
-		save_leaf->entries[be16_to_cpu(save_leaf->hdr.count)-1].hashval);
+	entry = xfs_attr3_leaf_entryp(save_leaf);
+	save_blk->hashval = be32_to_cpu(entry[savehdr.count - 1].hashval);
 }
 
 /*========================================================================
@@ -2013,31 +2229,33 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
  * Don't change the args->value unless we find the attribute.
  */
 int
-xfs_attr_leaf_lookup_int(
-	struct xfs_buf	*bp,
-	xfs_da_args_t	*args)
+xfs_attr3_leaf_lookup_int(
+	struct xfs_buf		*bp,
+	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_local_t *name_loc;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	int probe, span;
-	xfs_dahash_t hashval;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_entry *entries;
+	struct xfs_attr_leaf_name_local *name_loc;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	xfs_dahash_t		hashval;
+	int			probe;
+	int			span;
 
 	trace_xfs_attr_leaf_lookup(args);
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT(be16_to_cpu(leaf->hdr.count)
-					< (XFS_LBSIZE(args->dp->i_mount)/8));
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	entries = xfs_attr3_leaf_entryp(leaf);
+	ASSERT(ichdr.count < XFS_LBSIZE(args->dp->i_mount) / 8);
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
 	 */
 	hashval = args->hashval;
-	probe = span = be16_to_cpu(leaf->hdr.count) / 2;
-	for (entry = &leaf->entries[probe]; span > 4;
-		   entry = &leaf->entries[probe]) {
+	probe = span = ichdr.count / 2;
+	for (entry = &entries[probe]; span > 4; entry = &entries[probe]) {
 		span /= 2;
 		if (be32_to_cpu(entry->hashval) < hashval)
 			probe += span;
@@ -2046,35 +2264,31 @@ xfs_attr_leaf_lookup_int(
 		else
 			break;
 	}
-	ASSERT((probe >= 0) &&
-	       (!leaf->hdr.count
-	       || (probe < be16_to_cpu(leaf->hdr.count))));
-	ASSERT((span <= 4) || (be32_to_cpu(entry->hashval) == hashval));
+	ASSERT(probe >= 0 && (!ichdr.count || probe < ichdr.count));
+	ASSERT(span <= 4 || be32_to_cpu(entry->hashval) == hashval);
 
 	/*
 	 * Since we may have duplicate hashval's, find the first matching
 	 * hashval in the leaf.
 	 */
-	while ((probe > 0) && (be32_to_cpu(entry->hashval) >= hashval)) {
+	while (probe > 0 && be32_to_cpu(entry->hashval) >= hashval) {
 		entry--;
 		probe--;
 	}
-	while ((probe < be16_to_cpu(leaf->hdr.count)) &&
-	       (be32_to_cpu(entry->hashval) < hashval)) {
+	while (probe < ichdr.count &&
+	       be32_to_cpu(entry->hashval) < hashval) {
 		entry++;
 		probe++;
 	}
-	if ((probe == be16_to_cpu(leaf->hdr.count)) ||
-	    (be32_to_cpu(entry->hashval) != hashval)) {
+	if (probe == ichdr.count || be32_to_cpu(entry->hashval) != hashval) {
 		args->index = probe;
-		return(XFS_ERROR(ENOATTR));
+		return XFS_ERROR(ENOATTR);
 	}
 
 	/*
 	 * Duplicate keys may be present, so search all of them for a match.
 	 */
-	for (  ; (probe < be16_to_cpu(leaf->hdr.count)) &&
-			(be32_to_cpu(entry->hashval) == hashval);
+	for (; probe < ichdr.count && (be32_to_cpu(entry->hashval) == hashval);
 			entry++, probe++) {
 /*
  * GROT: Add code to remove incomplete entries.
@@ -2088,21 +2302,22 @@ xfs_attr_leaf_lookup_int(
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
-			name_loc = xfs_attr_leaf_name_local(leaf, probe);
+			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
 			if (name_loc->namelen != args->namelen)
 				continue;
-			if (memcmp(args->name, (char *)name_loc->nameval, args->namelen) != 0)
+			if (memcmp(args->name, name_loc->nameval,
+							args->namelen) != 0)
 				continue;
 			if (!xfs_attr_namesp_match(args->flags, entry->flags))
 				continue;
 			args->index = probe;
-			return(XFS_ERROR(EEXIST));
+			return XFS_ERROR(EEXIST);
 		} else {
-			name_rmt = xfs_attr_leaf_name_remote(leaf, probe);
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
 			if (name_rmt->namelen != args->namelen)
 				continue;
-			if (memcmp(args->name, (char *)name_rmt->name,
-					     args->namelen) != 0)
+			if (memcmp(args->name, name_rmt->name,
+							args->namelen) != 0)
 				continue;
 			if (!xfs_attr_namesp_match(args->flags, entry->flags))
 				continue;
@@ -2110,11 +2325,11 @@ xfs_attr_leaf_lookup_int(
 			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
 			args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount,
 						   be32_to_cpu(name_rmt->valuelen));
-			return(XFS_ERROR(EEXIST));
+			return XFS_ERROR(EEXIST);
 		}
 	}
 	args->index = probe;
-	return(XFS_ERROR(ENOATTR));
+	return XFS_ERROR(ENOATTR);
 }
 
 /*
@@ -2122,40 +2337,40 @@ xfs_attr_leaf_lookup_int(
  * list structure.
  */
 int
-xfs_attr_leaf_getvalue(
-	struct xfs_buf	*bp,
-	xfs_da_args_t	*args)
+xfs_attr3_leaf_getvalue(
+	struct xfs_buf		*bp,
+	struct xfs_da_args	*args)
 {
-	int valuelen;
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_local_t *name_loc;
-	xfs_attr_leaf_name_remote_t *name_rmt;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_local *name_loc;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	int			valuelen;
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT(be16_to_cpu(leaf->hdr.count)
-					< (XFS_LBSIZE(args->dp->i_mount)/8));
-	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	ASSERT(ichdr.count < XFS_LBSIZE(args->dp->i_mount) / 8);
+	ASSERT(args->index < ichdr.count);
 
-	entry = &leaf->entries[args->index];
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
+		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
 		ASSERT(name_loc->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
 		valuelen = be16_to_cpu(name_loc->valuelen);
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = valuelen;
-			return(0);
+			return 0;
 		}
 		if (args->valuelen < valuelen) {
 			args->valuelen = valuelen;
-			return(XFS_ERROR(ERANGE));
+			return XFS_ERROR(ERANGE);
 		}
 		args->valuelen = valuelen;
 		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
 	} else {
-		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
 		ASSERT(name_rmt->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
 		valuelen = be32_to_cpu(name_rmt->valuelen);
@@ -2163,15 +2378,15 @@ xfs_attr_leaf_getvalue(
 		args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount, valuelen);
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = valuelen;
-			return(0);
+			return 0;
 		}
 		if (args->valuelen < valuelen) {
 			args->valuelen = valuelen;
-			return(XFS_ERROR(ERANGE));
+			return XFS_ERROR(ERANGE);
 		}
 		args->valuelen = valuelen;
 	}
-	return(0);
+	return 0;
 }
 
 /*========================================================================
@@ -2184,13 +2399,21 @@ xfs_attr_leaf_getvalue(
  */
 /*ARGSUSED*/
 STATIC void
-xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
-			xfs_attr_leafblock_t *leaf_d, int start_d,
-			int count, xfs_mount_t *mp)
+xfs_attr3_leaf_moveents(
+	struct xfs_attr_leafblock	*leaf_s,
+	struct xfs_attr3_icleaf_hdr	*ichdr_s,
+	int				start_s,
+	struct xfs_attr_leafblock	*leaf_d,
+	struct xfs_attr3_icleaf_hdr	*ichdr_d,
+	int				start_d,
+	int				count,
+	struct xfs_mount		*mp)
 {
-	xfs_attr_leaf_hdr_t *hdr_s, *hdr_d;
-	xfs_attr_leaf_entry_t *entry_s, *entry_d;
-	int desti, tmp, i;
+	struct xfs_attr_leaf_entry	*entry_s;
+	struct xfs_attr_leaf_entry	*entry_d;
+	int				desti;
+	int				tmp;
+	int				i;
 
 	/*
 	 * Check for nothing to do.
@@ -2201,45 +2424,41 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
 	/*
 	 * Set up environment.
 	 */
-	ASSERT(leaf_s->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	ASSERT(leaf_d->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	hdr_s = &leaf_s->hdr;
-	hdr_d = &leaf_d->hdr;
-	ASSERT((be16_to_cpu(hdr_s->count) > 0) &&
-	       (be16_to_cpu(hdr_s->count) < (XFS_LBSIZE(mp)/8)));
-	ASSERT(be16_to_cpu(hdr_s->firstused) >=
-		((be16_to_cpu(hdr_s->count)
-					* sizeof(*entry_s))+sizeof(*hdr_s)));
-	ASSERT(be16_to_cpu(hdr_d->count) < (XFS_LBSIZE(mp)/8));
-	ASSERT(be16_to_cpu(hdr_d->firstused) >=
-		((be16_to_cpu(hdr_d->count)
-					* sizeof(*entry_d))+sizeof(*hdr_d)));
-
-	ASSERT(start_s < be16_to_cpu(hdr_s->count));
-	ASSERT(start_d <= be16_to_cpu(hdr_d->count));
-	ASSERT(count <= be16_to_cpu(hdr_s->count));
+	ASSERT(ichdr_s->magic == XFS_ATTR_LEAF_MAGIC ||
+	       ichdr_s->magic == XFS_ATTR3_LEAF_MAGIC);
+	ASSERT(ichdr_s->magic == ichdr_d->magic);
+	ASSERT(ichdr_s->count > 0 && ichdr_s->count < XFS_LBSIZE(mp) / 8);
+	ASSERT(ichdr_s->firstused >= (ichdr_s->count * sizeof(*entry_s))
+					+ xfs_attr3_leaf_hdr_size(leaf_s));
+	ASSERT(ichdr_d->count < XFS_LBSIZE(mp) / 8);
+	ASSERT(ichdr_d->firstused >= (ichdr_d->count * sizeof(*entry_d))
+					+ xfs_attr3_leaf_hdr_size(leaf_d));
+
+	ASSERT(start_s < ichdr_s->count);
+	ASSERT(start_d <= ichdr_d->count);
+	ASSERT(count <= ichdr_s->count);
+
 
 	/*
 	 * Move the entries in the destination leaf up to make a hole?
 	 */
-	if (start_d < be16_to_cpu(hdr_d->count)) {
-		tmp  = be16_to_cpu(hdr_d->count) - start_d;
+	if (start_d < ichdr_d->count) {
+		tmp  = ichdr_d->count - start_d;
 		tmp *= sizeof(xfs_attr_leaf_entry_t);
-		entry_s = &leaf_d->entries[start_d];
-		entry_d = &leaf_d->entries[start_d + count];
-		memmove((char *)entry_d, (char *)entry_s, tmp);
+		entry_s = &xfs_attr3_leaf_entryp(leaf_d)[start_d];
+		entry_d = &xfs_attr3_leaf_entryp(leaf_d)[start_d + count];
+		memmove(entry_d, entry_s, tmp);
 	}
 
 	/*
 	 * Copy all entry's in the same (sorted) order,
 	 * but allocate attribute info packed and in sequence.
 	 */
-	entry_s = &leaf_s->entries[start_s];
-	entry_d = &leaf_d->entries[start_d];
+	entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
+	entry_d = &xfs_attr3_leaf_entryp(leaf_d)[start_d];
 	desti = start_d;
 	for (i = 0; i < count; entry_s++, entry_d++, desti++, i++) {
-		ASSERT(be16_to_cpu(entry_s->nameidx)
-				>= be16_to_cpu(hdr_s->firstused));
+		ASSERT(be16_to_cpu(entry_s->nameidx) >= ichdr_s->firstused);
 		tmp = xfs_attr_leaf_entsize(leaf_s, start_s + i);
 #ifdef GROT
 		/*
@@ -2248,36 +2467,34 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
 		 * off for 6.2, should be revisited later.
 		 */
 		if (entry_s->flags & XFS_ATTR_INCOMPLETE) { /* skip partials? */
-			memset(xfs_attr_leaf_name(leaf_s, start_s + i), 0, tmp);
-			be16_add_cpu(&hdr_s->usedbytes, -tmp);
-			be16_add_cpu(&hdr_s->count, -1);
+			memset(xfs_attr3_leaf_name(leaf_s, start_s + i), 0, tmp);
+			ichdr_s->usedbytes -= tmp;
+			ichdr_s->count -= 1;
 			entry_d--;	/* to compensate for ++ in loop hdr */
 			desti--;
 			if ((start_s + i) < offset)
 				result++;	/* insertion index adjustment */
 		} else {
 #endif /* GROT */
-			be16_add_cpu(&hdr_d->firstused, -tmp);
+			ichdr_d->firstused -= tmp;
 			/* both on-disk, don't endian flip twice */
 			entry_d->hashval = entry_s->hashval;
-			/* both on-disk, don't endian flip twice */
-			entry_d->nameidx = hdr_d->firstused;
+			entry_d->nameidx = cpu_to_be16(ichdr_d->firstused);
 			entry_d->flags = entry_s->flags;
 			ASSERT(be16_to_cpu(entry_d->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
-			memmove(xfs_attr_leaf_name(leaf_d, desti),
-				xfs_attr_leaf_name(leaf_s, start_s + i), tmp);
+			memmove(xfs_attr3_leaf_name(leaf_d, desti),
+				xfs_attr3_leaf_name(leaf_s, start_s + i), tmp);
 			ASSERT(be16_to_cpu(entry_s->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
-			memset(xfs_attr_leaf_name(leaf_s, start_s + i), 0, tmp);
-			be16_add_cpu(&hdr_s->usedbytes, -tmp);
-			be16_add_cpu(&hdr_d->usedbytes, tmp);
-			be16_add_cpu(&hdr_s->count, -1);
-			be16_add_cpu(&hdr_d->count, 1);
-			tmp = be16_to_cpu(hdr_d->count)
-						* sizeof(xfs_attr_leaf_entry_t)
-						+ sizeof(xfs_attr_leaf_hdr_t);
-			ASSERT(be16_to_cpu(hdr_d->firstused) >= tmp);
+			memset(xfs_attr3_leaf_name(leaf_s, start_s + i), 0, tmp);
+			ichdr_s->usedbytes -= tmp;
+			ichdr_d->usedbytes += tmp;
+			ichdr_s->count -= 1;
+			ichdr_d->count += 1;
+			tmp = ichdr_d->count * sizeof(xfs_attr_leaf_entry_t)
+					+ xfs_attr3_leaf_hdr_size(leaf_d);
+			ASSERT(ichdr_d->firstused >= tmp);
 #ifdef GROT
 		}
 #endif /* GROT */
@@ -2286,71 +2503,40 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
 	/*
 	 * Zero out the entries we just copied.
 	 */
-	if (start_s == be16_to_cpu(hdr_s->count)) {
+	if (start_s == ichdr_s->count) {
 		tmp = count * sizeof(xfs_attr_leaf_entry_t);
-		entry_s = &leaf_s->entries[start_s];
+		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
 		ASSERT(((char *)entry_s + tmp) <=
 		       ((char *)leaf_s + XFS_LBSIZE(mp)));
-		memset((char *)entry_s, 0, tmp);
+		memset(entry_s, 0, tmp);
 	} else {
 		/*
 		 * Move the remaining entries down to fill the hole,
 		 * then zero the entries at the top.
 		 */
-		tmp  = be16_to_cpu(hdr_s->count) - count;
-		tmp *= sizeof(xfs_attr_leaf_entry_t);
-		entry_s = &leaf_s->entries[start_s + count];
-		entry_d = &leaf_s->entries[start_s];
-		memmove((char *)entry_d, (char *)entry_s, tmp);
+		tmp  = (ichdr_s->count - count) - sizeof(xfs_attr_leaf_entry_t);
+		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s + count];
+		entry_d = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
+		memmove(entry_d, entry_s, tmp);
 
 		tmp = count * sizeof(xfs_attr_leaf_entry_t);
-		entry_s = &leaf_s->entries[be16_to_cpu(hdr_s->count)];
+		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[ichdr_s->count];
 		ASSERT(((char *)entry_s + tmp) <=
 		       ((char *)leaf_s + XFS_LBSIZE(mp)));
-		memset((char *)entry_s, 0, tmp);
+		memset(entry_s, 0, tmp);
 	}
 
 	/*
 	 * Fill in the freemap information
 	 */
-	hdr_d->freemap[0].base = cpu_to_be16(sizeof(xfs_attr_leaf_hdr_t));
-	be16_add_cpu(&hdr_d->freemap[0].base, be16_to_cpu(hdr_d->count) *
-			sizeof(xfs_attr_leaf_entry_t));
-	hdr_d->freemap[0].size = cpu_to_be16(be16_to_cpu(hdr_d->firstused)
-			      - be16_to_cpu(hdr_d->freemap[0].base));
-	hdr_d->freemap[1].base = 0;
-	hdr_d->freemap[2].base = 0;
-	hdr_d->freemap[1].size = 0;
-	hdr_d->freemap[2].size = 0;
-	hdr_s->holes = 1;	/* leaf may not be compact */
-}
-
-/*
- * Compare two leaf blocks "order".
- * Return 0 unless leaf2 should go before leaf1.
- */
-int
-xfs_attr_leaf_order(
-	struct xfs_buf	*leaf1_bp,
-	struct xfs_buf	*leaf2_bp)
-{
-	xfs_attr_leafblock_t *leaf1, *leaf2;
-
-	leaf1 = leaf1_bp->b_addr;
-	leaf2 = leaf2_bp->b_addr;
-	ASSERT((leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) &&
-	       (leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)));
-	if ((be16_to_cpu(leaf1->hdr.count) > 0) &&
-	    (be16_to_cpu(leaf2->hdr.count) > 0) &&
-	    ((be32_to_cpu(leaf2->entries[0].hashval) <
-	      be32_to_cpu(leaf1->entries[0].hashval)) ||
-	     (be32_to_cpu(leaf2->entries[
-			be16_to_cpu(leaf2->hdr.count)-1].hashval) <
-	      be32_to_cpu(leaf1->entries[
-			be16_to_cpu(leaf1->hdr.count)-1].hashval)))) {
-		return(1);
-	}
-	return(0);
+	ichdr_d->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_d);
+	ichdr_d->freemap[0].base += ichdr_d->count * sizeof(xfs_attr_leaf_entry_t);
+	ichdr_d->freemap[0].size = ichdr_d->firstused - ichdr_d->freemap[0].base;
+	ichdr_d->freemap[1].base = 0;
+	ichdr_d->freemap[2].base = 0;
+	ichdr_d->freemap[1].size = 0;
+	ichdr_d->freemap[2].size = 0;
+	ichdr_s->holes = 1;	/* leaf may not be compact */
 }
 
 /*
@@ -2361,15 +2547,16 @@ xfs_attr_leaf_lasthash(
 	struct xfs_buf	*bp,
 	int		*count)
 {
-	xfs_attr_leafblock_t *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entries;
 
-	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, bp->b_addr);
+	entries = xfs_attr3_leaf_entryp(bp->b_addr);
 	if (count)
-		*count = be16_to_cpu(leaf->hdr.count);
-	if (!leaf->hdr.count)
-		return(0);
-	return be32_to_cpu(leaf->entries[be16_to_cpu(leaf->hdr.count)-1].hashval);
+		*count = ichdr.count;
+	if (!ichdr.count)
+		return 0;
+	return be32_to_cpu(entries[ichdr.count - 1].hashval);
 }
 
 /*
@@ -2379,20 +2566,21 @@ xfs_attr_leaf_lasthash(
 STATIC int
 xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
 {
+	struct xfs_attr_leaf_entry *entries;
 	xfs_attr_leaf_name_local_t *name_loc;
 	xfs_attr_leaf_name_remote_t *name_rmt;
 	int size;
 
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	if (leaf->entries[index].flags & XFS_ATTR_LOCAL) {
-		name_loc = xfs_attr_leaf_name_local(leaf, index);
+	entries = xfs_attr3_leaf_entryp(leaf);
+	if (entries[index].flags & XFS_ATTR_LOCAL) {
+		name_loc = xfs_attr3_leaf_name_local(leaf, index);
 		size = xfs_attr_leaf_entsize_local(name_loc->namelen,
 						   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = xfs_attr_leaf_name_remote(leaf, index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, index);
 		size = xfs_attr_leaf_entsize_remote(name_rmt->namelen);
 	}
-	return(size);
+	return size;
 }
 
 /*
@@ -2417,35 +2605,40 @@ xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize, int *local)
 			*local = 0;
 		}
 	}
-	return(size);
+	return size;
 }
 
 /*
  * Copy out attribute list entries for attr_list(), for leaf attribute lists.
  */
 int
-xfs_attr_leaf_list_int(
-	struct xfs_buf		*bp,
-	xfs_attr_list_context_t	*context)
+xfs_attr3_leaf_list_int(
+	struct xfs_buf			*bp,
+	struct xfs_attr_list_context	*context)
 {
-	attrlist_cursor_kern_t *cursor;
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	int retval, i;
+	struct attrlist_cursor_kern	*cursor;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_attr_leaf_entry	*entries;
+	struct xfs_attr_leaf_entry	*entry;
+	int				retval;
+	int				i;
+
+	trace_xfs_attr_list_leaf(context);
 
-	ASSERT(bp != NULL);
 	leaf = bp->b_addr;
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	entries = xfs_attr3_leaf_entryp(leaf);
+
 	cursor = context->cursor;
 	cursor->initted = 1;
 
-	trace_xfs_attr_list_leaf(context);
-
 	/*
 	 * Re-find our place in the leaf block if this is a new syscall.
 	 */
 	if (context->resynch) {
-		entry = &leaf->entries[0];
-		for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
+		entry = &entries[0];
+		for (i = 0; i < ichdr.count; entry++, i++) {
 			if (be32_to_cpu(entry->hashval) == cursor->hashval) {
 				if (cursor->offset == context->dupcnt) {
 					context->dupcnt = 0;
@@ -2458,12 +2651,12 @@ xfs_attr_leaf_list_int(
 				break;
 			}
 		}
-		if (i == be16_to_cpu(leaf->hdr.count)) {
+		if (i == ichdr.count) {
 			trace_xfs_attr_list_notfound(context);
-			return(0);
+			return 0;
 		}
 	} else {
-		entry = &leaf->entries[0];
+		entry = &entries[0];
 		i = 0;
 	}
 	context->resynch = 0;
@@ -2472,7 +2665,7 @@ xfs_attr_leaf_list_int(
 	 * We have found our place, start copying out the new attributes.
 	 */
 	retval = 0;
-	for (  ; (i < be16_to_cpu(leaf->hdr.count)); entry++, i++) {
+	for (; i < ichdr.count; entry++, i++) {
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
 			cursor->hashval = be32_to_cpu(entry->hashval);
 			cursor->offset = 0;
@@ -2483,7 +2676,7 @@ xfs_attr_leaf_list_int(
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			xfs_attr_leaf_name_local_t *name_loc =
-				xfs_attr_leaf_name_local(leaf, i);
+				xfs_attr3_leaf_name_local(leaf, i);
 
 			retval = context->put_listent(context,
 						entry->flags,
@@ -2495,7 +2688,7 @@ xfs_attr_leaf_list_int(
 				return retval;
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt =
-				xfs_attr_leaf_name_remote(leaf, i);
+				xfs_attr3_leaf_name_remote(leaf, i);
 
 			int valuelen = be32_to_cpu(name_rmt->valuelen);
 
@@ -2535,7 +2728,7 @@ xfs_attr_leaf_list_int(
 		cursor->offset++;
 	}
 	trace_xfs_attr_list_leaf_end(context);
-	return(retval);
+	return retval;
 }
 
 
@@ -2547,14 +2740,16 @@ xfs_attr_leaf_list_int(
  * Clear the INCOMPLETE flag on an entry in a leaf block.
  */
 int
-xfs_attr_leaf_clearflag(xfs_da_args_t *args)
+xfs_attr3_leaf_clearflag(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_buf		*bp;
+	int			error;
 #ifdef DEBUG
+	struct xfs_attr3_icleaf_hdr ichdr;
 	xfs_attr_leaf_name_local_t *name_loc;
 	int namelen;
 	char *name;
@@ -2564,23 +2759,25 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
 		return(error);
 
 	leaf = bp->b_addr;
-	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
-	ASSERT(args->index >= 0);
-	entry = &leaf->entries[ args->index ];
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 	ASSERT(entry->flags & XFS_ATTR_INCOMPLETE);
 
 #ifdef DEBUG
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	ASSERT(args->index < ichdr.count);
+	ASSERT(args->index >= 0);
+
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
+		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
 		namelen = name_loc->namelen;
 		name = (char *)name_loc->nameval;
 	} else {
-		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
 		namelen = name_rmt->namelen;
 		name = (char *)name_rmt->name;
 	}
@@ -2595,7 +2792,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 
 	if (args->rmtblkno) {
 		ASSERT((entry->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
 		xfs_trans_log_buf(args->trans, bp,
@@ -2612,34 +2809,41 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
  * Set the INCOMPLETE flag on an entry in a leaf block.
  */
 int
-xfs_attr_leaf_setflag(xfs_da_args_t *args)
+xfs_attr3_leaf_setflag(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	struct xfs_buf *bp;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_buf		*bp;
 	int error;
+#ifdef DEBUG
+	struct xfs_attr3_icleaf_hdr ichdr;
+#endif
 
 	trace_xfs_attr_leaf_setflag(args);
 
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
 		return(error);
 
 	leaf = bp->b_addr;
-	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
+#ifdef DEBUG
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	ASSERT(args->index < ichdr.count);
 	ASSERT(args->index >= 0);
-	entry = &leaf->entries[ args->index ];
+#endif
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
 	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	if ((entry->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_trans_log_buf(args->trans, bp,
@@ -2660,14 +2864,20 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
  * Note that they could be in different blocks, or in the same block.
  */
 int
-xfs_attr_leaf_flipflags(xfs_da_args_t *args)
+xfs_attr3_leaf_flipflags(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_leafblock_t *leaf1, *leaf2;
-	xfs_attr_leaf_entry_t *entry1, *entry2;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	struct xfs_buf *bp1, *bp2;
+	struct xfs_attr_leafblock *leaf1;
+	struct xfs_attr_leafblock *leaf2;
+	struct xfs_attr_leaf_entry *entry1;
+	struct xfs_attr_leaf_entry *entry2;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_buf		*bp1;
+	struct xfs_buf		*bp2;
 	int error;
 #ifdef DEBUG
+	struct xfs_attr3_icleaf_hdr ichdr1;
+	struct xfs_attr3_icleaf_hdr ichdr2;
 	xfs_attr_leaf_name_local_t *name_loc;
 	int namelen1, namelen2;
 	char *name1, *name2;
@@ -2678,7 +2888,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
 	if (error)
 		return error;
 
@@ -2686,7 +2896,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	 * Read the block containing the "new" attr, if it is different
 	 */
 	if (args->blkno2 != args->blkno) {
-		error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno2,
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
 					   -1, &bp2);
 		if (error)
 			return error;
@@ -2695,31 +2905,35 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	}
 
 	leaf1 = bp1->b_addr;
-	ASSERT(args->index < be16_to_cpu(leaf1->hdr.count));
-	ASSERT(args->index >= 0);
-	entry1 = &leaf1->entries[ args->index ];
+	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
 
 	leaf2 = bp2->b_addr;
-	ASSERT(args->index2 < be16_to_cpu(leaf2->hdr.count));
-	ASSERT(args->index2 >= 0);
-	entry2 = &leaf2->entries[ args->index2 ];
+	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
 
 #ifdef DEBUG
+	xfs_attr3_leaf_hdr_from_disk(&ichdr1, leaf1);
+	ASSERT(args->index < ichdr1.count);
+	ASSERT(args->index >= 0);
+
+	xfs_attr3_leaf_hdr_from_disk(&ichdr2, leaf2);
+	ASSERT(args->index2 < ichdr2.count);
+	ASSERT(args->index2 >= 0);
+
 	if (entry1->flags & XFS_ATTR_LOCAL) {
-		name_loc = xfs_attr_leaf_name_local(leaf1, args->index);
+		name_loc = xfs_attr3_leaf_name_local(leaf1, args->index);
 		namelen1 = name_loc->namelen;
 		name1 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf1, args->index);
 		namelen1 = name_rmt->namelen;
 		name1 = (char *)name_rmt->name;
 	}
 	if (entry2->flags & XFS_ATTR_LOCAL) {
-		name_loc = xfs_attr_leaf_name_local(leaf2, args->index2);
+		name_loc = xfs_attr3_leaf_name_local(leaf2, args->index2);
 		namelen2 = name_loc->namelen;
 		name2 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf2, args->index2);
 		namelen2 = name_rmt->namelen;
 		name2 = (char *)name_rmt->name;
 	}
@@ -2736,7 +2950,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 			  XFS_DA_LOGRANGE(leaf1, entry1, sizeof(*entry1)));
 	if (args->rmtblkno) {
 		ASSERT((entry1->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf1, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
 		xfs_trans_log_buf(args->trans, bp1,
@@ -2747,7 +2961,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	xfs_trans_log_buf(args->trans, bp2,
 			  XFS_DA_LOGRANGE(leaf2, entry2, sizeof(*entry2)));
 	if ((entry2->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf2, args->index2);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_trans_log_buf(args->trans, bp2,
@@ -2759,7 +2973,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	 */
 	error = xfs_trans_roll(&args->trans, args->dp);
 
-	return(error);
+	return error;
 }
 
 /*========================================================================
@@ -2771,12 +2985,14 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
  * We're doing a depth-first traversal in order to invalidate everything.
  */
 int
-xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
+xfs_attr3_root_inactive(
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp)
 {
-	xfs_da_blkinfo_t *info;
-	xfs_daddr_t blkno;
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_da_blkinfo	*info;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		blkno;
+	int			error;
 
 	/*
 	 * Read block 0 to see what we have to work with.
@@ -2786,38 +3002,44 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	 */
 	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
 	if (error)
-		return(error);
-	blkno = XFS_BUF_ADDR(bp);
+		return error;
+	blkno = bp->b_bn;
 
 	/*
 	 * Invalidate the tree, even if the "tree" is only a single leaf block.
 	 * This is a depth-first traversal!
 	 */
 	info = bp->b_addr;
-	if (info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
-		error = xfs_attr_node_inactive(trans, dp, bp, 1);
-	} else if (info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) {
-		error = xfs_attr_leaf_inactive(trans, dp, bp);
-	} else {
+	switch (info->magic) {
+	case cpu_to_be16(XFS_DA_NODE_MAGIC):
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
+		break;
+	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
+	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+		error = xfs_attr3_leaf_inactive(trans, dp, bp);
+		break;
+	default:
 		error = XFS_ERROR(EIO);
 		xfs_trans_brelse(*trans, bp);
+		break;
 	}
 	if (error)
-		return(error);
+		return error;
 
 	/*
 	 * Invalidate the incore copy of the root block.
 	 */
 	error = xfs_da_get_buf(*trans, dp, 0, blkno, &bp, XFS_ATTR_FORK);
 	if (error)
-		return(error);
+		return error;
 	xfs_trans_binval(*trans, bp);	/* remove from cache */
 	/*
 	 * Commit the invalidate and start the next transaction.
 	 */
 	error = xfs_trans_roll(trans, dp);
 
-	return (error);
+	return error;
 }
 
 /*
@@ -2825,7 +3047,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
  * We're doing a depth-first traversal in order to invalidate everything.
  */
 STATIC int
-xfs_attr_node_inactive(
+xfs_attr3_node_inactive(
 	struct xfs_trans **trans,
 	struct xfs_inode *dp,
 	struct xfs_buf	*bp,
@@ -2835,25 +3057,25 @@ xfs_attr_node_inactive(
 	xfs_da_intnode_t *node;
 	xfs_dablk_t child_fsb;
 	xfs_daddr_t parent_blkno, child_blkno;
-	int error, count, i;
+	int error, i;
 	struct xfs_buf *child_bp;
 	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr ichdr;
 
 	/*
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-		return(XFS_ERROR(EIO));
+		return XFS_ERROR(EIO);
 	}
 
 	node = bp->b_addr;
-	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	parent_blkno = XFS_BUF_ADDR(bp);	/* save for re-read later */
-	count = be16_to_cpu(node->hdr.count);
-	if (!count) {
+	xfs_da3_node_hdr_from_disk(&ichdr, node);
+	parent_blkno = bp->b_bn;
+	if (!ichdr.count) {
 		xfs_trans_brelse(*trans, bp);
-		return(0);
+		return 0;
 	}
 	btree = xfs_da3_node_tree_p(node);
 	child_fsb = be32_to_cpu(btree[0].before);
@@ -2864,7 +3086,7 @@ xfs_attr_node_inactive(
 	 * over the leaves removing all of them.  If this is higher up
 	 * in the tree, recurse downward.
 	 */
-	for (i = 0; i < count; i++) {
+	for (i = 0; i < ichdr.count; i++) {
 		/*
 		 * Read the subsidiary block to see what we have to work with.
 		 * Don't do this in a transaction.  This is a depth-first
@@ -2883,18 +3105,24 @@ xfs_attr_node_inactive(
 			 * Invalidate the subtree, however we have to.
 			 */
 			info = child_bp->b_addr;
-			if (info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
-				error = xfs_attr_node_inactive(trans, dp,
-						child_bp, level+1);
-			} else if (info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)) {
-				error = xfs_attr_leaf_inactive(trans, dp,
-						child_bp);
-			} else {
+			switch (info->magic) {
+			case cpu_to_be16(XFS_DA_NODE_MAGIC):
+			case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+				error = xfs_attr3_node_inactive(trans, dp,
+							child_bp, level + 1);
+				break;
+			case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
+			case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+				error = xfs_attr3_leaf_inactive(trans, dp,
+							child_bp);
+				break;
+			default:
 				error = XFS_ERROR(EIO);
 				xfs_trans_brelse(*trans, child_bp);
+				break;
 			}
 			if (error)
-				return(error);
+				return error;
 
 			/*
 			 * Remove the subsidiary block from the cache
@@ -2903,7 +3131,7 @@ xfs_attr_node_inactive(
 			error = xfs_da_get_buf(*trans, dp, 0, child_blkno,
 				&child_bp, XFS_ATTR_FORK);
 			if (error)
-				return(error);
+				return error;
 			xfs_trans_binval(*trans, child_bp);
 		}
 
@@ -2911,12 +3139,12 @@ xfs_attr_node_inactive(
 		 * If we're not done, re-read the parent to get the next
 		 * child block number.
 		 */
-		if ((i+1) < count) {
+		if (i + 1 < ichdr.count) {
 			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
 						 &bp, XFS_ATTR_FORK);
 			if (error)
-				return(error);
-			child_fsb = be32_to_cpu(btree[i+1].before);
+				return error;
+			child_fsb = be32_to_cpu(btree[i + 1].before);
 			xfs_trans_brelse(*trans, bp);
 		}
 		/*
@@ -2924,10 +3152,10 @@ xfs_attr_node_inactive(
 		 */
 		error = xfs_trans_roll(trans, dp);
 		if (error)
-			return (error);
+			return  error;
 	}
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -2937,29 +3165,35 @@ xfs_attr_node_inactive(
  * caught holding something that the logging code wants to flush to disk.
  */
 STATIC int
-xfs_attr_leaf_inactive(
-	struct xfs_trans **trans,
-	struct xfs_inode *dp,
-	struct xfs_buf	*bp)
+xfs_attr3_leaf_inactive(
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
-	xfs_attr_leaf_name_remote_t *name_rmt;
-	xfs_attr_inactive_list_t *list, *lp;
-	int error, count, size, tmp, i;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_attr_inactive_list *list;
+	struct xfs_attr_inactive_list *lp;
+	int			error;
+	int			count;
+	int			size;
+	int			tmp;
+	int			i;
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
 
 	/*
 	 * Count the number of "remote" value extents.
 	 */
 	count = 0;
-	entry = &leaf->entries[0];
-	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
+	entry = xfs_attr3_leaf_entryp(leaf);
+	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (be16_to_cpu(entry->nameidx) &&
 		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr_leaf_name_remote(leaf, i);
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			if (name_rmt->valueblk)
 				count++;
 		}
@@ -2970,24 +3204,24 @@ xfs_attr_leaf_inactive(
 	 */
 	if (count == 0) {
 		xfs_trans_brelse(*trans, bp);
-		return(0);
+		return 0;
 	}
 
 	/*
 	 * Allocate storage for a list of all the "remote" value extents.
 	 */
 	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = (xfs_attr_inactive_list_t *)kmem_alloc(size, KM_SLEEP);
+	list = kmem_alloc(size, KM_SLEEP);
 
 	/*
 	 * Identify each of the "remote" value extents.
 	 */
 	lp = list;
-	entry = &leaf->entries[0];
-	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
+	entry = xfs_attr3_leaf_entryp(leaf);
+	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (be16_to_cpu(entry->nameidx) &&
 		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr_leaf_name_remote(leaf, i);
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			if (name_rmt->valueblk) {
 				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
 				lp->valuelen = XFS_B_TO_FSB(dp->i_mount,
@@ -3003,15 +3237,15 @@ xfs_attr_leaf_inactive(
 	 */
 	error = 0;
 	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr_leaf_freextent(trans, dp,
+		tmp = xfs_attr3_leaf_freextent(trans, dp,
 				lp->valueblk, lp->valuelen);
 
 		if (error == 0)
 			error = tmp;	/* save only the 1st errno */
 	}
 
-	kmem_free((xfs_caddr_t)list);
-	return(error);
+	kmem_free(list);
+	return error;
 }
 
 /*
@@ -3019,14 +3253,20 @@ xfs_attr_leaf_inactive(
  * invalidate any buffers that are incore/in transactions.
  */
 STATIC int
-xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
-				    xfs_dablk_t blkno, int blkcnt)
+xfs_attr3_leaf_freextent(
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		blkno,
+	int			blkcnt)
 {
-	xfs_bmbt_irec_t map;
-	xfs_dablk_t tblkno;
-	int tblkcnt, dblkcnt, nmap, error;
-	xfs_daddr_t dblkno;
-	xfs_buf_t *bp;
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*bp;
+	xfs_dablk_t		tblkno;
+	xfs_daddr_t		dblkno;
+	int			tblkcnt;
+	int			dblkcnt;
+	int			nmap;
+	int			error;
 
 	/*
 	 * Roll through the "value", invalidating the attribute value's
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 77de139..5a4558d 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -89,7 +89,7 @@ typedef struct xfs_attr_leaf_hdr {	/* constant-structure header block */
 
 typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
 	__be32	hashval;		/* hash value of name */
- 	__be16	nameidx;		/* index into buffer of name/value */
+	__be16	nameidx;		/* index into buffer of name/value */
 	__u8	flags;			/* LOCAL/ROOT/SECURE/INCOMPLETE flag */
 	__u8	pad2;			/* unused pad byte */
 } xfs_attr_leaf_entry_t;
@@ -115,6 +115,54 @@ typedef struct xfs_attr_leafblock {
 } xfs_attr_leafblock_t;
 
 /*
+ * CRC enabled leaf structures. Called "version 3" structures to match the
+ * version number of the directory and dablk structures for this feature, and
+ * attr2 is already taken by the variable inode attribute fork size feature.
+ */
+struct xfs_attr3_leaf_hdr {
+	struct xfs_da3_blkinfo	info;
+	__be16			count;
+	__be16			usedbytes;
+	__be16			firstused;
+	__u8			holes;
+	__u8			pad1;
+	struct xfs_attr_leaf_map freemap[XFS_ATTR_LEAF_MAPSIZE];
+};
+
+#define XFS_ATTR3_LEAF_CRC_OFF	(offsetof(struct xfs_attr3_leaf_hdr, info.crc))
+
+struct xfs_attr3_leafblock {
+	struct xfs_attr3_leaf_hdr	hdr;
+	struct xfs_attr_leaf_entry	entries[1];
+
+	/*
+	 * The rest of the block contains the following structures after the
+	 * leaf entries, growing from the bottom up. The variables are never
+	 * referenced, the locations accessed purely from helper functions.
+	 *
+	 * struct xfs_attr_leaf_name_local
+	 * struct xfs_attr_leaf_name_remote
+	 */
+};
+
+/*
+ * incore, neutral version of the attribute leaf header
+ */
+struct xfs_attr3_icleaf_hdr {
+	__uint32_t	forw;
+	__uint32_t	back;
+	__uint16_t	magic;
+	__uint16_t	count;
+	__uint16_t	usedbytes;
+	__uint16_t	firstused;
+	__u8		holes;
+	struct {
+		__uint16_t	base;
+		__uint16_t	size;
+	} freemap[XFS_ATTR_LEAF_MAPSIZE];
+};
+
+/*
  * Flags used in the leaf_entry[i].flags field.
  * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
  * on the system call, they are "or"ed together for various operations.
@@ -147,26 +195,43 @@ typedef struct xfs_attr_leafblock {
  */
 #define	XFS_ATTR_LEAF_NAME_ALIGN	((uint)sizeof(xfs_dablk_t))
 
+static inline int
+xfs_attr3_leaf_hdr_size(struct xfs_attr_leafblock *leafp)
+{
+	if (leafp->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
+		return sizeof(struct xfs_attr3_leaf_hdr);
+	return sizeof(struct xfs_attr_leaf_hdr);
+}
+
+static inline struct xfs_attr_leaf_entry *
+xfs_attr3_leaf_entryp(xfs_attr_leafblock_t *leafp)
+{
+	if (leafp->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
+		return &((struct xfs_attr3_leafblock *)leafp)->entries[0];
+	return &leafp->entries[0];
+}
+
 /*
  * Cast typed pointers for "local" and "remote" name/value structs.
  */
-static inline xfs_attr_leaf_name_remote_t *
-xfs_attr_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
+static inline char *
+xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 {
-	return (xfs_attr_leaf_name_remote_t *)
-		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
-static inline xfs_attr_leaf_name_local_t *
-xfs_attr_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
+static inline xfs_attr_leaf_name_remote_t *
+xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
-	return (xfs_attr_leaf_name_local_t *)
-		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
+	return (xfs_attr_leaf_name_remote_t *)xfs_attr3_leaf_name(leafp, idx);
 }
 
-static inline char *xfs_attr_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
+static inline xfs_attr_leaf_name_local_t *
+xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
 {
-	return &((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
+	return (xfs_attr_leaf_name_local_t *)xfs_attr3_leaf_name(leafp, idx);
 }
 
 /*
@@ -221,37 +286,37 @@ int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
 /*
  * Internal routines when attribute fork size == XFS_LBSIZE(mp).
  */
-int	xfs_attr_leaf_to_node(struct xfs_da_args *args);
-int	xfs_attr_leaf_to_shortform(struct xfs_buf *bp,
+int	xfs_attr3_leaf_to_node(struct xfs_da_args *args);
+int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 				   struct xfs_da_args *args, int forkoff);
-int	xfs_attr_leaf_clearflag(struct xfs_da_args *args);
-int	xfs_attr_leaf_setflag(struct xfs_da_args *args);
-int	xfs_attr_leaf_flipflags(xfs_da_args_t *args);
+int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
 
 /*
  * Routines used for growing the Btree.
  */
-int	xfs_attr_leaf_split(struct xfs_da_state *state,
+int	xfs_attr3_leaf_split(struct xfs_da_state *state,
 				   struct xfs_da_state_blk *oldblk,
 				   struct xfs_da_state_blk *newblk);
-int	xfs_attr_leaf_lookup_int(struct xfs_buf *leaf,
+int	xfs_attr3_leaf_lookup_int(struct xfs_buf *leaf,
 					struct xfs_da_args *args);
-int	xfs_attr_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
-int	xfs_attr_leaf_add(struct xfs_buf *leaf_buffer,
+int	xfs_attr3_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
+int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
-int	xfs_attr_leaf_remove(struct xfs_buf *leaf_buffer,
+int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);
-int	xfs_attr_leaf_list_int(struct xfs_buf *bp,
+int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
 				      struct xfs_attr_list_context *context);
 
 /*
  * Routines used for shrinking the Btree.
  */
-int	xfs_attr_leaf_toosmall(struct xfs_da_state *state, int *retval);
-void	xfs_attr_leaf_unbalance(struct xfs_da_state *state,
+int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
+void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 				       struct xfs_da_state_blk *drop_blk,
 				       struct xfs_da_state_blk *save_blk);
-int	xfs_attr_root_inactive(struct xfs_trans **trans, struct xfs_inode *dp);
+int	xfs_attr3_root_inactive(struct xfs_trans **trans, struct xfs_inode *dp);
 
 /*
  * Utility routines.
@@ -261,10 +326,12 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
 int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
 					int *local);
-int	xfs_attr_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
+int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			struct xfs_buf **bpp);
+void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
+				     struct xfs_attr_leafblock *from);
 
-extern const struct xfs_buf_ops xfs_attr_leaf_buf_ops;
+extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index f0ffc7c..da619bc 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -269,7 +269,7 @@ xfs_da3_node_read_verify(
 				break;
 			return;
 		case XFS_ATTR_LEAF_MAGIC:
-			bp->b_ops = &xfs_attr_leaf_buf_ops;
+			bp->b_ops = &xfs_attr3_leaf_buf_ops;
 			bp->b_ops->verify_read(bp);
 			return;
 		case XFS_DIR2_LEAFN_MAGIC:
@@ -399,7 +399,7 @@ xfs_da3_split(
 		 */
 		switch (oldblk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
-			error = xfs_attr_leaf_split(state, oldblk, newblk);
+			error = xfs_attr3_leaf_split(state, oldblk, newblk);
 			if ((error != 0) && (error != ENOSPC)) {
 				return(error);	/* GROT: attr is inconsistent */
 			}
@@ -414,12 +414,12 @@ xfs_da3_split(
 			if (state->inleaf) {
 				state->extraafter = 0;	/* before newblk */
 				trace_xfs_attr_leaf_split_before(state->args);
-				error = xfs_attr_leaf_split(state, oldblk,
+				error = xfs_attr3_leaf_split(state, oldblk,
 							    &state->extrablk);
 			} else {
 				state->extraafter = 1;	/* after newblk */
 				trace_xfs_attr_leaf_split_after(state->args);
-				error = xfs_attr_leaf_split(state, newblk,
+				error = xfs_attr3_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
 			if (error)
@@ -959,12 +959,12 @@ xfs_da3_join(
 		 */
 		switch (drop_blk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
-			error = xfs_attr_leaf_toosmall(state, &action);
+			error = xfs_attr3_leaf_toosmall(state, &action);
 			if (error)
 				return(error);
 			if (action == 0)
 				return(0);
-			xfs_attr_leaf_unbalance(state, drop_blk, save_blk);
+			xfs_attr3_leaf_unbalance(state, drop_blk, save_blk);
 			break;
 		case XFS_DIR2_LEAFN_MAGIC:
 			error = xfs_dir2_leafn_toosmall(state, &action);
@@ -1473,7 +1473,9 @@ xfs_da3_node_lookup_int(
 		curr = blk->bp->b_addr;
 		blk->magic = be16_to_cpu(curr->magic);
 
-		if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
+		if (blk->magic == XFS_ATTR_LEAF_MAGIC ||
+		    blk->magic == XFS_ATTR3_LEAF_MAGIC) {
+			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
 			break;
 		}
@@ -1550,7 +1552,7 @@ xfs_da3_node_lookup_int(
 			retval = xfs_dir2_leafn_lookup_int(blk->bp, args,
 							&blk->index, state);
 		} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
-			retval = xfs_attr_leaf_lookup_int(blk->bp, args);
+			retval = xfs_attr3_leaf_lookup_int(blk->bp, args);
 			blk->index = args->index;
 			args->blkno = blk->blkno;
 		} else {
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index f20741e..fd805d8 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -54,6 +54,7 @@ typedef struct xfs_da_blkinfo {
  * magic numbers without modification for both v2 and v3 nodes.
  */
 #define XFS_DA3_NODE_MAGIC	0x3ebe	/* magic number: non-leaf blocks */
+#define XFS_ATTR3_LEAF_MAGIC	0x3bee	/* magic number: attribute leaf blks */
 #define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
 #define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
