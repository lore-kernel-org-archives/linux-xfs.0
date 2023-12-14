Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A352BCF3
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaaWI0Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0539DC433C8;
	Thu, 14 Dec 2023 21:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587935;
	bh=+dWscCZOCb47NBBJuRwQahgCFmSZvQB7pt2AiD2fskw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iaaWI0Wl0cTDTWWH8vws8IGjDejacyySxH8NkkTIiNTk/wH/y1uir5AP/Gcgpplmq
	 FgBRagVeN4s/A488KtU7NW5XokzoVOwsg4PteDlt10hkHmd8Xt3hfHaGSOe2qXLv3J
	 1CFKrWW9nK6uOS49zck74cFDkDDLyVUYbbAf7MqKC1q5ga96Y2CTJF9LasCikUUqR3
	 PMKut9qkeYdDxkzId1DxKZw4GY9X+NvcNjlyzv7Qi3t9Mie2SkpPRVvcizgamhZ7h0
	 S+f2mxFosL2kAZItjGhj11MJyqCGXDxaH8By+lCD9H6j2ZxEH5wkANc+TMf76D+swF
	 FYkOdy9PlHhYw==
Date: Thu, 14 Dec 2023 13:05:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/19] xfs: factor out a xfs_rtalloc_sumlevel helper
Message-ID: <20231214210534.GB361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-15-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:33AM +0100, Christoph Hellwig wrote:
> xfs_rtallocate_extent_size has two loops with nearly identical logic
> in them.  Split that logic into a separate xfs_rtalloc_sumlevel helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty simple hoist,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 153 ++++++++++++++++++++-----------------------
>  1 file changed, 70 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index ea6f221c6a193c..2e578e726e9137 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -537,6 +537,52 @@ xfs_rtallocate_extent_near(
>  	return -ENOSPC;
>  }
>  
> +static int
> +xfs_rtalloc_sumlevel(
> +	struct xfs_rtalloc_args	*args,
> +	int			l,	/* level number */
> +	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
> +	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
> +	xfs_rtxlen_t		prod,	/* extent product factor */
> +	xfs_rtxlen_t		*len,	/* out: actual length allocated */
> +	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
> +{
> +	xfs_fileoff_t		i;	/* bitmap block number */
> +
> +	for (i = 0; i < args->mp->m_sb.sb_rbmblocks; i++) {
> +		xfs_suminfo_t	sum;	/* summary information for extents */
> +		xfs_rtxnum_t	n;	/* next rtext to be tried */
> +		int		error;
> +
> +		error = xfs_rtget_summary(args, l, i, &sum);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Nothing there, on to the next block.
> +		 */
> +		if (!sum)
> +			continue;
> +
> +		/*
> +		 * Try allocating the extent.
> +		 */
> +		error = xfs_rtallocate_extent_block(args, i, minlen, maxlen,
> +				len, &n, prod, rtx);
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		/*
> +		 * If the "next block to try" returned from the allocator is
> +		 * beyond the next bitmap block, skip to that bitmap block.
> +		 */
> +		if (xfs_rtx_to_rbmblock(args->mp, n) > i + 1)
> +			i = xfs_rtx_to_rbmblock(args->mp, n) - 1;
> +	}
> +
> +	return -ENOSPC;
> +}
> +
>  /*
>   * Allocate an extent of length minlen<=len<=maxlen, with no position
>   * specified.  If we don't get maxlen then use prod to trim
> @@ -551,12 +597,8 @@ xfs_rtallocate_extent_size(
>  	xfs_rtxlen_t		prod,	/* extent product factor */
>  	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
>  {
> -	struct xfs_mount	*mp = args->mp;
>  	int			error;
> -	xfs_fileoff_t		i;	/* bitmap block number */
>  	int			l;	/* level number (loop control) */
> -	xfs_rtxnum_t		n;	/* next rtext to be tried */
> -	xfs_suminfo_t		sum;	/* summary information for extents */
>  
>  	ASSERT(minlen % prod == 0);
>  	ASSERT(maxlen % prod == 0);
> @@ -564,46 +606,23 @@ xfs_rtallocate_extent_size(
>  
>  	/*
>  	 * Loop over all the levels starting with maxlen.
> -	 * At each level, look at all the bitmap blocks, to see if there
> -	 * are extents starting there that are long enough (>= maxlen).
> -	 * Note, only on the initial level can the allocation fail if
> -	 * the summary says there's an extent.
> +	 *
> +	 * At each level, look at all the bitmap blocks, to see if there are
> +	 * extents starting there that are long enough (>= maxlen).
> +	 *
> +	 * Note, only on the initial level can the allocation fail if the
> +	 * summary says there's an extent.
>  	 */
> -	for (l = xfs_highbit32(maxlen); l < mp->m_rsumlevels; l++) {
> -		/*
> -		 * Loop over all the bitmap blocks.
> -		 */
> -		for (i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
> -			/*
> -			 * Get the summary for this level/block.
> -			 */
> -			error = xfs_rtget_summary(args, l, i, &sum);
> -			if (error)
> -				return error;
> -			/*
> -			 * Nothing there, on to the next block.
> -			 */
> -			if (!sum)
> -				continue;
> -			/*
> -			 * Try allocating the extent.
> -			 */
> -			error = xfs_rtallocate_extent_block(args, i, maxlen,
> -					maxlen, len, &n, prod, rtx);
> -			if (error != -ENOSPC)
> -				return error;
> -			/*
> -			 * If the "next block to try" returned from the
> -			 * allocator is beyond the next bitmap block,
> -			 * skip to that bitmap block.
> -			 */
> -			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
> -				i = xfs_rtx_to_rbmblock(mp, n) - 1;
> -		}
> +	for (l = xfs_highbit32(maxlen); l < args->mp->m_rsumlevels; l++) {
> +		error = xfs_rtalloc_sumlevel(args, l, minlen, maxlen, prod, len,
> +				rtx);
> +		if (error != -ENOSPC)
> +			return error;
>  	}
> +
>  	/*
> -	 * Didn't find any maxlen blocks.  Try smaller ones, unless
> -	 * we're asking for a fixed size extent.
> +	 * Didn't find any maxlen blocks.  Try smaller ones, unless we are
> +	 * looking for a fixed size extent.
>  	 */
>  	if (minlen > --maxlen)
>  		return -ENOSPC;
> @@ -612,51 +631,19 @@ xfs_rtallocate_extent_size(
>  
>  	/*
>  	 * Loop over sizes, from maxlen down to minlen.
> -	 * This time, when we do the allocations, allow smaller ones
> -	 * to succeed.
> +	 *
> +	 * This time, when we do the allocations, allow smaller ones to succeed,
> +	 * but make sure the specified minlen/maxlen are in the possible range
> +	 * for this summary level.
>  	 */
>  	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
> -		/*
> -		 * Loop over all the bitmap blocks, try an allocation
> -		 * starting in that block.
> -		 */
> -		for (i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
> -			/*
> -			 * Get the summary information for this level/block.
> -			 */
> -			error =	xfs_rtget_summary(args, l, i, &sum);
> -			if (error)
> -				return error;
> -
> -			/*
> -			 * If nothing there, go on to next.
> -			 */
> -			if (!sum)
> -				continue;
> -			/*
> -			 * Try the allocation.  Make sure the specified
> -			 * minlen/maxlen are in the possible range for
> -			 * this summary level.
> -			 */
> -			error = xfs_rtallocate_extent_block(args, i,
> -					XFS_RTMAX(minlen, 1 << l),
> -					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
> -					len, &n, prod, rtx);
> -			if (error != -ENOSPC)
> -				return error;
> -
> -			/*
> -			 * If the "next block to try" returned from the
> -			 * allocator is beyond the next bitmap block,
> -			 * skip to that bitmap block.
> -			 */
> -			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
> -				i = xfs_rtx_to_rbmblock(mp, n) - 1;
> -		}
> +		error = xfs_rtalloc_sumlevel(args, l, XFS_RTMAX(minlen, 1 << l),
> +				XFS_RTMIN(maxlen, (1 << (l + 1)) - 1), prod,
> +				len, rtx);
> +		if (error != -ENOSPC)
> +			return error;
>  	}
> -	/*
> -	 * Got nothing, return failure.
> -	 */
> +
>  	return -ENOSPC;
>  }
>  
> -- 
> 2.39.2
> 
> 
