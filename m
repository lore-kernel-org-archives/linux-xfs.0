Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47170 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdKCQcG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 12:32:06 -0400
Date: Fri, 3 Nov 2017 09:32:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/21] xfs: remove a duplicate assignment in
 xfs_bmap_add_extent_delay_real
Message-ID: <20171103163202.GJ4911@magnolia>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:20PM +0300, Christoph Hellwig wrote:
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index db369653eb50..e1d61face277 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1765,7 +1765,7 @@ xfs_bmap_add_extent_delay_real(
>  		LEFT.br_blockcount += new->br_blockcount;
>  		xfs_iext_update_extent(bma->ip, state, bma->idx - 1, &LEFT);
>  
> -		PREV.br_blockcount = temp = PREV.br_blockcount - new->br_blockcount;
> +		PREV.br_blockcount = temp;
>  		PREV.br_startoff += new->br_blockcount;
>  		PREV.br_startblock = nullstartblock(da_new);
>  		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
