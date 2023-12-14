Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA3A7494
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4itzQcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12309C433C8;
	Thu, 14 Dec 2023 20:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587597;
	bh=MhNC24lNUW111VhSgRF0kaEhkNt/FZuZe0kGSLwSBKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l4itzQcYx4dAM+ysJKx9Utabf7PFmtC6dWC73bAtwBusMlmJ3UBlJdB2L9MaogPhz
	 81U5jg2pJqPBsNOhsGEhK6clK4in9RN99YkCCZbwlPzvZMpaXInWBBpQZMLC3UVWx1
	 DlQHgYBsKe3XJiFbmtFrGKi1KFq+LEQBtSOHEC4RZJjTZ7LE9r0g2i+BSZRi9XlX+i
	 m6zlWzIjQwk0/4Yi7J+7/D4dXQNG0soofaCPTJgB8tw5Xcw9gT329+neoUjPUTE13i
	 wRWCQ8b9xtPGhaAjOGPxD43OrJtAr7wT+1m5MqA5+ZuW+6th6wAAwie5NA6W0jl16+
	 Lren9XEOYNvVg==
Date: Thu, 14 Dec 2023 12:59:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/19] xfs: cleanup picking the start extent hint in
 xfs_bmap_rtalloc
Message-ID: <20231214205956.GX361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-10-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:28AM +0100, Christoph Hellwig wrote:
> Clean up the logical in xfs_bmap_rtalloc that tries to find a rtextent
> to start the search from by using a separate variable for the hint, not
> calling xfs_bmap_adjacent when we want to ignore the locality and avoid
> an extra roundtrip converting between block numbers and RT extent
> numbers.

Ahah, I had wondered about that...

> As a side-effect this doesn't pointlessly call xfs_rtpick_extent and
> increment the start rtextent hint if we are going to ignore the result
> anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 35 +++++++++++++++--------------------
>  1 file changed, 15 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 158a631379378e..2ce3bcf4b84b76 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1393,7 +1393,8 @@ xfs_bmap_rtalloc(
>  {
>  	struct xfs_mount	*mp = ap->ip->i_mount;
>  	xfs_fileoff_t		orig_offset = ap->offset;
> -	xfs_rtxnum_t		rtx;
> +	xfs_rtxnum_t		start;	   /* allocation hint rtextent no */
> +	xfs_rtxnum_t		rtx;	   /* actually allocated rtextent no */
>  	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
>  	xfs_extlen_t		mod = 0;   /* product factor for allocators */
>  	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
> @@ -1454,30 +1455,24 @@ xfs_bmap_rtalloc(
>  		rtlocked = true;
>  	}
>  
> -	/*
> -	 * If it's an allocation to an empty file at offset 0,
> -	 * pick an extent that will space things out in the rt area.
> -	 */
> -	if (ap->eof && ap->offset == 0) {
> -		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
> +	if (ignore_locality) {
> +		start = 0;
> +	} else if (xfs_bmap_adjacent(ap)) {
> +		start = xfs_rtb_to_rtx(mp, ap->blkno);
> +	} else if (ap->eof && ap->offset == 0) {
> +		/*
> +		 * If it's an allocation to an empty file at offset 0, pick an
> +		 * extent that will space things out in the rt area.
> +		 */
> +		error = xfs_rtpick_extent(mp, ap->tp, ralen, &start);
>  		if (error)
>  			return error;
> -		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
>  	} else {
> -		ap->blkno = 0;
> +		start = 0;
>  	}

It took me a while to wrap my head around the dual "start = 0" clauses
here, but eventually I figured out that the first one is from below, and
this one here is merely the continuation of the "!adjacent" and
"!emptyfileatoffset0" cases.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
> -	xfs_bmap_adjacent(ap);
> -
> -	/*
> -	 * Realtime allocation, done through xfs_rtallocate_extent.
> -	 */
> -	if (ignore_locality)
> -		rtx = 0;
> -	else
> -		rtx = xfs_rtb_to_rtx(mp, ap->blkno);
>  	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
> -	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
> +	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
>  			ap->wasdel, prod, &rtx);
>  	if (error == -ENOSPC) {
>  		if (align > mp->m_sb.sb_rextsize) {
> @@ -1494,7 +1489,7 @@ xfs_bmap_rtalloc(
>  			goto retry;
>  		}
>  
> -		if (!ignore_locality && ap->blkno != 0) {
> +		if (!ignore_locality && start != 0) {
>  			/*
>  			 * If we can't allocate near a specific rt extent, try
>  			 * again without locality criteria.
> -- 
> 2.39.2
> 
> 
