Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C373C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbiDNJsu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbiDNJsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:16 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50A067A986
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C9E9A10C797B
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00HZKE-TS
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00AWzW-SN
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/16] xfs: consolidate leaf/node states in xfs_attr_set_iter
Date:   Thu, 14 Apr 2022 19:44:24 +1000
Message-Id: <20220414094434.2508781-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6257ed06
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=sSY1SZa-z43ULZiO_Y8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The operations performed from XFS_DAS_FOUND_LBLK through to
XFS_DAS_RM_LBLK are now identical to XFS_DAS_FOUND_NBLK through to
XFS_DAS_RM_NBLK. We can collapse these down into a single set of
code.

To do this, define the states that leaf and node run through as
separate sets of sequential states. Then as we move to the next
state, we can use increments rather than specific state assignments
to move through the states. This means the state progression is set
by the initial state that enters the series and we don't need to
duplicate the code anymore.

At the exit point of the series we need to select the correct leaf
or node state, but that can also be done by state increment rather
than assignment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 127 ++++++---------------------------------
 fs/xfs/libxfs/xfs_attr.h |   9 ++-
 2 files changed, 27 insertions(+), 109 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fed476bd048e..655e4388dfec 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -407,6 +407,7 @@ xfs_attr_set_iter(
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
+next_state:
 	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		ASSERT(0);
@@ -419,6 +420,7 @@ xfs_attr_set_iter(
 		return xfs_attr_node_addname(attr);
 
 	case XFS_DAS_FOUND_LBLK:
+	case XFS_DAS_FOUND_NBLK:
 		/*
 		 * Find space for remote blocks and fall into the allocation
 		 * state.
@@ -428,9 +430,10 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 		}
-		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
+		attr->xattri_dela_state++;
 		fallthrough;
 	case XFS_DAS_LEAF_ALLOC_RMT:
+	case XFS_DAS_NODE_ALLOC_RMT:
 
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
@@ -479,16 +482,18 @@ xfs_attr_set_iter(
 				return error;
 			/*
 			 * Commit the flag value change and start the next trans
-			 * in series.
+			 * in series at FLIP_FLAG.
 			 */
-			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+			attr->xattri_dela_state++;
 			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
 
+		attr->xattri_dela_state++;
 		fallthrough;
 	case XFS_DAS_FLIP_LFLAG:
+	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
 		 * "remote" value (if it exists).
@@ -498,10 +503,10 @@ xfs_attr_set_iter(
 		if (error)
 			return error;
 
+		attr->xattri_dela_state++;
 		fallthrough;
 	case XFS_DAS_RM_LBLK:
-		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
+	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
 			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
@@ -516,7 +521,16 @@ xfs_attr_set_iter(
 			return -EAGAIN;
 		}
 
-		fallthrough;
+		/*
+		 * This is the end of the shared leaf/node sequence. We need
+		 * to continue at the next state in the sequence, but we can't
+		 * easily just fall through. So we increment to the next state
+		 * and then jump back to switch statement to evaluate the next
+		 * state correctly.
+		 */
+		attr->xattri_dela_state++;
+		goto next_state;
+
 	case XFS_DAS_RD_LEAF:
 		/*
 		 * This is the last step for leaf format. Read the block with
@@ -537,106 +551,6 @@ xfs_attr_set_iter(
 
 		return error;
 
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
-
-		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
-		fallthrough;
-	case XFS_DAS_NODE_ALLOC_RMT:
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
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			}
-
-			error = xfs_attr_rmtval_set_value(args);
-			if (error)
-				return error;
-		}
-
-		/*
-		 * If this was not a rename, clear the incomplete flag and we're
-		 * done.
-		 */
-		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-			if (args->rmtblkno > 0)
-				error = xfs_attr3_leaf_clearflag(args);
-			goto out;
-		}
-
-		/*
-		 * If this is an atomic rename operation, we must "flip" the
-		 * incomplete flags on the "new" and "old" attribute/value pairs
-		 * so that one disappears and one appears atomically.  Then we
-		 * must remove the "old" attribute/value pair.
-		 *
-		 * In a separate transaction, set the incomplete flag on the
-		 * "old" attr and clear the incomplete flag on the "new" attr.
-		 */
-		if (!xfs_has_larp(mp)) {
-			error = xfs_attr3_leaf_flipflags(args);
-			if (error)
-				goto out;
-			/*
-			 * Commit the flag value change and start the next trans
-			 * in series
-			 */
-			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
-			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-						       args->dp);
-			return -EAGAIN;
-		}
-
-		fallthrough;
-	case XFS_DAS_FLIP_NFLAG:
-		/*
-		 * Dismantle the "old" attribute/value pair by removing a
-		 * "remote" value (if it exists).
-		 */
-		xfs_attr_restore_rmt_blk(args);
-
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		fallthrough;
-	case XFS_DAS_RM_NBLK:
-		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
-		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(attr);
-			if (error == -EAGAIN)
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-
-			if (error)
-				return error;
-
-			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
-			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-						       args->dp);
-			return -EAGAIN;
-		}
-
-		fallthrough;
 	case XFS_DAS_CLR_FLAG:
 		/*
 		 * The last state for node format. Look up the old attr and
@@ -648,7 +562,6 @@ xfs_attr_set_iter(
 		ASSERT(0);
 		break;
 	}
-out:
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 184dca735cf3..0ad78f9279ac 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -450,16 +450,21 @@ enum xfs_delattr_state {
 	XFS_DAS_RMTBLK,			/* Removing remote blks */
 	XFS_DAS_RM_NAME,		/* Remove attr name */
 	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
+
+	/* Leaf state set sequence */
 	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
 	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
-	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
-	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
 	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
 	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
+
+	/* Node state set sequence, must match leaf state above */
+	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
+	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
 	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
 	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
+
 	XFS_DAS_DONE,			/* finished operation */
 };
 
-- 
2.35.1

