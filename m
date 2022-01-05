Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED61C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiAEArI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:47:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34742 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiAEArI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:47:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1713615D4
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FA9C36AED;
        Wed,  5 Jan 2022 00:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641343627;
        bh=RafI4mMqfP0yqRS3v5H9zeHWCIDHns1/jo1czc4SHEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qJCoFpxWxmFERLrf6mVq4FM7aSQtwf5xXl13qG5+jSY5SwyG7BpJ1Jp/qvOe1XYge
         uVNPdMKe9tdLu0jmUon3eCt7//64PJE4Hi+jehcS90mXDleNcmDO59QIbEiq2Yuspu
         Fjk33YCyH4dmMDWdvGMBUF78vZ0YfwYYhDLDrKhkWIn3AtcdUCBQ1IO7Bdov22GBhl
         iphkrjud7Ud8/OipL8jPb4JURDJM1IiEWGJXdQWu2w4fWy6tvHoPDprjooL9YYwWys
         Ey197SR2gp8djG+WjShMB4InPYAS8c1QjXOA/8w9J8OtR5kne2U+WcZdudhKHMl607
         uMFJ08su1yUBQ==
Date:   Tue, 4 Jan 2022 16:47:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 16/16] xfs: Define max extent length based on on-disk
 format definition
Message-ID: <20220105004706.GT31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-17-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-17-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:19PM +0530, Chandan Babu R wrote:
> The maximum extent length depends on maximum block count that can be stored in
> a BMBT record. Hence this commit defines MAXEXTLEN based on
> BMBT_BLOCKCOUNT_BITLEN.
> 
> While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c      |  2 +-
>  fs/xfs/libxfs/xfs_bmap.c       | 57 +++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_format.h     | 21 +++++++------
>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
>  fs/xfs/libxfs/xfs_trans_resv.c | 11 ++++---
>  fs/xfs/scrub/bmap.c            |  2 +-
>  fs/xfs/xfs_bmap_util.c         | 14 +++++----
>  fs/xfs/xfs_iomap.c             | 28 ++++++++---------
>  8 files changed, 72 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 353e53b892e6..3f9b9cbfef43 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2493,7 +2493,7 @@ __xfs_free_extent_later(
>  
>  	ASSERT(bno != NULLFSBLOCK);
>  	ASSERT(len > 0);
> -	ASSERT(len <= MAXEXTLEN);
> +	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
>  	ASSERT(!isnullstartblock(bno));
>  	agno = XFS_FSB_TO_AGNO(mp, bno);
>  	agbno = XFS_FSB_TO_AGBNO(mp, bno);

Yessss another  unprefixed constant goes away.

<snip>

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 3183f78fe7a3..dd5cffe63be3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -885,15 +885,6 @@ enum xfs_dinode_fmt {
>  	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>  
> -/*
> - * Max values for extlen, extnum, aextnum.
> - */
> -#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
> -#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
> -#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
> -#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
> -#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
> -
>  /*
>   * Inode minimum and maximum sizes.
>   */
> @@ -1623,7 +1614,17 @@ typedef struct xfs_bmdr_block {
>  #define BMBT_BLOCKCOUNT_BITLEN	21
>  
>  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> -#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
> +
> +/*
> + * Max values for extlen and disk inode's extent counters.

Nit: 'ondisk inode'


> + */
> +#define XFS_MAX_BMBT_EXTLEN		((xfs_extlen_t)(1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
> +
> +#define BMBT_BLOCKCOUNT_MASK	XFS_MAX_BMBT_EXTLEN

Would this be simpler if XFS_MAX_EXTCNT* stay where they are, and only
XFS_MAX_BMBT_EXTLEN moves down to be defined as an alias of
BMBT_BLOCKCOUNT_MASK?

--D

>  
>  /*
>   * bmbt records have a file offset (block) field that is 54 bits wide, so this
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index b8e4e1f69989..780bad03d953 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -691,7 +691,7 @@ xfs_inode_validate_extsize(
>  	if (extsize_bytes % blocksize_bytes)
>  		return __this_address;
>  
> -	if (extsize > MAXEXTLEN)
> +	if (extsize > XFS_MAX_BMBT_EXTLEN)
>  		return __this_address;
>  
>  	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
> @@ -748,7 +748,7 @@ xfs_inode_validate_cowextsize(
>  	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
>  		return __this_address;
>  
> -	if (cowextsize > MAXEXTLEN)
> +	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
>  		return __this_address;
>  
>  	if (cowextsize > mp->m_sb.sb_agblocks / 2)
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 6f83d9b306ee..19313021fb99 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -199,8 +199,8 @@ xfs_calc_inode_chunk_res(
>  /*
>   * Per-extent log reservation for the btree changes involved in freeing or
>   * allocating a realtime extent.  We have to be able to log as many rtbitmap
> - * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
> - * as well as the realtime summary block.
> + * blocks as needed to mark inuse XFS_BMBT_MAX_EXTLEN blocks' worth of realtime
> + * extents, as well as the realtime summary block.
>   */
>  static unsigned int
>  xfs_rtalloc_log_count(
> @@ -210,7 +210,7 @@ xfs_rtalloc_log_count(
>  	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
>  	unsigned int		rtbmp_bytes;
>  
> -	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
> +	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
>  	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
>  }
>  
> @@ -247,7 +247,7 @@ xfs_rtalloc_log_count(
>   *    the inode's bmap btree: max depth * block size
>   *    the agfs of the ags from which the extents are allocated: 2 * sector
>   *    the superblock free block counter: sector size
> - *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
> + *    the realtime bitmap: ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes
>   *    the realtime summary: 1 block
>   *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
>   * And the bmap_finish transaction can free bmap blocks in a join (t3):
> @@ -299,7 +299,8 @@ xfs_calc_write_reservation(
>   *    the agf for each of the ags: 2 * sector size
>   *    the agfl for each of the ags: 2 * sector size
>   *    the super block to reflect the freed blocks: sector size
> - *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
> + *    the realtime bitmap: 2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY)
> + *    bytes
>   *    the realtime summary: 2 exts * 1 block
>   *    worst case split in allocation btrees per extent assuming 2 extents:
>   *		2 exts * 2 trees * (2 * max depth - 1) * block size
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index a4cbbc346f60..c357593e0a02 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -350,7 +350,7 @@ xchk_bmap_iextent(
>  				irec->br_startoff);
>  
>  	/* Make sure the extent points to a valid place. */
> -	if (irec->br_blockcount > MAXEXTLEN)
> +	if (irec->br_blockcount > XFS_MAX_BMBT_EXTLEN)
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  	if (info->is_rt &&
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 73a36b7be3bd..36cde254dedd 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -119,14 +119,14 @@ xfs_bmap_rtalloc(
>  	 */
>  	ralen = ap->length / mp->m_sb.sb_rextsize;
>  	/*
> -	 * If the old value was close enough to MAXEXTLEN that
> +	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
>  	 * we rounded up to it, cut it back so it's valid again.
>  	 * Note that if it's a really large request (bigger than
> -	 * MAXEXTLEN), we don't hear about that number, and can't
> +	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
>  	 * adjust the starting point to match it.
>  	 */
> -	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
> -		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
> +	if (ralen * mp->m_sb.sb_rextsize >= XFS_MAX_BMBT_EXTLEN)
> +		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
>  
>  	/*
>  	 * Lock out modifications to both the RT bitmap and summary inodes
> @@ -840,9 +840,11 @@ xfs_alloc_file_space(
>  		 * count, hence we need to limit the number of blocks we are
>  		 * trying to reserve to avoid an overflow. We can't allocate
>  		 * more than @nimaps extents, and an extent is limited on disk
> -		 * to MAXEXTLEN (21 bits), so use that to enforce the limit.
> +		 * to XFS_BMBT_MAX_EXTLEN (21 bits), so use that to enforce the
> +		 * limit.
>  		 */
> -		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
> +		resblks = min_t(xfs_fileoff_t, (e - s),
> +				(XFS_MAX_BMBT_EXTLEN * nimaps));
>  		if (unlikely(rt)) {
>  			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  			rblocks = resblks;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 093758440ad5..6835adc8d62f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -395,7 +395,7 @@ xfs_iomap_prealloc_size(
>  	 */
>  	plen = prev.br_blockcount;
>  	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
> -		if (plen > MAXEXTLEN / 2 ||
> +		if (plen > XFS_MAX_BMBT_EXTLEN / 2 ||
>  		    isnullstartblock(got.br_startblock) ||
>  		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
>  		    got.br_startblock + got.br_blockcount != prev.br_startblock)
> @@ -407,23 +407,23 @@ xfs_iomap_prealloc_size(
>  	/*
>  	 * If the size of the extents is greater than half the maximum extent
>  	 * length, then use the current offset as the basis.  This ensures that
> -	 * for large files the preallocation size always extends to MAXEXTLEN
> -	 * rather than falling short due to things like stripe unit/width
> -	 * alignment of real extents.
> +	 * for large files the preallocation size always extends to
> +	 * XFS_BMBT_MAX_EXTLEN rather than falling short due to things like stripe
> +	 * unit/width alignment of real extents.
>  	 */
>  	alloc_blocks = plen * 2;
> -	if (alloc_blocks > MAXEXTLEN)
> +	if (alloc_blocks > XFS_MAX_BMBT_EXTLEN)
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
>  	qblocks = alloc_blocks;
>  
>  	/*
> -	 * MAXEXTLEN is not a power of two value but we round the prealloc down
> -	 * to the nearest power of two value after throttling. To prevent the
> -	 * round down from unconditionally reducing the maximum supported
> -	 * prealloc size, we round up first, apply appropriate throttling,
> -	 * round down and cap the value to MAXEXTLEN.
> +	 * XFS_BMBT_MAX_EXTLEN is not a power of two value but we round the prealloc
> +	 * down to the nearest power of two value after throttling. To prevent
> +	 * the round down from unconditionally reducing the maximum supported
> +	 * prealloc size, we round up first, apply appropriate throttling, round
> +	 * down and cap the value to XFS_BMBT_MAX_EXTLEN.
>  	 */
> -	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
> +	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_BMBT_EXTLEN),
>  				       alloc_blocks);
>  
>  	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
> @@ -471,14 +471,14 @@ xfs_iomap_prealloc_size(
>  	 */
>  	if (alloc_blocks)
>  		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
> -	if (alloc_blocks > MAXEXTLEN)
> -		alloc_blocks = MAXEXTLEN;
> +	if (alloc_blocks > XFS_MAX_BMBT_EXTLEN)
> +		alloc_blocks = XFS_MAX_BMBT_EXTLEN;
>  
>  	/*
>  	 * If we are still trying to allocate more space than is
>  	 * available, squash the prealloc hard. This can happen if we
>  	 * have a large file on a small filesystem and the above
> -	 * lowspace thresholds are smaller than MAXEXTLEN.
> +	 * lowspace thresholds are smaller than XFS_BMBT_MAX_EXTLEN.
>  	 */
>  	while (alloc_blocks && alloc_blocks >= freesp)
>  		alloc_blocks >>= 4;
> -- 
> 2.30.2
> 
