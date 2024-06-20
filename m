Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E321BBBC7
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718908835; cv=none; b=TD7k7qqcY02dYfi6hgUv4fg87fFuIxllWRuLTH3ZPWia4bVEnljLELj+OU0nulapk/bBs+0IkR0s4yYVO8yeeY/7nialDU6QiKaRFPvSuUqaUXu810ZnxbEWg5BO43VVBotxKpcaM6SIN3It1lLy04RsDEjBg6s2u1X1hBhyV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718908835; c=relaxed/simple;
	bh=QKKNnzbEfbOzIO6+G3fEdwR4jGQACbs3szfgsorh9Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNbPD2jgRkIk7fFP8zNLe3iDPNE1zCWHKKhReUVLyZGtsletbE6DYfBGJ42pcFhmWsIhe2NwFfFvlY0fjz93f4TXRgvJEACG46DW6ASvY3BTiO70CUqi1CAaxFLpe8KmMYw2wr6MUBbBshfS2oON8QtF/WDoiKatml5EPuQkfLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ex6/uMDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ex6/uMDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A7C2BD10;
	Thu, 20 Jun 2024 18:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718908834;
	bh=QKKNnzbEfbOzIO6+G3fEdwR4jGQACbs3szfgsorh9Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ex6/uMDfeVfXMdTWWY8WmWshrc2eN6WKJ7Lti+q3fggQKqTZiX9je0lT4oMwog1DJ
	 DQAbc7ubBqk1S7SFWH0D+lPaN78zoG2J5q8ziER1vS5PVWSRFNfavfNXKGLHkuLHXT
	 xBnv8e+6eO8oMJ0Rhrt/teqvqy2b3YmIrIqyxt/HMdiqJWoAA5Gcxak4Tu/MpjSiYm
	 O9WXsW9icmqkFz71ljUsX5K+5WPc7iY6Xsrr1dH97DLK3yZhoE/y/QMiSg2/fl43ur
	 X1+cSdlAwo8sCguMEuPWgXK1/ELWAdIs1IL+2zOiRwGFBErhnya67k2jk034eHRlN8
	 E9MsTWuum2hYQ==
Date: Thu, 20 Jun 2024 11:40:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: move the dio write relocking out of
 xfs_ilock_for_iomap
Message-ID: <20240620184034.GY103034@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619115426.332708-2-hch@lst.de>

On Wed, Jun 19, 2024 at 01:53:51PM +0200, Christoph Hellwig wrote:
> About half of xfs_ilock_for_iomap deals with a special case for direct
> I/O writes to COW files that need to take the ilock exclusively.  Move
> this code into the one callers that cares and simplify
> xfs_ilock_for_iomap.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It took me a few minutes to sort this out, but yeah, directio writes are
the only place where we do this shared->cow->excl promotion dance.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 71 ++++++++++++++++++++++------------------------
>  1 file changed, 34 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3783426739258c..b0085e5972393a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -717,53 +717,30 @@ imap_needs_cow(
>  	return true;
>  }
>  
> +/*
> + * Extents not yet cached requires exclusive access, don't block for
> + * IOMAP_NOWAIT.
> + *
> + * This is basically an opencoded xfs_ilock_data_map_shared() call, but with
> + * support for IOMAP_NOWAIT.
> + */
>  static int
>  xfs_ilock_for_iomap(
>  	struct xfs_inode	*ip,
>  	unsigned		flags,
>  	unsigned		*lockmode)
>  {
> -	unsigned int		mode = *lockmode;
> -	bool			is_write = flags & (IOMAP_WRITE | IOMAP_ZERO);
> -
> -	/*
> -	 * COW writes may allocate delalloc space or convert unwritten COW
> -	 * extents, so we need to make sure to take the lock exclusively here.
> -	 */
> -	if (xfs_is_cow_inode(ip) && is_write)
> -		mode = XFS_ILOCK_EXCL;
> -
> -	/*
> -	 * Extents not yet cached requires exclusive access, don't block.  This
> -	 * is an opencoded xfs_ilock_data_map_shared() call but with
> -	 * non-blocking behaviour.
> -	 */
> -	if (xfs_need_iread_extents(&ip->i_df)) {
> -		if (flags & IOMAP_NOWAIT)
> -			return -EAGAIN;
> -		mode = XFS_ILOCK_EXCL;
> -	}
> -
> -relock:
>  	if (flags & IOMAP_NOWAIT) {
> -		if (!xfs_ilock_nowait(ip, mode))
> +		if (xfs_need_iread_extents(&ip->i_df))
> +			return -EAGAIN;
> +		if (!xfs_ilock_nowait(ip, *lockmode))
>  			return -EAGAIN;
>  	} else {
> -		xfs_ilock(ip, mode);
> +		if (xfs_need_iread_extents(&ip->i_df))
> +			*lockmode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, *lockmode);
>  	}
>  
> -	/*
> -	 * The reflink iflag could have changed since the earlier unlocked
> -	 * check, so if we got ILOCK_SHARED for a write and but we're now a
> -	 * reflink inode we have to switch to ILOCK_EXCL and relock.
> -	 */
> -	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_cow_inode(ip)) {
> -		xfs_iunlock(ip, mode);
> -		mode = XFS_ILOCK_EXCL;
> -		goto relock;
> -	}
> -
> -	*lockmode = mode;
>  	return 0;
>  }
>  
> @@ -801,7 +778,7 @@ xfs_direct_write_iomap_begin(
>  	int			nimaps = 1, error = 0;
>  	bool			shared = false;
>  	u16			iomap_flags = 0;
> -	unsigned int		lockmode = XFS_ILOCK_SHARED;
> +	unsigned int		lockmode;
>  	u64			seq;
>  
>  	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
> @@ -817,10 +794,30 @@ xfs_direct_write_iomap_begin(
>  	if (offset + length > i_size_read(inode))
>  		iomap_flags |= IOMAP_F_DIRTY;
>  
> +	/*
> +	 * COW writes may allocate delalloc space or convert unwritten COW
> +	 * extents, so we need to make sure to take the lock exclusively here.
> +	 */
> +	if (xfs_is_cow_inode(ip))
> +		lockmode = XFS_ILOCK_EXCL;
> +	else
> +		lockmode = XFS_ILOCK_SHARED;
> +
> +relock:
>  	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
>  	if (error)
>  		return error;
>  
> +	/*
> +	 * The reflink iflag could have changed since the earlier unlocked
> +	 * check, check if it again and relock if needed.
> +	 */
> +	if (xfs_is_cow_inode(ip) && lockmode == XFS_ILOCK_SHARED) {
> +		xfs_iunlock(ip, lockmode);
> +		lockmode = XFS_ILOCK_EXCL;
> +		goto relock;
> +	}
> +
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
>  			       &nimaps, 0);
>  	if (error)
> -- 
> 2.43.0
> 
> 
