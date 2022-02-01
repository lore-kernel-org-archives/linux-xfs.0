Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6984C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 19:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242406AbiBAT0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242404AbiBAT0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 14:26:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57D0C061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 11:26:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A036164A
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 19:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15396C340EB;
        Tue,  1 Feb 2022 19:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643743603;
        bh=3NBplWUv8aTn0Ca9aF8z8VzZb4uUbJoFIbzfXVwQKj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F99LyMFqz0ZKz0b58A8wbBIWFhXah6FWa0Khd3qv5mKqcEbu1MnGV/5CcDVTKCC8d
         t8c4uk0n9qwXm5B+hM8aMorVx1mm7eXbYd5hfZA1Mvk6xneeetnawhuBHm/CjTjPPm
         7yv/9E09o6mab3RxX/fQyn8+Fhtc2oDpzcejVrHN3j6y/91c1BRLu+VeEzHhS7NudF
         gRYI2Ix3dXAsSxfIfXsbGEaoKK5BR1w579Xyzk1EMEBzDqfBEIqyveTQII7inKHgCG
         zYyqJvqOuFUTDYm6GZxytExo/P85G8PAJ3id3PwV6ecQzWpaFT8sOcLW5n7yWFwx/B
         fF6ZhHrwm6TUw==
Date:   Tue, 1 Feb 2022 11:26:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 16/16] xfs: Define max extent length based on on-disk
 format definition
