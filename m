Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41077 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdDLFzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 01:55:42 -0400
Date: Tue, 11 Apr 2017 22:55:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Message-ID: <20170412055535.GI8502@birch.djwong.org>
References: <20170411111011.9437-1-hch@lst.de>
 <20170411111011.9437-6-hch@lst.de>
 <20170411230246.GG8502@birch.djwong.org>
 <20170412053839.GA19900@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412053839.GA19900@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 07:38:39AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 11, 2017 at 04:02:46PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 11, 2017 at 01:10:10PM +0200, Christoph Hellwig wrote:
> > > The main thing that xfs_bmap_remap_alloc does is fixing the AGFL, similar
> > > to what we do in the space allocator.  But the reflink code doesn't touch
> > > the allocation btree unlike the normal space allocator, so we couldn't
> > > care less about the state of the AGFL.
> > > 
> > > So remove xfs_bmap_remap_alloc and just handle the di_nblocks update in
> > > the caller.
> > 
> > Looks ok, will go test.  By the way, what release were you targeting
> > with this patchset?
> 
> The patches are against for-next.  Given how late we are in 4.11 I didn't
> dare to send them for 4.11, although I'd like to backport it to 4.11-stable
> and 4.9-stable eventually.
> 
> > AFAICT the only behavioral change is that we no
> > longer ensure the AGFL in the remap step prior to (if necessary)
> > ensuring the AGFL again in the subsequent rmap step.
> 
> Yes.

Hmmm... I got a crash in generic/187 with:

MKFS_OPTIONS="-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024, /dev/sdf"

