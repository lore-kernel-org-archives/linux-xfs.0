Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48298C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD9923A1C
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbhAUSwG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:52:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726593AbhAUSsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 13:48:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611254845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+yxPXXQ5TyHEsEcGiSqpBltZleUWZaS0e9cVnE67muM=;
        b=YFGhpfNBBkkzIUCkMi/nRNH7DWxLIlCyZHW52xXM4JBkYfkHvLYL8QSGh9qkLS4qMfKIKA
        yg470CZ2Qkkg9wXQBjA6OSzt9zQbGCQaZT5/cv720/u2L/gWwt0LlZUXGfGcPzjPwtZLFS
        0JdBH4E09MRl74SKiO88/dp7OobALRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-TPveQpGuMiuFpnTcaULMdQ-1; Thu, 21 Jan 2021 13:47:23 -0500
X-MC-Unique: TPveQpGuMiuFpnTcaULMdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C708B1005513;
        Thu, 21 Jan 2021 18:47:22 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C6CD5D9DD;
        Thu, 21 Jan 2021 18:47:22 +0000 (UTC)
Date:   Thu, 21 Jan 2021 13:47:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] xfs: refactor xfs_attr_set follow up
Message-ID: <20210121184720.GC1793795@bfoster>
References: <20210116081240.12478-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116081240.12478-1-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 16, 2021 at 01:12:40AM -0700, Allison Henderson wrote:
> Hi all,
> 
> This is a follow up to Brians earlier patch
> "[PATCH RFC] xfs: refactor xfs_attr_set() into incremental components"
> 
> This patch resembles the earlier patch, but it is seated at the top of
> the parent pointers set rather than the bottom to give a better
> illustraion of what this approach might end up looking like in the
> bigger picture.  This patch is both compiled and tested, and is meant to
> be more of an exploratory effort than anything.
> 
> Most of the state management is collapsed into the *_iter functions
> similar to Brians patch which collapsed them into the *_args routines.
> Though there are a few states that a still in a few subfunctions.
> 
> In anycase, I think it gives decent idea of what the solution might
> look like in practice.  Questions, comments and feedback appreciated.
> 

Thanks for the patch. By and large, I think the centralized state
management of __xfs_attr_set_iter() is much more clear than the label
management approach of jumping up and down through multiple levels of
helper functions. For the most part, I'm able to walk through the iter
function and follow the sequence of steps involved in the set. I did
have some higher level comments on various parts of the patch,
particularly where we seem to deviate from centralized state management.

Note that if we were to take this approach, a primary goal was to
incrementally port the existing xfs_attr_set_args() implementation into
states. For example, such that we could split the current monstrous
xfs_attr_set() patch into multiple patches that introduce infrastructure
first, and then convert the existing code a state or so at a time. That
eliminates churn from factoring code into one scheme only to immediately
refactor into another. It also facilitates testing because I think the
rework should be able to maintain functionality across each step.

Porting on top of the whole thing certainly helps to get an advanced
look at the final result. However, if we do use this approach and start
getting into the details of individual states and whatnot, I do think it
would be better to start breaking things down into smaller patches that
replace some of the earlier code rather than use it as a baseline.
Further comments inline...

