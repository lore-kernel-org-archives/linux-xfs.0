Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28194 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424491AbdDUTEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 15:04:49 -0400
Date: Fri, 21 Apr 2017 12:04:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: use NULL instead of 0 to initialize a pointer
 in xfs_ioc_getfsmap
Message-ID: <20170421190443.GG23371@birch.djwong.org>
References: <20170421152123.11316-1-hch@lst.de>
 <20170421152123.11316-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421152123.11316-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 05:21:19PM +0200, Christoph Hellwig wrote:
> Found by sparse.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index fee6b4a3a83d..0f8bed9a7e4c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1640,7 +1640,7 @@ xfs_ioc_getfsmap(
>  	struct xfs_inode	*ip,
>  	void			__user *arg)
>  {
> -	struct getfsmap_info	info = {0};
> +	struct getfsmap_info	info = { NULL };
>  	struct xfs_fsmap_head	xhead = {0};
>  	struct fsmap_head	head;
>  	bool			aborted = false;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
