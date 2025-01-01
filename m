Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C125E2C9D
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jan 2025 04:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735704391; cv=none; b=fIvMZnWvu8o2UGcI/CLgdg+ocyU4BFzoD2cdea+uwqZ7lZV9rltv0BLiF8nFfpLUSoBSNrZuITMkTA7GAO8Xq9Za2AH+T8QSny5n8P++7zhTesKPDp0OVG38XL5YWiTMqFAr/V49A55IbfKFezgJRcPHtbZOl4vHnvSkqugnUnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735704391; c=relaxed/simple;
	bh=gaImlAN8IPTfet/FmhEw724vIL0qAsDDZmTdaxhDvjQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BOzgMEBBG7xg9hJ+kAoZZSlv12+sXFvRhZut1uoNujim/Z6tK5cw+zWh1AQ07USzIV6QT4T1xpS1Mw5UZskKQI0cBvsWvbYZxCfnNWeVJ0oUcZgUoKp+7nZYuOFrl4vsietrVpqxkjXJSFK/P7NK3NjLP6Eod1jUJchGKKvefZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a814406be9so212901055ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 20:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735704389; x=1736309189;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qnYCLKExr6eoNbDJbknmVHm1sklDydZSpj0hqUG9rhM=;
        b=rWtcMSkc+bHdlbfqb3Cq3U2eyer6f6Jyf3d2xUNfWrkVxLWtvNybcrO+7awTrAoszM
         M9+898l0B3E7AzUh82G/NzgCfa6t39w9f3/kh+6NAczFW+BykYrMKLkWvAowcZfoO2fl
         MFyr6ydtBP07OmQyHbLo4O1xhaFGzUOQAZ8zRoCgWS3/YdGYh3RbWrI95YisUgBntjSW
         aE8X1owC/55aONGuDSpOHyiFtbFznMsDNQSOoIp3U0yu3OQAewjkCWeEyRCpBipYanS1
         9MAow4EyK6zTCksvgoEhS1K4xZzrHowoWH6fHeOKH6NTks025vL45pk7fPDeQb9wcMty
         Px0A==
X-Forwarded-Encrypted: i=1; AJvYcCU2+mvz2TyZokaC1D9NP1KHysJg4wwi52nDH2n8GYVAzCzKDntp2/lKWbvJQLsEqcQn1EZoYN2pu1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj/E02J3KJ4Gxu+fKHn7ZwRjx93NeQycrBR0gLmD5xLkfmiQhb
	G45t7GTMlutrH7qNk5D6iKtTJozB2lqFuPdxExfsJycZXfW2Nl4qd3HoufPKeiarVAjwpuctQVq
	h1jEriAwmle7LpxmksPRHKu1F9ApA3G15kNmxQ6TzqnRC39cY2h9HN/w=
X-Google-Smtp-Source: AGHT+IGSdYmgVveZKWFilDoAqIf6NmN/a8ItQBa/HJG6dn0q2a3m7gr7LPOauR65EBVtwSYxoWwdtvNWyZU1CKpn3qV+f3KOFoMz
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b24:b0:3ab:1b7a:5932 with SMTP id
 e9e14a558f8ab-3c2d514f756mr333194135ab.18.1735704388927; Tue, 31 Dec 2024
 20:06:28 -0800 (PST)
Date: Tue, 31 Dec 2024 20:06:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6774bf44.050a0220.25abdd.098a.GAE@google.com>
Subject: [syzbot] [mm?] [xfs?] KASAN: slab-use-after-free Read in filemap_map_pages
From: syzbot <syzbot+14d047423f40dc1dac89@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chandan.babu@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8155b4ef3466 Add linux-next specific files for 20241220
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10633018580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c90bb7161a56c88
dashboard link: https://syzkaller.appspot.com/bug?extid=14d047423f40dc1dac89
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a1fadf980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ed90b0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/98a974fc662d/disk-8155b4ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2dea9b72f624/vmlinux-8155b4ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/593a42b9eb34/bzImage-8155b4ef.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/fc321fb08e1d/mount_0.gz

Bisection is inconclusive: the first bad commit could be any of:

568570fdf2b9 Merge tag 'xfs-6.12-fixes-4' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
6aca91c416f6 cifs: Remove unused functions
b04ae0f45168 Merge tag 'v6.12-rc3-smb3-client-fixes' of git://git.samba.org/sfrench/cifs-2.6

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c5a818580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+14d047423f40dc1dac89@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in ptep_get include/linux/pgtable.h:338 [inline]
BUG: KASAN: slab-use-after-free in filemap_map_folio_range mm/filemap.c:3632 [inline]
BUG: KASAN: slab-use-after-free in filemap_map_pages+0xf14/0x1900 mm/filemap.c:3748
Read of size 8 at addr ffff88807c164000 by task syz-executor318/6008

