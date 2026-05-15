Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77E318787A
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 04:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778817688; cv=none; b=Ct9NrtOUAA1fHLQeElMXoqIA4k/A0IhGAO4sszD1Am62haikRd6US3175Gziqy0bxfOY/32z+bCBrWHoSvKdG21yD8vsl64OTOJGu4lntYdvDXl5ibumwZrsz9LGsEkkLSoMtQ4R5jDDPPb3j7IIUitFQGFa8E83Z+rVT6MTzYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778817688; c=relaxed/simple;
	bh=daZq+fOfrrJO34I1o8/uFX65qYRBX2zK7bn36H2tUeE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tvyJRJExh2ynchhpRQw7z2QULgKs/9cl7j4cogHOArYFq9711NPTR5GCxEDZgkcrsCNhtGc+RU2uJ4Q0K6bIbvay/BBSifO9S22MqBtXP9YEHJZiKm76dZiXAuYT3RXZlxe917UoOeyghM+1VLk1ilMU2LR/7antZxwH/jq2WNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7dca6ecdd85so12329805a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 21:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778817686; x=1779422486;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6LhgVESpvQNDhk2/cjGaIf9nTyGsehH1t/gr5sHaFrc=;
        b=cucIhv1sVQV3Kb0pc1B1H0QB7u9fgpM62H/qzKM/uh++p2bh5NHod3+Gf1lf7XIhAr
         ayOQi4TMCKCBVhGrsyUlc2SzJJR3sKhrnn4yKaHbvwS0xRMUcUfdtCzQyMkFTitk/xPY
         S5hkfG+65Rzno42XPCbLB8E+hC8HS9kJ5TrUXv/cp8odRF7xoXSpPvDO0tZtRG16KdNW
         9ZDOeOxsjpZMcHq3Cekn9T1R/wbBZJMpnOTHZewj/HJxhC/AAgercG5QlIymV10wC74O
         qLfr/EheE3fwdLlthoh0ONmw2ju4ADJzf94A41Z2nBVVXESmohIz5KkWwNGXzdh4mXCX
         yJLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+IvIc8+Jdu9eEmjIDUGHLDD8UAGm1QSg7GavF96VKz+dRcbGmZvE1vZzE9ZxEfi1xuRQ+bU/ST7Hc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoiwYjuvUsNBfiAm7ornOzOVDDtZ6t25XRlHKY4lYUlSA9upzv
	83QRtyEzmigNLaAlALW2Tou4QQGJcz3H+7mFDvwbBfSyE18PBl5cSI0xchqJugVjNWzk3dqHLH+
	G673bZAYilDASau9kMZqtBs0gsd0mZhlf45P3Pxs/fOTTDMOW0nTWo3UC42k=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:290e:b0:696:2674:8a07 with SMTP id
 006d021491bc7-69c9437a0e0mr1479874eaf.33.1778817685957; Thu, 14 May 2026
 21:01:25 -0700 (PDT)
Date: Thu, 14 May 2026 21:01:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a069a95.050a0220.2921a.0006.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xlog_cil_push_work (2)
From: syzbot <syzbot+598a791b31c498b63c6b@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5d6919055dec Linux 7.1-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e49ad2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2e8ebfec4636d32
dashboard link: https://syzkaller.appspot.com/bug?extid=598a791b31c498b63c6b
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f3613f2ac4da/disk-5d691905.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/684389e52691/vmlinux-5d691905.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dfdae69c3f9f/bzImage-5d691905.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+598a791b31c498b63c6b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0xb5/0x190 lib/list_debug.c:65
Read of size 8 at addr ffff8880408ef9a0 by task kworker/u8:9/1184

