Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BA0BE7CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 11:15:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98E00304032
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 09:15:32 -0700 (PDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	fWxUA4U84UnvjqAw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 09:15:31 -0700 (PDT)
Received: by mail-qc0-f174.google.com with SMTP id m16so3423687qcq.19
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 09:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130511011505.GB32675@dastard>
References: <CAEUQcejFPKDqqwbT_BNFJEVkUeAY=mgYGv-kUvLX6Ys7YQkqfg@mail.gmail.com>
	<518D22F0.8040405@sgi.com> <20130511011505.GB32675@dastard>
Date: Mon, 13 May 2013 21:45:30 +0530
Message-ID: <CAEUQceg6iy=TBrBkhan5bN5vO4y=JGcNy6LGhgfvO-7ereiB=Q@mail.gmail.com>
Subject: Re: Error during bulk removal of files
From: Subranshu Patel <spatel.ml@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

> What 2.6.32 kernel? Output of uname -a?

 uname -a
Linux machine1 2.6.32-279.el6.x86_64 #1 SMP Wed Jun 13 18:24:36 EDT
2012 x86_64 x86_64 x86_64 GNU/Linux

 # cat /etc/issue
Red Hat Enterprise Linux Server release 6.3 (Santiago)

I am using mdtest program to delete 7 million files (of 1KB size).
Total 128 concurrent mdtest process are there. Each process removes
approx 54000 files ( 7 million / 128).
mdtest runs for a while, after that, it gets blocked and does not do
anything. However the machine is still responsive.

dmesg:

May 13 16:27:10 machine1 kernel: INFO: task xfssyncd/dm-3:6838 blocked
for more than 120 seconds.
May 13 16:27:10 machine1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 13 16:27:10 machine1 kernel: xfssyncd/dm-3 D 0000000000000010
0  6838      2 0x00000080
May 13 16:27:10 machine1 kernel: ffff88185d571c70 0000000000000046
ffff88002830fec0 0000000000016680
May 13 16:27:10 machine1 kernel: 0000000000016680 ffff88185975e040
ffff880c61170ae0 ffffffff8160b400
May 13 16:27:10 machine1 kernel: ffff88185975e5f8 ffff88185d571fd8
000000000000fb88 ffff88185975e5f8
May 13 16:27:10 machine1 kernel: Call Trace:
May 13 16:27:10 machine1 kernel: [<ffffffffa056c492>] xlog_wait+0x72/0x90 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81060250>] ?
default_wake_function+0x0/0x20
May 13 16:27:10 machine1 kernel: [<ffffffffa056e08b>]
xlog_grant_log_space+0x3ab/0x520 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa0582d1a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff8127f3ac>] ? random32+0x1c/0x20
May 13 16:27:10 machine1 kernel: [<ffffffffa057d201>] ?
xfs_trans_ail_push+0x21/0x80 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa056e2e6>]
xfs_log_reserve+0xe6/0x140 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa057bad0>]
xfs_trans_reserve+0xa0/0x210 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa055f0a3>]
xfs_fs_log_dummy+0x43/0x90 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa056c9c4>] ?
xfs_log_need_covered+0x94/0xd0 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa0591831>]
xfs_sync_worker+0x81/0x90 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa059171e>] xfssyncd+0x17e/0x210 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa05915a0>] ? xfssyncd+0x0/0x210 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81091d66>] kthread+0x96/0xa0
May 13 16:27:10 machine1 kernel: [<ffffffff8100c14a>] child_rip+0xa/0x20
May 13 16:27:10 machine1 kernel: [<ffffffff81091cd0>] ? kthread+0x0/0xa0
May 13 16:27:10 machine1 kernel: [<ffffffff8100c140>] ? child_rip+0x0/0x20
May 13 16:27:10 machine1 kernel: INFO: task mdtest:7397 blocked for
more than 120 seconds.
May 13 16:27:10 machine1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 13 16:27:10 machine1 kernel: mdtest        D 0000000000000019
0  7397   7395 0x00000080
May 13 16:27:10 machine1 kernel: ffff880c3ce13bf8 0000000000000082
0000000000000000 ffffffff81060262
May 13 16:27:10 machine1 kernel: ffff880c3ce13ba8 ffffffff8104e309
ffff880c3ce13ba8 0000000300000000
May 13 16:27:10 machine1 kernel: ffff880c5d027af8 ffff880c3ce13fd8
000000000000fb88 ffff880c5d027af8
May 13 16:27:10 machine1 kernel: Call Trace:
May 13 16:27:10 machine1 kernel: [<ffffffff81060262>] ?
default_wake_function+0x12/0x20
May 13 16:27:10 machine1 kernel: [<ffffffff8104e309>] ?
__wake_up_common+0x59/0x90
May 13 16:27:10 machine1 kernel: [<ffffffffa056c492>] xlog_wait+0x72/0x90 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81060250>] ?
default_wake_function+0x0/0x20
May 13 16:27:10 machine1 kernel: [<ffffffffa056e08b>]
xlog_grant_log_space+0x3ab/0x520 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa0582d1a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff8127f3ac>] ? random32+0x1c/0x20
May 13 16:27:10 machine1 kernel: [<ffffffffa057d201>] ?
xfs_trans_ail_push+0x21/0x80 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa056e2e6>]
xfs_log_reserve+0xe6/0x140 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa057bad0>]
xfs_trans_reserve+0xa0/0x210 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa058a720>] ?
xfs_tosspages+0x20/0x30 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa05810b4>]
xfs_inactive+0x2e4/0x460 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff814fed1e>] ? mutex_lock+0x1e/0x50
May 13 16:27:10 machine1 kernel: [<ffffffffa058e790>]
xfs_fs_clear_inode+0xa0/0xd0 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81195adc>] clear_inode+0xac/0x140
May 13 16:27:10 machine1 kernel: [<ffffffff81196296>]
generic_delete_inode+0x196/0x1d0
May 13 16:27:10 machine1 kernel: [<ffffffff81196335>]
generic_drop_inode+0x65/0x80
May 13 16:27:10 machine1 kernel: [<ffffffff81195182>] iput+0x62/0x70
May 13 16:27:10 machine1 kernel: [<ffffffff8118b0d2>] do_unlinkat+0x112/0x1c0
May 13 16:27:10 machine1 kernel: [<ffffffff810d69e2>] ?
audit_syscall_entry+0x272/0x2a0
May 13 16:27:10 machine1 kernel: [<ffffffff8100c5b5>] ?
math_state_restore+0x45/0x60
May 13 16:27:10 machine1 kernel: [<ffffffff8118b196>] sys_unlink+0x16/0x20
May 13 16:27:10 machine1 kernel: [<ffffffff8100b0f2>]
system_call_fastpath+0x16/0x1b
May 13 16:27:10 machine1 kernel: INFO: task mdtest:7398 blocked for
more than 120 seconds.
May 13 16:27:10 machine1 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 13 16:27:10 machine1 kernel: mdtest        D 0000000000000008
0  7398   7395 0x00000080
May 13 16:27:10 machine1 kernel: ffff880b79bcbbf8 0000000000000082
ffff880b79bcbb88 ffffffffa0587633
May 13 16:27:10 machine1 kernel: 0000000000000000 0000000000014001
0000000000000010 ffff880b79bcbc90
May 13 16:27:10 machine1 kernel: ffff880c5e6fbaf8 ffff880b79bcbfd8
000000000000fb88 ffff880c5e6fbaf8
May 13 16:27:10 machine1 kernel: Call Trace:
May 13 16:27:10 machine1 kernel: [<ffffffffa0587633>] ?
xfs_buf_get+0x103/0x1a0 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa056c492>] xlog_wait+0x72/0x90 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81060250>] ?
default_wake_function+0x0/0x20
May 13 16:27:10 machine1 kernel: [<ffffffffa056e08b>]
xlog_grant_log_space+0x3ab/0x520 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa0582d1a>] ?
kmem_zone_zalloc+0x3a/0x50 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff8127f3ac>] ? random32+0x1c/0x20
May 13 16:27:10 machine1 kernel: [<ffffffffa057d201>] ?
xfs_trans_ail_push+0x21/0x80 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa056e2e6>]
xfs_log_reserve+0xe6/0x140 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa057bad0>]
xfs_trans_reserve+0xa0/0x210 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa057bdbf>] ?
xfs_trans_alloc+0x9f/0xb0 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffffa057fb93>]
xfs_remove+0x113/0x3a0 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81186fd3>] ?
generic_permission+0x23/0xb0
May 13 16:27:10 machine1 kernel: [<ffffffffa058d6c8>]
xfs_vn_unlink+0x48/0x90 [xfs]
May 13 16:27:10 machine1 kernel: [<ffffffff81188c0f>] vfs_unlink+0x9f/0xe0
May 13 16:27:10 machine1 kernel: [<ffffffff8118795a>] ? lookup_hash+0x3a/0x50
May 13 16:27:10 machine1 kernel: [<ffffffff8118b143>] do_unlinkat+0x183/0x1c0
May 13 16:27:10 machine1 kernel: [<ffffffff810d69e2>] ?
audit_syscall_entry+0x272/0x2a0
May 13 16:27:10 machine1 kernel: [<ffffffff8100c5b5>] ?
math_state_restore+0x45/0x60
May 13 16:27:10 machine1 kernel: [<ffffffff8118b196>] sys_unlink+0x16/0x20
May 13 16:27:10 machine1 kernel: [<ffffffff8100b0f2>]
system_call_fastpath+0x16/0x1b

--
Subranshu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
