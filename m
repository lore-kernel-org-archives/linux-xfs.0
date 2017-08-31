Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26625 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751823AbdHaQlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 12:41:11 -0400
Date: Thu, 31 Aug 2017 09:41:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix unused variable warning in xfs_buf_item_unlock()
Message-ID: <20170831164107.GL3775@magnolia>
References: <20170831160458.24886-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831160458.24886-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 31, 2017 at 12:04:58PM -0400, Brian Foster wrote:
> The ordered variable generates an unused warning on !DEBUG builds.
> Separate the initialization of the associated variables from the
> declarations to quiet gcc.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_buf_item.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index ef2c137..f5d25f5 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -567,10 +567,15 @@ xfs_buf_item_unlock(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	bool			aborted = !!(lip->li_flags & XFS_LI_ABORTED);
> -	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> -	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> -	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
> +	bool			aborted;
> +	bool			hold;
> +	bool			dirty;
> +	bool			ordered;
> +
> +	aborted = !!(lip->li_flags & XFS_LI_ABORTED);
> +	hold = !!(bip->bli_flags & XFS_BLI_HOLD);
> +	dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
> +	ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
>  
>  	/* Clear the buffer's association with this transaction. */
>  	bp->b_transp = NULL;
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
