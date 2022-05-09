Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB606C43217
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 01:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiEIBaj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 21:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbiEIApg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:36 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A89DBC05
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5D85153457D
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:41 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hd9-BG
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CPX-AG
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/18] xfs: split remote attr setting out from replace path
Date:   Mon,  9 May 2022 10:41:28 +1000
Message-Id: <20220509004138.762556-9-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62786345
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=6UJM7DMw8K4G-EudLrUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we set a new xattr, we have three exit paths:

	1. nothing else to do
	2. allocate and set the remote xattr value
	3. perform the rest of a replace operation

Currently we push both 2 and 3 into the same state, regardless of
whether we just set a remote attribute or not. Once we've set the
remote xattr, we have two exit states:

	1. nothing else to do
	2. perform the rest of a replace operation

Hence we can split the remote xattr allocation and setting into
their own states and factor it out of xfs_attr_set_iter() to further
clean up the state machine and the implementation of the state
machine.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 113 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr.h |  14 +++--
 fs/xfs/xfs_trace.h       |   9 ++--
 3 files changed, 77 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index be580da62f08..d2b29f7e103a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -334,9 +334,11 @@ xfs_attr_leaf_addname(
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	if (args->rmtblkno ||
-	    (args->op_flags & XFS_DA_OP_RENAME)) {
-		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	if (args->rmtblkno) {
+		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
+		error = -EAGAIN;
+	} else if (args->op_flags & XFS_DA_OP_RENAME) {
+		attr->xattri_dela_state = XFS_DAS_LEAF_REPLACE;
 		error = -EAGAIN;
 	} else {
 		attr->xattri_dela_state = XFS_DAS_DONE;
@@ -363,9 +365,11 @@ xfs_attr_node_addname(
 	if (error)
 		return error;
 
-	if (args->rmtblkno ||
-	    (args->op_flags & XFS_DA_OP_RENAME)) {
-		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	if (args->rmtblkno) {
+		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
+		error = -EAGAIN;
+	} else if (args->op_flags & XFS_DA_OP_RENAME) {
+		attr->xattri_dela_state = XFS_DAS_NODE_REPLACE;
 		error = -EAGAIN;
 	} else {
 		attr->xattri_dela_state = XFS_DAS_DONE;
@@ -375,6 +379,40 @@ xfs_attr_node_addname(
 	return error;
 }
 
+static int
+xfs_attr_rmtval_alloc(
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_da_args              *args = attr->xattri_da_args;
+	int				error = 0;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (attr->xattri_blkcnt > 0) {
+		error = xfs_attr_rmtval_set_blk(attr);
+		if (error)
+			return error;
+		error = -EAGAIN;
+		goto out;
+	}
+
+	error = xfs_attr_rmtval_set_value(args);
+	if (error)
+		return error;
+
+	/* If this is not a rename, clear the incomplete flag and we're done. */
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		error = xfs_attr3_leaf_clearflag(args);
+		attr->xattri_dela_state = XFS_DAS_DONE;
+	}
+out:
+	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
+	return error;
+}
 
 /*
  * Set the attribute specified in @args.
@@ -406,54 +444,26 @@ xfs_attr_set_iter(
 	case XFS_DAS_NODE_ADD:
 		return xfs_attr_node_addname(attr);
 
-	case XFS_DAS_FOUND_LBLK:
-	case XFS_DAS_FOUND_NBLK:
-		/*
-		 * Find space for remote blocks and fall into the allocation
-		 * state.
-		 */
-		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(attr);
-			if (error)
-				return error;
-		}
+	case XFS_DAS_LEAF_SET_RMT:
+	case XFS_DAS_NODE_SET_RMT:
+		error = xfs_attr_rmtval_find_space(attr);
+		if (error)
+			return error;
 		attr->xattri_dela_state++;
 		fallthrough;
+
 	case XFS_DAS_LEAF_ALLOC_RMT:
 	case XFS_DAS_NODE_ALLOC_RMT:
-
-		/*
-		 * If there was an out-of-line value, allocate the blocks we
-		 * identified for its storage and copy the value.  This is done
-		 * after we create the attribute so that we don't overflow the
-		 * maximum size of a transaction and/or hit a deadlock.
-		 */
-		if (args->rmtblkno > 0) {
-			if (attr->xattri_blkcnt > 0) {
-				error = xfs_attr_rmtval_set_blk(attr);
-				if (error)
-					return error;
-				trace_xfs_attr_set_iter_return(
-						attr->xattri_dela_state,
-						args->dp);
-				return -EAGAIN;
-			}
-
-			error = xfs_attr_rmtval_set_value(args);
-			if (error)
-				return error;
-		}
-
-		/*
-		 * If this is not a rename, clear the incomplete flag and we're
-		 * done.
-		 */
-		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-			if (args->rmtblkno > 0)
-				error = xfs_attr3_leaf_clearflag(args);
+		error = xfs_attr_rmtval_alloc(attr);
+		if (error)
 			return error;
-		}
+		if (attr->xattri_dela_state == XFS_DAS_DONE)
+			break;
+		attr->xattri_dela_state++;
+		fallthrough;
 
+	case XFS_DAS_LEAF_REPLACE:
+	case XFS_DAS_NODE_REPLACE:
 		/*
 		 * If this is an atomic rename operation, we must "flip" the
 		 * incomplete flags on the "new" and "old" attribute/value pairs
@@ -471,10 +481,9 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series at FLIP_FLAG.
 			 */
+			error = -EAGAIN;
 			attr->xattri_dela_state++;
-			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-						       args->dp);
-			return -EAGAIN;
+			break;
 		}
 
 		attr->xattri_dela_state++;
@@ -549,6 +558,8 @@ xfs_attr_set_iter(
 		ASSERT(0);
 		break;
 	}
+
+	trace_xfs_attr_set_iter_return(attr->xattri_dela_state, args->dp);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 37db61649217..1749fd8f7ddd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -452,15 +452,17 @@ enum xfs_delattr_state {
 	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
 
 	/* Leaf state set sequence */
-	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
+	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a leaf */
 	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
+	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a leaf */
 	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
 	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
 	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
 
 	/* Node state set sequence, must match leaf state above */
-	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
+	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a node */
 	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
+	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a node */
 	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
 	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
 	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
@@ -476,13 +478,15 @@ enum xfs_delattr_state {
 	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
 	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
 	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
-	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
+	{ XFS_DAS_LEAF_SET_RMT,	"XFS_DAS_LEAF_SET_RMT" }, \
 	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
-	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
-	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
+	{ XFS_DAS_LEAF_REPLACE,	"XFS_DAS_LEAF_REPLACE" }, \
 	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
 	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
 	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
+	{ XFS_DAS_NODE_SET_RMT,	"XFS_DAS_NODE_SET_RMT" }, \
+	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
+	{ XFS_DAS_NODE_REPLACE,	"XFS_DAS_NODE_REPLACE" },  \
 	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
 	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
 	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 067ab31d7a20..cb9122327114 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4136,13 +4136,15 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
 TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
-TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
-TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
-TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
 TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
 TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
@@ -4172,6 +4174,7 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
 DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
-- 
2.35.1

