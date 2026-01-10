Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A542D42048
	for <linux-xfs@vger.kernel.org>; Sat, 10 Jan 2026 01:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768008524; cv=none; b=foMJmEtE8pZqSkvYbbsGfrXFPWmGQYgSqpWVONIBDf299fsE6d4lVz0ACfDZ2RgJzGBXFYigfy7GNRgazi1DzfMAuKA+UTYloQJEHMhdMgfxCUtGf5v3MRgyCxvUkFN2z/E2kKbBDqDy5qt58qdLtrhE9MYHASf+rEcrR7OkMpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768008524; c=relaxed/simple;
	bh=raviR3S6MSCxKsfnx195fOcsMH2nZFFUymnRlyGFxyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ab0rJZ2uyKivf6C9+3NEL0ic0O6yuiD4u5FkOtNp6e83SyWvEFjlMOCS50pNBFVz3AmWdr7qaJRkh1FiYBj2BHKlWNJcCYIaCw9U97alcmRG9zu/yPYo05K0lwZLUhk32qid+Xj8STn1enErYVhY5Ll0v56hKWJTEBNs+3fdS/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3xjvEug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3xjvEug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCF1C4CEF1;
	Sat, 10 Jan 2026 01:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768008524;
	bh=raviR3S6MSCxKsfnx195fOcsMH2nZFFUymnRlyGFxyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V3xjvEug5Z1SenhVKx8h1zSzZwZ6BQ7BRSD2TH93AFy9xZBvegsUn52MnbdiBZbpO
	 t5L3gzMfv/yCmg8QSmlO2SSTaodqIv4fxOQ2uVv5Ts8AGKbR733r9BIvYtLdvj5OYF
	 GSMma6aBquAOmEd/scXVydw5clc3VyoscxMC9X1bYyGEP+3CjWQJHm/6Pld+7nk0kF
	 3JYpJLVKpibN0WCA6mOIMjGvU3iMcQp18VkM6x9bm/qs54VlSDkkjN12fwG007t3yH
	 yKinDd8r4MJS0xWMS9lRb3PQt23rIZUqUpEjWysCmI4qz1u8I0OWsEkHw57thxHG9X
	 Ms6QO7cOMs4EA==
Date: Fri, 9 Jan 2026 17:28:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: use blkdev_get_zone_info to simply zone
 reporting
Message-ID: <20260110012843.GZ15551@frogsfrogsfrogs>
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109172139.2410399-7-hch@lst.de>

