Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K8N1Br044279 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 03:23:02 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87E681949A70
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:24:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	d1S9EHny2bBvXtk3 for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 01:24:13 -0700 (PDT)
Date: Wed, 20 Oct 2010 19:24:09 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: XFS bad inode magic/vsn daddr 64 #8 (magic=5858)
Message-ID: <20101020082409.GA5415@amd>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi, I keep hitting this bug running xfstests, and managed to
reproduce it several times on current vanilla upstream kernel
too, below is one trace.

Nothing special about the xfstests run, except that it is run
on brd device for both the test and the scratch mounts. No
special mount options or mkfs flags. It seems pretty reproducable
though, triggering every time I've run the tests like this.

I didn't narrow down the test that causes the bug because it
keeps running other tests and then eventually hanging. Any hints
to narrow it down?

Thanks,
Nick

[ 1161.193017] Device ram1 - bad inode magic/vsn daddr 64 #8
(magic=5858)
[ 1161.193200] ------------[ cut here ]------------
[ 1161.193359] kernel BUG at fs/xfs/support/debug.c:61!
[ 1161.193518] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1161.193953] last sysfs file:
/sys/devices/virtual/block/ram1/removable
[ 1161.194004] CPU 3
[ 1161.194004] Modules linked in: ext2 xfs exportfs brd [last unloaded:
scsi_wait_scan]
[ 1161.194004]
[ 1161.194004] Pid: 2599, comm: mount Not tainted 2.6.36-rc8+ #16
S5520UR/S5520UR
[ 1161.194004] RIP: 0010:[<ffffffffa00aa049>]  [<ffffffffa00aa049>]
cmn_err+0xd9/0xe0 [xfs]
[ 1161.194004] RSP: 0018:ffff880134965a58  EFLAGS: 00010246
[ 1161.194004] RAX: ffff880134965fd8 RBX: 0000000000000000 RCX: 0000000000000000
[ 1161.194004] RDX: 00000000000000d8 RSI: 0000000000000000 RDI: 0000000000000001
[ 1161.194004] RBP: ffff880134965ac8 R08: 0000000000000000 R09: 0000000000000000[
1161.194004] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000286
[ 1161.194004] R13: ffffffffa00ba480 R14: 0000000000000040 R15: ffff8801c02db860
[ 1161.194004] FS: 00007f5357eff7e0(0000) GS:ffff880132c20000(0000) knlGS:0000000000000000
[ 1161.194004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1161.194004] CR2: 0000000001fa9788 CR3: 0000000140adf000 CR4: 00000000000006e0
[ 1161.194004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1161.194004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1161.194004] Process mount (pid: 2599, threadinfo ffff880134964000, task ffff88013424be80)
[ 1161.194004] Stack:
[ 1161.194004]  ffff880100000030 ffff880134965ad8 ffff880134965a78
ffff88012dd0109c
[ 1161.194004] <0> 00000000000000b5 0000000000005858 ffff880134965b18 0000000000000040
[ 1161.194004] <0> 0000000000000008 0000000000005858 ffff88012d4452d0 0000000000000008
[ 1161.194004] Call Trace:
[ 1161.194004]  [<ffffffffa00724d6>] xfs_imap_to_bp+0x166/0x240 [xfs]
[ 1161.194004]  [<ffffffffa00756c3>] ? xfs_iread+0x83/0x200 [xfs]
[ 1161.194004]  [<ffffffffa00756c3>] xfs_iread+0x83/0x200 [xfs]
[ 1161.194004]  [<ffffffffa006ea22>] xfs_iget+0x3c2/0x970 [xfs]
[ 1161.194004]  [<ffffffffa008bb31>] xfs_mountfs+0x391/0x780 [xfs]
[ 1161.194004]  [<ffffffffa0069100>] ? xfs_fstrm_free_func+0x0/0x1d0
[xfs]
[ 1161.194004]  [<ffffffffa008c6ed>] ? xfs_mru_cache_create+0x18d/0x1c0
[xfs]
[ 1161.194004]  [<ffffffffa00a7ee4>] xfs_fs_fill_super+0x1f4/0x3d0 [xfs]
[ 1161.194004]  [<ffffffff811788aa>] ? disk_name+0xba/0xc0
[ 1161.194004]  [<ffffffff8111310f>] get_sb_bdev+0x18f/0x1d0
[ 1161.194004]  [<ffffffffa00a7cf0>] ? xfs_fs_fill_super+0x0/0x3d0 [xfs]
[ 1161.194004]  [<ffffffffa00a58a3>] xfs_fs_get_sb+0x13/0x20 [xfs]
[ 1161.194004]  [<ffffffff811116f5>] vfs_kern_mount+0x65/0x150
[ 1161.194004]  [<ffffffff8111184d>] do_kern_mount+0x4d/0x130
[ 1161.194004]  [<ffffffff815bbeca>] ? _lock_kernel+0x6a/0x1a0
[ 1161.194004]  [<ffffffff8112dbf7>] do_mount+0x2d7/0x870
[ 1161.194004]  [<ffffffff810dbbe3>] ? strndup_user+0x53/0x70
[ 1161.194004]  [<ffffffff8112e9c3>] sys_mount+0x93/0xe0
[ 1161.194004]  [<ffffffff810030ab>] system_call_fastpath+0x16/0x1b
[ 1161.194004] Code: c7 e0 a6 0c a0 e8 78 18 51 e1 85 db 74 1d 48 83 c4
58 5b 41 5c 41 5d c9 c3 66 0f 1f 84 00 00 00 00 00 c6 82 c0 83 0d a0 00
eb b0 <0f> 0b eb fe 90 90 90 55 48 85 ff 48 89 e5 74 37 80 3f 00 75 32
[ 1161.194004] RIP  [<ffffffffa00aa049>] cmn_err+0xd9/0xe0 [xfs]
[ 1161.194004]  RSP <ffff880134965a58>
[ 1161.208585] ---[ end trace c4cb90fb4c1c6dc9 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
