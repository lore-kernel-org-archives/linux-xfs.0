Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f199.google.com ([209.85.223.199]:35527 "EHLO
        mail-io0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754753AbeDCCBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 22:01:02 -0400
Received: by mail-io0-f199.google.com with SMTP id h132so12043392ioe.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Apr 2018 19:01:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 02 Apr 2018 19:01:02 -0700
Message-ID: <f403043cbe8414177d0568e81405@google.com>
Subject: WARNING: bad unlock balance in xfs_iunlock
From: syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

Hello,

syzbot hit the following crash on upstream commit
86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
Merge branch 'ras-core-for-linus' of  
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
syzbot dashboard link:  
https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba

C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
syzkaller reproducer:  
https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
Raw console output:  
https://syzkaller.appspot.com/x/log.txt?id=5643378645532672
Kernel config:  
https://syzkaller.appspot.com/x/.config?id=6801295859785128502
compiler: gcc (GCC) 7.1.1 20170620

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+84a67953651a971809ba@syzkaller.appspotmail.com
It will help syzbot understand when the bug is fixed. See footer for  
details.
If you forward the report, please keep this part and the footer.

000000005e445429: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  
00  ................
00000000c1c426da: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  
00  ................
XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x1  
len 1 error 117

=====================================
WARNING: bad unlock balance detected!
4.16.0+ #11 Not tainted
-------------------------------------
syzkaller109734/4463 is trying to release lock (&xfs_nondir_ilock_class) at:
[<ffffffff8276589f>] mrunlock_excl fs/xfs/mrlock.h:74 [inline]
[<ffffffff8276589f>] xfs_iunlock+0x36f/0x4a0 fs/xfs/xfs_inode.c:329
but there are no more locks to release!

other info that might help us debug this:
2 locks held by syzkaller109734/4463:
  #0: 00000000b4cfce0b (&type->s_umount_key#36/1){+.+.}, at: alloc_super  
fs/super.c:211 [inline]
  #0: 00000000b4cfce0b (&type->s_umount_key#36/1){+.+.}, at:  
sget_userns+0x3b2/0xe60 fs/super.c:502
  #1: 00000000d8e8aeed (sb_internal#2){.+.+}, at: sb_start_intwrite  
include/linux/fs.h:1595 [inline]
  #1: 00000000d8e8aeed (sb_internal#2){.+.+}, at:  
xfs_trans_alloc+0x349/0x430 fs/xfs/xfs_trans.c:264

stack backtrace:
CPU: 1 PID: 4463 Comm: syzkaller109734 Not tainted 4.16.0+ #11
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:17 [inline]
  dump_stack+0x1a7/0x27d lib/dump_stack.c:53
  print_unlock_imbalance_bug+0x12f/0x140 kernel/locking/lockdep.c:3484
  __lock_release kernel/locking/lockdep.c:3691 [inline]
  lock_release+0x6fe/0xa40 kernel/locking/lockdep.c:3939
  up_write+0x72/0x210 kernel/locking/rwsem.c:132
  mrunlock_excl fs/xfs/mrlock.h:74 [inline]
  xfs_iunlock+0x36f/0x4a0 fs/xfs/xfs_inode.c:329
  xfs_inode_item_unlock+0x82/0xa0 fs/xfs/xfs_inode_item.c:600
  xfs_trans_free_items+0x176/0x230 fs/xfs/xfs_trans.c:790
  xfs_trans_cancel+0x1bb/0x260 fs/xfs/xfs_trans.c:1047
  xfs_qm_dqread+0xc7c/0x13b0 fs/xfs/xfs_dquot.c:623
  xfs_qm_dqget+0x6b9/0x2060 fs/xfs/xfs_dquot.c:766
  xfs_qm_quotacheck_dqadjust+0xe4/0x800 fs/xfs/xfs_qm.c:1080
  xfs_qm_dqusage_adjust+0x814/0x11c0 fs/xfs/xfs_qm.c:1194
  xfs_bulkstat_ag_ichunk fs/xfs/xfs_itable.c:302 [inline]
  xfs_bulkstat+0xc0a/0x1cb0 fs/xfs/xfs_itable.c:487
  xfs_qm_quotacheck+0x3cb/0x800 fs/xfs/xfs_qm.c:1340
  xfs_qm_mount_quotas+0x2c4/0x470 fs/xfs/xfs_qm.c:1459
  xfs_mountfs+0x22a1/0x2690 fs/xfs/xfs_mount.c:982
  xfs_fs_fill_super+0xc8d/0x1250 fs/xfs/xfs_super.c:1703
  mount_bdev+0x2b7/0x370 fs/super.c:1119
  xfs_fs_mount+0x34/0x40 fs/xfs/xfs_super.c:1770
  mount_fs+0x66/0x2d0 fs/super.c:1222
  vfs_kern_mount.part.26+0xc6/0x4a0 fs/namespace.c:1037
  vfs_kern_mount fs/namespace.c:2509 [inline]
  do_new_mount fs/namespace.c:2512 [inline]
  do_mount+0xea4/0x2bb0 fs/namespace.c:2842
  SYSC_mount fs/namespace.c:3058 [inline]
  SyS_mount+0xab/0x120 fs/namespace.c:3035
  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x44488a
RSP: 002b:00007fff118ea198 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda R


---
This bug is generated by a dumb bot. It may contain errors.
See https://goo.gl/tpsmEJ for details.
Direct all questions to syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is  
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
If you want to test a patch for this bug, please reply with:
#syz test: git://repo/address.git branch
and provide the patch inline or as an attachment.
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug  
report.
Note: all commands must start from beginning of the line in the email body.
