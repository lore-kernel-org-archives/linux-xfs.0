Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 17:01:46 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1C11gXG028121
	for <linux-xfs@oss.sgi.com>; Mon, 11 Feb 2008 17:01:43 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57974DE6C66
	for <linux-xfs@oss.sgi.com>; Mon, 11 Feb 2008 17:02:05 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id Yo1HfpBrqEKgJda7 for <linux-xfs@oss.sgi.com>; Mon, 11 Feb 2008 17:02:05 -0800 (PST)
Message-ID: <47B0F00D.3060802@tlinx.org>
Date: Mon, 11 Feb 2008 17:02:05 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfs [_fsr] probs in 2.6.24.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux-Xfs <linux-xfs@oss.sgi.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>


I'm getting similar errors on an x86-32 & x86-64 kernel.  The x86-64 system
(2nd log below w/date+times) was unusable this morning: one or more of the
xfs file systems had "gone off line" due to some unknown error (upon reboot,
no errors were indicated; all partitions on the same physical disk).

I keep ending up with random failures on two systems.  The 32-bit sys more
often than not just "locks-up" -- no messages, no keyboard response...etc.
Nothing to do except reset -- and of course, nothing in the logs....

I'm turning on all the stat and diagnostics that don't seem to have a noted
performance penalty (or not much of one) to see if that helps.  Perhaps one
issue is the "bug" (looks like multiple instances of the same bug) in xfs.

The 32-bit machine does lots of disk activity in early morning hours...and
coincidentally, it seemed to be crashing (not consistently) in the morning.
With 2.6.24, the 32-bit machine "seems" a bit more stable -- up for over 3
days now (average before was <48 hours).  But the 64-bit machine went
bonkers (not sure of exact time) -- It *had* been stable (non crashing,
anyway) before 2.6.24.

I vaguely remember there being a similar xfs lock bug a few versions back
and was told just "not to worry about and turn off the lock checking to
"avoid the problem"....( :^| ).  So I did, but still trying to track down
randomness.  So I turn back on what checks I could and ... ding -- still a
problem in the xfs area -- which "coincidentally" (has happened on more than
one occasion), an xfs partition developed a run-time error and shut itself
down.  This also happened on the 32-bit machine with the SATA disk (thought
it might be sata specific), so removed its controller and disk and threw in
a same-size PATA.  No more file-system errors on 32bit.  But first time I've
had a filesystem 'forced offline' on the 64bit (but just switched to 2.6.24
recently for obvious reasons).

Sadly -- it also seemed to be the case that the 32bit machine when it had
the SATA controller+disk installed, was more likely to crash if xfs_fsr was
running at the same-time remote backups were being written to the
SATA-drive.  Couldn't repeat it reliably, though so not sure what's going on
there.

Both machines are SMP, so that's a potential factor along with the fact that
both machines also use SCSI (64bit, SAS form).  Neither are running a
graphical console but are being remotely accessed.

Lemme know if I can provide any info in addressing these problems.  I don't
know if they are related to the other system crashes, but usage patterns
indicate it could be disk-activity related.  So eliminating known bugs &
problems in that area might help (?)...

Suspect log messages follow (1st, w/o Date/time were from dmesg on 32bit,
latter was a previously unnoticed one on 64bit until I started looking
through logs for clues on last night's failures.


The first set of errors the I have some diagnostics for, I could
only find in dmesg:
(ish-32bit machine)
=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-ish #1
-------------------------------------------------------
xfs_fsr/2119 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<b01a3432>] dio_get_page+0x62/0x160

