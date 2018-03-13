Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbeCMUol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:44:41 -0400
Date: Tue, 13 Mar 2018 13:44:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: don't use XFS_BMAPI_ENTRIRE in xfs_get_blocks
Message-ID: <20180313204436.GD4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:35:55PM +0100, Christoph Hellwig wrote:
> There is no reason to get a mapping bigger than what we were asked for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a0afb6411417..c79a3ca20ef8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1331,8 +1331,8 @@ xfs_get_blocks(
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
> -	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> -				&imap, &nimaps, XFS_BMAPI_ENTIRE);
> +	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
> +			&nimaps, 0);
>  	if (error)
>  		goto out_unlock;
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
