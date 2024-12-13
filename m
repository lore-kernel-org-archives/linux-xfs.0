Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21601372
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129927; cv=none; b=cyDMli1l8nuEsdw3vdgSXgrZBxf7cb4BQg8KBNHQCSUpBtg9yM2n7zcrQR3eoP49TaFJ+FNkxWtf5Q6JFHylXbYSx7aAebMSMozERVfhWfKjfXT0Jli0emlZhPjpXWgURfwv4idnxEerVAxcBM3BYVBhILneL27uNeGMTRJksxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129927; c=relaxed/simple;
	bh=iqeLzzRlb3jGWtS7iI6WuxfNzkKN8HyNHWgd3ejiQNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGUFiTZ39SxDtV5QlEZb1lnKh/mVtqNIou9+X2I4UclsTzMx5JU6H3owxIL54ddMGz6Urb1e1ND6pfFHV0SW5Arza+DXgBag7cPwcqAQPV8wf1dCeD4TIULz09uApP8Sa8wHqqrL6MG0zE0bNKWbIyLOf69bxpD0I0Dj3LeJYsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCpRVaiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCpRVaiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884FFC4CED0;
	Fri, 13 Dec 2024 22:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734129927;
	bh=iqeLzzRlb3jGWtS7iI6WuxfNzkKN8HyNHWgd3ejiQNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vCpRVaiwaArvqOhJ0y2ckNsj9ZxGAetPRQJF6qgqz5JaWsf4WjhWfPnb/GhKgad4l
	 oL+NjteaXJ7pN1QFB0xrAu1sqYsebnTSPhyUFYKWHCdzgyBKVWhjJQyvor3qmaNQjg
	 S0I9sd+PPEpy171sJ2JI8UlqSp9Yr1YakHxXbWVfqh1DlZG0zftjNicnPX4KMqKmYV
	 RcNyEHIn3dDXTtmqLAjvYOsb+E/8f4gFHstaq5oJ3T4ZxLVF2pjd22wUz7e1/WLl3V
	 PWkNh3g1mlnK/W+ERvetpTm7O0qkzrtpHkpfeokBsHfkwLa4KY0wX53cPtTzpxcywf
	 TkUqnhzGC31FA==
