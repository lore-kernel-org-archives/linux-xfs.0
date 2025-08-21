Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5A72DAFD6
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 12:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755778840; cv=none; b=gDe/EwUwQmy32zNWf2GtqHem6VWwsc4kf+NIW59EJE9xA9T/Xm10yihGcj/7fdaqtSiDiHXUBOURT7PLyvdmZnU5YrXKDB2lvM42JQfbxf8vpf1nrxPVk8GuIeJfvvjUrJmoRiWwuhZk5dFn+21lqAAys2Q3fGygx5eyk6Vun0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755778840; c=relaxed/simple;
	bh=N/LNT8SD2/LxOdTNtjI49PNC6vfAqW2w0prPokM1bQo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LH5o1odQRl0mRsc0h7jY+J2fi6JcWu2PhMip4puvvgan7/3QZrBP1Gx2nQBASiLtJ7XHgJQqFNHQsCqAx79r9mqdoy/glMgPFdzcLpZilirKU2PYXMrvtonHRZs2uNgGuL5k8yb2W1ykIaJms7ybhtBOPp1gndtdGjhhLSzo/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3e67df0ee00so23594115ab.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 05:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755778837; x=1756383637;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h7aTL0dL5KDokJT29SVXlOZ5mgUE/HaWzjTz75JEw2Q=;
        b=r+Dr0l6oM1e3VdC4719BPgu7VM2cjRqN7BVXMbyGztYSCX4ZLgnnITwOX7ZUJ5ttOM
         0u8r9+ATxQta+th72CFy29juHAOLD8xTRz+7psWbu/E5VAbFUXEL2AKF4+70LbItCXPC
         gdaYOw+sf3YIJcgLnO9S915A0bCnRDJBIEdRozNm01AsV8Qz8FmBUOMKbXyB7/QGoHdQ
         d8Q588YI7evUrho/k2XWfpXYQR+KCYCuwyuW9BYqlo3hS4uVbIaIUZpphhGJza11eKVj
         KZ+nq+7PmoI2nmN/CpfBgKPyycn1OjBfiSA1OQy3uZq5AYha1qzVw54/6jtViYSkPivp
         amAw==
X-Forwarded-Encrypted: i=1; AJvYcCWLvUlkuzbLWHqetQ6Voj4qDYNDAqKXiCxPHR7fE0WCf7/FsUZf30cKxtTDdGM0m05dT+L2BYYE7Ho=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsTPxa2zNlVHnH9hgcDW6k4/k1YAT/96rVt6Snpsg/hOk6wkTd
	XM9aovtC2bW2AOZqjfBGmLzIsbI2+Qsyxv/tJYkx85SaG8pn8YHJSjssfzsqTj8zSBAq/D81o/Z
	r4OnpJF5KUk0A26ayKIvPDPIp2BXTHpV4prdRxktboULmBmCyE6iw33kjdcw=
X-Google-Smtp-Source: AGHT+IH/i9LR6+HiX88YgdC2d+z817LYOZiBnhf+FqpfK+K8gjvpK9P76m7SNc1VLCpuYHPPZFwR685GOZawn73UwjkTkU8IMpCF
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180c:b0:3e3:d1ef:83f9 with SMTP id
 e9e14a558f8ab-3e6d4060653mr43313855ab.6.1755778837259; Thu, 21 Aug 2025
 05:20:37 -0700 (PDT)
Date: Thu, 21 Aug 2025 05:20:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a70f15.050a0220.3d78fd.0024.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Write in xlog_cil_committed
From: syzbot <syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com>
To: cem@kernel.org, cmaiolino@redhat.com, dchinner@redhat.com, 
	djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    931e46dcbc7e Add linux-next specific files for 20250814
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14621234580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a286bd75352e92fa
dashboard link: https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1128faf0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12621234580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fb896162d550/disk-931e46dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/45f6f857b82c/vmlinux-931e46dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0f16e70143e1/bzImage-931e46dc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d03c38510d66/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=15e82442580000)

