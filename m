Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752414AbeCMUqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:46:00 -0400
Date: Tue, 13 Mar 2018 13:45:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: minor cleanup for xfs_get_blocks
Message-ID: <20180313204553.GG4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:35:58PM +0100, Christoph Hellwig wrote:
> Simplify the control flow a bit in preparation for O_ATOMIC-related
> changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c79a3ca20ef8..19eadc807056 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1335,17 +1335,16 @@ xfs_get_blocks(
>  			&nimaps, 0);
>  	if (error)
>  		goto out_unlock;
> -
> -	if (nimaps) {
> -		trace_xfs_get_blocks_found(ip, offset, size,
> -			imap.br_state == XFS_EXT_UNWRITTEN ?
> -				XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, &imap);
> -		xfs_iunlock(ip, lockmode);
> -	} else {
> +	if (!nimaps) {
>  		trace_xfs_get_blocks_notfound(ip, offset, size);
>  		goto out_unlock;
>  	}
>  
> +	trace_xfs_get_blocks_found(ip, offset, size,
> +		imap.br_state == XFS_EXT_UNWRITTEN ?
> +			XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, &imap);
> +	xfs_iunlock(ip, lockmode);
> +
>  	/* trim mapping down to size requested */
>  	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
