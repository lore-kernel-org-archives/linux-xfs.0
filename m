Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7010AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiEJXUZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiEJXUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8266C266CAF
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1196761901
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68127C385CE;
        Tue, 10 May 2022 23:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652224820;
        bh=SEu2TK9Tsl/RnPRgf5HfRrip37i5Br7Vrt6OUOrl2e0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cFkushFom0OtGgN6kXaNtdvg0G9kqcI6rfnmLt2Q59gSxNsfrUkscl31zNYgFq0np
         yJWKq7yWzvyxnhD+G6STXF4NsxhZvXVXqWVSGlcq1EQyFXTMMsSB/kZGb+yv1YpzA6
         1eIeuEYnClMkxyAC8EMb2b7VHvENSvLO17PAfds40Li9eXZ+zVm9FbcyJ9QXBxQpdD
         l35Ge3OcYrNxe/83le9NUSvPcP6BtpufA7EaUFQHKCRCv+CQbPbgasi4j9elJ6W2Oz
         hDnl51Mv+/1vaXCtTn1rg1QzV8pLWZJkP0IbBMDl8dPV9Ze8k4xvQWX3ahqc09m0Bv
         60xXuGE+Eunuw==
Date:   Tue, 10 May 2022 16:20:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: consolidate leaf/node states in
 xfs_attr_set_iter
Message-ID: <20220510232019.GK27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:27AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The operations performed from XFS_DAS_FOUND_LBLK through to
> XFS_DAS_RM_LBLK are now identical to XFS_DAS_FOUND_NBLK through to
> XFS_DAS_RM_NBLK. We can collapse these down into a single set of
> code.
> 
> To do this, define the states that leaf and node run through as
> separate sets of sequential states. Then as we move to the next
> state, we can use increments rather than specific state assignments
> to move through the states. This means the state progression is set
> by the initial state that enters the series and we don't need to
> duplicate the code anymore.
> 
> At the exit point of the series we need to select the correct leaf
> or node state, but that can also be done by state increment rather
> than assignment.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 127 ++++++---------------------------------
>  fs/xfs/libxfs/xfs_attr.h |   9 ++-
>  2 files changed, 27 insertions(+), 109 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ab8a884af512..be580da62f08 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -394,6 +394,7 @@ xfs_attr_set_iter(
>  	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
> +next_state:
>  	switch (attr->xattri_dela_state) {
>  	case XFS_DAS_UNINIT:
>  		ASSERT(0);
> @@ -406,6 +407,7 @@ xfs_attr_set_iter(
>  		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
> +	case XFS_DAS_FOUND_NBLK:
>  		/*
>  		 * Find space for remote blocks and fall into the allocation
>  		 * state.
> @@ -415,9 +417,10 @@ xfs_attr_set_iter(
>  			if (error)
>  				return error;
>  		}
> -		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
> +		attr->xattri_dela_state++;
>  		fallthrough;
>  	case XFS_DAS_LEAF_ALLOC_RMT:
> +	case XFS_DAS_NODE_ALLOC_RMT:
>  
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
> @@ -466,16 +469,18 @@ xfs_attr_set_iter(
>  				return error;
>  			/*
>  			 * Commit the flag value change and start the next trans
> -			 * in series.
> +			 * in series at FLIP_FLAG.
>  			 */
> -			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
> +			attr->xattri_dela_state++;
>  			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>  						       args->dp);
>  			return -EAGAIN;
>  		}
>  
> +		attr->xattri_dela_state++;
>  		fallthrough;
>  	case XFS_DAS_FLIP_LFLAG:
> +	case XFS_DAS_FLIP_NFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing a
>  		 * "remote" value (if it exists).
> @@ -485,10 +490,10 @@ xfs_attr_set_iter(
>  		if (error)
>  			return error;
>  
> +		attr->xattri_dela_state++;
>  		fallthrough;
>  	case XFS_DAS_RM_LBLK:
> -		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
> +	case XFS_DAS_RM_NBLK:
>  		if (args->rmtblkno) {
>  			error = xfs_attr_rmtval_remove(attr);
>  			if (error == -EAGAIN)
> @@ -503,7 +508,16 @@ xfs_attr_set_iter(
>  			return -EAGAIN;
>  		}
>  
> -		fallthrough;
> +		/*
> +		 * This is the end of the shared leaf/node sequence. We need
> +		 * to continue at the next state in the sequence, but we can't
> +		 * easily just fall through. So we increment to the next state
> +		 * and then jump back to switch statement to evaluate the next
> +		 * state correctly.
> +		 */
> +		attr->xattri_dela_state++;
> +		goto next_state;
> +
>  	case XFS_DAS_RD_LEAF:
>  		/*
>  		 * This is the last step for leaf format. Read the block with
> @@ -524,106 +538,6 @@ xfs_attr_set_iter(
>  
>  		return error;
>  
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
> -
> -		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
> -		fallthrough;
> -	case XFS_DAS_NODE_ALLOC_RMT:
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
> -					attr->xattri_dela_state, args->dp);
> -				return -EAGAIN;
> -			}
> -
> -			error = xfs_attr_rmtval_set_value(args);
> -			if (error)
> -				return error;
> -		}
> -
> -		/*
> -		 * If this was not a rename, clear the incomplete flag and we're
> -		 * done.
> -		 */
> -		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -			if (args->rmtblkno > 0)
> -				error = xfs_attr3_leaf_clearflag(args);
> -			goto out;
> -		}
> -
> -		/*
> -		 * If this is an atomic rename operation, we must "flip" the
> -		 * incomplete flags on the "new" and "old" attribute/value pairs
> -		 * so that one disappears and one appears atomically.  Then we
> -		 * must remove the "old" attribute/value pair.
> -		 *
> -		 * In a separate transaction, set the incomplete flag on the
> -		 * "old" attr and clear the incomplete flag on the "new" attr.
> -		 */
> -		if (!xfs_has_larp(mp)) {
> -			error = xfs_attr3_leaf_flipflags(args);
> -			if (error)
> -				goto out;
> -			/*
> -			 * Commit the flag value change and start the next trans
> -			 * in series
> -			 */
> -			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
> -			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_FLIP_NFLAG:
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing a
> -		 * "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
> -
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		fallthrough;
> -	case XFS_DAS_RM_NBLK:
> -		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> -		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(attr);
> -			if (error == -EAGAIN)
> -				trace_xfs_attr_set_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -
> -			if (error)
> -				return error;
> -
> -			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
> -			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
>  	case XFS_DAS_CLR_FLAG:
>  		/*
>  		 * The last state for node format. Look up the old attr and
> @@ -635,7 +549,6 @@ xfs_attr_set_iter(
>  		ASSERT(0);
>  		break;
>  	}
> -out:
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index d016af4dbf81..37db61649217 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -450,16 +450,21 @@ enum xfs_delattr_state {
>  	XFS_DAS_RMTBLK,			/* Removing remote blks */
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
> +
> +	/* Leaf state set sequence */

I think this comment should note that the state increment operations of
xfs_attr_set_iter requires that the exact order of the values
FOUND_[LN]BLK through RM_[LN]BLK must be preserved exactly.

Question: Are we supposed to be able to dela_state++ our way from
RM_LBLK to RD_LEAF and from RM_NBLK to CLR_FLAG?

With that comment added,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
> -	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
> -	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
>  	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> +
> +	/* Node state set sequence, must match leaf state above */
> +	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
> +	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
>  	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> +
>  	XFS_DAS_DONE,			/* finished operation */
>  };
>  
> -- 
> 2.35.1
> 
