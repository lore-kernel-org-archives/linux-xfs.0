Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B111C7F88
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 03:07:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BBAE8F807A
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 01:07:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uGqbGRkxdxXX5Dgh for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 01:06:59 -0700 (PDT)
Date: Thu, 10 Oct 2013 19:06:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010080652.GW4446@dastard>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
	<20131010033300.GA12952@localhost>
	<20131010033834.GA13141@localhost> <20131010042820.GA5663@dastard>
	<20131010060334.GA17576@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010060334.GA17576@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Thu, Oct 10, 2013 at 02:03:34PM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 03:28:20PM +1100, Dave Chinner wrote:
> > On Thu, Oct 10, 2013 at 11:38:34AM +0800, Fengguang Wu wrote:
> > > On Thu, Oct 10, 2013 at 11:33:00AM +0800, Fengguang Wu wrote:
> > > > On Thu, Oct 10, 2013 at 11:26:37AM +0800, Fengguang Wu wrote:
> > > > > Dave,
> > > > > 
> > > > > > I note that you have CONFIG_SLUB=y, which means that the cache slabs
> > > > > > are shared with objects of other types. That means that the memory
> > > > > > corruption problem is likely to be caused by one of the other
> > > > > > filesystems that is probing the block device(s), not XFS.
> > > > > 
> > > > > Good to know that, it would easy to test then: just turn off every
> > > > > other filesystems. I'll try it right away.
> > > > 
> > > > Seems that we don't even need to do that. A dig through the oops
> > > > database and I find stack dumps from other FS.
> > > > 
> > > > This happens in the kernel with same kconfig and commit 3.12-rc1.
> > > 
> > > Here is a summary of all FS with oops:
> > > 
> > >     411 ocfs2_fill_super
> > >     189 xfs_fs_fill_super
> > >      86 jfs_fill_super
> > >      50 isofs_fill_super
> > >      33 fat_fill_super
> > >      18 vfat_fill_super
> > >      15 msdos_fill_super
> > >      11 ext2_fill_super
> > >      10 ext3_fill_super
> > >       3 reiserfs_fill_super
> > 
> > The order of probing on the original dmesg output you reported is:
> > 
> > 	ext3
> > 	ext2
> > 	fatfs
> > 	reiserfs
> > 	gfs2
> > 	isofs
> > 	ocfs2
> 
> There are effectively no particular order, because there are many
> superblocks for these filesystems to scan.
> 
>         for superblocks:
>                 for filesystems:
>                         scan super block

Sure, but if XFs is at the end of the list of filesystems to try to
mount, then you'll get allt he other filesystems attempted first,
lik eis being seen. And the absence of a single message in dmesg
from XFS is kind of suspicious, because XFs is by far the noisest of
all filesystems when it comes to warning about bad superblocks....

> 
> In the end, any filesystem may impact the other (and perhaps a later
> run of itself).

No filesystem should impact on any other filesystem.

However, we have seen in the past that when filesystems share slab
caches that a bug in one filesystem can cause problems in another.
For example, years ago there was a bug in Reiserfs causing bufferhead
corruption that only affected other XFS filesystems on the same
machine.

> > which means that no XFS filesystem was mounted in the original bug
> > report, and hence that further indicates that XFS is not responsible
> > for the problem and that perhaps the original bisect was not
> > reliable...
> 
> This is an easily reproducible bug. And I further confirmed it in
> two ways:
> 
> 1) turn off XFS, build 39 commits and boot them 2000+ times
> 
> => no single mount error

That doesn't tell you it is an XFS error. Absence of symptoms !=
absence of bug.

> 2) turn off all other filesystems, build 2 kernels on v3.12-rc3
>    v3.12-rc4 and boot them
> 
> => half boots have oops

Again, it doesn't tell you that it is an XFS bug. XFS is well known
for exposing bugs in less used block devices, and you are definitely
using devices that are unusual and not commonly tested by filesystem
developers (e.g. zram, nbd, etc).

You need to refine the test down from "throw shit at the wall, look
at what sticks" to a simple, reproducable test case. I can't
reproduce your systems or testing, so you need to provide a test
case I can use. Otherwise we're just wasting time....

