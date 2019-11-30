Return-Path: <SRS0=J6xf=ZW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB0EC432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 07:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1453F2072C
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 07:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbfK3HTJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Nov 2019 02:19:09 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:39445 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfK3HTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Nov 2019 02:19:09 -0500
Received: by mail-io1-f72.google.com with SMTP id u13so19416335iol.6
        for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2019 23:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Iszxj3xslkgFiHBpTht8Zqpoj8q3iHoILKi1CRIqeFo=;
        b=sW0wOnfLKT64fWmyxvUFh+pVtq7Fs4XkN6+MmemCtCD9kfuClJqPoV+PcdF4GSzCAx
         Djr8MX0CvBqkLlsucJCetDhKhm5S1R0tXv1ZwGLM95LcQmDqOcxVVub8/oIKKHPIS2kw
         UOPJykZ+i6AGXc0Du+32B9hnhLygyaqfAci0KfrY6oOwNyhD+BN0IlwGdBWxKKoPadgz
         F9zKsMDCPFgzx1FHC80uOLR2OOSXxgQO0PtDPpc46VH4Clr/dJA+b3T1hYAf0daVO1ch
         eQG60HLBFxa7u8f3UTQ09w5og5IukxNssGPMsRUFLhJDT6CyK/WZjUe4SGTyiMIUBT/X
         Gqig==
X-Gm-Message-State: APjAAAV60z8g05fnrFe+D00YRxiRKbMfNHGDw7KMgP8FB+Uvqtqx/ibX
        RGZ9hQF2bripHF/4KCiZuVmx2fENBIXNFG2d1WRZtE7yGkta
X-Google-Smtp-Source: APXvYqxMt060BD8gSa++k51h6Fp7squipmwrA4vm7Riv4aIzuKEn/9cvlou91jaqXCGEVS2ftXaKCqBjw7WzXdD6/yYNsXYosfFh
MIME-Version: 1.0
X-Received: by 2002:a6b:9302:: with SMTP id v2mr36196070iod.12.1575098348190;
 Fri, 29 Nov 2019 23:19:08 -0800 (PST)
Date:   Fri, 29 Nov 2019 23:19:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000087c51905988b297b@google.com>
Subject: KASAN: use-after-free Read in xlog_alloc_log (2)
From:   syzbot <syzbot+c732f8644185de340492@syzkaller.appspotmail.com>
To:     darrick.wong@oracle.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b27696e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=773597fe8d7cb41a
dashboard link: https://syzkaller.appspot.com/bug?extid=c732f8644185de340492
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in xlog_alloc_log+0x1398/0x14b0  
fs/xfs/xfs_log.c:1495
Read of size 8 at addr ffff888068139890 by task syz-executor.3/32544

CPU: 0 PID: 32544 Comm: syz-executor.3 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  xlog_alloc_log+0x1398/0x14b0 fs/xfs/xfs_log.c:1495
  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
  xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
  mount_bdev+0x304/0x3c0 fs/super.c:1415
  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
  legacy_get_tree+0x108/0x220 fs/fs_context.c:647
  vfs_get_tree+0x8e/0x300 fs/super.c:1545
  do_new_mount fs/namespace.c:2822 [inline]
  do_mount+0x135a/0x1b50 fs/namespace.c:3142
  ksys_mount+0xdb/0x150 fs/namespace.c:3351
  __do_sys_mount fs/namespace.c:3365 [inline]
  __se_sys_mount fs/namespace.c:3362 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45d0ca
Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 4d 8c fb ff c3 66 2e 0f  
1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 2a 8c fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007f525b430a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f525b430b40 RCX: 000000000045d0ca
RDX: 00007f525b430ae0 RSI: 0000000020000100 RDI: 00007f525b430b00
RBP: 0000000000000001 R08: 00007f525b430b40 R09: 00007f525b430ae0
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
R13: 00000000004ca258 R14: 00000000004e2870 R15: 00000000ffffffff

Allocated by task 32544:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:561 [inline]
  kmem_alloc+0x15b/0x4d0 fs/xfs/kmem.c:21
  kmem_zalloc fs/xfs/kmem.h:68 [inline]
  xlog_alloc_log+0xcce/0x14b0 fs/xfs/xfs_log.c:1437
  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
  xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
  mount_bdev+0x304/0x3c0 fs/super.c:1415
  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
  legacy_get_tree+0x108/0x220 fs/fs_context.c:647
  vfs_get_tree+0x8e/0x300 fs/super.c:1545
  do_new_mount fs/namespace.c:2822 [inline]
  do_mount+0x135a/0x1b50 fs/namespace.c:3142
  ksys_mount+0xdb/0x150 fs/namespace.c:3351
  __do_sys_mount fs/namespace.c:3365 [inline]
  __se_sys_mount fs/namespace.c:3362 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 32544:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  kvfree+0x61/0x70 mm/util.c:593
  kmem_free fs/xfs/kmem.h:61 [inline]
  xlog_alloc_log+0xeb5/0x14b0 fs/xfs/xfs_log.c:1497
  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:599
  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:811
  xfs_fs_fill_super+0xd24/0x1750 fs/xfs/xfs_super.c:1732
  mount_bdev+0x304/0x3c0 fs/super.c:1415
  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1806
  legacy_get_tree+0x108/0x220 fs/fs_context.c:647
  vfs_get_tree+0x8e/0x300 fs/super.c:1545
  do_new_mount fs/namespace.c:2822 [inline]
  do_mount+0x135a/0x1b50 fs/namespace.c:3142
  ksys_mount+0xdb/0x150 fs/namespace.c:3351
  __do_sys_mount fs/namespace.c:3365 [inline]
  __se_sys_mount fs/namespace.c:3362 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3362
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888068139800
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 144 bytes inside of
  1024-byte region [ffff888068139800, ffff888068139c00)
The buggy address belongs to the page:
page:ffffea0001a04e40 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0
raw: 00fffe0000000200 ffffea0002728148 ffffea00015604c8 ffff8880aa400c40
raw: 0000000000000000 ffff888068139000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888068139780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888068139800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888068139880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff888068139900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888068139980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
