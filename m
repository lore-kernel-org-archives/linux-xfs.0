Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 849A67CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 19:22:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF5E7AC006
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 17:22:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iiX0jFmS0Ak424nb for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 17:22:09 -0700 (PDT)
Date: Tue, 19 Jul 2016 10:22:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [4.7-rc6 snapshot] xfstests::generic/081 unable to tear down
	snapshot VG
Message-ID: <20160719002202.GE16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: dm-devel@redhat.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

Hi folks,

I'm currently running the latest set of XFS patches through QA, and
I'm getting generic/081 failing and leaving a block device in an
unrecoverable EBUSY state. I'm running xfstests on a pair of 8GB
fake pmem devices:

$ sudo ./run_check.sh " -i sparse=1" "" " -s xfs generic/081"
umount: /mnt/test: not mounted
umount: /mnt/scratch: not mounted
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Clearing log and setting UUID
writing all SBs
new UUID = 300b4aff-a65e-4de1-ac0e-5a0058e93ef0
Building include
Building lib
Building tests
Building ltp
Building src
Building m4
Building common
Building aio-dio-regress
SECTION       -- xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test4 4.7.0-rc6-dgc+
MKFS_OPTIONS  -- -f -i sparse=1 /dev/pmem1
MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

generic/081 1s ... 1s
Ran: generic/081
Passed all 1 tests

SECTION       -- xfs
=========================
Ran: generic/081
Passed all 1 tests

$

Looking at the console output from the test:

[   28.227059] run fstests generic/081 at 2016-07-19 09:03:19
[   28.465398] XFS (pmem1): Unmounting Filesystem
[   28.684889] XFS (dm-3): EXPERIMENTAL sparse inode feature enabled. Use at your own risk!
[   28.686940] XFS (dm-3): Mounting V5 Filesystem
[   28.692561] XFS (dm-3): Ending clean mount
[   28.703692] device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
[   28.707574] Buffer I/O error on dev dm-3, logical block 24, lost async page write
[   28.708653] Buffer I/O error on dev dm-3, logical block 25, lost async page write
[   28.709798] Buffer I/O error on dev dm-3, logical block 26, lost async page write
[   28.710899] Buffer I/O error on dev dm-3, logical block 27, lost async page write
[   28.711973] Buffer I/O error on dev dm-3, logical block 28, lost async page write
[   28.713062] Buffer I/O error on dev dm-3, logical block 29, lost async page write
[   28.714191] Buffer I/O error on dev dm-3, logical block 30, lost async page write
[   28.715247] Buffer I/O error on dev dm-3, logical block 31, lost async page write
[   28.716407] Buffer I/O error on dev dm-3, logical block 32, lost async page write
[   28.717490] Buffer I/O error on dev dm-3, logical block 33, lost async page write
[   28.725428] XFS (dm-3): metadata I/O error: block 0x40048 ("xlog_iodone") error 5 numblks 64
[   28.726555] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1200 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff81520ef2
[   28.728136] XFS (dm-3): Log I/O Error Detected.  Shutting down filesystem
[   28.729019] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
[   28.730025] XFS (dm-3): xfs_log_force: error -5 returned.
[   28.731613] XFS (dm-3): Unmounting Filesystem
[   28.732197] XFS (dm-3): xfs_log_force: error -5 returned.
[   28.732905] XFS (dm-3): xfs_log_force: error -5 returned.
[   28.777469] XFS (pmem0): Unmounting Filesystem

And so, aparently the test passed. Except, the scratch device is now
busy:

$ sudo mkfs.xfs -f /dev/pmem1
mkfs.xfs: cannot open /dev/pmem1: Device or resource busy
$

And the device mapper volumes created have not been torn down.
The test attempts to tear down the dm devices via "vgremove -f <vg>"
and "pvremove -f <dev>". These fail, and when I ran them manually:

$ ls /dev/mapper
control  vg_081-base_081  vg_081-base_081-real  vg_081-snap_081  vg_081-snap_081-cow
$ sudo vgs
  VG     #PV #LV #SN Attr   VSize VFree
  vg_081   1   2   1 wz--n- 8.00g 7.74g
