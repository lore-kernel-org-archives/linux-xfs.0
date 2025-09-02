Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE102F8BF4
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 11:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756813238; cv=none; b=JctWXY3t+NHZhck1nmd4kqyTttm7BZ2gO3JYC1cLrVa693tcWdijJZkVkoyC59vmVOvMnIpUIcbGT5iyA6fTPBZyfCE+4VmysuNOowCz1iJo2grlOghJQ9ouOerDiYJyBGK6iHIajUzUEVEzx2OfNieN9ZVVP6s80bWX+Iv9itI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756813238; c=relaxed/simple;
	bh=jwOShjKWQpY9xylp7XBdKLuc9Nxt7iic03iHbNdCAEU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sUdew/lfIM6pxTIw5+HxroskDJjJ17jUcCpwuwuy1GRYkzxhj59oob2JrBE68JxFz/R0UJxACsA1yrsXA+rhtF1KRDJp/6ORuwRl+DdpJRPCEBt1XfUkJkEX0ALggnnibHGSfGt6oK4CgKJ/cQZbvPWzi0cGKa2G6QnUCQvV6lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3eefbb2da62so135509265ab.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Sep 2025 04:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756813235; x=1757418035;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VvM3dqHw/KI0wK5RCnGG1ydreQygwpfTOzr25km0eSI=;
        b=gCOY8/mZb9gQlObK4lYBTHIAHXWkzzvu4J9CRwoofT/D+2OP+Kfyy3C7aSLta8scXf
         ZhSEj6F+sXUfFLKTOCfTYLb0QjQvCCro5cOyP3BH3rwQrCzT0NpxxuCcUGZGnGnj/okb
         Nf4qoUcDTyw2i8AV2MxOhUTp8WPoUoONQmc5yuqeNqskGh3frRBVUTi0MXfRHtR1Y59H
         Z5UsbybP3F20KBybnzLJVyQuAbas4oVK7fOioIPjwu158+koyUdWdb71VFVX5a2YGT+S
         Vv/TK+turU7Ef4Oa8hJtm+MD4rohy6MalfGLlmS6ZPKpLWlUy0cx6dcqRBdQoCEbAOC1
         qzpA==
X-Forwarded-Encrypted: i=1; AJvYcCXXzmOyzcwHeND8iN8CQvkUupnW7fyXOvtCoL4xaBMnA7+ohEo946FErs8IDCYwp3thwIMvs5jTNcI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8OaGRH+ahMNvXaEs1VXMSNb9BuPes0w06UrtxK4ctTLfJ/BX6
	n9K6HcX719jCe27Qi3eU+K9oApwAvsRm23Y557LSvy+rphWAySfm5FPMj8nss+W+WV1iSJ27Ngc
	EFLur/QZUm8toEpksSaknQJZbEngbedXOxj5dv39zU8Q/mAu5wCBqCDMXQgI=
X-Google-Smtp-Source: AGHT+IHkCEVXcHHvR8vLbeKl00EzSrQAXdodf2jG8t5Vepn2mbZ7N1XgvWFS7ZsknlKjKd+2FOudjGuYXvgJk/cT3xSWv7vlshbS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214e:b0:3ee:7fb3:5ffa with SMTP id
 e9e14a558f8ab-3f4026c322fmr208019555ab.25.1756813235568; Tue, 02 Sep 2025
 04:40:35 -0700 (PDT)
Date: Tue, 02 Sep 2025 04:40:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b6d7b3.050a0220.3db4df.01cf.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
From: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=144aca42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17161662580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124aca42580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b51a434c3e2c/mount_1.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=104aca42580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in rht_key_hashfn include/linux/rhashtable.h:159 [inline]
BUG: KASAN: slab-use-after-free in rht_head_hashfn include/linux/rhashtable.h:174 [inline]
BUG: KASAN: slab-use-after-free in __rhashtable_remove_fast_one include/linux/rhashtable.h:1007 [inline]
BUG: KASAN: slab-use-after-free in __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
BUG: KASAN: slab-use-after-free in rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
BUG: KASAN: slab-use-after-free in xfs_buf_rele_cached fs/xfs/xfs_buf.c:926 [inline]
BUG: KASAN: slab-use-after-free in xfs_buf_rele+0x79c/0xcfc fs/xfs/xfs_buf.c:951
Read of size 4 at addr ffff0000ce9fe008 by task syz.2.1678/16850

