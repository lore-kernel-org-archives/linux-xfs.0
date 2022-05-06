Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0741C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390705AbiEFJt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 05:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390708AbiEFJtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 05:49:46 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF30A65D13
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:46:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 49A4C10E6453
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 19:45:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX7-008fMt-1H
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 19:45:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX7-0029Tw-0V
        for linux-xfs@vger.kernel.org;
        Fri, 06 May 2022 19:45:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/17] xfs: remove xfs_attri_remove_iter
Date:   Fri,  6 May 2022 19:45:51 +1000
Message-Id: <20220506094553.512973-16-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506094553.512973-1-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6274ee56
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=uzfVmOfQd1FiEXLSBw0A:9 a=FL95XUGkWnwA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_attri_remove_iter is not used anymore, so remove it and all the
infrastructure it uses and is needed to drive it. THe
xfs_attr_refillstate() function now throws an unused warning, so
isolate the xfs_attr_fillstate()/xfs_attr_refillstate() code pair
with an #if 0 and a comment explaining why we want to keep this code
and restore the optimisation it provides in the near future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 431 ++++++++++++---------------------------
 1 file changed, 135 insertions(+), 296 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e2067aead818..c326fb2f5417 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -64,8 +64,6 @@ STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
 				    struct xfs_da_state *state);
 
@@ -100,6 +98,123 @@ xfs_attr_is_leaf(
 	return imap.br_startoff == 0 && imap.br_blockcount == 1;
 }
 
+/*
+ * XXX (dchinner): name path state saving and refilling is an optimisation to
+ * avoid needing to look up name entries after rolling transactions removing
+ * remote xattr blocks between the name entry lookup and name entry removal.
+ * This optimisation got sidelined when combining the set and remove state
+ * machines, but the code has been left in place because it is worthwhile to
+ * restore the optimisation once the combined state machine paths have settled.
+ *
+ * This comment is a public service announcement to remind Future Dave that he
+ * still needs to restore this code to working order.
+ */
+#if 0
+/*
+ * Fill in the disk block numbers in the state structure for the buffers
+ * that are attached to the state structure.
+ * This is done so that we can quickly reattach ourselves to those buffers
+ * after some set of transaction commits have released these buffers.
+ */
+static int
+xfs_attr_fillstate(xfs_da_state_t *state)
+{
+	xfs_da_state_path_t *path;
+	xfs_da_state_blk_t *blk;
+	int level;
+
+	trace_xfs_attr_fillstate(state->args);
+
+	/*
+	 * Roll down the "path" in the state structure, storing the on-disk
+	 * block number for those buffers in the "path".
+	 */
+	path = &state->path;
+	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
+	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
+		if (blk->bp) {
+			blk->disk_blkno = xfs_buf_daddr(blk->bp);
+			blk->bp = NULL;
+		} else {
+			blk->disk_blkno = 0;
+		}
+	}
+
+	/*
+	 * Roll down the "altpath" in the state structure, storing the on-disk
+	 * block number for those buffers in the "altpath".
+	 */
+	path = &state->altpath;
+	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
+	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
+		if (blk->bp) {
+			blk->disk_blkno = xfs_buf_daddr(blk->bp);
+			blk->bp = NULL;
+		} else {
+			blk->disk_blkno = 0;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Reattach the buffers to the state structure based on the disk block
+ * numbers stored in the state structure.
+ * This is done after some set of transaction commits have released those
+ * buffers from our grip.
+ */
+static int
+xfs_attr_refillstate(xfs_da_state_t *state)
+{
+	xfs_da_state_path_t *path;
+	xfs_da_state_blk_t *blk;
+	int level, error;
+
+	trace_xfs_attr_refillstate(state->args);
+
+	/*
+	 * Roll down the "path" in the state structure, storing the on-disk
+	 * block number for those buffers in the "path".
+	 */
+	path = &state->path;
+	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
+	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
+		if (blk->disk_blkno) {
+			error = xfs_da3_node_read_mapped(state->args->trans,
+					state->args->dp, blk->disk_blkno,
+					&blk->bp, XFS_ATTR_FORK);
+			if (error)
+				return error;
+		} else {
+			blk->bp = NULL;
+		}
+	}
+
+	/*
+	 * Roll down the "altpath" in the state structure, storing the on-disk
+	 * block number for those buffers in the "altpath".
+	 */
+	path = &state->altpath;
+	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
+	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
+		if (blk->disk_blkno) {
+			error = xfs_da3_node_read_mapped(state->args->trans,
+					state->args->dp, blk->disk_blkno,
+					&blk->bp, XFS_ATTR_FORK);
+			if (error)
+				return error;
+		} else {
+			blk->bp = NULL;
+		}
+	}
+
+	return 0;
+}
+#else
+static int xfs_attr_fillstate(xfs_da_state_t *state) { return 0; }
+#endif
+
 /*========================================================================
  * Overall external interface routines.
  *========================================================================*/
