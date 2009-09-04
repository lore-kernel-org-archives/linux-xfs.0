Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n842vTbQ158463 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 21:57:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 775C915CFEFC
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 19:58:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	hPG62UB754eENMMd for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2009 19:58:05 -0700 (PDT)
Date: Fri, 4 Sep 2009 12:57:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/14] repair memory usage reductions
Message-ID: <20090904025753.GB7146@discord.disaster>
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090903204940.GB24510@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090903204940.GB24510@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Sep 03, 2009 at 03:49:40PM -0500, Geoffrey Wehrman wrote:
> On Wed, Sep 02, 2009 at 01:55:31PM -0400, Christoph Hellwig wrote:
> | This is a respin of the patches Barry Naujok wrote at SGI for reducing
> | the memory usage in repair.  I've split it up, fixed a few small bugs
> | and added two preparatory cleanups - but all the real work is Barry's.
> | There has been lots of heavy testing on large filesystems by Barry
> | on the original patches, and quite a lot of testing on slightly smaller
> | filesystems by me.  These were all ad-hoc tests as XFSQA coverage is
> | rather low on repair.  My plan is to add various additional testcase
> | for XFSQA both for intentional corruptions as well as reproducing past
> | reported bugs before we'll release these patches in xfsprogs.  But I think
> | it would be good if we could get them into the development git tree to
> | get wider coverage already.
> 
> How do these changes affect xfs_repair I/O performance?  Barry changes
> were previously withheld within SGI due to a regression in performance.

Christoph asked me to repeat what I said on #xfs w.r.t the regression.

The repair slowdowns were a result of increased CPU usage of the
btree structures used to track free space compared to manipulating
massive bitmaps. Hence if you have a disk subsystem fast enough that
prefetching could keep the CPUs 100% busy processing all the
incoming metadata the memory-optimised repair was about 30% slower
than the existing repair code.

However, given that getting to being CPU bound with the current
repair code requires having a *lot* of memory, so the more common
case is that you have to add gigabytes of swap space so that repair
can run. In these situations, the current repair will run much, much
slower than the memory optimised repair because the new version does
not have to swap.

Indeed, I recall one of the driving factors for this work was the SGI
customer that needed to connect their 300TB (or was it 600TB?) XFS
filesystem to an Altix with 2TB of RAM to be able to repair it
because the server head connected to the filesystem did not have 2TB
of storage available to assign as swap space. That is, XFS
scalability is limited by the amount of memory needed by repair....

Another mitigating factor is that the worst regressions were on
ia64, for which bitmap manipulation is far more friendly than branchy,
cache-miss causing btree traversals. Hence the regression will be
less (maybe even not present) on current x86-64 CPUs which handle
branches and cache misses far, far better than Altix/ia64....

With that in mind, I think the memory usage optimisation is far more
important to the majority of XFS users than the CPU usage regression
it causes as the majority of users don't have RAM-rich environments
to run repair in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
