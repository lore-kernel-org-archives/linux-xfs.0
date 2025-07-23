Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689092E36F0
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 16:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753287684; cv=none; b=qrBdyfs65yvLcHi4Fl1qRGzOyGzhswgfktnxXOlUa+SnBaF1lvFklzfUmNm895uBVb8ItqNRDEb9TqSDrfomVaco3OzCxtHFc4nNCZyngud4OKa+0HrW3y/r35gAcJeuvbIfBO+kEy2hXCyhI9/qA2e8NzXP+dVNWFrtok7+N04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753287684; c=relaxed/simple;
	bh=BBvmuYSwPLR5MNr7W6wCmnL0/VX4JRswHlD3U4CCnKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SuKINWS+TMUZ4sWSNfaiu+K0zc9KcaGdnfzkgu5wsecSvpDx5hEPTA/Y2wPZ0ep2g+PutjtlI3ZIS+xk+V92hItuhE2jelzNMfVivVNB+uE1yEB8Z31gWtrzjDGGvENbUj0Cl3FnMEXtAaflWpblbLF2ur9pZTT0L/6JPY+33DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F82dVVAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F82dVVAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF041C4CEE7;
	Wed, 23 Jul 2025 16:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753287683;
	bh=BBvmuYSwPLR5MNr7W6wCmnL0/VX4JRswHlD3U4CCnKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F82dVVAxX06KGB5pEN/nhicBwOpAFcpUOW+fRmRT1yw6M3HwryXTirTn4g93dOM9x
	 aaIN5BlziYTIcpes+OdxKkrBMnu/fouK5Q+MDxXZD5Mi8auckyUhx1G3Udb1uj/Oxe
	 TsashDmG8dwVEHD5ibp5Fq4xNDMs4HUcrgYMS4IpeHmXwB069HO8EsNnAdc2DbH69h
	 gjLyJVJYAgLtUqdk0ssw+FG98FSZA+pBm3ORDVjvP3OgzzFX2af6Wi32BoC4HNdeNK
	 s+Z/RRJIgZ8eErgCT4o1c6mY6VR5kCnECTpQVureiPTVUHoLi7OK2BvX2CGzhxeQDg
	 YUKrDCp6i/wpA==
Date: Wed, 23 Jul 2025 09:21:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, cen zhang <zzzccc427@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove XFS_IBULK_SAME_AG
Message-ID: <20250723162123.GY2672049@frogsfrogsfrogs>
References: <20250723122011.3178474-1-hch@lst.de>
 <20250723122011.3178474-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723122011.3178474-3-hch@lst.de>

On Wed, Jul 23, 2025 at 02:19:45PM +0200, Christoph Hellwig wrote:
> Add a new field to struct xfs_ibulk to directly pass XFS_IWALK* flags,
> and thus remove the need to indirect the SAME_AG flag through
> XFS_IBULK*.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that clears things up :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl.c  |  2 +-
>  fs/xfs/xfs_itable.c | 12 ++----------
>  fs/xfs/xfs_itable.h | 10 ++++------
>  3 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index fe1f74a3b6a3..e1051a530a50 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -219,7 +219,7 @@ xfs_bulk_ireq_setup(
>  		else if (XFS_INO_TO_AGNO(mp, breq->startino) < hdr->agno)
>  			return -EINVAL;
>  
> -		breq->flags |= XFS_IBULK_SAME_AG;
> +		breq->iwalk_flags |= XFS_IWALK_SAME_AG;
>  
>  		/* Asking for an inode past the end of the AG?  We're done! */
>  		if (XFS_INO_TO_AGNO(mp, breq->startino) > hdr->agno)
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 5116842420b2..2aa37a4d2706 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -307,7 +307,6 @@ xfs_bulkstat(
>  		.breq		= breq,
>  	};
>  	struct xfs_trans	*tp;
> -	unsigned int		iwalk_flags = 0;
>  	int			error;
>  
>  	if (breq->idmap != &nop_mnt_idmap) {
> @@ -328,10 +327,7 @@ xfs_bulkstat(
>  	 * locking abilities to detect cycles in the inobt without deadlocking.
>  	 */
>  	tp = xfs_trans_alloc_empty(breq->mp);
> -	if (breq->flags & XFS_IBULK_SAME_AG)
> -		iwalk_flags |= XFS_IWALK_SAME_AG;
> -
> -	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
> +	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->iwalk_flags,
>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>  	xfs_trans_cancel(tp);
>  	kfree(bc.buf);
> @@ -447,21 +443,17 @@ xfs_inumbers(
>  		.breq		= breq,
>  	};
>  	struct xfs_trans	*tp;
> -	unsigned int		iwalk_flags = 0;
>  	int			error = 0;
>  
>  	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
>  		return 0;
>  
> -	if (breq->flags & XFS_IBULK_SAME_AG)
> -		iwalk_flags |= XFS_IWALK_SAME_AG;
> -
>  	/*
>  	 * Grab an empty transaction so that we can use its recursive buffer
>  	 * locking abilities to detect cycles in the inobt without deadlocking.
>  	 */
>  	tp = xfs_trans_alloc_empty(breq->mp);
> -	error = xfs_inobt_walk(breq->mp, tp, breq->startino, iwalk_flags,
> +	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->iwalk_flags,
>  			xfs_inumbers_walk, breq->icount, &ic);
>  	xfs_trans_cancel(tp);
>  
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index f10e8f8f2335..2d0612f14d6e 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -13,17 +13,15 @@ struct xfs_ibulk {
>  	xfs_ino_t		startino; /* start with this inode */
>  	unsigned int		icount;   /* number of elements in ubuffer */
>  	unsigned int		ocount;   /* number of records returned */
> -	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
> +	unsigned int		flags;    /* XFS_IBULK_FLAG_* */
> +	unsigned int		iwalk_flags; /* XFS_IWALK_FLAG_* */
>  };
>  
> -/* Only iterate within the same AG as startino */
> -#define XFS_IBULK_SAME_AG	(1U << 0)
> -
>  /* Fill out the bs_extents64 field if set. */
> -#define XFS_IBULK_NREXT64	(1U << 1)
> +#define XFS_IBULK_NREXT64	(1U << 0)
>  
>  /* Signal that we can return metadata directories. */
> -#define XFS_IBULK_METADIR	(1U << 2)
> +#define XFS_IBULK_METADIR	(1U << 1)
>  
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
> -- 
> 2.47.2
> 
> 
