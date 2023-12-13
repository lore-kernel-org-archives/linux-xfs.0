Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618FF8537E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYqVbl3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E821C433C8;
	Wed, 13 Dec 2023 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702491009;
	bh=LaYwgSBVqrt9bLnxq6qm4Wbfb6XYbH6BtFdz/LAuebc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qYqVbl3ea0NqrAjqYHemjBOjdHkdEwrxRvt7Fknz5wKmhC1mpAqtNiGId2HrXA2iv
	 x5XcC/1umAXU/yra1IbNqVC/Htp8VjtqxVn4ggUoxKoDms7WT8xp0n7MwZOV/69sRS
	 AXzHOhXuGiYiiju3thq0dtOX8xHHEeR3oMi927/grAgjsUvN4aVEsHYkMp5xYvjJ5L
	 JQoomzL4qw3QfBwvxNkfw2xeATnMCXscKPJDx1XmxmnAGOc1ITUuKjlOVGmkaN6C6/
	 WgmDYClOfUshpQ16N9mSKHxyztY7/7x/09amol+QVEdg0GFdea52tHv35BQ9VPQbJo
	 NHbWrrsm6xMZQ==
Date: Wed, 13 Dec 2023 10:10:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] xfs: consolidate the xfs_attr_defer_* helpers
Message-ID: <20231213181009.GD361584@frogsfrogsfrogs>
References: <20231213090633.231707-1-hch@lst.de>
 <20231213090633.231707-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213090633.231707-2-hch@lst.de>

On Wed, Dec 13, 2023 at 10:06:29AM +0100, Christoph Hellwig wrote:
> Consolidate the xfs_attr_defer_* helpers into a single xfs_attr_defer_add
> one that picks the right dela_state based on the passed in operation.
> Also move to a single trace point as the actual operation is visible
> through the flags in the delta_state passed to the trace point.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh, I had been thinking about the same consolidation...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 90 ++++++++++------------------------------
>  fs/xfs/xfs_trace.h       |  2 -
>  2 files changed, 21 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e28d93d232de49..4fed0c87a968ab 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -880,11 +880,10 @@ xfs_attr_lookup(
>  	return error;
>  }
>  
> -static int
> -xfs_attr_intent_init(
> +static void
> +xfs_attr_defer_add(
>  	struct xfs_da_args	*args,
> -	unsigned int		op_flags,	/* op flag (set or remove) */
> -	struct xfs_attr_intent	**attr)		/* new xfs_attr_intent */
> +	unsigned int		op_flags)
>  {
>  
>  	struct xfs_attr_intent	*new;
> @@ -893,66 +892,22 @@ xfs_attr_intent_init(
>  	new->xattri_op_flags = op_flags;
>  	new->xattri_da_args = args;
>  
> -	*attr = new;
> -	return 0;
> -}
> -
> -/* Sets an attribute for an inode as a deferred operation */
> -static int
> -xfs_attr_defer_add(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_attr_intent	*new;
> -	int			error = 0;
> -
> -	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
> -	if (error)
> -		return error;
> +	switch (op_flags) {
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +		new->xattri_dela_state = xfs_attr_init_add_state(args);
> +		break;
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +		new->xattri_dela_state = xfs_attr_init_replace_state(args);
> +		break;
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
> +		new->xattri_dela_state = xfs_attr_init_remove_state(args);
> +		break;
> +	default:
> +		ASSERT(0);
> +	}
>  
> -	new->xattri_dela_state = xfs_attr_init_add_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>  	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
> -
> -	return 0;
> -}
> -
> -/* Sets an attribute for an inode as a deferred operation */
> -static int
> -xfs_attr_defer_replace(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_attr_intent	*new;
> -	int			error = 0;
> -
> -	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
> -	if (error)
> -		return error;
> -
> -	new->xattri_dela_state = xfs_attr_init_replace_state(args);
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> -	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
> -
> -	return 0;
> -}
> -
> -/* Removes an attribute for an inode as a deferred operation */
> -static int
> -xfs_attr_defer_remove(
> -	struct xfs_da_args	*args)
> -{
> -
> -	struct xfs_attr_intent	*new;
> -	int			error;
> -
> -	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
> -	if (error)
> -		return error;
> -
> -	new->xattri_dela_state = xfs_attr_init_remove_state(args);
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> -	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
> -
> -	return 0;
>  }
>  
>  /*
> @@ -1038,16 +993,16 @@ xfs_attr_set(
>  	error = xfs_attr_lookup(args);
>  	switch (error) {
>  	case -EEXIST:
> -		/* if no value, we are performing a remove operation */
>  		if (!args->value) {
> -			error = xfs_attr_defer_remove(args);
> +			/* if no value, we are performing a remove operation */
> +			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
>  			break;
>  		}
> +
>  		/* Pure create fails if the attr already exists */
>  		if (args->attr_flags & XATTR_CREATE)
>  			goto out_trans_cancel;
> -
> -		error = xfs_attr_defer_replace(args);
> +		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
>  		break;
>  	case -ENOATTR:
>  		/* Can't remove what isn't there. */
> @@ -1057,14 +1012,11 @@ xfs_attr_set(
>  		/* Pure replace fails if no existing attr to replace. */
>  		if (args->attr_flags & XATTR_REPLACE)
>  			goto out_trans_cancel;
> -
> -		error = xfs_attr_defer_add(args);
> +		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
>  		break;
>  	default:
>  		goto out_trans_cancel;
>  	}
> -	if (error)
> -		goto out_trans_cancel;
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 514095b6ba2bdb..516529c151ae1c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4408,8 +4408,6 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_alloc);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
> -DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
> -DEFINE_DAS_STATE_EVENT(xfs_attr_defer_remove);
>  
>  
>  TRACE_EVENT(xfs_force_shutdown,
> -- 
> 2.39.2
> 
> 
