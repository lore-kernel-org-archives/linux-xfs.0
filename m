Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363C2282E7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0Rm+9kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72B2C433C7;
	Thu, 14 Dec 2023 21:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702589541;
	bh=/Z6kA/SGzwGSU0QNVKCchF6SRlyJe1IID6hDIOSJyik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M0Rm+9kRwJAY0/5Chak2ZV/CLZAs1KtibMiJMI9U30l0a8A7ycLFOhuErgyFD0fnn
	 SFYtY17LDl3QFhwaCVtwxRCfnSAPTAZXSZK5mHeKrDv/TnmJrbEVn2+tSuRoYWPFYs
	 Gonz0aDrVMYo+Wd0T/WC0/4jghFpLTDdiqgIJ7YS4pBYA7CHb2U9XK/Hz7dNkOeLcz
	 kXS7a0cruMJxRc9ZYKQciBb9DOtgFFwIVisr3+8ajp/slcLwoP0tPHTFTtPie6GwbS
	 gURAKoL+8tVUNPOJwR64kfnAToRUHIkH4C/1ITe/U1UBolta0w+ffnduz7l0zDa7eE
	 jDYaGrcC59XPQ==
Date: Thu, 14 Dec 2023 13:32:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/19] xfs: simplify and optimize the RT allocation
 fallback cascade
Message-ID: <20231214213221.GH361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-19-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:37AM +0100, Christoph Hellwig wrote:
> There are currently multiple levels of fall back if an RT allocation
> can not be satisfied:
> 
>  1) xfs_rtallocate_extent extents the minlen and reduces the maxlen due

                            ^^^^^^^ extends?

>     to the extent size hint.  If that can't be done, it return -ENOSPC
>     and let's xfs_bmap_rtalloc retry, which then not only drops the
>     extent size hint based alignment, but also the minlen adjustment
>  2) if xfs_rtallocate_extent gets -ENOSPC from the underlying functions,
>     it only drops the extent size hint based alignment and retries
>  3) if that still does not succeed, xfs_rtallocate_extent drops the
>     extent size hint (which is a complex no-op at this point) and the
>     minlen using the same code as (1) above
>  4) if that still doesn't success and the caller wanted an allocation
>     near a blkno, drop that blkno hint.
> 
> The handling in 1 is rather inefficient as we could just drop the
> alignment and continue, and 2/3 interact in really weird ways due to
> the duplicate policy.
> 
> Move aligning the min and maxlen out of xfs_rtallocate_extent and into
> a helper called directly by xfs_bmap_rtalloc.  This allows just
> continuing with the allocation if we have to drop the alignment instead
> of going through the retry loop and also dropping the perfectly the
> minlen adjustment that didn't cause the problem, and then just use

"...dropping the perfectly *usable* minlen adjustment..." ?

> a single retry that drops both the minlen and alignment requirement
> when we really are out of space, thus consolidating cases (2) and (3)
> above.

How can we drop the minlen requirement, won't that result in undersize
mapping allocations?  Or is the subtlety here that for realtime files,
that's ok because we never have forced multi-rtx allocations like we do
for the data device?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 58 ++++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 595740d18dc4c3..16255617629ef5 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1088,21 +1088,6 @@ xfs_rtallocate_extent(
>  	ASSERT(xfs_isilocked(args.mp->m_rbmip, XFS_ILOCK_EXCL));
>  	ASSERT(minlen > 0 && minlen <= maxlen);
>  
> -	/*
> -	 * If prod is set then figure out what to do to minlen and maxlen.
> -	 */
> -	if (prod > 1) {
> -		xfs_rtxlen_t	i;
> -
> -		if ((i = maxlen % prod))
> -			maxlen -= i;
> -		if ((i = minlen % prod))
> -			minlen += prod - i;
> -		if (maxlen < minlen)
> -			return -ENOSPC;
> -	}
> -
> -retry:
>  	if (start == 0) {
>  		error = xfs_rtallocate_extent_size(&args, minlen,
>  				maxlen, len, prod, rtx);
> @@ -1111,13 +1096,8 @@ xfs_rtallocate_extent(
>  				maxlen, len, prod, rtx);
>  	}
>  	xfs_rtbuf_cache_relse(&args);
> -	if (error) {
> -		if (error == -ENOSPC && prod > 1) {
> -			prod = 1;
> -			goto retry;
> -		}
> +	if (error)
>  		return error;
> -	}
>  
>  	/*
>  	 * If it worked, update the superblock.
> @@ -1348,6 +1328,35 @@ xfs_rtpick_extent(
>  	return 0;
>  }
>  
> +static void
> +xfs_rtalloc_align_minmax(
> +	xfs_rtxlen_t		*raminlen,
> +	xfs_rtxlen_t		*ramaxlen,
> +	xfs_rtxlen_t		*prod)
> +{
> +	xfs_rtxlen_t		newmaxlen = *ramaxlen;
> +	xfs_rtxlen_t		newminlen = *raminlen;
> +	xfs_rtxlen_t		slack;
> +
> +	slack = newmaxlen % *prod;
> +	if (slack)
> +		newmaxlen -= slack;
> +	slack = newminlen % *prod;
> +	if (slack)
> +		newminlen += *prod - slack;
> +
> +	/*
> +	 * If adjusting for extent size hint alignment produces an invalid
> +	 * min/max len combination, go ahead without it.
> +	 */
> +	if (newmaxlen < newminlen) {
> +		*prod = 1;
> +		return;
> +	}
> +	*ramaxlen = newmaxlen;
> +	*raminlen = newminlen;
> +}
> +
>  int
>  xfs_bmap_rtalloc(
>  	struct xfs_bmalloca	*ap)
> @@ -1430,10 +1439,13 @@ xfs_bmap_rtalloc(
>  	 * perfectly aligned, otherwise it will just get us in trouble.
>  	 */
>  	div_u64_rem(ap->offset, align, &mod);
> -	if (mod || ap->length % align)
> +	if (mod || ap->length % align) {
>  		prod = 1;
> -	else
> +	} else {
>  		prod = xfs_extlen_to_rtxlen(mp, align);
> +		if (prod > 1)
> +			xfs_rtalloc_align_minmax(&raminlen, &ralen, &prod);
> +	}
>  
>  	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
>  			ap->wasdel, prod, &rtx);
> -- 
> 2.39.2
> 
> 