> Thanks!
> Allison
> 
> ---
>  fs/xfs/libxfs/xfs_attr.c | 596 +++++++++++++++++++----------------------------
>  fs/xfs/libxfs/xfs_attr.h |   4 +-
>  2 files changed, 247 insertions(+), 353 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6ba8f4b..356e35c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -45,8 +45,8 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>  /*
>   * Internal routines when attribute list is one block.
>   */
> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args      *args);
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
> @@ -55,6 +55,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
> +STATIC int xfs_attr_node_addname_work(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_removename_iter(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
> @@ -219,52 +220,77 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> -/*
> - * Attempts to set an attr in shortform, or converts short form to leaf form if
> - * there is not enough room.  This function is meant to operate as a helper
> - * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
> - * that the calling function should roll the transaction, and then proceed to
> - * add the attr in leaf form.  This subroutine does not expect to be recalled
> - * again like the other delayed attr routines do.
> - */
> -STATIC int
> -xfs_attr_set_shortform(
> -	struct xfs_da_args	*args,
> -	struct xfs_buf		**leaf_bp)
> +int
> +xfs_attr_set_fmt(
> +	struct xfs_attr_item	*attr,
> +	bool			*done)
>  {
> +	struct xfs_da_args	*args = attr->xattri_da_args;
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_buf		**leaf_bp = &attr->xattri_leaf_bp;
>  	int			error = 0;
>  
> -	/*
> -	 * Try to add the attr to the attribute list in the inode.
> -	 */
> -	error = xfs_attr_try_sf_addname(dp, args);
> +	*done = false;
> +	if (xfs_attr_is_shortform(dp)) {
>  
> -	/* Should only be 0, -EEXIST or -ENOSPC */
> -	if (error != -ENOSPC) {
> -		return error;
> +		*done = true;
> +		error = xfs_attr_try_sf_addname(dp, args);
> +		if (!error)
> +			*done = true;
> +
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +		if (error)
> +			return error;
> +
> +		xfs_trans_bhold(args->trans, *leaf_bp);
> +
> +		trace_xfs_das_state_return(XFS_DAS_UNINIT);
> +		return -EAGAIN;
>  	}
>  	/*
> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> -	 * another possible req'mt for a double-split btree op.
> +	 * After a shortform to leaf conversion, we need to hold the leaf and
> +	 * cycle out the transaction.  When we get back, we need to release
> +	 * the leaf to release the hold on the leaf buffer.
>  	 */
> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -	if (error)
> -		return error;
> +	if (*leaf_bp != NULL) {
> +		xfs_trans_bhold_release(args->trans, *leaf_bp);
> +		*leaf_bp = NULL;
> +	}
>  
> -	/*
> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> -	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier.
> -	 */
> -	xfs_trans_bhold(args->trans, *leaf_bp);
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
> +		switch (error) {
> +		case -ENOSPC:
> +			/*
> +			 * Promote the attribute list to the Btree format.
> +			 */
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				return error;
>  
> -	/*
> -	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
> -	 * fork to leaf format and will restart with the leaf add.
> -	 */
> -	trace_xfs_das_state_return(XFS_DAS_UNINIT);
> -	return -EAGAIN;
> +			/*
> +			 * Finish any deferred work items and roll the
> +			 * transaction once more.  The goal here is to call
> +			 * node_addname with the inode and transaction in the
> +			 * same state (inode locked and joined, transaction
> +			 * clean) no matter how we got to this step.
> +			 *
> +			 * At this point, we are still in XFS_DAS_UNINIT, but
> +			 * when we come back, we'll be a node, so we'll fall
> +			 * down into the node handling code below
> +			 */
> +			trace_xfs_das_state_return(attr->xattri_dela_state);
> +			return -EAGAIN;
> +		case 0:
> +			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +			trace_xfs_das_state_return(attr->xattri_dela_state);
> +			return -EAGAIN;
> +		}
> +	}
> +	return error;
>  }
>  
>  /*
> @@ -274,108 +300,197 @@ xfs_attr_set_shortform(
>   * to handle this, and recall the function until a successful error code is
>   * returned.
>   */
> -int
> -xfs_attr_set_iter(
> -	struct xfs_attr_item		*attr)
> +STATIC int
> +__xfs_attr_set_iter(
> +	struct xfs_attr_item		*attr,
> +	bool				*done)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_inode		*dp = args->dp;
> -	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
> -	int				error = 0;
>  	int				sf_size;
> +	struct xfs_buf			*bp = NULL;
> +	int				error, forkoff;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
>  	switch (attr->xattri_dela_state) {
> -	case XFS_DAS_FLIP_LFLAG:
> -	case XFS_DAS_FOUND_LBLK:
> -	case XFS_DAS_RM_LBLK:
> -		return xfs_attr_leaf_addname(attr);
> -	case XFS_DAS_FOUND_NBLK:
> -	case XFS_DAS_FLIP_NFLAG:
> -	case XFS_DAS_ALLOC_NODE:
> -		return xfs_attr_node_addname(attr);
>  	case XFS_DAS_UNINIT:
> -		break;
> -	default:
> -		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
> -		break;
> -	}
> +		if (XFS_IFORK_Q((args->dp)) == 0) {
> +			sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +				  xfs_attr_sf_entsize_byname(args->namelen,
> +							     args->valuelen);
> +			xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +			args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_zone, 0);
> +			args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> +			args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> +		}
>  
> -	/*
> -	 * New inodes may not have an attribute fork yet. So set the attribute
> -	 * fork appropriately
> -	 */
> -	if (XFS_IFORK_Q((args->dp)) == 0) {
> -		sf_size = sizeof(struct xfs_attr_sf_hdr) +
> -				 xfs_attr_sf_entsize_byname(args->namelen,
> -							    args->valuelen);
> -		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> -		args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_zone, 0);
> -		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> -		args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> -	}
> +		return xfs_attr_set_fmt(attr, done);

