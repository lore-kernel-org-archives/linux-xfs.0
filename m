Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89E1C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD46D61040
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhG1Tw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhG1Tw2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0355660E9B;
        Wed, 28 Jul 2021 19:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627501947;
        bh=14nTrobk4NQYUM3gFdeiqW8kbjigzsb46SQf1AOAApQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gHsIhU+6aKuoRYvrRvT2b6kMBpLtf/+0TkQiSdrwP87wOouIgw9F+vD48Vm/ioQhl
         RfisTYlyNHQAUxl2VTzG/sPHzubl1tLBH4yqE6wnCY/obORRlYoNLbxi+yDEYhycsc
         fIUX1L5d2UY8OEwpdkETRDMX9qjqFdzlwCzYFKAjWhf9YNpkaACFrJJqurizJpGlYs
         GkO/cj4MNzEaHTu4sEUQvrpuJA7Vqm6zTzH0uCFg3uNgniQyyqLNPOmXAFx9RLGSSX
         L92BwY9ygSd+o2tVl8r9BsJRbHGyA+c9/966gpjybT6QVlJg8O7IdRSKH7fG6AL40r
         0ksFyZfKBrIqw==
Date:   Wed, 28 Jul 2021 12:52:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 16/16] xfs: Add helper function xfs_attr_leaf_addname
Message-ID: <20210728195226.GG3601443@magnolia>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727062053.11129-17-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:20:53PM -0700, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_leaf_addname.  While this
> does help to break down xfs_attr_set_iter, it does also hoist out some
> of the state management.  This patch has been moved to the end of the
> clean up series for further discussion.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 108 ++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_trace.h       |   1 +
>  2 files changed, 61 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 811288d..acb995b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -285,6 +285,65 @@ xfs_attr_sf_addname(
>  	return -EAGAIN;
>  }
>  
> +STATIC int
> +xfs_attr_leaf_addname(
> +	struct xfs_attr_item	*attr)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error;
> +
> +	if (xfs_attr_is_leaf(dp)) {
> +		error = xfs_attr_leaf_try_add(args, leaf_bp);
> +		if (error == -ENOSPC) {
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				return error;
> +
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
> +			trace_xfs_attr_set_iter_return(
> +				attr->xattri_dela_state, args->dp);
> +			return -EAGAIN;
> +		}
> +
> +		if (error)
> +			return error;
> +
> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;

Hmm.  I know I reviewed this once before, but on second thought it's a
little strange to be calling the node addname function from the leaf
addname function.  Can you reduce the leaf addname function's scope like
this:

STATIC int
xfs_attr_leaf_addname(
	struct xfs_attr_item	*attr)

	struct xfs_da_args	*args = attr->xattri_da_args;
	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
	struct xfs_inode	*dp = args->dp;
	int			error;

	error = xfs_attr_leaf_try_add(args, leaf_bp);
	if (error == 0) {
		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
		trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
				args->dp);
		return -EAGAIN;
	}
	if (error != -ENOSPC)
		return error;

	/* No room in leaf; convert to node format and try again. */
	error = xfs_attr3_leaf_to_node(args);
	if (error)
		return error;

	/*
	 * Finish any deferred work items and roll the transaction once
	 * more.  The goal here is to call node_addname with the inode
	 * and transaction in the same state (inode locked and joined,
	 * transaction clean) no matter how we got to this step.
	 *
	 * At this point, we are still in XFS_DAS_UNINIT, but when we
	 * come back, we'll be a node, so we'll fall down into the node
	 * handling code below
	 */
	trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
			args->dp);
	return -EAGAIN;
}

Then the callsite up in xfs_attr_set_iter looks like:

	case XFS_DAS_UNINIT:
		if (xfs_attr_is_shortform(dp))
			return xfs_attr_sf_addname(dac, leaf_bp);
		if (*leaf_bp != NULL) {
			xfs_trans_bhold_release(args->trans, *leaf_bp);
			*leaf_bp = NULL;
		}

		if (xfs_attr_is_leaf(dp))
			return xfs_attr_leaf_addname(...);

		/* node format */
		error = xfs_attr_node_addname_find_attr(attr);
		if (error)
			return error;

		error = xfs_attr_node_addname(attr);
		if (error)
			return error;

		dac->dela_state = XFS_DAS_FOUND_NBLK;
		return -EAGAIN;

	case XFS_DAS_FOUND_LBLK:

--D

> +	} else {
> +		error = xfs_attr_node_addname_find_attr(attr);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_node_addname(attr);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * If addname was successful, and we dont need to alloc or
> +		 * remove anymore blks, we're done.
> +		 */
> +		if (!args->rmtblkno && !args->rmtblkno2)
> +			return 0;
> +
> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	}
> +
> +	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may return
> @@ -320,55 +379,8 @@ xfs_attr_set_iter(
>  			*leaf_bp = NULL;
>  		}
>  
> -		if (xfs_attr_is_leaf(dp)) {
> -			error = xfs_attr_leaf_try_add(args, *leaf_bp);
> -			if (error == -ENOSPC) {
> -				error = xfs_attr3_leaf_to_node(args);
> -				if (error)
> -					return error;
> -
> -				/*
> -				 * Finish any deferred work items and roll the
> -				 * transaction once more.  The goal here is to
> -				 * call node_addname with the inode and
> -				 * transaction in the same state (inode locked
> -				 * and joined, transaction clean) no matter how
> -				 * we got to this step.
> -				 *
> -				 * At this point, we are still in
> -				 * XFS_DAS_UNINIT, but when we come back, we'll
> -				 * be a node, so we'll fall down into the node
> -				 * handling code below
> -				 */
> -				trace_xfs_attr_set_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -				return -EAGAIN;
> -			} else if (error) {
> -				return error;
> -			}
> -
> -			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> -		} else {
> -			error = xfs_attr_node_addname_find_attr(attr);
> -			if (error)
> -				return error;
> +		return xfs_attr_leaf_addname(attr);
>  
> -			error = xfs_attr_node_addname(attr);
> -			if (error)
> -				return error;
> -
> -			/*
> -			 * If addname was successful, and we dont need to alloc
> -			 * or remove anymore blks, we're done.
> -			 */
> -			if (!args->rmtblkno && !args->rmtblkno2)
> -				return 0;
> -
> -			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> -		}
> -		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -					       args->dp);
> -		return -EAGAIN;
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9840dd..cf8bd3a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4008,6 +4008,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
>  	TP_ARGS(das, ip))
>  DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
> -- 
> 2.7.4
> 
