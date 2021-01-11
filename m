Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B27BC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 14:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCE8224B1
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 14:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbhAKOSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 09:18:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726442AbhAKOSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 09:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610374636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ue8DLRzAJrD0qrmgiuw/qKmH0EGcUi2y/aa31x0arEE=;
        b=O/0D6ey79ElXAQjpfnf+6rwWYyaEj+V9ib3W0f7OWcSUEqpIcZ6yq7Hkk4sblHZ57sVlS+
        MSqe2jPfVPtXp7FcYq+/jV+5WMBnE+b1bJlAQ/PTfHOUWwa4KInbJeB8b0LBxy4ZZnBlpy
        RcqEMJh38Muh8j6B4mkltSCOpIKNdYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-TaDmBFj_P9-1_hH5rsszpA-1; Mon, 11 Jan 2021 09:17:12 -0500
X-MC-Unique: TaDmBFj_P9-1_hH5rsszpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EAE88030AF;
        Mon, 11 Jan 2021 14:17:11 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5758D5D9F8;
        Mon, 11 Jan 2021 14:17:10 +0000 (UTC)
Date:   Mon, 11 Jan 2021 09:17:08 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: refactor xfs_attr_set() into incremental
 components
Message-ID: <20210111141708.GB1091932@bfoster>
References: <20210107161444.858242-1-bfoster@redhat.com>
 <193dbb11-9a1d-5654-56f0-2f6a8347cca3@oracle.com>
 <20210108140238.GA893097@bfoster>
 <1308b69a-dcc1-787c-3e20-581b523d46d9@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1308b69a-dcc1-787c-3e20-581b523d46d9@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 11, 2021 at 12:45:29AM -0700, Allison Henderson wrote:
> 
> 
> On 1/8/21 7:02 AM, Brian Foster wrote:
> > On Fri, Jan 08, 2021 at 12:13:03AM -0700, Allison Henderson wrote:
> > > 
> > > 
> > > On 1/7/21 9:14 AM, Brian Foster wrote:
> > > > POC to explore whether xfs_attr_set() can be refactored into
> > > > incremental components to facilitate isolated state management.
> > > > 
> > > > Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > Hi all,
> > > > 
> > > > This is a followup to the ongoing discussion with Allison around delayed
> > > > attrs and the xfs_attr_set() path in particular. It is a continuation of
> > > > the RFC patch posted here[1]. One of the things that concerns me about
> > > > the current approach is not so much the state management, but the
> > > > resulting structure that the current xattr implementation imposes on the
> > > > state machine code. Earlier on in this effort, we discussed an objective
> > > > to keep the state management code as isolated as possible (ideally to a
> > > > single level) from the functional xattr code. The purpose of this RFC is
> > > > to explore whether the existing code can be refactored in such a way to
> > > > accommodate that.
> > > > 
> > > > Note that this is patch is not intended to be functional. It is compile
> > > > tested only, takes intentional shortcuts, and is intended only to
> > > > illustrate an idea / potential approach. IOW, this was essentially a
> > > > blitz through the set codepath to try and determine whether this kind of
> > > > approach was feasible, not necessarily an attempt to implement it
> > > > correctly.
> > > > 
> > > > Also note that some code has been borrowed from Allison's series, but
> > > > otherwise a crude state machine mechanism has been hacked in just to
> > > > support the associated refactoring. This state machine code is not
> > > > intended to replace the broader mechanism Allison has implemented. I
> > > > needed something to support breaking down the code into components and
> > > > didn't want to pull in a world of infrastructure, so I hacked in the
> > > > bare minimal mechanism necessary to support that effort. This state
> > > > management code should ultimately be thrown away and is not the focus of
> > > > the patch. I do have a local git branch with more granular commits, but
> > > > it's kind of a mess atm so I squashed this down to a single patch since
> > > > it is primarily intended to generate discussion.
> > > > 
> > > > The flow of development was generally as follows:
> > > > 
> > > > 1. Implement a basic transaction rolling and function reentry loop
> > > > (based on -EAGAIN). This is the primary loop in xfs_attr_set_iter() and
> > > > based on Allison's code.
> > > > 
> > > > 2. Tack on a crude mechanism to implement incremental states. This is
> > > > essentially the switch statement inside the aforementioned loop. Any
> > > > state that returns -EAGAIN is reentered after a transaction roll.
> > > > Otherwise a non-error return increments to the next state. Note that
> > > > some states are semi-artificial in that they don't ever repeat, so could
> > > > potentially be optimized away.
> > > > 
> > > > 3. With the above infrastructure in place, incrementally convert the
> > > > existing xattr set implementation into reentrant components. This is
> > > > accomplished by peeling off bits of the existing implemention that are
> > > > currently separated by explicit transaction rolls and working them into
> > > > the state management loop. On termination of the loop, we call into the
> > > > remainder of the explicit rolling implementation to maintain
> > > > functionality.
> > > > 
> > > > The state machine consists of the following high level states:
> > > > 
> > > > 0. Set the xattr fork format and add the attr name. This state repeats
> > > > as the fork is converted into something that can hold the requested
> > > > xattr. If the set completes in shortform format, the entire operation
> > > > completes.
> > > > 1. Find a hole for a remote value, if necessary. This state does not
> > > > repeat or roll the transaction.
> > > > 2. Allocate blocks for the remote value, if necessary. This state
> > > > repeats until all required blocks are allocated.
> > > > 3. Write the remote value, if necessary. This state does not repeat or
> > > > roll.
> > > > 4. Clear or flip the inactive flag depending on whether the set is a
> > > > rename. If !rename, the flag is cleared and the set returns. Otherwise,
> > > > the flag is flipped to the old xattr and we progress to the next state.
> > > > 5. Invalidate remote blocks for the old xattr, if necessary. This state
> > > > does not roll or repeat.
> > > > 6. Remove remote blocks from the old xattr. This state repeats until all
> > > > extents for the old remote value are removed.
> > > > 
> > > > Finally, we fall back into what remains of the existing leaf/node
> > > > implementations. At this point this consists of removing the old xattr
> > > > name and some final attr fork format cleanup, if necessary. This code
> > > > should ultimately be reworked as well, but I didn't see any transaction
> > > > rolls through here and so decided it was sufficient to stop at this
> > > > point for the purpose of the RFC.
> > > > 
> > > > To me, the primary takeaways from this are that it seems reasonably
> > > > possible to clean up the xattr set codepath such that we don't require a
> > > > large number of per-format states and that we can do so in a way that
> > > > state management code is isolated to a single function (or single switch
> > > > statement). This is demonstrated by explicitly containing throwaway
> > > > state management code within xfs_attr_set_iter() and refactoring the
> > > > functional code into components that either complete (return 0) or
> > > > repeat (return -EAGAIN). Though it may not be apparent from the squashed
> > > > together RFC patch, this also suggests a more incremental development
> > > > approach is possible, as this patch was developed in a manner that
> > > > implemented one (or several related) states at a time with the intent to
> > > > maintain functionality at each step. Thoughts? >
> > > > Brian
> > > 
> > > Alrighty, I think I see what you mean to illustrate here.  Maybe I can use
> > > what you have here as a sort of guide to get a functional version working.
> > > I think it may look a little cleaner once we get it there since a lot of
> > > this is a bit of a substitute for the bigger set.  I will see if I can work
> > > through it and post back.  Or if something doesnt work, I'll make of note of
> > > it.
> > > 
> > 
> > ... or just point it out in this thread. ;)
> > 
> > But yeah, unless something is blatantly wrong or I missed something that
> > causes a significant impedence mismatch with your state management
> > design (both of which are quite possible :), this is intended to be a
> > map of sorts for a proposed refactoring of xattr set and state breakdown
> > to factor out of that. To try and generalize it even further, I think
> > the big question is can we break everything down such that the end
> > result (before getting into dfops and pptrs and whatnot) looks something
> > like:
> > 
> > xfs_attr_set_args()
> > {
> > 	do {
> > 		xfs_attr_set_iter();
> > 		<roll on -EAGAIN>
> > 	} while (...);
> > 	...
> > }
> > 
> > xfs_attr_set_iter()
> > {
> > 	switch (ctx->da_state) {
> > 	case INIT:
> > 		...
> > 		break;
> > 	case ADDNAME:
> > 		...
> > 		break;
> > 	case RMTBLKSTUFF:
> > 		if (!rmtblk) {
> > 			->da_state = FLAGSTUFF;
> > 			break;
> > 		}
> > 		<do_rmt_stuff>
> > 		break;
> > 	case MORERMTBLKSTUFF:
> > 		...
> > 		break;
> > 	case FLAGSTUFF:
> > 		...
> > 		break;
> > 	...
> > 	};
> > 	...
> > }
> > 
> > ... where there is essentially no other state aware code outside of
> > xfs_attr_set_iter(). I had these two squashed into a single function
> > just to be able use local variables across states because I didn't have
> > the context bits you've defined for that purpose. It doesn't necessarily
> > have to be a switch statement or whatever either, though I admit I do
> > kind of like the "bump to next state by default" pattern, particularly
> > if it reduces boilerplate state changes. The bigger picture is that all
> > of the functional components below this level either complete or repeat
> > (and are reentrant, if so), the higher level code just handles rolling
> > the transaction and pretty much all of the state flow is isolated to a
> > single function.
> Just wanted to follow up on this before too much time gets away.  I do think
> this will work, I cant promise will look exactly like what you have here,
> but I figure the point of the exercise is to see what it ends up looking
> like :-)  Once I get it worked out, I'll post back with the result.
> 