One thing the original patch tried to accomplish was to draw a line
between the state management and underlying helpers in this iter()
function. It looks like you've done that in other places, but here some
of that state code is buried down in _set_fmt(). Instead, I think the
helper should return -EAGAIN only if it should be called again and
otherwise return 0. The caller then determines if/how/when to move to
the next state. The purpose of the done flag in this case was to let the
caller know whether the operation had completed or to move on to the
next state.

Also, I notice a lot of
trace_xfs_das_state_return(attr->xattri_dela_state) calls scattered
about. Could we turn that into a common exit path out of this function
and let the users fall into it appropriately with a label?

> +	case XFS_DAS_FOUND_LBLK:
> +		if (args->rmtblkno > 0) {
> +			error = xfs_attr_rmtval_find_space(attr);
> +			if (error)
> +				return error;
> +		}
> +		attr->xattri_dela_state = XFS_DAS_ALLOC_LBLK;

Just FWIW, I get a bunch of warnings related to these fallthrus with gcc
10.2.1.

> +	case XFS_DAS_ALLOC_LBLK:
> +		if (attr->xattri_blkcnt > 0) {
> +			error = xfs_attr_rmtval_set_blk(attr);
> +			if (error)
> +				return error;
>  
> -	/*
> -	 * If the attribute list is already in leaf format, jump straight to
> -	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> -	 * list; if there's no room then convert the list to leaf format and try
> -	 * again. No need to set state as we will be in leaf form when we come
> -	 * back
> -	 */
> -	if (xfs_attr_is_shortform(dp)) {
> +			trace_xfs_das_state_return(attr->xattri_dela_state);
> +			return -EAGAIN;
> +		}
> +		attr->xattri_dela_state = XFS_DAS_SET_LBLK;
> +	case XFS_DAS_SET_LBLK:
> +		error = xfs_attr_rmtval_set_value(args);
> +		if (error)
> +			return error;
>  
> -		/*
> -		 * If the attr was successfully set in shortform, no need to
> -		 * continue.  Otherwise, is it converted from shortform to leaf
> -		 * and -EAGAIN is returned.
> -		 */
> -		return xfs_attr_set_shortform(args, leaf_bp);
> -	}
> +		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +			/*
> +			 * Added a "remote" value, just clear the incomplete flag.
> +			 */
> +			if (args->rmtblkno > 0)
> +				error = xfs_attr3_leaf_clearflag(args);
>  
> -	/*
> -	 * After a shortform to leaf conversion, we need to hold the leaf and
> -	 * cycle out the transaction.  When we get back, we need to release
> -	 * the leaf to release the hold on the leaf buffer.
> -	 */
> -	if (*leaf_bp != NULL) {
> -		xfs_trans_bhold_release(args->trans, *leaf_bp);
> -		*leaf_bp = NULL;
> -	}
> +			return error;
> +		}
>  
> -	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -		return xfs_attr_node_addname(attr);
> +		if (xfs_hasdelattr(mp))
> +			return error;
>  
> -	error = xfs_attr_leaf_try_add(args, *leaf_bp);
> -	switch (error) {
> -	case -ENOSPC:
> +		error = xfs_attr3_leaf_flipflags(args);
> +		if (error)
> +			return error;
>  		/*
> -		 * Promote the attribute list to the Btree format.
> +		 * Commit the flag value change and start the next trans in series.
>  		 */
> -		error = xfs_attr3_leaf_to_node(args);
> +		attr->xattri_dela_state = XFS_DAS_INVAL_LBLK;
> +		trace_xfs_das_state_return(attr->xattri_dela_state);
> +		return -EAGAIN;
> +
> +	case XFS_DAS_INVAL_LBLK:
> +		xfs_attr_restore_rmt_blk(args);
> +
> +		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
>  
> +		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
> +	case XFS_DAS_RM_LBLK:
> +		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_remove(attr);
> +			if (error == -EAGAIN)
> +				trace_xfs_das_state_return(attr->xattri_dela_state);
> +			if (error)
> +				return error;
> +		}
> +
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> +				   &bp);
> +		if (error)
> +			return error;
> +
> +		xfs_attr3_leaf_remove(bp, args);
> +
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			/* bp is gone due to xfs_da_shrink_inode */
> +
> +		return error;

