Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49404 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbeLFBGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 20:06:01 -0500
Date: Wed, 5 Dec 2018 17:05:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181206010550.GN24487@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:24:52PM -0500, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds the always_cow mode support after improving our COW
> write support a little bit first.
> 
> The always_cow mode stresses the COW path a lot, but with a few xfstests
> fixups it generall looks good, except for a few tests that complain about
> fragmentation, which is rather inherent in this mode, and xfs/326 which
> inserts error tags into the COW path not getting the expected result.
> 
> Changes since v2:
>  - add a patch to remove xfs_trim_extent_eof
>  - add a patch to remove the separate io_type and rely on existing state
>    in the writeback path
>  - rework the truncate race handling in the writeback path a little more
> 
> Changes since v1:
>  - make delalloc and unwritten extent conversions simpler and more robust
>  - add a few additional cleanups
>  - support all fallocate modes but actual preallocation
>  - rebase on top of a fix from Brian (which is included as first patch
>    to make the patch set more usable)

Hmm, so I tried running xfstests with quota enabled and -g all and
always_cow=1, and saw a bunch of test failures.  Are these expected?
A always_cow=0 run seems to have run fine.

(generic/050 might just be broken so don't spend too much energy on
that one)

--D

--- /tmp/xfstests/tests/generic/050.out	2017-11-27 09:17:11.023736523 -0800
+++ /var/tmp/xfstests//generic/050.out.bad	2018-12-03 22:05:57.391636614 -0800
@@ -2,9 +2,11 @@
 setting device read-only
 mounting read-only block device:
 mount: device write-protected, mounting read-only
+mount: permission denied
 touching file on read-only filesystem (should fail)
 touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
+umount: SCRATCH_DEV: not mounted
 setting device read-write
 mounting read-write block device:
 touch files
@@ -18,7 +20,9 @@
 umount: SCRATCH_DEV: not mounted
 mounting filesystem with -o norecovery on a read-only device:
 mount: device write-protected, mounting read-only
+mount: permission denied
 unmounting read-only filesystem
+umount: SCRATCH_DEV: not mounted
 setting device read-write
 mounting filesystem that needs recovery with -o ro:
 *** done
--- /tmp/xfstests/tests/generic/075.out	2017-02-28 09:23:56.049065953 -0800
+++ /var/tmp/xfstests//generic/075.out.bad	2018-12-03 22:11:12.392566688 -0800
@@ -8,11 +8,6 @@
 -----------------------------------------------
 fsx.1 : -d -N numops -S 0 -x
 -----------------------------------------------
-
------------------------------------------------
-fsx.2 : -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -d -N numops -l filelen -S 0 -x
------------------------------------------------
+    fsx (-d -N 1000 -S 0 -x) failed, 0 - compare /var/tmp/xfstests/generic/075.1.{good,bad,fsxlog}
+mv: cannot stat '/tmp/xfstests/075.1.fsxlog': No such file or directory
+od: /tmp/xfstests/075.1.fsxgood: No such file or directory
--- /tmp/xfstests/tests/generic/112.out	2017-02-28 09:23:56.052066035 -0800
+++ /var/tmp/xfstests//generic/112.out.bad	2018-12-03 22:15:41.225044797 -0800
@@ -8,11 +8,5 @@
 -----------------------------------------------
 fsx.1 : -A -d -N numops -S 0 -x
 -----------------------------------------------
-
------------------------------------------------
-fsx.2 : -A -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -A -d -N numops -l filelen -S 0 -x
------------------------------------------------
+    fsx (-A -d -N 1000 -S 0 -x) returned 0 - see 112.1.full
+mv: cannot stat '/tmp/xfstests/112.1.fsxlog': No such file or directory
--- /tmp/xfstests/tests/generic/392.out	2017-02-28 09:23:56.076066685 -0800
+++ /var/tmp/xfstests//generic/392.out.bad	2018-12-03 23:24:31.217086985 -0800
@@ -3,9 +3,13 @@
 ==== i_size 4096 test with fsync ====
 ==== i_time test with fsync ====
 ==== fpunch 1024 test with fsync ====
