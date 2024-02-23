Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9ED13BAC2
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709208; cv=none; b=OBFORFeNjTAm+PBjGNHAXs5RqUlJroFktrSJHl1S7B8dHLOFq/bfPTkImnUrbB5owiU/lDlGWeEkPOHki84v7WEF4cboA5llRy60hgA3hf42eODfjmJIx58eaJMVE214eO+zTySNE0VuXHxUgFNn5v5H2cgt0z4IS/vBWNBOkHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709208; c=relaxed/simple;
	bh=SVgF/pxH9AtCm+PG2RrHf4rkCZQCLNoboTT0/Hh0x0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bb5mjpcQsBH9wNw605Han8N5KmP2WECB9WjsLsUZ6jifDZfRRZrXiCelpCOfORLpsRFfo0tftMpk+eeEtA496F+cZuQ0UDWioc8UrDk56ofBv6RgM6/HzQJjZ4wjBqs+cY/I72Y9jrEifxD7ccOwfFw6X3Q0JzvpwyOL0xLwblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpAqRcYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpAqRcYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A216C43399;
	Fri, 23 Feb 2024 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708709207;
	bh=SVgF/pxH9AtCm+PG2RrHf4rkCZQCLNoboTT0/Hh0x0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bpAqRcYiTf4E79lt1wSIXm1FZKBlNS2bxEp4riF3R8RySuVZ76Mj6vxvggzEyvr0F
	 djBnP2wqVTNi/40QeAf/L/da45akTPJNLUecpRGPiKQoMBeCKEwd8x3GtJEtCrqVl3
	 dgubrTPxFr/SihdxZL9VbIxIveOZMkE1ApkS3rPcqCxDg0OeTJa8qcDiqHzjVgFt/5
	 NATFhNiPqM8zTgHKgQHeLGcuxpCe2+xnnTCWB36yGQZEQ7ES/GtbpUlrALGJ3XHpM3
	 mN+n4VAEyvwEeY5VtEveM/y9kwKFZeLR3SY5Bhj4dwhIac2uHunzNoyOqSJ9KSLNBk
	 0ukRj6o10Aq7w==
Date: Fri, 23 Feb 2024 09:26:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: reinstate delalloc for RT inodes (if
 sb_rextsize == 1)
Message-ID: <20240223172646.GW616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-11-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:06AM +0100, Christoph Hellwig wrote:
> Commit aff3a9edb708 ("xfs: Use preallocation for inodes with extsz
> hints") disabled delayed allocation for all inodes with extent size
> hints due a data exposure problem.  It turns out we fixed this data
> exposure problem since by always creating unwritten extents for
> delalloc conversions due to more data exposure problems, but the
> writeback path doesn't actually support extent size hints when
> converting delalloc these days, which probably isn't a problem given
> that people using the hints know what they get.
> 
> However due to the way how xfs_get_extsz_hint is implemented, it
> always claims an extent size hint for RT inodes even if the RT
> extent size is a single FSB.  Due to that the above commit effectively
> disabled delalloc support for RT inodes.
> 
> Switch xfs_get_extsz_hint to return 0 for this case and work around
> that in a few places to reinstate delalloc support for RT inodes on
> file systems with an sb_rextsize of 1.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woot!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c   | 3 ++-
>  fs/xfs/xfs_iomap.c   | 2 --
>  fs/xfs/xfs_iops.c    | 2 +-
>  fs/xfs/xfs_rtalloc.c | 2 ++
>  4 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 37ec247edc1332..9e12278d1b62cd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -60,7 +60,8 @@ xfs_get_extsz_hint(
>  		return 0;
>  	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
>  		return ip->i_extsize;
> -	if (XFS_IS_REALTIME_INODE(ip))
> +	if (XFS_IS_REALTIME_INODE(ip) &&
> +	    ip->i_mount->m_sb.sb_rextsize > 1)
>  		return ip->i_mount->m_sb.sb_rextsize;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e6abe56d1f1f23..aea4e29ebd6785 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -992,8 +992,6 @@ xfs_buffered_write_iomap_begin(
>  		return xfs_direct_write_iomap_begin(inode, offset, count,
>  				flags, iomap, srcmap);
>  
> -	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> -
>  	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index be102fd49560dc..ca60ba060fd5c9 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -521,7 +521,7 @@ xfs_stat_blksize(
>  	 * always return the realtime extent size.
>  	 */
>  	if (XFS_IS_REALTIME_INODE(ip))
> -		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip));
> +		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip) ? : 1);
>  
>  	/*
>  	 * Allow large block sizes to be reported to userspace programs if the
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 2f85567f3d756b..9c7fba175b9025 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1340,6 +1340,8 @@ xfs_bmap_rtalloc(
>  	int			error;
>  
>  	align = xfs_get_extsz_hint(ap->ip);
> +	if (!align)
> +		align = 1;
>  retry:
>  	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
>  					align, 1, ap->eof, 0,
> -- 
> 2.39.2
> 
> 
