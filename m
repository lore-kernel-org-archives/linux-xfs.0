Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49587C28D17
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26CAF64D9E
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245113AbhCBGiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236900AbhCBBkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 20:40:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 108ED601FF;
        Tue,  2 Mar 2021 01:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614649149;
        bh=Pia6b5mXDuy3o9EQqciAdTQq0tklfjh1JnTxl5kfUWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZiS3N9zpTnMjz30GgfCquSHnChFG2UljZtPVbrADjdIOGO/5B5ysDPH7huvZIJL3e
         mDus0UTP7OX3xRq7T9oorxKPDNej00ADibS+U4dGCjrA0ygP4hP0bq0TcRtrfUoQTR
         a2IdgnMC1kJgt50/5ABOkTXSZxepcy+602tbsfUKQpi4LeRfs5Os40CTw6FFFXfUBb
         BEVGSFMncRqDNZHm/KAfip7mL79Jzw+JL58Rt2iQiUNze+L0BBxV2OoLRS+R+IXa0C
         eJIWwUe7l+u8UNcVsvXmZjcFO3iXxwQVrDPm8DgZ5wmX6MEgJIljfCIuA3fI+K069V
         WBdG0GgU+aP7g==
Date:   Mon, 1 Mar 2021 17:39:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 12/22] xfs: Add delay ready attr set routines
Message-ID: <20210302013905.GL7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210218165348.4754-13-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:38AM -0700, Allison Henderson wrote:
> This patch modifies the attr set routines to be delay ready. This means
> they no longer roll or commit transactions, but instead return -EAGAIN
> to have the calling routine roll and refresh the transaction.  In this
> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> state machine like switch to keep track of where it was when EAGAIN was
> returned. See xfs_attr.h for a more detailed diagram of the states.
> 
> Two new helper functions have been added: xfs_attr_rmtval_find_space and
> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations.
> This helps to simplify and consolidate code used by
> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> now become a simple loop to refresh the transaction until the operation
> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> removed.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

I /think/ this looks reasonable.

