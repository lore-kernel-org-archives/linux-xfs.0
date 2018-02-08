Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbeBHB4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 20:56:39 -0500
Date: Wed, 7 Feb 2018 17:56:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: account format bouncing into rmapbt swapext tx
 reservation
Message-ID: <20180208015634.GD5433@magnolia>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205174601.51574-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 05, 2018 at 12:45:59PM -0500, Brian Foster wrote:
> The extent swap mechanism requires a unique implementation for
> rmapbt enabled filesystems. Because the rmapbt tracks extent owner
> information, extent swap must individually unmap and remap each
> extent between the two inodes.
> 
> The rmapbt extent swap transaction block reservation currently
> accounts for the worst case bmapbt block and rmapbt block
> consumption based on the extent count of each inode. There is a
> corner case that exists due to the extent swap implementation that
> is not covered by this reservation, however.
> 
> If one of the associated inodes is just over the max extent count
> used for extent format inodes (i.e., the inode is in btree format by
> a single extent), the unmap/remap cycle of the extent swap can
> bounce the inode between extent and btree format multiple times,
> almost as many times as there are extents in the inode (if the
> opposing inode happens to have one less, for example). Each back and
> forth cycle involves a block free and allocation, which isn't a
> problem except for that the initial transaction reservation must
> account for the total number of block allocations performed by the
> chain of deferred operations. If not, a block reservation overrun
> occurs and the filesystem shuts down.
> 
> Update the rmapbt extent swap block reservation to check for this
> situation and add some block reservation slop to ensure the entire
> operation succeeds. We'd never likely require reservation for both
> inodes as fsr wouldn't defrag the file in that case, but the
> additional reservation is constrained by the data fork size so be
> cautious and check for both.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c83f549dc17b..e0a442f504e5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1899,17 +1899,28 @@ xfs_swap_extents(
>  	 * performed with log redo items!
>  	 */
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		int		w	= XFS_DATA_FORK;
> +		uint32_t	ipnext	= XFS_IFORK_NEXTENTS(ip, w);
> +		uint32_t	tipnext	= XFS_IFORK_NEXTENTS(tip, w);
> +
> +		/*
> +		 * Conceptually this shouldn't affect the shape of either bmbt,
> +		 * but since we atomically move extents one by one, we reserve
> +		 * enough space to rebuild both trees.
> +		 */
> +		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
> +		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> +
>  		/*
> -		 * Conceptually this shouldn't affect the shape of either
> -		 * bmbt, but since we atomically move extents one by one,
> -		 * we reserve enough space to rebuild both trees.
> +		 * Handle the corner case where either inode might straddle the
> +		 * btree format boundary. If so, the inode could bounce between
> +		 * btree <-> extent format on unmap -> remap cycles, freeing and
> +		 * allocating a bmapbt block each time.
>  		 */
> -		resblks = XFS_SWAP_RMAP_SPACE_RES(mp,
> -				XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK),
> -				XFS_DATA_FORK) +
> -			  XFS_SWAP_RMAP_SPACE_RES(mp,
> -				XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK),
> -				XFS_DATA_FORK);
> +		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> +			resblks += XFS_IFORK_MAXEXT(ip, w);
> +		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> +			resblks += XFS_IFORK_MAXEXT(tip, w);

I think this looks good enough to fix the problem, but I've been
wondering (in a more general sense) if it really makes sense to be
repeatedly freeing and allocating bmbt blocks like this?

What I mean is, there are a few operations (like rmapbt updates) that
can cause a lot of similar thrashing behavior when we delete a record
from one place and reinsert it shortly thereafter.  If the btree block
has the exact minimum number of records then it'll try to disperse the
records into the adjoining blocks, which is completely unnecessary if we
know that we're about to reinsert it somewhere else in the block.

Granted in swapext-with-rmap we also have a lot of log update machinery
in the way so there might not be a good way to hold on to blocks.  It
might introduce so much extra complexity it's not worth it either, since
I think we'd have to claw back references to the buffer in the log,
remove the extent busy record, and change the buffer type...?

--D

>  	}
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
