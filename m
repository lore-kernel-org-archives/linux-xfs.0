Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BA5C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 14:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB5A2332A
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 14:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgLWORn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 09:17:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729003AbgLWORm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Dec 2020 09:17:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608732975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=twO58+btXJGXsfiNu+gMcqHt20ufMip1gNtePoaUNio=;
        b=a78hRv6aYkT+r8+LX+TA4e2N/bmH7c94XJUy5oYNOUOKWMcU52gQrLoewLuznMIXgFTmq6
        eIBUHcR9h+mXcx7e37dQmShnGT30aNpRFKjziDpJnaFJ4BvnExGmn2Uu/0rQv/kpLjfJEq
        dK8/aWmVoVFMloU4ZWpgbsoJP8HuYf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-ULnyv_oJMcuOhUM_WA0y2g-1; Wed, 23 Dec 2020 09:16:13 -0500
X-MC-Unique: ULnyv_oJMcuOhUM_WA0y2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E1B4193413E;
        Wed, 23 Dec 2020 14:16:08 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A800369A;
        Wed, 23 Dec 2020 14:16:07 +0000 (UTC)
Date:   Wed, 23 Dec 2020 09:16:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
Message-ID: <20201223141606.GA2911764@bfoster>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-5-allison.henderson@oracle.com>
 <20201222171148.GC2808393@bfoster>
 <20201222172020.GD2808393@bfoster>
 <20201222184451.GE2808393@bfoster>
 <4d3a8199-4d8f-2691-6ad0-1f7d0aa9500c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d3a8199-4d8f-2691-6ad0-1f7d0aa9500c@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 22, 2020 at 10:20:16PM -0700, Allison Henderson wrote:
> 
> 
> On 12/22/20 11:44 AM, Brian Foster wrote:
> > On Tue, Dec 22, 2020 at 12:20:20PM -0500, Brian Foster wrote:
> > > On Tue, Dec 22, 2020 at 12:11:48PM -0500, Brian Foster wrote:
> > > > On Fri, Dec 18, 2020 at 12:29:06AM -0700, Allison Henderson wrote:
> > > > > This patch modifies the attr remove routines to be delay ready. This
> > > > > means they no longer roll or commit transactions, but instead return
> > > > > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > > > > this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> > > > > uses a sort of state machine like switch to keep track of where it was
> > > > > when EAGAIN was returned. xfs_attr_node_removename has also been
> > > > > modified to use the switch, and a new version of xfs_attr_remove_args
> > > > > consists of a simple loop to refresh the transaction until the operation
> > > > > is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
> > > > > transaction where ever the existing code used to.
> > > > > 
> > > > > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > > > > version __xfs_attr_rmtval_remove. We will rename
> > > > > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > > > > done.
> > > > > 
> > > > > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > > > > during a rename).  For reasons of preserving existing function, we
> > > > > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > > > > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > > > > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > > > > used and will be removed.
> > > > > 
> > > > > This patch also adds a new struct xfs_delattr_context, which we will use
> > > > > to keep track of the current state of an attribute operation. The new
> > > > > xfs_delattr_state enum is used to track various operations that are in
> > > > > progress so that we know not to repeat them, and resume where we left
> > > > > off before EAGAIN was returned to cycle out the transaction. Other
> > > > > members take the place of local variables that need to retain their
> > > > > values across multiple function recalls.  See xfs_attr.h for a more
> > > > > detailed diagram of the states.
> > > > > 
> > > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > > ---
> > > > 
> > > > I started with a couple small comments on this patch but inevitably
> > > > started thinking more about the factoring again and ended up with a
> > > > couple patches on top. The first is more of some small tweaks and
> > > > open-coding that IMO makes this patch a bit easier to follow. The
> > > > second is more of an RFC so I'll follow up with that in a second email.
> > > > I'm curious what folks' thoughts might be on either. Also note that I'm
> > > > primarily focusing on code structure and whatnot here, so these are fast
> > > > and loose, compile tested only and likely to be broken.
> > > > 
> > > 
> > > ... and here's the second diff (applies on top of the first).
> > > 
> > > This one popped up after staring at the previous changes for a bit and
> > > wondering whether using "done flags" might make the whole thing easier
> > > to follow than incremental state transitions. I think the attr remove
> > > path is easy enough to follow with either method, but the attr set path
> > > is a beast and so this is more with that in mind. Initial thoughts?
> > > 
> > 
> > Eh, the more I stare at the attr set code I'm not sure this by itself is
> > much of an improvement. It helps in some areas, but there are so many
> > transaction rolls embedded throughout at different levels that a larger
> > rework of the code is probably still necessary. Anyways, this was just a
> > random thought for now..
> > 
> > Brian
> 
> No worries, I know the feeling :-)  The set works and all, but I do think
> there is struggle around trying to find a particularly pleasent looking
> presentation of it.  Especially when we get into the set path, it's a bit
> more complex.  I may pick through the patches you habe here and pick up the
> whitespace cleanups and other style adjustments if people prefer it that
> way.  The good news is, a lot of the *_args routines are supposed to
> disappear at the end of the set, so there's not really a need to invest too
> much in them I suppose. It may help to jump to the "Set up infastructure"
> patch too.  I've expanded the diagram to try and help illustrait the code
> flow a bit, so that may help with following the code flow.
> 

