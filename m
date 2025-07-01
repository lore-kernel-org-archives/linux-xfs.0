Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B914927D770
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388787; cv=none; b=IxdQWbmJJgXbKm4SEeyTHjybl2Ke/j2PGv0rOvaZ/e48tYnLTX8CddI0ioqB+fVdxer91u0UvRryKXcp2wqLVN4zABuLc2zg7q5GCmB6z4PISSFxuQUje7SEIaFyeq6wYtzZGP2KGOGB5c4TnMJyC9uYwnLfbaltVf3UcjEeI+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388787; c=relaxed/simple;
	bh=ZFGrAsQtty49Y9XmO+YS1hMVSkTwb72beqxOKOT/g20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAi/mm3D2SynmmCXa/eYXajUu0pCWl4JJWW+R6mGBMo9RVHw71VYkIkCXFvLiXksjHEfo4brMoY/cm/VnJ9vBx0jaa3HQ4Nl3nDM5LbGFVF8mTVFjLl4I22ifFoho3AuBKF087BJw7PnuhCyiLV+6mRM9lKtt1FyfOaMfVJhMis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sp4JddCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sp4JddCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F93FC4CEEF;
	Tue,  1 Jul 2025 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751388787;
	bh=ZFGrAsQtty49Y9XmO+YS1hMVSkTwb72beqxOKOT/g20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sp4JddCojKGsFOe1w7R/qlvh4NMuZplkdNw7Nq1A2b6E5HqBB1jc/TQIK+uKY8A/i
	 5ImX4g8A4YV0Q4pN8rIBpYy6mxWLVLJr/tj9/qdIBkYWPzxm2oHll4xYMKf6w8sTDy
	 f7YPy4RN51ph+m+WQATFS2Oy5iYTK5s42lP52JZiEKGlNg+9VmvBGRqWKxYNGjtXNQ
	 ci1FvXo2/4SGp6ZVf2UCxWdxmrJlxDWRIdtPTNgUkHJoVyVguPPH4GZGoCJQ5B2rks
	 TTMgaOfD9YXMBOfb24k88mxdmSUzdS12oZ+k24IpUNdkVk6AYzf3fpq7cbFdu/9jgY
	 T1lro0d4AgonA==
Date: Tue, 1 Jul 2025 09:53:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
Message-ID: <20250701165306.GK10009@frogsfrogsfrogs>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-5-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:38PM +0200, Christoph Hellwig wrote:
> This function and the helpers used by it duplicate the same logic for AGs
> and RTGs.  Use the xfs_group_type enum to unify both variants.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>

