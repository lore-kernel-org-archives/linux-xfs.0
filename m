Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33542 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388666AbeGXVf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 17:35:57 -0400
Date: Tue, 24 Jul 2018 13:27:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 02/15] xfs: use ->t_dfops in log recovery intent
 processing
Message-ID: <20180724202735.GA4813@magnolia>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:01AM -0400, Brian Foster wrote:
> xlog_finish_defer_ops() processes the deferred operations collected
> over the entire intent recovery sequence. We can't xfs_defer_init()
> here because the dfops is already populated. Attach it manually and
> eliminate the last caller of xfs_defer_finish() that doesn't pass
> ->t_dfops.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index cbac943896f4..3289811eb076 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4854,6 +4854,8 @@ xlog_finish_defer_ops(
>  			0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
> +	/* dfops is already populated so assign it manually */
> +	tp->t_dfops = dfops;
>  
>  	error = xfs_defer_finish(&tp, dfops);
>  	if (error)
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
