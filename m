Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outprodmail02.cc.columbia.edu ([128.59.72.51]:34781 "EHLO
        outprodmail02.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751013AbdIKLMV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 07:12:21 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v8BAs8vG046088
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2017 06:56:07 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id CB9C76D
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2017 06:56:07 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu [128.59.72.14])
        by hazelnut (Postfix) with ESMTP id AB2246D
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2017 06:56:07 -0400 (EDT)
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v8BAu7so021060
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2017 06:56:07 -0400
Received: by mail-wm0-f69.google.com with SMTP id i198so7129268wmf.5
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2017 03:56:07 -0700 (PDT)
MIME-Version: 1.0
From: Shankara Pailoor <sp3485@columbia.edu>
Date: Mon, 11 Sep 2017 06:56:05 -0400
Message-ID: <CAASgV=ugG=Chc5RK4CK-=FsVm+9UEd-2kSTxQrZFG90bYHpMpw@mail.gmail.com>
Subject: WARN_ON_ONCE in fs/iomap.c:993
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Zhu Aday <andrew.aday@columbia.edu>, syzkaller <syzkaller@googlegroups.com>, viro@zeniv.linux.org.uk

Hi,

I am fuzzing linux 4.13-rc7 with XFS using syzkaller on x86_64 and I
found the following warning:

WARNING: CPU: 2 PID: 5391 at fs/iomap.c:993 iomap_dio_rw+0xc79/0xe70
fs/iomap.c:993
Kernel panic - not syncing: panic_on_warn set ...

CPU: 2 PID: 5391 Comm: syz-executor1 Not tainted 4.13.0-rc7 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:16 [inline]
 dump_stack+0xf7/0x1aa lib/dump_stack.c:52
 panic+0x1ae/0x3a7 kernel/panic.c:180
 __warn+0x1c4/0x1d9 kernel/panic.c:541
 report_bug+0x211/0x2d0 lib/bug.c:183
 fixup_bug+0x40/0x90 arch/x86/kernel/traps.c:190
 do_trap_no_signal arch/x86/kernel/traps.c:224 [inline]
 do_trap+0x260/0x390 arch/x86/kernel/traps.c:273
 do_error_trap+0x118/0x340 arch/x86/kernel/traps.c:310
 do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:323
 invalid_op+0x18/0x20 arch/x86/entry/entry_64.S:846
RIP: 0010:iomap_dio_rw+0xc79/0xe70 fs/iomap.c:993
RSP: 0018:ffff88006d13f6d0 EFLAGS: 00010297
RAX: ffff880069c3da00 RBX: ffff88006d04c000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffed000da27ed0
RBP: ffff88006d13f8c0 R08: 0000000000000001 R09: 1ffff1000da27ddb
R10: ffff88006d13eea0 R11: 0000000000000002 R12: 1ffff1000da27eea
R13: 000000007ffff000 R14: 0000000000000000 R15: ffff88006d13fac8
 xfs_file_dio_aio_read+0x19c/0x5a0 fs/xfs/xfs_file.c:220
 xfs_file_read_iter+0x369/0x460 fs/xfs/xfs_file.c:286
 call_read_iter include/linux/fs.h:1737 [inline]
 generic_file_splice_read+0x3f9/0x7b0 fs/splice.c:307
 do_splice_to+0x10a/0x160 fs/splice.c:896
 splice_direct_to_actor+0x23e/0x870 fs/splice.c:968
 do_splice_direct+0x29b/0x3c0 fs/splice.c:1077
 do_sendfile+0x5c9/0xe80 fs/read_write.c:1412
 SYSC_sendfile64 fs/read_write.c:1467 [inline]
 SyS_sendfile64+0xbd/0x160 fs/read_write.c:1459
 entry_SYSCALL_64_fastpath+0x18/0xad
RIP: 0033:0x451e59
RSP: 002b:00007fa4a3718c08 EFLAGS: 00000216 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000718000 RCX: 0000000000451e59
RDX: 0000000020005ff8 RSI: 0000000000000003 RDI: 0000000000000003
RBP: 0000000000000046 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000800000000 R11: 0000000000000216 R12: 0000000000000000
R13: 00007ffde54a34ef R14: 00007fa4a37199c0 R15: 0000000000000000
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: 0x18a00000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
Rebooting in 86400 seconds..

Here is a reproducer program: https://pastebin.com/tc014k97
Here are my configs: https://pastebin.com/PWtYUiHD

