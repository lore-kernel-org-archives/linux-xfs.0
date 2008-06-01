Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 13:27:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m51KRZqj029204
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 13:27:36 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9094179151B
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2008 13:28:27 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156]) by cuda.sgi.com with ESMTP id 0bxMG9S2G6W8vMz8 for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 13:28:27 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so619237fgb.8
        for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 13:28:26 -0700 (PDT)
Date: Sun, 1 Jun 2008 23:28:16 +0300
From: Roman Kravchenko <roman@atech.lv>
Message-ID: <1562332443.20080601232816@atech.lv>
Subject: xfs write locks
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello Xfs,

  Not sure if i have to report it this way... but anyway, at least it
  will be informative.

  I have problems with XFS file system with quota support. It
  sometimes freeze on write operations to filesystem. It's rare,
  freeze ocurring after a week or two of normal opetaion. I experience
  it since 2.6.23 series kernel and unable to track it down to get
  more detailed info...

  It's possible that it related to locking, as filesystem is still
  accesible for read operations. But I unable to recover additional
  info and just recently recompiled kernel with debug info to track it
  down.

  so far the only info I get is this INFO warning on boot:

=============================================
[ INFO: possible recursive locking detected ]
2.6.25.4-g6dbg #1
---------------------------------------------
mysqld/1883 is trying to acquire lock:
 (&list->qh_lock){--..}, at: [<c0255308>] xfs_qm_dqget+0x288/0x370

but task is already holding lock:
 (&list->qh_lock){--..}, at: [<c025513d>] xfs_qm_dqget+0xbd/0x370

other info that might help us debug this:
3 locks held by mysqld/1883:
 #0:  (&type->i_mutex_dir_key#2){--..}, at: [<c017f3f1>] open_namei+0xf1/0x5f0
 #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<c028d84f>] xfs_ilock+0x8f/0xd0
 #2:  (&list->qh_lock){--..}, at: [<c025513d>] xfs_qm_dqget+0xbd/0x370

stack backtrace:
Pid: 1883, comm: mysqld Not tainted 2.6.25.4-g6dbg #1
 [<c014310d>] __lock_acquire+0xe5d/0x1080
 [<c0142626>] __lock_acquire+0x376/0x1080
 [<c01433b7>] lock_acquire+0x87/0xb0
 [<c0255308>] xfs_qm_dqget+0x288/0x370
 [<c0591f6e>] mutex_lock_nested+0x9e/0x280
 [<c0255308>] xfs_qm_dqget+0x288/0x370
 [<c0255308>] xfs_qm_dqget+0x288/0x370
 [<c0255308>] xfs_qm_dqget+0x288/0x370
 [<c02594f2>] xfs_qm_dqattach_one+0xd2/0x1a0
 [<c0259762>] xfs_qm_dqattach+0x1a2/0x1d0
 [<c0259a88>] xfs_qm_vop_dqalloc+0x248/0x300
 [<c02af109>] xfs_create+0xa9/0x490
 [<c010849b>] native_sched_clock+0x7b/0xd0
 [<c02ba9b9>] xfs_vn_mknod+0x159/0x1a0
 [<c017d059>] vfs_create+0xc9/0x120
 [<c017f850>] open_namei+0x550/0x5f0
 [<c017268e>] do_filp_open+0x2e/0x60
 [<c0593414>] _spin_unlock+0x14/0x20
 [<c0172405>] get_unused_fd_flags+0xc5/0xe0
 [<c017270c>] do_sys_open+0x4c/0xe0
 [<c017281c>] sys_open+0x2c/0x40
 [<c0102f2e>] syscall_call+0x7/0xb
 =======================

 If there is any additional info that might help you, I'm gladly provide
 it to you.

-- 
Best regards,
 Roman Kravchenko
 A Technologies
