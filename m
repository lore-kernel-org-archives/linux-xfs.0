Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E9E128822
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708325; cv=none; b=Xun0E7u3jltmUoGKaI5nF1ATIgLAPwUylD9G6mRwxr5UhZBNomjREz0homzwlPfhK0WvvxownyWnWdADpbff+NeWW7LlRu4wIKAU5kdt0JZtIO95urF7gUFUpe5ska40eV/GxJAhuzHZJ/ZD3rMMD89+RdnXpT+gX1KyZJn0oRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708325; c=relaxed/simple;
	bh=U67EBxvecmOFzKEs0pik/CTLvZMljGT9zlWPMpU7xpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RoIdZzjJ6Xkl8p1eNvq5FaqRZHm7H9muQMZTOga58VN0QHhB55bcsSk7Z5dCMpWRW4mFEDDHeuZ2eXoJAjVK7mKZHT3/XPT8YVZXSsiUKp0fuW8SNpDfj32nVVNlJEouCxKTAvt8AxihEKkg2yJZo2XsLJ/tV/EtOgcA+0Qmafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAOxmJb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAOxmJb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD2AC433C7;
	Fri, 23 Feb 2024 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708708325;
	bh=U67EBxvecmOFzKEs0pik/CTLvZMljGT9zlWPMpU7xpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LAOxmJb8v563ysU4rJSfbKHC78QksW9/AassB4Yt/cy0F+3X2tN77xYExz77Ozr9S
	 U3Gv+2OHEg4M6rrQ5HK/bWJUGXu/4IM48lwZlb1hGlRhqAw8MKhbhUNW9hXolROQO2
	 STGq56ZpzfQgT3A8rrkxGettPEIRCgG4akM6Sl+NTie7Ztqc5LLSxtJs98q9KjGZtj
	 Thz1VWt16nKh0/0EO+G54RslAVvA+QQ9IKLC4AyYvffH9pN136PGIo84HI3/Au7m9/
	 mvcfOs8M0w46/Odssu16IZ7fyrDAZfkNUi02oOSQ1iaj5hOGAdNjxJZN0kmWDdPBub
	 Q0k3VReni0J5g==
Date: Fri, 23 Feb 2024 09:12:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: reinstate RT support in
 xfs_bmapi_reserve_delalloc
Message-ID: <20240223171204.GR616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-6-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:01AM +0100, Christoph Hellwig wrote:
> Allocate data blocks for RT inodes using xfs_dec_frextents.  While at
> it optimize the data device case by doing only a single xfs_dec_fdblocks
> call for the extent itself and the indirect blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I like collapsing the two xfs_dec_fdblocks calls into one.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cc788cde8bffd6..95e93534cd1264 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3984,6 +3984,7 @@ xfs_bmapi_reserve_delalloc(
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
>  	xfs_extlen_t		alen;
>  	xfs_extlen_t		indlen;
> +	uint64_t		fdblocks;
>  	int			error;
>  	xfs_fileoff_t		aoff = off;
>  
> @@ -4026,14 +4027,18 @@ xfs_bmapi_reserve_delalloc(
>  	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
>  	ASSERT(indlen > 0);
>  
> -	error = xfs_dec_fdblocks(mp, alen, false);
> -	if (error)
> -		goto out_unreserve_quota;
> +	fdblocks = indlen;
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		error = xfs_dec_frextents(mp, xfs_rtb_to_rtx(mp, alen));
> +		if (error)
> +			goto out_unreserve_quota;
> +	} else {
> +		fdblocks += alen;
> +	}
>  
> -	error = xfs_dec_fdblocks(mp, indlen, false);
> +	error = xfs_dec_fdblocks(mp, fdblocks, false);
>  	if (error)
> -		goto out_unreserve_blocks;
> -
> +		goto out_unreserve_frextents;
>  
>  	ip->i_delayed_blks += alen;
>  	xfs_mod_delalloc(ip->i_mount, alen + indlen);
> @@ -4057,8 +4062,9 @@ xfs_bmapi_reserve_delalloc(
>  
>  	return 0;
>  
> -out_unreserve_blocks:
> -	xfs_add_fdblocks(mp, alen);
> +out_unreserve_frextents:
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, alen));
>  out_unreserve_quota:
>  	if (XFS_IS_QUOTA_ON(mp))
>  		xfs_quota_unreserve_blkres(ip, alen);
> -- 
> 2.39.2
> 
> 
