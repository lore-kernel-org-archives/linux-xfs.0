Received: from mail-oi2-f2.google.com (mail-oi2-f2.google.com [74.125.231.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C18263F4A
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 00:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788999386; cv=none; b=VsAy/pJ6AWHFSth/2IWDwceZF988t2SGzYJDWNpnq30ZcZWQQrnu+ud7gfXBnaURkHO5efbEatZlp8p2IJ3KilDrASUy0iGXFExGDfFoYjpZdYt0//EhAXK1ve7831d6O46QCF86DUqVt0vdFhq6iKUVamyKqpQWV+FVqxy9vZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788999386; c=relaxed/simple;
	bh=5DaK47e10/aN55eb0B3RcqXG/NfKdMaonV5ryvZnx4k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GFScRoP9qxgclHszbxxDb9hM3rVgVzrgM+BZg4ex+y8cqqNZGhtXOWQeHWYv5Ms3S7VDYziqakZNvE6prZ1Sk4ZUuzS+fMKWQKr//WVx3XQIyNwBw/diKSU4kFRROPSuHXdANzsEuCTTPRGGxqKrdqyQOOnj+DSkaLU+no0T+DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f2.google.com with SMTP id 5614622812f47-495d5d27acfso1907202b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 09 Sep 2026 17:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788999384; x=1789604184;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q95V9Ai954L90g+kOOR98kbHfmsfX6B1XCdngR+XJwc=;
        b=A8depcOQOlaV/A+7U+cpOIp61ZL+sN8Yw40cd5NPzBKoEaQP6WHVSBWkkoJI6iZmlX
         L4/wVJfl8KkDPksNdnsVLyqfDdneLMDzD2TAX/5GsTbMaFd/UhoUFwh2TJd5IlPCkfrz
         qZKNSLi06rHE8mLQmi3JKCoUr/gwPmCLuNcwE658IVvy0CUHa6prgusHdB9ST8ymI8ue
         xKSSySK+mq/zCUG/Zs5RzRG+GCkq9ZOJmzajuKeY8V7rHBzZqRHxpDTK7/ALyeArU5hS
         6xURLo1ydXYjyx79JlBYXfhS3Mg+PqWugdlFFwr78qmoc9PaJw+AqjswfVhfSlTzTu77
         aigw==
X-Forwarded-Encrypted: i=1; AKwUvBxzxNrKqj848GB0fRgpF5N17tWz/D3cCpRTEcVd827rtnUlny/G+h2BF/d3SJIKhl1bIAIP9gz2LKU=@vger.kernel.org
X-Gm-Message-State: AFuF++mHUY6gAfgvgUaQ5ckLn0zzVbkSgD6XPBVV81t/VnGzbQFuZ/gq
	Zzqzt39H5MAibGhli+DZqAgQytc9Ir0ELxBzVtdy2dKEkjw97xO0GeESwdSY0h3IOqElAW6UhXJ
	Zvd2a0sjGEw2zPccxUG4cNu0aO1CJHWZ4nz0KKnREfrwFeNcZXw/XWUCWG/U=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81cb:b0:6b1:6636:e919 with SMTP id
 006d021491bc7-6bdc9f6f200mr9974752eaf.11.1788999383845; Wed, 09 Sep 2026
 17:16:23 -0700 (PDT)
Date: Wed, 09 Sep 2026 17:16:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa1f6d7.f2639fcc.29487d.0010.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Write in xlog_cil_ail_insert
From: syzbot <syzbot+a4fde844548510369112@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    654ae5d73c05 Merge tag 'drm-fixes-2026-09-05' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16691125580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19560cab9a915237
dashboard link: https://syzkaller.appspot.com/bug?extid=a4fde844548510369112
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bb30b9c473e7/disk-654ae5d7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fcb222028f47/vmlinux-654ae5d7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5cfc3b5a7eef/bzImage-654ae5d7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4fde844548510369112@syzkaller.appspotmail.com

XFS (loop0): Please unmount the filesystem and rectify the problem(s).
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_write include/linux/instrumented.h:97 [inline]
BUG: KASAN: slab-use-after-free in set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_ail_insert+0x55b/0xd00 fs/xfs/xfs_log_cil.c:889
Write of size 8 at addr ffff888028e06d60 by task kworker/1:1H/1998

CPU: 1 UID: 0 PID: 1998 Comm: kworker/1:1H Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Workqueue: xfs-log/loop0 xlog_ioend_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
 instrument_atomic_write include/linux/instrumented.h:97 [inline]
 set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
 xlog_cil_ail_insert+0x55b/0xd00 fs/xfs/xfs_log_cil.c:889
 xlog_cil_committed+0xd7/0x6f0 fs/xfs/xfs_log_cil.c:995
 xlog_cil_process_committed+0x123/0x1f0 fs/xfs/xfs_log_cil.c:1025
 xlog_state_shutdown_callbacks+0x1ef/0x3a0 fs/xfs/xfs_log.c:438
 xlog_force_shutdown+0x21b/0x490 fs/xfs/xfs_log.c:3408
 xlog_ioend_work+0xec/0x110 fs/xfs/xfs_log.c:1205
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
 process_scheduled_works kernel/workqueue.c:3479 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 9369:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x269/0x6a0 mm/slub.c:5010
 xfs_buf_item_init+0x8a/0x660 fs/xfs/xfs_buf_item.c:872
 _xfs_trans_bjoin+0x3f/0x140 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_get_buf_map+0x2be/0x750 fs/xfs/xfs_trans_buf.c:162
 xfs_trans_get_buf fs/xfs/xfs_trans.h:189 [inline]
 xfs_dquot_disk_alloc+0x62a/0xbc0 fs/xfs/xfs_dquot.c:397
 xfs_qm_dqread+0x4e7/0x5d0 fs/xfs/xfs_dquot.c:720
 xfs_qm_dqget+0xee/0x3c0 fs/xfs/xfs_dquot.c:923
 xfs_qm_quotacheck_dqadjust+0xae/0x5a0 fs/xfs/xfs_qm.c:1260
 xfs_qm_dqusage_adjust+0x524/0x6f0 fs/xfs/xfs_qm.c:1403
 xfs_iwalk_ag_recs+0x523/0x870 fs/xfs/xfs_iwalk.c:209
 xfs_iwalk_run_callbacks+0x1f7/0x580 fs/xfs/xfs_iwalk.c:370
 xfs_iwalk_ag+0x81e/0xa30 fs/xfs/xfs_iwalk.c:473
 xfs_iwalk_ag_work+0x117/0x1f0 fs/xfs/xfs_iwalk.c:620
 xfs_pwork_work+0x82/0x170 fs/xfs/xfs_pwork.c:47
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
 process_scheduled_works kernel/workqueue.c:3479 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 13586:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6499 [inline]
 kmem_cache_free+0x127/0x6c0 mm/slub.c:6626
 xfs_buf_ioend+0x351/0x1aa0 fs/xfs/xfs_buf.c:1167
 xfs_buf_iowait+0xfa/0x470 fs/xfs/xfs_buf.c:1336
 xfs_buf_delwri_submit+0x3f8/0x600 fs/xfs/xfs_buf.c:2051
 xfs_qm_quotacheck+0x2f9/0x880 fs/xfs/xfs_qm.c:1536
 xfs_qm_mount_quotas+0x17f/0x6d0 fs/xfs/xfs_qm.c:1645
 xfs_mountfs+0x1d04/0x1fd0 fs/xfs/xfs_mount.c:1190
 xfs_fs_fill_super+0x1523/0x1f30 fs/xfs/xfs_super.c:1987
 get_tree_bdev_flags+0x38c/0x620 fs/super.c:1887
 vfs_get_tree+0x92/0x320 fs/super.c:1947
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount fs/namespace.c:3848 [inline]
 path_mount+0x7d0/0x24c0 fs/namespace.c:4168
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount fs/namespace.c:4374 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888028e06d20
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 64 bytes inside of
 freed 272-byte region [ffff888028e06d20, ffff888028e06e30)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x28e06
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88802031a500 dead000000000100 dead000000000122
raw: 0000000000000000 00000002000c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9561, tgid 9561 (kworker/u8:12), ts 351126059615
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7410
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_noprof+0x4c4/0x6a0 mm/slub.c:5010
 xfs_buf_item_init+0x8a/0x660 fs/xfs/xfs_buf_item.c:872
 _xfs_trans_bjoin+0x3f/0x140 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_read_buf_map+0x54f/0x8b0 fs/xfs/xfs_trans_buf.c:294
 xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
 xfs_alloc_read_agfl+0x23b/0x390 fs/xfs/libxfs/xfs_alloc.c:885
 xfs_alloc_fix_freelist+0xac5/0x10d0 fs/xfs/libxfs/xfs_alloc.c:2961
 xfs_alloc_vextent_prepare_ag+0x7a/0x680 fs/xfs/libxfs/xfs_alloc.c:3566
 xfs_alloc_vextent_iterate_ags.constprop.0+0x1b5/0x9f0 fs/xfs/libxfs/xfs_alloc.c:3750
 xfs_alloc_vextent_start_ag+0x2cb/0x7f0 fs/xfs/libxfs/xfs_alloc.c:3839
 xfs_bmap_btalloc_best_length fs/xfs/libxfs/xfs_bmap.c:3617 [inline]
 xfs_bmap_btalloc+0x1113/0x18a0 fs/xfs/libxfs/xfs_bmap.c:3661
page last free pid 12 tgid 12 ts 350823962674 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0x79f/0x10f0 mm/page_alloc.c:2962
 __folio_put+0x3b4/0x5f0 mm/folio.c:105
 folio_put_refs include/linux/mm.h:2180 [inline]
 gup_put_folio+0x1cb/0x270 mm/gup.c:114
 unpin_user_pages mm/gup.c:422 [inline]
 unpin_user_pages+0x179/0x200 mm/gup.c:401
 io_free_region+0xd6/0x340 io_uring/memmap.c:115
 io_rings_free io_uring/io_uring.c:2071 [inline]
 io_ring_ctx_free io_uring/io_uring.c:2180 [inline]
 io_ring_exit_work+0x9de/0xd59 io_uring/io_uring.c:2410
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
 process_scheduled_works kernel/workqueue.c:3479 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888028e06c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888028e06c80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff888028e06d00: fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888028e06d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888028e06e00: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fa fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
