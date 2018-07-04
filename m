Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbeGDAl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:41:27 -0400
Date: Tue, 3 Jul 2018 17:41:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/25] xfs: add firstblock field to xfs_trans
Message-ID: <20180704004111.GC32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:22:56PM -0400, Brian Foster wrote:
> A firstblock var is typically allocated and initialized along with
> xfs_defer_ops structures and passed around independent from the
> associated transaction. To facilitate combining the two, add an
> optional ->t_firstblock field to xfs_trans that can be used in place
> of an on-stack variable.
> 
> The firstblock value follows the lifetime of the transaction, so
> initialize it on allocation and when a transaction rolls.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems ok so far,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans.c | 2 ++
>  fs/xfs/xfs_trans.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 630993387517..de00f79ff698 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -100,6 +100,7 @@ xfs_trans_dup(
>  	ntp->t_mountp = tp->t_mountp;
>  	INIT_LIST_HEAD(&ntp->t_items);
>  	INIT_LIST_HEAD(&ntp->t_busy);
> +	ntp->t_firstblock = NULLFSBLOCK;
>  
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(tp->t_ticket != NULL);
> @@ -273,6 +274,7 @@ xfs_trans_alloc(
>  	tp->t_mountp = mp;
>  	INIT_LIST_HEAD(&tp->t_items);
>  	INIT_LIST_HEAD(&tp->t_busy);
> +	tp->t_firstblock = NULLFSBLOCK;
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>  	if (error) {
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index d8a695c57103..37fdacc690c7 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -102,6 +102,7 @@ typedef struct xfs_trans {
>  	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
>  	unsigned int		t_rtx_res;	/* # of rt extents resvd */
>  	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
> +	xfs_fsblock_t		t_firstblock;	/* first block allocated */
>  	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
>  	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
>  	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
