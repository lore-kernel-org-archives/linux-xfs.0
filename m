Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18F73B8D4C
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493950; cv=none; b=rk3pZ+0kD4HVWKrfCUrRILzxq8VDa451WGD6P7wMaDA2yINTnUNWX1hQOmU7wMBJ2A6XdfXgQBU0rFJhHdYAuNMDZ9cAcLWriiUhScCYjvKWgsRIgOBwz3FGEylxfQ4JJZAxcJfSJGyz5lWDKOo/Sj6X3tsUl034n7rytH45eKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493950; c=relaxed/simple;
	bh=hhiKQwstXbTmMtEtRW0TinBTBubtQbSF3SNh7nnCjFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IvZXD6IH055S7RjRvMjJyR8sWK3Ez+ar70qnBIVoPFM2gcJECC2YZaM1Rh4hhOwSEURnfrzySgqYBXuz/0F+AQJPTQLAYMXRwATz75jZmr8z4yVr48EryDYES5felD00VXTmGEHGZ8d3EWKt5u6XTQ29BRCS7CjgfeDsMCH47Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X18wQ0q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X18wQ0q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909CFC4AF09;
	Thu, 15 Jan 2026 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768493949;
	bh=hhiKQwstXbTmMtEtRW0TinBTBubtQbSF3SNh7nnCjFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X18wQ0q0oNT5s01/kfhqJDhjMO5OsudI+E8WSXW7715hNdPOzvjMQ+ssXUH6epbUy
	 Cj2Z7qpectc/jxa75z5cDncirLn2oqHZDP0FemOYpnTyk+Lj0S+Vj/quYJiMryx01M
	 YDl4bxppQ/vbFplVQk3uj3PlSPiAbFIfreCbGizV5ivItbC0omsXbRHpSd0EaU05qE
	 RvsDJXCShhkdWoLHTAFNpUmPMicFOTiRbThDNL8nIUcKbQqRT/nuqv3oDmV0Lrx3AJ
	 1GU+j0s+JEHuxjViLiErTSZC5bkhnDdDemDllmmo21rmpVGeWlS8jaxJods3HI8Lz3
	 tI++NtvPqADog==
Date: Thu, 15 Jan 2026 08:19:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RESEND v6] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code
 base
Message-ID: <20260115161908.GV15551@frogsfrogsfrogs>
References: <20260115092615.21110-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092615.21110-1-lukas@herbolt.com>

On Thu, Jan 15, 2026 at 10:26:15AM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me now, thanks for taking this on!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 10 ++++++++--
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_file.c      | 25 +++++++++++++++++++------
>  3 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 06ca11731e430..ee5765bf52944 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -642,11 +642,17 @@ xfs_free_eofblocks(
>  	return error;
>  }
>  
> +/*
> + * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used there are no
> + * further checks whether the hard ware supports and it can fallback to
> + * software zeroing.
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
> index c477b33616304..2895cc97a5728 100644
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
> index f96fbf5c54c99..040e4407a8a07 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1261,23 +1261,33 @@ xfs_falloc_zero_range(
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
> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
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
> @@ -1302,7 +1312,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1330,7 +1341,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1340,7 +1352,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1383,6 +1395,7 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_INSERT_RANGE:
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;
> -- 
> 2.51.1
> 
> 
