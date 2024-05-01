Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BEBD52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598879; cv=none; b=LIPnehzTbLe+TDHdHaCLPRTGMI8pzeBxbAab/JsUuIyRkGeeUjF85cAz9R+Ma9hJSlh9SQ6v+RvU2O2QRYy24eNE3vkT9Al52ziCLGsXjZatjJhC29lX3EZHsneJmmuXEYdzgdlAGDBOAgLzEZRGdkQTwN2OSrfIh/TmDJLsBW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598879; c=relaxed/simple;
	bh=sP0sBUcRwnUTpZz91+rg19opBeC8wuOSFtYZZUYZ7f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWjKyPf9Pe6Z0NjNjJcbEVHo8S67yzrKycVx3WJx6VeSvnqC7qybUxJ3SQhaT0H9sZrn/M1VUk15ef9H+Ik6aDTf76gedTdRmGu3IhEhE+qiJcV7rXO/kUvh416JQ7+HCodiAX+L9yHCAbAe5UbHEoVw7pacvhyglEwqel0iTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEYUCGqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEYUCGqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58F6C072AA;
	Wed,  1 May 2024 21:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598878;
	bh=sP0sBUcRwnUTpZz91+rg19opBeC8wuOSFtYZZUYZ7f0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mEYUCGqFu1uGw9j20TvY59nhiaWxxg57GLKF5qyLUVbODGzaEAaRQqjkzutUXcYLE
	 LOICtns5EHmpZu5ZGu63QDR9xneOk8Fy7oMKhvBncWfeMpiuitioNF0ZW04n2ZO0xn
	 e67yPUPpq/pYEPAbIDQd+cC9t6o5oVGyXLZ26O4m2QLN8OhdIv+3SyvWrMLRVEwsUi
	 nm0HvCdlGHOn6oFb6yxnz60edn53tsv3ognRdLW32rzDX2ybuumNI6ERTpieWeY/Mx
	 c2OAbLfgaebZExNTychZIbBBHUxxurZlLK8ssLlZWV1rz3wBJDIUuR5iJIVmSFtaJu
	 nBqM1NTlQbmQA==
Date: Wed, 1 May 2024 14:27:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: add xfs_dir2_block_overhead helper
Message-ID: <20240501212758.GZ360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-12-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:21PM +0200, Christoph Hellwig wrote:
> Add a common helper for the calculation of the overhead when converting
> a shortform to block format directory.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_priv.h  | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 12 ++++--------
>  3 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 378d3aefdd9ced..a19744cb43ca0c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1109,8 +1109,8 @@ xfs_dir2_sf_to_block(
>  	/*
>  	 * Compute size of block "tail" area.
>  	 */
> -	i = (uint)sizeof(*btp) +
> -	    (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t);
> +	i = xfs_dir2_block_overhead(sfp->count);
> +
>  	/*
>  	 * The whole thing is initialized to free by the init routine.
>  	 * Say we're using the leaf and tail area.
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 1e4401f9ec936e..bfbc73251f275a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -205,4 +205,16 @@ xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp,
>  enum xfs_dacmp xfs_dir2_compname(struct xfs_da_args *args,
>  		const unsigned char *name, int len);
>  
> +/*
> + * Overhead if we converted a shortform directory to block format.
> + *
> + * The extra two entries are because "." and ".." don't have real entries in
> + * the shortform format.
> + */
> +static inline unsigned int xfs_dir2_block_overhead(unsigned int count)
> +{
> +	return (count + 2) * sizeof(struct xfs_dir2_leaf_entry) +
> +		sizeof(struct xfs_dir2_block_tail);

I could've sworn there's a helper to compute this, but as I cannot find
it I guess I'll let that go.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +}
> +
>  #endif /* __XFS_DIR2_PRIV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 21e04594606b89..1e1dcdf83b8f95 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -629,9 +629,7 @@ xfs_dir2_sf_addname_pick(
>  	 * Calculate data bytes used excluding the new entry, if this
>  	 * was a data block (block form directory).
>  	 */
> -	used = offset +
> -	       (sfp->count + 3) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
> -	       (uint)sizeof(xfs_dir2_block_tail_t);
> +	used = offset + xfs_dir2_block_overhead(sfp->count + 1);
>  	/*
>  	 * If it won't fit in a block form then we can't insert it,
>  	 * we'll go back, convert to block, then try the insert and convert
> @@ -691,9 +689,7 @@ xfs_dir2_sf_check(
>  	}
>  	ASSERT(i8count == sfp->i8count);
>  	ASSERT((char *)sfep - (char *)sfp == dp->i_disk_size);
> -	ASSERT(offset +
> -	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
> -	       (uint)sizeof(xfs_dir2_block_tail_t) <= args->geo->blksize);
> +	ASSERT(offset + xfs_dir2_block_overhead(sfp->count));
>  }
>  #endif	/* DEBUG */
>  
> @@ -782,8 +778,8 @@ xfs_dir2_sf_verify(
>  		return __this_address;
>  
>  	/* Make sure this whole thing ought to be in local format. */
> -	if (offset + (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
> -	    (uint)sizeof(xfs_dir2_block_tail_t) > mp->m_dir_geo->blksize)
> +	if (offset + xfs_dir2_block_overhead(sfp->count) >
> +	    mp->m_dir_geo->blksize)
>  		return __this_address;
>  
>  	return NULL;
> -- 
> 2.39.2
> 
> 
