Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33F3C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Dec 2022 05:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiLLFum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Dec 2022 00:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLLFul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2022 00:50:41 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDD426C7
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2022 21:50:40 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id k6-20020a92c246000000b003035797fa8cso4455943ilo.8
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2022 21:50:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2kTBxmFefaIe3ApIljBUsgPpNXlsB2QlyMDSvZtPkIk=;
        b=5PqPeoEZE0cTkzO+jHH3dXlxjstnWsW3cp25nwrot0gtHpuhIaM0VgokDdr1uvrVBB
         XnF13GaOPbJY0lfowAgYbzFNf/cUlaLOgud5yN+yW+fsoMXE8GCQ90Fv1AFN3l2H/DLw
         q0tXOZK0LASCoJe28FZYMkghMNh/QCPsEieGcXpKGnEm/AaE/7otY4WAfJFSrr2rGXWy
         vU2iFTAjKIV1xwJOm332Ac6/OjTaA4wYtVFBljYdcvKbxiGCeRcTDsh6yP3g/e9zKIYy
         RfacBUMLtMxggRnCliOSFhD0blbQyrJEscrrccbyzAR6+KfmkW4GVcbFQwG3FMRv1CAV
         PGEQ==
X-Gm-Message-State: ANoB5pnjE9jb6fQBd8HHyT1Dsndo9NCU0NCzwjf+5r3hcTVM7QZ9COus
        l+IHh1eXfyY78u3DYVmDRPLbTS9wEEH4gDfGGXcON8Il4Mcm
X-Google-Smtp-Source: AA0mqf6rVXvhqEiG9Mr8boUZhaTIqlpTDay79N6D1dQ1qNP9tBIW/wAXL5dSLg1kJ52fRWngWvHYAgiolfattWXM003d3Po6T3V0
MIME-Version: 1.0
X-Received: by 2002:a05:6602:889:b0:6e2:ec05:87c8 with SMTP id
 f9-20020a056602088900b006e2ec0587c8mr464658ioz.144.1670824239739; Sun, 11 Dec
 2022 21:50:39 -0800 (PST)
Date:   Sun, 11 Dec 2022 21:50:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ab8ac05ef9b1578@google.com>
Subject: [syzbot] KASAN: stack-out-of-bounds Read in xfs_buf_lock
From:   syzbot <syzbot+0bc698a422b5e4ac988c@syzkaller.appspotmail.com>
To:     djwong@kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    830b3c68c1fb Linux 6.1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1058e613880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=81ba923a020d4bf2
dashboard link: https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0bc698a422b5e4ac988c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: stack-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: stack-out-of-bounds in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: stack-out-of-bounds in xfs_buf_lock+0xd0/0x750 fs/xfs/xfs_buf.c:1118
Read of size 4 at addr ffffc90003bb7bec by task kswapd0/137

CPU: 0 PID: 137 Comm: kswapd0 Not tainted 6.1.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x461 mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 xfs_buf_lock+0xd0/0x750 fs/xfs/xfs_buf.c:1118
 xfs_buf_delwri_submit_buffers+0x131/0xae0 fs/xfs/xfs_buf.c:2164
 xfs_buf_delwri_submit+0x8a/0x260 fs/xfs/xfs_buf.c:2242
 xfs_qm_shrink_scan fs/xfs/xfs_qm.c:514 [inline]
 xfs_qm_shrink_scan+0x1a7/0x370 fs/xfs/xfs_qm.c:495
 do_shrink_slab+0x464/0xce0 mm/vmscan.c:842
 shrink_slab+0x175/0x660 mm/vmscan.c:1002
 shrink_node_memcgs mm/vmscan.c:6112 [inline]
 shrink_node+0x93d/0x1f30 mm/vmscan.c:6141
 kswapd_shrink_node mm/vmscan.c:6930 [inline]
 balance_pgdat+0x8f5/0x1530 mm/vmscan.c:7120
 kswapd+0x70b/0xfc0 mm/vmscan.c:7380
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

The buggy address belongs to the virtual mapping at
 [ffffc90003bb0000, ffffc90003bb9000) created by:
 kernel_clone+0xeb/0x980 kernel/fork.c:2671

The buggy address belongs to the physical page:
page:ffffea000112a0c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x44a83
memcg:ffff88801ef48d82
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff ffff88801ef48d82
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x102dc2(GFP_HIGHUSER|__GFP_NOWARN|__GFP_ZERO), pid 4100, tgid 4100 (syz-executor.3), ts 374197857049, free_ts 372703071778
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 vm_area_alloc_pages mm/vmalloc.c:2975 [inline]
 __vmalloc_area_node mm/vmalloc.c:3043 [inline]
 __vmalloc_node_range+0x978/0x13c0 mm/vmalloc.c:3213
 alloc_thread_stack_node kernel/fork.c:311 [inline]
 dup_task_struct kernel/fork.c:974 [inline]
 copy_process+0x1566/0x7190 kernel/fork.c:2084
 kernel_clone+0xeb/0x980 kernel/fork.c:2671
 __do_sys_clone+0xba/0x100 kernel/fork.c:2812
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x4d0 mm/page_alloc.c:3483
 __vunmap+0x85d/0xd30 mm/vmalloc.c:2713
 free_work+0x5c/0x80 mm/vmalloc.c:97
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Memory state around the buggy address:
 ffffc90003bb7a80: 00 00 00 00 00 f1 f1 f1 f1 00 00 f3 f3 00 00 00
 ffffc90003bb7b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffffc90003bb7b80: 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1 04
                                                          ^
 ffffc90003bb7c00: f2 04 f2 00 f2 f2 f2 00 f3 f3 f3 00 00 00 00 00
 ffffc90003bb7c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
