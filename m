Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F031DF27F
	for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771334360; cv=none; b=lp/3HhuPuaUCx4gcm1aJx8AzyF+uYMSeDZSvSLSPPru8iKeDRsdsLZZGc/3IlPJrNuiOycP4uRUq2ivvT2INY/ssCbDsDfj45Bk7ILMfhBUmZEdTqx8W3kYKULtq4hhOtTloRC1U25YrKuZ2SzLGw3hF//drrJODmqh9zYyP8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771334360; c=relaxed/simple;
	bh=p3OesVCkD1eTGRXZtuB7DymQrZtUa90XZPMdfyANI4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/wZfosF0hwP9bhG5Lbho4OuK6gBaT/OtIllrsLuiGRZQHvgy8W7arysp0i5bZJpZexAPiF1lr6oHoYr+bOHjN+18J6YG/FfiVozMFxbFj7vhEa+bsuxU3hb3BtU9bxPK1BicV/q8JadZGPpcA5Q/8ZK7JnsvCMHBzEAAgs53o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldVqn4ST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldVqn4ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40123C4CEF7;
	Tue, 17 Feb 2026 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771334360;
	bh=p3OesVCkD1eTGRXZtuB7DymQrZtUa90XZPMdfyANI4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ldVqn4STQxh0UI52lO2o849wAGh5kxkwMJ4wchztKtPUkZFYCccrJS7VijF4Yfha1
	 hHaVFncoNUmFblhBhWeDuOHhMitY0YXfcc+c1k8MKeacT7cOHhhS4+MuDCD8KRAq9W
	 5YP/metLcQCQAtxfrwlgo+Of7HieQmjfnQbM+sspMnBfzQJDqX4I8gSrpge8dZ8SQv
	 sXwgCD5xXzpDO9UQq9dIwj7umOTFhVJlgODSCsTioGv+WiYSiu1rWZWsWyGRbbGkRM
	 KK+L+bBDscFpKHyTVRxUI91JOOPoX6h1WqWjc+P49NkgGt0+zHJPMIr57pXIA5XZfY
	 nRO/04vaxVXGQ==
Date: Tue, 17 Feb 2026 14:19:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 REBASE] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code
 base
Message-ID: <aZRjL9KElwju605a@nidhogg.toxiclabs.cc>
References: <20260212131302.132709-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212131302.132709-3-lukas@herbolt.com>

On Thu, Feb 12, 2026 at 02:13:04PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
> v8 changes:
> 	rebase to v6.19
> 	add early check for not supported cases
> 
>  fs/xfs/xfs_bmap_util.c | 10 ++++++++--
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_file.c      | 39 ++++++++++++++++++++++++++-------------
>  3 files changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2208a720ec3f..942d35743b82 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -642,11 +642,17 @@ xfs_free_eofblocks(
>  	return error;
>  }
>  
> +/*
> + * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used there are no

"Callers can specify bmapi_flags" is unneeded here IMHO, the function
definition already states that.

> + * further checks whether the hard ware supports and it can fallback to
> + * software zeroing.

This sounds weird to me, but I'm not native English speaker. Also, I
don't think this comment belongs here, xfs_alloc_file_space() ignores
bmapi_flags, it just pass it along...


> + */
>  int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	uint32_t		bmapi_flags)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -748,7 +754,7 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				allocatesize_fsb, bmapi_flags, 0, imapp,
>  				&nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..2895cc97a572 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  
>  /* preallocation and hole punch interface */
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +		xfs_off_t len, uint32_t bmapi_flags);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7874cf745af3..2535db43ff25 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1293,6 +1293,7 @@ xfs_falloc_zero_range(
>  	unsigned int		blksize = i_blocksize(inode);
>  	loff_t			new_size = 0;
>  	int			error;
> +	uint32_t                bmapi_flags;
>  
>  	trace_xfs_zero_file_space(ip);
>  
> @@ -1300,18 +1301,27 @@ xfs_falloc_zero_range(
>  	if (error)
>  		return error;
>  
> -	if (xfs_falloc_force_zero(ip, ac)) {
> -		error = xfs_zero_range(ip, offset, len, ac, NULL);
> -	} else {
> -		error = xfs_free_file_space(ip, offset, len, ac);
> -		if (error)
> -			return error;
>  
> -		len = round_up(offset + len, blksize) -
> -			round_down(offset, blksize);
> -		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {

	... The comment probably belongs here and it can be short like
	(based on the same comment from Ext4):

	  /*
	   * Do not allow writing zeroes if the hardware does not
	   * support it
	   */

The rest of the patch looks fine to me, although Christoph likely will
also need to take a look on it because xfs_falloc_force_zero() behavior.

> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
> +			xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;
> +		bmapi_flags = XFS_BMAPI_ZERO;
> +	} else {
> +		if (xfs_falloc_force_zero(ip, ac)) {
> +			error = xfs_zero_range(ip, offset, len, ac, NULL);
> +			goto set_filesize;
> +		}
> +		bmapi_flags = XFS_BMAPI_PREALLOC;
>  	}
> +
> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> +	offset = round_down(offset, blksize);
> +
> +	error = xfs_alloc_file_space(ip, offset, len, bmapi_flags);
> +
> +set_filesize:
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1336,7 +1346,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1364,7 +1375,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1374,7 +1386,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1417,6 +1429,7 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_INSERT_RANGE:
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;
> 
> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> -- 
> 2.53.0
> 
> 
