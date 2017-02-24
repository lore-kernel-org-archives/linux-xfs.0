Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145902.pgv7mkcfiuflag7g@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx1.redhat.com ([209.132.183.28]:53076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751297AbdBXNEv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Feb 2017 08:04:51 -0500
Date: Fri, 24 Feb 2017 08:04:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/8] xfs: have getfsmap fall back to the freesp btrees
 when rmap is not present
Message-ID: <20170224130449.GB59560@bfoster.bfoster>
References: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
 <148738067544.29384.3138548741798927323.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148738067544.29384.3138548741798927323.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 17, 2017 at 05:17:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the reverse-mapping btree isn't available, fall back to the
> free space btrees to provide partial reverse mapping information.
> The online scrub tool can make use of even partial information to
> speed up the data block scan.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_fsmap.c |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 152 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 09d6b92..82e44a9 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -40,6 +40,7 @@
>  #include "xfs_fsmap.h"
>  #include "xfs_refcount.h"
>  #include "xfs_refcount_btree.h"
> +#include "xfs_alloc_btree.h"
>  
>  /* Convert an xfs_fsmap to an fsmap. */
>  void
> @@ -158,6 +159,9 @@ xfs_fsmap_owner_from_rmap(
>  	case XFS_RMAP_OWN_COW:
>  		fmr->fmr_owner = XFS_FMR_OWN_COW;
>  		break;
> +	case XFS_RMAP_OWN_NULL:	/* "free" */
> +		fmr->fmr_owner = XFS_FMR_OWN_FREE;
> +		break;
>  	default:
>  		return -EFSCORRUPTED;
>  	}
> @@ -433,6 +437,31 @@ xfs_getfsmap_rtdev_helper(
>  	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
>  }
>  
> +/* Transform a bnobt irec into a fsmap */
> +STATIC int
> +xfs_getfsmap_datadev_bnobt_helper(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_alloc_rec_incore	*rec,
> +	void				*priv)
> +{
> +	struct xfs_mount		*mp = cur->bc_mp;
> +	struct xfs_getfsmap_info	*info = priv;
> +	struct xfs_rmap_irec		irec;
> +	xfs_fsblock_t			fsb;
> +	xfs_daddr_t			rec_daddr;
> +
> +	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno, rec->ar_startblock);
> +	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
> +
> +	irec.rm_startblock = rec->ar_startblock;
> +	irec.rm_blockcount = rec->ar_blockcount;
> +	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
> +	irec.rm_offset = 0;
> +	irec.rm_flags = 0;
> +

Slightly confused... if we directly pass free space records to
xfs_getfsmap_helper(), won't it also assume the gaps between the records
are free space?

> +	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr);
> +}
> +
>  /* Set rmap flags based on the getfsmap flags */
>  static void
>  xfs_getfsmap_set_irec_flags(
> @@ -621,6 +650,125 @@ xfs_getfsmap_datadev(
>  	return error;
>  }
>  
> +/* Execute a getfsmap query against the regular data device's bnobt. */
> +STATIC int
> +xfs_getfsmap_datadev_bnobt(
> +	struct xfs_trans		*tp,
> +	struct xfs_fsmap		*keys,
> +	struct xfs_getfsmap_info	*info)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_btree_cur		*bt_cur = NULL;
> +	struct xfs_fsmap		*dkey_low;
> +	struct xfs_fsmap		*dkey_high;
> +	struct xfs_alloc_rec_incore	alow;
> +	struct xfs_alloc_rec_incore	ahigh;
> +	xfs_fsblock_t			start_fsb;
> +	xfs_fsblock_t			end_fsb;
> +	xfs_agnumber_t			start_ag;
> +	xfs_agnumber_t			end_ag;
> +	xfs_daddr_t			eofs;
> +	int				error = 0;
> +
> +	dkey_low = keys;
> +	dkey_high = keys + 1;
> +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> +	if (dkey_low->fmr_physical >= eofs)
> +		return 0;
> +	if (dkey_high->fmr_physical >= eofs)
> +		dkey_high->fmr_physical = eofs - 1;
> +	start_fsb = XFS_DADDR_TO_FSB(mp, dkey_low->fmr_physical);
> +	end_fsb = XFS_DADDR_TO_FSB(mp, dkey_high->fmr_physical);
> +
> +	/* Set up search keys */
> +	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
> +	info->low.rm_offset = XFS_BB_TO_FSBT(mp, dkey_low->fmr_offset);
> +	error = xfs_fsmap_owner_to_rmap(dkey_low, &info->low);
> +	if (error)
> +		return error;
> +	info->low.rm_blockcount = 0;
> +	xfs_getfsmap_set_irec_flags(&info->low, dkey_low);
> +
> +	info->high.rm_startblock = -1U;
> +	info->high.rm_owner = ULLONG_MAX;
> +	info->high.rm_offset = ULLONG_MAX;
> +	info->high.rm_blockcount = 0;
> +	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
> +
> +	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
> +

Ok, I see. We've swapped the meaning of the gaps in the record space to
allocated blocks with an unknown owner. Comment please :). Also, I
suppose the comments in xfs_getfsmap_helper() could be more discrete
about this as they currently explicitly say that gaps refer to free
space in one or two places.

