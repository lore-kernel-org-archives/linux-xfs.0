Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF25C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiEJXFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbiEJXE5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:04:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4B027D002
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BABD2B81FA8
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776BAC385D1;
        Tue, 10 May 2022 23:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652223892;
        bh=oCQo+mZWxSmvR9vNfb+mJbWVTKspBzLS2KBe6RvJzOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXv3ktOTfzE9H3DantVDEXEM7kKv8mJtQytbsk/5VlynCi4r8gYSEbuOqmqI6s5jq
         mIRk6wW0DUeo6VN01tDJ2kUUbukyYkBNQqV2rqTs2WwV22d8pfQgjMVMaZcbQ5Af6n
         aH4+FDTB/Qmf3NFxb5KzdgTR0/uVSw6c2BEeC16bB8bhKeaR09Hjs2DEYhIm/3JFaQ
         DbWLkVeMbf5PRLcNr5NUm1E6oJTvN1TK1tyPeKohfQllVT6p1PuEp2kw8BlQ20NVRK
         jJ5s2+UQGTj4CBFALz2PzIqqPg0RXYYTpTivpGn6kG/5R6dJpmseMC7qO44pwPqsYd
         nxjLRqK8GDQWw==
Date:   Tue, 10 May 2022 16:04:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: rework deferred attribute operation setup
Message-ID: <20220510230451.GH27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:24AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Logged attribute intents only have set and remove types - there is
> no type of the replace operation. We should ahve a separate type for

"..no separate intent type for a replace operation."?

Also, "ahve" -> "have".

