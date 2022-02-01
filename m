Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC594C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 18:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbiBASta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 13:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiBASt3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 13:49:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E084C061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 10:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AF4AB82F5C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 18:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F5C340EB;
        Tue,  1 Feb 2022 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643741367;
        bh=M9iOLN70Wtp0JrIJ9zYMAdNRJZucuMF1/MmmwOtJFI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnJidVaTMUI3D5uymGZFtg6sMG38YN3fHvDlG7AEwbxn8evFJ4BjZX7wDsN1TVgWS
         PsaZMVipb316eQCFNjO83Xg49P/uxxGIOOA80i11UEAhV/htmI+09oSPL2TE4+ODaJ
         hGsC8B98uKj/V6Z16JHvpIQLiWMVPnKJr44yK9OjXR+YTwDFdBH1cqkg0Msw4wzbTs
         gWtHzccYZNlIA4XqpkrPNsxiHUF4jGONN1Dl0rM6cSs+puKyI1DjfIDLXouNj3OMla
         obJU6BC0jGvwRdE8SwKMo5RqoVyU0DxDYHl4B2wC+2imLEKnO9sS0HO3jVYg/D0YLl
         q9VdsqsC/91Dw==
Date:   Tue, 1 Feb 2022 10:49:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 11/16] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <20220201184926.GA8338@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-12-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:48:52AM +0530, Chandan Babu R wrote:
> This commit defines new macros to represent maximum extent counts allowed by
> filesystems which have support for large per-inode extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
>  fs/xfs/libxfs/xfs_format.h     | 20 ++++++++++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
>  6 files changed, 38 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1948af000c97..384532aac60a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
>  	int		sz;		/* root block size */
>  
>  	/*
> -	 * The maximum number of extents in a file, hence the maximum number of
> -	 * leaf entries, is controlled by the size of the on-disk extent count,
> -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> -	 * number for the attr fork.
> +	 * The maximum number of extents in a fork, hence the maximum number of
> +	 * leaf entries, is controlled by the size of the on-disk extent count.
>  	 *
>  	 * Note that we can no longer assume that if we are in ATTR1 that the
>  	 * fork offset of all the inodes will be
> @@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
>  	 * ATTR2 we have to assume the worst case scenario of a minimum size
>  	 * available.
>  	 */
> -	maxleafents = xfs_iext_max_nextents(whichfork);
> +	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
>  	if (whichfork == XFS_DATA_FORK)
>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>  	else
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 453309fc85f2..e8d21d69b9ff 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
>  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
>  
>  	/* One extra level for the inode root. */
> -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
> +	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9934c320bf01..d3dfd45c39e0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -872,10 +872,22 @@ enum xfs_dinode_fmt {
>  
>  /*
>   * Max values for extlen, extnum, aextnum.
> - */
> -#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> + *
> + * The newly introduced data fork extent counter is a 64-bit field. However, the
> + * maximum number of extents in a file is limited to 2^54 extents (assuming one
> + * blocks per extent) by the 54-bit wide startoff field of an extent record.
> + *
> + * A further limitation applies as shown below,
> + * 2^63 (max file size) / 64k (max block size) = 2^47
> + *
> + * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
> + * 2^48 was chosen as the maximum data fork extent count.

Ok.  I know I've brought up previously the fact that we leave the upper
16 bits of di_big_nextents completely unused, AKA:

It's odd that startoff is a 54-bit field, di_big_nextents is a 64-bit
field, but we don't allow more than 2^48 data fork extents even though
that means that one cannot populate a file on a 4k-FSB filesystem with
one extent record for each file block.

Prior to 5.16, a potential justification was that xfs_btree_cur
supported exactly 9 levels and we didn't want to raise that all the way
to 12 (or whatever you'd need to support a btree with 2^54 extent
records) for *all cursor types* to handle Ultra Extreme Fragmentation.

Now that we have separate cursor caches for all btree types, we could
create one bmbt cursor cache for NREXT64 data forks and another for all
other cases, which (in my mind anyway) assuages that concern.

The other justification we've covered is that the incore btree for a
data fork with 2^48 xfs_bmbt_irec records will consume a bit more than
2^52 bytes of memory, which is (AFAIK) the current x64 memory limit.
Assuming that CPU manufacturers keep adding an extra address line bit
every other year or so, the extremely wealthy could complain about
hitting this limit as early as 2040.  That's ~20 or so years out, which
is probably enough time either to find a more efficient incore extent
map structure due to customer demand or start using the upper 16 bits.

So with those two factors in mind, I /think/ I'm ok with approving this
extension to the ondisk format.

IOWs, if anyone has an objection, the time to raise it is NOW.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> + */
> +#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1)) /* Signed 16-bits */
>  
>  /*
>   * Inode minimum and maximum sizes.
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 860d32816909..34f360a38603 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
>  			return __this_address;
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		max_extents = xfs_iext_max_nextents(whichfork);
> +		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
> +					whichfork);
>  		if (di_nextents > max_extents)
>  			return __this_address;
>  		break;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ce690abe5dce..a3a3b54f9c55 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
>  	if (whichfork == XFS_COW_FORK)
>  		return 0;
>  
> -	max_exts = xfs_iext_max_nextents(whichfork);
> +	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
>  
>  	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>  		max_exts = 10;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 4a8b77d425df..e56803436c61 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> -static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
> +static inline xfs_extnum_t xfs_iext_max_nextents(bool has_nrext64,
> +				int whichfork)
>  {
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> -		return MAXEXTNUM;
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +	case XFS_COW_FORK:
> +		return has_nrext64 ? XFS_MAX_EXTCNT_DATA_FORK
> +			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
> +
> +	case XFS_ATTR_FORK:
> +		return has_nrext64 ? XFS_MAX_EXTCNT_ATTR_FORK
> +			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
>  
> -	return MAXAEXTNUM;
> +	default:
> +		ASSERT(0);
> +		return 0;
> +	}
>  }
>  
>  static inline xfs_extnum_t
> -- 
> 2.30.2
> 
