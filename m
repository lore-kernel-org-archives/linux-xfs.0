Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:34550 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfBHRFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 12:05:22 -0500
MIME-Version: 1.0
From: Kyungtae Kim <kt0755@gmail.com>
Date: Fri, 8 Feb 2019 12:05:09 -0500
Message-ID: <CAEAjamtgtkkBbwOEjSG+m9Oe0Jb2JDpZoAiYXg4Js4hEMB9pBw@mail.gmail.com>
Subject: UBSAN: Undefined behaviour in fs/xfs/xfs_ioctl.c
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: Byoungyoung Lee <lifeasageek@gmail.com>, DaeRyong Jeong <threeearcat@gmail.com>, syzkaller <syzkaller@googlegroups.com>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

I'm reporting a bug in linux-4.19.19: "UBSAN: Undefined behaviour in
fs/xfs/xfs_ioctl.c"

kernel config: https://kt0755.github.io/etc/config_4.19.19
repro: https://kt0755.github.io/etc/repro.8d35e.c (xfs is mounted on
/mnt/xfs/)

Integer overflow arose in xfs_ioc_space() when bf->l_start + bf->l_len
(at line 676) is larger than the boundary of its storage (i.e., long long int).
A sanity check right before it would help.

=========================================
UBSAN: Undefined behaviour in fs/xfs/xfs_ioctl.c:676:18
signed integer overflow:
2378465760851919362 + 8382694012240466910 cannot be represented in
type 'long long int'
CPU: 0 PID: 8220 Comm: syz-executor2 Not tainted 4.19.19 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xd2/0x148 lib/dump_stack.c:113
 ubsan_epilogue+0x12/0x94 lib/ubsan.c:159
 handle_overflow+0x1cf/0x21a lib/ubsan.c:190
 __ubsan_handle_add_overflow+0x2a/0x31 lib/ubsan.c:198
 xfs_ioc_space+0xb97/0xc70 fs/xfs/xfs_ioctl.c:676
 xfs_file_ioctl+0x101e/0x1690 fs/xfs/xfs_ioctl.c:1926
 vfs_ioctl fs/ioctl.c:46 [inline]
 do_vfs_ioctl+0x1aa/0x1160 fs/ioctl.c:690
 ksys_ioctl+0x9e/0xb0 fs/ioctl.c:705
 __do_sys_ioctl fs/ioctl.c:712 [inline]
 __se_sys_ioctl fs/ioctl.c:710 [inline]
 __x64_sys_ioctl+0x7e/0xc0 fs/ioctl.c:710
 do_syscall_64+0xc4/0x510 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4497b9
Code: e8 8c 9f 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 0f 83 9b 6b fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7df3931c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f7df39326cc RCX: 00000000004497b9
RDX: 0000000020000000 RSI: 0000020040305829 RDI: 0000000000000013
RBP: 000000000071bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000005f70 R14: 00000000006ef010 R15: 00007f7df3932700
=========================================

Thanks,
Kyungtae