$ sudo vgremove vg_081
Do you really want to remove volume group "vg_081" containing 2 logical volumes? [y/n]: y
Do you really want to remove active logical volume snap_081? [y/n]: y
  device-mapper: resume ioctl on (249:2) failed: Invalid argument
  Unable to resume vg_081-snap_081-cow (249:2)
  Attempted to decrement suspended device counter below zero.
  Failed to activate snap_081.
$

I couldn't remove the the VGs, with or without the "-f" option.

However, I could remove the base and snapshot LVs with lvremove, and
then I could remove the VGs and PVs. However, this still left
/dev/pmem1 in an EBUSY state. lsof and friends showed no visible
users of the block device, and so a reboot followed.

In reproducing it, I've found that re-running the test immediately
fails 9/10 times. If it does fail, then I have to manually run:

$ sudo vgremove -f vg_081; sudo pvremove -f /dev/pmem1

before I can use the scratch device again. Rerunning generic/081
doesn't hang the device, though.

$ sudo vgremove -f vg_081
  Logical volume "snap_081" successfully removed
  Logical volume "base_081" successfully removed
  Volume group "vg_081" successfully removed
$

Seem to succeed without hanging the block device. I then found that running
generic/085 directly after generic/081 failing to clean up properly
causes the nasty problems:

