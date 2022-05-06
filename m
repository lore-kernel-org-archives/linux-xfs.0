Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F96C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390730AbiEFJtq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390682AbiEFJto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 05:49:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E755565D30
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:46:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D46C7534624
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 19:45:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-008fMc-RI
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 19:45:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-0029TT-Q7
        for linux-xfs@vger.kernel.org;
        Fri, 06 May 2022 19:45:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/17] xfs: XFS_DAS_LEAF_REPLACE state only needed if !LARP
Date:   Fri,  6 May 2022 19:45:45 +1000
Message-Id: <20220506094553.512973-10-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506094553.512973-1-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6274ee55
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=PrrlBD9mbrQCzPW2O-0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We can skip the REPLACE state when LARP is enabled, but that means
the XFS_DAS_FLIP_LFLAG state is now poorly named - it indicates
something that has been done rather than what the state is going to
do. Rename it to "REMOVE_OLD" to indicate that we are now going to
perform removal of the old attr.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 81 +++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h | 44 +++++++++++-----------
 fs/xfs/xfs_trace.h       |  4 +-
 3 files changed, 75 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d2b29f7e103a..0f4636e2e246 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -296,6 +296,26 @@ xfs_attr_sf_addname(
 	return error;
 }
 
+/*
+ * When we bump the state to REPLACE, we may actually need to skip over the
+ * state. When LARP mode is enabled, we don't need to run the atomic flags flip,
+ * so we skip straight over the REPLACE state and go on to REMOVE_OLD.
+ */
+static void
+xfs_attr_dela_state_set_replace(
+	struct xfs_attr_item	*attr,
+	enum xfs_delattr_state	replace)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+
+	ASSERT(replace == XFS_DAS_LEAF_REPLACE ||
+			replace == XFS_DAS_NODE_REPLACE);
+
+	attr->xattri_dela_state = replace;
+	if (xfs_has_larp(args->dp->i_mount))
+		attr->xattri_dela_state++;
+}
+
 static int
 xfs_attr_leaf_addname(
 	struct xfs_attr_item	*attr)
