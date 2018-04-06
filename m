Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28922 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751298AbeDFBFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 21:05:22 -0400
Date: Fri, 6 Apr 2018 11:05:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] xfs: repair superblocks
Message-ID: <20180406010520.GP23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269904439.16346.10122475346850875266.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269904439.16346.10122475346850875266.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:57:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If one of the backup superblocks is found to differ seriously from
> superblock 0, write out a fresh copy from the in-core sb.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> +/* Repair the superblock. */
> +int
> +xfs_repair_superblock(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_buf			*bp;
> +	struct xfs_dsb			*sbp;
> +	xfs_agnumber_t			agno;
> +	int				error;
> +
> +	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
> +	agno = sc->sm->sm_agno;
> +	if (agno == 0)
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +		  XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> +		  XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);

If we are just overwriting the superblock, then use
xfs_trans_get_buf() so we don't need to do IO here.

> +	if (error)
> +		return error;
> +	bp->b_ops = &xfs_sb_buf_ops;
> +
> +	/* Copy AG 0's superblock to this one. */
> +	sbp = XFS_BUF_TO_SBP(bp);
> +	memset(sbp, 0, mp->m_sb.sb_sectsize);

That's a bit nasty. struct xfs_dsb is not a sector size in length.

	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));

> +	xfs_sb_to_disk(sbp, &mp->m_sb);
> +	sbp->sb_bad_features2 = sbp->sb_features2;

Why is sb_bad_features2 not correct when taken from the incore
superblock?

> +	/* Write this to disk. */
> +	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> +	xfs_trans_log_buf(sc->tp, bp, 0, mp->m_sb.sb_sectsize - 1);

And why log this rather than just write it straight to disk? We've
never logged secondary superblocks before, so why now?

>  int xfs_repair_setup_btree_extent_collection(struct xfs_scrub_context *sc);
>  
>  /* Metadata repairers */
> +int xfs_repair_superblock(struct xfs_scrub_context *sc);
>  
>  #else
>  
> @@ -106,6 +107,8 @@ xfs_repair_calc_ag_resblks(
>  	return 0;
>  }
>  
> +#define xfs_repair_superblock		(NULL)

Static inline, returns -EOPNOTSUPP. Or, as I'm suspecting that
all the patches are goign to do this - have a generic
xfs_repair_notsupported() function and define the functions
to that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