Great, and yes, the point is more to propose an alternative breakdown of
the existing code. I'd expect all the new state bits to look more like
what you've constructed already, with the exception of isolating the
state management and transitions to a single function.

> > 
> > Also, I can fire over a tarball of the patches in my local branch if you
> > wanted to see the individual breakdown (i.e. showing how to potentially
> > implement this a state at a time without having to reshuffle the whole
> > thing in a single patch). It's pretty much what I described in the
> > initial post, but sometimes it's just easier to see the code...
> Sure, I'll take what ever you have if it's already separated out.  I tend to
> just grab and move bits at a time to make sure things dont break as I go
> along.  For the most part, I think I can see which chunks went where from
> what you've hashed out here.  Will try to have it worked out this week :-)
> 

Same.. I just squashed it down to a single patch for the purpose of the
RFC. I've attached a tarball of my local dev tree for reference. Feel
free to ignore or reuse any of it...

Brian

> Thanks!
> Allison
> 
> > 
> > Brian
> > 
> > > Thank you for all your help, I know it's a really complicated set, but it
> > > feels like we're makeing progress :-)
> > > 
> > > Allison
> > > 
> > > 
> > > > 
> > > > [1] https://urldefense.com/v3/__https://lore.kernel.org/linux-xfs/20201218072917.16805-1-allison.henderson@oracle.com/T/*m3fcf7be3a8154ab98ddc9e1d45bc764d79d39dc3__;Iw!!GqivPVa7Brio!Le5Q-6GnjBKTG_b64Oh7dGImvE5RQbKK0mrqUaxi0Bl7bWhrtqDKXuIh_j3_vIYI5ibg$
> > > > 
> > > >    fs/xfs/libxfs/xfs_attr.c        | 361 ++++++++++++--------------------
> > > >    fs/xfs/libxfs/xfs_attr_remote.c |  67 ++----
> > > >    fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
> > > >    3 files changed, 154 insertions(+), 278 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index fd8e6418a0d3..216055b6ad0d 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -58,6 +58,9 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > > >    				 struct xfs_da_state **state);
> > > >    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> > > >    STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> > > > +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *, struct xfs_buf *);
> > > > +STATIC int xfs_attr_node_addname_work(struct xfs_da_args *);
> > > > +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> > > >    int
> > > >    xfs_inode_hasattr(
> > > > @@ -216,118 +219,153 @@ xfs_attr_is_shortform(
> > > >    		ip->i_afp->if_nextents == 0);
> > > >    }
> > > > -/*
> > > > - * Attempts to set an attr in shortform, or converts short form to leaf form if
> > > > - * there is not enough room.  If the attr is set, the transaction is committed
> > > > - * and set to NULL.
> > > > - */
> > > > -STATIC int
> > > > -xfs_attr_set_shortform(
> > > > +int
> > > > +xfs_attr_set_fmt(
> > > >    	struct xfs_da_args	*args,
> > > > -	struct xfs_buf		**leaf_bp)
> > > > +	bool			*done)
> > > >    {
> > > >    	struct xfs_inode	*dp = args->dp;
> > > > -	int			error, error2 = 0;
> > > > +	struct xfs_buf		*leaf_bp = NULL;
> > > > +	int			error = 0;
> > > > -	/*
> > > > -	 * Try to add the attr to the attribute list in the inode.
> > > > -	 */
> > > > -	error = xfs_attr_try_sf_addname(dp, args);
> > > > -	if (error != -ENOSPC) {
> > > > -		error2 = xfs_trans_commit(args->trans);
> > > > -		args->trans = NULL;
> > > > -		return error ? error : error2;
> > > > +	if (xfs_attr_is_shortform(dp)) {
> > > > +		error = xfs_attr_try_sf_addname(dp, args);
> > > > +		if (!error)
> > > > +			*done = true;
> > > > +		if (error != -ENOSPC)
> > > > +			return error;
> > > > +
> > > > +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> > > > +		if (error)
> > > > +			return error;
> > > > +		return -EAGAIN;
> > > >    	}
> > > > -	/*
> > > > -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> > > > -	 * another possible req'mt for a double-split btree op.
> > > > -	 */
> > > > -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> > > > -	if (error)
> > > > -		return error;
> > > > -	/*
> > > > -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> > > > -	 * push cannot grab the half-baked leaf buffer and run into problems
> > > > -	 * with the write verifier. Once we're done rolling the transaction we
> > > > -	 * can release the hold and add the attr to the leaf.
> > > > -	 */
> > > > -	xfs_trans_bhold(args->trans, *leaf_bp);
> > > > -	error = xfs_defer_finish(&args->trans);
> > > > -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> > > > -	if (error) {
> > > > -		xfs_trans_brelse(args->trans, *leaf_bp);
> > > > -		return error;
> > > > +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > > +		struct xfs_buf	*bp = NULL;
> > > > +
> > > > +		error = xfs_attr_leaf_try_add(args, bp);
> > > > +		if (error != -ENOSPC)
> > > > +			return error;
> > > > +
> > > > +		error = xfs_attr3_leaf_to_node(args);
> > > > +		if (error)
> > > > +			return error;
> > > > +		return -EAGAIN;
> > > >    	}
> > > > -	return 0;
> > > > +	return xfs_attr_node_addname(args);
> > > >    }
> > > >    /*
> > > >     * Set the attribute specified in @args.
> > > >     */
> > > >    int
> > > > -xfs_attr_set_args(
> > > > +__xfs_attr_set_args(
> > > >    	struct xfs_da_args	*args)
> > > >    {
> > > >    	struct xfs_inode	*dp = args->dp;
> > > > -	struct xfs_buf          *leaf_bp = NULL;
> > > >    	int			error = 0;
> > > > -	/*
> > > > -	 * If the attribute list is already in leaf format, jump straight to
> > > > -	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> > > > -	 * list; if there's no room then convert the list to leaf format and try
> > > > -	 * again.
> > > > -	 */
> > > > -	if (xfs_attr_is_shortform(dp)) {
> > > > -
> > > > -		/*
> > > > -		 * If the attr was successfully set in shortform, the
> > > > -		 * transaction is committed and set to NULL.  Otherwise, is it
> > > > -		 * converted from shortform to leaf, and the transaction is
> > > > -		 * retained.
> > > > -		 */
> > > > -		error = xfs_attr_set_shortform(args, &leaf_bp);
> > > > -		if (error || !args->trans)
> > > > -			return error;
> > > > -	}
> > > > -
> > > >    	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > > >    		error = xfs_attr_leaf_addname(args);
> > > > -		if (error != -ENOSPC)
> > > > +		if (error)
> > > >    			return error;
> > > > +	}
> > > > -		/*
> > > > -		 * Promote the attribute list to the Btree format.
> > > > -		 */
> > > > -		error = xfs_attr3_leaf_to_node(args);
> > > > -		if (error)
> > > > +	error = xfs_attr_node_addname_work(args);
> > > > +	return error;
> > > > +}
> > > > +
> > > > +int
> > > > +xfs_attr_set_iter(
> > > > +	struct xfs_da_args	*args,
> > > > +	bool			*done)
> > > > +{
> > > > +	int			error;
> > > > +	int			state = 0;
> > > > +	xfs_dablk_t		lblkno;
> > > > +	int			blkcnt;
> > > > +
> > > > +	do {
> > > > +		switch (state) {
> > > > +		case 0:	/* SET_FMT */
> > > > +			error = xfs_attr_set_fmt(args, done);
> > > > +			if (*done)
> > > > +				return error;
> > > > +			break;
> > > > +		case 1: /* RMT_FIND_HOLE */
> > > > +			if (args->rmtblkno <= 0)
> > > > +				break;
> > > > +
> > > > +			trace_xfs_attr_rmtval_set(args);
> > > > +			error = xfs_attr_rmt_find_hole(args);
> > > > +			lblkno = (xfs_dablk_t)args->rmtblkno;
> > > > +			blkcnt = args->rmtblkcnt;
> > > > +			state++;
> > > > +			continue;
> > > > +		case 2: /* RMTVAL_ALLOC */
> > > > +			if (args->rmtblkno <= 0)
> > > > +				break;
> > > > +			error = xfs_attr_rmtval_set(args, &lblkno, &blkcnt);
> > > > +			break;
> > > > +		case 3: /* RMTVAL_SET */
> > > > +			if (args->rmtblkno <= 0)
> > > > +				break;
> > > > +			error = xfs_attr_rmtval_set_value(args);
> > > > +			state++;
> > > > +			continue;
> > > > +		case 4:	/* SET_FLAG */
> > > > +			if (args->op_flags & XFS_DA_OP_RENAME) {
> > > > +				error = xfs_attr3_leaf_flipflags(args);
> > > > +			} else {
> > > > +				if (args->rmtblkno > 0)
> > > > +					error = xfs_attr3_leaf_clearflag(args);
> > > > +				return error;
> > > > +			}
> > > > +			break;
> > > > +		case 5: /* RMT_INVALIDATE */
> > > > +			xfs_attr_restore_rmt_blk(args);
> > > > +			if (args->rmtblkno)
> > > > +				error = xfs_attr_rmtval_invalidate(args);
> > > > +			state++;
> > > > +			continue;
> > > > +		case 6: /* RMT_REMOVE */
> > > > +			error = __xfs_attr_rmtval_remove(args);
> > > > +			break;
> > > > +		default:
> > > >    			return error;
> > > > +		};
> > > > -		/*
> > > > -		 * Finish any deferred work items and roll the transaction once
> > > > -		 * more.  The goal here is to call node_addname with the inode
> > > > -		 * and transaction in the same state (inode locked and joined,
> > > > -		 * transaction clean) no matter how we got to this step.
> > > > -		 */
> > > > -		error = xfs_defer_finish(&args->trans);
> > > > -		if (error)
> > > > +		if (!error)
> > > > +			state++;
> > > > +		else if (error != -EAGAIN)
> > > >    			return error;
> > > > -		/*
> > > > -		 * Commit the current trans (including the inode) and
> > > > -		 * start a new one.
> > > > -		 */
> > > > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > > > +		error = xfs_defer_finish(&args->trans);
> > > >    		if (error)
> > > > -			return error;
> > > > -	}
> > > > +			break;
> > > > +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > > +	} while (!error);
> > > > -	error = xfs_attr_node_addname(args);
> > > >    	return error;
> > > >    }
> > > > +int
> > > > +xfs_attr_set_args(
> > > > +	struct xfs_da_args	*args)
> > > > +
> > > > +{
> > > > +	int			error;
> > > > +	bool			done = false;
> > > > +
> > > > +	error = xfs_attr_set_iter(args, &done);
> > > > +	if (error || done)
> > > > +		return error;
> > > > +
> > > > +	return __xfs_attr_set_args(args);
> > > > +}
> > > > +
> > > >    /*
> > > >     * Return EEXIST if attr is found, or ENOATTR if not
> > > >     */
> > > > @@ -676,76 +714,6 @@ xfs_attr_leaf_addname(
> > > >    	trace_xfs_attr_leaf_addname(args);
> > > > -	error = xfs_attr_leaf_try_add(args, bp);
> > > > -	if (error)
> > > > -		return error;
> > > > -
> > > > -	/*
> > > > -	 * Commit the transaction that added the attr name so that
> > > > -	 * later routines can manage their own transactions.
> > > > -	 */
> > > > -	error = xfs_trans_roll_inode(&args->trans, dp);
> > > > -	if (error)
> > > > -		return error;
> > > > -
> > > > -	/*
> > > > -	 * If there was an out-of-line value, allocate the blocks we
> > > > -	 * identified for its storage and copy the value.  This is done
> > > > -	 * after we create the attribute so that we don't overflow the
> > > > -	 * maximum size of a transaction and/or hit a deadlock.
> > > > -	 */
> > > > -	if (args->rmtblkno > 0) {
> > > > -		error = xfs_attr_rmtval_set(args);
> > > > -		if (error)
> > > > -			return error;
> > > > -	}
> > > > -
> > > > -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> > > > -		/*
> > > > -		 * Added a "remote" value, just clear the incomplete flag.
> > > > -		 */
> > > > -		if (args->rmtblkno > 0)
> > > > -			error = xfs_attr3_leaf_clearflag(args);
> > > > -
> > > > -		return error;
> > > > -	}
> > > > -
> > > > -	/*
> > > > -	 * If this is an atomic rename operation, we must "flip" the incomplete
> > > > -	 * flags on the "new" and "old" attribute/value pairs so that one
> > > > -	 * disappears and one appears atomically.  Then we must remove the "old"
> > > > -	 * attribute/value pair.
> > > > -	 *
> > > > -	 * In a separate transaction, set the incomplete flag on the "old" attr
> > > > -	 * and clear the incomplete flag on the "new" attr.
> > > > -	 */
> > > > -
> > > > -	error = xfs_attr3_leaf_flipflags(args);
> > > > -	if (error)
> > > > -		return error;
> > > > -	/*
> > > > -	 * Commit the flag value change and start the next trans in series.
> > > > -	 */
> > > > -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > > -	if (error)
> > > > -		return error;
> > > > -
> > > > -	/*
> > > > -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> > > > -	 * (if it exists).
> > > > -	 */
> > > > -	xfs_attr_restore_rmt_blk(args);
> > > > -
> > > > -	if (args->rmtblkno) {
> > > > -		error = xfs_attr_rmtval_invalidate(args);
> > > > -		if (error)
> > > > -			return error;
> > > > -
> > > > -		error = xfs_attr_rmtval_remove(args);
> > > > -		if (error)
> > > > -			return error;
> > > > -	}
> > > > -
> > > >    	/*
> > > >    	 * Read in the block containing the "old" attr, then remove the "old"
> > > >    	 * attr from that block (neat, huh!)
> > > > @@ -923,7 +891,7 @@ xfs_attr_node_addname(
> > > >    	 * Fill in bucket of arguments/results/context to carry around.
> > > >    	 */
> > > >    	dp = args->dp;
> > > > -restart:
> > > > +
> > > >    	/*
> > > >    	 * Search to see if name already exists, and get back a pointer
> > > >    	 * to where it should go.
> > > > @@ -967,21 +935,10 @@ xfs_attr_node_addname(
> > > >    			xfs_da_state_free(state);
> > > >    			state = NULL;
> > > >    			error = xfs_attr3_leaf_to_node(args);
> > > > -			if (error)
> > > > -				goto out;
> > > > -			error = xfs_defer_finish(&args->trans);
> > > > -			if (error)
> > > > -				goto out;
> > > > -
> > > > -			/*
> > > > -			 * Commit the node conversion and start the next
> > > > -			 * trans in the chain.
> > > > -			 */
> > > > -			error = xfs_trans_roll_inode(&args->trans, dp);
> > > >    			if (error)
> > > >    				goto out;
> > > > -			goto restart;
> > > > +			return -EAGAIN;
> > > >    		}
> > > >    		/*
> > > > @@ -993,9 +950,6 @@ xfs_attr_node_addname(
> > > >    		error = xfs_da3_split(state);
> > > >    		if (error)
> > > >    			goto out;
> > > > -		error = xfs_defer_finish(&args->trans);
> > > > -		if (error)
> > > > -			goto out;
> > > >    	} else {
> > > >    		/*
> > > >    		 * Addition succeeded, update Btree hashvals.
> > > > @@ -1010,70 +964,23 @@ xfs_attr_node_addname(
> > > >    	xfs_da_state_free(state);
> > > >    	state = NULL;
> > > > -	/*
> > > > -	 * Commit the leaf addition or btree split and start the next
> > > > -	 * trans in the chain.
> > > > -	 */
> > > > -	error = xfs_trans_roll_inode(&args->trans, dp);
> > > > -	if (error)
> > > > -		goto out;
> > > > -
> > > > -	/*
> > > > -	 * If there was an out-of-line value, allocate the blocks we
> > > > -	 * identified for its storage and copy the value.  This is done
> > > > -	 * after we create the attribute so that we don't overflow the
> > > > -	 * maximum size of a transaction and/or hit a deadlock.
> > > > -	 */
> > > > -	if (args->rmtblkno > 0) {
> > > > -		error = xfs_attr_rmtval_set(args);
> > > > -		if (error)
> > > > -			return error;
> > > > -	}
> > > > -
> > > > -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> > > > -		/*
> > > > -		 * Added a "remote" value, just clear the incomplete flag.
> > > > -		 */
> > > > -		if (args->rmtblkno > 0)
> > > > -			error = xfs_attr3_leaf_clearflag(args);
> > > > -		retval = error;
> > > > -		goto out;
> > > > -	}
> > > > +	return 0;
> > > > -	/*
> > > > -	 * If this is an atomic rename operation, we must "flip" the incomplete
> > > > -	 * flags on the "new" and "old" attribute/value pairs so that one
> > > > -	 * disappears and one appears atomically.  Then we must remove the "old"
> > > > -	 * attribute/value pair.
> > > > -	 *
> > > > -	 * In a separate transaction, set the incomplete flag on the "old" attr
> > > > -	 * and clear the incomplete flag on the "new" attr.
> > > > -	 */
> > > > -	error = xfs_attr3_leaf_flipflags(args);
> > > > -	if (error)
> > > > -		goto out;
> > > > -	/*
> > > > -	 * Commit the flag value change and start the next trans in series
> > > > -	 */
> > > > -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > > +out:
> > > > +	if (state)
> > > > +		xfs_da_state_free(state);
> > > >    	if (error)
> > > > -		goto out;
> > > > -
> > > > -	/*
> > > > -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> > > > -	 * (if it exists).
> > > > -	 */
> > > > -	xfs_attr_restore_rmt_blk(args);
> > > > -
> > > > -	if (args->rmtblkno) {
> > > > -		error = xfs_attr_rmtval_invalidate(args);
> > > > -		if (error)
> > > > -			return error;
> > > > +		return error;
> > > > +	return retval;
> > > > +}
> > > > -		error = xfs_attr_rmtval_remove(args);
> > > > -		if (error)
> > > > -			return error;
> > > > -	}
> > > > +STATIC int
> > > > +xfs_attr_node_addname_work(
> > > > +	struct xfs_da_args	*args)
> > > > +{
> > > > +	struct xfs_da_state	*state;
> > > > +	struct xfs_da_state_blk	*blk;
> > > > +	int			retval, error;
> > > >    	/*
> > > >    	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > > index 48d8e9caf86f..2c02875a4930 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > > @@ -441,7 +441,7 @@ xfs_attr_rmtval_get(
> > > >     * Find a "hole" in the attribute address space large enough for us to drop the
> > > >     * new attribute's value into
> > > >     */
> > > > -STATIC int
> > > > +int
> > > >    xfs_attr_rmt_find_hole(
> > > >    	struct xfs_da_args	*args)
> > > >    {
> > > > @@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
> > > >    	return 0;
> > > >    }
> > > > -STATIC int
> > > > +int
> > > >    xfs_attr_rmtval_set_value(
> > > >    	struct xfs_da_args	*args)
> > > >    {
> > > > @@ -567,64 +567,31 @@ xfs_attr_rmtval_stale(
> > > >     */
> > > >    int
> > > >    xfs_attr_rmtval_set(
> > > > -	struct xfs_da_args	*args)
> > > > +	struct xfs_da_args	*args,
> > > > +	xfs_dablk_t		*lblkno,
> > > > +	int			*blkcnt)
> > > >    {
> > > >    	struct xfs_inode	*dp = args->dp;
> > > >    	struct xfs_bmbt_irec	map;
> > > > -	xfs_dablk_t		lblkno;
> > > > -	int			blkcnt;
> > > >    	int			nmap;
> > > >    	int			error;
> > > > -	trace_xfs_attr_rmtval_set(args);
> > > > -
> > > > -	error = xfs_attr_rmt_find_hole(args);
> > > > +	nmap = 1;
> > > > +	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)*lblkno,
> > > > +			  *blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> > > > +			  &nmap);
> > > >    	if (error)
> > > >    		return error;
> > > > -	blkcnt = args->rmtblkcnt;
> > > > -	lblkno = (xfs_dablk_t)args->rmtblkno;
> > > > -	/*
> > > > -	 * Roll through the "value", allocating blocks on disk as required.
> > > > -	 */
> > > > -	while (blkcnt > 0) {
> > > > -		/*
> > > > -		 * Allocate a single extent, up to the size of the value.
> > > > -		 *
> > > > -		 * Note that we have to consider this a data allocation as we
> > > > -		 * write the remote attribute without logging the contents.
> > > > -		 * Hence we must ensure that we aren't using blocks that are on
> > > > -		 * the busy list so that we don't overwrite blocks which have
> > > > -		 * recently been freed but their transactions are not yet
> > > > -		 * committed to disk. If we overwrite the contents of a busy
> > > > -		 * extent and then crash then the block may not contain the
> > > > -		 * correct metadata after log recovery occurs.
> > > > -		 */
> > > > -		nmap = 1;
> > > > -		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> > > > -				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> > > > -				  &nmap);
> > > > -		if (error)
> > > > -			return error;
> > > > -		error = xfs_defer_finish(&args->trans);
> > > > -		if (error)
> > > > -			return error;
> > > > -
> > > > -		ASSERT(nmap == 1);
> > > > -		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> > > > -		       (map.br_startblock != HOLESTARTBLOCK));
> > > > -		lblkno += map.br_blockcount;
> > > > -		blkcnt -= map.br_blockcount;
> > > > +	ASSERT(nmap == 1);
> > > > +	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> > > > +	       (map.br_startblock != HOLESTARTBLOCK));
> > > > +	*lblkno += map.br_blockcount;
> > > > +	*blkcnt -= map.br_blockcount;
> > > > -		/*
> > > > -		 * Start the next trans in the chain.
> > > > -		 */
> > > > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > > > -		if (error)
> > > > -			return error;
> > > > -	}
> > > > -
> > > > -	return xfs_attr_rmtval_set_value(args);
> > > > +	if (*blkcnt)
> > > > +		return -EAGAIN;
> > > > +	return 0;
> > > >    }
> > > >    /*
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > > > index 9eee615da156..74d768dd8afa 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > > @@ -7,9 +7,11 @@
> > > >    #define	__XFS_ATTR_REMOTE_H__
> > > >    int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
> > > > +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
> > > >    int xfs_attr_rmtval_get(struct xfs_da_args *args);
> > > > -int xfs_attr_rmtval_set(struct xfs_da_args *args);
> > > > +int xfs_attr_rmtval_set(struct xfs_da_args *args, xfs_dablk_t *, int *);
> > > > +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> > > >    int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > > >    int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> > > >    		xfs_buf_flags_t incore_flags);
> > > > 
> > > 
> > 
> 

--8t9RHnE3ZwKMSgU+
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs_attr_set-rfc.tar.bz2"
Content-Transfer-Encoding: base64

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
v+0CQoInAIyEIsbwQb0RyiB/4u5IpwoSBxTwkqA=

--8t9RHnE3ZwKMSgU+--

