Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54514 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbeCMVJk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 17:09:40 -0400
Date: Tue, 13 Mar 2018 14:09:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: remove an outdated comment for
 xfs_inode_item_committing
Message-ID: <20180313210934.GL4865@magnolia>
References: <20180313104927.12926-1-hch@lst.de>
 <20180313104927.12926-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313104927.12926-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 11:49:21AM +0100, Christoph Hellwig wrote:
> The function now does something, and that something is central to our
> inode logging scheme.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode_item.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index b83fa38f1c74..31f2b32b7e27 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -634,10 +634,6 @@ xfs_inode_item_committed(
>  	return lsn;
>  }
>  
> -/*
> - * XXX rcc - this one really has to do something.  Probably needs
> - * to stamp in a new field in the incore inode.
> - */
>  STATIC void
>  xfs_inode_item_committing(
>  	struct xfs_log_item	*lip,
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
