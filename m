Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388176AbeIUBtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 21:49:40 -0400
Date: Thu, 20 Sep 2018 13:04:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs: cancel COW blocks before swapext
Message-ID: <20180920200421.GL20086@magnolia>
References: <20180920144220.2181-1-hch@lst.de>
 <20180920144220.2181-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920144220.2181-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 04:42:16PM +0200, Christoph Hellwig wrote:
> We need to make sure we have no outstanding COW blocks before we swap
> extents, as there is nothing preventing us from having COW preallocations
> on an inode that swapext is called on.  That case can easily be
> reproduced by the upcoming always_cow mode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 414dbc31139c..e0e9cbc98ccd 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1515,6 +1515,12 @@ xfs_swap_extent_flush(
>  		return error;
>  	truncate_pagecache_range(VFS_I(ip), 0, -1);
>  
> +	if (xfs_inode_has_cow_data(ip)) {
> +		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
> +		if (error)
> +			return error;
> +	}
> +
>  	/* Verify O_DIRECT for ftmp */
>  	if (VFS_I(ip)->i_mapping->nrpages)
>  		return -EINVAL;
> -- 
> 2.18.0
> 
