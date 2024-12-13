Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270BF19992C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130514; cv=none; b=I4zkTa4fKcMtXrPDtVT1JW5OkJm22dyih+zqEWiRMm5JFIH/JTa1+0VhPMvYCSkADv/TRCbI0HnVpbFq/yrhMB9e/215VtzUKUSf+5lR3usysZeHzTNws2HZjVH9NVa6Ti/1/Ek14CGM5F7rKKO9uyuiqyPBjpr5urvVPYu+G98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130514; c=relaxed/simple;
	bh=iyIe5j/pqIipJQe1AAJcD0W6L4iM0g+hBVAmR0FPUyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFE3LfUJy2M/6fdonwSC89uUCMJOF7Pvyq3hTzrEDlspZSigm/QY/3XirQnXc+a4iB4nzuhGohfH87UiQrKsqyVeG3NxZd2vN6TE4Rue4ArEgJE0b4vhFMR/v6vYRiHiCU1Xu4lPfxjashYIHyrCb4bDo67xiNcOhw9DzxcPf08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpINbXoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpINbXoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC05C4CED0;
	Fri, 13 Dec 2024 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130514;
	bh=iyIe5j/pqIipJQe1AAJcD0W6L4iM0g+hBVAmR0FPUyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rpINbXoHOsSZBgtECBc+va0S9nDKZ9MaQz4UaJEEQoSL9+oiEesHAdHwxX2U5mq8A
	 lqNE+vS3rzELfylrh6lMQgb0BDXj2ZQ7U08q2SOaEeytzV/S+sjbuLiwKt8VI4XBqX
	 tGhZbZK40q6J9JeI2yM20gVYvR6WBtB0Lh+JiBu5tOEujxw2RYAqjv47RQ/63Ek8oH
	 xgCfYbUUapYg/oSQ3YGLqxYA2tdfbcQg6VQscS/sf8aRjwXipo5IqkQ/EhvOpwTwm8
	 f/403/16fL2pLt+itH42yqctsz+lRUfRuqPTMlf2RJhL7sinQFL7d7wCsZ3bKd8Hsj
	 rr3wytWMPxxsQ==
Date: Fri, 13 Dec 2024 14:55:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/43] xfs: support zone gaps
Message-ID: <20241213225513.GZ6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-40-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-40-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:04AM +0100, Christoph Hellwig wrote:
> Zoned devices can have gaps beyond the usable capacity of a zone and the
> end in the LBA/daddr address space.  In other words, the hardware
> equivalent to the RT groups already takes care of the power of 2
> alignment for us.  In this case the sparse FSB/RTB address space maps 1:1
> to the device address space.

Heh, sparse lba ranges.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h  |  4 +++-
>  fs/xfs/libxfs/xfs_group.h   |  6 +++++-
>  fs/xfs/libxfs/xfs_rtgroup.h | 13 ++++++++-----
>  fs/xfs/libxfs/xfs_sb.c      |  3 +++
>  fs/xfs/libxfs/xfs_zones.c   | 19 +++++++++++++++++--
>  fs/xfs/xfs_mount.h          |  9 +++++++++
>  6 files changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index fc56de8fe696..9491a09f6aa7 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -398,6 +398,7 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
>  #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
>  #define XFS_SB_FEAT_INCOMPAT_ZONED	(1U << 31)/* zoned RT allocator */
> +#define XFS_SB_FEAT_INCOMPAT_ZONE_GAPS	(1U << 30)/* RTGs have LBA gaps */

These will have to be renumbered before merging.

