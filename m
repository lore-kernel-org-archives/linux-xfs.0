Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732347AbeHCRPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Aug 2018 13:15:20 -0400
Date: Fri, 3 Aug 2018 08:18:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix a comment in xfs_log_reserve
Message-ID: <20180803151830.GW30972@magnolia>
References: <1533285093-193140-1-git-send-email-huang.chong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1533285093-193140-1-git-send-email-huang.chong@zte.com.cn>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Huang Chong <huang.chong@zte.com.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn

On Fri, Aug 03, 2018 at 04:31:33PM +0800, Huang Chong wrote:
> From: "Huang Chong" <huang.chong@zte.com.cn>
> 
> Fix the comment in xfs_log_reserve to avoid confusing.
> 
> Signed-of-by: Huang Chong <huang.chong@zte.com.cn>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5e56f3b..891ffb1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -410,7 +410,7 @@
>  }
>  
>  /*
> - * Reserve log space and return a ticket corresponding the reservation.
> + * Reserve log space and return a ticket corresponding to the reservation.
>   *
>   * Each reservation is going to reserve extra space for a log record header.
>   * When writes happen to the on-disk log, we don't subtract the length of the
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
