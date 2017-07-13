Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34035 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752749AbdGMTX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 15:23:59 -0400
Date: Thu, 13 Jul 2017 12:23:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: assert locking precondition in
 xfs_readlink_bmap_ilocked
Message-ID: <20170713192354.GG4151@magnolia>
References: <20170713113304.8079-1-hch@lst.de>
 <20170713113304.8079-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713113304.8079-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2017 at 01:33:03PM +0200, Christoph Hellwig wrote:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_symlink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 12cd9cf7de41..23a50d7aa46a 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -61,6 +61,8 @@ xfs_readlink_bmap_ilocked(
>  	int			fsblocks = 0;
>  	int			offset;
>  
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> +
>  	fsblocks = xfs_symlink_blocks(mp, pathlen);
>  	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
>  	if (error)
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
