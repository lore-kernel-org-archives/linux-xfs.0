Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28206 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752837AbdHPRVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 13:21:35 -0400
Date: Wed, 16 Aug 2017 10:21:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: rename xfs_defer_join to xfs_defer_join_inode
Message-ID: <20170816172130.GA4796@magnolia>
References: <20170813144216.11192-1-hch@lst.de>
 <20170813144216.11192-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170813144216.11192-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Aug 13, 2017 at 04:42:15PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c  | 2 +-
>  fs/xfs/libxfs/xfs_defer.c | 4 ++--
>  fs/xfs/libxfs/xfs_defer.h | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c09c16b1ad3b..24eba36ef818 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6452,7 +6452,7 @@ __xfs_bmap_add(
>  	bi->bi_whichfork = whichfork;
>  	bi->bi_bmap = *bmap;
>  
> -	error = xfs_defer_join(dfops, bi->bi_owner);
> +	error = xfs_defer_join_inode(dfops, bi->bi_owner);

/me wonders if this should be named xfs_defer_ijoin to be more
consistent with xfs_trans_ijoin, or if we should rename the other one to
xfs_trans_join_inode instead?

Other than that,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	if (error) {
>  		kmem_free(bi);
>  		return error;
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 87169bf56a09..043844f00f6e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -281,7 +281,7 @@ xfs_defer_has_unfinished_work(
>   * to xfs_defer_finish().
>   */
>  int
> -xfs_defer_join(
> +xfs_defer_join_inode(
>  	struct xfs_defer_ops		*dop,
>  	struct xfs_inode		*ip)
>  {
> @@ -324,7 +324,7 @@ xfs_defer_finish(
>  
>  	trace_xfs_defer_finish((*tp)->t_mountp, dop);
>  
> -	xfs_defer_join(dop, ip);
> +	xfs_defer_join_inode(dop, ip);
>  
>  	/* Until we run out of pending work to finish... */
>  	while (xfs_defer_has_unfinished_work(dop)) {
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index f6e93ef0bffe..4632c798ea2b 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -77,7 +77,7 @@ int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop,
>  void xfs_defer_cancel(struct xfs_defer_ops *dop);
>  void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> -int xfs_defer_join(struct xfs_defer_ops *dop, struct xfs_inode *ip);
> +int xfs_defer_join_inode(struct xfs_defer_ops *dop, struct xfs_inode *ip);
>  
>  /* Description of a deferred type. */
>  struct xfs_defer_op_type {
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