CPU: 0 UID: 0 PID: 1184 Comm: kworker/u8:9 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: xfs-cil/loop2 xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 __list_del_entry_valid_or_report+0xb5/0x190 lib/list_debug.c:65
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del_init include/linux/list.h:295 [inline]
 xlog_cil_build_lv_chain fs/xfs/xfs_log_cil.c:1335 [inline]
 xlog_cil_push_work+0x1291/0x2b10 fs/xfs/xfs_log_cil.c:1463
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 7903:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4569 [inline]
 slab_alloc_node mm/slub.c:4898 [inline]
 kmem_cache_alloc_noprof+0x33b/0x680 mm/slub.c:4905
 xfs_buf_item_init+0x6a/0x6d0 fs/xfs/xfs_buf_item.c:873
 _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_read_buf_map+0x294/0x8f0 fs/xfs/xfs_trans_buf.c:325
 xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
 xfs_btree_read_buf_block+0x2b0/0x490 fs/xfs/libxfs/xfs_btree.c:1402
 xfs_btree_lookup_get_block+0x297/0x510 fs/xfs/libxfs/xfs_btree.c:1907
 xfs_btree_lookup+0x45a/0x1350 fs/xfs/libxfs/xfs_btree.c:2018
 xfs_alloc_lookup fs/xfs/libxfs/xfs_alloc.c:166 [inline]
 xfs_alloc_lookup_eq fs/xfs/libxfs/xfs_alloc.c:184 [inline]
 xfs_alloc_fixup_trees+0x219/0xd30 fs/xfs/libxfs/xfs_alloc.c:626
 xfs_alloc_cur_finish+0xd5/0x4a0 fs/xfs/libxfs/xfs_alloc.c:1117
 xfs_alloc_ag_vextent_near+0xd70/0x1280 fs/xfs/libxfs/xfs_alloc.c:1776
 xfs_alloc_vextent_iterate_ags+0x640/0x950 fs/xfs/libxfs/xfs_alloc.c:3764
 xfs_alloc_vextent_start_ag+0x378/0x850 fs/xfs/libxfs/xfs_alloc.c:3839
 xfs_bmap_btalloc_best_length fs/xfs/libxfs/xfs_bmap.c:3619 [inline]
 xfs_bmap_btalloc fs/xfs/libxfs/xfs_bmap.c:3663 [inline]
 xfs_bmapi_allocate+0x17c1/0x2da0 fs/xfs/libxfs/xfs_bmap.c:3938
 xfs_bmapi_write+0x843/0x1330 fs/xfs/libxfs/xfs_bmap.c:4267
 xfs_iomap_write_direct+0x3ba/0x6b0 fs/xfs/xfs_iomap.c:338
 xfs_direct_write_iomap_begin+0xfbf/0x1410 fs/xfs/xfs_iomap.c:1012
 iomap_iter+0x600/0xf90 fs/iomap/iter.c:110
 __iomap_dio_rw+0xcda/0x1e40 fs/iomap/direct-io.c:806
 iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:901
 xfs_file_dio_write_aligned+0x3bc/0x4a0 fs/xfs/xfs_file.c:780
 xfs_file_dio_write fs/xfs/xfs_file.c:989 [inline]
 xfs_file_write_iter+0x7ea/0x920 fs/xfs/xfs_file.c:1201
 iter_file_splice_write+0x9a6/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x104/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x545/0xc80 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x19b/0x2a0 fs/splice.c:1228
 do_sendfile+0x547/0x7e0 fs/read_write.c:1372
 __do_sys_sendfile64 fs/read_write.c:1433 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 7903:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 slab_free mm/slub.c:6250 [inline]
 kmem_cache_free+0x187/0x6c0 mm/slub.c:6377
 __xfs_buf_ioend+0x292/0x6f0 fs/xfs/xfs_buf.c:1109
 xfs_buf_iowait+0x156/0x480 fs/xfs/xfs_buf.c:1293
 _xfs_buf_read fs/xfs/xfs_buf.c:597 [inline]
 xfs_buf_read_map+0x32d/0xa20 fs/xfs/xfs_buf.c:663
 xfs_trans_read_buf_map+0x1db/0x8f0 fs/xfs/xfs_trans_buf.c:304
 xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
 xfs_btree_read_buf_block+0x2b0/0x490 fs/xfs/libxfs/xfs_btree.c:1402
 xfs_btree_lookup_get_block+0x297/0x510 fs/xfs/libxfs/xfs_btree.c:1907
 xfs_btree_lookup+0x45a/0x1350 fs/xfs/libxfs/xfs_btree.c:2018
 xfs_alloc_lookup fs/xfs/libxfs/xfs_alloc.c:166 [inline]
 xfs_alloc_lookup_eq fs/xfs/libxfs/xfs_alloc.c:184 [inline]
 xfs_alloc_fixup_trees+0x219/0xd30 fs/xfs/libxfs/xfs_alloc.c:626
 xfs_alloc_cur_finish+0xd5/0x4a0 fs/xfs/libxfs/xfs_alloc.c:1117
 xfs_alloc_ag_vextent_near+0xd70/0x1280 fs/xfs/libxfs/xfs_alloc.c:1776
 xfs_alloc_vextent_iterate_ags+0x640/0x950 fs/xfs/libxfs/xfs_alloc.c:3764
 xfs_alloc_vextent_start_ag+0x378/0x850 fs/xfs/libxfs/xfs_alloc.c:3839
 xfs_bmap_btalloc_best_length fs/xfs/libxfs/xfs_bmap.c:3619 [inline]
 xfs_bmap_btalloc fs/xfs/libxfs/xfs_bmap.c:3663 [inline]
 xfs_bmapi_allocate+0x17c1/0x2da0 fs/xfs/libxfs/xfs_bmap.c:3938
 xfs_bmapi_write+0x843/0x1330 fs/xfs/libxfs/xfs_bmap.c:4267
 xfs_iomap_write_direct+0x3ba/0x6b0 fs/xfs/xfs_iomap.c:338
 xfs_direct_write_iomap_begin+0xfbf/0x1410 fs/xfs/xfs_iomap.c:1012
 iomap_iter+0x600/0xf90 fs/iomap/iter.c:110
 __iomap_dio_rw+0xcda/0x1e40 fs/iomap/direct-io.c:806
 iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:901
 xfs_file_dio_write_aligned+0x3bc/0x4a0 fs/xfs/xfs_file.c:780
 xfs_file_dio_write fs/xfs/xfs_file.c:989 [inline]
 xfs_file_write_iter+0x7ea/0x920 fs/xfs/xfs_file.c:1201
 iter_file_splice_write+0x9a6/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x104/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x545/0xc80 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x19b/0x2a0 fs/splice.c:1228
 do_sendfile+0x547/0x7e0 fs/read_write.c:1372
 __do_sys_sendfile64 fs/read_write.c:1433 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1419
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880408ef930
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 112 bytes inside of
 freed 272-byte region [ffff8880408ef930, ffff8880408efa40)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8880408ef150 pfn:0x408ef
