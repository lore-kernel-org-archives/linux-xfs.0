Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2193F1110
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6+b4zil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC9FC433C8;
	Thu, 14 Dec 2023 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587620;
	bh=NO+eSIs1B2xWv4QZHWkQ3vzLVGAltyEcdM5+YQioy1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H6+b4zilNZeB5gpT1Lqd68bm7swDhTHmK8wwY7mvgCXbW/VRENyiNC0e+XYqjhu0B
	 D9pNukhShafo1G7bxNBEF4QFWlZUpGO9+y+eqGeEP6M54sjLJth/HlLp9n5y4gKMKd
	 NWc+VtftPeCoMwwH04kK+t1s9HT4CtCMolAAzwXTTmVpw60ZJ6VTBX6zR/c8d/XYS7
	 Me+i2Ll5iiyKGxIHxU+Iuh6b6fJX7dHbldlCqkodXZPi0do/cU1l0pRRLYxRDnXPML
	 SpdJ55R/g8Y7Pg/Z5Ct+buysYKHnyyq3HF30gIO8Psjj12S1kJxgl0X4Usd8mbMqgJ
	 vwzOQqSS25+UA==
Date: Thu, 14 Dec 2023 13:00:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/19] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
Message-ID: <20231214210020.GY361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-11-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:29AM +0100, Christoph Hellwig wrote:
> xfs_rtmodify_summary_int is only used inside xfs_rtbitmap.c and to
> implement xfs_rtget_summary.  Move xfs_rtget_summary to xfs_rtbitmap.c
> as the exported API and mark xfs_rtmodify_summary_int static.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hoooray!!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
>  fs/xfs/libxfs/xfs_rtbitmap.h |  4 ++--
>  fs/xfs/xfs_rtalloc.c         | 16 ----------------
>  3 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 30a2844f62e30f..e67f6f763f7d0f 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -519,6 +519,20 @@ xfs_rtmodify_summary(
>  	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
>  }
>  
> +/*
> + * Read and return the summary information for a given extent size, bitmap block
> + * combination.
> + */
> +int
> +xfs_rtget_summary(
> +	struct xfs_rtalloc_args	*args,
> +	int			log,	/* log2 of extent size */
> +	xfs_fileoff_t		bbno,	/* bitmap block number */
> +	xfs_suminfo_t		*sum)	/* out: summary info for this block */
> +{
> +	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
> +}
> +
>  /* Log rtbitmap block from the word @from to the byte before @next. */
>  static inline void
>  xfs_trans_log_rtbitmap(
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index 1c84b52de3d424..274dc7dae1faf8 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -321,8 +321,8 @@ int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
>  		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
>  int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
>  		xfs_rtxlen_t len, int val);
> -int xfs_rtmodify_summary_int(struct xfs_rtalloc_args *args, int log,
> -		xfs_fileoff_t bbno, int delta, xfs_suminfo_t *sum);
> +int xfs_rtget_summary(struct xfs_rtalloc_args *args, int log,
> +		xfs_fileoff_t bbno, xfs_suminfo_t *sum);
>  int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
>  		xfs_fileoff_t bbno, int delta);
>  int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 2ce3bcf4b84b76..fbc60658ef24bf 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -23,22 +23,6 @@
>  #include "xfs_rtbitmap.h"
>  #include "xfs_quota.h"
>  
> -/*
> - * Read and return the summary information for a given extent size,
> - * bitmap block combination.
> - * Keeps track of a current summary block, so we don't keep reading
> - * it from the buffer cache.
> - */
> -static int
> -xfs_rtget_summary(
> -	struct xfs_rtalloc_args	*args,
> -	int			log,	/* log2 of extent size */
> -	xfs_fileoff_t		bbno,	/* bitmap block number */
> -	xfs_suminfo_t		*sum)	/* out: summary info for this block */
> -{
> -	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
> -}
> -
>  /*
>   * Return whether there are any free extents in the size range given
>   * by low and high, for the bitmap block bbno.
> -- 
> 2.39.2
> 
> 
