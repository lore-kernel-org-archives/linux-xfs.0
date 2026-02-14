Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB522749DF
	for <linux-xfs@vger.kernel.org>; Sat, 14 Feb 2026 19:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771099119; cv=none; b=kFiQj5uyJlBxTAd68CVkWYpg5sf1ph4xHSv5+uKGuVzoWIQK81pqnKXfogmp2orZvmhzRt6/qQ0rXWZMJbVeCIkSkNu+ZgomGWZxtwr2azH6rUqbiFu334JoRFGgXlU/TBQkTGaFtq7nMujcqY3KmXZkcv4FzD4znDIs27r+G5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771099119; c=relaxed/simple;
	bh=kZMupmOdEg7g7ElhrfbguwS/d3ptIJhrxI6Q2pDhBZY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=A1OsglZC4DxhGc4n5cTxMXqL1fQkcRUf//BBuTK1m4tQWqnokjb65l1fld9r+LBTtHOqnES9q5CjKRQMH0iHL3Z0uIxM+d42q6kJmwtL1xTH8PMuHVeqESTc8wHaHlVfSNrmqZK+p6k7F8xN+Wt71h2MGO+HN0UEqQpsLRiT5wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40ea48ccbd2so6230856fac.3
        for <linux-xfs@vger.kernel.org>; Sat, 14 Feb 2026 11:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771099117; x=1771703917;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bsfVjpTU3pyec+nQ2qpW1XWMu/ykIzLRTh3lXAZRdMY=;
        b=GeDV1yKRI0lTnDyspKCG/f4Yu+iqVYr2e1xkiUWKDOJesR6e2uS+DzNF7kJQwrJxed
         EYYv2/ucAtKFpjwEsX5CRSqpyJE5wcTUzV8g6gDE3IlQWeTDDl7AvZm2CFGu/enRXBjL
         6Jb8xFDuLdPl6njpXCl3G6h4OTu7GmMf4siSOyXc5e8IfvANjB9h+P9f+864CGd1NQMv
         XM2FkEf1vp99lGeNkQmUpO8iwuUN3R9R691wpcgavacodac+32hNN0Van076VPKpr1qf
         dZ1CLFpxEyXJVvEZnDmb00NN2Tm8etjQ19Yli/uyx0HGPCSVt3XSS63eMtU4b9Yb0+Y/
         zXJg==
X-Forwarded-Encrypted: i=1; AJvYcCVmxP7lRV3jtGQx1hgbCO0JYJwH/f6DMrR/teKREJ0GXMITW1Mhj7khS7yI0AbQjuAm80sAGgnZkp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlLW4Zxci9V1MJshRH53wjmew3rb9Z6AjwFnj/pnPl2Unqm02U
	Is0a5mbsZfCi/GpHmGKR4+M5zTjfIuqfjc9Oytl/eJKAlf9MMXql9aokAEhGtxaQFr+9Gtexnv9
	m+Dzy7kdgV59l5hNamB+NmPi8tilLrM3MhcEF1m7fs2Nd2SAZhz8L3Ck86Eo=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2906:b0:674:3230:ff1c with SMTP id
 006d021491bc7-6785c51090fmr1648545eaf.80.1771099116778; Sat, 14 Feb 2026
 11:58:36 -0800 (PST)
Date: Sat, 14 Feb 2026 11:58:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6990d3ec.a70a0220.2c38d7.00d2.GAE@google.com>
Subject: [syzbot] [xfs?] KASAN: slab-use-after-free Read in fserror_worker
From: syzbot <syzbot+fbf6ff30de890ff32ec5@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dc855b77719f Merge tag 'irq-drivers-2026-02-09' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d8ccaa580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d3f400265d9837ec
dashboard link: https://syzkaller.appspot.com/bug?extid=fbf6ff30de890ff32ec5
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173a5b22580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1648d7fa580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dc855b77.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9b3fb6cba25b/vmlinux-dc855b77.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1e986cdef5ea/bzImage-dc855b77.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e278523ff18b/mount_1.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1599365a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fbf6ff30de890ff32ec5@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in inode_state_read_once include/linux/fs.h:884 [inline]
BUG: KASAN: slab-use-after-free in iput+0x3a7/0xe80 fs/inode.c:1977
Read of size 4 at addr ffff88800ba8efb8 by task kworker/0:2/54

CPU: 0 UID: 0 PID: 54 Comm: kworker/0:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events fserror_worker
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 inode_state_read_once include/linux/fs.h:884 [inline]
 iput+0x3a7/0xe80 fs/inode.c:1977
 fserror_worker+0x230/0x350 fs/fserror.c:69
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>

