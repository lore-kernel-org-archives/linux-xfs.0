Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q993oA8C212985 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 22:50:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HUgGYE8URVkwngol for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 20:51:38 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLQr1-0002Q7-16
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLQqq-0008Px-SQ
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/19] xfs: factor and verify attr leaf reads
Date: Tue,  9 Oct 2012 14:51:08 +1100
Message-Id: <1349754670-32009-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1349754670-32009-1-git-send-email-david@fromorbit.com>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
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

Some reads are not converted yet because it isn't obvious ahead of
time what the format of the block is going to be. Need to determine
how to tell if the first block in the tree is a node or leaf format
block. That will be done in later patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c      |   70 +++++++++++--------------------------------
 fs/xfs/xfs_attr_leaf.c |   78 ++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_attr_leaf.h |    2 ++
 3 files changed, 65 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 956c2ba..548e910 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -903,11 +903,9 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK, NULL);
+	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
-		return(error);
-	ASSERT(bp != NULL);
+		return error;
 
 	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
@@ -1031,12 +1029,12 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Read in the block containing the "old" attr, then
 		 * remove the "old" attr from that block (neat, huh!)
 		 */
-		error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1,
-						     &bp, XFS_ATTR_FORK, NULL);
+		error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno,
+					   -1, &bp);
 		if (error)
-			return(error);
-		ASSERT(bp != NULL);
-		(void)xfs_attr_leaf_remove(bp, args);
+			return error;
+
+		xfs_attr_leaf_remove(bp, args);
 
 		/*
 		 * If the result is small enough, shrink it all into the inode.
@@ -1100,20 +1098,17 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK, NULL);
-	if (error) {
-		return(error);
-	}
+	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	if (error)
+		return error;
 
-	ASSERT(bp != NULL);
 	error = xfs_attr_leaf_lookup_int(bp, args);
 	if (error == ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
 		return(error);
 	}
 
-	(void)xfs_attr_leaf_remove(bp, args);
+	xfs_attr_leaf_remove(bp, args);
 
 	/*
 	 * If the result is small enough, shrink it all into the inode.
@@ -1156,11 +1151,9 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	int error;
 
 	args->blkno = 0;
-	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK, NULL);
+	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
-		return(error);
-	ASSERT(bp != NULL);
+		return error;
 
 	error = xfs_attr_leaf_lookup_int(bp, args);
 	if (error != EEXIST)  {
@@ -1181,23 +1174,13 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 STATIC int
 xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 {
-	xfs_attr_leafblock_t *leaf;
 	int error;
 	struct xfs_buf *bp;
 
 	context->cursor->blkno = 0;
-	error = xfs_da_read_buf(NULL, context->dp, 0, -1, &bp, XFS_ATTR_FORK,
-				NULL);
+	error = xfs_attr_leaf_read(NULL, context->dp, 0, -1, &bp);
 	if (error)
 		return XFS_ERROR(error);
-	ASSERT(bp != NULL);
-	leaf = bp->b_addr;
-	if (unlikely(leaf->hdr.info.magic != cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
-		XFS_CORRUPTION_ERROR("xfs_attr_leaf_list", XFS_ERRLEVEL_LOW,
-				     context->dp->i_mount, leaf);
-		xfs_trans_brelse(NULL, bp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
 
 	error = xfs_attr_leaf_list_int(bp, context);
 	xfs_trans_brelse(NULL, bp);
@@ -1601,12 +1584,9 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 		ASSERT(state->path.blk[0].bp);
 		state->path.blk[0].bp = NULL;
 
-		error = xfs_da_read_buf(args->trans, args->dp, 0, -1, &bp,
-						     XFS_ATTR_FORK, NULL);
+		error = xfs_attr_leaf_read(args->trans, args->dp, 0, -1, &bp);
 		if (error)
 			goto out;
-		ASSERT((((xfs_attr_leafblock_t *)bp->b_addr)->hdr.info.magic) ==
-		       cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
 			xfs_bmap_init(args->flist, args->firstblock);
@@ -1908,14 +1888,6 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 */
 	for (;;) {
 		leaf = bp->b_addr;
-		if (unlikely(leaf->hdr.info.magic !=
-			     cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
-			XFS_CORRUPTION_ERROR("xfs_attr_node_list(4)",
-					     XFS_ERRLEVEL_LOW,
-					     context->dp->i_mount, leaf);
-			xfs_trans_brelse(NULL, bp);
-			return(XFS_ERROR(EFSCORRUPTED));
-		}
 		error = xfs_attr_leaf_list_int(bp, context);
 		if (error) {
 			xfs_trans_brelse(NULL, bp);
@@ -1925,16 +1897,10 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			break;
 		cursor->blkno = be32_to_cpu(leaf->hdr.info.forw);
 		xfs_trans_brelse(NULL, bp);
-		error = xfs_da_read_buf(NULL, context->dp, cursor->blkno, -1,
-					      &bp, XFS_ATTR_FORK, NULL);
+		error = xfs_attr_leaf_read(NULL, context->dp, cursor->blkno, -1,
+					   &bp);
 		if (error)
-			return(error);
-		if (unlikely((bp == NULL))) {
-			XFS_ERROR_REPORT("xfs_attr_node_list(5)",
-					 XFS_ERRLEVEL_LOW,
-					 context->dp->i_mount);
-			return(XFS_ERROR(EFSCORRUPTED));
-		}
+			return error;
 	}
 	xfs_trans_brelse(NULL, bp);
 	return(0);
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index f2b698e..2069b53 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -87,6 +87,36 @@ STATIC void xfs_attr_leaf_moveents(xfs_attr_leafblock_t *src_leaf,
 					 xfs_mount_t *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
+static void
+xfs_attr_leaf_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_attr_leaf_hdr *hdr = bp->b_addr;
+	int			block_ok = 0;
+
+	block_ok = hdr->info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC);
+	if (!block_ok) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+int
+xfs_attr_leaf_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	int			map_type,
+	struct xfs_buf		**bpp)
+{
+	return xfs_da_read_buf(tp, dp, bno, map_type, bpp,
+					XFS_ATTR_FORK, xfs_attr_leaf_verify);
+}
+
 /*========================================================================
  * Namespace helper routines
  *========================================================================*/
@@ -869,11 +899,10 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_da_read_buf(args->trans, args->dp, 0, -1, &bp1,
-					     XFS_ATTR_FORK, NULL);
+	error = xfs_attr_leaf_read(args->trans, args->dp, 0, -1, &bp1);
 	if (error)
 		goto out;
-	ASSERT(bp1 != NULL);
+
 	bp2 = NULL;
 	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp2,
 					    XFS_ATTR_FORK);
