Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38696 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbeG3VqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 17:46:21 -0400
Date: Mon, 30 Jul 2018 13:09:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/15] xfs: remove unused __xfs_defer_cancel() internal
 helper
Message-ID: <20180730200938.GD30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:08PM -0400, Brian Foster wrote:
> With no more external dfops users, there is no need for an
> xfs_defer_ops cancel wrapper.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 5 +++--
>  fs/xfs/libxfs/xfs_defer.h | 2 +-
>  fs/xfs/xfs_trans.c        | 7 -------
>  fs/xfs/xfs_trans.h        | 3 ---
>  4 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index a5f7dc18a62f..ebead781613f 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -465,9 +465,10 @@ xfs_defer_finish(
>   * Free up any items left in the list.
>   */
>  void
> -__xfs_defer_cancel(
> -	struct xfs_defer_ops		*dop)
> +xfs_defer_cancel(
> +	struct xfs_trans		*tp)
>  {
> +	struct xfs_defer_ops		*dop = tp->t_dfops;
>  	struct xfs_defer_pending	*dfp;
>  	struct xfs_defer_pending	*pli;
>  	struct list_head		*pwi;
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 85c41fe4dbae..da145fc04ae1 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -50,7 +50,7 @@ void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
>  		struct list_head *h);
>  int xfs_defer_finish_noroll(struct xfs_trans **tp);
>  int xfs_defer_finish(struct xfs_trans **tp);
> -void __xfs_defer_cancel(struct xfs_defer_ops *dop);
> +void xfs_defer_cancel(struct xfs_trans *);
>  void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
>  int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8d3b7f28b193..b0eeeaf6d24e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1105,10 +1105,3 @@ xfs_trans_roll(
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  	return xfs_trans_reserve(*tpp, &tres, 0, 0);
>  }
> -
> -void
> -xfs_defer_cancel(
> -	struct xfs_trans	*tp)
> -{
> -	__xfs_defer_cancel(tp->t_dfops);
> -}
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 5170e89bec02..dc79e3c1d3e8 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -214,9 +214,6 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> -/* cancel dfops associated with a transaction */
> -void xfs_defer_cancel(struct xfs_trans *);
> -
>  struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
>  
>  void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
