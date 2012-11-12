Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBs80u218005 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:54:09 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YjiILVo9deCgqY1G for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:56:07 -0800 (PST)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsbm-00054R-IH
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:18 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsbc-00013E-Fu
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/32] xfs: add verifier callback to directory read code
Date: Mon, 12 Nov 2012 22:54:10 +1100
Message-Id: <1352721264-3700-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Phil White <pwhite@sgi.com>
---
 fs/xfs/xfs_attr.c       |   23 ++++++++++++-----------
 fs/xfs/xfs_attr_leaf.c  |   18 +++++++++---------
 fs/xfs/xfs_da_btree.c   |   44 ++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_da_btree.h   |    7 ++++---
 fs/xfs/xfs_dir2_block.c |   23 ++++++++++++-----------
 fs/xfs/xfs_dir2_leaf.c  |   33 ++++++++++++++++-----------------
 fs/xfs/xfs_dir2_node.c  |   43 ++++++++++++++++++++-----------------------
 fs/xfs/xfs_file.c       |    2 +-
 8 files changed, 102 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 474c57a..cd5a9cd 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -904,7 +904,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	dp = args->dp;
 	args->blkno = 0;
 	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
@@ -1032,7 +1032,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * remove the "old" attr from that block (neat, huh!)
 		 */
 		error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1,
-						     &bp, XFS_ATTR_FORK);
+						     &bp, XFS_ATTR_FORK, NULL);
 		if (error)
 			return(error);
 		ASSERT(bp != NULL);
@@ -1101,7 +1101,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	dp = args->dp;
 	args->blkno = 0;
 	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error) {
 		return(error);
 	}
@@ -1159,7 +1159,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 
 	args->blkno = 0;
 	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
@@ -1190,7 +1190,8 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor->blkno = 0;
-	error = xfs_da_read_buf(NULL, context->dp, 0, -1, &bp, XFS_ATTR_FORK);
+	error = xfs_da_read_buf(NULL, context->dp, 0, -1, &bp, XFS_ATTR_FORK,
+				NULL);
 	if (error)
 		return XFS_ERROR(error);
 	ASSERT(bp != NULL);
@@ -1605,7 +1606,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		state->path.blk[0].bp = NULL;
 
 		error = xfs_da_read_buf(args->trans, args->dp, 0, -1, &bp,
-						     XFS_ATTR_FORK);
+						     XFS_ATTR_FORK, NULL);
 		if (error)
 			goto out;
 		ASSERT((((xfs_attr_leafblock_t *)bp->b_addr)->hdr.info.magic) ==
@@ -1718,7 +1719,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 			error = xfs_da_read_buf(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
-						&blk->bp, XFS_ATTR_FORK);
+						&blk->bp, XFS_ATTR_FORK, NULL);
 			if (error)
 				return(error);
 		} else {
@@ -1737,7 +1738,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 			error = xfs_da_read_buf(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
-						&blk->bp, XFS_ATTR_FORK);
+						&blk->bp, XFS_ATTR_FORK, NULL);
 			if (error)
 				return(error);
 		} else {
@@ -1827,7 +1828,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	bp = NULL;
 	if (cursor->blkno > 0) {
 		error = xfs_da_read_buf(NULL, context->dp, cursor->blkno, -1,
-					      &bp, XFS_ATTR_FORK);
+					      &bp, XFS_ATTR_FORK, NULL);
 		if ((error != 0) && (error != EFSCORRUPTED))
 			return(error);
 		if (bp) {
@@ -1870,7 +1871,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		for (;;) {
 			error = xfs_da_read_buf(NULL, context->dp,
 						      cursor->blkno, -1, &bp,
-						      XFS_ATTR_FORK);
+						      XFS_ATTR_FORK, NULL);
 			if (error)
 				return(error);
 			if (unlikely(bp == NULL)) {
@@ -1937,7 +1938,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		cursor->blkno = be32_to_cpu(leaf->hdr.info.forw);
 		xfs_trans_brelse(NULL, bp);
 		error = xfs_da_read_buf(NULL, context->dp, cursor->blkno, -1,
-					      &bp, XFS_ATTR_FORK);
+					      &bp, XFS_ATTR_FORK, NULL);
 		if (error)
 			return(error);
 		if (unlikely((bp == NULL))) {
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 4bfc732..ba2b9a2 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -871,7 +871,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	if (error)
 		goto out;
 	error = xfs_da_read_buf(args->trans, args->dp, 0, -1, &bp1,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error)
 		goto out;
 	ASSERT(bp1 != NULL);
@@ -1642,7 +1642,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 		if (blkno == 0)
 			continue;
 		error = xfs_da_read_buf(state->args->trans, state->args->dp,
-					blkno, -1, &bp, XFS_ATTR_FORK);
+					blkno, -1, &bp, XFS_ATTR_FORK, NULL);
 		if (error)
 			return(error);
 		ASSERT(bp != NULL);
@@ -2519,7 +2519,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	 * Set up the operation.
 	 */
 	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error) {
 		return(error);
 	}
@@ -2584,7 +2584,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	 * Set up the operation.
 	 */
 	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error) {
 		return(error);
 	}
