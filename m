Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910F2C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbiDNJsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbiDNJsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:15 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16D4B78052
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C4F70534577
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00HZKb-48
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00AX04-2i
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: introduce attr remove initial states into xfs_attr_set_iter
Date:   Thu, 14 Apr 2022 19:44:30 +1000
Message-Id: <20220414094434.2508781-13-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6257ed06
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=Coy4TuuiO9G2m3U92GUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Ground work to enable safe recovery of replace operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 139 ++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h |   4 ++
 fs/xfs/xfs_trace.h       |   3 +
 3 files changed, 84 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a509c998e781..8665b74ddfaf 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -459,6 +459,68 @@ xfs_attr_rmtval_alloc(
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
@@ -517,6 +579,21 @@ xfs_attr_set_iter(
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
@@ -1334,68 +1411,6 @@ xfs_attr_node_shrink(
 	return error;
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
index f4f78d841857..e4b11ac243d7 100644
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
index 3a215d298e62..c85bab6215e1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4105,6 +4105,9 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
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

