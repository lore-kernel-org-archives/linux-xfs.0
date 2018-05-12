Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36596 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbeELBrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 21:47:49 -0400
Date: Fri, 11 May 2018 18:47:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/10] xfs: rework secondary superblock updates in growfs
Message-ID: <20180512014743.GU11261@magnolia>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511225107.27171-9-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, May 12, 2018 at 08:51:05AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Right now we wait until we've committed changes to the primary
> superblock before we initialise any of the new secondary
> superblocks. This means that if we have any write errors for new
> secondary superblocks we end up with garbage in place rather than
> zeros or even an "in progress" superblock to indicate a grow
> operation is being done.
> 
> To ensure we can write the secondary superblocks, initialise them
> earlier in the same loop that initialises the AG headers. We stamp
> the new secondary superblocks here with the old geometry, but set
> the "sb_inprogress" field to indicate that updates are being done to
> the superblock so they cannot be used.  This will result in the
> secondary superblock fields being updated or triggering errors that
> will abort the grow before we commit any permanent changes.
> 
> This also means we can change the update mechanism of the secondary
> superblocks.  We know that we are going to wholly overwrite the
> information in the struct xfs_sb in the buffer, so there's no point
> reading it from disk. Just allocate an uncached buffer, zero it in
> memory, stamp the new superblock structure in it and write it out.
> If we fail to write it out, then we'll leave the existing sb (old or
> new w/ inprogress) on disk for repair to deal with later.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 99 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 62 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 69facd4aa7c1..28692b0e61ce 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -192,6 +192,25 @@ xfs_rmaproot_init(
>  	}
>  }
>  
> +/*
> + * Initialise new secondary superblocks with the pre-grow geometry, but mark
> + * them as "in progress" so we know they haven't yet been activated. This will
> + * get cleared when the update with the new geometry information is done after
> + * changes to the primary are committed. This isn't strictly necessary, but we
> + * get it for free with the delayed buffer write lists and it means we can tell
> + * if a grow operation didn't complete properly after the fact.
> + */
> +static void
> +xfs_sbblock_init(
> +	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp,
> +	struct aghdr_init_data	*id)
> +{
> +	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
> +
> +	xfs_sb_to_disk(dsb, &mp->m_sb);
> +	dsb->sb_inprogress = 1;
> +}
>  
>  static void
>  xfs_agfblock_init(
> @@ -328,6 +347,10 @@ xfs_grow_ag_headers(
>  
>  {
>  	struct xfs_aghdr_grow_data aghdr_data[] = {
> +		/* SB */
> +		{ XFS_AG_DADDR(mp, id->agno, XFS_SB_DADDR),
> +		  XFS_FSS_TO_BB(mp, 1), &xfs_sb_buf_ops,
> +		  &xfs_sbblock_init, 0, 0, true },
>  		/* AGF */
>  		{ XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
>  		  XFS_FSS_TO_BB(mp, 1), &xfs_agf_buf_ops,
> @@ -634,43 +657,30 @@ xfs_growfs_imaxpct(
>  
>  /*
>   * After a grow operation, we need to update all the secondary superblocks
> - * to match the new state of the primary. Read/init the superblocks and update
> - * them appropriately.
> + * to match the new state of the primary. Because we are completely overwriting
> + * all the existing fields in the secondary superblock buffers, there is no need
> + * to read them in from disk. Just get a new buffer, stamp it and write it.
> + *
> + * The sb buffers need to be cached here so that we serialise against scrub
> + * scanning secondary superblocks, but we don't want to keep it in memory once
> + * it is written so we mark it as a one-shot buffer.
>   */
>  static int
>  xfs_growfs_update_superblocks(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		oagcount)
> +	struct xfs_mount	*mp)
>  {
> -	struct xfs_buf		*bp;
>  	xfs_agnumber_t		agno;
>  	int			saved_error = 0;
>  	int			error = 0;
> +	LIST_HEAD		(buffer_list);
>  
>  	/* update secondary superblocks. */
>  	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> -		error = 0;
> -		/*
> -		 * new secondary superblocks need to be zeroed, not read from
> -		 * disk as the contents of the new area we are growing into is
> -		 * completely unknown.
> -		 */
> -		if (agno < oagcount) {
> -			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> -				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> -				  XFS_FSS_TO_BB(mp, 1), 0, &bp,
> -				  &xfs_sb_buf_ops);
> -		} else {
> -			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
> -				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> -				  XFS_FSS_TO_BB(mp, 1), 0);
> -			if (bp) {
> -				bp->b_ops = &xfs_sb_buf_ops;
> -				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> -			} else
> -				error = -ENOMEM;
> -		}
> +		struct xfs_buf		*bp;
>  
> +		bp = xfs_buf_get(mp->m_ddev_targp,
> +				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +				 XFS_FSS_TO_BB(mp, 1), 0);
>  		/*
>  		 * If we get an error reading or writing alternate superblocks,
>  		 * continue.  xfs_repair chooses the "best" superblock based
> @@ -678,25 +688,42 @@ xfs_growfs_update_superblocks(
>  		 * superblocks un-updated than updated, and xfs_repair may
>  		 * pick them over the properly-updated primary.
>  		 */
> -		if (error) {
> +		if (!bp) {
>  			xfs_warn(mp,
> -		"error %d reading secondary superblock for ag %d",
> -				error, agno);
> -			saved_error = error;
> +		"error allocating secondary superblock for ag %d",
> +				agno);
> +			if (!saved_error)
> +				saved_error = -ENOMEM;
>  			continue;
>  		}
> -		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
>  
> -		error = xfs_bwrite(bp);
> +		bp->b_ops = &xfs_sb_buf_ops;
> +		xfs_buf_oneshot(bp);

For online repair I refactored this into a xfs_sb_get_secondary function
that does all this; I guess we can clean that up later when either/both
of those things get merged.

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


--D

> +		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> +		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +		xfs_buf_delwri_queue(bp, &buffer_list);
>  		xfs_buf_relse(bp);
> +
> +		/* don't hold too many buffers at once */
> +		if (agno % 16)
> +			continue;
> +
> +		error = xfs_buf_delwri_submit(&buffer_list);
>  		if (error) {
>  			xfs_warn(mp,
> -		"write error %d updating secondary superblock for ag %d",
> +		"write error %d updating a secondary superblock near ag %d",
>  				error, agno);
> -			saved_error = error;
> +			if (!saved_error)
> +				saved_error = error;
>  			continue;
>  		}
>  	}
> +	error = xfs_buf_delwri_submit(&buffer_list);
> +	if (error) {
> +		xfs_warn(mp,
> +		"write error %d updating a secondary superblock near ag %d",
> +			error, agno);
> +	}
>  
>  	return saved_error ? saved_error : error;
>  }
> @@ -711,7 +738,6 @@ xfs_growfs_data(
>  	struct xfs_mount	*mp,
>  	struct xfs_growfs_data	*in)
>  {
> -	xfs_agnumber_t		oagcount;
>  	int			error = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -726,7 +752,6 @@ xfs_growfs_data(
>  			goto out_error;
>  	}
>  
> -	oagcount = mp->m_sb.sb_agcount;
>  	if (in->newblocks != mp->m_sb.sb_dblocks) {
>  		error = xfs_growfs_data_private(mp, in);
>  		if (error)
> @@ -742,7 +767,7 @@ xfs_growfs_data(
>  		mp->m_maxicount = 0;
>  
>  	/* Update secondary superblocks now the physical grow has completed */
> -	error = xfs_growfs_update_superblocks(mp, oagcount);
> +	error = xfs_growfs_update_superblocks(mp);
>  
>  out_error:
>  	/*
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