CPU: 0 UID: 0 PID: 6008 Comm: syz-executor318 Not tainted 6.13.0-rc3-next-20241220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 ptep_get include/linux/pgtable.h:338 [inline]
 filemap_map_folio_range mm/filemap.c:3632 [inline]
 filemap_map_pages+0xf14/0x1900 mm/filemap.c:3748
 do_fault_around mm/memory.c:5351 [inline]
 do_read_fault mm/memory.c:5384 [inline]
 do_fault mm/memory.c:5527 [inline]
 do_pte_missing mm/memory.c:4048 [inline]
 handle_pte_fault+0x3888/0x5ee0 mm/memory.c:5890
 __handle_mm_fault mm/memory.c:6033 [inline]
 handle_mm_fault+0x11f5/0x1d50 mm/memory.c:6202
 faultin_page mm/gup.c:1196 [inline]
 __get_user_pages+0x1a92/0x4140 mm/gup.c:1491
 populate_vma_page_range+0x264/0x330 mm/gup.c:1929
 __mm_populate+0x27a/0x460 mm/gup.c:2032
 mm_populate include/linux/mm.h:3400 [inline]
 vm_mmap_pgoff+0x303/0x430 mm/util.c:585
 ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:607
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc532801b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc52a0e208 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fbc533174b8 RCX: 00007fbc532801b9
RDX: 0000000000000002 RSI: 0000000000b36000 RDI: 0000000020000000
RBP: 00007fbc533174b0 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000028011 R11: 0000000000000246 R12: 00007fbc532dcf08
R13: 0030656c69662f2e R14: 00746e6572727563 R15: 632e79726f6d656d
 </TASK>

Allocated by task 5770:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4115 [inline]
 kmem_cache_alloc_bulk_noprof+0x4fa/0x7c0 mm/slub.c:5125
 mt_alloc_bulk lib/maple_tree.c:181 [inline]
 mas_alloc_nodes+0x38e/0x7e0 lib/maple_tree.c:1275
 mas_node_count_gfp lib/maple_tree.c:1335 [inline]
 mas_preallocate+0x575/0x8d0 lib/maple_tree.c:5505
 vma_iter_prealloc mm/vma.h:353 [inline]
 __split_vma+0x302/0xc50 mm/vma.c:480
 split_vma mm/vma.c:543 [inline]
 vma_modify+0x244/0x330 mm/vma.c:1530
 vma_modify_flags+0x3a5/0x430 mm/vma.c:1548
 mprotect_fixup+0x45a/0xaa0 mm/mprotect.c:666
 do_mprotect_pkey+0x99e/0xde0 mm/mprotect.c:840
 __do_sys_mprotect mm/mprotect.c:861 [inline]
 __se_sys_mprotect mm/mprotect.c:858 [inline]
 __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:858
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5770:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2353 [inline]
 slab_free mm/slub.c:4609 [inline]
 kmem_cache_free+0x195/0x410 mm/slub.c:4711
 mt_free_one lib/maple_tree.c:186 [inline]
 mas_destroy+0x1955/0x1fe0 lib/maple_tree.c:5562
 mas_store_prealloc+0xd23/0x1390 lib/maple_tree.c:5481
 vma_complete+0x21d/0xb50 mm/vma.c:309
 __split_vma+0xaa6/0xc50 mm/vma.c:513
 split_vma mm/vma.c:543 [inline]
 vma_modify+0x244/0x330 mm/vma.c:1530
 vma_modify_flags+0x3a5/0x430 mm/vma.c:1548
 mprotect_fixup+0x45a/0xaa0 mm/mprotect.c:666
 do_mprotect_pkey+0x99e/0xde0 mm/mprotect.c:840
 __do_sys_mprotect mm/mprotect.c:861 [inline]
 __se_sys_mprotect mm/mprotect.c:858 [inline]
 __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:858
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88807c164000
 which belongs to the cache maple_node of size 256
The buggy address is located 0 bytes inside of
 freed 256-byte region [ffff88807c164000, ffff88807c164100)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7c164
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac91000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac91000 dead000000000122 0000000000000000
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000001 ffffea0001f05901 ffffffffffffffff 0000000000000000
head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5770, tgid 5770 (sed), ts 64767761345, free_ts 64734581038
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4754
 alloc_pages_mpol+0x30e/0x550 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:2423 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2587
 new_slab mm/slub.c:2640 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3826
 __kmem_cache_alloc_bulk mm/slub.c:5045 [inline]
 kmem_cache_alloc_bulk_noprof+0x21e/0x7c0 mm/slub.c:5117
 mt_alloc_bulk lib/maple_tree.c:181 [inline]
 mas_alloc_nodes+0x38e/0x7e0 lib/maple_tree.c:1275
 mas_node_count_gfp lib/maple_tree.c:1335 [inline]
 mas_preallocate+0x575/0x8d0 lib/maple_tree.c:5505
 vma_iter_prealloc mm/vma.h:353 [inline]
 __split_vma+0x302/0xc50 mm/vma.c:480
 split_vma mm/vma.c:543 [inline]
 vma_modify+0x244/0x330 mm/vma.c:1530
 vma_modify_flags+0x3a5/0x430 mm/vma.c:1548
 mprotect_fixup+0x45a/0xaa0 mm/mprotect.c:666
 do_mprotect_pkey+0x99e/0xde0 mm/mprotect.c:840
 __do_sys_mprotect mm/mprotect.c:861 [inline]
 __se_sys_mprotect mm/mprotect.c:858 [inline]
 __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:858
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
page last free pid 0 tgid 0 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_frozen_pages+0xe0d/0x10e0 mm/page_alloc.c:2660
 __folio_put+0x2b3/0x360 mm/swap.c:112
 __tlb_remove_table arch/x86/include/asm/tlb.h:34 [inline]
 __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
 tlb_remove_table_rcu+0x76/0xf0 mm/mmu_gather.c:282
 rcu_do_batch kernel/rcu/tree.c:2546 [inline]
 rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2802
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702

Memory state around the buggy address:
 ffff88807c163f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88807c163f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88807c164000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88807c164080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807c164100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