@@ -2641,7 +2641,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	 * Read the block containing the "old" attr
 	 */
 	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp1,
-					     XFS_ATTR_FORK);
+					     XFS_ATTR_FORK, NULL);
 	if (error) {
 		return(error);
 	}
@@ -2652,7 +2652,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	 */
 	if (args->blkno2 != args->blkno) {
 		error = xfs_da_read_buf(args->trans, args->dp, args->blkno2,
-					-1, &bp2, XFS_ATTR_FORK);
+					-1, &bp2, XFS_ATTR_FORK, NULL);
 		if (error) {
 			return(error);
 		}
@@ -2753,7 +2753,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	 * the extents in reverse order the extent containing
 	 * block 0 must still be there.
 	 */
-	error = xfs_da_read_buf(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
+	error = xfs_da_read_buf(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK, NULL);
 	if (error)
 		return(error);
 	blkno = XFS_BUF_ADDR(bp);
@@ -2839,7 +2839,7 @@ xfs_attr_node_inactive(
 		 * before we come back to this one.
 		 */
 		error = xfs_da_read_buf(*trans, dp, child_fsb, -2, &child_bp,
-						XFS_ATTR_FORK);
+						XFS_ATTR_FORK, NULL);
 		if (error)
 			return(error);
 		if (child_bp) {
@@ -2880,7 +2880,7 @@ xfs_attr_node_inactive(
 		 */
 		if ((i+1) < count) {
 			error = xfs_da_read_buf(*trans, dp, 0, parent_blkno,
-				&bp, XFS_ATTR_FORK);
+				&bp, XFS_ATTR_FORK, NULL);
 			if (error)
 				return(error);
 			child_fsb = be32_to_cpu(node->btree[i+1].before);
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 4af8bad..f9e9149 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -747,7 +747,7 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	child = be32_to_cpu(oldroot->btree[0].before);
 	ASSERT(child != 0);
 	error = xfs_da_read_buf(args->trans, args->dp, child, -1, &bp,
-					     args->whichfork);
+					     args->whichfork, NULL);
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
@@ -838,7 +838,8 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 		if (blkno == 0)
 			continue;
 		error = xfs_da_read_buf(state->args->trans, state->args->dp,
-					blkno, -1, &bp, state->args->whichfork);
+					blkno, -1, &bp, state->args->whichfork,
+					NULL);
 		if (error)
 			return(error);
 		ASSERT(bp != NULL);
@@ -1084,7 +1085,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		 */
 		blk->blkno = blkno;
 		error = xfs_da_read_buf(args->trans, args->dp, blkno,
-					-1, &blk->bp, args->whichfork);
+					-1, &blk->bp, args->whichfork, NULL);
 		if (error) {
 			blk->blkno = 0;
 			state->path.active--;
@@ -1247,7 +1248,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		if (old_info->back) {
 			error = xfs_da_read_buf(args->trans, args->dp,
 						be32_to_cpu(old_info->back),
-						-1, &bp, args->whichfork);
+						-1, &bp, args->whichfork, NULL);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1268,7 +1269,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		if (old_info->forw) {
 			error = xfs_da_read_buf(args->trans, args->dp,
 						be32_to_cpu(old_info->forw),
-						-1, &bp, args->whichfork);
+						-1, &bp, args->whichfork, NULL);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1368,7 +1369,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		if (drop_info->back) {
 			error = xfs_da_read_buf(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
-						-1, &bp, args->whichfork);
+						-1, &bp, args->whichfork, NULL);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1385,7 +1386,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		if (drop_info->forw) {
 			error = xfs_da_read_buf(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
-						-1, &bp, args->whichfork);
+						-1, &bp, args->whichfork, NULL);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1470,7 +1471,7 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 		 */
 		blk->blkno = blkno;
 		error = xfs_da_read_buf(args->trans, args->dp, blkno, -1,
-						     &blk->bp, args->whichfork);
+					&blk->bp, args->whichfork, NULL);
 		if (error)
 			return(error);
 		ASSERT(blk->bp != NULL);