Message-ID: <20220201192642.GL8313@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-17-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-17-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:48:57AM +0530, Chandan Babu R wrote:
> The maximum extent length depends on maximum block count that can be stored in
> a BMBT record. Hence this commit defines MAXEXTLEN based on
> BMBT_BLOCKCOUNT_BITLEN.
> 
> While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c      |  2 +-
>  fs/xfs/libxfs/xfs_bmap.c       | 57 +++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_format.h     |  5 +--
>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
>  fs/xfs/libxfs/xfs_trans_resv.c | 11 ++++---
>  fs/xfs/scrub/bmap.c            |  2 +-
>  fs/xfs/xfs_bmap_util.c         | 14 +++++----
>  fs/xfs/xfs_iomap.c             | 28 ++++++++---------
>  8 files changed, 64 insertions(+), 59 deletions(-)
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
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 384532aac60a..1c3da6aac2f9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1449,7 +1449,7 @@ xfs_bmap_add_extent_delay_real(
>  	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
>  	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
>  	    LEFT.br_state == new->br_state &&
> -	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
> +	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
>  		state |= BMAP_LEFT_CONTIG;
>  
>  	/*
> @@ -1467,13 +1467,13 @@ xfs_bmap_add_extent_delay_real(
>  	    new_endoff == RIGHT.br_startoff &&
>  	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
>  	    new->br_state == RIGHT.br_state &&
> -	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
> +	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
>  	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
>  		       BMAP_RIGHT_FILLING)) !=
>  		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
>  		       BMAP_RIGHT_FILLING) ||
>  	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
> -			<= MAXEXTLEN))
> +			<= XFS_MAX_BMBT_EXTLEN))
>  		state |= BMAP_RIGHT_CONTIG;
>  
>  	error = 0;
> @@ -1997,7 +1997,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
>  	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
>  	    LEFT.br_state == new->br_state &&
> -	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
> +	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
>  		state |= BMAP_LEFT_CONTIG;
>  
>  	/*
> @@ -2015,13 +2015,13 @@ xfs_bmap_add_extent_unwritten_real(
>  	    new_endoff == RIGHT.br_startoff &&
>  	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
>  	    new->br_state == RIGHT.br_state &&
> -	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
> +	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
>  	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
>  		       BMAP_RIGHT_FILLING)) !=
>  		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
>  		       BMAP_RIGHT_FILLING) ||
>  	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
> -			<= MAXEXTLEN))
> +			<= XFS_MAX_BMBT_EXTLEN))
>  		state |= BMAP_RIGHT_CONTIG;
>  
>  	/*
> @@ -2507,15 +2507,15 @@ xfs_bmap_add_extent_hole_delay(
>  	 */
>  	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
>  	    left.br_startoff + left.br_blockcount == new->br_startoff &&
> -	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
> +	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
>  		state |= BMAP_LEFT_CONTIG;
>  
>  	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
>  	    new->br_startoff + new->br_blockcount == right.br_startoff &&
> -	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
> +	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
>  	    (!(state & BMAP_LEFT_CONTIG) ||
>  	     (left.br_blockcount + new->br_blockcount +
> -	      right.br_blockcount <= MAXEXTLEN)))
> +	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
>  		state |= BMAP_RIGHT_CONTIG;
>  
>  	/*
> @@ -2658,17 +2658,17 @@ xfs_bmap_add_extent_hole_real(
>  	    left.br_startoff + left.br_blockcount == new->br_startoff &&
>  	    left.br_startblock + left.br_blockcount == new->br_startblock &&
>  	    left.br_state == new->br_state &&
> -	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
> +	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
>  		state |= BMAP_LEFT_CONTIG;
>  
>  	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
>  	    new->br_startoff + new->br_blockcount == right.br_startoff &&
>  	    new->br_startblock + new->br_blockcount == right.br_startblock &&
>  	    new->br_state == right.br_state &&
> -	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
> +	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
>  	    (!(state & BMAP_LEFT_CONTIG) ||
>  	     left.br_blockcount + new->br_blockcount +
> -	     right.br_blockcount <= MAXEXTLEN))
> +	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
>  		state |= BMAP_RIGHT_CONTIG;
>  
>  	error = 0;
> @@ -2903,15 +2903,15 @@ xfs_bmap_extsize_align(
>  
>  	/*
>  	 * For large extent hint sizes, the aligned extent might be larger than
> -	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
> -	 * the length back under MAXEXTLEN. The outer allocation loops handle
> -	 * short allocation just fine, so it is safe to do this. We only want to
> -	 * do it when we are forced to, though, because it means more allocation
> -	 * operations are required.
> +	 * XFS_BMBT_MAX_EXTLEN. In that case, reduce the size by an extsz so
> +	 * that it pulls the length back under XFS_BMBT_MAX_EXTLEN. The outer
> +	 * allocation loops handle short allocation just fine, so it is safe to
> +	 * do this. We only want to do it when we are forced to, though, because
> +	 * it means more allocation operations are required.
>  	 */
> -	while (align_alen > MAXEXTLEN)
> +	while (align_alen > XFS_MAX_BMBT_EXTLEN)
>  		align_alen -= extsz;
> -	ASSERT(align_alen <= MAXEXTLEN);
> +	ASSERT(align_alen <= XFS_MAX_BMBT_EXTLEN);
>  
>  	/*
>  	 * If the previous block overlaps with this proposed allocation
> @@ -3001,9 +3001,9 @@ xfs_bmap_extsize_align(
>  			return -EINVAL;
>  	} else {
>  		ASSERT(orig_off >= align_off);
> -		/* see MAXEXTLEN handling above */
> +		/* see XFS_BMBT_MAX_EXTLEN handling above */
>  		ASSERT(orig_end <= align_off + align_alen ||
> -		       align_alen + extsz > MAXEXTLEN);
> +		       align_alen + extsz > XFS_MAX_BMBT_EXTLEN);
>  	}
>  
>  #ifdef DEBUG
> @@ -3968,7 +3968,7 @@ xfs_bmapi_reserve_delalloc(
>  	 * Cap the alloc length. Keep track of prealloc so we know whether to
>  	 * tag the inode before we return.
>  	 */
> -	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
> +	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
>  	if (!eof)
>  		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
>  	if (prealloc && alen >= len)
> @@ -4101,7 +4101,7 @@ xfs_bmapi_allocate(
>  		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
>  			bma->prev.br_startoff = NULLFILEOFF;
>  	} else {
> -		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
> +		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
>  		if (!bma->eof)
>  			bma->length = XFS_FILBLKS_MIN(bma->length,
>  					bma->got.br_startoff - bma->offset);
> @@ -4421,8 +4421,8 @@ xfs_bmapi_write(
>  			 * xfs_extlen_t and therefore 32 bits. Hence we have to
>  			 * check for 32-bit overflows and handle them here.
>  			 */
> -			if (len > (xfs_filblks_t)MAXEXTLEN)
> -				bma.length = MAXEXTLEN;
> +			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
> +				bma.length = XFS_MAX_BMBT_EXTLEN;
>  			else
>  				bma.length = len;
>  
> @@ -4557,7 +4557,8 @@ xfs_bmapi_convert_delalloc(
>  	bma.ip = ip;
>  	bma.wasdel = true;
>  	bma.offset = bma.got.br_startoff;
> -	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
> +	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
> +			XFS_MAX_BMBT_EXTLEN);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
>  
>  	/*
> @@ -4638,7 +4639,7 @@ xfs_bmapi_remap(
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(len > 0);
> -	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
> +	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
>  			   XFS_BMAPI_NORMAP)));
> @@ -5638,7 +5639,7 @@ xfs_bmse_can_merge(
>  	if ((left->br_startoff + left->br_blockcount != startoff) ||
>  	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
>  	    (left->br_state != got->br_state) ||
> -	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
> +	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
>  		return false;
>  
>  	return true;
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b7521c1d1db2..fa11e4c1cc41 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -886,7 +886,7 @@ enum xfs_dinode_fmt {
>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>  
>  /*
> - * Max values for extlen, extnum, aextnum.
> + * Max values for ondisk inode's extent counters.
>   *
>   * The newly introduced data fork extent counter is a 64-bit field. However, the
>   * maximum number of extents in a file is limited to 2^54 extents (assuming one
> @@ -898,7 +898,6 @@ enum xfs_dinode_fmt {
>   * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
>   * 2^48 was chosen as the maximum data fork extent count.
>   */
> -#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
>  #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
>  #define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
>  #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
> @@ -1635,6 +1634,8 @@ typedef struct xfs_bmdr_block {
>  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
>  #define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
>  
> +#define XFS_MAX_BMBT_EXTLEN	((xfs_extlen_t)(BMBT_BLOCKCOUNT_MASK))
> +
>  /*
>   * bmbt records have a file offset (block) field that is 54 bits wide, so this
>   * is the largest xfs_fileoff_t that we ever expect to see.
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 767189c7c887..409be63fd80d 100644
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
