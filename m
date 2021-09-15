Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94264C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB76610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhIOXJ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhIOXJ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C43D7610A4;
        Wed, 15 Sep 2021 23:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747287;
        bh=1hwXDKociXgSve3pL6rkO19BWEJ3PMrNFSFp1St3NCY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QHYTgt2M4ZS79meQ8CpBXY1BmjxYqv7ZUQujFGi8wbt4CF520y1vnuZmfatKtl7W4
         9/BCueQtNGqle+NC3PXZ2aNSMvPCZE+SBpGIc8+Hw++2y3c2zyVJpTz7XRMSWhORHv
         r0jL6NIdqRV/KLuOhKNY9/pIIXTNWthj082nFvsdgqGPJAYImou2WvtaOZZGiHbEfC
         c6Gf/W8Ij8eAZB2VKEtpin/coXJ2uKnuRlx/Df56Zka+8T2PPsIUuJEA8+5QhZzFaj
         b0cOU9pvUvkNV/5BlTxcJkxrFM4z3udBQQvuoAwW25+f6yxmtILttkE5SAcYBZjpBW
         eE5TiF0FrIyrA==
Subject: [PATCH 17/61] xfs: Add delay ready attr remove routines
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:07 -0700
Message-ID: <163174728755.350433.16892987217139081185.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 2b74b03c13c444cb5af56804cc975534e2058d06

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args is merged with
xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
This new version uses a sort of state machine like switch to keep track
of where it was when EAGAIN was returned. A new version of
xfs_attr_remove_args consists of a simple loop to refresh the
transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
flag is used to finish the transaction where ever the existing code used
to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of preserving existing function, we
modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
set.  Similar to how xfs_attr_remove_args does here.  Once we transition
the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
used and will be removed.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function calls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h         |    1 
 libxfs/xfs_attr.c        |  239 +++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_attr.h        |  131 +++++++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |    2 
 libxfs/xfs_attr_remote.c |   53 ++++++----
 libxfs/xfs_attr_remote.h |    2 
 6 files changed, 335 insertions(+), 93 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index c297152f..1d874fcb 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -62,6 +62,7 @@ struct iomap;
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_attr.h"
 #include "xfs_attr_sf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_buf.h"
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 118ec0b4..94da860f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
 				 struct xfs_da_state **state);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
@@ -241,6 +240,31 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+/*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * transaction is finished or rolled as needed.
+ */
+int
+xfs_attr_trans_roll(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		/*
+		 * The caller wants us to finish all the deferred ops so that we
+		 * avoid pinning the log tail with a large number of deferred
+		 * ops.
+		 */
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		error = xfs_defer_finish(&args->trans);
+	} else
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+
+	return error;
+}
+
 STATIC int
 xfs_attr_set_fmt(
 	struct xfs_da_args	*args)
@@ -544,16 +568,25 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	if (!xfs_inode_hasattr(args->dp))
-		return -ENOATTR;
-
-	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_shortform_remove(args);
-	if (xfs_attr_is_leaf(args->dp))
-		return xfs_attr_leaf_removename(args);
-	return xfs_attr_node_removename(args);
+	int				error;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
+
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+
+	} while (true);
+
+	return error;
 }
 
 /*
@@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac)
 {
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		**state = &dac->da_state;
+	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
+	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
@@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
-			return error;
+			goto out;
 
-		return xfs_attr_rmtval_invalidate(args);
+		error = xfs_attr_rmtval_invalidate(args);
 	}
+out:
+	if (error)
+		xfs_da_state_free(*state);
 
-	return 0;
+	return error;
 }
 
 STATIC int
@@ -1241,70 +1279,133 @@ xfs_attr_node_remove_name(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Remove the attribute specified in @args.
  *
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an in-line or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and call the function until a
+ * successful error code is returned.
  */
-STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+int
+xfs_attr_remove_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = dac->da_state;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		if (!xfs_inode_hasattr(dp))
+			return -ENOATTR;
+
+		/*
+		 * Shortform or leaf formats don't require transaction rolls and
+		 * thus state transitions. Call the right helper and return.
+		 */
+		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
+			return xfs_attr_shortform_remove(args);
+
+		if (xfs_attr_is_leaf(dp))
+			return xfs_attr_leaf_removename(args);
+
+		/*
+		 * Node format may require transaction rolls. Set up the
+		 * state context and fall into the state machine.
+		 */
+		if (!dac->da_state) {
+			error = xfs_attr_node_removename_setup(dac);
+			if (error)
+				return error;
+			state = dac->da_state;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RMTBLK:
+		dac->dela_state = XFS_DAS_RMTBLK;
+
+		/*
+		 * If there is an out-of-line value, de-allocate the blocks.
+		 * This is done before we remove the attribute so that we don't
+		 * overflow the maximum size of a transaction and/or hit a
+		 * deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			/*
+			 * May return -EAGAIN. Roll and repeat until all remote
+			 * blocks are removed.
+			 */
+			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				return error;
+			else if (error)
+				goto out;
+
+			/*
+			 * Refill the state structure with buffers (the prior
+			 * calls released our buffers) and close out this
+			 * transaction before proceeding.
+			 */
+			ASSERT(args->rmtblkno == 0);
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+			dac->dela_state = XFS_DAS_RM_NAME;
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_NAME:
+		/*
+		 * If we came here fresh from a transaction roll, reattach all
+		 * the buffers to the current transaction.
+		 */
+		if (dac->dela_state == XFS_DAS_RM_NAME) {
+			error = xfs_attr_refillstate(state);
+			if (error)
+				goto out;
+		}
+
+		retval = xfs_attr_node_remove_name(args, state);
+
+		/*
+		 * Check to see if the tree needs to be collapsed. If so, roll
+		 * the transacton and fall into the shrink state.
+		 */
+		if (retval && (state->path.active > 1)) {
+			error = xfs_da3_join(state);
+			if (error)
+				goto out;
+
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			dac->dela_state = XFS_DAS_RM_SHRINK;
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
+	case XFS_DAS_RM_SHRINK:
+		/*
+		 * If the result is small enough, push it all into the inode.
+		 * This is our final state so it's safe to return a dirty
+		 * transaction.
+		 */
+		if (xfs_attr_is_leaf(dp))
+			error = xfs_attr_node_shrink(args, state);
+		ASSERT(error != -EAGAIN);
+		break;
+	default:
+		ASSERT(0);
+		error = -EINVAL;
 		goto out;
-
-	/*
-	 * If there is an out-of-line value, de-allocate the blocks.
-	 * This is done before we remove the attribute so that we don't
-	 * overflow the maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
-
-		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
-		 */
-		error = xfs_attr_refillstate(state);
-		if (error)
-			goto out;
 	}
-	retval = xfs_attr_node_remove_name(args, state);
-
-	/*
-	 * Check to see if the tree needs to be collapsed.
-	 */
-	if (retval && (state->path.active > 1)) {
-		error = xfs_da3_join(state);
-		if (error)
-			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
-		/*
-		 * Commit the Btree join operation and start a new trans.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-	}
-
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_attr_is_leaf(dp))
-		error = xfs_attr_node_shrink(args, state);
-
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 2b1f6198..1267ea86 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -74,6 +74,133 @@ struct xfs_attr_list_context {
 };
 
 
+/*
+ * ========================================================================
+ * Structure used to pass context around among the delayed routines.
+ * ========================================================================
+ */
+
+/*
+ * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
+ * states indicate places where the function would return -EAGAIN, and then
+ * immediately resume from after being called by the calling function. States
+ * marked as a "subroutine state" indicate that they belong to a subroutine, and
+ * so the calling function needs to pass them back to that subroutine to allow
+ * it to finish where it left off. But they otherwise do not have a role in the
+ * calling function other than just passing through.
+ *
+ * xfs_attr_remove_iter()
+ *              │
+ *              v
+ *        have attr to remove? ──n──> done
+ *              │
+ *              y
+ *              │
+ *              v
+ *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
+ *              │
+ *              n
+ *              │
+ *              V
+ *   ┌── need to setup state?
+ *   │          │
+ *   n          y
+ *   │          │
+ *   │          v
+ *   │ find attr and get state
+ *   │ attr has remote blks? ──n─┐
+ *   │          │                v
+ *   │          │         find and invalidate
+ *   │          y         the remote blocks.
+ *   │          │         mark attr incomplete
+ *   │          ├────────────────┘
+ *   └──────────┤
+ *              │
+ *              v
+ *   Have remote blks to remove? ───y─────┐
+ *              │        ^          remove the blks
+ *              │        │                │
+ *              │        │                v
+ *              │  XFS_DAS_RMTBLK <─n── done?
+ *              │  re-enter with          │
+ *              │  one less blk to        y
+ *              │      remove             │
+ *              │                         V
+ *              │                  refill the state
+ *              n                         │
+ *              │                         v
+ *              │                   XFS_DAS_RM_NAME
+ *              │                         │
+ *              ├─────────────────────────┘
+ *              │
+ *              v
+ *       remove leaf and
+ *       update hash with
+ *   xfs_attr_node_remove_cleanup
+ *              │
+ *              v
+ *           need to
+ *        shrink tree? ─n─┐
+ *              │         │
+ *              y         │
+ *              │         │
+ *              v         │
+ *          join leaf     │
+ *              │         │
+ *              v         │
+ *      XFS_DAS_RM_SHRINK │
+ *              │         │
+ *              v         │
+ *       do the shrink    │
+ *              │         │
+ *              v         │
+ *          free state <──┘
+ *              │
+ *              v
+ *            done
+ *
+ */
+
+/*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then call the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RMTBLK,		      /* Removing remote blks */
+	XFS_DAS_RM_NAME,	      /* Remove attr name */
+	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_args      *da_args;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state     *da_state;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index e13e83e0..08600ea8 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 3807cd3d..e41bbb2e 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -673,10 +673,12 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	int			error;
-	int			retval;
+	int				error;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -684,31 +686,30 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error && error != -EAGAIN)
+			break;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_trans_roll(&dac);
 		if (error)
 			return error;
-	} while (retval == -EAGAIN);
+	} while (true);
 
-	return 0;
+	return error;
 }
 
 /*
  * Remove the value associated with an attribute by deleting the out-of-line
- * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
- * transaction and re-call the function
+ * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
+ * transaction and re-call the function.  Callers should keep calling this
+ * routine until it returns something other than -EAGAIN.
  */
 int
 __xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, done;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error, done;
 
 	/*
 	 * Unmap value blocks for this attr.
@@ -718,12 +719,20 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	/*
+	 * We don't need an explicit state here to pick up where we left off. We
+	 * can figure it out using the !done return code. The actual value of
+	 * attr->xattri_dela_state may be some value reminiscent of the calling
+	 * function, but it's value is irrelevant with in the context of this
+	 * function. Once we are done here, the next state is set as needed by
+	 * the parent
+	 */
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
-	return error;
+	args->rmtblkno = 0;
+	args->rmtblkcnt = 0;
+	return 0;
 }
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 9eee615d..002fd300 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */

