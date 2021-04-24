Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4BDC433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 15:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B096147F
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Apr 2021 15:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhDXP5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Apr 2021 11:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhDXP5Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Apr 2021 11:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC8061422;
        Sat, 24 Apr 2021 15:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619279805;
        bh=6xzuKNnbVW9P1p6zTCc6GnMNO6ii8wrg5CIBySA4Rms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fRj6v4YGnUVpnnvBqaMFzAbH865jNOuu9ckCvWh76bFlAvsSrLLKH02xAVrM49caL
         WpqUhNTrKLb/tgrJLk0dlec8CG0jREJ5QXn2AxbpPefGQwYRu0nHsr0iu5z20e46eu
         dCCZd9gjrFkol9UUt0RHWYeED7FsAK5RqH/ZlZ9gNSHN2ZMTa0ywf/b42LuES0aMTY
         nik6QB5F8dAKF8A9Aj3ISPY9qRuxHHbdb6Kb7jC5MdShacdFmXjdzuUx4Z4bmsXdCB
         +5osF04zuvbCk3Ke4wW4wYxjFcgzmp/XOFeNj1cOl+yt753bSeKcjvL/hfs3dfO5F0
         SlvKtxU2A0Xaw==
Date:   Sat, 24 Apr 2021 08:56:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
Message-ID: <20210424155645.GX3122264@magnolia>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-11-allison.henderson@oracle.com>
 <YIL+j3BmnDOEqHrp@bfoster>
 <85c61f76-81e1-9c03-3171-0f01759c46de@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85c61f76-81e1-9c03-3171-0f01759c46de@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 23, 2021 at 08:27:28PM -0700, Allison Henderson wrote:
> 
> 
> On 4/23/21 10:06 AM, Brian Foster wrote:
> > On Fri, Apr 16, 2021 at 02:20:44AM -0700, Allison Henderson wrote:
> > > This patch modifies the attr remove routines to be delay ready. This
> > > means they no longer roll or commit transactions, but instead return
> > > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > > this series, xfs_attr_remove_args is merged with
> > > xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
> > > This new version uses a sort of state machine like switch to keep track
> > > of where it was when EAGAIN was returned. A new version of
> > > xfs_attr_remove_args consists of a simple loop to refresh the
> > > transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
> > > flag is used to finish the transaction where ever the existing code used
> > > to.
> > > 
> > > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > > version __xfs_attr_rmtval_remove. We will rename
> > > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > > done.
> > > 
> > > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > > during a rename).  For reasons of preserving existing function, we
> > > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > > used and will be removed.
> > > 
> > > This patch also adds a new struct xfs_delattr_context, which we will use
> > > to keep track of the current state of an attribute operation. The new
> > > xfs_delattr_state enum is used to track various operations that are in
> > > progress so that we know not to repeat them, and resume where we left
> > > off before EAGAIN was returned to cycle out the transaction. Other
> > > members take the place of local variables that need to retain their
> > > values across multiple function recalls.  See xfs_attr.h for a more
> > > detailed diagram of the states.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
> > >   fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
> > >   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> > >   fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
> > >   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> > >   fs/xfs/xfs_attr_inactive.c      |   2 +-
> > >   6 files changed, 305 insertions(+), 88 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index ed06b60..0bea8dd 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > ...
> > > @@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
> > >   }
> > >   /*
> > > - * Remove a name from a B-tree attribute list.
> > > + * Remove the attribute specified in @args.
> > >    *
> > >    * This will involve walking down the Btree, and may involve joining
> > >    * leaf nodes and even joining intermediate nodes up to and including
> > >    * the root node (a special case of an intermediate node).
> > > + *
> > > + * This routine is meant to function as either an in-line or delayed operation,
> > > + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> > > + * functions will need to handle this, and recall the function until a
> > > + * successful error code is returned.
> > >    */
> > > -STATIC int
> > > -xfs_attr_node_removename(
> > > -	struct xfs_da_args	*args)
> > > +int
> > > +xfs_attr_remove_iter(
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	struct xfs_da_state	*state;
> > > -	int			retval, error;
> > > -	struct xfs_inode	*dp = args->dp;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	struct xfs_da_state		*state = dac->da_state;
> > > +	int				retval, error;
> > > +	struct xfs_inode		*dp = args->dp;
> > >   	trace_xfs_attr_node_removename(args);
> > ...
> > > +	case XFS_DAS_CLNUP:
> > > +		retval = xfs_attr_node_remove_cleanup(args, state);
> > 
> > This is a nit, but when reading the code the "cleanup" name gives the
> > impression that this is a resource cleanup or something along those
> > lines, when this is actually a primary component of the operation where
> > we remove the attr name. That took me a second to find. Could we tweak
> > the state and rename the helper to something like DAS_RMNAME  /
> > _node_remove_name() so the naming is a bit more explicit?
> Sure, this helper is actually added in patch 2 of this set.  I can rename it
> there?  People have already added their rvb's, but I'm assuming people are
> not bothered by small tweeks like that?  That way this patch just sort of
> moves it and XFS_DAS_CLNUP can turn into XFS_DAS_RMNAME here.

<bikeshed> "RMNAME" looks too similar to "RENAME" for my old eyes, can
we please pick something else?  Like "RM_NAME", or "REMOVE_NAME" ?

--D

> 
> > 
> > > -	/*
> > > -	 * Check to see if the tree needs to be collapsed.
> > > -	 */
> > > -	if (retval && (state->path.active > 1)) {
> > > -		error = xfs_da3_join(state);
> > > -		if (error)
> > > -			goto out;
> > > -		error = xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			goto out;
> > >   		/*
> > > -		 * Commit the Btree join operation and start a new trans.
> > > +		 * Check to see if the tree needs to be collapsed. Set the flag
> > > +		 * to indicate that the calling function needs to move the
> > > +		 * shrink operation
> > >   		 */
> > > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > > -		if (error)
> > > -			goto out;
> > > -	}
> > > +		if (retval && (state->path.active > 1)) {
> > > +			error = xfs_da3_join(state);
> > > +			if (error)
> > > +				goto out;
> > > -	/*
> > > -	 * If the result is small enough, push it all into the inode.
> > > -	 */
> > > -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > > -		error = xfs_attr_node_shrink(args, state);
> > > +			dac->flags |= XFS_DAC_DEFER_FINISH;
> > > +			dac->dela_state = XFS_DAS_RM_SHRINK;
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > > +		/* fallthrough */
> > > +	case XFS_DAS_RM_SHRINK:
> > > +		/*
> > > +		 * If the result is small enough, push it all into the inode.
> > > +		 */
> > > +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > > +			error = xfs_attr_node_shrink(args, state);
> > > +
> > > +		break;
> > > +	default:
> > > +		ASSERT(0);
> > > +		error = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +	if (error == -EAGAIN)
> > > +		return error;
> > >   out:
> > >   	if (state)
> > >   		xfs_da_state_free(state);
> > ...
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index 48d8e9c..908521e7 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > ...
> > > @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
> > >   	 * Keep de-allocating extents until the remote-value region is gone.
> > >   	 */
> > >   	do {
> > > -		retval = __xfs_attr_rmtval_remove(args);
> > > -		if (retval && retval != -EAGAIN)
> > > -			return retval;
> > > +		error = __xfs_attr_rmtval_remove(&dac);
> > > +		if (error != -EAGAIN)
> > > +			break;
> > 
> > Shouldn't this retain the (error && error != -EAGAIN) logic to roll the
> > transaction after the final unmap? Even if this is transient, it's
> > probably best to preserve behavior if this is unintentional.
> Sure, I dont think it's intentional, I think back in v10 we had a different
> arangement here with a helper inside the while() expression that had
> equivelent error handling logic.  But that got nak'd in the next review and
> I think I likley forgot to put back this handling.  Will fix.
> 
> > 
> > Otherwise my only remaining feedback was to add/tweak some comments that
> > I think make the iteration function easier to follow. I've appended a
> > diff for that. If you agree with the changes feel free to just fold them
> > in and/or tweak as necessary. With those various nits and Chandan's
> > feedback addressed, I think this patch looks pretty good.
> Sure, those all look reasonable.  Will add.  Thanks for the reviews!
> Allison
> 
> > 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 0bea8dd34902..ee885c649c26 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -1289,14 +1289,21 @@ xfs_attr_remove_iter(
> >   		if (!xfs_inode_hasattr(dp))
> >   			return -ENOATTR;
> > +		/*
> > +		 * Shortform or leaf formats don't require transaction rolls and
> > +		 * thus state transitions. Call the right helper and return.
> > +		 */
> >   		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> >   			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> >   			return xfs_attr_shortform_remove(args);
> >   		}
> > -
> >   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >   			return xfs_attr_leaf_removename(args);
> > +		/*
> > +		 * Node format may require transaction rolls. Set up the
> > +		 * state context and fall into the state machine.
> > +		 */
> >   		if (!dac->da_state) {
> >   			error = xfs_attr_node_removename_setup(dac);
> >   			if (error)
> > @@ -1304,7 +1311,7 @@ xfs_attr_remove_iter(
> >   			state = dac->da_state;
> >   		}
> > -	/* fallthrough */
> > +		/* fallthrough */
> >   	case XFS_DAS_RMTBLK:
> >   		dac->dela_state = XFS_DAS_RMTBLK;
> > @@ -1316,7 +1323,8 @@ xfs_attr_remove_iter(
> >   		 */
> >   		if (args->rmtblkno > 0) {
> >   			/*
> > -			 * May return -EAGAIN. Remove blocks until 0 is returned
> > +			 * May return -EAGAIN. Roll and repeat until all remote
> > +			 * blocks are removed.
> >   			 */
> >   			error = __xfs_attr_rmtval_remove(dac);
> >   			if (error == -EAGAIN)
> > @@ -1325,26 +1333,26 @@ xfs_attr_remove_iter(
> >   				goto out;
> >   			/*
> > -			 * Refill the state structure with buffers, the prior
> > -			 * calls released our buffers.
> > +			 * Refill the state structure with buffers (the prior
> > +			 * calls released our buffers) and close out this
> > +			 * transaction before proceeding.
> >   			 */
> >   			ASSERT(args->rmtblkno == 0);
> >   			error = xfs_attr_refillstate(state);
> >   			if (error)
> >   				goto out;
> > -
> >   			dac->dela_state = XFS_DAS_CLNUP;
> >   			dac->flags |= XFS_DAC_DEFER_FINISH;
> >   			return -EAGAIN;
> >   		}
> > +		/* fallthrough */
> >   	case XFS_DAS_CLNUP:
> >   		retval = xfs_attr_node_remove_cleanup(args, state);
> >   		/*
> > -		 * Check to see if the tree needs to be collapsed. Set the flag
> > -		 * to indicate that the calling function needs to move the
> > -		 * shrink operation
> > +		 * Check to see if the tree needs to be collapsed. If so, roll
> > +		 * the transacton and fall into the shrink state.
> >   		 */
> >   		if (retval && (state->path.active > 1)) {
> >   			error = xfs_da3_join(state);
> > @@ -1360,10 +1368,12 @@ xfs_attr_remove_iter(
> >   	case XFS_DAS_RM_SHRINK:
> >   		/*
> >   		 * If the result is small enough, push it all into the inode.
> > +		 * This is our final state so it's safe to return a dirty
> > +		 * transaction.
> >   		 */
> >   		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> >   			error = xfs_attr_node_shrink(args, state);
> > -
> > +		ASSERT(error != -EAGAIN);
> >   		break;
> >   	default:
> >   		ASSERT(0);
> > 
