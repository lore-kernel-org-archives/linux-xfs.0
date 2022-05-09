Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04895C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiEIB3h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 21:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiEIApf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:35 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 652536573
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7EA8210E6403
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:41 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hdO-Gs
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CPx-FZ
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/18] xfs: introduce attr remove initial states into xfs_attr_set_iter
Date:   Mon,  9 May 2022 10:41:33 +1000
Message-Id: <20220509004138.762556-14-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62786345
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=YGz1zjWgr2h1Gk-NCmIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We need to merge the add and remove code paths to enable safe
recovery of replace operations. Hoist the initial remove states from
xfs_attr_remove_iter into xfs_attr_set_iter. We will make use of
them in the next patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 139 ++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h |   4 ++
 fs/xfs/xfs_trace.h       |   3 +
 3 files changed, 84 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 89e68d9e22c0..a6a9b1f8dce6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -451,6 +451,68 @@ xfs_attr_rmtval_alloc(
 	return error;
 }
 
+/*
+ * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
+ * for later deletion of the entry.
+ */
+static int
+xfs_attr_leaf_mark_incomplete(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	int			error;
+
+	/*
+	 * Fill in disk block numbers in the state structure
+	 * so that we can get the buffers back after we commit
+	 * several transactions in the following calls.
+	 */
+	error = xfs_attr_fillstate(state);
+	if (error)
+		return error;
+
+	/*
+	 * Mark the attribute as INCOMPLETE
+	 */
+	return xfs_attr3_leaf_setflag(args);
+}
+
+/*
+ * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
+ * the blocks are valid.  Attr keys with remote blocks will be marked
+ * incomplete.
+ */
+static
+int xfs_attr_node_removename_setup(
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
+	int				error;
+
+	error = xfs_attr_node_hasname(args, state);
+	if (error != -EEXIST)
+		goto out;
+	error = 0;
+
+	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
+	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
+		XFS_ATTR_LEAF_MAGIC);
+
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_leaf_mark_incomplete(args, *state);
+		if (error)
+			goto out;
+
+		error = xfs_attr_rmtval_invalidate(args);
+	}
+out:
+	if (error)
+		xfs_da_state_free(*state);
+
+	return error;
+}
+
 /*
  * Remove the original attr we have just replaced. This is dependent on the
  * original lookup and insert placing the old attr in args->blkno/args->index
@@ -550,6 +612,21 @@ xfs_attr_set_iter(
 	case XFS_DAS_NODE_ADD:
 		return xfs_attr_node_addname(attr);
 
+	case XFS_DAS_SF_REMOVE:
+		attr->xattri_dela_state = XFS_DAS_DONE;
+		return xfs_attr_sf_removename(args);
+	case XFS_DAS_LEAF_REMOVE:
+		attr->xattri_dela_state = XFS_DAS_DONE;
+		return xfs_attr_leaf_removename(args);
+	case XFS_DAS_NODE_REMOVE:
+		error = xfs_attr_node_removename_setup(attr);
+		if (error)
+			return error;
+		attr->xattri_dela_state = XFS_DAS_NODE_REMOVE_RMT;
+		if (args->rmtblkno == 0)
+			attr->xattri_dela_state++;
+		break;
+
 	case XFS_DAS_LEAF_SET_RMT:
 	case XFS_DAS_NODE_SET_RMT:
 		error = xfs_attr_rmtval_find_space(attr);
@@ -1351,68 +1428,6 @@ xfs_attr_node_remove_attr(
 }
 
 
-/*
- * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
- * for later deletion of the entry.
- */
-STATIC int
-xfs_attr_leaf_mark_incomplete(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	int			error;
-
-	/*
-	 * Fill in disk block numbers in the state structure
-	 * so that we can get the buffers back after we commit
-	 * several transactions in the following calls.
-	 */
-	error = xfs_attr_fillstate(state);
-	if (error)
-		return error;
-
-	/*
-	 * Mark the attribute as INCOMPLETE
-	 */
-	return xfs_attr3_leaf_setflag(args);
-}
-
-/*
- * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
- * the blocks are valid.  Attr keys with remote blocks will be marked
- * incomplete.
- */
-STATIC
-int xfs_attr_node_removename_setup(
-	struct xfs_attr_item		*attr)
-{
-	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_da_state		**state = &attr->xattri_da_state;
-	int				error;
-
-	error = xfs_attr_node_hasname(args, state);
-	if (error != -EEXIST)
-		goto out;
-	error = 0;
-
-	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
-	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
-		XFS_ATTR_LEAF_MAGIC);
-
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_leaf_mark_incomplete(args, *state);
-		if (error)
-			goto out;
-
-		error = xfs_attr_rmtval_invalidate(args);
-	}
-out:
-	if (error)
-		xfs_da_state_free(*state);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_node_removename(
 	struct xfs_da_args	*args,
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index c318260f17d4..7ea7c7fa31ac 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -451,6 +451,10 @@ enum xfs_delattr_state {
 	XFS_DAS_RM_NAME,		/* Remove attr name */
 	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
 
+	XFS_DAS_SF_REMOVE,		/* Initial shortform set iter state */
+	XFS_DAS_LEAF_REMOVE,		/* Initial leaf form set iter state */
+	XFS_DAS_NODE_REMOVE,		/* Initial node form set iter state */
+
 	/* Leaf state set/replace sequence */
 	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a leaf */
 	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 260760ce2d05..01b047d86cd1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4136,6 +4136,9 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
 TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
+TRACE_DEFINE_ENUM(XFS_DAS_SF_REMOVE);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
-- 
2.35.1