> +	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
> +	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
> +
> +	/* Query each AG */
> +	for (info->agno = start_ag; info->agno <= end_ag; info->agno++) {
> +		if (info->agno == end_ag) {
> +			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
> +					end_fsb);
> +			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
> +					dkey_high->fmr_offset);
> +			error = xfs_fsmap_owner_to_rmap(dkey_high, &info->high);
> +			if (error)
> +				goto err;
> +			xfs_getfsmap_set_irec_flags(&info->high, dkey_high);
> +		}
> +
> +		if (bt_cur) {
> +			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> +			bt_cur = NULL;
> +			info->agf_bp = NULL;
> +		}
> +
> +		error = xfs_alloc_read_agf(mp, tp, info->agno, 0,
> +				&info->agf_bp);
> +		if (error)
> +			goto err;
> +
> +		trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
> +				info->low.rm_startblock,
> +				info->low.rm_blockcount,
> +				info->low.rm_owner,
> +				info->low.rm_offset);
> +
> +		trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
> +				info->high.rm_startblock,
> +				info->high.rm_blockcount,
> +				info->high.rm_owner,
> +				info->high.rm_offset);
> +
> +		bt_cur = xfs_allocbt_init_cursor(mp, tp, info->agf_bp,
> +				info->agno, XFS_BTNUM_BNO);
> +		alow.ar_startblock = info->low.rm_startblock;
> +		ahigh.ar_startblock = info->high.rm_startblock;
> +		error = xfs_alloc_query_range(bt_cur, &alow, &ahigh,
> +				xfs_getfsmap_datadev_bnobt_helper, info);
> +		if (error)
> +			goto err;
> +
> +		if (info->agno == start_ag) {
> +			info->low.rm_startblock = 0;
> +			info->low.rm_owner = 0;
> +			info->low.rm_offset = 0;
> +			info->low.rm_flags = 0;
> +		}
> +	}
> +
> +	/* Report any free space at the end of the AG */
> +	info->last = true;
> +	error = xfs_getfsmap_datadev_bnobt_helper(bt_cur, &ahigh, info);
> +	if (error)
> +		goto err;
> +

I guess the comment here is a little misleading too because we aren't
looking for more free space. Rather, any more allocated ranges beyond
the last free space record, right?

FWIW, this handler overall looks quite similar to xfs_datadev_helper().
It might be interesting to see if the guts of the two could be combined
into an internal function (called by both _datadev() and
_datadev_bnobt() as wrappers) that has the unique bits passed to it
(i.e., cursor, missing owner).

Brian

> +err:
> +	if (bt_cur)
> +		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
> +							 XFS_BTREE_NOERROR);
> +	if (info->agf_bp)
> +		info->agf_bp = NULL;
> +
> +	return error;
> +}
> +
>  /* Do we recognize the device? */
>  STATIC bool
>  xfs_getfsmap_is_valid_device(
> @@ -689,8 +837,6 @@ xfs_getfsmap(
>  	int				i;
>  	int				error = 0;
>  
> -	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> -		return -EOPNOTSUPP;
>  	if (head->fmh_iflags & ~FMH_IF_VALID)
>  		return -EINVAL;
>  	rkey_low = head->fmh_keys;
> @@ -704,7 +850,10 @@ xfs_getfsmap(
>  	/* Set up our device handlers. */
>  	memset(handlers, 0, sizeof(handlers));
>  	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
> -	handlers[0].fn = xfs_getfsmap_datadev;
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		handlers[0].fn = xfs_getfsmap_datadev;
> +	else
> +		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
>  	if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
>  		handlers[1].fn = xfs_getfsmap_logdev;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
