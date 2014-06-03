Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B2D67F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 16:29:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 844AFAC00D
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 14:28:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sp3LqBLaum2zB9XC for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 14:28:50 -0700 (PDT)
Date: Wed, 4 Jun 2014 07:28:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140603212834.GG14410@dastard>
References: <5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
	<20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538DA7FF.4080002@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

On Tue, Jun 03, 2014 at 01:48:31PM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 06/03/2014 12:55 PM, Stefan Ring wrote:
> > From skimming this thread, it seems that there is some hardware
> > issue at work here, but nonetheless, I had a very similar situation
> > a while ago that was rather puzzling to me at the time, having to
> > do with mount namespaces: 
> > http://oss.sgi.com/pipermail/xfs/2012-August/020910.html
> > 
> 
> Hardware issue or not, IMHO XFS has some issues.

No issues, XFS just behaves differently to hot-unplug scenarios to
ext4. the ext4 behaviour is actually problematic when it comes
to data and filesystem security in error conditions and so it is not
a model we shoul dbe following.

To summarise, yanking the device out from behind XFS iis causin an
EIO error to a critical metadata write and it is shutting down to
prevent further error and/or corruption propagation. You have to
unmount the XFS shutdown filesystem before you can access the
filesystem and mount point again.

The fact that ext4 is not failing when you yank the plug is a bad
sign. That's actually a major potential for Bad Stuff because
there's no guarantee that the device you plugged back in is the same
device, yet ext4 appears to think it is just fine. What happens next
is likely to be filesystem corruption and data loss.

> $ cat /proc/mounts | grep media/T
>   --- no output ---
> $ lsof | grep TEST
> hexedit   24010      martin    3u  unknown
>               /TEST...FILE (stat: Input/output error)

Yup, EIO - the device is gone, filesystem shutdown. This is a correct
reposnse to the conditions you have created.

> hexedit   24011      martin    3u      REG              259,6
> 4198400         12 /TEST...FILE
> 
> After reconnecting the device ext4 mounts, xfs does not.

Yup - XFS refuses to mount a filesystem with a duplicate UUID,
preventing you from mounting the same filesystem from two different
logical block device instances that point to the same physical disk.
That's the only sane thing to do in enterprise storage systems that
use multi-pathing to present failure-tolerant access to a physical
device.

> dmegs contains this (among other [unrelated] things):
> 
> [3095915.107117] sd 60:0:0:0: [sdf] 976773167 512-byte logical blocks:
> (500 GB/465 GiB)
> [3095915.108343] sd 60:0:0:0: [sdf] Write Protect is off
> [3095915.108360] sd 60:0:0:0: [sdf] Mode Sense: 1c 00 00 00
> [3095915.110633] sd 60:0:0:0: [sdf] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [3095915.207622]  sdf: sdf69 sdf100 sdf101 sdf102 sdf103 sdf104 sdf105
> [3095915.210148] sd 60:0:0:0: [sdf] Attached SCSI disk
> [3095917.969887] XFS (sdf100): Mounting Filesystem
> [3095918.209464] XFS (sdf100): Starting recovery (logdev: internal)
> [3095918.260450] XFS (sdf100): Ending recovery (logdev: internal)
> [3096069.218797] XFS (sdf100): metadata I/O error: block 0xa02007
> ("xlog_iodone") error 19 numblks 64

#define ENODEV          19      /* No such device */

Yup, that's what happened to the filesystem - you unplugged the
device and it:

> [3096069.218808] XFS (sdf100): xfs_do_force_shutdown(0x2) called from
> line 1115 of file
> /build/buildd/linux-lts-raring-3.8.0/fs/xfs/xfs_log.c.  Return address
> = 0xffffffffa07f4fd1
> [3096069.218830] XFS (sdf100): Log I/O Error Detected.  Shutting down
> filesystem
> [3096069.218833] XFS (sdf100): Please umount the filesystem and
> rectify the problem(s)

triggered a shutdown and told you what to do next.

> [3096099.254131] XFS (sdf100): xfs_log_force: error 5 returned.
> [3096129.289338] XFS (sdf100): xfs_log_force: error 5 returned.
> [3096159.324525] XFS (sdf100): xfs_log_force: error 5 returned.
> [3096185.296795] sd 61:0:0:0: [sdg] 976773167 512-byte logical blocks:
> (500 GB/465 GiB)
> [3096185.297431] sd 61:0:0:0: [sdg] Write Protect is off
> [3096185.297447] sd 61:0:0:0: [sdg] Mode Sense: 1c 00 00 00
> [3096185.298022] sd 61:0:0:0: [sdg] Write cache: enabled, read cache:

Then the device was hot-plugged and it came back as a different
block device.

> sdf100 (the old device) and sdg100 (the reconnected device) are
> different, but XFS won't touch it.
> 
> # xfs_repair /dev/sdg100
> xfs_repair: /dev/sdg100 contains a mounted filesystem
> 
> fatal error -- couldn't initialize XFS library

Yup, because the filesystem is still mounted at /mnt/TEST. XFS
checks whether the filesystem on the block device is mounted, not
whether the block device *instance* is mounted. Again, this is
needed in redundant path storage setups because, for example,
/dev/sdc and /dev/sdx might be the same physical disk and filesystem
but have different paths to get them.

> Also please do carefully note the difference between the lsof output
> for the hung file descriptor for xfs and ext4. ext4 reports everything
> the same as before, except for the mount path. xfs report changes, the
> device ID is missing, the file changes from REG to unknown.

Of course - it can't be queried because the filesystem has shut down
and it returned an error.

> So, AFAIK and IMHO this is an issue with XFS. The impact can be the
> inability to recover from a device disconnect, since so far I don't
> see a good way to figure out which processes are holding up the FS.
> And besides, having to kill processes to mount a filesystem (xfs) is
> not a happy state of affairs.

I think you have incorrect expectations of how filesystems should
handle device hot-unplug and a later replug.  You're expecting a
filesystem that is designed for robustness in data center
environments and complex redundant path storage configurations to
behave like a filesystem designed for your laptop.

Hot-unplug is a potential data loss event. Silent data loss is the
single worst evil a filesystem can perpetrate on a user because the
user does not know they lost their important cat videos until they
try to show them to their friends. Now, would you prefer to know you
lost your cat videos straight away (XFS behaviour), or a few months
later when you try to retreive them (ext4 behaviour)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
