Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52BWHH4094353 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 06:32:17 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C1C72C61B9
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 04:32:33 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	vUAqDc9jvMBuRJUi for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2009 04:32:33 -0700 (PDT)
Received: by fxm25 with SMTP id 25so7705757fxm.20
	for <xfs@oss.sgi.com>; Tue, 02 Jun 2009 04:32:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a4423d670906020121v131c9c12t35c3ffc7df048ee9@mail.gmail.com>
References: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
	<B5660F1A-7940-4E4A-92E8-8C0F93C274BD@sgi.com>
	<a4423d670906011038qd809ebay22aebca5aaf271a4@mail.gmail.com>
	<D7FB8214-6C2B-4D13-9B50-C53CB74885C2@sgi.com>
	<a4423d670906020121v131c9c12t35c3ffc7df048ee9@mail.gmail.com>
Date: Tue, 2 Jun 2009 15:32:32 +0400
Message-ID: <a4423d670906020432w7d3cb478i6df2b6a844640edb@mail.gmail.com>
Subject: Re: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

Again similar trace:

Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4846
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:109!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0
Modules linked in:
Pid: 1988, comm: emerge Not tainted 2.6.30-rc7-00227-gd9244b5 #66 PowerEdge 1950
RIP: 0010:[<ffffffff8043ac1b>]  [<ffffffff8043ac1b>] assfail+0x2b/0x30
RSP: 0018:ffff88006db6bb98  EFLAGS: 00010246
RAX: 0000000000000054 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880077336558 RDI: 0000000010000000
RBP: ffff88006db6bba8 R08: ffff880077335e10 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000800000000
R13: ffff8800581f2980 R14: 0000000000000002 R15: ffff88007eb87000
FS:  00007f63e31586f0(0000) GS:ffff880005000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001d04024 CR3: 000000005a70e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process emerge (pid: 1988, threadinfo ffff88006db6a000, task ffff880077335e10)
Stack:
 ffff88006db6bbd8 00000000b772307d ffff88006db6bd88 ffffffff803d6bdd
 ffff880077335e10 ffffffff802d429b ffff880050450480 ffff88007e32e800
 ffff88006db6bc08 ffffffff80280e6d 0000000000000000 00000000b772307d
Call Trace:
 [<ffffffff803d6bdd>] xfs_bmapi+0xad/0x1ad0
 [<ffffffff802d429b>] ? kmem_cache_free+0xbb/0x140
 [<ffffffff80280e6d>] ? trace_hardirqs_on_caller+0x17d/0x1e0
 [<ffffffff8042efc7>] ? xfs_buf_free+0xd7/0x130
 [<ffffffff806d994f>] ? _spin_unlock+0x3f/0x80
 [<ffffffff8042f144>] ? xfs_buf_rele+0x124/0x190
 [<ffffffff8042df5d>] ? xfs_buf_unlock+0x3d/0x80
 [<ffffffff80421e99>] ? xfs_trans_brelse+0x219/0x2e0
 [<ffffffff803e448f>] ? xfs_da_brelse+0x7f/0x150
 [<ffffffff803ee5f0>] xfs_dir2_leaf_getdents+0x640/0x7b0
 [<ffffffff802ec270>] ? filldir+0x0/0x100
 [<ffffffff802ec270>] ? filldir+0x0/0x100
 [<ffffffff803e978c>] xfs_readdir+0x12c/0x140
 [<ffffffff802ec270>] ? filldir+0x0/0x100
 [<ffffffff80430b87>] xfs_file_readdir+0x47/0x70
 [<ffffffff802ec550>] vfs_readdir+0xd0/0xf0
 [<ffffffff802ec706>] sys_getdents+0x96/0x110
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
Code: 55 89 d1 48 89 e5 48 89 f2 48 83 ec 10 48 89 fe 65 48 8b 04 25
28 00 00 00 48 89 45 f8 31 c0 48 c7 c7 78 73 83 80 e8 c5 a4 29 00 <0f>
0b eb fe 90 55 48 89 e5 41 57 49 89 d7 41 56 41 55 49 89 cd
RIP  [<ffffffff8043ac1b>] assfail+0x2b/0x30
 RSP <ffff88006db6bb98>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
