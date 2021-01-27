Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC70C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 18:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E48AB64D9A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 18:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344381AbhA0R7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344363AbhA0R7P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 12:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GXFii9oGNudyImX8YxkiQJt2C7edeJDfXDZ8OhGoRU4=;
        b=FgoqBeeaQ1tPmNydjJpenkGK1Y/Me6fqoFkX5bh0HREfU0tt4fwy4Rx1a3aOO4yKTG4kKD
        4bmpvHH4buAwe3LZXmZt8W3wI5J5u2KZ9bry20LirZt2zlqE6Hiy0V0S0FBYUqvE8kcfTG
        l0siJob2W9etXFwP1SJjhQ3IUE6BfDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-cjAWJ4itOBys_W8JW7HB5Q-1; Wed, 27 Jan 2021 12:57:38 -0500
X-MC-Unique: cjAWJ4itOBys_W8JW7HB5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CEBC8066F1;
        Wed, 27 Jan 2021 17:57:37 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E48F35D6A1;
        Wed, 27 Jan 2021 17:57:36 +0000 (UTC)
Date:   Wed, 27 Jan 2021 12:57:35 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] xfs: refactor xfs_attr_set follow up
Message-ID: <20210127175735.GA2555063@bfoster>
References: <20210116081240.12478-1-allison.henderson@oracle.com>
 <20210121184720.GC1793795@bfoster>
 <ee542ded-3894-5511-bb83-beac5543ac6a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee542ded-3894-5511-bb83-beac5543ac6a@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 03:22:59PM -0700, Allison Henderson wrote:
