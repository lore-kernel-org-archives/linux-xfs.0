Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA0AC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2BAB6023D
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhG1Tb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhG1Tb2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9686B6101B;
        Wed, 28 Jul 2021 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627500686;
        bh=H5yc1SWQODO0mmI7VVekNJcDwu7Ebppmq2OlIsGHg/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PfRY4QBpFBB9sGNSHkDbUG2zrRL5YekLMLlOdUcB5Ee2lsPy0Ohabhg0Vn7IN4T2Q
         Y9TBllmeabOLNG4+JtIkkDFweDUdlz4XuoG9qUyNYmr9sAYtmIqSkd1lvBVIWksUjz
         LnmK07fHI9kWzwqXbg0Hlr3dhV4vMdUJq4noujCJXL281ke8ZSd8fU7nhkLpAjJ8IG
         rW1TAnFmzJO7n+thCI/5bH5Jnd7pArtRWjPNHiEAhcreCp7BtUULPymXwhxwCFtmnC
         BlHc93jtGM+3kgS6EClDJGq1N5OBFTgupOOtC0RXjSf/fLoduv8V617SpHGA2MNU/M
         /DBfLOiCuA7Cw==
Date:   Wed, 28 Jul 2021 12:31:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 12/16] xfs: Remove unused xfs_attr_*_args
Message-ID: <20210728193126.GB3601466@magnolia>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727062053.11129-13-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:20:49PM -0700, Allison Henderson wrote:
> Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
> These high level loops are now driven by the delayed operations code,
> and can be removed.
> 
> Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
> since we only have one caller that passes dac->leaf_bp
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

More random ideas for cleanups, sorry...

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 96 +++--------------------------------------
>  fs/xfs/libxfs/xfs_attr.h        | 10 ++---
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>  fs/xfs/xfs_attr_item.c          |  6 +--
>  4 files changed, 10 insertions(+), 103 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c447c21..ec03a7b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -244,67 +244,13 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> -/*
> - * Checks to see if a delayed attribute transaction should be rolled.  If so,
> - * transaction is finished or rolled as needed.
> - */
> -STATIC int
> -xfs_attr_trans_roll(
> -	struct xfs_delattr_context	*dac)
> -{
> -	struct xfs_da_args		*args = dac->da_args;
> -	int				error;
> -
> -	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> -		/*
> -		 * The caller wants us to finish all the deferred ops so that we
> -		 * avoid pinning the log tail with a large number of deferred
> -		 * ops.
> -		 */
> -		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> -		error = xfs_defer_finish(&args->trans);
> -	} else
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -
> -	return error;
> -}
> -
> -/*
> - * Set the attribute specified in @args.
> - */
> -int
> -xfs_attr_set_args(
> -	struct xfs_da_args		*args)
> -{
> -	struct xfs_buf			*leaf_bp = NULL;
> -	int				error = 0;
> -	struct xfs_delattr_context	dac = {
> -		.da_args	= args,
> -	};
> -
> -	do {
> -		error = xfs_attr_set_iter(&dac, &leaf_bp);
> -		if (error != -EAGAIN)
> -			break;
> -
> -		error = xfs_attr_trans_roll(&dac);
> -		if (error) {
> -			if (leaf_bp)
> -				xfs_trans_brelse(args->trans, leaf_bp);
> -			return error;
> -		}
> -	} while (true);
> -
> -	return error;
> -}
> -
>  STATIC int
>  xfs_attr_sf_addname(
> -	struct xfs_delattr_context	*dac,
> -	struct xfs_buf			**leaf_bp)
> +	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_inode		*dp = args->dp;
> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;

Can you remove this local variable from this function completely?

