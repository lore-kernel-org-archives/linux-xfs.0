Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbeCMUm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:42:59 -0400
Date: Tue, 13 Mar 2018 13:42:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: fix the check for COW extents in
 xfs_swap_extents
Message-ID: <20180313204254.GC4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:35:54PM +0100, Christoph Hellwig wrote:
> i_cnextents does not include delayed allocated extents, so switch
> to the inode fork size check that we already use in other places
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e0a442f504e5..19ea7d086cf8 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -2014,11 +2014,11 @@ xfs_swap_extents(
>  		ip->i_cowfp = tip->i_cowfp;
>  		tip->i_cowfp = cowfp;
>  
> -		if (ip->i_cowfp && ip->i_cnextents)
> +		if (ip->i_cowfp && ip->i_cowfp->if_bytes)
>  			xfs_inode_set_cowblocks_tag(ip);
>  		else
>  			xfs_inode_clear_cowblocks_tag(ip);
> -		if (tip->i_cowfp && tip->i_cnextents)
> +		if (tip->i_cowfp && tip->i_cowfp->if_bytes)
>  			xfs_inode_set_cowblocks_tag(tip);
>  		else
>  			xfs_inode_clear_cowblocks_tag(tip);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
