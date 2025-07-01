Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A5427CCE7
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388182; cv=none; b=lMZMFKsbNsGODL3/QirJfit6idqzmZvpujoIEoVT0dPiVri+WZ7yEVkcCVkcfDMbRB6W1kWzXmf1FT8BsNX87ICNuFm7NgMG57VjfG9pVBDD3bX0sUP6tbQE0l6dQ6qJmJJcRIsfZ2ZF1yznNVm4CbLrm/6ZBivBS4p1hNXog2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388182; c=relaxed/simple;
	bh=yf5OwzYJft3AdnzQQtbtJT/ZkHXWTXxcYiVhDi3Pf2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lc4F599UfsLFJNAY+E0kr08Sv5c65iIDaf/5lELLAZ4qnVq/CUHXHRm59CkOklF6yeNVT/xO45keC4P65YZ8uYwPqZgGjxt/A0Vq74qh5mePYf88ji/g9BbgVSLzyy4VxVW/eWBDtkNM3dfbaUfDQdseCWOJ+tgFyYB5ifVhB2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwfGhFTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwfGhFTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F69C4CEEB;
	Tue,  1 Jul 2025 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751388181;
	bh=yf5OwzYJft3AdnzQQtbtJT/ZkHXWTXxcYiVhDi3Pf2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rwfGhFThSdvkUm2e9oV81IoPzuIP87okpiWX0ND4ogbY1DAdaDzpAZmlKhKAZaiqV
	 vLe5IseFqT12Yu66MuVueJnYcuempBecquIxyw4G4aKOMGhqt+wOe0f3U7CoMii93X
	 p+2og+6red8MkkKdmsJPCRuqyyhBiea1IgNb0C5cjfyMGCFGCyoFWNoGxdKdD50lAA
	 7WRPX+ZWcfEk9sKSu03TkOmERLIBPXIDojcUkDNcZOnB4YuDahnMnEEa7OKFo9PyeS
	 vaZl49stT/N2F8odx1UWNm26HAXW/Kzhh6jmPiC5QiOGK7th8GnqwQFUyNkGoHjMOe
	 fttG2kYZXCoHA==
Date: Tue, 1 Jul 2025 09:43:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: clean up the initial read logic in xfs_readsb
Message-ID: <20250701164301.GF10009@frogsfrogsfrogs>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-2-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:35PM +0200, Christoph Hellwig wrote:
> The initial sb read is always for a device logical block size
> buffer.  The device logical block size is provided in the
> bt_logical_sectorsize in struct buftarg, so use that instead of the
> confusingly named xfs_getsize_buftarg buffer that reads it from the bdev.
> 
> Update the comments surrounding the code to better describe what is going
> on.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.h   |  1 -
>  fs/xfs/xfs_mount.c | 21 +++++++++++----------
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 15fc56948346..73a9686110e8 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -375,7 +375,6 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
>  int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize);
>  
> -#define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
>  
>  int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 29276fe60df9..047100b080aa 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -171,19 +171,16 @@ xfs_readsb(
>  	ASSERT(mp->m_ddev_targp != NULL);
>  
>  	/*
> -	 * For the initial read, we must guess at the sector
> -	 * size based on the block device.  It's enough to
> -	 * get the sb_sectsize out of the superblock and
> -	 * then reread with the proper length.
> -	 * We don't verify it yet, because it may not be complete.
> +	 * In the first pass, use the device sector size to just read enough
> +	 * of the superblock to extract the XFS sector size.
> +	 *
> +	 * The device sector size must be smaller than or equal to the XFS
> +	 * sector size and thus we can always read the superblock.  Once we know
> +	 * the XFS sector size, re-read it and run the buffer verifier.
>  	 */
> -	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
> +	sector_size = mp->m_ddev_targp->bt_logical_sectorsize;
>  	buf_ops = NULL;
>  
> -	/*
> -	 * Allocate a (locked) buffer to hold the superblock. This will be kept
> -	 * around at all times to optimize access to the superblock.
> -	 */
>  reread:
>  	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
>  				      BTOBB(sector_size), &bp, buf_ops);
> @@ -247,6 +244,10 @@ xfs_readsb(
>  	/* no need to be quiet anymore, so reset the buf ops */
>  	bp->b_ops = &xfs_sb_buf_ops;
>  
> +	/*
> +	 * Keep a pointer of the sb buffer around instead of caching it in the
> +	 * buffer cache because we access it frequently.
> +	 */
>  	mp->m_sb_bp = bp;
>  	xfs_buf_unlock(bp);
>  	return 0;
> -- 
> 2.47.2
> 
> 