....
generic/081 4s ... 1s
generic/085 4s ... 1s
_check_xfs_filesystem: filesystem on /dev/pmem1 has dirty log (see /home/dave/src/xfstests-dev/results//xfs/generic/085.full)
_check_xfs_filesystem: filesystem on /dev/pmem1 is inconsistent (c) (see /home/dave/src/xfstests-dev/results//xfs/generic/085.full)
_check_xfs_filesystem: filesystem on /dev/pmem1 is inconsistent (r) (see /home/dave/src/xfstests-dev/results//xfs/generic/085.full)
Ran: generic/081 generic/085
Failures: generic/085
Failed 1 of 2 tests

SECTION       -- xfs
=========================
Ran: generic/081 generic/085
Failures: generic/085
Failed 1 of 2 tests

$ sudo vgremove -f vg_081; sudo pvremove -f /dev/pmem1
  device-mapper: resume ioctl on (249:2) failed: Invalid argument
  Unable to resume vg_081-snap_081-cow (249:2)
  Attempted to decrement suspended device counter below zero.
  Failed to activate snap_081.
  WARNING: duplicate PV 1Gu10MXqCOmP1l9BjlwcL2CPGH00GgLJ is being used from both devices /dev/mapper/085-test and /dev/pmem1
  Can't open /dev/pmem1 exclusively - not removing. Mounted filesystem?
$ sudo lvs
  LV       VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  base_081 vg_081 -wi-s----- 256.00m                                                    
  snap_081 vg_081 -wi-s-----   4.00m                 
$ sudo vgs
  VG     #PV #LV #SN Attr   VSize VFree
  vg_081   1   2   0 wz--n- 8.00g 7.74g
$ sudo pvs
  PV                   VG     Fmt  Attr PSize PFree
  /dev/mapper/085-test vg_081 lvm2 a--  8.00g 7.74g
$ ls /dev/mapper/
085-test  control  vg_081-base_081  vg_081-base_081-real  vg_081-snap_081  vg_081-snap_081-cow
$

After copying this into the email, I ran:

$ sudo vgremove -f vg_081
  Attempted to decrement suspended device counter below zero.
  Logical volume "base_081" successfully removed
  Attempted to decrement suspended device counter below zero.
  Attempted to decrement suspended device counter below zero.
  Logical volume "snap_081" successfully removed
  Volume group "vg_081" successfully removed
$ sudo vgs
$ sudo pvs
  PV                   VG   Fmt  Attr PSize   PFree  
  /dev/mapper/085-test      lvm2 ---  256.00m 256.00m
$ sudo vgremove -f vg_081; sudo pvremove -f /dev/pmem1
  Volume group "vg_081" not found
  Cannot process volume group vg_081
  Can't open /dev/pmem1 exclusively - not removing. Mounted filesystem?
$

So the VG cleaned up this time (huh?), but the PV cannot be scrubbed
because the block device can't be opened exclusively.

<reboot again>
<rerun generic/081>

$ ls /dev/mapper
control  vg_081-base_081  vg_081-base_081-real  vg_081-snap_081  vg_081-snap_081-cow
$ sudo lvs; sudo vgs; sudo pvs
  LV       VG     Attr       LSize   Pool Origin   Data%  Meta%  Move Log Cpy%Sync Convert
  base_081 vg_081 owi-a-s--- 256.00m
  snap_081 vg_081 swi-I-s---   4.00m      base_081 100.00
  VG     #PV #LV #SN Attr   VSize VFree
  vg_081   1   2   1 wz--n- 8.00g 7.74g
  /dev/vg_081/snap_081: read failed after 0 of 4096 at 0: Input/output error
  /dev/vg_081/snap_081: read failed after 0 of 4096 at 268369920: Input/output error
  /dev/vg_081/snap_081: read failed after 0 of 4096 at 268427264: Input/output error
  /dev/vg_081/snap_081: read failed after 0 of 4096 at 4096: Input/output error
  PV         VG     Fmt  Attr PSize PFree
  /dev/pmem1 vg_081 lvm2 a--  8.00g 7.74g
$

[No idea what those IO errors are from! Another bug?]

<clean up>
<rerun generic/08[15]>

$ sudo lvs; sudo vgs; sudo pvs
  LV       VG     Attr       LSize   Pool Origin   Data%  Meta%  Move Log Cpy%Sync Convert
  base_081 vg_081 owi-s-s--- 256.00m
  snap_081 vg_081 swi-S-s---   4.00m      base_081 100.00
  VG     #PV #LV #SN Attr   VSize VFree
  vg_081   1   2   1 wz--n- 8.00g 7.74g
  PV                   VG     Fmt  Attr PSize PFree
  /dev/mapper/085-test vg_081 lvm2 a--  8.00g 7.74g
$

And now we are in the bad state. What I notice here is that the PV
has *changed name*. It's no longer "/dev/pmem1", but is
"/dev/mapper/085-test" and apparently has vg_081 inside it.

Ok, so let's try removing that PV:

$ sudo pvremove -f /dev/mapper/085-test
  PV /dev/mapper/085-test belongs to Volume Group vg_081 so please use vgreduce first.
  (If you are certain you need pvremove, then confirm by using --force twice.)
$ sudo pvremove -f -f /dev/mapper/085-test
Really WIPE LABELS from physical volume "/dev/mapper/085-test" of volume group "vg_081" [y/n]? y
  WARNING: Wiping physical volume label from /dev/mapper/085-test of volume group "vg_081"
  Can't open /dev/mapper/085-test exclusively - not removing.  Mounted filesystem?
$

Yikes. So, given generic/085 is a suspend/resume test, lets see if
there's a counter problem:

$ sudo dmsetup resume /dev/mapper/085-test
$ sudo vgremove -f vg_081; sudo pvremove -f /dev/mapper/085-test
  Attempted to decrement suspended device counter below zero.
  Logical volume "base_081" successfully removed
  Attempted to decrement suspended device counter below zero.
  Attempted to decrement suspended device counter below zero.
  Logical volume "snap_081" successfully removed
  Volume group "vg_081" successfully removed
  Labels on physical volume "/dev/mapper/085-test" successfully wiped
$

OK, it's cleaned up. Or is it?

$ sudo pvs
$ sudo lvs
$ sudo vgs
$ sudo mkfs.xfs -f /dev/pmem1
mkfs.xfs: cannot open /dev/pmem1: Device or resource busy
$ ls /dev/mapper
085-test  control
$

Nope, it's still fucked up. Ok, one last string to pull:

$ sudo dmsetup remove 085-test
$ ls /dev/mapper
control
$ sudo mkfs.xfs -f /dev/pmem1
meta-data=/dev/pmem1             isize=512    agcount=4, agsize=524288 blks
.....
$

Yay! I unravelled the tangled ball of LVM/dmsetup fuck-up!

Now, this *might* be a result of generic/085 screwing up the setup
using dmsetup because the teardown of the previous device failed.
Well, that might have been the case if you could actually run a test
once generic/081 failed to clean up, but you can't. So there's a
window where the LVM teardown has failed, but a new DM device
creation via dmsetup succeeds and overwrites part of the LVM config.
And it's all down hill from there. What a mess.

Can I have the last 2 hours of my life back, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
