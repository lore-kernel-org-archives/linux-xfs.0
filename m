Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45248 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbeDIRgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Apr 2018 13:36:43 -0400
Date: Mon, 9 Apr 2018 10:36:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/21] xfs: repair superblocks
Message-ID: <20180409173636.GQ7500@magnolia>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269904439.16346.10122475346850875266.stgit@magnolia>
 <20180406010520.GP23861@dastard>
 <20180407180448.GM7500@magnolia>
 <20180409002651.GT23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180409002651.GT23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 09, 2018 at 10:26:52AM +1000, Dave Chinner wrote:
> On Sat, Apr 07, 2018 at 11:04:48AM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 06, 2018 at 11:05:20AM +1000, Dave Chinner wrote:
> > > On Mon, Apr 02, 2018 at 12:57:24PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > If one of the backup superblocks is found to differ seriously from
> > > > superblock 0, write out a fresh copy from the in-core sb.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > .....
> > > > +/* Repair the superblock. */
> > > > +int
> > > > +xfs_repair_superblock(
> > > > +	struct xfs_scrub_context	*sc)
> > > > +{
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	struct xfs_buf			*bp;
> > > > +	struct xfs_dsb			*sbp;
> > > > +	xfs_agnumber_t			agno;
> > > > +	int				error;
> > > > +
> > > > +	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
> > > > +	agno = sc->sm->sm_agno;
> > > > +	if (agno == 0)
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > > > +		  XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > > > +		  XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> > > 
> > > If we are just overwriting the superblock, then use
> > > xfs_trans_get_buf() so we don't need to do IO here.
> > 
> > Ok.
> > 
> > > > +	if (error)
> > > > +		return error;
> > > > +	bp->b_ops = &xfs_sb_buf_ops;
> > > > +
> > > > +	/* Copy AG 0's superblock to this one. */
> > > > +	sbp = XFS_BUF_TO_SBP(bp);
> > > > +	memset(sbp, 0, mp->m_sb.sb_sectsize);
> > > 
> > > That's a bit nasty. struct xfs_dsb is not a sector size in length.
> > > 
> > > 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> > 
> > Fixed.
> > 
> > > > +	xfs_sb_to_disk(sbp, &mp->m_sb);
> > > > +	sbp->sb_bad_features2 = sbp->sb_features2;
> > > 
> > > Why is sb_bad_features2 not correct when taken from the incore
> > > superblock?
> > 
> > It is correct, this is unnecessary.
> > 
> > > > +	/* Write this to disk. */
> > > > +	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> > > > +	xfs_trans_log_buf(sc->tp, bp, 0, mp->m_sb.sb_sectsize - 1);
> > > 
> > > And why log this rather than just write it straight to disk? We've
> > > never logged secondary superblocks before, so why now?
> > 
> > Ok, will do.  I might as well change the sb scrubber to use uncached
> > buffers while I'm at it (separate patch, obviously).
> 
> We discussed this with my growfs rework that used uncached buffers -
> if there's a concurrent growfs then the secondary superblock buffers
> need to be coherent and access correctly serialised. Hence they need to
> remain cached buffers. What we need to do is make them single use
> cached buffers, so they are discarded immediately the last reference
> goes away and are not put on the lru....

Ah, ok, I'd forgotten that bit of context.  Hm, this is tricky in terms
of timing because the current growfs still uses uncached buffers for the
superblock, whereas the 'growfs tablise' series was going to use cached
buffers but (presumably) with xfs_buf_set_ref(bp, 0) to ensure they
don't hang around on the lru.

I think I'd prefer the scrub/repair code to be consistent with the only
other user of secondary superblocks (i.e. growfs).  For now that means
using uncached buffers, though I'd convert my patches if we decide to
land your growfs series before online repair.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