+Before:  "b: 8464 s: 4202496 a: 2018-12-03 23:24:28.977047177 -0800 m: 2018-12-03 23:24:28.989047390 -0800 c: 2018-12-03 23:24:28.989047390 -0800"
+After :  "b: 8208 s: 4202496 a: 2018-12-03 23:24:28.977047177 -0800 m: 2018-12-03 23:24:28.989047390 -0800 c: 2018-12-03 23:24:28.989047390 -0800"
 ==== fpunch 4096 test with fsync ====
 ==== i_size 1024 test with fdatasync ====
 ==== i_size 4096 test with fdatasync ====
 ==== i_time test with fdatasync ====
 ==== fpunch 1024 test with fdatasync ====
+Before:  "b: 8464 s: 4202496"
+After :  "b: 8208 s: 4202496"
 ==== fpunch 4096 test with fdatasync ====
--- /tmp/xfstests/tests/generic/451.out	2017-09-03 08:56:14.795707491 -0700
+++ /var/tmp/xfstests//generic/451.out.bad	2018-12-03 23:43:53.829680018 -0800
@@ -1,2 +1,9 @@
 QA output created by 451
+get stale data from buffer read
+00000000  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+*
+0001c000  55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55  UUUUUUUUUUUUUUUU
+*
+0003c000  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+000a0000
 Silence is golden
