Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeECU5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 16:57:04 -0400
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fELHk-0000lo-5M
        for linux-xfs@vger.kernel.org; Thu, 03 May 2018 20:57:04 +0000
Date: Thu, 3 May 2018 13:57:03 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Oops from linux-next 20180430
Message-ID: <20180503205703.GA27821@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I was running xfstests xfs/350 at the time.  No kernel patches applied
beyond linux-next (I was hoping to get a baseline).

5726 XFS: Assertion failed: sbp->sb_rsumino != NULLFSINO, file: ../fs/xfs/xfs_rtalloc.c, line: 1223
5726 ------------[ cut here ]------------
5726 kernel BUG at ../fs/xfs/xfs_message.c:114!
5726 invalid opcode: 0000 [#1] SMP PTI
5726 CPU: 2 PID: 8468 Comm: mount Tainted: G        W         4.17.0-rc3-next-20180430+ #4
5726 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
5726 RIP: 0010:assfail+0x23/0x30
5726 Code: c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 e8 ba b2 81 48 89 fa 31 ff e8 69 f9 ff ff 80 3d 26 f1 9e 00 00 75 03 0f 0b c3 <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 48 63 f6 49 89 f9 6a 01 ba 
5726 RSP: 0018:ffffc900067f3d18 EFLAGS: 00010202
5726 RAX: 0000000000000000 RBX: ffff880032ee4000 RCX: 0000000000000000
5726 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81af2fa5
5726 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
5726 R10: ffffffff81a37940 R11: f000000000000000 R12: ffff880032ee45e8
5726 R13: ffff880032ee48d0 R14: ffff880032ee4140 R15: 0000000000000000
5726 FS:  00007f13e91d0100(0000) GS:ffff88007f480000(0000) knlGS:0000000000000000
5726 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
5726 CR2: 00007f842e22b980 CR3: 0000000079afc000 CR4: 00000000000006a0
5726 Call Trace:
5726  xfs_rtmount_inodes+0x13e/0x170
5726  ? xfs_iunlock+0xfd/0x200
5726  xfs_mountfs+0x5b2/0x980
5726  xfs_fs_fill_super+0x417/0x580
5726  ? xfs_test_remount_options+0x50/0x50
5726  mount_bdev+0x16c/0x1a0
5726  mount_fs+0xa/0x70
5726  vfs_kern_mount.part.7+0x4f/0x110
5726  do_mount+0x208/0xc30
5726  ksys_mount+0x7b/0xd0
5726  __x64_sys_mount+0x1c/0x20
5726  do_syscall_64+0x43/0x100
5726  entry_SYSCALL_64_after_hwframe+0x44/0xa9
5726 RIP: 0033:0x7f13e88767fa
5726 Code: 48 8b 0d 91 c6 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5e c6 2b 00 f7 d8 64 89 01 48 
5726 RSP: 002b:00007fff36ff4178 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
5726 RAX: ffffffffffffffda RBX: 000055eb65801970 RCX: 00007f13e88767fa
5726 RDX: 000055eb65801be0 RSI: 000055eb65801c20 RDI: 000055eb65801c00
5726 RBP: 0000000000000000 R08: 000055eb65801b80 R09: 000055eb65801be0
5726 R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000055eb65801c00
5726 R13: 000055eb65801be0 R14: 0000000000000000 R15: 00007f13e8fb5ee4
5726 Modules linked in:
5726 ---[ end trace 5d9a89b7ed142727 ]---
5726 RIP: 0010:assfail+0x23/0x30
5726 Code: c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 e8 ba b2 81 48 89 fa 31 ff e8 69 f9 ff ff 80 3d 26 f1 9e 00 00 75 03 0f 0b c3 <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 48 63 f6 49 89 f9 6a 01 ba 
5726 RSP: 0018:ffffc900067f3d18 EFLAGS: 00010202
5726 RAX: 0000000000000000 RBX: ffff880032ee4000 RCX: 0000000000000000
5726 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81af2fa5
5726 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
5726 R10: ffffffff81a37940 R11: f000000000000000 R12: ffff880032ee45e8
5726 R13: ffff880032ee48d0 R14: ffff880032ee4140 R15: 0000000000000000
5726 FS:  00007f13e91d0100(0000) GS:ffff88007f480000(0000) knlGS:0000000000000000
5726 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
5726 CR2: 00007f842e22b980 CR3: 0000000079afc000 CR4: 00000000000006a0
5726 Kernel panic - not syncing: Fatal exception
5726 Kernel Offset: disabled
5726 ---[ end Kernel panic - not syncing: Fatal exception ]---


