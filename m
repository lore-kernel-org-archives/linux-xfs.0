Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 02:32:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAMAWGuT015153
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 02:32:21 -0800
Date: Thu, 22 Nov 2007 21:31:59 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122103159.GW114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com> <20071122072549.GQ19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122072549.GQ19691@waste.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matt Mackall <mpm@selenic.com>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 01:25:49AM -0600, Matt Mackall wrote:
> On Thu, Nov 22, 2007 at 02:41:06PM +1100, David Chinner wrote:
> > On Wed, Nov 21, 2007 at 08:57:27PM -0600, Matt Mackall wrote:
> > > On Thu, Nov 22, 2007 at 12:12:14PM +1100, David Chinner wrote:
> > > > In all the cases that I know of where ppl are using what could
> > > > be considered real-time I/O (e.g. media environments where they
> > > > do real-time ingest and playout from the same filesystem) the
> > > > real-time ingest processes create the files and do pre-allocation
> > > > before doing their I/O. This I/O can get held up behind another
> > > > process that is not real time that has issued log I/O. 
> > > > 
> > > > Given there is no I/O priority inheritence and having log I/O stall
> > > > will stall the entire filesystem, we cannot allow log I/O to
> > > > stall in real-time environments. Hence it must have the highest
> > > > possible priority to prevent this.
> > > 
> > > I've seen PVRs that would be upset by this. They put media on one
> > > filesystem and database/apps/swap/etc. on another, but have everything
> > > on a single spindle. Stalling a media filesystem read for a write
> > > anywhere else = fail.
> > 
> > Sounds like the PVR is badly designed to me. If a write can cause a
> > read to miss a playback deadline, then you haven't built enough
> > buffering into your playback application.
> 
> Normally it's not a problem. But your proposed change can push a
> working system into a non-working system by making non-critical I/O on
> an unrelated filesystem have higher priority than the thing that -actually
> has real-time constraints-.
>
> In other words, I/O priority is per-spindle and not per-filesystem and
> thus this change has consequences that leak outside the filesystem in
> question. That's bad.

This has nothing to do with this patch - it's a problem with sharing
a single resource in a RT system between two non-deterministic
constructs. e.g. I can put two ext3 filesystems on the one spindle,
run two completely independent RT workloads on the different
filesystems and have one workload DOS the other due to differences
in priority at the spindle.

That's not a bug in ext3 or the I/O priority mechanism - that's bad
system design. Put the filesystems on different spindles and the
problem goes away.

> I'd further add that the kernel internals probably shouldn't wander
> into RT priority levels unless it's actually doing priority
> inheritance, otherwise it's quite likely to upset the careful
> considerations of the RT system designer's priority schemes.

Even if issuing RT I/O will guarantee problems in a RT system?
We've put this cool RT I/O prioritisation mechanism in the I/O layer
without any consideration of what it means for the filesystems that
the I/O must pass through first.  The design defines I/O
prioritsation from a *process* POV and it ignores the fact that the
filesystem might not work effectively under such prioritisation
mechanism.

An example, perhaps.

If you're smart about the way your application does its multi-stream
RT write I/O you preallocate the space and use direct I/O.  But even
though you've preallocated the space, in XFS you still need
transactions to work because you have to mark the extent you just
wrote to as written.

This conversion happens during I/O completion (i.e. in a workqueue)
so it doesn't have the *process* priority to force out log I/O at the same
priority as the RT thread. Hence once all the log buffers are queued
for I/O, the transaction system blocks all the I/O completion workqueues
and all the RT write I/O stops completing and your application, which
is doing synchronous direct I/O into preallocated regions hangs.....

Hence the only way to give the log I/O enough priority to be issued
is to give the I/O a higher priority than anything that is running
at the time.

This is not a problem the I/O scheduler can solve - it is a result
of the mechanism used to transfer priority from process context to
I/o context. The needs of the filesystem is the key thing that is
missing here - you can't do RT I/O if the filesystem backs up....

> Now consider that you're
> recording and playing back multiple HD streams on low-margin set-top
> hardware and you'll see that making this work -at all- means lots of
> I/O tuning.

Yes, it does. But along the same lines, sustaining multiple
uncompressed 2k and 4k streams (i.e. multiple GB/s of throughput)
takes a lot of I/O tuning. We had to design a whole new allocator to
tune the I/O patterns to make it work....

Basically, we're not optimising XFS for small, embedded systems. We
are at the other end of the scale - XFS is optimised for very large,
very expensive storage subsystems and hence we often do things that
don't make sense for embedded systems...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
