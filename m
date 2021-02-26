Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E78C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D4B64ECE
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZE7h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhBZE7g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 23:59:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F1A64DE8;
        Fri, 26 Feb 2021 04:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614315534;
        bh=n8sJzINzXdhTxy8n3QsDTEF99xZM2Ek8smvQ/5gh+Gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tjzHjAkREEMFoMOb0TiK8zW9b0NMi7wIiqPMvv43T3OCBIWOL1PWVfcIlV9IPyI0C
         neWTl8QUHZHdE7TZPD5jvYr9h7xO+oHqivs5udM+EKFEYGn+VupfeRpIdMHJEvJqWq
         AHlyi7yucrT2sdy4BgDabNtUV31WxjS9hLX6PobTIkJsaVfltMjOhJbZL/PBNsEG2N
         iBn+Tzg+pzlkqt4qBVN1r80S5jAuerF3wpsE6FF/x+/eS+oN/amlCxczh4kxrn/KYq
         7ugl3/EM1j6vXG2Tf6qx3bK8/YNz7nA5cBNG37ixpPMiGF8cxCVUkbD0z3dRYOS5q0
         L+ZjieitXwPzw==
Date:   Thu, 25 Feb 2021 20:58:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 19/22] xfs: Remove unused xfs_attr_*_args
Message-ID: <20210226045855.GX7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-20-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:45AM -0700, Allison Henderson wrote:
> Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
> These high level loops are now driven by the delayed operations code,
> and can be removed.
> 
> Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
> since we only have one caller that passes dac->leaf_bp
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 97 +++--------------------------------------
>  fs/xfs/libxfs/xfs_attr.h        | 10 ++---
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>  fs/xfs/xfs_attr_item.c          |  8 ++--
>  4 files changed, 11 insertions(+), 105 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cec861e..8b62447 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -63,8 +63,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> -int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> -		      struct xfs_buf **leaf_bp);
>  
>  int
>  xfs_inode_hasattr(
> @@ -223,67 +221,13 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> -/*
> - * Checks to see if a delayed attribute transaction should be rolled.  If so,
> - * also checks for a defer finish.  Transaction is finished and rolled as
> - * needed, and returns true of false if the delayed operation should continue.
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
> -		if (error)
> -			return error;
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
> -		if (error)
> -			return error;
> -	} while (true);
> -
> -	return error;
> -}
> -
>  STATIC int
>  xfs_attr_set_fmt(
> -	struct xfs_delattr_context	*dac,
> -	struct xfs_buf			**leaf_bp)
> +	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_inode		*dp = args->dp;
> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>  	int				error = 0;
>  
>  	/*
> @@ -316,7 +260,6 @@ xfs_attr_set_fmt(
>  	 * add.
>  	 */
>  	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
> -	dac->flags |= XFS_DAC_DEFER_FINISH;
>  	return -EAGAIN;
>  }
>  
> @@ -329,10 +272,10 @@ xfs_attr_set_fmt(
>   */
>  int
>  xfs_attr_set_iter(
> -	struct xfs_delattr_context	*dac,
> -	struct xfs_buf			**leaf_bp)
> +	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args              *args = dac->da_args;
> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	struct xfs_da_state		*state = NULL;
> @@ -344,7 +287,7 @@ xfs_attr_set_iter(
>  	switch (dac->dela_state) {
>  	case XFS_DAS_UNINIT:
>  		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_set_fmt(dac, leaf_bp);
> +			return xfs_attr_set_fmt(dac);
>  
>  		/*
>  		 * After a shortform to leaf conversion, we need to hold the
> @@ -381,7 +324,6 @@ xfs_attr_set_iter(
>  				 * be a node, so we'll fall down into the node
>  				 * handling code below
>  				 */
> -				dac->flags |= XFS_DAC_DEFER_FINISH;
>  				trace_xfs_attr_set_iter_return(
>  					dac->dela_state, args->dp);
>  				return -EAGAIN;
> @@ -687,32 +629,6 @@ xfs_has_attr(
>  
>  /*
>   * Remove the attribute specified in @args.
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
> - * Remove the attribute specified in @args.
>   *
>   * This function may return -EAGAIN to signal that the transaction needs to be
>   * rolled.  Callers should continue calling this function until they receive a
> @@ -1297,7 +1213,6 @@ xfs_attr_node_addname(
>  			 * this. dela_state is still unset by this function at
>  			 * this point.
>  			 */
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			trace_xfs_attr_node_addname_return(
>  					dac->dela_state, args->dp);
>  			return -EAGAIN;
> @@ -1312,7 +1227,6 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -1599,7 +1513,6 @@ xfs_attr_node_removename_iter(
>  			if (error)
>  				goto out;
>  
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_RM_SHRINK;
>  			trace_xfs_attr_node_removename_iter_return(
>  					dac->dela_state, args->dp);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 4abf02c..f82c0b1 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -393,9 +393,8 @@ enum xfs_delattr_state {
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
> @@ -452,11 +451,8 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
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
> index b6554a3..78bb552 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -762,7 +762,6 @@ xfs_attr_rmtval_remove(
>  	 * by the parent
>  	 */
>  	if (!done) {
> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>  		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  	}
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 8c8f72d..13b289b 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -291,7 +291,6 @@ int
>  xfs_trans_attr(
>  	struct xfs_delattr_context	*dac,
>  	struct xfs_attrd_log_item	*attrdp,
> -	struct xfs_buf			**leaf_bp,
>  	uint32_t			op_flags)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
> @@ -304,7 +303,7 @@ xfs_trans_attr(
>  	switch (op_flags) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> -		error = xfs_attr_set_iter(dac, leaf_bp);
> +		error = xfs_attr_set_iter(dac);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
>  		ASSERT(XFS_IFORK_Q(args->dp));
> @@ -428,8 +427,7 @@ xfs_attr_finish_item(
>  	 */
>  	dac->da_args->trans = tp;
>  
> -	error = xfs_trans_attr(dac, done_item, &dac->leaf_bp,
> -			       attr->xattri_op_flags);
> +	error = xfs_trans_attr(dac, done_item, attr->xattri_op_flags);
>  	if (error != -EAGAIN)
>  		kmem_free(attr);
>  
> @@ -625,7 +623,7 @@ xfs_attri_item_recover(
>  	xfs_trans_ijoin(args.trans, ip, 0);
>  
>  	error = xfs_trans_attr(&attr.xattri_dac, done_item,
> -			       &attr.xattri_dac.leaf_bp, attrp->alfi_op_flags);
> +			       attrp->alfi_op_flags);
>  	if (error == -EAGAIN) {
>  		/*
>  		 * There's more work to do, so make a new xfs_attr_item and add
> -- 
> 2.7.4
> 
