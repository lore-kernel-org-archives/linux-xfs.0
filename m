Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8E249D58C
	for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792327949; cv=none; b=ICZMhb7r4WnXDLWRru7UDw2+ryjsNR3eNqZCy3j7Ttl1KQ4b5ikkeiLlrXduEjQ9jDBg+tTThQInssQ6KDkbxn5EtkLrOlU9H/Vha5M+fM59YmXBqLXsjbTgfba2aAJIz1pkZwaGSQHh51syDdsn9jOqItHQxLGYSl4dSgvH+pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792327949; c=relaxed/simple;
	bh=4e/cZlNHFugnl0GQlTF6D9lv8zDe84gkKeLcigX3E04=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Js0JYwN6rNV7U8MSwpb/TjcLx2HYWzvMTFVI1oRQl9BmJz4PdmdxiLwGrZvc7Wdno3Q05srxIEJLPOQx9Mg1Iy+o1ZU8s2pZFzBL6DgebVUaX79u5OR2yryWMzPOCn0YJ/EXUzb/4EdVi003YGaUUkuN/jer3AObyapRWtt8io4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e778acdbc6so2470081b6e.3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 05:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792327947; x=1792932747;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ynpU3sFABEIJ2y70VYaPsZuLbo5x2o5qkA8rVhUTAfM=;
        b=ol0gN3iN/e4FMowxAJDfbVLs/P06IubGdg24KT9p0XWHz5AvNkSjqGw8KIF2aMGHzK
         i3ko5hfal3/aWCgv2u5i/CAcoD+vjP4E/UpgkzIRTbwC+xoYSH2Rx8rOd/OM1nuBJ7py
         qAwy77TaUC3ZtF2fKwwg6a4cscA3zj06W9N7hcACqR8DT4mW58wGtnFhxOt2xsbBtXvs
         rQ4xyKrH5GSgJ7Y36RqR0i0n/fdxzlfEzC+t6evxZ1KA420PDJebraq6RMJA30qb02gI
         xf2UFktK/Cefrp5T6EE/tPPcr6Wqaw4HG/MPfAYGxwVuFQUMp4F8aAWER/bkRF+xwFc4
         HumQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2N2pY/bY88YUv8k75dGIg742DZqrF0j5CFgFjxz31DkoXIwIwiWGMTCvi+WVkzEeSWp67HsxQlyc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJxj7F313OMjyeIaS1V+aFfHrJb/iAMSTIt91auSmOTQR3iY9oR
	e+4/2TrOpFCaxe5OHF0kbpqsQNdc9qLBkSQutHR1cDK+k60JNjeJfBePc7j63G/KvtltTBlr/+Y
	tfBpJF1zYy4Obhyx21u/9+Gse3Z8gxmkH7vVeOd/DHFI3alTAOuXGp2ATFlg=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2384:b0:4f8:716d:793e with SMTP id
 5614622812f47-53cd2a696camr3829902b6e.46.1792327946845; Sun, 18 Oct 2026
 05:52:26 -0700 (PDT)
Date: Sun, 18 Oct 2026 05:52:26 -0700
In-Reply-To: <6a6c0d7d.b1a781d0.210f9.001a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad4c10a.6814cce4.34c49f.00f2.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_defer_item_unpause
From: syzbot <syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com>
To: cem@kernel.org, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, stable@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, viennaoffh@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    32c52ec87d62 x86/insn-eval: Fix shadowed segment index in ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13778bc9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ccb65e03706547e
dashboard link: https://syzkaller.appspot.com/bug?extid=e7f24354da9f7915bc54
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ca1e9c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ca1e9c580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-32c52ec8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e3667e150f2a/vmlinux-32c52ec8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/603cc202ff6c/bzImage-32c52ec8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/97b1c323a9b6/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=15ca1e9c580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in xfs_defer_item_unpause+0x116/0x250 fs/xfs/libxfs/xfs_defer.c:1256
Read of size 4 at addr ffff88803b37d0fc by task syz.0.22/5598

CPU: 0 UID: 0 PID: 5598 Comm: syz.0.22 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 xfs_defer_item_unpause+0x116/0x250 fs/xfs/libxfs/xfs_defer.c:1256
 xrep_newbt_free+0x3fe/0x5f0 fs/xfs/scrub/newbt.c:522
 xrep_ibt_build_new_trees+0xafd/0xdc0 fs/xfs/scrub/ialloc_repair.c:752
 xrep_iallocbt+0x24e/0x340 fs/xfs/scrub/ialloc_repair.c:828
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:980
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc864b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc865a8b028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc864e25fa0 RCX: 00007fc864b9e559
RDX: 0000200000041d40 RSI: 00000000c0285840 RDI: 0000000000000005
RBP: 00007fc864c35ab8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc864e26038 R14: 00007fc864e25fa0 R15: 00007ffe67582028
 </TASK>

