Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O1UNbv037475 for <xfs@oss.sgi.com>; Mon, 23 May 2011 20:30:23 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 558034770CF
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 18:30:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZAvR4mnMp4NA9kBb for <xfs@oss.sgi.com>;
	Mon, 23 May 2011 18:30:21 -0700 (PDT)
Date: Tue, 24 May 2011 11:30:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110524013016.GD32466@dastard>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
	<20110522020024.GZ32466@dastard>
	<20110523133547.GA25777@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110523133547.GA25777@schmorp.de>
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
Cc: xfs@oss.sgi.com

On Mon, May 23, 2011 at 03:35:48PM +0200, Marc Lehmann wrote:
> On Sun, May 22, 2011 at 12:00:24PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > The problem is that this is not anything like the normal case.
> > 
> > For you, maybe.
> 
> For the majority of boxes that use xfs - most desktop boxes are not heavy
> NFS servers.

Desktops are not a use case we optimise XFS for. We make sure XFS
works adequately on the desktop, but other than that we focus of
server workloads as optimisation targets.

> > > It's easy to get some gains in special situations at the expense of normal
> > > ones - keep in mind that this optimisation makes little sense for non-NFS
> > > cases, which is the majority of use cases.
> > 
> > XFS is used extensively in NAS products, from small $100 ARM/MIPS
> > embedded NAS systems all the way up to high end commercial NAS
> > products. It is one of the main use cases we optimise XFS for.
> 
> Thats really sad - maybe people like me who use XFS on their servers
> should rethink that decision that, if XFS mainly optimises for commercial
> nas boxes only.

Nice twist - you're trying to imply we do something very different
to what I said.

So to set the record straight, we optimise for several different
overlapping primary use cases. We make optimisation decisions that
benefit systems and workloads that fall into the following
categories:

	- large filesystems (e.g > 100TB)
	- large storage subsystems (hundreds to thousands of
	  spindles)
	- large amounts of RAM (tens of GBs to TBs of RAM)
	- high concurrency from large numbers of CPUs (thousands of
	  CPU cores)
	- high throughput, both IOPS and bandwidth
	- low fragmentation of large files
	- robust error detection and handling

IOWs, we optimise for high performance, high end servers and
workloads.  And that means that Just because we make changes that
help high performance, high end NFS servers acheive these goals
_does not mean_ we only optimise for NFS servers.

I'm not going to continue this part of this thread - it's just a
waste of my time. If you want the regression fixed, then stop
trying to tell us what the bug is and instead try to help diagnose
the cause of the problem.

> > we should fix it. What I really want is your test cases that
> > reproduce the problem so I can analyse it for myself. Once I
> > understand what is going on, then we can talk about what the real
> > problem is and how to fix it.
> 
> Being a good citizen wanting to improve XFS I of course dleivered that in
> my first e-mail. Again, I used allocsize=64m and then made a buildroot
> build, which stopped after a few minutes because 180GB of disk space were
> gone.
> 
> The disk space was all used up by the buildroot, which is normally a few
> gigabytes (after a successful build).
> 
> I found that the uclibc object directory uses 50GB of space, about 8 hours
> after the compile - the object files were typically a few kb in size, but
> du showed 64mb of usage, even though nobody was using that file more than
> once, or ever after the make stopped.

A vaguely specified 8 hour long test involving building some large number of packages
is not a useful test case.  There are too many variables, too much
setup time, too much data to analyse and taking 8 hours to get a
result is far too long.  I did try a couple of kernel builds and
didn't see the problem you reported. Hence I came to the conclusion
that it was something specific to your build environment and asked
for more a more exact test case.

Indeed, someone else presented a 100% reproducable test case in a 3
line script using cp and rm that took 10s to run. It then took me 15
minutes to analyse, then write, test and post a patch that fixes the
problem their test case demonstrated. Does the patch in the
following email fix your buildroot space usage problem?

http://oss.sgi.com/pipermail/xfs/2011-May/050651.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