--- /dev/null	2018-12-03 21:37:59.088000000 -0800
+++ /var/tmp/xfstests//generic/476.dmesg	2018-12-03 23:51:33.429850088 -0800
@@ -0,0 +1,104 @@
+[ 7804.425766] run fstests generic/476 at 2018-12-03 23:47:40
+[ 7804.828467] XFS (pmem3): using DEBUG-only always_cow mode.
+[ 7804.830272] XFS (pmem3): Mounting V5 Filesystem
+[ 7804.836758] XFS (pmem3): Ending clean mount
+[ 7805.207900] XFS (pmem4): using DEBUG-only always_cow mode.
+[ 7805.210817] XFS (pmem4): Mounting V5 Filesystem
+[ 7805.214250] XFS (pmem4): Ending clean mount
+[ 7805.216764] XFS (pmem4): Quotacheck needed: Please wait.
+[ 7805.220707] XFS (pmem4): Quotacheck: Done.
+[ 7806.345711] XFS (pmem4): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
+[ 7806.345712] XFS (pmem4): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
+
+[ 7892.155964] ======================================================
+[ 7892.158181] WARNING: possible circular locking dependency detected
+[ 7892.159864] 4.20.0-rc1-djw #8 Not tainted
+[ 7892.161865] ------------------------------------------------------
+[ 7892.164655] kswapd0/54 is trying to acquire lock:
+[ 7892.166931] 00000000f0bcc36e (sb_internal){++++}, at: xfs_trans_alloc+0x1a5/0x220 [xfs]
+[ 7892.171000] 
+               but task is already holding lock:
+[ 7892.173813] 000000005352e33b (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x30
+[ 7892.203207] 
+               which lock already depends on the new lock.
+
+[ 7892.205884] 
+               the existing dependency chain (in reverse order) is:
+[ 7892.207859] 
+               -> #1 (fs_reclaim){+.+.}:
+[ 7892.209537]        kmem_cache_alloc+0x29/0x290
+[ 7892.211472]        kmem_zone_alloc+0x83/0x100 [xfs]
+[ 7892.213626]        xfs_trans_alloc+0x45/0x220 [xfs]
+[ 7892.215745]        xfs_sync_sb+0x35/0x70 [xfs]
+[ 7892.217677]        xfs_quiesce_attr+0x53/0x90 [xfs]
+[ 7892.219820]        xfs_fs_freeze+0x25/0x40 [xfs]
+[ 7892.222046]        freeze_super+0xc8/0x180
+[ 7892.223993]        do_vfs_ioctl+0x5b8/0x750
+[ 7892.225946]        ksys_ioctl+0x36/0x60
+[ 7892.227707]        __x64_sys_ioctl+0x16/0x20
+[ 7892.230376]        do_syscall_64+0x50/0x170
+[ 7892.244271]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
+[ 7892.246233] 
+               -> #0 (sb_internal){++++}:
+[ 7892.248518]        __sb_start_write+0xb0/0x1f0
+[ 7892.251785]        xfs_trans_alloc+0x1a5/0x220 [xfs]
+[ 7892.253483]        xfs_free_eofblocks+0x14e/0x230 [xfs]
+[ 7892.255249]        xfs_fs_destroy_inode+0xd6/0x300 [xfs]
+[ 7892.256814]        dispose_list+0x48/0x70
+[ 7892.258418]        prune_icache_sb+0x52/0x70
+[ 7892.260494]        super_cache_scan+0x13e/0x190
+[ 7892.262403]        shrink_slab.constprop.86+0x1ed/0x560
+[ 7892.264742]        shrink_node+0x99/0x310
+[ 7892.266323]        kswapd+0x33d/0x860
+[ 7892.268272]        kthread+0x106/0x140
+[ 7892.269798]        ret_from_fork+0x3a/0x50
+[ 7892.271957] 
+               other info that might help us debug this:
+
+[ 7892.275294]  Possible unsafe locking scenario:
+
+[ 7892.277820]        CPU0                    CPU1
+[ 7892.279797]        ----                    ----
+[ 7892.281817]   lock(fs_reclaim);
+[ 7892.283167]                                lock(sb_internal);
+[ 7892.285511]                                lock(fs_reclaim);
+[ 7892.287806]   lock(sb_internal);
+[ 7892.289174] 
+                *** DEADLOCK ***
+
+[ 7892.291593] 3 locks held by kswapd0/54:
+[ 7892.293239]  #0: 000000005352e33b (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x30
+[ 7892.296470]  #1: 00000000d57c66e4 (shrinker_rwsem){++++}, at: shrink_slab.constprop.86+0x5f/0x560
+[ 7892.300215]  #2: 000000007add902d (&type->s_umount_key#33){++++}, at: trylock_super+0x16/0x50
+[ 7892.303874] 
+               stack backtrace:
+[ 7892.306308] CPU: 0 PID: 54 Comm: kswapd0 Not tainted 4.20.0-rc1-djw #8
+[ 7892.309597] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
+[ 7892.313494] Call Trace:
+[ 7892.321691]  dump_stack+0x5e/0x8b
+[ 7892.329352]  print_circular_bug.isra.35+0x212/0x21f
+[ 7892.339719]  __lock_acquire+0x1196/0x1580
+[ 7892.348877]  ? kvm_clock_read+0x14/0x30
+[ 7892.357090]  ? lock_acquire+0x9d/0x1a0
+[ 7892.364959]  lock_acquire+0x9d/0x1a0
+[ 7892.369784]  ? xfs_trans_alloc+0x1a5/0x220 [xfs]
+[ 7892.372053]  __sb_start_write+0xb0/0x1f0
+[ 7892.374286]  ? xfs_trans_alloc+0x1a5/0x220 [xfs]
+[ 7892.376305]  xfs_trans_alloc+0x1a5/0x220 [xfs]
+[ 7892.378462]  xfs_free_eofblocks+0x14e/0x230 [xfs]
+[ 7892.381112]  xfs_fs_destroy_inode+0xd6/0x300 [xfs]
+[ 7892.383713]  dispose_list+0x48/0x70
+[ 7892.385831]  prune_icache_sb+0x52/0x70
+[ 7892.387484]  super_cache_scan+0x13e/0x190
+[ 7892.389412]  shrink_slab.constprop.86+0x1ed/0x560
+[ 7892.391531]  shrink_node+0x99/0x310
+[ 7892.393055]  kswapd+0x33d/0x860
+[ 7892.394507]  ? node_reclaim+0x270/0x270
+[ 7892.396437]  kthread+0x106/0x140
+[ 7892.397902]  ? kthread_cancel_delayed_work_sync+0x10/0x10
+[ 7892.400332]  ret_from_fork+0x3a/0x50
+[ 7977.067500] XFS (pmem3): Unmounting Filesystem
+[ 8036.080093] XFS (pmem4): Unmounting Filesystem
+[ 8037.706746] XFS (pmem4): using DEBUG-only always_cow mode.
+[ 8037.708416] XFS (pmem4): Mounting V5 Filesystem
+[ 8037.718914] XFS (pmem4): Ending clean mount
--- /tmp/xfstests/tests/xfs/026.out	2018-11-01 15:51:51.833340753 -0700
+++ /var/tmp/xfstests//xfs/026.out.bad	2018-12-04 00:15:40.163563143 -0800
@@ -27,6 +27,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4516 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/027.out	2018-11-01 15:51:51.833340753 -0700
+++ /var/tmp/xfstests//xfs/027.out.bad	2018-12-04 00:15:52.707774592 -0800
@@ -18,6 +18,8 @@
 xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4516 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 39 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/046.out	2018-11-01 15:51:51.838340643 -0700
+++ /var/tmp/xfstests//xfs/046.out.bad	2018-12-04 00:18:44.602685223 -0800
@@ -27,6 +27,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4236 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 10 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/056.out	2018-11-01 15:51:51.840340598 -0700
+++ /var/tmp/xfstests//xfs/056.out.bad	2018-12-04 00:20:00.859983661 -0800
@@ -27,6 +27,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4488 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4246 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 7 directories and 11 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/060.out	2018-11-01 15:51:51.841340576 -0700
+++ /var/tmp/xfstests//xfs/060.out.bad	2018-12-04 00:20:58.672970719 -0800
@@ -41,6 +41,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4546 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 41 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/061.out	2018-11-01 15:51:51.841340576 -0700
+++ /var/tmp/xfstests//xfs/061.out.bad	2018-12-04 00:21:10.273169035 -0800
@@ -18,6 +18,8 @@
 xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4488 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4216 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 7 directories and 11 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/063.out	2018-11-01 15:51:51.841340576 -0700
+++ /var/tmp/xfstests//xfs/063.out.bad	2018-12-04 00:21:32.261545187 -0800
@@ -37,6 +37,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4320 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4346 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 4 directories and 21 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/064.out	2018-11-01 15:51:51.842340554 -0700
+++ /var/tmp/xfstests//xfs/064.out.bad	2018-12-04 00:22:25.158451306 -0800
@@ -313,6 +313,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27467/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4236 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27467/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -394,6 +396,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27493/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27493/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -427,6 +431,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27519/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27519/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -460,6 +466,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27545/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27545/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -493,6 +501,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27571/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27571/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -526,6 +536,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27597/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27597/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -559,6 +571,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27623/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27623/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -592,6 +606,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27649/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27649/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -625,6 +641,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27675/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27675/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -658,6 +676,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27701/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/xfsrestorehousekeepingdir.27701/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -692,6 +712,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4236 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -773,6 +795,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -854,6 +877,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -935,6 +959,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -1016,6 +1041,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -1097,6 +1123,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -1178,6 +1205,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -1259,6 +1287,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -1340,6 +1369,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
@@ -1421,6 +1451,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 55 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/066.out	2018-11-01 15:51:51.843340532 -0700
+++ /var/tmp/xfstests//xfs/066.out.bad	2018-12-04 00:22:57.991014568 -0800
@@ -31,6 +31,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 2 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/068.out	2018-11-01 15:51:51.844340510 -0700
+++ /var/tmp/xfstests//xfs/068.out.bad	2018-12-04 00:23:12.487263477 -0800
@@ -21,8 +21,10 @@
 xfsrestore: session id: ID
 xfsrestore: media ID: ID
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 25488 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 17556 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
-xfsrestore: 383 directories and 1335 entries processed
+xfsrestore: 382 directories and 1343 entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
--- /dev/null	2018-12-03 21:37:59.088000000 -0800
+++ /var/tmp/xfstests//xfs/079.dmesg	2018-12-04 00:24:01.116099243 -0800
@@ -0,0 +1,51 @@
+[ 9983.940112] XFS (pmem3): Unmounting Filesystem
+[ 9984.709782] XFS (pmem4): Unmounting Filesystem
+[ 9984.868053] XFS (pmem4): Mounting V5 Filesystem
+[ 9984.871502] XFS (pmem4): Ending clean mount
+[ 9984.873227] XFS (pmem4): Quotacheck needed: Please wait.
+[ 9985.273714] XFS (pmem4): Quotacheck: Done.
+[ 9985.275187] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: /raid/home/djwong/cdev/work/linux-djw/fs/xfs/libxfs/xfs_ag_resv.c, line: 319
+[ 9985.349822] WARNING: CPU: 2 PID: 11265 at /raid/home/djwong/cdev/work/linux-djw/fs/xfs/xfs_message.c:104 assfail+0x25/0x30 [xfs]
+[ 9985.352759] Modules linked in: ext2 ocfs2_stack_o2cb ocfs2_dlm ocfs2 ocfs2_nodemanager configfs quota_tree ocfs2_stackglue dm_thin_pool dm_persistent_data dm_bio_prison mq_deadline deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c bfq dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: scsi_debug]
+[ 9985.359330] CPU: 2 PID: 11265 Comm: mount Not tainted 4.20.0-rc1-djw #8
+[ 9985.360846] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
+[ 9985.362961] RIP: 0010:assfail+0x25/0x30 [xfs]
+[ 9985.363999] Code: ff 0f 0b c3 90 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 58 48 1e a0 48 89 fa 31 ff e8 54 f9 ff ff 80 3d 55 49 0f 00 00 75 03 <0f> 0b c3 0f 0b 66 0f 1f 44 00 00 66 66 66 66 90 48 63 f6 49 89 f9
+[ 9985.368107] RSP: 0000:ffffc90000b63cf0 EFLAGS: 00010246
+[ 9985.369323] RAX: 0000000000000000 RBX: ffff88006dc77000 RCX: 0000000000000000
+[ 9985.370933] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa01d5cf3
+[ 9985.372570] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
+[ 9985.374188] R10: 0000000000000001 R11: f000000000000000 R12: ffff88006767e000
+[ 9985.375809] R13: 0000000000000000 R14: ffff88006767e000 R15: 0000000000000000
+[ 9985.377433] FS:  00007f1507eb7840(0000) GS:ffff88007e200000(0000) knlGS:0000000000000000
+[ 9985.379257] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[ 9985.380590] CR2: 00000000023c70d8 CR3: 0000000078828000 CR4: 00000000000006a0
+[ 9985.382212] Call Trace:
+[ 9985.382866]  xfs_ag_resv_init+0x1bd/0x1d0 [xfs]
+[ 9985.383977]  xfs_fs_reserve_ag_blocks+0x37/0xa0 [xfs]
+[ 9985.385206]  xfs_mountfs+0x89f/0x970 [xfs]
+[ 9985.386220]  xfs_fs_fill_super+0x511/0x6e0 [xfs]
+[ 9985.387343]  ? xfs_test_remount_options+0x60/0x60 [xfs]
+[ 9985.388594]  mount_bdev+0x17a/0x1b0
+[ 9985.389451]  mount_fs+0x15/0x80
+[ 9985.390233]  vfs_kern_mount+0x62/0x160
+[ 9985.391145]  do_mount+0x1dc/0xd70
+[ 9985.391964]  ? copy_mount_options+0x2d/0x180
+[ 9985.392991]  ksys_mount+0x7e/0xd0
+[ 9985.393801]  __x64_sys_mount+0x21/0x30
+[ 9985.394713]  do_syscall_64+0x50/0x170
+[ 9985.395614]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
+[ 9985.396814] RIP: 0033:0x7f1507798b9a
+[ 9985.397681] Code: 48 8b 0d 01 c3 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ce c2 2b 00 f7 d8 64 89 01 48
+[ 9985.401810] RSP: 002b:00007ffcdcdc6458 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
+[ 9985.403525] RAX: ffffffffffffffda RBX: 000000000182a060 RCX: 00007f1507798b9a
+[ 9985.405155] RDX: 000000000182a2d0 RSI: 000000000182a310 RDI: 000000000182a2f0
+[ 9985.406781] RBP: 0000000000000000 R08: 000000000182a270 R09: 0000000000000012
+[ 9985.408442] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 000000000182a2f0
+[ 9985.410077] R13: 000000000182a2d0 R14: 0000000000000000 R15: 0000000000000005
+[ 9985.411704] irq event stamp: 0
+[ 9985.412456] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
+[ 9985.417384] hardirqs last disabled at (0): [<ffffffff81056678>] copy_process+0x6e8/0x2190
+[ 9985.419283] softirqs last  enabled at (0): [<ffffffff81056678>] copy_process+0x6e8/0x2190
+[ 9985.421144] softirqs last disabled at (0): [<0000000000000000>]           (null)
+[ 9985.422816] ---[ end trace f0b195b925b8de5a ]---
--- /tmp/xfstests/tests/xfs/080.out	2018-11-01 15:51:51.846340466 -0700
+++ /var/tmp/xfstests//xfs/080.out.bad	2018-12-04 00:24:02.892129791 -0800
@@ -1,3 +1,6 @@
 QA output created by 080
 
