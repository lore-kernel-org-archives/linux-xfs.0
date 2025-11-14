Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3633358BC
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138677; cv=none; b=tX2QPjGqmkiFLIud0AURXR2nGqxFiDuKOCDlWZvUXREnfBNGM3vqK4srDYOgVSRALMxs4ZcbUh9+lr7LDYj9OPT3xwQT+2psmzNlCRowxW/YO1iSzIc2N0YV//dkiuP7hABgj2jPCaip8R7bnQ8TesYhpxQZWqxgJHZWQ9uxxBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138677; c=relaxed/simple;
	bh=y11jh129VzpLg1lcfaYjRW4POIy0FP8Mzkz+l0q9EE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCkAMoyF7N1PDjpbXao3VQpEUYCjclaWIyFyhooZVztfep/eSq/hNP2kCsF0ABm8cg4xdBB2KHdgpHo1TuTV5HlVc5QbN53KDqlo+gM5uPxvqk/6Mn0r6I0mIXKCDSIxFbIJDrPA8j9jPvMy2YgyvpJwb2qo6RRyC3wzIb4bppk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZ3cq0VT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZ3cq0VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A6C19422;
	Fri, 14 Nov 2025 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763138677;
	bh=y11jh129VzpLg1lcfaYjRW4POIy0FP8Mzkz+l0q9EE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PZ3cq0VTfkREixDUaCuCBs3PQKE8ESDxN4mAPiAfjCpK7HL4I3kuhx/YJyDqMbelS
	 OUHF1HT0z2HV+nOo3tdF6SV8/ihxVoNNGkwU/NQ5yck3vtxgE3sM+K2m24h7/KAuIR
	 qIBbxWzvjNmb7tOi7WuZdVhBk3j3FrGnTGcwRUEUGgDI3Y8aAo9s6fcIjt0Gk/GLMg
	 R2SsdihXETmG1bgidXk6+JUxws/jN8JkokAT1XJKJa7mYdqjmAN7Hw3DqHxzTztaP4
	 Gr+Tou2MeErNEMzWgWHxPLGjXB/9M0TwmHRq1GL8F813CcVLNrk5SZuwkNAWJTE5iC
	 S7IPMMcxRdMeg==
Date: Fri, 14 Nov 2025 08:44:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20251114164436.GE196370@frogsfrogsfrogs>
References: <aRWB3ZCiCBQ8TcGR@infradead.org>
 <20251114085524.1468486-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114085524.1468486-3-lukas@herbolt.com>

On Fri, Nov 14, 2025 at 09:55:26AM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
> v5 changes:
> 	formating
> 
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
> index f96fbf5c54c99..3ed11b1028563 100644
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
> +				!bdev_write_zeroes_unmap_sectors(
> +					xfs_inode_buftarg(ip)->bt_bdev))

I think hch was asking for this indentation:

		if (xfs_is_always_cow_inode(ip) ||
		    !bdev_write_zeroes_unmap_sectors(
				xfs_inode_buftarg(ip)->bt_bdev))
			return -EOPNOTSUPP;

(otherwise the code looks correct to me)

--D

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
