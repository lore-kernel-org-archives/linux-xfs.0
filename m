Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1553451DF
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062115; cv=none; b=EE0/+Vkks9WldzwgKzUnKE3gkQC9723JSC7LCFasL+mZ3UpGMLP5lZutsSozl+nDU+eCsSPh2gVkzW0mUQqseXt8JW0P0SJC2y5FzgOrxt3dch/fnKAux6GF0UEF2UKp076OTaBZ9ECKGhEb3osHWXnhq7mZ8BxaKNA5q6zZSDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062115; c=relaxed/simple;
	bh=QLEetoLkCva3yuHdKCZ5FGM3BAwZ7bm9BJWbREWP5F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HR1jzwGf00UHMUqoj4DbIlM/NYU6kJBE74+5Ga1gU7/iLYiW6AAvxk2HnHwqW6rrCowHs17ycGe6tc043RlQ8iD9AxY8Soyljgl/CZhaFNmNIFHAKy6kCa7IMW8cjQg0S3/UCG5MszuEX2lq1Mb6abKyk1qFpUoQsxUxA1+rY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7adb8Sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7adb8Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41B8C4CEF1;
	Tue, 21 Oct 2025 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761062115;
	bh=QLEetoLkCva3yuHdKCZ5FGM3BAwZ7bm9BJWbREWP5F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t7adb8SwlkU8Id2y3ClIuTsNr75KVQ53Fu+hTV4VkUN3OH2uSZByn3G4GDJjBSZW/
	 5CaBf3lI5r9gckrPH7x4DhsdQmST6md5+ZmJja/3hSs0HaxBIUvzaXhs39EgjQNiPF
	 bsqO9k34dBUZTcCSr54tiAc8aE0zhFMOUumYmykVBV870bVHS73VLnjw9sMD6RU/rR
	 e0YTfWQ8stDqSUgyDXwHZFDwR6/BG6/N/2rh8byaKtAyYFxBI3tOauybu7BmmDbM9J
	 cVg/MGsJQfMfAE8aY8h8W5tFNAT+8fg2hCTBlMqNR6XKtGqdJe9KVyIPEiqWUxEaN+
	 WLuWrNtFugBBA==
Date: Tue, 21 Oct 2025 08:55:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20251021155515.GL6215@frogsfrogsfrogs>
References: <20251021141744.1375627-1-lukas@herbolt.com>
 <20251021141744.1375627-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021141744.1375627-3-lukas@herbolt.com>

On Tue, Oct 21, 2025 at 04:17:44PM +0200, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  6 +++---
>  fs/xfs/xfs_bmap_util.h |  4 ++--
>  fs/xfs/xfs_file.c      | 25 ++++++++++++++++++-------
>  3 files changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 06ca11731e430..fd43c9db79a8d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -645,6 +645,7 @@ xfs_free_eofblocks(
>  int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
> +	uint32_t		flags,		/* XFS_BMAPI_... */
>  	xfs_off_t		offset,
>  	xfs_off_t		len)
>  {
> @@ -747,9 +748,8 @@ xfs_alloc_file_space(
>  		 * startoffset_fsb so that one of the following allocations
>  		 * will eventually reach the requested range.
>  		 */
> -		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> -				&nimaps);
> 		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
> +				flags, 0, imapp, &nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
>  				goto error;
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b33616304..67770830eb245 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -55,8 +55,8 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  			     int *is_empty);
>  
>  /* preallocation and hole punch interface */
> -int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +int	xfs_alloc_file_space(struct xfs_inode *ip, uint32_t flags,
> +		xfs_off_t offset, xfs_off_t len);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f96fbf5c54c99..b7e8cda62bb73 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1255,29 +1255,37 @@ xfs_falloc_insert_range(
>  static int
>  xfs_falloc_zero_range(
>  	struct file		*file,
> -	int			mode,
> +	int				mode,
>  	loff_t			offset,
>  	loff_t			len,
>  	struct xfs_zone_alloc_ctx *ac)
>  {
>  	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	unsigned int		blksize = i_blocksize(inode);
>  	loff_t			new_size = 0;
>  	int			error;
>  
> -	trace_xfs_zero_file_space(XFS_I(inode));
> +	trace_xfs_zero_file_space(ip);
>  
>  	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
>  	if (error)
>  		return error;
>  
> -	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
> +	error = xfs_free_file_space(ip, offset, len, ac);
>  	if (error)
>  		return error;
>  
>  	len = round_up(offset + len, blksize) - round_down(offset, blksize);
>  	offset = round_down(offset, blksize);
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (!bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;
> +		xfs_alloc_file_space(ip, XFS_BMAPI_ZERO, offset, len);

Don't we need to check the return value of xfs_alloc_file_space?

--D

> +	} else {
> +		error = xfs_alloc_file_space(ip, XFS_BMAPI_PREALLOC,
> +				offset, len);
> +	}
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1302,7 +1310,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
> +			offset, len);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1330,7 +1339,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), XFS_BMAPI_PREALLOC,
> +			offset, len);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1340,7 +1350,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1383,6 +1393,7 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_INSERT_RANGE:
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;
> -- 
> 2.51.0
> 
