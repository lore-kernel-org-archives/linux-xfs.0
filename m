Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750994AbdEZLpf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 May 2017 07:45:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F5E5AC04
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2017 11:45:34 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
Subject: xfs/098 hits assertion failure on 4.12-rc2
Message-ID: <3f9e935b-5203-d183-69e9-b548e81fb232@suse.com>
Date: Fri, 26 May 2017 14:45:33 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Running xfs/098 test on latest master I get the following: 

[  314.719553] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 552
[  314.721397] kernel BUG at fs/xfs/xfs_message.c:113!
[  314.722399] invalid opcode: 0000 [#1] SMP
[  314.723091] Modules linked in:
[  314.723622] CPU: 2 PID: 4424 Comm: mount Not tainted 4.12.0-rc2-nbor #187
[  314.724386] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  314.725423] task: ffff880128581c40 task.stack: ffffc90007d10000
[  314.726089] RIP: 0010:assfail+0x20/0x30
[  314.726520] RSP: 0018:ffffc90007d13ba8 EFLAGS: 00010286
[  314.727097] RAX: 00000000ffffffea RBX: 0000000000004dff RCX: 0000000000000000
[  314.727879] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff819ccf9a
[  314.728656] RBP: ffffc90007d13ba8 R08: 0000000000000000 R09: 0000000000000000
[  314.729433] R10: 0000000000000000 R11: f000000000000000 R12: ffff88012e460000
[  314.730210] R13: ffff880127437000 R14: 0000000000000000 R15: 0000000000004e00
[  314.730982] FS:  00007f2878919840(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
[  314.732068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  314.732698] CR2: 00007f329ff66070 CR3: 000000012ea94000 CR4: 00000000000006a0
[  314.733649] Call Trace:
[  314.733901]  xlog_find_verify_log_record+0x1be/0x230
[  314.734379]  xlog_find_head+0x244/0x4f0
[  314.734774]  xlog_find_tail+0x34/0x360
[  314.735345]  xlog_recover+0x1e/0x130
[  314.735977]  xfs_log_mount+0xdb/0x2e0
[  314.736717]  xfs_mountfs+0x57b/0xac0
[  314.737441]  xfs_fs_fill_super+0x483/0x610
[  314.738233]  mount_bdev+0x180/0x1b0
[  314.738684]  ? xfs_finish_flags+0x150/0x150
[  314.739153]  xfs_fs_mount+0x15/0x20
[  314.739748]  mount_fs+0x14/0x80
[  314.740133]  vfs_kern_mount+0x67/0x170
[  314.740542]  do_mount+0x195/0xd40
[  314.740912]  ? _copy_from_user+0x47/0x80
[  314.741348]  ? memdup_user+0x53/0x80
[  314.741741]  SyS_mount+0x95/0xe0
[  314.742102]  entry_SYSCALL_64_fastpath+0x23/0xc2
[  314.742602] RIP: 0033:0x7f28781f8faa
[  314.742991] RSP: 002b:00007fff23471d48 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  314.743801] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f28781f8faa
[  314.744560] RDX: 0000000002168240 RSI: 0000000002168280 RDI: 0000000002168260
[  314.745306] RBP: 0000000002168120 R08: 0000000000000000 R09: 0000000000000012
[  314.746225] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007f287870183c
[  314.747175] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
[  314.748417] Code: 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 30 b0 a0 81 48 89 e5 48 89 fa 31 ff e8 70 fa ff ff <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
[  314.750647] RIP: assfail+0x20/0x30 RSP: ffffc90007d13ba8
[  314.751456] ---[ end trace 56977821d2418231 ]---


Shouldn't the assertion there on xfs_Log_recover.c be removed, since -EIO can be 
handled gracefully and ASSERT(0) seems rather brutal? 