The issue was bisected to:

commit d2fe5c4c8d25999862d615f616aea7befdd62799
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 22:48:58 2025 +0000

    xfs: rearrange code in xfs_buf_item.c

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14bca6f0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16bca6f0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12bca6f0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")

BUG: KASAN: slab-use-after-free in instrument_atomic_write include/linux/instrumented.h:82 [inline]
BUG: KASAN: slab-use-after-free in set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:791 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_committed+0x45e/0x1040 fs/xfs/xfs_log_cil.c:897
Write of size 8 at addr ffff8880750cbc10 by task kworker/1:0H/25

CPU: 1 UID: 0 PID: 25 Comm: kworker/1:0H Not tainted 6.17.0-rc1-next-20250814-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: xfs-log/loop0 xlog_ioend_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_write include/linux/instrumented.h:82 [inline]
 set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
 xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:791 [inline]
 xlog_cil_committed+0x45e/0x1040 fs/xfs/xfs_log_cil.c:897
 xlog_cil_process_committed+0x15c/0x1b0 fs/xfs/xfs_log_cil.c:927
 xlog_state_shutdown_callbacks+0x269/0x360 fs/xfs/xfs_log.c:488
 xlog_force_shutdown+0x332/0x400 fs/xfs/xfs_log.c:3520
 xlog_ioend_work+0xaf/0x100 fs/xfs/xfs_log.c:1245
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5867:
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
 xfs_alloc_lookup_eq fs/xfs/libxfs/xfs_alloc.c:184 [inline]
 xfs_alloc_fixup_trees+0x21b/0xd20 fs/xfs/libxfs/xfs_alloc.c:626
 xfs_alloc_cur_finish+0xd3/0x4b0 fs/xfs/libxfs/xfs_alloc.c:1117
 xfs_alloc_ag_vextent_near+0xd1a/0x1230 fs/xfs/libxfs/xfs_alloc.c:1776
 xfs_alloc_vextent_iterate_ags+0x640/0x940 fs/xfs/libxfs/xfs_alloc.c:3764
 xfs_alloc_vextent_start_ag+0x388/0x850 fs/xfs/libxfs/xfs_alloc.c:3839
 xfs_bmap_btalloc_best_length fs/xfs/libxfs/xfs_bmap.c:3627 [inline]
 xfs_bmap_btalloc fs/xfs/libxfs/xfs_bmap.c:3672 [inline]
 xfs_bmapi_allocate+0x188e/0x2e00 fs/xfs/libxfs/xfs_bmap.c:3947
 xfs_bmapi_write+0x7df/0x1260 fs/xfs/libxfs/xfs_bmap.c:4276
 xfs_da_grow_inode_int+0x298/0x860 fs/xfs/libxfs/xfs_da_btree.c:2315
 xfs_da_grow_inode+0x16d/0x390 fs/xfs/libxfs/xfs_da_btree.c:2380
 xfs_attr_shortform_to_leaf+0x273/0x860 fs/xfs/libxfs/xfs_attr_leaf.c:965
 xfs_attr_sf_addname fs/xfs/libxfs/xfs_attr.c:402 [inline]
 xfs_attr_set_iter+0xd30/0x4b70 fs/xfs/libxfs/xfs_attr.c:824
 xfs_attr_finish_item+0xed/0x320 fs/xfs/xfs_attr_item.c:506
 xfs_defer_finish_one+0x5c8/0xcf0 fs/xfs/libxfs/xfs_defer.c:595
 xfs_defer_finish_noroll+0x910/0x12d0 fs/xfs/libxfs/xfs_defer.c:707
 xfs_trans_commit+0x10b/0x1c0 fs/xfs/xfs_trans.c:920
 xfs_attr_set+0xdc6/0x1210 fs/xfs/libxfs/xfs_attr.c:1150
 xfs_xattr_set+0x14d/0x250 fs/xfs/xfs_xattr.c:186
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_setxattr fs/xattr.c:747 [inline]
 __se_sys_setxattr fs/xattr.c:743 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5876:
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
 xfs_alloc_lookup_eq fs/xfs/libxfs/xfs_alloc.c:184 [inline]
 xfs_alloc_fixup_trees+0x21b/0xd20 fs/xfs/libxfs/xfs_alloc.c:626
 xfs_alloc_cur_finish+0xd3/0x4b0 fs/xfs/libxfs/xfs_alloc.c:1117
 xfs_alloc_ag_vextent_near+0xd1a/0x1230 fs/xfs/libxfs/xfs_alloc.c:1776
 xfs_alloc_vextent_iterate_ags+0x640/0x940 fs/xfs/libxfs/xfs_alloc.c:3764
 xfs_alloc_vextent_start_ag+0x388/0x850 fs/xfs/libxfs/xfs_alloc.c:3839
 xfs_bmap_btalloc_best_length fs/xfs/libxfs/xfs_bmap.c:3627 [inline]
 xfs_bmap_btalloc fs/xfs/libxfs/xfs_bmap.c:3672 [inline]
 xfs_bmapi_allocate+0x188e/0x2e00 fs/xfs/libxfs/xfs_bmap.c:3947
 xfs_bmapi_write+0x7df/0x1260 fs/xfs/libxfs/xfs_bmap.c:4276
 xfs_da_grow_inode_int+0x298/0x860 fs/xfs/libxfs/xfs_da_btree.c:2315
 xfs_da_grow_inode+0x16d/0x390 fs/xfs/libxfs/xfs_da_btree.c:2380
 xfs_attr_shortform_to_leaf+0x273/0x860 fs/xfs/libxfs/xfs_attr_leaf.c:965
 xfs_attr_sf_addname fs/xfs/libxfs/xfs_attr.c:402 [inline]
 xfs_attr_set_iter+0xd30/0x4b70 fs/xfs/libxfs/xfs_attr.c:824
 xfs_attr_finish_item+0xed/0x320 fs/xfs/xfs_attr_item.c:506
 xfs_defer_finish_one+0x5c8/0xcf0 fs/xfs/libxfs/xfs_defer.c:595
 xfs_defer_finish_noroll+0x910/0x12d0 fs/xfs/libxfs/xfs_defer.c:707
 xfs_trans_commit+0x10b/0x1c0 fs/xfs/xfs_trans.c:920
 xfs_attr_set+0xdc6/0x1210 fs/xfs/libxfs/xfs_attr.c:1150
 xfs_xattr_set+0x14d/0x250 fs/xfs/xfs_xattr.c:186
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_setxattr fs/xattr.c:747 [inline]
 __se_sys_setxattr fs/xattr.c:743 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880750cbbd0
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 64 bytes inside of
 freed 272-byte region [ffff8880750cbbd0, ffff8880750cbce0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x750cb
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff888146690280 dead000000000122 0000000000000000
raw: 0000000000000000 00000000000c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5867, tgid 5867 (syz-executor779), ts 70134831759, free_ts 22799021473
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
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 __free_pages mm/page_alloc.c:5260 [inline]
 free_contig_range+0x1bd/0x4a0 mm/page_alloc.c:7091
 destroy_args+0x69/0x660 mm/debug_vm_pgtable.c:958
 debug_vm_pgtable+0x39f/0x3b0 mm/debug_vm_pgtable.c:1345
 do_one_initcall+0x233/0x820 init/main.c:1281
 do_initcall_level+0x104/0x190 init/main.c:1343
 do_initcalls+0x59/0xa0 init/main.c:1359
 kernel_init_freeable+0x334/0x4b0 init/main.c:1591
 kernel_init+0x1d/0x1d0 init/main.c:1481
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff8880750cbb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880750cbb80: fb fb fc fc fc fc fc fc fc fc fa fb fb fb fb fb
>ffff8880750cbc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880750cbc80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880750cbd00: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
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
