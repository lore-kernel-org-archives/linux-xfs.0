Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78J2SGO048802 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 14:02:29 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14B6A5362B9
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 12:02:25 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id m3eJpGng483Wr3Rh for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 12:02:25 -0700 (PDT)
Date: Mon, 8 Aug 2011 21:02:22 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110808190222.GB7087@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <20110806142005.GG3162@dastard>
	<20110807014237.GA18909@schmorp.de> <20110807102625.GJ3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110807102625.GJ3162@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Aug 07, 2011 at 08:26:25PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> Use trace-cmd or do it manually via:
> 
> # echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_swap_extent_before/enable
> # echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_swap_extent_before/after
> # cat /sys/kernel/debug/tracing/trace_pipe > trace.out

Thanks, I'll have a look at enabling this with a regular xfs_fsr on a few
machines.

> To use a car analogy: I know the brakes on your car have a fault
> that could cause a catastrophic failure, and I know you are taking a
> drive over a mountain. Don't you think I should tell you not to
> drive your car over the mountain, but to get the brakes looked at
> first?

To take your car analogy - if I went to my car dealer and told him my
brakes just malfunctioned, but fortunately it was uphill and I could
safely stop with my handbrake, he would most decisively not reply with
"then don't use your car".

No, he would presumably offer me to take back the car and replace the
brakes, for free.

I am not sure what you want to say with your analogy, but it doesn'T seem
to be sensible.

> > (and does so with older kernels).
> 
> On older kernels (2.6.34 and earlier) I can corrupt filesystems
> using xfs-fsr just by crafting a file with a specific layout.

Wow, and it's not mentioned anywhere in the status updates, unlike all
those nice performance upgrades, especially those dirty NFS hacks.

Yes, I am a bit sarcastic, but this corruption bug is either pretty
harmless or the xfs team is really somewhat irressponsible in not giving
information out about this harmful bug.

> easy and doesn't require any special privileges to do.

Wow, so any kernel before 2.6.34 can have its xfs corrupted by an
untrusted user?

Seriously, shouldn't this be mentioned at least in the fAQ or somewhere
else?

> IOWs, xfs_fsr on old kernels is actually dangerous and should not be
> used if you

Logic error - if I can corrupt an XFS without special privileges then
this is not a problem with xfs_fsr, but simply a kernel bug in the xfs
code. And a rather big one, one step below a remote exploit.

> The problem with running xfs_fsr is that while it defragments files,
> it fragments free space, i.e. xfs_fsr turns large contiguous free

While that is true in *some* cases, it can also be countered in userspace,
and will not happen if files get removed regulalry, e.g. for a cache
partition.

However, if you have those famous append-style loads, and this causes files
to have thousdands of fragments, these are most likely interleaved with other
files.

xfs_fsr can, if it manages to defragment the file completely (which is
the norm in my case), introduce at most one fragment, while, in the acse
of non-static files, it will likely remove thousands of small free space
fragments.

Sure, xfs_fsr can be detrimental, but so be doing nothing, letting your disk
gte full accidentally and many other actions.

there is definitely no clear cut "xfs_fsr causes your fs to detoriate",
and as always, you have to know what you are doing.

> That's why running xfs-fsr regularly out of a cron job is not
> advisable. This lesson was learn on Irix more than 10 years ago when
> it was defaulted to running once a week for two hours on Sunday
> night.  Running it more frequently like is happening on your systems
> will only make things worse.

Yes, I remember that change - however, running it once week and daily is
not a big difference. Quite obviously, the difference in workloads can and
will easily dominate any difference in effects.

And to me, it doesn't make a difference if xfs_fsr causes a crash every
week or every other month.

> FWIW, this comes up often enough that I think I need to add a FAQ
> entry for it.

Yes, thats a good idea in any case.

