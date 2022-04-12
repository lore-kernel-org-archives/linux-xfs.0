Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBED3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244464AbiDLE2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344502AbiDLE2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:09 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C4363298F
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 655B2534696;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-00Gh2P-Ux; Tue, 12 Apr 2022 14:25:45 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-009NrQ-Tl;
        Tue, 12 Apr 2022 14:25:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 03/10] xfs: separate out initial attr_set states
Date:   Tue, 12 Apr 2022 14:25:36 +1000
Message-Id: <20220412042543.2234866-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=1pSoUot-eWrqs-dKmUYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We current use XFS_DAS_UNINIT for several steps in the attr_set
state machine. We use it for setting shortform xattrs, converting
from shortform to leaf, leaf add, leaf-to-node and leaf add. All of
these things are essentially known before we start the state machine
iterating, so we really should separate them out:

XFS_DAS_SF_ADD:
	- tries to do a shortform add
	- on success -> done
	- on ENOSPC converts to leaf, -> XFS_DAS_LEAF_ADD
	- on error, dies.

XFS_DAS_LEAF_ADD:
	- tries to do leaf add
	- on success:
		- inline attr -> done
		- remote xattr || REPLACE -> XFS_DAS_FOUND_LBLK
	- on ENOSPC converts to node, -> XFS_DAS_NODE_ADD
	- on error, dies

XFS_DAS_NODE_ADD:
	- tries to do node add
	- on success:
		- inline attr -> done
		- remote xattr || REPLACE -> XFS_DAS_FOUND_NBLK
	- on error, dies

This makes it easier to understand how the state machine starts
up and sets us up on the path to further state machine
simplifications.

This also converts the DAS state tracepoints to use strings rather
than numbers, as converting between enums and numbers requires
manual counting rather than just reading the name.

This also introduces a XFS_DAS_DONE state so that we can trace
successful operation completions easily.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 151 ++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h |  49 +++++++++----
 fs/xfs/xfs_trace.h       |  22 +++++-
 3 files changed, 140 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a4b0b20a3bab..b0bbf827fbca 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -59,7 +59,7 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -224,6 +224,11 @@ xfs_init_attr_trans(
 	}
 }
 
