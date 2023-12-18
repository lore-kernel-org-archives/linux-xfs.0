Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B915D71446
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McBDbjMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9B4C433C7;
	Mon, 18 Dec 2023 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702921865;
	bh=6gOxYY3TgkBWw7DgcWkuq6H1iTVQSYdlHvnlXxnY+Jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=McBDbjMZi1MZ4iTp4BwQmcVLDihM8cCBSXDytX5Tc9/uj/gC5MFfe9G+maKyX4WRz
	 9j15R3I8bp6qNDBb2eP/DOilp8TwgsONnHDhvE36L1G/JhILefjYdcibxiLwnAQOWI
	 zEyTMjXmcGFPTvEleR/24GnjeP2Puo4fWoInMAAad5VgcjsFACVhBtuEIdA67HX221
	 ltSopunUnRTWVgNNyuDvB6kSeKpPnR6J39wvVRbvYOEM0AmnWSxWorgLXRoiZECwyM
	 echDplsWVmGtCA8lpb/OLz+tr3pRb+zYlVvlZvt1YJ33tpnUuRCNnMsoc8QCATct/z
	 L+ViEiBWIJkiA==
Date: Mon, 18 Dec 2023 09:51:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/22] xfs: reflow the tail end of
 xfs_rtallocate_extent_block
Message-ID: <20231218175104.GS361584@frogsfrogsfrogs>
References: <20231218045738.711465-1-hch@lst.de>
 <20231218045738.711465-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218045738.711465-14-hch@lst.de>

On Mon, Dec 18, 2023 at 05:57:29AM +0100, Christoph Hellwig wrote:
> Change polarity of a check so that the successful case of being able to
> allocate an extent is in the main path of the function and error handling
> is on a branch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 44 +++++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 924665b66210ed..6fcc847b116273 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -289,36 +289,38 @@ xfs_rtallocate_extent_block(
>  		if (error)
>  			return error;
>  	}
> +
>  	/*
>  	 * Searched the whole thing & didn't find a maxlen free extent.
>  	 */
> -	if (minlen <= maxlen && besti != -1) {
> -		xfs_rtxlen_t	p;	/* amount to trim length by */
> -
> +	if (minlen > maxlen || besti == -1) {
>  		/*
> -		 * If size should be a multiple of prod, make that so.
> +		 * Allocation failed.  Set *nextp to the next block to try.
>  		 */
> -		if (prod > 1) {
> -			div_u64_rem(bestlen, prod, &p);
> -			if (p)
> -				bestlen -= p;
> -		}
> +		*nextp = next;
> +		return -ENOSPC;
> +	}
>  
> -		/*
> -		 * Allocate besti for bestlen & return that.
> -		 */
> -		error = xfs_rtallocate_range(args, besti, bestlen);
> -		if (error)
> -			return error;
> -		*len = bestlen;
> -		*rtx = besti;
> -		return 0;
> +	/*
> +	 * If size should be a multiple of prod, make that so.
> +	 */
> +	if (prod > 1) {
> +		xfs_rtxlen_t	p;	/* amount to trim length by */
> +
> +		div_u64_rem(bestlen, prod, &p);
> +		if (p)
> +			bestlen -= p;
>  	}
> +
>  	/*
> -	 * Allocation failed.  Set *nextp to the next block to try.
> +	 * Allocate besti for bestlen & return that.
>  	 */
> -	*nextp = next;
> -	return -ENOSPC;
> +	error = xfs_rtallocate_range(args, besti, bestlen);
> +	if (error)
> +		return error;
> +	*len = bestlen;
> +	*rtx = besti;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.39.2
> 
> 
