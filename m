Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58224 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbeDDHOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Apr 2018 03:14:07 -0400
Date: Wed, 4 Apr 2018 09:14:06 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: KASAN: use-after-free Read in radix_tree_next_chunk
Message-ID: <20180404071405.GA18184@atrey.karlin.mff.cuni.cz>
References: <001a11427716a78e3c0568bb759f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001a11427716a78e3c0568bb759f@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: syzbot <syzbot+040b31ac96753fd7eb46@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, billodo@redhat.com, cmaiolino@redhat.com, colin.king@canonical.com, darrick.wong@oracle.com, dchinner@redhat.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

Come on? Two copies of one mail, to lkml with thousands of
subscribers?


> Hello,
> 
> syzbot hit the following crash on upstream commit
> 9dd2326890d89a5179967c947dab2bab34d7ddee (Fri Mar 30 17:29:47 2018 +0000)
> Merge tag 'ceph-for-4.16-rc8' of git://github.com/ceph/ceph-client
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=040b31ac96753fd7eb46
> 
> So far this crash happened 50 times on upstream.
> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6534913729757184
> syzkaller reproducer:
> https://syzkaller.appspot.com/x/repro.syz?id=6221692233842688
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=5252920484298752
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=-2760467897697295172
> compiler: gcc (GCC) 7.1.1 20170620
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+040b31ac96753fd7eb46@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> IPVS: ftp: loaded support on port[0] = 21
> XFS (loop5): Invalid device [./file0], error=-15
> XFS (loop7): nobarrier option is deprecated, ignoring.
> XFS (loop7): Invalid device [./file0], error=-15
> ==================================================================
> BUG: KASAN: use-after-free in radix_tree_next_chunk+0xde1/0xdf0
> lib/radix-tree.c:1733
> Read of size 4 at addr ffff8801b1669250 by task syzkaller476032/4458
> 
> CPU: 1 PID: 4458 Comm: syzkaller476032 Not tainted 4.16.0-rc7+ #7
> IPVS: ftp: loaded support on port[0] = 21
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report+0x23c/0x360 mm/kasan/report.c:412
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
>  radix_tree_next_chunk+0xde1/0xdf0 lib/radix-tree.c:1733
>  radix_tree_gang_lookup_tag+0x36e/0x5e0 lib/radix-tree.c:1918
> IPVS: ftp: loaded support on port[0] = 21
>  xfs_perag_get_tag+0x109/0x6c0 fs/xfs/libxfs/xfs_sb.c:88
> IPVS: ftp: loaded support on port[0] = 21
>  xfs_reclaim_inodes_count+0x82/0xb0 fs/xfs/xfs_icache.c:1362
>  xfs_fs_nr_cached_objects+0x37/0x50 fs/xfs/xfs_super.c:1778
>  super_cache_count+0x96/0x280 fs/super.c:131
>  do_shrink_slab mm/vmscan.c:310 [inline]
>  shrink_slab.part.46+0x30c/0xe80 mm/vmscan.c:475
>  shrink_slab+0x9d/0xb0 mm/vmscan.c:442
>  shrink_node+0x51e/0xf70 mm/vmscan.c:2556
>  shrink_zones mm/vmscan.c:2728 [inline]
>  do_try_to_free_pages+0x383/0x1020 mm/vmscan.c:2790
>  try_to_free_mem_cgroup_pages+0x44d/0xb40 mm/vmscan.c:3079
> IPVS: ftp: loaded support on port[0] = 21
>  reclaim_high.constprop.64+0x1e2/0x330 mm/memcontrol.c:1862
> IPVS: ftp: loaded support on port[0] = 21
>  mem_cgroup_handle_over_high+0x8d/0x130 mm/memcontrol.c:1887
>  tracehook_notify_resume include/linux/tracehook.h:193 [inline]
>  exit_to_usermode_loop+0x242/0x2f0 arch/x86/entry/common.c:166
>  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
>  do_syscall_64+0x6ec/0x940 arch/x86/entry/common.c:292
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x440fda
> RSP: 002b:00007ffd309f1880 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
> RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000440fda
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
> RBP: 00007ffd309f18a0 R08: 0000000000000001 R09: 00000000020eb880
> R10: 00000000020ebb50 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007ffd309f18d0 R14: 0000000000000000 R15: 00007ffd309f19e8
> 
> Allocated by task 4469:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
>  kmem_cache_alloc_trace+0x136/0x740 mm/slab.c:3608
>  kmalloc include/linux/slab.h:512 [inline]
>  kzalloc include/linux/slab.h:701 [inline]
>  xfs_fs_fill_super+0xd1/0x1220 fs/xfs/xfs_super.c:1579
>  mount_bdev+0x2b7/0x370 fs/super.c:1119
>  xfs_fs_mount+0x34/0x40 fs/xfs/xfs_super.c:1770
>  mount_fs+0x66/0x2d0 fs/super.c:1222
>  vfs_kern_mount.part.26+0xc6/0x4a0 fs/namespace.c:1037
>  vfs_kern_mount fs/namespace.c:2509 [inline]
>  do_new_mount fs/namespace.c:2512 [inline]
>  do_mount+0xea4/0x2bb0 fs/namespace.c:2842
>  SYSC_mount fs/namespace.c:3058 [inline]
>  SyS_mount+0xab/0x120 fs/namespace.c:3035
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> 
> Freed by task 4469:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
>  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
>  __cache_free mm/slab.c:3486 [inline]
>  kfree+0xd9/0x260 mm/slab.c:3801
>  xfs_fs_fill_super+0x6c3/0x1220 fs/xfs/xfs_super.c:1734
>  mount_bdev+0x2b7/0x370 fs/super.c:1119
>  xfs_fs_mount+0x34/0x40 fs/xfs/xfs_super.c:1770
>  mount_fs+0x66/0x2d0 fs/super.c:1222
>  vfs_kern_mount.part.26+0xc6/0x4a0 fs/namespace.c:1037
>  vfs_kern_mount fs/namespace.c:2509 [inline]
>  do_new_mount fs/namespace.c:2512 [inline]
>  do_mount+0xea4/0x2bb0 fs/namespace.c:2842
>  SYSC_mount fs/namespace.c:3058 [inline]
>  SyS_mount+0xab/0x120 fs/namespace.c:3035
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> 
> The buggy address belongs to the object at ffff8801b1668e80
>  which belongs to the cache kmalloc-4096 of size 4096
> The buggy address is located 976 bytes inside of
>  4096-byte region [ffff8801b1668e80, ffff8801b1669e80)
> The buggy address belongs to the page:
> page:ffffea0006c59a00 count:1 mapcount:0 mapping:ffff8801b1668e80
> index:0x0 compound_mapcount: 0
> flags: 0x2fffc0000008100(slab|head)
> raw: 02fffc0000008100 ffff8801b1668e80 0000000000000000 0000000100000001
> raw: ffffea0006c5a2a0 ffffea0006cc47a0 ffff8801dac00dc0 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff8801b1669100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b1669180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8801b1669200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                  ^
>  ffff8801b1669280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801b1669300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> 
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug
> is merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new
> bug report.
> Note: all commands must start from beginning of the line in the email body.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
