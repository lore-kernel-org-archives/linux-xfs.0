Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BD1219E91
	for <linux-xfs@vger.kernel.org>; Mon,  9 Dec 2024 11:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733743409; cv=none; b=NDkTUa0+/WPunZaRUBVKsNpaqYPZeK3IbnnOLGQd7qMFTTZY0fWjyh9uynMsaLm8WBh8SD46PzdFQ8DEES3smnyv5bdnbs+JPNH794OQYNxS9fzvmkTe1OEf+sBWibIPuJkHAUlm+v5lIVxUHGIQ8gW0aQa5gA1GhLoVmTvcGOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733743409; c=relaxed/simple;
	bh=G1oMQIuUcy1aQyFeSgfVedIvY8oXeEFkNldf6KQee4c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CWEbzFqXRq+n0qVdvRlV01Lec1s6t24mkrFKxFBC7Nfcv/BhY6m1djgTUIljyQvFved1Prs55xOmtBAwKsX1Eb5SRK9ZU3a3jY2YtHOAr4b5HUTXjlhqW6LFGHoY6pHGCIb9JNj1kSyV9bG+lb/9FFQE+BHob4g8vwIDjuU7pl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a815ab079cso62281265ab.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Dec 2024 03:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733743406; x=1734348206;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=76j1GvUOire3gGHM4gaEqfWoT6ggd3LcvClgvNUY9Qc=;
        b=Y6SDKZTtsh1yIeXkVmgdJcBatYn7fwNipnoFtzLMiXjclxF1WtH0Exl28lX1uxeABP
         YWCOv8bsRFK3dV+NYmtkgTgqPxgq2FAEXn0rYxAcD7FtP2wrX7FpQ3u2iuTbawEOgwuF
         lTK4w3Hail1C78vd0Qpurkp6ss8QOIF78vYVj9F5EKPf7P0jseFhrMpA6EnZlkknLHrU
         0YTmWj+qUerSL2EvZAHiXswgACAp/tEY/5nhjqRGn225pKCmlb7kG9q09hKBw4ChiuYg
         iARWKve2fBvOFNKAtWlmMcLFnmJXEM7yBQJIpFPieTTFRAU0WrZs7+RX2XKqSKYFYdFV
         lJ1A==
X-Forwarded-Encrypted: i=1; AJvYcCXyujxR6ZWlRQZbS9Yv1fGQBlvvwpuNFLqyTbvMZZMJivQMB5aRQH8gQMyDTzDnmLUKyVHQqDqTOxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTXJJNVsQJ2oJ4+UeweB+w3yLQeZDjY8KbmMXCqEXml97eG1vs
	OGQBpoEu93nGhEM2IzUsgBFoqpIeYqiq73cxqffp6I9v0yY/9EdZ5+Vz32tlPIMOOsBOLzi3fWO
	rKAlwj+4GO+3y59J09WzNEbw9LUDIUU4jt2kfMqAkkFj6bhryzJJXSWo=
X-Google-Smtp-Source: AGHT+IE3Exvnlmm6bUuGWQ1Rli5LjP+PMqx7WMWLLyC+PIsyepSKY6FHI++ol1VQuUN257ePl4ArnsdH12Nqf/doYweFzIFxGd/C
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ca:b0:3a7:a3a4:2cb3 with SMTP id
 e9e14a558f8ab-3a9dbb26947mr746125ab.15.1733743406576; Mon, 09 Dec 2024
 03:23:26 -0800 (PST)
Date: Mon, 09 Dec 2024 03:23:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6756d32e.050a0220.a30f1.019c.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (2)
From: syzbot <syzbot+643ffa707a94e3d66378@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7af08b57bcb9 Merge tag 'trace-v6.13-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17cecd30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=129a9798def93175
dashboard link: https://syzkaller.appspot.com/bug?extid=643ffa707a94e3d66378
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f6e67f04bc76/disk-7af08b57.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/31932bddea1f/vmlinux-7af08b57.xz
kernel image: https://storage.googleapis.com/syzbot-assets/62707034e0dd/bzImage-7af08b57.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+643ffa707a94e3d66378@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in rht_key_hashfn include/linux/rhashtable.h:159 [inline]
BUG: KASAN: slab-use-after-free in rht_head_hashfn include/linux/rhashtable.h:174 [inline]
BUG: KASAN: slab-use-after-free in __rhashtable_remove_fast_one include/linux/rhashtable.h:1007 [inline]
BUG: KASAN: slab-use-after-free in __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
BUG: KASAN: slab-use-after-free in rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
BUG: KASAN: slab-use-after-free in xfs_buf_rele_cached fs/xfs/xfs_buf.c:1125 [inline]
BUG: KASAN: slab-use-after-free in xfs_buf_rele+0xd26/0x15b0 fs/xfs/xfs_buf.c:1151
Read of size 4 at addr ffff888033dd6c08 by task syz.7.96/6977

