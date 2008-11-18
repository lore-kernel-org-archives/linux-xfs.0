Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAI1h42Z010844 for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 17:43:04 -0800
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id CB8588F804E
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2008 17:42:59 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id MAA29028 for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 12:42:57 +1100
Message-ID: <49221D83.6030406@sgi.com>
Date: Tue, 18 Nov 2008 12:42:27 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: assertion failed in xfs_reclaim_inodes_ag()
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Hit this while running stress tests.  Looks like an inode is tagged with
XFS_ICI_RECLAIM_TAG but not XFS_IRECLAIMABLE|XFS_IRECLAIM.  I can't see
how that can happen.

Nov 17 21:51:42 wipeout kernel: [18577.060078] Assertion failed: xfs_iflags_test(ip, (XFS_IRECLAIMABLE|XFS_IRECLAIM)), file: fs/xfs/linux-2.6/xfs_sync.c, line: 710
Nov 17 21:51:42 wipeout kernel: [18577.060094] ------------[ cut here ]------------
Nov 17 21:51:42 wipeout kernel: [18577.060251] kernel BUG at fs/xfs/support/debug.c:81!
Nov 17 21:51:42 wipeout kernel: [18577.060251] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Nov 17 21:51:42 wipeout kernel: [18577.105062] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/0000:08:00.1/resource
Nov 17 21:51:42 wipeout kernel: [18577.105062] CPU 4
Nov 17 21:51:42 wipeout kernel: [18577.105062] Modules linked in:
Nov 17 21:51:42 wipeout kernel: [18577.105062] Pid: 6446, comm: xfssyncd Not tainted 2.6.28-rc3 #1
Nov 17 21:51:42 wipeout kernel: [18577.105062] RIP: 0010:[<ffffffff811caf65>]  [<ffffffff811caf65>] assfail+0x1a/0x1e
Nov 17 21:51:42 wipeout kernel: [18577.105062] RSP: 0018:ffff88100e521e20  EFLAGS: 00010282
Nov 17 21:51:42 wipeout kernel: [18577.105062] RAX: 0000000000000087 RBX: ffff88100e99ad88 RCX: 0000000000000082
Nov 17 21:51:42 wipeout kernel: [18577.215378] RDX: ffff8800a6725000 RSI: 0000000000000001 RDI: 0000000000000082
Nov 17 21:51:42 wipeout kernel: [18577.215378] RBP: ffff88100e521e20 R08: 0000000000000087 R09: 0000000000000000
Nov 17 21:51:42 wipeout kernel: [18577.215378] R10: 0000000000000000 R11: 0000000000000082 R12: ffff88100e99ad20
Nov 17 21:51:42 wipeout kernel: [18577.215378] R13: 0000000000349ca3 R14: 0000000000000000 R15: 0000000000000000
Nov 17 21:51:42 wipeout kernel: [18577.215378] FS:  0000000000000000(0000) GS:ffff881029e51690(0000) knlGS:0000000000000000
Nov 17 21:51:42 wipeout kernel: [18577.215378] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Nov 17 21:51:42 wipeout kernel: [18577.215378] CR2: 00007faf309f4000 CR3: 000000100a81c000 CR4: 00000000000006a0
Nov 17 21:51:42 wipeout kernel: [18577.215378] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 17 21:51:42 wipeout kernel: [18577.215378] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 17 21:51:42 wipeout kernel: [18577.215378] Process xfssyncd (pid: 6446, threadinfo ffff88100e520000, task ffff8810254fa098)
Nov 17 21:51:42 wipeout kernel: [18577.215378] Stack:
Nov 17 21:51:42 wipeout kernel: [18577.215378]  ffff88100e521e80 ffffffff811c9e1a 0000000200000000 000000020e521e7c
Nov 17 21:51:42 wipeout kernel: [18577.215378]  ffff881023c357f0 ffff881024415bf0 ffff8801ecd70960 ffff881023c357f0
Nov 17 21:51:42 wipeout kernel: [18577.215378]  0000000000000014 0000000000000d20 0000000000000002 0000000000000000
Nov 17 21:51:42 wipeout kernel: [18577.215378] Call Trace:
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff811c9e1a>] xfs_reclaim_inodes_ag+0xbf/0x16b
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff811c9f08>] xfs_reclaim_inodes+0x42/0x60
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff811ca230>] xfs_sync_worker+0x30/0x8a
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff811ca873>] ? xfssyncd+0x95/0x1a2
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff811ca92c>] xfssyncd+0x14e/0x1a2
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff811ca7de>] ? xfssyncd+0x0/0x1a2
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff8104e7a2>] kthread+0x49/0x77
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff8100d009>] child_rip+0xa/0x11
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff8104e759>] ? kthread+0x0/0x77
Nov 17 21:51:42 wipeout kernel: [18577.215378]  [<ffffffff8100cfff>] ? child_rip+0x0/0x11
Nov 17 21:51:42 wipeout kernel: [18577.215378] Code: 6e 81 c7 44 24 08 01 00 00 00 e8 22 a8 04 00 c9 c3 55 89 d1 31 c0 48 89 f2 48 89 fe 48 c7 c7 79 f7 6d 81 48 89 e5 e8 08 13 e7 ff <0f> 0b eb fe 55 83 e7 07 83 ff 07 48 89 e5 41 56 41 55 41 bd 07
Nov 17 21:51:42 wipeout kernel: [18577.215378] RIP  [<ffffffff811caf65>] assfail+0x1a/0x1e
Nov 17 21:51:42 wipeout kernel: [18577.215378]  RSP <ffff88100e521e20>
Nov 17 21:51:42 wipeout kernel: [18577.764403] ---[ end trace 479c4bea846e5978 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
