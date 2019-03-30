Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f70.google.com ([209.85.166.70]:37212 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730678AbfC3LKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Mar 2019 07:10:05 -0400
Received: by mail-io1-f70.google.com with SMTP id u22so3858295iof.4
        for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2019 04:10:05 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 30 Mar 2019 04:10:04 -0700
In-Reply-To: <0000000000005ff8b20585395280@google.com>
Message-ID: <00000000000056fddd05854dd4f0@google.com>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low! (2)
From: syzbot <syzbot+6f39a9deb697359fe520@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: danitg@mellanox.com, darrick.wong@oracle.com, dledford@redhat.com, jannh@google.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, roland@purestorage.com, shamir.rabinovitch@oracle.com, syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com

syzbot has found a reproducer for the following crash on:

HEAD commit:    0e40da3e Merge tag 'kbuild-fixes-v5.1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d9123f200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8dcdce25ea72bedf
dashboard link: https://syzkaller.appspot.com/bug?extid=6f39a9deb697359fe520
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1244591f200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12611c73200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6f39a9deb697359fe520@syzkaller.appspotmail.com

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
CPU: 0 PID: 678 Comm: syz-executor519 Not tainted 5.1.0-rc2+ #43
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  save_trace kernel/locking/lockdep.c:467 [inline]
  save_trace.cold+0x14/0x19 kernel/locking/lockdep.c:437
  mark_lock+0x2fb/0x1380 kernel/locking/lockdep.c:3410
  __lock_acquire+0x548/0x3fb0 kernel/locking/lockdep.c:3657
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4211
  flush_workqueue+0x126/0x14c0 kernel/workqueue.c:2774
  drain_workqueue+0x1b4/0x470 kernel/workqueue.c:2939
  destroy_workqueue+0x21/0x700 kernel/workqueue.c:4320
  ucma_close+0x289/0x320 drivers/infiniband/core/ucma.c:1786
  __fput+0x2e5/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:341 [inline]
  do_fast_syscall_32+0xa9d/0xc98 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fc4869
Code: 85 d2 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 90 90  
90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffc382bc EFLAGS: 00000246 ORIG_RAX: 0000000000000006
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 00000000200002c0
RDX: 0000000000000004 RSI: 00000000080bc36e RDI: 00000000200002d8
RBP: 00000000ffc38308 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
