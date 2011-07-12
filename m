Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6CG56E8040700 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 11:05:06 -0500
Received: from mail.uscreen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31AE563C0D
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 09:05:04 -0700 (PDT)
Received: from mail.uscreen.net (mail.uscreen.net [62.67.233.10]) by
	cuda.sgi.com with ESMTP id 8ku77L4dLgmcGG3D for
	<xfs@oss.sgi.com>; Tue, 12 Jul 2011 09:05:04 -0700 (PDT)
Received: from mail.uscreen.net (unknown [127.0.0.1])
	by mail.uscreen.net (Postfix) with ESMTP id 9903D137C0D3
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 18:05:03 +0200 (CEST)
Received: from [192.168.23.88] (unknown [78.94.64.127])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.uscreen.net (Postfix) with ESMTP id 4A7C7137C0D1
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 18:05:03 +0200 (CEST)
Message-ID: <4E1C70AD.1010101@u-club.de>
Date: Tue, 12 Jul 2011 18:05:01 +0200
From: Christoph <cr2005@u-club.de>
MIME-Version: 1.0
Subject: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
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

Hi!

I'd like you to have a look into this issue:

pm-hibernate locks up when using xfs while "Preallocating image memory".

https://bugzilla.kernel.org/show_bug.cgi?id=33622

I got at least this backtrace (2.6.39.3)

tia

chris



SysRq : Show Blocked State

pm-hibernate    D 0000000000000000     0  3638   3637 0x00000000
 ffff8800017bf918 0000000000000082 ffff8800017be010 ffff880000000000
 ffff8800017be010 ffff88000b8a6170 0000000000013900 ffff8800017bffd8
 ffff8800017bffd8 0000000000013900 ffffffff8148b020 ffff88000b8a6170
Call Trace:
 [<ffffffff81344ce2>] schedule_timeout+0x22/0xbb
 [<ffffffff81344b64>] wait_for_common+0xcb/0x148
 [<ffffffff810408ea>] ? try_to_wake_up+0x18c/0x18c
 [<ffffffff81345527>] ? down_write+0x2d/0x31
 [<ffffffff81344c7b>] wait_for_completion+0x18/0x1a
 [<ffffffffa02374da>] xfs_reclaim_inode+0x74/0x258 [xfs]
 [<ffffffffa0237853>] xfs_reclaim_inodes_ag+0x195/0x264 [xfs]
 [<ffffffffa0237974>] xfs_reclaim_inode_shrink+0x52/0x90 [xfs]
 [<ffffffff810c4e21>] shrink_slab+0xdb/0x151
 [<ffffffff810c625a>] do_try_to_free_pages+0x204/0x39a
 [<ffffffff8134ce4e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff810c647f>] shrink_all_memory+0x8f/0xa8
 [<ffffffff810cc41a>] ? next_online_pgdat+0x20/0x41
 [<ffffffff8107937d>] hibernate_preallocate_memory+0x1c4/0x30f
 [<ffffffff811a8fa2>] ? kobject_put+0x47/0x4b
 [<ffffffff81077eb2>] hibernation_snapshot+0x45/0x281
 [<ffffffff810781bf>] hibernate+0xd1/0x1b8
 [<ffffffff81076c58>] state_store+0x57/0xce
 [<ffffffff811a8d0b>] kobj_attr_store+0x17/0x19
 [<ffffffff81152bda>] sysfs_write_file+0xfc/0x138
 [<ffffffff810fca74>] vfs_write+0xa9/0x105
 [<ffffffff810fcb89>] sys_write+0x45/0x6c
 [<ffffffff8134c492>] system_call_fastpath+0x16/0x1b

kworker/0:2     D 0000000000000000     0   379      2 0x00000000
 ffff88000ea99b90 0000000000000046 ffff88000b8ff840 0000000000000000
 ffff88000ea98010 ffff88000c319ac0 0000000000013900 ffff88000ea99fd8
 ffff88000ea99fd8 0000000000013900 ffffffff8148b020 ffff88000c319ac0
Call Trace:
 [<ffffffff8134515f>] __mutex_lock_common+0x12e/0x195
 [<ffffffff813451da>] __mutex_lock_slowpath+0x14/0x16
 [<ffffffff813452a8>] mutex_lock+0x1e/0x38
 [<ffffffffa0237738>] xfs_reclaim_inodes_ag+0x7a/0x264 [xfs]
 [<ffffffffa02379cc>] ? xfs_reclaim_inodes+0x1a/0x1a [xfs]
 [<ffffffffa02379ca>] xfs_reclaim_inodes+0x18/0x1a [xfs]
 [<ffffffffa02379e9>] xfs_reclaim_worker+0x1d/0x29 [xfs]
 [<ffffffff81059ec4>] process_one_work+0x1de/0x2ec
 [<ffffffff8105bf60>] worker_thread+0x13d/0x262
 [<ffffffff8105be23>] ? manage_workers+0x194/0x194
 [<ffffffff8105f25a>] kthread+0x7d/0x85
 [<ffffffff8134d5a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105f1dd>] ? kthread_worker_fn+0x148/0x148
 [<ffffffff8134d5a0>] ? gs_change+0x13/0x13

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
