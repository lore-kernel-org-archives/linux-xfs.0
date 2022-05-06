Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C05DC43217
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390707AbiEFJt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 05:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390706AbiEFJtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 05:49:45 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D61066F98
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:46:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2BB80534626
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 19:45:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-008fMk-Up
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 19:45:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-0029Ti-U5
        for linux-xfs@vger.kernel.org;
        Fri, 06 May 2022 19:45:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/17] xfs: xfs_attr_set_iter() does not need to return EAGAIN
Date:   Fri,  6 May 2022 19:45:48 +1000
Message-Id: <20220506094553.512973-13-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506094553.512973-1-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6274ee56
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=Gim71dvWPD5AZUqq42QA:9
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
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 86 +++++++++++++++++-----------------------
 fs/xfs/xfs_attr_item.c   |  2 +
 2 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3457847e97ef..39d7046d8970 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -290,7 +290,6 @@ xfs_attr_sf_addname(
 	 */
 	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
-	error = -EAGAIN;
 out:
 	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
@@ -343,7 +342,6 @@ xfs_attr_leaf_addname(
 		 * retry the add to the newly allocated node block.
 		 */
 		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
-		error = -EAGAIN;
 		goto out;
 	}
 	if (error)
@@ -354,20 +352,24 @@ xfs_attr_leaf_addname(
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
@@ -382,19 +384,26 @@ xfs_attr_node_addname(
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
@@ -417,10 +426,8 @@ xfs_attr_rmtval_alloc(
 		if (error)
 			return error;
 		/* Roll the transaction only if there is more to allocate. */
-		if (attr->xattri_blkcnt > 0) {
-			error = -EAGAIN;
+		if (attr->xattri_blkcnt > 0)
 			goto out;
-		}
 	}
 
 	error = xfs_attr_rmtval_set_value(args);
@@ -475,11 +482,12 @@ xfs_attr_leaf_remove_attr(
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
@@ -532,7 +540,6 @@ xfs_attr_set_iter(
 		 * We must commit the flag value change now to make it atomic
 		 * and then we can start the next trans in series at REMOVE_OLD.
 		 */
-		error = -EAGAIN;
 		attr->xattri_dela_state++;
 		break;
 
@@ -560,8 +567,10 @@ xfs_attr_set_iter(
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
 
@@ -573,7 +582,6 @@ xfs_attr_set_iter(
 		 * can't do that in the same transaction where we removed the
 		 * remote attr blocks.
 		 */
-		error = -EAGAIN;
 		attr->xattri_dela_state++;
 		break;
 
@@ -1207,14 +1215,6 @@ xfs_attr_node_addname_find_attr(
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
@@ -1236,24 +1236,10 @@ xfs_attr_node_try_addname(
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
index 5bfb33746e37..740a55d07660 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -313,6 +313,8 @@ xfs_xattri_finish_update(
 	case XFS_ATTR_OP_FLAGS_SET:
 	case XFS_ATTR_OP_FLAGS_REPLACE:
 		error = xfs_attr_set_iter(attr);
+		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
+			error = -EAGAIN;
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
-- 
2.35.1