@@ -1733,7 +1734,8 @@ xfs_da_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - mp->m_dirblkfsbs;
-	if ((error = xfs_da_read_buf(tp, ip, last_blkno, -1, &last_buf, w)))
+	error = xfs_da_read_buf(tp, ip, last_blkno, -1, &last_buf, w, NULL);
+	if (error)
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
@@ -1759,7 +1761,9 @@ xfs_da_swap_lastblock(
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		if ((error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w)))
+		error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w,
+					NULL);
+		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
 		if (unlikely(
@@ -1780,7 +1784,9 @@ xfs_da_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		if ((error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w)))
+		error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w,
+					NULL);
+		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
 		if (unlikely(
@@ -1803,7 +1809,9 @@ xfs_da_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		if ((error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w)))
+		error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w,
+					NULL);
+		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
 		if (unlikely(par_node->hdr.info.magic !=
@@ -1853,7 +1861,9 @@ xfs_da_swap_lastblock(
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		if ((error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w)))
+		error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w,
+					NULL);
+		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
 		if (unlikely(
@@ -2139,7 +2149,8 @@ xfs_da_read_buf(
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp,
-	int			whichfork)
+	int			whichfork,
+	xfs_buf_iodone_t	verifier)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf_map	map;
@@ -2161,7 +2172,7 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(dp->i_mount, trans,
 					dp->i_mount->m_ddev_targp,
-					mapp, nmap, 0, &bp, NULL);
+					mapp, nmap, 0, &bp, verifier);
 	if (error)
 		goto out_free;
 
@@ -2217,7 +2228,8 @@ xfs_da_reada_buf(
 	struct xfs_trans	*trans,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	int			whichfork)
+	int			whichfork,
+	xfs_buf_iodone_t	verifier)
 {
 	xfs_daddr_t		mappedbno = -1;
 	struct xfs_buf_map	map;
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 132adaf..bf8bfaa 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -18,7 +18,6 @@
 #ifndef __XFS_DA_BTREE_H__
 #define	__XFS_DA_BTREE_H__
 
-struct xfs_buf;
 struct xfs_bmap_free;
 struct xfs_inode;
 struct xfs_mount;
@@ -226,9 +225,11 @@ int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			      struct xfs_buf **bp, int whichfork);
 int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			       struct xfs_buf **bpp, int whichfork);
+			       struct xfs_buf **bpp, int whichfork,
+			       xfs_buf_iodone_t verifier);
 xfs_daddr_t	xfs_da_reada_buf(struct xfs_trans *trans, struct xfs_inode *dp,
-			xfs_dablk_t bno, int whichfork);
+				xfs_dablk_t bno, int whichfork,
+				xfs_buf_iodone_t verifier);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index e93ca8f..53666ca 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -97,10 +97,10 @@ xfs_dir2_block_addname(
 	/*
 	 * Read the (one and only) directory block into dabuf bp.
 	 */
-	if ((error =
-	    xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp, XFS_DATA_FORK))) {
+	error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp,
+				XFS_DATA_FORK, NULL);
+	if (error)
 		return error;
-	}
 	ASSERT(bp != NULL);
 	hdr = bp->b_addr;
 	/*
@@ -457,7 +457,7 @@ xfs_dir2_block_getdents(
 	 * Can't read the block, give up, else get dabuf in bp.
 	 */
 	error = xfs_da_read_buf(NULL, dp, mp->m_dirdatablk, -1,
-				&bp, XFS_DATA_FORK);
+				&bp, XFS_DATA_FORK, NULL);
 	if (error)
 		return error;
 