generic/187      - output mismatch (see /tmp/xfstests/results//generic/187.out.bad)
    --- tests/generic/187.out   2017-02-28 09:23:56.058066197 -0800
    +++ /tmp/xfstests/results//generic/187.out.bad      2017-04-11 18:14:40.715071575 -0700
    @@ -7,8 +7,11 @@
     8d9ea4925db533da10a45d2919d8d2d9  SCRATCH_MNT/test-187/file3
     8d9ea4925db533da10a45d2919d8d2d9  SCRATCH_MNT/test-187/file3.chk
     CoW with multiple extents?
    +pwrite: No space left on device
    +/opt/test-187/file3.chk: Input/output error
    +./common/rc: line 192: 24965 Segmentation fault      $MOUNT_PROG '_mount_ops_filter $*'
     Compare files
    ...
    (Run 'diff -u tests/generic/187.out /tmp/xfstests/results//generic/187.out.bad'  to see the entire diff)
_check_xfs_filesystem: filesystem on /dev/sdf has dirty log
(see /tmp/xfstests/results//generic/187.full for details)

[ 4307.852659] run fstests generic/187 at 2017-04-11 18:13:44
[ 4308.507527] XFS (sdf): Unmounting Filesystem
[ 4308.627786] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 4308.628673] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 4308.629822] XFS (sdf): Mounting V5 Filesystem
[ 4308.634470] XFS (sdf): Ending clean mount
[ 4308.692509] XFS (sdf): Unmounting Filesystem
[ 4308.876024] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 4308.877205] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 4308.878274] XFS (sdf): Mounting V5 Filesystem
[ 4308.883306] XFS (sdf): Ending clean mount
[ 4328.077062] XFS (sdf): Unmounting Filesystem
[ 4328.128459] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 4328.129473] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 4328.130719] XFS (sdf): Mounting V5 Filesystem
[ 4328.166304] XFS (sdf): Ending clean mount
[ 4362.064634] XFS (sdf): Unmounting Filesystem
[ 4362.157219] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 4362.159172] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 4362.161274] XFS (sdf): Mounting V5 Filesystem
[ 4362.223441] XFS (sdf): Ending clean mount
[ 4363.236809] XFS (sdf): xfs_do_force_shutdown(0x1) called from line 236 of file /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa0203400
[ 4363.240663] XFS (sdf): I/O Error Detected. Shutting down filesystem
[ 4363.241532] XFS (sdf): Please umount the filesystem and rectify the problem(s)
[ 4363.375513] XFS (sdf): Unmounting Filesystem
[ 4363.422278] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 4363.432790] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 4363.435026] XFS (sdf): Mounting V5 Filesystem
[ 4363.538385] XFS (sdf): Starting recovery (logdev: internal)
[ 4363.630364] XFS: Assertion failed: ifp->if_flags & XFS_IFEXTENTS, file: /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/libxfs/xfs_bmap.c, line: 4706
[ 4363.632502] ------------[ cut here ]------------
[ 4363.633162] kernel BUG at /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/xfs_message.c:113!
[ 4363.634304] invalid opcode: 0000 [#1] PREEMPT SMP
[ 4363.634969] Dumping ftrace buffer:
[ 4363.635463]    (ftrace buffer empty)
[ 4363.635974] Modules linked in: deadline_iosched dm_snapshot dm_bufio ext4 jbd2 mbcache dm_flakey xfs libcrc32c dax_pmem nd_pmem dax sch_fq_codel af_packet [last unloaded: scsi_debug]
[ 4363.638224] CPU: 3 PID: 24965 Comm: mount Tainted: G        W       4.11.0-rc4-dgc #1
[ 4363.639316] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1djwong0 04/01/2014
[ 4363.640688] task: ffff880074aaa780 task.stack: ffffc90002e50000
[ 4363.641580] RIP: 0010:assfail+0x20/0x30 [xfs]
[ 4363.642205] RSP: 0018:ffffc90002e53ac8 EFLAGS: 00010282
[ 4363.642942] RAX: 00000000ffffffea RBX: ffff880072629b00 RCX: 0000000000000001
[ 4363.643927] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa02a7e3a
[ 4363.644989] RBP: ffffc90002e53ac8 R08: 0000000000000000 R09: 0000000000000000
[ 4363.645939] R10: 000000000000000a R11: f000000000000000 R12: 0000000000006740
[ 4363.646964] R13: ffff88007497d000 R14: 00000000000350ee R15: ffff880072629b48
[ 4363.648019] FS:  00007f16ba56d840(0000) GS:ffff88007f600000(0000) knlGS:0000000000000000
[ 4363.649091] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4363.649851] CR2: 00007f16b9d95170 CR3: 0000000069983000 CR4: 00000000000006e0
[ 4363.650796] Call Trace:
[ 4363.651182]  xfs_bmap_finish_one+0x5fa/0x6f0 [xfs]
[ 4363.651947]  ? rcu_read_lock_sched_held+0x72/0x80
[ 4363.652724]  ? kmem_zone_alloc+0x81/0x120 [xfs]
[ 4363.653373]  xfs_trans_log_finish_bmap_update+0x40/0x60 [xfs]
[ 4363.654209]  xfs_bui_recover+0x265/0x5d0 [xfs]
[ 4363.654897]  xlog_recover_process_intents+0x293/0x2b0 [xfs]
[ 4363.655723]  xlog_recover_finish+0x1d/0xa0 [xfs]
[ 4363.656423]  xfs_log_mount_finish+0x3a/0x80 [xfs]
[ 4363.657125]  xfs_mountfs+0x65a/0xad0 [xfs]
[ 4363.657745]  xfs_fs_fill_super+0x483/0x610 [xfs]
[ 4363.658419]  mount_bdev+0x180/0x1b0
[ 4363.658954]  ? xfs_finish_flags+0x150/0x150 [xfs]
[ 4363.659660]  xfs_fs_mount+0x15/0x20 [xfs]
[ 4363.660256]  mount_fs+0x14/0xa0
[ 4363.660724]  vfs_kern_mount+0x6b/0x160
[ 4363.661269]  do_mount+0x195/0xd30
[ 4363.661754]  ? _copy_from_user+0x8c/0xd0
[ 4363.662328]  ? memdup_user+0x60/0x90
[ 4363.662846]  SyS_mount+0x95/0xe0
[ 4363.663326]  entry_SYSCALL_64_fastpath+0x1f/0xc2
[ 4363.663988] RIP: 0033:0x7f16b9e4efaa
[ 4363.664490] RSP: 002b:00007ffe9202d4a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[ 4363.665515] RAX: ffffffffffffffda RBX: 00007f16ba14763a RCX: 00007f16b9e4efaa
[ 4363.666484] RDX: 0000000002579240 RSI: 0000000002579280 RDI: 0000000002579260
[ 4363.667452] RBP: 0000000002579120 R08: 0000000000000000 R09: 0000000000000012
[ 4363.668431] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00007f16ba35783c
[ 4363.669370] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
[ 4363.670319] Code: 00 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 d0 66 2b a0 48 89 fa 31 ff 48 89 e5 e8 50 fa ff ff <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[ 4363.673053] RIP: assfail+0x20/0x30 [xfs] RSP: ffffc90002e53ac8
[ 4363.674170] ---[ end trace 6f71a70ec6fdf3f5 ]---

Looks like _bmapi_remap needs to be able to _iread_extents() if the
data fork hasn't been loaded during log recovery.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
