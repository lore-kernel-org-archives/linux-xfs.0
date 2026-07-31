Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E16339368
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 02:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785466240; cv=none; b=MGicuujn3bQB2s9XK+Q4oo0/kIm3wfMbvROeF4qowEvpKCZVErWGYmf3Mu3q7VLgNTwWoQmKYTSGiRXQqrFREq8/xQTGYXeplOCUWjVpYjyoYS53wyBrIDrOGlrRIA3BSOmmWbBgVY0VUii78dGQHenfus2c3l+eMKha47esfHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785466240; c=relaxed/simple;
	bh=wmmRytSRWbqOj4fryQrLgCvdZ7j5tEeO/uBFwZqvD/M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UJDNd5oPwwMh/BtLipEo8+qbSE9pGGKZSYr/Qf7uSOrc283AvWN+nIKf4VKRzzIlU+gFubAfhVWuJXLyNU63+kzlrt2XPCTQVEwCxC0FcaJW8sux9TEfaznRfb/Q6bi27/6dsYpkoiB6k9FSO9Mbz8XrhL9FkpHegfl+cyCS50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4a7c64fbbc6so392983b6e.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 19:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785466237; x=1786071037;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GhqQkKgTGoxfydBDAhV/wixFXe1YhZymGRQkaYgGFu0=;
        b=loYY9I085J6b2cbrrx9Fv7PqQIdKnW41K/vf89t9aY/ucKblfVPI4tdab47gCe/H/+
         qYWWz8Sf5JdRYy5plMDtFkVkVp4AJ4hwxomh6AS3qXqF9x/dJ3G46nN1dizgkt2B52gF
         HMjEBaPN/QbxqbSqo/qgv/ZIrBguBsuaE8qpzABXbQrnf8Fegz/pQ0XbTmssPSiWnnBB
         PwF7MxlegcwBsBJ3lYfXNL8wkPq0D7ET37dFHB0V+am4ghKgcQzfZTmofWAIubf4F2jx
         FTIjHST8X4dAGZSxk47ZlZqEO3Liirk/JZmZbSp+aIa5P6riGx/j7w68RzX059Zp3Zny
         JM+A==
X-Forwarded-Encrypted: i=1; AHgh+RrFzy8OgwGuaAAECf4scFDhrxFvCy42RnCliqC+qocujTz0emOmgex8Mn4zUZmr0DC9sp4cyosRKOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTwKRdbJYvdpcpV/Gx09HfpT4FBj0sFbRi1VyPQqO79KmOiRCY
	0/zWqecVoNuzSrwUV3fbB/m2iQIW9P8MCAu4wyknI5Wb0vgebHNHyWVdC3u7W4NvmgOhpRoXTYM
	yNTkhP8mCqxVZZRE+TsX2p0+AAQ7rwSajWLmiZ4WseUbLMnVR+9jVPSoNMRY=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6808:b0:4a3:fb6c:9adf with SMTP id
 5614622812f47-4ae4c472a80mr156917b6e.12.1785466237392; Thu, 30 Jul 2026
 19:50:37 -0700 (PDT)
Date: Thu, 30 Jul 2026 19:50:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6c0d7d.b1a781d0.210f9.001a.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_defer_item_unpause
From: syzbot <syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0ce37745d4bf Merge tag 'block-7.2-20260724' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=108627b1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05be6c9b0d36cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=e7f24354da9f7915bc54
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0ce37745.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1ae117bfa58a/vmlinux-0ce37745.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c5c9d9abed6a/bzImage-0ce37745.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
loop0: detected capacity change from 32768 to 0
==================================================================
BUG: KASAN: slab-use-after-free in xfs_defer_item_unpause+0x116/0x250 fs/xfs/libxfs/xfs_defer.c:1242
Read of size 4 at addr ffff8880443214bc by task syz.0.0/5326

CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 xfs_defer_item_unpause+0x116/0x250 fs/xfs/libxfs/xfs_defer.c:1242
 xrep_newbt_free+0x3fe/0x5f0 fs/xfs/scrub/newbt.c:520
 xrep_rmap_build_new_tree+0x5b5/0x8c0 fs/xfs/scrub/rmap_repair.c:1447
 xrep_rmapbt+0x78/0xb0 fs/xfs/scrub/rmap_repair.c:1722
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:981
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7335b9de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7336b4cfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f7335e25fa0 RCX: 00007f7335b9de99
RDX: 0000200000000000 RSI: 00000000c0285840 RDI: 0000000000000007
RBP: 00007f7335c33eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7335e26038 R14: 00007f7335e25fa0 R15: 00007ffde61731e8
 </TASK>

