Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E538EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC5C601FE
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbhCAUZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbhCAUX2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50880653FF;
        Mon,  1 Mar 2021 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614621920;
        bh=XWoPm3ISAvuUO1MMtFlCN5LQPouhIhlEaV5tk288Hog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ioeDmL3TMgtzN8AYeucQFmY2j2OZsO/ScK1khNqeHL/rBpDImgV+Wf0EOD0Knzxfr
         m2pyz9A5vP9oYMzO9XRjk6YpQhK0YtBrLKOn8M92s4Vm9RXPaCcaOX7KzzY/rn3geH
         orBLgQHKlRMAxCLtgBmVHbJnUhe43DFvxnyVqLFDFvZwOx6AXJZ2jPkHEGbvChVdPI
         cCWCcjWFTw0fQBagCEv/n5ZaF1aB2sWtDlVxP/XMUDN4wfxWDK4smg4L+beAN9nVfV
         Cu0u8ib05arJZT10w6rP8SN245Lw7LG6+9jwnR3P0CKlWvnDaLFzcHpvLLANkkztFH
         6W8SwoDOaFWQw==
Date:   Mon, 1 Mar 2021 10:05:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 08/22] xfs: Hoist xfs_attr_node_addname
Message-ID: <20210301180519.GH7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-9-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:34AM -0700, Allison Henderson wrote:
> This patch hoists the later half of xfs_attr_node_addname into
> the calling function.  We do this because it is this area that
> will need the most state management, and we want to keep such
> code in the same scope as much as possible
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Simple enough transplant,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 165 ++++++++++++++++++++++++-----------------------
>  1 file changed, 83 insertions(+), 82 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4333b61..19a532a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>  				 struct xfs_da_state *state);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> @@ -268,8 +269,9 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_da_state     *state;
> -	int			error;
> +	struct xfs_da_state     *state = NULL;
> +	int			error = 0;
> +	int			retval = 0;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -320,8 +322,82 @@ xfs_attr_set_args(
>  			return error;
>  		error = xfs_attr_node_addname(args, state);
>  	} while (error == -EAGAIN);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Commit the leaf addition or btree split and start the next
> +	 * trans in the chain.
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, dp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_rmtval_set(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +		/*
> +		 * Added a "remote" value, just clear the incomplete flag.
> +		 */
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
> +		retval = error;
> +		goto out;
> +	}
> +
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		goto out;
> +	/*
> +	 * Commit the flag value change and start the next trans in series
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
> +
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_rmtval_remove(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	error = xfs_attr_node_addname_work(args);
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
> +	if (error)
> +		return error;
> +	return retval;
>  
> -	return error;
>  }
>  
>  /*
> @@ -955,7 +1031,7 @@ xfs_attr_node_addname(
>  {
>  	struct xfs_da_state_blk	*blk;
>  	struct xfs_inode	*dp;
> -	int			retval, error;
> +	int			error;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> @@ -963,8 +1039,8 @@ xfs_attr_node_addname(
>  	blk = &state->path.blk[state->path.active-1];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  
> -	retval = xfs_attr3_leaf_add(blk->bp, state->args);
> -	if (retval == -ENOSPC) {
> +	error = xfs_attr3_leaf_add(blk->bp, state->args);
> +	if (error == -ENOSPC) {
>  		if (state->path.active == 1) {
>  			/*
>  			 * Its really a single leaf node, but it had
> @@ -1010,85 +1086,10 @@ xfs_attr_node_addname(
>  		xfs_da3_fixhashpath(state, &state->path);
>  	}
>  
> -	/*
> -	 * Kill the state structure, we're done with it and need to
> -	 * allow the buffers to come back later.
> -	 */
> -	xfs_da_state_free(state);
> -	state = NULL;
> -
> -	/*
> -	 * Commit the leaf addition or btree split and start the next
> -	 * trans in the chain.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
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
> -	error = xfs_attr3_leaf_flipflags(args);
> -	if (error)
> -		goto out;
> -	/*
> -	 * Commit the flag value change and start the next trans in series
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		goto out;
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
> -	error = xfs_attr_node_addname_work(args);
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> -	if (error)
> -		return error;
> -	return retval;
> +	return error;
>  }
>  
>  
> -- 
> 2.7.4
> 
