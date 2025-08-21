Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2401C2F658B
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755781417; cv=none; b=qK75er3pU4aE/g+lYS9/zsmLEfn00On++XgF2GRYGMuMB0O+dvhcrkZ5+iH6u06K8ROknmd27onTiGqCw4XxhtwCuC1o41lMq26+TSLlCWlkNEhwanEmk5Gr4V2HO7o8Acryni6du0N3a7VqDBjNZt7QF7ZuErXBaojad7Tpibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755781417; c=relaxed/simple;
	bh=btE0F6kikJhl2rYvwbMq4EB60Ii4f4Fy2lLuOKFGS2c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YPwbufryPWLrsj27Dktzj0TgWHklbEtrbuJKu8tat01ZQOYFqT7eMPchZAcdkhrLd6D9jQ5CN9kLqJO15uZRRdAOTOpfA7Dc0i9iKCJ/8lUxrMYSoBu90ybHwULCIo5F6+FvhLuW37LlBTCkRbzcnZVVRYZLHqkoMzwAPekIAIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3e56fc142e0so12257405ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 06:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755781414; x=1756386214;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l689Uj8nPRK7CV4a0+e0NJooZGxup9TaeXN8cC4mJCI=;
        b=DIV1K6bkXbubZoZQ6PTV7a1jxl9sGu4WBBZ1fA6FOsZO7FGsTi/QAAvHeoNZyUb0Wr
         JC6MeG512Yq+HXS6/vNztfytoa7H/77twG+EIpAi/LssBXhKJg1C8xDPZMoOZ4p2k3t5
         9tqzX8/dOkh/n9qbnmJ6iSEps8z4Pi8/EGXd71n8eZpxYliBl1tKKdS4uHaUskWrwWsB
         sMmmEcJmWM3py34XPRe6l3XEjZqi44kkjVa/vPrNRKWIB9KgqTrD6KKX3+i2MJbA8nw3
         k5IPJKHDeN1/qlr5NXRiUIYfKsSnUPfl9Uv07mvNYxNBMY17yxCmybN5uf9JIlHhA5xc
         pKwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBXtoZ5YqSxeQjZbJaP2/+X/aNj0vdH4FQLqxe1ZH3wFeSvRAF3e+xk4krDWNajgpzln3znn+PRdw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEF3wBj8nMMZkRXjdDAApLbmB8LUVJXKqJyxjndliGu4qg4pQz
	pUInDGOr92AW1ST4OrKvyJj4wstg5ReY8WZCV4LXRetdV3n9kJ7LqR0+5BByN8emVMdf99zlrUU
	r06Pl6VLJHqBw7Udn82hAVzFaYi8ylsAqYzuYWNQJXFgBXys6cyC7b3l28OQ=
X-Google-Smtp-Source: AGHT+IHeriFa3NlWYLLfCkleetm0h8/OmuyMwoRnI/W8O02OF/z+R6fyX89x6L3maypgszyJm8Narp+Jr9gGe91MFPcNxgVVVrTK
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4512:b0:3e6:7d1a:8f22 with SMTP id
 e9e14a558f8ab-3e6d9de6790mr34561235ab.6.1755781414226; Thu, 21 Aug 2025
 06:03:34 -0700 (PDT)
Date: Thu, 21 Aug 2025 06:03:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a71926.050a0220.3d78fd.0028.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xlog_cil_push_work
From: syzbot <syzbot+95170b2e7d9e80b8a7d7@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    931e46dcbc7e Add linux-next specific files for 20250814
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16f92ba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a286bd75352e92fa
dashboard link: https://syzkaller.appspot.com/bug?extid=95170b2e7d9e80b8a7d7
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16db8ba2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111f7af0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fb896162d550/disk-931e46dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/45f6f857b82c/vmlinux-931e46dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0f16e70143e1/bzImage-931e46dc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9e084238f7d7/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=16b113a2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95170b2e7d9e80b8a7d7@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0xb5/0x190 lib/list_debug.c:65
Read of size 8 at addr ffff88805f82f850 by task kworker/u8:5/1029

