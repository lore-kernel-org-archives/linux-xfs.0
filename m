Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5043A987B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131655; cv=none; b=O7nDFDEHwi5LLbZbvHOb0qtPqKTo7jjErQyaq5rY3qnszYZ8qHa6e+2vt9uFVoJpA8H607Qo4RyldvebBMzxjTbQV4WFQAZtuZ9szU0UGjgvuGJk7tcck9A9fVg1hbzO448W6IrZmZqElnPGq9zasU8Lvw/QuJXrRE++eZynIEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131655; c=relaxed/simple;
	bh=VH6MWAm/7MPR8/agr5501ZUjt/OSjEqzWb1M9kwot/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sbiqOxX28TzWhfAeEUxzAQYfC0GRurl5NhKnoinvCdJI9SOPMUtrvQ9Cgh6ExXo9eQKTXey8rbIvbDPh5RiPTPDmmcN6o+2hrEtX38H+2luZxsAVsde2AVerewBXzmHjFykQsC14SlvcEKcUHX7X2uGABVl81x1j1/jVX7ywWcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYIssVSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYIssVSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4E21F000E9;
	Mon, 22 Jun 2026 12:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782131653;
	bh=nU7DkqwpJB1cl0YLpJ0wIrXAugq4Mev3veWM/UEZgAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PYIssVSHUzxuxZufVwfkDUEN8qA6yVU5+0KUMgyLx70mETnjgG8wXk5zEyHtRinQi
	 IgrLlZ6woP27ZMEOuEq5Dcg6vMQW2CH7nUI7UjAXAypYq2153Lv7BZYN8c/nKITOAj
	 sgWNhkqA+NuzzhTnriNFNQ2TIktUXXfxPsTz3rfM+7leiyVuiE89PIQn+4UbJ3wLq9
	 40526KqYFdOTi07hLcGapWZjQ7LC1OHGv4jyMcrnYGkEprPrhq0IwHTD2vepqQlOGY
	 ycufqlM/r7BP4R2X9suCi9GCY5wrn0TQqIlMznJki5yFFbA5hlIVLe86xNp7ZXao/q
	 Ooq908AkWjGnw==
Date: Mon, 22 Jun 2026 14:34:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: simplify the failure path in
 xfs_buf_alloc_vmalloc
Message-ID: <ajkrJHFg4lYeWskS@nidhogg.toxiclabs.cc>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617055814.3842058-5-hch@lst.de>

On Wed, Jun 17, 2026 at 07:58:05AM +0200, Christoph Hellwig wrote:
> Look at the __GFP_NORETRY flag set for readahead so that we don't
> have to pass both the gfp_t and the flags in.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index eea2a8757fe1..1ed9f01b3275 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -168,14 +168,13 @@ static int
>  xfs_buf_alloc_vmalloc(
>  	struct xfs_buf		*bp,
>  	size_t			size,
> -	gfp_t			gfp_mask,
> -	xfs_buf_flags_t		flags)
> +	gfp_t			gfp_mask)
>  {
>  	for (;;) {
>  		bp->b_addr = __vmalloc(size, gfp_mask);
>  		if (bp->b_addr)
>  			break;
> -		if (flags & XBF_READ_AHEAD)

My only concern is that looking at it now, isn't obvious why GRP_NORETRY
has been set in the first place, perhaps worth adding a comment above
it? Like:
		/* Set during readahead */
> +		if (gfp_mask & __GFP_NORETRY)
>  			return -ENOMEM;
>  		XFS_STATS_INC(bp->b_mount, xb_page_retries);
>  		memalloc_retry_wait(gfp_mask);
> @@ -244,7 +243,7 @@ xfs_buf_alloc_backing_mem(
>  				return 0;
>  			trace_xfs_buf_backing_fallback(bp, _RET_IP_);
>  		}
> -		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
> +		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask);
>  	}

Other than the above caveat:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
>  	/*
> -- 
> 2.53.0
> 
> 
