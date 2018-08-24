Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:58000 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbeHYDOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 23:14:46 -0400
Date: Fri, 24 Aug 2018 16:37:57 -0700
From: Andi Kleen <andi@firstfloor.org>
Subject: Trying to write to read-only block-device from XFS
Message-ID: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


Seen this a few times now with recent kernels:

[81416.847584] ------------[ cut here ]------------
[81416.848108] generic_make_request: Trying to write to read-only
block-device dm-3 (partno 0)
[81416.848613] WARNING: CPU: 6 PID: 1118 at block/blk-core.c:2161
generic_make_request_checks+0x36b/0x410
[81416.849123] Modules linked in: xfs x86_pkg_temp_thermal crc32c_intel
[81416.849635] CPU: 6 PID: 1118 Comm: umount Not tainted
4.18.0-01517-g958f338e96f8-dirty #1778
[81416.850736] RIP: 0010:generic_make_request_checks+0x36b/0x410
[81416.851264] Code: ad 14 03 00 00 48 8d 75 b0 48 89 df c6 05 bc fb f6
00 01 e8 e7 63 01 00 48 c7 c7 00 bb 09 82 44 89 ea 48 89 c6 e8 5c 2d d1
ff <0f> 0b 4c 8b 6b 08 e9 25 fd ff ff 65 8b 05 e3 ce c5 7e 89 c0 48 0f
[81416.852398] RSP: 0018:ffffc9000369bc40 EFLAGS: 00010286
[81416.852965] RAX: 0000000000000000 RBX: ffff880454ea1240 RCX:
0000000000000006
[81416.853537] RDX: 0000000000000007 RSI: 0000000000000086 RDI:
ffff88046ed95550
[81416.854145] RBP: ffffc9000369bca0 R08: 0000000000000000 R09:
00000000000002b7
[81416.854718] R10: 0000000000000001 R11: 00000000ffffffff R12:
0000000000000000
[81416.855273] R13: 0000000000000000 R14: 0000000000000001 R15:
ffff880456d688e0
[81416.855824] FS:  00007f9277f9efc0(0000) GS:ffff88046ed80000(0000)
knlGS:0000000000000000
[81416.856383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[81416.856947] CR2: 00007f92777d77b0 CR3: 0000000456ed4004 CR4:
00000000003606e0
[81416.857517] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[81416.858089] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[81416.858701] Call Trace:
[81416.859268]  ? kmem_cache_alloc+0xa2/0x180
[81416.859828]  generic_make_request+0x5b/0x3a0
[81416.860381]  ? mempool_alloc+0x71/0x180
[81416.860935]  ? check_preempt_curr+0x79/0x90
[81416.861485]  submit_bio+0x49/0x130
[81416.862032]  submit_bio_wait+0x59/0x90
[81416.862632]  blkdev_issue_flush+0x85/0xb0
[81416.863189]  xfs_blkdev_issue_flush+0x19/0x20 [xfs]
[81416.863742]  xfs_free_buftarg+0x36/0x50 [xfs]
[81416.864284]  xfs_close_devices+0x5e/0x70 [xfs]
[81416.864816]  xfs_fs_put_super+0x86/0xb0 [xfs]
[81416.865340]  generic_shutdown_super+0x6d/0x110
[81416.865855]  kill_block_super+0x27/0x50
[81416.866428]  deactivate_locked_super+0x35/0x70
[81416.866949]  deactivate_super+0x51/0x60
[81416.867470]  cleanup_mnt+0x3f/0x70
[81416.867975]  __cleanup_mnt+0x12/0x20
[81416.868476]  task_work_run+0x9d/0xc0
[81416.868977]  exit_to_usermode_loop+0xb8/0xc0
[81416.869468]  do_syscall_64+0xd3/0x100
[81416.869964]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[81416.870513] RIP: 0033:0x7f9277881867
[81416.871010] Code: b6 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44
00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 01 b6 2b 00 f7 d8 64 89 01 48
