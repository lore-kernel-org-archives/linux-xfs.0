Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39F16A327
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyeNcAHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41F8C433C7;
	Thu, 14 Dec 2023 21:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702588735;
	bh=NtpFVAYdUK5MnP/L0BKlpuSORTBkIf1+CLB/wvG8xmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cyeNcAHWP/BG9YpESiIMe8NjegaiaYwDsGGtt+uLJw8FCoyL4D5c2xgkDY00O1f3s
	 9IJqQBj+4C36JWzHmWtkCzsORQK7Dq5BJDHyJIjyL9EXpHrl2T0JZepfL4dWS52n1W
	 DAWst8At6IdFQUUFcFh24Qi9fNUAsV4OTOF82FkD0JchlGjy7R7qJFWrVurMipiFY0
	 unSECy7JeY1pwvk15+IH2vtFmWK7F6oa4+yaq+kfz3e6tsrYHjtS9vK4EOe16Nj/Na
	 qE5T1han0iixN/48qR+qitCTH3bvEQmC5+flxYTM7p0eFfsmaGJcG1Q44W+5UXhE51
	 82KmPCE+F2ThQ==
Date: Thu, 14 Dec 2023 13:18:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/19] xfs: remove rt-wrappers from xfs_format.h
Message-ID: <20231214211854.GE361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-16-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:34AM +0100, Christoph Hellwig wrote:
> xfs_format.h has a bunch odd wrappers for helper functions and mount
> structure access using RT* prefixes.  Replace them with their open coded
> versions (for those that weren't entirely unused) and remove the wrappers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h   |  8 --------
>  fs/xfs/libxfs/xfs_rtbitmap.c | 24 ++++++++++++------------
>  fs/xfs/scrub/rtsummary.c     |  2 +-
>  fs/xfs/xfs_rtalloc.c         |  6 +++---
>  4 files changed, 16 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9a88aba1589f87..82a4ab2d89e9f0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1156,20 +1156,12 @@ static inline bool xfs_dinode_has_large_extent_counts(
>  #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
>  #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
>  
> -#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
> -#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)

Apparently I forgot to get rid of these when I demacro'd the code.
Thanks for picking that up,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -
>  /*
>   * RT bit manipulation macros.
>   */
>  #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
>  #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
>  
> -#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
> -#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
> -
> -#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
> -
>  /*
>   * Dquot and dquot block format definitions
>   */
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 5773e4ea36c624..4185ccf83bab68 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -195,7 +195,7 @@ xfs_rtfind_back(
>  			/*
>  			 * Different.  Mark where we are and return.
>  			 */
> -			i = bit - XFS_RTHIBIT(wdiff);
> +			i = bit - xfs_highbit32(wdiff);
>  			*rtx = start - i + 1;
>  			return 0;
>  		}
> @@ -233,7 +233,7 @@ xfs_rtfind_back(
>  			/*
>  			 * Different, mark where we are and return.
>  			 */
> -			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
> +			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
>  			*rtx = start - i + 1;
>  			return 0;
>  		}
> @@ -272,7 +272,7 @@ xfs_rtfind_back(
>  			/*
>  			 * Different, mark where we are and return.
>  			 */
> -			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
> +			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
>  			*rtx = start - i + 1;
>  			return 0;
>  		} else
> @@ -348,7 +348,7 @@ xfs_rtfind_forw(
>  			/*
>  			 * Different.  Mark where we are and return.
>  			 */
> -			i = XFS_RTLOBIT(wdiff) - bit;
> +			i = xfs_lowbit32(wdiff) - bit;
>  			*rtx = start + i - 1;
>  			return 0;
>  		}
> @@ -386,7 +386,7 @@ xfs_rtfind_forw(
>  			/*
>  			 * Different, mark where we are and return.
>  			 */
> -			i += XFS_RTLOBIT(wdiff);
> +			i += xfs_lowbit32(wdiff);
>  			*rtx = start + i - 1;
>  			return 0;
>  		}
> @@ -423,7 +423,7 @@ xfs_rtfind_forw(
>  			/*
>  			 * Different, mark where we are and return.
>  			 */
> -			i += XFS_RTLOBIT(wdiff);
> +			i += xfs_lowbit32(wdiff);
>  			*rtx = start + i - 1;
>  			return 0;
>  		} else
> @@ -708,7 +708,7 @@ xfs_rtfree_range(
>  	 */
>  	if (preblock < start) {
>  		error = xfs_rtmodify_summary(args,
> -				XFS_RTBLOCKLOG(start - preblock),
> +				xfs_highbit64(start - preblock),
>  				xfs_rtx_to_rbmblock(mp, preblock), -1);
>  		if (error) {
>  			return error;
> @@ -720,7 +720,7 @@ xfs_rtfree_range(
>  	 */
>  	if (postblock > end) {
>  		error = xfs_rtmodify_summary(args,
> -				XFS_RTBLOCKLOG(postblock - end),
> +				xfs_highbit64(postblock - end),
>  				xfs_rtx_to_rbmblock(mp, end + 1), -1);
>  		if (error) {
>  			return error;
> @@ -731,7 +731,7 @@ xfs_rtfree_range(
>  	 * (new) free extent.
>  	 */
>  	return xfs_rtmodify_summary(args,
> -			XFS_RTBLOCKLOG(postblock + 1 - preblock),
> +			xfs_highbit64(postblock + 1 - preblock),
>  			xfs_rtx_to_rbmblock(mp, preblock), 1);
>  }
>  
> @@ -800,7 +800,7 @@ xfs_rtcheck_range(
>  			/*
>  			 * Different, compute first wrong bit and return.
>  			 */
> -			i = XFS_RTLOBIT(wdiff) - bit;
> +			i = xfs_lowbit32(wdiff) - bit;
>  			*new = start + i;
>  			*stat = 0;
>  			return 0;
> @@ -839,7 +839,7 @@ xfs_rtcheck_range(
>  			/*
>  			 * Different, compute first wrong bit and return.
>  			 */
> -			i += XFS_RTLOBIT(wdiff);
> +			i += xfs_lowbit32(wdiff);
>  			*new = start + i;
>  			*stat = 0;
>  			return 0;
> @@ -877,7 +877,7 @@ xfs_rtcheck_range(
>  			/*
>  			 * Different, compute first wrong bit and return.
>  			 */
> -			i += XFS_RTLOBIT(wdiff);
> +			i += xfs_lowbit32(wdiff);
>  			*new = start + i;
>  			*stat = 0;
>  			return 0;
> diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
> index 8b15c47408d031..0689025aa4849d 100644
> --- a/fs/xfs/scrub/rtsummary.c
> +++ b/fs/xfs/scrub/rtsummary.c
> @@ -143,7 +143,7 @@ xchk_rtsum_record_free(
>  
>  	/* Compute the relevant location in the rtsum file. */
>  	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
> -	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
> +	lenlog = xfs_highbit64(rec->ar_extcount);
>  	offs = xfs_rtsumoffs(mp, lenlog, rbmoff);
>  
>  	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 2e578e726e9137..70b4eb840df4f3 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -156,7 +156,7 @@ xfs_rtallocate_range(
>  	 * (old) free extent.
>  	 */
>  	error = xfs_rtmodify_summary(args,
> -			XFS_RTBLOCKLOG(postblock + 1 - preblock),
> +			xfs_highbit64(postblock + 1 - preblock),
>  			xfs_rtx_to_rbmblock(mp, preblock), -1);
>  	if (error)
>  		return error;
> @@ -167,7 +167,7 @@ xfs_rtallocate_range(
>  	 */
>  	if (preblock < start) {
>  		error = xfs_rtmodify_summary(args,
> -				XFS_RTBLOCKLOG(start - preblock),
> +				xfs_highbit64(start - preblock),
>  				xfs_rtx_to_rbmblock(mp, preblock), 1);
>  		if (error)
>  			return error;
> @@ -179,7 +179,7 @@ xfs_rtallocate_range(
>  	 */
>  	if (postblock > end) {
>  		error = xfs_rtmodify_summary(args,
> -				XFS_RTBLOCKLOG(postblock - end),
> +				xfs_highbit64(postblock - end),
>  				xfs_rtx_to_rbmblock(mp, end + 1), 1);
>  		if (error)
>  			return error;
> -- 
> 2.39.2
> 
> 
