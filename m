Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeBIQMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Feb 2018 11:12:43 -0500
Date: Fri, 9 Feb 2018 11:12:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] xfs: rework secondary superblock updates in growfs
Message-ID: <20180209161240.GD21413@bfoster.bfoster>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201064202.7174-8-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 05:42:02PM +1100, Dave Chinner wrote:
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
>  fs/xfs/xfs_fsops.c | 92 ++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 55 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 113be7dbdc81..7318cebb591d 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
...
> @@ -630,43 +653,27 @@ xfs_growfs_imaxpct(
>  
...
>  static int
>  xfs_growfs_update_superblocks(
...
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
> +		bp = xfs_growfs_get_hdr_buf(mp,
> +				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);

This all seems fine to me up until the point where we use uncached
buffers for pre-existing secondary superblocks. This may all be fine now
if nothing else happens to access/use secondary supers, but it seems
like this essentially enforces that going forward.

Hmm, I see that scrub does appear to look at secondary superblocks via
cached buffers. Shouldn't we expect this path to maintain coherency with
an sb buffer that may have been read/cached from there?

Brian

>  		/*
>  		 * If we get an error reading or writing alternate superblocks,
>  		 * continue.  xfs_repair chooses the "best" superblock based
> @@ -674,25 +681,38 @@ xfs_growfs_update_superblocks(
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
>  		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> -
> -		error = xfs_bwrite(bp);
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
> @@ -707,7 +727,6 @@ xfs_growfs_data(
>  	struct xfs_mount	*mp,
>  	struct xfs_growfs_data	*in)
>  {
> -	xfs_agnumber_t		oagcount;
>  	int			error = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -722,7 +741,6 @@ xfs_growfs_data(
>  			goto out_error;
>  	}
>  
> -	oagcount = mp->m_sb.sb_agcount;
>  	error = xfs_growfs_data_private(mp, in);
>  	if (error)
>  		goto out_error;
> @@ -740,7 +758,7 @@ xfs_growfs_data(
>  	/*
>  	 * Update secondary superblocks now the physical grow has completed
>  	 */
> -	error = xfs_growfs_update_superblocks(mp, oagcount);
> +	error = xfs_growfs_update_superblocks(mp);
>  
>  out_error:
>  	/*
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
