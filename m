Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8E7mLUc125385 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 02:48:21 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7F371C0E551
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 00:48:19 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 0pAZiRyjPjkxshZD
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 00:48:19 -0700 (PDT)
Message-ID: <4E705C42.6020909@profihost.ag>
Date: Wed, 14 Sep 2011 09:48:18 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <4E70571A.80108@profihost.ag>
In-Reply-To: <4E70571A.80108@profihost.ag>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, aelder@sgi.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

>> Oops, that's a bug that I actually introduced myself. Fix below:
>
> Thanks for the patch.
>
> Now we have the following situation:
>
> 1.) Systems running fine with 2.6.32, 2.6.38 and with 3.1 rc-6 + patch
> 2.) Sadly it does not run with 3.0.4 for more than 1 hour. And 3.0.X
> will become the next long term stable. So there will be a lot of people
> using it.
> 3.) I have seen this deadlock on systems with aacraid and with intel
> ahci onboard. (that's all we're using)
> 4.) I still write to other devices / raids on the same controller while
> the XFS root filesystem hangs.

Sadly it was now crashing with  3.1 rc-6 + patch again. Sorry i was to 
fast to write you an email.

Hung Task detection showed me this with 3.1 rc-6:

[] ? might_fault+0x3b/0x88
[] do_filp_open+0x38/0x86
[] ? _raw_spin_unlock+0x26/0x2b
[] ? alloc_fd+0x11d/0x12e
[] do_sys_open+0x114/0x1a3
[] sys_open+0x1b/0x1d
[] system_call_fastpath+0x16/0x1b
1 lock held by mysqld/17058:
#0: (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [] do_last+0x287/0x693
INFO: task qmail-send:4899 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
qmail-send D 0000000000000000 0 4899 1 0x00020000
ffff88081c4afc38 0000000000000046 ffffffff814a52d5 0000000100000000
ffff88082cf5be70 ffff88081c4ae010 0000000000004000 ffff88082cf5b5d0
0000000000011c40 ffff88081c4affd8 ffff88081c4affd8 0000000000011c40
Call Trace:
[] ? __schedule+0x2e8/0x9fd
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_remove+0x136/0x34e
[] ? mutex_lock_nested+0x275/0x290
[] ? mutex_lock_nested+0x281/0x290
[] ? vfs_unlink+0x51/0xdd
[] xfs_vn_unlink+0x3c/0x75
[] vfs_unlink+0x69/0xdd
[] do_unlinkat+0xde/0x170
[] ? retint_swapgs+0xe/0x13
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] ? trace_hardirqs_on_thunk+0x3a/0x3f
[] ? file_free_rcu+0x35/0x35
[] sys_unlink+0x11/0x13
[] ia32_do_call+0x13/0x13
2 locks held by qmail-send/4899:
#0: (&sb->s_type->i_mutex_key#5/1){+.+.+.}, at: [] do_unlinkat+0x63/0x170
#1: (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [] vfs_unlink+0x51/0xdd
INFO: task httpd:6316 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
httpd D 0000000000000001 0 6316 6270 0x00000000
ffff880406edfb78 0000000000000046 ffff88041b792c30 0000000100000000
ffff88041b792c80 ffff880406ede010 0000000000004000 ffff88041b7923e0
0000000000011c40 ffff880406edffd8 ffff880406edffd8 0000000000011c40
Call Trace:
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_create+0x200/0x53a
[] ? d_lookup+0x2d/0x42
2 locks held by httpd/6316:
[] ? __d_lookup+0x16a/0x17c
[] ? __d_lookup+0x16a/0x17c
1 lock held by imap/11461:
INFO: task flush-8:0:3658 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:0 D 000000000000000b 0 3658 2 0x00000000
ffff88082c389690 0000000000000046 ffff88082c8bac30 0000000100000000
ffff88082c8bac58 ffff88082c388010 0000000000004000 ffff88082c8ba3e0
0000000000011c40 ffff88082c389fd8 ffff88082c389fd8 0000000000011c40
Call Trace:
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_iomap_write_allocate+0xcc/0x2cc
[] ? xfs_ilock_nowait+0x66/0xd5
[] ? up_read+0x1e/0x37
[] xfs_map_blocks+0x159/0x1ee
[] xfs_vm_writepage+0x21e/0x3f9
[] __writepage+0x15/0x3b
[] write_cache_pages+0x28c/0x3a8
[] ? alloc_pages_exact_nid+0x9a/0x9a
[] generic_writepages+0x46/0x61
[] xfs_vm_writepages+0x45/0x4e
[] do_writepages+0x1f/0x28
[] writeback_single_inode+0x18f/0x387
[] writeback_sb_inodes+0x196/0x237
[] ? grab_super_passive+0x52/0x76
[] __writeback_inodes_wb+0x73/0xb6
[] wb_writeback+0x163/0x24b
[] ? trace_hardirqs_on+0xd/0xf
[] ? local_bh_enable_ip+0xbc/0xc1
[] wb_do_writeback+0x183/0x210
[] bdi_writeback_thread+0xc0/0x1e4
[] ? wb_do_writeback+0x210/0x210
[] kthread+0x81/0x89
[] kernel_thread_helper+0x4/0x10
[] ? finish_task_switch+0x45/0xc3
[] ? retint_restore_args+0xe/0xe
[] ? __init_kthread_worker+0x56/0x56
[] ? gs_change+0xb/0xb
1 lock held by flush-8:0/3658:
#0: (&type->s_umount_key#31){++++.+}, at: [] grab_super_passive+0x52/0x76
INFO: task syslogd:4459 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syslogd D 000000000000000c 0 4459 1 0x00000000
ffff88082b4c3d78 0000000000000046 ffffffff814a52d5 ffff88082c8605d8
ffff88082b446ba0 ffff88082b4c2010 0000000000004000 ffff88082b446ba0
0000000000011c40 ffff88082b4c3fd8 ffff88082b4c3fd8 0000000000011c40
Call Trace:
[] ? __schedule+0x2e8/0x9fd
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_file_fsync+0x15f/0x22d
[] vfs_fsync_range+0x18/0x21
[] vfs_fsync+0x17/0x19
[] do_fsync+0x2e/0x44
[] sys_fsync+0xb/0xf
[] system_call_fastpath+0x16/0x1b
no locks held by syslogd/4459.
INFO: task mysqld:4612 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mysqld D 0000000000000000 0 4612 4567 0x00000000
ffff880429a31d78 0000000000000046 ffffffff814a52d5 ffff88082c8605d8
ffff88042cd8d9b0 ffff880429a30010 0000000000004000 ffff88042cd8d9b0
0000000000011c40 ffff880429a31fd8 ffff880429a31fd8 0000000000011c40
Call Trace:
[] ? __schedule+0x2e8/0x9fd
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_file_fsync+0x15f/0x22d
[] vfs_fsync_range+0x18/0x21
[] vfs_fsync+0x17/0x19
[] do_fsync+0x2e/0x44
[] sys_fsync+0xb/0xf
[] system_call_fastpath+0x16/0x1b
no locks held by mysqld/4612.
INFO: task mysqld:27595 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mysqld D 0000000000000008 0 27595 4567 0x00000000
ffff88011dda3ca8 0000000000000046 ffffffff814a52d5 ffff880403cd88a0
0000000000000246 ffff88011dda2010 0000000000004000 ffff880403cd8000
0000000000011c40 ffff88011dda3fd8 ffff88011dda3fd8 0000000000011c40
Call Trace:
[] ? __schedule+0x2e8/0x9fd
[] ? mark_held_locks+0xc9/0xef
[] ? mutex_lock_nested+0x16b/0x290
[] schedule+0x57/0x59
[] mutex_lock_nested+0x173/0x290
[] ? do_last+0x287/0x693
[] do_last+0x287/0x693
[] path_openat+0xcd/0x342
[] ? might_fault+0x3b/0x88
[] do_filp_open+0x38/0x86
[] ? _raw_spin_unlock+0x26/0x2b
[] ? alloc_fd+0x11d/0x12e
[] do_sys_open+0x114/0x1a3
[] sys_open+0x1b/0x1d
[] system_call_fastpath+0x16/0x1b
1 lock held by mysqld/27595:
#0: (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [] do_last+0x287/0x693
INFO: task mysqld:4873 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mysqld D 0000000000000000 0 4873 4625 0x00000000
ffff88081bf61d78 0000000000000046 ffffffff814a52d5 0000000100000000
ffff88081e82f3f0 ffff88081bf60010 0000000000004000 ffff88081e82eba0
0000000000011c40 ffff88081bf61fd8 ffff88081bf61fd8 0000000000011c40
Call Trace:
[] ? __schedule+0x2e8/0x9fd
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_file_fsync+0x15f/0x22d
[] vfs_fsync_range+0x18/0x21
[] vfs_fsync+0x17/0x19
[] do_fsync+0x2e/0x44
[] sys_fsync+0xb/0xf
[] system_call_fastpath+0x16/0x1b
no locks held by mysqld/4873.
INFO: task mysqld:17058 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mysqld D 000000000000000c 0 17058 4625 0x00000000
ffff88010325fa88 0000000000000046 ffffffff814a52d5 0000000100000000
ffff88025be8f418 ffff88010325e010 0000000000004000 ffff88025be8eba0
0000000000011c40 ffff88010325ffd8 ffff88010325ffd8 0000000000011c40
Call Trace:
[] ? __schedule+0x2e8/0x9fd
[] ? mark_held_locks+0xc9/0xef
[] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[] ? trace_hardirqs_on_caller+0x11c/0x153
[] schedule+0x57/0x59
[] xlog_grant_log_space+0x18e/0x4ae
[] ? try_to_wake_up+0x330/0x330
[] xfs_log_reserve+0x11a/0x122
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_create+0x200/0x53a
[] ? __d_lookup+0xbe/0x17c
[] ? __d_lookup+0x16a/0x17c
[] ? d_validate+0x96/0x96
[] xfs_vn_mknod+0x9a/0xf5
[] xfs_vn_create+0xb/0xd
[] vfs_create+0x72/0xa4
[] do_last+0x323/0x693
[] path_openat+0xcd/0x342


Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
