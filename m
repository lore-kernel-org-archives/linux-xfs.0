Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J35tXR142717 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 22:05:55 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 490797CD1E
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:05:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uZU8vnXqri9E0jra for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 20:05:53 -0700 (PDT)
Date: Tue, 19 Jul 2011 13:05:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: flush the CIL via a workqueue
Message-ID: <20110719030551.GK30254@dastard>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-4-git-send-email-david@fromorbit.com>
	<20110719020317.GC4259@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110719020317.GC4259@infradead.org>
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

On Mon, Jul 18, 2011 at 10:03:17PM -0400, Christoph Hellwig wrote:
> Generally looks okay, but doing a context switch in every log force
> might bite us.  Less the general context switch overhead, but more
> the nasty interactions with cfq, which are causing huge problems
> for ext3/4,

Quite frankly, I don't recommend CFQ unless you need block level
throttling or use IO prioritisation seriously. CFQ is way too smart
for it's own good trying to do everything for everyone, and as such
suffers from different regressions every release.  It has weird
workload specific heuristics in it to try to address issues that
don't solve the general class of problem, and so is always being
patched to fix the next occurrence of the same problem.  e.g. the IO
stalls caused by dependent IOs being issued by different threads
that ext3/4 fsync hits all the time.

> with no good way to fix them for workqueues.

Right, which I pointed out to them last time round of ext4 specific
hacks that tried to tell the journal thread that it's IO had
external depenencies.

And let's face it - every time we move IO into a workqueue, we
introduce new cases of IO dependencies between threads. e.g.
anything waiting on a log force in progress is already dependent on
dispatch from a different thread, so the xfssyncd xfsaild and busy
extent log forces all will suffer to some extent from CFQ's existing
deficiencies in this regard. Moving the log IO into a workqueue
doesn't change this at all....

I'm of the opinion that anyone with a RAID controller with a BBWC
doesn't need the smarts in CFQ because the BBWC provides a much
larger and smarter IO re-order window than the Linux IO schedulers
and hence do a better job of IO scheduling than Linux can ever do.
We shouldn't penalise the target market for XFS for having fast
storage by catering to difficiencies of IO schedulers that are
mostly redundant for the hardware XFS typically runs on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