Allocated by task 5498:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_lru_noprof+0x35f/0x6c0 mm/slub.c:5282
 xfs_inode_alloc+0x7e/0x710 fs/xfs/xfs_icache.c:97
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:635 [inline]
 xfs_iget+0xa85/0x2ce0 fs/xfs/xfs_icache.c:799
 xfs_lookup+0x321/0x630 fs/xfs/xfs_inode.c:553
 xfs_vn_lookup+0x130/0x200 fs/xfs/xfs_iops.c:327
 __lookup_slow+0x2b7/0x410 fs/namei.c:1916
 lookup_slow+0x53/0x70 fs/namei.c:1933
 ovl_lookup_positive_unlocked fs/overlayfs/namei.c:210 [inline]
 ovl_lookup_single+0x32f/0xea0 fs/overlayfs/namei.c:254
 ovl_lookup_layer+0x377/0x450 fs/overlayfs/namei.c:359
 ovl_lookup_layers fs/overlayfs/namei.c:1103 [inline]
 ovl_lookup+0x5f2/0x1c80 fs/overlayfs/namei.c:1397
 lookup_one_qstr_excl+0x131/0x360 fs/namei.c:1805
 __start_renaming+0x1db/0x410 fs/namei.c:3862
 filename_renameat2+0x38c/0x9c0 fs/namei.c:6119
 __do_sys_renameat2 fs/namei.c:6173 [inline]
 __se_sys_renameat2+0x5a/0x2c0 fs/namei.c:6168
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5498:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6674 [inline]
 kmem_cache_free+0x195/0x610 mm/slub.c:6789
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x7c0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x5f/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3131 [inline]
 call_rcu+0xee/0x890 kernel/rcu/tree.c:3251
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:740 [inline]
 xfs_iget+0xb01/0x2ce0 fs/xfs/xfs_icache.c:799
 xfs_lookup+0x321/0x630 fs/xfs/xfs_inode.c:553
 xfs_vn_lookup+0x130/0x200 fs/xfs/xfs_iops.c:327
 __lookup_slow+0x2b7/0x410 fs/namei.c:1916
 lookup_slow+0x53/0x70 fs/namei.c:1933
 ovl_lookup_positive_unlocked fs/overlayfs/namei.c:210 [inline]
 ovl_lookup_single+0x32f/0xea0 fs/overlayfs/namei.c:254
 ovl_lookup_layer+0x377/0x450 fs/overlayfs/namei.c:359
 ovl_lookup_layers fs/overlayfs/namei.c:1103 [inline]
 ovl_lookup+0x5f2/0x1c80 fs/overlayfs/namei.c:1397
 lookup_one_qstr_excl+0x131/0x360 fs/namei.c:1805
 __start_renaming+0x1db/0x410 fs/namei.c:3862
 filename_renameat2+0x38c/0x9c0 fs/namei.c:6119
 __do_sys_renameat2 fs/namei.c:6173 [inline]
 __se_sys_renameat2+0x5a/0x2c0 fs/namei.c:6168
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88800ba8ed00
 which belongs to the cache xfs_inode of size 1784
The buggy address is located 696 bytes inside of
 freed 1784-byte region [ffff88800ba8ed00, ffff88800ba8f3f8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xba8c
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8880125ab781
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88803139da00 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080080008 00000000f5000000 ffff8880125ab781
head: 00fff00000000040 ffff88803139da00 dead000000000122 0000000000000000
head: 0000000000000000 0000000080080008 00000000f5000000 ffff8880125ab781
head: 00fff00000000002 ffffea00002ea301 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5498, tgid 5497 (syz.0.17), ts 109700745240, free_ts 106973924123
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd90/0x1790 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 kmem_cache_alloc_lru_noprof+0x3ed/0x6c0 mm/slub.c:5282
 xfs_inode_alloc+0x7e/0x710 fs/xfs/xfs_icache.c:97
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:635 [inline]
 xfs_iget+0xa85/0x2ce0 fs/xfs/xfs_icache.c:799
 xfs_icreate+0xbe/0x170 fs/xfs/xfs_inode.c:600
 xfs_create+0x648/0xae0 fs/xfs/xfs_inode.c:721
 xfs_generic_create+0x410/0xb30 fs/xfs/xfs_iops.c:216
 xfs_vn_mkdir+0x37/0x50 fs/xfs/xfs_iops.c:309
 vfs_mkdir+0x413/0x630 fs/namei.c:5233
 filename_mkdirat+0x285/0x510 fs/namei.c:5266
page last free pid 5456 tgid 5456 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2973
 discard_slab mm/slub.c:3346 [inline]
 __put_partials+0x146/0x170 mm/slub.c:3886
 __slab_free+0x294/0x320 mm/slub.c:5956
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_node_noprof+0x427/0x6f0 mm/slub.c:5315
 __alloc_skb+0x1d7/0x390 net/core/skbuff.c:679
 alloc_skb include/linux/skbuff.h:1383 [inline]
 nlmsg_new include/net/netlink.h:1055 [inline]
 netlink_ack+0x146/0xa50 net/netlink/af_netlink.c:2487
 netlink_rcv_skb+0x2b6/0x4b0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 __sys_sendto+0x709/0x7a0 net/socket.c:2206
 __do_sys_sendto net/socket.c:2213 [inline]
 __se_sys_sendto net/socket.c:2209 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2209
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88800ba8ee80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800ba8ef00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88800ba8ef80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff88800ba8f000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800ba8f080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
