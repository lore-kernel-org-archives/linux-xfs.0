Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p77AQXSs226368 for <xfs@oss.sgi.com>; Sun, 7 Aug 2011 05:26:34 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49CE11E70B1C
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 03:26:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JilMLNNizA4mf4am for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 03:26:29 -0700 (PDT)
Date: Sun, 7 Aug 2011 20:26:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110807102625.GJ3162@dastard>
References: <20110806122556.GB20341@schmorp.de> <20110806142005.GG3162@dastard>
	<20110807014237.GA18909@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110807014237.GA18909@schmorp.de>
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

On Sun, Aug 07, 2011 at 03:42:38AM +0200, Marc Lehmann wrote:
> On Sun, Aug 07, 2011 at 12:20:05AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > The backtraces look all very similar:
> > > 
> > >    http://ue.tst.eu/85b9c9f66e36dda81be46892661c5bd0.txt
> > 
> > Tainted kernel. Please reproduce without the NVidia binary drivers.
> 
> This is just because it is form my desktop system. None of my other
> machines have a tainted kernel, but getting backtraces from there is much
> harder.
> 
> > > all the backtraces crash with a null pointer dereference in xfs_iget, or
> > > in xfs_trans_log_inode, and always for process xfs_fsr.
> > 
> > and when you do, please record an event trace of the
> > xfs_swap_extent* trace points while xfs_fsr is running and triggers
> > a crash. That will tell me if xfs_fsr is corrupting inodes,
> 
> Ah - how do I do that?

Use trace-cmd or do it manually via:

# echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_swap_extent_before/enable
# echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_swap_extent_before/after
# cat /sys/kernel/debug/tracing/trace_pipe > trace.out

> > > I haven't seen a crash without xfs_fsr.
> > 
> > Then don't use xfs_fsr until we know if it is the cause of the
> > problem (except to reproduce the problem).
> 
> Why so defensive? xfs_fsr is an advertised feature and should just work

Defensive? Sure - to protect -your systems- from further corruption
problems until we know what the problem is.

To use a car analogy: I know the brakes on your car have a fault
that could cause a catastrophic failure, and I know you are taking a
drive over a mountain. Don't you think I should tell you not to
drive your car over the mountain, but to get the brakes looked at
first?

But it's your data, so if you want to risk catastrophic corruption
by continuing to run xfs_fsr then that's your choice.

> (and does so with older kernels).

On older kernels (2.6.34 and earlier) I can corrupt filesystems
using xfs-fsr just by crafting a file with a specific layout. It's
easy and doesn't require any special privileges to do. IOWs, xfs_fsr
on old kernels is actually dangerous and should not be used if you
have anything that stores information in attributes (like selinux).
We made quite a lot of fixes to the swap extent code to fix those
problems, along with regression tests so the problem doesn't arise
again.

It's entirely possible that a problem was introduced by these fixes.
Perhaps there's a case that I didn't fully understand and fix
properly or there's some other as yet unknown problem. Until I know
what it is, then the safest thing is not to run xfs_fsr.  Indeed, if
you get new corruptions showing up without running xfs_fsr, than
that's also something worth knowing.

> > And as I always ask - why do you need to run xfs_fsr so often?  Do
> 
> Did I say I am running it often? IT typically runs once a day for an hour.

Yes, that is often. I don't run xfs_fsr at all on any of my
machines (except for the test VMs when testing xfs_fsr).

The problem with running xfs_fsr is that while it defragments files,
it fragments free space, i.e. xfs_fsr turns large contiguous free
space ranges into smaller, non-contiguous free space ranges.
IOWs, using xfs_fsr accelerates filesystem aging effects, meaning
that new files are much more likely to be get fragemented as they
grow because they cannot be located in large contiguous free space
extents. Then you run xfs_fsr to reduce the number of fragments in
the file, thereby converting free space into more smaller, less
contiguous extents. It's a downward spiral....

That's why running xfs-fsr regularly out of a cron job is not
advisable. This lesson was learn on Irix more than 10 years ago when
it was defaulted to running once a week for two hours on Sunday
night.  Running it more frequently like is happening on your systems
will only make things worse.

FWIW, this comes up often enough that I think I need to add a FAQ
entry for it.

