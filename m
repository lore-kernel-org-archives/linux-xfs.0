Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC8057875
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kcipy6No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2066C433C8;
	Wed, 13 Dec 2023 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702491410;
	bh=SpVVc9Hb5NooGwqKD/qBWMr2kfkL6CcbsDWCwRwCmu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kcipy6No1FN0p5j0llS1fXYKEuxYbNJ17Dx4/YL4IgBFNR6JlBPSfBzPzcqVfiCHS
	 OHvn54TBXswYOAisZmNESx3GB2XqB+CAS4BujM90XMwWwqYhDnKlkWCycDVyY9xxuZ
	 QHaACo1+KjO8D/wtYZcHfj3LTnnm2mPuFF8LirYGPYWUvdU+TshhXOMADgPwfcQkR/
	 U3shwbXp+ov+t/PEPG3/lvqfrvTqDCxVwURFgpHU6S/ESih0et+lGdi4TH2cvrieAb
	 G4Nk2qAKCjijgF1Pi7DKtFRyqoH0sYQO4oFy/C+LWTKFBVULuT/WUT+pobrx2vHOe3
	 Gg8FWNYptuxbw==
Date: Wed, 13 Dec 2023 10:16:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] xfs: pass the defer ops directly to xfs_defer_add
Message-ID: <20231213181650.GH361584@frogsfrogsfrogs>
References: <20231213090633.231707-1-hch@lst.de>
 <20231213090633.231707-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213090633.231707-6-hch@lst.de>

On Wed, Dec 13, 2023 at 10:06:33AM +0100, Christoph Hellwig wrote:
> Pass a pointer to the xfs_defer_op_type structure to xfs_defer_add and
> remove the indirection through the xfs_defer_ops_type enum and a global
> table of all possible operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

And now anyone can create their own deferred work loops without having
to register it in some dumb enum in xfs_defer.[ch].  Hooray!

Thanks for doing these cleanups,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c    |  4 ++--
>  fs/xfs/libxfs/xfs_attr.c     |  2 +-
>  fs/xfs/libxfs/xfs_bmap.c     |  2 +-
>  fs/xfs/libxfs/xfs_defer.c    | 16 ++--------------
>  fs/xfs/libxfs/xfs_defer.h    | 18 ++----------------
>  fs/xfs/libxfs/xfs_refcount.c |  2 +-
>  fs/xfs/libxfs/xfs_rmap.c     |  2 +-
>  7 files changed, 10 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 4940f9377f21a1..60c2c18e8e54f9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2514,7 +2514,7 @@ xfs_defer_agfl_block(
>  	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
>  
>  	xfs_extent_free_get_group(mp, xefi);
> -	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
> +	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
>  	return 0;
>  }
>  
> @@ -2578,7 +2578,7 @@ xfs_defer_extent_free(
>  			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
>  
>  	xfs_extent_free_get_group(mp, xefi);
> -	*dfpp = xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
> +	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, &xfs_extent_free_defer_type);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4fed0c87a968ab..fa49c795f40745 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -906,7 +906,7 @@ xfs_attr_defer_add(
>  		ASSERT(0);
>  	}
>  
> -	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
>  	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ca6614f4eac50a..e308d2f44a3c31 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6091,7 +6091,7 @@ __xfs_bmap_add(
>  	bi->bi_bmap = *bmap;
>  
>  	xfs_bmap_update_get_group(tp->t_mountp, bi);
> -	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
> +	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 6a6444ffe5544b..10987877f19378 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -235,16 +235,6 @@ static const struct xfs_defer_op_type xfs_barrier_defer_type = {
>  	.cancel_item	= xfs_defer_barrier_cancel_item,
>  };
>  
> -static const struct xfs_defer_op_type *defer_op_types[] = {
> -	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
> -	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
> -	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
> -	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
> -	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> -	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
> -	[XFS_DEFER_OPS_TYPE_BARRIER]	= &xfs_barrier_defer_type,
> -};
> -
>  /* Create a log intent done item for a log intent item. */
>  static inline void
>  xfs_defer_create_done(
> @@ -847,14 +837,12 @@ xfs_defer_alloc(
>  struct xfs_defer_pending *
>  xfs_defer_add(
>  	struct xfs_trans		*tp,
> -	enum xfs_defer_ops_type		type,
> -	struct list_head		*li)
> +	struct list_head		*li,
> +	const struct xfs_defer_op_type	*ops)
>  {
>  	struct xfs_defer_pending	*dfp = NULL;
> -	const struct xfs_defer_op_type	*ops = defer_op_types[type];
>  
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> -	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
>  
>  	dfp = xfs_defer_find_last(tp, ops);
>  	if (!dfp || !xfs_defer_can_append(dfp, ops))
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 60de91b6639225..18a9fb92dde8e6 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -10,20 +10,6 @@ struct xfs_btree_cur;
>  struct xfs_defer_op_type;
>  struct xfs_defer_capture;
>  
> -/*
> - * Header for deferred operation list.
> - */
> -enum xfs_defer_ops_type {
> -	XFS_DEFER_OPS_TYPE_BMAP,
> -	XFS_DEFER_OPS_TYPE_REFCOUNT,
> -	XFS_DEFER_OPS_TYPE_RMAP,
> -	XFS_DEFER_OPS_TYPE_FREE,
> -	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> -	XFS_DEFER_OPS_TYPE_ATTR,
> -	XFS_DEFER_OPS_TYPE_BARRIER,
> -	XFS_DEFER_OPS_TYPE_MAX,
> -};
> -
>  /*
>   * Save a log intent item and a list of extents, so that we can replay
>   * whatever action had to happen to the extent list and file the log done
> @@ -51,8 +37,8 @@ struct xfs_defer_pending {
>  void xfs_defer_item_pause(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
>  void xfs_defer_item_unpause(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
>  
> -struct xfs_defer_pending *xfs_defer_add(struct xfs_trans *tp,
> -		enum xfs_defer_ops_type type, struct list_head *h);
> +struct xfs_defer_pending *xfs_defer_add(struct xfs_trans *tp, struct list_head *h,
> +		const struct xfs_defer_op_type *ops);
>  int xfs_defer_finish_noroll(struct xfs_trans **tp);
>  int xfs_defer_finish(struct xfs_trans **tp);
>  int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 3702b4a071100d..5b039cd022e073 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1458,7 +1458,7 @@ __xfs_refcount_add(
>  	ri->ri_blockcount = blockcount;
>  
>  	xfs_refcount_update_get_group(tp->t_mountp, ri);
> -	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
> +	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index fbb0b263746352..76bf7f48cb5acf 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2567,7 +2567,7 @@ __xfs_rmap_add(
>  	ri->ri_bmap = *bmap;
>  
>  	xfs_rmap_update_get_group(tp->t_mountp, ri);
> -	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
> +	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
>  }
>  
>  /* Map an extent into a file. */
> -- 
> 2.39.2
> 
> 
