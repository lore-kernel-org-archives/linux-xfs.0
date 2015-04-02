Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E24037F59
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 06:42:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49B78AC002
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 04:42:16 -0700 (PDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id 8QdNTgqptZitGpuB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Apr 2015 04:42:13 -0700 (PDT)
Received: by wgra20 with SMTP id a20so82415283wgr.3
	for <xfs@oss.sgi.com>; Thu, 02 Apr 2015 04:42:12 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: FYI: xfstests generic/019 result panic. 4.0.0-rc5
Date: Thu, 02 Apr 2015 14:40:26 +0300
Message-ID: <87r3s2g3md.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


Hi I've played with recent kernel 4.0.0-rc5 (AlViro's tree vfs.git/for-next)

And have found two issues (I do not know whenever it was fixed in
xfs.git already, so I just want to let you know)
First one is Panic caused by xfstest generic/019 (disk failure
simulation test) see attachment

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVHSqrAAoJELhyPTmIL6kB57IH/3F+o3Zgvm/IHSTtg73uuJus
bmmOjvStQ/y+moDIDC8gkZDAMBHC249vLrWGUaxIVaKqalsrBFgGS4tnQgAeKkQp
cLRcnNRi5XonazKnHPAaG+sECmivWGBeqHdq70SyE98dOEj9yv6b8bPsXac/1BAh
LIxO1pYJYaweavLH/voU2f8sWiyQikkIQITrYbBV9hanTxy+74nIlO1aBqh97za3
MobynFwYFx6WVMIh4dveSas8ePd4mVYiKVaYBfqe3LHUWl4Zphg9CR9c4oO5pWFt
TuLCBxAZdA4XzJTBVJsrk5WF3ZKdzE6VGwohvUiok9CkEZH+hNGy9dI9CFxrzAw=
=gec5
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=xfs-generic-019-panic.txt

/dev/vdb: 68/327680 files (5.9% non-contiguous), 59205/1310720 blocks
FSTESTVER: fio		fio-2.2.5-2-g64666f8-dirty (Thu, 22 Jan 2015 00:57:00 +0100)
FSTESTVER: quota		52f4e0a (Mon, 5 Jan 2015 17:13:22 +0100)
FSTESTVER: xfsprogs	v3.2.2 (Thu, 4 Dec 2014 07:56:44 +1100)
FSTESTVER: xfstests-bld	5a41f87 (Thu, 22 Jan 2015 17:26:16 +0300)
FSTESTVER: xfstests	linux-v3.8-571-gad5c393 (Tue, 20 Jan 2015 15:37:19 +0400)
FSTESTVER: kernel	4.0.0-rc5-196354-gcf5ffe9 #18 SMP Tue Mar 31 17:23:06 MSK 2015 x86_64
FSTESTCFG: "xfs"
FSTESTSET: "generic/019"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
meta-data=/dev/vdd               isize=256    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
             total       used       free     shared    buffers     cached
Mem:          1974         69       1905          9          0         17
-/+ buffers/cache:         51       1923
Swap:            0          0          0
xfs_dqtrx              0      0    576   14    2 : tunables    0    0    0 : slabdata      0      0      0
xfs_dquot              0      0    720   22    4 : tunables    0    0    0 : slabdata      0      0      0
xfs_icr                0      0    144   28    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_inode              0      0   1792   18    8 : tunables    0    0    0 : slabdata      0      0      0
xfs_efd_item           0      0    400   20    2 : tunables    0    0    0 : slabdata      0      0      0
xfs_buf_item          34     34    232   17    1 : tunables    0    0    0 : slabdata      2      2      0
xfs_da_state           0      0    480   17    2 : tunables    0    0    0 : slabdata      0      0      0
xfs_btree_cur          0      0    208   19    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_log_ticket         0      0    184   22    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_ioend             52     52    152   26    1 : tunables    0    0    0 : slabdata      2      2      0
BEGIN TEST: XFS Tue Mar 31 13:30:30 UTC 2015
Device: /dev/vdd
mk2fs options:
mount options: -o block_validity
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 kvm-xfstests 4.0.0-rc5-196354-gcf5ffe9
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdc
MOUNT_OPTIONS -- /dev/vdc /vdc