Allocated by task 5598:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:351 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:377
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_noprof+0x2b9/0x600 mm/slub.c:5010
 xfs_defer_alloc fs/xfs/libxfs/xfs_defer.c:843 [inline]
 xfs_defer_add+0x143/0x480 fs/xfs/libxfs/xfs_defer.c:871
 xfs_extent_free_defer_add+0x1bf/0x3b0 fs/xfs/xfs_extfree_item.c:507
 xfs_defer_extent_free+0x2a8/0x400 fs/xfs/libxfs/xfs_alloc.c:2682
 xfs_alloc_schedule_autoreap+0xb0/0x170 fs/xfs/libxfs/xfs_alloc.c:2727
 xrep_newbt_add_blocks+0x22a/0x3f0 fs/xfs/scrub/newbt.c:211
 xrep_newbt_alloc_ag_blocks+0x81e/0xcc0 fs/xfs/scrub/newbt.c:311
 xrep_ibt_build_new_trees+0x75e/0xdc0 fs/xfs/scrub/ialloc_repair.c:696
 xrep_iallocbt+0x24e/0x340 fs/xfs/scrub/ialloc_repair.c:828
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:980
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5598:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kmem_cache_free+0x182/0x650 mm/slub.c:6636
 xfs_defer_cancel_list fs/xfs/libxfs/xfs_defer.c:505 [inline]
 xfs_defer_finish_noroll+0xf8b/0x14e0 fs/xfs/libxfs/xfs_defer.c:737
 xfs_defer_finish+0x1c/0x180 fs/xfs/libxfs/xfs_defer.c:755
 xrep_defer_finish+0x16e/0x240 fs/xfs/scrub/repair.c:242
 xrep_newbt_alloc_ag_blocks+0x86c/0xcc0 fs/xfs/scrub/newbt.c:318
 xrep_ibt_build_new_trees+0x75e/0xdc0 fs/xfs/scrub/ialloc_repair.c:696
 xrep_iallocbt+0x24e/0x340 fs/xfs/scrub/ialloc_repair.c:828
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:980
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88803b37d0c0
 which belongs to the cache xfs_defer_pending of size 64
The buggy address is located 60 bytes inside of
 freed 64-byte region [ffff88803b37d0c0, ffff88803b37d100)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88803b37d600 pfn:0x3b37d
flags: 0x4fff00000000200(workingset|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000200 ffff888033947dc0 ffff888033c36588 ffff888033c36588
raw: ffff88803b37d600 00000002002a0010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 131, tgid 131 (kworker/u4:5), ts 153391648879
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_noprof+0x399/0x600 mm/slub.c:5010
 xfs_defer_alloc fs/xfs/libxfs/xfs_defer.c:843 [inline]
 xfs_defer_add+0x143/0x480 fs/xfs/libxfs/xfs_defer.c:871
 xfs_bmap_add_extent_hole_real+0xd61/0x1a40 fs/xfs/libxfs/xfs_bmap.c:2782
 xfs_bmapi_allocate+0x248c/0x2f20 fs/xfs/libxfs/xfs_bmap.c:3975
 xfs_bmapi_write+0x843/0x1330 fs/xfs/libxfs/xfs_bmap.c:4265
 xfs_dquot_disk_alloc+0x4af/0xae0 fs/xfs/xfs_dquot.c:385
 xfs_qm_dqread+0xfe/0x520 fs/xfs/xfs_dquot.c:724
 xfs_qm_dqget+0x18a/0x3d0 fs/xfs/xfs_dquot.c:927
 xfs_qm_quotacheck_dqadjust+0xdd/0x5a0 fs/xfs/xfs_qm.c:1260
 xfs_qm_dqusage_adjust+0x4ad/0x670 fs/xfs/xfs_qm.c:1389
page last free pid 9 tgid 9 ts 153295791972 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __slab_free+0x274/0x2c0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __kmalloc_cache_noprof+0x29f/0x600 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 nsim_fib6_rt_create drivers/net/netdevsim/fib.c:547 [inline]
 nsim_fib6_rt_insert drivers/net/netdevsim/fib.c:752 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:856 [inline]
 nsim_fib_event+0xf37/0xa3a0 drivers/net/netdevsim/fib.c:889
 nsim_fib_event_work+0x244/0x3b0 drivers/net/netdevsim/fib.c:1493
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88803b37cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803b37d000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88803b37d080: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                                ^
 ffff88803b37d100: fc fc fc fc fa fb fb fb fb fb fb fb fc fc fc fc
 ffff88803b37d180: fa fb fb fb fb fb fb fb fc fc fc fc fa fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
