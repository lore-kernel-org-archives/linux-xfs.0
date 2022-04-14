Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7654AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbiDNJsu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242283AbiDNJsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:15 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C80878044
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C5C37534578
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00HZKh-6W
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00AX0E-5Q
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: remove xfs_attri_remove_iter
Date:   Thu, 14 Apr 2022 19:44:32 +1000
Message-Id: <20220414094434.2508781-15-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6257ed06
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=xyUtrdob7fCUx3CpiMYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_attri_remove_iter is not used anymore, so remove it and all the
infrastructure it uses and is needed to drive it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 210 ++++-----------------------------------
 1 file changed, 18 insertions(+), 192 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ccc72c0c3cf5..34c31077b08f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1340,6 +1340,24 @@ xfs_attr_node_try_addname(
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
@@ -1382,198 +1400,6 @@ xfs_attr_node_remove_attr(
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
 /*
  * Fill in the disk block numbers in the state structure for the buffers
  * that are attached to the state structure.
-- 
2.35.1

