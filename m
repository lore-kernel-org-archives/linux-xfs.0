Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1011C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiAEAmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:42:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44652 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiAEAmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:42:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09BC7B81851
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC139C36AEB;
        Wed,  5 Jan 2022 00:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641343325;
        bh=WCU5IvukzFBEPIhAvOkHrXlcKxhXNJWstY3mH5ij0QQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P6UvlHkvvyimcl/Yy655iN+r1GZYwZBohf1QJ4v/ik7NGY4W+H8k+6RPx63g+pzPi
         j4MeMUFtZB8DkVoRzOLi7kC2lYKLb9qZi3W64n2j6NVx+uPnVuqk2GFkvlwvmrp5qV
         4oKStmLVvVsW19/SMCg+xCx+LEiVdtAyXOXgKdEJIFr5gjrGhbSVNYrd3RLnUxpMX8
         qiAfQ8xbE7XJAUhvsAALYTZyGxJ2IGEJVbsIg5/PJDp246qHfDWdRGsxtjv7T1V/GQ
         FEbz9pQbECxFCFls3U016i79d7It3U6GIwD+vuLgeTjtvgLniGJrzuegOlG+SI+3t8
         UVUMdrwo1cCRA==
Date:   Tue, 4 Jan 2022 16:42:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 11/16] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <20220105004205.GR31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-12-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:14PM +0530, Chandan Babu R wrote:
> This commit defines new macros to represent maximum extent counts allowed by
> filesystems which have support for large per-inode extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
>  fs/xfs/libxfs/xfs_format.h     |  8 +++++---
>  fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
>  6 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4113622e9733..0ce58e4a9c44 100644
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
> index 9934c320bf01..eff86f6c4c99 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -873,9 +873,11 @@ enum xfs_dinode_fmt {
>  /*
>   * Max values for extlen, extnum, aextnum.
>   */
> -#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> +#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */

Could you change the #define value to a shift and subtract like you do
for MAXEXTLEN^WXFS_MAX_BMBT_EXTLEN in patch 16?

e.g.

#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1))

Also, you might want to document briefly in this header file why it is
that the bmbt is limited to 2^48 extents even though the dinode fields
are 64 bits wide and there can be up to 2^54 blocks mapped by a fork.
ISTR the reason is to avoid having the bmbt cursor cache have to handle
a 12-level btree or something, right?

(Sorry, it's been a while...)

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
> index 4a8b77d425df..0cfc351648f9 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> -static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
> +static inline xfs_extnum_t xfs_iext_max_nextents(bool has_big_extcnt,

has_nrext64, to be consistent with most everywhere else?

--D

> +				int whichfork)
>  {
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> -		return MAXEXTNUM;
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +	case XFS_COW_FORK:
> +		return has_big_extcnt ? XFS_MAX_EXTCNT_DATA_FORK
> +			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
> +
> +	case XFS_ATTR_FORK:
> +		return has_big_extcnt ? XFS_MAX_EXTCNT_ATTR_FORK
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
