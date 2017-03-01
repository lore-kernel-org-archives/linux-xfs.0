Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbdCAR56 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 12:57:58 -0500
Date: Wed, 1 Mar 2017 12:59:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: report realtime space information via the
 rtbitmap
Message-ID: <20170301175928.GD3312@bfoster.bfoster>
References: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
 <148830760185.22089.7585485406339387044.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148830760185.22089.7585485406339387044.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2017 at 10:46:41AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the realtime bitmap to return free space information via getfsmap.
> Eventually this will be superseded by the realtime rmapbt code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsmap.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 119 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 56bbd24..bb351ed 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -41,6 +41,7 @@
>  #include "xfs_refcount.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_alloc_btree.h"
> +#include "xfs_rtalloc.h"
>  
>  /* Convert an xfs_fsmap to an fsmap. */
>  void
> @@ -415,6 +416,29 @@ xfs_getfsmap_rtdev_helper(
>  	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
>  }
>  
> +/* Transform a rtbitmap "record" into a fsmap */
> +STATIC int
> +xfs_getfsmap_rtdev_rtbitmap_helper(
> +	struct xfs_trans		*tp,
> +	struct xfs_rtalloc_rec		*rec,
> +	void				*priv)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_getfsmap_info	*info = priv;
> +	struct xfs_rmap_irec		irec;
> +	xfs_daddr_t			rec_daddr;
> +
> +	rec_daddr = XFS_FSB_TO_BB(mp, rec->ar_startblock);
> +
> +	irec.rm_startblock = rec->ar_startblock;
> +	irec.rm_blockcount = rec->ar_blockcount;
> +	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
> +	irec.rm_offset = 0;
> +	irec.rm_flags = 0;
> +
> +	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
> +}
> +
>  /* Transform a bnobt irec into a fsmap */
>  STATIC int
>  xfs_getfsmap_datadev_bnobt_helper(
> @@ -504,6 +528,93 @@ xfs_getfsmap_logdev(
>  	return xfs_getfsmap_rtdev_helper(&cur, &rmap, info);
>  }
>  
> +/* Execute a getfsmap query against the realtime device. */
> +STATIC int
> +__xfs_getfsmap_rtdev(
> +	struct xfs_trans		*tp,
> +	struct xfs_fsmap		*keys,
> +	int				(*query_fn)(struct xfs_trans *,
> +						    struct xfs_getfsmap_info *),
> +	struct xfs_getfsmap_info	*info)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	xfs_fsblock_t			start_fsb;
> +	xfs_fsblock_t			end_fsb;
> +	xfs_daddr_t			eofs;
> +	int				error = 0;
> +
> +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> +	if (keys[0].fmr_physical >= eofs)
> +		return 0;
> +	if (keys[1].fmr_physical >= eofs)
> +		keys[1].fmr_physical = eofs - 1;
> +	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
> +	end_fsb = XFS_BB_TO_FSB(mp, keys[1].fmr_physical);
> +
> +	/* Set up search keys */
> +	info->low.rm_startblock = start_fsb;
> +	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
> +	if (error)
> +		return error;
> +	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
> +	info->low.rm_blockcount = 0;
> +	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
> +
> +	info->high.rm_startblock = end_fsb;
> +	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
> +	if (error)
> +		return error;
> +	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
> +	info->high.rm_blockcount = 0;
> +	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
> +
> +	trace_xfs_fsmap_low_key(mp, info->dev, info->agno, &info->low);
> +	trace_xfs_fsmap_high_key(mp, info->dev, info->agno, &info->high);
> +
> +	return query_fn(tp, info);
> +}
> +
> +/* Actually query the realtime bitmap. */
> +STATIC int
> +xfs_getfsmap_rtdev_rtbitmap_query(
> +	struct xfs_trans		*tp,
> +	struct xfs_getfsmap_info	*info)
> +{
> +	struct xfs_rtalloc_rec		alow;
> +	struct xfs_rtalloc_rec		ahigh;
> +	int				error;
> +
> +	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> +
> +	alow.ar_startblock = info->low.rm_startblock;
> +	ahigh.ar_startblock = info->high.rm_startblock;
> +	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
> +			xfs_getfsmap_rtdev_rtbitmap_helper, info);
> +	if (error)
> +		goto err;
> +
> +	/* Report any gaps at the end of the rtbitmap */
> +	info->last = true;
> +	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
> +	if (error)
> +		goto err;
> +err:
> +	xfs_iunlock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> +	return error;
> +}
> +
> +/* Execute a getfsmap query against the realtime device rtbitmap. */
> +STATIC int
> +xfs_getfsmap_rtdev_rtbitmap(
> +	struct xfs_trans		*tp,
> +	struct xfs_fsmap		*keys,
> +	struct xfs_getfsmap_info	*info)
> +{
> +	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
> +	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
> +			info);
> +}
> +
>  /* Execute a getfsmap query against the regular data device. */
>  STATIC int
>  __xfs_getfsmap_datadev(
> @@ -719,6 +830,9 @@ xfs_getfsmap_is_valid_device(
>  	if (mp->m_logdev_targp &&
>  	    fm->fmr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
>  		return true;
> +	if (mp->m_rtdev_targp &&
> +	    fm->fmr_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
> +		return true;
>  	return false;
>  }
>  
> @@ -751,7 +865,7 @@ xfs_getfsmap_check_keys(
>  	return false;
>  }
>  
> -#define XFS_GETFSMAP_DEVS	2
> +#define XFS_GETFSMAP_DEVS	3
>  /*
>   * Get filesystem's extents as described in head, and format for
>   * output.  Calls formatter to fill the user's buffer until all
> @@ -807,6 +921,10 @@ xfs_getfsmap(
>  		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
>  		handlers[1].fn = xfs_getfsmap_logdev;
>  	}
> +	if (mp->m_rtdev_targp) {
> +		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
> +		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
> +	}
>  
>  	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),
>  			xfs_getfsmap_dev_compare);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
