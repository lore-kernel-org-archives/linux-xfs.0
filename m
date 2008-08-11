Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 12:30:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7BJUfau006120
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 12:30:43 -0700
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1405E3828F9
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 12:31:49 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id 8y1g5cHpZ9xlGVVa for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 12:31:49 -0700 (PDT)
Message-ID: <48A093A7.40606@tlinx.org>
Date: Mon, 11 Aug 2008 12:31:51 -0700
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Lock debugging noise or real problem?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On July 24, I upgraded my kernel from 2.6.24.2 (uptimes in months) to
2.6.26 and haven't had a real stable system since.

I've built & tried the intermediate 2.6.25.12 but it didn't seem to be more
stable.  I also turned on lock correctness -- since the crashes have 
involved
the machine hanging with no output to indicate what's going on -- though 
one time
I noticed a HANG CHECK timer go off -- but that only happened once -- 
and it didn't
hang at that point (did hours later, but don't know if related).

I had my warning log split out from the other messages, so it may be 
hiding something
useful from one of the other logs, but there is a bunch of "noise" 
relating to
locking and program crashing recorded in the log.

I interspersed the boot messages in the log so I could try to determine 
a pattern.

There are a few other weird messages, but none consistent -- clocksource 
unstable
(which also saw when I got the TIMER HANG CHECK),

squid's restart messages seem to be going into 'warn' as well as occasional
warnings about it taking a long time to respond...  I don't think theya re
related, but they are a bit odd at times...

Most of these seem to be related to  XFS  related problems -- but I'm 
not sure how
many of the messages are red-herrings.

A few of the XFS messages around the 8th or 9th got serious as two or three
partitions were unable to be mounted -- xfs couldn't mount or recover them
automatically, and I had to run xfs_repair and throw away the log (-L).

I should note that some automatic operations occur in the 2-3am hours --
cron.dailies seem go go off in that time frame, and system backup jobs start
at 2:30 -- so some of the errors happen during disk-using processes like 
xfs_fsr
and xfs_dump.

I have smartd running on all the disks, a few of the disks...are spouting
random noise but no hard errors.  /dev/hde is where "/home" dirs are 
located.
/dev/hdf also gave some errors -- but its one of the newer disks and is a
second-volume that's used to store backups (only spins up during backups or
restoring)...

Is there anyway to eliminate the red-herring disk errors in XFS?  They are
really helping obscure what are real messages and what are not...(presuming
any are not...(?))...

This is a trimmed version of my Warn log (with boot indicators) since
 the problems started.  I'm also unsure why some user-level processes seem
to be dumping trace-backs periodically, including:

cifsopslock
xfs_fsr (a few)
sort
imaps (a few)
mount (several)
--- the mount dumps might be related to the xfs problems caused by the 
previous
hard hang...

Any hints at how to help narrow this down would be helpeful....

There could be more than one problem, since going back to my previouos
stable kernel (2.6.24.2) still resulted in a crash, though not as quickly...
I wish the darn hangs would leave more traces!  Console locked up...no 
output
no key input...just wedged (no pings...etc)...
Thanks much for any help...

These are all "Vanilla" kernels configged for the specific hardware of the
machine (a 2xP-III) and cross compiled on an x86_64 machine. 

tnx,
-linda


