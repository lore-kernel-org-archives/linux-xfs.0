Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D799A1D54F7
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037870; cv=none; b=kh/zAIFQOsWj2JuPBcGpVd9tYSzfcG7mSxgXhr/fegFmgluq0fxFHfg149rgDAFfUsT/hAP9/Y6+Fb9FOfeG9IAZEQy1xj8eQzN+hmSRBasEGh7DEhQDJSvJc6/2KG6AqfvJFq6g+orYU+6q+eAWFN14k/jc14rCnEl14n+TYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037870; c=relaxed/simple;
	bh=pu6BizVDHeUSnSiZMVDGRKxLjGRQ9Gi5NC8DCGjGSkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAuVY0YGryGA7o9GKNefRMTdsmWhgtm6Gw6ZXpkIIMiCMZRcmc4j1QPxudqEyKL5DWIvb9J6XmlNxnxIkjWqRuZedRh5W3aKGhLJ7+kXy0K5cQipA8ljfMbGRGNg8qhqY1k/THjet0N2M2gKD3fxKpAV1WmhzhmSgcrIMwJrNRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmI+8weM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmI+8weM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C336C4CED0;
	Thu, 12 Dec 2024 21:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734037870;
	bh=pu6BizVDHeUSnSiZMVDGRKxLjGRQ9Gi5NC8DCGjGSkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmI+8weMxmKHZqXrZjncrCGrDRjpIV4I9wyr/+3hMIs93ltWrdpDbq8qJ4EEC7e4q
	 WA3fHP3o1/zsbFkSp8J8uEDvVTDTyIXzG3cUfewyb6GUpnIbfxokhDknxx3soiODXi
	 NnrNTjmtJ8ycKfUfAXKcfAyM4Luox6eDwRqtJntIKwXeREeCqGwrwlX03PxSXBobTp
	 xEGnDst1+4PFfIu062jExHFvsZd5A506Wl8iN9QIr+5fXqHRtIVnoQ2DNrfeYSvjBw
	 o9bPZ5vnwLit+unwVVeoEhAyHBjWB68k3Ii1Q5wyO2FjKkw1NGEJ1x2cGBIB1pFLeo
	 hM59pJ0do8nJg==
Date: Thu, 12 Dec 2024 13:11:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/43] xfs: factor out a xfs_rt_check_size helper
Message-ID: <20241212211109.GO6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-3-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:27AM +0100, Christoph Hellwig wrote:
> Add a helper to check that the last block of a RT device is readable
> to share the code between mount and growfs.  This also adds the mount
> time overflow check to growfs and improves the error messages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 62 ++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d8e6d073d64d..bc18b694db75 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1248,6 +1248,34 @@ xfs_grow_last_rtg(
>  			mp->m_sb.sb_rgextents;
>  }
>  
> +/*
> + * Read in the last block of the RT device to make sure it is accessible.
> + */
> +static int
> +xfs_rt_check_size(
> +	struct xfs_mount	*mp,
> +	xfs_rfsblock_t		last_block)
> +{
> +	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
> +		xfs_warn(mp, "RT device size overflow: %llu != %llu",
> +			XFS_BB_TO_FSB(mp, daddr), last_block);
> +		return -EFBIG;
> +	}
> +
> +	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
> +			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +	if (error)
> +		xfs_warn(mp, "cannot read last RT device sector (%lld)",
> +				last_block);
> +	else
> +		xfs_buf_relse(bp);
> +	return error;
> +}
> +
>  /*
>   * Grow the realtime area of the filesystem.
>   */
> @@ -1259,7 +1287,6 @@ xfs_growfs_rt(
>  	xfs_rgnumber_t		old_rgcount = mp->m_sb.sb_rgcount;
>  	xfs_rgnumber_t		new_rgcount = 1;
>  	xfs_rgnumber_t		rgno;
> -	struct xfs_buf		*bp;
>  	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
>  	int			error;
>  
> @@ -1302,15 +1329,10 @@ xfs_growfs_rt(
>  	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
>  	if (error)
>  		goto out_unlock;
> -	/*
> -	 * Read in the last block of the device, make sure it exists.
> -	 */
> -	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
> -				XFS_FSB_TO_BB(mp, in->newblocks - 1),
> -				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +
> +	error = xfs_rt_check_size(mp, in->newblocks - 1);
>  	if (error)
>  		goto out_unlock;
> -	xfs_buf_relse(bp);
>  
>  	/*
>  	 * Calculate new parameters.  These are the final values to be reached.
> @@ -1444,10 +1466,6 @@ int				/* error */
>  xfs_rtmount_init(
>  	struct xfs_mount	*mp)	/* file system mount structure */
>  {
> -	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
> -	xfs_daddr_t		d;	/* address of last block of subvolume */
> -	int			error;
> -
>  	if (mp->m_sb.sb_rblocks == 0)
>  		return 0;
>  	if (mp->m_rtdev_targp == NULL) {
> @@ -1458,25 +1476,7 @@ xfs_rtmount_init(
>  
>  	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
>  
> -	/*
> -	 * Check that the realtime section is an ok size.
> -	 */
> -	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> -	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_rblocks) {
> -		xfs_warn(mp, "realtime mount -- %llu != %llu",
> -			(unsigned long long) XFS_BB_TO_FSB(mp, d),
> -			(unsigned long long) mp->m_sb.sb_rblocks);
> -		return -EFBIG;
> -	}
> -	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
> -					d - XFS_FSB_TO_BB(mp, 1),
> -					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> -	if (error) {
> -		xfs_warn(mp, "realtime device size check failed");
> -		return error;
> -	}
> -	xfs_buf_relse(bp);
> -	return 0;
> +	return xfs_rt_check_size(mp, mp->m_sb.sb_rblocks - 1);
>  }
>  
>  static int
> -- 
> 2.45.2
> 
> 