> a replace operation, as it needs to perform operations that neither
> SET or REMOVE can perform.
> 
> Add this type to the intent items and rearrange the deferred
> operation setup to reflect the different operations we are
> performing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 165 +++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h       |   2 -
>  fs/xfs/libxfs/xfs_log_format.h |   1 +
>  fs/xfs/xfs_attr_item.c         |   9 +-
>  fs/xfs/xfs_trace.h             |   4 +
>  5 files changed, 110 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a4b0b20a3bab..817e15740f9c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -671,6 +671,81 @@ xfs_attr_lookup(
>  	return xfs_attr_node_hasname(args, NULL);
>  }
>  
> +static int
> +xfs_attr_item_init(
> +	struct xfs_da_args	*args,
> +	unsigned int		op_flags,	/* op flag (set or remove) */
> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
> +{
> +
> +	struct xfs_attr_item	*new;
> +
> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);

Can this fail?

> +	new->xattri_op_flags = op_flags;
> +	new->xattri_da_args = args;
> +
> +	*attr = new;
> +	return 0;

And if it can't, then there's no need for a return value, AFAICT.  I
looked at the end of xfs-5.19-compose and there's no other return
statements in this function.

And then you don't need any of the error handling in this patch at all,
right?

*OH*, this is just a hoist of the stuff at the end.  Could someone add a
patch on the end of ... whatever patchset there is to clean that up?

In the meantime, with the commit message typos cleaned up,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_add(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	if (error)
> +		return error;
> +
> +	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
> +
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_replace(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE, &new);
> +	if (error)
> +		return error;
> +
> +	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
> +
> +	return 0;
> +}
> +
> +/* Removes an attribute for an inode as a deferred operation */
> +static int
> +xfs_attr_defer_remove(
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	int			error;
> +
> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
> +	if (error)
> +		return error;
> +
> +	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
> +
> +	return 0;
> +}
> +
>  /*
>   * Note: If args->value is NULL the attribute will be removed, just like the
>   * Linux ->setattr API.
> @@ -759,29 +834,35 @@ xfs_attr_set(
>  	}
>  
>  	error = xfs_attr_lookup(args);
> -	if (args->value) {
> -		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
> -			goto out_trans_cancel;
> -		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> -			goto out_trans_cancel;
> -		if (error != -ENOATTR && error != -EEXIST)
> +	switch (error) {
> +	case -EEXIST:
> +		/* if no value, we are performing a remove operation */
> +		if (!args->value) {
> +			error = xfs_attr_defer_remove(args);
> +			break;
> +		}
> +		/* Pure create fails if the attr already exists */
> +		if (args->attr_flags & XATTR_CREATE)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_set_deferred(args);
> -		if (error)
> +		error = xfs_attr_defer_replace(args);
> +		break;
> +	case -ENOATTR:
> +		/* Can't remove what isn't there. */
> +		if (!args->value)
>  			goto out_trans_cancel;
>  
> -		/* shortform attribute has already been committed */
> -		if (!args->trans)
> -			goto out_unlock;
> -	} else {
> -		if (error != -EEXIST)
> +		/* Pure replace fails if no existing attr to replace. */
> +		if (args->attr_flags & XATTR_REPLACE)
>  			goto out_trans_cancel;
>  
> -		error = xfs_attr_remove_deferred(args);
> -		if (error)
> -			goto out_trans_cancel;
> +		error = xfs_attr_defer_add(args);
> +		break;
> +	default:
> +		goto out_trans_cancel;
>  	}
> +	if (error)
> +		goto out_trans_cancel;
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> @@ -845,58 +926,6 @@ xfs_attrd_destroy_cache(void)
>  	xfs_attrd_cache = NULL;
>  }
>  
> -STATIC int
> -xfs_attr_item_init(
> -	struct xfs_da_args	*args,
> -	unsigned int		op_flags,	/* op flag (set or remove) */
> -	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
> -{
> -
> -	struct xfs_attr_item	*new;
> -
> -	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> -	new->xattri_op_flags = op_flags;
> -	new->xattri_da_args = args;
> -
> -	*attr = new;
> -	return 0;
> -}
> -
> -/* Sets an attribute for an inode as a deferred operation */
> -int
> -xfs_attr_set_deferred(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_attr_item	*new;
> -	int			error = 0;
> -
> -	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> -	if (error)
> -		return error;
> -
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> -
> -	return 0;
> -}
> -
> -/* Removes an attribute for an inode as a deferred operation */
> -int
> -xfs_attr_remove_deferred(
> -	struct xfs_da_args	*args)
> -{
> -
> -	struct xfs_attr_item	*new;
> -	int			error;
> -
> -	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
> -	if (error)
> -		return error;
> -
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> -
> -	return 0;
> -}
> -
>  /*========================================================================
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index f6c13d2bfbcd..c9c867e3406c 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -521,8 +521,6 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
>  			 unsigned int *total);
> -int xfs_attr_set_deferred(struct xfs_da_args *args);
> -int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  extern struct kmem_cache	*xfs_attri_cache;
>  extern struct kmem_cache	*xfs_attrd_cache;
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index a27492e99673..f7edd1ecf6d9 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -908,6 +908,7 @@ struct xfs_icreate_log {
>   */
>  #define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
>  #define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> +#define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
>  #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
>  /*
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5f8680b05079..fe1e37696634 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -311,6 +311,7 @@ xfs_xattri_finish_update(
>  
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
>  		error = xfs_attr_set_iter(attr);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
> @@ -500,8 +501,14 @@ xfs_attri_validate(
>  		return false;
>  
>  	/* alfi_op_flags should be either a set or remove */
> -	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
> +	switch (op) {
> +	case XFS_ATTR_OP_FLAGS_SET:
> +	case XFS_ATTR_OP_FLAGS_REPLACE:
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		break;
> +	default:
>  		return false;
> +	}
>  
>  	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
>  		return false;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index fec4198b738b..01ce0401aa32 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4154,6 +4154,10 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_defer_remove);
> +
>  
>  TRACE_EVENT(xfs_force_shutdown,
>  	TP_PROTO(struct xfs_mount *mp, int ptag, int flags, const char *fname,
> -- 
> 2.35.1
> 
