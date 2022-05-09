Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05602C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 01:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiEIB3t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 21:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiEIAph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:37 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5FCBBC14
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B8AC510E63DB
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:41 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hcv-8j
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CPJ-7j
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/18] xfs: separate out initial attr_set states
Date:   Mon,  9 May 2022 10:41:25 +1000
Message-Id: <20220509004138.762556-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62786346
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=va722VKTXfrkBZV_MTkA:9
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
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c  | 161 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr.h  |  80 ++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.c |   2 +
 fs/xfs/xfs_acl.c          |   4 +-
 fs/xfs/xfs_attr_item.c    |  13 ++-
 fs/xfs/xfs_ioctl.c        |   4 +-
 fs/xfs/xfs_trace.h        |  22 +++++-
 fs/xfs/xfs_xattr.c        |   2 +-
 8 files changed, 185 insertions(+), 103 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 817e15740f9c..edc31075fde4 100644
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
@@ -255,20 +260,7 @@ xfs_attr_try_sf_addname(
 	return error;
 }
 
-/*
- * Check to see if the attr should be upgraded from non-existent or shortform to
- * single-leaf-block attribute list.
- */
-static inline bool
-xfs_attr_is_shortform(
-	struct xfs_inode    *ip)
-{
-	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
-	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
-		ip->i_afp->if_nextents == 0);
-}
-
-STATIC int
+static int
 xfs_attr_sf_addname(
 	struct xfs_attr_item		*attr)
 {
@@ -276,14 +268,12 @@ xfs_attr_sf_addname(
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
@@ -299,64 +289,42 @@ xfs_attr_sf_addname(
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
-
-		/*
-		 * Use the leaf buffer we may already hold locked as a result of
-		 * a sf-to-leaf conversion. The held buffer is no longer valid
-		 * after this call, regardless of the result.
-		 */
-		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
-		attr->xattri_leaf_bp = NULL;
+	ASSERT(xfs_attr_is_leaf(args->dp));
 
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
@@ -368,15 +336,46 @@ xfs_attr_leaf_addname(
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
@@ -397,16 +396,14 @@ xfs_attr_set_iter(
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
@@ -700,7 +697,7 @@ xfs_attr_defer_add(
 	if (error)
 		return error;
 
-	new->xattri_dela_state = XFS_DAS_UNINIT;
+	new->xattri_dela_state = xfs_attr_init_add_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 
@@ -719,7 +716,7 @@ xfs_attr_defer_replace(
 	if (error)
 		return error;
 
-	new->xattri_dela_state = XFS_DAS_UNINIT;
+	new->xattri_dela_state = xfs_attr_init_replace_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
 
@@ -1262,8 +1259,8 @@ xfs_attr_node_addname_find_attr(
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
index c9c867e3406c..ad52b5dc59e4 100644
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
@@ -530,4 +553,35 @@ void xfs_attri_destroy_cache(void);
 int __init xfs_attrd_init_cache(void);
 void xfs_attrd_destroy_cache(void);
 
+/*
+ * Check to see if the attr should be upgraded from non-existent or shortform to
+ * single-leaf-block attribute list.
+ */
+static inline bool
+xfs_attr_is_shortform(
+	struct xfs_inode    *ip)
+{
+	return ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
+	       (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
+		ip->i_afp->if_nextents == 0);
+}
+
+static inline enum xfs_delattr_state
+xfs_attr_init_add_state(struct xfs_da_args *args)
+{
+	if (!args->dp->i_afp)
+		return XFS_DAS_DONE;
+	if (xfs_attr_is_shortform(args->dp))
+		return XFS_DAS_SF_ADD;
+	if (xfs_attr_is_leaf(args->dp))
+		return XFS_DAS_LEAF_ADD;
+	return XFS_DAS_NODE_ADD;
+}
+
+static inline enum xfs_delattr_state
+xfs_attr_init_replace_state(struct xfs_da_args *args)
+{
+	return xfs_attr_init_add_state(args);
+}
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index b2ecc272f9e4..ceb222b4f261 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -23,6 +23,8 @@
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
 #include "xfs_buf.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 5c52ee869272..3df9c1782ead 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -10,12 +10,12 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_acl.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 #include "xfs_trans.h"
 
 #include <linux/posix_acl_xattr.h>
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index fe1e37696634..5bfb33746e37 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -570,10 +570,21 @@ xfs_attri_item_recover(
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_flags;
 
-	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
+	switch (attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK) {
+	case XFS_ATTR_OP_FLAGS_SET:
+	case XFS_ATTR_OP_FLAGS_REPLACE:
 		args->value = attrip->attri_value;
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
+		attr->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		attr->xattri_dela_state = XFS_DAS_UNINIT;
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		goto out;
 	}
 
 	xfs_init_attr_trans(args, &tres, &total);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e9eadc7337ce..0e5cb7936206 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -15,6 +15,8 @@
 #include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
@@ -35,8 +37,6 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
-#include "xfs_da_format.h"
-#include "xfs_da_btree.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 01ce0401aa32..8f722be25c29 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4129,6 +4129,23 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
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
@@ -4140,8 +4157,9 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
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
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0d050f8829ef..7a044afd4c46 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -12,9 +12,9 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
-#include "xfs_da_btree.h"
 
 #include <linux/posix_acl_xattr.h>
 
-- 
2.35.1

