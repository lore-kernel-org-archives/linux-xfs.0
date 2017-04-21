Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28053 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424252AbdDUTEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 15:04:33 -0400
Date: Fri, 21 Apr 2017 12:04:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] xfs: use NULL instead of 0 to initialize a pointer
 in xfs_getfsmap
Message-ID: <20170421190427.GF23371@birch.djwong.org>
References: <20170421152123.11316-1-hch@lst.de>
 <20170421152123.11316-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421152123.11316-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 05:21:18PM +0200, Christoph Hellwig wrote:
> Found by sparse.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_fsmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 48ce356da9e9..3683819887a5 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -827,7 +827,7 @@ xfs_getfsmap(
>  	struct xfs_trans		*tp = NULL;
>  	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
>  	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
> -	struct xfs_getfsmap_info	info = {0};
> +	struct xfs_getfsmap_info	info = { NULL };
>  	int				i;
>  	int				error = 0;
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
