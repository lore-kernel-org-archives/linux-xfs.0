Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68AA136342
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255944; cv=none; b=njgJjXvej4/yK26j6obq/6YyZsLI3uGoL5GBrMj0hJDypOkLUh+GYbz0hsA3hh4hZVVCFCaV0lhIUbuhF2ChSfpTal8fMobpGIJon0AnQrblAITKb8dJt6gR91mQ9vQijoYCGNEgzkaUIcINUw2ZxL6tiW5RUiYcs8lBb8BxWFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255944; c=relaxed/simple;
	bh=WdiVBp32qyjyY9UanN5eNWX2hXI2yiL0Q+NyQaCet0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pUK/tRZBQWygs92PIrXU8P1f+w2wl9GuFSJbT60KdzLy3qL6DWPyx0P/ZwLIDf4NniVDAOGW3V7kFP9pfbobk+7TEALEsWLcHXe0ry7GTIE93tjXgDRhk09PwggzOGpqaFLcodfbAQOcxTHR8gII4esmmVwTxbaY//SicE+tGG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n68ehrio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n68ehrio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B3EC4AF09;
	Wed, 21 Aug 2024 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724255944;
	bh=WdiVBp32qyjyY9UanN5eNWX2hXI2yiL0Q+NyQaCet0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n68ehrioP349UVeeUlMz4yExncYg+jVB9DNs78C/b6nh00GvRF5DsL5VFXAirl4oX
	 Rzjc7Q8Yv/XXDeOHBXkKZQpSeK0sFIIj3LYN4ux+7PQQDtjn8yUeXd+DdxDFeRHDTT
	 ZMl1q6d4xiqsKLn+YJouG9f8J9H2ZrcQnS8WzepdUSHDf2SF8eXnuDK+m2ZjaiLyHb
	 iTaiAi2lbF+xzNJU7DwAV5RShFFhEqVm0pNI0F9AxX5AfyHSXQBfuWQjtjBhBxgK/R
	 qwRlZy5xt1ZQMbJnOdU+vj0ZRtSsZe0jQbQF+j7+B3SEHIXxcCT2JnH1vxAPmuqbZB
	 gDGBwYgQCJqAA==
Date: Wed, 21 Aug 2024 08:59:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fold xfs_bmap_alloc_userdata into
 xfs_bmapi_allocate
Message-ID: <20240821155903.GY865349@frogsfrogsfrogs>
References: <20240820170517.528181-1-hch@lst.de>
 <20240820170517.528181-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-5-hch@lst.de>

On Tue, Aug 20, 2024 at 07:04:55PM +0200, Christoph Hellwig wrote:
> Userdata and metadata allocations end up in the same allocation helpers.
> Remove the separate xfs_bmap_alloc_userdata function to make this more
> clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to combine these
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a63be14a9873e8..1db9d084a44c47 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4167,43 +4167,6 @@ xfs_bmapi_reserve_delalloc(
>  	return error;
>  }
>  
> -static int
> -xfs_bmap_alloc_userdata(
> -	struct xfs_bmalloca	*bma)
> -{
> -	struct xfs_mount	*mp = bma->ip->i_mount;
> -	int			whichfork = xfs_bmapi_whichfork(bma->flags);
> -	int			error;
> -
> -	/*
> -	 * Set the data type being allocated. For the data fork, the first data
> -	 * in the file is treated differently to all other allocations. For the
> -	 * attribute fork, we only need to ensure the allocated range is not on
> -	 * the busy list.
> -	 */
> -	bma->datatype = XFS_ALLOC_NOBUSY;
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
> -		bma->datatype |= XFS_ALLOC_USERDATA;
> -		if (bma->offset == 0)
> -			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> -
> -		if (mp->m_dalign && bma->length >= mp->m_dalign) {
> -			error = xfs_bmap_isaeof(bma, whichfork);
> -			if (error)
> -				return error;
> -		}
> -
> -		if (XFS_IS_REALTIME_INODE(bma->ip))
> -			return xfs_bmap_rtalloc(bma);
> -	}
> -
> -	if (unlikely(XFS_TEST_ERROR(false, mp,
> -			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> -		return xfs_bmap_exact_minlen_extent_alloc(bma);
> -
> -	return xfs_bmap_btalloc(bma);
> -}
> -
>  static int
>  xfs_bmapi_allocate(
>  	struct xfs_bmalloca	*bma)
> @@ -4221,15 +4184,35 @@ xfs_bmapi_allocate(
>  	else
>  		bma->minlen = 1;
>  
> -	if (bma->flags & XFS_BMAPI_METADATA) {
> -		if (unlikely(XFS_TEST_ERROR(false, mp,
> -				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> -			error = xfs_bmap_exact_minlen_extent_alloc(bma);
> -		else
> -			error = xfs_bmap_btalloc(bma);
> -	} else {
> -		error = xfs_bmap_alloc_userdata(bma);
> +	if (!(bma->flags & XFS_BMAPI_METADATA)) {
> +		/*
> +		 * For the data and COW fork, the first data in the file is
> +		 * treated differently to all other allocations. For the
> +		 * attribute fork, we only need to ensure the allocated range
> +		 * is not on the busy list.
> +		 */
> +		bma->datatype = XFS_ALLOC_NOBUSY;
> +		if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
> +			bma->datatype |= XFS_ALLOC_USERDATA;
> +			if (bma->offset == 0)
> +				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> +
> +			if (mp->m_dalign && bma->length >= mp->m_dalign) {
> +				error = xfs_bmap_isaeof(bma, whichfork);
> +				if (error)
> +					return error;
> +			}
> +		}
>  	}
> +
> +	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
> +	    XFS_IS_REALTIME_INODE(bma->ip))
> +		error = xfs_bmap_rtalloc(bma);
> +	else if (unlikely(XFS_TEST_ERROR(false, mp,
> +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +		error = xfs_bmap_exact_minlen_extent_alloc(bma);
> +	else
> +		error = xfs_bmap_btalloc(bma);
>  	if (error)
>  		return error;
>  	if (bma->blkno == NULLFSBLOCK)
> -- 
> 2.43.0
> 
> 
