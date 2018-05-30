Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753784AbeE3RcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 13:32:20 -0400
Date: Wed, 30 May 2018 10:32:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/18] xfs: simplify xfs_map_blocks by using
 xfs_iext_lookup_extent directly
Message-ID: <20180530173213.GN837@magnolia>
References: <20180530100013.31358-1-hch@lst.de>
 <20180530100013.31358-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100013.31358-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 12:00:05PM +0200, Christoph Hellwig wrote:
> xfs_bmapi_read adds zero value in xfs_map_blocks.  Replace it with a
> direct call to the low-level extent lookup function.
> 
> Note that we now always pass a 0 length to the trace points as we ask
> for an unspecified len.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 587493e9c8a1..cef2bc3cf98b 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -387,7 +387,6 @@ xfs_map_blocks(
>  	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_iext_cursor	icur;
>  	int			error = 0;
> -	int			nimaps = 1;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> @@ -429,24 +428,16 @@ xfs_map_blocks(
>  		goto allocate_blocks;
>  	}
>  
> -	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> -				imap, &nimaps, XFS_BMAPI_ENTIRE);
> +	if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, imap))
> +		imap->br_startoff = end_fsb;	/* fake a hole past EOF */
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -	if (error)
> -		return error;
>  
> -	if (!nimaps) {
> -		/*
> -		 * Lookup returns no match? Beyond eof? regardless,
> -		 * return it as a hole so we don't write it
> -		 */
> +	if (imap->br_startoff > offset_fsb) {
> +		/* landed in a hole or beyond EOF */
> +		imap->br_blockcount = imap->br_startoff - offset_fsb;
>  		imap->br_startoff = offset_fsb;
> -		imap->br_blockcount = end_fsb - offset_fsb;
>  		imap->br_startblock = HOLESTARTBLOCK;
>  		*type = XFS_IO_HOLE;
> -	} else if (imap->br_startblock == HOLESTARTBLOCK) {
> -		/* landed in a hole */
> -		*type = XFS_IO_HOLE;
>  	} else {
>  		if (isnullstartblock(imap->br_startblock)) {
>  			/* got a delalloc extent */
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
