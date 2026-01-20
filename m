Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217DC314B83
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924673; cv=none; b=ix0eaZIAtBMfh9NX6BcUj9RJfTlv/fReQ7aZyx05Pf9vXreCxPJADHDtmJtJujQ8ZqjVGJKXcyyyjEY0eSlCFt8DefL0yA3Fmg0NV3FzlqoKJ4i29hmLf5qJm9OGOzMabTZ4yHYx9GqR7WI7JzqixqggrWuuPD/ZTlprWwWdExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924673; c=relaxed/simple;
	bh=1UswxSr/8ju25fUycxgQs8KNsdogT7eUPXXWSmeiMiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnWH9eV8CJZ08zAu/jk+c4ovBYvAfwR24N85iNQDCrcD0IK86qxC7YjA7UqtFlHC7Jrz+X9StuNo+rLX5GL7wJ/uHx4bmc0JIZkyDg6VUrAF++I6I6wuFeaY941gi8OH69W6fm9EK/QXyltc/EqQpKhbgywtCjLlPuVqnDFJT34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBrt4Kjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBrt4Kjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEB5C16AAE;
	Tue, 20 Jan 2026 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768924672;
	bh=1UswxSr/8ju25fUycxgQs8KNsdogT7eUPXXWSmeiMiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SBrt4KjonGQUDRILxTFzTihsqiDWBY8nr6ly7Q7pcnU9Ad75GI5rYYJRr+h3NirB1
	 JQOz7Z/nLEM+CS4PpDsZprApDJ445ubwPgLgKBecNECvYBzR3pJzs+cCf6BsWvd9bp
	 r6qJJ5x3OCE8CTsZHj4Huurl41Km+ME0M/6VUvtIZKYlIBFTQ/KGzGtTr74+sIUwLa
	 qvCJCkgJxSKR16/nJab5mesPZwmOJp9nwMllt8LMuRVcORGVIyiPOS2xKChUxLDahl
	 XJcBSZNn8qVUTJyjydxomj6cdQJzEZr1Z1gIaeSa1F06dKvhwmwtpaDBWJvlzSJh/A
	 WBWsIFkOQBYXA==
Date: Tue, 20 Jan 2026 07:57:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, lukas@herbolt.com
Subject: Re: [PATCH v7] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20260120155752.GN15551@frogsfrogsfrogs>
References: <20260120132056.534646-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120132056.534646-2-cem@kernel.org>

On Tue, Jan 20, 2026 at 02:20:50PM +0100, cem@kernel.org wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> the unmap write zeroes operation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> [cem: rewrite xfs_falloc_zero_range() bits]
> ---
> 
> Christoph, Darrick, could you please review/ack this patch again? I
> needed to rewrite the xfs_falloc_zero_range() bits, because it
> conflicted with 66d78a11479c and 8dc15b7a6e59. This version aims mostly
> to remove one of the if-else nested levels to keep it a bit cleaner.
> 
> please let me know if you agree with this version, otherwise I'll ask
> Lukas to rebase it on top of the new code.
> 
> Thanks!
> 
>  fs/xfs/xfs_bmap_util.c | 10 ++++++++--
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_file.c      | 38 +++++++++++++++++++++++++++-----------
>  3 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..74a7597d0998 100644
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
> index d36a9aafa8ab..b23f1373116e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1302,16 +1302,29 @@ xfs_falloc_zero_range(
>  
>  	if (xfs_falloc_force_zero(ip, ac)) {
>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
> -	} else {
> -		error = xfs_free_file_space(ip, offset, len, ac);
> -		if (error)
> -			return error;
> +		goto out;
> +	}
>  
> -		len = round_up(offset + len, blksize) -
> -			round_down(offset, blksize);
> -		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +	error = xfs_free_file_space(ip, offset, len, ac);
> +	if (error)
> +		return error;
> +
> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> +	offset = round_down(offset, blksize);
> +
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (xfs_is_always_cow_inode(ip) ||
> +		    !bdev_write_zeroes_unmap_sectors(
> +				xfs_inode_buftarg(ip)->bt_bdev))
> +			return -EOPNOTSUPP;

Taking a second look -- this code allows ZERO_RANGE|WRITE_ZEROES to
punch out the file space but then fail with EOPNOTSUPP.  I think if
we're going to error out that way, we should do that at the top of the
function before any changes are made.

--D

> +		error = xfs_alloc_file_space(ip, offset, len,
> +					     XFS_BMAPI_ZERO);
> +	} else {
> +		error = xfs_alloc_file_space(ip, offset, len,
> +					     XFS_BMAPI_PREALLOC);
>  	}
> +
> +out:
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1336,7 +1349,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1364,7 +1378,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1374,7 +1389,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1417,6 +1432,7 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_INSERT_RANGE:
>  		error = xfs_falloc_insert_range(file, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;
> -- 
> 2.52.0
> 
> 