-Completed rwtest pass 1 successfully.
+iogen:  Could not xfsctl(XFS_IOC_RESVSP) 104185344 bytes in file rwtest.file: Operation not supported (95)
+iogen warning:  Couldn't create file rwtest.file of 104185344 bytes
+iogen:  Could not create, or gather info for any test files
+rwtest.sh : iogen reported errors (r=2)
--- /tmp/xfstests/tests/xfs/114.out	2018-11-01 15:51:51.863340090 -0700
+++ /var/tmp/xfstests//xfs/114.out.bad	2018-12-04 00:25:42.117839178 -0800
@@ -1,6 +1,8 @@
 QA output created by 114
 Format and mount
 Create some files
+fallocate: Operation not supported
+fallocate: Operation not supported
 Insert and write file range
 Remount
 Collapse file
--- /tmp/xfstests/tests/xfs/170.out	2018-11-01 15:51:51.879339736 -0700
+++ /var/tmp/xfstests//xfs/170.out.bad	2018-12-04 00:29:25.817709966 -0800
@@ -3,19 +3,5 @@
 # streaming
 # sync AGs...
 # checking stream AGs...
-+ passed, streams are in seperate AGs
-# testing 8 22 4 8 3 1 0 ....
-# streaming
-# sync AGs...
-# checking stream AGs...
-+ passed, streams are in seperate AGs
-# testing 8 22 4 8 3 0 1 ....
-# streaming
-# sync AGs...
-# checking stream AGs...
-+ passed, streams are in seperate AGs
-# testing 8 22 4 8 3 1 1 ....
-# streaming
-# sync AGs...
-# checking stream AGs...
-+ passed, streams are in seperate AGs
+- failed, 2 streams with matching AGs
+(see /var/tmp/xfstests/xfs/170.full for details)
--- /tmp/xfstests/tests/xfs/171.out	2018-11-01 15:51:51.879339736 -0700
+++ /var/tmp/xfstests//xfs/171.out.bad	2018-12-04 00:29:41.669985068 -0800
@@ -3,19 +3,5 @@
 # streaming
 # sync AGs...
 # checking stream AGs...
