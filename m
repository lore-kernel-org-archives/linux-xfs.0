Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F29FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiEJXkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbiEJXkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:40:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCB74A3F1
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:40:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6634561948
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6835C385D2;
        Tue, 10 May 2022 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652226006;
        bh=iiRAjM3ye0wY5CDiscwFVV/n5eWQxYc6H3Tb1wWiaTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MznhGPTURPBh3xY7KUG5E9tUMPq78Pd+S7zlBQXPRM7r38GlPm2dWfb2gb/CgbX9Q
         NviXl4P5cPpNdUIbIbo5iKelAHOTkiHaAW4VOO/7LJ7C/hLMf3Ovv9gmV34k/YvdWi
         8bdSgPfwxZf/eJwXfWGcNM0Y4hzc/Cf99tchSWEclAQOPVGuDvQNXUg1bnf9tt+cqF
         OjJcuPmf1HisMkwTOzZmV8K84cAWNityRyTLoYdhJ3HuOk26fSoNyZm/guYIdP60I3
         1dMEKd5/awmCxeM6rm/fVYsEmufz3eGByIQUOhxoZYovl54RQ1LM/KpoCm98Hl2HJL
         Gi6OuN8/69DCw==
Date:   Tue, 10 May 2022 16:40:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/18] xfs: switch attr remove to xfs_attri_set_iter
Message-ID: <20220510234006.GR27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-15-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:34AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that xfs_attri_set_iter() has initial states for removing
> attributes, switch the pure attribute removal code over to using it.
> This requires attrs being removed to always be marked as INCOMPLETE
> before we start the removal due to the fact we look up the attr to
> remove again in xfs_attr_node_remove_attr().
> 
> Note: this drops the fillstate/refillstate optimisations from
> the remove path that avoid having to look up the path again after
> setting the incomplete flag and removeing remote attrs. Restoring

'removing'

> that optimisation to this path is future Dave's problem.

LOL.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Stupid nit: Probably ought to  ^^^ be a space between the 'son' and the
bracket.

With that stuff cleaned up,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> ---
>  fs/xfs/libxfs/xfs_attr.c | 21 +++++++++------------
>  fs/xfs/libxfs/xfs_attr.h | 10 ++++++++++
>  fs/xfs/xfs_attr_item.c   | 31 +++++++------------------------
>  3 files changed, 26 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a6a9b1f8dce6..b935727cf517 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -499,13 +499,11 @@ int xfs_attr_node_removename_setup(
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>  		XFS_ATTR_LEAF_MAGIC);
>  
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, *state);
> -		if (error)
> -			goto out;
> -
> +	error = xfs_attr_leaf_mark_incomplete(args, *state);
> +	if (error)
> +		goto out;
> +	if (args->rmtblkno > 0)
>  		error = xfs_attr_rmtval_invalidate(args);
> -	}
>  out:
>  	if (error)
>  		xfs_da_state_free(*state);
> @@ -821,7 +819,7 @@ xfs_attr_defer_remove(
>  	if (error)
>  		return error;
>  
> -	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	new->xattri_dela_state = xfs_attr_init_remove_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>  	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
>  
> @@ -1391,16 +1389,15 @@ xfs_attr_node_remove_attr(
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = NULL;
> -	struct xfs_mount		*mp = args->dp->i_mount;
>  	int				retval = 0;
>  	int				error = 0;
>  
>  	/*
> -	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> -	 * flag means that we will find the "old" attr, not the "new" one.
> +	 * The attr we are removing has already been marked incomplete, so
> +	 * we need to set the filter appropriately to re-find the "old"
> +	 * attribute entry after any split ops.
>  	 */
> -	if (!xfs_has_larp(mp))
> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 7ea7c7fa31ac..6bef522533a4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -593,6 +593,16 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
>  	return XFS_DAS_NODE_ADD;
>  }
>  
> +static inline enum xfs_delattr_state
> +xfs_attr_init_remove_state(struct xfs_da_args *args)
> +{
> +	if (xfs_attr_is_shortform(args->dp))
> +		return XFS_DAS_SF_REMOVE;
> +	if (xfs_attr_is_leaf(args->dp))
> +		return XFS_DAS_LEAF_REMOVE;
> +	return XFS_DAS_NODE_REMOVE;
> +}
> +
>  static inline enum xfs_delattr_state
>  xfs_attr_init_replace_state(struct xfs_da_args *args)
>  {
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 740a55d07660..fb9549e7ea96 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -296,12 +296,9 @@ xfs_attrd_item_release(
>  STATIC int
>  xfs_xattri_finish_update(
>  	struct xfs_attr_item		*attr,
> -	struct xfs_attrd_log_item	*attrdp,
> -	uint32_t			op_flags)
> +	struct xfs_attrd_log_item	*attrdp)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> -	unsigned int			op = op_flags &
> -					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>  	int				error;
>  
>  	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
> @@ -309,22 +306,9 @@ xfs_xattri_finish_update(
>  		goto out;
>  	}
>  
> -	switch (op) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -	case XFS_ATTR_OP_FLAGS_REPLACE:
> -		error = xfs_attr_set_iter(attr);
> -		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> -			error = -EAGAIN;
> -		break;
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> -		ASSERT(XFS_IFORK_Q(args->dp));
> -		error = xfs_attr_remove_iter(attr);
> -		break;
> -	default:
> -		error = -EFSCORRUPTED;
> -		break;
> -	}
> -
> +	error = xfs_attr_set_iter(attr);
> +	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> +		error = -EAGAIN;
>  out:
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
> @@ -432,8 +416,7 @@ xfs_attr_finish_item(
>  	 */
>  	attr->xattri_da_args->trans = tp;
>  
> -	error = xfs_xattri_finish_update(attr, done_item,
> -					 attr->xattri_op_flags);
> +	error = xfs_xattri_finish_update(attr, done_item);
>  	if (error != -EAGAIN)
>  		kmem_free(attr);
>  
> @@ -581,7 +564,7 @@ xfs_attri_item_recover(
>  		attr->xattri_dela_state = xfs_attr_init_add_state(args);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
> -		attr->xattri_dela_state = XFS_DAS_UNINIT;
> +		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -600,7 +583,7 @@ xfs_attri_item_recover(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	ret = xfs_xattri_finish_update(attr, done_item, attrp->alfi_op_flags);
> +	ret = xfs_xattri_finish_update(attr, done_item);
>  	if (ret == -EAGAIN) {
>  		/* There's more work to do, so add it to this transaction */
>  		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> -- 
> 2.35.1
> 
