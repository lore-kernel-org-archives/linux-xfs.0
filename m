Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n51FMgxH016777 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 10:22:42 -0500
Received: from mail-bw0-f226.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76084148B17F
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2009 08:29:20 -0700 (PDT)
Received: from mail-bw0-f226.google.com (mail-bw0-f226.google.com
	[209.85.218.226]) by cuda.sgi.com with ESMTP id
	dfy5BBVVZX8Ru2km for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2009 08:29:20 -0700 (PDT)
Received: by bwz26 with SMTP id 26so7151114bwz.20
	for <xfs@oss.sgi.com>; Mon, 01 Jun 2009 08:22:57 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 19:22:56 +0400
Message-ID: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
Subject: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

Hi

Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4846
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:109!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0
Modules linked in:
Pid: 30665, comm: emerge Not tainted 2.6.30-rc6-00144-g5805977 #1 PowerEdge 1950
RIP: 0010:[<ffffffff8043abeb>]  [<ffffffff8043abeb>] assfail+0x2b/0x30
RSP: 0018:ffff8800303c1b98  EFLAGS: 00010246
RAX: 0000000000000054 RBX: 0000000000000000 RCX: 0000000000000301
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff8800303c1ba8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000800000000
R13: ffff880078c0ccc0 R14: 0000000000000002 R15: ffff88007eb3f000
FS:  00007f7e92dbc6f0(0000) GS:ffff880005000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001b0a024 CR3: 0000000074cb0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process emerge (pid: 30665, threadinfo ffff8800303c0000, task ffff88007e335e10)
Stack:
 ffff8800051cefa0 00000000780d89a3 ffff8800303c1d88 ffffffff803d6bad
 ffffffff804c9ad8 ffffffff814497f8 ffff880045a72000 ffff880045a72aa8
 ffffffff81449800 0000000000000000 0000000000000000 00000000780d89a3
Call Trace:
 [<ffffffff803d6bad>] xfs_bmapi+0xad/0x1ad0
 [<ffffffff804c9ad8>] ? _atomic_dec_and_lock+0x88/0xb0
 [<ffffffff8042ef97>] ? xfs_buf_free+0xd7/0x130
 [<ffffffff806d987f>] ? _spin_unlock+0x3f/0x80
 [<ffffffff8042f114>] ? xfs_buf_rele+0x124/0x190
 [<ffffffff8042df2d>] ? xfs_buf_unlock+0x3d/0x80
 [<ffffffff80421e69>] ? xfs_trans_brelse+0x219/0x2e0
 [<ffffffff803e445f>] ? xfs_da_brelse+0x7f/0x150
 [<ffffffff803ee5c0>] xfs_dir2_leaf_getdents+0x640/0x7b0
 [<ffffffff802ec220>] ? filldir+0x0/0x100
 [<ffffffff802ec220>] ? filldir+0x0/0x100
 [<ffffffff803e975c>] xfs_readdir+0x12c/0x140
 [<ffffffff802ec220>] ? filldir+0x0/0x100
 [<ffffffff80430b57>] xfs_file_readdir+0x47/0x70
 [<ffffffff802ec500>] vfs_readdir+0xd0/0xf0
 [<ffffffff802ec6b6>] sys_getdents+0x96/0x110
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
Code: 55 89 d1 48 89 e5 48 89 f2 48 83 ec 10 48 89 fe 65 48 8b 04 25
28 00 00 00 48 89 45 f8 31 c0 48 c7 c7 38 73 83 80 e8 25 a4 29 00 <0f>
0b eb fe 90 55 48 89 e5 41 57 49 89 d7 41 56 41 55 49 89 cd
RIP  [<ffffffff8043abeb>] assfail+0x2b/0x30
 RSP <ffff8800303c1b98>
---[ end trace bf7e45980908c8f7 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
