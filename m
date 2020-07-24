Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFB0C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 03:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A15B20737
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 03:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgGXDlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 23:41:09 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:39700 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726696AbgGXDlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 23:41:09 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 7A4C8D7B679;
        Fri, 24 Jul 2020 13:41:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jyoZw-0002pt-5P; Fri, 24 Jul 2020 13:41:00 +1000
Date:   Fri, 24 Jul 2020 13:41:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 00/25] xfs: Delay Ready Attributes
Message-ID: <20200724034100.GN2005@dread.disaster.area>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=4D8N2WlKCPoxDYbqUFwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 05:15:41PM -0700, Allison Collins wrote:
> Hi all,
> 
> This set is a subset of a larger series for delayed attributes. Which is a
> subset of an even larger series, parent pointers. Delayed attributes allow
> attribute operations (set and remove) to be logged and committed in the same
> way that other delayed operations do. This allows more complex operations (like
> parent pointers) to be broken up into multiple smaller transactions. To do
> this, the existing attr operations must be modified to operate as either a
> delayed operation or a inline operation since older filesystems will not be
> able to use the new log entries.  This means that they cannot roll, commit, or
> finish transactions.  Instead, they return -EAGAIN to allow the calling
> function to handle the transaction. In this series, we focus on only the clean
> up and refactoring needed to accomplish this. We will introduce delayed attrs
> and parent pointers in a later set.
> 
> At the moment, I would like people to focus their review efforts on just this
> "delay ready" subseries, as I think that is a more conservative use of peoples
> review time.  I also think the set is a bit much to manage all at once, and we
> need to get the infrastructure ironed out before we focus too much anything
> that depends on it. But I do have the extended series for folks that want to
> see the bigger picture of where this is going.
> 
> To help organize the set, I've arranged the patches to make sort of mini sets.
> I thought it would help reviewers break down the reviewing some. For reviewing
> purposes, the set could be broken up into 4 different phases:
> 
> Error code filtering (patches 1-2):
> These two patches are all about finding and catching error codes that need to
> be sent back up to user space before starting delayed operations.  Errors that
> happen during a delayed operation are treated like internal errors that cause a
> shutdown.  But we wouldnt want that for example: when the user tries to rename
> a non existent attr.  So the idea is that we need to find all such conditions,
> and take care of them before starting a delayed operation.
>    xfs: Add xfs_has_attr and subroutines
>    xfs: Check for -ENOATTR or -EEXIST
> 
> Move transactions upwards (patches 3-12): 
> The goal of this subset is to try and move all the transaction specific code up
> the call stack much as possible.  The idea being that once we get them to the
> top, we can introduce the statemachine to handle the -EAGAIN logic where ever
> the transactions used to be.
>   xfs: Factor out new helper functions xfs_attr_rmtval_set
>   xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
>   xfs: Split apart xfs_attr_leaf_addname
>   xfs: Refactor xfs_attr_try_sf_addname
>   xfs: Pull up trans roll from xfs_attr3_leaf_setflag
>   xfs: Factor out xfs_attr_rmtval_invalidate
>   xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
>   xfs: Refactor xfs_attr_rmtval_remove
>   xfs: Pull up xfs_attr_rmtval_invalidate
>   xfs: Add helper function xfs_attr_node_shrink
> 
> Modularizing and cleanups (patches 13-22):
> Now that we have pulled the transactions up to where we need them, it's time to
> start breaking down the top level functions into new subfunctions. The goal
> being to work towards a top level function that deals mostly with the
> statemachine, and helpers for those states
>   xfs: Remove unneeded xfs_trans_roll_inode calls
>   xfs: Remove xfs_trans_roll in xfs_attr_node_removename
>   xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
>   xfs: Add helper function xfs_attr_leaf_mark_incomplete
>   xfs: Add remote block helper functions
>   xfs: Add helper function xfs_attr_node_removename_setup
>   xfs: Add helper function xfs_attr_node_removename_rmt
>   xfs: Simplify xfs_attr_leaf_addname
>   xfs: Simplify xfs_attr_node_addname
>   xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

I'm happy to see everything up to here merged.

> Introduce statemachine (patches 23-25):
> Now that we have re-arranged the code such that we can remove the transaction
> handling, we proceed to do so.  The behavior of the attr set/remove routines
> are now also compatible as a .finish_item callback
>   xfs: Add delay ready attr remove routines
>   xfs: Add delay ready attr set routines
>   xfs: Rename __xfs_attr_rmtval_remove

However, I think these still need work. The state machine mechanism
needs more factoring so that there is a function per state/action
that moves the state forwards one step, rather than the current
setup where a single function might handle 3-5 different states by
jumping to different parts of the code.

