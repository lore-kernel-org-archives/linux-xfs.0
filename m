Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbeGDAzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:55:06 -0400
Date: Tue, 3 Jul 2018 17:54:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/25] xfs: use ->t_firstblock in dq alloc
Message-ID: <20180704005450.GT32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-21-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-21-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:14PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 84359eeb20f4..3b61b4d266b4 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -540,14 +540,13 @@ xfs_qm_dqread_alloc(
>  	struct xfs_trans	*tp;
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_buf		*bp;
> -	xfs_fsblock_t		firstblock;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
>  			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
>  	if (error)
>  		goto err;
> -	xfs_defer_init(tp, &dfops, &firstblock);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  
>  	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
>  	if (error)
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
