Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3FAC43217
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345839AbiDLE2Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345827AbiDLE2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:11 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02CFB32991
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9BAB610C7C1B;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne866-00Gh2V-20; Tue, 12 Apr 2022 14:25:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne866-009Nrf-0w;
        Tue, 12 Apr 2022 14:25:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 06/10] xfs: split remote attr setting out from replace path
Date:   Tue, 12 Apr 2022 14:25:39 +1000
Message-Id: <20220412042543.2234866-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=58BS8la1inLbC0avub8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we set a new xattr, we have three exit paths:

	1. nothign else to do
	2. allocate and set the remote xattr value
	3. perform the rest of a replace operation

Currently we push both 2 and 3 into the same state, regardless of
whether we just set a remote attribute or not. Once we've set the
remote xattr, we have two exit states:

	1. nothign else to do
	2. perform the rest of a replace operation

Hence we can split the remote xattr allocation and setting into
their own states and factor it out of xfs_attr_set_iter() to further
clean up the state machine and the implementation of the state
machine.


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 113 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr.h |  14 +++--
 fs/xfs/xfs_trace.h       |   9 ++--
 3 files changed, 77 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 655e4388dfec..4b9c107fe5de 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -347,9 +347,11 @@ xfs_attr_leaf_addname(
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
@@ -376,9 +378,11 @@ xfs_attr_node_addname(
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
@@ -388,6 +392,40 @@ xfs_attr_node_addname(
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
@@ -419,54 +457,26 @@ xfs_attr_set_iter(
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
@@ -484,10 +494,9 @@ xfs_attr_set_iter(
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
@@ -562,6 +571,8 @@ xfs_attr_set_iter(
 		ASSERT(0);
 		break;
 	}
+
+	trace_xfs_attr_set_iter_return(attr->xattri_dela_state, args->dp);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0ad78f9279ac..1de6c06b7f19 100644
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
index 8739cc1e0561..cf99efc5ba5a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4105,13 +4105,15 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
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
@@ -4141,6 +4143,7 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 
 TRACE_EVENT(xfs_force_shutdown,
-- 
2.35.1