I started thinking that this was largely just code re-arrangement,
but as I started to to do a bit of cleanup onit as an example, I
think there's some bugs in the code that might be leading to leaking
buffers and other such stuff. So I think this code really needs a
good cleanup and going over before it will be ready to merge.

I've attached an untested, uncompiled patch below to demonstrate
how I think we should start flattening this out. It takes
xfs_attr_set_iter() and flattens it into a switch statement which
calls fine grained functions. There are a couple of new states to
efficiently jump into the state machine based on initial attr fork
format, and xfs_attr_set_iter() goes away entirely.

Note that I haven't flattened the second level of function calls out
into a function per state, which is where it's like to see this end
up. i.e. we don't need to call through xfs_attr_leaf_addname() to
just get to another switch statement to jump to the code that flips
the flags.

The factoring and flattening process is the same, though: isolate
the code that needs to run to a single function, call it from the
state machine switch. That function then selects the next state to
run, whether a transaction roll is necessary, etc, and the main loop
then takes care of it from there.

Allison, if you want I can put together another couple of patches
like the one below that flatten it right out into fine grained
states and functions. I think having all the state machien
transitions in one spot makes the code much easier to understand
and, later, to simplify and optimise.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

---
 fs/xfs/libxfs/xfs_attr.c | 246 ++++++++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_attr.h |   2 +
 2 files changed, 139 insertions(+), 109 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 88172459c8f4..8ebe09b7c26a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -59,8 +59,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -252,13 +250,7 @@ xfs_attr_set_shortform(
 	if (error)
 		return error;
 
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	return -EAGAIN;
+	return -ENOSPC;
 }
 
 /*
@@ -288,47 +280,35 @@ xfs_attr_trans_roll(
 	return xfs_trans_roll_inode(&args->trans, args->dp);
 }
 
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args	*args)
+static int
+xfs_attr_das_set_sf(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
 {
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
 
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-		if (leaf_bp) {
-			xfs_trans_bjoin(args->trans, leaf_bp);
-			xfs_trans_bhold(args->trans, leaf_bp);
-		}
+	/*
+	 * If the attr was successfully set in shortform, no need to
+	 * continue.  Otherwise, is it converted from shortform to leaf
+	 * and -EAGAIN is returned.
+	 */
+	error = xfs_attr_set_shortform(args, leaf_bp);
+	if (error != ENOSPC)
+		return error;
 
-	} while (true);
+	dac->flags |= XFS_DAC_DEFER_FINISH;
+	dac->state = XFS_DAS_FIND_LBLK;
 
