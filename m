Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079A6C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 02:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D673561075
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 02:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhJ2CXv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhJ2CXv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Oct 2021 22:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85A1661165
        for <linux-xfs@vger.kernel.org>; Fri, 29 Oct 2021 02:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635474083;
        bh=7vA7GdFW80wPg5v10fYPZNiDe6YLVZFMVr2Xnt8LMLE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UhZxFWmpiijnOV4NhMuQn8wstZ71CUveEx4cR5NlIQB0DXhHSqVnwofuIFF8ldrO0
         eG84eoOhBgtxxK7cYVOEag909vXI+JGg6dNezYnUgdcFlBtQLQTw9KEVzybW4Ya3un
         lvG1UfLFrqeM090a/Mr6vjnzEE8GkUNhJqSv3aVzcRiKQZLxhI+EtlVExTiK/t91uX
         XsyWrthEq0pfZwFGNOcS+h2M2BCoiWjCIHFhcXlFAsITi/Hqd8y+2PH8WChmbQEZsJ
         5e5yXIDCkXyEWZXDSHzDTJK/LRmy8PzxvBMzz/fpBnQ51N7ZvEb40QM5mGdsoKVtrH
         XCMw9D/DP22zA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Fri, 29 Oct 2021 02:21:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pedram.fard@appian.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214767-201763-2S5R4pWO3a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

