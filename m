Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85DCC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 02:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiCDCdT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 21:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiCDCdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 21:33:18 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77EB4403E8
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 18:32:30 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A7C7D10E14D6;
        Fri,  4 Mar 2022 13:32:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPxk4-001FvJ-G5; Fri, 04 Mar 2022 13:32:28 +1100
Date:   Fri, 4 Mar 2022 13:32:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 11/17] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <20220304023228.GG59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-12-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62217a3d
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=xaiAadYxyiA1c69CxVgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:32PM +0530, Chandan Babu R wrote:
> This commit defines new macros to represent maximum extent counts allowed by
> filesystems which have support for large per-inode extent counters.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
> index a01d9a9225ae..be7f8ebe3cd5 100644
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
> + */
> +#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1)) /* Signed 16-bits */

These go way beyond 80 columns. You do not need the trailing comment
saying how many bits are supported - that's obvious from numbers.
If you need to describe the actual supported limits, then do it
in the head comment:

/*
 * Max values for extent sizes and counts
 *
 * The original on-disk extent counts were held in signed fields,
 * resulting in maximum extent counts of 2^31 and 2^15 for the data
 * and attr forks respectively. Similarly the maximum extent length
 * is limited to 2^21 blocks by the 21-bit wide blockcount field of
 * a BMBT extent record.
 *
 * The newly introduced data fork extent counter can hold a 64-bit
 * value, however the  maximum number of extents in a file is also
 * limited to 2^54 extents by the 54-bit wide startoff field of a BMBT
 * extent record.
 *
 * It is further limited by the maximum supported file size
 * of 2^63 *bytes*. This leads to a maximum extent count for maximally sized
 * filesystem blocks (64kB) of:
 *
 * 2^63 bytes / 2^16 bytes per block = 2^47 blocks
 *
 * Rounding up 47 to the nearest multiple of bits-per-byte
 * results in 48. Hence 2^48 was chosen as the maximum data fork
 * extent count.
 */
#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1))
#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1))
#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1))
#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1))
#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1))


Hmmm. On reading that back and looking at the code below, maybe the
names should be _LARGE and _SMALL, not (blank) and _OLD....

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
							has_large_extent_counts
> +				int whichfork)
>  {
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> -		return MAXEXTNUM;
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +	case XFS_COW_FORK:
> +		return has_nrext64 ? XFS_MAX_EXTCNT_DATA_FORK
> +			: XFS_MAX_EXTCNT_DATA_FORK_OLD;

		if (has_large_extent_counts)
			return XFS_MAX_EXTCNT_DATA_FORK_LARGE;
		return XFS_MAX_EXTCNT_DATA_FORK_SMALL;

That reads much better to me...

Cheers,

DAve/
-- 
Dave Chinner
david@fromorbit.com
