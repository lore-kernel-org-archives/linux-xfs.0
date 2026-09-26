Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B21624C0
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 01:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790386290; cv=none; b=TV+j8C+kVwiaBNhwpszljUpkBHZMzIW0PQy6v/Zvv9IPOddni2Fu24xLeYgg+fPHlpDFchrZ6OQw95JU8TzUZkfK2KTd+WF5bUNSQXw3axQLNQ2PKV/tzw4VyNgphqG7xLnD9u59sLQoN1vO9ynFVbfmpeNc8rSnEKOp+1QWHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790386290; c=relaxed/simple;
	bh=E5M8QhhrUI+c7txXAJHX7r7HyxnZRw+NlSkTWpXOXG4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MJxAxyodeo/rPPFtE0AVDUr2uv+e+uGTqUnMLTUiCywYwVRLwCa3lqePXlmUEPCJOfH5fpMQS98StgGL0Z3EScO5bYA8Z1xPc5syKNTecEugqGu97dxSwl3iMocQLMt/qK8ZFH2YGtqAoqDQPQgXeVj09JRirjXDn+QPa205JuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4cc691d106fso2312322b6e.1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 18:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790386288; x=1790991088;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4cZSBn2zw/XbMeBYq5zuM8G+Y2uoeKGrGxErMpIJodw=;
        b=KOMFNPr3bdEB4ju1wJKuG5kZqQjeRSYq6b+dFtsDHlP7+9aKT0h6lB2qB9arTNLaNP
         ViFuvMYQchT8mCv677CHD/4IfinvKoP+vGCHw3Uukc1bb/DVU51Qx+HhvYwPz2Q98Vyx
         3H7pWuCxqUbQd/aUdfCdqefpl+ZTGADEAeA7nJkWXJLSttduyTeTVVl4IsEzi+brwxwl
         cgGS2fsNvOXqLrST/ckGGeXQa2ajN/naAV3zPPqBsKfWYsf1GVi4QdzFLPpmzKFwC059
         IBCgZt/He38x96nLrbvBRWImqsiKuWd5Hmcd/2zqW14BSYqS76xm2mNgk7qLcYr58AAA
         YHpg==
X-Forwarded-Encrypted: i=1; AKwUvBz0G127QORxVbSvb4zcmxaazrvDClpXNNxzXsnJKMmyj7RqONeSW1SgbmKFEw6G6x1gNtUys5uc8lU=@vger.kernel.org
X-Gm-Message-State: AFuF++lA3GL8B5N7nABzdOe6wWLMKIDmtR6pqXob8tCaidg5UXAnog3e
	a5+fBgA6wjboVCpaiIn3YXjKaZEZgmYB/krvuMo7PDnx5gxJAeAqPE8X0gOghx5Yur/zmpAFsHC
	/VPv5W3R55UfkdIJhwz/IzsY5w6Qmf4dw3wNZzzjtWqTviFThwstdBECtqNs=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1825:b0:4d6:93e2:5bc3 with SMTP id
 5614622812f47-4d72f4452b2mr8119550b6e.68.1790386288271; Fri, 25 Sep 2026
 18:31:28 -0700 (PDT)
Date: Fri, 25 Sep 2026 18:31:28 -0700
In-Reply-To: <6ab1c82d.514bccd6.255447.0018.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab72070.dc2998a4.2261f5.004f.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Write in xlog_cil_push_work
From: syzbot <syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    aa98230e410f Merge tag 'vfs-7.3-rc5.fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b4025e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=718e346eb0b8f38
dashboard link: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11440a05580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a99d25580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e111cbedae47/disk-aa98230e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/448db8740448/vmlinux-aa98230e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bf2dee21a792/bzImage-aa98230e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e1fe55618d28/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12ab2a05580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __list_splice include/linux/list.h:577 [inline]
BUG: KASAN: slab-use-after-free in list_splice_init include/linux/list.h:619 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
BUG: KASAN: slab-use-after-free in xlog_cil_push_work+0x986/0x2a90 fs/xfs/xfs_log_cil.c:1417
Write of size 8 at addr ffff88803ac995b0 by task kworker/u8:8/1160

CPU: 1 UID: 0 PID: 1160 Comm: kworker/u8:8 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: xfs-cil/loop0 xlog_cil_push_work
Call Trace:
 <TASK>
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 __list_splice include/linux/list.h:577 [inline]
 list_splice_init include/linux/list.h:619 [inline]
 xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
 xlog_cil_push_work+0x986/0x2a90 fs/xfs/xfs_log_cil.c:1417
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 6137:
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

Freed by task 6137:
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

The buggy address belongs to the object at ffff88803ac99540
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 112 bytes inside of
 freed 272-byte region [ffff88803ac99540, ffff88803ac99650)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3ac99
flags: 0x80000000000000(node=0|zone=1)
page_type: f5(slab)
raw: 0080000000000000 ffff88801e348b40 dead000000000122 0000000000000000
raw: 0000000000000000 00000002000c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6116, tgid 6106 (syz.4.30), ts 150746597616
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
 xfs_rtmount_inodes+0x245/0x7a0 fs/xfs/xfs_rtalloc.c:1721
 xfs_mountfs+0x1254/0x2380 fs/xfs/xfs_mount.c:1095
page last free pid 6120 tgid 6072 ts 149440641538 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 free_unref_folios+0xd0f/0x1950 mm/page_alloc.c:3022
 folios_put_refs+0x815/0x920 mm/folio.c:1036
 folio_batch_release include/linux/folio_batch.h:101 [inline]
 mapping_try_invalidate+0x3b7/0x4b0 mm/truncate.c:579
 xfs_ioc_setlabel+0x262/0x340 fs/xfs/xfs_ioctl.c:1091
 xfs_file_ioctl+0x901/0x1590 fs/xfs/xfs_ioctl.c:1238
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88803ac99480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803ac99500: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff88803ac99580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff88803ac99600: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
 ffff88803ac99680: fc fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