@@ -1620,18 +1649,16 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 			blkno = be32_to_cpu(info->back);
 		if (blkno == 0)
 			continue;
-		error = xfs_da_read_buf(state->args->trans, state->args->dp,
-					blkno, -1, &bp, XFS_ATTR_FORK, NULL);
+		error = xfs_attr_leaf_read(state->args->trans, state->args->dp,
+					blkno, -1, &bp);
 		if (error)
 			return(error);
-		ASSERT(bp != NULL);
 
 		leaf = (xfs_attr_leafblock_t *)info;
 		count  = be16_to_cpu(leaf->hdr.count);
 		bytes  = state->blocksize - (state->blocksize>>2);
 		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
 		leaf = bp->b_addr;
-		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 		count += be16_to_cpu(leaf->hdr.count);
 		bytes -= be16_to_cpu(leaf->hdr.usedbytes);
 		bytes -= count * sizeof(xfs_attr_leaf_entry_t);
@@ -2495,15 +2522,11 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK, NULL);
-	if (error) {
+	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	if (error)
 		return(error);
-	}
-	ASSERT(bp != NULL);
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
 	ASSERT(args->index >= 0);
 	entry = &leaf->entries[ args->index ];
@@ -2560,15 +2583,11 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp,
-					     XFS_ATTR_FORK, NULL);
-	if (error) {
+	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	if (error)
 		return(error);
-	}
-	ASSERT(bp != NULL);
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf->hdr.count));
 	ASSERT(args->index >= 0);
 	entry = &leaf->entries[ args->index ];
@@ -2617,35 +2636,28 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_da_read_buf(args->trans, args->dp, args->blkno, -1, &bp1,
-					     XFS_ATTR_FORK, NULL);
-	if (error) {
-		return(error);
-	}
-	ASSERT(bp1 != NULL);
+	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
+	if (error)
+		return error;
 
 	/*
 	 * Read the block containing the "new" attr, if it is different
 	 */
 	if (args->blkno2 != args->blkno) {
-		error = xfs_da_read_buf(args->trans, args->dp, args->blkno2,
-					-1, &bp2, XFS_ATTR_FORK, NULL);
-		if (error) {
-			return(error);
-		}
-		ASSERT(bp2 != NULL);
+		error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno2,
+					   -1, &bp2);
+		if (error)
+			return error;
 	} else {
 		bp2 = bp1;
 	}
 
 	leaf1 = bp1->b_addr;
-	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index < be16_to_cpu(leaf1->hdr.count));
 	ASSERT(args->index >= 0);
 	entry1 = &leaf1->entries[ args->index ];
 
 	leaf2 = bp2->b_addr;
-	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(args->index2 < be16_to_cpu(leaf2->hdr.count));
 	ASSERT(args->index2 >= 0);
 	entry2 = &leaf2->entries[ args->index2 ];
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index dea1772..e05babc 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -227,6 +227,8 @@ int	xfs_attr_leaf_to_shortform(struct xfs_buf *bp,
 int	xfs_attr_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr_leaf_setflag(struct xfs_da_args *args);
 int	xfs_attr_leaf_flipflags(xfs_da_args_t *args);
+int	xfs_attr_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
+			xfs_dablk_t bno, int map_type, struct xfs_buf **bpp);
 
 /*
  * Routines used for growing the Btree.
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