+/*
+ * Add an attr to a shortform fork. If there is no space,
+ * xfs_attr_shortform_addname() will convert to leaf format and return -ENOSPC.
+ * to use.
+ */
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
@@ -268,7 +273,7 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-STATIC int
+static int
 xfs_attr_sf_addname(
 	struct xfs_attr_item		*attr)
 {
@@ -276,14 +281,12 @@ xfs_attr_sf_addname(
 	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
 	error = xfs_attr_try_sf_addname(dp, args);
-
-	/* Should only be 0, -EEXIST or -ENOSPC */
-	if (error != -ENOSPC)
-		return error;
+	if (error != -ENOSPC) {
+		ASSERT(!error || error == -EEXIST);
+		attr->xattri_dela_state = XFS_DAS_DONE;
+		goto out;
+	}
 
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
@@ -299,64 +302,42 @@ xfs_attr_sf_addname(
 	 * with the write verifier.
 	 */
 	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
-
-	/*
-	 * We're still in XFS_DAS_UNINIT state here.  We've converted
-	 * the attr fork to leaf format and will restart with the leaf
-	 * add.
-	 */
-	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	return -EAGAIN;
+	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
+	error = -EAGAIN;
+out:
+	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args->dp);
+	return error;
 }
 
-STATIC int
+static int
 xfs_attr_leaf_addname(
 	struct xfs_attr_item	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
-	struct xfs_inode	*dp = args->dp;
-	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
 	int			error;
 
-	if (xfs_attr_is_leaf(dp)) {
+	ASSERT(xfs_attr_is_leaf(args->dp));
 
-		/*
-		 * Use the leaf buffer we may already hold locked as a result of
-		 * a sf-to-leaf conversion. The held buffer is no longer valid
-		 * after this call, regardless of the result.
-		 */
-		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
-		attr->xattri_leaf_bp = NULL;
-
-		if (error == -ENOSPC) {
-			error = xfs_attr3_leaf_to_node(args);
-			if (error)
-				return error;
-
-			/*
-			 * Finish any deferred work items and roll the
-			 * transaction once more.  The goal here is to call
-			 * node_addname with the inode and transaction in the
-			 * same state (inode locked and joined, transaction
-			 * clean) no matter how we got to this step.
-			 *
-			 * At this point, we are still in XFS_DAS_UNINIT, but
-			 * when we come back, we'll be a node, so we'll fall
-			 * down into the node handling code below
-			 */
-			error = -EAGAIN;
-			goto out;
-		}
-		next_state = XFS_DAS_FOUND_LBLK;
-	} else {
-		ASSERT(!attr->xattri_leaf_bp);
+	/*
+	 * Use the leaf buffer we may already hold locked as a result of
+	 * a sf-to-leaf conversion. The held buffer is no longer valid
+	 * after this call, regardless of the result.
+	 */
+	error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+	attr->xattri_leaf_bp = NULL;
 
-		error = xfs_attr_node_addname_find_attr(attr);
+	if (error == -ENOSPC) {
+		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
 
-		next_state = XFS_DAS_FOUND_NBLK;
-		error = xfs_attr_node_addname(attr);
+		/*
+		 * We're not in leaf format anymore, so roll the transaction and
+		 * retry the add to the newly allocated node block.
+		 */
+		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
+		error = -EAGAIN;
+		goto out;
 	}
 	if (error)
 		return error;
@@ -368,15 +349,46 @@ xfs_attr_leaf_addname(
 	 */
 	if (args->rmtblkno ||
 	    (args->op_flags & XFS_DA_OP_RENAME)) {
-		attr->xattri_dela_state = next_state;
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
 		error = -EAGAIN;
+	} else {
+		attr->xattri_dela_state = XFS_DAS_DONE;
 	}
-
 out:
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
 }
 
+static int
+xfs_attr_node_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	int			error;
+
+	ASSERT(!attr->xattri_leaf_bp);
+
+	error = xfs_attr_node_addname_find_attr(attr);
+	if (error)
+		return error;
+
+	error = xfs_attr_node_try_addname(attr);
+	if (error)
+		return error;
+
+	if (args->rmtblkno ||
+	    (args->op_flags & XFS_DA_OP_RENAME)) {
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+		error = -EAGAIN;
+	} else {
+		attr->xattri_dela_state = XFS_DAS_DONE;
+	}
+
+	trace_xfs_attr_node_addname_return(attr->xattri_dela_state, args->dp);
+	return error;
+}
+
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -397,16 +409,14 @@ xfs_attr_set_iter(
 	/* State machine switch */
 	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
-		/*
-		 * If the fork is shortform, attempt to add the attr. If there
-		 * is no space, this converts to leaf format and returns
-		 * -EAGAIN with the leaf buffer held across the roll. The caller
-		 * will deal with a transaction roll error, but otherwise
-		 * release the hold once we return with a clean transaction.
-		 */
-		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(attr);
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	case XFS_DAS_SF_ADD:
+		return xfs_attr_sf_addname(attr);
+	case XFS_DAS_LEAF_ADD:
 		return xfs_attr_leaf_addname(attr);
+	case XFS_DAS_NODE_ADD:
+		return xfs_attr_node_addname(attr);
 
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -874,6 +884,13 @@ xfs_attr_set_deferred(
 	if (error)
 		return error;
 
+	if (xfs_attr_is_shortform(args->dp))
+		new->xattri_dela_state = XFS_DAS_SF_ADD;
+	else if (xfs_attr_is_leaf(args->dp))
+		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
+	else
+		new->xattri_dela_state = XFS_DAS_NODE_ADD;
+
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 
 	return 0;
@@ -1233,8 +1250,8 @@ xfs_attr_node_addname_find_attr(
  * to handle this, and recall the function until a successful error code is
  *returned.
  */
-STATIC int
-xfs_attr_node_addname(
+static int
+xfs_attr_node_try_addname(
 	struct xfs_attr_item		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index f6c13d2bfbcd..fc2a177f6994 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -443,21 +443,44 @@ struct xfs_attr_list_context {
  * to where it was and resume executing where it left off.
  */
 enum xfs_delattr_state {
-	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
-	XFS_DAS_RMTBLK,		      /* Removing remote blks */
-	XFS_DAS_RM_NAME,	      /* Remove attr name */
-	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
-	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
-	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
-	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
-	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
-	XFS_DAS_RD_LEAF,	      /* Read in the new leaf */
-	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
-	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
-	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
-	XFS_DAS_CLR_FLAG,	      /* Clear incomplete flag */
+	XFS_DAS_UNINIT		= 0,	/* No state has been set yet */
+	XFS_DAS_SF_ADD,			/* Initial shortform set iter state */
+	XFS_DAS_LEAF_ADD,		/* Initial leaf form set iter state */
+	XFS_DAS_NODE_ADD,		/* Initial node form set iter state */
+	XFS_DAS_RMTBLK,			/* Removing remote blks */
+	XFS_DAS_RM_NAME,		/* Remove attr name */
+	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
+	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
+	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
+	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
+	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
+	XFS_DAS_ALLOC_NODE,		/* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
+	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
+	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
+	XFS_DAS_DONE,			/* finished operation */
 };
 
+#define XFS_DAS_STRINGS	\
+	{ XFS_DAS_UNINIT,	"XFS_DAS_UNINIT" }, \
+	{ XFS_DAS_SF_ADD,	"XFS_DAS_SF_ADD" }, \
+	{ XFS_DAS_LEAF_ADD,	"XFS_DAS_LEAF_ADD" }, \
+	{ XFS_DAS_NODE_ADD,	"XFS_DAS_NODE_ADD" }, \
+	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
+	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
+	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
+	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
+	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
+	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
+	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
+	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
+	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
+	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
+	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
+	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
+	{ XFS_DAS_DONE,		"XFS_DAS_DONE" }
+
 /*
  * Defines for xfs_attr_item.xattri_flags
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 51e45341cf76..9fc3fe334b5f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4098,6 +4098,23 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
 DEFINE_ICLOG_EVENT(xlog_iclog_write);
 
+TRACE_DEFINE_ENUM(XFS_DAS_UNINIT);
+TRACE_DEFINE_ENUM(XFS_DAS_SF_ADD);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
+TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
+TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
+TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
+TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
+TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
+TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
+TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
+
 DECLARE_EVENT_CLASS(xfs_das_state_class,
 	TP_PROTO(int das, struct xfs_inode *ip),
 	TP_ARGS(das, ip),
@@ -4109,8 +4126,9 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
 		__entry->das = das;
 		__entry->ino = ip->i_ino;
 	),
-	TP_printk("state change %d ino 0x%llx",
-		  __entry->das, __entry->ino)
+	TP_printk("state change %s ino 0x%llx",
+		  __print_symbolic(__entry->das, XFS_DAS_STRINGS),
+		  __entry->ino)
 )
 
 #define DEFINE_DAS_STATE_EVENT(name) \
-- 
2.35.1

