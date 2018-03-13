Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbeCMU4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:56:14 -0400
Date: Tue, 13 Mar 2018 13:56:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] xfs: only clear preallocated COW blocks in
 xfs_reflink_clear_inode_flag
Message-ID: <20180313205604.GJ4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:36:01PM +0100, Christoph Hellwig wrote:
> Currently these are the only ones that should exist at this point anyway,
> but with O_ATOMIC writes we might have legit extents around in the COW
> fork even when clearing the reflink flag.

Hmmm... so I assume that the premise of the O_ATOMIC write series is
still that we use the cow fork to stage writes until fsync, and the
presence of a cow fork is now separate from the reflink inode flag?

Therefore, it's perfectly legit to have a !reflink inode with real
extents sitting in the cow fork and legit to be clearing the reflink
iflag with real extents sitting around.

I think this is ok but I'd sure like to see the atomic writes patches
before I pull this one in.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 85d3379a81df..8ab9c73b430e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1570,7 +1570,7 @@ xfs_reflink_clear_inode_flag(
>  	 * We didn't find any shared blocks so turn off the reflink flag.
>  	 * First, get rid of any leftover CoW mappings.
>  	 */
> -	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
> +	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, false);
>  	if (error)
>  		return error;
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
