Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbfD2RqB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Apr 2019 13:46:01 -0400
Date: Mon, 29 Apr 2019 13:45:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: add online scrub for superblock counters
Message-ID: <20190429174533.GA56119@bfoster>
References: <20190428221006.GD5217@magnolia>
 <20190429120029.GA49787@bfoster>
 <20190429171011.GE5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429171011.GE5207@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 29, 2019 at 10:10:11AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 29, 2019 at 08:00:29AM -0400, Brian Foster wrote:
> > On Sun, Apr 28, 2019 at 03:10:06PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Teach online scrub how to check the filesystem summary counters.  We use
> > > the incore delalloc block counter along with the incore AG headers to
> > > compute expected values for fdblocks, icount, and ifree, and then check
> > > that the percpu counter is within a certain threshold of the expected
> > > value.  This is done to avoid having to freeze or otherwise lock the
> > > filesystem, which means that we're only checking that the counters are
> > > fairly close, not that they're exactly correct.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: move all the io generating calls into a warmup function
> > > v3: tighten the aggregation loop and rework the threshold check function
> > > ---
> > >  fs/xfs/Makefile           |    1 
> > >  fs/xfs/libxfs/xfs_fs.h    |    3 
> > >  fs/xfs/libxfs/xfs_types.c |    2 
> > >  fs/xfs/libxfs/xfs_types.h |    2 
> > >  fs/xfs/scrub/common.c     |    9 +
> > >  fs/xfs/scrub/common.h     |    2 
> > >  fs/xfs/scrub/fscounters.c |  360 +++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/scrub/health.c     |    1 
> > >  fs/xfs/scrub/scrub.c      |    6 +
> > >  fs/xfs/scrub/scrub.h      |    9 +
> > >  fs/xfs/scrub/trace.h      |   63 ++++++++
> > >  11 files changed, 455 insertions(+), 3 deletions(-)
> > >  create mode 100644 fs/xfs/scrub/fscounters.c
> > > 
> > ...
> > > diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> > > new file mode 100644
> > > index 000000000000..aeb753dd0eaa
> > > --- /dev/null
> > > +++ b/fs/xfs/scrub/fscounters.c
> > > @@ -0,0 +1,360 @@
> > ...
> > > +/*
> > > + * Make sure the per-AG structure has been initialized from the on-disk header
> > > + * contents and that the incore counters match the ondisk counters.  Do this
> > > + * from the setup function so that the inner summation loop runs as quickly as
> > > + * possible.
> > > + *
> > 
> > I don't see this function matching incore counters against ondisk
> > counters anywhere.
> 
> Oops, that was moved to the AG[FI] scrubbers.  How about I change the
> comment to:
> 

Ok, figured it was just stale content..

> /*
>  * Make sure the per-AG structure has been initialized from the on-disk
>  * header contents and trust that the incore counters match the ondisk
>  * counters.  (The AGF and AGI scrubbers check them, and a normal
>  * xfs_scrub run checks the summary counters after checking all AG
>  * headers).  Do this from the setup function so that the inner AG
>  * aggregation loop runs as quickly as possible.
>  *
>  * This function runs during the setup phase /before/ we start checking
>  * any metadata.
>  */
> 
> ?
> 

Sounds good.

