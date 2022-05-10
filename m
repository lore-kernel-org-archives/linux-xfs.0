Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9382BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiEJXaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiEJXaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5372613D15A
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3331618F7
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2DAC385CE;
        Tue, 10 May 2022 23:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652225420;
        bh=N+nY8ORFDrQA4S0VoH5Rw/W3ElGCC7tx/ObuOg7b+Rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PJWFf599+hwe185KorrCrf5xGBSn8LyqVK+USc2KUABIzV5iqSNSPL4zQjjTODCKW
         xlvqtpxJIBfFk64gZ7SduwHd2qtVg1UdKLII/JTPz87/6jsZD6m8GAwrOXN3LbI3Uq
         rH91hY3aLhLz59ukklukyC/FOMqQkF0xJOGc45ZokcvRuNje43VWDGvhgwWoFRoUQK
         7srATj+TGw/O0IbRTp5AjUL1bHwcQxhpnoHDkCe+hBp2Jf4qHMq23RkSxUpnHFyP+q
         XFkiVsZlTdr6B8G6zbtqlsoDkCReaZSTRApzndqOiujU2bXWs5/+IyKGqhtIVPfLJw
         rpDnA/QYcm4bA==
Date:   Tue, 10 May 2022 16:30:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] xfs: xfs_attr_set_iter() does not need to return
 EAGAIN
