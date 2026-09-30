Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8B41AA797
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 04:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790743839; cv=none; b=XibpMWHbH/PfljcimzCGvM2ioYXH6VB6+/vv8papxyBMD8NYldjSGibYXJJpd2nYhF5s+J/Zecb3835pcElDYbTICZniVOGpIRxNWJulxokOwzb4Qw3iuy+4LoeIKtHuVa4dURQgdv8emXZbkPdBjh3ZCYWZ+uPydy5pOBiRP1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790743839; c=relaxed/simple;
	bh=wuNm7jjclN+Efk41Kucz3rN3shAUEXFeSRSP02ZU3OA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lY7cXS1Zw2r4SwvJxikCcKmIcUnQOo57HUJe+tbwAygrRdjxeX7pLEJSrqMNSf6PFVZPRioy4/vJ2KQiEDPRMIWQGEYrUyvIXNCnFlIaywn0IZBJ6EruyetcOsSq3b0e55mB/urDLGLQKUDQs7IdpLC/TOzcPC61CAM6/OKfFFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b37620eb73so9130183b6e.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 21:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790743837; x=1791348637;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rlJr0xWAgWuTtKuw6J0u9PNe0SuYYVDQdyv1++JOcWc=;
        b=jh/AlhyPCMbPbz08qROjpczgM0gzygfdQyTYBrw2A75iTRQVetwR5PvN+L+MClnA3q
         q16IsHxKkCQAVdV1GeIQU9dLBPRrYTbsuhq1lCWniJy6+uZdxUv8E5M8X60ynY72EGlB
         aKvf+IbSyQDkR+q557Ytp2/mrbatdFHmEs2go564Hb5M8+YUKePDLqxOmT3boNrdPvVB
         fgIVotL15s95glLNnNl7MzaKa5IONgx/hqwtAfjCTTZ96hVEXt+VafyteJe0tvWzE7Bu
         zKsuNDZnjkOfC5NeVN4RPScjzIqAKqBtotnYPQFDEs8Joh430zz/TLwt8L/xp7E48NVq
         UO6w==
X-Forwarded-Encrypted: i=1; AKwUvBxkVmi5MJ+9HTewqx0qLXCT3iXweXLSHB4LhGoptc97rRdZ4QBGYh2MZ7x3UMkS9xiL13KstFhxVKo=@vger.kernel.org
X-Gm-Message-State: AFuF++mLi43abSniLU9p8n+nDP99SfnavZAZ0E7Xo1szQX52lPmowsSt
	+Z0sC00yk1DvJShdTxZEKy6SaCUFDyYAdpRYkzU91h9dgraCp9W7qsqrDj6uAbGW3dqGOTdWhvD
	lgHOmGZz90gYnuaLUoRrO1tfyu2CvEkO3OePU6rC0Ls0er1FI2uemGza3WlI=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3c47:b0:4cb:f21b:6f97 with SMTP id
 5614622812f47-4f1b84c70a8mr111573b6e.42.1790743836867; Tue, 29 Sep 2026
 21:50:36 -0700 (PDT)
Date: Tue, 29 Sep 2026 21:50:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abc951c.00649fcc.35d151.00e8.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Write in
 xlog_cil_committed (2)
From: syzbot <syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aa98230e410f Merge tag 'vfs-7.3-rc5.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17067d15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=718e346eb0b8f38
dashboard link: https://syzkaller.appspot.com/bug?extid=9d8e687768d0f38c1f09
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e111cbedae47/disk-aa98230e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/448db8740448/vmlinux-aa98230e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bf2dee21a792/bzImage-aa98230e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com

=========================
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_write include/linux/instrumented.h:97 [inline]
BUG: KASAN: slab-use-after-free in set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:889 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_committed+0x4ac/0x1110 fs/xfs/xfs_log_cil.c:995
Write of size 8 at addr ffff88803c610820 by task kworker/u8:5/69