On Fri, Jan 09, 2026 at 06:20:51PM +0100, Christoph Hellwig wrote:
> Unwind the callback based programming model by querying the cached
> zone information using blkdev_get_zone_info.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, so now I see what's going here -- the libxfs zone code does the
validation, but it's up to the code in fs/xfs/ (or libxfs/init.c in
userspace) to find the zone information.  Let's hope the cached zone
information reduces the noticeable(ish) mount delays on some of my zoned
hardware.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 104 +++++++++++++++++-----------------------
>  1 file changed, 45 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 00260f70242f..2849be19369e 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -976,7 +976,6 @@ xfs_free_open_zones(
>  }
>  
>  struct xfs_init_zones {
> -	struct xfs_mount	*mp;
>  	uint32_t		zone_size;
>  	uint32_t		zone_capacity;
>  	uint64_t		available;
> @@ -1009,6 +1008,39 @@ xfs_rmap_write_pointer(
>  	return highest_rgbno + 1;
>  }
>  
> +static int
> +xfs_query_write_pointer(
> +	struct xfs_init_zones	*iz,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		*write_pointer)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
> +	sector_t		start = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
> +	struct blk_zone		zone = {
> +		.cond	= BLK_ZONE_COND_NOT_WP,
> +	};
> +	int			error;
> +
> +	if (bdev_is_zoned(bdev)) {
> +		error = blkdev_get_zone_info(bdev, start, &zone);
> +		if (error)
> +			return error;
> +		if (zone.start != start) {
> +			xfs_warn(mp, "mismatched zone start: 0x%llx/0x%llx.",
> +				zone.start, start);
> +			return -EFSCORRUPTED;
> +		}
> +		if (!xfs_zone_validate(mp, &zone, rtg_rgno(rtg), iz->zone_size,
> +				iz->zone_capacity, write_pointer))
> +			return -EFSCORRUPTED;
> +	}
> +
> +	if (zone.cond == BLK_ZONE_COND_NOT_WP)
> +		*write_pointer = xfs_rmap_write_pointer(rtg);
> +	return 0;
> +}
> +
>  static int
>  xfs_init_zone(
>  	struct xfs_init_zones	*iz,
> @@ -1084,43 +1116,6 @@ xfs_init_zone(
>  	return 0;
>  }
>  
> -static int
> -xfs_get_zone_info_cb(
> -	struct blk_zone		*zone,
> -	unsigned int		idx,
> -	void			*data)
> -{
> -	struct xfs_init_zones	*iz = data;
> -	struct xfs_mount	*mp = iz->mp;
> -	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
> -	xfs_rgnumber_t		rgno;
> -	xfs_rgblock_t		write_pointer;
> -	struct xfs_rtgroup	*rtg;
> -	int			error;
> -
> -	if (xfs_rtb_to_rgbno(mp, zsbno) != 0) {
> -		xfs_warn(mp, "mismatched zone start 0x%llx.", zsbno);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	rgno = xfs_rtb_to_rgno(mp, zsbno);
> -	rtg = xfs_rtgroup_grab(mp, rgno);
> -	if (!rtg) {
> -		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
> -		return -EFSCORRUPTED;
> -	}
> -	if (!xfs_zone_validate(mp, zone, idx, iz->zone_size,
> -			iz->zone_capacity, &write_pointer)) {
> -		xfs_rtgroup_rele(rtg);
> -		return -EFSCORRUPTED;
> -	}
> -	if (zone->cond == BLK_ZONE_COND_NOT_WP)
> -		write_pointer = xfs_rmap_write_pointer(rtg);
> -	error = xfs_init_zone(iz, rtg, write_pointer);
> -	xfs_rtgroup_rele(rtg);
> -	return error;
> -}
> -
>  /*
>   * Calculate the max open zone limit based on the of number of backing zones
>   * available.
> @@ -1255,15 +1250,13 @@ xfs_mount_zones(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_init_zones	iz = {
> -		.mp		= mp,
>  		.zone_capacity	= mp->m_groups[XG_TYPE_RTG].blocks,
>  		.zone_size	= xfs_rtgroup_raw_size(mp),
>  	};
> -	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
> -	xfs_extlen_t		zone_blocks = mp->m_groups[XG_TYPE_RTG].blocks;
> +	struct xfs_rtgroup	*rtg = NULL;
>  	int			error;
>  
> -	if (!bt) {
> +	if (!mp->m_rtdev_targp) {
>  		xfs_notice(mp, "RT device missing.");
>  		return -EINVAL;
>  	}
> @@ -1291,7 +1284,7 @@ xfs_mount_zones(
>  		return -ENOMEM;
>  
>  	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
> -		 mp->m_sb.sb_rgcount, zone_blocks, mp->m_max_open_zones);
> +		 mp->m_sb.sb_rgcount, iz.zone_capacity, mp->m_max_open_zones);
>  	trace_xfs_zones_mount(mp);
>  
>  	/*
> @@ -1315,25 +1308,18 @@ xfs_mount_zones(
>  	 * or beneficial.
>  	 */
>  	mp->m_super->s_min_writeback_pages =
> -		XFS_FSB_TO_B(mp, min(zone_blocks, XFS_MAX_BMBT_EXTLEN)) >>
> +		XFS_FSB_TO_B(mp, min(iz.zone_capacity, XFS_MAX_BMBT_EXTLEN)) >>
>  			PAGE_SHIFT;
>  
> -	if (bdev_is_zoned(bt->bt_bdev)) {
> -		error = blkdev_report_zones_cached(bt->bt_bdev,
> -				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
> -				mp->m_sb.sb_rgcount, xfs_get_zone_info_cb, &iz);
> -		if (error < 0)
> +	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> +		xfs_rgblock_t		write_pointer;
> +
> +		error = xfs_query_write_pointer(&iz, rtg, &write_pointer);
> +		if (!error)
> +			error = xfs_init_zone(&iz, rtg, write_pointer);
> +		if (error) {
> +			xfs_rtgroup_rele(rtg);
>  			goto out_free_zone_info;
> -	} else {
> -		struct xfs_rtgroup	*rtg = NULL;
> -
> -		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> -			error = xfs_init_zone(&iz, rtg,
> -					xfs_rmap_write_pointer(rtg));
> -			if (error) {
> -				xfs_rtgroup_rele(rtg);
> -				goto out_free_zone_info;
> -			}
>  		}
>  	}
>  
> -- 
> 2.47.3
> 
> 
