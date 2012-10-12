Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5icTk072567 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:44:39 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	R9xdu7h9FNo4RrXG for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:46:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY3I-0003aF-5L
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY38-000572-2J
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/23] xfs: add xfs_da_node verification
Date: Fri, 12 Oct 2012 16:44:25 +1100
Message-Id: <1350020669-19504-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1350020669-19504-1-git-send-email-david@fromorbit.com>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_attr.c      |   22 ++++------
 fs/xfs/xfs_attr_leaf.c |   12 +++---
 fs/xfs/xfs_attr_leaf.h |    8 ++--
 fs/xfs/xfs_da_btree.c  |  108 ++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_da_btree.h  |    3 ++
 fs/xfs/xfs_dir2_leaf.c |    2 +-
 fs/xfs/xfs_dir2_priv.h |    1 +
 7 files changed, 106 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 548e910..4b862ed 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1688,10 +1688,10 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da_read_buf(state->args->trans,
+			error = xfs_da_node_read(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
-						&blk->bp, XFS_ATTR_FORK, NULL);
+						&blk->bp, XFS_ATTR_FORK);
 			if (error)
 				return(error);
 		} else {
@@ -1707,10 +1707,10 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da_read_buf(state->args->trans,
+			error = xfs_da_node_read(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
-						&blk->bp, XFS_ATTR_FORK, NULL);
+						&blk->bp, XFS_ATTR_FORK);
 			if (error)
 				return(error);
 		} else {
@@ -1795,8 +1795,8 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
-		error = xfs_da_read_buf(NULL, context->dp, cursor->blkno, -1,
-					      &bp, XFS_ATTR_FORK, NULL);
+		error = xfs_da_node_read(NULL, context->dp, cursor->blkno, -1,
+					      &bp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != EFSCORRUPTED))
 			return(error);
 		if (bp) {
@@ -1837,17 +1837,11 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	if (bp == NULL) {
 		cursor->blkno = 0;
 		for (;;) {
-			error = xfs_da_read_buf(NULL, context->dp,
+			error = xfs_da_node_read(NULL, context->dp,
 						      cursor->blkno, -1, &bp,
-						      XFS_ATTR_FORK, NULL);
+						      XFS_ATTR_FORK);
 			if (error)
 				return(error);
-			if (unlikely(bp == NULL)) {
-				XFS_ERROR_REPORT("xfs_attr_node_list(2)",
-						 XFS_ERRLEVEL_LOW,
-						 context->dp->i_mount);
-				return(XFS_ERROR(EFSCORRUPTED));
-			}
 			node = bp->b_addr;
 			if (node->hdr.info.magic ==
 			    cpu_to_be16(XFS_ATTR_LEAF_MAGIC))
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 7891d06..5ba92eb 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -87,7 +87,7 @@ STATIC void xfs_attr_leaf_moveents(xfs_attr_leafblock_t *src_leaf,
 					 xfs_mount_t *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
-static void
+void
 xfs_attr_leaf_verify(
 	struct xfs_buf		*bp)
 {
@@ -2742,7 +2742,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	 * the extents in reverse order the extent containing
 	 * block 0 must still be there.
 	 */
-	error = xfs_da_read_buf(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK, NULL);
+	error = xfs_da_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
 	if (error)
 		return(error);
 	blkno = XFS_BUF_ADDR(bp);
@@ -2827,8 +2827,8 @@ xfs_attr_node_inactive(
 		 * traversal of the tree so we may deal with many blocks
 		 * before we come back to this one.
 		 */
-		error = xfs_da_read_buf(*trans, dp, child_fsb, -2, &child_bp,
-						XFS_ATTR_FORK, NULL);
+		error = xfs_da_node_read(*trans, dp, child_fsb, -2, &child_bp,
+						XFS_ATTR_FORK);
 		if (error)
 			return(error);
 		if (child_bp) {
@@ -2868,8 +2868,8 @@ xfs_attr_node_inactive(
 		 * child block number.
 		 */
 		if ((i+1) < count) {
-			error = xfs_da_read_buf(*trans, dp, 0, parent_blkno,
-				&bp, XFS_ATTR_FORK, NULL);
+			error = xfs_da_node_read(*trans, dp, 0, parent_blkno,
+						 &bp, XFS_ATTR_FORK);
 			if (error)
 				return(error);
 			child_fsb = be32_to_cpu(node->btree[i+1].before);
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 8f7ab98..098e9a5 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -227,9 +227,6 @@ int	xfs_attr_leaf_to_shortform(struct xfs_buf *bp,
 int	xfs_attr_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr_leaf_setflag(struct xfs_da_args *args);
 int	xfs_attr_leaf_flipflags(xfs_da_args_t *args);
-int	xfs_attr_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			struct xfs_buf **bpp);
 
 /*
  * Routines used for growing the Btree.
@@ -264,4 +261,9 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
 int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
 					int *local);
+int	xfs_attr_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
+			xfs_dablk_t bno, xfs_daddr_t mappedbno,
+			struct xfs_buf **bpp);
+void	xfs_attr_leaf_verify(struct xfs_buf *bp);
+
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index a46035b..e950192 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -91,6 +91,67 @@ STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *save_blk);
 STATIC void	xfs_da_state_kill_altpath(xfs_da_state_t *state);
 
+static void
+__xfs_da_node_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_da_node_hdr *hdr = bp->b_addr;
+	int			block_ok = 0;
+
+	block_ok = hdr->info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC);
+	block_ok |= hdr->level > 0;
+	block_ok |= hdr->count > 0;
+	if (!block_ok) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+static void
+xfs_da_node_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_da_blkinfo	*info = bp->b_addr;
+
+	switch (be16_to_cpu(info->magic)) {
+		case XFS_DA_NODE_MAGIC:
+			__xfs_da_node_verify(bp);
+			return;
+		case XFS_ATTR_LEAF_MAGIC:
+			xfs_attr_leaf_verify(bp);
+			return;
+		case XFS_DIR2_LEAFN_MAGIC:
+			xfs_dir2_leafn_verify(bp);
+			return;
+		default:
+			break;
+	}
+
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, info);
+	xfs_buf_ioerror(bp, EFSCORRUPTED);
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+int
+xfs_da_node_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mappedbno,
+	struct xfs_buf		**bpp,
+	int			which_fork)
+{
+	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
+					which_fork, xfs_da_node_verify);
+}
+
 /*========================================================================
  * Routines used for growing the Btree.
  *========================================================================*/
@@ -746,8 +807,8 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	 */
 	child = be32_to_cpu(oldroot->btree[0].before);
 	ASSERT(child != 0);
-	error = xfs_da_read_buf(args->trans, args->dp, child, -1, &bp,
-					     args->whichfork, NULL);
+	error = xfs_da_node_read(args->trans, args->dp, child, -1, &bp,
+					     args->whichfork);
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
@@ -835,9 +896,8 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 			blkno = be32_to_cpu(info->back);
 		if (blkno == 0)
 			continue;
-		error = xfs_da_read_buf(state->args->trans, state->args->dp,
-					blkno, -1, &bp, state->args->whichfork,
-					NULL);
+		error = xfs_da_node_read(state->args->trans, state->args->dp,
+					blkno, -1, &bp, state->args->whichfork);
 		if (error)
 			return(error);
 		ASSERT(bp != NULL);
@@ -1080,8 +1140,8 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		 * Read the next node down in the tree.
 		 */
 		blk->blkno = blkno;
-		error = xfs_da_read_buf(args->trans, args->dp, blkno,
-					-1, &blk->bp, args->whichfork, NULL);
+		error = xfs_da_node_read(args->trans, args->dp, blkno,
+					-1, &blk->bp, args->whichfork);
 		if (error) {
 			blk->blkno = 0;
 			state->path.active--;
@@ -1242,9 +1302,9 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		new_info->forw = cpu_to_be32(old_blk->blkno);
 		new_info->back = old_info->back;
 		if (old_info->back) {
-			error = xfs_da_read_buf(args->trans, args->dp,
+			error = xfs_da_node_read(args->trans, args->dp,
 						be32_to_cpu(old_info->back),
-						-1, &bp, args->whichfork, NULL);
+						-1, &bp, args->whichfork);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1263,9 +1323,9 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		new_info->forw = old_info->forw;
 		new_info->back = cpu_to_be32(old_blk->blkno);
 		if (old_info->forw) {
-			error = xfs_da_read_buf(args->trans, args->dp,
+			error = xfs_da_node_read(args->trans, args->dp,
 						be32_to_cpu(old_info->forw),
-						-1, &bp, args->whichfork, NULL);
+						-1, &bp, args->whichfork);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1363,9 +1423,9 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		trace_xfs_da_unlink_back(args);
 		save_info->back = drop_info->back;
 		if (drop_info->back) {
-			error = xfs_da_read_buf(args->trans, args->dp,
+			error = xfs_da_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
-						-1, &bp, args->whichfork, NULL);
+						-1, &bp, args->whichfork);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1380,9 +1440,9 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		trace_xfs_da_unlink_forward(args);
 		save_info->forw = drop_info->forw;
 		if (drop_info->forw) {
-			error = xfs_da_read_buf(args->trans, args->dp,
+			error = xfs_da_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
-						-1, &bp, args->whichfork, NULL);
+						-1, &bp, args->whichfork);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
@@ -1464,8 +1524,8 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 		 * Read the next child block.
 		 */
 		blk->blkno = blkno;
-		error = xfs_da_read_buf(args->trans, args->dp, blkno, -1,
-					&blk->bp, args->whichfork, NULL);
+		error = xfs_da_node_read(args->trans, args->dp, blkno, -1,
+					&blk->bp, args->whichfork);
 		if (error)
 			return(error);
 		ASSERT(blk->bp != NULL);
@@ -1728,7 +1788,7 @@ xfs_da_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - mp->m_dirblkfsbs;
-	error = xfs_da_read_buf(tp, ip, last_blkno, -1, &last_buf, w, NULL);
+	error = xfs_da_node_read(tp, ip, last_blkno, -1, &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -1755,8 +1815,7 @@ xfs_da_swap_lastblock(
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w,
-					NULL);
+		error = xfs_da_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -1778,8 +1837,7 @@ xfs_da_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da_read_buf(tp, ip, sib_blkno, -1, &sib_buf, w,
-					NULL);
+		error = xfs_da_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -1803,8 +1861,7 @@ xfs_da_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w,
-					NULL);
+		error = xfs_da_node_read(tp, ip, par_blkno, -1, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
@@ -1855,8 +1912,7 @@ xfs_da_swap_lastblock(
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		error = xfs_da_read_buf(tp, ip, par_blkno, -1, &par_buf, w,
-					NULL);
+		error = xfs_da_node_read(tp, ip, par_blkno, -1, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index bf8bfaa..2d1bec4 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -213,6 +213,9 @@ int	xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
  */
 int	xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 				       xfs_da_state_blk_t *new_blk);
+int	xfs_da_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
+			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
+			 struct xfs_buf **bpp, int which_fork);
 
 /*
  * Utility routines.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 97408e3..67cc21c 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -74,7 +74,7 @@ xfs_dir2_leaf1_verify(
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 }
 
-static void
+void
 xfs_dir2_leafn_verify(
 	struct xfs_buf		*bp)
 {
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index ecf75d9..1f42e81 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -70,6 +70,7 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
+extern void xfs_dir2_leafn_verify(struct xfs_buf *bp);
 extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
