Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbfEQOHI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:07:08 -0400
Date: Fri, 17 May 2019 10:07:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/20] xfs: remove the dummy iop_push implementation for
 inode creation items
Message-ID: <20190517140705.GD7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:03AM +0200, Christoph Hellwig wrote:
> This method should never be called, so don't waste code on it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icreate_item.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 03c174ff1ab3..cbaabc55f0c9 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -83,23 +83,12 @@ xfs_icreate_item_committed(
>  	return (xfs_lsn_t)-1;
>  }
>  
> -/* item can never get into the AIL */
> -STATIC uint
> -xfs_icreate_item_push(
> -	struct xfs_log_item	*lip,
> -	struct list_head	*buffer_list)
> -{
> -	ASSERT(0);
> -	return XFS_ITEM_SUCCESS;
> -}
> -
>  /*
>   * This is the ops vector shared by all buf log items.
>   */
>  static const struct xfs_item_ops xfs_icreate_item_ops = {
>  	.iop_size	= xfs_icreate_item_size,
>  	.iop_format	= xfs_icreate_item_format,
> -	.iop_push	= xfs_icreate_item_push,
>  	.iop_unlock	= xfs_icreate_item_unlock,
>  	.iop_committed	= xfs_icreate_item_committed,
>  };
> -- 
> 2.20.1
> 
