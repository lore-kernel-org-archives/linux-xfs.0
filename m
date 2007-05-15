Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 17:53:18 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4F0rFfB031079
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 17:53:15 -0700
Message-ID: <46490478.3010409@goop.org>
Date: Mon, 14 May 2007 17:53:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: 2.6.22-rc1 xfs lockdep messages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

I tend to get this when doing unlinks or rms in xfs:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.22-rc1-paravirt #1382
-------------------------------------------------------
rm/1451 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock/1){--..}, at: [<e1209f9d>] xfs_ilock+0x64/0x8d [xfs]

but task is already holding lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<e1209f9d>] xfs_ilock+0x64/0x8d [xfs]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_lock)->mr_lock){----}:
       [<c0146b33>] __lock_acquire+0xa1f/0xbab
       [<c0146d3a>] lock_acquire+0x7b/0x9f
       [<c013e61b>] down_write_nested+0x3d/0x58
       [<e1209f9d>] xfs_ilock+0x64/0x8d [xfs]
       [<e120a8cd>] xfs_iget_core+0x2bd/0x605 [xfs]
       [<e120acc1>] xfs_iget+0xac/0x133 [xfs]
       [<e1221d2a>] xfs_trans_iget+0xdc/0x142 [xfs]
       [<e120e46f>] xfs_ialloc+0xa5/0x457 [xfs]
       [<e12226f5>] xfs_dir_ialloc+0x6d/0x260 [xfs]
       [<e122812d>] xfs_create+0x2f4/0x5a6 [xfs]
       [<e1232124>] xfs_vn_mknod+0x130/0x1e5 [xfs]
       [<e1232202>] xfs_vn_create+0x12/0x14 [xfs]
       [<c01806b9>] vfs_create+0x9b/0xe5
       [<c0182f4e>] open_namei+0x176/0x593
       [<c0178480>] do_filp_open+0x26/0x3b
       [<c01784d8>] do_sys_open+0x43/0xc7
       [<c0178594>] sys_open+0x1c/0x1e
       [<c0108080>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (&(&ip->i_lock)->mr_lock/1){--..}:
       [<c0146a17>] __lock_acquire+0x903/0xbab
       [<c0146d3a>] lock_acquire+0x7b/0x9f
       [<c013e61b>] down_write_nested+0x3d/0x58
       [<e1209f9d>] xfs_ilock+0x64/0x8d [xfs]
       [<e122591f>] xfs_lock_inodes+0x11d/0x12f [xfs]
       [<e122a9de>] xfs_lock_dir_and_entry+0xc2/0xcc [xfs]
       [<e122b04e>] xfs_remove+0x213/0x425 [xfs]
       [<e1231782>] xfs_vn_unlink+0x1c/0x44 [xfs]
       [<c0180c2b>] vfs_unlink+0x75/0xb3
       [<c01826b7>] do_unlinkat+0x96/0x12c
       [<c0182760>] sys_unlink+0x13/0x15
       [<c0108080>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by rm/1451:
 #0:  (&inode->i_mutex/1){--..}, at: [<c018267f>] do_unlinkat+0x5e/0x12c
 #1:  (&inode->i_mutex){--..}, at: [<c0378b93>] mutex_lock+0x1f/0x23
 #2:  (&(&ip->i_lock)->mr_lock){----}, at: [<e1209f9d>] xfs_ilock+0x64/0x8d [xfs]

stack backtrace:
 [<c0109173>] show_trace_log_lvl+0x1a/0x30
 [<c0109c7f>] show_trace+0x12/0x14
 [<c0109d0c>] dump_stack+0x16/0x18
 [<c01451af>] print_circular_bug_tail+0x5f/0x68
 [<c0146a17>] __lock_acquire+0x903/0xbab
 [<c0146d3a>] lock_acquire+0x7b/0x9f
 [<c013e61b>] down_write_nested+0x3d/0x58
 [<e1209f9d>] xfs_ilock+0x64/0x8d [xfs]
 [<e122591f>] xfs_lock_inodes+0x11d/0x12f [xfs]
 [<e122a9de>] xfs_lock_dir_and_entry+0xc2/0xcc [xfs]
 [<e122b04e>] xfs_remove+0x213/0x425 [xfs]
 [<e1231782>] xfs_vn_unlink+0x1c/0x44 [xfs]
 [<c0180c2b>] vfs_unlink+0x75/0xb3
 [<c01826b7>] do_unlinkat+0x96/0x12c
 [<c0182760>] sys_unlink+0x13/0x15
 [<c0108080>] syscall_call+0x7/0xb
 =======================

	J
