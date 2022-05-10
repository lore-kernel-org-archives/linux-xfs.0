Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759A3C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbiEJX3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiEJX3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:29:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5592817B8
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8408DB8201C
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C174C385CC;
        Tue, 10 May 2022 23:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652225357;
        bh=Q/gNZsZKJhbiOncy9dF5ZYHmF2qx079xGHzA2uQeoDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sawRiRL23M0UszPFPE8e5Q+LgO2QgP2GFRGare2XCtfAV9n1fc0nQLmJuSyPHNsDI
         vhp9aMNraaP5F5Kp8IC/Q9pW5hBbHlwu+E/H7w1li2e2ILW3q2eB3YODz/PBjTEtIb
         3P7+BpoFWhPzcvgvlUyKjiPPdABmnwU26Be7vuBKEsB9iDFsg+75tzbqXwRMD7Eyvi
         pE9JFM07W428Ea+vP57v2dIznMokkT+VHDbApTDxjoZiJJTSg/v8JToZzXg7wCPMfi
         9ZtxAeYPydkPfuBiqETS4TiF03ks9yMmmTgwBvQvszO/9bvj+BSztWdHOPrDnp6E41
         hBKO5qODOBeKA==
Date:   Tue, 10 May 2022 16:29:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: clean up final attr removal in
 xfs_attr_set_iter
Message-ID: <20220510232916.GO27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-12-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up the final leaf/node states in xfs_attr_set_iter() to
> further simplify the high level state machine and to set the
> completion state correctly. As we are adding a separate state
> for node format removal, we need to ensure that node formats
> are collapsed back to shortformi or empty correctly.

Nit: shortform