@@ -1339,6 +1454,24 @@ xfs_attr_node_try_addname(
 	return error;
 }
 
+static int
+xfs_attr_node_removename(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
 
 static int
 xfs_attr_node_remove_attr(
@@ -1381,300 +1514,6 @@ xfs_attr_node_remove_attr(
 	return retval;
 }
 
-/*
- * Shrink an attribute from leaf to shortform
- */
-STATIC int
-xfs_attr_node_shrink(
-	struct xfs_da_args	*args,
-	struct xfs_da_state     *state)
-{
-	struct xfs_inode	*dp = args->dp;
-	int			error, forkoff;
-	struct xfs_buf		*bp;
-
-	/*
-	 * Have to get rid of the copy of this dabuf in the state.
-	 */
-	ASSERT(state->path.active == 1);
-	ASSERT(state->path.blk[0].bp);
-	state->path.blk[0].bp = NULL;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
-	if (error)
-		return error;
-
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff) {
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-	} else
-		xfs_trans_brelse(args->trans, bp);
-
-	return error;
-}
-
-STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	struct xfs_da_state_blk	*blk;
-	int			retval;
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[state->path.active-1];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
-
-	return retval;
-}
-
-/*
- * Remove the attribute specified in @args.
- *
- * This will involve walking down the Btree, and may involve joining
- * leaf nodes and even joining intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * This routine is meant to function as either an in-line or delayed operation,
- * and may return -EAGAIN when the transaction needs to be rolled.  Calling
- * functions will need to handle this, and call the function until a
- * successful error code is returned.
- */
-int
-xfs_attr_remove_iter(
-	struct xfs_attr_item		*attr)
-{
-	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_da_state		*state = attr->xattri_da_state;
-	int				retval, error = 0;
-	struct xfs_inode		*dp = args->dp;
-
-	trace_xfs_attr_node_removename(args);
-
-	switch (attr->xattri_dela_state) {
-	case XFS_DAS_UNINIT:
-		if (!xfs_inode_hasattr(dp))
-			return -ENOATTR;
-
-		/*
-		 * Shortform or leaf formats don't require transaction rolls and
-		 * thus state transitions. Call the right helper and return.
-		 */
-		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-			return xfs_attr_sf_removename(args);
-
-		if (xfs_attr_is_leaf(dp))
-			return xfs_attr_leaf_removename(args);
-
-		/*
-		 * Node format may require transaction rolls. Set up the
-		 * state context and fall into the state machine.
-		 */
-		if (!attr->xattri_da_state) {
-			error = xfs_attr_node_removename_setup(attr);
-			if (error)
-				return error;
-			state = attr->xattri_da_state;
-		}
-
-		fallthrough;
-	case XFS_DAS_RMTBLK:
-		attr->xattri_dela_state = XFS_DAS_RMTBLK;
-
-		/*
-		 * If there is an out-of-line value, de-allocate the blocks.
-		 * This is done before we remove the attribute so that we don't
-		 * overflow the maximum size of a transaction and/or hit a
-		 * deadlock.
-		 */
-		if (args->rmtblkno > 0) {
-			/*
-			 * May return -EAGAIN. Roll and repeat until all remote
-			 * blocks are removed.
-			 */
-			error = xfs_attr_rmtval_remove(attr);
-			if (error == -EAGAIN) {
-				trace_xfs_attr_remove_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return error;
-			} else if (error) {
-				goto out;
-			}
-
-			/*
-			 * Refill the state structure with buffers (the prior
-			 * calls released our buffers) and close out this
-			 * transaction before proceeding.
-			 */
-			ASSERT(args->rmtblkno == 0);
-			error = xfs_attr_refillstate(state);
-			if (error)
-				goto out;
-
-			attr->xattri_dela_state = XFS_DAS_RM_NAME;
-			trace_xfs_attr_remove_iter_return(
-					attr->xattri_dela_state, args->dp);
-			return -EAGAIN;
-		}
-
-		fallthrough;
-	case XFS_DAS_RM_NAME:
-		/*
-		 * If we came here fresh from a transaction roll, reattach all
-		 * the buffers to the current transaction.
-		 */
-		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
-			error = xfs_attr_refillstate(state);
-			if (error)
-				goto out;
-		}
-
-		retval = xfs_attr_node_removename(args, state);
-
-		/*
-		 * Check to see if the tree needs to be collapsed. If so, roll
-		 * the transacton and fall into the shrink state.
-		 */
-		if (retval && (state->path.active > 1)) {
-			error = xfs_da3_join(state);
-			if (error)
-				goto out;
-
-			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
-			trace_xfs_attr_remove_iter_return(
-					attr->xattri_dela_state, args->dp);
-			return -EAGAIN;
-		}
-
-		fallthrough;
-	case XFS_DAS_RM_SHRINK:
-		/*
-		 * If the result is small enough, push it all into the inode.
-		 * This is our final state so it's safe to return a dirty
-		 * transaction.
-		 */
-		if (xfs_attr_is_leaf(dp))
-			error = xfs_attr_node_shrink(args, state);
-		ASSERT(error != -EAGAIN);
-		break;
-	default:
-		ASSERT(0);
-		error = -EINVAL;
-		goto out;
-	}
-out:
-	if (state)
-		xfs_da_state_free(state);
-	return error;
-}
-
-/*
- * Fill in the disk block numbers in the state structure for the buffers
- * that are attached to the state structure.
- * This is done so that we can quickly reattach ourselves to those buffers
- * after some set of transaction commits have released these buffers.
- */
-STATIC int
-xfs_attr_fillstate(xfs_da_state_t *state)
-{
-	xfs_da_state_path_t *path;
-	xfs_da_state_blk_t *blk;
-	int level;
-
-	trace_xfs_attr_fillstate(state->args);
-
-	/*
-	 * Roll down the "path" in the state structure, storing the on-disk
-	 * block number for those buffers in the "path".
-	 */
-	path = &state->path;
-	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
-	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
-		if (blk->bp) {
-			blk->disk_blkno = xfs_buf_daddr(blk->bp);
-			blk->bp = NULL;
-		} else {
-			blk->disk_blkno = 0;
-		}
-	}
-
-	/*
-	 * Roll down the "altpath" in the state structure, storing the on-disk
-	 * block number for those buffers in the "altpath".
-	 */
-	path = &state->altpath;
-	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
-	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
-		if (blk->bp) {
-			blk->disk_blkno = xfs_buf_daddr(blk->bp);
-			blk->bp = NULL;
-		} else {
-			blk->disk_blkno = 0;
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Reattach the buffers to the state structure based on the disk block
- * numbers stored in the state structure.
- * This is done after some set of transaction commits have released those
- * buffers from our grip.
- */
-STATIC int
-xfs_attr_refillstate(xfs_da_state_t *state)
-{
-	xfs_da_state_path_t *path;
-	xfs_da_state_blk_t *blk;
-	int level, error;
-
-	trace_xfs_attr_refillstate(state->args);
-
-	/*
-	 * Roll down the "path" in the state structure, storing the on-disk
-	 * block number for those buffers in the "path".
-	 */
-	path = &state->path;
-	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
-	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
-		if (blk->disk_blkno) {
-			error = xfs_da3_node_read_mapped(state->args->trans,
-					state->args->dp, blk->disk_blkno,
-					&blk->bp, XFS_ATTR_FORK);
-			if (error)
-				return error;
-		} else {
-			blk->bp = NULL;
-		}
-	}
-
-	/*
-	 * Roll down the "altpath" in the state structure, storing the on-disk
-	 * block number for those buffers in the "altpath".
-	 */
-	path = &state->altpath;
-	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
-	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
-		if (blk->disk_blkno) {
-			error = xfs_da3_node_read_mapped(state->args->trans,
-					state->args->dp, blk->disk_blkno,
-					&blk->bp, XFS_ATTR_FORK);
-			if (error)
-				return error;
-		} else {
-			blk->bp = NULL;
-		}
-	}
-
-	return 0;
-}
-
 /*
  * Retrieve the attribute data from a node attribute list.
  *
-- 
2.35.1