@@ -338,7 +358,7 @@ xfs_attr_leaf_addname(
 		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
 		error = -EAGAIN;
 	} else if (args->op_flags & XFS_DA_OP_RENAME) {
-		attr->xattri_dela_state = XFS_DAS_LEAF_REPLACE;
+		xfs_attr_dela_state_set_replace(attr, XFS_DAS_LEAF_REPLACE);
 		error = -EAGAIN;
 	} else {
 		attr->xattri_dela_state = XFS_DAS_DONE;
@@ -369,7 +389,7 @@ xfs_attr_node_addname(
 		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
 		error = -EAGAIN;
 	} else if (args->op_flags & XFS_DA_OP_RENAME) {
-		attr->xattri_dela_state = XFS_DAS_NODE_REPLACE;
+		xfs_attr_dela_state_set_replace(attr, XFS_DAS_NODE_REPLACE);
 		error = -EAGAIN;
 	} else {
 		attr->xattri_dela_state = XFS_DAS_DONE;
@@ -396,8 +416,11 @@ xfs_attr_rmtval_alloc(
 		error = xfs_attr_rmtval_set_blk(attr);
 		if (error)
 			return error;
-		error = -EAGAIN;
-		goto out;
+		/* Roll the transaction only if there is more to allocate. */
+		if (attr->xattri_blkcnt > 0) {
+			error = -EAGAIN;
+			goto out;
+		}
 	}
 
 	error = xfs_attr_rmtval_set_value(args);
@@ -408,6 +431,13 @@ xfs_attr_rmtval_alloc(
 	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
 		error = xfs_attr3_leaf_clearflag(args);
 		attr->xattri_dela_state = XFS_DAS_DONE;
+	} else {
+		/*
+		 * We are running a REPLACE operation, so we need to bump the
+		 * state to the step in that operation.
+		 */
+		attr->xattri_dela_state++;
+		xfs_attr_dela_state_set_replace(attr, attr->xattri_dela_state);
 	}
 out:
 	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
@@ -429,7 +459,6 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
-	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 next_state:
@@ -459,37 +488,29 @@ xfs_attr_set_iter(
 			return error;
 		if (attr->xattri_dela_state == XFS_DAS_DONE)
 			break;
-		attr->xattri_dela_state++;
-		fallthrough;
+		goto next_state;
 
 	case XFS_DAS_LEAF_REPLACE:
 	case XFS_DAS_NODE_REPLACE:
 		/*
-		 * If this is an atomic rename operation, we must "flip" the
-		 * incomplete flags on the "new" and "old" attribute/value pairs
-		 * so that one disappears and one appears atomically.  Then we
-		 * must remove the "old" attribute/value pair.
-		 *
-		 * In a separate transaction, set the incomplete flag on the
-		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 * We must "flip" the incomplete flags on the "new" and "old"
+		 * attribute/value pairs so that one disappears and one appears
+		 * atomically.  Then we must remove the "old" attribute/value
+		 * pair.
 		 */
-		if (!xfs_has_larp(mp)) {
-			error = xfs_attr3_leaf_flipflags(args);
-			if (error)
-				return error;
-			/*
-			 * Commit the flag value change and start the next trans
-			 * in series at FLIP_FLAG.
-			 */
-			error = -EAGAIN;
-			attr->xattri_dela_state++;
-			break;
-		}
-
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans
+		 * in series at REMOVE_OLD.
+		 */
+		error = -EAGAIN;
 		attr->xattri_dela_state++;
-		fallthrough;
-	case XFS_DAS_FLIP_LFLAG:
-	case XFS_DAS_FLIP_NFLAG:
+		break;
+
+	case XFS_DAS_LEAF_REMOVE_OLD:
+	case XFS_DAS_NODE_REMOVE_OLD:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
 		 * "remote" value (if it exists).
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1749fd8f7ddd..3f1234272f3a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -455,7 +455,7 @@ enum xfs_delattr_state {
 	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a leaf */
 	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a leaf */
-	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf */
 	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
 	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
 
@@ -463,7 +463,7 @@ enum xfs_delattr_state {
 	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a node */
 	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a node */
-	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
+	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node */
 	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
 	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
 
@@ -471,26 +471,26 @@ enum xfs_delattr_state {
 };
 
 #define XFS_DAS_STRINGS	\
-	{ XFS_DAS_UNINIT,	"XFS_DAS_UNINIT" }, \
-	{ XFS_DAS_SF_ADD,	"XFS_DAS_SF_ADD" }, \
-	{ XFS_DAS_LEAF_ADD,	"XFS_DAS_LEAF_ADD" }, \
-	{ XFS_DAS_NODE_ADD,	"XFS_DAS_NODE_ADD" }, \
-	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
-	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
-	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
-	{ XFS_DAS_LEAF_SET_RMT,	"XFS_DAS_LEAF_SET_RMT" }, \
-	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
-	{ XFS_DAS_LEAF_REPLACE,	"XFS_DAS_LEAF_REPLACE" }, \
-	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
-	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
-	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
-	{ XFS_DAS_NODE_SET_RMT,	"XFS_DAS_NODE_SET_RMT" }, \
-	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
-	{ XFS_DAS_NODE_REPLACE,	"XFS_DAS_NODE_REPLACE" },  \
-	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
-	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
-	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
-	{ XFS_DAS_DONE,		"XFS_DAS_DONE" }
+	{ XFS_DAS_UNINIT,		"XFS_DAS_UNINIT" }, \
+	{ XFS_DAS_SF_ADD,		"XFS_DAS_SF_ADD" }, \
+	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
+	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
+	{ XFS_DAS_RMTBLK,		"XFS_DAS_RMTBLK" }, \
+	{ XFS_DAS_RM_NAME,		"XFS_DAS_RM_NAME" }, \
+	{ XFS_DAS_RM_SHRINK,		"XFS_DAS_RM_SHRINK" }, \
+	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
+	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
+	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
+	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" }, \
+	{ XFS_DAS_RM_LBLK,		"XFS_DAS_RM_LBLK" }, \
+	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
+	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
+	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
+	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
+	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" }, \
+	{ XFS_DAS_RM_NBLK,		"XFS_DAS_RM_NBLK" }, \
+	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
+	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
 
 /*
  * Defines for xfs_attr_item.xattri_flags
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cb9122327114..b528c0f375c2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4139,13 +4139,13 @@ TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
-TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
-TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
 
-- 
2.35.1