-+ passed, streams are in seperate AGs
-# testing 64 16 8 100 1 1 1 ....
-# streaming
-# sync AGs...
-# checking stream AGs...
-+ passed, streams are in seperate AGs
-# testing 64 16 8 100 1 0 0 ....
-# streaming
-# sync AGs...
-# checking stream AGs...
-+ passed, streams are in seperate AGs
-# testing 64 16 8 100 1 0 1 ....
-# streaming
-# sync AGs...
-# checking stream AGs...
-+ passed, streams are in seperate AGs
+- failed, 7 streams with matching AGs
+(see /var/tmp/xfstests/xfs/171.full for details)
--- /tmp/xfstests/tests/xfs/173.out	2018-11-01 15:51:51.879339736 -0700
+++ /var/tmp/xfstests//xfs/173.out.bad	2018-12-04 00:30:17.422605872 -0800
@@ -18,4 +18,5 @@
 # streaming
 # sync AGs...
 # checking stream AGs...
-+ passed, streams are in seperate AGs
+- failed, 28 streams with matching AGs
+(see /var/tmp/xfstests/xfs/173.full for details)
--- /tmp/xfstests/tests/xfs/180.out	2018-11-01 15:51:51.880339714 -0700
+++ /var/tmp/xfstests//xfs/180.out.bad	2018-12-04 00:30:38.254967826 -0800
@@ -9,3 +9,4 @@
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-180/file1
 d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-180/file2
 Check extent counts
