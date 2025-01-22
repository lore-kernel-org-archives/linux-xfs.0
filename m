Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EAC1B87F1
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737528911; cv=none; b=TrRoZymnpwOCh5kV+Cooh6Qyj+yXto3bNbkUsvFspLRpaEwewP8ZvkTNRKfUIqCZewgll0VHqjJI40G7XyfIOObvi+0HJsZ/59G/yinaC0Q6vCOWOTqRNbQVy9c9ReqTOKq2/t7RiqVi8sfn4PIdC+0Jtf5RQsIq0E3XvG/xU0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737528911; c=relaxed/simple;
	bh=gSMMAD+vHpCtKbb0wJ9fZ47RpakSwnK3RW8VQdFmJm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usJzWHOPEa11v7YzurXcfzibr7UV4prCAv40da66pDM5paUGYhFTGW8Z3TdhbLUF+KB8kh398QDrOvIvy3T/wuPv60wK98Vw62KOyGWD2tJPBv167gbZZdGesIApHBq3xDeEVtPrfQudRWP4xVPgH/q4utNJI/fySbg3uQ4YRyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2SqA7sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2SqA7sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A17C4CED6;
	Wed, 22 Jan 2025 06:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737528911;
	bh=gSMMAD+vHpCtKbb0wJ9fZ47RpakSwnK3RW8VQdFmJm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2SqA7say7MvzfT/ZbwD+/pa43E0Tr3Rkn04DHEXZx0W7nsjAO3DjDqVC2cyv9XAw
	 UlXxOaVf6Gb9E2px+FUheUwxwbS4b20FSLGoag4QPof5pcY2p8M4tt+u7/gNaVr2zR
	 GtIRlL2TDtpMCanDvxKfLAGPevWQJnAk+oQmn2M7nIUscQ0sAF4NB9iehdhbiP/Mzz
	 624uhZ+gLEHmp6bB3e1IowuHLDb3IE5VTi1K0aNr6ZkoePuYGcApNH9vW4G/MlqtsO
	 TuDthcyrJ64cgOcf6oknDgG6sIEN8QTxMd2VAN2saYm3k1mM301vCIuYqNqkTThQak
	 Hnabez1rzGxnA==
Date: Tue, 21 Jan 2025 22:55:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, amir73il@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't call remap_verify_area with sb write
 protection held
Message-ID: <20250122065510.GA1611770@frogsfrogsfrogs>
References: <20250122054321.910578-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122054321.910578-1-hch@lst.de>

