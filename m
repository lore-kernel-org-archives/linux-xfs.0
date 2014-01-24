Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1DCB7F60
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 19:59:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BEE95304032
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 17:59:01 -0800 (PST)
Date: Thu, 23 Jan 2014 20:58:56 -0500
From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: XFS lockdep spew with v3.13-4156-g90804ed
Message-ID: <20140124015855.GM16455@hansolo.jdub.homelinux.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Ben Myers <bpm@sgi.com>
Cc: sandeen@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi All,

I'm hitting an XFS lockdep error with Linus' tree today after the XFS
merge.  I wasn't hitting this with v3.13-3995-g0dc3fd0, which seems
to backup the "before XFS merge" claim.  Full text below:


[  132.638044] ======================================================
[  132.638045] [ INFO: possible circular locking dependency detected ]
[  132.638047] 3.14.0-0.rc0.git7.1.fc21.x86_64 #1 Not tainted
[  132.638048] -------------------------------------------------------
[  132.638049] gnome-session/1432 is trying to acquire lock:
[  132.638050]  (&mm->mmap_sem){++++++}, at: [<ffffffff811b846f>] might_fault+0x
5f/0xb0
[  132.638055] 
but task is already holding lock:
[  132.638056]  (&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa05b3c12>] xfs_
ilock+0xf2/0x1c0 [xfs]
[  132.638076] 
which lock already depends on the new lock.

[  132.638077] 
the existing dependency chain (in reverse order) is:
[  132.638078] 
-> #1 (&(&ip->i_lock)->mr_lock){++++..}:
[  132.638080]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
[  132.638083]        [<ffffffff8178312e>] _raw_spin_lock+0x3e/0x80
[  132.638085]        [<ffffffff8123c579>] __mark_inode_dirty+0x119/0x440
[  132.638088]        [<ffffffff812447fc>] __set_page_dirty+0x6c/0xc0
[  132.638090]        [<ffffffff812477e1>] mark_buffer_dirty+0x61/0x180
[  132.638092]        [<ffffffff81247a31>] __block_commit_write.isra.21+0x81/0xb0
[  132.638094]        [<ffffffff81247be6>] block_write_end+0x36/0x70
[  132.638096]        [<ffffffff81247c48>] generic_write_end+0x28/0x90
[  132.638097]        [<ffffffffa0554cab>] xfs_vm_write_end+0x2b/0x70 [xfs]
[  132.638104]        [<ffffffff8118c4f6>] generic_file_buffered_write+0x156/0x260
[  132.638107]        [<ffffffffa05651d7>] xfs_file_buffered_aio_write+0x107/0x250 [xfs]
[  132.638115]        [<ffffffffa05653eb>] xfs_file_aio_write+0xcb/0x130 [xfs]
[  132.638122]        [<ffffffff8120af8a>] do_sync_write+0x5a/0x90
[  132.638125]        [<ffffffff8120b74d>] vfs_write+0xbd/0x1f0
[  132.638126]        [<ffffffff8120c15c>] SyS_write+0x4c/0xa0
[  132.638128]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b
[  132.638130] 
-> #0 (&mm->mmap_sem){++++++}:
[  132.638132]        [<ffffffff810de0fc>] __lock_acquire+0x18ec/0x1aa0
[  132.638133]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
[  132.638135]        [<ffffffff811b849c>] might_fault+0x8c/0xb0
[  132.638136]        [<ffffffff81220a91>] filldir+0x91/0x120
[  132.638138]        [<ffffffffa0560f7f>] xfs_dir2_sf_getdents+0x23f/0x2a0 [xfs]
[  132.638146]        [<ffffffffa05613fb>] xfs_readdir+0x16b/0x1d0 [xfs]
[  132.638154]        [<ffffffffa056383b>] xfs_file_readdir+0x2b/0x40 [xfs]
[  132.638161]        [<ffffffff812208d8>] iterate_dir+0xa8/0xe0
[  132.638163]        [<ffffffff81220d83>] SyS_getdents+0x93/0x120
[  132.638165]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b
[  132.638166] 
other info that might help us debug this:
[  132.638167]  Possible unsafe locking scenario:

[  132.638168]        CPU0                    CPU1
[  132.638169]        ----                    ----
[  132.638169]   lock(&(&ip->i_lock)->mr_lock);
[  132.638171]                                lock(&mm->mmap_sem);
[  132.638172]                                lock(&(&ip->i_lock)->mr_lock);
[  132.638173]   lock(&mm->mmap_sem);
[  132.638174] 
 *** DEADLOCK ***

[  132.638176] 2 locks held by gnome-session/1432:
[  132.638177]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<ffffffff81220892>] iterate_dir+0x62/0xe0
[  132.638180]  #1:  (&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa05b3c12>] xfs_ilock+0xf2/0x1c0 [xfs]
[  132.638193] 
stack backtrace:
[  132.638195] CPU: 3 PID: 1432 Comm: gnome-session Not tainted 3.14.0-0.rc0.git7.1.fc21.x86_64 #1
[  132.638196] Hardware name: Dell Inc. XPS 8300  /0Y2MRG, BIOS A06 10/17/2011
[  132.638197]  ffffffff825ba040 ffff88030dc75c60 ffffffff8177a8c9 ffffffff825ba040
[  132.638199]  ffff88030dc75ca0 ffffffff8177616c ffff88030dc75cf0 ffff8802fb51dba8
[  132.638201]  ffff8802fb51d010 0000000000000002 0000000000000002 ffff8802fb51dba8
[  132.638203] Call Trace:
[  132.638205]  [<ffffffff8177a8c9>] dump_stack+0x4d/0x66
[  132.638207]  [<ffffffff8177616c>] print_circular_bug+0x201/0x20f
[  132.638210]  [<ffffffff810de0fc>] __lock_acquire+0x18ec/0x1aa0
[  132.638212]  [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
[  132.638213]  [<ffffffff811b846f>] ? might_fault+0x5f/0xb0
[  132.638215]  [<ffffffff811b849c>] might_fault+0x8c/0xb0
[  132.638216]  [<ffffffff811b846f>] ? might_fault+0x5f/0xb0
[  132.638218]  [<ffffffff81220a91>] filldir+0x91/0x120
[  132.638226]  [<ffffffffa0560f7f>] xfs_dir2_sf_getdents+0x23f/0x2a0 [xfs]
[  132.638237]  [<ffffffffa05b3c12>] ? xfs_ilock+0xf2/0x1c0 [xfs]
[  132.638245]  [<ffffffffa05613fb>] xfs_readdir+0x16b/0x1d0 [xfs]
[  132.638253]  [<ffffffffa056383b>] xfs_file_readdir+0x2b/0x40 [xfs]
[  132.638255]  [<ffffffff812208d8>] iterate_dir+0xa8/0xe0
[  132.638258]  [<ffffffff8122ca7c>] ? fget_light+0x3c/0x4f0
[  132.638260]  [<ffffffff81220d83>] SyS_getdents+0x93/0x120
[  132.638261]  [<ffffffff81220a00>] ? fillonedir+0xf0/0xf0
[  132.638264]  [<ffffffff81134ecc>] ? __audit_syscall_entry+0x9c/0xf0
[  132.638265]  [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b

josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
