Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0809AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiDLE2L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243444AbiDLE2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:07 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CBAF32995
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5763C10C7BB8;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne866-00Gh2g-4Z; Tue, 12 Apr 2022 14:25:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne866-009Nrq-33;
        Tue, 12 Apr 2022 14:25:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 08/10] xfs: remote xattr removal in xfs_attr_set_iter() is conditional
Date:   Tue, 12 Apr 2022 14:25:41 +1000
Message-Id: <20220412042543.2234866-9-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=0S6kOs-DtnbvdYliHJcA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We may not have a remote value for the old xattr we have to remove,
so skip over the remote value removal states and go straight to
the xattr name removal in the leaf/node block.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 59 ++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h |  8 +++---
 fs/xfs/xfs_trace.h       |  4 +--
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 27fa94d1c4db..09490fcd1e28 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -488,15 +488,14 @@ xfs_attr_set_iter(
 		/*
 		 * We must "flip" the incomplete flags on the "new" and "old"
 		 * attribute/value pairs so that one disappears and one appears
-		 * atomically.  Then we must remove the "old" attribute/value
-		 * pair.
+		 * atomically.
 		 */
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
 		/*
-		 * Commit the flag value change and start the next trans
-		 * in series at REMOVE_OLD.
+		 * We must commit the flag value change now to make it atomic
+		 * and then we can start the next trans in series at REMOVE_OLD.
 		 */
 		error = -EAGAIN;
 		attr->xattri_dela_state++;
@@ -505,41 +504,43 @@ xfs_attr_set_iter(
 	case XFS_DAS_LEAF_REMOVE_OLD:
 	case XFS_DAS_NODE_REMOVE_OLD:
 		/*
-		 * Dismantle the "old" attribute/value pair by removing a
-		 * "remote" value (if it exists).
+		 * If we have a remote attr, start the process of removing it
+		 * by invalidating any cached buffers.
+		 *
+		 * If we don't have a remote attr, we skip the remote block
+		 * removal state altogether with a second state increment.
 		 */
 		xfs_attr_restore_rmt_blk(args);
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		attr->xattri_dela_state++;
-		fallthrough;
-	case XFS_DAS_RM_LBLK:
-	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(attr);
-			if (error == -EAGAIN)
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
+			error = xfs_attr_rmtval_invalidate(args);
 			if (error)
 				return error;
-
-			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
-			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-						       args->dp);
-			return -EAGAIN;
+		} else {
+			attr->xattri_dela_state++;
 		}
 
+		attr->xattri_dela_state++;
+		goto next_state;
+
+	case XFS_DAS_LEAF_REMOVE_RMT:
+	case XFS_DAS_NODE_REMOVE_RMT:
+		error = xfs_attr_rmtval_remove(attr);
+		if (error == -EAGAIN)
+			break;
+		if (error)
+			return error;
+
 		/*
-		 * This is the end of the shared leaf/node sequence. We need
-		 * to continue at the next state in the sequence, but we can't
-		 * easily just fall through. So we increment to the next state
-		 * and then jump back to switch statement to evaluate the next
-		 * state correctly.
+		 * We've finished removing the remote attr blocks, so commit the
+		 * transaction and move on to removing the attr name from the
+		 * leaf/node block. Removing the attr might require a full
+		 * transaction reservation for btree block freeing, so we
+		 * can't do that in the same transaction where we removed the
+		 * remote attr blocks.
 		 */
+		error = -EAGAIN;
 		attr->xattri_dela_state++;
-		goto next_state;
+		break;
 
 	case XFS_DAS_RD_LEAF:
 		/*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index a4ff0a2305d6..18e157bf19cb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -456,7 +456,7 @@ enum xfs_delattr_state {
 	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a leaf */
 	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf */
-	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
+	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks */
 	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
 
 	/* Node state set sequence, must match leaf state above */
@@ -464,7 +464,7 @@ enum xfs_delattr_state {
 	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a node */
 	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node */
-	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
+	XFS_DAS_NODE_REMOVE_RMT,	/* A rename is removing remote blocks */
 	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
 
 	XFS_DAS_DONE,			/* finished operation */
@@ -482,13 +482,13 @@ enum xfs_delattr_state {
 	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
 	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
 	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" }, \
-	{ XFS_DAS_RM_LBLK,		"XFS_DAS_RM_LBLK" }, \
+	{ XFS_DAS_LEAF_REMOVE_RMT,	"XFS_DAS_LEAF_REMOVE_RMT" }, \
 	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
 	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
 	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
 	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
 	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" }, \
-	{ XFS_DAS_RM_NBLK,		"XFS_DAS_RM_NBLK" }, \
+	{ XFS_DAS_NODE_REMOVE_RMT,	"XFS_DAS_NODE_REMOVE_RMT" }, \
 	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
 	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a4b99c7f8ef0..91852b9721e4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4109,13 +4109,13 @@ TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
-TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
-TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
 
 DECLARE_EVENT_CLASS(xfs_das_state_class,
-- 
2.35.1

