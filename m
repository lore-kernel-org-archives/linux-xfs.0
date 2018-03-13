Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752541AbeCMVJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 17:09:21 -0400
Date: Tue, 13 Mar 2018 14:09:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: remove misleading comment text on
 xfs_inode_item_unlock
Message-ID: <20180313210916.GK4865@magnolia>
References: <20180313104927.12926-1-hch@lst.de>
 <20180313104927.12926-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313104927.12926-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 11:49:20AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode_item.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index d5037f060d6f..b83fa38f1c74 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -579,9 +579,6 @@ xfs_inode_item_push(
>  
>  /*
>   * Unlock the inode associated with the inode log item.
> - * Clear the fields of the inode and inode log item that
> - * are specific to the current transaction.  If the
> - * hold flags is set, do not unlock the inode.
>   */
>  STATIC void
>  xfs_inode_item_unlock(
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