By the way, would you mind going through the comments in these patches
looking for typos?  I noticed a few ("sucesfull") lurking here and
there.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 448 ++++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_attr.h        | 241 ++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  98 ++++++---
>  fs/xfs/libxfs/xfs_attr_remote.h |   5 +-
>  fs/xfs/xfs_trace.h              |   1 -
>  5 files changed, 583 insertions(+), 210 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d46b92a..c7b86d5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -53,16 +53,16 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
> -STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
> -				 struct xfs_da_state *state);
> -STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> -				 struct xfs_da_state **state);
> -STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
> +STATIC int xfs_attr_node_addname_work(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> +			     struct xfs_buf **leaf_bp);
>  
>  int
>  xfs_inode_hasattr(
> @@ -226,7 +226,7 @@ xfs_attr_is_shortform(
>   * also checks for a defer finish.  Transaction is finished and rolled as
>   * needed, and returns true of false if the delayed operation should continue.
>   */
> -int
> +STATIC int
>  xfs_attr_trans_roll(
>  	struct xfs_delattr_context	*dac)
>  {
> @@ -249,29 +249,55 @@ xfs_attr_trans_roll(
>  	return error;
>  }
>  
> +/*
> + * Set the attribute specified in @args.
> + */
> +int
> +xfs_attr_set_args(
> +	struct xfs_da_args		*args)
> +{
> +	struct xfs_buf			*leaf_bp = NULL;
> +	int				error = 0;
> +	struct xfs_delattr_context	dac = {
> +		.da_args	= args,
> +	};
> +
> +	do {
> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
> +		if (error != -EAGAIN)
> +			break;
> +
> +		error = xfs_attr_trans_roll(&dac);
> +		if (error)
> +			return error;
> +	} while (true);
> +
> +	return error;
> +}
> +
>  STATIC int
>  xfs_attr_set_fmt(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_buf			**leaf_bp)
>  {
> -	struct xfs_buf          *leaf_bp = NULL;
> -	struct xfs_inode	*dp = args->dp;
> -	int			error2, error = 0;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
>  
>  	/*
>  	 * Try to add the attr to the attribute list in the inode.
>  	 */
>  	error = xfs_attr_try_sf_addname(dp, args);
> -	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> -	}
> +
> +	/* Should only be 0, -EEXIST or -ENOSPC */
> +	if (error != -ENOSPC)
> +		return error;
>  
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf block.
>  	 * GROT: another possible req'mt for a double-split btree op.
>  	 */
> -	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>  	if (error)
>  		return error;
>  
> @@ -280,93 +306,140 @@ xfs_attr_set_fmt(
>  	 * concurrent AIL push cannot grab the half-baked leaf buffer
>  	 * and run into problems with the write verifier.
>  	 */
> -	xfs_trans_bhold(args->trans, leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, leaf_bp);
> -	if (error)
> -		xfs_trans_brelse(args->trans, leaf_bp);
> +	xfs_trans_bhold(args->trans, *leaf_bp);
>  
> +	/*
> +	 * We're still in XFS_DAS_UNINIT state here.  We've converted
> +	 * the attr fork to leaf format and will restart with the leaf
> +	 * add.
> +	 */
> +	dac->flags |= XFS_DAC_DEFER_FINISH;
>  	return -EAGAIN;
>  }
>  
>  /*
>   * Set the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
>   */
>  int
> -xfs_attr_set_args(
> -	struct xfs_da_args	*args)
> +xfs_attr_set_iter(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_buf			**leaf_bp)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_da_state     *state = NULL;
> -	int			forkoff, error = 0;
> -	int			retval = 0;
> +	struct xfs_da_args              *args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_buf			*bp = NULL;
> +	struct xfs_da_state		*state = NULL;
> +	int				forkoff, error = 0;
> +	int				retval = 0;
>  
> -	/*
> -	 * If the attribute list is already in leaf format, jump straight to
> -	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> -	 * list; if there's no room then convert the list to leaf format and try
> -	 * again.
> -	 */
> -	if (xfs_attr_is_shortform(dp)) {
> -		error = xfs_attr_set_fmt(args);
> -		if (error != -EAGAIN)
> -			return error;
> -	}
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_UNINIT:
> +		if (xfs_attr_is_shortform(dp))
> +			return xfs_attr_set_fmt(dac, leaf_bp);
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_try_add(args, bp);
> -		if (error == -ENOSPC) {
> -			/*
> -			 * Promote the attribute list to the Btree format.
> -			 */
> -			error = xfs_attr3_leaf_to_node(args);
> +		/*
> +		 * After a shortform to leaf conversion, we need to hold the
> +		 * leaf and cycle out the transaction.  When we get back,
> +		 * we need to release the leaf to release the hold on the leaf
> +		 * buffer.
> +		 */
> +		if (*leaf_bp != NULL) {
> +			xfs_trans_bhold_release(args->trans, *leaf_bp);
> +			*leaf_bp = NULL;
> +		}
> +
> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +			error = xfs_attr_leaf_try_add(args, *leaf_bp);
> +			if (error == -ENOSPC) {
> +				/*
> +				 * Promote the attribute list to the Btree
> +				 * format.
> +				 */
> +				error = xfs_attr3_leaf_to_node(args);
> +				if (error)
> +					return error;
> +
> +				/*
> +				 * Finish any deferred work items and roll the
> +				 * transaction once more.  The goal here is to
> +				 * call node_addname with the inode and
> +				 * transaction in the same state (inode locked
> +				 * and joined, transaction clean) no matter how
> +				 * we got to this step.
> +				 *
> +				 * At this point, we are still in
> +				 * XFS_DAS_UNINIT, but when we come back, we'll
> +				 * be a node, so we'll fall down into the node
> +				 * handling code below
> +				 */
> +				dac->flags |= XFS_DAC_DEFER_FINISH;
> +				return -EAGAIN;
> +			}
> +			else if (error)
> +				return error;
> +		}
> +		else {
> +			error = xfs_attr_node_addname_find_attr(dac);
>  			if (error)
>  				return error;
>  
> -			/*
> -			 * Finish any deferred work items and roll the transaction once
> -			 * more.  The goal here is to call node_addname with the inode
> -			 * and transaction in the same state (inode locked and joined,
> -			 * transaction clean) no matter how we got to this step.
> -			 */
> -			error = xfs_defer_finish(&args->trans);
> +			error = xfs_attr_node_addname(dac);
>  			if (error)
>  				return error;
>  
>  			/*
> -			 * Commit the current trans (including the inode) and
> -			 * start a new one.
> +			 * If addname was sucesfull, and we dont need to alloc
> +			 * anymore blks, we're done.
>  			 */
> -			error = xfs_trans_roll_inode(&args->trans, dp);
> -			if (error)
> +			if (!args->rmtblkno && !args->rmtblkno2)
>  				return error;
>  
> -			goto node;
> +			dac->dela_state = XFS_DAS_FOUND_NBLK;
> +			return -EAGAIN;
>  		}
> -		else if (error)
> -			return error;
>  
> -		/*
> -		 * Commit the transaction that added the attr name so that
> -		 * later routines can manage their own transactions.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> +		dac->dela_state = XFS_DAS_FOUND_LBLK;
> +		return -EAGAIN;
>  
> +        case XFS_DAS_FOUND_LBLK:
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
>  		 * identified for its storage and copy the value.  This is done
>  		 * after we create the attribute so that we don't overflow the
>  		 * maximum size of a transaction and/or hit a deadlock.
>  		 */
> -		if (args->rmtblkno > 0) {
> -			error = xfs_attr_rmtval_set(args);
> +
> +		/* Open coded xfs_attr_rmtval_set without trans handling */
> +		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> +			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
> +			if (args->rmtblkno > 0) {
> +				error = xfs_attr_rmtval_find_space(dac);
> +				if (error)
> +					return error;
> +			}
> +		}
> +
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.
> +		 */
> +		if (dac->blkcnt > 0) {
> +			error = xfs_attr_rmtval_set_blk(dac);
>  			if (error)
>  				return error;
> +
> +			return -EAGAIN;
>  		}
>  
> +		error = xfs_attr_rmtval_set_value(args);
> +		if (error)
> +			return error;
> +
>  		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  			/*
>  			 * Added a "remote" value, just clear the incomplete
> @@ -395,22 +468,26 @@ xfs_attr_set_args(
>  		 * Commit the flag value change and start the next trans in
>  		 * series.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			return error;
> -
> +		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +		return -EAGAIN;
> +	case XFS_DAS_FLIP_LFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing a
>  		 * "remote" value (if it exists).
>  		 */
>  		xfs_attr_restore_rmt_blk(args);
>  
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_invalidate(args);
> -			if (error)
> -				return error;
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
>  
> -			error = xfs_attr_rmtval_remove(args);
> +		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> +		dac->dela_state = XFS_DAS_RM_LBLK;
> +
> +		/* fallthrough */
> +	case XFS_DAS_RM_LBLK:
> +		if (args->rmtblkno) {
> +			error = __xfs_attr_rmtval_remove(dac);
>  			if (error)
>  				return error;
>  		}
> @@ -435,94 +512,117 @@ xfs_attr_set_args(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  
>  		return error;
> -	}
> -node:
>  
> +	case XFS_DAS_FOUND_NBLK:
> +		/*
> +		 * If there was an out-of-line value, allocate the blocks we
> +		 * identified for its storage and copy the value.  This is done
> +		 * after we create the attribute so that we don't overflow the
> +		 * maximum size of a transaction and/or hit a deadlock.
> +		 */
> +		if (args->rmtblkno > 0) {
> +			/*
> +			 * Open coded xfs_attr_rmtval_set without trans
> +			 * handling
> +			 */
> +			error = xfs_attr_rmtval_find_space(dac);
> +			if (error)
> +				return error;
>  
> -	do {
> -		error = xfs_attr_node_addname_find_attr(args, &state);
> -		if (error)
> -			return error;
> -		error = xfs_attr_node_addname(args, state);
> -	} while (error == -EAGAIN);
> -	if (error)
> -		return error;
> +			/*
> +			 * Roll through the "value", allocating blocks on disk
> +			 * as required.  Set the state in case of -EAGAIN return
> +			 * code
> +			 */
> +			dac->dela_state = XFS_DAS_ALLOC_NODE;
> +		}
>  
> -	/*
> -	 * Commit the leaf addition or btree split and start the next
> -	 * trans in the chain.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
> +		/* fallthrough */
> +	case XFS_DAS_ALLOC_NODE:
> +		if (args->rmtblkno > 0) {
> +			if (dac->blkcnt > 0) {
> +				error = xfs_attr_rmtval_set_blk(dac);
> +				if (error)
> +					return error;
>  
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
> +			 * Added a "remote" value, just clear the incomplete
> +			 * flag.
> +			 */
> +			if (args->rmtblkno > 0)
> +				error = xfs_attr3_leaf_clearflag(args);
> +			retval = error;
> +			goto out;
> +		}
>  
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> +		 * If this is an atomic rename operation, we must "flip" the
> +		 * incomplete flags on the "new" and "old" attribute/value pairs
> +		 * so that one disappears and one appears atomically.  Then we
> +		 * must remove the "old" attribute/value pair.
> +		 *
> +		 * In a separate transaction, set the incomplete flag on the
> +		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
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
> +		error = xfs_attr3_leaf_flipflags(args);
> +		if (error)
> +			goto out;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series
> +		 */
> +		dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +		return -EAGAIN;
>  
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> +	case XFS_DAS_FLIP_NFLAG:
> +		/*
> +		 * Dismantle the "old" attribute/value pair by removing a
> +		 * "remote" value (if it exists).
> +		 */
> +		xfs_attr_restore_rmt_blk(args);
>  
> -	if (args->rmtblkno) {
>  		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
>  
> -		error = xfs_attr_rmtval_remove(args);
> +		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
> +		dac->dela_state = XFS_DAS_RM_NBLK;
> +
> +		/* fallthrough */
> +	case XFS_DAS_RM_NBLK:
> +		if (args->rmtblkno) {
> +			error = __xfs_attr_rmtval_remove(dac);
> +			if (error)
> +				return error;
> +		}
> +
> +		error = xfs_attr_node_addname_work(dac);
> +
> +out:
> +		if (state)
> +			xfs_da_state_free(state);
>  		if (error)
>  			return error;
> -	}
> +		return retval;
>  
> -	error = xfs_attr_node_addname_work(args);
> -out:
> -	if (state)
> -		xfs_da_state_free(state);
> -	if (error)
> -		return error;
> -	return retval;
> +	default:
> +		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
> +		break;
> +	}
>  
> +	return error;
>  }
>  
> +
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> @@ -1021,18 +1121,18 @@ xfs_attr_node_hasname(
>  
>  STATIC int
>  xfs_attr_node_addname_find_attr(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state     **state)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			retval;
> +	struct xfs_da_args		*args = dac->da_args;
> +	int				retval;
>  
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	retval = xfs_attr_node_hasname(args, state);
> +	retval = xfs_attr_node_hasname(args, &dac->da_state);
>  	if (retval != -ENOATTR && retval != -EEXIST)
> -		goto out;
> +		return retval;
>  
>  	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>  		goto out;
> @@ -1058,8 +1158,8 @@ xfs_attr_node_addname_find_attr(
>  
>  	return 0;
>  out:
> -	if (*state)
> -		xfs_da_state_free(*state);
> +	if (dac->da_state)
> +		xfs_da_state_free(dac->da_state);
>  	return retval;
>  }
>  
> @@ -1072,20 +1172,24 @@ xfs_attr_node_addname_find_attr(
>   *
>   * "Remote" attribute values confuse the issue and atomic rename operations
>   * add a whole extra layer of confusion on top of that.
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + *returned.
>   */
>  STATIC int
>  xfs_attr_node_addname(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
> -	int			error;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		*state = dac->da_state;
> +	struct xfs_da_state_blk		*blk;
> +	int				error;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> -	dp = args->dp;
> -	blk = &state->path.blk[state->path.active-1];
> +	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  
>  	error = xfs_attr3_leaf_add(blk->bp, state->args);
> @@ -1101,18 +1205,15 @@ xfs_attr_node_addname(
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  
>  			/*
> -			 * Commit the node conversion and start the next
> -			 * trans in the chain.
> +			 * Now that we have converted the leaf to a node, we can
> +			 * roll the transaction, and try xfs_attr3_leaf_add
> +			 * again on re-entry.  No need to set dela_state to do
> +			 * this. dela_state is still unset by this function at
> +			 * this point.
>  			 */
> -			error = xfs_trans_roll_inode(&args->trans, dp);
> -			if (error)
> -				goto out;
> -
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			return -EAGAIN;
>  		}
>  
> @@ -1125,9 +1226,7 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -1144,8 +1243,9 @@ xfs_attr_node_addname(
>  
>  STATIC
>  int xfs_attr_node_addname_work(
> -	struct xfs_da_args		*args)
> +	struct xfs_delattr_context	*dac)
>  {
> +	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = NULL;
>  	struct xfs_da_state_blk		*blk;
>  	int				retval = 0;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3154ef4..603887e 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -135,6 +135,233 @@ struct xfs_attr_list_context {
>   *              v
>   *            done
>   *
> + *
> + * Below is a state machine diagram for attr set operations.
> + *
> + * It seems the challenge with undertanding this system comes from trying to
> + * absorb the state machine all at once, when really one should only be looking
> + * at it with in the context of a single function.  Once a state sensitive
> + * function is called, the idea is that it "takes ownership" of the
> + * statemachine. It isn't concerned with the states that may have belonged to
> + * it's calling parent.  Only the states relevant to itself or any other
> + * subroutines there in.  Once a calling function hands off the statemachine to
> + * a subroutine, it needs to respect the simple rule that it doesn't "own" the
> + * statemachine anymore, and it's the responsibility of that calling function to
> + * propagate the -EAGAIN back up the call stack.  Upon reentry, it is committed
> + * to re-calling that subroutine until it returns something other than -EAGAIN.
> + * Once that subroutine signals completion (by returning anything other than
> + * -EAGAIN), the calling function can resume using the statemachine.
> + *
> + *  xfs_attr_set_iter()
> + *              │
> + *              v
> + *   ┌─y─ has an attr fork?
> + *   │          |
> + *   │          n
> + *   │          |
> + *   │          V
> + *   │       add a fork
> + *   │          │
> + *   └──────────┤
> + *              │
> + *              V
> + *   ┌─y─ is shortform?
> + *   │          │
> + *   │          V
> + *   │   xfs_attr_set_fmt
> + *   │          |
> + *   │          V
> + *   │ xfs_attr_try_sf_addname
> + *   │          │
> + *   │          V
> + *   │      had enough ──y──> done
> + *   │        space?
> + *   n          │
> + *   │          n
> + *   │          │
> + *   │          V
> + *   │   transform to leaf
> + *   │          │
> + *   │          V
> + *   │   hold the leaf buffer
> + *   │          │
> + *   │          V
> + *   │     return -EAGAIN
> + *   │      Re-enter in
> + *   │       leaf form
> + *   │
> + *   └─> release leaf buffer
> + *          if needed
> + *              │
> + *              V
> + *   ┌───n── fork has
> + *   │      only 1 blk?
> + *   │          │
> + *   │          y
> + *   │          │
> + *   │          v
> + *   │ xfs_attr_leaf_try_add()
> + *   │          │
> + *   │          v
> + *   │      had enough ──────────────y───────────────┐
> + *   │        space?                                 │
> + *   │          │                                    │
> + *   │          n                                    │
> + *   │          │                                    │
> + *   │          v                                    │
> + *   │    return -EAGAIN                             │
> + *   │      re-enter in                              │
> + *   │        node form                              │
> + *   │          │                                    │
> + *   └──────────┤                                    │
> + *              │                                    │
> + *              V                                    │
> + * xfs_attr_node_addname_find_attr                   │
> + *        determines if this                         │
> + *       is create or rename                         │
> + *     find space to store attr                      │
> + *              │                                    │
> + *              v                                    │
> + *     xfs_attr_node_addname                         │
> + *              │                                    │
> + *              v                                    │
> + *   fits in a node leaf? ────n─────┐                │
> + *              │     ^             v                │
> + *              │     │        single leaf node?     │
> + *              │     │          │            │      │
> + *              y     │          y            n      │
> + *              │     │          │            │      │
> + *              v     │          v            v      │
> + *            update  │     grow the leaf  split if  │
> + *           hashvals └─── return -EAGAIN   needed   │
> + *              │          retry leaf add     │      │
> + *              │            on reentry       │      │
> + *              ├─────────────────────────────┘      │
> + *              │                                    │
> + *              v                                    │
> + *         need to alloc                             │
> + *   ┌─y── or flip flag?                             │
> + *   │          │                                    │
> + *   │          n                                    │
> + *   │          │                                    │
> + *   │          v                                    │
> + *   │         done                                  │
> + *   │                                               │
> + *   │                                               │
> + *   │         XFS_DAS_FOUND_LBLK <──────────────────┘
> + *   │                  │
> + *   │                  V
> + *   │        xfs_attr_leaf_addname()
> + *   │                  │
> + *   │                  v
> + *   │      ┌──first time through?
> + *   │      │          │
> + *   │      │          y
> + *   │      │          │
> + *   │      n          v
> + *   │      │    if we have rmt blks
> + *   │      │    find space for them
> + *   │      │          │
> + *   │      └──────────┤
> + *   │                 │
> + *   │                 v
> + *   │            still have
> + *   │      ┌─n─ blks to alloc? <──┐
> + *   │      │          │           │
> + *   │      │          y           │
> + *   │      │          │           │
> + *   │      │          v           │
> + *   │      │     alloc one blk    │
> + *   │      │     return -EAGAIN ──┘
> + *   │      │    re-enter with one
> + *   │      │    less blk to alloc
> + *   │      │
> + *   │      │
> + *   │      └───> set the rmt
> + *   │               value
> + *   │                 │
> + *   │                 v
> + *   │               was this
> + *   │              a rename? ──n─┐
> + *   │                 │          │
> + *   │                 y          │
> + *   │                 │          │
> + *   │                 v          │
> + *   │           flip incomplete  │
> + *   │               flag         │
> + *   │                 │          │
> + *   │                 v          │
> + *   │         XFS_DAS_FLIP_LFLAG │
> + *   │                 │          │
> + *   │                 v          │
> + *   │               remove       │
> + *   │        ┌───> old name      │
> + *   │        │        │          │
> + *   │ XFS_DAS_RM_LBLK │          │
> + *   │        ^        │          │
> + *   │        │        v          │
> + *   │        └──y── more to      │
> + *   │               remove       │
> + *   │                 │          │
> + *   │                 n          │
> + *   │                 │          │
> + *   │                 v          │
> + *   │                done <──────┘
> + *   │
> + *   └──────> XFS_DAS_FOUND_NBLK
> + *                     │
> + *                     v
> + *       ┌─────n──  need to
> + *       │        alloc blks?
> + *       │             │
> + *       │             y
> + *       │             │
> + *       │             v
> + *       │        find space
> + *       │             │
> + *       │             v
> + *       │  ┌─>XFS_DAS_ALLOC_NODE
> + *       │  │          │
> + *       │  │          v
> + *       │  │      alloc blk
> + *       │  │          │
> + *       │  │          v
> + *       │  └──y── need to alloc
> + *       │         more blocks?
> + *       │             │
> + *       │             n
> + *       │             │
> + *       │             v
> + *       │      set the rmt value
> + *       │             │
> + *       │             v
> + *       │          was this
> + *       └────────> a rename? ──n─┐
> + *                     │          │
> + *                     y          │
> + *                     │          │
> + *                     v          │
> + *               flip incomplete  │
> + *                   flag         │
> + *                     │          │
> + *                     v          │
> + *             XFS_DAS_FLIP_NFLAG │
> + *                     │          │
> + *                     v          │
> + *                   remove       │
> + *        ┌────────> old name     │
> + *        │            │          │
> + *  XFS_DAS_RM_NBLK    │          │
> + *        ^            │          │
> + *        │            v          │
> + *        └──────y── more to      │
> + *                   remove       │
> + *                     │          │
> + *                     n          │
> + *                     │          │
> + *                     v          │
> + *                    done <──────┘
> + *
>   */
>  
>  /*
> @@ -149,12 +376,20 @@ struct xfs_attr_list_context {
>  enum xfs_delattr_state {
>  	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>  	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> +	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
> +	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
> +	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
> +	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> +	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
> +	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
> +	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
>  };
>  
>  /*
>   * Defines for xfs_delattr_context.flags
>   */
>  #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>  
>  /*
>   * Context used for keeping track of delayed attribute operations
> @@ -162,6 +397,11 @@ enum xfs_delattr_state {
>  struct xfs_delattr_context {
>  	struct xfs_da_args      *da_args;
>  
> +	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +
>  	/* Used in xfs_attr_node_removename to roll through removing blocks */
>  	struct xfs_da_state     *da_state;
>  
> @@ -188,7 +428,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> -int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index f09820c..6af86bf 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -441,7 +441,7 @@ xfs_attr_rmtval_get(
>   * Find a "hole" in the attribute address space large enough for us to drop the
>   * new attribute's value into
>   */
> -STATIC int
> +int
>  xfs_attr_rmt_find_hole(
>  	struct xfs_da_args	*args)
>  {
> @@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
>  	return 0;
>  }
>  
> -STATIC int
> +int
>  xfs_attr_rmtval_set_value(
>  	struct xfs_da_args	*args)
>  {
> @@ -628,6 +628,69 @@ xfs_attr_rmtval_set(
>  }
>  
>  /*
> + * Find a hole for the attr and store it in the delayed attr context.  This
> + * initializes the context to roll through allocating an attr extent for a
> + * delayed attr operation
> + */
> +int
> +xfs_attr_rmtval_find_space(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_bmbt_irec		*map = &dac->map;
> +	int				error;
> +
> +	dac->lblkno = 0;
> +	dac->blkcnt = 0;
> +	args->rmtblkcnt = 0;
> +	args->rmtblkno = 0;
> +	memset(map, 0, sizeof(struct xfs_bmbt_irec));
> +
> +	error = xfs_attr_rmt_find_hole(args);
> +	if (error)
> +		return error;
> +
> +	dac->blkcnt = args->rmtblkcnt;
> +	dac->lblkno = args->rmtblkno;
> +
> +	return 0;
> +}
> +
> +/*
> + * Write one block of the value associated with an attribute into the
> + * out-of-line buffer that we have defined for it. This is similar to a subset
> + * of xfs_attr_rmtval_set, but records the current block to the delayed attr
> + * context, and leaves transaction handling to the caller.
> + */
> +int
> +xfs_attr_rmtval_set_blk(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_bmbt_irec		*map = &dac->map;
> +	int nmap;
> +	int error;
> +
> +	nmap = 1;
> +	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
> +				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
> +				map, &nmap);
> +	if (error)
> +		return error;
> +
> +	ASSERT(nmap == 1);
> +	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
> +	       (map->br_startblock != HOLESTARTBLOCK));
> +
> +	/* roll attribute extent map forwards */
> +	dac->lblkno += map->br_blockcount;
> +	dac->blkcnt -= map->br_blockcount;
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove the value associated with an attribute by deleting the
>   * out-of-line buffer that it is stored on.
>   */
> @@ -669,37 +732,6 @@ xfs_attr_rmtval_invalidate(
>  }
>  
>  /*
> - * Remove the value associated with an attribute by deleting the
> - * out-of-line buffer that it is stored on.
> - */
> -int
> -xfs_attr_rmtval_remove(
> -	struct xfs_da_args		*args)
> -{
> -	int				error;
> -	struct xfs_delattr_context	dac  = {
> -		.da_args	= args,
> -	};
> -
> -	trace_xfs_attr_rmtval_remove(args);
> -
> -	/*
> -	 * Keep de-allocating extents until the remote-value region is gone.
> -	 */
> -	do {
> -		error = __xfs_attr_rmtval_remove(&dac);
> -		if (error != -EAGAIN)
> -			break;
> -
> -		error = xfs_attr_trans_roll(&dac);
> -		if (error)
> -			return error;
> -	} while (true);
> -
> -	return error;
> -}
> -
> -/*
>   * Remove the value associated with an attribute by deleting the out-of-line
>   * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>   * transaction and re-call the function
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 002fd30..8ad68d5 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -10,9 +10,12 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
> -int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>  int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 63ecbc6..363e1bf 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1942,7 +1942,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
>  
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
>  
>  #define DEFINE_DA_EVENT(name) \
>  DEFINE_EVENT(xfs_da_class, name, \
> -- 
> 2.7.4
> 
