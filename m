Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD07374CE
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 22:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXz/z868"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB6EC433C7;
	Mon, 27 Nov 2023 22:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701125176;
	bh=iDNlrlF5MFlpfJ4aYzmwqm2LpXx5bpa+dUF5RN3quYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CXz/z868NNGpyBL/sxhu4Bz3JJ74DOjjCjBZ/rk3D4AlxXTsvu7wE3jnKkTgYulce
	 sPJSh8H7yTi58Ror/WG+uMS7uA9xsxja1k2t9NWfqn9BCWG2u7JLu/aj6gPJStjXWi
	 T/iVgpI9Y/B3G23+4VderYHNPx0vJg4bCMmx1ZRuU5y3kBq/Ny0Lpi3iXmAk/D9HXh
	 gjgRSyomwVEu5Q7in8QxxluYXz4CbYOWB4F5CNWaOjGwrJhRL+68aGiwk6lH8bg4G8
	 ztvkPlx58NybtGuVzByeNAN8Fbo8qN7RXNlgFZYSJ416hZEOIqd6RJ6Uy23kLXZalv
	 OWpwQIOhB3pWw==
Date: Mon, 27 Nov 2023 14:46:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: force small EFIs for reaping btree extents
Message-ID: <20231127224615.GH2766956@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926238.2768790.8811874509215907711.stgit@frogsfrogsfrogs>
 <ZWGCcotfoJNbeol6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGCcotfoJNbeol6@infradead.org>

On Fri, Nov 24, 2023 at 09:13:22PM -0800, Christoph Hellwig wrote:
> This generally looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But as mentioned earlier I think it would be nice to share some
> code between the normal xfs_defer_add and xfs_defer_add_barrier.
> 
> This would be the fold for this patch on top of the one previously
> posted and a light merge fix for the pausing between:

Applied.  Thanks for the quick cleanup!

--D

> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index e70dc347074dc5..5d621e445e8ab9 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -753,6 +753,22 @@ xfs_defer_can_append(
>  	return true;
>  }
>  
> +/* Create a new pending item at the end of the intake list. */
> +static struct xfs_defer_pending *
> +xfs_defer_alloc(
> +	struct xfs_trans		*tp,
> +	enum xfs_defer_ops_type		type)
> +{
> +	struct xfs_defer_pending	*dfp;
> +
> +	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> +			GFP_NOFS | __GFP_NOFAIL);
> +	dfp->dfp_type = type;
> +	INIT_LIST_HEAD(&dfp->dfp_work);
> +	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
> +	return dfp;
> +};
> +
>  /* Add an item for later deferred processing. */
>  struct xfs_defer_pending *
>  xfs_defer_add(
> @@ -760,29 +776,18 @@ xfs_defer_add(
>  	enum xfs_defer_ops_type		type,
>  	struct list_head		*li)
>  {
> -	struct xfs_defer_pending	*dfp = NULL;
>  	const struct xfs_defer_op_type	*ops = defer_op_types[type];
> +	struct xfs_defer_pending	*dfp;
>  
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
>  
>  	dfp = xfs_defer_find(tp, type);
> -	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
> -		/* Create a new pending item at the end of the intake list. */
> -		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> -				GFP_NOFS | __GFP_NOFAIL);
> -		dfp->dfp_type = type;
> -		dfp->dfp_intent = NULL;
> -		dfp->dfp_done = NULL;
> -		dfp->dfp_count = 0;
> -		INIT_LIST_HEAD(&dfp->dfp_work);
> -		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
> -	}
> -
> +	if (!dfp || !xfs_defer_can_append(dfp, ops))
> +		dfp = xfs_defer_alloc(tp, type);
>  	list_add_tail(li, &dfp->dfp_work);
>  	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
>  	dfp->dfp_count++;
> -
>  	return dfp;
>  }
>  
> @@ -1106,19 +1111,10 @@ xfs_defer_add_barrier(
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
>  	/* If the last defer op added was a barrier, we're done. */
> -	if (!list_empty(&tp->t_dfops)) {
> -		dfp = list_last_entry(&tp->t_dfops,
> -				struct xfs_defer_pending, dfp_list);
> -		if (dfp->dfp_type == XFS_DEFER_OPS_TYPE_BARRIER)
> -			return;
> -	}
> -
> -	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> -			GFP_NOFS | __GFP_NOFAIL);
> -	dfp->dfp_type = XFS_DEFER_OPS_TYPE_BARRIER;
> -	INIT_LIST_HEAD(&dfp->dfp_work);
> -	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
> -
> +	dfp = xfs_defer_find(tp, XFS_DEFER_OPS_TYPE_BARRIER);
> +	if (dfp)
> +		return;
> +	dfp = xfs_defer_alloc(tp, XFS_DEFER_OPS_TYPE_BARRIER);
>  	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
>  	dfp->dfp_count++;
>  }
> 