Message-ID: <20220510233019.GP27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-13-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:32AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the full xfs_attr_set_iter() state machine always
> terminates with either the state being XFS_DAS_DONE on success or
> an error on failure, we can get rid of the need for it to return
> -EAGAIN whenever it needs to roll the transaction before running
> the next state.
> 
> That is, we don't need to spray -EAGAIN return states everywhere,
> the caller just check the state machine state for completion to
> determine what action should be taken next. This greatly simplifies
> the code within the state machine implementation as it now only has
> to handle 0 for success or -errno for error and it doesn't need to
> tell the caller to retry.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 86 +++++++++++++++++-----------------------
>  fs/xfs/xfs_attr_item.c   |  2 +
>  2 files changed, 38 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5707ac4f44a7..89e68d9e22c0 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -290,7 +290,6 @@ xfs_attr_sf_addname(
>  	 */
>  	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
>  	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
> -	error = -EAGAIN;
>  out:
>  	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args->dp);
>  	return error;
> @@ -343,7 +342,6 @@ xfs_attr_leaf_addname(
>  		 * retry the add to the newly allocated node block.
>  		 */
>  		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
> -		error = -EAGAIN;
>  		goto out;
>  	}
>  	if (error)
> @@ -354,20 +352,24 @@ xfs_attr_leaf_addname(
>  	 * or perform more xattr manipulations. Otherwise there is nothing more
>  	 * to do and we can return success.
>  	 */
> -	if (args->rmtblkno) {
> +	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> -		error = -EAGAIN;
> -	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +	else if (args->op_flags & XFS_DA_OP_RENAME)
>  		xfs_attr_dela_state_set_replace(attr, XFS_DAS_LEAF_REPLACE);
> -		error = -EAGAIN;
> -	} else {
> +	else
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> -	}
>  out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
>  	return error;
>  }
>  
> +/*
> + * Add an entry to a node format attr tree.
> + *
> + * Note that we might still have a leaf here - xfs_attr_is_leaf() cannot tell
> + * the difference between leaf + remote attr blocks and a node format tree,
> + * so we may still end up having to convert from leaf to node format here.
> + */
>  static int
>  xfs_attr_node_addname(
>  	struct xfs_attr_item	*attr)
> @@ -382,19 +384,26 @@ xfs_attr_node_addname(
>  		return error;
>  
>  	error = xfs_attr_node_try_addname(attr);
> +	if (error == -ENOSPC) {
> +		error = xfs_attr3_leaf_to_node(args);
> +		if (error)
> +			return error;
> +		/*
> +		 * No state change, we really are in node form now
> +		 * but we need the transaction rolled to continue.
> +		 */
> +		goto out;
> +	}
>  	if (error)
>  		return error;
>  
> -	if (args->rmtblkno) {
> +	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> -		error = -EAGAIN;
> -	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +	else if (args->op_flags & XFS_DA_OP_RENAME)
>  		xfs_attr_dela_state_set_replace(attr, XFS_DAS_NODE_REPLACE);
> -		error = -EAGAIN;
> -	} else {
> +	else
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> -	}
> -
> +out:
>  	trace_xfs_attr_node_addname_return(attr->xattri_dela_state, args->dp);
>  	return error;
>  }
> @@ -417,10 +426,8 @@ xfs_attr_rmtval_alloc(
>  		if (error)
>  			return error;
>  		/* Roll the transaction only if there is more to allocate. */
> -		if (attr->xattri_blkcnt > 0) {
> -			error = -EAGAIN;
> +		if (attr->xattri_blkcnt > 0)
>  			goto out;
> -		}
>  	}
>  
>  	error = xfs_attr_rmtval_set_value(args);
> @@ -516,11 +523,12 @@ xfs_attr_leaf_shrink(
>  }
>  
>  /*
> - * Set the attribute specified in @args.
> - * This routine is meant to function as a delayed operation, and may return
> - * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> - * to handle this, and recall the function until a successful error code is
> - * returned.
> + * Run the attribute operation specified in @attr.
> + *
> + * This routine is meant to function as a delayed operation and will set the
> + * state to XFS_DAS_DONE when the operation is complete.  Calling functions will
> + * need to handle this, and recall the function until either an error or
> + * XFS_DAS_DONE is detected.
>   */
>  int
>  xfs_attr_set_iter(
> @@ -573,7 +581,6 @@ xfs_attr_set_iter(
>  		 * We must commit the flag value change now to make it atomic
>  		 * and then we can start the next trans in series at REMOVE_OLD.
>  		 */
> -		error = -EAGAIN;
>  		attr->xattri_dela_state++;
>  		break;
>  
> @@ -601,8 +608,10 @@ xfs_attr_set_iter(
>  	case XFS_DAS_LEAF_REMOVE_RMT:
>  	case XFS_DAS_NODE_REMOVE_RMT:
>  		error = xfs_attr_rmtval_remove(attr);
> -		if (error == -EAGAIN)
> +		if (error == -EAGAIN) {
> +			error = 0;
>  			break;
> +		}
>  		if (error)
>  			return error;
>  
> @@ -614,7 +623,6 @@ xfs_attr_set_iter(
>  		 * can't do that in the same transaction where we removed the
>  		 * remote attr blocks.
>  		 */
> -		error = -EAGAIN;
>  		attr->xattri_dela_state++;
>  		break;
>  
> @@ -1250,14 +1258,6 @@ xfs_attr_node_addname_find_attr(
>   * This will involve walking down the Btree, and may involve splitting
>   * leaf nodes and even splitting intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> - *
> - * "Remote" attribute values confuse the issue and atomic rename operations
> - * add a whole extra layer of confusion on top of that.
> - *
> - * This routine is meant to function as a delayed operation, and may return
> - * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> - * to handle this, and recall the function until a successful error code is
> - *returned.
>   */
>  static int
>  xfs_attr_node_try_addname(
> @@ -1279,24 +1279,10 @@ xfs_attr_node_try_addname(
>  			/*
>  			 * Its really a single leaf node, but it had
>  			 * out-of-line values so it looked like it *might*
> -			 * have been a b-tree.
> +			 * have been a b-tree. Let the caller deal with this.
>  			 */
>  			xfs_da_state_free(state);
> -			state = NULL;
> -			error = xfs_attr3_leaf_to_node(args);
> -			if (error)
> -				goto out;
> -
> -			/*
> -			 * Now that we have converted the leaf to a node, we can
> -			 * roll the transaction, and try xfs_attr3_leaf_add
> -			 * again on re-entry.  No need to set dela_state to do
> -			 * this. dela_state is still unset by this function at
> -			 * this point.
> -			 */
> -			trace_xfs_attr_node_addname_return(
> -					attr->xattri_dela_state, args->dp);
> -			return -EAGAIN;
> +			return -ENOSPC;
>  		}
>  
>  		/*
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5bfb33746e37..740a55d07660 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -313,6 +313,8 @@ xfs_xattri_finish_update(
>  	case XFS_ATTR_OP_FLAGS_SET:
>  	case XFS_ATTR_OP_FLAGS_REPLACE:
>  		error = xfs_attr_set_iter(attr);
> +		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> +			error = -EAGAIN;
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
>  		ASSERT(XFS_IFORK_Q(args->dp));
> -- 
> 2.35.1
> 
