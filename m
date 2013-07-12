Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51BE67F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 21:39:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C50D30404E
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:39:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id z4K6TouYFpkpw3O0 for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:39:39 -0700 (PDT)
Date: Thu, 11 Jul 2013 22:39:30 -0400
From: Dave Jones <davej@redhat.com>
Subject: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
	fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130712023930.GA6473@redhat.com>
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
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com

Just saw this during boot after an unclean shutdown. It hung afterwards.

[   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
[   97.164646] ------------[ cut here ]------------
[   97.165312] kernel BUG at fs/xfs/xfs_message.c:108!
[   97.165986] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   97.166947] Modules linked in: snd_hda_codec_realtek pcspkr usb_debug snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp snd_page_alloc pps_core snd_timer snd soundcore xfs libcrc32c
[   97.170782] CPU: 3 PID: 341 Comm: rpcbind Not tainted 3.10.0+ #49
[   97.173684] task: ffff880235d14a40 ti: ffff880235dae000 task.ti: ffff880235dae000
[   97.173701] RIP: 0010:[<ffffffffa002a362>]  [<ffffffffa002a362>] assfail+0x22/0x30 [xfs]
[   97.173702] RSP: 0018:ffff880235dafa98  EFLAGS: 00010296
[   97.173703] RAX: 0000000000000060 RBX: ffff880235dafb20 RCX: 0000000000000006
[   97.173703] RDX: 00000000000031e0 RSI: ffff880235d152a0 RDI: ffff880235d14a40
[   97.173704] RBP: ffff880235dafa98 R08: 0000000000000002 R09: 0000000000000000
[   97.173704] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880235e54000
[   97.173705] R13: 0000000000035e92 R14: ffff880235dafc88 R15: ffff880235dafc28
[   97.173706] FS:  00007fa6aac79840(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[   97.173706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   97.173707] CR2: 00007fffb1905f18 CR3: 0000000235ce5000 CR4: 00000000001407e0
[   97.173707] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   97.173708] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   97.173708] Stack:
[   97.173712]  ffff880235dafb00 ffffffffa0076953 ffffe8ffffc066a0 ffff880240e04ca8
[   97.173713]  0000000000000250 0000000000000020 ffff88023d05af40 ffff880235dafb20
[   97.173715]  ffff880235a14a40 ffff880235e54000 0000000000035e92 ffff880235dafc88
[   97.173715] Call Trace:
[   97.173730]  [<ffffffffa0076953>] xfs_dir2_sf_addname+0x43/0x760 [xfs]
[   97.173743]  [<ffffffffa0067cfc>] xfs_dir_createname+0x15c/0x1b0 [xfs]
[   97.173754]  [<ffffffffa002f2dc>] xfs_create+0x4cc/0x710 [xfs]
[   97.173764]  [<ffffffffa00278ca>] xfs_vn_mknod+0x9a/0x1c0 [xfs]
[   97.173773]  [<ffffffffa0027a03>] xfs_vn_create+0x13/0x20 [xfs]
[   97.173776]  [<ffffffff811d100d>] vfs_create+0x9d/0x100
[   97.173778]  [<ffffffff811d1995>] do_last+0x925/0xe00
[   97.173780]  [<ffffffff811d1f2e>] path_openat+0xbe/0x6f0
[   97.173783]  [<ffffffff8109e33f>] ? local_clock+0x3f/0x50
[   97.173785]  [<ffffffff811e1b5f>] ? __alloc_fd+0xaf/0x200
[   97.173787]  [<ffffffff811d2c3a>] do_filp_open+0x3a/0x90
[   97.173789]  [<ffffffff811e1b5f>] ? __alloc_fd+0xaf/0x200
[   97.173790]  [<ffffffff811c0ddb>] do_sys_open+0x10b/0x200
[   97.173792]  [<ffffffff81010578>] ? syscall_trace_enter+0x18/0x290
[   97.173794]  [<ffffffff811c0eee>] SyS_open+0x1e/0x20
[   97.173796]  [<ffffffff81717c14>] tracesys+0xdd/0xe2
[   97.173813] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 a8 98 0b a0 31 ff 31 c0 e8 ce fb ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 

This trace repeated a few times, then the same assertion was triggered from sys_renameat.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