Allocated by task 5326:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4584 [inline]
 slab_alloc_node mm/slub.c:4917 [inline]
 kmem_cache_alloc_noprof+0x2a0/0x5f0 mm/slub.c:4931
 xfs_defer_alloc fs/xfs/libxfs/xfs_defer.c:829 [inline]
 xfs_defer_add+0x143/0x480 fs/xfs/libxfs/xfs_defer.c:857
 xfs_extent_free_defer_add+0x1bf/0x3b0 fs/xfs/xfs_extfree_item.c:507
 xfs_defer_extent_free+0x2a8/0x400 fs/xfs/libxfs/xfs_alloc.c:2682
 xfs_alloc_schedule_autoreap+0xb0/0x170 fs/xfs/libxfs/xfs_alloc.c:2727
 xrep_newbt_add_blocks+0x239/0x410 fs/xfs/scrub/newbt.c:209
 xrep_newbt_alloc_ag_blocks+0x81e/0xcc0 fs/xfs/scrub/newbt.c:309
 xrep_rmap_try_reserve+0x1f4/0x800 fs/xfs/scrub/rmap_repair.c:1068
 xrep_rmap_reserve_space+0x19a/0x470 fs/xfs/scrub/rmap_repair.c:1162
 xrep_rmap_build_new_tree+0x3d9/0x8c0 fs/xfs/scrub/rmap_repair.c:1369
 xrep_rmapbt+0x78/0xb0 fs/xfs/scrub/rmap_repair.c:1722
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:981
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5326:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2677 [inline]
 slab_free mm/slub.c:6377 [inline]
 kmem_cache_free+0x182/0x650 mm/slub.c:6504
 xfs_defer_cancel_list fs/xfs/libxfs/xfs_defer.c:504 [inline]
 xfs_defer_finish_noroll+0xde4/0x1320 fs/xfs/libxfs/xfs_defer.c:723
 xfs_defer_finish+0x1c/0x180 fs/xfs/libxfs/xfs_defer.c:741
 xrep_defer_finish+0x16e/0x240 fs/xfs/scrub/repair.c:242
 xrep_newbt_alloc_ag_blocks+0x86c/0xcc0 fs/xfs/scrub/newbt.c:316
 xrep_rmap_try_reserve+0x1f4/0x800 fs/xfs/scrub/rmap_repair.c:1068
 xrep_rmap_reserve_space+0x19a/0x470 fs/xfs/scrub/rmap_repair.c:1162
 xrep_rmap_build_new_tree+0x3d9/0x8c0 fs/xfs/scrub/rmap_repair.c:1369
 xrep_rmapbt+0x78/0xb0 fs/xfs/scrub/rmap_repair.c:1722
 xrep_attempt+0x184/0x7c0 fs/xfs/scrub/repair.c:78
 xfs_scrub_metadata+0xce4/0x1910 fs/xfs/scrub/scrub.c:747
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:981
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888044321480
 which belongs to the cache xfs_defer_pending of size 64
The buggy address is located 60 bytes inside of
 freed 64-byte region [ffff888044321480, ffff8880443214c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8880443216c0 pfn:0x44321
flags: 0x4fff00000000200(workingset|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000200 ffff888030ba9c80 ffff8880305a9ac8 ffff8880305a9ac8
raw: ffff8880443216c0 00000008002a0012 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 12, tgid 12 (kworker/u4:0), ts 94710883881, free_ts 90574972561
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0x21fa/0x2270 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5304
 alloc_slab_page mm/slub.c:3266 [inline]
 allocate_slab+0x79/0x5e0 mm/slub.c:3380
 new_slab mm/slub.c:3426 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7310
 refill_sheaf mm/slub.c:2804 [inline]
 __pcs_replace_empty_main+0x2bf/0x6b0 mm/slub.c:4675
 alloc_from_pcs mm/slub.c:4773 [inline]
 slab_alloc_node mm/slub.c:4905 [inline]
 kmem_cache_alloc_noprof+0x382/0x5f0 mm/slub.c:4931
 xfs_defer_alloc fs/xfs/libxfs/xfs_defer.c:829 [inline]
 xfs_defer_add+0x143/0x480 fs/xfs/libxfs/xfs_defer.c:857
 xfs_bmap_add_extent_hole_real+0xd61/0x1a40 fs/xfs/libxfs/xfs_bmap.c:2782
 xfs_bmapi_allocate+0x248c/0x2f20 fs/xfs/libxfs/xfs_bmap.c:3975
 xfs_bmapi_write+0x843/0x1330 fs/xfs/libxfs/xfs_bmap.c:4265
 xfs_dquot_disk_alloc+0x4af/0xae0 fs/xfs/xfs_dquot.c:381
 xfs_qm_dqread+0xfe/0x520 fs/xfs/xfs_dquot.c:720
 xfs_qm_dqget+0x18a/0x3d0 fs/xfs/xfs_dquot.c:922
 xfs_qm_quotacheck_dqadjust+0xdd/0x5a0 fs/xfs/xfs_qm.c:1260
 xfs_qm_dqusage_adjust+0x4ad/0x670 fs/xfs/xfs_qm.c:1389
page last free pid 5284 tgid 5284 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xc1e/0xd10 mm/page_alloc.c:2950
 __slab_free+0x274/0x2c0 mm/slub.c:5741
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4584 [inline]
 slab_alloc_node mm/slub.c:4917 [inline]
 kmem_cache_alloc_node_noprof+0x355/0x610 mm/slub.c:4989
 __alloc_skb+0x1d7/0x7a0 net/core/skbuff.c:704
 alloc_skb include/linux/skbuff.h:1384 [inline]
 nlmsg_new include/net/netlink.h:1055 [inline]
 netlink_ack+0x136/0xb30 net/netlink/af_netlink.c:2493
 netlink_rcv_skb+0x2a4/0x4a0 net/netlink/af_netlink.c:2562
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2252
 __do_sys_sendto net/socket.c:2259 [inline]
 __se_sys_sendto net/socket.c:2255 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2255
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888044321380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888044321400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888044321480: fa fb fb fb fb fb fb fb fc fc fc fc fa fb fb fb
                                        ^
 ffff888044321500: fb fb fb fb fc fc fc fc fa fb fb fb fb fb fb fb
 ffff888044321580: fc fc fc fc fa fb fb fb fb fb fb fb fc fc fc fc
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
