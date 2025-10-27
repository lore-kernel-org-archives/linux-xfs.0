Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF1430C609
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761581247; cv=none; b=DQ0v+sRRF9Gyq5N53NNMsz9iJ6RmgSeHZlLSb3+D3LKcopgYUlJ8qK6jbFIaZ6nTpJWLMICoWucV42RCyqepp14/qZ/mGlOZSgOH8HbL+1S0J4+z4TTzjzk7nGV09tmwByzvbAzG2npt2YON48Q8WgWnwCNROoYKvWDYJ8kn8IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761581247; c=relaxed/simple;
	bh=+8M4aVMXXOPPQiZmeTrFB//jgNjrTul4FVrqsUtROSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ampS78Goa5hOXM8jLACvikXASmPPRvs8FhEjYssBgnPGDf2gi92Vo/+b0BZ3XHWJ0D2ePOl5GXIM1tE9fysSNqp8vjewxdWDhlESeFcNwEDg0o65XcUHKIvTuILRVUBvdQju34JFkfty4ItXTcZfc00xn5NBI5aAzrc0T4FDEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1bDMmDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1bDMmDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16993C4CEF1;
	Mon, 27 Oct 2025 16:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761581247;
	bh=+8M4aVMXXOPPQiZmeTrFB//jgNjrTul4FVrqsUtROSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A1bDMmDxFjlwSB+g2GrA1NYXS70/zoRsoRKE0cvvSmHEgXQj1V9dsyWzAaXlPDbWL
	 hpLardt6RZbRRulE6NtLX4t/PImhE4aoL5237B/qvkVuloSJEHBsKdjj3mBlz7NwV/
	 7/OeQvso75n+V7c21adgsA1D9duJOIOXVvNmxBCxO2Q3BXdqLrEYlcP9Lm0T37feSl
	 P46gYzXh6VerWEV+T6S6FH8AZdTt9zHrksNGlzF7do45dZsFMg6TNGSrZ/37Z4SX0A
	 QyZmnAqRTU2I7Kao4Re62emULGNhTCA3fR3dGuCXcoeorf8DfpWp2OlvRzC8QlO69E
	 v3yQxeJk/a6Rg==
Date: Mon, 27 Oct 2025 09:07:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix overflows when converting from a count of
 groups to blocks
Message-ID: <20251027160726.GR3356773@frogsfrogsfrogs>
References: <20251027140439.812210-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027140439.812210-1-hch@lst.de>

On Mon, Oct 27, 2025 at 03:04:39PM +0100, Christoph Hellwig wrote:
> Add a xfs_group helper and a xfs_rtgroup wrapper and use that to avoid
> overflows when converting zone/rtg counts to block counts.
> 
> Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")

Cc: <stable@vger.kernel.org> # v6.15

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_group.h    | 9 +++++++++
>  fs/xfs/libxfs/xfs_rtgroup.h  | 8 ++++++++
>  fs/xfs/xfs_zone_gc.c         | 3 +--
>  fs/xfs/xfs_zone_space_resv.c | 8 +++-----
>  4 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
> index 4423932a2313..a6eabe6da4fb 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -98,6 +98,15 @@ xfs_group_max_blocks(
>  	return xg->xg_mount->m_groups[xg->xg_type].blocks;
>  }
>  
> +static inline xfs_rfsblock_t
> +xfs_groups_to_fsb(

Minor nitpicking: should these functions that return a raw fsblock count
(xfs_rfsblock_t) have a slightly different name?

xfs_groups_to_rfsb() ?

Just so that someone doesn't think the return value is a segmented
fsblock address based on a misreading of the function name...

> +	struct xfs_mount	*mp,
> +	uint32_t		nr_groups,
> +	enum xfs_group_type	type)
> +{
> +	return (xfs_rfsblock_t)mp->m_groups[type].blocks * nr_groups;
> +}
> +
>  static inline xfs_fsblock_t
>  xfs_group_start_fsb(
>  	struct xfs_group	*xg)
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index d36a6ae0abe5..a34da969bb6b 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -365,4 +365,12 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>  # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
>  #endif /* CONFIG_XFS_RT */
>  
> +static inline xfs_rfsblock_t
> +xfs_rtgs_to_rtb(

...especially since we're really not returning an rtblock here.

The additional casting is correct though.

--D

> +	struct xfs_mount	*mp,
> +	uint32_t		nr_groups)
> +{
> +	return xfs_groups_to_fsb(mp, nr_groups, XG_TYPE_RTG);
> +}
> +
>  #endif /* __LIBXFS_RTGROUP_H */
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 109877d9a6bf..c43513531200 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -179,8 +179,7 @@ xfs_zoned_need_gc(
>  	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
>  
>  	if (available <
> -	    mp->m_groups[XG_TYPE_RTG].blocks *
> -	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
> +	    xfs_rtgs_to_rtb(mp, mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
>  		return true;
>  
>  	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 9cd38716fd25..3a1a363fc8ea 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -54,12 +54,10 @@ xfs_zoned_default_resblks(
>  {
>  	switch (ctr) {
>  	case XC_FREE_RTEXTENTS:
> -		return (uint64_t)XFS_RESERVED_ZONES *
> -			mp->m_groups[XG_TYPE_RTG].blocks +
> -			mp->m_sb.sb_rtreserved;
> +		return xfs_rtgs_to_rtb(mp, XFS_RESERVED_ZONES) +
> +				mp->m_sb.sb_rtreserved;
>  	case XC_FREE_RTAVAILABLE:
> -		return (uint64_t)XFS_GC_ZONES *
> -			mp->m_groups[XG_TYPE_RTG].blocks;
> +		return xfs_rtgs_to_rtb(mp, XFS_GC_ZONES);
>  	default:
>  		ASSERT(0);
>  		return 0;
> -- 
> 2.47.3
> 
> 
