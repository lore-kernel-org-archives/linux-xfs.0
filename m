Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62941 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753550AbdDMS2W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 14:28:22 -0400
Date: Thu, 13 Apr 2017 14:28:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/10] xfs: introduce xfs_trans_blk_res
Message-ID: <20170413182820.GA25915@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:08AM +0200, Christoph Hellwig wrote:
> This is a smaller helper to check the remaining block reservation in a
> transaction.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c | 2 +-
>  fs/xfs/xfs_trans.h | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index a280e126491f..3a83927a5334 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -97,7 +97,7 @@ xfs_trans_dup(
>  	/* We gave our writer reference to the new transaction */
>  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
>  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> -	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
> +	ntp->t_blk_res = xfs_trans_blk_res(tp);
>  	tp->t_blk_res = tp->t_blk_res_used;
>  	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
>  	tp->t_rtx_res = tp->t_rtx_res_used;
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 2a9292df6640..e4f041c89846 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -152,6 +152,11 @@ typedef struct xfs_trans {
>  #define	xfs_trans_agbtree_delta(tp, d)
>  #endif
>  
> +static inline unsigned int xfs_trans_blk_res(struct xfs_trans *tp)
> +{
> +	return tp->t_blk_res - tp->t_blk_res_used;
> +}
> +
>  /*
>   * XFS transaction mechanism exported interfaces.
>   */
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