Pedram Fard (pedram.fard@appian.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pedram.fard@appian.com

--- Comment #13 from Pedram Fard (pedram.fard@appian.com) ---
We have run into a similar issue. We use xfs_freeze to take backup snapshot=
s of
our filesystems and occasionally, in the process the xfs_freeze/thaw process
turns into zombies.
We used the echo w > /proc/sysrq-trigger to get the stack trace:

[736826.666940] task:kswapd0         state:D stack:    0 pid:  576 ppid:   =
  2
flags:0x00004000
[736826.674439] Call Trace:
[736826.677686]  __schedule+0x1f9/0x660
[736826.681593]  schedule+0x46/0xb0
[736826.685141]  percpu_rwsem_wait+0xa9/0x180
[736826.688867]  ? percpu_free_rwsem+0x30/0x30
[736826.692764]  __percpu_down_read+0x49/0x60
[736826.696549]  xfs_trans_alloc+0x15d/0x170
[736826.700367]  xfs_free_eofblocks+0x130/0x1e0
[736826.807546]  xfs_fs_destroy_inode+0xa8/0x1b0
[736826.811610]  destroy_inode+0x3b/0x70
[736826.815150]  dispose_list+0x48/0x60
[736826.818796]  prune_icache_sb+0x54/0x80
[736826.822476]  super_cache_scan+0x161/0x1e0
[736826.826341]  do_shrink_slab+0x145/0x240
[736826.830294]  shrink_slab_memcg+0xcd/0x1e0
[736826.834371]  shrink_node_memcgs+0x186/0x1c0
[736826.838491]  shrink_node+0x14f/0x570
[736826.842088]  balance_pgdat+0x232/0x510
[736826.845820]  kswapd+0xe2/0x170
[736826.849154]  ? balance_pgdat+0x510/0x510
[736826.852944]  kthread+0x11b/0x140
[736826.856326]  ? __kthread_bind_mask+0x60/0x60
[736826.860313]  ret_from_fork+0x22/0x30

[736826.863839] task:systemd-logind  state:D stack:    0 pid: 2073 ppid:   =
  1
flags:0x00000084
[736826.871453] Call Trace:
[736826.874898]  __schedule+0x1f9/0x660
[736826.878898]  ? kvm_sched_clock_read+0xd/0x20
[736826.883265]  schedule+0x46/0xb0
[736826.887003]  rwsem_down_write_slowpath+0x234/0x4b0
[736826.891114]  ? __kmalloc+0x154/0x2b0
[736826.894794]  prealloc_shrinker+0x4c/0xf0
[736826.898526]  alloc_super+0x29a/0x2f0
[736826.902210]  ? set_anon_super+0x40/0x40
[736826.905867]  sget_fc+0x6c/0x240
[736826.909206]  ? shmem_create+0x20/0x20
[736826.912912]  get_tree_nodev+0x23/0xb0
[736826.916533]  ? bpf_lsm_capset+0x10/0x10
[736826.920310]  vfs_get_tree+0x25/0xb0
[736826.923848]  do_new_mount+0x152/0x1b0
[736826.927548]  __x64_sys_mount+0x103/0x140
[736826.931531]  do_syscall_64+0x33/0x40
[736826.935597]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[736826.940323] RIP: 0033:0x7f49f8efcdba
[736826.944298] RSP: 002b:00007ffdb98f2658 EFLAGS: 00000202 ORIG_RAX:
00000000000000a5
[736826.952238] RAX: ffffffffffffffda RBX: 000055f21a7113a0 RCX:
00007f49f8efcdba
[736826.959940] RDX: 000055f218672af0 RSI: 000055f21a721de0 RDI:
000055f218672af0
[736826.967721] RBP: 00007ffdb98f2690 R08: 000055f21a7a51e0 R09:
0000000000000000
[736826.975503] R10: 0000000000000006 R11: 0000000000000202 R12:
0000000000000000
[736826.983253] R13: 00007ffdb98f2740 R14: 00007ffdb98f2820 R15:
0000000000000000

[736826.990979] task:dockerd         state:D stack:    0 pid: 6639 ppid:   =
  1
flags:0x00000080
[736826.999289] Call Trace:
[736827.002695]  __schedule+0x1f9/0x660
[736827.006708]  schedule+0x46/0xb0
[736827.010512]  rwsem_down_write_slowpath+0x234/0x4b0
[736827.015214]  ? __kmalloc+0x154/0x2b0
[736827.019291]  prealloc_shrinker+0x4c/0xf0
[736827.023495]  alloc_super+0x29a/0x2f0
[736827.027505]  sget+0x91/0x220
[736827.031089]  ? destroy_super_rcu+0x40/0x40
[736827.035268]  ? ovl_get_lowerstack+0x190/0x190 [overlay]
[736827.040172]  mount_nodev+0x26/0x90
[736827.044070]  legacy_get_tree+0x27/0x40
[736827.048169]  vfs_get_tree+0x25/0xb0
[736827.052088]  do_new_mount+0x152/0x1b0
[736827.056076]  __x64_sys_mount+0x103/0x140
[736827.060176]  do_syscall_64+0x33/0x40
[736827.064158]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[736827.068950] RIP: 0033:0x55c5416cc2aa
[736827.072915] RSP: 002b:000000c0015b2768 EFLAGS: 00000216 ORIG_RAX:
00000000000000a5
[736827.080676] RAX: ffffffffffffffda RBX: 000000c00005e800 RCX:
000055c5416cc2aa
[736827.088375] RDX: 000000c000df5320 RSI: 000000c0012db140 RDI:
000000c000df52e8
[736827.095311] RBP: 000000c0015b2800 R08: 000000c0015a0600 R09:
0000000000000000
[736827.102300] R10: 0000000000000000 R11: 0000000000000216 R12:
0000000000000133
[736827.109100] R13: 0000000000000132 R14: 0000000000000200 R15:
0000000000000055


[737030.525416] task:sh              state:D stack:    0 pid:27526 ppid: 27=
517
flags:0x00000080
[737030.532905] Call Trace:
[737030.536188]  __schedule+0x1f9/0x660
[737030.540060]  schedule+0x46/0xb0
[737030.543385]  percpu_rwsem_wait+0xa9/0x180
[737030.547220]  ? percpu_free_rwsem+0x30/0x30
[737030.551093]  __percpu_down_read+0x49/0x60
[737030.555220]  mnt_want_write+0x66/0x90
[737030.558966]  open_last_lookups+0x30d/0x3f0
[737030.562914]  ? path_init+0x2bd/0x3e0
[737030.681735]  path_openat+0x88/0x1d0
[737030.685600]  ? xfs_iunlock+0x94/0xe0
[737030.689575]  do_filp_open+0x88/0x130
[737030.693496]  ? __check_object_size.part.0+0x11f/0x140
[737030.698201]  do_sys_openat2+0x97/0x150
[737030.702232]  __x64_sys_openat+0x54/0x90
[737030.706301]  do_syscall_64+0x33/0x40
[737030.710248]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[737030.714945] RIP: 0033:0x7f4502c0d14e
[737030.718849] RSP: 002b:00007ffd066be7a0 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[737030.726628] RAX: ffffffffffffffda RBX: 00000000009ba360 RCX:
00007f4502c0d14e
[737030.734177] RDX: 0000000000000241 RSI: 00000000009bb8c0 RDI:
ffffffffffffff9c
[737030.741759] RBP: 00007ffd066be8a0 R08: 0000000000000020 R09:
00000000009bb8c0
[737030.749452] R10: 00000000000001b6 R11: 0000000000000246 R12:
0000000000000000
[737030.757142] R13: 0000000000000001 R14: 0000000000000001 R15:
00000000009bad60
[737030.764836] task:bash            state:D stack:    0 pid:27580 ppid:   =
  1
flags:0x00000084
[737030.773068] Call Trace:
[737030.776437]  __schedule+0x1f9/0x660
[737030.780354]  schedule+0x46/0xb0
[737030.784080]  percpu_rwsem_wait+0xa9/0x180
[737030.788264]  ? percpu_free_rwsem+0x30/0x30
[737030.792476]  __percpu_down_read+0x49/0x60
[737030.796642]  mnt_want_write+0x66/0x90
[737030.800660]  open_last_lookups+0x30d/0x3f0
[737030.804923]  ? path_init+0x2bd/0x3e0
[737030.808895]  path_openat+0x88/0x1d0
[737030.812800]  ? xfs_iunlock+0x94/0xe0
[737030.816745]  do_filp_open+0x88/0x130
[737030.820694]  ? getname_flags.part.0+0x29/0x1a0
[737030.825097]  ? __check_object_size.part.0+0x11f/0x140
[737030.829846]  ? audit_alloc_name+0x8c/0xe0
[737030.834010]  do_sys_openat2+0x97/0x150
[737030.838056]  __x64_sys_openat+0x54/0x90
[737030.842164]  do_syscall_64+0x33/0x40
[737030.846146]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[737030.850855] RIP: 0033:0x7f2072a9414e
[737030.854822] RSP: 002b:00007ffd855832e0 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[737030.862655] RAX: ffffffffffffffda RBX: 000000000178aab0 RCX:
00007f2072a9414e
[737030.870259] RDX: 0000000000000241 RSI: 000000000178af20 RDI:
ffffffffffffff9c
[737030.877820] RBP: 00007ffd855833e0 R08: 0000000000000020 R09:
000000000178af20
[737030.885463] R10: 00000000000001b6 R11: 0000000000000246 R12:
0000000000000000
[737030.893083] R13: 0000000000000003 R14: 0000000000000001 R15:
000000000178aa60

[736992.593491] task:k               state:D stack:    0 pid:11166 ppid: 29=
014
flags:0x00000184
[736992.600911] Call Trace:
[736992.604234]  __schedule+0x1f9/0x660
[736992.607842]  schedule+0x46/0xb0
[736992.611295]  percpu_rwsem_wait+0xa9/0x180
[736992.614999]  ? percpu_free_rwsem+0x30/0x30
[736992.618901]  __percpu_down_read+0x49/0x60
[736992.622614]  mnt_want_write+0x66/0x90
[736992.626323]  open_last_lookups+0x30d/0x3f0
[736992.630064]  ? path_init+0x2bd/0x3e0
[736992.633795]  path_openat+0x88/0x1d0
[736992.637360]  do_filp_open+0x88/0x130
[736992.640911]  ? getname_flags.part.0+0x29/0x1a0
[736992.645006]  ? __check_object_size.part.0+0x11f/0x140
[736992.649268]  ? audit_alloc_name+0x8c/0xe0
[736992.653173]  do_sys_openat2+0x97/0x150
[736992.656832]  __x64_sys_openat+0x54/0x90
[736992.660619]  do_syscall_64+0x33/0x40
[736992.664181]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[736992.668543] RIP: 0033:0x7f81dc2d11ae
[736992.672208] RSP: 002b:00007ffcff615c00 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[736992.679509] RAX: ffffffffffffffda RBX: 0000000000000002 RCX:
00007f81dc2d11ae
[736992.686481] RDX: 0000000000000042 RSI: 00007f81d757e6b8 RDI:
00000000ffffff9c
[736992.693723] RBP: 00007f81d7ba14c4 R08: 000000000000003a R09:
0000000000000000
[736992.700684] R10: 00000000000001b6 R11: 0000000000000246 R12:
00007f81d757e6b8
[736992.708136] R13: 00007f81d7ba14c4 R14: 00007f81dbfb45b8 R15:
00007f81d7f3f8fc


[736992.715824] task:k               state:D stack:    0 pid:11273 ppid: 29=
014
flags:0x00000184
[736992.724256] Call Trace:
[736992.727698]  __schedule+0x1f9/0x660
[736992.731616]  schedule+0x46/0xb0
[736992.735367]  percpu_rwsem_wait+0xa9/0x180
[736992.739512]  ? percpu_free_rwsem+0x30/0x30
[736992.743681]  __percpu_down_read+0x49/0x60
[736992.747837]  mnt_want_write+0x66/0x90
[736992.751896]  open_last_lookups+0x30d/0x3f0
[736992.756191]  ? path_init+0x2bd/0x3e0
[736992.760175]  path_openat+0x88/0x1d0
[736992.764055]  do_filp_open+0x88/0x130
[736992.768115]  ? getname_flags.part.0+0x29/0x1a0
[736992.772563]  ? __check_object_size.part.0+0x11f/0x140
[736992.777391]  ? audit_alloc_name+0x8c/0xe0
[736992.781658]  do_sys_openat2+0x97/0x150
[736992.785794]  __x64_sys_openat+0x54/0x90
[736992.789856]  do_syscall_64+0x33/0x40
[736992.793913]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[736992.798746] RIP: 0033:0x7fb7d337f1ae
[736992.802878] RSP: 002b:00007ffd9b2dbda0 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[736992.810824] RAX: ffffffffffffffda RBX: 0000000000000002 RCX:
00007fb7d337f1ae
[736992.818496] RDX: 0000000000000042 RSI: 00007fb7d2e2aa88 RDI:
00000000ffffff9c
[736992.826359] RBP: 00007fb7cecdc7dc R08: 0000000000000008 R09:
0000000000000000
[736992.833753] R10: 00000000000001b6 R11: 0000000000000246 R12:
00007fb7d2e2aa88
[736992.840727] R13: 00007fb7d2e2aa7c R14: 00007fb7d3150920 R15:
0000000000000004


[736992.847580] task:tail            state:D stack:    0 pid:11608 ppid:  9=
603
flags:0x00004186
[736992.855146] Call Trace:
[736992.858238]  __schedule+0x1f9/0x660
[736992.861943]  schedule+0x46/0xb0
[736992.865387]  percpu_rwsem_wait+0xa9/0x180
[736992.869138]  ? percpu_free_rwsem+0x30/0x30
[736992.873134]  __percpu_down_read+0x49/0x60
[736992.876948]  xfs_trans_alloc+0x15d/0x170
[736992.880854]  xfs_free_eofblocks+0x130/0x1e0
[736992.885085]  xfs_release+0x13d/0x160
[736992.888807]  __fput+0x96/0x240
[736992.892138]  task_work_run+0x5f/0x90
[736992.895834]  do_exit+0x22c/0x3b0
[736992.899189]  ? timerqueue_del+0x1e/0x40
[736992.902967]  do_group_exit+0x33/0xa0
[736992.906469]  get_signal+0x15d/0x5b0
[736993.013638]  arch_do_signal+0x25/0xf0
[736993.017223]  exit_to_user_mode_loop+0x8d/0xc0
[736993.021148]  exit_to_user_mode_prepare+0x6a/0x70
[736993.025371]  syscall_exit_to_user_mode+0x22/0x140
[736993.029417]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[736993.033852] RIP: 0033:0x7f907725e6f4
[736993.037391] RSP: 002b:00007ffcf7722f38 EFLAGS: 00000246 ORIG_RAX:
0000000000000023
[736993.044403] RAX: fffffffffffffdfc RBX: 0000000000000001 RCX:
00007f907725e6f4
[736993.051384] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
00007ffcf7722f40
[736993.058190] RBP: 0000000000000000 R08: 00007ffcf7723070 R09:
00007f9077312e80
[736993.065109] R10: 0000000000000000 R11: 0000000000000246 R12:
00007ffcf7722f40
[736993.071934] R13: 00007ffcf77256bf R14: 0000560396137440 R15:
0000000000000000


[736996.659414] task:process-exporte state:D stack:    0 pid:30396 ppid:  2=
204
flags:0x00004082
[736996.666720] Call Trace:
[736996.669864]  __schedule+0x1f9/0x660
[736996.673371]  schedule+0x46/0xb0
[736996.676730]  rwsem_down_write_slowpath+0x234/0x4b0
[736996.680991]  unregister_memcg_shrinker.isra.0+0x18/0x40
[736996.685377]  unregister_shrinker+0x7b/0x80
[736996.689295]  deactivate_locked_super+0x29/0xa0
[736996.693241]  cleanup_mnt+0x12d/0x190
[736996.696912]  task_work_run+0x5f/0x90
[736996.700444]  do_exit+0x22c/0x3b0
[736996.703996]  do_group_exit+0x33/0xa0
[736996.707581]  get_signal+0x15d/0x5b0
[736996.711191]  arch_do_signal+0x25/0xf0
[736996.714771]  exit_to_user_mode_loop+0x8d/0xc0
[736996.718759]  exit_to_user_mode_prepare+0x6a/0x70
[736996.722740]  syscall_exit_to_user_mode+0x22/0x140
[736996.726869]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[736996.835174] RIP: 0033:0x4a2c50
[736996.838687] RSP: 002b:000000c000213798 EFLAGS: 00000216 ORIG_RAX:
0000000000000000
[736996.845651] RAX: 0000000000000200 RBX: 000000c000032500 RCX:
00000000004a2c50
[736996.852636] RDX: 0000000000000200 RSI: 000000c0008ef600 RDI:
0000000000000005
[736996.859446] RBP: 000000c0002137e8 R08: 0000000000000000 R09:
0000000000000000
[736996.866347] R10: 0000000000000000 R11: 0000000000000216 R12:
ffffffffffffffff
[736996.873124] R13: 000000000000000c R14: 000000000000000b R15:
0000000000000010

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