flags: 0x80000000000200(workingset|node=0|zone=1)
page_type: f5(slab)
raw: 0080000000000200 ffff88814042c780 ffffea00018bc250 ffffea0000fa99d0
raw: ffff8880408ef150 00000008000c000b 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6875, tgid 6874 (syz.0.190), ts 178643306243, free_ts 175406030838
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x27c8/0x2840 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_slab_page mm/slub.c:3278 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3467
 new_slab mm/slub.c:3525 [inline]
 refill_objects+0x33c/0x3d0 mm/slub.c:7255
 refill_sheaf mm/slub.c:2816 [inline]
 __pcs_replace_empty_main+0x373/0x720 mm/slub.c:4651
 alloc_from_pcs mm/slub.c:4749 [inline]
 slab_alloc_node mm/slub.c:4883 [inline]
 kmem_cache_alloc_noprof+0x433/0x680 mm/slub.c:4905
 xfs_buf_item_init+0x6a/0x6d0 fs/xfs/xfs_buf_item.c:873
 _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_read_buf_map+0x294/0x8f0 fs/xfs/xfs_trans_buf.c:325
 xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
 xfs_imap_to_bp+0x12a/0x2d0 fs/xfs/libxfs/xfs_inode_buf.c:139
 xfs_inode_item_precommit+0x737/0xb70 fs/xfs/xfs_inode_item.c:170
 xfs_trans_run_precommits fs/xfs/xfs_trans.c:798 [inline]
 __xfs_trans_commit+0x2ec/0xbf0 fs/xfs/xfs_trans.c:841
 xfs_trans_roll+0x127/0x450 fs/xfs/xfs_trans.c:1031
 xfs_defer_trans_roll+0x182/0x5e0 fs/xfs/libxfs/xfs_defer.c:479
 xfs_defer_finish_noroll+0x844/0x1310 fs/xfs/libxfs/xfs_defer.c:688
page last free pid 20 tgid 20 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xfa6/0x10f0 mm/page_alloc.c:2943
 __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core kernel/rcu/tree.c:2869 [inline]
 rcu_cpu_kthread+0x99e/0x1470 kernel/rcu/tree.c:2957
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff8880408ef880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc
 ffff8880408ef900: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
>ffff8880408ef980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff8880408efa00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880408efa80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