+file2 badly fragmented
--- /tmp/xfstests/tests/xfs/182.out	2018-11-01 15:51:51.880339714 -0700
+++ /var/tmp/xfstests//xfs/182.out.bad	2018-12-04 00:30:52.171209702 -0800
@@ -10,3 +10,4 @@
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
 c6ba35da9f73ced20d7781a448cc11d4  SCRATCH_MNT/test-182/file2
 Check extent counts
+file2 badly fragmented
--- /tmp/xfstests/tests/xfs/192.out	2018-11-01 15:51:51.883339647 -0700
+++ /var/tmp/xfstests//xfs/192.out.bad	2018-12-04 00:32:19.796734292 -0800
@@ -8,3 +8,4 @@
 Compare files
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-192/file1
 Check extent counts
+file2 badly fragmented
--- /tmp/xfstests/tests/xfs/198.out	2018-11-01 15:51:51.884339625 -0700
+++ /var/tmp/xfstests//xfs/198.out.bad	2018-12-04 00:32:29.484903017 -0800
@@ -8,3 +8,4 @@
 Compare files
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-198/file1
 Check extent counts
+file2 badly fragmented
--- /tmp/xfstests/tests/xfs/204.out	2018-11-01 15:51:51.885339603 -0700
+++ /var/tmp/xfstests//xfs/204.out.bad	2018-12-04 00:32:39.781082365 -0800
@@ -8,3 +8,4 @@
 Compare files
 2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-204/file1
 Check extent counts
