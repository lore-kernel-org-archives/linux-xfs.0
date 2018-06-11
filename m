Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f71.google.com ([209.85.214.71]:38056 "EHLO
        mail-it0-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753866AbeFKFsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 01:48:02 -0400
Received: by mail-it0-f71.google.com with SMTP id l6-v6so8334707itb.3
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 22:48:02 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 10 Jun 2018 22:48:02 -0700
Message-ID: <000000000000f2fd7c056e574a40@google.com>
Subject: WARNING in destroy_workqueue
From: syzbot <syzbot+ed2b6bee3bb95389611d@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

Hello,

syzbot found the following crash on:

HEAD commit:    a16afaf7928b Merge tag 'for-v4.18' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f66f9f800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=314f2150f36c16ca
dashboard link: https://syzkaller.appspot.com/bug?extid=ed2b6bee3bb95389611d
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ed2b6bee3bb95389611d@syzkaller.appspotmail.com

000000003ed4096b: 00 00 00 00 00 ec 00 00 0c 09 0a 02 0c 00 00  
00  ................
XFS (loop5): SB validate failed with error -117.
binder: 21818:21820 ioctl 40046207 0 returned -16
binder: 21818:21861 ioctl c0306201 20000040 returned -22
binder: 21818:21820 BC_CLEAR_DEATH_NOTIFICATION death notification cookie  
mismatch 0000000000000000 != 0000000000000002
WARNING: CPU: 0 PID: 21819 at kernel/workqueue.c:4155  
destroy_workqueue+0x2d2/0x9b0 kernel/workqueue.c:4155
binder: 21818:21864 ioctl 8 20000000 returned -22
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 21819 Comm: syz-executor5 Not tainted 4.17.0+ #93
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  panic+0x22f/0x4de kernel/panic.c:184
binder_alloc: 21818: binder_alloc_buf, no vma
  __warn.cold.8+0x163/0x1b3 kernel/panic.c:536
  report_bug+0x252/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x1fc/0x4d0 arch/x86/kernel/traps.c:296
  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:316
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:992
RIP: 0010:destroy_workqueue+0x2d2/0x9b0 kernel/workqueue.c:4155
Code:
binder: 21818:21820 transaction failed 29189/-3, size 0-0 line 2967
0f 8e fe 05 00 00 48 8b 85 30
binder: undelivered TRANSACTION_ERROR: 29189
fe
binder: undelivered TRANSACTION_ERROR: 29201
ff ff bf 01 00 00 00 8b 58 18 89 de e8 6c c4 2a 00 83 fb 01 0f 8e 91 00 00  
00 e8 4e c3 2a 00 <0f> 0b e8 47 c3 2a 00 48 8b bd 18 fe ff ff e8 ab 13 32  
06 e8 46 f3
RSP: 0018:ffff8801b61276b0 EFLAGS: 00010216
RAX: 0000000000040000 RBX: 0000000000000002 RCX: ffffc900036a8000
RDX: 000000000002824e RSI: ffffffff814f7a12 RDI: 0000000000000005
RBP: ffff8801b61278a0 R08: ffff8801c6fa6680 R09: ffffed003b5c46d6
R10: ffffed003b5c46d6 R11: ffff8801dae236b3 R12: 000000000000000f
R13: dffffc0000000000 R14: ffff8801d653cd40 R15: 0000000000000000
  xfs_destroy_mount_workqueues+0x171/0x1c0 fs/xfs/xfs_super.c:936
  xfs_fs_fill_super+0xa10/0x1700 fs/xfs/xfs_super.c:1777
  mount_bdev+0x30c/0x3e0 fs/super.c:1174
  xfs_fs_mount+0x34/0x40 fs/xfs/xfs_super.c:1825
  mount_fs+0xae/0x328 fs/super.c:1277
  vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
  vfs_kern_mount fs/namespace.c:1027 [inline]
  do_new_mount fs/namespace.c:2518 [inline]
  do_mount+0x564/0x30b0 fs/namespace.c:2848
  ksys_mount+0x12d/0x140 fs/namespace.c:3064
  __do_sys_mount fs/namespace.c:3078 [inline]
  __se_sys_mount fs/namespace.c:3075 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3075
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45842a
Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 dd 8f fb ff c3 66 2e 0f  
1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 ba 8f fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007f367396bba8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000020000180 RCX: 000000000045842a
RDX: 0000000020000180 RSI: 0000000020000140 RDI: 00007f367396bbf0
RBP: 0000000000000001 R08: 0000000020000040 R09: 0000000020000180
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000013
R13: 0000000000000001 R14: 00000000004d2d70 R15: 0000000000000000
Dumping ftrace buffer:
    (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