generic/019		[13:30:32][   17.619593] XFS (vdc): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[   41.914283] XFS (vdc): metadata I/O error: block 0x503d1f ("xlog_iodone") error 5 numblks 64
[   41.917326] XFS (vdc): xfs_bmap_check_leaf_extents: BAD after btree leaves for 6623 extents
[   41.917376] XFS (vdc): Log I/O Error Detected.  Shutting down filesystem
[   41.917378] XFS (vdc): Please umount the filesystem and rectify the problem(s)
[   41.918098] fsstress (3180) used greatest stack depth: 11392 bytes left
[   41.918876] XFS (vdc): metadata I/O error: block 0x503d5f ("xlog_iodone") error 5 numblks 64
[   41.918966] XFS (vdc): xfs_log_force: error -5 returned.
[   41.930237] Kernel panic - not syncing: xfs_bmap_check_leaf_extents: CORRUPTED BTREE OR SOMETHING
[   41.932793] CPU: 0 PID: 3214 Comm: fio Not tainted 4.0.0-rc5-196354-gcf5ffe9 #18
[   41.933500] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   41.933500]  00000000000019df ffff880072b4f508 ffffffff816effa5 000000000000001e
[   41.933500]  ffffffff81ac0665 ffff880072b4f588 ffffffff816efc10 ffff880000000010
[   41.933500]  ffff880072b4f598 ffff880072b4f538 ffff880072b4f598 ffff880072b4f558
[   41.933500] Call Trace:
[   41.933500]  [<ffffffff816effa5>] dump_stack+0x48/0x5b
[   41.933500]  [<ffffffff816efc10>] panic+0xd4/0x21c
[   41.933500]  [<ffffffff8128cc45>] xfs_bmap_check_leaf_extents+0x495/0x506
[   41.933500]  [<ffffffff812906b4>] xfs_bmap_add_extent_hole_real+0x786/0x7ae
[   41.933500]  [<ffffffff812940d9>] xfs_bmapi_write+0x6da/0xbb9
[   41.933500]  [<ffffffff812cc8ed>] xfs_iomap_write_direct+0x26d/0x321
[   41.933500]  [<ffffffff812b9c0f>] __xfs_get_blocks+0x1cb/0x4a1
[   41.933500]  [<ffffffff810c3c63>] ? trace_hardirqs_on_caller+0x164/0x19b
[   41.933500]  [<ffffffff812b9ef9>] xfs_get_blocks_direct+0x14/0x16
[   41.933500]  [<ffffffff811b9627>] do_blockdev_direct_IO+0x64a/0xb83
[   41.933500]  [<ffffffff810b15a4>] ? local_clock+0x1a/0x23
[   41.933500]  [<ffffffff812b9ee5>] ? __xfs_get_blocks+0x4a1/0x4a1
[   41.933500]  [<ffffffff811b9bac>] __blockdev_direct_IO+0x4c/0x4e
[   41.933500]  [<ffffffff812b9ee5>] ? __xfs_get_blocks+0x4a1/0x4a1
[   41.933500]  [<ffffffff812ba93f>] ? xfs_setfilesize+0xf3/0xf3
[   41.933500]  [<ffffffff812b8c6a>] xfs_vm_direct_IO+0x8a/0x8c
[   41.933500]  [<ffffffff812b9ee5>] ? __xfs_get_blocks+0x4a1/0x4a1
[   41.933500]  [<ffffffff812ba93f>] ? xfs_setfilesize+0xf3/0xf3
[   41.933500]  [<ffffffff81149bb8>] generic_file_direct_write+0xc1/0x150
[   41.933500]  [<ffffffff812c49d6>] xfs_file_dio_aio_write+0x21c/0x265
[   41.933500]  [<ffffffff811c3423>] ? aio_run_iocb+0x163/0x28d
[   41.933500]  [<ffffffff8107b40b>] ? kvm_clock_read+0x1e/0x20
[   41.933500]  [<ffffffff812c57e9>] ? xfs_file_buffered_aio_write+0x1e8/0x1e8
[   41.933500]  [<ffffffff812c5865>] xfs_file_write_iter+0x7c/0x107
[   41.933500]  [<ffffffff811c3432>] aio_run_iocb+0x172/0x28d
[   41.933500]  [<ffffffff81166c39>] ? might_fault+0x42/0x92
[   41.933500]  [<ffffffff81166c39>] ? might_fault+0x42/0x92
[   41.933500]  [<ffffffff811c3899>] do_io_submit+0x34c/0x3e3
[   41.933500]  [<ffffffff811c3940>] SyS_io_submit+0x10/0x12
[   41.933500]  [<ffffffff816f5f49>] system_call_fastpath+0x12/0x17
[   41.933500] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   41.933500] ---[ end Kernel panic - not syncing: xfs_bmap_check_leaf_extents: CORRUPTED BTREE OR SOMETHING

--=-=-=
Content-Type: text/plain


Second one is lockdep's complain from splice, It looks like a false-positive one, but still.

--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=xfs-lockdep-complain.txt

[  468.667585] ======================================================
[  468.669774] [ INFO: possible circular locking dependency detected ]
[  468.669983] 4.0.0-rc5-196355-gd50b8fe-dirty #19 Not tainted
[  468.669983] -------------------------------------------------------
[  468.669983] splice-fcntl/2950 is trying to acquire lock:
[  468.669983]  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff812c3f60>] xfs_rw_ilock+0x21/0x31
[  468.669983]
but task is already holding lock:
[  468.669983]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8118f93e>] pipe_lock+0x1c/0x1e
[  468.669983]
which lock already depends on the new lock.