> 
> 
> On 1/21/21 11:47 AM, Brian Foster wrote:
> > On Sat, Jan 16, 2021 at 01:12:40AM -0700, Allison Henderson wrote:
> > > Hi all,
> > > 
> > > This is a follow up to Brians earlier patch
> > > "[PATCH RFC] xfs: refactor xfs_attr_set() into incremental components"
> > > 
> > > This patch resembles the earlier patch, but it is seated at the top of
> > > the parent pointers set rather than the bottom to give a better
> > > illustraion of what this approach might end up looking like in the
> > > bigger picture.  This patch is both compiled and tested, and is meant to
> > > be more of an exploratory effort than anything.
> > > 
> > > Most of the state management is collapsed into the *_iter functions
> > > similar to Brians patch which collapsed them into the *_args routines.
> > > Though there are a few states that a still in a few subfunctions.
> > > 
> > > In anycase, I think it gives decent idea of what the solution might
> > > look like in practice.  Questions, comments and feedback appreciated.
> > > 
> > 
> > Thanks for the patch. By and large, I think the centralized state
> > management of __xfs_attr_set_iter() is much more clear than the label
> > management approach of jumping up and down through multiple levels of
> > helper functions. For the most part, I'm able to walk through the iter
> > function and follow the sequence of steps involved in the set. I did
> > have some higher level comments on various parts of the patch,
> > particularly where we seem to deviate from centralized state management.
> > 
> > Note that if we were to take this approach, a primary goal was to
> > incrementally port the existing xfs_attr_set_args() implementation into
> > states. For example, such that we could split the current monstrous
> > xfs_attr_set() patch into multiple patches that introduce infrastructure
> > first, and then convert the existing code a state or so at a time. That
> > eliminates churn from factoring code into one scheme only to immediately
> > refactor into another. It also facilitates testing because I think the
> > rework should be able to maintain functionality across each step.
> > 
> > Porting on top of the whole thing certainly helps to get an advanced
> > look at the final result. However, if we do use this approach and start
> > getting into the details of individual states and whatnot, I do think it
> > would be better to start breaking things down into smaller patches that
> > replace some of the earlier code rather than use it as a baseline.
> Sure, I think doing quick and dirty patches on top moves a little faster
> just because the infastructure is already setup, and I'm not working through
> merge conflicts, plus it cuts out the userspace side and just the misc nits
> that are probably best done after the greater architectural descisions are
> set.  The idea being to just establish an end goal of course.  It is tougher
> to review like this though, maybe we can do a few spins of this and I'll try
> to break it down into smaller chunks if that's ok.
> 
> 
> > Further comments inline...
> > 
> > > Thanks!
> > > Allison
> > > 
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 596 +++++++++++++++++++----------------------------
> > >   fs/xfs/libxfs/xfs_attr.h |   4 +-
> > >   2 files changed, 247 insertions(+), 353 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 6ba8f4b..356e35c 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
...
> > > @@ -274,108 +300,197 @@ xfs_attr_set_shortform(
...
> > > +int xfs_attr_set_iter(
> > > +	struct xfs_attr_item	*attr)
> > > +{
> > > +	bool	done = true;
> > > +	int 	error;
> > > +
> > > +	error =  __xfs_attr_set_iter(attr, &done);
> > > +	if (error || done)
> > > +		return error;
> > > +
> > > +	return xfs_attr_node_addname(attr);
> > 
> > Note that this was also intended to go away and get folded into the
> > state code in __xfs_attr_set_iter(), I just left off here because it
> > looked like there might have been opportunity to fall into the remove
> > path, and that was getting a bit more involved than I wanted to. This
> > variant looks a little different in that we can presumably fall into
> > this function and then back into the state machine. Even if we didn't
> > immediately reuse the remove path, I suspect we should probably continue
> > chunking off the remainder of the operation into proper states.
> Yes, I'm thinking maybe I could chop this down into a few patches that just
> sort of hoist everything up and then try to collapse down any duplicated
> code in a successive patch.  It'll create bit of a monster function at
> first, but I think it might help us find the an arrangement we like.
> 

FWIW, I've seen enough that the design seems sane and reasonable to me.
It addresses my primary gripe with the current implementation of
spreading the state management code around a bit too much. My previous
comments on this patch were around some of the detailed state breakdown
and management logic, but I don't think that really requires seeing the
whole thing completely done and functional to resolve. In fact, I'd
rather not get too deep into detailed functional and state review with
an RFC patch based on top of the current implementation, as this patch
is, because that will just have to be repeated when broken down into
smaller patches and rebased.

Of course, that is not to say we shouldn't continue down this RFC path
if you have other reasons to do so, aren't sold on the approach, have
design concerns, etc. I'm not totally clear on where we stand on that
tbh. This is just an FYI that if you want my .02, I think the design is
reasonable and I'd probably reserve detailed review for a proper non-rfc
series.

Brian

> Thanks for the reviews!  I know its complicated!!
> Allison
> 
> > 
> > Brian
> > 
> > > +}
> > > +
> > >   /*
> > >    * Return EEXIST if attr is found, or ENOATTR if not
> > >    */
> > > @@ -773,145 +888,6 @@ xfs_attr_leaf_try_add(
> > >   /*
> > > - * Add a name to the leaf attribute list structure
> > > - *
> > > - * This leaf block cannot have a "remote" value, we only call this routine
> > > - * if bmap_one_block() says there is only one block (ie: no remote blks).
> > > - *
> > > - * This routine is meant to function as a delayed operation, and may return
> > > - * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> > > - * to handle this, and recall the function until a successful error code is
> > > - * returned.
> > > - */
> > > -STATIC int
> > > -xfs_attr_leaf_addname(
> > > -	struct xfs_attr_item		*attr)
> > > -{
> > > -	struct xfs_da_args		*args = attr->xattri_da_args;
> > > -	struct xfs_buf			*bp = NULL;
> > > -	int				error, forkoff;
> > > -	struct xfs_inode		*dp = args->dp;
> > > -	struct xfs_mount		*mp = args->dp->i_mount;
> > > -
> > > -	/* State machine switch */
> > > -	switch (attr->xattri_dela_state) {
> > > -	case XFS_DAS_FLIP_LFLAG:
> > > -		goto das_flip_flag;
> > > -	case XFS_DAS_RM_LBLK:
> > > -		goto das_rm_lblk;
> > > -	default:
> > > -		break;
> > > -	}
> > > -
> > > -	/*
> > > -	 * If there was an out-of-line value, allocate the blocks we
> > > -	 * identified for its storage and copy the value.  This is done
> > > -	 * after we create the attribute so that we don't overflow the
> > > -	 * maximum size of a transaction and/or hit a deadlock.
> > > -	 */
> > > -
> > > -	/* Open coded xfs_attr_rmtval_set without trans handling */
> > > -	if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> > > -		attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
> > > -		if (args->rmtblkno > 0) {
> > > -			error = xfs_attr_rmtval_find_space(attr);
> > > -			if (error)
> > > -				return error;
> > > -		}
> > > -	}
> > > -
> > > -	/*
> > > -	 * Roll through the "value", allocating blocks on disk as
> > > -	 * required.
> > > -	 */
> > > -	if (attr->xattri_blkcnt > 0) {
> > > -		error = xfs_attr_rmtval_set_blk(attr);
> > > -		if (error)
> > > -			return error;
> > > -
> > > -		trace_xfs_das_state_return(attr->xattri_dela_state);
> > > -		return -EAGAIN;
> > > -	}
> > > -
> > > -	error = xfs_attr_rmtval_set_value(args);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> > > -		/*
> > > -		 * Added a "remote" value, just clear the incomplete flag.
> > > -		 */
> > > -		if (args->rmtblkno > 0)
> > > -			error = xfs_attr3_leaf_clearflag(args);
> > > -
> > > -		return error;
> > > -	}
> > > -
> > > -	/*
> > > -	 * If this is an atomic rename operation, we must "flip" the incomplete
> > > -	 * flags on the "new" and "old" attribute/value pairs so that one
> > > -	 * disappears and one appears atomically.  Then we must remove the "old"
> > > -	 * attribute/value pair.
> > > -	 *
> > > -	 * In a separate transaction, set the incomplete flag on the "old" attr
> > > -	 * and clear the incomplete flag on the "new" attr.
> > > -	 */
> > > -	if (!xfs_hasdelattr(mp)) {
> > > -		error = xfs_attr3_leaf_flipflags(args);
> > > -		if (error)
> > > -			return error;
> > > -		/*
> > > -		 * Commit the flag value change and start the next trans in series.
> > > -		 */
> > > -		attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
> > > -		trace_xfs_das_state_return(attr->xattri_dela_state);
> > > -		return -EAGAIN;
> > > -	}
> > > -das_flip_flag:
> > > -	/*
> > > -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> > > -	 * (if it exists).
> > > -	 */
> > > -	xfs_attr_restore_rmt_blk(args);
> > > -
> > > -	error = xfs_attr_rmtval_invalidate(args);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> > > -	attr->xattri_dela_state = XFS_DAS_RM_LBLK;
> > > -das_rm_lblk:
> > > -	if (args->rmtblkno) {
> > > -		error = xfs_attr_rmtval_remove(attr);
> > > -		if (error == -EAGAIN)
> > > -			trace_xfs_das_state_return(attr->xattri_dela_state);
> > > -		if (error)
> > > -			return error;
> > > -	}
> > > -
> > > -	/*
> > > -	 * Read in the block containing the "old" attr, then remove the "old"
> > > -	 * attr from that block (neat, huh!)
> > > -	 */
> > > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> > > -				   &bp);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	xfs_attr3_leaf_remove(bp, args);
> > > -
> > > -	/*
> > > -	 * If the result is small enough, shrink it all into the inode.
> > > -	 */
> > > -	forkoff = xfs_attr_shortform_allfit(bp, dp);
> > > -	if (forkoff)
> > > -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> > > -		/* bp is gone due to xfs_da_shrink_inode */
> > > -
> > > -	return error;
> > > -}
> > > -
> > > -/*
> > >    * Return EEXIST if attr is found, or ENOATTR if not
> > >    */
> > >   STATIC int
> > > @@ -1065,24 +1041,9 @@ xfs_attr_node_addname(
> > >   	struct xfs_da_state_blk		*blk;
> > >   	int				retval = 0;
> > >   	int				error = 0;
> > > -	struct xfs_mount		*mp = args->dp->i_mount;
> > >   	trace_xfs_attr_node_addname(args);
> > > -	/* State machine switch */
> > > -	switch (attr->xattri_dela_state) {
> > > -	case XFS_DAS_FLIP_NFLAG:
> > > -		goto das_flip_flag;
> > > -	case XFS_DAS_FOUND_NBLK:
> > > -		goto das_found_nblk;
> > > -	case XFS_DAS_ALLOC_NODE:
> > > -		goto das_alloc_node;
> > > -	case XFS_DAS_RM_NBLK:
> > > -		goto das_rm_nblk;
> > > -	default:
> > > -		break;
> > > -	}
> > > -
> > >   	/*
> > >   	 * Search to see if name already exists, and get back a pointer
> > >   	 * to where it should go.
> > > @@ -1171,93 +1132,24 @@ xfs_attr_node_addname(
> > >   	attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> > >   	trace_xfs_das_state_return(attr->xattri_dela_state);
> > >   	return -EAGAIN;
> > > -das_found_nblk:
> > > -
> > > -	/*
> > > -	 * If there was an out-of-line value, allocate the blocks we
> > > -	 * identified for its storage and copy the value.  This is done
> > > -	 * after we create the attribute so that we don't overflow the
> > > -	 * maximum size of a transaction and/or hit a deadlock.
> > > -	 */
> > > -	if (args->rmtblkno > 0) {
> > > -		/* Open coded xfs_attr_rmtval_set without trans handling */
> > > -		error = xfs_attr_rmtval_find_space(attr);
> > > -		if (error)
> > > -			return error;
> > > -
> > > -		/*
> > > -		 * Roll through the "value", allocating blocks on disk as
> > > -		 * required.  Set the state in case of -EAGAIN return code
> > > -		 */
> > > -		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
> > > -das_alloc_node:
> > > -		if (attr->xattri_blkcnt > 0) {
> > > -			error = xfs_attr_rmtval_set_blk(attr);
> > > -			if (error)
> > > -				return error;
> > > -
> > > -			trace_xfs_das_state_return(attr->xattri_dela_state);
> > > -			return -EAGAIN;
> > > -		}
> > > -
> > > -		error = xfs_attr_rmtval_set_value(args);
> > > -		if (error)
> > > -			return error;
> > > -	}
> > > -
> > > -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> > > -		/*
> > > -		 * Added a "remote" value, just clear the incomplete flag.
> > > -		 */
> > > -		if (args->rmtblkno > 0)
> > > -			error = xfs_attr3_leaf_clearflag(args);
> > > -		retval = error;
> > > -		goto out;
> > > -	}
> > > -
> > > -	/*
> > > -	 * If this is an atomic rename operation, we must "flip" the incomplete
> > > -	 * flags on the "new" and "old" attribute/value pairs so that one
> > > -	 * disappears and one appears atomically.  Then we must remove the "old"
> > > -	 * attribute/value pair.
> > > -	 *
> > > -	 * In a separate transaction, set the incomplete flag on the "old" attr
> > > -	 * and clear the incomplete flag on the "new" attr.
> > > -	 */
> > > -	if (!xfs_hasdelattr(mp)) {
> > > -		error = xfs_attr3_leaf_flipflags(args);
> > > -		if (error)
> > > -			goto out;
> > > -		/*
> > > -		 * Commit the flag value change and start the next trans in series
> > > -		 */
> > > -		attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
> > > -		trace_xfs_das_state_return(attr->xattri_dela_state);
> > > -		return -EAGAIN;
> > > -	}
> > > -das_flip_flag:
> > > -	/*
> > > -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> > > -	 * (if it exists).
> > > -	 */
> > > -	xfs_attr_restore_rmt_blk(args);
> > > +out:
> > > +	if (state)
> > > +		xfs_da_state_free(state);
> > > -	error = xfs_attr_rmtval_invalidate(args);
> > >   	if (error)
> > >   		return error;
> > > +	return retval;
> > > +}
> > > -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> > > -	attr->xattri_dela_state = XFS_DAS_RM_NBLK;
> > > -das_rm_nblk:
> > > -	if (args->rmtblkno) {
> > > -		error = xfs_attr_rmtval_remove(attr);
> > > -
> > > -		if (error == -EAGAIN)
> > > -			trace_xfs_das_state_return(attr->xattri_dela_state);
> > > -
> > > -		if (error)
> > > -			return error;
> > > -	}
> > > +STATIC
> > > +int xfs_attr_node_addname_work(
> > > +	struct xfs_attr_item		*attr)
> > > +{
> > > +	struct xfs_da_args		*args = attr->xattri_da_args;
> > > +	struct xfs_da_state		*state = NULL;
> > > +	struct xfs_da_state_blk		*blk;
> > > +	int				retval = 0;
> > > +	int				error = 0;
> > >   	/*
> > >   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index c80575a..050e5be 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -376,8 +376,10 @@ enum xfs_delattr_state {
> > >   	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
> > >   	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> > >   	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
> > > +	XFS_DAS_ALLOC_LBLK,
> > > +	XFS_DAS_SET_LBLK,
> > >   	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
> > > -	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
> > > +	XFS_DAS_INVAL_LBLK,	      /* Invalidate leaf blks */
> > >   	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> > >   	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
> > >   	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
> > > -- 
> > > 2.7.4
> > > 
> > 
> 