CPU: 1 UID: 0 PID: 6977 Comm: syz.7.96 Not tainted 6.12.0-syzkaller-10689-g7af08b57bcb9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 rht_key_hashfn include/linux/rhashtable.h:159 [inline]
 rht_head_hashfn include/linux/rhashtable.h:174 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1007 [inline]
 __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
 rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
 xfs_buf_rele_cached fs/xfs/xfs_buf.c:1125 [inline]
 xfs_buf_rele+0xd26/0x15b0 fs/xfs/xfs_buf.c:1151
 xfs_buftarg_shrink_scan+0x264/0x300 fs/xfs/xfs_buf.c:2001
 do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:414 [inline]
 drop_slab+0x142/0x280 mm/vmscan.c:432
 drop_caches_sysctl_handler+0xbc/0x160 fs/drop_caches.c:68
 proc_sys_call_handler+0x5ec/0x920 fs/proc/proc_sysctl.c:601
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1050
 do_writev+0x1b6/0x360 fs/read_write.c:1096
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd7c0780809
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd7be5f6058 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007fd7c0945fa0 RCX: 00007fd7c0780809
RDX: 0000000000000001 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00007fd7c07f393e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fd7c0945fa0 R15: 00007fffcac00d18
 </TASK>

Allocated by task 6968:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4283 [inline]
 __kmalloc_node_noprof+0x290/0x4d0 mm/slub.c:4289
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:650
 bucket_table_alloc lib/rhashtable.c:186 [inline]
 rhashtable_init_noprof+0x534/0xa60 lib/rhashtable.c:1071
 xfs_perag_alloc fs/xfs/libxfs/xfs_ag.c:238 [inline]
 xfs_initialize_perag+0x26a/0x630 fs/xfs/libxfs/xfs_ag.c:279
 xfs_mountfs+0xaaf/0x2410 fs/xfs/xfs_mount.c:831
 xfs_fs_fill_super+0x12db/0x1590 fs/xfs/xfs_super.c:1791
 get_tree_bdev_flags+0x48c/0x5c0 fs/super.c:1636
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5852:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:582
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2338 [inline]
 slab_free mm/slub.c:4598 [inline]
 kfree+0x196/0x430 mm/slub.c:4746
 rhashtable_free_and_destroy+0x7c6/0x920 lib/rhashtable.c:1169
 xfs_group_free+0xd4/0x230 fs/xfs/libxfs/xfs_group.c:170
 xfs_free_perag_range+0x36/0x60 fs/xfs/libxfs/xfs_ag.c:133
 xfs_unmountfs+0x24d/0x2e0 fs/xfs/xfs_mount.c:1185
 xfs_fs_put_super+0x65/0x150 fs/xfs/xfs_super.c:1149
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 xfs_kill_sb+0x15/0x50 fs/xfs/xfs_super.c:2089
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888033dd6c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 8 bytes inside of
 freed 512-byte region [ffff888033dd6c00, ffff888033dd6e00)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x33dd4
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac41c80 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac41c80 dead000000000100 dead000000000122
head: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 00fff00000000002 ffffea0000cf7501 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5216, tgid 5216 (udevadm), ts 27719249718, free_ts 27704552099
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3651/0x37a0 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x140 mm/slub.c:2408
 allocate_slab+0x5a/0x2f0 mm/slub.c:2574
 new_slab mm/slub.c:2627 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3815
 __slab_alloc+0x58/0xa0 mm/slub.c:3905
 __slab_alloc_node mm/slub.c:3980 [inline]
 slab_alloc_node mm/slub.c:4141 [inline]
 __kmalloc_cache_noprof+0x27b/0x390 mm/slub.c:4309
 kmalloc_noprof include/linux/slab.h:901 [inline]
 kzalloc_noprof include/linux/slab.h:1037 [inline]
 kernfs_fop_open+0x3e0/0xd10 fs/kernfs/file.c:623
 do_dentry_open+0xbe1/0x1b70 fs/open.c:945
 vfs_open+0x3e/0x330 fs/open.c:1075
 do_open fs/namei.c:3828 [inline]
 path_openat+0x2c84/0x3590 fs/namei.c:3987
 do_filp_open+0x27f/0x4e0 fs/namei.c:4014
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_openat fs/open.c:1433 [inline]
 __se_sys_openat fs/open.c:1428 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
page last free pid 5227 tgid 5227 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xde3/0x1130 mm/page_alloc.c:2657
 discard_slab mm/slub.c:2673 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3142
 put_cpu_partial+0x17c/0x250 mm/slub.c:3217
 __slab_free+0x2ea/0x3d0 mm/slub.c:4468
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4104 [inline]
 slab_alloc_node mm/slub.c:4153 [inline]
 kmem_cache_alloc_noprof+0x1d9/0x380 mm/slub.c:4160
 alloc_empty_file+0x9e/0x1d0 fs/file_table.c:228
 path_openat+0x107/0x3590 fs/namei.c:3973
 do_filp_open+0x27f/0x4e0 fs/namei.c:4014
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_openat fs/open.c:1433 [inline]
 __se_sys_openat fs/open.c:1428 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1428
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888033dd6b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888033dd6b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888033dd6c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888033dd6c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888033dd6d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
