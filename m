Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 14:11:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MLBc6v007191
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 14:11:39 -0700
Received: from py-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A14E51203D7F
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 14:13:00 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177]) by cuda.sgi.com with ESMTP id eQXKZzPf9Jebqvzu for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 14:13:00 -0700 (PDT)
Received: by py-out-1112.google.com with SMTP id f31so433803pyh.4
        for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 14:12:59 -0700 (PDT)
Message-ID: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
Date: Fri, 22 Aug 2008 22:12:59 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: [2.6.27-rc4] XFS i_lock vs i_iolock...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Cc: Christoph Lameter <clameter@sgi.com>

On 2.6.27-rc4 with various debug options enabled, lockdep claims lock
ordering issues with XFS [1] - easiest reproducer is just running
xfs_fsr. Mount options I was using were
'nobarrier,noatime,nodiratime'.

Thanks,
  Daniel

--- [1]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc4-224c #1
-------------------------------------------------------
xfs_fsr/5763 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0

but task is already holding lock:
 (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
xfs_ilock+0xa5/0xb0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_iolock)->mr_lock/3){--..}:
       [<ffffffff8026b011>] __lock_acquire+0xdb1/0x1150
       [<ffffffff8026b441>] lock_acquire+0x91/0xc0
       [<ffffffff8025d967>] down_write_nested+0x57/0x90
       [<ffffffff803ad915>] xfs_ilock+0xa5/0xb0
       [<ffffffff803cb086>] xfs_lock_two_inodes+0x106/0x120
       [<ffffffff803b78e0>] xfs_swap_extents+0x70/0x5b0
       [<ffffffff803b7f68>] xfs_swapext+0x148/0x150
       [<ffffffff803d8195>] xfs_ioctl+0x6a5/0x810
       [<ffffffff803d58bd>] xfs_file_ioctl_invis+0x3d/0x80
       [<ffffffff802d4586>] vfs_ioctl+0x36/0xb0
       [<ffffffff802d488b>] do_vfs_ioctl+0x28b/0x2f0
       [<ffffffff802d493f>] sys_ioctl+0x4f/0x80
       [<ffffffff8020c74b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&(&ip->i_lock)->mr_lock/2){--..}:
       [<ffffffff8026b0f5>] __lock_acquire+0xe95/0x1150
       [<ffffffff8026b441>] lock_acquire+0x91/0xc0
       [<ffffffff8025d967>] down_write_nested+0x57/0x90
       [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
       [<ffffffff803caff0>] xfs_lock_two_inodes+0x70/0x120
       [<ffffffff803b7b03>] xfs_swap_extents+0x293/0x5b0
       [<ffffffff803b7f68>] xfs_swapext+0x148/0x150
       [<ffffffff803d8195>] xfs_ioctl+0x6a5/0x810
       [<ffffffff803d58bd>] xfs_file_ioctl_invis+0x3d/0x80
       [<ffffffff802d4586>] vfs_ioctl+0x36/0xb0
       [<ffffffff802d488b>] do_vfs_ioctl+0x28b/0x2f0
       [<ffffffff802d493f>] sys_ioctl+0x4f/0x80
       [<ffffffff8020c74b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by xfs_fsr/5763:
 #0:  (&(&ip->i_iolock)->mr_lock/2){--..}, at: [<ffffffff803ad915>]
xfs_ilock+0xa5/0xb0
 #1:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
xfs_ilock+0xa5/0xb0

stack backtrace:
Pid: 5763, comm: xfs_fsr Not tainted 2.6.27-rc4-224c #1

Call Trace:
 [<ffffffff80268d1f>] print_circular_bug_tail+0x9f/0xe0
 [<ffffffff8026b0f5>] __lock_acquire+0xe95/0x1150
 [<ffffffff8026b441>] lock_acquire+0x91/0xc0
 [<ffffffff803ad8fc>] ? xfs_ilock+0x8c/0xb0
 [<ffffffff8025d967>] down_write_nested+0x57/0x90
 [<ffffffff803ad8fc>] ? xfs_ilock+0x8c/0xb0
 [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
 [<ffffffff803caff0>] xfs_lock_two_inodes+0x70/0x120
 [<ffffffff803b7b03>] xfs_swap_extents+0x293/0x5b0
 [<ffffffff803b7f68>] xfs_swapext+0x148/0x150
 [<ffffffff803d8195>] xfs_ioctl+0x6a5/0x810
 [<ffffffff802148b0>] ? native_sched_clock+0x70/0xa0
 [<ffffffff802e24f2>] ? mnt_drop_write+0x62/0x140
 [<ffffffff803d58bd>] xfs_file_ioctl_invis+0x3d/0x80
 [<ffffffff802d4586>] vfs_ioctl+0x36/0xb0
 [<ffffffff802d488b>] do_vfs_ioctl+0x28b/0x2f0
 [<ffffffff8064128e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff802d493f>] sys_ioctl+0x4f/0x80
 [<ffffffff8020c74b>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
