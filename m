Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7C45a2c022068 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 23:05:36 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19FFFD5466
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 21:05:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yCHJlq3RpWSXTVxI for <xfs@oss.sgi.com>;
	Thu, 11 Aug 2011 21:05:34 -0700 (PDT)
Date: Fri, 12 Aug 2011 14:05:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110812040530.GB26978@dastard>
References: <20110806122556.GB20341@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de> <201108100859.27576@zmi.at>
	<20110811220418.GB12808@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110811220418.GB12808@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Fri, Aug 12, 2011 at 12:04:19AM +0200, Marc Lehmann wrote:
> On Wed, Aug 10, 2011 at 08:59:26AM +0200, Michael Monnerie <michael.monnerie@is.it-management.at> wrote:
> > > current xfs - in my case, it lead to xfs causing ENOSPC even when the
> > > disk was 40% empty (~188gb).
> > 
> > Was this the "NFS optimization" stuff? I don't like that either.
> 
> The NFS server apparently opens and closes files very often (probably on
> every read/write or so, I don't know the details), so XFS was
> benchmark-improved by keeping the preallocation as long as the inode is in
> memory.

It only does that if the pattern of writes are such that keeping the
preallocation around for longer periods of time will reduce
potential fragmentation.  Indeed, it's not a NFS specific
optimisation, but it is one that directly benefits NFS server IO
patterns.

e.g. it can also help reduce fragmentation on slow append-only
workloads if the necessary conditions are triggered by the log
writers (which is the other problem you are complaining noisily
about). Given that inodes for log files will almost always remain in
memory as they are regularly referenced, it seems like the right
solution to that problem, too...

FWIW, you make it sound like "benchmark-improved" is a bad thing.
However, I don't hear you complaining about the delayed logging
optimisations at all. I'll let you in on a dirty little secret: I
tested delayed logging on nothing but benchmarks - it is -entirely-
a "benchmark-improved" class optimisation.

But despite how delayed logging was developed and optimised, it
has significant real-world impact on performance under many
different workloads. That's because the  benchmarks I use accurately
model the workloads that cause the problem that needs to be solved.

Similarly, the "NFS optimisation" in a significant and measurable
reduction in fragmentation on NFS-exported XFS filesystems across a
wide range of workloads. It's a major win in the real world - I
just wish I had of thought of it 4 or 5 years ago back when I was at
SGI when we first started seeing serious NFS related fragmentation
problems at customer sites.

Yes, there have been regressions caused by both changes (though
delayed logging had far more serious ones) - that's a
fact of life in software development. However, the existence of
regressions does not take anything away from the significant
real-world improvements that are the result of the changes.

> > > I presume strace would do, but thats where the "lot of work" comes
> > > in. If there is a ready-to-use tool, that would of course make it
> > > easy.
> > 
> > It's a pity that such a generic tool doesn't existing. I can't believe 
> > that. Doesn't anybody have such a tool at hand?
> 
> Yeah, I'm listening :) I hope it doesn't boil down to an instrumented
> kernel :(

GFGI.

http://code.google.com/p/ioapps/wiki/ioreplay

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
