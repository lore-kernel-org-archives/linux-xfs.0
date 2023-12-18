Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F192D74E32
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="covAWDLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF64C433C9;
	Mon, 18 Dec 2023 22:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702937853;
	bh=H4R2DziQz+z5LOTKC6rA4UKux23wLzup2ALVOOCNTdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=covAWDLYp9ry2lkNjKvfv+MGCuYMswvEZVR13MKxOJQDy9IXOVp9FUGPa5X3EThmj
	 GyHKPqBv+tuNnOJDArx2NcixYTn3kHt8Vdo6KW6hFoRXwuuuHc6nHvXI3HZYbfRS37
	 bnbUji0OslKZb+XLE+Q1eQepkcIUtEDXM8UnwzuGMT8dwKm8jW8QJeMsCvXAwHzuNX
	 91com1lln8YK6SygQ35hWsEu1Fw091KIAuuxoqTJWAmMI7bZ18Sl+48AG60KKBPoDU
	 IUh9vw/pBZQYHHoCfwUjpL3pp0dPU6w5BGEGVwxOvgW/7XlB46vrWrsNScY+JMWw5j
	 fyKyn/bOK/Hbw==
Date: Mon, 18 Dec 2023 14:17:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: simplify and optimize the RT allocation
 fallback cascade
Message-ID: <20231218221732.GV361584@frogsfrogsfrogs>
References: <20231218045738.711465-1-hch@lst.de>
 <20231218045738.711465-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218045738.711465-21-hch@lst.de>

On Mon, Dec 18, 2023 at 05:57:36AM +0100, Christoph Hellwig wrote:
> There are currently multiple levels of fall back if an RT allocation
> can not be satisfied:
> 
>  1) xfs_rtallocate_extent extends the minlen and reduces the maxlen due
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
> of going through the retry loop and also dropping the perfectly usable
> minlen adjustment that didn't cause the problem, and then just use
> a single retry that drops both the minlen and alignment requirement
> when we really are out of space, thus consolidating cases (2) and (3)
> above.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 58 ++++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index bac8eacd628c29..8a09e42b2dcdcc 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1089,21 +1089,6 @@ xfs_rtallocate_extent(
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
> @@ -1112,13 +1097,8 @@ xfs_rtallocate_extent(
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
> @@ -1349,6 +1329,35 @@ xfs_rtpick_extent(
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
> @@ -1431,10 +1440,13 @@ xfs_bmap_rtalloc(
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
