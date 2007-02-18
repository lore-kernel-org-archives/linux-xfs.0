Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Feb 2007 14:05:57 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1IM5qm7020192
	for <xfs@oss.sgi.com>; Sun, 18 Feb 2007 14:05:52 -0800
Message-ID: <45D8C765.7080306@tlinx.org>
Date: Sun, 18 Feb 2007 13:38:45 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: lock checking feedback (bug?) 2.6.20(xfs)/i386 during boot
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Turned on lock testing/proving/deadlock detection.  Not chasing any 
particular
problem, but looking for things "oddities".

Turned on options (under kernel hacking):
   Locking API boot-time self-tests
   RT Mutex debugging, deadlock detection
   Lock debugging: prove locking correctness

Multiple reboots show it to be a constant.
I had tried the new "Asynchronous SCSI scanning" -- thought that might 
have been
related, but turning it off makes no difference.

I'm guessing this "error" has been present before this, but the lock
proving algorithms are bringing it to light?  So I don't know how serious
this is (if it is anything), but at the least, it doesn't look too clean...


Maybe that
....
SCSI device sda: write cache: enabled, read cache: enabled, supports DPO 
and FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: Attached scsi disk sda
UDF-fs: No VRS found
XFS mounting filesystem sda3
Ending clean XFS mount for filesystem: sda3
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 316k freed

=============================================
[ INFO: possible recursive locking detected ]
2.6.20 #3
---------------------------------------------
rm/682 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<b024068d>] xfs_ilock+0x7d/0xb0

but task is already holding lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<b024068d>] xfs_ilock+0x7d/0xb0

other info that might help us debug this:
3 locks held by rm/682:
 #0:  (&inode->i_mutex/1){--..}, at: [<b016f946>] do_unlinkat+0x96/0x170
 #1:  (&inode->i_mutex){--..}, at: [<b016db9a>] vfs_unlink+0x5a/0xd0
 #2:  (&(&ip->i_lock)->mr_lock){----}, at: [<b024068d>] xfs_ilock+0x7d/0xb0

stack backtrace:
 [<b013aaf1>] __lock_acquire+0xaf1/0xdf0
 [<b013ae47>] lock_acquire+0x57/0x70
 [<b024068d>] xfs_ilock+0x7d/0xb0
 [<b0135d7f>] down_write+0x2f/0x50
 [<b024068d>] xfs_ilock+0x7d/0xb0
 [<b024068d>] xfs_ilock+0x7d/0xb0
 [<b025ff2d>] xfs_lock_dir_and_entry+0xfd/0x100
 [<b0263c68>] xfs_remove+0x198/0x4e0
 [<b025fff6>] xfs_access+0x26/0x50
 [<b025fff6>] xfs_access+0x26/0x50
 [<b016db9a>] vfs_unlink+0x5a/0xd0
 [<b026d8f3>] xfs_vn_unlink+0x23/0x60
 [<b0417f72>] __mutex_lock_slowpath+0x152/0x2a0
 [<b01398bb>] mark_held_locks+0x6b/0x90
 [<b0417f72>] __mutex_lock_slowpath+0x152/0x2a0
 [<b0417f72>] __mutex_lock_slowpath+0x152/0x2a0
 [<b0139a67>] trace_hardirqs_on+0xc7/0x170
 [<b0417f65>] __mutex_lock_slowpath+0x145/0x2a0
 [<b016db9a>] vfs_unlink+0x5a/0xd0
 [<b016d077>] permission+0x137/0x140
 [<b016dbd0>] vfs_unlink+0x90/0xd0
 [<b016f983>] do_unlinkat+0xd3/0x170
 [<b0113807>] do_page_fault+0x327/0x630
 [<b0102fda>] sysenter_past_esp+0x5f/0x99
 =======================
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
