Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D730C3BD635
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281646; cv=none; b=lE2363jSoXA1nY8Ts5s1PMplKbxOsPc5OgdhRVMdK1Atd5lc/DXNvfRiE9ylMb48Nx4WwUFwoklZybKmzXkxCjMv6VRnUEYoFl2VAEF+LBWd0K7bvUc/xHWVNP8YL/zv/pskZSWhaNp9rclJLyMhJg2QDsidow8vqQ/gna6jKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281646; c=relaxed/simple;
	bh=U/dhmTNDH2J0OX+X/Tfu5zjaShywn8mFksmuxecVl+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=augUZ3Xr+3rNFOWFr9wJ8DWjEHASGXySPxafpzFm9b+wNNi5pLL2TgKSWseQIXeX2tRm1w9SADYCHgUqVrY5EN28Em3GsXPkNI6q8MrQZfBZNd52Ghktw8n/tsBIWwVpf5Pw42RUVl0FtWg4SJTNpyV4AGhQtrqGnI7+e9FJtbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gle6L95m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gle6L95m"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 04C6B1F000FF;
	Thu, 24 Sep 2026 20:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281639;
	bh=acmZ3yDCsaS1AyqjthlebcLtJifF2lpzctGG6BrspXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gle6L95mhdW3/+YJuj7id1iVyLvpg03OtSsxpjoD297mCcImCGSXhvehWPYTpktLL
	 OGIAcf/FMfAildLOzL49PLvG+FdN3tVsnnIyWvdfqu34/2lPzpLcIG4FqtsqD6scdv
	 hIdk9m74HcRz8BKMSWLJMi5XrpC/1pTLKlUYqc/dJMplV43MV+ZkCNiHC9EdHkRk2G
	 8Ha3faaktepUvdz+0lKGTGTvDZDpx5GGeG9T/Ir8b07J1LrCF/NRaCabVcPUJ/BygO
	 ZrbQOLt1mjnt775en7O2A7BPNpyw/xmY5uqO+6xsh3WwxU+jP5NADDiujzyQktb+hJ
	 dPImspkygzkDA==
Date: Thu, 24 Sep 2026 13:27:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: factor out a xfs_zoned_fill_srcmap helper
Message-ID: <20260924202718.GX2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-9-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:09AM +0200, Christoph Hellwig wrote:
> The code filling the srcmap in xfs_zoned_buffered_write_iomap_begin isn't
> terribly complicated, but fairly deeply indented and will become a bit
> more complex soon.  Factor it into a helper and add some comments.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This hoist looks fine. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 53 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 35 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7c6238fed61e..7bc17f179be7 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1588,6 +1588,37 @@ xfs_bmapi_reserve_delalloc(
>  	return error;
>  }
>  
> +static int
> +xfs_zoned_fill_srcmap(
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_fileoff_t		*end_fsb,
> +	unsigned		flags,
> +	struct iomap		*srcmap)
> +{
> +	struct xfs_bmbt_irec	smap;
> +	struct xfs_iext_cursor	scur;
> +
> +	if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &scur, &smap))
> +		smap.br_startoff = *end_fsb; /* fake hole until EOF */
> +	if (smap.br_startoff > offset_fsb) {
> +		/*
> +		 * There is a hole at @offset_fsb.  Only map until the end of
> +		 * the of it.
> +		 */
> +		*end_fsb = min(*end_fsb, smap.br_startoff);
> +		return 0;
> +	}
> +
> +	/*
> +	 * There is a data fork mapping, only map until the end of it.
> +	 */
> +	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
> +	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
> +	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
> +			xfs_iomap_inode_sequence(ip, 0));
> +}
> +
>  static int
>  xfs_zoned_buffered_write_iomap_begin(
>  	struct inode		*inode,
> @@ -1655,24 +1686,10 @@ xfs_zoned_buffered_write_iomap_begin(
>  	if (!IS_ALIGNED(offset, mp->m_sb.sb_blocksize) ||
>  	    !IS_ALIGNED(offset + count, mp->m_sb.sb_blocksize) ||
>  	    (flags & IOMAP_ZERO)) {
> -		struct xfs_bmbt_irec	smap;
> -		struct xfs_iext_cursor	scur;
> -
> -		if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &scur,
> -				&smap))
> -			smap.br_startoff = end_fsb; /* fake hole until EOF */
> -		if (smap.br_startoff > offset_fsb) {
> -			end_fsb = min(end_fsb, smap.br_startoff);
> -		} else {
> -			end_fsb = min(end_fsb,
> -				smap.br_startoff + smap.br_blockcount);
> -			xfs_trim_extent(&smap, offset_fsb,
> -					end_fsb - offset_fsb);
> -			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
> -					xfs_iomap_inode_sequence(ip, 0));
> -			if (error)
> -				goto out_unlock;
> -		}
> +		error = xfs_zoned_fill_srcmap(ip, offset_fsb, &end_fsb, flags,
> +				srcmap);
> +		if (error)
> +			goto out_unlock;
>  	}
>  
>  	if (!ip->i_cowfp)
> -- 
> 2.53.0
> 
> 