CPU: 1 UID: 0 PID: 69 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: xfs-cil/loop4 xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_write include/linux/instrumented.h:97 [inline]
 set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
 xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:889 [inline]
 xlog_cil_committed+0x4ac/0x1110 fs/xfs/xfs_log_cil.c:995
 xlog_cil_push_work+0x24b6/0x2a90 fs/xfs/xfs_log_cil.c:1608
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 6374:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x360/0x690 mm/slub.c:5010
 xfs_buf_item_init+0x6a/0x6e0 fs/xfs/xfs_buf_item.c:872
 _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
 __xfs_trans_getsb+0x65/0x4a0 fs/xfs/xfs_trans_buf.c:191
 xfs_log_sb+0x43/0x200 fs/xfs/libxfs/xfs_sb.c:1327
 xfs_sync_sb_buf+0xc2/0x290 fs/xfs/libxfs/xfs_sb.c:1479
 xfs_ioc_setlabel+0x1d7/0x340 fs/xfs/xfs_ioctl.c:1081
 xfs_file_ioctl+0x901/0x1590 fs/xfs/xfs_ioctl.c:1238
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6374:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kmem_cache_free+0x187/0x6d0 mm/slub.c:6635
 xfs_buf_ioend+0x235/0x790 fs/xfs/xfs_buf.c:1167
 xfs_buf_iowait+0x133/0x420 fs/xfs/xfs_buf.c:1336
 xfs_bwrite+0x5f/0xe0 fs/xfs/xfs_buf.c:1239
 xfs_sync_sb_buf+0x172/0x290 fs/xfs/libxfs/xfs_sb.c:1489
 xfs_ioc_setlabel+0x1d7/0x340 fs/xfs/xfs_ioctl.c:1081
 xfs_file_ioctl+0x901/0x1590 fs/xfs/xfs_ioctl.c:1238
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88803c6107e0
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 64 bytes inside of
 freed 272-byte region [ffff88803c6107e0, ffff88803c6108f0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3c610
flags: 0x80000000000000(node=0|zone=1)
page_type: f5(slab)
raw: 0080000000000000 ffff88801f3d6c80 dead000000000100 dead000000000122
raw: 0000000000000000 00000002000c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5857, tgid 5854 (syz.4.12), ts 99901674002
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2591/0x2600 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x230/0x5c0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d8/0x350 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x339/0x690 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_noprof+0x45d/0x690 mm/slub.c:5010
 xfs_buf_item_init+0x6a/0x6e0 fs/xfs/xfs_buf_item.c:872
 _xfs_trans_bjoin+0x46/0x110 fs/xfs/xfs_trans_buf.c:75
 xfs_trans_read_buf_map+0x2ee/0x820 fs/xfs/xfs_trans_buf.c:294
 xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
 xfs_read_icluster+0x218/0x3e0 fs/xfs/libxfs/xfs_inode_buf.c:139
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:663 [inline]
 xfs_iget+0xc34/0x2f00 fs/xfs/xfs_icache.c:804
 xfs_trans_metafile_iget+0x77/0x330 fs/xfs/xfs_icache.c:853
 xfs_rtginode_load+0x3a3/0x920 fs/xfs/libxfs/xfs_rtgroup.c:469
 xfs_rtmount_rtg fs/xfs/xfs_rtalloc.c:1684 [inline]
 xfs_rtmount_inodes+0x14f/0x7a0 fs/xfs/xfs_rtalloc.c:1721
 xfs_mountfs+0x1254/0x2380 fs/xfs/xfs_mount.c:1095
page last free pid 41 tgid 41 ts 94068259020 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xf8e/0x1070 mm/page_alloc.c:2962
 __slab_free+0x250/0x2a0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __kmalloc_cache_noprof+0x353/0x680 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 mca_alloc net/ipv6/mcast.c:890 [inline]
 __ipv6_dev_mc_inc+0x447/0xaf0 net/ipv6/mcast.c:981
 addrconf_join_solict net/ipv6/addrconf.c:2262 [inline]
 addrconf_dad_begin net/ipv6/addrconf.c:4135 [inline]
 addrconf_dad_work+0x5dd/0x16e0 net/ipv6/addrconf.c:4263
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88803c610700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803c610780: fb fb fb fb fc fc fc fc fc fc fc fc fa fb fb fb
>ffff88803c610800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff88803c610880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff88803c610900: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
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