With that fixed, this is a nice disentangling of more of the state
machine.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 149 ++++++++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_attr.h |  12 ++--
>  fs/xfs/xfs_trace.h       |   5 +-
>  3 files changed, 94 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d65abaead9a1..5707ac4f44a7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -61,7 +61,7 @@ STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>  static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
> -STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
> +STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> @@ -444,6 +444,77 @@ xfs_attr_rmtval_alloc(
>  	return error;
>  }
>  
> +/*
> + * Remove the original attr we have just replaced. This is dependent on the
> + * original lookup and insert placing the old attr in args->blkno/args->index
> + * and the new attr in args->blkno2/args->index2.
> + */
> +static int
> +xfs_attr_leaf_remove_attr(
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_da_args              *args = attr->xattri_da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_buf			*bp = NULL;
> +	int				forkoff;
> +	int				error;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> +				   &bp);
> +	if (error)
> +		return error;
> +
> +	xfs_attr3_leaf_remove(bp, args);
> +
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff)
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +
> +	return error;
> +}
> +
> +/*
> + * Shrink an attribute from leaf to shortform. Used by the node format remove
> + * path when the node format collapses to a single block and so we have to check
> + * if it can be collapsed further.
> + */
> +static int
> +xfs_attr_leaf_shrink(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state     *state)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error, forkoff;
> +	struct xfs_buf		*bp;
> +
> +	if (!xfs_attr_is_leaf(dp))
> +		return 0;
> +
> +	/*
> +	 * Have to get rid of the copy of this dabuf in the state.
> +	 */
> +	if (state) {
> +		ASSERT(state->path.active == 1);
> +		ASSERT(state->path.blk[0].bp);
> +		state->path.blk[0].bp = NULL;
> +	}
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> +	if (error)
> +		return error;
> +
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff) {
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +	} else {
> +		xfs_trans_brelse(args->trans, bp);
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may return
> @@ -456,9 +527,7 @@ xfs_attr_set_iter(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args              *args = attr->xattri_da_args;
> -	struct xfs_inode		*dp = args->dp;
> -	struct xfs_buf			*bp = NULL;
> -	int				forkoff, error = 0;
> +	int				error = 0;
>  
>  	/* State machine switch */
>  next_state:
> @@ -549,32 +618,16 @@ xfs_attr_set_iter(
>  		attr->xattri_dela_state++;
>  		break;
>  
> -	case XFS_DAS_RD_LEAF:
> -		/*
> -		 * This is the last step for leaf format. Read the block with
> -		 * the old attr, remove the old attr, check for shortform
> -		 * conversion and return.
> -		 */
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -					   &bp);
> -		if (error)
> -			return error;
> -
> -		xfs_attr3_leaf_remove(bp, args);
> -
> -		forkoff = xfs_attr_shortform_allfit(bp, dp);
> -		if (forkoff)
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -
> -		return error;
> +	case XFS_DAS_LEAF_REMOVE_ATTR:
> +		error = xfs_attr_leaf_remove_attr(attr);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +		break;
>  
> -	case XFS_DAS_CLR_FLAG:
> -		/*
> -		 * The last state for node format. Look up the old attr and
> -		 * remove it.
> -		 */
> -		error = xfs_attr_node_addname_clear_incomplete(attr);
> +	case XFS_DAS_NODE_REMOVE_ATTR:
> +		error = xfs_attr_node_remove_attr(attr);
> +		if (!error)
> +			error = xfs_attr_leaf_shrink(args, NULL);
> +		attr->xattri_dela_state = XFS_DAS_DONE;
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -1269,8 +1322,8 @@ xfs_attr_node_try_addname(
>  }
>  
>  
> -STATIC int
> -xfs_attr_node_addname_clear_incomplete(
> +static int
> +xfs_attr_node_remove_attr(
>  	struct xfs_attr_item		*attr)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> @@ -1311,38 +1364,6 @@ xfs_attr_node_addname_clear_incomplete(
>  	return retval;
>  }
>  
> -/*
> - * Shrink an attribute from leaf to shortform
> - */
> -STATIC int
> -xfs_attr_node_shrink(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state     *state)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	int			error, forkoff;
> -	struct xfs_buf		*bp;
> -
> -	/*
> -	 * Have to get rid of the copy of this dabuf in the state.
> -	 */
> -	ASSERT(state->path.active == 1);
> -	ASSERT(state->path.blk[0].bp);
> -	state->path.blk[0].bp = NULL;
> -
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -	if (error)
> -		return error;
> -
> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
> -	if (forkoff) {
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -		/* bp is gone due to xfs_da_shrink_inode */
> -	} else
> -		xfs_trans_brelse(args->trans, bp);
> -
> -	return error;
> -}
>  
>  /*
>   * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
> @@ -1551,7 +1572,7 @@ xfs_attr_remove_iter(
>  		 * transaction.
>  		 */
>  		if (xfs_attr_is_leaf(dp))
> -			error = xfs_attr_node_shrink(args, state);
> +			error = xfs_attr_leaf_shrink(args, state);
>  		ASSERT(error != -EAGAIN);
>  		break;
>  	default:
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index d67535e4ce5a..c318260f17d4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -451,21 +451,21 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
>  
> -	/* Leaf state set sequence */
> +	/* Leaf state set/replace sequence */
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a leaf */
>  	XFS_DAS_LEAF_REMOVE_OLD,	/* Start removing old attr from leaf */
>  	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks */
> -	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> +	XFS_DAS_LEAF_REMOVE_ATTR,	/* Remove the old attr from a leaf */
>  
> -	/* Node state set sequence, must match leaf state above */
> +	/* Node state set/replace sequence, must match leaf state above */
>  	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a node */
>  	XFS_DAS_NODE_REMOVE_OLD,	/* Start removing old attr from node */
>  	XFS_DAS_NODE_REMOVE_RMT,	/* A rename is removing remote blocks */
> -	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> +	XFS_DAS_NODE_REMOVE_ATTR,	/* Remove the old attr from a node */
>  
>  	XFS_DAS_DONE,			/* finished operation */
>  };
> @@ -483,13 +483,13 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
>  	{ XFS_DAS_LEAF_REMOVE_OLD,	"XFS_DAS_LEAF_REMOVE_OLD" }, \
>  	{ XFS_DAS_LEAF_REMOVE_RMT,	"XFS_DAS_LEAF_REMOVE_RMT" }, \
> -	{ XFS_DAS_RD_LEAF,		"XFS_DAS_RD_LEAF" }, \
> +	{ XFS_DAS_LEAF_REMOVE_ATTR,	"XFS_DAS_LEAF_REMOVE_ATTR" }, \
>  	{ XFS_DAS_NODE_SET_RMT,		"XFS_DAS_NODE_SET_RMT" }, \
>  	{ XFS_DAS_NODE_ALLOC_RMT,	"XFS_DAS_NODE_ALLOC_RMT" },  \
>  	{ XFS_DAS_NODE_REPLACE,		"XFS_DAS_NODE_REPLACE" },  \
>  	{ XFS_DAS_NODE_REMOVE_OLD,	"XFS_DAS_NODE_REMOVE_OLD" }, \
>  	{ XFS_DAS_NODE_REMOVE_RMT,	"XFS_DAS_NODE_REMOVE_RMT" }, \
> -	{ XFS_DAS_CLR_FLAG,		"XFS_DAS_CLR_FLAG" }, \
> +	{ XFS_DAS_NODE_REMOVE_ATTR,	"XFS_DAS_NODE_REMOVE_ATTR" }, \
>  	{ XFS_DAS_DONE,			"XFS_DAS_DONE" }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 793d2a86ab2c..260760ce2d05 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4141,13 +4141,14 @@ TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_RMT);
> -TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE_ATTR);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REPLACE);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_OLD);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_RMT);
> -TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE_ATTR);
> +TRACE_DEFINE_ENUM(XFS_DAS_DONE);
>  
>  DECLARE_EVENT_CLASS(xfs_das_state_class,
>  	TP_PROTO(int das, struct xfs_inode *ip),
> -- 
> 2.35.1
> 
