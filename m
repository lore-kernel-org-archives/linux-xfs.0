Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F83B34A765
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 08:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872227; cv=none; b=kzW56PU04SZLDqeZmwiebhNwxM+zFtNAWsJzsr/jxwjfOcS8R5nliQ3igojunheOTkY4imER+bk668Fbwz3MFCelw2Fwz+lC1LnuCk28vjtbpHKoFvKCRqi8B8Jl7Hy34GjMUM8sGJIcfDIlhGWoKCb1er8jAWcXglhiimGTcWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872227; c=relaxed/simple;
	bh=ok750ti1d93Tj4yLbb/pG8f5H3ZVWqE2tc0BWxwpT/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtgYwWQDGNUEZPmgQXO1skDhWjP9sBXifneIYRLdT6zNvPbxLmi5LvxLPiCfYHCA1gPF/vZj9ugNBO78kzj3nI+SLEpyDMFy7kngZc4TbpLJSAnpZ9HJQD0ycJEdgqdlPKKbGQhoUQ0LU1q0vswPqt83oeelqcndFeH3+fZHu7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sUi8R5m9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sUi8R5m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC58CC113D0;
	Tue, 16 Dec 2025 08:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872226;
	bh=ok750ti1d93Tj4yLbb/pG8f5H3ZVWqE2tc0BWxwpT/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sUi8R5m9+7nWlWCr2FTt2PlhIkuhO9yc00CRvJW121uzEmJp8k5ArrP5BpsdKqIP9
	 STvTZrF55vxyKOnixdLUzW+Jb4jcHZsc/nlRVeGIx5QNzAqJOYjeMIYPfwtAj6Tpnt
	 FnPQxJvUsN+gsKF6/zpWHcZLOklAblqI4EB6EJOrGJ4FinPOKZLZlss5aiFLhK5Yk6
	 hLtB54sesSRaCsNLenolzGPzjnFVo7V/cJ+EmBrOSSnd6tiN4HteQT7XkXP4FVMU4R
	 F6nZVvdn/mjb00XG1G5Ap0ARjXqP5rifqk1mDfdACapNDz5tdxYTTTklGWFUoOy7It
	 8S1OpRKiMnZdQ==
Date: Tue, 16 Dec 2025 09:03:42 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <ffgi6wyu52fnaprwf3yh55zu7w54jnzeujfqhojpevntzfd4an@bpjnajccspt2>
References: <P_OCd7pNcLvRe038VeBLKmIi6KSgitIcPVyjn56Ucs9A34-ckTtKbjGP08W5TLKsAjB8PriOequE0_FNUOny-Q==@protonmail.internalid>
 <20251215060654.478876-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215060654.478876-1-hch@lst.de>

> 
> +/*
> + * For various operations we need to zero up to one block each at each end of

							^^^
					Is this correct? Or should have it been
					"one block at each end..." ?

Not native English speaker so just double checking. I can update it when
applying if it is not correct.

Other than that:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> + * the affected range.  For zoned file systems this will require a space
> + * allocation, for which we need a reservation ahead of time.
> + */
> +#define XFS_ZONED_ZERO_EDGE_SPACE_RES		2
> +
> +/*
> + * Zero range implements a full zeroing mechanism but is only used in limited
> + * situations. It is more efficient to allocate unwritten extents than to
> + * perform zeroing here, so use an errortag to randomly force zeroing on DEBUG
> + * kernels for added test coverage.
> + *
> + * On zoned file systems, the error is already injected by
> + * xfs_file_zoned_fallocate, which then reserves the additional space needed.
> + * We only check for this extra space reservation here.
> + */
> +static inline bool
> +xfs_falloc_force_zero(
> +	struct xfs_inode		*ip,
> +	struct xfs_zone_alloc_ctx	*ac)
> +{
> +	if (xfs_is_zoned_inode(ip)) {
> +		if (ac->reserved_blocks > XFS_ZONED_ZERO_EDGE_SPACE_RES) {
> +			ASSERT(IS_ENABLED(CONFIG_XFS_DEBUG));
> +			return true;
> +		}
> +		return false;
> +	}
> +	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
> +}
> +
>  /*
>   * Punch a hole and prealloc the range.  We use a hole punch rather than
>   * unwritten extent conversion for two reasons:
> @@ -1268,14 +1300,7 @@ xfs_falloc_zero_range(
>  	if (error)
>  		return error;
> 
> -	/*
> -	 * Zero range implements a full zeroing mechanism but is only used in
> -	 * limited situations. It is more efficient to allocate unwritten
> -	 * extents than to perform zeroing here, so use an errortag to randomly
> -	 * force zeroing on DEBUG kernels for added test coverage.
> -	 */
> -	if (XFS_TEST_ERROR(ip->i_mount,
> -			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
> +	if (xfs_falloc_force_zero(ip, ac)) {
>  		error = xfs_zero_range(ip, offset, len, ac, NULL);
>  	} else {
>  		error = xfs_free_file_space(ip, offset, len, ac);
> @@ -1423,13 +1448,26 @@ xfs_file_zoned_fallocate(
>  {
>  	struct xfs_zone_alloc_ctx ac = { };
>  	struct xfs_inode	*ip = XFS_I(file_inode(file));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_filblks_t		count_fsb;
>  	int			error;
> 
> -	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
> +	/*
> +	 * If full zeroing is forced by the error injection knob, we need a
> +	 * space reservation that covers the entire range.  See the comment in
> +	 * xfs_zoned_write_space_reserve for the rationale for the calculation.
> +	 * Otherwise just reserve space for the two boundary blocks.
> +	 */
> +	count_fsb = XFS_ZONED_ZERO_EDGE_SPACE_RES;
> +	if ((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE &&
> +	    XFS_TEST_ERROR(mp, XFS_ERRTAG_FORCE_ZERO_RANGE))
> +		count_fsb += XFS_B_TO_FSB(mp, len) + 1;
> +
> +	error = xfs_zoned_space_reserve(mp, count_fsb, XFS_ZR_RESERVED, &ac);
>  	if (error)
>  		return error;
>  	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
> -	xfs_zoned_space_unreserve(ip->i_mount, &ac);
> +	xfs_zoned_space_unreserve(mp, &ac);
>  	return error;
>  }
> 
> --
> 2.47.3
> 
