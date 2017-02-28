Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:39915 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdB1GQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 01:16:41 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1S5T2Ov011300
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2017 05:29:03 GMT
Date: Mon, 27 Feb 2017 21:27:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: factor out a xfs_bmap_is_real_extent helper
Message-ID: <20170228052754.GE5297@birch.djwong.org>
References: <20170228004930.9559-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228004930.9559-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2017 at 04:49:29PM -0800, Christoph Hellwig wrote:
> This checks for all the non-normal extent types, including handling both
> encodings of delayed allocations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.h | 12 ++++++++++++
>  fs/xfs/xfs_aops.c        |  4 +---
>  fs/xfs/xfs_bmap_util.c   |  7 +++----
>  fs/xfs/xfs_reflink.c     | 21 ++++-----------------
>  4 files changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index cdef87db5262..a6e612cabe15 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -172,6 +172,18 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
>  
>  
>  /*
> + * Return true if the extent is a real, allocated extent, or false if it is  a
> + * delayed allocation, and unwritten extent or a hole.
> + */
> +static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
> +{
> +	return irec->br_state != XFS_EXT_UNWRITTEN &&
> +		irec->br_startblock != HOLESTARTBLOCK &&
> +		irec->br_startblock != DELAYSTARTBLOCK &&
> +		!isnullstartblock(irec->br_startblock);
> +}
> +
> +/*
>   * This macro is used to determine how many extents will be shifted
>   * in one write transaction. We could require two splits,
>   * an extent move on the first and an extent merge on the second,
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1ff9df7a3ce8..582e3275bb51 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1281,9 +1281,7 @@ xfs_get_blocks(
>  	 * For unwritten extents do not report a disk address in the buffered
>  	 * read case (treat as if we're reading into a hole).
>  	 */
> -	if (imap.br_startblock != HOLESTARTBLOCK &&
> -	    imap.br_startblock != DELAYSTARTBLOCK &&
> -	    !ISUNWRITTEN(&imap))
> +	if (xfs_bmap_is_real_extent(&imap))
>  		xfs_map_buffer(inode, bh_result, &imap, offset);
>  
>  	/*
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 8b75dcea5966..88b2e923f2ed 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -448,10 +448,9 @@ xfs_getbmap_adjust_shared(
>  	next_map->br_blockcount = 0;
>  
>  	/* Only written data blocks can be shared. */
> -	if (!xfs_is_reflink_inode(ip) || whichfork != XFS_DATA_FORK ||
> -	    map->br_startblock == DELAYSTARTBLOCK ||
> -	    map->br_startblock == HOLESTARTBLOCK ||
> -	    ISUNWRITTEN(map))
> +	if (!xfs_is_reflink_inode(ip) ||
> +	    whichfork != XFS_DATA_FORK ||
> +	    !xfs_bmap_is_real_extent(map))
>  		return 0;
>  
>  	agno = XFS_FSB_TO_AGNO(mp, map->br_startblock);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index da6d08fb359c..08ca9f81b087 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -206,11 +206,7 @@ xfs_reflink_trim_around_shared(
>  	int			error = 0;
>  
>  	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (!xfs_is_reflink_inode(ip) ||
> -	    ISUNWRITTEN(irec) ||
> -	    irec->br_startblock == HOLESTARTBLOCK ||
> -	    irec->br_startblock == DELAYSTARTBLOCK ||
> -	    isnullstartblock(irec->br_startblock)) {
> +	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
>  		*shared = false;
>  		return 0;
>  	}
> @@ -1036,12 +1032,12 @@ xfs_reflink_remap_extent(
>  	xfs_off_t		new_isize)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	bool			real_extent = xfs_bmap_is_real_extent(irec);
>  	struct xfs_trans	*tp;
>  	xfs_fsblock_t		firstfsb;
>  	unsigned int		resblks;
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_bmbt_irec	uirec;
> -	bool			real_extent;
>  	xfs_filblks_t		rlen;
>  	xfs_filblks_t		unmap_len;
>  	xfs_off_t		newlen;
> @@ -1050,11 +1046,6 @@ xfs_reflink_remap_extent(
>  	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
>  	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
>  
> -	/* Only remap normal extents. */
> -	real_extent =  (irec->br_startblock != HOLESTARTBLOCK &&
> -			irec->br_startblock != DELAYSTARTBLOCK &&
> -			!ISUNWRITTEN(irec));
> -
>  	/* No reflinking if we're low on space */
>  	if (real_extent) {
>  		error = xfs_reflink_ag_has_free_space(mp,
> @@ -1350,9 +1341,7 @@ xfs_reflink_dirty_extents(
>  			goto out;
>  		if (nmaps == 0)
>  			break;
> -		if (map[0].br_startblock == HOLESTARTBLOCK ||
> -		    map[0].br_startblock == DELAYSTARTBLOCK ||
> -		    ISUNWRITTEN(&map[0]))
> +		if (!xfs_bmap_is_real_extent(&map[0]))
>  			goto next;
>  
>  		map[1] = map[0];
> @@ -1426,9 +1415,7 @@ xfs_reflink_clear_inode_flag(
>  			return error;
>  		if (nmaps == 0)
>  			break;
> -		if (map.br_startblock == HOLESTARTBLOCK ||
> -		    map.br_startblock == DELAYSTARTBLOCK ||
> -		    ISUNWRITTEN(&map))
> +		if (!xfs_bmap_is_real_extent(&map))
>  			goto next;
>  
>  		agno = XFS_FSB_TO_AGNO(mp, map.br_startblock);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