-	return error;
+	/*
+	 * Prevent the leaf buffer from being unlocked while we roll the
+	 * transaction so that a concurrent AIL push cannot grab the half-baked
+	 * leaf buffer and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, *leaf_bp);
+	return -EAGAIN;
 }
 
-/*
- * Set the attribute specified in @args.
- * This routine is meant to function as a delayed operation, and may return
- * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
- * to handle this, and recall the function until a successful error code is
- * returned.
- */
-STATIC int
-xfs_attr_set_iter(
+static int
+xfs_attr_das_find_leaf(
 	struct xfs_delattr_context	*dac,
 	struct xfs_buf			**leaf_bp)
 {
@@ -336,89 +316,137 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
-	/* State machine switch */
-	switch (dac->dela_state) {
-	case XFS_DAS_FLIP_LFLAG:
-	case XFS_DAS_FOUND_LBLK:
-		goto das_leaf;
-	case XFS_DAS_FOUND_NBLK:
-	case XFS_DAS_FLIP_NFLAG:
-	case XFS_DAS_ALLOC_NODE:
-		goto das_node;
-	default:
-		break;
-	}
-
 	/*
-	 * If the attribute list is already in leaf format, jump straight to
-	 * leaf handling.  Otherwise, try to add the attribute to the shortform
-	 * list; if there's no room then convert the list to leaf format and try
-	 * again. No need to set state as we will be in leaf form when we come
-	 * back
+	 * After a shortform to leaf conversion, we don't need to hold the leaf
+	 * block we allocated anymore. Release the hold if we are passed a leaf
+	 * block and clear the pointer.
 	 */
-	if (xfs_attr_is_shortform(dp)) {
+	if (*leaf_bp) {
+		xfs_trans_bhold_release(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
 
+	error = xfs_attr_leaf_try_add(args, leaf_bp);
+	switch (error) {
+	case -ENOSPC:
 		/*
-		 * If the attr was successfully set in shortform, no need to
-		 * continue.  Otherwise, is it converted from shortform to leaf
-		 * and -EAGAIN is returned.
+		 * Promote the attribute list to the Btree format.
 		 */
-		error = xfs_attr_set_shortform(args, leaf_bp);
-		if (error == -EAGAIN)
-			dac->flags |= XFS_DAC_DEFER_FINISH;
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
 
+		/*
+		 * Finish any deferred work items and roll the
+		 * transaction once more.  The goal here is to call
+		 * node_addname with the inode  and transaction in the
+		 * same state (inode locked and joined, transaction
+		 * clean) no matter how we got to this step.
+		 */
+		dac->flags |= XFS_DAC_DEFER_FINISH;
+		return -EAGAIN;
+	case 0:
+		dac->dela_state = XFS_DAS_FOUND_LBLK;
+		return -EAGAIN;
+	default:
 		return error;
 	}
+}
+
+static int
+xfs_attr_das_set_leaf(
+	struct xfs_delattr_context	*dac)
+{
+	int				error = 0;
+
+	error = xfs_attr_leaf_addname(dac);
+	if (error == -ENOSPC) {
+		/*
+		 * No need to set state.  We will be in node form when
+		 * we are recalled
+		 */
+		return -EAGAIN;
+	}
+	return error;
+}
+
+static int
+xfs_attr_das_set_node(
+	struct xfs_delattr_context	*dac)
+{
+	return  xfs_attr_node_addname(dac);
+}
+
+/*
+ * Set the attribute specified in @args.
+ */
+int
+xfs_attr_set_args(
+	struct xfs_da_args	*args)
+{
+	struct xfs_buf			*leaf_bp = NULL;
+	int				error = 0;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
 
 	/*
-	 * After a shortform to leaf conversion, we need to hold the leaf and
-	 * cycle out the transaction.  When we get back, we need to release
-	 * the leaf.
+	 * Initial condition setup is based on detected form of
+	 * the attribute tree.
 	 */
-	if (*leaf_bp != NULL) {
-		xfs_trans_bhold_release(args->trans, *leaf_bp);
-		*leaf_bp = NULL;
+	if (xfs_attr_is_shortform(dp)) {
+		dac->dela_state = XFS_DAS_FIND_SF;
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		dac->dela_state = XFS_DAS_FIND_LBLK;
+	} else {
+		dac->dela_state = XFS_DAS_FIND_NBLK;
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_try_add(args, *leaf_bp);
-		switch (error) {
-		case -ENOSPC:
-			/*
-			 * Promote the attribute list to the Btree format.
-			 */
-			error = xfs_attr3_leaf_to_node(args);
-			if (error)
-				return error;
+	do {
+		/*
+		 * XXX: Need two returns here:
+		 *	- state change occurred, no trans roll required
+		 *	- state change occurred, trans roll required.
+		 */
+		switch (dac->dela_state) {
+		case XFS_DAS_FIND_SF:
+			error = xfs_attr_das_set_sf(dac, &leaf_bp);
+			break;
+		case XFS_DAS_FIND_LBLK:
+			/* XXX: should we really be getting leaf_bp back here? */
+			error = xfs_attr_das_find_leaf(dac, &leaf_bp);
+			break;
 
-			/*
-			 * Finish any deferred work items and roll the
-			 * transaction once more.  The goal here is to call
-			 * node_addname with the inode  and transaction in the
-			 * same state (inode locked and joined, transaction
-			 * clean) no matter how we got to this step.
-			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
-			return -EAGAIN;
-		case 0:
-			dac->dela_state = XFS_DAS_FOUND_LBLK;
-			return -EAGAIN;
+		case XFS_DAS_FLIP_LFLAG:
+		case XFS_DAS_FOUND_LBLK:
+			error = xfs_attr_das_set_leaf(dac);
+			break;
+
+		case XFS_DAS_FOUND_NBLK:
+		case XFS_DAS_FLIP_NFLAG:
+		case XFS_DAS_ALLOC_NODE:
+			error = xfs_attr_das_set_node(dac);
+			break;
 		default:
+			error = xfs_attr_das_set_sf(dac, &leaf_bp);
+			break;
+		}
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
 			return error;
+
+		if (leaf_bp) {
+			xfs_trans_bjoin(args->trans, leaf_bp);
+			xfs_trans_bhold(args->trans, leaf_bp);
 		}
-das_leaf:
-		error = xfs_attr_leaf_addname(dac);
-		if (error == -ENOSPC)
-			/*
-			 * No need to set state.  We will be in node form when
-			 * we are recalled
-			 */
-			return -EAGAIN;
 
-		return error;
-	}
-das_node:
-	error = xfs_attr_node_addname(dac);
+	} while (true);
+
+	/* XXX: shouldn't this drop the hold on leaf_bp here? */
+
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 4f6bba87fd42..9f80b937c22a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -232,6 +232,8 @@ struct xfs_attr_list_context {
 enum xfs_delattr_state {
 				      /* Zero is uninitalized */
 	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
+	XFS_DAS_FIND_SF,
+	XFS_DAS_FIND_LBLK,
 	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
 	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
 	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