LGTM,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.c | 76 +++++++++++++++++-----------------------------
>  fs/xfs/xfs_trace.h | 31 +++++++++----------
>  2 files changed, 42 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 047100b080aa..99fbb22bad4c 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -679,68 +679,46 @@ static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
>  }
>  
>  /*
> - * If the data device advertises atomic write support, limit the size of data
> - * device atomic writes to the greatest power-of-two factor of the AG size so
> - * that every atomic write unit aligns with the start of every AG.  This is
> - * required so that the per-AG allocations for an atomic write will always be
> + * If the underlying device advertises atomic write support, limit the size of
> + * atomic writes to the greatest power-of-two factor of the group size so
> + * that every atomic write unit aligns with the start of every group.  This is
> + * required so that the allocations for an atomic write will always be
>   * aligned compatibly with the alignment requirements of the storage.
>   *
> - * If the data device doesn't advertise atomic writes, then there are no
> - * alignment restrictions and the largest out-of-place write we can do
> - * ourselves is the number of blocks that user files can allocate from any AG.
> + * If the device doesn't advertise atomic writes, then there are no alignment
> + * restrictions and the largest out-of-place write we can do ourselves is the
> + * number of blocks that user files can allocate from any group.
>   */
> -static inline xfs_extlen_t xfs_calc_perag_awu_max(struct xfs_mount *mp)
> -{
> -	if (mp->m_ddev_targp->bt_bdev_awu_min > 0)
> -		return max_pow_of_two_factor(mp->m_sb.sb_agblocks);
> -	return rounddown_pow_of_two(mp->m_ag_max_usable);
> -}
> -
> -/*
> - * Reflink on the realtime device requires rtgroups, and atomic writes require
> - * reflink.
> - *
> - * If the realtime device advertises atomic write support, limit the size of
> - * data device atomic writes to the greatest power-of-two factor of the rtgroup
> - * size so that every atomic write unit aligns with the start of every rtgroup.
> - * This is required so that the per-rtgroup allocations for an atomic write
> - * will always be aligned compatibly with the alignment requirements of the
> - * storage.
> - *
> - * If the rt device doesn't advertise atomic writes, then there are no
> - * alignment restrictions and the largest out-of-place write we can do
> - * ourselves is the number of blocks that user files can allocate from any
> - * rtgroup.
> - */
> -static inline xfs_extlen_t xfs_calc_rtgroup_awu_max(struct xfs_mount *mp)
> +static xfs_extlen_t
> +xfs_calc_group_awu_max(
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
>  {
> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
> +	struct xfs_groups	*g = &mp->m_groups[type];
> +	struct xfs_buftarg	*btp = xfs_group_type_buftarg(mp, type);
>  
> -	if (rgs->blocks == 0)
> +	if (g->blocks == 0)
>  		return 0;
> -	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev_awu_min > 0)
> -		return max_pow_of_two_factor(rgs->blocks);
> -	return rounddown_pow_of_two(rgs->blocks);
> +	if (btp && btp->bt_bdev_awu_min > 0)
> +		return max_pow_of_two_factor(g->blocks);
> +	return rounddown_pow_of_two(g->blocks);
>  }
>  
>  /* Compute the maximum atomic write unit size for each section. */
>  static inline void
>  xfs_calc_atomic_write_unit_max(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
>  {
> -	struct xfs_groups	*ags = &mp->m_groups[XG_TYPE_AG];
> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
> +	struct xfs_groups	*g = &mp->m_groups[type];
>  
>  	const xfs_extlen_t	max_write = xfs_calc_atomic_write_max(mp);
>  	const xfs_extlen_t	max_ioend = xfs_reflink_max_atomic_cow(mp);
> -	const xfs_extlen_t	max_agsize = xfs_calc_perag_awu_max(mp);
> -	const xfs_extlen_t	max_rgsize = xfs_calc_rtgroup_awu_max(mp);
> -
> -	ags->awu_max = min3(max_write, max_ioend, max_agsize);
> -	rgs->awu_max = min3(max_write, max_ioend, max_rgsize);
> +	const xfs_extlen_t	max_gsize = xfs_calc_group_awu_max(mp, type);
>  
> -	trace_xfs_calc_atomic_write_unit_max(mp, max_write, max_ioend,
> -			max_agsize, max_rgsize);
> +	g->awu_max = min3(max_write, max_ioend, max_gsize);
> +	trace_xfs_calc_atomic_write_unit_max(mp, type, max_write, max_ioend,
> +			max_gsize, g->awu_max);
>  }
>  
>  /*
> @@ -758,7 +736,8 @@ xfs_set_max_atomic_write_opt(
>  		max(mp->m_groups[XG_TYPE_AG].blocks,
>  		    mp->m_groups[XG_TYPE_RTG].blocks);
>  	const xfs_extlen_t	max_group_write =
> -		max(xfs_calc_perag_awu_max(mp), xfs_calc_rtgroup_awu_max(mp));
> +		max(xfs_calc_group_awu_max(mp, XG_TYPE_AG),
> +		    xfs_calc_group_awu_max(mp, XG_TYPE_RTG));
>  	int			error;
>  
>  	if (new_max_bytes == 0)
> @@ -814,7 +793,8 @@ xfs_set_max_atomic_write_opt(
>  		return error;
>  	}
>  
> -	xfs_calc_atomic_write_unit_max(mp);
> +	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_AG);
> +	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_RTG);
>  	mp->m_awu_max_bytes = new_max_bytes;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index aae0d0ef84e0..6addebd764b0 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -171,36 +171,33 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
>  DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
>  
>  TRACE_EVENT(xfs_calc_atomic_write_unit_max,
> -	TP_PROTO(struct xfs_mount *mp, unsigned int max_write,
> -		 unsigned int max_ioend, unsigned int max_agsize,
> -		 unsigned int max_rgsize),
> -	TP_ARGS(mp, max_write, max_ioend, max_agsize, max_rgsize),
> +	TP_PROTO(struct xfs_mount *mp, enum xfs_group_type type,
> +		 unsigned int max_write, unsigned int max_ioend,
> +		 unsigned int max_gsize, unsigned int awu_max),
> +	TP_ARGS(mp, type, max_write, max_ioend, max_gsize, awu_max),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
> +		__field(enum xfs_group_type, type)
>  		__field(unsigned int, max_write)
>  		__field(unsigned int, max_ioend)
> -		__field(unsigned int, max_agsize)
> -		__field(unsigned int, max_rgsize)
> -		__field(unsigned int, data_awu_max)
> -		__field(unsigned int, rt_awu_max)
> +		__field(unsigned int, max_gsize)
> +		__field(unsigned int, awu_max)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
> +		__entry->type = type;
>  		__entry->max_write = max_write;
>  		__entry->max_ioend = max_ioend;
> -		__entry->max_agsize = max_agsize;
> -		__entry->max_rgsize = max_rgsize;
> -		__entry->data_awu_max = mp->m_groups[XG_TYPE_AG].awu_max;
> -		__entry->rt_awu_max = mp->m_groups[XG_TYPE_RTG].awu_max;
> +		__entry->max_gsize = max_gsize;
> +		__entry->awu_max = awu_max;
>  	),
> -	TP_printk("dev %d:%d max_write %u max_ioend %u max_agsize %u max_rgsize %u data_awu_max %u rt_awu_max %u",
> +	TP_printk("dev %d:%d %s max_write %u max_ioend %u max_gsize %u awu_max %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
>  		  __entry->max_write,
>  		  __entry->max_ioend,
> -		  __entry->max_agsize,
> -		  __entry->max_rgsize,
> -		  __entry->data_awu_max,
> -		  __entry->rt_awu_max)
> +		  __entry->max_gsize,
> +		  __entry->awu_max)
>  );
>  
>  TRACE_EVENT(xfs_calc_max_atomic_write_fsblocks,
> -- 
> 2.47.2
> 
> 
