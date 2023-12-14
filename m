Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E847F2BCF6
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NF3SqPGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4740C433C8;
	Thu, 14 Dec 2023 21:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702588906;
	bh=iuuUTNqHTklq0WgSHYZEnOxtK9TwVmRpvSsM7H10iPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NF3SqPGs6j/NUocbYP3PS1oTcpccMyYGIVxrM5pcTQMBF/UE6E2eIPbl3149re+kj
	 2V0NImmfEQXn1ggU/KYeMsjDItSKG6lDHpVCclk/r0t5RgCJvEJ3k9plt0wKskhQuF
	 OZMLemgmbIz/iH2AFo18sjfFN2Fd+i/dU5CaCzzGoe09iiy5lAxnxNBmwjb9FPJzgm
	 x9mHRRjLGF+SoMhRtkuMFgN4ca1rQ8zGT/BMwFqTjELI1I7SyQvXgd/M+t1e/wS44P
	 0pJ3AJYxond6ivQXxSIHqBpMf+it8sPWAMo+OzwCJ1d0CxQC9RDgv1lio9ZSkR5qZc
	 3jkJPpAZOrYXQ==
Date: Thu, 14 Dec 2023 13:21:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/19] xfs: remove XFS_RTMIN/XFS_RTMAX
Message-ID: <20231214212146.GF361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-17-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:35AM +0100, Christoph Hellwig wrote:
> Use the kernel min/max helpers instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h   | 6 ------
>  fs/xfs/libxfs/xfs_rtbitmap.c | 8 ++++----
>  fs/xfs/xfs_rtalloc.c         | 7 ++++---
>  3 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 82a4ab2d89e9f0..f11e7c8d336993 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1156,12 +1156,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
>  #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
>  #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
>  
> -/*
> - * RT bit manipulation macros.
> - */
> -#define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
> -#define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
> -
>  /*
>   * Dquot and dquot block format definitions
>   */
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 4185ccf83bab68..31100120b2c586 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -184,7 +184,7 @@ xfs_rtfind_back(
>  		 * Calculate first (leftmost) bit number to look at,
>  		 * and mask for all the relevant bits in this word.
>  		 */
> -		firstbit = XFS_RTMAX((xfs_srtblock_t)(bit - len + 1), 0);
> +		firstbit = max_t(xfs_srtblock_t, bit - len + 1, 0);
>  		mask = (((xfs_rtword_t)1 << (bit - firstbit + 1)) - 1) <<
>  			firstbit;
>  		/*
> @@ -338,7 +338,7 @@ xfs_rtfind_forw(
>  		 * Calculate last (rightmost) bit number to look at,
>  		 * and mask for all the relevant bits in this word.
>  		 */
> -		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
> +		lastbit = min(bit + len, XFS_NBWORD);
>  		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
>  		/*
>  		 * Calculate the difference between the value there
> @@ -573,7 +573,7 @@ xfs_rtmodify_range(
>  		/*
>  		 * Compute first bit not changed and mask of relevant bits.
>  		 */
> -		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
> +		lastbit = min(bit + len, XFS_NBWORD);
>  		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
>  		/*
>  		 * Set/clear the active bits.
> @@ -787,7 +787,7 @@ xfs_rtcheck_range(
>  		/*
>  		 * Compute first bit not examined.
>  		 */
> -		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
> +		lastbit = min(bit + len, XFS_NBWORD);
>  		/*
>  		 * Mask of relevant bits.
>  		 */
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 70b4eb840df4f3..24d74c8b532e5f 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -637,9 +637,10 @@ xfs_rtallocate_extent_size(
>  	 * for this summary level.
>  	 */
>  	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
> -		error = xfs_rtalloc_sumlevel(args, l, XFS_RTMAX(minlen, 1 << l),
> -				XFS_RTMIN(maxlen, (1 << (l + 1)) - 1), prod,
> -				len, rtx);
> +		error = xfs_rtalloc_sumlevel(args, l,
> +				max_t(xfs_rtxlen_t, minlen, 1 << l),
> +				min_t(xfs_rtxlen_t, maxlen, (1 << (l + 1)) - 1),

Oof, the minlen/maxlen arguments are not pretty.  OTOH I can't come up
with a better name for the loop body versions of minlen/maxlen.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +				prod, len, rtx);
>  		if (error != -ENOSPC)
>  			return error;
>  	}
> -- 
> 2.39.2
> 
> 