Otherwise looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> @@ -409,7 +410,8 @@ xfs_sb_has_ro_compat_feature(
>  		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
>  		 XFS_SB_FEAT_INCOMPAT_PARENT | \
>  		 XFS_SB_FEAT_INCOMPAT_METADIR | \
> -		 XFS_SB_FEAT_INCOMPAT_ZONED)
> +		 XFS_SB_FEAT_INCOMPAT_ZONED | \
> +		 XFS_SB_FEAT_INCOMPAT_ZONE_GAPS)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
> index 430a43e1591e..996b29313bc2 100644
> --- a/fs/xfs/libxfs/xfs_group.h
> +++ b/fs/xfs/libxfs/xfs_group.h
> @@ -117,7 +117,11 @@ xfs_gbno_to_daddr(
>  	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
>  	xfs_fsblock_t		fsbno;
>  
> -	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
> +	if (g->has_daddr_gaps)
> +		fsbno = xfs_gbno_to_fsb(xg, gbno);
> +	else
> +		fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
> +
>  	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index 85d8d329d417..5b3305e09ec3 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -245,11 +245,14 @@ xfs_rtb_to_daddr(
>  	xfs_rtblock_t		rtbno)
>  {
>  	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> -	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
> -	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
>  
> -	return XFS_FSB_TO_BB(mp,
> -		g->start_fsb + start_bno + (rtbno & g->blkmask));
> +	if (xfs_has_rtgroups(mp) && !g->has_daddr_gaps) {
> +		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
> +
> +		rtbno = (xfs_rtblock_t)rgno * g->blocks + (rtbno & g->blkmask);
> +	}
> +
> +	return XFS_FSB_TO_BB(mp, g->start_fsb + rtbno);
>  }
>  
>  static inline xfs_rtblock_t
> @@ -261,7 +264,7 @@ xfs_daddr_to_rtb(
>  	xfs_rfsblock_t		bno;
>  
>  	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
> -	if (xfs_has_rtgroups(mp)) {
> +	if (xfs_has_rtgroups(mp) && !g->has_daddr_gaps) {
>  		xfs_rgnumber_t	rgno;
>  		uint32_t	rgbno;
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ee56fc22fd06..18e4c4908f94 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1176,6 +1176,9 @@ xfs_sb_mount_rextsize(
>  		rgs->blklog = mp->m_sb.sb_rgblklog;
>  		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
>  		rgs->start_fsb = mp->m_sb.sb_rtstart;
> +		if (xfs_sb_has_incompat_feature(sbp,
> +				XFS_SB_FEAT_INCOMPAT_ZONE_GAPS))
> +			rgs->has_daddr_gaps = true;
>  	} else {
>  		rgs->blocks = 0;
>  		rgs->blklog = 0;
> diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
> index e170d7c13533..c17111f40821 100644
> --- a/fs/xfs/libxfs/xfs_zones.c
> +++ b/fs/xfs/libxfs/xfs_zones.c
> @@ -135,6 +135,7 @@ xfs_zone_validate(
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +	uint32_t		expected_size;
>  
>  	/*
>  	 * Check that the zone capacity matches the rtgroup size stored in the
> @@ -149,11 +150,25 @@ xfs_zone_validate(
>  		return -EIO;
>  	}
>  
> -	if (XFS_BB_TO_FSB(mp, zone->len) != 1 << g->blklog) {
> +	if (g->has_daddr_gaps) {
> +		expected_size = 1 << g->blklog;
> +	} else {
> +		if (zone->len != zone->capacity) {
> +			xfs_warn(mp,
> +"zone %u has capacity != size ((0x%llx vs 0x%llx)",
> +				rtg_rgno(rtg),
> +				XFS_BB_TO_FSB(mp, zone->len),
> +				XFS_BB_TO_FSB(mp, zone->capacity));
> +			return -EIO;
> +		}
> +		expected_size = g->blocks;
> +	}
> +
> +	if (XFS_BB_TO_FSB(mp, zone->len) != expected_size) {
>  		xfs_warn(mp,
>  "zone %u length (0x%llx) does match geometry (0x%x).",
>  			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->len),
> -			1 << g->blklog);
> +			expected_size);
>  	}
>  
>  	switch (zone->type) {
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 831d9e09fe72..ec8612c8b71d 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -97,6 +97,15 @@ struct xfs_groups {
>  	 */
>  	uint8_t			blklog;
>  
> +	/*
> +	 * Zoned devices can have gaps beyond the usable capacity of a zone and
> +	 * the end in the LBA/daddr address space.  In other words, the hardware
> +	 * equivalent to the RT groups already takes care of the power of 2
> +	 * alignment for us.  In this case the sparse FSB/RTB address space maps
> +	 * 1:1 to the device address space.
> +	 */
> +	bool			has_daddr_gaps;
> +
>  	/*
>  	 * Mask to extract the group-relative block number from a FSB.
>  	 * For a pre-rtgroups filesystem we pretend to have one very large
> -- 
> 2.45.2
> 
> 
