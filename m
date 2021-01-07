Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD6CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D85523118
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbhAGQQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:16:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbhAGQQS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 11:16:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610036089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aQT7UupBq+pqvXOrFdCP4y8M8TkeX0ssqzIuEUP8cFk=;
        b=Cou9WxsH0b/ZmXb8eVjnhflWtuZ7i9RnlRu+TjfL+Ohd0yXJnAYJMiSFzHB2lJ84JrzJtz
        R2RF2EOjNihJFIsYtXK5npp7nDBS1ls8ERMnPD9DwKPw4Yfoaq1W8AF87ypcLjZ9Qzgan2
        mtq0M/Yt24fRqBmfEHpWKI5HY4gfgr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-s6LLBE9ZOEmAJWDlaA_fBQ-1; Thu, 07 Jan 2021 11:14:46 -0500
X-MC-Unique: s6LLBE9ZOEmAJWDlaA_fBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9337F184214D;
        Thu,  7 Jan 2021 16:14:45 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08C7F60BD9;
        Thu,  7 Jan 2021 16:14:44 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH RFC] xfs: refactor xfs_attr_set() into incremental components
Date:   Thu,  7 Jan 2021 11:14:44 -0500
Message-Id: <20210107161444.858242-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

POC to explore whether xfs_attr_set() can be refactored into
incremental components to facilitate isolated state management.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This is a followup to the ongoing discussion with Allison around delayed
attrs and the xfs_attr_set() path in particular. It is a continuation of
the RFC patch posted here[1]. One of the things that concerns me about
the current approach is not so much the state management, but the
resulting structure that the current xattr implementation imposes on the
state machine code. Earlier on in this effort, we discussed an objective
to keep the state management code as isolated as possible (ideally to a
single level) from the functional xattr code. The purpose of this RFC is
to explore whether the existing code can be refactored in such a way to
accommodate that.

Note that this is patch is not intended to be functional. It is compile
tested only, takes intentional shortcuts, and is intended only to
illustrate an idea / potential approach. IOW, this was essentially a
blitz through the set codepath to try and determine whether this kind of
approach was feasible, not necessarily an attempt to implement it
correctly.

Also note that some code has been borrowed from Allison's series, but
otherwise a crude state machine mechanism has been hacked in just to
support the associated refactoring. This state machine code is not
intended to replace the broader mechanism Allison has implemented. I
needed something to support breaking down the code into components and
didn't want to pull in a world of infrastructure, so I hacked in the
bare minimal mechanism necessary to support that effort. This state
management code should ultimately be thrown away and is not the focus of
the patch. I do have a local git branch with more granular commits, but
it's kind of a mess atm so I squashed this down to a single patch since
it is primarily intended to generate discussion.

The flow of development was generally as follows:

1. Implement a basic transaction rolling and function reentry loop
(based on -EAGAIN). This is the primary loop in xfs_attr_set_iter() and
based on Allison's code.

2. Tack on a crude mechanism to implement incremental states. This is
essentially the switch statement inside the aforementioned loop. Any
state that returns -EAGAIN is reentered after a transaction roll.
Otherwise a non-error return increments to the next state. Note that
some states are semi-artificial in that they don't ever repeat, so could
potentially be optimized away.

3. With the above infrastructure in place, incrementally convert the
existing xattr set implementation into reentrant components. This is
accomplished by peeling off bits of the existing implemention that are
currently separated by explicit transaction rolls and working them into
the state management loop. On termination of the loop, we call into the
remainder of the explicit rolling implementation to maintain
functionality.

The state machine consists of the following high level states:

0. Set the xattr fork format and add the attr name. This state repeats
as the fork is converted into something that can hold the requested
xattr. If the set completes in shortform format, the entire operation
completes.
1. Find a hole for a remote value, if necessary. This state does not
repeat or roll the transaction.
2. Allocate blocks for the remote value, if necessary. This state
repeats until all required blocks are allocated.
3. Write the remote value, if necessary. This state does not repeat or
roll.
4. Clear or flip the inactive flag depending on whether the set is a
rename. If !rename, the flag is cleared and the set returns. Otherwise,
the flag is flipped to the old xattr and we progress to the next state.
5. Invalidate remote blocks for the old xattr, if necessary. This state
does not roll or repeat.
6. Remove remote blocks from the old xattr. This state repeats until all
extents for the old remote value are removed.