Date: Fri, 13 Dec 2024 14:45:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/43] xfs: support growfs on zoned file systems
Message-ID: <20241213224527.GU6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-32-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-32-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:56AM +0100, Christoph Hellwig wrote:
> Replace the inner loop growing one RT bitmap block at a time with
> one just modifying the superblock counters for growing an entire
> zone (aka RTG).  The big restriction is just like at mkfs time only
> a RT extent size of a single FSB is allowed, and the file system
> capacity needs to be aligned to the zone size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Got it, that really is nice to do growfs a group at a time.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 121 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 101 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 47c94ac74259..e21baa494c33 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -860,6 +860,84 @@ xfs_growfs_rt_init_rtsb(
>  	return error;
>  }
>  
> +static void
> +xfs_growfs_rt_sb_fields(
> +	struct xfs_trans	*tp,
> +	const struct xfs_mount	*nmp)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +
> +	if (nmp->m_sb.sb_rextsize != mp->m_sb.sb_rextsize)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSIZE,
> +			nmp->m_sb.sb_rextsize - mp->m_sb.sb_rextsize);
> +	if (nmp->m_sb.sb_rbmblocks != mp->m_sb.sb_rbmblocks)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBMBLOCKS,
> +			nmp->m_sb.sb_rbmblocks - mp->m_sb.sb_rbmblocks);
> +	if (nmp->m_sb.sb_rblocks != mp->m_sb.sb_rblocks)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBLOCKS,
> +			nmp->m_sb.sb_rblocks - mp->m_sb.sb_rblocks);
> +	if (nmp->m_sb.sb_rextents != mp->m_sb.sb_rextents)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTENTS,
> +			nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents);
> +	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
> +			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
> +	if (nmp->m_sb.sb_rgcount != mp->m_sb.sb_rgcount)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RGCOUNT,
> +			nmp->m_sb.sb_rgcount - mp->m_sb.sb_rgcount);
> +}
> +
> +static int
> +xfs_growfs_rt_zoned(
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rfsblock_t		nrblocks)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_mount	*nmp;
> +	struct xfs_trans	*tp;
> +	xfs_rtbxlen_t		freed_rtx;
> +	int			error;
> +
> +	/*
> +	 * Calculate new sb and mount fields for this round.  Also ensure the
> +	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
> +	 */
> +	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
> +			mp->m_sb.sb_rextsize);
> +	if (!nmp)
> +		return -ENOMEM;
> +	freed_rtx = nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents;
> +
> +	xfs_rtgroup_calc_geometry(nmp, rtg, rtg_rgno(rtg),
> +			nmp->m_sb.sb_rgcount, nmp->m_sb.sb_rextents);
> +
> +	error = xfs_trans_alloc(mp, &M_RES(nmp)->tr_growrtfree, 0, 0, 0, &tp);
> +	if (error)
> +		goto out_free;
> +
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
> +
> +	xfs_growfs_rt_sb_fields(tp, nmp);
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
> +
> +	error = xfs_trans_commit(tp);
> +	if (error)
> +		goto out_free;
> +
> +	/*
> +	 * Ensure the mount RT feature flag is now set, and compute new
> +	 * maxlevels for rt btrees.
> +	 */
> +	mp->m_features |= XFS_FEAT_REALTIME;
> +	xfs_rtrmapbt_compute_maxlevels(mp);
> +	xfs_rtrefcountbt_compute_maxlevels(mp);
> +	xfs_zoned_add_available(mp, freed_rtx);
> +out_free:
> +	kfree(nmp);
> +	return error;
> +}
> +
>  static int
>  xfs_growfs_rt_bmblock(
>  	struct xfs_rtgroup	*rtg,
> @@ -945,24 +1023,7 @@ xfs_growfs_rt_bmblock(
>  	/*
>  	 * Update superblock fields.
>  	 */
> -	if (nmp->m_sb.sb_rextsize != mp->m_sb.sb_rextsize)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSIZE,
> -			nmp->m_sb.sb_rextsize - mp->m_sb.sb_rextsize);
> -	if (nmp->m_sb.sb_rbmblocks != mp->m_sb.sb_rbmblocks)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBMBLOCKS,
> -			nmp->m_sb.sb_rbmblocks - mp->m_sb.sb_rbmblocks);
> -	if (nmp->m_sb.sb_rblocks != mp->m_sb.sb_rblocks)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBLOCKS,
> -			nmp->m_sb.sb_rblocks - mp->m_sb.sb_rblocks);
> -	if (nmp->m_sb.sb_rextents != mp->m_sb.sb_rextents)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTENTS,
> -			nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents);
> -	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSLOG,
> -			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
> -	if (nmp->m_sb.sb_rgcount != mp->m_sb.sb_rgcount)
> -		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RGCOUNT,
> -			nmp->m_sb.sb_rgcount - mp->m_sb.sb_rgcount);
> +	xfs_growfs_rt_sb_fields(args.tp, nmp);
>  
>  	/*
>  	 * Free the new extent.
> @@ -1129,6 +1190,11 @@ xfs_growfs_rtg(
>  			goto out_rele;
>  	}
>  
> +	if (xfs_has_zoned(mp)) {
> +		error = xfs_growfs_rt_zoned(rtg, nrblocks);
> +		goto out_rele;
> +	}
> +
>  	error = xfs_growfs_rt_alloc_blocks(rtg, nrblocks, rextsize, &bmblocks);
>  	if (error)
>  		goto out_rele;
> @@ -1148,8 +1214,7 @@ xfs_growfs_rtg(
>  
>  	if (old_rsum_cache)
>  		kvfree(old_rsum_cache);
> -	xfs_rtgroup_rele(rtg);
> -	return 0;
> +	goto out_rele;
>  
>  out_error:
>  	/*
> @@ -1197,6 +1262,22 @@ xfs_growfs_check_rtgeom(
>  
>  	if (min_logfsbs > mp->m_sb.sb_logblocks)
>  		return -EINVAL;
> +
> +	if (xfs_has_zoned(mp)) {
> +		uint32_t	gblocks = mp->m_groups[XG_TYPE_RTG].blocks;
> +		uint32_t	rem;
> +
> +		if (rextsize != 1)
> +			return -EINVAL;
> +		div_u64_rem(mp->m_sb.sb_rblocks, gblocks, &rem);
> +		if (rem) {
> +			xfs_warn(mp,
> +"new RT volume size (%lld) not aligned to RT group size (%d)",
> +				mp->m_sb.sb_rblocks, gblocks);
> +			return -EINVAL;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.45.2
> 
> 
