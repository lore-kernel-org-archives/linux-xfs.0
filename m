Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQCbrZO163849 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 06:37:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97CD11DB3F83
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 04:39:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	CjyuGcySdJwW5HA3 for <xfs@oss.sgi.com>;
	Fri, 26 Nov 2010 04:39:31 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	2553143-1927428
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 23:09:29 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1PLxaK-0005d1-5P
	for xfs@oss.sgi.com; Fri, 26 Nov 2010 23:39:28 +1100
Date: Fri, 26 Nov 2010 23:39:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [bug] deadlock in forced shutdown
Message-ID: <20101126123928.GI12187@dastard>
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

Christoph, Alex,

Just so you know, I just had a forced shutdown deadlock like so:

[  276.038251] Filesystem "vdb": xfs_trans_ail_delete_bulk: attempting to delete a log item that is not in the AIL
[  276.039467] xfs_force_shutdown(vdb,0x8) called from line 562 of file fs/xfs/xfs_trans_ail.c.  Return address = 0xffffffff814a0d6a
[  276.041085] Filesystem "vdb": xfs_inactive: xfs_trans_commit() returned error 5
[  276.042848] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on vdb.  Returning error.
[  276.047176] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on vdb.  Returning error.
[  338.176185] SysRq : Show Blocked State
[  338.176785]   task                        PC stack   pid father
[  338.177608] kworker/5:1   D 0000000000000001     0   390      2 0x00000000
[  338.178581]  ffff88011b2898d0 0000000000000046 ffff88011b289830 ffffffff810ae1f8
[  338.179662]  00000000001d2ac0 ffff88011b0ac9c0 ffff88011b0acd28 ffff88011b289fd8
[  338.180024]  ffff88011b0acd30 00000000001d2ac0 ffff88011b288010 00000000001d2ac0
[  338.180024] Call Trace:
[  338.180024]  [<ffffffff810ae1f8>] ? sched_clock_cpu+0xb8/0x110
[  338.180024]  [<ffffffff816ba34e>] ? do_raw_spin_unlock+0x5e/0xb0
[  338.180024]  [<ffffffff81491d42>] _xfs_log_force+0x142/0x2b0
[  338.180024]  [<ffffffff8107e7b0>] ? default_wake_function+0x0/0x20
[  338.180024]  [<ffffffff816ba34e>] ? do_raw_spin_unlock+0x5e/0xb0
[  338.180024]  [<ffffffff81492050>] xfs_log_force_umount+0x1a0/0x2d0
[  338.180024]  [<ffffffff814a887b>] xfs_do_force_shutdown+0x6b/0x1a0
[  338.180024]  [<ffffffff814a0d6a>] ? xfs_trans_ail_delete_bulk+0x13a/0x170
[  338.180024]  [<ffffffff814a0d6a>] xfs_trans_ail_delete_bulk+0x13a/0x170
[  338.180024]  [<ffffffff8147b1de>] xfs_efi_release+0x8e/0xa0
[  338.180024]  [<ffffffff81b19d1b>] ? _raw_spin_unlock+0x2b/0x40
[  338.180024]  [<ffffffff8147b216>] xfs_efd_item_committed+0x26/0x40
[  338.180024]  [<ffffffff8149e9d8>] xfs_trans_committed_bulk+0x78/0x210
[  338.180024]  [<ffffffff8148e57e>] ? xlog_state_do_callback+0x17e/0x3d0
[  338.180024]  [<ffffffff810637c9>] ? kvm_clock_read+0x19/0x20
[  338.180024]  [<ffffffff81041339>] ? sched_clock+0x9/0x10
[  338.180024]  [<ffffffff810ae0d5>] ? sched_clock_local+0x25/0x90
[  338.180024]  [<ffffffff810ae1f8>] ? sched_clock_cpu+0xb8/0x110
[  338.180024]  [<ffffffff810b9c3d>] ? trace_hardirqs_off+0xd/0x10
[  338.180024]  [<ffffffff810ae2bf>] ? local_clock+0x6f/0x80
[  338.180024]  [<ffffffff8148e57e>] ? xlog_state_do_callback+0x17e/0x3d0
[  338.180024]  [<ffffffff814928a2>] xlog_cil_committed+0x32/0xe0
[  338.180024]  [<ffffffff8148e595>] xlog_state_do_callback+0x195/0x3d0
[  338.180024]  [<ffffffff8148e8cd>] xlog_state_done_syncing+0xfd/0x130
[  338.180024]  [<ffffffff8148f2ca>] xlog_iodone+0xba/0x150
[  338.180024]  [<ffffffff814ae416>] xfs_buf_iodone_work+0x26/0x70
[  338.180024]  [<ffffffff8109fa3d>] process_one_work+0x1ad/0x520
[  338.180024]  [<ffffffff8109f9cf>] ? process_one_work+0x13f/0x520
[  338.180024]  [<ffffffff814ae3f0>] ? xfs_buf_iodone_work+0x0/0x70
[  338.180024]  [<ffffffff810a25d2>] worker_thread+0x172/0x400
[  338.180024]  [<ffffffff810a2460>] ? worker_thread+0x0/0x400
[  338.180024]  [<ffffffff810a6f66>] kthread+0xa6/0xb0
[  338.180024]  [<ffffffff8103ae64>] kernel_thread_helper+0x4/0x10
[  338.180024]  [<ffffffff81b1a110>] ? restore_args+0x0/0x30
[  338.180024]  [<ffffffff810a6ec0>] ? kthread+0x0/0xb0
[  338.180024]  [<ffffffff8103ae60>] ? kernel_thread_helper+0x0/0x10

Yes, I know the trigger was a change I was testing, but the deadlock
is caused by the fact we've tried to force the log iduring shutdown
from inside the log IO completion context. It's gone to sleep
waiting on the processing only it can complete. I haven't looked
into this in any detail yet, just wanted to to make sure you guys
know about it...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