Is this a completion state? How do end up in the state below?

Hmm.. that comes from xfs_attr_node_addname(), so it looks like this was
split into semi-duplicate states between leaf/node formats. Was there a
reason this was split up instead of folded together as attempted in the
original patch?

> +	case XFS_DAS_FOUND_NBLK:
> +		if (args->rmtblkno > 0) {
> +			error = xfs_attr_rmtval_find_space(attr);
> +			if (error)
> +				return error;
> +
> +		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
> +	case XFS_DAS_ALLOC_NODE:

Oof, the case statement inside the if branch is rather odd here.

> +			if (attr->xattri_blkcnt > 0) {
> +				error = xfs_attr_rmtval_set_blk(attr);
> +				if (error)
> +					return error;
> +
> +				trace_xfs_das_state_return(attr->xattri_dela_state);
> +				return -EAGAIN;
> +			}
> +
> +			error = xfs_attr_rmtval_set_value(args);
> +			if (error)
> +				return error;
> +		}
> +
> +		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +			/*
> +			 * Added a rmt value, just clear the incomplete flag.
> +			 */
> +			if (args->rmtblkno > 0)
> +				error = xfs_attr3_leaf_clearflag(args);
> +			return error;
> +		}
> +
> +		if (!xfs_hasdelattr(mp)) {
> +			error = xfs_attr3_leaf_flipflags(args);
> +			if (error)
> +				return error;
> +			/*
> +			 * Commit the flag value change and start the next trans
> +			 * in series
> +			 */
> +			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
> +			trace_xfs_das_state_return(attr->xattri_dela_state);
> +			return -EAGAIN;
> +		}
> +	case XFS_DAS_FLIP_NFLAG:
>  		/*
> -		 * Finish any deferred work items and roll the
> -		 * transaction once more.  The goal here is to call
> -		 * node_addname with the inode and transaction in the
> -		 * same state (inode locked and joined, transaction
> -		 * clean) no matter how we got to this step.
> -		 *
> -		 * At this point, we are still in XFS_DAS_UNINIT, but
> -		 * when we come back, we'll be a node, so we'll fall
> -		 * down into the node handling code below
> +		 * Dismantle the "old" attribute/value pair by removing a
> +		 * "remote" value (if it exists).
>  		 */
> -		trace_xfs_das_state_return(attr->xattri_dela_state);
> -		return -EAGAIN;
> -	case 0:
> -		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> -		trace_xfs_das_state_return(attr->xattri_dela_state);
> -		return -EAGAIN;
> +		xfs_attr_restore_rmt_blk(args);
> +
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
> +
> +		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
> +	case XFS_DAS_RM_NBLK:
> +		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_remove(attr);
> +
> +			if (error == -EAGAIN) {
> +				attr->xattri_dela_state = XFS_DAS_RM_NBLK;
> +				trace_xfs_das_state_return(attr->xattri_dela_state);
> +			}
> +
> +			if (error)
> +				return error;
> +		}
> +
> +		return xfs_attr_node_addname_work(attr);
> +	default:
> +		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
> +		break;
>  	}
> +
>  	return error;
>  }
>  
> +int xfs_attr_set_iter(
> +	struct xfs_attr_item	*attr)
> +{
> +	bool	done = true;
> +	int 	error;
> +
> +	error =  __xfs_attr_set_iter(attr, &done);
> +	if (error || done)
> +		return error;
> +
> +	return xfs_attr_node_addname(attr);

Note that this was also intended to go away and get folded into the
state code in __xfs_attr_set_iter(), I just left off here because it
looked like there might have been opportunity to fall into the remove
path, and that was getting a bit more involved than I wanted to. This
variant looks a little different in that we can presumably fall into
this function and then back into the state machine. Even if we didn't
immediately reuse the remove path, I suspect we should probably continue
chunking off the remainder of the operation into proper states.

Brian

> +}
> +
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> @@ -773,145 +888,6 @@ xfs_attr_leaf_try_add(
>  
>  
>  /*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - *
> - * This routine is meant to function as a delayed operation, and may return
> - * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> - * to handle this, and recall the function until a successful error code is
> - * returned.
> - */
> -STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_attr_item		*attr)
> -{
> -	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_buf			*bp = NULL;
> -	int				error, forkoff;
> -	struct xfs_inode		*dp = args->dp;
> -	struct xfs_mount		*mp = args->dp->i_mount;
> -
> -	/* State machine switch */
> -	switch (attr->xattri_dela_state) {
> -	case XFS_DAS_FLIP_LFLAG:
> -		goto das_flip_flag;
> -	case XFS_DAS_RM_LBLK:
> -		goto das_rm_lblk;
> -	default:
> -		break;
> -	}
> -
> -	/*
> -	 * If there was an out-of-line value, allocate the blocks we
> -	 * identified for its storage and copy the value.  This is done
> -	 * after we create the attribute so that we don't overflow the
> -	 * maximum size of a transaction and/or hit a deadlock.
> -	 */
> -
> -	/* Open coded xfs_attr_rmtval_set without trans handling */
> -	if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> -		attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
> -		if (args->rmtblkno > 0) {
> -			error = xfs_attr_rmtval_find_space(attr);
> -			if (error)
> -				return error;
> -		}
> -	}
> -
> -	/*
> -	 * Roll through the "value", allocating blocks on disk as
> -	 * required.
> -	 */
> -	if (attr->xattri_blkcnt > 0) {
> -		error = xfs_attr_rmtval_set_blk(attr);
> -		if (error)
> -			return error;
> -
> -		trace_xfs_das_state_return(attr->xattri_dela_state);
> -		return -EAGAIN;
> -	}
> -
> -	error = xfs_attr_rmtval_set_value(args);
> -	if (error)
> -		return error;
> -
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		if (args->rmtblkno > 0)
> -			error = xfs_attr3_leaf_clearflag(args);
> -
> -		return error;
> -	}
> -
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the incomplete
> -	 * flags on the "new" and "old" attribute/value pairs so that one
> -	 * disappears and one appears atomically.  Then we must remove the "old"
> -	 * attribute/value pair.
> -	 *
> -	 * In a separate transaction, set the incomplete flag on the "old" attr
> -	 * and clear the incomplete flag on the "new" attr.
> -	 */
> -	if (!xfs_hasdelattr(mp)) {
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the flag value change and start the next trans in series.
> -		 */
> -		attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
> -		trace_xfs_das_state_return(attr->xattri_dela_state);
> -		return -EAGAIN;
> -	}
> -das_flip_flag:
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> -
> -	error = xfs_attr_rmtval_invalidate(args);
> -	if (error)
> -		return error;
> -
> -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -	attr->xattri_dela_state = XFS_DAS_RM_LBLK;
> -das_rm_lblk:
> -	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_remove(attr);
> -		if (error == -EAGAIN)
> -			trace_xfs_das_state_return(attr->xattri_dela_state);
> -		if (error)
> -			return error;
> -	}
> -
> -	/*
> -	 * Read in the block containing the "old" attr, then remove the "old"
> -	 * attr from that block (neat, huh!)
> -	 */
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -				   &bp);
> -	if (error)
> -		return error;
> -
> -	xfs_attr3_leaf_remove(bp, args);
> -
> -	/*
> -	 * If the result is small enough, shrink it all into the inode.
> -	 */
> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
> -	if (forkoff)
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -		/* bp is gone due to xfs_da_shrink_inode */
> -
> -	return error;
> -}
> -
> -/*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
>  STATIC int
> @@ -1065,24 +1041,9 @@ xfs_attr_node_addname(
>  	struct xfs_da_state_blk		*blk;
>  	int				retval = 0;
>  	int				error = 0;
> -	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> -	/* State machine switch */
> -	switch (attr->xattri_dela_state) {
> -	case XFS_DAS_FLIP_NFLAG:
> -		goto das_flip_flag;
> -	case XFS_DAS_FOUND_NBLK:
> -		goto das_found_nblk;
> -	case XFS_DAS_ALLOC_NODE:
> -		goto das_alloc_node;
> -	case XFS_DAS_RM_NBLK:
> -		goto das_rm_nblk;
> -	default:
> -		break;
> -	}
> -
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
> @@ -1171,93 +1132,24 @@ xfs_attr_node_addname(
>  	attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>  	trace_xfs_das_state_return(attr->xattri_dela_state);
>  	return -EAGAIN;
> -das_found_nblk:
> -
> -	/*
> -	 * If there was an out-of-line value, allocate the blocks we
> -	 * identified for its storage and copy the value.  This is done
> -	 * after we create the attribute so that we don't overflow the
> -	 * maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		/* Open coded xfs_attr_rmtval_set without trans handling */
> -		error = xfs_attr_rmtval_find_space(attr);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Roll through the "value", allocating blocks on disk as
> -		 * required.  Set the state in case of -EAGAIN return code
> -		 */
> -		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
> -das_alloc_node:
> -		if (attr->xattri_blkcnt > 0) {
> -			error = xfs_attr_rmtval_set_blk(attr);
> -			if (error)
> -				return error;
> -
> -			trace_xfs_das_state_return(attr->xattri_dela_state);
> -			return -EAGAIN;
> -		}
> -
> -		error = xfs_attr_rmtval_set_value(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		if (args->rmtblkno > 0)
> -			error = xfs_attr3_leaf_clearflag(args);
> -		retval = error;
> -		goto out;
> -	}
> -
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the incomplete
> -	 * flags on the "new" and "old" attribute/value pairs so that one
> -	 * disappears and one appears atomically.  Then we must remove the "old"
> -	 * attribute/value pair.
> -	 *
> -	 * In a separate transaction, set the incomplete flag on the "old" attr
> -	 * and clear the incomplete flag on the "new" attr.
> -	 */
> -	if (!xfs_hasdelattr(mp)) {
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the flag value change and start the next trans in series
> -		 */
> -		attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
> -		trace_xfs_das_state_return(attr->xattri_dela_state);
> -		return -EAGAIN;
> -	}
> -das_flip_flag:
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
>  
> -	error = xfs_attr_rmtval_invalidate(args);
>  	if (error)
>  		return error;
> +	return retval;
> +}
>  
> -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -	attr->xattri_dela_state = XFS_DAS_RM_NBLK;
> -das_rm_nblk:
> -	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_remove(attr);
> -
> -		if (error == -EAGAIN)
> -			trace_xfs_das_state_return(attr->xattri_dela_state);
> -
> -		if (error)
> -			return error;
> -	}
> +STATIC
> +int xfs_attr_node_addname_work(
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_da_args		*args = attr->xattri_da_args;
> +	struct xfs_da_state		*state = NULL;
> +	struct xfs_da_state_blk		*blk;
> +	int				retval = 0;
> +	int				error = 0;
>  
>  	/*
>  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index c80575a..050e5be 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -376,8 +376,10 @@ enum xfs_delattr_state {
>  	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>  	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>  	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
> +	XFS_DAS_ALLOC_LBLK,
> +	XFS_DAS_SET_LBLK,
>  	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
> -	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
> +	XFS_DAS_INVAL_LBLK,	      /* Invalidate leaf blks */
>  	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
>  	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
>  	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
> -- 
> 2.7.4
> 