[  468.669983]
the existing dependency chain (in reverse order) is:
[  468.669983]
-> #2 (&pipe->mutex/1){+.+.+.}:
[  468.669983]        [<ffffffff810c4f5c>] lock_acquire+0xd7/0x112
[  468.669983]        [<ffffffff816f1f88>] mutex_lock_nested+0x63/0x5ab
[  468.669983]        [<ffffffff8118f93e>] pipe_lock+0x1c/0x1e
[  468.669983]        [<ffffffff811aff79>] splice_to_pipe+0x2d/0x203
[  468.669983]        [<ffffffff811b0f82>] __generic_file_splice_read+0x41f/0x440
[  468.669983]        [<ffffffff811b0fec>] generic_file_splice_read+0x49/0x73
[  468.669983]        [<ffffffff812c50ac>] xfs_file_splice_read+0xfb/0x144
[  468.669983]        [<ffffffff811af6a4>] do_splice_to+0x74/0x81
[  468.669983]        [<ffffffff811b0751>] SyS_splice+0x4b6/0x55e
[  468.669983]        [<ffffffff816f5f09>] system_call_fastpath+0x12/0x17
[  468.669983]
-> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
[  468.669983]        [<ffffffff810c4f5c>] lock_acquire+0xd7/0x112
[  468.669983]        [<ffffffff810bf5d0>] down_write_nested+0x4b/0xad
[  468.669983]        [<ffffffff812d1c5f>] xfs_ilock+0xdb/0x14b
[  468.669983]        [<ffffffff812c3f6b>] xfs_rw_ilock+0x2c/0x31
[  468.669983]        [<ffffffff812c561e>] xfs_file_buffered_aio_write+0x59/0x1e8
[  468.669983]        [<ffffffff812c5830>] xfs_file_write_iter+0x83/0x107
[  468.669983]        [<ffffffff811882e7>] new_sync_write+0x64/0x82
[  468.669983]        [<ffffffff8118956b>] vfs_write+0xb5/0x14d
[  468.669983]        [<ffffffff811896eb>] SyS_write+0x5c/0x8c
[  468.669983]        [<ffffffff816f5f09>] system_call_fastpath+0x12/0x17
[  468.669983]
-> #0 (&sb->s_type->i_mutex_key#11){+.+.+.}:
[  468.669983]        [<ffffffff810c4b60>] __lock_acquire+0xbd6/0xefb
[  468.669983]        [<ffffffff810c4f5c>] lock_acquire+0xd7/0x112
[  468.669983]        [<ffffffff816f1f88>] mutex_lock_nested+0x63/0x5ab
[  468.669983]        [<ffffffff812c3f60>] xfs_rw_ilock+0x21/0x31
[  468.669983]        [<ffffffff812c561e>] xfs_file_buffered_aio_write+0x59/0x1e8
[  468.669983]        [<ffffffff812c5830>] xfs_file_write_iter+0x83/0x107
[  468.669983]        [<ffffffff81187e4c>] vfs_iter_write+0x4c/0x6b
[  468.669983]        [<ffffffff811afdfb>] iter_file_splice_write+0x230/0x33a
[  468.669983]        [<ffffffff811b06a4>] SyS_splice+0x409/0x55e
[  468.669983]        [<ffffffff816f5f09>] system_call_fastpath+0x12/0x17
[  468.669983]
other info that might help us debug this[  604.889687] serial8250: too much work for irq4
:

[  468.669983] Chain exists of:
  &sb->s_type->i_mutex_key#11 --> &(&ip->i_iolock)->mr_lock --> &pipe->mutex/1

[  468.669983]  Possible unsafe locking scenario:

[  468.669983]        CPU0                    CPU1
[  468.669983]        ----                    ----
[  468.669983]   lock(&pipe->mutex/1);
[  468.669983]                                lock(&(&ip->i_iolock)->mr_lock);
[  468.669983]                                lock(&pipe->mutex/1);
[  468.669983]   lock(&sb->s_type->i_mutex_key#11);
[  468.669983]
 *** DEADLOCK ***

[  468.669983] 2 locks held by splice-fcntl/2950:
[  468.669983]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff811b0671>] SyS_splice+0x3d6/0x55e
[  468.669983]  #1:  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8118f93e>] pipe_lock+0x1c/0x1e
[  468.669983]
stack backtrace:
[  468.669983] CPU: 1 PID: 2950 Comm: splice-fcntl Not tainted 4.0.0-rc5-196355-gd50b8fe-dirty #19
[  468.669983] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  468.669983]  ffffffff8247a700 ffff88006b03fa18 ffffffff816eff65 0000000000000001
[  468.669983]  ffffffff824924b0 ffff88006b03fa68 ffffffff810c2fae ffff88006b03fa68
[  468.669983]  ffffffff822781f0 ffff88007c062de0 ffff88007c0624b0 ffff88007c062de0
[  468.669983] Call Trace:
[  468.669983]  [<ffffffff816eff65>] dump_stack+0x48/0x5b
[  468.669983]  [<ffffffff810c2fae>] print_circular_bug+0x1f8/0x209
[  468.669983]  [<ffffffff810c4b60>] __lock_acquire+0xbd6/0xefb
[  468.669983]  [<ffffffff812c3f60>] ? xfs_rw_ilock+0x21/0x31
[  468.669983]  [<ffffffff810c4f5c>] lock_acquire+0xd7/0x112
[  468.669983]  [<ffffffff812c3f60>] ? xfs_rw_ilock+0x21/0x31
[  468.669983]  [<ffffffff816f1f88>] mutex_lock_nested+0x63/0x5ab
[  468.669983]  [<ffffffff812c3f60>] ? xfs_rw_ilock+0x21/0x31
[  468.669983]  [<ffffffff812c3f60>] ? xfs_rw_ilock+0x21/0x31
[  468.669983]  [<ffffffff810c3909>] ? mark_held_locks+0x59/0x77
[  468.669983]  [<ffffffff81183919>] ? slab_free_hook+0x7a/0x9a
[  468.669983]  [<ffffffff8107b40b>] ? kvm_clock_read+0x1e/0x20
[  468.669983]  [<ffffffff812c3f60>] xfs_rw_ilock+0x21/0x31
[  468.669983]  [<ffffffff812c561e>] xfs_file_buffered_aio_write+0x59/0x1e8
[  468.669983]  [<ffffffff810c3c63>] ? trace_hardirqs_on_caller+0x164/0x19b
[  468.669983]  [<ffffffff810c3ca7>] ? trace_hardirqs_on+0xd/0xf
[  468.669983]  [<ffffffff8118f93e>] ? pipe_lock+0x1c/0x1e
[  468.669983]  [<ffffffff812c5830>] xfs_file_write_iter+0x83/0x107
[  468.669983]  [<ffffffff81187e4c>] vfs_iter_write+0x4c/0x6b
[  468.669983]  [<ffffffff811afdfb>] iter_file_splice_write+0x230/0x33a
[  468.669983]  [<ffffffff811b06a4>] SyS_splice+0x409/0x55e
[  468.669983]  [<ffffffff811a1167>] ? __fd_install+0x9f/0xab
[  468.669983]  [<ffffffff810c3c63>] ? trace_hardirqs_on_caller+0x164/0x19b
[  468.669983]  [<ffffffff816f5f09>] system_call_fastpath+0x12/0x17

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
