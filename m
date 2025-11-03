Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941E31815E
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762189266; cv=none; b=pkquGz8jBL6SS9w1j4KOlh03QDHVdvg+ZtzSH7yineD49aLbiZh0T3QhW68JEiaKRmU6dAmdHk9kVZRD2/26jsKVkB64JEnFC6rDL88GmD1rvFr3LeNtTjbcbdlTg9ADQJYd8nWJCLCRlqe6GHv5X8/OeurkHmSs/wYLiQQ8dYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762189266; c=relaxed/simple;
	bh=mT4NUltDMSWTIMjqc0khKyRqUEjD6e1SZOQNzwF9iyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqLi+/sF2wNjux4hYHWLa9/MWj2P3thV0jgyP7Qwxq9GUaJR6+Jn4wzWuy9iJ7Dt1sIJV3r2yEhQOxzdMD0cB9wtJPBLH2num+pgpwEdM6plk7FEoaIkVB1t6qflgm1ZOYX3TQqJeSLqYG0BdSFQJAQ3Pg4YWdP50KGon5ZNrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C61DbEPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C61DbEPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDD6C4CEE7;
	Mon,  3 Nov 2025 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189266;
	bh=mT4NUltDMSWTIMjqc0khKyRqUEjD6e1SZOQNzwF9iyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C61DbEPuJfZcXSBzuuM1LZWu+7mBgNa6E8tj0OVIz1NI6CdF1exTrTUtB7IwBp2EF
	 4W+HcueSnHukIb/+61Szz0VJdPaDyFofml48uGmZLDKGE4kGFK9zID/cIhX0z7T0QF
	 d+9TUbZWiex2RSrZ0C7kVDX++ZuJSS4M1TEfgnSXa7ZrU1ioxUa3EOHa+Fc9gl2BYz
	 OetJqGURHa3Xi6mwwpyVDkf8wgJ8f4Hs+f+sw/yHEUihyUfVBJJ0VvI9FP9tJ6jSIQ
	 UrtacOsC4ZIAa10Ij7vceTWvauYqJAF02ORkOw8eaxL+3hYSmdKVMIJ2Y2Y39T0jwL
	 aBRHK5FouD4UA==
Date: Mon, 3 Nov 2025 09:01:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a xfs_groups_to_rfsbs helper
Message-ID: <20251103170105.GA196370@frogsfrogsfrogs>
References: <20251103101419.2082953-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103101419.2082953-1-hch@lst.de>

On Mon, Nov 03, 2025 at 05:14:09AM -0500, Christoph Hellwig wrote:
> Plus a rtgroup wrapper and use that to avoid overflows when converting
> zone/rtg counts to block counts.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v1:
>  - new names

Woot, thanks for refactoring this!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
>  fs/xfs/libxfs/xfs_group.h    | 9 +++++++++
>  fs/xfs/libxfs/xfs_rtgroup.h  | 8 ++++++++
>  fs/xfs/xfs_zone_gc.c         | 3 +--
>  fs/xfs/xfs_zone_space_resv.c | 8 +++-----
>  4 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
> index 4423932a2313..4ae638f1c2c5 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -98,6 +98,15 @@ xfs_group_max_blocks(
>  	return xg->xg_mount->m_groups[xg->xg_type].blocks;
>  }
>  
> +static inline xfs_rfsblock_t
> +xfs_groups_to_rfsbs(
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
> index d4fcf591e63d..a94e925ae67c 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -371,4 +371,12 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>  # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
>  #endif /* CONFIG_XFS_RT */
>  
> +static inline xfs_rfsblock_t
> +xfs_rtgs_to_rfsbs(
> +	struct xfs_mount	*mp,
> +	uint32_t		nr_groups)
> +{
> +	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
> +}
> +
>  #endif /* __LIBXFS_RTGROUP_H */
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 4ade54445532..a98939aba7b9 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -181,8 +181,7 @@ xfs_zoned_need_gc(
>  	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
>  
>  	if (available <
> -	    mp->m_groups[XG_TYPE_RTG].blocks *
> -	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
> +	    xfs_rtgs_to_rfsbs(mp, mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
>  		return true;
>  
>  	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 9cd38716fd25..0e54e557a585 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -54,12 +54,10 @@ xfs_zoned_default_resblks(
>  {
>  	switch (ctr) {
>  	case XC_FREE_RTEXTENTS:
> -		return (uint64_t)XFS_RESERVED_ZONES *
> -			mp->m_groups[XG_TYPE_RTG].blocks +
> -			mp->m_sb.sb_rtreserved;
> +		return xfs_rtgs_to_rfsbs(mp, XFS_RESERVED_ZONES) +
> +				mp->m_sb.sb_rtreserved;
>  	case XC_FREE_RTAVAILABLE:
> -		return (uint64_t)XFS_GC_ZONES *
> -			mp->m_groups[XG_TYPE_RTG].blocks;
> +		return xfs_rtgs_to_rfsbs(mp, XFS_GC_ZONES);
>  	default:
>  		ASSERT(0);
>  		return 0;
> -- 
> 2.47.3
> 
> 