On Wed, Jan 22, 2025 at 06:43:21AM +0100, Christoph Hellwig wrote:
> The XFS_IOC_EXCHANGE_RANGE ioctl with the XFS_EXCHANGE_RANGE_TO_EOF flag
> operates on a range bounded by the end of the file.  This means the
> actual amount of blocks exchanged is derived from the inode size, which
> is only stable with the IOLOCK (i_rwsem) held.  Do that, it currently
> calls remap_verify_area from inside the sb write protection which nests
> outside the IOLOCK.  But this makes fsnotify_file_area_perm which is
> called from remap_verify_area unhappy when the kernel is built with
> lockdep and the recently added CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> option.
> 
> Fix this by always calling remap_verify_area before taking the write
> protection, and passing a 0 size to remap_verify_area similar to
> the FICLONE/FICLONERANGE ioctls when they are asked to clone until
> the file end.
> 
> (Note: the size argument gets passed to fsnotify_file_area_perm, but
> then isn't actually used there).
> 
> Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I shudder to think of what happens if security_file_permission tries
to take i_rwsem in the old _TO_EOF case -- that sounds like a livelock
vector.  How about:

Cc: <stable@vger.kernel.org> # v6.10
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_exchrange.c | 71 ++++++++++++++++--------------------------
>  1 file changed, 27 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
> index f340a2015c4c..0b41bdfecdfb 100644
> --- a/fs/xfs/xfs_exchrange.c
> +++ b/fs/xfs/xfs_exchrange.c
> @@ -329,22 +329,6 @@ xfs_exchrange_mappings(
>   * successfully but before locks are dropped.
>   */
>  
> -/* Verify that we have security clearance to perform this operation. */
> -static int
> -xfs_exchange_range_verify_area(
> -	struct xfs_exchrange	*fxr)
> -{
> -	int			ret;
> -
> -	ret = remap_verify_area(fxr->file1, fxr->file1_offset, fxr->length,
> -			true);
> -	if (ret)
> -		return ret;
> -
> -	return remap_verify_area(fxr->file2, fxr->file2_offset, fxr->length,
> -			true);
> -}
> -
>  /*
>   * Performs necessary checks before doing a range exchange, having stabilized
>   * mutable inode attributes via i_rwsem.
> @@ -355,11 +339,13 @@ xfs_exchange_range_checks(
>  	unsigned int		alloc_unit)
>  {
>  	struct inode		*inode1 = file_inode(fxr->file1);
> +	loff_t			size1 = i_size_read(inode1);
>  	struct inode		*inode2 = file_inode(fxr->file2);
> +	loff_t			size2 = i_size_read(inode2);
>  	uint64_t		allocmask = alloc_unit - 1;
>  	int64_t			test_len;
>  	uint64_t		blen;
> -	loff_t			size1, size2, tmp;
> +	loff_t			tmp;
>  	int			error;
>  
>  	/* Don't touch certain kinds of inodes */
> @@ -368,24 +354,25 @@ xfs_exchange_range_checks(
>  	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
>  		return -ETXTBSY;
>  
> -	size1 = i_size_read(inode1);
> -	size2 = i_size_read(inode2);
> -
>  	/* Ranges cannot start after EOF. */
>  	if (fxr->file1_offset > size1 || fxr->file2_offset > size2)
>  		return -EINVAL;
>  
> -	/*
> -	 * If the caller said to exchange to EOF, we set the length of the
> -	 * request large enough to cover everything to the end of both files.
> -	 */
>  	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) {
> +		/*
> +		 * If the caller said to exchange to EOF, we set the length of
> +		 * the request large enough to cover everything to the end of
> +		 * both files.
> +		 */
>  		fxr->length = max_t(int64_t, size1 - fxr->file1_offset,
>  					     size2 - fxr->file2_offset);
> -
> -		error = xfs_exchange_range_verify_area(fxr);
> -		if (error)
> -			return error;
> +	} else {
> +		/*
> +		 * Otherwise we require both ranges to end within EOF.
> +		 */
> +		if (fxr->file1_offset + fxr->length > size1 ||
> +		    fxr->file2_offset + fxr->length > size2)
> +			return -EINVAL;
>  	}
>  
>  	/*
> @@ -401,15 +388,6 @@ xfs_exchange_range_checks(
>  	    check_add_overflow(fxr->file2_offset, fxr->length, &tmp))
>  		return -EINVAL;
>  
> -	/*
> -	 * We require both ranges to end within EOF, unless we're exchanging
> -	 * to EOF.
> -	 */
> -	if (!(fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF) &&
> -	    (fxr->file1_offset + fxr->length > size1 ||
> -	     fxr->file2_offset + fxr->length > size2))
> -		return -EINVAL;
> -
>  	/*
>  	 * Make sure we don't hit any file size limits.  If we hit any size
>  	 * limits such that test_length was adjusted, we abort the whole
> @@ -747,6 +725,7 @@ xfs_exchange_range(
>  {
>  	struct inode		*inode1 = file_inode(fxr->file1);
>  	struct inode		*inode2 = file_inode(fxr->file2);
> +	loff_t			check_len = fxr->length;
>  	int			ret;
>  
>  	BUILD_BUG_ON(XFS_EXCHANGE_RANGE_ALL_FLAGS &
> @@ -779,14 +758,18 @@ xfs_exchange_range(
>  		return -EBADF;
>  
>  	/*
> -	 * If we're not exchanging to EOF, we can check the areas before
> -	 * stabilizing both files' i_size.
> +	 * If we're exchanging to EOF we can't calculate the length until taking
> +	 * the iolock.  Pass a 0 length to remap_verify_area similar to the
> +	 * FICLONE and FICLONERANGE ioctls that support cloning to EOF as well.
>  	 */
> -	if (!(fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF)) {
> -		ret = xfs_exchange_range_verify_area(fxr);
> -		if (ret)
> -			return ret;
> -	}
> +	if (fxr->flags & XFS_EXCHANGE_RANGE_TO_EOF)
> +		check_len = 0;
> +	ret = remap_verify_area(fxr->file1, fxr->file1_offset, check_len, true);
> +	if (ret)
> +		return ret;
> +	ret = remap_verify_area(fxr->file2, fxr->file2_offset, check_len, true);
> +	if (ret)
> +		return ret;
>  
>  	/* Update cmtime if the fd/inode don't forbid it. */
>  	if (!(fxr->file1->f_mode & FMODE_NOCMTIME) && !IS_NOCMTIME(inode1))
> -- 
> 2.45.2
> 
> 
