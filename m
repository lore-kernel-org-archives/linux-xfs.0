Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24057 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdJDA4J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 20:56:09 -0400
Date: Tue, 3 Oct 2017 17:56:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/25] xfs: create helpers to record and deal with scrub
 problems
Message-ID: <20171004005605.GI6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706327465.19351.16599589169408373396.stgit@magnolia>
 <20171003234449.GR3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003234449.GR3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 10:44:49AM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:41:14PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create helper functions to record crc and corruption problems, and
> > deal with any other runtime errors that arise.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > +/*
> > + * Handling scrub corruption/optimization/warning checks.
> > + *
> > + * The *_set_{corrupt,preen,warning}() family of functions are used to
> > + * record the presence of metadata that is incorrect (corrupt), could be
> > + * optimized somehow (preen), or should be flagged for administrative
> > + * review but is not incorrect (warn).
> > + *
> > + * ftrace can be used to record the precise metadata location and
> > + * approximate code location of the failed check.
> > + */
> > +
> > +/* Record a block which could be optimized. */
> > +void
> > +xfs_scrub_block_set_preen(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_buf			*bp)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_fsblock_t			fsbno;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			bno;
> > +
> > +	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
> > +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > +
> > +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> > +	trace_xfs_scrub_block_preen(sc, agno, bno, __return_address);
> 
> Is agno/agbno used here only for the trace point? if
> so, the tracepoint call could simply be:
> 
> 	trace_xfs_scrub_block_preen(sc, bp->b_bn, __return_address);
> 
> and the tracepoint internal implementation can split that into
> agno/agbno.

Yes, I'll make that change.

> 
> 
> > +}
> > +
> > +/*
> > + * Record an inode which could be optimized.  The trace data will
> > + * include the block given by bp if bp is given; otherwise it will use
> > + * the block location of the inode record itself.
> > + */
> > +void
> > +xfs_scrub_ino_set_preen(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_buf			*bp)
> > +{
> > +	struct xfs_inode		*ip = sc->ip;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_fsblock_t			fsbno;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			bno;
> > +
> > +	if (bp) {
> > +		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
> > +		agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > +	} else {
> > +		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
> 
> That's not a block number. Going to be mighty confusing because the
> trace output isn't going to tell you whether bno is an agbno or an
> agino....

Oops.  That should've been XFS_AGINO_TO_AGBNO(mp, XFS_INO_TO_AGINO(mp, ino));

Will fix, thanks for catching that.

> > +	}
> > +
> > +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> > +	trace_xfs_scrub_ino_preen(sc, ip->i_ino, agno, bno, __return_address);
> > +}
> > +
> > +/* Record a corrupt block. */
> > +void
> > +xfs_scrub_block_set_corrupt(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_buf			*bp)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_fsblock_t			fsbno;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			bno;
> > +
> > +	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
> > +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > +
> > +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> > +	trace_xfs_scrub_block_error(sc, agno, bno, __return_address);
> > +}
> > +
> > +/*
> > + * Record a corrupt inode.  The trace data will include the block given
> > + * by bp if bp is given; otherwise it will use the block location of the
> > + * inode record itself.
> > + */
> > +void
> > +xfs_scrub_ino_set_corrupt(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_ino_t			ino,
> > +	struct xfs_buf			*bp)
> > +{
> > +	struct xfs_inode		*ip = sc->ip;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_fsblock_t			fsbno;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			bno;
> > +
> > +	if (bp) {
> > +		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
> > +		agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > +	} else {
> > +		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> > +		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
> > +	}
> > +
> > +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> > +	trace_xfs_scrub_ino_error(sc, ino, agno, bno, __return_address);
> 
> Pattern seems to be repeated...
> 
> >  DEFINE_SCRUB_EVENT(xfs_scrub_start);
> >  DEFINE_SCRUB_EVENT(xfs_scrub_done);
> > +DEFINE_SCRUB_EVENT(xfs_scrub_deadlock_retry);
> > +
> > +TRACE_EVENT(xfs_scrub_op_error,
> > +	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
> > +		 xfs_agblock_t bno, int error, void *ret_ip),
> > +	TP_ARGS(sc, agno, bno, error, ret_ip),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(unsigned int, type)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agblock_t, bno)
> > +		__field(int, error)
> > +		__field(void *, ret_ip)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = sc->mp->m_super->s_dev;
> > +		__entry->type = sc->sm->sm_type;
> > +		__entry->agno = agno;
> > +		__entry->bno = bno;
> > +		__entry->error = error;
> > +		__entry->ret_ip = ret_ip;
> 
> i.e. we can put the decoding in here, which makes it all conditional
> on the tracepoint being enabled....

<nod> Done.

--D

> 
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
