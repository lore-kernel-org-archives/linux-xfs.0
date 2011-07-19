Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J4Spj5147853 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 23:28:52 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D261615F6349
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 21:28:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bfT2oGyW24hRnHl6 for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 21:28:47 -0700 (PDT)
Date: Tue, 19 Jul 2011 14:28:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: flush the CIL via a workqueue
Message-ID: <20110719042845.GF31294@dastard>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-4-git-send-email-david@fromorbit.com>
	<20110719020317.GC4259@infradead.org>
	<20110719030551.GK30254@dastard>
	<20110719031147.GA22114@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110719031147.GA22114@infradead.org>
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

On Mon, Jul 18, 2011 at 11:11:47PM -0400, Christoph Hellwig wrote:
> On Tue, Jul 19, 2011 at 01:05:51PM +1000, Dave Chinner wrote:
> > On Mon, Jul 18, 2011 at 10:03:17PM -0400, Christoph Hellwig
> > wrote:
> > > Generally looks okay, but doing a context switch in every log
> > > force might bite us.  Less the general context switch
> > > overhead, but more the nasty interactions with cfq, which are
> > > causing huge problems for ext3/4,
> > 
> > Quite frankly, I don't recommend CFQ unless you need block level
> > throttling or use IO prioritisation seriously. CFQ is way too
> > smart for it's own good trying to do everything for everyone,
> > and as such suffers from different regressions every release.
> > It has weird workload specific heuristics in it to try to
> > address issues that don't solve the general class of problem,
> > and so is always being patched to fix the next occurrence of the
> > same problem.  e.g. the IO stalls caused by dependent IOs being
> > issued by different threads that ext3/4 fsync hits all the time.
> 
> I don't like CFQ very much either.  But it's the default for both
> mainline Linux and all major distros, so screwing it means a major
> support burden

We never tuned for AS or really cared how it performed when it was
the kernel and major distro default, either. The answer was always
"don't use AS if you care about performance". That's the same advice
major distro's give to their users of XFS w.r.t CFQ, anyway...

> as well as losing all kinds of benchmarks.

Do we really care about benchmarketing? I don't really...

> > I'm of the opinion that anyone with a RAID controller with a BBWC
> > doesn't need the smarts in CFQ because the BBWC provides a much
> > larger and smarter IO re-order window than the Linux IO schedulers
> > and hence do a better job of IO scheduling than Linux can ever do.
> > We shouldn't penalise the target market for XFS for having fast
> > storage by catering to difficiencies of IO schedulers that are
> > mostly redundant for the hardware XFS typically runs on....
> 
> What penatlity do we get for doing the cil force in line from log
> force and only doing it in the background when it needs to be
> written because of filling up the buffers?

I can make the log force code do the push in line, it just
complicates things a little with the need for wrapper functions to
handle the different calling conventions. The log force has to wait
on the workqueue anyway (and will still have to do so even if it
pushes directly itself), so doing the push work directly won't
change the performance there at all.

It's really the background push that I want out of line, so I'll
rework it such that only the background push uses the workqueue.
That should alleviate most of the concerns with fsync+CFQ.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
