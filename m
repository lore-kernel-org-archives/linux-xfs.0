Received: from mail-oa2-f8.google.com (mail-oa2-f8.google.com [74.125.231.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE0023EAAF
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790036017; cv=none; b=RJMBTJRQIczHNr3ZUZRk+jaqHX9INFF1KM+N7dDqUcTDtdFdap8zn3yQ6VDIQgLCuvm9GhzGQ7iSf1Hfi0C+OxFxvAQoAri6kwAtREjdtbb2sGa3CUKR4FUaTaHsbpRWXsPUSSagjnyN3sv1VJM4Q09UtE4I172a171SSWBZgVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790036017; c=relaxed/simple;
	bh=qwJY7dBParvjkZusqMip3ebuiHmALk4T8TF/IJwr5yw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uoe5qvuzFgJOarAULMvl3P87fvqwofAbVmGoEGkXjLstOW90meLSGQYWTOj8Og8lGtlsmR0OkSArhajVujT7EwLHvfg4uqQWKEozSDAfcD1rxXC6g+87/ctuvPkQVry3SHZRrRFE89/qg/q9zK1rCxAqiNSXwPHIDMg6EMOfPBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f8.google.com with SMTP id 586e51a60fabf-46683b030d9so1470912fac.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 17:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790036014; x=1790640814;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XxuT5WAYU+O61SPlOaWDQ1DeR9X0yve3nEnJiyruIb4=;
        b=izCUfvvjIOh8F07rcA97J8/rKn2WApXr7RSlRDgg83wtpGrcCUtJzlzHVRryhlI/ET
         +WBG5Rr91FVtecLXgGHMyAWPSWWg6yoAledUY9fo5cY5pDiBWh8gTt+TgZ/Oiv3TrCUu
         2PewEA9g1oNeofAC3DYXhqitZ4J4n2ll1xNHgRlPZUzMkyVvPQilUfflPRhTbrsiueWS
         4hNqHP3EOUeqNKN3DHdcSeCrOyWnzDrvyn0bNQoxYXp/lY5D6Fw6UYRCAi/tkvxKHN8n
         T6wWrrxfrt9rFREzYfcsPp/Ulr66/MhCx/5ahMxtrrOP2DyvgpWLZU0bqFjkuaY0eY3a
         Y21Q==
X-Forwarded-Encrypted: i=1; AKwUvBz6F2o6V7vp1bGAVgWRxAYH/ce28j0TWQ9RYR7eUmILArNsMfnjQD4LgsKrXMrlzBfs9SCp4tDdsSA=@vger.kernel.org
X-Gm-Message-State: AFuF++k6gbFayGt+Imp4ylRWXPVpnqwIAbirXuzn/WZEtGuF6hzbXfIq
	6oZrhQ5SmUFgVpqCLYUPQv9I0Bz/HH9R2nAoywJD308WNYNijUn669Pyp/6n4hjykkWJ17YAu9D
	ovt5jSJ3ANxCkvBPns5y4qV0Z7C3HOjiFJ56mFQGfQWxJnMVS/OSairMAm4k=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f02a:b0:6cd:3fcc:96cc with SMTP id
 006d021491bc7-6cd3fdbddcamr9119251eaf.74.1790036013992; Mon, 21 Sep 2026
 17:13:33 -0700 (PDT)
Date: Mon, 21 Sep 2026 17:13:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab1c82d.514bccd6.255447.0018.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Write in xlog_cil_push_work
From: syzbot <syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    238650ef6c7c Merge tag 'powerpc-7.3-4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17857925580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/41924f079a65/disk-238650ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/09d46c75ec43/vmlinux-238650ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/061e8caeb39c/bzImage-238650ef.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __list_splice include/linux/list.h:580 [inline]
BUG: KASAN: slab-use-after-free in list_splice_init include/linux/list.h:619 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_push_work+0x9b6/0x2a90 fs/xfs/xfs_log_cil.c:1417
Write of size 8 at addr ffff8880261d5d88 by task kworker/u8:9/1441

CPU: 0 UID: 0 PID: 1441 Comm: kworker/u8:9 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: xfs-cil/loop3 xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 __list_splice include/linux/list.h:580 [inline]
 list_splice_init include/linux/list.h:619 [inline]
 xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
 xlog_cil_push_work+0x9b6/0x2a90 fs/xfs/xfs_log_cil.c:1417
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5944:
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

Freed by task 5944:
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

The buggy address belongs to the object at ffff8880261d5d20
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 104 bytes inside of
 freed 272-byte region [ffff8880261d5d20, ffff8880261d5e30)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x261d5
flags: 0x80000000000000(node=0|zone=1)
page_type: f5(slab)
raw: 0080000000000000 ffff88814043fdc0 dead000000000122 0000000000000000
raw: 0000000000000000 00000002000c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5795, tgid 5794 (syz.3.4), ts 106215173769
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
page last free pid 5581 tgid 5581 ts 106036434714 stack trace:
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
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_node_track_caller_noprof+0x505/0x7b0 mm/slub.c:5545
 memdup_user+0x2b/0xd0 mm/util.c:221
 strndup_user+0x68/0xd0 mm/util.c:280
 copy_mount_string fs/namespace.c:4076 [inline]
 __do_sys_mount fs/namespace.c:4387 [inline]
 __se_sys_mount+0xdf/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880261d5c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880261d5d00: fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb fb
>ffff8880261d5d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff8880261d5e00: fb fb fb fb fb fb fc fc fc fc fc fc fc fc 00 00
 ffff8880261d5e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