> > 
> > > + * This function runs during the setup phase /before/ we start checking any
> > > + * metadata.
> > > + */
> > > +STATIC int
> > > +xchk_fscount_warmup(
> > > +	struct xfs_scrub	*sc)
> > > +{
> > > +	struct xfs_mount	*mp = sc->mp;
> > > +	struct xfs_buf		*agi_bp = NULL;
> > > +	struct xfs_buf		*agf_bp = NULL;
> > > +	struct xfs_perag	*pag = NULL;
> > > +	xfs_agnumber_t		agno;
> > > +	int			error = 0;
> > > +
> > > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > > +		pag = xfs_perag_get(mp, agno);
> > > +
> > > +		if (pag->pagi_init && pag->pagf_init)
> > > +			goto next_loop_perag;
> > > +
> > > +		/* Lock both AG headers. */
> > > +		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
> > > +		if (error)
> > > +			break;
> > > +		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
> > > +		if (error)
> > > +			break;
> > > +		error = -ENOMEM;
> > > +		if (!agf_bp || !agi_bp)
> > > +			break;
> > > +
> > > +		/*
> > > +		 * These are supposed to be initialized by the header read
> > > +		 * function.
> > > +		 */
> > > +		error = -EFSCORRUPTED;
> > > +		if (!pag->pagi_init || !pag->pagf_init)
> > > +			break;
> > > +
> > > +		xfs_buf_relse(agf_bp);
> > > +		agf_bp = NULL;
> > > +		xfs_buf_relse(agi_bp);
> > > +		agi_bp = NULL;
> > > +next_loop_perag:
> > > +		xfs_perag_put(pag);
> > > +		pag = NULL;
> > > +		error = 0;
> > > +
> > > +		if (fatal_signal_pending(current))
> > > +			break;
> > > +	}
> > > +
> > > +	if (agf_bp)
> > > +		xfs_buf_relse(agf_bp);
> > > +	if (agi_bp)
> > > +		xfs_buf_relse(agi_bp);
> > > +	if (pag)
> > > +		xfs_perag_put(pag);
> > > +	return error;
> > > +}
> > > +
> > ...
> > > +/*
> > > + * Is the @counter reasonably close to the @expected value?
> > > + *
> > > + * We neither locked nor froze anything in the filesystem while aggregating the
> > > + * per-AG data to compute the @expected value, which means that the counter
> > > + * could have changed.  We know the @old_value of the summation of the counter
> > > + * before the aggregation, and we re-sum the counter now.  If the expected
> > > + * value falls between the two summations, we're ok.
> > > + *
> > > + * Otherwise, we /might/ have a problem.  If the change in the summations is
> > > + * more than we want to tolerate, the filesystem is probably busy and we should
> > > + * just send back INCOMPLETE and see if userspace will try again.
> > > + */
> > > +static inline bool
> > > +xchk_fscount_within_range(
> > > +	struct xfs_scrub	*sc,
> > > +	const int64_t		old_value,
> > > +	struct percpu_counter	*counter,
> > > +	uint64_t		expected)
> > > +{
> > > +	int64_t			min_value, max_value;
> > > +	int64_t			curr_value = percpu_counter_sum(counter);
> > > +
> > > +	trace_xchk_fscounters_within_range(sc->mp, expected, curr_value,
> > > +			old_value);
> > > +
> > > +	/* Negative values are always wrong. */
> > > +	if (curr_value < 0)
> > > +		return false;
> > > +
> > > +	/* Exact matches are always ok. */
> > > +	if (curr_value == expected)
> > > +		return true;
> > > +
> > > +	min_value = min(old_value, curr_value);
> > > +	max_value = max(old_value, curr_value);
> > > +
> > > +	/* Within the before-and-after range is ok. */
> > > +	if (expected >= min_value && expected <= max_value)
> > > +		return true;
> > > +
> > 
> > If the max/min variance is subject to restrictions, why do we allow the
> > expected value to pass against those values before we check the variance
> > below? Is the variance intended to only filter out false corruption
> > reports?
> 
> For now, yes, the placement is deliberate to filter only false
> corruption reports, because the only thing we can do for now is set the
> OFLAG_INCOMPLETE.  xfs_scrub reports that status but doesn't otherwise
> do anything with that information...
> 
> > It seems a little strange to me to establish a variance rule
> > like this where we don't trust them enough to indicate corruption, but
> > would trust them enough to confirm lack of corruption (as opposed to
> > telling the user "you might want to try again").
> 
> ...because "INCOMPLETE" isn't specific enough to suggest to xfs_scrub
> how it might improve the odds of a complete check when it tries again.
> We ran the race on a busy system once and didn't win, so there's little
> point in doing that all over again.
> 
> In a future online repair patchset I'll add the ability to freeze the
> filesystem for certain fsck operations, which should solve the
> variability problems; and add a new return value (EUSERS) that the
> kernel will use to signal to xfs_scrub that it should try the scrub
> again, but this time granting the kernel permission to freeze the fs
> (IFLAG_FREEZE_OK).  (Or xfs_scrub can decide that it doesn't care.)
> 
> At that point, I'll move the MIN_VARIANCE check above the min/max_value
> check and have it return EUSERS so that userspace can be asked to call
> back with freezing enabled.  For now I aim only to avoid triggering
> false corruption reports and warning about incomplete checks when scrub
> can't really do much better.
> 

That all sounds reasonable to me. You basically end up with a pass, fail
or "fs too busy/inconclusive, retry with blocking enabled" status. I
still don't really see the point of even temporarily putting the
variance check after the passing check though. If the current gap in the
feature is the blocking mechanism, as a user, I'd still prefer to see
the "too busy" status in the meantime over some semi-false "everything
checks out" status. At least then I know to either run a check during
downtime or to stop whatever fs activity is going on to get a legitimate
result. As it is, a user could be running this check repeatedly
concurrent with a workload that would never satisfy the variance check
even if it found something wrong and thus not even be aware the check is
simply a waste of time.

That said, it's not a big deal to me if this is all WIP and we're moving
in the direction where the "too much variance" state overrides the
pass/fail state (in the non blocking scrub) once all the parts are in
place..

> Hmm, maybe that should be wrapped up in a comment...
> 
> 	/*
> 	 * If the difference between the two summations is too large, the fs
> 	 * might just be busy and so we'll mark the scrub incomplete.  Return
> 	 * true here so that we don't mark the counter corrupt.
> 	 *
> 	 * XXX: In the future when userspace can grant scrub permission to
> 	 * quiesce the filesystem to solve the outsized variance problem, this
> 	 * check should be moved up and the return code changed to signal to
> 	 * userspace that we need quiesce permission.
> 	 */
> 
> How about that?
> 

That works for me. With those comment fixups in place:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> --D
> 
> > Brian
> > 
> > > +	/*
> > > +	 * If the difference between the two summations is too large, the fs
> > > +	 * might just be busy and so we'll mark the scrub incomplete.  Return
> > > +	 * true here so that we don't mark the counter corrupt.
> > > +	 */
> > > +	if (max_value - min_value >= XCHK_FSCOUNT_MIN_VARIANCE) {
> > > +		xchk_set_incomplete(sc);
> > > +		return true;
> > > +	}
> > > +
> > > +	return false;
> > > +}
> > > +
> > > +/* Check the superblock counters. */
> > > +int
> > > +xchk_fscounters(
> > > +	struct xfs_scrub	*sc)
> > > +{
> > > +	struct xfs_mount	*mp = sc->mp;
> > > +	struct xchk_fscounters	*fsc = sc->buf;
> > > +	int64_t			icount, ifree, fdblocks;
> > > +	int			error;
> > > +
> > > +	/* Snapshot the percpu counters. */
> > > +	icount = percpu_counter_sum(&mp->m_icount);
> > > +	ifree = percpu_counter_sum(&mp->m_ifree);
> > > +	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +
> > > +	/* No negative values, please! */
> > > +	if (icount < 0 || ifree < 0 || fdblocks < 0)
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	/* See if icount is obviously wrong. */
> > > +	if (icount < fsc->icount_min || icount > fsc->icount_max)
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	/* See if fdblocks is obviously wrong. */
> > > +	if (fdblocks > mp->m_sb.sb_dblocks)
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	/*
> > > +	 * If ifree exceeds icount by more than the minimum variance then
> > > +	 * something's probably wrong with the counters.
> > > +	 */
> > > +	if (ifree > icount && ifree - icount > XCHK_FSCOUNT_MIN_VARIANCE)
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	/* Walk the incore AG headers to calculate the expected counters. */
> > > +	error = xchk_fscount_aggregate_agcounts(sc, fsc);
> > > +	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(mp), &error))
> > > +		return error;
> > > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
> > > +		return 0;
> > > +
> > > +	/* Compare the in-core counters with whatever we counted. */
> > > +	if (!xchk_fscount_within_range(sc, icount, &mp->m_icount, fsc->icount))
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	if (!xchk_fscount_within_range(sc, ifree, &mp->m_ifree, fsc->ifree))
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	if (!xchk_fscount_within_range(sc, fdblocks, &mp->m_fdblocks,
> > > +			fsc->fdblocks))
> > > +		xchk_set_corrupt(sc);
> > > +
> > > +	return 0;
> > > +}
> > > diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> > > index 16b536aa125e..23cf8e2f25db 100644
> > > --- a/fs/xfs/scrub/health.c
> > > +++ b/fs/xfs/scrub/health.c
> > > @@ -109,6 +109,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
> > >  	[XFS_SCRUB_TYPE_UQUOTA]		= { XHG_FS,  XFS_SICK_FS_UQUOTA },
> > >  	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
> > >  	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
> > > +	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
> > >  };
> > >  
> > >  /* Return the health status mask for this scrub type. */
> > > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > > index ce13c1c366db..f630389ee176 100644
> > > --- a/fs/xfs/scrub/scrub.c
> > > +++ b/fs/xfs/scrub/scrub.c
> > > @@ -352,6 +352,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> > >  		.scrub	= xchk_quota,
> > >  		.repair	= xrep_notsupported,
> > >  	},
> > > +	[XFS_SCRUB_TYPE_FSCOUNTERS] = {	/* fs summary counters */
> > > +		.type	= ST_FS,
> > > +		.setup	= xchk_setup_fscounters,
> > > +		.scrub	= xchk_fscounters,
> > > +		.repair	= xrep_notsupported,
> > > +	},
> > >  };
> > >  
> > >  /* This isn't a stable feature, warn once per day. */
> > > diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> > > index 01986ed364db..ad1ceb44a628 100644
> > > --- a/fs/xfs/scrub/scrub.h
> > > +++ b/fs/xfs/scrub/scrub.h
> > > @@ -127,6 +127,7 @@ xchk_quota(struct xfs_scrub *sc)
> > >  	return -ENOENT;
> > >  }
> > >  #endif
> > > +int xchk_fscounters(struct xfs_scrub *sc);
> > >  
> > >  /* cross-referencing helpers */
> > >  void xchk_xref_is_used_space(struct xfs_scrub *sc, xfs_agblock_t agbno,
> > > @@ -152,4 +153,12 @@ void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
> > >  # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
> > >  #endif
> > >  
> > > +struct xchk_fscounters {
> > > +	uint64_t		icount;
> > > +	uint64_t		ifree;
> > > +	uint64_t		fdblocks;
> > > +	unsigned long long	icount_min;
> > > +	unsigned long long	icount_max;
> > > +};
> > > +
> > >  #endif	/* __XFS_SCRUB_SCRUB_H__ */
> > > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > > index 3c83e8b3b39c..3362bae28b46 100644
> > > --- a/fs/xfs/scrub/trace.h
> > > +++ b/fs/xfs/scrub/trace.h
> > > @@ -50,6 +50,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTSUM);
> > >  TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
> > >  TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
> > >  TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
> > > +TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
> > >  
> > >  #define XFS_SCRUB_TYPE_STRINGS \
> > >  	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
> > > @@ -75,7 +76,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
> > >  	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }, \
> > >  	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
> > >  	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
> > > -	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }
> > > +	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
> > > +	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
> > >  
> > >  DECLARE_EVENT_CLASS(xchk_class,
> > >  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
> > > @@ -223,6 +225,7 @@ DEFINE_EVENT(xchk_block_error_class, name, \
> > >  		 void *ret_ip), \
> > >  	TP_ARGS(sc, daddr, ret_ip))
> > >  
> > > +DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_fs_error);
> > >  DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_error);
> > >  DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_preen);
> > >  
> > > @@ -590,6 +593,64 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
> > >  		  __entry->cluster_ino)
> > >  )
> > >  
> > > +TRACE_EVENT(xchk_fscounters_calc,
> > > +	TP_PROTO(struct xfs_mount *mp, uint64_t icount, uint64_t ifree,
> > > +		 uint64_t fdblocks, uint64_t delalloc),
> > > +	TP_ARGS(mp, icount, ifree, fdblocks, delalloc),
> > > +	TP_STRUCT__entry(
> > > +		__field(dev_t, dev)
> > > +		__field(int64_t, icount_sb)
> > > +		__field(uint64_t, icount_calculated)
> > > +		__field(int64_t, ifree_sb)
> > > +		__field(uint64_t, ifree_calculated)
> > > +		__field(int64_t, fdblocks_sb)
> > > +		__field(uint64_t, fdblocks_calculated)
> > > +		__field(uint64_t, delalloc)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->dev = mp->m_super->s_dev;
> > > +		__entry->icount_sb = mp->m_sb.sb_icount;
> > > +		__entry->icount_calculated = icount;
> > > +		__entry->ifree_sb = mp->m_sb.sb_ifree;
> > > +		__entry->ifree_calculated = ifree;
> > > +		__entry->fdblocks_sb = mp->m_sb.sb_fdblocks;
> > > +		__entry->fdblocks_calculated = fdblocks;
> > > +		__entry->delalloc = delalloc;
> > > +	),
> > > +	TP_printk("dev %d:%d icount %lld:%llu ifree %lld::%llu fdblocks %lld::%llu delalloc %llu",
> > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > +		  __entry->icount_sb,
> > > +		  __entry->icount_calculated,
> > > +		  __entry->ifree_sb,
> > > +		  __entry->ifree_calculated,
> > > +		  __entry->fdblocks_sb,
> > > +		  __entry->fdblocks_calculated,
> > > +		  __entry->delalloc)
> > > +)
> > > +
> > > +TRACE_EVENT(xchk_fscounters_within_range,
> > > +	TP_PROTO(struct xfs_mount *mp, uint64_t expected, int64_t curr_value,
> > > +		 int64_t old_value),
> > > +	TP_ARGS(mp, expected, curr_value, old_value),
> > > +	TP_STRUCT__entry(
> > > +		__field(dev_t, dev)
> > > +		__field(uint64_t, expected)
> > > +		__field(int64_t, curr_value)
> > > +		__field(int64_t, old_value)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->dev = mp->m_super->s_dev;
> > > +		__entry->expected = expected;
> > > +		__entry->curr_value = curr_value;
> > > +		__entry->old_value = old_value;
> > > +	),
> > > +	TP_printk("dev %d:%d expected %llu curr_value %lld old_value %lld",
> > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > +		  __entry->expected,
> > > +		  __entry->curr_value,
> > > +		  __entry->old_value)
> > > +)
> > > +
> > >  /* repair tracepoints */
> > >  #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
> > >  
