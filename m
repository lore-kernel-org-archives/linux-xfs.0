Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257A872631
	for <linux-xfs@vger.kernel.org>; Sat, 10 Jan 2026 01:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768007504; cv=none; b=rewD0KR/97tixg/iHaSx1thaT7ALrDRu1syViLhSSl5ZxH0uZ5hzdt5jB1MBHirMQqLdfknyYUYCXbp0iGIMJUHaQlnKW1LDIH39ZTvE03GfXC4K9Y/QERLSqpM7oMOyl55l0+dNNfFl5yD7JPteyKKP+wlW6AzCnfcPZcS8z6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768007504; c=relaxed/simple;
	bh=wvi+guS6BmaFqQo3g6+084lELo9/UCCchEsMG5GhfEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyX6/Doi7lgjzhe/ut6pYiiunYwX7BEDNmnqii6BP05HrClk+FmM83xO3cd0cmPi8EzfCi4OvztApK3FFRlfu3k4K3U3Xe5bYmSS6MTnk09dSJZUeyLu4p9derAyUrvkyQSS4qMhTimNksIlGJFGY7nD+cf3sFkSSB6YUMHKShg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diuccTE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diuccTE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D147C4CEF1;
	Sat, 10 Jan 2026 01:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768007503;
	bh=wvi+guS6BmaFqQo3g6+084lELo9/UCCchEsMG5GhfEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=diuccTE+xDWkGyyg4aDCySb2c99pyoEROmrl2KVtOO05Himo/Q1+IWg7EU/+ZQHeP
	 wKJm/Zm29Js/J0Nu4sG5eqYdQhxSrRDx9rqMT86aHY1d4iGY/MXl/ofP3XMNil7/5l
	 lBkHgWB+ZFBY8nlTemzhDnOMyBt1RuKtHxTFMaiNvPwpDICbfAWFudUqwcHDbWryfd
	 fN/36FKPOIjEDSICDfhzkUmTpCHj1mf3UMRHdM1O+dBrFGtxjyN7yZDLTQve4YNlOC
	 GzK85AaiNDSZrx+lTLQRplgY/WLvDIHeBbFRRpRsVYvzkmxJ106jQACZwc0f5k8y89
	 d6E/hfz7OjxWA==
Date: Fri, 9 Jan 2026 17:11:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Message-ID: <20260110011143.GX15551@frogsfrogsfrogs>
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109172139.2410399-4-hch@lst.de>

On Fri, Jan 09, 2026 at 06:20:48PM +0100, Christoph Hellwig wrote:
> Move the two methods to query the write pointer out of xfs_init_zone into
> the callers, so that xfs_init_zone doesn't have to bother with the
> blk_zone structure and instead operates purely at the XFS realtime group
> level.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, so this change is decoupling zone initialization (aka
xfs_init_zone) from struct blk_zone so that now zone initialization
itself doesn't have to know how to call the stuff in linux/blkzoned.h.

That's a nice restructuring, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> ---
>  fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bbcf21704ea0..013228eab0ac 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -981,43 +981,43 @@ struct xfs_init_zones {
>  	uint64_t		reclaimable;
>  };
>  
> +/*
> + * For sequential write required zones, we restart writing at the hardware write
> + * pointer.
> + *
> + * For conventional zones or conventional devices we have query the rmap to
> + * find the highest recorded block and set the write pointer to the block after
> + * that.  In case of a power loss this misses blocks where the data I/O has
> + * completed but not recorded in the rmap yet, and it also rewrites blocks if
> + * the most recently written ones got deleted again before unmount, but this is
> + * the best we can do without hardware support.
> + */
> +static xfs_rgblock_t
> +xfs_rmap_write_pointer(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	xfs_rgblock_t		highest_rgbno;
> +
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> +	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +
> +	if (highest_rgbno == NULLRGBLOCK)
> +		return 0;
> +	return highest_rgbno + 1;
> +}
> +
>  static int
>  xfs_init_zone(
>  	struct xfs_init_zones	*iz,
>  	struct xfs_rtgroup	*rtg,
> -	struct blk_zone		*zone)
> +	xfs_rgblock_t		write_pointer)
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
> -	xfs_rgblock_t		write_pointer, highest_rgbno;
>  	int			error;
>  
> -	if (zone && !xfs_zone_validate(zone, rtg, &write_pointer))
> -		return -EFSCORRUPTED;
> -
> -	/*
> -	 * For sequential write required zones we retrieved the hardware write
> -	 * pointer above.
> -	 *
> -	 * For conventional zones or conventional devices we don't have that
> -	 * luxury.  Instead query the rmap to find the highest recorded block
> -	 * and set the write pointer to the block after that.  In case of a
> -	 * power loss this misses blocks where the data I/O has completed but
> -	 * not recorded in the rmap yet, and it also rewrites blocks if the most
> -	 * recently written ones got deleted again before unmount, but this is
> -	 * the best we can do without hardware support.
> -	 */
> -	if (!zone || zone->cond == BLK_ZONE_COND_NOT_WP) {
> -		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> -		highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> -		if (highest_rgbno == NULLRGBLOCK)
> -			write_pointer = 0;
> -		else
> -			write_pointer = highest_rgbno + 1;
> -		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> -	}
> -
>  	/*
>  	 * If there are no used blocks, but the zone is not in empty state yet
>  	 * we lost power before the zoned reset.  In that case finish the work
> @@ -1066,6 +1066,7 @@ xfs_get_zone_info_cb(
>  	struct xfs_mount	*mp = iz->mp;
>  	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
>  	xfs_rgnumber_t		rgno;
> +	xfs_rgblock_t		write_pointer;
>  	struct xfs_rtgroup	*rtg;
>  	int			error;
>  
> @@ -1080,7 +1081,13 @@ xfs_get_zone_info_cb(
>  		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
>  		return -EFSCORRUPTED;
>  	}
> -	error = xfs_init_zone(iz, rtg, zone);
> +	if (!xfs_zone_validate(zone, rtg, &write_pointer)) {
> +		xfs_rtgroup_rele(rtg);
> +		return -EFSCORRUPTED;
> +	}
> +	if (zone->cond == BLK_ZONE_COND_NOT_WP)
> +		write_pointer = xfs_rmap_write_pointer(rtg);
> +	error = xfs_init_zone(iz, rtg, write_pointer);
>  	xfs_rtgroup_rele(rtg);
>  	return error;
>  }
> @@ -1290,7 +1297,8 @@ xfs_mount_zones(
>  		struct xfs_rtgroup	*rtg = NULL;
>  
>  		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> -			error = xfs_init_zone(&iz, rtg, NULL);
> +			error = xfs_init_zone(&iz, rtg,
> +					xfs_rmap_write_pointer(rtg));
>  			if (error) {
>  				xfs_rtgroup_rele(rtg);
>  				goto out_free_zone_info;
> -- 
> 2.47.3
> 
> 
