Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbeGCVKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:10:11 -0400
Date: Tue, 3 Jul 2018 14:09:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/24] xfs: remove unused btree cursor bc_private.a.dfops
 field
Message-ID: <20180703210954.GP32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-21-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-21-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:32PM -0400, Brian Foster wrote:
> The xfs_btree_cur.bc_private.a.dfops field is only ever initialized
> by the refcountbt cursor init function. The only caller of that
> function with a non-NULL dfops is from deferred completion context,
> which already has attached to ->t_dfops.
> 
> In addition to that, the only actual reference of a.dfops is the
> cursor duplication function, which means the field is effectively
> unused.
> 
> Remove the dfops field from the bc_private.a union. Any future users
> can acquire the dfops from the transaction. This patch does not
> change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

IIRC that unused dfops was a leftover artifact of preparing for
inode-rooted refcount btrees for the realtime device, but I can always
add it back in whenever I get back to working on that.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_btree.h          | 1 -
>  fs/xfs/libxfs/xfs_refcount.c       | 4 ++--
>  fs/xfs/libxfs/xfs_refcount_btree.c | 7 ++-----
>  fs/xfs/libxfs/xfs_refcount_btree.h | 4 ++--
>  fs/xfs/scrub/common.c              | 2 +-
>  fs/xfs/xfs_fsmap.c                 | 2 +-
>  fs/xfs/xfs_reflink.c               | 2 +-
>  7 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index cc94ac765dec..b986a8fc8d40 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -209,7 +209,6 @@ typedef struct xfs_btree_cur
>  	union {
>  		struct {			/* needed for BNO, CNT, INO */
>  			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> -			struct xfs_defer_ops *dfops;	/* deferred updates */
>  			xfs_agnumber_t	agno;	/* ag number */
>  			union xfs_btree_cur_private	priv;
>  		} a;
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 9dda6fd0bb13..8e330a196060 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1132,7 +1132,7 @@ xfs_refcount_finish_one(
>  		if (!agbp)
>  			return -EFSCORRUPTED;
>  
> -		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, dfops);
> +		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
>  		if (!rcur) {
>  			error = -ENOMEM;
>  			goto out_cur;
> @@ -1666,7 +1666,7 @@ xfs_refcount_recover_cow_leftovers(
>  		error = -ENOMEM;
>  		goto out_trans;
>  	}
> -	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
>  
>  	/* Find all the leftover CoW staging extents. */
>  	memset(&low, 0, sizeof(low));
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index b71937982c5b..393aa88f93db 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -27,8 +27,7 @@ xfs_refcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
> -			cur->bc_private.a.agbp, cur->bc_private.a.agno,
> -			cur->bc_private.a.dfops);
> +			cur->bc_private.a.agbp, cur->bc_private.a.agno);
>  }
>  
>  STATIC void
> @@ -323,8 +322,7 @@ xfs_refcountbt_init_cursor(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> -	xfs_agnumber_t		agno,
> -	struct xfs_defer_ops	*dfops)
> +	xfs_agnumber_t		agno)
>  {
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	struct xfs_btree_cur	*cur;
> @@ -344,7 +342,6 @@ xfs_refcountbt_init_cursor(
>  
>  	cur->bc_private.a.agbp = agbp;
>  	cur->bc_private.a.agno = agno;
> -	cur->bc_private.a.dfops = dfops;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
>  	cur->bc_private.a.priv.refc.nr_ops = 0;
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index d2852b6e1fa8..801c2c7732fd 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -44,8 +44,8 @@ struct xfs_mount;
>  		 ((index) - 1) * sizeof(xfs_refcount_ptr_t)))
>  
>  extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
> -		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
> -		struct xfs_defer_ops *dfops);
> +		struct xfs_trans *tp, struct xfs_buf *agbp,
> +		xfs_agnumber_t agno);
>  extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
>  extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
>  
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 70e70c69f83f..385fa5b9c878 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -499,7 +499,7 @@ xfs_scrub_ag_btcur_init(
>  	/* Set up a refcountbt cursor for cross-referencing. */
>  	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb)) {
>  		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
> -				sa->agf_bp, agno, NULL);
> +				sa->agf_bp, agno);
>  		if (!sa->refc_cur)
>  			goto err;
>  	}
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index c7157bc48bd1..297d7ce2901e 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -214,7 +214,7 @@ xfs_getfsmap_is_shared(
>  	/* Are there any shared blocks here? */
>  	flen = 0;
>  	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
> -			info->agno, NULL);
> +			info->agno);
>  
>  	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
>  			rec->rm_blockcount, &fbno, &flen, false);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 2221c6c6a5d3..7cfe74d1514e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -157,7 +157,7 @@ xfs_reflink_find_shared(
>  	if (!agbp)
>  		return -ENOMEM;
>  
> -	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> +	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
>  
>  	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
>  			find_end_of_shared);
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