Finally, we fall back into what remains of the existing leaf/node
implementations. At this point this consists of removing the old xattr
name and some final attr fork format cleanup, if necessary. This code
should ultimately be reworked as well, but I didn't see any transaction
rolls through here and so decided it was sufficient to stop at this
point for the purpose of the RFC.

To me, the primary takeaways from this are that it seems reasonably
possible to clean up the xattr set codepath such that we don't require a
large number of per-format states and that we can do so in a way that
state management code is isolated to a single function (or single switch
statement). This is demonstrated by explicitly containing throwaway
state management code within xfs_attr_set_iter() and refactoring the
functional code into components that either complete (return 0) or
repeat (return -EAGAIN). Though it may not be apparent from the squashed
together RFC patch, this also suggests a more incremental development
approach is possible, as this patch was developed in a manner that
implemented one (or several related) states at a time with the intent to
maintain functionality at each step. Thoughts?

Brian

[1] https://lore.kernel.org/linux-xfs/20201218072917.16805-1-allison.henderson@oracle.com/T/#m3fcf7be3a8154ab98ddc9e1d45bc764d79d39dc3

 fs/xfs/libxfs/xfs_attr.c        | 361 ++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr_remote.c |  67 ++----
 fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
 3 files changed, 154 insertions(+), 278 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e6418a0d3..216055b6ad0d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -58,6 +58,9 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *, struct xfs_buf *);
+STATIC int xfs_attr_node_addname_work(struct xfs_da_args *);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 
 int
 xfs_inode_hasattr(
@@ -216,118 +219,153 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
-STATIC int
-xfs_attr_set_shortform(
+int
+xfs_attr_set_fmt(
 	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
+	bool			*done)
 {
 	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
+	struct xfs_buf		*leaf_bp = NULL;
+	int			error = 0;
 
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
+	if (xfs_attr_is_shortform(dp)) {
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (!error)
+			*done = true;
+		if (error != -ENOSPC)
+			return error;
+
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			return error;
+		return -EAGAIN;
 	}
-	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
-	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
 
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		struct xfs_buf	*bp = NULL;
+
+		error = xfs_attr_leaf_try_add(args, bp);
+		if (error != -ENOSPC)
+			return error;
+
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
+		return -EAGAIN;
 	}
 
-	return 0;
+	return xfs_attr_node_addname(args);
 }
 
 /*
  * Set the attribute specified in @args.
  */
 int
-xfs_attr_set_args(
+__xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
 	int			error = 0;
 
-	/*
-	 * If the attribute list is already in leaf format, jump straight to
-	 * leaf handling.  Otherwise, try to add the attribute to the shortform
-	 * list; if there's no room then convert the list to leaf format and try
-	 * again.
-	 */
-	if (xfs_attr_is_shortform(dp)) {
-
-		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
-		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
-			return error;
-	}
-
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
+		if (error)
 			return error;
+	}
 
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
+	error = xfs_attr_node_addname_work(args);
+	return error;
+}
+
+int
+xfs_attr_set_iter(
+	struct xfs_da_args	*args,
+	bool			*done)
+{
+	int			error;
+	int			state = 0;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+
+	do {
+		switch (state) {
+		case 0:	/* SET_FMT */
+			error = xfs_attr_set_fmt(args, done);
+			if (*done)
+				return error;
+			break;
+		case 1: /* RMT_FIND_HOLE */
+			if (args->rmtblkno <= 0)
+				break;
+
+			trace_xfs_attr_rmtval_set(args);
+			error = xfs_attr_rmt_find_hole(args);
+			lblkno = (xfs_dablk_t)args->rmtblkno;
+			blkcnt = args->rmtblkcnt;
+			state++;
+			continue;
+		case 2: /* RMTVAL_ALLOC */
+			if (args->rmtblkno <= 0)
+				break;
+			error = xfs_attr_rmtval_set(args, &lblkno, &blkcnt);
+			break;
+		case 3: /* RMTVAL_SET */
+			if (args->rmtblkno <= 0)
+				break;
+			error = xfs_attr_rmtval_set_value(args);
+			state++;
+			continue;
+		case 4:	/* SET_FLAG */
+			if (args->op_flags & XFS_DA_OP_RENAME) {
+				error = xfs_attr3_leaf_flipflags(args);
+			} else {
+				if (args->rmtblkno > 0)
+					error = xfs_attr3_leaf_clearflag(args);
+				return error;
+			}
+			break;
+		case 5: /* RMT_INVALIDATE */
+			xfs_attr_restore_rmt_blk(args);
+			if (args->rmtblkno)
+				error = xfs_attr_rmtval_invalidate(args);
+			state++;
+			continue;
+		case 6: /* RMT_REMOVE */
+			error = __xfs_attr_rmtval_remove(args);
+			break;
+		default:
 			return error;
+		};
 
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
+		if (!error)
+			state++;
+		else if (error != -EAGAIN)
 			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
+		error = xfs_defer_finish(&args->trans);
 		if (error)
-			return error;
-	}
+			break;
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	} while (!error);
 