CPU: 0 UID: 0 PID: 16850 Comm: syz.2.1678 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xa8/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0xb0/0x110 mm/kasan/report.c:595
 __asan_report_load4_noabort+0x20/0x2c mm/kasan/report_generic.c:380
 rht_key_hashfn include/linux/rhashtable.h:159 [inline]
 rht_head_hashfn include/linux/rhashtable.h:174 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1007 [inline]
 __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
 rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
 xfs_buf_rele_cached fs/xfs/xfs_buf.c:926 [inline]
 xfs_buf_rele+0x79c/0xcfc fs/xfs/xfs_buf.c:951
 xfs_buftarg_shrink_scan+0x1d8/0x270 fs/xfs/xfs_buf.c:1653
 do_shrink_slab+0x650/0x11b0 mm/shrinker.c:437
 shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:441 [inline]
 drop_slab+0x120/0x248 mm/vmscan.c:459
 drop_caches_sysctl_handler+0x170/0x300 fs/drop_caches.c:68
 proc_sys_call_handler+0x460/0x7e8 fs/proc/proc_sysctl.c:600
 proc_sys_write+0x2c/0x3c fs/proc/proc_sysctl.c:626
 do_iter_readv_writev+0x4c0/0x724 fs/read_write.c:-1
 vfs_writev+0x29c/0x7cc fs/read_write.c:1057
 do_writev+0x128/0x290 fs/read_write.c:1103
 __do_sys_writev fs/read_write.c:1171 [inline]
 __se_sys_writev fs/read_write.c:1168 [inline]
 __arm64_sys_writev+0x80/0x94 fs/read_write.c:1168
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Allocated by task 16829:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x44/0x54 mm/kasan/generic.c:562
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x9c/0xb4 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4365 [inline]
 __kvmalloc_node_noprof+0x38c/0x638 mm/slub.c:5052
 bucket_table_alloc lib/rhashtable.c:186 [inline]
 rhashtable_init_noprof+0x3b4/0xa10 lib/rhashtable.c:1075
 xfs_buf_cache_init+0x28/0x38 fs/xfs/xfs_buf.c:375
 xfs_perag_alloc fs/xfs/libxfs/xfs_ag.c:238 [inline]
 xfs_initialize_perag+0x208/0x5ac fs/xfs/libxfs/xfs_ag.c:279
 xfs_mountfs+0x81c/0x1c04 fs/xfs/xfs_mount.c:976
 xfs_fs_fill_super+0xe74/0x11f0 fs/xfs/xfs_super.c:1965
 get_tree_bdev_flags+0x360/0x414 fs/super.c:1692
 get_tree_bdev+0x2c/0x3c fs/super.c:1715
 xfs_fs_get_tree+0x28/0x38 fs/xfs/xfs_super.c:2012
 vfs_get_tree+0x90/0x28c fs/super.c:1815
 do_new_mount+0x278/0x7f4 fs/namespace.c:3805
 path_mount+0x5b4/0xde0 fs/namespace.c:4120
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount fs/namespace.c:4321 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Freed by task 6692:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_free_info+0x58/0x70 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x74/0x98 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kfree+0x17c/0x474 mm/slub.c:4879
 kvfree+0x30/0x40 mm/slub.c:5095
 bucket_table_free+0xec/0x1a4 lib/rhashtable.c:114
 rhashtable_free_and_destroy+0x70c/0x87c lib/rhashtable.c:1173
 rhashtable_destroy+0x28/0x38 lib/rhashtable.c:1184
 xfs_buf_cache_destroy+0x20/0x30 fs/xfs/xfs_buf.c:382
 xfs_perag_uninit+0x28/0x38 fs/xfs/libxfs/xfs_ag.c:116
 xfs_group_free+0x144/0x32c fs/xfs/libxfs/xfs_group.c:171
 xfs_free_perag_range+0x58/0x8c fs/xfs/libxfs/xfs_ag.c:133
 xfs_unmountfs+0x29c/0x310 fs/xfs/xfs_mount.c:1354
 xfs_fs_put_super+0x6c/0x144 fs/xfs/xfs_super.c:1247
 generic_shutdown_super+0x12c/0x2b8 fs/super.c:643
 kill_block_super+0x44/0x90 fs/super.c:1766
 xfs_kill_sb+0x20/0x58 fs/xfs/xfs_super.c:2317
 deactivate_locked_super+0xc4/0x12c fs/super.c:474
 deactivate_super+0xe0/0x100 fs/super.c:507
 cleanup_mnt+0x31c/0x3ac fs/namespace.c:1378
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1385
 task_work_run+0x1dc/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x174/0x1f4 arch/arm64/kernel/entry-common.c:155
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:173 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:182 [inline]
 el0_svc+0xb8/0x180 arch/arm64/kernel/entry-common.c:880
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

