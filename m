Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF0D33F589
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782323242; cv=none; b=av6y6ra+zM2pZaa2SVXCHRav2eYLZCZaFJTAlkHclTqS5iI3P8potdgzOAMXYIFxtNhXp2hCjPHKWE2mQi36YmblKvCpGFbpR3M8J/fYu72eWNqWIO4pWSfSkitXawu9dg9m12Oo3zlOTfS7s0URBWTYWO9BIM99RheVzuLKMcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782323242; c=relaxed/simple;
	bh=3fpzsn0lxeaSF+Oh+K427zsp4lqsWhit5SEderY9ll8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tiNrkw4qBo3iS4tDGpw1Tf+T20F847bPLsMAAWHvkjgF1tbslJmMjBaa2LMXil0ibyprb7EhWE/gOJG8nAZDGyiLbopOQyZRMzAqNvkwuxwkeoQ5g9FADSCnOKoIDPeeBgAuU2chaeJ7PRC4X4fOfr2wb8dTjUvPQKW9rMe4/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3F2TWUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3F2TWUg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4D411F000E9;
	Wed, 24 Jun 2026 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782323240;
	bh=SwPri8l4jZ8bpnqlgOLb2sIGqtIEzw1gG33AXBlgwEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X3F2TWUgKHqECv8OTV1VQ+WGmR/gXqY1U8z7t96DQZBwNs4ec7N/m33ea4LXetxnS
	 pxfc0GKPFK8oAVlLaFh4b3UoSyrCbGwBLhy9bKfug4PoNs3a3NbrscMna772TJ6T1k
	 c4UcC7yYl3f4PFBKKGKP/X3Ty4yK17wucIffTRYdaFOvyOHqYTLA1PqNBR7nJJsnCh
	 oBJQ2GYW+55omO5DSoeaiZQ5XJcmuB3Of4XTA9OArs5bE3/HIVrjxVvGeqx5eHOolr
	 HxN3Yfw/kQOirhj8z7ce78QhAu2pZRzscfM5+OTIqf5Y/tAkxgCfTr6pR+/JUcWXdv
	 6Pt/3GPAaVLqA==
Date: Wed, 24 Jun 2026 10:47:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	dgc@kernel.org, gost.dev@samsung.com, pankaj.raghav@linux.dev,
	andres@anarazel.de, kundan.kumar@samsung.com, hch@lst.de,
	cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v7 1/2] xfs: add an allocation mode to
 xfs_alloc_file_space()
Message-ID: <20260624174720.GT6078@frogsfrogsfrogs>
References: <20260622083106.2914092-1-p.raghav@samsung.com>
 <20260622083106.2914092-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622083106.2914092-2-p.raghav@samsung.com>

On Mon, Jun 22, 2026 at 10:31:05AM +0200, Pankaj Raghav wrote:
> xfs_alloc_file_space() hardcodes XFS_BMAPI_PREALLOC to preallocate
> unwritten extents across a range.
> 
> In preparation for FALLOC_FL_WRITE_ZEROES, add an explicit allocation
> mode argument, enum xfs_alloc_file_space_mode, and derive the xfs_bmapi
> flags from it. The only mode for now is XFS_ALLOC_FILE_SPACE_PREALLOC,
> which preallocates unwritten extents and marks the inode as preallocated
> exactly as before, so there is no functional change.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 25 +++++++++++++++++++++----
>  fs/xfs/xfs_bmap_util.h |  6 +++++-
>  fs/xfs/xfs_file.c      |  9 ++++++---
>  3 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 3b9f262f8e91..8dfb3c1e3759 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -642,11 +642,19 @@ xfs_free_eofblocks(
>  	return error;
>  }
>  
> +/*
> + * Allocate space for a file according to @mode:
> + *
> + * XFS_ALLOC_FILE_SPACE_PREALLOC:
> + * Preallocate unwritten extents across the range and mark the inode as
> + * preallocated.

"Preallocate unwritten extents over holes across the range..."?

Other than that, this looks good to me.

--D

> + */
>  int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	enum xfs_alloc_file_space_mode mode)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -657,6 +665,7 @@ xfs_alloc_file_space(
>  	int			rt;
>  	xfs_trans_t		*tp;
>  	xfs_bmbt_irec_t		imaps[1], *imapp;
> +	uint32_t		bmapi_flags, nr_exts;
>  	int			error;
>  
>  	if (xfs_is_always_cow_inode(ip))
> @@ -674,6 +683,15 @@ xfs_alloc_file_space(
>  	if (len <= 0)
>  		return -EINVAL;
>  
> +	switch (mode) {
> +	case XFS_ALLOC_FILE_SPACE_PREALLOC:
> +		bmapi_flags = XFS_BMAPI_PREALLOC;
> +		nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>  	rt = XFS_IS_REALTIME_INODE(ip);
>  	extsz = xfs_get_extsz_hint(ip);
>  
> @@ -733,8 +751,7 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
>  		if (error)
>  			goto error;
>  
> @@ -748,7 +765,7 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				allocatesize_fsb, bmapi_flags, 0, imapp,
>  				&nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..232b4c48247e 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -55,8 +55,12 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  			     int *is_empty);
>  
>  /* preallocation and hole punch interface */
> +enum xfs_alloc_file_space_mode {
> +	XFS_ALLOC_FILE_SPACE_PREALLOC,
> +};
> +
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +		xfs_off_t len, enum xfs_alloc_file_space_mode mode);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..e90ea6ebdc8e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1406,7 +1406,8 @@ xfs_falloc_zero_range(
>  		len = round_up(offset + len, blksize) -
>  			round_down(offset, blksize);
>  		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +		error = xfs_alloc_file_space(ip, offset, len,
> +				XFS_ALLOC_FILE_SPACE_PREALLOC);
>  	}
>  	if (error)
>  		return error;
> @@ -1432,7 +1433,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_ALLOC_FILE_SPACE_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1460,7 +1462,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_ALLOC_FILE_SPACE_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> -- 
> 2.51.2
> 
> 
