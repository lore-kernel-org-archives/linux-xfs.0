Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37730 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937190AbeFSCRr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jun 2018 22:17:47 -0400
Date: Mon, 18 Jun 2018 20:17:46 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem)
Message-ID: <20180619021746.GA6652@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

During some xfstest runs on next-20180615 I hit the following with DAX +
generic/388:

================================================
WARNING: lock held when returning to user space!
4.17.0-next-20180615-00001-gf09d99951966 #2 Not tainted
------------------------------------------------
fsstress/6598 is leaving the kernel with locks still held!
2 locks held by fsstress/6598:
 #0: 00000000d8f89e14 (&sb->s_type->i_mutex_key#13){++++}, at: xfs_ilock+0x211/0x310
 #1: 000000005cc93137 (&(&ip->i_mmaplock)->mr_lock){++++}, at: xfs_ilock+0x1eb/0x310
XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file: fs/xfs/xfs_super.c, line: 966
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
CPU: 5 PID: 6609 Comm: umount Not tainted 4.17.0-next-20180615-00001-gf09d99951966 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:assfail+0x2d/0x30
Code: 00 00 55 48 89 f1 41 89 d0 48 c7 c6 40 f1 59 82 48 89 fa 31 ff 48 89 e5 e8 50 f9 ff ff 80 3d 11 dc 37 01 00 75 04 0f 0b 5d c3 <0f> 0b 90 0f 1f 44 00 00 55 48 63 f6 49 89 f9 ba 01 00 00 00 41 b8
RSP: 0018:ffffc9000404bd28 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff8800b65c4cc0 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff825320e6
RBP: ffffc9000404bd28 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: f000000000000000 R12: ffff8800b65c4a40
R13: ffffffff822644e0 R14: ffffffff8258431b R15: ffff8801049331c0
FS:  00007f0bdbc8bfc0(0000) GS:ffff880114e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ff8b3060c8 CR3: 000000010ec9c000 CR4: 00000000000006e0
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
RIP: 0033:0x7f0bdace21a7
Code: ad 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 ac 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffefd64f788 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 000055ff8b2fc2d0 RCX: 00007f0bdace21a7
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055ff8b304960
RBP: 000055ff8b304960 R08: 0000000000000000 R09: 000055ff8b2fc010
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0bdba76184
R13: 0000000000000000 R14: 000055ff8b2fc4b0 R15: 0000000000000000
Modules linked in: nd_pmem dax_pmem device_dax nd_btt nfit libnvdimm
---[ end trace f46cb40cc37c4976 ]---

Message from syslogd@amonkhet-5 at Jun 18 13:50:34 ...
 kernel:XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file: fs/xfs/xfs_super.c, line: 966

I've run the test a bunch more times since then and haven't been able to
reproduce the issue.  I'm hoping that the above might be enough to be useful.

Thanks,
- Ross