> > you really have filesystems that get quickly fragmented (or are you
> 
> Yes, fragmentation with xfs is enourmous - I have yet to see whether
> the changes in recent kernels make a big difference, but for log files,
> reading through a log file with 60000 fragments tends to be much slower
> than reading through one with just a few fragments (or just one...).

So you've got a problem with append only workloads.

2.6.38 and more recent kernels should be much more resistent to
fragmentation under such conditions thanks to the dynamic
speculative allocation changes that went into 2.6.38.

Alternatively, you can use the allocsize mount option, or set the
append-only inode flag, or set the preallocated flag on the inode
so that truncation of specualtive allocation beyond EOF doesn't
occur every time the file is closed.

.....

> > If you are getting fragmentation, what is the workload that is causing
> > it?
> 
> Basically, anything but the OS itself. Copying large video files while the
> disk is busy with other things causes lots of fragmentation (usually 30
> fragments for a 100mb file), which in turn slows down things enourmously once
> the disk reaches 95% full.

Another oft-repeated rule of thumb - filling XFS filesystems over
85-90% full causes increased fragmentation because of the lack of
large contiguous free space extents. That's exactly the same problem
that excessive use of xfs_fsr causes.....

> Freenet is also a good test case.

Not for a filesystem developer. Running internet facing, anonymous,
encrypted peer-to-peer file storage servers anywhere is not
something I'll ever do on my network.

If you think it's a good workload that we should use, then capture a
typical directory profile and the IO/filesystem operations made on a
busy server for an hour or so. Then write a script to reproduce that
directory structure and IO pattern.....

> As are logfiles.
> 
> Or a news spool.

append only workloads.

> Or database files for databases that grow files (such as mysql myisam) -
> fortunately I could move of all those to SSDs this year.

I thought mysql as capable of preallocating regions when files grow.
Perhaps it isn't configured to do so?

> Or simply unpacking an archive.

That should not cause fragmentation unless you have already
fragmented free space...

Use xfs_db -r -c "freesp -s" <dev> to get an idea of what your
freespace situation looks like.

> Simple example - the www.deliantra.net gameserver writes logs to a logfile
> and stdout, which is redirected to another logfile in the same directory
> (which gets truncated on each restart).
> 
> Today I had to reboot the server because of buggy xfs (which prompted the
> bugreport, as I am seeing this bug for a while now, but so far didn't want
> to exclude e.g. bad ram or simply a corrupt filesystem), and in the 4
> hours uptime, I got a 4MB logfile with 8 fragments.

What kernel, and what is the xfs_bmap -vp output for the file?

> This is clearly an improvement over the 2.6.26 kernel I used before on
> that machine. But over a few months this still leads to thousands of
> fragments,

Have you seen this, or are you extrapolating from the 4MB file
you've seen above?

....

> Freenet fares much worse. The persistent blob has 1757 fragments for 13gb
> (not that bad), and the download database has 22756 for 600mb, fragments
> (that sucks).

You're still talking about how 2.6.26 kernels behave, right?

> On my tv, the recorded video files that haven't been defragmented yet
> have between 11 and 63 fragments (all smaller than 2gb), which is almost
> acceptable, but I do not think that without a regular xfs_fsr the fs would
> be in that good shape after one or two years of usage.

For old kernels, allocsize should have mostly solved that problem.
For current kernels that shouldn't even be necessary.

> The cool thing about xfs_fsr is not that the cool kids run it, but that,
> unlike other filesystems that also fragment a lot (ext3 is absolutely
> horrible for example), it can mostly be fixed.

"fixed" is not really true - all it has done is trade file
fragementation for freespace fragementation. That bites you
eventually.

> Given that xfs is clearly the lowest quality of the common filesystems
> on linux (which I mean to be reiserfs, ext2/3/4 - and before you ask,
> literally each time I run a file system check xfs_repair crashes or hangs,
> and the filesystems have some issues, on all my numerous machines, and
> the number of bugs I have hit with xfs is easily twice the amount of
> bugs I hit with reiserfs and extX together, and I was an early adopter
> of reiserfs, before it even had a fsck), it is important to have some
> features left that cancel this general lack of quality.

Quality will only improve if you report bugs and help trace their
root cause. Then we can fix them.  If you don't, we don't know about
them, can't fid them and hence can't fix them.

> Right now, these features for me are the very tunable nature of xfs (for
> example, 512b block size for news spools), the very fast xfs_repair and
> the long-term maintainability of the filesystem - a heavily used ext3
> filesystem basically becomes unusable after a year.
> 
> Another feature was the very good feedback I got from this list in the
> past w.r.t. bugs and fixes (while nowadays I have to listen to "xfs is
> optimised for nfs not for your use" or "then don't use it" replies to bug
> reports).

<sigh>

Ok, now I remember you. I hope this time you'll provide me with the
information I ask you for to triage your problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