>  	int				error = 0;
>  
>  	/*
> @@ -337,7 +283,6 @@ xfs_attr_sf_addname(
>  	 * add.
>  	 */
>  	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
> -	dac->flags |= XFS_DAC_DEFER_FINISH;
>  	return -EAGAIN;
>  }
>  
> @@ -350,10 +295,10 @@ xfs_attr_sf_addname(
>   */
>  int
>  xfs_attr_set_iter(
> -	struct xfs_delattr_context	*dac,
> -	struct xfs_buf			**leaf_bp)
> +	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args              *args = dac->da_args;
> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;

And here too?  It's easier to figure out what the code is doing if I
don't have to reparse through a double pointer.

>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	int				forkoff, error = 0;
> @@ -370,7 +315,7 @@ xfs_attr_set_iter(
>  		 * release the hold once we return with a clean transaction.
>  		 */
>  		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_sf_addname(dac, leaf_bp);
> +			return xfs_attr_sf_addname(dac);
>  		if (*leaf_bp != NULL) {
>  			xfs_trans_bhold_release(args->trans, *leaf_bp);
>  			*leaf_bp = NULL;

	if (dac->leaf_bp != NULL) {
		xfs_trans_bhold_release(args->trans,  dac->leaf_bp);
		dac->leaf_bp = NULL;
	}

etc.

--D

> @@ -396,7 +341,6 @@ xfs_attr_set_iter(
>  				 * be a node, so we'll fall down into the node
>  				 * handling code below
>  				 */
> -				dac->flags |= XFS_DAC_DEFER_FINISH;
>  				trace_xfs_attr_set_iter_return(
>  					dac->dela_state, args->dp);
>  				return -EAGAIN;
> @@ -685,32 +629,6 @@ xfs_has_attr(
>  }
>  
>  /*
> - * Remove the attribute specified in @args.
> - */
> -int
> -xfs_attr_remove_args(
> -	struct xfs_da_args	*args)
> -{
> -	int				error;
> -	struct xfs_delattr_context	dac = {
> -		.da_args	= args,
> -	};
> -
> -	do {
> -		error = xfs_attr_remove_iter(&dac);
> -		if (error != -EAGAIN)
> -			break;
> -
> -		error = xfs_attr_trans_roll(&dac);
> -		if (error)
> -			return error;
> -
> -	} while (true);
> -
> -	return error;
> -}
> -
> -/*
>   * Note: If args->value is NULL the attribute will be removed, just like the
>   * Linux ->setattr API.
>   */
> @@ -1272,7 +1190,6 @@ xfs_attr_node_addname(
>  			 * this. dela_state is still unset by this function at
>  			 * this point.
>  			 */
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			trace_xfs_attr_node_addname_return(
>  					dac->dela_state, args->dp);
>  			return -EAGAIN;
> @@ -1287,7 +1204,6 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -1538,7 +1454,6 @@ xfs_attr_remove_iter(
>  			if (error)
>  				goto out;
>  			dac->dela_state = XFS_DAS_RM_NAME;
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			return -EAGAIN;
>  		}
>  
> @@ -1565,7 +1480,6 @@ xfs_attr_remove_iter(
>  			if (error)
>  				goto out;
>  
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_RM_SHRINK;
>  			trace_xfs_attr_remove_iter_return(
>  					dac->dela_state, args->dp);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 72b0ea5..c0c92bd3 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -457,9 +457,8 @@ enum xfs_delattr_state {
>  /*
>   * Defines for xfs_delattr_context.flags
>   */
> -#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> -#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
> -#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
> +#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
>  
>  /*
>   * Context used for keeping track of delayed attribute operations
> @@ -517,11 +516,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
> -int xfs_attr_set_args(struct xfs_da_args *args);
> -int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> -		      struct xfs_buf **leaf_bp);
> +int xfs_attr_set_iter(struct xfs_delattr_context *dac);
>  int xfs_has_attr(struct xfs_da_args *args);
> -int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 1669043..e29c2b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
>  	 * the parent
>  	 */
>  	if (!done) {
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  	}
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 44c44d9..12a0151 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -285,7 +285,6 @@ STATIC int
>  xfs_trans_attr_finish_update(
>  	struct xfs_delattr_context	*dac,
>  	struct xfs_attrd_log_item	*attrdp,
> -	struct xfs_buf			**leaf_bp,
>  	uint32_t			op_flags)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
> @@ -300,7 +299,7 @@ xfs_trans_attr_finish_update(
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> -		error = xfs_attr_set_iter(dac, leaf_bp);
> +		error = xfs_attr_set_iter(dac);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
>  		ASSERT(XFS_IFORK_Q(args->dp));
> @@ -424,7 +423,7 @@ xfs_attr_finish_item(
>  	 */
>  	dac->da_args->trans = tp;
>  
> -	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
> +	error = xfs_trans_attr_finish_update(dac, done_item,
>  					     attr->xattri_op_flags);
>  	if (error != -EAGAIN)
>  		kmem_free(attr);
> @@ -640,7 +639,6 @@ xfs_attri_item_recover(
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
> -					   &attr->xattri_dac.leaf_bp,
>  					   attrp->alfi_op_flags);
>  	if (ret == -EAGAIN) {
>  		/* There's more work to do, so add it to this transaction */
> -- 
> 2.7.4
> 
