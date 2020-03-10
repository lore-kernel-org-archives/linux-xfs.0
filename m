Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977B8C18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 09:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B372467F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 09:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgCJJ0P convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgCJJ0O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Mar 2020 05:26:14 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206807] New: [xfstests generic/053]: WARNING: possible circular
 locking between fs_reclaim_acquire.part and xfs_ilock_attr_map_shared
Date:   Tue, 10 Mar 2020 09:26:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206807-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206807

            Bug ID: 206807
           Summary: [xfstests generic/053]: WARNING: possible circular
                    locking between fs_reclaim_acquire.part and
                    xfs_ilock_attr_map_shared
           Product: File System
           Version: 2.5
    Kernel Version: xfs-5.7-merge-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests generic/053 always hit below warning. I'm not sure if it's a real
issue, just due to it can be reproduced easily. So report this bug to get more
xfs developer review.

[ 4237.682652] run fstests generic/053 at 2020-03-08 08:59:40
[ 4239.360186] XFS (sda3): Mounting V5 Filesystem
[ 4239.407716] XFS (sda3): Ending clean mount
[ 4239.419928] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[ 4240.158679] XFS (sda3): Unmounting Filesystem
[ 4240.571304] XFS (sda3): Mounting V5 Filesystem
[ 4240.599167] XFS (sda3): Ending clean mount
[ 4240.611047] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)

[ 4240.709666] ======================================================
[ 4240.715848] WARNING: possible circular locking dependency detected
[ 4240.722028] 5.6.0-rc4+ #1 Not tainted
[ 4240.725685] ------------------------------------------------------
[ 4240.731863] chacl/376734 is trying to acquire lock:
[ 4240.736733] ffffffff86ad3920 (fs_reclaim){+.+.}, at:
fs_reclaim_acquire.part.55+0x5/0x30
[ 4240.744846] 
               but task is already holding lock:
[ 4240.750668] ffff88800cedf8f0 (&xfs_nondir_ilock_class){++++}, at:
xfs_ilock_attr_map_shared+0x4c/0xd0 [xfs]
[ 4240.760457] 
               which lock already depends on the new lock.

[ 4240.768635] 
               the existing dependency chain (in reverse order) is:
[ 4240.776116] 
               -> #1 (&xfs_nondir_ilock_class){++++}:
[ 4240.782412]        down_write_nested+0xa4/0x3c0
[ 4240.786986]        xfs_ilock+0x149/0x4c0 [xfs]
[ 4240.791460]        xfs_reclaim_inode+0xe4/0x9e0 [xfs]
[ 4240.796558]        xfs_reclaim_inodes_ag+0x50a/0xb10 [xfs]
[ 4240.802077]        xfs_reclaim_inodes_nr+0x92/0xd0 [xfs]
[ 4240.807370]        super_cache_scan+0x302/0x430
[ 4240.811909]        do_shrink_slab+0x31c/0x9b0
[ 4240.816256]        shrink_slab+0x3ad/0x4e0
[ 4240.820378]        shrink_node+0x3d8/0x16b0
[ 4240.824560]        balance_pgdat+0x5ba/0xf10
[ 4240.828843]        kswapd+0x528/0xc30
[ 4240.832507]        kthread+0x333/0x3f0
[ 4240.836250]        ret_from_fork+0x3a/0x50
[ 4240.840374] 
               -> #0 (fs_reclaim){+.+.}:
[ 4240.845499]        __lock_acquire+0x23f7/0x4030
[ 4240.850026]        lock_acquire+0x15a/0x3d0
[ 4240.854200]        fs_reclaim_acquire.part.55+0x29/0x30
[ 4240.859411]        slab_pre_alloc_hook+0x14/0x80
[ 4240.864033]        __kmalloc+0x58/0x380
[ 4240.867939]        kmem_alloc+0xf0/0x3e0 [xfs]
[ 4240.872419]        kmem_alloc_large+0x9f/0x2e0 [xfs]
[ 4240.877405]        xfs_attr_copy_value+0x134/0x200 [xfs]
[ 4240.882750]        xfs_attr_get+0x373/0x4f0 [xfs]
[ 4240.887508]        xfs_get_acl+0x192/0x510 [xfs]
[ 4240.892132]        get_acl+0x10e/0x260
[ 4240.895896]        posix_acl_xattr_get+0xc6/0x1b0
[ 4240.900597]        __vfs_getxattr+0xbb/0x110
[ 4240.904849]        vfs_getxattr+0x185/0x1b0
[ 4240.909038]        getxattr+0xea/0x220
[ 4240.912809]        path_getxattr+0xae/0x110
[ 4240.916985]        do_syscall_64+0x9f/0x4f0
[ 4240.921150]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4240.926722] 
               other info that might help us debug this:

[ 4240.934729]  Possible unsafe locking scenario:

[ 4240.940676]        CPU0                    CPU1
[ 4240.945211]        ----                    ----
[ 4240.949733]   lock(&xfs_nondir_ilock_class);
[ 4240.954041]                                lock(fs_reclaim);
[ 4240.959721]                                lock(&xfs_nondir_ilock_class);
[ 4240.966500]   lock(fs_reclaim);
[ 4240.969640] 
                *** DEADLOCK ***

[ 4240.975543] 1 lock held by chacl/376734:
[ 4240.979461]  #0: ffff88800cedf8f0 (&xfs_nondir_ilock_class){++++}, at:
xfs_ilock_attr_map_shared+0x4c/0xd0 [xfs]
[ 4240.989667] 
               stack backtrace:
[ 4240.994042] CPU: 2 PID: 376734 Comm: chacl Not tainted 5.6.0-rc4+ #1
[ 4241.000409] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver.
01.21 03/02/2016
[ 4241.008674] Call Trace:
[ 4241.011127]  dump_stack+0x96/0xe0
[ 4241.014474]  check_noncircular+0x354/0x410
[ 4241.018586]  ? sched_clock_cpu+0x18/0x1d0
[ 4241.022591]  ? print_circular_bug+0x1e0/0x1e0
[ 4241.026983]  ? __lock_acquire+0xf64/0x4030
[ 4241.031064]  ? perf_trace_lock_acquire+0x5c0/0x5c0
[ 4241.035849]  ? sched_clock+0x5/0x10
[ 4241.039345]  ? sched_clock+0x5/0x10
[ 4241.042860]  __lock_acquire+0x23f7/0x4030
[ 4241.046899]  ? __lock_acquire+0xf64/0x4030
[ 4241.051002]  ? lockdep_hardirqs_on+0x590/0x590
[ 4241.055476]  lock_acquire+0x15a/0x3d0
[ 4241.059140]  ? fs_reclaim_acquire.part.55+0x5/0x30
[ 4241.063987]  ? kmem_alloc+0xf0/0x3e0 [xfs]
[ 4241.068072]  fs_reclaim_acquire.part.55+0x29/0x30
[ 4241.072766]  ? fs_reclaim_acquire.part.55+0x5/0x30
[ 4241.077564]  slab_pre_alloc_hook+0x14/0x80
[ 4241.081672]  __kmalloc+0x58/0x380
[ 4241.085036]  kmem_alloc+0xf0/0x3e0 [xfs]
[ 4241.089017]  ? kmem_alloc_large+0x9f/0x2e0 [xfs]
[ 4241.093637]  ? rcu_read_lock_bh_held+0xd0/0xd0
[ 4241.098123]  kmem_alloc_large+0x9f/0x2e0 [xfs]
[ 4241.102588]  ? xfs_attr_copy_value+0x134/0x200 [xfs]
[ 4241.107590]  xfs_attr_copy_value+0x134/0x200 [xfs]
[ 4241.112412]  xfs_attr_get+0x373/0x4f0 [xfs]
[ 4241.116628]  xfs_get_acl+0x192/0x510 [xfs]
[ 4241.120725]  ? rcu_read_lock_held+0xaf/0xc0
[ 4241.124987]  ? xfs_acl_from_disk+0x550/0x550 [xfs]
[ 4241.129769]  get_acl+0x10e/0x260
[ 4241.133002]  posix_acl_xattr_get+0xc6/0x1b0
[ 4241.137203]  __vfs_getxattr+0xbb/0x110
[ 4241.140947]  ? __vfs_setxattr+0x130/0x130
[ 4241.144977]  vfs_getxattr+0x185/0x1b0
[ 4241.148660]  ? __kasan_kmalloc.constprop.7+0xc1/0xd0
[ 4241.153636]  ? xattr_permission+0x1f0/0x1f0
[ 4241.157846]  ? __kmalloc_node+0x134/0x2c0
[ 4241.161852]  ? strncpy_from_user+0x7d/0x350
[ 4241.166044]  getxattr+0xea/0x220
[ 4241.169287]  ? __ia32_sys_llistxattr+0xb0/0xb0
[ 4241.173721]  ? __kasan_kmalloc.constprop.7+0xc1/0xd0
[ 4241.178670]  ? strncpy_from_user+0x7d/0x350
[ 4241.182867]  ? kmem_cache_alloc+0x34a/0x380
[ 4241.187065]  ? getname_flags+0xf8/0x510
[ 4241.190899]  ? syscall_trace_enter+0x549/0xcf0
[ 4241.195333]  path_getxattr+0xae/0x110
[ 4241.199000]  ? getxattr+0x220/0x220
[ 4241.202493]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[ 4241.207116]  ? do_syscall_64+0x22/0x4f0
[ 4241.210954]  do_syscall_64+0x9f/0x4f0
[ 4241.214637]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4241.219686] RIP: 0033:0x7f04e21f1c5e
[ 4241.223290] Code: 73 01 c3 48 8b 0d 2a 22 2c 00 f7 d8 64 89 01 48 83 c8 ff
c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 49 89 ca b8 bf 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d fa 21 2c 00 f7 d8 64 89 01 48
[ 4241.242030] RSP: 002b:00007ffd876ecd58 EFLAGS: 00000246 ORIG_RAX:
00000000000000bf
[ 4241.249586] RAX: ffffffffffffffda RBX: 0000000000008000 RCX:
00007f04e21f1c5e
[ 4241.256722] RDX: 00007ffd876ecd60 RSI: 00007f04e26c61ef RDI:
00007ffd876ef351
[ 4241.263868] RBP: 00007ffd876eceb0 R08: 0000000000000000 R09:
0000000000000000
[ 4241.271033] R10: 0000000000000084 R11: 0000000000000246 R12:
00007ffd876ef351
[ 4241.278148] R13: 00007ffd876ecd60 R14: 00007f04e26c61ef R15:
0000000000000000
[ 4241.341907] XFS (sda2): Unmounting Filesystem
[ 4241.576470] XFS (sda3): Unmounting Filesystem
[ 4241.845011] XFS (sda3): Mounting V5 Filesystem
[ 4241.868871] XFS (sda3): Ending clean mount
[ 4241.878933] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[ 4241.897754] XFS (sda3): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