boot-080417.1055:<5>Linux version 2.6.24.2-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #5 SMP Fri Feb 15 17:55:46 PST 2008
boot-080606.0751:<5>Linux version 2.6.24.2-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #5 SMP Fri Feb 15 17:55:46 PST 2008
boot-080723.1515:<5>Linux version 2.6.24.2-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #5 SMP Fri Feb 15 17:55:46 PST 2008
boot-080724.1832:<5>Linux version 2.6.26-ish (lw@Ast) (gcc version 4.2.1 
(SUSE Linux)) #2 SMP Tue Jul 22 11:29:39 PDT 2008
boot-080725.0823:<5>Linux version 2.6.26-ish (lw@Ast) (gcc version 4.2.1 
(SUSE Linux)) #2 SMP Tue Jul 22 11:29:39 PDT 2008
---
Jul 25 18:21:28 kern: Clocksource tsc unstable (delta = 571817442154 ns)
Jul 25 18:21:28 kern: Modules linked in: uhci_hcd
Jul 25 18:21:28 kern:
Jul 25 18:21:28 kern: Pid: 183, comm: cifsoplockd Not tainted 
(2.6.26-ish #2)
Jul 25 18:21:28 kern: EIP: 0060:[<b0412437>] EFLAGS: 00000286 CPU: 1
Jul 25 18:21:28 kern: EIP is at _spin_unlock_irqrestore+0x7/0x10
Jul 25 18:21:28 kern: EAX: b05a8d00 EBX: efb13f54 ECX: b05a8d00 EDX: 
00000286
Jul 25 18:21:28 kern: ESI: 00000000 EDI: b01eaa90 EBP: efb13f24 ESP: 
efb13f24
Jul 25 18:21:28 kern:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul 25 18:21:28 kern: CR0: 8005003b CR2: a7a2c000 CR3: 37c10000 CR4: 
000006d0
Jul 25 18:21:28 kern: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 
00000000
Jul 25 18:21:28 kern: DR6: ffff0ff0 DR7: 00000400
Jul 25 18:21:28 kern:  [<b012df2a>] try_to_del_timer_sync+0x4a/0x60
Jul 25 18:21:28 kern:  [<b012df51>] del_timer_sync+0x11/0x20
Jul 25 18:21:28 kern:  [<b0410dbf>] schedule_timeout+0x4f/0xc0
Jul 25 18:21:28 kern:  [<b012db20>] ? process_timeout+0x0/0x10
Jul 25 18:21:28 kern:  [<b0410db3>] ? schedule_timeout+0x43/0xc0
Jul 25 18:21:28 kern:  [<b01eabee>] cifs_oplock_thread+0x15e/0x230
Jul 25 18:21:28 kern:  [<b011a836>] ? complete+0x46/0x60
Jul 25 18:21:28 kern:  [<b01eaa90>] ? cifs_oplock_thread+0x0/0x230
Jul 25 18:21:28 kern:  [<b01375b2>] kthread+0x42/0x70
Jul 25 18:21:28 kern:  [<b0137570>] ? kthread+0x0/0x70
Jul 25 18:21:28 kern:  [<b0103c4f>] kernel_thread_helper+0x7/0x18
Jul 25 18:21:28 kern:  =======================

---
boot-080726.2021:<5>Linux version 2.6.26-ish (lw@Ast) (gcc version 4.2.1 
(SUSE Linux)) #2 SMP Tue Jul 22 11:29:39 PDT 2008
---

Jul 27 03:21:30 Ish squid[2124]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Jul 28 02:10:38 kern:
Jul 28 02:10:38 kern: 
=======================================================
Jul 28 02:10:38 kern: [ INFO: possible circular locking dependency 
detected ]
Jul 28 02:10:38 kern: 2.6.24.2-ish #5
Jul 28 02:10:38 kern: 
-------------------------------------------------------
Jul 28 02:10:38 kern: xfs_fsr/17758 is trying to acquire lock:
Jul 28 02:10:38 kern:  (&(&ip->i_lock)->mr_lock/2){----}, at: 
[<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:38 kern:
Jul 28 02:10:38 kern: but task is already holding lock:
Jul 28 02:10:38 kern:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
[<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:38 kern:
Jul 28 02:10:38 kern: which lock already depends on the new lock.
Jul 28 02:10:38 kern:
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: the existing dependency chain (in reverse order) is:
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: -> #1 (&(&ip->i_iolock)->mr_lock/3){--..}:
Jul 28 02:10:39 kern:        [<b014a01b>] __lock_acquire+0xc0b/0x10b0
Jul 28 02:10:39 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:        [<b014a521>] lock_acquire+0x61/0x80
Jul 28 02:10:39 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:        [<b013f6f8>] down_write_nested+0x38/0x60
Jul 28 02:10:39 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:        [<b027fb92>] xfs_lock_inodes+0x112/0x160
Jul 28 02:10:39 kern:        [<b02698d6>] xfs_swap_extents+0x96/0x5c0
Jul 28 02:10:39 kern:        [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Jul 28 02:10:39 kern:        [<b014993c>] __lock_acquire+0x52c/0x10b0
Jul 28 02:10:39 kern:        [<b02902f7>] __vn_revalidate+0x47/0x80
Jul 28 02:10:39 kern:        [<b026981b>] xfs_swapext+0x13b/0x160
Jul 28 02:10:39 kern:        [<b028ca91>] xfs_ioctl+0x521/0x750
Jul 28 02:10:39 kern:        [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Jul 28 02:10:39 kern:        [<b028ab50>] xfs_file_ioctl_invis+0x30/0x70
Jul 28 02:10:39 kern:        [<b028ab20>] xfs_file_ioctl_invis+0x0/0x70
Jul 28 02:10:39 kern:        [<b01839fb>] do_ioctl+0x2b/0x90
Jul 28 02:10:39 kern:        [<b0183c91>] vfs_ioctl+0x231/0x2b0
Jul 28 02:10:39 kern:        [<b0183d4d>] sys_ioctl+0x3d/0x70
Jul 28 02:10:39 kern:        [<b0104376>] sysenter_past_esp+0x5f/0xa5
Jul 28 02:10:39 kern:        [<ffffffff>] 0xffffffff
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: -> #0 (&(&ip->i_lock)->mr_lock/2){----}:
Jul 28 02:10:39 kern:        [<b01475e0>] print_circular_bug_entry+0x40/0x50
Jul 28 02:10:39 kern:        [<b0149e3d>] __lock_acquire+0xa2d/0x10b0
Jul 28 02:10:39 kern:        [<b014a521>] lock_acquire+0x61/0x80
Jul 28 02:10:39 kern:        [<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:39 kern:        [<b013f6f8>] down_write_nested+0x38/0x60
Jul 28 02:10:39 kern:        [<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:39 kern:        [<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:39 kern:        [<b027fb92>] xfs_lock_inodes+0x112/0x160
Jul 28 02:10:39 kern:        [<b0269b98>] xfs_swap_extents+0x358/0x5c0
Jul 28 02:10:39 kern:        [<b02902f7>] __vn_revalidate+0x47/0x80
Jul 28 02:10:39 kern:        [<b026981b>] xfs_swapext+0x13b/0x160
Jul 28 02:10:39 kern:        [<b028ca91>] xfs_ioctl+0x521/0x750
Jul 28 02:10:39 kern:        [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Jul 28 02:10:39 kern:        [<b028ab50>] xfs_file_ioctl_invis+0x30/0x70
Jul 28 02:10:39 kern:        [<b028ab20>] xfs_file_ioctl_invis+0x0/0x70
Jul 28 02:10:39 kern:        [<b01839fb>] do_ioctl+0x2b/0x90
Jul 28 02:10:39 kern:        [<b0183c91>] vfs_ioctl+0x231/0x2b0
Jul 28 02:10:39 kern:        [<b0183d4d>] sys_ioctl+0x3d/0x70
Jul 28 02:10:39 kern:        [<b0104376>] sysenter_past_esp+0x5f/0xa5
Jul 28 02:10:39 kern:        [<ffffffff>] 0xffffffff
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: other info that might help us debug this:
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: 2 locks held by xfs_fsr/17758:
Jul 28 02:10:39 kern:  #0:  (&(&ip->i_iolock)->mr_lock/2){--..}, at: 
[<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:  #1:  (&(&ip->i_iolock)->mr_lock/3){--..}, at: 
[<b025ed17>] xfs_ilock+0x97/0xb0
Jul 28 02:10:39 kern:
Jul 28 02:10:39 kern: stack backtrace:
Jul 28 02:10:39 kern: Pid: 17758, comm: xfs_fsr Not tainted 2.6.24.2-ish #5
Jul 28 02:10:39 kern:  [<b014807a>] print_circular_bug_tail+0x7a/0x90
Jul 28 02:10:39 kern:  [<b0149e3d>] __lock_acquire+0xa2d/0x10b0
Jul 28 02:10:39 kern:  [<b014a521>] lock_acquire+0x61/0x80
Jul 28 02:10:39 kern:  [<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:39 kern:  [<b013f6f8>] down_write_nested+0x38/0x60
Jul 28 02:10:39 kern:  [<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:39 kern:  [<b025eced>] xfs_ilock+0x6d/0xb0
Jul 28 02:10:39 kern:  [<b027fb92>] xfs_lock_inodes+0x112/0x160
Jul 28 02:10:39 kern:  [<b0269b98>] xfs_swap_extents+0x358/0x5c0
Jul 28 02:10:39 kern:  [<b02902f7>] __vn_revalidate+0x47/0x80
Jul 28 02:10:39 kern:  [<b026981b>] xfs_swapext+0x13b/0x160
Jul 28 02:10:39 kern:  [<b028ca91>] xfs_ioctl+0x521/0x750
Jul 28 02:10:39 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Jul 28 02:10:39 kern:  [<b028ab50>] xfs_file_ioctl_invis+0x30/0x70
Jul 28 02:10:39 kern:  [<b028ab20>] xfs_file_ioctl_invis+0x0/0x70
Jul 28 02:10:39 kern:  [<b01839fb>] do_ioctl+0x2b/0x90
Jul 28 02:10:39 kern:  [<b0183c91>] vfs_ioctl+0x231/0x2b0
Jul 28 02:10:39 kern:  [<b0183d4d>] sys_ioctl+0x3d/0x70
Jul 28 02:10:39 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Jul 28 02:10:39 kern:  =======================

---
boot-080728.0555:<5>Linux version 2.6.24.2-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #5 SMP Fri Feb 15 17:55:46 PST 2008
---

Jul 28 07:18:52 Ish squid[2124]: WARNING: Median response time is 41553 
milliseconds
Jul 28 12:53:55 Ish xinetd[1949]: Exiting...
Jul 28 12:53:55 Ish apcupsd[1915]: apcupsd exiting, signal 15
Jul 28 12:53:56 Ish apcupsd[1915]: apcupsd shutdown succeeded
Jul 28 12:56:15 Ish squid[2184]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Jul 28 16:55:20 Ish squid[2184]: WARNING: Median response time is 79423 
milliseconds
Jul 28 16:56:20 Ish squid[2184]: WARNING: Median response time is 79423 
milliseconds
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: 
=======================================================
Jul 29 02:07:29 kern: [ INFO: possible circular locking dependency 
detected ]
Jul 29 02:07:29 kern: 2.6.25.12-ish #2
Jul 29 02:07:29 kern: 
-------------------------------------------------------
Jul 29 02:07:29 kern: imapds/26747 is trying to acquire lock:
Jul 29 02:07:29 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: but task is already holding lock:
Jul 29 02:07:29 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: which lock already depends on the new lock.
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: the existing dependency chain (in reverse order) is:
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: -> #1 (&(&ip->i_iolock)->mr_lock){----}:
Jul 29 02:07:29 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Jul 29 02:07:29 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Jul 29 02:07:29 kern:        [<c023e066>] down_write_nested+0x46/0x70
Jul 29 02:07:29 kern:        [<c0357b47>] xfs_ilock+0x97/0xb0
Jul 29 02:07:29 kern:        [<c0357d00>] xfs_ireclaim+0x30/0x70
Jul 29 02:07:29 kern:        [<c037600f>] xfs_finish_reclaim+0x4f/0x180
Jul 29 02:07:29 kern:        [<c0377ae7>] xfs_reclaim+0xe7/0xf0
Jul 29 02:07:29 kern:        [<c0385028>] xfs_fs_clear_inode+0xa8/0xe0
Jul 29 02:07:29 kern:        [<c028a959>] clear_inode+0x79/0x100
Jul 29 02:07:29 kern:        [<c028ac27>] dispose_list+0x27/0xf0
Jul 29 02:07:29 kern:        [<c028ae72>] shrink_icache_memory+0x182/0x250
Jul 29 02:07:29 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Jul 29 02:07:29 kern:        [<c026133e>] kswapd+0x2ee/0x460
Jul 29 02:07:29 kern:        [<c0239fc2>] kthread+0x42/0x70
Jul 29 02:07:29 kern:        [<c0204d97>] kernel_thread_helper+0x7/0x10
Jul 29 02:07:29 kern:        [<ffffffff>] 0xffffffff
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: -> #0 (iprune_mutex){--..}:
Jul 29 02:07:29 kern:        [<c02486e7>] __lock_acquire+0x967/0xf90
Jul 29 02:07:29 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Jul 29 02:07:29 kern:        [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Jul 29 02:07:29 kern:        [<c028ad52>] shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Jul 29 02:07:29 kern:        [<c0260f0e>] try_to_free_pages+0x14e/0x210
Jul 29 02:07:29 kern:        [<c025bf28>] __alloc_pages+0x138/0x350
Jul 29 02:07:29 kern:        [<c025e03b>] 
__do_page_cache_readahead+0x13b/0x240
Jul 29 02:07:29 kern:        [<c025e311>] ondemand_readahead+0xc1/0x180
Jul 29 02:07:29 kern:        [<c025e432>] 
page_cache_async_readahead+0x62/0x80
Jul 29 02:07:29 kern:        [<c02585bc>] generic_file_aio_read+0x28c/0x5c0
Jul 29 02:07:29 kern:        [<c0384113>] xfs_read+0x133/0x2b0
Jul 29 02:07:29 kern:        [<c0380aec>] xfs_file_aio_read+0x5c/0x70
Jul 29 02:07:29 kern:        [<c027718d>] do_sync_read+0xcd/0x110
Jul 29 02:07:29 kern:        [<c0277a14>] vfs_read+0x94/0x130
Jul 29 02:07:29 kern:        [<c0277eed>] sys_read+0x3d/0x70
Jul 29 02:07:29 kern:        [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:07:29 kern:        [<ffffffff>] 0xffffffff
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: other info that might help us debug this:
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: 2 locks held by imapds/26747:
Jul 29 02:07:29 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 29 02:07:29 kern:  #1:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170
Jul 29 02:07:29 kern:
Jul 29 02:07:29 kern: stack backtrace:
Jul 29 02:07:29 kern: Pid: 26747, comm: imapds Not tainted 2.6.25.12-ish #2
Jul 29 02:07:29 kern:  [<c02469ef>] print_circular_bug_tail+0x6f/0x80
Jul 29 02:07:29 kern:  [<c02486e7>] __lock_acquire+0x967/0xf90
Jul 29 02:07:29 kern:  [<c0398db1>] ? cfq_add_rq_rb+0x61/0x90
Jul 29 02:07:29 kern:  [<c0247ecc>] ? __lock_acquire+0x14c/0xf90
Jul 29 02:07:29 kern:  [<c0248d70>] lock_acquire+0x60/0x80
Jul 29 02:07:29 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern:  [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Jul 29 02:07:29 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern:  [<c028ad52>] shrink_icache_memory+0x62/0x250
Jul 29 02:07:29 kern:  [<c0260d5b>] shrink_slab+0x10b/0x170
Jul 29 02:07:29 kern:  [<c0260f0e>] try_to_free_pages+0x14e/0x210
Jul 29 02:07:29 kern:  [<c025fa80>] ? isolate_pages_global+0x0/0x60
Jul 29 02:07:29 kern:  [<c025bf28>] __alloc_pages+0x138/0x350
Jul 29 02:07:29 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Jul 29 02:07:29 kern:  [<c025e03b>] __do_page_cache_readahead+0x13b/0x240
Jul 29 02:07:29 kern:  [<c025dfad>] ? __do_page_cache_readahead+0xad/0x240
Jul 29 02:07:29 kern:  [<c025e311>] ondemand_readahead+0xc1/0x180
Jul 29 02:07:29 kern:  [<c025e432>] page_cache_async_readahead+0x62/0x80
Jul 29 02:07:29 kern:  [<c02585bc>] generic_file_aio_read+0x28c/0x5c0
Jul 29 02:07:29 kern:  [<c023e1b6>] ? down_read_nested+0x46/0x60
Jul 29 02:07:29 kern:  [<c0384113>] xfs_read+0x133/0x2b0
Jul 29 02:07:29 kern:  [<c0380aec>] xfs_file_aio_read+0x5c/0x70
Jul 29 02:07:29 kern:  [<c027718d>] do_sync_read+0xcd/0x110
Jul 29 02:07:29 kern:  [<c023a2b0>] ? autoremove_wake_function+0x0/0x40
Jul 29 02:07:29 kern:  [<c02478c0>] ? trace_hardirqs_on+0xa0/0x120
Jul 29 02:07:29 kern:  [<c0520c98>] ? mutex_unlock+0x8/0x10
Jul 29 02:07:29 kern:  [<c0277a14>] vfs_read+0x94/0x130
Jul 29 02:07:29 kern:  [<c0276cac>] ? vfs_llseek+0x3c/0x50
Jul 29 02:07:29 kern:  [<c02770c0>] ? do_sync_read+0x0/0x110
Jul 29 02:07:29 kern:  [<c0277eed>] sys_read+0x3d/0x70
Jul 29 02:07:29 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:07:29 kern:  =======================
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d9bc3b28 00200046 db454000 c06a4180 
c06a4180 c06a4180 00000001 00000002
Jul 29 02:45:59 kern:        7ffc6e9b 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 db454000 db454248
Jul 29 02:45:59 kern:        c181a180 00000001 d9bc2000 e307f900 
00000000 00000004 00000000 00200046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035343a>] xfs_ialloc_read_agi+0x7a/0x130
Jul 29 02:45:59 kern:  [<c035471f>] xfs_ialloc_ag_select+0x1ef/0x2f0
Jul 29 02:45:59 kern:  [<c04c78a5>] ? ip_output+0x45/0x50
Jul 29 02:45:59 kern:  [<c0354af4>] xfs_dialloc+0x2d4/0x860
Jul 29 02:45:59 kern:  [<c0358f69>] ? xfs_iext_bno_to_ext+0x99/0x1a0
Jul 29 02:45:59 kern:  [<c03359ff>] ? 
xfs_bmap_search_multi_extents+0x6f/0xf0
Jul 29 02:45:59 kern:  [<c035c4b6>] xfs_ialloc+0x56/0x5b0
Jul 29 02:45:59 kern:  [<c0364967>] ? xlog_grant_log_space+0x227/0x260
Jul 29 02:45:59 kern:  [<c0373aec>] xfs_dir_ialloc+0x6c/0x2a0
Jul 29 02:45:59 kern:  [<c023e066>] ? down_write_nested+0x46/0x70
Jul 29 02:45:59 kern:  [<c0357b1e>] ? xfs_ilock+0x6e/0xb0
Jul 29 02:45:59 kern:  [<c037815a>] xfs_create+0x2ba/0x460
Jul 29 02:45:59 kern:  [<c038345f>] xfs_vn_mknod+0x17f/0x2c0
Jul 29 02:45:59 kern:  [<c03835c0>] ? xfs_vn_create+0x0/0x20
Jul 29 02:45:59 kern:  [<c03835d2>] xfs_vn_create+0x12/0x20
Jul 29 02:45:59 kern:  [<c027f2b3>] vfs_create+0x83/0xc0
Jul 29 02:45:59 kern:  [<c02820bf>] open_namei+0x55f/0x680
Jul 29 02:45:59 kern:  [<c027a80e>] ? vfs_lstat_fd+0x1e/0x50
Jul 29 02:45:59 kern:  [<c0275a7c>] do_filp_open+0x2c/0x50
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c0275825>] ? get_unused_fd_flags+0xb5/0xd0
Jul 29 02:45:59 kern:  [<c0275ae9>] do_sys_open+0x49/0xe0
Jul 29 02:45:59 kern:  [<c0275be9>] sys_open+0x29/0x40
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        db43de6c 00200046 db43de44 db43df14 
f2831015 00000002 00000001 00000000
Jul 29 02:45:59 kern:        7ffc91db 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d23b8000 d23b8248
Jul 29 02:45:59 kern:        c181a180 00000001 db43c000 f7666480 
f2831000 00000004 00000000 f7aef0c0
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c0520d92>] mutex_lock_nested+0xf2/0x270
Jul 29 02:45:59 kern:  [<c0281c50>] ? open_namei+0xf0/0x680
Jul 29 02:45:59 kern:  [<c0281c50>] ? open_namei+0xf0/0x680
Jul 29 02:45:59 kern:  [<c0281c50>] open_namei+0xf0/0x680
Jul 29 02:45:59 kern:  [<c027a80e>] ? vfs_lstat_fd+0x1e/0x50
Jul 29 02:45:59 kern:  [<c0275a7c>] do_filp_open+0x2c/0x50
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c0275825>] ? get_unused_fd_flags+0xb5/0xd0
Jul 29 02:45:59 kern:  [<c0275ae9>] do_sys_open+0x49/0xe0
Jul 29 02:45:59 kern:  [<c0275be9>] sys_open+0x29/0x40
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d9bc3b28 00200046 db454000 c06a4180 
c06a4180 c06a4180 00000001 00000002
Jul 29 02:45:59 kern:        7ffc6e9b 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 db454000 db454248
Jul 29 02:45:59 kern:        c181a180 00000001 d9bc2000 e307f900 
00000000 00000004 00000000 00200046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035343a>] xfs_ialloc_read_agi+0x7a/0x130
Jul 29 02:45:59 kern:  [<c035471f>] xfs_ialloc_ag_select+0x1ef/0x2f0
Jul 29 02:45:59 kern:  [<c04c78a5>] ? ip_output+0x45/0x50
Jul 29 02:45:59 kern:  [<c0354af4>] xfs_dialloc+0x2d4/0x860
Jul 29 02:45:59 kern:  [<c0358f69>] ? xfs_iext_bno_to_ext+0x99/0x1a0
Jul 29 02:45:59 kern:  [<c03359ff>] ? 
xfs_bmap_search_multi_extents+0x6f/0xf0
Jul 29 02:45:59 kern:  [<c035c4b6>] xfs_ialloc+0x56/0x5b0
Jul 29 02:45:59 kern:  [<c0364967>] ? xlog_grant_log_space+0x227/0x260
Jul 29 02:45:59 kern:  [<c0373aec>] xfs_dir_ialloc+0x6c/0x2a0
Jul 29 02:45:59 kern:  [<c023e066>] ? down_write_nested+0x46/0x70
Jul 29 02:45:59 kern:  [<c0357b1e>] ? xfs_ilock+0x6e/0xb0
Jul 29 02:45:59 kern:  [<c037815a>] xfs_create+0x2ba/0x460
Jul 29 02:45:59 kern:  [<c038345f>] xfs_vn_mknod+0x17f/0x2c0
Jul 29 02:45:59 kern:  [<c03835c0>] ? xfs_vn_create+0x0/0x20
Jul 29 02:45:59 kern:  [<c03835d2>] xfs_vn_create+0x12/0x20
Jul 29 02:45:59 kern:  [<c027f2b3>] vfs_create+0x83/0xc0
Jul 29 02:45:59 kern:  [<c02820bf>] open_namei+0x55f/0x680
Jul 29 02:45:59 kern:  [<c027a80e>] ? vfs_lstat_fd+0x1e/0x50
Jul 29 02:45:59 kern:  [<c0275a7c>] do_filp_open+0x2c/0x50
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c0275825>] ? get_unused_fd_flags+0xb5/0xd0
Jul 29 02:45:59 kern:  [<c0275ae9>] do_sys_open+0x49/0xe0
Jul 29 02:45:59 kern:  [<c0275be9>] sys_open+0x29/0x40
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        db43de6c 00200046 db43de44 db43df14 
f2831015 00000002 00000001 00000000
Jul 29 02:45:59 kern:        7ffc91db 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d23b8000 d23b8248
Jul 29 02:45:59 kern:        c181a180 00000001 db43c000 f7666480 
f2831000 00000004 00000000 f7aef0c0
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c0520d92>] mutex_lock_nested+0xf2/0x270
Jul 29 02:45:59 kern:  [<c0281c50>] ? open_namei+0xf0/0x680
Jul 29 02:45:59 kern:  [<c0281c50>] ? open_namei+0xf0/0x680
Jul 29 02:45:59 kern:  [<c0281c50>] open_namei+0xf0/0x680
Jul 29 02:45:59 kern:  [<c027a80e>] ? vfs_lstat_fd+0x1e/0x50
Jul 29 02:45:59 kern:  [<c0275a7c>] do_filp_open+0x2c/0x50
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c0275825>] ? get_unused_fd_flags+0xb5/0xd0
Jul 29 02:45:59 kern:  [<c0275ae9>] do_sys_open+0x49/0xe0
Jul 29 02:45:59 kern:  [<c0275be9>] sys_open+0x29/0x40
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        d22edd64 00000046 d2280000 d22edd40 
c04d821c 00000002 00000001 00000002
Jul 29 02:45:59 kern:        80046ee9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 d2280000 d2280248
Jul 29 02:45:59 kern:        c181a180 00000001 d22ec000 e307f240 
00000000 00000000 00000000 00000046
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c04d821c>] ? tcp_transmit_skb+0x3fc/0x770
Jul 29 02:45:59 kern:  [<c0522148>] __down+0x88/0xf0
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c0521ef2>] __down_failed+0xa/0x10
Jul 29 02:45:59 kern:  [<c0391ba3>] ? generic_unplug_device+0x23/0x30
Jul 29 02:45:59 kern:  [<c037e2fc>] xfs_buf_lock+0x4c/0x50
Jul 29 02:45:59 kern:  [<c037fc8c>] _xfs_buf_find+0xfc/0x1f0
Jul 29 02:45:59 kern:  [<c037baa5>] ? kmem_zone_alloc+0x55/0xb0
Jul 29 02:45:59 kern:  [<c037fdd8>] xfs_buf_get_flags+0x58/0x140
Jul 29 02:45:59 kern:  [<c037fedd>] xfs_buf_read_flags+0x1d/0x90
Jul 29 02:45:59 kern:  [<c0372a74>] xfs_trans_read_buf+0x224/0x340
Jul 29 02:45:59 kern:  [<c035b20e>] xfs_iunlink+0x9e/0x210
Jul 29 02:45:59 kern:  [<c0372daf>] ? xfs_trans_log_inode+0x1f/0x50
Jul 29 02:45:59 kern:  [<c037394e>] xfs_droplink+0x4e/0x60
Jul 29 02:45:59 kern:  [<c037a66e>] xfs_remove+0x28e/0x3a0
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c0382d21>] xfs_vn_unlink+0x21/0x50
Jul 29 02:45:59 kern:  [<c0382d00>] ? xfs_vn_unlink+0x0/0x50
Jul 29 02:45:59 kern:  [<c027f35a>] vfs_unlink+0x6a/0xd0
Jul 29 02:45:59 kern:  [<c02811c1>] do_unlinkat+0xc1/0x150
Jul 29 02:45:59 kern:  [<c0281260>] sys_unlink+0x10/0x20
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 kern:        f6763df8 00200046 00000001 c1811180 
00e557a4 00000000 00000001 f7c5a000
Jul 29 02:45:59 kern:        7ffbeeb9 00002e4a c06a0fa0 c06a4180 
c06a4180 c06a4180 f65ac000 f65ac248
Jul 29 02:45:59 kern:        c181a180 00000001 f6762000 f669dd80 
f6763e94 00000002 00000000 00000000
Jul 29 02:45:59 kern: Call Trace:
Jul 29 02:45:59 kern:  [<c021eb7b>] ? default_wake_function+0xb/0x10
Jul 29 02:45:59 kern:  [<c0520515>] schedule_timeout+0x75/0xc0
Jul 29 02:45:59 kern:  [<c0520298>] wait_for_common+0x88/0x150
Jul 29 02:45:59 kern:  [<c021eb70>] ? default_wake_function+0x0/0x10
Jul 29 02:45:59 kern:  [<c05203f2>] wait_for_completion+0x12/0x20
Jul 29 02:45:59 kern:  [<c02364dd>] call_usermodehelper_exec+0x9d/0xb0
Jul 29 02:45:59 kern:  [<c023637a>] ? call_usermodehelper_setup+0x4a/0x80
Jul 29 02:45:59 kern:  [<c0236778>] request_module+0x98/0xe0
Jul 29 02:45:59 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 29 02:45:59 kern:  [<c04a1a7f>] __sock_create+0x1af/0x1e0
Jul 29 02:45:59 kern:  [<c04a1b1a>] sock_create+0x3a/0x50
Jul 29 02:45:59 kern:  [<c04a1cbb>] sys_socket+0x1b/0x50
Jul 29 02:45:59 kern:  [<c04a265f>] sys_socketcall+0x24f/0x260
Jul 29 02:45:59 kern:  [<c02040f9>] ? sysenter_past_esp+0x9a/0xa5
Jul 29 02:45:59 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 29 02:45:59 kern:  =======================
Jul 29 02:45:59 kern: INFO: lockdep is turned off.
Jul 29 02:45:59 Ish sendmail[23107]: m6T9jxUp023107: collect: premature 
EOM: unexpected close
Jul 29 06:25:53 kern: Clocksource tsc unstable (delta = -90402575 ns)
Jul 29 16:38:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds
Jul 29 16:39:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds
Jul 29 16:40:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds
Jul 29 16:41:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds
Jul 29 16:42:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds
Jul 29 16:43:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds
Jul 29 16:44:05 Ish squid[2184]: WARNING: Median response time is 83828 
milliseconds

---
boot-080729.1937:<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #2 SMP Mon Jul 28 12:51:23 PDT 2008
---


Jul 30 02:37:59 Ish squid[2255]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Jul 30 07:39:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:40:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:41:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:42:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:43:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:44:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:45:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 07:46:05 Ish squid[2255]: WARNING: Median response time is 43858 
milliseconds
Jul 30 16:51:15 Ish squid[2255]: WARNING: Median response time is 30056 
milliseconds
Jul 30 16:52:15 Ish squid[2255]: WARNING: Median response time is 30056 
milliseconds
Jul 30 16:53:15 Ish squid[2255]: WARNING: Median response time is 30056 
milliseconds
Jul 30 16:54:15 Ish squid[2255]: WARNING: Median response time is 30056 
milliseconds
Jul 30 16:55:15 Ish squid[2255]: WARNING: Median response time is 30056 
milliseconds
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: 
=======================================================
Jul 31 02:13:19 kern: [ INFO: possible circular locking dependency 
detected ]
Jul 31 02:13:19 kern: 2.6.25.12-ish #2
Jul 31 02:13:19 kern: 
-------------------------------------------------------
Jul 31 02:13:19 kern: xfs_fsr/12232 is trying to acquire lock:
Jul 31 02:13:19 kern:  (&mm->mmap_sem){----}, at: [<c029d8aa>] 
dio_get_page+0x6a/0x170
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: but task is already holding lock:
Jul 31 02:13:19 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: which lock already depends on the new lock.
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: the existing dependency chain (in reverse order) is:
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: -> #1 (&(&ip->i_iolock)->mr_lock){----}:
Jul 31 02:13:19 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Jul 31 02:13:19 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Jul 31 02:13:19 kern:        [<c023e066>] down_write_nested+0x46/0x70
Jul 31 02:13:19 kern:        [<c0357b47>] xfs_ilock+0x97/0xb0
Jul 31 02:13:19 kern:        [<c03767a1>] xfs_free_eofblocks+0x211/0x2b0
Jul 31 02:13:19 kern:        [<c037a92d>] xfs_release+0x1ad/0x200
Jul 31 02:13:19 kern:        [<c03808ee>] xfs_file_release+0xe/0x20
Jul 31 02:13:19 kern:        [<c02783ab>] __fput+0xbb/0x180
Jul 31 02:13:19 kern:        [<c0278669>] fput+0x19/0x20
Jul 31 02:13:19 kern:        [<c0267a0c>] remove_vma+0x3c/0x50
Jul 31 02:13:19 kern:        [<c02684fc>] do_munmap+0x18c/0x1f0
Jul 31 02:13:19 kern:        [<c0268590>] sys_munmap+0x30/0x50
Jul 31 02:13:19 kern:        [<c0204146>] syscall_call+0x7/0xb
Jul 31 02:13:19 kern:        [<ffffffff>] 0xffffffff
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: -> #0 (&mm->mmap_sem){----}:
Jul 31 02:13:19 kern:        [<c02486e7>] __lock_acquire+0x967/0xf90
Jul 31 02:13:19 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Jul 31 02:13:19 kern:        [<c052131f>] down_read+0x3f/0x60
Jul 31 02:13:19 kern:        [<c029d8aa>] dio_get_page+0x6a/0x170
Jul 31 02:13:19 kern:        [<c029e434>] __blockdev_direct_IO+0x404/0xd00
Jul 31 02:13:19 kern:        [<c037c68c>] xfs_vm_direct_IO+0xfc/0x110
Jul 31 02:13:19 kern:        [<c025736a>] generic_file_direct_IO+0xba/0x150
Jul 31 02:13:19 kern:        [<c0257459>] 
generic_file_direct_write+0x59/0x160
Jul 31 02:13:19 kern:        [<c03845c1>] xfs_write+0x331/0x7f0
Jul 31 02:13:19 kern:        [<c0380a7e>] xfs_file_aio_write+0x5e/0x70
Jul 31 02:13:19 kern:        [<c027707d>] do_sync_write+0xcd/0x110
Jul 31 02:13:19 kern:        [<c02778e6>] vfs_write+0x96/0x130
Jul 31 02:13:19 kern:        [<c0277f5d>] sys_write+0x3d/0x70
Jul 31 02:13:19 kern:        [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 31 02:13:19 kern:        [<ffffffff>] 0xffffffff
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: other info that might help us debug this:
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: 1 lock held by xfs_fsr/12232:
Jul 31 02:13:19 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Jul 31 02:13:19 kern:
Jul 31 02:13:19 kern: stack backtrace:
Jul 31 02:13:19 kern: Pid: 12232, comm: xfs_fsr Not tainted 2.6.25.12-ish #2
Jul 31 02:13:19 kern:  [<c02469ef>] print_circular_bug_tail+0x6f/0x80
Jul 31 02:13:19 kern:  [<c02486e7>] __lock_acquire+0x967/0xf90
Jul 31 02:13:19 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Jul 31 02:13:19 kern:  [<c0248d70>] lock_acquire+0x60/0x80
Jul 31 02:13:19 kern:  [<c029d8aa>] ? dio_get_page+0x6a/0x170
Jul 31 02:13:19 kern:  [<c052131f>] down_read+0x3f/0x60
Jul 31 02:13:19 kern:  [<c029d8aa>] ? dio_get_page+0x6a/0x170
Jul 31 02:13:19 kern:  [<c029d8aa>] dio_get_page+0x6a/0x170
Jul 31 02:13:19 kern:  [<c03a3be2>] ? __spin_lock_init+0x32/0x60
Jul 31 02:13:19 kern:  [<c029e434>] __blockdev_direct_IO+0x404/0xd00
Jul 31 02:13:19 kern:  [<c027405a>] ? kmem_cache_alloc+0x8a/0xb0
Jul 31 02:13:19 kern:  [<c02478c0>] ? trace_hardirqs_on+0xa0/0x120
Jul 31 02:13:19 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Jul 31 02:13:19 kern:  [<c037c68c>] xfs_vm_direct_IO+0xfc/0x110
Jul 31 02:13:19 kern:  [<c037cb30>] ? xfs_get_blocks_direct+0x0/0x30
Jul 31 02:13:19 kern:  [<c037c080>] ? xfs_end_io_direct+0x0/0xa0
Jul 31 02:13:19 kern:  [<c025736a>] generic_file_direct_IO+0xba/0x150
Jul 31 02:13:19 kern:  [<c0257459>] generic_file_direct_write+0x59/0x160
Jul 31 02:13:19 kern:  [<c03845c1>] xfs_write+0x331/0x7f0
Jul 31 02:13:19 kern:  [<c0380a7e>] xfs_file_aio_write+0x5e/0x70
Jul 31 02:13:19 kern:  [<c027707d>] do_sync_write+0xcd/0x110
Jul 31 02:13:19 kern:  [<c023a2b0>] ? autoremove_wake_function+0x0/0x40
Jul 31 02:13:19 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Jul 31 02:13:19 kern:  [<c02778e6>] vfs_write+0x96/0x130
Jul 31 02:13:19 kern:  [<c0276fb0>] ? do_sync_write+0x0/0x110
Jul 31 02:13:19 kern:  [<c0277f5d>] sys_write+0x3d/0x70
Jul 31 02:13:19 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Jul 31 02:13:19 kern:  =======================
Jul 31 14:31:39 Ish squid[2255]: WARNING: Median response time is 24218 
milliseconds
Jul 31 14:32:39 Ish squid[2255]: WARNING: Median response time is 24218 
milliseconds
Jul 31 14:33:39 Ish squid[2255]: WARNING: Median response time is 24218 
milliseconds
Jul 31 14:34:39 Ish squid[2255]: WARNING: Median response time is 24218 
milliseconds
Jul 31 14:35:39 Ish squid[2255]: WARNING: Median response time is 24218 
milliseconds
Jul 31 14:36:39 Ish squid[2255]: WARNING: Median response time is 24218 
milliseconds
Jul 31 17:20:42 Ish squid[2255]: WARNING: Median response time is 30056 
milliseconds

---
boot-080731.1934:<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #2 SMP Mon Jul 28 12:51:23 PDT 2008
---

Aug  1 02:12:57 kern: hde: dma_intr: status=0xd0 { Busy }
Aug  1 02:12:57 kern: ide: failed opcode was: unknown
Aug  1 02:13:02 kern: hde: dma_intr: status=0xd0 { Busy }
Aug  1 02:13:02 kern: ide: failed opcode was: unknown
Aug  1 02:13:04 kern: hde: dma_intr: status=0xd0 { Busy }
Aug  1 02:13:04 kern: ide: failed opcode was: unknown
Aug  1 02:13:47 kern: hdf: dma_timer_expiry: dma status == 0x61
Aug  1 02:13:57 kern: hdf: DMA timeout error
Aug  1 02:13:57 kern: hdf: dma timeout error: status=0x3a { DeviceFault 
SeekComplete DataRequest Index }
Aug  1 02:13:57 kern: ide: failed opcode was: unknown
Aug  1 02:13:57 kern: pdc202xx_new: Primary channel reset.
Aug  1 02:13:57 kern: ide2: reset: success
Aug  1 02:17:16 kern: hdf: dma_timer_expiry: dma status == 0x41
Aug  1 02:18:15 kern: hdf: DMA timeout error
Aug  1 02:18:15 kern: hdf: dma timeout error: status=0x80 { Busy }
Aug  1 02:18:15 kern: ide: failed opcode was: unknown
Aug  1 02:18:15 kern: pdc202xx_new: Primary channel reset.
Aug  1 02:18:15 kern: Clocksource tsc unstable (delta = 46870588625 ns)
Aug  1 02:18:20 kern: ide2: reset: success
Aug  1 02:35:04 Ish squid[2190]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...

---
boot-080801.1916:<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #2 SMP Mon Jul 28 12:51:23 PDT 2008
---

Aug  1 17:30:21 Ish squid[2190]: WARNING: Median response time is 63997 
milliseconds
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: 
=======================================================
Aug  2 02:04:51 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  2 02:04:51 kern: 2.6.25.12-ish #2
Aug  2 02:04:51 kern: 
-------------------------------------------------------
Aug  2 02:04:51 kern: sort/24453 is trying to acquire lock:
Aug  2 02:04:51 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: but task is already holding lock:
Aug  2 02:04:51 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b47>] xfs_ilock+0x97/0xb0
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: which lock already depends on the new lock.
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: the existing dependency chain (in reverse order) is:
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: -> #1 (&(&ip->i_iolock)->mr_lock){----}:
Aug  2 02:04:51 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Aug  2 02:04:51 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  2 02:04:51 kern:        [<c023e066>] down_write_nested+0x46/0x70
Aug  2 02:04:51 kern:        [<c0357b47>] xfs_ilock+0x97/0xb0
Aug  2 02:04:51 kern:        [<c0357d00>] xfs_ireclaim+0x30/0x70
Aug  2 02:04:51 kern:        [<c037600f>] xfs_finish_reclaim+0x4f/0x180
Aug  2 02:04:51 kern:        [<c0377ae7>] xfs_reclaim+0xe7/0xf0
Aug  2 02:04:51 kern:        [<c0385028>] xfs_fs_clear_inode+0xa8/0xe0
Aug  2 02:04:51 kern:        [<c028a959>] clear_inode+0x79/0x100
Aug  2 02:04:51 kern:        [<c028ac27>] dispose_list+0x27/0xf0
Aug  2 02:04:51 kern:        [<c028ae72>] shrink_icache_memory+0x182/0x250
Aug  2 02:04:51 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  2 02:04:51 kern:        [<c026133e>] kswapd+0x2ee/0x460
Aug  2 02:04:51 kern:        [<c0239fc2>] kthread+0x42/0x70
Aug  2 02:04:51 kern:        [<c0204d97>] kernel_thread_helper+0x7/0x10
Aug  2 02:04:51 kern:        [<ffffffff>] 0xffffffff
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: -> #0 (iprune_mutex){--..}:
Aug  2 02:04:51 kern:        [<c02486e7>] __lock_acquire+0x967/0xf90
Aug  2 02:04:51 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  2 02:04:51 kern:        [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug  2 02:04:51 kern:        [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  2 02:04:51 kern:        [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug  2 02:04:51 kern:        [<c025bf28>] __alloc_pages+0x138/0x350
Aug  2 02:04:51 kern:        [<c0256aa1>] __grab_cache_page+0x71/0xb0
Aug  2 02:04:51 kern:        [<c0299270>] block_write_begin+0x70/0xe0
Aug  2 02:04:51 kern:        [<c037c353>] xfs_vm_write_begin+0x43/0x50
Aug  2 02:04:51 kern:        [<c0257654>] 
generic_file_buffered_write+0xf4/0x5b0
Aug  2 02:04:51 kern:        [<c03849b0>] xfs_write+0x720/0x7f0
Aug  2 02:04:51 kern:        [<c0380a7e>] xfs_file_aio_write+0x5e/0x70
Aug  2 02:04:51 kern:        [<c027707d>] do_sync_write+0xcd/0x110
Aug  2 02:04:51 kern:        [<c02778e6>] vfs_write+0x96/0x130
Aug  2 02:04:51 kern:        [<c0277f5d>] sys_write+0x3d/0x70
Aug  2 02:04:51 kern:        [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug  2 02:04:51 kern:        [<ffffffff>] 0xffffffff
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: other info that might help us debug this:
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: 3 locks held by sort/24453:
Aug  2 02:04:51 kern:  #0:  (&sb->s_type->i_mutex_key#3){--..}, at: 
[<c038462f>] xfs_write+0x39f/0x7f0
Aug  2 02:04:51 kern:  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b47>] xfs_ilock+0x97/0xb0
Aug  2 02:04:51 kern:  #2:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170
Aug  2 02:04:51 kern:
Aug  2 02:04:51 kern: stack backtrace:
Aug  2 02:04:51 kern: Pid: 24453, comm: sort Not tainted 2.6.25.12-ish #2
Aug  2 02:04:51 kern:  [<c02469ef>] print_circular_bug_tail+0x6f/0x80
Aug  2 02:04:51 kern:  [<c02486e7>] __lock_acquire+0x967/0xf90
Aug  2 02:04:51 kern:  [<c0248d70>] lock_acquire+0x60/0x80
Aug  2 02:04:51 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern:  [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug  2 02:04:51 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern:  [<c0287e88>] ? prune_dcache+0x108/0x1a0
Aug  2 02:04:51 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern:  [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug  2 02:04:51 kern:  [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  2 02:04:51 kern:  [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug  2 02:04:51 kern:  [<c025fa80>] ? isolate_pages_global+0x0/0x60
Aug  2 02:04:51 kern:  [<c025bf28>] __alloc_pages+0x138/0x350
Aug  2 02:04:51 kern:  [<c02478c0>] ? trace_hardirqs_on+0xa0/0x120
Aug  2 02:04:51 kern:  [<c0256aa1>] __grab_cache_page+0x71/0xb0
Aug  2 02:04:51 kern:  [<c0299270>] block_write_begin+0x70/0xe0
Aug  2 02:04:51 kern:  [<c037c353>] xfs_vm_write_begin+0x43/0x50
Aug  2 02:04:51 kern:  [<c037cb60>] ? xfs_get_blocks+0x0/0x30
Aug  2 02:04:51 kern:  [<c0257654>] generic_file_buffered_write+0xf4/0x5b0
Aug  2 02:04:51 kern:  [<c0357b1e>] ? xfs_ilock+0x6e/0xb0
Aug  2 02:04:51 kern:  [<c03849b0>] xfs_write+0x720/0x7f0
Aug  2 02:04:51 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Aug  2 02:04:51 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Aug  2 02:04:51 kern:  [<c0380a7e>] xfs_file_aio_write+0x5e/0x70
Aug  2 02:04:51 kern:  [<c027707d>] do_sync_write+0xcd/0x110
Aug  2 02:04:51 kern:  [<c023a2b0>] ? autoremove_wake_function+0x0/0x40
Aug  2 02:04:51 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Aug  2 02:04:51 kern:  [<c02778e6>] vfs_write+0x96/0x130
Aug  2 02:04:51 kern:  [<c0276fb0>] ? do_sync_write+0x0/0x110
Aug  2 02:04:51 kern:  [<c0277f5d>] sys_write+0x3d/0x70
Aug  2 02:04:51 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug  2 02:04:51 kern:  =======================
Aug  2 02:16:50 Ish squid[2243]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: 
=======================================================
Aug  3 02:11:17 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  3 02:11:17 kern: 2.6.25.12-ish #2
Aug  3 02:11:17 kern: 
-------------------------------------------------------
Aug  3 02:11:17 kern: xfs_fsr/4455 is trying to acquire lock:
Aug  3 02:11:17 kern:  (&mm->mmap_sem){----}, at: [<c029d8aa>] 
dio_get_page+0x6a/0x170
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: but task is already holding lock:
Aug  3 02:11:17 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: which lock already depends on the new lock.
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: the existing dependency chain (in reverse order) is:
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: -> #2 (&(&ip->i_iolock)->mr_lock){----}:
Aug  3 02:11:17 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Aug  3 02:11:17 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  3 02:11:17 kern:        [<c023e066>] down_write_nested+0x46/0x70
Aug  3 02:11:17 kern:        [<c0357b47>] xfs_ilock+0x97/0xb0
Aug  3 02:11:17 kern:        [<c0357d00>] xfs_ireclaim+0x30/0x70
Aug  3 02:11:17 kern:        [<c037600f>] xfs_finish_reclaim+0x4f/0x180
Aug  3 02:11:17 kern:        [<c0377ae7>] xfs_reclaim+0xe7/0xf0
Aug  3 02:11:17 kern:        [<c0385028>] xfs_fs_clear_inode+0xa8/0xe0
Aug  3 02:11:17 kern:        [<c028a959>] clear_inode+0x79/0x100
Aug  3 02:11:17 kern:        [<c028ac27>] dispose_list+0x27/0xf0
Aug  3 02:11:17 kern:        [<c028ae72>] shrink_icache_memory+0x182/0x250
Aug  3 02:11:17 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  3 02:11:17 kern:        [<c026133e>] kswapd+0x2ee/0x460
Aug  3 02:11:17 kern:        [<c0239fc2>] kthread+0x42/0x70
Aug  3 02:11:17 kern:        [<c0204d97>] kernel_thread_helper+0x7/0x10
Aug  3 02:11:17 kern:        [<ffffffff>] 0xffffffff
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: -> #1 (iprune_mutex){--..}:
Aug  3 02:11:17 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Aug  3 02:11:17 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  3 02:11:17 kern:        [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug  3 02:11:17 kern:        [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug  3 02:11:17 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  3 02:11:17 kern:        [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug  3 02:11:17 kern:        [<c025bf28>] __alloc_pages+0x138/0x350
Aug  3 02:11:17 kern:        [<c026547d>] handle_mm_fault+0x1fd/0x5d0
Aug  3 02:11:17 kern:        [<c02178be>] do_page_fault+0x10e/0x650
Aug  3 02:11:17 kern:        [<c0522afa>] error_code+0x72/0x78
Aug  3 02:11:17 kern:        [<ffffffff>] 0xffffffff
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: -> #0 (&mm->mmap_sem){----}:
Aug  3 02:11:17 kern:        [<c02486e7>] __lock_acquire+0x967/0xf90
Aug  3 02:11:17 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  3 02:11:17 kern:        [<c052131f>] down_read+0x3f/0x60
Aug  3 02:11:17 kern:        [<c029d8aa>] dio_get_page+0x6a/0x170
Aug  3 02:11:17 kern:        [<c029e434>] __blockdev_direct_IO+0x404/0xd00
Aug  3 02:11:17 kern:        [<c037c68c>] xfs_vm_direct_IO+0xfc/0x110
Aug  3 02:11:17 kern:        [<c025736a>] generic_file_direct_IO+0xba/0x150
Aug  3 02:11:17 kern:        [<c0257459>] 
generic_file_direct_write+0x59/0x160
Aug  3 02:11:17 kern:        [<c03845c1>] xfs_write+0x331/0x7f0
Aug  3 02:11:17 kern:        [<c0380a7e>] xfs_file_aio_write+0x5e/0x70
Aug  3 02:11:17 kern:        [<c027707d>] do_sync_write+0xcd/0x110
Aug  3 02:11:17 kern:        [<c02778e6>] vfs_write+0x96/0x130
Aug  3 02:11:17 kern:        [<c0277f5d>] sys_write+0x3d/0x70
Aug  3 02:11:17 kern:        [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug  3 02:11:17 kern:        [<ffffffff>] 0xffffffff
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: other info that might help us debug this:
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: 1 lock held by xfs_fsr/4455:
Aug  3 02:11:17 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug  3 02:11:17 kern:
Aug  3 02:11:17 kern: stack backtrace:
Aug  3 02:11:17 kern: Pid: 4455, comm: xfs_fsr Not tainted 2.6.25.12-ish #2
Aug  3 02:11:17 kern:  [<c02469ef>] print_circular_bug_tail+0x6f/0x80
Aug  3 02:11:17 kern:  [<c0246153>] ? print_circular_bug_entry+0x43/0x50
Aug  3 02:11:17 kern:  [<c02486e7>] __lock_acquire+0x967/0xf90
Aug  3 02:11:17 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Aug  3 02:11:17 kern:  [<c0248d70>] lock_acquire+0x60/0x80
Aug  3 02:11:17 kern:  [<c029d8aa>] ? dio_get_page+0x6a/0x170
Aug  3 02:11:17 kern:  [<c052131f>] down_read+0x3f/0x60
Aug  3 02:11:17 kern:  [<c029d8aa>] ? dio_get_page+0x6a/0x170
Aug  3 02:11:17 kern:  [<c029d8aa>] dio_get_page+0x6a/0x170
Aug  3 02:11:17 kern:  [<c03a3be2>] ? __spin_lock_init+0x32/0x60
Aug  3 02:11:17 kern:  [<c029e434>] __blockdev_direct_IO+0x404/0xd00
Aug  3 02:11:17 kern:  [<c027405a>] ? kmem_cache_alloc+0x8a/0xb0
Aug  3 02:11:17 kern:  [<c02478c0>] ? trace_hardirqs_on+0xa0/0x120
Aug  3 02:11:17 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Aug  3 02:11:17 kern:  [<c037c68c>] xfs_vm_direct_IO+0xfc/0x110
Aug  3 02:11:17 kern:  [<c037cb30>] ? xfs_get_blocks_direct+0x0/0x30
Aug  3 02:11:17 kern:  [<c037c080>] ? xfs_end_io_direct+0x0/0xa0
Aug  3 02:11:17 kern:  [<c025736a>] generic_file_direct_IO+0xba/0x150
Aug  3 02:11:17 kern:  [<c0257459>] generic_file_direct_write+0x59/0x160
Aug  3 02:11:17 kern:  [<c03845c1>] xfs_write+0x331/0x7f0
Aug  3 02:11:17 kern:  [<c0380a7e>] xfs_file_aio_write+0x5e/0x70
Aug  3 02:11:17 kern:  [<c027707d>] do_sync_write+0xcd/0x110
Aug  3 02:11:17 kern:  [<c023a2b0>] ? autoremove_wake_function+0x0/0x40
Aug  3 02:11:17 kern:  [<c052237d>] ? _spin_unlock+0x1d/0x20
Aug  3 02:11:17 kern:  [<c02778e6>] vfs_write+0x96/0x130
Aug  3 02:11:17 kern:  [<c0276fb0>] ? do_sync_write+0x0/0x110
Aug  3 02:11:17 kern:  [<c0277f5d>] sys_write+0x3d/0x70
Aug  3 02:11:17 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug  3 02:11:17 kern:  =======================
Aug  3 18:58:35 Ish squid[2243]: WARNING: Median response time is 83828 
milliseconds

---
boot-080804.1917:<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #2 SMP Mon Jul 28 12:51:23 PDT 2008
---

Aug  5 02:17:42 Ish squid[2158]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: 
=======================================================
Aug  5 02:32:13 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  5 02:32:13 kern: 2.6.25.12-ish #2
Aug  5 02:32:13 kern: 
-------------------------------------------------------
Aug  5 02:32:13 kern: imapds/2051 is trying to acquire lock:
Aug  5 02:32:13 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: but task is already holding lock:
Aug  5 02:32:13 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: which lock already depends on the new lock.
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: the existing dependency chain (in reverse order) is:
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: -> #1 (&(&ip->i_iolock)->mr_lock){----}:
Aug  5 02:32:13 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Aug  5 02:32:13 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  5 02:32:13 kern:        [<c023e066>] down_write_nested+0x46/0x70
Aug  5 02:32:13 kern:        [<c0357b47>] xfs_ilock+0x97/0xb0
Aug  5 02:32:13 kern:        [<c0357d00>] xfs_ireclaim+0x30/0x70
Aug  5 02:32:13 kern:        [<c037600f>] xfs_finish_reclaim+0x4f/0x180
Aug  5 02:32:13 kern:        [<c0377ae7>] xfs_reclaim+0xe7/0xf0
Aug  5 02:32:13 kern:        [<c0385028>] xfs_fs_clear_inode+0xa8/0xe0
Aug  5 02:32:13 kern:        [<c028a959>] clear_inode+0x79/0x100
Aug  5 02:32:13 kern:        [<c028ac27>] dispose_list+0x27/0xf0
Aug  5 02:32:13 kern:        [<c028ae72>] shrink_icache_memory+0x182/0x250
Aug  5 02:32:13 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  5 02:32:13 kern:        [<c026133e>] kswapd+0x2ee/0x460
Aug  5 02:32:13 kern:        [<c0239fc2>] kthread+0x42/0x70
Aug  5 02:32:13 kern:        [<c0204d97>] kernel_thread_helper+0x7/0x10
Aug  5 02:32:13 kern:        [<ffffffff>] 0xffffffff
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: -> #0 (iprune_mutex){--..}:
Aug  5 02:32:13 kern:        [<c02486e7>] __lock_acquire+0x967/0xf90
Aug  5 02:32:13 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug  5 02:32:13 kern:        [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug  5 02:32:13 kern:        [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug  5 02:32:13 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  5 02:32:13 kern:        [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug  5 02:32:13 kern:        [<c025bf28>] __alloc_pages+0x138/0x350
Aug  5 02:32:13 kern:        [<c025e03b>] 
__do_page_cache_readahead+0x13b/0x240
Aug  5 02:32:13 kern:        [<c025e311>] ondemand_readahead+0xc1/0x180
Aug  5 02:32:13 kern:        [<c025e432>] 
page_cache_async_readahead+0x62/0x80
Aug  5 02:32:13 kern:        [<c02585bc>] generic_file_aio_read+0x28c/0x5c0
Aug  5 02:32:13 kern:        [<c0384113>] xfs_read+0x133/0x2b0
Aug  5 02:32:13 kern:        [<c0380aec>] xfs_file_aio_read+0x5c/0x70
Aug  5 02:32:13 kern:        [<c027718d>] do_sync_read+0xcd/0x110
Aug  5 02:32:13 kern:        [<c0277a14>] vfs_read+0x94/0x130
Aug  5 02:32:13 kern:        [<c0277eed>] sys_read+0x3d/0x70
Aug  5 02:32:13 kern:        [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug  5 02:32:13 kern:        [<ffffffff>] 0xffffffff
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: other info that might help us debug this:
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: 2 locks held by imapds/2051:
Aug  5 02:32:13 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug  5 02:32:13 kern:  #1:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170
Aug  5 02:32:13 kern:
Aug  5 02:32:13 kern: stack backtrace:
Aug  5 02:32:13 kern: Pid: 2051, comm: imapds Not tainted 2.6.25.12-ish #2
Aug  5 02:32:13 kern:  [<c02469ef>] print_circular_bug_tail+0x6f/0x80
Aug  5 02:32:13 kern:  [<c02486e7>] __lock_acquire+0x967/0xf90
Aug  5 02:32:13 kern:  [<c0247ecc>] ? __lock_acquire+0x14c/0xf90
Aug  5 02:32:13 kern:  [<c0248d70>] lock_acquire+0x60/0x80
Aug  5 02:32:13 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug  5 02:32:13 kern:  [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug  5 02:32:13 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug  5 02:32:13 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug  5 02:32:13 kern:  [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug  5 02:32:13 kern:  [<c0260d5b>] shrink_slab+0x10b/0x170
Aug  5 02:32:13 kern:  [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug  5 02:32:13 kern:  [<c025fa80>] ? isolate_pages_global+0x0/0x60
Aug  5 02:32:13 kern:  [<c025bf28>] __alloc_pages+0x138/0x350
Aug  5 02:32:13 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Aug  5 02:32:13 kern:  [<c025e03b>] __do_page_cache_readahead+0x13b/0x240
Aug  5 02:32:13 kern:  [<c025dfad>] ? __do_page_cache_readahead+0xad/0x240
Aug  5 02:32:13 kern:  [<c025e311>] ondemand_readahead+0xc1/0x180
Aug  5 02:32:13 kern:  [<c025e432>] page_cache_async_readahead+0x62/0x80
Aug  5 02:32:13 kern:  [<c02585bc>] generic_file_aio_read+0x28c/0x5c0
Aug  5 02:32:13 kern:  [<c023e1b6>] ? down_read_nested+0x46/0x60
Aug  5 02:32:13 kern:  [<c0384113>] xfs_read+0x133/0x2b0
Aug  5 02:32:13 kern:  [<c0380aec>] xfs_file_aio_read+0x5c/0x70
Aug  5 02:32:13 kern:  [<c027718d>] do_sync_read+0xcd/0x110
Aug  5 02:32:13 kern:  [<c023a2b0>] ? autoremove_wake_function+0x0/0x40
Aug  5 02:32:13 kern:  [<c02478c0>] ? trace_hardirqs_on+0xa0/0x120
Aug  5 02:32:13 kern:  [<c0520c98>] ? mutex_unlock+0x8/0x10
Aug  5 02:32:13 kern:  [<c0277a14>] vfs_read+0x94/0x130
Aug  5 02:32:13 kern:  [<c0276cac>] ? vfs_llseek+0x3c/0x50
Aug  5 02:32:13 kern:  [<c02770c0>] ? do_sync_read+0x0/0x110
Aug  5 02:32:13 kern:  [<c0277eed>] sys_read+0x3d/0x70
Aug  5 02:32:13 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug  5 02:32:13 kern:  =======================
Aug  5 13:38:55 Ish squid[2158]: WARNING: Median response time is 67547 
milliseconds

---
boot-080805.1947:<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #2 SMP Mon Jul 28 12:51:23 PDT 2008
---

Aug  6 02:10:34 kern: hde: dma_intr: status=0xd0 { Busy }
Aug  6 02:10:34 kern: ide: failed opcode was: unknown
Aug  6 02:10:34 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:10:59 kern: ide2: reset: success
Aug  6 02:11:04 kern: hde: task_out_intr: status=0x58 { DriveReady 
SeekComplete DataRequest }
Aug  6 02:11:04 kern: ide: failed opcode was: unknown
Aug  6 02:11:04 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:11:04 kern: ide2: reset: success
Aug  6 02:11:09 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:11:09 kern: ide: failed opcode was: unknown
Aug  6 02:11:47 kern: hde: task_in_intr: status=0xd0 { Busy }
Aug  6 02:11:47 kern: ide: failed opcode was: unknown
Aug  6 02:11:47 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:11:50 kern: ide2: reset: success
Aug  6 02:12:30 kern: hde: task_in_intr: status=0xd0 { Busy }
Aug  6 02:12:30 kern: ide: failed opcode was: unknown
Aug  6 02:12:30 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:12:42 kern: ide2: reset: success
Aug  6 02:14:43 kern: hde: task_in_intr: status=0xd0 { Busy }
Aug  6 02:14:43 kern: ide: failed opcode was: unknown
Aug  6 02:14:43 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:14:55 kern: ide2: reset: success
Aug  6 02:15:49 kern: hde: task_in_intr: status=0xd0 { Busy }
Aug  6 02:15:49 kern: ide: failed opcode was: unknown
Aug  6 02:15:49 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:15:53 kern: ide2: reset: success
Aug  6 02:15:59 kern: hde: task_in_intr: status=0xd0 { Busy }
Aug  6 02:15:59 kern: ide: failed opcode was: unknown
Aug  6 02:15:59 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:16:03 kern: ide2: reset: success
Aug  6 02:18:27 kern: hde: task_in_intr: status=0xd0 { Busy }
Aug  6 02:18:27 kern: ide: failed opcode was: unknown
Aug  6 02:18:27 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:18:32 kern: ide2: reset: success
Aug  6 02:29:07 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:29:07 kern: ide: failed opcode was: unknown
Aug  6 02:29:09 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:29:09 kern: ide: failed opcode was: unknown
Aug  6 02:29:14 kern: hde: task_out_intr: status=0x58 { DriveReady 
SeekComplete DataRequest }
Aug  6 02:29:14 kern: ide: failed opcode was: unknown
Aug  6 02:29:49 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:29:49 kern: ide: failed opcode was: unknown
Aug  6 02:29:49 kern: hde: task_out_intr: status=0x58 { DriveReady 
SeekComplete DataRequest }
Aug  6 02:29:49 kern: ide: failed opcode was: unknown
Aug  6 02:29:49 kern: pdc202xx_new: Primary channel reset.
Aug  6 02:29:49 kern: ide2: reset: success
Aug  6 02:29:49 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:29:49 kern: ide: failed opcode was: unknown
Aug  6 02:29:50 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:29:50 kern: ide: failed opcode was: unknown
Aug  6 02:29:50 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:29:50 kern: ide: failed opcode was: unknown
Aug  6 02:30:42 kern: hdf: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:30:42 kern: ide: failed opcode was: unknown
Aug  6 02:30:42 kern: hdf: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:30:42 kern: ide: failed opcode was: unknown
Aug  6 02:33:51 kern: hde: task_out_intr: status=0x50 { DriveReady 
SeekComplete }
Aug  6 02:33:51 kern: ide: failed opcode was: unknown
Aug  6 02:47:30 Ish squid[2181]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Aug  6 02:49:37 kern: Pid: 2304, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:49:37 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:49:37 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:49:37 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:49:37 kern:  [<b026d6d3>] 
xlog_recover_insert_item_frontq+0x13/0x20
Aug  6 02:49:37 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:49:37 kern:  [<b0271e4f>] xlog_recover_commit_trans+0x3f/0x50
Aug  6 02:49:37 kern:  [<b0272005>] xlog_recover_process_data+0x1a5/0x220
Aug  6 02:49:37 kern:  [<b027298e>] xlog_do_recovery_pass+0x90e/0x9d0
Aug  6 02:49:37 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:49:37 kern:  [<b01273cb>] wake_up_klogd+0x3b/0x40
Aug  6 02:49:37 kern:  [<b0272aca>] xlog_do_log_recovery+0x7a/0xb0
Aug  6 02:49:37 kern:  [<b0272b29>] xlog_do_recover+0x29/0x130
Aug  6 02:49:37 kern:  [<b0272ccd>] xlog_recover+0x9d/0xc0
Aug  6 02:49:37 kern:  [<b026b552>] xfs_log_mount+0xa2/0x160
Aug  6 02:49:37 kern:  [<b0275e1b>] xfs_mountfs+0x89b/0xdc0
Aug  6 02:49:37 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:49:37 kern:  [<b0146dbd>] lockdep_init_map+0x3d/0x4c0
Aug  6 02:49:37 kern:  [<b02acc52>] __spin_lock_init+0x32/0x60
Aug  6 02:49:37 kern:  [<b02765da>] xfs_mru_cache_create+0x13a/0x150
Aug  6 02:49:37 kern:  [<b027e715>] xfs_mount+0x335/0x370
Aug  6 02:49:37 kern:  [<b028ff1a>] xfs_fs_fill_super+0xba/0x210
Aug  6 02:49:37 kern:  [<b02a8c7f>] snprintf+0x1f/0x30
Aug  6 02:49:37 kern:  [<b01b2a62>] disk_name+0xb2/0xc0
Aug  6 02:49:37 kern:  [<b02a75e0>] strlcpy+0x20/0x60
Aug  6 02:49:37 kern:  [<b017a175>] get_sb_bdev+0x105/0x130
Aug  6 02:49:37 kern:  [<b018e132>] alloc_vfsmnt+0x92/0xd0
Aug  6 02:49:37 kern:  [<b028f2c1>] xfs_fs_get_sb+0x21/0x30
Aug  6 02:49:37 kern:  [<b028fe60>] xfs_fs_fill_super+0x0/0x210
Aug  6 02:49:37 kern:  [<b0179c97>] vfs_kern_mount+0x37/0x90
Aug  6 02:49:37 kern:  [<b0179d4d>] do_kern_mount+0x3d/0xe0
Aug  6 02:49:37 kern:  [<b018eb6b>] do_mount+0x4eb/0x690
Aug  6 02:49:37 kern:  [<b014993c>] __lock_acquire+0x52c/0x10b0
Aug  6 02:49:37 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:49:37 kern:  [<b0429ef0>] _read_unlock_irq+0x20/0x30
Aug  6 02:49:37 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:49:37 kern:  [<b0157af5>] find_lock_page+0x25/0xa0
Aug  6 02:49:37 kern:  [<b015c3b9>] get_page_from_freelist+0x299/0x440
Aug  6 02:49:37 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:49:37 kern:  [<b015d0f0>] __alloc_pages+0x60/0x380
Aug  6 02:49:37 kern:  [<b017466b>] kmem_cache_alloc+0x9b/0xc0
Aug  6 02:49:37 kern:  [<b015d45f>] __get_free_pages+0x4f/0x60
Aug  6 02:49:37 kern:  [<b018d463>] copy_mount_options+0x43/0x130
Aug  6 02:49:37 kern:  [<b018ed87>] sys_mount+0x77/0xc0
Aug  6 02:49:37 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  6 02:49:37 kern:  =======================
Aug  6 02:49:37 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:49:37 kern: XFS: log mount failed
Aug  6 02:50:18 kern: Pid: 2333, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:18 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:18 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:18 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:18 kern:  [<b026d6d3>] 
xlog_recover_insert_item_frontq+0x13/0x20
Aug  6 02:50:18 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:18 kern:  [<b0271e4f>] xlog_recover_commit_trans+0x3f/0x50
Aug  6 02:50:18 kern:  [<b0272005>] xlog_recover_process_data+0x1a5/0x220
Aug  6 02:50:18 kern:  [<b027298e>] xlog_do_recovery_pass+0x90e/0x9d0
Aug  6 02:50:18 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:18 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:18 kern:  [<b01273cb>] wake_up_klogd+0x3b/0x40
Aug  6 02:50:18 kern:  [<b0272aca>] xlog_do_log_recovery+0x7a/0xb0
Aug  6 02:50:18 kern:  [<b0272b29>] xlog_do_recover+0x29/0x130
Aug  6 02:50:18 kern:  [<b0272ccd>] xlog_recover+0x9d/0xc0
Aug  6 02:50:18 kern:  [<b026b552>] xfs_log_mount+0xa2/0x160
Aug  6 02:50:18 kern:  [<b0275e1b>] xfs_mountfs+0x89b/0xdc0
Aug  6 02:50:18 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:18 kern:  [<b0146dbd>] lockdep_init_map+0x3d/0x4c0
Aug  6 02:50:18 kern:  [<b02acc52>] __spin_lock_init+0x32/0x60
Aug  6 02:50:18 kern:  [<b02765da>] xfs_mru_cache_create+0x13a/0x150
Aug  6 02:50:18 kern:  [<b027e715>] xfs_mount+0x335/0x370
Aug  6 02:50:18 kern:  [<b028ff1a>] xfs_fs_fill_super+0xba/0x210
Aug  6 02:50:18 kern:  [<b02a8c7f>] snprintf+0x1f/0x30
Aug  6 02:50:18 kern:  [<b01b2a62>] disk_name+0xb2/0xc0
Aug  6 02:50:18 kern:  [<b02a75e0>] strlcpy+0x20/0x60
Aug  6 02:50:18 kern:  [<b017a175>] get_sb_bdev+0x105/0x130
Aug  6 02:50:18 kern:  [<b018e132>] alloc_vfsmnt+0x92/0xd0
Aug  6 02:50:18 kern:  [<b028f2c1>] xfs_fs_get_sb+0x21/0x30
Aug  6 02:50:18 kern:  [<b028fe60>] xfs_fs_fill_super+0x0/0x210
Aug  6 02:50:18 kern:  [<b0179c97>] vfs_kern_mount+0x37/0x90
Aug  6 02:50:18 kern:  [<b0179d4d>] do_kern_mount+0x3d/0xe0
Aug  6 02:50:18 kern:  [<b018eb6b>] do_mount+0x4eb/0x690
Aug  6 02:50:18 kern:  [<b014993c>] __lock_acquire+0x52c/0x10b0
Aug  6 02:50:18 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:18 kern:  [<b0429ef0>] _read_unlock_irq+0x20/0x30
Aug  6 02:50:18 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:18 kern:  [<b0157af5>] find_lock_page+0x25/0xa0
Aug  6 02:50:18 kern:  [<b015c3b9>] get_page_from_freelist+0x299/0x440
Aug  6 02:50:18 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:18 kern:  [<b015d0f0>] __alloc_pages+0x60/0x380
Aug  6 02:50:18 kern:  [<b017466b>] kmem_cache_alloc+0x9b/0xc0
Aug  6 02:50:18 kern:  [<b015d45f>] __get_free_pages+0x4f/0x60
Aug  6 02:50:18 kern:  [<b018d463>] copy_mount_options+0x43/0x130
Aug  6 02:50:18 kern:  [<b018ed87>] sys_mount+0x77/0xc0
Aug  6 02:50:18 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  6 02:50:18 kern:  =======================
Aug  6 02:50:18 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:18 kern: XFS: log mount failed
Aug  6 02:50:26 kern: Pid: 2335, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:26 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:26 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:26 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:26 kern:  [<b026d6d3>] 
xlog_recover_insert_item_frontq+0x13/0x20
Aug  6 02:50:26 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:26 kern:  [<b0271e4f>] xlog_recover_commit_trans+0x3f/0x50
Aug  6 02:50:26 kern:  [<b0272005>] xlog_recover_process_data+0x1a5/0x220
Aug  6 02:50:26 kern:  [<b027298e>] xlog_do_recovery_pass+0x90e/0x9d0
Aug  6 02:50:26 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:26 kern:  [<b01273cb>] wake_up_klogd+0x3b/0x40
Aug  6 02:50:26 kern:  [<b0272aca>] xlog_do_log_recovery+0x7a/0xb0
Aug  6 02:50:26 kern:  [<b0272b29>] xlog_do_recover+0x29/0x130
Aug  6 02:50:26 kern:  [<b0272ccd>] xlog_recover+0x9d/0xc0
Aug  6 02:50:26 kern:  [<b026b552>] xfs_log_mount+0xa2/0x160
Aug  6 02:50:26 kern:  [<b0275e1b>] xfs_mountfs+0x89b/0xdc0
Aug  6 02:50:26 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:26 kern:  [<b0146dbd>] lockdep_init_map+0x3d/0x4c0
Aug  6 02:50:26 kern:  [<b02acc52>] __spin_lock_init+0x32/0x60
Aug  6 02:50:26 kern:  [<b02765da>] xfs_mru_cache_create+0x13a/0x150
Aug  6 02:50:26 kern:  [<b027e715>] xfs_mount+0x335/0x370
Aug  6 02:50:26 kern:  [<b028ff1a>] xfs_fs_fill_super+0xba/0x210
Aug  6 02:50:26 kern:  [<b02a8c7f>] snprintf+0x1f/0x30
Aug  6 02:50:26 kern:  [<b01b2a62>] disk_name+0xb2/0xc0
Aug  6 02:50:26 kern:  [<b02a75e0>] strlcpy+0x20/0x60
Aug  6 02:50:26 kern:  [<b017a175>] get_sb_bdev+0x105/0x130
Aug  6 02:50:26 kern:  [<b018e132>] alloc_vfsmnt+0x92/0xd0
Aug  6 02:50:26 kern:  [<b028f2c1>] xfs_fs_get_sb+0x21/0x30
Aug  6 02:50:26 kern:  [<b028fe60>] xfs_fs_fill_super+0x0/0x210
Aug  6 02:50:26 kern:  [<b0179c97>] vfs_kern_mount+0x37/0x90
Aug  6 02:50:26 kern:  [<b0179d4d>] do_kern_mount+0x3d/0xe0
Aug  6 02:50:26 kern:  [<b018eb6b>] do_mount+0x4eb/0x690
Aug  6 02:50:26 kern:  [<b014993c>] __lock_acquire+0x52c/0x10b0
Aug  6 02:50:26 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:26 kern:  [<b0429ef0>] _read_unlock_irq+0x20/0x30
Aug  6 02:50:26 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:26 kern:  [<b0157af5>] find_lock_page+0x25/0xa0
Aug  6 02:50:26 kern:  [<b015c3b9>] get_page_from_freelist+0x299/0x440
Aug  6 02:50:26 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:26 kern:  [<b015d0f0>] __alloc_pages+0x60/0x380
Aug  6 02:50:26 kern:  [<b017466b>] kmem_cache_alloc+0x9b/0xc0
Aug  6 02:50:26 kern:  [<b015d45f>] __get_free_pages+0x4f/0x60
Aug  6 02:50:26 kern:  [<b018d463>] copy_mount_options+0x43/0x130
Aug  6 02:50:26 kern:  [<b018ed87>] sys_mount+0x77/0xc0
Aug  6 02:50:26 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  6 02:50:26 kern:  =======================
Aug  6 02:50:26 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:26 kern: XFS: log mount failed
Aug  6 02:50:37 kern: Pid: 2340, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:37 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:37 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:37 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:37 kern:  [<b026d6d3>] 
xlog_recover_insert_item_frontq+0x13/0x20
Aug  6 02:50:37 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:37 kern:  [<b0271e4f>] xlog_recover_commit_trans+0x3f/0x50
Aug  6 02:50:37 kern:  [<b0272005>] xlog_recover_process_data+0x1a5/0x220
Aug  6 02:50:37 kern:  [<b027298e>] xlog_do_recovery_pass+0x90e/0x9d0
Aug  6 02:50:37 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:37 kern:  [<b01273cb>] wake_up_klogd+0x3b/0x40
Aug  6 02:50:37 kern:  [<b0272aca>] xlog_do_log_recovery+0x7a/0xb0
Aug  6 02:50:37 kern:  [<b0272b29>] xlog_do_recover+0x29/0x130
Aug  6 02:50:37 kern:  [<b0272ccd>] xlog_recover+0x9d/0xc0
Aug  6 02:50:37 kern:  [<b026b552>] xfs_log_mount+0xa2/0x160
Aug  6 02:50:37 kern:  [<b0275e1b>] xfs_mountfs+0x89b/0xdc0
Aug  6 02:50:37 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:37 kern:  [<b0146dbd>] lockdep_init_map+0x3d/0x4c0
Aug  6 02:50:37 kern:  [<b02acc52>] __spin_lock_init+0x32/0x60
Aug  6 02:50:37 kern:  [<b02765da>] xfs_mru_cache_create+0x13a/0x150
Aug  6 02:50:37 kern:  [<b027e715>] xfs_mount+0x335/0x370
Aug  6 02:50:37 kern:  [<b028ff1a>] xfs_fs_fill_super+0xba/0x210
Aug  6 02:50:37 kern:  [<b02a8c7f>] snprintf+0x1f/0x30
Aug  6 02:50:37 kern:  [<b01b2a62>] disk_name+0xb2/0xc0
Aug  6 02:50:37 kern:  [<b02a75e0>] strlcpy+0x20/0x60
Aug  6 02:50:37 kern:  [<b017a175>] get_sb_bdev+0x105/0x130
Aug  6 02:50:37 kern:  [<b018e132>] alloc_vfsmnt+0x92/0xd0
Aug  6 02:50:37 kern:  [<b028f2c1>] xfs_fs_get_sb+0x21/0x30
Aug  6 02:50:37 kern:  [<b028fe60>] xfs_fs_fill_super+0x0/0x210
Aug  6 02:50:37 kern:  [<b0179c97>] vfs_kern_mount+0x37/0x90
Aug  6 02:50:37 kern:  [<b0179d4d>] do_kern_mount+0x3d/0xe0
Aug  6 02:50:37 kern:  [<b018eb6b>] do_mount+0x4eb/0x690
Aug  6 02:50:37 kern:  [<b014993c>] __lock_acquire+0x52c/0x10b0
Aug  6 02:50:37 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:37 kern:  [<b0429ef0>] _read_unlock_irq+0x20/0x30
Aug  6 02:50:37 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:37 kern:  [<b0157af5>] find_lock_page+0x25/0xa0
Aug  6 02:50:37 kern:  [<b015c3b9>] get_page_from_freelist+0x299/0x440
Aug  6 02:50:37 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:37 kern:  [<b015d0f0>] __alloc_pages+0x60/0x380
Aug  6 02:50:37 kern:  [<b017466b>] kmem_cache_alloc+0x9b/0xc0
Aug  6 02:50:37 kern:  [<b015d45f>] __get_free_pages+0x4f/0x60
Aug  6 02:50:37 kern:  [<b018d463>] copy_mount_options+0x43/0x130
Aug  6 02:50:37 kern:  [<b018ed87>] sys_mount+0x77/0xc0
Aug  6 02:50:37 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  6 02:50:37 kern:  =======================
Aug  6 02:50:37 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:37 kern: XFS: log mount failed
Aug  6 02:50:55 kern: Pid: 2342, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:50:55 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:50:55 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:55 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:50:55 kern:  [<b026d6d3>] 
xlog_recover_insert_item_frontq+0x13/0x20
Aug  6 02:50:55 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:50:55 kern:  [<b0271e4f>] xlog_recover_commit_trans+0x3f/0x50
Aug  6 02:50:55 kern:  [<b0272005>] xlog_recover_process_data+0x1a5/0x220
Aug  6 02:50:55 kern:  [<b027298e>] xlog_do_recovery_pass+0x90e/0x9d0
Aug  6 02:50:55 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:55 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:55 kern:  [<b01273cb>] wake_up_klogd+0x3b/0x40
Aug  6 02:50:55 kern:  [<b0272aca>] xlog_do_log_recovery+0x7a/0xb0
Aug  6 02:50:55 kern:  [<b0272b29>] xlog_do_recover+0x29/0x130
Aug  6 02:50:55 kern:  [<b0272ccd>] xlog_recover+0x9d/0xc0
Aug  6 02:50:55 kern:  [<b026b552>] xfs_log_mount+0xa2/0x160
Aug  6 02:50:55 kern:  [<b0275e1b>] xfs_mountfs+0x89b/0xdc0
Aug  6 02:50:55 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:50:55 kern:  [<b0146dbd>] lockdep_init_map+0x3d/0x4c0
Aug  6 02:50:55 kern:  [<b02acc52>] __spin_lock_init+0x32/0x60
Aug  6 02:50:55 kern:  [<b02765da>] xfs_mru_cache_create+0x13a/0x150
Aug  6 02:50:55 kern:  [<b027e715>] xfs_mount+0x335/0x370
Aug  6 02:50:55 kern:  [<b028ff1a>] xfs_fs_fill_super+0xba/0x210
Aug  6 02:50:55 kern:  [<b02a8c7f>] snprintf+0x1f/0x30
Aug  6 02:50:55 kern:  [<b01b2a62>] disk_name+0xb2/0xc0
Aug  6 02:50:55 kern:  [<b02a75e0>] strlcpy+0x20/0x60
Aug  6 02:50:55 kern:  [<b017a175>] get_sb_bdev+0x105/0x130
Aug  6 02:50:55 kern:  [<b018e132>] alloc_vfsmnt+0x92/0xd0
Aug  6 02:50:55 kern:  [<b028f2c1>] xfs_fs_get_sb+0x21/0x30
Aug  6 02:50:55 kern:  [<b028fe60>] xfs_fs_fill_super+0x0/0x210
Aug  6 02:50:55 kern:  [<b0179c97>] vfs_kern_mount+0x37/0x90
Aug  6 02:50:55 kern:  [<b0179d4d>] do_kern_mount+0x3d/0xe0
Aug  6 02:50:55 kern:  [<b018eb6b>] do_mount+0x4eb/0x690
Aug  6 02:50:55 kern:  [<b018d8b3>] mntput_no_expire+0x13/0x60
Aug  6 02:50:55 kern:  [<b01814e5>] link_path_walk+0x65/0xc0
Aug  6 02:50:55 kern:  [<b0139445>] call_rcu+0x55/0x70
Aug  6 02:50:55 kern:  [<b0174b07>] kmem_cache_free+0xa7/0xe0
Aug  6 02:50:55 kern:  [<b015c3b9>] get_page_from_freelist+0x299/0x440
Aug  6 02:50:55 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:50:55 kern:  [<b01821c9>] __user_walk_fd+0x49/0x60
Aug  6 02:50:55 kern:  [<b015d0f0>] __alloc_pages+0x60/0x380
Aug  6 02:50:55 kern:  [<b017466b>] kmem_cache_alloc+0x9b/0xc0
Aug  6 02:50:55 kern:  [<b015d45f>] __get_free_pages+0x4f/0x60
Aug  6 02:50:55 kern:  [<b018d463>] copy_mount_options+0x43/0x130
Aug  6 02:50:55 kern:  [<b018ed87>] sys_mount+0x77/0xc0
Aug  6 02:50:55 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  6 02:50:55 kern:  =======================
Aug  6 02:50:55 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:50:55 kern: XFS: log mount failed
Aug  6 02:51:07 kern: Pid: 2346, comm: mount Not tainted 2.6.24.2-ish #5
Aug  6 02:51:07 kern:  [<b02717b5>] xlog_recover_do_inode_trans+0x695/0x9f0
Aug  6 02:51:07 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:51:07 kern:  [<b02897d5>] xfs_buf_iostart+0x25/0x90
Aug  6 02:51:07 kern:  [<b026d6d3>] 
xlog_recover_insert_item_frontq+0x13/0x20
Aug  6 02:51:07 kern:  [<b0271d8b>] xlog_recover_do_trans+0xbb/0x140
Aug  6 02:51:07 kern:  [<b0271e4f>] xlog_recover_commit_trans+0x3f/0x50
Aug  6 02:51:07 kern:  [<b0272005>] xlog_recover_process_data+0x1a5/0x220
Aug  6 02:51:07 kern:  [<b027298e>] xlog_do_recovery_pass+0x90e/0x9d0
Aug  6 02:51:07 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:51:07 kern:  [<b01273cb>] wake_up_klogd+0x3b/0x40
Aug  6 02:51:07 kern:  [<b0272aca>] xlog_do_log_recovery+0x7a/0xb0
Aug  6 02:51:07 kern:  [<b0272b29>] xlog_do_recover+0x29/0x130
Aug  6 02:51:07 kern:  [<b0272ccd>] xlog_recover+0x9d/0xc0
Aug  6 02:51:07 kern:  [<b026b552>] xfs_log_mount+0xa2/0x160
Aug  6 02:51:07 kern:  [<b0275e1b>] xfs_mountfs+0x89b/0xdc0
Aug  6 02:51:07 kern:  [<b0148d78>] mark_held_locks+0x38/0x70
Aug  6 02:51:07 kern:  [<b0146dbd>] lockdep_init_map+0x3d/0x4c0
Aug  6 02:51:07 kern:  [<b02acc52>] __spin_lock_init+0x32/0x60
Aug  6 02:51:07 kern:  [<b02765da>] xfs_mru_cache_create+0x13a/0x150
Aug  6 02:51:07 kern:  [<b027e715>] xfs_mount+0x335/0x370
Aug  6 02:51:07 kern:  [<b028ff1a>] xfs_fs_fill_super+0xba/0x210
Aug  6 02:51:07 kern:  [<b02a8c7f>] snprintf+0x1f/0x30
Aug  6 02:51:07 kern:  [<b01b2a62>] disk_name+0xb2/0xc0
Aug  6 02:51:07 kern:  [<b02a75e0>] strlcpy+0x20/0x60
Aug  6 02:51:07 kern:  [<b017a175>] get_sb_bdev+0x105/0x130
Aug  6 02:51:07 kern:  [<b018e132>] alloc_vfsmnt+0x92/0xd0
Aug  6 02:51:07 kern:  [<b028f2c1>] xfs_fs_get_sb+0x21/0x30
Aug  6 02:51:07 kern:  [<b028fe60>] xfs_fs_fill_super+0x0/0x210
Aug  6 02:51:07 kern:  [<b0179c97>] vfs_kern_mount+0x37/0x90
Aug  6 02:51:07 kern:  [<b0179d4d>] do_kern_mount+0x3d/0xe0
Aug  6 02:51:07 kern:  [<b018eb6b>] do_mount+0x4eb/0x690
Aug  6 02:51:07 kern:  [<b0166577>] handle_mm_fault+0x267/0x580
Aug  6 02:51:07 kern:  [<b0429ab4>] _spin_unlock+0x14/0x20
Aug  6 02:51:07 kern:  [<b015c3b9>] get_page_from_freelist+0x299/0x440
Aug  6 02:51:07 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  6 02:51:07 kern:  [<b015d0f0>] __alloc_pages+0x60/0x380
Aug  6 02:51:07 kern:  [<b017466b>] kmem_cache_alloc+0x9b/0xc0
Aug  6 02:51:07 kern:  [<b015d45f>] __get_free_pages+0x4f/0x60
Aug  6 02:51:07 kern:  [<b018d463>] copy_mount_options+0x43/0x130
Aug  6 02:51:07 kern:  [<b018ed87>] sys_mount+0x77/0xc0
Aug  6 02:51:07 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  6 02:51:07 kern:  =======================
Aug  6 02:51:07 kern: XFS: log mount/recovery failed: error 117
Aug  6 02:51:07 kern: XFS: log mount failed
Aug  6 12:41:04 kern: XFS: failed to read RT inodes
Aug  6 21:51:37 Ish mountd[13571]: could not open /var/lib/nfs/xtab for 
locking
Aug  6 22:00:29 Ish mountd[13572]: could not open /var/lib/nfs/rmtab for 
locking
Aug  6 22:00:41 Ish last message repeated 5 times
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: 
=======================================================
Aug  7 02:09:48 kern: [ INFO: possible circular locking dependency 
detected ]
Aug  7 02:09:48 kern: 2.6.24.2-ish #5
Aug  7 02:09:48 kern: 
-------------------------------------------------------
Aug  7 02:09:48 kern: imapds/17962 is trying to acquire lock:
Aug  7 02:09:48 kern:  (iprune_mutex){--..}, at: [<b018b973>] 
shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: but task is already holding lock:
Aug  7 02:09:48 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<b025ecdb>] xfs_ilock+0x5b/0xb0
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: which lock already depends on the new lock.
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: the existing dependency chain (in reverse order) is:
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: -> #1 (&(&ip->i_iolock)->mr_lock){----}:
Aug  7 02:09:48 kern:        [<b014a01b>] __lock_acquire+0xc0b/0x10b0
Aug  7 02:09:48 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Aug  7 02:09:48 kern:        [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  7 02:09:48 kern:        [<b014a521>] lock_acquire+0x61/0x80
Aug  7 02:09:48 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Aug  7 02:09:48 kern:        [<b013f6f8>] down_write_nested+0x38/0x60
Aug  7 02:09:48 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Aug  7 02:09:48 kern:        [<b025ed17>] xfs_ilock+0x97/0xb0
Aug  7 02:09:48 kern:        [<b025eebe>] xfs_ireclaim+0x2e/0x70
Aug  7 02:09:48 kern:        [<b027fc33>] xfs_finish_reclaim+0x53/0x1b0
Aug  7 02:09:48 kern:        [<b028f3bf>] xfs_fs_clear_inode+0xaf/0xe0
Aug  7 02:09:48 kern:        [<b018b571>] clear_inode+0x61/0x100
Aug  7 02:09:48 kern:        [<b018b97d>] shrink_icache_memory+0x7d/0x250
Aug  7 02:09:48 kern:        [<b018b83a>] dispose_list+0x1a/0xe0
Aug  7 02:09:48 kern:        [<b018ba8b>] shrink_icache_memory+0x18b/0x250
Aug  7 02:09:48 kern:        [<b01621a7>] shrink_slab+0x117/0x170
Aug  7 02:09:48 kern:        [<b016258b>] kswapd+0x30b/0x4a0
Aug  7 02:09:48 kern:        [<b013b830>] autoremove_wake_function+0x0/0x40
Aug  7 02:09:48 kern:        [<b0162280>] kswapd+0x0/0x4a0
Aug  7 02:09:48 kern:        [<b013b582>] kthread+0x42/0x70
Aug  7 02:09:48 kern:        [<b013b540>] kthread+0x0/0x70
Aug  7 02:09:48 kern:        [<b0105027>] kernel_thread_helper+0x7/0x10
Aug  7 02:09:48 kern:        [<ffffffff>] 0xffffffff
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: -> #0 (iprune_mutex){--..}:
Aug  7 02:09:48 kern:        [<b01475e0>] print_circular_bug_entry+0x40/0x50
Aug  7 02:09:48 kern:        [<b0149e3d>] __lock_acquire+0xa2d/0x10b0
Aug  7 02:09:48 kern:        [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:        [<b014a521>] lock_acquire+0x61/0x80
Aug  7 02:09:48 kern:        [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:        [<b042886f>] mutex_lock_nested+0x7f/0x2c0
Aug  7 02:09:48 kern:        [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:        [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:        [<b01620b6>] shrink_slab+0x26/0x170
Aug  7 02:09:48 kern:        [<b01621a7>] shrink_slab+0x117/0x170
Aug  7 02:09:48 kern:        [<b0162b72>] try_to_free_pages+0x172/0x250
Aug  7 02:09:48 kern:        [<b015d1e9>] __alloc_pages+0x159/0x380
Aug  7 02:09:48 kern:        [<b015f428>] 
__do_page_cache_readahead+0x148/0x260
Aug  7 02:09:48 kern:        [<b015f39d>] 
__do_page_cache_readahead+0xbd/0x260
Aug  7 02:09:48 kern:        [<b0158064>] 
do_generic_mapping_read+0x174/0x460
Aug  7 02:09:48 kern:        [<b0157660>] file_read_actor+0x0/0x120
Aug  7 02:09:48 kern:        [<b0159cc6>] generic_file_aio_read+0x116/0x1b0
Aug  7 02:09:48 kern:        [<b0157660>] file_read_actor+0x0/0x120
Aug  7 02:09:48 kern:        [<b028e65f>] xfs_read+0x13f/0x2e0
Aug  7 02:09:48 kern:        [<b028af0c>] xfs_file_aio_read+0x5c/0x70
Aug  7 02:09:48 kern:        [<b0177b27>] do_sync_read+0xc7/0x110
Aug  7 02:09:48 kern:        [<b0178531>] generic_file_llseek+0x31/0xc0
Aug  7 02:09:48 kern:        [<b013b830>] autoremove_wake_function+0x0/0x40
Aug  7 02:09:48 kern:        [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  7 02:09:48 kern:        [<b0177a60>] do_sync_read+0x0/0x110
Aug  7 02:09:48 kern:        [<b01783ad>] vfs_read+0x9d/0x130
Aug  7 02:09:48 kern:        [<b01788a1>] sys_read+0x41/0x70
Aug  7 02:09:48 kern:        [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  7 02:09:48 kern:        [<ffffffff>] 0xffffffff
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: other info that might help us debug this:
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: 2 locks held by imapds/17962:
Aug  7 02:09:48 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<b025ecdb>] xfs_ilock+0x5b/0xb0
Aug  7 02:09:48 kern:  #1:  (shrinker_rwsem){----}, at: [<b01620b6>] 
shrink_slab+0x26/0x170
Aug  7 02:09:48 kern:
Aug  7 02:09:48 kern: stack backtrace:
Aug  7 02:09:48 kern: Pid: 17962, comm: imapds Not tainted 2.6.24.2-ish #5
Aug  7 02:09:48 kern:  [<b014807a>] print_circular_bug_tail+0x7a/0x90
Aug  7 02:09:48 kern:  [<b0149e3d>] __lock_acquire+0xa2d/0x10b0
Aug  7 02:09:48 kern:  [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:  [<b014a521>] lock_acquire+0x61/0x80
Aug  7 02:09:48 kern:  [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:  [<b042886f>] mutex_lock_nested+0x7f/0x2c0
Aug  7 02:09:48 kern:  [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:  [<b018b973>] shrink_icache_memory+0x73/0x250
Aug  7 02:09:48 kern:  [<b01620b6>] shrink_slab+0x26/0x170
Aug  7 02:09:48 kern:  [<b01621a7>] shrink_slab+0x117/0x170
Aug  7 02:09:48 kern:  [<b0162b72>] try_to_free_pages+0x172/0x250
Aug  7 02:09:48 kern:  [<b015d1e9>] __alloc_pages+0x159/0x380
Aug  7 02:09:48 kern:  [<b015f428>] __do_page_cache_readahead+0x148/0x260
Aug  7 02:09:48 kern:  [<b015f39d>] __do_page_cache_readahead+0xbd/0x260
Aug  7 02:09:48 kern:  [<b0158064>] do_generic_mapping_read+0x174/0x460
Aug  7 02:09:48 kern:  [<b0157660>] file_read_actor+0x0/0x120
Aug  7 02:09:48 kern:  [<b0159cc6>] generic_file_aio_read+0x116/0x1b0
Aug  7 02:09:48 kern:  [<b0157660>] file_read_actor+0x0/0x120
Aug  7 02:09:48 kern:  [<b028e65f>] xfs_read+0x13f/0x2e0
Aug  7 02:09:48 kern:  [<b028af0c>] xfs_file_aio_read+0x5c/0x70
Aug  7 02:09:48 kern:  [<b0177b27>] do_sync_read+0xc7/0x110
Aug  7 02:09:48 kern:  [<b0178531>] generic_file_llseek+0x31/0xc0
Aug  7 02:09:48 kern:  [<b013b830>] autoremove_wake_function+0x0/0x40
Aug  7 02:09:48 kern:  [<b0148f0f>] trace_hardirqs_on+0xaf/0x160
Aug  7 02:09:48 kern:  [<b0177a60>] do_sync_read+0x0/0x110
Aug  7 02:09:48 kern:  [<b01783ad>] vfs_read+0x9d/0x130
Aug  7 02:09:48 kern:  [<b01788a1>] sys_read+0x41/0x70
Aug  7 02:09:48 kern:  [<b0104376>] sysenter_past_esp+0x5f/0xa5
Aug  7 02:09:48 kern:  =======================
Aug  8 01:35:07 Ish squid[2181]: WARNING: Median response time is 54429 
milliseconds
Aug  8 01:36:07 Ish squid[2181]: WARNING: Median response time is 43858 
milliseconds
Aug  8 01:37:07 Ish squid[2181]: WARNING: Median response time is 41553 
milliseconds
Aug  8 01:38:07 Ish squid[2181]: WARNING: Median response time is 41553 
milliseconds
Aug  8 17:34:20 Ish squid[2181]: WARNING: Median response time is 341160 
milliseconds
Aug  8 17:35:20 Ish squid[2181]: WARNING: Median response time is 341160 
milliseconds
Aug  8 17:36:20 Ish squid[2181]: WARNING: Median response time is 341160 
milliseconds
Aug  8 17:37:20 Ish squid[2181]: WARNING: Median response time is 341160 
milliseconds
Aug  8 17:38:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:39:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:40:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:41:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:42:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:43:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:44:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds
Aug  8 17:45:20 Ish squid[2181]: WARNING: Median response time is 221513 
milliseconds

---
boot-080809.1930:<5>Linux version 2.6.24.2-ish (lw@Ast) (gcc version 
4.2.1 (SUSE Linux)) #5 SMP Fri Feb 15 17:55:46 PST 2008
---

Aug  9 02:44:52 kern: Clocksource tsc unstable (delta = 9374169734 ns)
Aug  9 02:59:05 kern: XFS: bad magic number
Aug  9 02:59:05 kern: XFS: SB validate failed
Aug  9 02:59:09 kern: XFS: bad magic number
Aug  9 02:59:09 kern: XFS: SB validate failed

---
<5>Linux version 2.6.25.12-ish (lw@Ast) (gcc version 4.2.1 (SUSE Linux)) 
#2 SMP Mon Jul 28 12:51:23 PDT 2008
---

Aug 10 02:30:48 Ish squid[2152]: Starting Squid Cache version 3.0.PRE6 
for i686-pc-linux-gnu...
Aug 10 15:14:03 Ish squid[2152]: WARNING: Median response time is 46290 
milliseconds
Aug 10 17:50:06 Ish squid[2152]: WARNING: Median response time is 83828 
milliseconds
Aug 10 17:51:06 Ish squid[2152]: WARNING: Median response time is 136268 
milliseconds
Aug 10 19:00:07 Ish squid[2152]: WARNING: Median response time is 88478 
milliseconds
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: 
=======================================================
Aug 11 02:04:56 kern: [ INFO: possible circular locking dependency 
detected ]
Aug 11 02:04:56 kern: 2.6.25.12-ish #2
Aug 11 02:04:56 kern: 
-------------------------------------------------------
Aug 11 02:04:56 kern: imapds/31560 is trying to acquire lock:
Aug 11 02:04:56 kern:  (iprune_mutex){--..}, at: [<c028ad52>] 
shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: but task is already holding lock:
Aug 11 02:04:56 kern:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: which lock already depends on the new lock.
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: the existing dependency chain (in reverse order) is:
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: -> #1 (&(&ip->i_iolock)->mr_lock){----}:
Aug 11 02:04:56 kern:        [<c02488bd>] __lock_acquire+0xb3d/0xf90
Aug 11 02:04:56 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug 11 02:04:56 kern:        [<c023e066>] down_write_nested+0x46/0x70
Aug 11 02:04:56 kern:        [<c0357b47>] xfs_ilock+0x97/0xb0
Aug 11 02:04:56 kern:        [<c0357d00>] xfs_ireclaim+0x30/0x70
Aug 11 02:04:56 kern:        [<c037600f>] xfs_finish_reclaim+0x4f/0x180
Aug 11 02:04:56 kern:        [<c0377ae7>] xfs_reclaim+0xe7/0xf0
Aug 11 02:04:56 kern:        [<c0385028>] xfs_fs_clear_inode+0xa8/0xe0
Aug 11 02:04:56 kern:        [<c028a959>] clear_inode+0x79/0x100
Aug 11 02:04:56 kern:        [<c028ac27>] dispose_list+0x27/0xf0
Aug 11 02:04:56 kern:        [<c028ae72>] shrink_icache_memory+0x182/0x250
Aug 11 02:04:56 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug 11 02:04:56 kern:        [<c026133e>] kswapd+0x2ee/0x460
Aug 11 02:04:56 kern:        [<c0239fc2>] kthread+0x42/0x70
Aug 11 02:04:56 kern:        [<c0204d97>] kernel_thread_helper+0x7/0x10
Aug 11 02:04:56 kern:        [<ffffffff>] 0xffffffff
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: -> #0 (iprune_mutex){--..}:
Aug 11 02:04:56 kern:        [<c02486e7>] __lock_acquire+0x967/0xf90
Aug 11 02:04:56 kern:        [<c0248d70>] lock_acquire+0x60/0x80
Aug 11 02:04:56 kern:        [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug 11 02:04:56 kern:        [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern:        [<c0260d5b>] shrink_slab+0x10b/0x170
Aug 11 02:04:56 kern:        [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug 11 02:04:56 kern:        [<c025bf28>] __alloc_pages+0x138/0x350
Aug 11 02:04:56 kern:        [<c025e03b>] 
__do_page_cache_readahead+0x13b/0x240
Aug 11 02:04:56 kern:        [<c025e311>] ondemand_readahead+0xc1/0x180
Aug 11 02:04:56 kern:        [<c025e432>] 
page_cache_async_readahead+0x62/0x80
Aug 11 02:04:56 kern:        [<c02585bc>] generic_file_aio_read+0x28c/0x5c0
Aug 11 02:04:56 kern:        [<c0384113>] xfs_read+0x133/0x2b0
Aug 11 02:04:56 kern:        [<c0380aec>] xfs_file_aio_read+0x5c/0x70
Aug 11 02:04:56 kern:        [<c027718d>] do_sync_read+0xcd/0x110
Aug 11 02:04:56 kern:        [<c0277a14>] vfs_read+0x94/0x130
Aug 11 02:04:56 kern:        [<c0277eed>] sys_read+0x3d/0x70
Aug 11 02:04:56 kern:        [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug 11 02:04:56 kern:        [<ffffffff>] 0xffffffff
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: other info that might help us debug this:
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: 2 locks held by imapds/31560:
Aug 11 02:04:56 kern:  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: 
[<c0357b0c>] xfs_ilock+0x5c/0xb0
Aug 11 02:04:56 kern:  #1:  (shrinker_rwsem){----}, at: [<c0260c74>] 
shrink_slab+0x24/0x170
Aug 11 02:04:56 kern:
Aug 11 02:04:56 kern: stack backtrace:
Aug 11 02:04:56 kern: Pid: 31560, comm: imapds Not tainted 2.6.25.12-ish #2
Aug 11 02:04:56 kern:  [<c02469ef>] print_circular_bug_tail+0x6f/0x80
Aug 11 02:04:56 kern:  [<c02486e7>] __lock_acquire+0x967/0xf90
Aug 11 02:04:56 kern:  [<c0247ecc>] ? __lock_acquire+0x14c/0xf90
Aug 11 02:04:56 kern:  [<c0248d70>] lock_acquire+0x60/0x80
Aug 11 02:04:56 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern:  [<c0520d3d>] mutex_lock_nested+0x9d/0x270
Aug 11 02:04:56 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern:  [<c028ad52>] ? shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern:  [<c028ad52>] shrink_icache_memory+0x62/0x250
Aug 11 02:04:56 kern:  [<c0260d5b>] shrink_slab+0x10b/0x170
Aug 11 02:04:56 kern:  [<c0260f0e>] try_to_free_pages+0x14e/0x210
Aug 11 02:04:56 kern:  [<c025fa80>] ? isolate_pages_global+0x0/0x60
Aug 11 02:04:56 kern:  [<c025bf28>] __alloc_pages+0x138/0x350
Aug 11 02:04:56 kern:  [<c024823d>] ? __lock_acquire+0x4bd/0xf90
Aug 11 02:04:56 kern:  [<c025e03b>] __do_page_cache_readahead+0x13b/0x240
Aug 11 02:04:56 kern:  [<c025dfad>] ? __do_page_cache_readahead+0xad/0x240
Aug 11 02:04:56 kern:  [<c025e311>] ondemand_readahead+0xc1/0x180
Aug 11 02:04:56 kern:  [<c025e432>] page_cache_async_readahead+0x62/0x80
Aug 11 02:04:56 kern:  [<c02585bc>] generic_file_aio_read+0x28c/0x5c0
Aug 11 02:04:56 kern:  [<c023e1b6>] ? down_read_nested+0x46/0x60
Aug 11 02:04:56 kern:  [<c0384113>] xfs_read+0x133/0x2b0
Aug 11 02:04:56 kern:  [<c0380aec>] xfs_file_aio_read+0x5c/0x70
Aug 11 02:04:56 kern:  [<c027718d>] do_sync_read+0xcd/0x110
Aug 11 02:04:56 kern:  [<c023a2b0>] ? autoremove_wake_function+0x0/0x40
Aug 11 02:04:56 kern:  [<c02478c0>] ? trace_hardirqs_on+0xa0/0x120
Aug 11 02:04:56 kern:  [<c0520c98>] ? mutex_unlock+0x8/0x10
Aug 11 02:04:56 kern:  [<c0277a14>] vfs_read+0x94/0x130
Aug 11 02:04:56 kern:  [<c0276cac>] ? vfs_llseek+0x3c/0x50
Aug 11 02:04:56 kern:  [<c02770c0>] ? do_sync_read+0x0/0x110
Aug 11 02:04:56 kern:  [<c0277eed>] sys_read+0x3d/0x70
Aug 11 02:04:56 kern:  [<c02040be>] sysenter_past_esp+0x5f/0xa5
Aug 11 02:04:56 kern:  =======================