but task is already holding lock:
 (&(&ip->i_iolock)->mr_lock){----}, at: [<b02651db>] xfs_ilock+0x5b/0xb0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_iolock)->mr_lock){----}:
       [<b014c026>] __lock_acquire+0xce6/0x1150
       [<b0265217>] xfs_ilock+0x97/0xb0
       [<b014ae3f>] trace_hardirqs_on+0xaf/0x160
       [<b014c4fa>] lock_acquire+0x6a/0x80
       [<b0265217>] xfs_ilock+0x97/0xb0
       [<b0140d63>] down_write_nested+0x43/0x80
       [<b0265217>] xfs_ilock+0x97/0xb0
       [<b0265217>] xfs_ilock+0x97/0xb0
       [<b0286c61>] xfs_free_eofblocks+0x231/0x2e0
       [<b028b137>] xfs_release+0x1a7/0x230
       [<b029154b>] xfs_file_release+0xb/0x10
       [<b017dc4c>] __fput+0xac/0x180
       [<b016dc25>] remove_vma+0x35/0x50
       [<b016e790>] do_munmap+0x190/0x200
       [<b016e82f>] sys_munmap+0x2f/0x50
       [<b0104396>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<b0148df1>] print_circular_bug_entry+0x41/0x50
       [<b014be19>] __lock_acquire+0xad9/0x1150
       [<b014aca3>] mark_held_locks+0x43/0x80
       [<b014c4fa>] lock_acquire+0x6a/0x80
       [<b01a3432>] dio_get_page+0x62/0x160
       [<b04675a8>] down_read+0x38/0x80
       [<b01a3432>] dio_get_page+0x62/0x160
       [<b01a3432>] dio_get_page+0x62/0x160
       [<b02bd4c2>] __spin_lock_init+0x32/0x60
       [<b01a4053>] __blockdev_direct_IO+0x483/0xc70
       [<b017945b>] kmem_cache_alloc+0x9b/0xc0
       [<b04684d4>] _spin_unlock+0x14/0x20
       [<b014863d>] lockdep_init_map+0x3d/0x4c0
       [<b028cd70>] xfs_alloc_ioend+0x120/0x170
       [<b028cf1f>] xfs_vm_direct_IO+0x15f/0x170
       [<b028d410>] xfs_get_blocks_direct+0x0/0x30
       [<b028c880>] xfs_end_io_direct+0x0/0x90
       [<b015db82>] generic_file_direct_IO+0xd2/0x160
       [<b015dc6a>] generic_file_direct_write+0x5a/0x170
       [<b0140db4>] up_write+0x14/0x30
       [<b0295418>] xfs_write+0x3e8/0x920
       [<b015c810>] file_read_actor+0x0/0x120
       [<b02916ce>] xfs_file_aio_write+0x5e/0x70
       [<b017c807>] do_sync_write+0xc7/0x110
       [<b013ce80>] autoremove_wake_function+0x0/0x40
       [<b01484a7>] lock_release_holdtime+0x47/0x70
       [<b017d240>] vfs_read+0xd0/0x160
       [<b017c740>] do_sync_write+0x0/0x110
       [<b017d0b0>] vfs_write+0xa0/0x160
       [<b017d7d1>] sys_write+0x41/0x70
       [<b0104396>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by xfs_fsr/2119:
 #0:  (&(&ip->i_iolock)->mr_lock){----}, at: [<b02651db>] 
xfs_ilock+0x5b/0xb0

stack backtrace:
Pid: 2119, comm: xfs_fsr Not tainted 2.6.24-ish #1
 [<b01499da>] print_circular_bug_tail+0x7a/0x90
 [<b014be19>] __lock_acquire+0xad9/0x1150
 [<b014aca3>] mark_held_locks+0x43/0x80
 [<b014c4fa>] lock_acquire+0x6a/0x80
 [<b01a3432>] dio_get_page+0x62/0x160
 [<b04675a8>] down_read+0x38/0x80
 [<b01a3432>] dio_get_page+0x62/0x160
 [<b01a3432>] dio_get_page+0x62/0x160
 [<b02bd4c2>] __spin_lock_init+0x32/0x60
 [<b01a4053>] __blockdev_direct_IO+0x483/0xc70
 [<b017945b>] kmem_cache_alloc+0x9b/0xc0
 [<b04684d4>] _spin_unlock+0x14/0x20
 [<b014863d>] lockdep_init_map+0x3d/0x4c0
 [<b028cd70>] xfs_alloc_ioend+0x120/0x170
 [<b028cf1f>] xfs_vm_direct_IO+0x15f/0x170
 [<b028d410>] xfs_get_blocks_direct+0x0/0x30
 [<b028c880>] xfs_end_io_direct+0x0/0x90
 [<b015db82>] generic_file_direct_IO+0xd2/0x160
 [<b015dc6a>] generic_file_direct_write+0x5a/0x170
 [<b0140db4>] up_write+0x14/0x30
 [<b0295418>] xfs_write+0x3e8/0x920
 [<b015c810>] file_read_actor+0x0/0x120
 [<b02916ce>] xfs_file_aio_write+0x5e/0x70
 [<b017c807>] do_sync_write+0xc7/0x110
 [<b013ce80>] autoremove_wake_function+0x0/0x40
 [<b01484a7>] lock_release_holdtime+0x47/0x70
 [<b017d240>] vfs_read+0xd0/0x160
 [<b017c740>] do_sync_write+0x0/0x110
 [<b017d0b0>] vfs_write+0xa0/0x160
 [<b017d7d1>] sys_write+0x41/0x70
 [<b0104396>] sysenter_past_esp+0x5f/0xa5
 =======================

--------------
The other system shows a similar message: in its logs:
Feb  7 02:01:50 kern: 
=======================================================
Feb  7 02:01:50 kern: [ INFO: possible circular locking dependency 
detected ]
Feb  7 02:01:50 kern: 2.6.24-asa64def #3
Feb  7 02:01:50 kern: 
-------------------------------------------------------
Feb  7 02:01:50 kern: xfs_fsr/6313 is trying to acquire lock:
Feb  7 02:01:50 kern:  (&(&ip->i_lock)->mr_lock/2){----}, at: 
[<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
Feb  7 02:01:50 kern:
Feb  7 02:01:50 kern: but task is already holding lock:
Feb  7 02:01:50 kern:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
[<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
Feb  7 02:01:50 kern:
Feb  7 02:01:50 kern: which lock already depends on the new lock.
Feb  7 02:01:50 kern:
Feb  7 02:01:50 kern:
Feb  7 02:01:50 kern: the existing dependency chain (in reverse order) is:
Feb  7 02:01:50 kern:
Feb  7 02:01:50 kern: -> #1 (&(&ip->i_iolock)->mr_lock/3){--..}:
Feb  7 02:01:50 kern:        [<ffffffff80261d39>] 
__lock_acquire+0xc39/0x1090
Feb  7 02:01:50 kern:        [<ffffffff802621f1>] lock_acquire+0x61/0x80
Feb  7 02:01:50 kern:        [<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
Feb  7 02:01:50 kern:        [<ffffffff802572ba>] 
down_write_nested+0x3a/0x80
Feb  7 02:01:50 kern:        [<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
Feb  7 02:01:50 kern:        [<ffffffff803e0a33>] 
xfs_lock_inodes+0x143/0x190
Feb  7 02:01:50 kern:        [<ffffffff803cbc81>] 
xfs_swap_extents+0xa1/0x630
Feb  7 02:01:50 kern:        [<ffffffff8025df35>] 
lock_release_holdtime+0x45/0x70
Feb  7 02:01:50 kern:        [<ffffffff803cbbb1>] xfs_swapext+0x131/0x160
Feb  7 02:01:50 kern:        [<ffffffff803edace>] xfs_ioctl+0x5ce/0x740
Feb  7 02:01:50 kern:        [<ffffffff8025df35>] 
lock_release_holdtime+0x45/0x70
Feb  7 02:01:50 kern:        [<ffffffff80626eba>] 
__mutex_unlock_slowpath+0xca/0x1a0
Feb  7 02:01:50 kern:        [<ffffffff803eb9b6>] 
xfs_file_ioctl_invis+0x36/0x80
Feb  7 02:01:50 kern:        [<ffffffff802a9dcf>] do_ioctl+0x2f/0xa0
Feb  7 02:01:50 kern:        [<ffffffff802aa070>] vfs_ioctl+0x230/0x2d0
Feb  7 02:01:50 kern:        [<ffffffff80260bb1>] 
trace_hardirqs_on+0xc1/0x160
Feb  7 02:01:50 kern:        [<ffffffff802aa159>] sys_ioctl+0x49/0x80
Feb  7 02:01:51 kern:        [<ffffffff8020c3ce>] system_call+0x7e/0x83
Feb  7 02:01:51 kern:        [<ffffffffffffffff>] 0xffffffffffffffff
Feb  7 02:01:51 kern:
Feb  7 02:01:51 kern: -> #0 (&(&ip->i_lock)->mr_lock/2){----}:
Feb  7 02:01:51 kern:        [<ffffffff80260018>] 
print_circular_bug_header+0xe8/0xf0
Feb  7 02:01:51 kern:        [<ffffffff80261ba8>] 
__lock_acquire+0xaa8/0x1090
Feb  7 02:01:51 kern:        [<ffffffff802621f1>] lock_acquire+0x61/0x80
Feb  7 02:01:51 kern:        [<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
Feb  7 02:01:51 kern:        [<ffffffff80628597>] _spin_unlock+0x17/0x20
Feb  7 02:01:51 kern:        [<ffffffff802572ba>] 
down_write_nested+0x3a/0x80
Feb  7 02:01:51 kern:        [<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
Feb  7 02:01:51 kern:        [<ffffffff803e0a33>] 
xfs_lock_inodes+0x143/0x190
Feb  7 02:01:51 kern:        [<ffffffff803cbefe>] 
xfs_swap_extents+0x31e/0x630
Feb  7 02:01:51 kern:        [<ffffffff803cbbb1>] xfs_swapext+0x131/0x160
Feb  7 02:01:51 kern:        [<ffffffff803edace>] xfs_ioctl+0x5ce/0x740
Feb  7 02:01:51 kern:        [<ffffffff8025df35>] 
lock_release_holdtime+0x45/0x70
Feb  7 02:01:51 kern:        [<ffffffff80626eba>] 
__mutex_unlock_slowpath+0xca/0x1a0
Feb  7 02:01:51 kern:        [<ffffffff803eb9b6>] 
xfs_file_ioctl_invis+0x36/0x80
Feb  7 02:01:51 kern:        [<ffffffff802a9dcf>] do_ioctl+0x2f/0xa0
Feb  7 02:01:51 kern:        [<ffffffff802aa070>] vfs_ioctl+0x230/0x2d0
Feb  7 02:01:51 kern:        [<ffffffff80260bb1>] 
trace_hardirqs_on+0xc1/0x160
Feb  7 02:01:51 kern:        [<ffffffff802aa159>] sys_ioctl+0x49/0x80
Feb  7 02:01:51 kern:        [<ffffffff8020c3ce>] system_call+0x7e/0x83
Feb  7 02:01:51 kern:        [<ffffffffffffffff>] 0xffffffffffffffff
Feb  7 02:01:51 kern:
Feb  7 02:01:51 kern: other info that might help us debug this:
Feb  7 02:01:51 kern:
Feb  7 02:01:51 kern: 2 locks held by xfs_fsr/6313:
Feb  7 02:01:51 kern:  #0:  (&(&ip->i_iolock)->mr_lock/2){--..}, at: 
[<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
Feb  7 02:01:51 kern:  #1:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
[<ffffffff803c1b45>] xfs_ilock+0xa5/0xc0
Feb  7 02:01:51 kern:
Feb  7 02:01:51 kern: stack backtrace:
Feb  7 02:01:51 kern: Pid: 6313, comm: xfs_fsr Not tainted 
2.6.24-asa64def #3
Feb  7 02:01:51 kern:
Feb  7 02:01:51 kern: Call Trace:
Feb  7 02:01:51 kern:  [<ffffffff8025f413>] 
print_circular_bug_tail+0x83/0x90
Feb  7 02:01:51 kern:  [<ffffffff80260018>] 
print_circular_bug_header+0xe8/0xf0
Feb  7 02:01:51 kern:  [<ffffffff80261ba8>] __lock_acquire+0xaa8/0x1090
Feb  7 02:01:51 kern:  [<ffffffff802621f1>] lock_acquire+0x61/0x80
Feb  7 02:01:51 kern:  [<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
Feb  7 02:01:51 kern:  [<ffffffff80628597>] _spin_unlock+0x17/0x20
Feb  7 02:01:51 kern:  [<ffffffff802572ba>] down_write_nested+0x3a/0x80
Feb  7 02:01:51 kern:  [<ffffffff803c1b22>] xfs_ilock+0x82/0xc0
Feb  7 02:01:51 kern:  [<ffffffff803e0a33>] xfs_lock_inodes+0x143/0x190
Feb  7 02:01:51 kern:  [<ffffffff803cbefe>] xfs_swap_extents+0x31e/0x630
Feb  7 02:01:51 kern:  [<ffffffff803cbbb1>] xfs_swapext+0x131/0x160
Feb  7 02:01:51 kern:  [<ffffffff803edace>] xfs_ioctl+0x5ce/0x740
Feb  7 02:01:51 kern:  [<ffffffff8025df35>] lock_release_holdtime+0x45/0x70
Feb  7 02:01:51 kern:  [<ffffffff80626eba>] 
__mutex_unlock_slowpath+0xca/0x1a0
[<ffffffff803eb9b6>] xfs_file_ioctl_invis+0x36/0x80
Feb  7 02:01:51 kern:  [<ffffffff802a9dcf>] do_ioctl+0x2f/0xa0
Feb  7 02:01:51 kern:  [<ffffffff802aa070>] vfs_ioctl+0x230/0x2d0
Feb  7 02:01:51 kern:  [<ffffffff80260bb1>] trace_hardirqs_on+0xc1/0x160
Feb  7 02:01:51 kern:  [<ffffffff802aa159>] sys_ioctl+0x49/0x80
Feb  7 02:01:51 kern:  [<ffffffff8020c3ce>] system_call+0x7e/0x83
