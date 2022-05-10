Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1E3C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiEJXXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiEJXXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8549F280E0E
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B78B82019
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EDAC385CC;
        Tue, 10 May 2022 23:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652224978;
        bh=hQEtFaQJCyUEJ+k5jLmuLk/wu5nVEg+FlUu1F7lKxAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/bavMyATqylnDOTniW6csAl3bpJTi+fiK8VE/tx5BW56xkEX5QUBdyIVHI6Hyrfm
         lqh9XtzFNoJsqgVVJNfd3SPzaEiezck/ksVzWWUsCrWjszhuBmYjBN++EIUsXrNElB
         7D7aRaXY2AK61CEKXObP4bUMowHvFKDhTff2wF+KD39x6nFO4S/EjkdDjueGS6BXfl
         gghekY8QiNtyD2EB/4lq4WIDU8jeqpdH+lpeTL3IJW3pMHlO7ZF5dberq/N6vhK7cA
         5f2L3MsOK+ZjfFLQawGXJBWodL27TP8KEHGiT9WCYHt6GL0V03Q7oFM1CLNiEy6bGS
         Y/vjBL/3jwJNw==
Date:   Tue, 10 May 2022 16:22:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/18] xfs: split remote attr setting out from replace
 path
Message-ID: <20220510232258.GL27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:28AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we set a new xattr, we have three exit paths:
> 
> 	1. nothing else to do
> 	2. allocate and set the remote xattr value
> 	3. perform the rest of a replace operation
> 
> Currently we push both 2 and 3 into the same state, regardless of
> whether we just set a remote attribute or not. Once we've set the
> remote xattr, we have two exit states:
> 
> 	1. nothing else to do
> 	2. perform the rest of a replace operation
> 
> Hence we can split the remote xattr allocation and setting into
> their own states and factor it out of xfs_attr_set_iter() to further
> clean up the state machine and the implementation of the state
> machine.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Pretty straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 113 +++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_attr.h |  14 +++--
>  fs/xfs/xfs_trace.h       |   9 ++--
>  3 files changed, 77 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index be580da62f08..d2b29f7e103a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -334,9 +334,11 @@ xfs_attr_leaf_addname(
>  	 * or perform more xattr manipulations. Otherwise there is nothing more
>  	 * to do and we can return success.
>  	 */
> -	if (args->rmtblkno ||
> -	    (args->op_flags & XFS_DA_OP_RENAME)) {
> -		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +	if (args->rmtblkno) {
> +		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> +		error = -EAGAIN;
> +	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +		attr->xattri_dela_state = XFS_DAS_LEAF_REPLACE;
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -363,9 +365,11 @@ xfs_attr_node_addname(
>  	if (error)
>  		return error;
>  
> -	if (args->rmtblkno ||
> -	    (args->op_flags & XFS_DA_OP_RENAME)) {
> -		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	if (args->rmtblkno) {
> +		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> +		error = -EAGAIN;
> +	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +		attr->xattri_dela_state = XFS_DAS_NODE_REPLACE;
>  		error = -EAGAIN;
>  	} else {
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> @@ -375,6 +379,40 @@ xfs_attr_node_addname(
>  	return error;
>  }
>  
> +static int
> +xfs_attr_rmtval_alloc(
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_da_args              *args = attr->xattri_da_args;
> +	int				error = 0;
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (attr->xattri_blkcnt > 0) {
> +		error = xfs_attr_rmtval_set_blk(attr);
> +		if (error)
> +			return error;
> +		error = -EAGAIN;
> +		goto out;
> +	}
> +
> +	error = xfs_attr_rmtval_set_value(args);
> +	if (error)
> +		return error;
> +
> +	/* If this is not a rename, clear the incomplete flag and we're done. */
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +		error = xfs_attr3_leaf_clearflag(args);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +	}
> +out:
> +	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
> +	return error;
> +}
>  
>  /*
>   * Set the attribute specified in @args.
> @@ -406,54 +444,26 @@ xfs_attr_set_iter(
>  	case XFS_DAS_NODE_ADD:
>  		return xfs_attr_node_addname(attr);
>  
> -	case XFS_DAS_FOUND_LBLK:
> -	case XFS_DAS_FOUND_NBLK:
> -		/*
> -		 * Find space for remote blocks and fall into the allocation
> -		 * state.
> -		 */
> -		if (args->rmtblkno > 0) {
> -			error = xfs_attr_rmtval_find_space(attr);
> -			if (error)
> -				return error;
> -		}
> +	case XFS_DAS_LEAF_SET_RMT:
> +	case XFS_DAS_NODE_SET_RMT:
> +		error = xfs_attr_rmtval_find_space(attr);
> +		if (error)
> +			return error;
>  		attr->xattri_dela_state++;
>  		fallthrough;
> +
>  	case XFS_DAS_LEAF_ALLOC_RMT:
>  	case XFS_DAS_NODE_ALLOC_RMT:
> -
> -		/*
> -		 * If there was an out-of-line value, allocate the blocks we
> -		 * identified for its storage and copy the value.  This is done
> -		 * after we create the attribute so that we don't overflow the
> -		 * maximum size of a transaction and/or hit a deadlock.
> -		 */
> -		if (args->rmtblkno > 0) {
> -			if (attr->xattri_blkcnt > 0) {
> -				error = xfs_attr_rmtval_set_blk(attr);
> -				if (error)
> -					return error;
> -				trace_xfs_attr_set_iter_return(
> -						attr->xattri_dela_state,
> -						args->dp);
> -				return -EAGAIN;
> -			}
> -
> -			error = xfs_attr_rmtval_set_value(args);
> -			if (error)
> -				return error;
> -		}
> -
> -		/*
> -		 * If this is not a rename, clear the incomplete flag and we're
> -		 * done.
> -		 */
> -		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -			if (args->rmtblkno > 0)
> -				error = xfs_attr3_leaf_clearflag(args);
> +		error = xfs_attr_rmtval_alloc(attr);
> +		if (error)
>  			return error;
> -		}
> +		if (attr->xattri_dela_state == XFS_DAS_DONE)
> +			break;
> +		attr->xattri_dela_state++;
> +		fallthrough;
>  
> +	case XFS_DAS_LEAF_REPLACE:
> +	case XFS_DAS_NODE_REPLACE:
>  		/*
>  		 * If this is an atomic rename operation, we must "flip" the
>  		 * incomplete flags on the "new" and "old" attribute/value pairs
> @@ -471,10 +481,9 @@ xfs_attr_set_iter(
>  			 * Commit the flag value change and start the next trans
>  			 * in series at FLIP_FLAG.
>  			 */
> +			error = -EAGAIN;
>  			attr->xattri_dela_state++;
> -			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> +			break;
>  		}
>  
>  		attr->xattri_dela_state++;
> @@ -549,6 +558,8 @@ xfs_attr_set_iter(
>  		ASSERT(0);
>  		break;
>  	}
> +
> +	trace_xfs_attr_set_iter_return(attr->xattri_dela_state, args->dp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 37db61649217..1749fd8f7ddd 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -452,15 +452,17 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
>  
>  	/* Leaf state set sequence */
> -	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
> +	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
> +	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a leaf */
>  	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
>  
>  	/* Node state set sequence, must match leaf state above */
> -	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
> +	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
> +	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a node */
>  	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> @@ -476,13 +478,15 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_RMTBLK,	"XFS_DAS_RMTBLK" }, \
>  	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
>  	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
> -	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
> +	{ XFS_DAS_LEAF_SET_RMT,	"XFS_DAS_LEAF_SET_RMT" }, \
>  	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
> -	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
> -	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
> +	{ XFS_DAS_LEAF_REPLACE,	"XFS_DAS_LEAF_REPLACE" }, \
>  	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
>  	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
>  	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_NODE_SET_RMT,	"XFS_DAS_NODE_SET_RMT" }, \
> +	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
> +	{ XFS_DAS_NODE_REPLACE,	"XFS_DAS_NODE_REPLACE" },  \
>  	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
>  	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
>  	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 067ab31d7a20..cb9122327114 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4136,13 +4136,15 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
> -TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
> -TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
> -TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> @@ -4172,6 +4174,7 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
> -- 
> 2.35.1
> 