-	error = xfs_attr_node_addname(args);
 	return error;
 }
 
+int
+xfs_attr_set_args(
+	struct xfs_da_args	*args)
+
+{
+	int			error;
+	bool			done = false;
+
+	error = xfs_attr_set_iter(args, &done);
+	if (error || done)
+		return error;
+
+	return __xfs_attr_set_args(args);
+}
+
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
@@ -676,76 +714,6 @@ xfs_attr_leaf_addname(
 
 	trace_xfs_attr_leaf_addname(args);
 
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-
-		return error;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
 	/*
 	 * Read in the block containing the "old" attr, then remove the "old"
 	 * attr from that block (neat, huh!)
@@ -923,7 +891,7 @@ xfs_attr_node_addname(
 	 * Fill in bucket of arguments/results/context to carry around.
 	 */
 	dp = args->dp;
-restart:
+
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
@@ -967,21 +935,10 @@ xfs_attr_node_addname(
 			xfs_da_state_free(state);
 			state = NULL;
 			error = xfs_attr3_leaf_to_node(args);
-			if (error)
-				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-
-			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
@@ -993,9 +950,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1010,70 +964,23 @@ xfs_attr_node_addname(
 	xfs_da_state_free(state);
 	state = NULL;
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
+	return 0;
 
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
+out:
+	if (state)
+		xfs_da_state_free(state);
 	if (error)
-		goto out;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
+		return error;
+	return retval;
+}
 
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
+STATIC int
+xfs_attr_node_addname_work(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state;
+	struct xfs_da_state_blk	*blk;
+	int			retval, error;
 
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 48d8e9caf86f..2c02875a4930 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -441,7 +441,7 @@ xfs_attr_rmtval_get(
  * Find a "hole" in the attribute address space large enough for us to drop the
  * new attribute's value into
  */
-STATIC int
+int
 xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
@@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
 	return 0;
 }
 
-STATIC int
+int
 xfs_attr_rmtval_set_value(
 	struct xfs_da_args	*args)
 {
@@ -567,64 +567,31 @@ xfs_attr_rmtval_stale(
  */
 int
 xfs_attr_rmtval_set(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	xfs_dablk_t		*lblkno,
+	int			*blkcnt)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
 	int			nmap;
 	int			error;
 
-	trace_xfs_attr_rmtval_set(args);
-
-	error = xfs_attr_rmt_find_hole(args);
+	nmap = 1;
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)*lblkno,
+			  *blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
+			  &nmap);
 	if (error)
 		return error;
 
-	blkcnt = args->rmtblkcnt;
-	lblkno = (xfs_dablk_t)args->rmtblkno;
-	/*
-	 * Roll through the "value", allocating blocks on disk as required.
-	 */
-	while (blkcnt > 0) {
-		/*
-		 * Allocate a single extent, up to the size of the value.
-		 *
-		 * Note that we have to consider this a data allocation as we
-		 * write the remote attribute without logging the contents.
-		 * Hence we must ensure that we aren't using blocks that are on
-		 * the busy list so that we don't overwrite blocks which have
-		 * recently been freed but their transactions are not yet
-		 * committed to disk. If we overwrite the contents of a busy
-		 * extent and then crash then the block may not contain the
-		 * correct metadata after log recovery occurs.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
-				  &nmap);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-		lblkno += map.br_blockcount;
-		blkcnt -= map.br_blockcount;
+	ASSERT(nmap == 1);
+	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
+	       (map.br_startblock != HOLESTARTBLOCK));
+	*lblkno += map.br_blockcount;
+	*blkcnt -= map.br_blockcount;
 
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
-
-	return xfs_attr_rmtval_set_value(args);
+	if (*blkcnt)
+		return -EAGAIN;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9eee615da156..74d768dd8afa 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -7,9 +7,11 @@
 #define	__XFS_ATTR_REMOTE_H__
 
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args);
+int xfs_attr_rmtval_set(struct xfs_da_args *args, xfs_dablk_t *, int *);
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
-- 
2.26.2

