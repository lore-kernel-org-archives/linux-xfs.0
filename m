Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04BwkP8238154 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 05:58:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63641D057AE
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 04:00:52 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	tTAmTNrd027qfGyU for <xfs@oss.sgi.com>;
	Tue, 04 Jan 2011 04:00:52 -0800 (PST)
Date: Tue, 4 Jan 2011 23:00:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Message-ID: <20110104120048.GL15179@dastard>
References: <1294121588-17233-1-git-send-email-david@fromorbit.com>
	<20110104100240.GB26885@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110104100240.GB26885@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 04, 2011 at 05:02:40AM -0500, Christoph Hellwig wrote:
> > This patch uses 32-way threading which results in no noticable
> > slowdown on single SATA drives with NCQ, but results in ~10x
> > reduction in runtime on a 12 disk RAID-0 array.
> 
> Shouldn't we have at least an option to allow tuning this value,
> similar to the ag_stride?  In fact I wonder why phase 3/4 should
> use different values for it than phase2.

Phase 3/4/5 use agressive prefetch to try to maximise throughput,
while phase 2 has no prefetch and uses synchronous reads.
Effectively the use of lots of parallelism simply keeps multiple IOs
in flight rather than reading them one at a time, hence reducing the
effective IO latency.

> 
> > @@ -75,8 +80,10 @@ scan_sbtree(
> >  				xfs_agblock_t		bno,
> >  				xfs_agnumber_t		agno,
> >  				int			suspect,
> > -				int			isroot),
> > -	int		isroot)
> > +				int			isroot,
> > +				struct aghdr_cnts	*agcnts),
> > +	int		isroot,
> > +	struct aghdr_cnts *agcnts)
> 
> Please make this a
> 
> 	void *priv
> 
> to keep scan_sbtree generic.

OK.

> >   * Scan an AG for obvious corruption.
> >   *
> >   * Note: This code is not reentrant due to the use of global variables.
> 
> That's not true any more I think.

Good point.

> > +#define SCAN_THREADS 32
> > +
> > +void
> > +scan_ags(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct aghdr_cnts agcnts[mp->m_sb.sb_agcount];
> > +	pthread_t	thr[SCAN_THREADS];
> > +	__uint64_t	fdblocks = 0;
> > +	__uint64_t	icount = 0;
> > +	__uint64_t	ifreecount = 0;
> > +	int		i, j, err;
> > +
> > +	/*
> > +	 * scan a few AGs in parallel. The scan is IO latency bound,
> > +	 * so running a few at a time will speed it up significantly.
> > +	 */
> > +	for (i = 0; i < mp->m_sb.sb_agcount; i += SCAN_THREADS) {
> 
> I think this should use the workqueues from repair/threads.c.  Just
> create a workqueue with 32 threads, and then enqueue all the AGs.

Ok. I just used an API I'm familiar with and didn't have to think
about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
