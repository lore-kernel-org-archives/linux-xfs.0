Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGBPv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:51:59 -0400
Date: Tue, 2 Jul 2019 08:51:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/15] xfs: multithreaded iwalk implementation
Message-ID: <20190702155138.GR1404256@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
 <156158192497.495087.5608242533988384883.stgit@magnolia>
 <20190702143320.GE2866@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702143320.GE2866@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 02, 2019 at 10:33:20AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:45:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a parallel iwalk implementation and switch quotacheck to use it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile      |    1 
> >  fs/xfs/xfs_globals.c |    3 +
> >  fs/xfs/xfs_iwalk.c   |   82 +++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_iwalk.h   |    2 +
> >  fs/xfs/xfs_pwork.c   |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_pwork.h   |   58 +++++++++++++++++++++++
> >  fs/xfs/xfs_qm.c      |    2 -
> >  fs/xfs/xfs_sysctl.h  |    6 ++
> >  fs/xfs/xfs_sysfs.c   |   40 ++++++++++++++++
> >  fs/xfs/xfs_trace.h   |   18 +++++++
> >  10 files changed, 337 insertions(+), 1 deletion(-)
> >  create mode 100644 fs/xfs/xfs_pwork.c
> >  create mode 100644 fs/xfs/xfs_pwork.h
> > 
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 74d30ef0dbce..48940a27d4aa 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -84,6 +84,7 @@ xfs-y				+= xfs_aops.o \
> >  				   xfs_message.o \
> >  				   xfs_mount.o \
> >  				   xfs_mru_cache.o \
> > +				   xfs_pwork.o \
> >  				   xfs_reflink.o \
> >  				   xfs_stats.o \
> >  				   xfs_super.o \
> > diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> > index d0d377384120..a44b564871b5 100644
> > --- a/fs/xfs/xfs_globals.c
> > +++ b/fs/xfs/xfs_globals.c
> > @@ -31,6 +31,9 @@ xfs_param_t xfs_params = {
> >  	.fstrm_timer	= {	1,		30*100,		3600*100},
> >  	.eofb_timer	= {	1,		300,		3600*24},
> >  	.cowb_timer	= {	1,		1800,		3600*24},
> > +#ifdef DEBUG
> > +	.pwork_threads	= {	-1,		-1,		NR_CPUS	},
> 
> So I noticed that /sys/fs/xfs/debug/pwork_threads was still 0 by default
> with this patch, then realized that we've only initialized it in
> xfs_params and not xfs_globals. The sysfs handlers added by this patch
> use the latter whereas the former looks related to /proc. It looks like
> this should be fixed up to init the global field to -1 and probably drop
> the xfs_params bits since we don't expose the value via /proc.

Oh, you're right.  I'll drop the xfs_params bits.

> 
> > +#endif
> >  };
> >  
> >  struct xfs_globals xfs_globals = {
> ...
> > diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
> > new file mode 100644
> > index 000000000000..779596ed9432
> > --- /dev/null
> > +++ b/fs/xfs/xfs_pwork.c
> > @@ -0,0 +1,126 @@
> ...
> > +/*
> > + * Return the amount of parallelism that the data device can handle, or 0 for
> > + * no limit.
> > + */
> > +unsigned int
> > +xfs_pwork_guess_datadev_parallelism(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_buftarg	*btp = mp->m_ddev_targp;
> > +	int			iomin;
> > +	int			ioopt;
> > +
> > +	if (blk_queue_nonrot(btp->bt_bdev->bd_queue))
> > +		return num_online_cpus();
> > +
> > +	if (mp->m_sb.sb_width && mp->m_sb.sb_unit)
> > +		return mp->m_sb.sb_width / mp->m_sb.sb_unit;
> > +
> > +	iomin = bdev_io_min(btp->bt_bdev);
> > +	ioopt = bdev_io_opt(btp->bt_bdev);
> > +	if (iomin && ioopt)
> > +		return ioopt / iomin;
> > +
> > +	return 1;
> > +}
> 
> I may have lost track of where we left off with this but IIRC we still
> needed some numbers with regard to multi-device storage where
> sb_width/sb_unit doesn't necessarily describe parallelism (i.e.
> RAID5/6). I'm not sure what your goal is for this patch vs. the rest of
> the series, but I'd be fine with merging this with just the
> non-rotational bit for now if we add some kind of conservative maximum
> (4? 8?) to the heuristic. It seems kind of risky to me to parallelize
> 100s of AGs just because we might have that many CPUs/AGs on a
> particular storage setup (we may also generate warning messages if a
> system has a CPU count that exceeds the workqueue limit).

Hm, how about the most conservative threading that I can think of?

unsigned int
xfs_pwork_guess_datadev_parallelism(
	struct xfs_mount	*mp)
{
	return blk_queue_nonrot(...) ? 2 : 1;
}

Since that did seem to yield speedups for everything except the dumb USB
mass storage case.  Then I can work on building a case for more threads
(and figuring out the maximums) for 5.4...

--D

> 
> ...
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index cabda13f3c64..a146a2e61be2 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -206,11 +206,51 @@ always_cow_show(
> >  }
> >  XFS_SYSFS_ATTR_RW(always_cow);
> >  
> > +#ifdef DEBUG
> > +/*
> > + * Override how many threads the parallel work queue is allowed to create.
> > + * This has to be a debug-only global (instead of an errortag) because one of
> > + * the main users of parallel workqueues is mount time quotacheck.
> > + */
> > +STATIC ssize_t
> > +pwork_threads_store(
> > +	struct kobject	*kobject,
> > +	const char	*buf,
> > +	size_t		count)
> > +{
> > +	int		ret;
> > +	int		val;
> > +
> > +	ret = kstrtoint(buf, 0, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (val < 0 || val > num_possible_cpus())
> > +		return -EINVAL;
> > +
> 
> We need to allow assignment of -1 now too.

<nod>

--D

> Brian
> 
> > +	xfs_globals.pwork_threads = val;
> > +
> > +	return count;
> > +}
> > +
> > +STATIC ssize_t
> > +pwork_threads_show(
> > +	struct kobject	*kobject,
> > +	char		*buf)
> > +{
> > +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
> > +}
> > +XFS_SYSFS_ATTR_RW(pwork_threads);
> > +#endif /* DEBUG */
> > +
> >  static struct attribute *xfs_dbg_attrs[] = {
> >  	ATTR_LIST(bug_on_assert),
> >  	ATTR_LIST(log_recovery_delay),
> >  	ATTR_LIST(mount_delay),
> >  	ATTR_LIST(always_cow),
> > +#ifdef DEBUG
> > +	ATTR_LIST(pwork_threads),
> > +#endif
> >  	NULL,
> >  };
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index f9bb1d50bc0e..658cbade1998 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3556,6 +3556,24 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
> >  		  __entry->startino, __entry->freemask)
> >  )
> >  
> > +TRACE_EVENT(xfs_pwork_init,
> > +	TP_PROTO(struct xfs_mount *mp, unsigned int nr_threads, pid_t pid),
> > +	TP_ARGS(mp, nr_threads, pid),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(unsigned int, nr_threads)
> > +		__field(pid_t, pid)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->nr_threads = nr_threads;
> > +		__entry->pid = pid;
> > +	),
> > +	TP_printk("dev %d:%d nr_threads %u pid %u",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->nr_threads, __entry->pid)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
