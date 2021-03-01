Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DFABC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37FE600CD
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhCAUhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237086AbhCAUdq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4AF164E44;
        Mon,  1 Mar 2021 18:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614622754;
        bh=1MZ5eOt78MNYMwCB93q0oi8B4XfvcLCqEfk/44gVK5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=imMT7vbXeHRaOUG8UX4nJBsr54zq8rh9M7T/OLJNb9tgS2TgP0/EC+8v5FVIHd4h2
         CLhSQaRcWdLpE9Petve6gaDZ/i4UsOalIzjBuvs9DN9lP5jqrnhWk0Uy8FWbtaXbB8
         q41MdZkzEZoIThetMtGRzbraqti6CLJipXbarMDr0LnQxSpZWX+r2Y/qLiI0asNtQQ
         TB5fmnth4RayUYbWyEo+jgMbmmu71x5zOxfu3gwPH5WS/OZXByW/Rly/PPrt3xFLFG
         M2a0QoGQGT/IPzrHleahoHRN6O8Rtd7/gGVEJiduu2JmL5NdR06hdvNP2FrWeBi7FE
         Dfk8+4WGdChzQ==
Date:   Mon, 1 Mar 2021 10:19:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 09/22] xfs: Hoist xfs_attr_leaf_addname
Message-ID: <20210301181913.GI7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-10-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:35AM -0700, Allison Henderson wrote:
> This patch hoists xfs_attr_leaf_addname into the calling function.  The
> goal being to get all the code that will require state management into
> the same scope. This isn't particuarly asetheic right away, but it is a

"aesthetic"

> preliminary step to to manageing the state machine code.

"to merging in" ?

The goto label is ugly, but afaict this patch moves code and the next
one rearranges it the way you ultimately want it, right?

With spelling fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>  1 file changed, 96 insertions(+), 113 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 19a532a..bfd4466 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   * Internal routines when attribute list is one block.
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>  
>  /*
>   * Internal routines when attribute list is more than one block.
> @@ -269,8 +269,9 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_buf		*bp = NULL;
>  	struct xfs_da_state     *state = NULL;
> -	int			error = 0;
> +	int			forkoff, error = 0;
>  	int			retval = 0;
>  
>  	/*
> @@ -286,10 +287,101 @@ xfs_attr_set_args(
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_addname(args);
> -		if (error != -ENOSPC)
> +		error = xfs_attr_leaf_try_add(args, bp);
> +		if (error == -ENOSPC)
> +			goto node;
> +		else if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the transaction that added the attr name so that
> +		 * later routines can manage their own transactions.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * If there was an out-of-line value, allocate the blocks we
> +		 * identified for its storage and copy the value.  This is done
> +		 * after we create the attribute so that we don't overflow the
> +		 * maximum size of a transaction and/or hit a deadlock.
> +		 */
> +		if (args->rmtblkno > 0) {
> +			error = xfs_attr_rmtval_set(args);
> +			if (error)
> +				return error;
> +		}
> +
> +		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +			/*
> +			 * Added a "remote" value, just clear the incomplete
> +			 *flag.
> +			 */
> +			if (args->rmtblkno > 0)
> +				error = xfs_attr3_leaf_clearflag(args);
> +
> +			return error;
> +		}
> +
> +		/*
> +		 * If this is an atomic rename operation, we must "flip" the
> +		 * incomplete flags on the "new" and "old" attribute/value pairs
> +		 * so that one disappears and one appears atomically.  Then we
> +		 * must remove the "old" attribute/value pair.
> +		 *
> +		 * In a separate transaction, set the incomplete flag on the
> +		 * "old" attr and clear the incomplete flag on the "new" attr.
> +		 */
> +
> +		error = xfs_attr3_leaf_flipflags(args);
> +		if (error)
> +			return error;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Dismantle the "old" attribute/value pair by removing a
> +		 * "remote" value (if it exists).
> +		 */
> +		xfs_attr_restore_rmt_blk(args);
> +
> +		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_invalidate(args);
> +			if (error)
> +				return error;
> +
> +			error = xfs_attr_rmtval_remove(args);
> +			if (error)
> +				return error;
> +		}
> +
> +		/*
> +		 * Read in the block containing the "old" attr, then remove the
> +		 * "old" attr from that block (neat, huh!)
> +		 */
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> +					   &bp);
> +		if (error)
>  			return error;
>  
> +		xfs_attr3_leaf_remove(bp, args);
> +
> +		/*
> +		 * If the result is small enough, shrink it all into the inode.
> +		 */
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			/* bp is gone due to xfs_da_shrink_inode */
> +
> +		return error;
> +node:
>  		/*
>  		 * Promote the attribute list to the Btree format.
>  		 */
> @@ -731,115 +823,6 @@ xfs_attr_leaf_try_add(
>  	return retval;
>  }
>  
> -
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
> -STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> -{
> -	int			error, forkoff;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error = xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If there was an out-of-line value, allocate the blocks we
> -	 * identified for its storage and copy the value.  This is done
> -	 * after we create the attribute so that we don't overflow the
> -	 * maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
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
> -
> -	error = xfs_attr3_leaf_flipflags(args);
> -	if (error)
> -		return error;
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> -
> -	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		error = xfs_attr_rmtval_remove(args);
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
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> -- 
> 2.7.4
> 