CPU: 1 UID: 0 PID: 1029 Comm: kworker/u8:5 Not tainted 6.17.0-rc1-next-20250814-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: xfs-cil/loop4 xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __list_del_entry_valid_or_report+0xb5/0x190 lib/list_debug.c:65
 __list_del_entry_valid include/linux/list.h:124 [inline]
 __list_del_entry include/linux/list.h:215 [inline]
 list_del_init include/linux/list.h:287 [inline]
 xlog_cil_build_lv_chain fs/xfs/xfs_log_cil.c:1246 [inline]
 xlog_cil_push_work+0x11c0/0x2570 fs/xfs/xfs_log_cil.c:1374
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 3859:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:339 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4236
 xfs_buf_item_init+0x66/0x670 fs/xfs/xfs_buf_item.c:878
 _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_read_buf_map+0x28f/0x8e0 fs/xfs/xfs_trans_buf.c:325
 xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]
 xfs_btree_read_buf_block+0x290/0x470 fs/xfs/libxfs/xfs_btree.c:1402
 xfs_btree_lookup_get_block+0x28d/0x500 fs/xfs/libxfs/xfs_btree.c:1907
 xfs_btree_lookup+0x4e1/0x1410 fs/xfs/libxfs/xfs_btree.c:2018
 xfs_alloc_lookup fs/xfs/libxfs/xfs_alloc.c:166 [inline]
 xfs_alloc_lookup_le fs/xfs/libxfs/xfs_alloc.c:212 [inline]
 xfs_free_ag_extent+0x25d/0x1760 fs/xfs/libxfs/xfs_alloc.c:2080
 __xfs_free_extent+0x2f1/0x470 fs/xfs/libxfs/xfs_alloc.c:4048
 xfs_extent_free_finish_item+0x28b/0x670 fs/xfs/xfs_extfree_item.c:555
 xfs_defer_finish_one+0x5c8/0xcf0 fs/xfs/libxfs/xfs_defer.c:595
 xfs_defer_finish_noroll+0x910/0x12d0 fs/xfs/libxfs/xfs_defer.c:707
 xfs_defer_finish+0x1c/0x180 fs/xfs/libxfs/xfs_defer.c:741
 xfs_bunmapi_range+0xc4/0x140 fs/xfs/libxfs/xfs_bmap.c:6178
 xfs_itruncate_extents_flags+0x306/0x990 fs/xfs/xfs_inode.c:1066
 xfs_itruncate_extents fs/xfs/xfs_inode.h:604 [inline]
 xfs_inactive_truncate+0x125/0x1b0 fs/xfs/xfs_inode.c:1168
 xfs_inactive+0x949/0xcd0 fs/xfs/xfs_inode.c:1454
 xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1944 [inline]
 xfs_inodegc_worker+0x31b/0x7c0 fs/xfs/xfs_icache.c:1990
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 10:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kmem_cache_free+0x18f/0x400 mm/slub.c:4782
 __xfs_buf_ioend+0x29c/0x6f0 fs/xfs/xfs_buf.c:1202
 xfs_buf_iowait+0x167/0x480 fs/xfs/xfs_buf.c:1384
 _xfs_buf_read fs/xfs/xfs_buf.c:646 [inline]
 xfs_buf_read_map+0x335/0xa50 fs/xfs/xfs_buf.c:712
 xfs_trans_read_buf_map+0x1d7/0x8e0 fs/xfs/xfs_trans_buf.c:304
 xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]
 xfs_btree_read_buf_block+0x290/0x470 fs/xfs/libxfs/xfs_btree.c:1402
 xfs_btree_lookup_get_block+0x28d/0x500 fs/xfs/libxfs/xfs_btree.c:1907
 xfs_btree_lookup+0x4e1/0x1410 fs/xfs/libxfs/xfs_btree.c:2018
 xfs_alloc_lookup fs/xfs/libxfs/xfs_alloc.c:166 [inline]
 xfs_alloc_lookup_le fs/xfs/libxfs/xfs_alloc.c:212 [inline]
 xfs_free_ag_extent+0x25d/0x1760 fs/xfs/libxfs/xfs_alloc.c:2080
 __xfs_free_extent+0x2f1/0x470 fs/xfs/libxfs/xfs_alloc.c:4048
 xfs_extent_free_finish_item+0x28b/0x670 fs/xfs/xfs_extfree_item.c:555
 xfs_defer_finish_one+0x5c8/0xcf0 fs/xfs/libxfs/xfs_defer.c:595
 xfs_defer_finish_noroll+0x910/0x12d0 fs/xfs/libxfs/xfs_defer.c:707
 xfs_defer_finish+0x1c/0x180 fs/xfs/libxfs/xfs_defer.c:741
 xfs_bunmapi_range+0xc4/0x140 fs/xfs/libxfs/xfs_bmap.c:6178
 xfs_itruncate_extents_flags+0x306/0x990 fs/xfs/xfs_inode.c:1066
 xfs_itruncate_extents fs/xfs/xfs_inode.h:604 [inline]
 xfs_inactive_truncate+0x125/0x1b0 fs/xfs/xfs_inode.c:1168
 xfs_inactive+0x949/0xcd0 fs/xfs/xfs_inode.c:1454
 xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1944 [inline]
 xfs_inodegc_worker+0x31b/0x7c0 fs/xfs/xfs_icache.c:1990
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88805f82f7e0
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 112 bytes inside of
 freed 272-byte region [ffff88805f82f7e0, ffff88805f82f8f0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5f82f
anon flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801ef9a140 0000000000000000 0000000000000001
raw: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 6113, tgid 6113 (syz.1.18), ts 84620086100, free_ts 84595180484
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 kmem_cache_alloc_noprof+0x283/0x3c0 mm/slub.c:4236
 xfs_buf_item_init+0x66/0x670 fs/xfs/xfs_buf_item.c:878
 xlog_recover_validate_buf_type+0xa2e/0xdb0 fs/xfs/xfs_buf_item_recover.c:452
 xlog_recover_buf_commit_pass2+0xe2b/0x1a10 fs/xfs/xfs_buf_item_recover.c:1098
 xlog_recover_items_pass2+0xe6/0x130 fs/xfs/xfs_log_recover.c:2009
 xlog_recover_commit_trans+0x658/0x8a0 fs/xfs/xfs_log_recover.c:2078
 xlog_recovery_process_trans+0xab/0x1c0 fs/xfs/xfs_log_recover.c:2309
 xlog_recover_process_ophdr+0x2f5/0x380 fs/xfs/xfs_log_recover.c:2455
 xlog_recover_process_data+0x1a5/0x430 fs/xfs/xfs_log_recover.c:2500
 xlog_do_recovery_pass+0x9cd/0xc30 fs/xfs/xfs_log_recover.c:3235
page last free pid 6113 tgid 6113 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 pagetable_free include/linux/mm.h:2917 [inline]
 pagetable_dtor_free include/linux/mm.h:3015 [inline]
 __tlb_remove_table+0x2d2/0x3b0 include/asm-generic/tlb.h:220
 __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:290
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xca8/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702

Memory state around the buggy address:
 ffff88805f82f700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805f82f780: fb fb fb fb fc fc fc fc fc fc fc fc fa fb fb fb
>ffff88805f82f800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff88805f82f880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff88805f82f900: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