+file2 badly fragmented
--- /tmp/xfstests/tests/xfs/205.out	2018-11-01 15:51:51.885339603 -0700
+++ /var/tmp/xfstests//xfs/205.out.bad	2018-12-04 00:32:43.641149612 -0800
@@ -1,4 +1,5 @@
 QA output created by 205
 *** one file
+   !!! disk full (expected)
 *** one file, a few bytes at a time
 *** done
--- /tmp/xfstests/tests/xfs/208.out	2018-11-01 15:51:51.885339603 -0700
+++ /var/tmp/xfstests//xfs/208.out.bad	2018-12-04 00:32:49.745255963 -0800
@@ -11,3 +11,5 @@
 d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-208/file2
 d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-208/file3
 Check extent counts
+file2 badly fragmented
+file3 badly fragmented
--- /tmp/xfstests/tests/xfs/252.out	2018-11-01 15:51:51.892339448 -0700
+++ /var/tmp/xfstests//xfs/252.out.bad	2018-12-04 00:43:57.620854199 -0800
@@ -7,9 +7,7 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..127]: unwritten
-1: [128..383]: hole
-2: [384..639]: unwritten
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
 0: [0..383]: hole
@@ -17,43 +15,39 @@
 2: [512..639]: hole
 286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..383]: hole
-1: [384..511]: unwritten
-2: [512..639]: hole
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
 0: [0..127]: data
 1: [128..639]: hole
 3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
-1: [128..383]: hole
-2: [384..511]: unwritten
-3: [512..639]: hole
+1: [128..639]: hole
 3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..127]: unwritten
-1: [128..639]: hole
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..127]: unwritten
-1: [128..383]: hole
-2: [384..511]: data
-3: [512..639]: hole
+fallocate: Operation not supported
+0: [0..383]: hole
+1: [384..511]: data
+2: [512..639]: hole
 286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
 1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..127]: unwritten
-1: [128..511]: hole
-2: [512..639]: unwritten
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
@@ -86,9 +80,7 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
-0: [0..127]: unwritten
-1: [128..383]: hole
-2: [384..639]: unwritten
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	4. hole -> data
 0: [0..383]: hole
@@ -96,43 +88,39 @@
 2: [512..639]: hole
 286aad7ca07b2256f0f2bb8e608ff63d
 	5. hole -> unwritten
-0: [0..383]: hole
-1: [384..511]: unwritten
-2: [512..639]: hole
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	6. data -> hole
 0: [0..127]: data
 1: [128..639]: hole
 3976e5cc0b8a47c4cdc9e0211635f568
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
-1: [128..383]: hole
-2: [384..511]: unwritten
-3: [512..639]: hole
+1: [128..639]: hole
 3976e5cc0b8a47c4cdc9e0211635f568
 	8. unwritten -> hole
-0: [0..127]: unwritten
-1: [128..639]: hole
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	9. unwritten -> data
-0: [0..127]: unwritten
-1: [128..383]: hole
-2: [384..511]: data
-3: [512..639]: hole
+fallocate: Operation not supported
+0: [0..383]: hole
+1: [384..511]: data
+2: [512..639]: hole
 286aad7ca07b2256f0f2bb8e608ff63d
 	10. hole -> data -> hole
 1aca77e2188f52a62674fe8a873bdaba
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
-0: [0..127]: unwritten
-1: [128..511]: hole
-2: [512..639]: unwritten
+fallocate: Operation not supported
 1aca77e2188f52a62674fe8a873bdaba
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
@@ -165,6 +153,7 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
@@ -175,6 +164,7 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
@@ -185,16 +175,19 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
@@ -205,16 +198,19 @@
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
@@ -247,6 +243,7 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
@@ -257,6 +254,7 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	5. hole -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
@@ -267,16 +265,19 @@
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	7. data -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	8. unwritten -> hole
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
 2f7a72b9ca9923b610514a11a45a80c9
 	9. unwritten -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..383]: hole
 2: [384..639]: data
@@ -287,16 +288,19 @@
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	11. data -> hole -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	12. unwritten -> data -> unwritten
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
 0bcfc7652751f8fe46381240ccadd9d7
 	13. data -> unwritten -> data