> > > you really have filesystems that get quickly fragmented (or are you
> > 
> > Yes, fragmentation with xfs is enourmous - I have yet to see whether
> > the changes in recent kernels make a big difference, but for log files,
> > reading through a log file with 60000 fragments tends to be much slower
> > than reading through one with just a few fragments (or just one...).
> 
> So you've got a problem with append only workloads.

Basically everything is append only on unix, because preallocating files
isn't being done except by special tools really, and the only way to
create file contents is to append (well, you can do random writes, as e.g.
vmware does, which causes havoc with XFS, but thats just a stupid way to
create files...).

> 2.6.38 and more recent kernels should be much more resistent to
> fragmentation under such conditions thanks to the dynamic
> speculative allocation changes that went into 2.6.38.

I would tend to agree.

> Alternatively, you can use the allocsize mount option, or set the

Well, not long ago somebody (you) told me that the allocsize option is
designed to eat all diskspace on servers with lots of run because of a NFS
optimisation hack that didn't go into the nfs server but the filesystem.

Has this been redesigned (I would say, fixed)?

> append-only inode flag, or set the preallocated flag on the inode
> so that truncation of specualtive allocation beyond EOF doesn't
> occur every time the file is closed.

Or use ext4, which fares much better without having to patch programs.

> > Basically, anything but the OS itself. Copying large video files while the
> > disk is busy with other things causes lots of fragmentation (usually 30
> > fragments for a 100mb file), which in turn slows down things enourmously once
> > the disk reaches 95% full.
> 
> Another oft-repeated rule of thumb - filling XFS filesystems over
> 85-90% full causes increased fragmentation because of the lack of
> large contiguous free space extents. That's exactly the same problem
> that excessive use of xfs_fsr causes.....

On a 39% full disk (my examples)?

> > Freenet is also a good test case.
> 
> Not for a filesystem developer. Running internet facing, anonymous,
> encrypted peer-to-peer file storage servers anywhere is not
> something I'll ever do on my network.

You are entitled to your political opinions, but why poison a purely
technical discussion with it?

Based on technical merits, freenet is a very good test case, because it
causes all kinds of I/O patterns. Your personal opinions on politics or laws
or whateverdon't make it a bad testcase, just soemthing _you_ don't want to
use yourself (which is ok).

Claiming it is a bad testcase based on your political views is just
unprofessional.

> If you think it's a good workload that we should use, then capture a
> typical directory profile and the IO/filesystem operations made on a
> busy server for an hour or so. Then write a script to reproduce that
> directory structure and IO pattern.....

I'll consider it, but is a major committment of worktime I might not be
able to commit to.

> > Or a news spool.
> 
> append only workloads.

Or anything else that creates files, i.e. *everything*.

A news spool is extremely different to logfiles - files are static and
never appended to after they have been created. They do get deleted in
irregular order, and can cause lots of free space fragmentation.

Calling everything "append only" workload is not very useful. If XFS is
bad at append-only workloads, which is *the* most common type of workload,
then XFS fails to be very relevant for the real world.

> > Or database files for databases that grow files (such as mysql myisam) -
> > fortunately I could move of all those to SSDs this year.
> 
> I thought mysql as capable of preallocating regions when files grow.

It's not. Maybe the effect isn't so bad on most filesystems (it certainly
isn't so bad on ext4):

-rw-rw---- 1 mysql mysql 3665891328 Aug  8 20:00 art.MYI
-rw------- 1 mysql mysql 2328898560 Aug  8 17:45 file.MYI
-rw-rw---- 1 mysql mysql 1098302464 Aug  8 17:45 image.MYI

art.MYI: 38 extents found
file.MYI: 20 extents found
image.MYI: 10 extents found

Thats after about 12 months of usage, during which time the file sizes
grew by about 50%.

> > Or simply unpacking an archive.
> 
> That should not cause fragmentation unless you have already
> fragmented free space...

I even get multiple fragments for lots of files when unpacking a big (>>
memory) tar on a freshly mkfs'ed filesystem. It's mostly 2-3 fragments,
affects maybe 5% of the files, and might not be a real issue, but
fragmentation it is.

> Use xfs_db -r -c "freesp -s" <dev> to get an idea of what your
> freespace situation looks like.

FWIW, this is on the disk with the 22k fragment 650mb freenet database:

   http://ue.tst.eu/edc5324f68b98076c9419ab0267ad9d6.txt

> > Today I had to reboot the server because of buggy xfs (which prompted the
> > bugreport, as I am seeing this bug for a while now, but so far didn't want
> > to exclude e.g. bad ram or simply a corrupt filesystem), and in the 4
> > hours uptime, I got a 4MB logfile with 8 fragments.
> 
> What kernel, and what is the xfs_bmap -vp output for the file?

2.6.39-2, and the crash took it with it :/

> > This is clearly an improvement over the 2.6.26 kernel I used before on
> > that machine. But over a few months this still leads to thousands of
> > fragments,
> 
> Have you seen this, or are you extrapolating from the 4MB file
> you've seen above?

These logfiles in particular had over 60000 fragments each (60k, not 6k)
before I started to regularly xfs_fsr them. Grepping through them took
almost an hour, now it takes less than a minute.

> > Freenet fares much worse. The persistent blob has 1757 fragments for 13gb
> > (not that bad), and the download database has 22756 for 600mb, fragments
> > (that sucks).
> 
> You're still talking about how 2.6.26 kernels behave, right?

No, thats with either 3.0.0-rc4/5/6 or 2.6.39-2. I am running 3.0.0-1 now
for other reasons.

> > On my tv, the recorded video files that haven't been defragmented yet
> > have between 11 and 63 fragments (all smaller than 2gb), which is almost
> > acceptable, but I do not think that without a regular xfs_fsr the fs would
> > be in that good shape after one or two years of usage.
> 
> For old kernels, allocsize should have mostly solved that problem.
> For current kernels that shouldn't even be necessary.

Yeha, I used allocsize=64m on all those storage filesystems. It certainly
helped the video fragmentation.

> > The cool thing about xfs_fsr is not that the cool kids run it, but that,
> > unlike other filesystems that also fragment a lot (ext3 is absolutely
> > horrible for example), it can mostly be fixed.
> 
> "fixed" is not really true - all it has done is trade file
> fragementation for freespace fragementation. That bites you
> eventually.

No, it might bite me, but that very much depends on the type of files. A
news spool mostly has two sizes of files for example, so it would be
surprising if that would bite me.

> Quality will only improve if you report bugs and help trace their
> root cause. Then we can fix them.  If you don't, we don't know about
> them, can't fid them and hence can't fix them.

Your are preaching to the wrong person, and this is not very
encouraging. In the past, I was often seeking the wisdom of this list, and
got good replies (and bugfixes).

It would tremendously helped if the obfuscation option actually worked -
which is the main reaosn why I sometimes can't provide metadumps. In this
case, I can because there is nothing problematic on those filesystems.

> Ok, now I remember you. I hope this time you'll provide me with the
> information I ask you for to triage your problem....

Sorry, but this is not the way you get people to help. I *always* provided
all information that I could provide and was asked for.

You are now pretending that I didn't do that in the past. Thats both
insulting and frustrating - to me, it means I can just stop interacting
with you - quite obviously, you are asking for the impossible.

I can understand if you dislike negative but true comments about XFS,
but thats niot a reason to misrepresent my contributions to track down
problems.

Or to put it differently, instead of making vague accusations, what
exactly did you ask for that I could provide, but didn't? Can you back up
your statement?

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