The buggy address belongs to the object at ffff0000ce9fe000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 8 bytes inside of
 freed 512-byte region [ffff0000ce9fe000, ffff0000ce9fe200)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10e9fc
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0x5ffc00000000040(head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 05ffc00000000040 ffff0000c0001c80 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 05ffc00000000040 ffff0000c0001c80 0000000000000000 dead000000000001
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 05ffc00000000002 fffffdffc33a7f01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000ce9fdf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff0000ce9fdf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff0000ce9fe000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff0000ce9fe080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff0000ce9fe100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/rhashtable.c:1192:34
shift exponent 4294901760 is too large for 32-bit type 'int'
CPU: 0 UID: 0 PID: 16850 Comm: syz.2.1678 Tainted: G    B               6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 ubsan_epilogue+0x14/0x48 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x2b0/0x34c lib/ubsan.c:494
 __rht_bucket_nested+0x460/0x594 lib/rhashtable.c:1192
 rht_bucket_var include/linux/rhashtable.h:296 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1008 [inline]
 __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
 rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
 xfs_buf_rele_cached fs/xfs/xfs_buf.c:926 [inline]
 xfs_buf_rele+0x690/0xcfc fs/xfs/xfs_buf.c:951
 xfs_buftarg_shrink_scan+0x1d8/0x270 fs/xfs/xfs_buf.c:1653
 do_shrink_slab+0x650/0x11b0 mm/shrinker.c:437
 shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:441 [inline]
 drop_slab+0x120/0x248 mm/vmscan.c:459
 drop_caches_sysctl_handler+0x170/0x300 fs/drop_caches.c:68
 proc_sys_call_handler+0x460/0x7e8 fs/proc/proc_sysctl.c:600
 proc_sys_write+0x2c/0x3c fs/proc/proc_sysctl.c:626
 do_iter_readv_writev+0x4c0/0x724 fs/read_write.c:-1
 vfs_writev+0x29c/0x7cc fs/read_write.c:1057
 do_writev+0x128/0x290 fs/read_write.c:1103
 __do_sys_writev fs/read_write.c:1171 [inline]
 __se_sys_writev fs/read_write.c:1168 [inline]
 __arm64_sys_writev+0x80/0x94 fs/read_write.c:1168
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
---[ end trace ]---
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/rhashtable.c:1193:32
shift exponent 4294901760 is too large for 32-bit type 'unsigned int'
CPU: 0 UID: 0 PID: 16850 Comm: syz.2.1678 Tainted: G    B               6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 ubsan_epilogue+0x14/0x48 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x2b0/0x34c lib/ubsan.c:494
 __rht_bucket_nested+0x4a8/0x594 lib/rhashtable.c:1193
 rht_bucket_var include/linux/rhashtable.h:296 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1008 [inline]
 __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
 rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
 xfs_buf_rele_cached fs/xfs/xfs_buf.c:926 [inline]
 xfs_buf_rele+0x690/0xcfc fs/xfs/xfs_buf.c:951
 xfs_buftarg_shrink_scan+0x1d8/0x270 fs/xfs/xfs_buf.c:1653
 do_shrink_slab+0x650/0x11b0 mm/shrinker.c:437
 shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:441 [inline]
 drop_slab+0x120/0x248 mm/vmscan.c:459
 drop_caches_sysctl_handler+0x170/0x300 fs/drop_caches.c:68
 proc_sys_call_handler+0x460/0x7e8 fs/proc/proc_sysctl.c:600
 proc_sys_write+0x2c/0x3c fs/proc/proc_sysctl.c:626
 do_iter_readv_writev+0x4c0/0x724 fs/read_write.c:-1
 vfs_writev+0x29c/0x7cc fs/read_write.c:1057
 do_writev+0x128/0x290 fs/read_write.c:1103
 __do_sys_writev fs/read_write.c:1171 [inline]
 __se_sys_writev fs/read_write.c:1168 [inline]
 __arm64_sys_writev+0x80/0x94 fs/read_write.c:1168
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
---[ end trace ]---
Unable to handle kernel paging request at virtual address dfff800000000000
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[dfff800000000000] address between user and kernel address ranges
Internal error: Oops: 0000000096000005 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 16850 Comm: syz.2.1678 Tainted: G    B               6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : __rht_bucket_nested+0xbc/0x594 lib/rhashtable.c:1198
lr : nested_table_top lib/rhashtable.c:72 [inline]
lr : __rht_bucket_nested+0xb0/0x594 lib/rhashtable.c:1197
sp : ffff8000a23a7300
x29: ffff8000a23a7310 x28: 0000000000000010 x27: 00000000c6aa9140
x26: dfff800000000000 x25: 0000000000000000 x24: 00000000c6aa9140
x23: ffff0000ce9fe080 x22: 00000000c4881028 x21: 00000000ffff0000
x20: ffff0000ce9fe000 x19: ffff0000ce9fe004 x18: 0000000000000000
x17: 64656e6769736e75 x16: ffff80008b007230 x15: ffff70001260d84c
x14: 1ffff0001260d84c x13: 0000000000000004 x12: ffffffffffffffff
x11: ffff70001260d84c x10: 0000000000ff0100 x9 : ffff8000975a4860
x8 : 0000000000000000 x7 : fffffffffffed948 x6 : ffff800080563af4
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff8000830c1284
x2 : 0000000000000000 x1 : 0000000000000008 x0 : 0000000000000000
Call trace:
 __rht_bucket_nested+0xbc/0x594 lib/rhashtable.c:1198 (P)
 rht_bucket_var include/linux/rhashtable.h:296 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1008 [inline]
 __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
 rhashtable_remove_fast include/linux/rhashtable.h:1122 [inline]
 xfs_buf_rele_cached fs/xfs/xfs_buf.c:926 [inline]
 xfs_buf_rele+0x690/0xcfc fs/xfs/xfs_buf.c:951
 xfs_buftarg_shrink_scan+0x1d8/0x270 fs/xfs/xfs_buf.c:1653
 do_shrink_slab+0x650/0x11b0 mm/shrinker.c:437
 shrink_slab+0xc68/0xfb8 mm/shrinker.c:664
 drop_slab_node mm/vmscan.c:441 [inline]
 drop_slab+0x120/0x248 mm/vmscan.c:459
 drop_caches_sysctl_handler+0x170/0x300 fs/drop_caches.c:68
 proc_sys_call_handler+0x460/0x7e8 fs/proc/proc_sysctl.c:600
 proc_sys_write+0x2c/0x3c fs/proc/proc_sysctl.c:626
 do_iter_readv_writev+0x4c0/0x724 fs/read_write.c:-1
 vfs_writev+0x29c/0x7cc fs/read_write.c:1057
 do_writev+0x128/0x290 fs/read_write.c:1103
 __do_sys_writev fs/read_write.c:1171 [inline]
 __se_sys_writev fs/read_write.c:1168 [inline]
 __arm64_sys_writev+0x80/0x94 fs/read_write.c:1168
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 976eb328 f94002e8 8b190d19 d343ff28 (387a6908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	976eb328 	bl	0xfffffffffdbacca0
   4:	f94002e8 	ldr	x8, [x23]
   8:	8b190d19 	add	x25, x8, x25, lsl #3
   c:	d343ff28 	lsr	x8, x25, #3
* 10:	387a6908 	ldrb	w8, [x8, x26] <-- trapping instruction


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
