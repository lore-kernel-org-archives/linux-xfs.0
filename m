Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48815 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966514AbeFSQoV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:44:21 -0400
Date: Tue, 19 Jun 2018 10:44:20 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem)
Message-ID: <20180619164420.GB6679@linux.intel.com>
References: <20180619021746.GA6652@linux.intel.com>
 <20180619023246.GG19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619023246.GG19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 12:32:46PM +1000, Dave Chinner wrote:
> On Mon, Jun 18, 2018 at 08:17:46PM -0600, Ross Zwisler wrote:
> > During some xfstest runs on next-20180615 I hit the following with DAX +
> > generic/388:
> > 
> > ================================================
> > WARNING: lock held when returning to user space!
> > 4.17.0-next-20180615-00001-gf09d99951966 #2 Not tainted
> > ------------------------------------------------
> > fsstress/6598 is leaving the kernel with locks still held!
> > 2 locks held by fsstress/6598:
> >  #0: 00000000d8f89e14 (&sb->s_type->i_mutex_key#13){++++}, at: xfs_ilock+0x211/0x310
> >  #1: 000000005cc93137 (&(&ip->i_mmaplock)->mr_lock){++++}, at: xfs_ilock+0x1eb/0x310
> 
> What errors occurred before this? generic/388 is testing all sorts
> of error paths by randomly shutting down the filesystem, so it'e
> entirely possible that we've leaked those locks (XFS_IOLOCK and
> XFS_MMAPLOCK) on some rarely travelled error path. The prior errors
> might help identify that path.

Here is the full output from another reproduction:

Shell:
 FSTYP         -- xfs (debug)
 PLATFORM      -- Linux/x86_64 amonkhet-7 4.17.0-next-20180615
 MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
 MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:root_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
 
 generic/388 71s ...
 Message from syslogd@amonkhet-7 at Jun 19 10:19:18 ...
  kernel:XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file: fs/xfs/xfs_super.c, line: 966

Dmesg:
 run fstests generic/388 at 2018-06-19 10:18:29
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Ending clean mount
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Ending clean mount
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 XFS (pmem0p2): xfs_do_force_shutdown(0x1) called from line 222 of file fs/xfs/libxfs/xfs_defer.c.  Return address = ffffffff8152d0f5
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_do_force_shutdown(0x1) called from line 222 of file fs/xfs/libxfs/xfs_defer.c.  Return address = ffffffff8152d0f5
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): Unmounting Filesystem
 XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
 XFS (pmem0p2): Mounting V5 Filesystem
 XFS (pmem0p2): Starting recovery (logdev: internal)
 XFS (pmem0p2): Ending recovery (logdev: internal)
 XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 
 ================================================
 WARNING: lock held when returning to user space!
 4.17.0-next-20180615 #1 Not tainted
 ------------------------------------------------
 fsstress/20108 is leaving the kernel with locks still held!
 2 locks held by fsstress/20108:
  #0: 00000000250ceb4d (&sb->s_type->i_mutex_key#13){++++}, at: xfs_ilock+0x211/0x310
  #1: 000000003caf8c3b (&(&ip->i_mmaplock)->mr_lock){++++}, at: xfs_ilock+0x1eb/0x310
 XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file: fs/xfs/xfs_super.c, line: 966
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 invalid opcode: 0000 [#1] PREEMPT SMP PTI
 CPU: 4 PID: 20148 Comm: umount Not tainted 4.17.0-next-20180615 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
 RIP: 0010:assfail+0x2d/0x30
 Code: 00 00 55 48 89 f1 41 89 d0 48 c7 c6 e8 f0 59 82 48 89 fa 31 ff 48 89 e5 e8 50 f9 ff ff 80 3d 11 dc 37 01 00 75 04 0f 0b 5d c3 <0f> 0b 90 0f 1f 44 00 00 55 48 63 f6 49 89 f9 ba 01 00 00 00 41 b8 
 RSP: 0018:ffffc90001253d28 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff8800b2d20940 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff825320a6
 RBP: ffffc90001253d28 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: f000000000000000 R12: ffff8800b2d206c0
 R13: ffffffff822644a0 R14: ffffffff825842c3 R15: ffff8800b2d216c0
 FS:  00007fb3326a9fc0(0000) GS:ffff880114c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005589e96bdb58 CR3: 0000000035aca000 CR4: 00000000000006e0
 Call Trace:
  xfs_fs_destroy_inode+0x22a/0x300
  destroy_inode+0x3e/0x60
  evict+0x141/0x1a0
  dispose_list+0x56/0x80
  evict_inodes+0x15a/0x1b0
  generic_shutdown_super+0x44/0x120
  kill_block_super+0x27/0x50
  deactivate_locked_super+0x48/0x80
  deactivate_super+0x40/0x60
  cleanup_mnt+0x3f/0x80
  __cleanup_mnt+0x12/0x20
  task_work_run+0x8f/0xc0
  exit_to_usermode_loop+0xc2/0xd0
  do_syscall_64+0x211/0x220
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fb3317001a7
 Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ac 2b 00 f7 d8 64 89 01 48 
 RSP: 002b:00007ffdaace4b08 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
 RAX: 0000000000000000 RBX: 00005636e2b472d0 RCX: 00007fb3317001a7
 RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00005636e2b4f960
 RBP: 00005636e2b4f960 R08: 0000000000000000 R09: 00005636e2b47010
 R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb332494184
 R13: 0000000000000000 R14: 00005636e2b474b0 R15: 0000000000000000
 Modules linked in: nd_pmem nd_btt dax_pmem device_dax nfit libnvdimm
 ---[ end trace 89eff31b76d71280 ]---
 RIP: 0010:assfail+0x2d/0x30
 Code: 00 00 55 48 89 f1 41 89 d0 48 c7 c6 e8 f0 59 82 48 89 fa 31 ff 48 89 e5 e8 50 f9 ff ff 80 3d 11 dc 37 01 00 75 04 0f 0b 5d c3 <0f> 0b 90 0f 1f 44 00 00 55 48 63 f6 49 89 f9 ba 01 00 00 00 41 b8 
 RSP: 0018:ffffc90001253d28 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff8800b2d20940 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff825320a6
 RBP: ffffc90001253d28 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: f000000000000000 R12: ffff8800b2d206c0
 R13: ffffffff822644a0 R14: ffffffff825842c3 R15: ffff8800b2d216c0
 FS:  00007fb3326a9fc0(0000) GS:ffff880114c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005589e96bdb58 CR3: 0000000035aca000 CR4: 00000000000006e0

- Ross
