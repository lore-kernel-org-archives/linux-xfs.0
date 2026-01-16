Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006E920CCE4
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573018; cv=none; b=pXuzjIVKJNCr6ti4108zWCRfAh7jdVaCH44GSuaG3BtyvcCT0QYTnfli2VLW6XDJed1/0KgmGU9YoeQqnKdlma9Y1/FUnRnZAI5y168JhRPCHSJ8fb18px7yunSS8ro2fKN5Kf5WYPq2QwOa+R2Zx0psd5aLSAlc3TtxM8dLJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573018; c=relaxed/simple;
	bh=sIHOva1xj2JzLg4b4/SGYANfdDmisir8nsDXqXb0bak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhczWkcC8ROyoB9oNaOFvtoFBrvFPXlDfIovQB7o8fYvcrslCvbDFpNr1K1gisZWYcxrhbBnrAbjCTkOzgbf48RZ3bmEDdKyJmNEoMj9Stp2b5Mgtf9WopyCWGsDM6hKv1njQtXN3g0O74tjIWCHXdaSCLCPPSr/0VsXlttTr+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OV7gcinW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OV7gcinW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C63C116C6;
	Fri, 16 Jan 2026 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768573017;
	bh=sIHOva1xj2JzLg4b4/SGYANfdDmisir8nsDXqXb0bak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OV7gcinWc9T6uNX+FDS2FK8vrCkPtLGJ5xKlRzjPW7RyOFRv4DNTgdNy8OFl/CK28
	 v4TRzoii/wCtorGj0ifEcDHk/PQhCrbY8t224Q/1A3vcNuoNOXLid67SpXXmN9Gq9N
	 h6BoejU5prqGbf+bhZT2H76z+mpYkIVnVAoDeqiH1akLjoluk8pIAHvO+fPg9KASQC
	 yoVF415N1opJpQGDvvx76aDyeQoQ9t61wQQ7iQaEbV//uAQ3mVGuEPepvZt5A5uamf
	 a/JZp0z72gfgX5Usw8LjQiHKTZvtUjtGf1t2ocMUShqOTlgUsBsQ6vnwoCmLbz04jo
	 RBiwxHo1F0rlQ==
Date: Fri, 16 Jan 2026 15:16:53 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Message-ID: <aWpIMjHNPZxuoBMM@nidhogg.toxiclabs.cc>
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114065339.3392929-4-hch@lst.de>

On Wed, Jan 14, 2026 at 07:53:26AM +0100, Christoph Hellwig wrote:
> Move the two methods to query the write pointer out of xfs_init_zone into
> the callers, so that xfs_init_zone doesn't have to bother with the
> blk_zone structure and instead operates purely at the XFS realtime group
> level.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 4ca7769b5adb..87243644d88e 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -981,43 +981,43 @@ struct xfs_init_zones {
>  	uint64_t		reclaimable;
>  };
>  
> +/*
> + * For sequential write required zones, we restart writing at the hardware write
> + * pointer returned by xfs_zone_validate().
> + *
> + * For conventional zones or conventional devices we have query the rmap to
> + * find the highest recorded block and set the write pointer to the block after
> + * that.  In case of a power loss this misses blocks where the data I/O has
> + * completed but not recorded in the rmap yet, and it also rewrites blocks if
> + * the most recently written ones got deleted again before unmount, but this is
> + * the best we can do without hardware support.
> + */
> +static xfs_rgblock_t
> +xfs_rmap_estimate_write_pointer(
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
> +		write_pointer = xfs_rmap_estimate_write_pointer(rtg);
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
> +					xfs_rmap_estimate_write_pointer(rtg));
>  			if (error) {
>  				xfs_rtgroup_rele(rtg);
>  				goto out_free_zone_info;
> -- 
> 2.47.3
> 

With Damien's comment in place:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
