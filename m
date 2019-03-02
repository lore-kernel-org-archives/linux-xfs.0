Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f197.google.com ([209.85.166.197]:41271 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfCBLpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Mar 2019 06:45:06 -0500
Received: by mail-it1-f197.google.com with SMTP id q184so722301itd.6
        for <linux-xfs@vger.kernel.org>; Sat, 02 Mar 2019 03:45:06 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 02 Mar 2019 03:45:05 -0800
In-Reply-To: <000000000000299b190583172880@google.com>
Message-ID: <000000000000fdc7da05831b0df8@google.com>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low!
From: syzbot <syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

syzbot has found a reproducer for the following crash on:

HEAD commit:    c63e9e91a254 Add linux-next specific files for 20190301
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10856157200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5875f9dc6e009b2
dashboard link: https://syzkaller.appspot.com/bug?extid=78923eea7cf44364f4fb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149ae1eb200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ee41eb200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
CPU: 0 PID: 1176 Comm: kworker/u5:0 Not tainted 5.0.0-rc8-next-20190301 #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: hci1 hci_power_on
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  save_trace kernel/locking/lockdep.c:467 [inline]
  save_trace.cold+0x14/0x19 kernel/locking/lockdep.c:437
  mark_lock+0x2fb/0x1380 kernel/locking/lockdep.c:3401
  mark_irqflags kernel/locking/lockdep.c:3304 [inline]
  __lock_acquire+0xf2c/0x3fb0 kernel/locking/lockdep.c:3644
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4202
  process_one_work+0x8df/0x1790 kernel/workqueue.c:2244
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
