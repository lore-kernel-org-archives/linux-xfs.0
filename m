Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 426007CA1
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 08:43:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96F5BAC002
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 06:43:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VTOD8vfMEPes3xr7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Mar 2016 06:43:17 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 57D4FAA7
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 13:43:16 +0000 (UTC)
Received: from cpach (ovpn-112-83.phx2.redhat.com [10.3.112.83])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2KDhEuJ003319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 09:43:15 -0400
Date: Sun, 20 Mar 2016 09:43:01 -0400 (EDT)
From: Sage Weil <sweil@redhat.com>
Subject: splice vs truncate lockdep splat
Message-ID: <alpine.DEB.2.11.1603200938010.17552@cpach.fuggernut.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi all,

For the last few kernel releases we've been seeing this pretty regularly:

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 4.5.0-rc3-ceph-00790-g2364ac5 #1 Not tainted
 -------------------------------------------------------
 tp_fstore_op/25647 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#19){+.+.+.}, at: [<ffffffffa0574bad>] xfs_file_buffered_aio_write+0x6d/0x300 [xfs]
 #012but task is already holding lock:
 (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8126347d>] pipe_lock+0x1d/0x20
 #012which lock already depends on the new lock.
 #012the existing dependency chain (in reverse order) is:
 #012-> #2 (&pipe->mutex/1){+.+.+.}:
       [<ffffffff81100842>] lock_acquire+0x162/0x1b0
       [<ffffffff817d77c9>] mutex_lock_nested+0x79/0x380
       [<ffffffff8126347d>] pipe_lock+0x1d/0x20
       [<ffffffff81290d20>] splice_to_pipe+0x30/0x250
       [<ffffffff81292379>] __generic_file_splice_read+0x4f9/0x620
       [<ffffffff812924de>] generic_file_splice_read+0x3e/0x70
       [<ffffffffa05738d4>] xfs_file_splice_read+0x194/0x220 [xfs]
       [<ffffffff812912da>] do_splice_to+0x6a/0x80
       [<ffffffff812934e1>] SyS_splice+0x6c1/0x720
       [<ffffffff817da4b2>] entry_SYSCALL_64_fastpath+0x12/0x76
 #012-> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
       [<ffffffff81100842>] lock_acquire+0x162/0x1b0
       [<ffffffff810fa37f>] down_write_nested+0x4f/0x80
       [<ffffffffa058106d>] xfs_ilock+0xed/0x1b0 [xfs]
       [<ffffffffa05801c0>] xfs_vn_setattr+0x30/0x70 [xfs]
       [<ffffffff8127a09d>] notify_change+0x1ed/0x320
       [<ffffffff8125843c>] do_truncate+0x7c/0xc0
       [<ffffffff81258843>] do_sys_ftruncate.constprop.12+0x153/0x170
       [<ffffffff8125889e>] SyS_ftruncate+0xe/0x10
       [<ffffffff817da4b2>] entry_SYSCALL_64_fastpath+0x12/0x76
 #012-> #0 (&sb->s_type->i_mutex_key#19){+.+.+.}:
       [<ffffffff810ff57e>] __lock_acquire+0x13be/0x1e30
       [<ffffffff81100842>] lock_acquire+0x162/0x1b0
       [<ffffffff817d77c9>] mutex_lock_nested+0x79/0x380
       [<ffffffffa0574bad>] xfs_file_buffered_aio_write+0x6d/0x300 [xfs]
       [<ffffffffa0574ed5>] xfs_file_write_iter+0x95/0x140 [xfs]
       [<ffffffff81259ee5>] vfs_iter_write+0x75/0xb0
       [<ffffffff81291a51>] iter_file_splice_write+0x281/0x3a0
       [<ffffffff812932fa>] SyS_splice+0x4da/0x720
       [<ffffffff817da4b2>] entry_SYSCALL_64_fastpath+0x12/0x76
 #012other info that might help us debug this:
 Chain exists of:#012  &sb->s_type->i_mutex_key#19 --> &(&ip->i_iolock)->mr_lock --> &pipe->mutex/1
 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&pipe->mutex/1);
                               lock(&(&ip->i_iolock)->mr_lock);
                               lock(&pipe->mutex/1);
  lock(&sb->s_type->i_mutex_key#19);
 #012 *** DEADLOCK ***
 2 locks held by tp_fstore_op/25647:
 #0:  (sb_writers#15){.+.+.+}, at: [<ffffffff8125db7d>] __sb_start_write+0xad/0xe0
 #1:  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8126347d>] pipe_lock+0x1d/0x20
 #012stack backtrace:
 CPU: 4 PID: 25647 Comm: tp_fstore_op Not tainted 4.5.0-rc3-ceph-00790-g2364ac5 #1
 Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
 0000000000000086 00000000547c0aa5 ffff880858c0bad8 ffffffff813f8661
 ffffffff827127a0 ffffffff82711870 ffff880858c0bb18 ffffffff811c5d39
 ffff880858c0bb70 ffff8808530288d8 0000000000000001 0000000000000002
 Call Trace:
 [<ffffffff813f8661>] dump_stack+0x85/0xc4
 [<ffffffff811c5d39>] print_circular_bug+0x200/0x20e
 [<ffffffff810ff57e>] __lock_acquire+0x13be/0x1e30
 [<ffffffff81100842>] lock_acquire+0x162/0x1b0
 [<ffffffffa0574bad>] ? xfs_file_buffered_aio_write+0x6d/0x300 [xfs]
 [<ffffffff817d77c9>] mutex_lock_nested+0x79/0x380
 [<ffffffffa0574bad>] ? xfs_file_buffered_aio_write+0x6d/0x300 [xfs]
 [<ffffffff810d338d>] ? ttwu_stat+0x19d/0x200
 [<ffffffffa0574bad>] xfs_file_buffered_aio_write+0x6d/0x300 [xfs]
 [<ffffffff810fdc6f>] ? mark_held_locks+0x6f/0x80
 [<ffffffff810fdde3>] ? trace_hardirqs_on_caller+0x163/0x1d0
 [<ffffffffa0574ed5>] xfs_file_write_iter+0x95/0x140 [xfs]
 [<ffffffff81259ee5>] vfs_iter_write+0x75/0xb0
 [<ffffffff81291a51>] iter_file_splice_write+0x281/0x3a0
 [<ffffffff812932fa>] SyS_splice+0x4da/0x720
 [<ffffffff810031d6>] ? do_audit_syscall_entry+0x66/0x70
 [<ffffffff817da4b2>] entry_SYSCALL_64_fastpath+0x12/0x76

We're not actually doing racing truncate and splice (or any racing 
operations for that matter) to the same files, so we don't actually hit 
this, but the lockdep warning is enough to make our test runs fail, and 
we'd rather not whitelist this if it's something that should get fixed 
anyway.

My apologies for not raising this sooner; I thought I'd already emailed 
the list about this a few months ago but it looks think I'd only pinged 
#xfs.

sage

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
