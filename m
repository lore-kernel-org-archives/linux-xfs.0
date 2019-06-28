Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43878 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbfF1O0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 10:26:32 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 84CD028517
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 14:26:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204015] New: BUG: KASAN: slab-out-of-bounds in
 __bio_add_page+0x1ec/0x2b0
Date: Fri, 28 Jun 2019 14:26:29 +0000
Message-ID: <bug-204015-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204015

            Bug ID: 204015
           Summary: BUG: KASAN: slab-out-of-bounds in
                    __bio_add_page+0x1ec/0x2b0
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.2.0-rc4 with xfs-5.3-merge-2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Block Layer
          Assignee: axboe@kernel.dk
          Reporter: zlang@redhat.com
                CC: filesystem_xfs@kernel-bugs.kernel.org
        Regression: No

I think a kasan warning several times when I built and installed 5.2-rc4
kernel. CC XFS developers to check if XFS is related.

[   30.072839] SGI XFS with ACLs, security attributes, verbose warnings, no
debug enabled 
[   30.141472] XFS (sda7): Mounting V5 Filesystem 
[   30.307363] XFS (sda7): Ending clean mount 
[   30.327331]
================================================================== 
[   30.360891] BUG: KASAN: slab-out-of-bounds in __bio_add_page+0x1ec/0x2b0 
[   30.391947] Write of size 4 at addr ffff8880321ddccc by task mount/748 
[   30.421680]  
[   30.428399] CPU: 7 PID: 748 Comm: mount Not tainted 5.2.0-rc4+ #1 
[   30.456331] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013 
[   30.486318] Call Trace: 
[   30.497284]  dump_stack+0x7c/0xc0 
[   30.512213]  ? __bio_add_page+0x1ec/0x2b0 
[   30.530389]  print_address_description+0x65/0x22e 
[   30.551533]  ? __bio_add_page+0x1ec/0x2b0 
[   30.569509]  ? __bio_add_page+0x1ec/0x2b0 
[   30.587526]  __kasan_report.cold.3+0x37/0x77 
[   30.607785]  ? __bio_add_page+0x1ec/0x2b0 
[   30.625952]  kasan_report+0xe/0x20 
[   30.641188]  __bio_add_page+0x1ec/0x2b0 
[   30.658950]  bio_add_page+0x96/0xb0 
[   30.674878]  xlog_write_iclog+0x4de/0x8e0 [xfs] 
[   30.695564]  xlog_state_release_iclog+0x1d6/0x2e0 [xfs] 
[   30.719506]  ? do_raw_spin_unlock+0x54/0x220 
[   30.738973]  xfs_log_write_unmount_record+0x223/0x7b0 [xfs] 
[   30.764214]  ? xfs_log_reserve+0xaa0/0xaa0 [xfs] 
[   30.785399]  ? sched_clock+0x5/0x10 
[   30.801308]  ? __lock_acquire+0x58d/0x2be0 
[   30.821886]  ? sched_clock+0x5/0x10 
[   30.838540]  ? sched_clock_cpu+0x18/0x170 
[   30.858708]  ? do_raw_spin_unlock+0x54/0x220 
[   30.878314]  ? _raw_spin_unlock+0x24/0x30 
[   30.896358]  ? xfs_log_force+0x8c4/0xc30 [xfs] 
[   30.916744]  ? xlog_commit_record+0x1a0/0x1a0 [xfs] 
[   30.939319]  ? xfs_log_quiesce+0x148/0x570 [xfs] 
[   30.960148]  ? rcu_read_lock_sched_held+0x114/0x130 
[   30.982293]  xfs_log_quiesce+0x375/0x570 [xfs] 
[   31.002708]  ? xfs_log_write_unmount_record+0x7b0/0x7b0 [xfs] 
[   31.028934]  ? xfs_cowblocks_worker+0x40/0x40 [xfs] 
[   31.050933]  xfs_mountfs+0x1385/0x1890 [xfs] 
[   31.070237]  ? xfs_default_resblks+0x60/0x60 [xfs] 
[   31.091730]  ? module_assert_mutex_or_preempt+0x41/0x70 
[   31.116538]  ? __module_address+0x3f/0x360 
[   31.135147]  ? xfs_filestream_get_ag+0x40/0x40 [xfs] 
[   31.157601]  ? is_module_address+0x11/0x20 
[   31.176822]  ? static_obj+0x2d/0x50 
[   31.192637]  ? lockdep_init_map+0x1dc/0x620 
[   31.211685]  ? xfs_filestream_get_ag+0x40/0x40 [xfs] 
[   31.234488]  ? xfs_mru_cache_create+0x34d/0x560 [xfs] 
[   31.257969]  xfs_fs_fill_super+0xb0e/0x13e0 [xfs] 
[   31.279666]  ? xfs_test_remount_options+0x80/0x80 [xfs] 
[   31.303804]  ? xfs_test_remount_options+0x80/0x80 [xfs] 
[   31.327825]  mount_bdev+0x26e/0x330 
[   31.343785]  ? xfs_finish_flags+0x310/0x310 [xfs] 
[   31.365424]  legacy_get_tree+0x101/0x1f0 
[   31.383731]  vfs_get_tree+0x89/0x350 
[   31.399799]  do_mount+0xe78/0x15c0 
[   31.415070]  ? copy_mount_string+0x20/0x20 
[   31.433508]  ? lock_downgrade+0x620/0x620 
[   31.452013]  ? _copy_from_user+0x93/0xd0 
[   31.469783]  ? memdup_user+0x4b/0x70 
[   31.486122]  ksys_mount+0xb6/0xd0 
[   31.501100]  __x64_sys_mount+0xba/0x150 
[   31.518965]  ? lockdep_hardirqs_on+0x37f/0x560 
[   31.539285]  do_syscall_64+0x9f/0x4d0 
[   31.555741]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[   31.578634] RIP: 0033:0x7fcb735d9fce 
[   31.594282] Code: 48 8b 0d bd fe 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 8a fe 2b 00 f7 d8 64 89 01 48 
[   31.680795] RSP: 002b:00007ffc8aaed448 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5 
[   31.715737] RAX: ffffffffffffffda RBX: 0000559c77156ef0 RCX:
00007fcb735d9fce 
[   31.748298] RDX: 0000559c77165f30 RSI: 0000559c771570d0 RDI:
0000559c77158dd0 
[   31.780803] RBP: 00007fcb74385184 R08: 0000000000000000 R09:
0000000000000000 
[   31.813645] R10: 00000000c0ed0001 R11: 0000000000000246 R12:
0000000000000000 
[   31.846394] R13: 00000000c0ed0001 R14: 0000559c77158dd0 R15:
0000559c77165f30 
[   31.878830]  
[   31.885488] Allocated by task 748: 
[   31.901122]  save_stack+0x19/0x80 
[   31.916029]  __kasan_kmalloc.constprop.6+0xc1/0xd0 
[   31.937991]  __kmalloc+0x14e/0x310 
[   31.953270]  kmem_alloc+0x5e/0x130 [xfs] 
[   31.971366]  xlog_alloc_log+0xc87/0x12e0 [xfs] 
[   31.991876]  xfs_log_mount+0xa2/0x650 [xfs] 
[   32.010721]  xfs_mountfs+0xb5e/0x1890 [xfs] 
[   32.030045]  xfs_fs_fill_super+0xb0e/0x13e0 [xfs] 
[   32.051336]  mount_bdev+0x26e/0x330 
[   32.067054]  legacy_get_tree+0x101/0x1f0 
[   32.084747]  vfs_get_tree+0x89/0x350 
[   32.100777]  do_mount+0xe78/0x15c0 
[   32.116054]  ksys_mount+0xb6/0xd0 
[   32.130906]  __x64_sys_mount+0xba/0x150 
[   32.148949]  do_syscall_64+0x9f/0x4d0 
[   32.165364]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[   32.188633]  
[   32.195288] Freed by task 346: 
[   32.209418]  save_stack+0x19/0x80 
[   32.224277]  __kasan_slab_free+0x125/0x170 
[   32.243142]  kfree+0xfa/0x2d0 
[   32.256474]  rfc4106_set_hash_subkey+0xb3/0xe0 
[   32.277138]  
[   32.283789] The buggy address belongs to the object at ffff8880321dda00 
[   32.283789]  which belongs to the cache kmalloc-1k of size 1024 
[   32.340980] The buggy address is located 716 bytes inside of 
[   32.340980]  1024-byte region [ffff8880321dda00, ffff8880321dde00) 
[   32.395443] The buggy address belongs to the page: 
[   32.416986] page:ffffea0000c87600 refcount:1 mapcount:0
mapping:ffff888105016400 index:0x0 compound_mapcount: 0 
[   32.463287] flags: 0xfffffc0010200(slab|head) 
[   32.483036] raw: 000fffffc0010200 dead000000000100 dead000000000200
ffff888105016400 
[   32.518755] raw: 0000000000000000 00000000801c001c 00000001ffffffff
0000000000000000 
[   32.553632] page dumped because: kasan: bad access detected 
[   32.579437]  
[   32.586214] Memory state around the buggy address: 
[   32.607839]  ffff8880321ddb80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 
[   32.640419]  ffff8880321ddc00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 
[   32.674436] >ffff8880321ddc80: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
fc 
[   32.707277]                                               ^ 
[   32.732585]  ffff8880321ddd00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
fc 
[   32.765431]  ffff8880321ddd80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
fc 
[   32.798577]
================================================================== 
[   32.831699] Disabling lock debugging due to kernel taint 
[   32.858427] random: crng init done 
[   32.874609] random: 7 urandom warning(s) missed due to ratelimiting 
[   32.907093] mount (748) used greatest stack depth: 24680 bytes left

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