I'm sure.. :P Note that the first patch was more smaller tweaks and
refactoring with the existing model in mind. For the set path, the
challenge IMO is to make the code generally more readable. I think the
remove path accomplishes this for the most part because the states and
whatnot are fairly low overhead on top of the existing complexity. This
changes considerably for the set path, not so much due to the mechanism
but because the baseline code is so fragmented and complex from the
start. I am slightly concerned that bolting state management onto the
current code as such might make it harder to grok and clean up after the
fact, but I could be wrong about that (my hope was certainly for the
opposite).

Regardless, that had me shifting focus a bit and playing around with the
current upstream code as opposed to shifting around your code. ISTM that
there is some commonality across the various set codepaths and perhaps
there is potential to simplify things notably _before_ applying the
state management scheme. I've appended a new diff below (based on
for-next) that starts to demonstrate what I mean. Note again that this
is similarly fast and loose as I've knowingly threw away some quirks of
the code (i.e. leaf buffer bhold) for the purpose of quickly trying to
explore/POC whether the factoring might be sane and plausible.

In summary, this combines the "try addname" part of each xattr format to
fall under a single transaction rolling loop such that I think the
resulting function could become one high level state. I ran out of time
for working through the rest, but from a read through it seems there's
at least a chance we could continue with similar refactoring and
reduction to a fewer number of generic states (vs. more format-specific
states). For example, the remaining parts of the set operation all seem
to have something along the lines of the following high level
components:

- remote value block allocation (and value set)
- if rename == true, clear flag and done
- if rename == false, flip flags
	- remove old xattr (i.e., similar to xattr remove)

... where much of that code looks remarkably similar across the
different leaf/node code branches. So I'm curious what you and others
following along might think about something like this as an intermediate
step...

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e6418a0d3..eff8833d5303 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -58,6 +58,8 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *, struct xfs_buf *);
+STATIC int xfs_attr_node_addname_work(struct xfs_da_args *);
 
 int
 xfs_inode_hasattr(
@@ -216,116 +218,93 @@ xfs_attr_is_shortform(
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
-			return error;
-
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
+	}
+
+	error = xfs_attr_node_addname_work(args);
+	return error;
+}
+
+int
+xfs_attr_set_args(
+	struct xfs_da_args	*args)
+
+{
+	int			error;
+	bool			done = false;
+
+	do {
+		error = xfs_attr_set_fmt(args, &done);
+		if (error != -EAGAIN)
+			break;
 
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
 		error = xfs_defer_finish(&args->trans);
 		if (error)
-			return error;
+			break;
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	} while (!error);
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
+	if (error || done)
+		return error;
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	error = xfs_defer_finish(&args->trans);
+	if (!error)
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		return error;
+
+	return __xfs_attr_set_args(args);
 }
 
 /*
@@ -676,18 +655,6 @@ xfs_attr_leaf_addname(
 
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
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
 	 * identified for its storage and copy the value.  This is done
@@ -923,7 +890,7 @@ xfs_attr_node_addname(
 	 * Fill in bucket of arguments/results/context to carry around.
 	 */
 	dp = args->dp;
-restart:
+
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
@@ -967,21 +934,10 @@ xfs_attr_node_addname(
 			xfs_da_state_free(state);
 			state = NULL;
 			error = xfs_attr3_leaf_to_node(args);
-			if (error)
-				goto out;
-			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out;
 
-			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
-			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
@@ -993,9 +949,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1010,13 +963,23 @@ xfs_attr_node_addname(
 	xfs_da_state_free(state);
 	state = NULL;
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
+	return 0;
+
+out:
+	if (state)
+		xfs_da_state_free(state);
 	if (error)
-		goto out;
+		return error;
+	return retval;
+}
+
+STATIC int
+xfs_attr_node_addname_work(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state;
+	struct xfs_da_state_blk	*blk;
+	int			retval, error;
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we

