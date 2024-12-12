Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20431D79A0
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734039515; cv=none; b=q71ROsNxUsDJeCkwoVnQ3u/9CSGawvG5KTBFiMKkvXRrugYg4GLWw1TjHo7V15aY7E5q4idLVB2N470380fd3R0oTOEpxcivm9dVzVQulbZ/WePdTuv5WWNVfZ2z4VjveFcJj6DA2rDNaHSNtvoHw4r3wp3WrD0HRypx7XEbfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734039515; c=relaxed/simple;
	bh=8PfkWwLt7uNLe7RCD/yodigaAyOXSvv1IUW3XtRF76o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iw47HcC5aMDgMlqh6LwVbQFt3rpXZt1BTJa3xHqCUehQvYZ7F1EfuGlnfGO2zfrITLGTU9fY5BaoexPlCaEo7RC8LRngG5i526K9HFZxnMk1B470iqcz6aT/7dLqJzkVeebXS37qTET8LeHSICoCv3h+E2wGzh/oq1j/RHmE8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKvEWezO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKvEWezO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB9BC4CECE;
	Thu, 12 Dec 2024 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734039514;
	bh=8PfkWwLt7uNLe7RCD/yodigaAyOXSvv1IUW3XtRF76o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nKvEWezO9c71HXZN0fAQoZ+LpbwavsjDsm7NCKIZyts45IFaSrmI3c+jQ1d3UIDb2
	 9PQVZ7OPwFl4NtDsd8YA8oyIrjE0O5E5clcoCnBEHUKHmXTlF+cC44+6acS2otrvuX
	 qjawyxXiOeAF0q4yylotTS4vkRzLPMP9WKoQeGYH+UsyXP6QZPF4tvqrVDqLGnzrDo
	 FobfIUX1Vgv0BQapJ6v6UBJm95tAxglGxuRzaE2eh+pq8SLahKWBAWWHfwsgm9Vg/9
	 mH6agP8pAVtIHZi3rMlx+H35AXRrJkwZNpPM7Lo6VePEt4JGmrKiI+PG4451RVqBta
	 s7L9GD1Xm04bg==
Date: Thu, 12 Dec 2024 13:38:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/43] xfs: preserve RT reservations across remounts
Message-ID: <20241212213833.GV6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-11-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:35AM +0100, Christoph Hellwig wrote:
> From: Hans Holmberg <hans.holmberg@wdc.com>
> 
> Introduce a reservation setting for rt devices so that zoned GC
> reservations are preserved over remount ro/rw cycles.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_mount.c | 22 +++++++++++++++-------
>  fs/xfs/xfs_mount.h |  3 ++-
>  fs/xfs/xfs_super.c |  2 +-
>  3 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 4174035b2ac9..db910ecc1ed4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -465,10 +465,15 @@ xfs_mount_reset_sbqflags(
>  }
>  
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
> @@ -683,6 +688,7 @@ xfs_mountfs(
>  	uint			quotamount = 0;
>  	uint			quotaflags = 0;
>  	int			error = 0;
> +	int			i;
>  
>  	xfs_sb_mount_common(mp, sbp);
>  
> @@ -1051,18 +1057,20 @@ xfs_mountfs(
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
> +		for (i = 0; i < XC_FREE_NR; i++) {
> +			error = xfs_reserve_blocks(mp, i,
> +					xfs_default_resblks(mp, i));
> +			if (error)
> +				xfs_warn(mp,
>  	"Unable to allocate reserve blocks. Continuing without reserve pool.");

Should we be able to log *which* reserve block pool is out?

Otherwise looks good to me.

--D

> +		}
>  
>  		/* Reserve AG blocks for future btree expansion. */
>  		error = xfs_fs_reserve_ag_blocks(mp);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index d92bce7bc184..73bc053fdd17 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -640,7 +640,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
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
> index 1960ee0aad45..f57c27940467 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -944,7 +944,7 @@ xfs_restore_resvblks(
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
