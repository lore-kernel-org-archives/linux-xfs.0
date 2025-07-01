Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947ED27780E
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381730; cv=none; b=CKWUozgAD4ofu+IlppBeJ7gJlBVGsWAHmP8tHsY3nz8MAii82rz4zZAHWAsCxFY5PRZx74A5u2BHVoom+XCEkbeyIIOCIPuKJe1ICPhkNFJqDz/ifsCD3DOPokhlL4ZI0r1Xs/1fgGMXnRdMMmSeB7C+HvCPXGjZjDxgKrX+UTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381730; c=relaxed/simple;
	bh=V29b99tdC/Ml7Etfp1YgEy8ojEI2z6kqI4ug/YslydM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAbkqs8mXCXwF5c0ggEIMO3e4WWCQsRjOLziggkxHtxy0NukJ1nys7QuOt9ja5vBrlgpyNfYh4MrJAfUZZxxdIeui/GfnshAqesRDko2Xq3xSzDCiGFgIuzPENWkVuyPmqmVKSU4isay576M+fS5/TnEISVOLnip4SjyN/s/Arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXKJJvYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXKJJvYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D88BC4CEEB;
	Tue,  1 Jul 2025 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751381730;
	bh=V29b99tdC/Ml7Etfp1YgEy8ojEI2z6kqI4ug/YslydM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bXKJJvYKQzT67tQJBFnUVEjNLPVFYpSxRjor2ethQujUJcgG6vJd8/fo17CtDVuqV
	 veSyhcxs/CzExYc8ZDcWsDEy6bg7M6w8R5gGpghk8rJ2kkCoqu4Wf+v21cFvv+l7yE
	 wuzOE0qErt9aX6ig7YhA74YwsPAC72tycz0isCeazuhCwTwEde0Tk+iXybqe3h0kcU
	 YJ0qZCq0l1/bdajsCFqI5ZqlwE63aqpTkBDMcAP6ExYfc8RfLLjsQtCq2sOKH02xNf
	 GFrGCS1E7uEs7Dszwuqy1u3pRCbg6vrhJyGLRalGTp8zOwRO3ZkU/SDdy44t/qOeLT
	 vGcDg2vqvDRSw==
Date: Tue, 1 Jul 2025 07:55:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: clean up the initial read logic in xfs_readsb
Message-ID: <20250701145529.GD10009@frogsfrogsfrogs>
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617105238.3393499-2-hch@lst.de>

On Tue, Jun 17, 2025 at 12:51:59PM +0200, Christoph Hellwig wrote:
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
> index 9d2ab567cf81..294dd9d61dbb 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -376,7 +376,6 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
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
