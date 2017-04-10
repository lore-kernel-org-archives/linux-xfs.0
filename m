Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35075 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754958AbdDJQsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 12:48:52 -0400
Date: Mon, 10 Apr 2017 09:48:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] xfs: fix integer truncation in xfs_bmap_remap_alloc
Message-ID: <20170410164846.GT4864@birch.djwong.org>
References: <20170403121833.7825-1-hch@lst.de>
 <20170403121833.7825-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403121833.7825-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 03, 2017 at 02:18:28PM +0200, Christoph Hellwig wrote:
> bno should be a xfs_fsblock_t, which is 64-bit wides instead of a
> xfs_aglock_t, which truncates the value to 32 bits.

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9bd104f32908..2a426d127e05 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3863,7 +3863,7 @@ xfs_bmap_remap_alloc(
>  {
>  	struct xfs_trans	*tp = ap->tp;
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_agblock_t		bno;
> +	xfs_fsblock_t		bno;
>  	struct xfs_alloc_arg	args;
>  	int			error;
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