@@ -640,10 +640,10 @@ xfs_dir2_block_lookup_int(
 	/*
 	 * Read the buffer, return error if we can't get it.
 	 */
-	if ((error =
-	    xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp, XFS_DATA_FORK))) {
+	error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp,
+				XFS_DATA_FORK, NULL);
+	if (error)
 		return error;
-	}
 	ASSERT(bp != NULL);
 	hdr = bp->b_addr;
 	xfs_dir2_data_check(dp, bp);
@@ -917,10 +917,11 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
-	if (dbp == NULL &&
-	    (error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &dbp,
-		    XFS_DATA_FORK))) {
-		return error;
+	if (!dbp) {
+		error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &dbp,
+					XFS_DATA_FORK, NULL);
+		if (error)
+			return error;
 	}
 	hdr = dbp->b_addr;
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index bac8698..86e3dc1 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -315,10 +315,9 @@ xfs_dir2_leaf_addname(
 	 * Read the leaf block.
 	 */
 	error = xfs_da_read_buf(tp, dp, mp->m_dirleafblk, -1, &lbp,
-		XFS_DATA_FORK);
-	if (error) {
+				XFS_DATA_FORK, NULL);
+	if (error)
 		return error;
-	}
 	ASSERT(lbp != NULL);
 	/*
 	 * Look up the entry by hash value and name.
@@ -500,9 +499,9 @@ xfs_dir2_leaf_addname(
 	 * Just read that one in.
 	 */
 	else {
-		if ((error =
-		    xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, use_block),
-			    -1, &dbp, XFS_DATA_FORK))) {
+		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, use_block),
+					-1, &dbp, XFS_DATA_FORK, NULL);
+		if (error) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
 		}
@@ -895,7 +894,7 @@ xfs_dir2_leaf_readbuf(
 	error = xfs_da_read_buf(NULL, dp, map->br_startoff,
 			map->br_blockcount >= mp->m_dirblkfsbs ?
 			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1,
-			&bp, XFS_DATA_FORK);
+			&bp, XFS_DATA_FORK, NULL);
 
 	/*
 	 * Should just skip over the data block instead of giving up.
@@ -938,7 +937,7 @@ xfs_dir2_leaf_readbuf(
 			xfs_da_reada_buf(NULL, dp,
 					map[mip->ra_index].br_startoff +
 							mip->ra_offset,
-					XFS_DATA_FORK);
+					XFS_DATA_FORK, NULL);
 			mip->ra_current = i;
 		}
 
@@ -1376,7 +1375,7 @@ xfs_dir2_leaf_lookup_int(
 	 * Read the leaf block into the buffer.
 	 */
 	error = xfs_da_read_buf(tp, dp, mp->m_dirleafblk, -1, &lbp,
-							XFS_DATA_FORK);
+							XFS_DATA_FORK, NULL);
 	if (error)
 		return error;
 	*lbpp = lbp;
@@ -1411,7 +1410,7 @@ xfs_dir2_leaf_lookup_int(
 				xfs_trans_brelse(tp, dbp);
 			error = xfs_da_read_buf(tp, dp,
 						xfs_dir2_db_to_da(mp, newdb),
-						-1, &dbp, XFS_DATA_FORK);
+						-1, &dbp, XFS_DATA_FORK, NULL);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1453,7 +1452,7 @@ xfs_dir2_leaf_lookup_int(
 			xfs_trans_brelse(tp, dbp);
 			error = xfs_da_read_buf(tp, dp,
 						xfs_dir2_db_to_da(mp, cidb),
-						-1, &dbp, XFS_DATA_FORK);
+						-1, &dbp, XFS_DATA_FORK, NULL);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1738,10 +1737,10 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	if ((error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp,
-			XFS_DATA_FORK))) {
+	error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp,
+				XFS_DATA_FORK, NULL);
+	if (error)
 		return error;
-	}
 
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
@@ -1864,10 +1863,10 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Read the freespace block.
 	 */
