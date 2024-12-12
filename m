Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CCD1D79BE
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041203; cv=none; b=AN7SWQNMhojGeNi+2fjTq/4QUKrg3n1sf/pwTaBbL4EKuq9ijD5Ov1jKtwFYfayhkLWnZNePZfqlSpenlyUGHZ2DG/pJedK1mq9rVJK+WabPC7y9JYXwnDt5SvpX2XeOsxTBdfNettR5qcqF7AGHG5M+DMZ08bFyWTzaZKAZC+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041203; c=relaxed/simple;
	bh=h7A2htuQypr+iBBxksLnqQ1aTJ3xVwWqu39JaR5GumE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Me6Os16KJGWRAPKk5t49vuHG57HVVNUcDMny2c9S4hYZLQ9djk/kfrHDBd6l2DGI9HjOHrs+89N+LEMdvuOTYxIMlgp0L/TJ4MvxAXqTEyjXEXFm3e4F6Mu0Mh4Mhu/JDEMKx5KpbFDpi29FmM6vsEzj8gT9AScaV4FeHdcSm4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJ+NzX3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJ+NzX3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82988C4CECE;
	Thu, 12 Dec 2024 22:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734041202;
	bh=h7A2htuQypr+iBBxksLnqQ1aTJ3xVwWqu39JaR5GumE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lJ+NzX3P0JM4sHTgT+mem9iSGMv5aD1XiTvcFvZoitXAYe1Ni56+PrCJQAqFHX3z1
	 aQ0Dwv+IOPDZSv7tK7SuP6ypgJH4Mlz/gSiHseVckKTwgs+fecLj13ID9Ofn85f5TU
	 eKmi+iRf4Y7aeHY2w2bYdESm/gi4Ab/aZ93s8nuEasxBYAiSVOujbdzDSY4DKVasCC
	 k5TqZy7iHc4HaQBWGwypFF50po52AVKjx/aM7HDFDvq5RKftG/bIIUkVTXaxbz2mXa
	 V9SwzXEBoGCr8QJkJB2rxu9grIh3Xf9QHYCN5qTJTqJNvSvu1xPzfmc1UcG53EGz3a
	 Jh2vqJPxaAk9w==
Date: Thu, 12 Dec 2024 14:06:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/43] xfs: allow internal RT devices for zoned mode
Message-ID: <20241212220642.GB6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-17-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:41AM +0100, Christoph Hellwig wrote:
> Allow creating an RT subvolume on the same device as the main data
> device.  This is mostly used for SMR HDDs where the conventional zones
> are used for the data device and the sequential write required zones
> for the zoned RT section.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  fs/xfs/libxfs/xfs_group.h   |  6 ++++--
>  fs/xfs/libxfs/xfs_rtgroup.h |  8 +++++---
>  fs/xfs/libxfs/xfs_sb.c      |  1 +
>  fs/xfs/xfs_file.c           |  2 +-
>  fs/xfs/xfs_mount.h          |  7 +++++++
>  fs/xfs/xfs_rtalloc.c        |  3 ++-
>  fs/xfs/xfs_super.c          | 12 ++++++++++--
>  7 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
> index 242b05627c7a..a70096113384 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -107,9 +107,11 @@ xfs_gbno_to_daddr(
>  	xfs_agblock_t		gbno)
>  {
>  	struct xfs_mount	*mp = xg->xg_mount;
> -	uint32_t		blocks = mp->m_groups[xg->xg_type].blocks;
> +	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
> +	xfs_fsblock_t		fsbno;
>  
> -	return XFS_FSB_TO_BB(mp, (xfs_fsblock_t)xg->xg_gno * blocks + gbno);
> +	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
> +	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
>  }
>  
>  static inline uint32_t
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index 0e1d9474ab77..d4c15c706b17 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -230,7 +230,8 @@ xfs_rtb_to_daddr(
>  	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
>  	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
>  
> -	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
> +	return XFS_FSB_TO_BB(mp,
> +		g->start_fsb + start_bno + (rtbno & g->blkmask));
>  }
>  
>  static inline xfs_rtblock_t
> @@ -238,10 +239,11 @@ xfs_daddr_to_rtb(
>  	struct xfs_mount	*mp,
>  	xfs_daddr_t		daddr)
>  {
> -	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
> +	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +	xfs_rfsblock_t		bno;
>  
> +	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
>  	if (xfs_has_rtgroups(mp)) {
> -		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
>  		xfs_rgnumber_t	rgno;
>  		uint32_t	rgbno;
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 0bbe0b87bf04..20b8318d4a59 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1175,6 +1175,7 @@ xfs_sb_mount_rextsize(
>  		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
>  		rgs->blklog = mp->m_sb.sb_rgblklog;
>  		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
> +		rgs->start_fsb = mp->m_sb.sb_rtstart;
>  	} else {
>  		rgs->blocks = 0;
>  		rgs->blklog = 0;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6bcfd4c34a37..27301229011b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -150,7 +150,7 @@ xfs_file_fsync(
>  	 * ensure newly written file data make it to disk before logging the new
>  	 * inode size in case of an extending write.
>  	 */
> -	if (XFS_IS_REALTIME_INODE(ip))
> +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_rtdev_targp != mp->m_ddev_targp)
>  		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 72c5389ff78b..3d92678d2c3b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -103,6 +103,13 @@ struct xfs_groups {
>  	 * rtgroup, so this mask must be 64-bit.
>  	 */
>  	uint64_t		blkmask;
> +
> +	/*
> +	 * Start of the first group in the device.  This is used to support a
> +	 * RT device following the data device on the same block device for
> +	 * SMR hard drives.
> +	 */
> +	xfs_fsblock_t		start_fsb;
>  };
>  
>  enum xfs_free_counter {
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index e457a2c2d561..7ef62e7a91c1 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1266,7 +1266,8 @@ xfs_rt_check_size(
>  		return -EFBIG;
>  	}
>  
> -	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
> +	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart) + daddr,
>  			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error)
>  		xfs_warn(mp, "cannot read last RT device sector (%lld)",
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 92dd44965943..18430e975c53 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -533,7 +533,15 @@ xfs_setup_devices(
>  		if (error)
>  			return error;
>  	}
> -	if (mp->m_rtdev_targp) {
> +
> +	if (mp->m_sb.sb_rtstart) {
> +		if (mp->m_rtdev_targp) {
> +			xfs_warn(mp,
> +		"can't use internal and external rtdev at the same time");
> +			return -EINVAL;
> +		}
> +		mp->m_rtdev_targp = mp->m_ddev_targp;
> +	} else if (mp->m_rtname) {
>  		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
>  					    mp->m_sb.sb_sectsize);
>  		if (error)
> @@ -757,7 +765,7 @@ xfs_mount_free(
>  {
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_free_buftarg(mp->m_logdev_targp);
> -	if (mp->m_rtdev_targp)
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
>  		xfs_free_buftarg(mp->m_rtdev_targp);
>  	if (mp->m_ddev_targp)
>  		xfs_free_buftarg(mp->m_ddev_targp);
> -- 
> 2.45.2
> 
> 
