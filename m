Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C122FC19F20
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 21:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjEBVya (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 17:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBVy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 17:54:29 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A261704
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 14:54:28 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-760ed929d24so587933439f.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 14:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683064468; x=1685656468;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTPVIrzcKEWMJ3byfboZXjS20kW2AjwQZBr60nTtraY=;
        b=N+kyxYeXn5JbbGI7AinFVIC/S2GSlfyehYxMeY4s1Y0DM4su5rJuYiJ4TS4CEg2eTh
         QhDPdGArbpTuqMvoxpyzi+p+gTe2+nyfRzuE6unY2CU1M0tnkkc0twkUyWFtQ/BlK/U4
         Qk9xekWK+ctX6vvdDfVcZSbOpO4NDkhNFETTZ9siJ6zA6KJ0zI6WVmZF3sazjt7okVtF
         K41JjNzf+tfshLqQhIUgxjVF03jFwZjPXnn7nrNoefReKOfIDDWQEh0C4HbuPOTOgGVZ
         h/v0CQfwjqR8FjJz042UlqPs/GvYla55vfMNwenr0OpPQa5vELrCgWTX8cuNloXD/6cw
         ITfA==
X-Gm-Message-State: AC+VfDwhGpZJPBuSccmXc5bRxP6LyiVf73WXKrt4TOc/xBBqz6foiKhe
        uj3Mmvge+Caqa2wurexGSskwdTWIx5TJ49yFmCxVk729jXvZ
X-Google-Smtp-Source: ACHHUZ79de6W3SH0oFksoBauOQY2CMDx93XEsOt9TZlhzQ88vMgWuKMAACD2hI38H/1OLISQH2DWfE2tgfHesctSQ1xrnHzJELKl
MIME-Version: 1.0
X-Received: by 2002:a6b:ee10:0:b0:766:3ffc:b5de with SMTP id
 i16-20020a6bee10000000b007663ffcb5demr8781874ioh.3.1683064467909; Tue, 02 May
 2023 14:54:27 -0700 (PDT)
Date:   Tue, 02 May 2023 14:54:27 -0700
In-Reply-To: <20230502212437.GB15394@frogsfrogsfrogs>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000be7b8e05fabcfb78@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-out-of-bounds Read in xfs_getbmap
From:   syzbot <syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com>
To:     djwong@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-out-of-bounds Read in xfs_getbmap

==================================================================
BUG: KASAN: slab-out-of-bounds in xfs_getbmap+0x1c06/0x1c90 fs/xfs/xfs_bmap_util.c:561
Read of size 4 at addr ffff88801e0c6bf8 by task syz-executor.0/5437

CPU: 0 PID: 5437 Comm: syz-executor.0 Not tainted 6.3.0-rc6-syzkaller-00136-g0d8b7cb91a7b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:319 [inline]
 print_report+0x163/0x540 mm/kasan/report.c:430
 kasan_report+0x176/0x1b0 mm/kasan/report.c:536
 xfs_getbmap+0x1c06/0x1c90 fs/xfs/xfs_bmap_util.c:561
 xfs_ioc_getbmap+0x243/0x7a0 fs/xfs/xfs_ioctl.c:1481
 xfs_file_ioctl+0xbf5/0x16a0 fs/xfs/xfs_ioctl.c:1949
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa58488c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa585693168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fa5849ac050 RCX: 00007fa58488c169
RDX: 0000000020000140 RSI: 00000000c0205826 RDI: 0000000000000005
RBP: 00007fa5848e7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff57c531ef R14: 00007fa585693300 R15: 0000000000022000
 </TASK>

Allocated by task 5119:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4f/0x70 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0xb9/0x230 mm/slab_common.c:980
 kmalloc include/linux/slab.h:584 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
 tomoyo_encode+0x26f/0x530 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x598/0x5e0 security/tomoyo/realpath.c:283
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x28d/0x700 security/tomoyo/file.c:822
 security_inode_getattr+0xd3/0x120 security/security.c:1375
 vfs_getattr fs/stat.c:167 [inline]
 vfs_statx+0x18f/0x480 fs/stat.c:242
 vfs_fstatat fs/stat.c:276 [inline]
 __do_sys_newfstatat fs/stat.c:446 [inline]
 __se_sys_newfstatat fs/stat.c:440 [inline]
 __x64_sys_newfstatat+0x14f/0x1d0 fs/stat.c:440
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88801e0c6b80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 56 bytes to the right of
 allocated 64-byte region [ffff88801e0c6b80, ffff88801e0c6bc0)

The buggy address belongs to the physical page:
page:ffffea0000783180 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1e0c6
anon flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff888012441640 ffffea0000a23a40 dead000000000005
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 56, tgid 56 (kworker/u4:4), ts 6181756049, free_ts 0
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x1e6/0x210 mm/page_alloc.c:2546
 prep_new_page mm/page_alloc.c:2553 [inline]
 get_page_from_freelist+0x3246/0x33c0 mm/page_alloc.c:4326
 __alloc_pages+0x255/0x670 mm/page_alloc.c:5592
 alloc_slab_page+0x6a/0x160 mm/slub.c:1851
 allocate_slab mm/slub.c:1998 [inline]
 new_slab+0x84/0x2f0 mm/slub.c:2051
 ___slab_alloc+0xa85/0x10a0 mm/slub.c:3193
 __slab_alloc mm/slub.c:3292 [inline]
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1b8/0x290 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc_node+0xa7/0x230 mm/slab_common.c:974
 kmalloc_node include/linux/slab.h:610 [inline]
 __vmalloc_area_node mm/vmalloc.c:3015 [inline]
 __vmalloc_node_range+0x5fc/0x14e0 mm/vmalloc.c:3201
 alloc_thread_stack_node kernel/fork.c:311 [inline]
 dup_task_struct+0x3e5/0x750 kernel/fork.c:982
 copy_process+0x5bd/0x3fc0 kernel/fork.c:2098
 kernel_clone+0x222/0x800 kernel/fork.c:2682
 user_mode_thread+0x132/0x190 kernel/fork.c:2758
 call_usermodehelper_exec_work+0x5c/0x220 kernel/umh.c:172
 process_one_work+0x8a0/0x10e0 kernel/workqueue.c:2390
 worker_thread+0xa63/0x1210 kernel/workqueue.c:2537
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801e0c6a80: 00 00 00 00 00 01 fc fc fc fc fc fc fc fc fc fc
 ffff88801e0c6b00: 00 00 00 00 00 01 fc fc fc fc fc fc fc fc fc fc
>ffff88801e0c6b80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                                                ^
 ffff88801e0c6c00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff88801e0c6c80: 00 00 00 00 00 01 fc fc fc fc fc fc fc fc fc fc
==================================================================


Tested on:

commit:         0d8b7cb9 xfs: fix xfs_inodegc_stop racing with mod_del..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git inodegc-fixes-6.4_2023-05-01
console output: https://syzkaller.appspot.com/x/log.txt?x=16be6974280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64660a60375eadd7
dashboard link: https://syzkaller.appspot.com/bug?extid=c103d3808a0de5faaf80
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