-	if ((error = xfs_da_read_buf(tp, dp, mp->m_dirfreeblk, -1, &fbp,
-			XFS_DATA_FORK))) {
+	error = xfs_da_read_buf(tp, dp,  mp->m_dirfreeblk, -1, &fbp,
+				XFS_DATA_FORK, NULL);
+	if (error)
 		return error;
-	}
 	free = fbp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	ASSERT(!free->hdr.firstdb);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 6c70524..290c2b1 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -399,7 +399,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				 */
 				error = xfs_da_read_buf(tp, dp,
 						xfs_dir2_db_to_da(mp, newfdb),
-						-1, &curbp, XFS_DATA_FORK);
+						-1, &curbp, XFS_DATA_FORK, NULL);
 				if (error)
 					return error;
 				free = curbp->b_addr;
@@ -536,7 +536,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			} else {
 				error = xfs_da_read_buf(tp, dp,
 						xfs_dir2_db_to_da(mp, newdb),
-						-1, &curbp, XFS_DATA_FORK);
+						-1, &curbp, XFS_DATA_FORK, NULL);
 				if (error)
 					return error;
 			}
@@ -915,10 +915,10 @@ xfs_dir2_leafn_remove(
 		 * read in the free block.
 		 */
 		fdb = xfs_dir2_db_to_fdb(mp, db);
-		if ((error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb),
-				-1, &fbp, XFS_DATA_FORK))) {
+		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb),
+					-1, &fbp, XFS_DATA_FORK, NULL);
+		if (error)
 			return error;
-		}
 		free = fbp->b_addr;
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 		ASSERT(be32_to_cpu(free->hdr.firstdb) ==
@@ -1169,11 +1169,10 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Read the sibling leaf block.
 		 */
-		if ((error =
-		    xfs_da_read_buf(state->args->trans, state->args->dp, blkno,
-			    -1, &bp, XFS_DATA_FORK))) {
+		error = xfs_da_read_buf(state->args->trans, state->args->dp,
+					blkno, -1, &bp, XFS_DATA_FORK, NULL);
+		if (error)
 			return error;
-		}
 		ASSERT(bp != NULL);
 		/*
 		 * Count bytes in the two blocks combined.
@@ -1454,14 +1453,13 @@ xfs_dir2_node_addname_int(
 			 * This should be really rare, so there's no reason
 			 * to avoid it.
 			 */
-			if ((error = xfs_da_read_buf(tp, dp,
-					xfs_dir2_db_to_da(mp, fbno), -2, &fbp,
-					XFS_DATA_FORK))) {
+			error = xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, fbno), -2,
+						&fbp, XFS_DATA_FORK, NULL);
+			if (error)
 				return error;
-			}
-			if (unlikely(fbp == NULL)) {
+			if (!fbp)
 				continue;
-			}
 			free = fbp->b_addr;
 			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 			findex = 0;
@@ -1520,9 +1518,9 @@ xfs_dir2_node_addname_int(
 		 * that was just allocated.
 		 */
 		fbno = xfs_dir2_db_to_fdb(mp, dbno);
-		if (unlikely(error = xfs_da_read_buf(tp, dp,
-				xfs_dir2_db_to_da(mp, fbno), -2, &fbp,
-				XFS_DATA_FORK)))
+		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, fbno), -2,
+					&fbp, XFS_DATA_FORK, NULL);
+		if (error)
 			return error;
 
 		/*
@@ -1631,7 +1629,7 @@ xfs_dir2_node_addname_int(
 		 * Read the data block in.
 		 */
 		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, dbno),
-				-1, &dbp, XFS_DATA_FORK);
+					-1, &dbp, XFS_DATA_FORK, NULL);
 		if (error)
 			return error;
 		hdr = dbp->b_addr;
@@ -1917,11 +1915,10 @@ xfs_dir2_node_trim_free(
 	/*
 	 * Read the freespace block.
 	 */
-	if (unlikely(error = xfs_da_read_buf(tp, dp, (xfs_dablk_t)fo, -2, &bp,
-			XFS_DATA_FORK))) {
+	error = xfs_da_read_buf(tp, dp, (xfs_dablk_t)fo, -2, &bp,
+				XFS_DATA_FORK, NULL);
+	if (error)
 		return error;
-	}
-
 	/*
 	 * There can be holes in freespace.  If fo is a hole, there's
 	 * nothing to do.
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c42f99e..f6dab7d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -891,7 +891,7 @@ xfs_dir_open(
 	 */
 	mode = xfs_ilock_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
-		xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK);
+		xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK, NULL);
 	xfs_iunlock(ip, mode);
 	return 0;
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
