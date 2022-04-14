Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B668DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbiDNJtG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242296AbiDNJsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:16 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AAF3716C0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C3D6310C7957
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00HZKX-2o
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00AWzy-1p
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/16] xfs: xfs_attr_set_iter() does not need to return EAGAIN
Date:   Thu, 14 Apr 2022 19:44:29 +1000
Message-Id: <20220414094434.2508781-12-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6257ed05
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=h6k7380s9PACC-rVqFQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the full xfs_attr_set_iter() state machine always
terminates with either the state being XFS_DAS_DONE on success or
an error on failure, we can get rid of the need for it to return
-EAGAIN whenever it needs to roll the transaction before running
the next state.

That is, we don't need to spray -EAGAIN return states everywhere,
the caller just check the state machine state for completion to
determine what action should be taken next. This greatly simplifies
the code within the state machine implementation as it now only has
to handle 0 for success or -errno for error and it doesn't need to
tell the caller to retry.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 83 +++++++++++++++++-----------------------
 fs/xfs/xfs_attr_item.c   |  2 +
 2 files changed, 37 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9dc08d59e4a6..a509c998e781 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -303,7 +303,6 @@ xfs_attr_sf_addname(
 	 */
 	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
-	error = -EAGAIN;
 out:
 	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
@@ -353,7 +352,6 @@ xfs_attr_leaf_addname(
 		 * retry the add to the newly allocated node block.
 		 */
 		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
-		error = -EAGAIN;
 		goto out;
 	}
 	if (error)
@@ -364,20 +362,24 @@ xfs_attr_leaf_addname(
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	if (args->rmtblkno) {
+	if (args->rmtblkno)
 		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
-		error = -EAGAIN;
-	} else if (args->op_flags & XFS_DA_OP_RENAME) {
+	else if (args->op_flags & XFS_DA_OP_RENAME)
 		xfs_attr_dela_state_set_replace(attr, XFS_DAS_LEAF_REPLACE);
-		error = -EAGAIN;
-	} else {
+	else
 		attr->xattri_dela_state = XFS_DAS_DONE;
-	}
 out:
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
 }
 
+/*
+ * Add an entry to a node format attr tree.
+ *
+ * Note that we might still have a leaf here - xfs_attr_is_leaf() cannot tell
+ * the difference between leaf + remote attr blocks and a node format tree,
+ * so we may still end up having to convert from leaf to node format here.
+ */
 static int
 xfs_attr_node_addname(
 	struct xfs_attr_item	*attr)
@@ -392,19 +394,26 @@ xfs_attr_node_addname(
 		return error;
 
 	error = xfs_attr_node_try_addname(attr);
+	if (error == -ENOSPC) {
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
+		/*
+		 * No state change, we really are in node form now
+		 * but we need the transaction rolled to continue.
+		 */
+		goto out;
+	}
 	if (error)
 		return error;
 
-	if (args->rmtblkno) {
+	if (args->rmtblkno)
 		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
-		error = -EAGAIN;
-	} else if (args->op_flags & XFS_DA_OP_RENAME) {
+	else if (args->op_flags & XFS_DA_OP_RENAME)
 		xfs_attr_dela_state_set_replace(attr, XFS_DAS_NODE_REPLACE);
-		error = -EAGAIN;
-	} else {
+	else
 		attr->xattri_dela_state = XFS_DAS_DONE;
-	}
-
+out:
 	trace_xfs_attr_node_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
 }
@@ -426,7 +435,6 @@ xfs_attr_rmtval_alloc(
 		error = xfs_attr_rmtval_set_blk(attr);
 		if (error)
 			return error;
-		error = -EAGAIN;
 		goto out;
 	}
 
@@ -482,11 +490,12 @@ xfs_attr_leaf_remove_attr(
 }
 
 /*
- * Set the attribute specified in @args.
- * This routine is meant to function as a delayed operation, and may return
- * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
- * to handle this, and recall the function until a successful error code is
- * returned.
+ * Run the attribute operation specified in @attr.
+ *
+ * This routine is meant to function as a delayed operation and will set the
+ * state to XFS_DAS_DONE when the operation is complete.  Calling functions will
+ * need to handle this, and recall the function until either an error or
+ * XFS_DAS_DONE is detected.
  */
 int
 xfs_attr_set_iter(
@@ -547,7 +556,6 @@ xfs_attr_set_iter(
 		 * We must commit the flag value change now to make it atomic
 		 * and then we can start the next trans in series at REMOVE_OLD.
 		 */
-		error = -EAGAIN;
 		attr->xattri_dela_state++;
 		break;
 
@@ -575,8 +583,10 @@ xfs_attr_set_iter(
 	case XFS_DAS_LEAF_REMOVE_RMT:
 	case XFS_DAS_NODE_REMOVE_RMT:
 		error = xfs_attr_rmtval_remove(attr);
-		if (error == -EAGAIN)
+		if (error == -EAGAIN) {
+			error = 0;
 			break;
+		}
 		if (error)
 			return error;
 
@@ -588,7 +598,6 @@ xfs_attr_set_iter(
 		 * can't do that in the same transaction where we removed the
 		 * remote attr blocks.
 		 */
-		error = -EAGAIN;
 		attr->xattri_dela_state++;
 		break;
 
@@ -1200,14 +1209,6 @@ xfs_attr_node_addname_find_attr(
  * This will involve walking down the Btree, and may involve splitting
  * leaf nodes and even splitting intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- *
- * This routine is meant to function as a delayed operation, and may return
- * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
- * to handle this, and recall the function until a successful error code is
- *returned.
  */
 static int
 xfs_attr_node_try_addname(
@@ -1229,24 +1230,10 @@ xfs_attr_node_try_addname(
 			/*
 			 * Its really a single leaf node, but it had
 			 * out-of-line values so it looked like it *might*
-			 * have been a b-tree.
+			 * have been a b-tree. Let the caller deal with this.
 			 */
 			xfs_da_state_free(state);
-			state = NULL;
-			error = xfs_attr3_leaf_to_node(args);
-			if (error)
-				goto out;
-
-			/*
-			 * Now that we have converted the leaf to a node, we can
-			 * roll the transaction, and try xfs_attr3_leaf_add
-			 * again on re-entry.  No need to set dela_state to do
-			 * this. dela_state is still unset by this function at
-			 * this point.
-			 */
-			trace_xfs_attr_node_addname_return(
-					attr->xattri_dela_state, args->dp);
-			return -EAGAIN;
+			return -ENOSPC;
 		}
 
 		/*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index b6561861ef01..f2de86756287 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -314,6 +314,8 @@ xfs_xattri_finish_update(
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		error = xfs_attr_set_iter(attr);
+		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
+			error = -EAGAIN;
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
-- 
2.35.1

