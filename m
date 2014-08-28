Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 214CB7F3F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:31:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 957CBAC001
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 15:31:35 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id tjQ8d6FaPIdKMWvp
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 15:31:34 -0700 (PDT)
Subject: Re: storage, libaio,
	or XFS =?UTF-8?Q?problem=3F=20=20=33=2E=34=2E=32=36?=
MIME-Version: 1.0
Date: Thu, 28 Aug 2014 17:31:33 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
In-Reply-To: <20140828003226.GO20518@dastard>
References: <3fe8c34c0ccbbd720015d273fa2b8b30@localhost>
	<20140826075345.GJ20518@dastard>
	<8c29baf987467a84f0b7c1d09c863662@localhost>
	<20140828003226.GO20518@dastard>
Message-ID: <7f9e5aef187b44e899077467aeb0809d@localhost>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 28 Aug 2014 10:32:27 +1000, Dave Chinner <david@fromorbit.com>
wrote:
> On Tue, Aug 26, 2014 at 12:19:43PM -0500, Stan Hoeppner wrote:
>> On Tue, 26 Aug 2014 17:53:45 +1000, Dave Chinner <david@fromorbit.com>
>> wrote:
>> > On Tue, Aug 26, 2014 at 01:18:50AM -0500, Stan Hoeppner wrote:
>> >> Had some controller issues but believe we had those ironed out
before
>> >> this
>> >> recent breakage.  I had reformatted both 48TB LUNs on this test box
>> with
>> >> -f
>> >> and defaults, and fired up the test app again.  Throughput was
>> fantastic
>> >> with no dropped application buffers for ~30 minutes, and IO times
were
>> >> 1.x
>> >> ms max, suggesting all the writes were acked by controller cache. 
The
>> >> app
>> >> was running perfectly.  Then it hanged and spit out an internal
error
>> >> msg:
>> >> 
>> >> 
>> >> Failed to reopen file /mnt/VOL1/sg-04/str-0015/f-0000000005
>> >> 
>> >> I have many call traces in dmesg, most are XFS, pasted below.  I
found
>> no
>> >> SCSI I/O errors in dmesg.  Application is submitting writes via
libaio
>> >> and
>> >> using O_DIRECT, writing to preallocated files.  I don't see any
errors
>> in
>> >> the storage controller log and everything seems to check out there. 
>> >> Using
>> >> noop elevator, mpt2sas, no multipathing.  The application process is
>> hung
>> >> in d state and kill -9 won't get rid of it.  I can't unmount the
hosed
>> up
>> >> filesystem.  Any ideas?
>> >> 
>> >> # ls -la /mnt/VOL1
>> >> ls: cannot access /mnt/VOL1: Input/output error
>> >> 
>> >> # dd if=/mnt/VOL1 of=/dev/null bs=1M count=16
>> >> dd: opening `/mnt/VOL1': Input/output error
>> >> 
>> >> # dd if=/dev/sdd of=/dev/null bs=1M count=16
>> >> 16+0 records in
>> >> 16+0 records out
>> >> 16777216 bytes (17 MB) copied, 1.10989 s, 15.1 MB/s
>> >> 
>> >> # ls -la /mnt/
>> >> ls: cannot access /mnt/VOL1: Input/output error
>> >> total 8
>> >> drwxrwxrwt  6 root root  120 Aug 25 17:59 .
>> >> drwxr-xr-x 21 root root 4096 Jul 15 09:39 ..
>> >> drwxrwxrwt  3 root root   80 Aug 25 16:52 initramfs
>> >> drwxr-xr-x  3 root root 4096 Apr 24 04:57 scratch
>> >> drwxrwxrwx  5 root root   58 Aug 25 22:06 VOL0
>> >> d?????????  ? ?    ?       ?            ? VOL1
>> > 
>> > That's an inode we failed to stat() - most likely because of the IO
>> > error. Has the filesystem shut down? the IO error shoul dhave had
>> > some kind of output in dmesg associated with it from XFS....
>> 
>> Sorry, I omitted the XFS logging preceding the first call trace:
>> 
>> Aug 25 18:02:50 Anguish-ssu-1 kernel: [ 4280.310304] SGI XFS with
>> security
>> attributes, large block/inode numbers, no debug enabled
>> Aug 25 18:02:50 Anguish-ssu-1 kernel: [ 4280.311101] XFS (sdc):
Mounting
>> Filesystem
>> Aug 25 18:02:51 Anguish-ssu-1 kernel: [ 4280.501405] XFS (sdc):
Starting
>> recovery (logdev: internal)
>> Aug 25 18:02:53 Anguish-ssu-1 kernel: [ 4282.766547] XFS (sdc): Failed
to
>> recover EFIs
>> Aug 25 18:02:53 Anguish-ssu-1 kernel: [ 4282.766549] XFS (sdc): log
mount
>> finish failed
> 
> That's indicative of corrupted free space btrees.

I did mkfs on both LUNs after this mount failure.
 
>> Aug 25 18:04:50 Anguish-ssu-1 kernel: [ 4399.471829] XFS (sdc):
Mounting
>> Filesystem
>> Aug 25 18:04:50 Anguish-ssu-1 kernel: [ 4399.620805] XFS (sdc): Ending
>> clean mount
>> Aug 25 18:04:56 Anguish-ssu-1 kernel: [ 4405.613778] XFS (sdd):
Mounting
>> Filesystem
>> Aug 25 18:04:56 Anguish-ssu-1 kernel: [ 4405.835412] XFS (sdd): Ending
>> clean mount

The back-to-back mounts here were me testing my storage prep automation
script - creates the mount points, sets permission, mounts the filesystems,
sets the elevator to noop, etc. (their kernel defaults to CFQ...)

>> Aug 25 23:05:39 Anguish-ssu-1 kernel: [22409.328839] XFS (sdd):
>> xfs_do_force_shutdown(0x8) called from line 3732 of file
>> fs/xfs/xfs_bmap.c.
>> Return address = 0xffffffffa01cc9a6
> 
> Yup, that's kinda important. That's from xfs_bmap_finish(), and
> freeing an extent has failed and triggered SHUTDOWN_CORRUPT_INCORE
> which it's found some kind of inconsistency in the free space
> btrees. So, likely the same problem that caused EFI recovery to fail
> on the other volume.
> 
> Are the tests being run on newly made filesystems? If not, have
> these filesystems had xfs_repair run on them after a failure?  If
> so, what is the error that is fixed? If not, does repairing the
> filesystem make the problem go away?

Newly made after every error of any kind, whether app, XFS shutdown, call
trace, etc.  I've not attempted xfs_repair.  Part of the problem is the
storage hardware is a moving target.  They're swapping modules and
upgrading firmware every few days.  And I don't have a view into that.  So
it's difficult to know when IO problems are due to hardware or buggy code. 
However, I can state with certainty that we only run into the XFS problems
when using AIO.  And it has occurred on both test rigs, each of which have
their own RAID controllers and disks.
 
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.307128] XFS (sdd): failed
to
>> update timestamps for inode 0x2a000000a4
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.307484] XFS (sdd): failed
to
>> update timestamps for inode 0x29000000a4
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.307487] XFS (sdd): failed
to
>> update timestamps for inode 0x20000009f
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.307499] XFS (sdd): failed
to
>> update timestamps for inode 0x29000000a4
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.307693] XFS (sdd): failed
to
>> update timestamps for inode 0x20000009f
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.368106] XFS (sdd): failed
to
>> update timestamps for inode 0xf000000a4
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.369785] XFS (sdd): failed
to
>> update timestamps for inode 0xf000000a4
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.605835] XFS (sdd): failed
to
>> update timestamps for inode 0x2810f413c
>> Aug 25 23:05:49 Anguish-ssu-1 kernel: [22419.606169] XFS (sdd): failed
to
>> update timestamps for inode 0x60000009f
> 
> And that is interesting. Makes me wonder if the inode is getting
> unlocked on transaction commit failure, or whether there's some
> other path in the shutdown code that is not unlocking the inode
> correctly.

Is this a separate time stamp from that which noatime disables?  We're
mounting with noatime, nodiratime.

>> Again, when the app locked up I was assuming we had more controller
>> issues, and I expected to find SCSI I/O errors preceding the XFS
errors. 
>> But there are none.
> 
> XFs has had some kind of internal error in extent or freespace
> management. The lack of output when the error has triggered makes it
> impossible to determine what might have gone wrong. Seeing what
> xfs_repair -n says about the filesystem woul dbe interesting.
> Probably best to use an xfs-repair from the current 3.2.1 release,
> because older 3.1.x versions (i think 3.1.10 and prior) didn't
> validate the freespace btrees - they just got rebuilt.

I'm hoping to be able to get kernel 3.12.26 onto the smaller rig soon so I
can test bcache.  I'll enable xfs_debug on it.  WRT newer user space tools,
that's like pulling teeth.  It's all like like pulling teeth actually, WRT
the platform software.  WRT the app we can do whatever we want.

>> These aren't truly lab systems in all respects.  I don't have the
>> permission/access to change the kernel config and recompile.  There is
a
>> "process" for that and a different group owns that process.  If this is
>> necessary to troubleshoot this then I'll see if I can push it through.
> 
> Good luck, it sounds like you might have a few stories for the
> Daily WTF if the "processes" at that so entrenched it's impossible
> to test fixes.

Yes, it's difficult.  I won't be able to test patches as things stand. 
That will require much time, many meetings, my project manager throwing
chairs, that kinda thing.  And he's very mild mannered.

>> > I haven't cheked if this still works on a 3.4 kernel, but it will
>> > change the rwsem implementation to the generic, spinlock based
>> > implementation rather than the super-special, highly optimised
>> > x86 specific implementation. If that makes the problem go away,
>> > then we've got another rwsem bug on our hands. If it doesn't, then I
>> > can probably get you the mrlock debug code lachlan wrote and we can
>> > see if XFS is doing something wrong...
>> 
>> Thanks for the detailed explanation.  Given the new information I've
>> provided, what is my next step?
> 
> xfs_repair output, turn /proc/sys/fs/xfs/error_level up to 11,
> maybe run a test with a CONFIG_XFS_DEBUG=y kernel, or even a
> current 3.15/3.16 kernel to see if the problem still exists...
> 
> But if you can't get new kernels or xfsprogs binaries onto the
> machine, then there is very little that we can do.

One would think such a thing would be easy, a no brainer.  But this is a
large corporation after all, so I shouldn't be surprised by red tape.  The
fact it took them over 3 months from contact to getting me in the door was
a bit of a clue up front.  I think the way this is seen is that AIO would
be nice to have, but it's not a necessity.  Not with the red tape to cut
through to get newer system software...


> Cheers,
> 
> Dave.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
