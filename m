Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753252AbdBCNG4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 08:06:56 -0500
Date: Fri, 3 Feb 2017 08:06:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: reset b_first_retry_time when clear the retry
 status of xfs_buf_t
Message-ID: <20170203130653.GA45388@bfoster.bfoster>
References: <1486112905-38025-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486112905-38025-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com, sandeen@redhat.com

On Fri, Feb 03, 2017 at 05:08:25PM +0800, Hou Tao wrote:
> After successful IO or permanent error, b_first_retry_time also
> needs to be cleared, else the invalid first retry time will be
> used by the next retry check.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 2975cb2..0306168 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1162,6 +1162,7 @@ xfs_buf_iodone_callbacks(
>  	 */
>  	bp->b_last_error = 0;
>  	bp->b_retries = 0;
> +	bp->b_first_retry_time = 0;
>  
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_fspriv = NULL;
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