+fallocate: Operation not supported
 0: [0..127]: data
 1: [128..511]: hole
 2: [512..639]: data
--- /tmp/xfstests/tests/xfs/266.out	2018-11-01 15:51:51.894339404 -0700
+++ /var/tmp/xfstests//xfs/266.out.bad	2018-12-04 00:44:52.097802263 -0800
@@ -58,6 +58,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4516 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
@@ -82,6 +84,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: NOTE: dump is not self-contained, orphaned files expected if base dump(s) was not applied
 xfsrestore: 1 directories and 4 entries processed
--- /tmp/xfstests/tests/xfs/281.out	2018-11-01 15:51:51.897339338 -0700
+++ /var/tmp/xfstests//xfs/281.out.bad	2018-12-04 00:45:55.718910065 -0800
@@ -31,6 +31,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4516 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/282.out	2018-11-01 15:51:51.897339338 -0700
+++ /var/tmp/xfstests//xfs/282.out.bad	2018-12-04 00:46:10.147161386 -0800
@@ -61,6 +61,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4516 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
@@ -86,6 +88,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/283.out	2018-11-01 15:51:51.897339338 -0700
+++ /var/tmp/xfstests//xfs/283.out.bad	2018-12-04 00:46:24.679414556 -0800
@@ -61,6 +61,8 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4516 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
@@ -86,6 +88,7 @@
 xfsrestore: media ID: ID
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
+xfsrestore: NOTE: attempt to reserve 4264 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 3 directories and 38 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/296.out	2018-11-01 15:51:51.899339294 -0700
+++ /var/tmp/xfstests//xfs/296.out.bad	2018-12-04 00:48:48.253917474 -0800
@@ -34,6 +34,8 @@
 xfsrestore: using online session inventory
 xfsrestore: searching media for directory dump
 xfsrestore: examining media file 0
+xfsrestore: NOTE: attempt to reserve 4208 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed: Operation not supported (95)
+xfsrestore: NOTE: attempt to reserve 4156 bytes for SCRATCH_MNT/restoredir/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)
 xfsrestore: reading directories
 xfsrestore: 2 directories and 2 entries processed
 xfsrestore: directory post-processing
--- /tmp/xfstests/tests/xfs/326.out	2018-11-01 15:51:51.904339183 -0700
+++ /var/tmp/xfstests//xfs/326.out.bad	2018-12-04 00:51:30.084742147 -0800
@@ -13,6 +13,6 @@
 FS should be online, touch should succeed
 Check files again
 2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
-1e108771fba35e2f2961d1ad23efbff7  SCRATCH_MNT/file2
+610b3ba989e5e55e90271c2d92e597ca  SCRATCH_MNT/file2
 153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
 Done
--- /tmp/xfstests/tests/xfs/329.out	2018-11-01 15:51:51.904339183 -0700
+++ /var/tmp/xfstests//xfs/329.out.bad	2018-12-04 00:51:34.236814667 -0800
@@ -4,7 +4,6 @@
 Inject error
 Defrag the file
 FS should be shut down, touch will fail
-touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
 Check extent count
 FS should be online, touch should succeed
--- /tmp/xfstests/tests/xfs/331.out	2018-11-01 15:51:51.904339183 -0700
+++ /var/tmp/xfstests//xfs/331.out.bad	2018-12-04 00:51:41.396939729 -0800
@@ -2,3 +2,5 @@
 + create scratch fs
 + mount fs image
 + make some files
+fallocate: Operation not supported
+fallocate: Operation not supported
--- /tmp/xfstests/tests/xfs/420.out	2018-11-01 15:51:51.915338940 -0700
+++ /var/tmp/xfstests//xfs/420.out.bad	2018-12-04 00:52:12.569484283 -0800
@@ -14,8 +14,6 @@
 Whence	Result
 DATA	0
 HOLE	131072
-DATA	196608
-HOLE	262144
 Compare files
 c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1
 017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-420/file2
--- /tmp/xfstests/tests/xfs/442.out	2018-11-01 15:51:51.918338874 -0700
+++ /var/tmp/xfstests//xfs/442.out.bad	2018-12-04 00:53:21.438687804 -0800
@@ -1,6 +1,7 @@
 QA output created by 442
 Format and fsstress
 Check quota before remount
+project quota 1485116 blocks does not match du 1485216 blocks?
 Check quota after remount
 Comparing user usage
 Comparing group usage
