Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 10:10:40 -0800 (PST)
Received: from waste.org (waste.org [66.93.16.53])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAMIAWWm019774
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 10:10:34 -0800
Date: Thu, 22 Nov 2007 12:10:29 -0600
From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122181029.GR19691@waste.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com> <20071122072549.GQ19691@waste.org> <20071122103159.GW114266761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122103159.GW114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 09:31:59PM +1100, David Chinner wrote:
[...]
> > In other words, I/O priority is per-spindle and not per-filesystem and
> > thus this change has consequences that leak outside the filesystem in
> > question. That's bad.
> 
> This has nothing to do with this patch - it's a problem with sharing
> a single resource in a RT system between two non-deterministic
> constructs. e.g. I can put two ext3 filesystems on the one spindle,
> run two completely independent RT workloads on the different
> filesystems and have one workload DOS the other due to differences
> in priority at the spindle.

Sure. And it's up to the RT system designer not to do something stupid
like that. The problem is that your patch potentially promotes a
non-RT I/O activity to an RT one without regard to the rest of the
system.

Stop for a moment and look at all the kernel threads on the system. If
your argument was sensible, we'd have raised various of these threads
to (CPU) RT ages ago. But if we do, we actually royally foul up things
that have tried to carefully isolate themselves from SCHED_NORMAL
tasks. If a kernel thread preempted our watchdog or our data
collection process because it was trying to service a lower priority
task, that would be fatally broken.

As kernel engineers, we -do not know- the absolute importance of a
given subsystem in the wider scheme of things. Thus we have no
business promoting anything outside the "normal" range into RT unless
explicitly asked to (eg chrt) or if we're actually doing real deadlock
avoidance.

> That's not a bug in ext3 or the I/O priority mechanism - that's bad
> system design. Put the filesystems on different spindles and the
> problem goes away.

And so do all your PVR sales. Two spindles is economically impossible
on a set-top PVR.

And I rather expect this all also applies to having XFS volumes on top
of LVM + RAID5 along with other filesystems but I haven't looked
closely.

> > I'd further add that the kernel internals probably shouldn't wander
> > into RT priority levels unless it's actually doing priority
> > inheritance, otherwise it's quite likely to upset the careful
> > considerations of the RT system designer's priority schemes.
> 
> Even if issuing RT I/O will guarantee problems in a RT system?

Absolutely (unless we're actually going to do priority inheritance).
The only person who can know the real RT requirements of a system is
the system's designer. If he wants to boost the priority of XFS I/O
threads into RT, he should be allowed to, but it shouldn't happen
automatically.

Consider someone concurrently running a database on a filesystem and
an RT data collection task direct to a separate partition. RT I/O may
currently allow them to successfully

> We've put this cool RT I/O prioritisation mechanism in the I/O layer
> without any consideration of what it means for the filesystems that
> the I/O must pass through first.  The design defines I/O
> prioritsation from a *process* POV and it ignores the fact that the
> filesystem might not work effectively under such prioritisation
> mechanism.
> 
> An example, perhaps.
> 
> If you're smart about the way your application does its multi-stream
> RT write I/O you preallocate the space and use direct I/O.  But even
> though you've preallocated the space, in XFS you still need
> transactions to work because you have to mark the extent you just
> wrote to as written.
>
> This conversion happens during I/O completion (i.e. in a workqueue)
> so it doesn't have the *process* priority to force out log I/O at the same
> priority as the RT thread. Hence once all the log buffers are queued
> for I/O, the transaction system blocks all the I/O completion workqueues
> and all the RT write I/O stops completing and your application, which
> is doing synchronous direct I/O into preallocated regions hangs.....

Perfectly understood. And that's fine. A system designer is allowed to
shoot himself in the foot.
 
> Hence the only way to give the log I/O enough priority to be issued
> is to give the I/O a higher priority than anything that is running
> at the time.
>
> This is not a problem the I/O scheduler can solve - it is a result
> of the mechanism used to transfer priority from process context to
> I/o context. The needs of the filesystem is the key thing that is
> missing here - you can't do RT I/O if the filesystem backs up....

I don't think there's any fundamental reason the I/O subsystem or
filesystems can't be taught to handle priority inversion, which is
much more acceptable and general fix.

> > Now consider that you're
> > recording and playing back multiple HD streams on low-margin set-top
> > hardware and you'll see that making this work -at all- means lots of
> > I/O tuning.
> 
> Yes, it does. But along the same lines, sustaining multiple
> uncompressed 2k and 4k streams (i.e. multiple GB/s of throughput)
> takes a lot of I/O tuning. We had to design a whole new allocator to
> tune the I/O patterns to make it work....

..which makes it fairly attractive to PVR folks until you go mucking
with RT behind their backs.

If I've got XFS on filesystems A and B on the same spindle (or volume
group?) and my real RT I/O takes place only on B, then I want log
flushing to happen in RT on B. But -never on A-. If I can do this with
a tunable, I'm perfectly happy.

-- 
Mathematics is the supreme nostalgia of our time.
