Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9D03126B5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761762176; cv=none; b=sWsfNm2U160zWRl82c7Y8BkwqHQFWCU1Xy3WW/AmUuBWwZr/S1aYyiT94uT1tzbFgHWC/0XbUaZrJQfxCD9OcqdmhlfKbxAJxULAKsOM+8znVNQUdEg9uK02ifghYLeOZcugKUOfQt56WAkHHXWWaX2lmKqO9NqnoKvp9Jl6W8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761762176; c=relaxed/simple;
	bh=RgrC2T96IpAOcBNwqjnUrEANwSaHJ4mlPJs0miaH4Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMC6s3qOl5XVZ69RXM+Vsh+YELvHHgB9TbuywLsAaVEqVQDjyc6uLP1k1luWixgFopdt1rWEylrC3OhvH2I8dma1Y84rKx5pdvb+aiY/8g+OQ9KdFuwO3z96VWLPAHlwXoQGdX483jydRJngTTJSCK7A8BW8411cVzQ86mXZ/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7Ghiq1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7Ghiq1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA40C4CEF7;
	Wed, 29 Oct 2025 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761762175;
	bh=RgrC2T96IpAOcBNwqjnUrEANwSaHJ4mlPJs0miaH4Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V7Ghiq1f/SJRBE+iuJy2P+17uRSAFgGO8FRXUHq5UPlh7CkpioRF1YSlrFkFez9ZF
	 RelVxXpcx9UCZKW6ACdzHCIPPDcbEzVPBrZ5fF9lC7eAfcv0zNzx+aRh7rV9Vz/ITt
	 mCVMXcbrC7iuxMR8Ma6Nad7q1Sn+SbomP2mSTjjiI8DXfmgdpdwWg0tmb6clKUJOxm
	 aRpTlxzQBo4KrNltemF/0AH7DonHJzlYhyJLCiGY+7dZp3944ByAyC34VCWs7tWkPs
	 AxekLaBRL4zOeot7Ml7ZaoVR+PWGI1qF34I0HZiuf8Z+rxir4UZrZcOaJtFVWE6hUk
	 tatdXRMLEruMg==
Date: Wed, 29 Oct 2025 11:22:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: yi.zhang@huaweicloud.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20251029182255.GK3356773@frogsfrogsfrogs>
References: <0e89b047-cacb-4c23-aa83-27de1eb235a5@huaweicloud.com>
 <20251029175313.3644646-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029175313.3644646-2-lukas@herbolt.com>

On Wed, Oct 29, 2025 at 06:53:14PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> v3 changes:
>  - fix formating
>  - fix check  on the return value of xfs_alloc_file_space
>  - add check if inode COW and return -EOPNOTSUPP
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_bmap_util.c |  6 +++---
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_file.c      | 24 ++++++++++++++++++------
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 06ca11731e430..ddbcf4b0cea17 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -646,7 +646,8 @@ int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	uint32_t		flags)	/* XFS_BMAPI_... */

Call the parameter bmapi_flags.

>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -748,8 +749,7 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> -				&nimaps);
> +				allocatesize_fsb, flags, 0, imapp, &nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
>  				goto error;
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b33616304..1fd4844d4ec64 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  
>  /* preallocation and hole punch interface */
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +		xfs_off_t len, uint32_t flags);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f96fbf5c54c99..38de47ffb8d39 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1261,23 +1261,32 @@ xfs_falloc_zero_range(
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
> +		if (xfs_is_cow_inode(ip) || !bdev_write_zeroes_unmap_sectors(

xfs_is_cow_inode() only tells us if the inode is capable of doing out of
place writes.  Why would a regular reflinked inode be ineligible for
WRITE_ZEROES?  The whole point of that fallocate mode is to avoid ioend
overhead during fsync, so I could see why you wouldn't want to allow
this for files that always do writes out of place.  But not for files
that happen to have been reflinked in the past but otherwise support
pure overwrites.

I don't understand why this bdev_write_zeroes_unmap_sectors check is
here and not in xfs_alloc_file_space.  Shouldn't other callers of
xfs_alloc_file_space be restricted from passing in XFS_BMAPI_ZERO if the
block device doesn't support unmap_sectors?

> +				xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;
> +		error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_ZERO);
> +	} else {
> +		error = xfs_alloc_file_space(ip, offset, len,
> +				XFS_BMAPI_PREALLOC);
> +	}
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1302,7 +1311,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode),	offset, len,

Whitespace damage                                 ^^^^^

--D

> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1330,7 +1340,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1340,7 +1351,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1383,6 +1394,7 @@ __xfs_file_fallocate(
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
> 