> So it may well be that XFS is impacted by an early run of itself.

You haven't provided any evidence that XFS is even finding bad
superblocks. As I said before, XFS is extremely loud when you
attempt to mount a corrupt image. I test this regularly on real
block devices, and I've never, ever had it fall over.

e.g:

$ sudo umount /dev/vda
$ sudo dd if=/dev/zero of=/dev/vda bs=512 count=128
128+0 records in
128+0 records out
65536 bytes (66 kB) copied, 0.0205057 s, 3.2 MB/s
$ sync
$ sudo !!
sudo mount /dev/vda /mnt/test
mount: block device /dev/vda is write-protected, mounting read-only
mount: you must specify the filesystem type
$ dmesg
....
[121196.435480] REISERFS warning (device vda): sh-2021 reiserfs_fill_super: can not find reiserfs on vda
[121196.440097] EXT3-fs (vda): error: can't find ext3 filesystem on dev vda.
[121196.443278] EXT2-fs (vda): error: can't find an ext2 filesystem on dev vda.
[121196.445941] EXT4-fs (vda): VFS: Can't find ext4 filesystem
[121196.449151] cramfs: wrong magic
[121196.450436] SQUASHFS error: Can't find a SQUASHFS superblock on vda
[121196.452453] VFS: Can't find a Minix filesystem V1 | V2 | V3 on device vda.
[121196.454745] FAT-fs (vda): bogus number of reserved sectors
[121196.456275] FAT-fs (vda): Can't find a valid FAT filesystem
[121196.458394] FAT-fs (vda): bogus number of reserved sectors
[121196.459885] FAT-fs (vda): Can't find a valid FAT filesystem
[121196.461918] BFS-fs: bfs_fill_super(): No BFS filesystem on vda (magic=00000000)
[121196.491192] REISERFS warning (device vda): sh-2021 reiserfs_fill_super: can not find reiserfs on vda
[121196.494607] EXT3-fs (vda): error: can't find ext3 filesystem on dev vda.
[121196.497112] EXT2-fs (vda): error: can't find an ext2 filesystem on dev vda.
[121196.499571] EXT4-fs (vda): VFS: Can't find ext4 filesystem
[121196.502664] cramfs: wrong magic
[121196.504210] SQUASHFS error: Can't find a SQUASHFS superblock on vda
[121196.506591] VFS: Can't find a Minix filesystem V1 | V2 | V3 on device vda.
[121196.509421] FAT-fs (vda): bogus number of reserved sectors
[121196.511023] FAT-fs (vda): Can't find a valid FAT filesystem
[121196.513268] FAT-fs (vda): bogus number of reserved sectors
[121196.514870] FAT-fs (vda): Can't find a valid FAT filesystem
[121196.517076] BFS-fs: bfs_fill_super(): No BFS filesystem on vda (magic=00000000)
[121196.537882] ISOFS: Unable to identify CD-ROM format.
[121196.540204] hfsplus: unable to find HFS+ superblock
[121196.542309] hfs: can't find a HFS filesystem on dev vda
[121196.544406] vxfs: WRONG superblock magic
[121196.546835] VFS: unable to find oldfs superblock on device vda
[121196.549310] VFS: could not find a valid V7 on vda.
[121196.551082] NTFS-fs error (device vda): read_ntfs_boot_sector(): Primary boot sector is invalid.
[121196.553688] NTFS-fs error (device vda): read_ntfs_boot_sector(): Mount option errors=recover not used. Aborting without trying to recover.
[121196.557272] NTFS-fs error (device vda): ntfs_fill_super(): Not an NTFS volume.
[121196.572149] AFFS: No valid root block on device vda
[121196.574170] VFS: Can't find a romfs filesystem on dev vda.
[121196.576214] qnx4: wrong fsid in superblock.
[121196.597773] UDF-fs: warning (device vda): udf_load_vrs: No anchor found
[121196.599777] UDF-fs: Rescanning with blocksize 2048
[121196.623750] UDF-fs: warning (device vda): udf_load_vrs: No anchor found
[121196.625766] UDF-fs: warning (device vda): udf_fill_super: No partition found (1)
[121196.628565] omfs: Invalid superblock (0)
[121196.630649] XFS (vda): bad magic number
[121196.631805] ffff88003ce1d000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[121196.634345] ffff88003ce1d010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[121196.636962] ffff88003ce1d020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[121196.639453] ffff88003ce1d030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[121196.642032] XFS (vda): Internal error xfs_sb_read_verify at line 628 of file fs/xfs/xfs_sb.c.  Caller 0xffffffff81476735
[121196.642032]
[121196.645141] CPU: 0 PID: 4544 Comm: kworker/0:1H Not tainted 3.12.0-rc4-dgc+ #27
[121196.646675] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[121196.647908] Workqueue: xfslogd xfs_buf_iodone_work
[121196.648979]  0000000000000001 ffff88000003dcf8 ffffffff81ab69b8 0000000000001c1c
[121196.650607]  ffff88003ce7a800 ffff88000003dd18 ffffffff81479f2f ffffffff81476735
[121196.652266]  0000000000000001 ffff88000003dd58 ffffffff81479f9e 0000000000000000
[121196.653897] Call Trace:
[121196.654443]  [<ffffffff81ab69b8>] dump_stack+0x46/0x58
[121196.655533]  [<ffffffff81479f2f>] xfs_error_report+0x3f/0x50
[121196.656761]  [<ffffffff81476735>] ? xfs_buf_iodone_work+0xc5/0xf0
[121196.658158]  [<ffffffff81479f9e>] xfs_corruption_error+0x5e/0x90
[121196.659453]  [<ffffffff814e23b2>] xfs_sb_read_verify+0x122/0x140
[121196.660752]  [<ffffffff81476735>] ? xfs_buf_iodone_work+0xc5/0xf0
[121196.662038]  [<ffffffff810ba7b1>] ? finish_task_switch+0x61/0x120
[121196.663328]  [<ffffffff81476735>] xfs_buf_iodone_work+0xc5/0xf0
[121196.664600]  [<ffffffff810a8a77>] process_one_work+0x177/0x400
[121196.665828]  [<ffffffff810a9172>] worker_thread+0x122/0x380
[121196.666993]  [<ffffffff810a9050>] ? rescuer_thread+0x310/0x310
[121196.668268]  [<ffffffff810b00d8>] kthread+0xd8/0xe0
[121196.669310]  [<ffffffff810b0000>] ? flush_kthread_worker+0xa0/0xa0
[121196.670610]  [<ffffffff81ac72fc>] ret_from_fork+0x7c/0xb0
[121196.671796]  [<ffffffff810b0000>] ? flush_kthread_worker+0xa0/0xa0
[121196.673144] XFS (vda): Corruption detected. Unmount and run xfs_repair
[121196.675483] XFS (vda): SB validate failed with error 22.
[121196.677958] NILFS: Can't find nilfs on dev vda.
[121196.679502] BeFS(vda): invalid magic header
[121196.682193] (mount,4795,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
[121196.683878] (mount,4795,0):ocfs2_fill_super:1229 ERROR: status = -22
[121196.685937] GFS2: not a GFS2 filesystem
[121196.686847] GFS2: gfs2 mount does not exist
[121196.688160] F2FS-fs (vda): Magic Mismatch, valid(0xf2f52010) - read(0x0)
[121196.689598] F2FS-fs (vda): Can't find a valid F2FS filesystem in first superblock
[121196.691473] F2FS-fs (vda): Magic Mismatch, valid(0xf2f52010) - read(0x0)
[121196.692972] F2FS-fs (vda): Can't find a valid F2FS filesystem in second superblock
$

Note the gigantic, noisy stack trace that XFS leaves behind when it
fails to validate a superblock? And the hexdump telling you what was
in the block that it read? That's the output that the commit your
bisect landed on adds. Now, if you are telling me that this commit
is causing the problems, then where's the output in dmesg from it?
It's clearly not so broken as to simply fail all the time, so you
should be seeing *thousands* of these traces in your logs.

If you aren't seeing any of these traces, then the first thing you
need to do is work out why. The code is not obviously broken, and I
can't break it here myself, so that suggests there's something
special in what you are doing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
