Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF079136352
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872870; cv=none; b=ZqBBGY4oEPpKOTgM8AoT87aqotpsYA8DJMsulA2ctoiK216/6oxnV4bl8AwqjCmJhIaBuUvsFRtXW0PbNet0chNrr5cTSYMtvhm1HgyJcT/jJzyhWuVj1RImADw2xHZ4YuQUfGpsxIyq+E/bBAQ+2GlH0maOS8QNykkhOka3EY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872870; c=relaxed/simple;
	bh=rWeJJThdAll/VPgO9IjjQENDwt0YSbdYCfri8q6NBFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTwAVvW3qfcGBkeewDjdU/u412AaKoLs/q6Eqw0cjVY/VWPmTOv4NxNtgKdzwBkOynomXQGmcxmTym5Pxz76BBwuz6rycAdRqci+jMSuG9klXm+eDPCrkElb5eSA/REh9MWKc4DZvDwVyWWkxiQpe9+RoJqW5fPwUBkmXQWpdbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YT4/c3PP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YT4/c3PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2859AC4CEDD;
	Thu,  6 Feb 2025 20:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738872870;
	bh=rWeJJThdAll/VPgO9IjjQENDwt0YSbdYCfri8q6NBFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YT4/c3PPO6KGgViincqoxjDKSbSKWG4fjfkzgeH6so1t74CNZalefa91RWvicaZ60
	 6cuCI0YQi4AZYde3bsztD0jjx3Sz56pJ8i+UwT4Egbhx2rdOCVrwrXzbyBMO4T4QJr
	 ZOZjSxzeZrOwkPglni3ulUfw31EcZKVCHoygrrNGVQamJC3T5IkGjojrLy8lJO1zeB
	 Hdifa4YkJwz3cGjH2RsCW75V1ffZ2KXG9OQsLfe8SEQ0mjrlyTxg95xDDNPkTctPue
	 g6PFZS+s/03ZJkOhO9oZ6vL4cZyscXvvnEn+bXLFYgJq61T5UtZ2J5d0rvjI+oyY0l
	 S+HWOpG8miN7Q==
Date: Thu, 6 Feb 2025 12:14:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/43] xfs: preserve RT reservations across remounts
Message-ID: <20250206201429.GI21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-8-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:23AM +0100, Christoph Hellwig wrote:
> From: Hans Holmberg <hans.holmberg@wdc.com>
> 
> Introduce a reservation setting for rt devices so that zoned GC
> reservations are preserved over remount ro/rw cycles.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_mount.c | 30 ++++++++++++++++++++++--------
>  fs/xfs/xfs_mount.h |  3 ++-
>  fs/xfs/xfs_super.c |  2 +-
>  3 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index b81a03b3133d..26793d4f2707 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -464,11 +464,21 @@ xfs_mount_reset_sbqflags(
>  	return xfs_sync_sb(mp, false);
>  }
>  
> +static const char *const xfs_free_pool_name[] = {
> +	[XC_FREE_BLOCKS]	= "free blocks",
> +	[XC_FREE_RTEXTENTS]	= "free rt extents",
> +};
> +
>  uint64_t
> -xfs_default_resblks(xfs_mount_t *mp)
> +xfs_default_resblks(
> +	struct xfs_mount	*mp,
> +	enum xfs_free_counter	ctr)
>  {
>  	uint64_t resblks;
>  
> +	if (ctr == XC_FREE_RTEXTENTS)
> +		return 0;
> +
>  	/*
>  	 * We default to 5% or 8192 fsbs of space reserved, whichever is
>  	 * smaller.  This is intended to cover concurrent allocation
> @@ -681,6 +691,7 @@ xfs_mountfs(
>  	uint			quotamount = 0;
>  	uint			quotaflags = 0;
>  	int			error = 0;
> +	int			i;
>  
>  	xfs_sb_mount_common(mp, sbp);
>  
> @@ -1049,18 +1060,21 @@ xfs_mountfs(
>  	 * privileged transactions. This is needed so that transaction
>  	 * space required for critical operations can dip into this pool
>  	 * when at ENOSPC. This is needed for operations like create with
> -	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
> -	 * are not allowed to use this reserved space.
> +	 * attr, unwritten extent conversion at ENOSPC, garbage collection
> +	 * etc. Data allocations are not allowed to use this reserved space.
>  	 *
>  	 * This may drive us straight to ENOSPC on mount, but that implies
>  	 * we were already there on the last unmount. Warn if this occurs.
>  	 */
>  	if (!xfs_is_readonly(mp)) {
> -		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS,
> -				xfs_default_resblks(mp));
> -		if (error)
> -			xfs_warn(mp,
> -	"Unable to allocate reserve blocks. Continuing without reserve pool.");
> +		for (i = 0; i < XC_FREE_NR; i++) {
> +			error = xfs_reserve_blocks(mp, i,
> +					xfs_default_resblks(mp, i));
> +			if (error)
> +				xfs_warn(mp,
> +"Unable to allocate reserve blocks. Continuing without reserve pool for %s.",
> +					xfs_free_pool_name[i]);
> +		}
>  
>  		/* Reserve AG blocks for future btree expansion. */
>  		error = xfs_fs_reserve_ag_blocks(mp);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 300ffefb2abd..2d0e34e517b1 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -647,7 +647,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  }
>  
>  extern void	xfs_uuid_table_free(void);
> -extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
> +uint64_t	xfs_default_resblks(struct xfs_mount *mp,
> +			enum xfs_free_counter ctr);
>  extern int	xfs_mountfs(xfs_mount_t *mp);
>  extern void	xfs_unmountfs(xfs_mount_t *);
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f0b0d8320c51..5c9a2a0826ff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -947,7 +947,7 @@ xfs_restore_resvblks(
>  			resblks = mp->m_resblks[i].save;
>  			mp->m_resblks[i].save = 0;
>  		} else
> -			resblks = xfs_default_resblks(mp);
> +			resblks = xfs_default_resblks(mp, i);
>  		xfs_reserve_blocks(mp, i, resblks);
>  	}
>  }
> -- 
> 2.45.2
> 
> 
