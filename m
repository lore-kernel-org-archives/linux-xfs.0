Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51254 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbfA2Anq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 19:43:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C56492B4E2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 00:43:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 00:43:39 +0000
Message-ID: <bug-202441-201763-rG3F1A17Ag@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #4 from Roger (rogan6710@gmail.com) ---
"If all else fails, read the man page" ;)
The complete dmesg output is a litte bit too big for the 
system here. they only allow 65535 characters
Last Output:
[ 1831.904739] sysrq: SysRq : Show Blocked State
[ 1831.904745]   task                        PC stack   pid father
[ 1831.904752] kswapd0         D    0    85      2 0x80000000
[ 1831.904753] Call Trace:
[ 1831.904758]  ? __schedule+0x21d/0x840
[ 1831.904760]  schedule+0x28/0x80
[ 1831.904761]  schedule_preempt_disabled+0xa/0x10
[ 1831.904762]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.904806]  ? xfs_perag_get_tag+0x3d/0xe0 [xfs]
[ 1831.904830]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.904854]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.904876]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.904899]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.904901]  super_cache_scan+0x155/0x1a0
[ 1831.904903]  do_shrink_slab+0x128/0x290
[ 1831.904905]  shrink_slab+0x233/0x2b0
[ 1831.904907]  shrink_node+0xe6/0x460
[ 1831.904908]  kswapd+0x408/0x720
[ 1831.904909]  ? mem_cgroup_shrink_node+0x180/0x180
[ 1831.904911]  kthread+0x112/0x130
[ 1831.904912]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 1831.904913]  ret_from_fork+0x22/0x40
[ 1831.904930] xfsaild/sdc1    D    0  1446      2 0x80000000
[ 1831.904931] Call Trace:
[ 1831.904932]  ? __schedule+0x21d/0x840
[ 1831.904933]  schedule+0x28/0x80
[ 1831.904956]  xfs_log_force+0x166/0x2e0 [xfs]
[ 1831.904957]  ? wake_up_q+0x70/0x70
[ 1831.904981]  xfsaild+0x1b2/0x830 [xfs]
[ 1831.905005]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[ 1831.905006]  kthread+0x112/0x130
[ 1831.905007]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 1831.905008]  ret_from_fork+0x22/0x40
[ 1831.905012] Xorg            D    0  1496   1495 0x00000000
[ 1831.905013] Call Trace:
[ 1831.905014]  ? __schedule+0x21d/0x840
[ 1831.905015]  schedule+0x28/0x80
[ 1831.905016]  schedule_preempt_disabled+0xa/0x10
[ 1831.905017]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.905039]  ? xfs_perag_get_tag+0x3d/0xe0 [xfs]
[ 1831.905061]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.905084]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.905106]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.905128]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.905130]  super_cache_scan+0x155/0x1a0
[ 1831.905131]  do_shrink_slab+0x128/0x290
[ 1831.905132]  shrink_slab+0x233/0x2b0
[ 1831.905133]  shrink_node+0xe6/0x460
[ 1831.905135]  do_try_to_free_pages+0xc6/0x370
[ 1831.905136]  try_to_free_pages+0xf5/0x1c0
[ 1831.905137]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.905139]  ? enqueue_entity+0x36d/0x7e0
[ 1831.905140]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.905142]  kmalloc_order+0x14/0x40
[ 1831.905143]  kmalloc_order_trace+0x1e/0xa0
[ 1831.905198]  dc_create_state+0x19/0x30 [amdgpu]
[ 1831.905234]  amdgpu_dm_atomic_check+0xc6/0x3b0 [amdgpu]
[ 1831.905248]  drm_atomic_check_only+0x460/0x660 [drm]
[ 1831.905258]  ? drm_atomic_set_fb_for_plane+0x53/0x80 [drm]
[ 1831.905267]  drm_atomic_nonblocking_commit+0x13/0x50 [drm]
[ 1831.905276]  drm_atomic_helper_page_flip+0x5b/0x90 [drm_kms_helper]
[ 1831.905285]  drm_mode_page_flip_ioctl+0x553/0x5b0 [drm]
[ 1831.905294]  ? drm_mode_cursor2_ioctl+0x10/0x10 [drm]
[ 1831.905301]  drm_ioctl_kernel+0xa1/0xf0 [drm]
[ 1831.905310]  drm_ioctl+0x206/0x3a0 [drm]
[ 1831.905319]  ? drm_mode_cursor2_ioctl+0x10/0x10 [drm]
[ 1831.905347]  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
[ 1831.905349]  do_vfs_ioctl+0xa4/0x630
[ 1831.905351]  ? __x64_sys_futex+0x143/0x180
[ 1831.905352]  ksys_ioctl+0x60/0x90
[ 1831.905354]  __x64_sys_ioctl+0x16/0x20
[ 1831.905355]  do_syscall_64+0x55/0x100
[ 1831.905356]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.905358] RIP: 0033:0x7f87fd574d37
[ 1831.905361] Code: Bad RIP value.
[ 1831.905362] RSP: 002b:00007fff347ff238 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 1831.905363] RAX: ffffffffffffffda RBX: 0000000000bd9f10 RCX:
00007f87fd574d37
[ 1831.905364] RDX: 00007fff347ff270 RSI: 00000000c01864b0 RDI:
000000000000000e
[ 1831.905364] RBP: 00007fff347ff270 R08: 00000000000041ce R09:
0000000000000000
[ 1831.905365] R10: 00000000014cbb60 R11: 0000000000000246 R12:
00000000c01864b0
[ 1831.905366] R13: 000000000000000e R14: 0000000000000000 R15:
0000000000bd58e0
[ 1831.905380] mc              D    0  1866   1740 0x00000000
[ 1831.905381] Call Trace:
[ 1831.905382]  ? __schedule+0x21d/0x840
[ 1831.905383]  schedule+0x28/0x80
[ 1831.905384]  schedule_preempt_disabled+0xa/0x10
[ 1831.905385]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.905407]  ? xfs_perag_get_tag+0x3d/0xe0 [xfs]
[ 1831.905429]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.905431]  ? inode_lru_list_add+0x20/0x40
[ 1831.905432]  ? iput+0x16d/0x200
[ 1831.905455]  ? xfs_iunlock+0x61/0x110 [xfs]
[ 1831.905477]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.905499]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.905522]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.905523]  super_cache_scan+0x155/0x1a0
[ 1831.905524]  do_shrink_slab+0x128/0x290
[ 1831.905526]  shrink_slab+0x233/0x2b0
[ 1831.905527]  shrink_node+0xe6/0x460
[ 1831.905528]  do_try_to_free_pages+0xc6/0x370
[ 1831.905529]  try_to_free_pages+0xf5/0x1c0
[ 1831.905530]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.905531]  ? __switch_to_asm+0x34/0x70
[ 1831.905532]  ? __switch_to_asm+0x40/0x70
[ 1831.905533]  ? __switch_to_asm+0x34/0x70
[ 1831.905534]  ? __switch_to_asm+0x40/0x70
[ 1831.905535]  ? __switch_to_asm+0x34/0x70
[ 1831.905536]  ? __switch_to_asm+0x40/0x70
[ 1831.905537]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.905538]  __do_page_cache_readahead+0xb1/0x1b0
[ 1831.905539]  ondemand_readahead+0x1f9/0x2c0
[ 1831.905541]  generic_file_read_iter+0x738/0xc10
[ 1831.905542]  ? page_cache_tree_insert+0xe0/0xe0
[ 1831.905543]  nfs_file_read+0x5d/0x80
[ 1831.905546]  __vfs_read+0x133/0x190
[ 1831.905547]  vfs_read+0x8a/0x140
[ 1831.905548]  ksys_read+0x4f/0xb0
[ 1831.905549]  do_syscall_64+0x55/0x100
[ 1831.905551]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.905551] RIP: 0033:0x7fad0ffd9aae
[ 1831.905553] Code: Bad RIP value.
[ 1831.905553] RSP: 002b:00007ffc380b1bb8 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[ 1831.905554] RAX: ffffffffffffffda RBX: 00000000008ef9e0 RCX:
00007fad0ffd9aae
[ 1831.905555] RDX: 0000000000020000 RSI: 00000000008f7ec0 RDI:
000000000000000a
[ 1831.905555] RBP: 0000000000020000 R08: 0000000000000000 R09:
0000000000000000
[ 1831.905556] R10: 0000000000000008 R11: 0000000000000246 R12:
00000000008f7ec0
[ 1831.905556] R13: 0000000000000000 R14: 0000000199000000 R15:
00000000008d5b70
[ 1831.905574] kworker/u16:4   D    0 14955      2 0x80000000
[ 1831.905577] Workqueue: writeback wb_workfn (flush-8:32)
[ 1831.905578] Call Trace:
[ 1831.905579]  ? __schedule+0x21d/0x840
[ 1831.905580]  schedule+0x28/0x80
[ 1831.905581]  schedule_timeout+0x1d8/0x370
[ 1831.905603]  ? xfs_buf_read_map+0xc1/0x180 [xfs]
[ 1831.905604]  ? schedule+0x28/0x80
[ 1831.905606]  ? down_trylock+0x25/0x30
[ 1831.905607]  __down+0x7f/0xd0
[ 1831.905629]  ? xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.905630]  down+0x3b/0x50
[ 1831.905652]  xfs_buf_lock+0x32/0xf0 [xfs]
[ 1831.905675]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.905698]  xfs_buf_get_map+0x40/0x2c0 [xfs]
[ 1831.905720]  xfs_buf_read_map+0x28/0x180 [xfs]
[ 1831.905743]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.905764]  xfs_read_agf+0x94/0x120 [xfs]
[ 1831.905785]  xfs_alloc_read_agf+0x47/0x1b0 [xfs]
[ 1831.905805]  xfs_alloc_fix_freelist+0x377/0x430 [xfs]
[ 1831.905807]  ? __update_load_avg_cfs_rq+0x1b5/0x230
[ 1831.905808]  ? __alloc_pages_nodemask+0x13a/0x2c0
[ 1831.905809]  ? update_curr+0xba/0x1a0
[ 1831.905831]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.905851]  xfs_alloc_vextent+0x121/0x580 [xfs]
[ 1831.905871]  xfs_bmap_btalloc+0x420/0x890 [xfs]
[ 1831.905893]  xfs_bmapi_write+0x5f5/0xb80 [xfs]
[ 1831.905916]  xfs_iomap_write_allocate+0x176/0x380 [xfs]
[ 1831.905939]  xfs_map_blocks+0x186/0x450 [xfs]
[ 1831.905962]  xfs_do_writepage+0x123/0x440 [xfs]
[ 1831.905963]  write_cache_pages+0x1dd/0x470
[ 1831.905985]  ? xfs_vm_releasepage+0x80/0x80 [xfs]
[ 1831.905987]  ? genl_register_family+0xfa/0x610
[ 1831.905989]  ? __tcp_transmit_skb+0x58d/0xad0
[ 1831.906011]  xfs_vm_writepages+0x59/0x90 [xfs]
[ 1831.906012]  do_writepages+0x41/0xd0
[ 1831.906013]  ? __tcp_push_pending_frames+0x2d/0xa0
[ 1831.906014]  ? tcp_sendmsg_locked+0x509/0xd80
[ 1831.906015]  __writeback_single_inode+0x4a/0x380
[ 1831.906017]  writeback_sb_inodes+0x1d0/0x460
[ 1831.906018]  __writeback_inodes_wb+0x5d/0xb0
[ 1831.906019]  wb_writeback+0x263/0x310
[ 1831.906020]  ? get_nr_inodes+0x35/0x50
[ 1831.906021]  ? cpumask_next+0x16/0x20
[ 1831.906022]  wb_workfn+0x340/0x3f0
[ 1831.906024]  ? __switch_to_asm+0x40/0x70
[ 1831.906025]  process_one_work+0x1eb/0x420
[ 1831.906026]  worker_thread+0x2d/0x3d0
[ 1831.906027]  ? pwq_unbound_release_workfn+0xc0/0xc0
[ 1831.906028]  kthread+0x112/0x130
[ 1831.906029]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 1831.906030]  ret_from_fork+0x22/0x40
[ 1831.906033] make            D    0 25592  24315 0x00000000
[ 1831.906034] Call Trace:
[ 1831.906036]  ? __schedule+0x21d/0x840
[ 1831.906037]  schedule+0x28/0x80
[ 1831.906037]  rwsem_down_read_failed+0xe1/0x140
[ 1831.906039]  ? update_curr+0xba/0x1a0
[ 1831.906040]  call_rwsem_down_read_failed+0x14/0x30
[ 1831.906041]  down_read+0x1c/0x30
[ 1831.906042]  lookup_slow+0x27/0x50
[ 1831.906043]  walk_component+0x1bf/0x4a0
[ 1831.906045]  ? __switch_to_asm+0x40/0x70
[ 1831.906046]  ? __switch_to_asm+0x34/0x70
[ 1831.906047]  ? __switch_to_asm+0x40/0x70
[ 1831.906048]  ? __switch_to_asm+0x34/0x70
[ 1831.906048]  path_lookupat.isra.55+0x6d/0x220
[ 1831.906050]  ? __switch_to_asm+0x40/0x70
[ 1831.906051]  ? __switch_to_asm+0x34/0x70
[ 1831.906051]  ? __switch_to_asm+0x40/0x70
[ 1831.906052]  ? __switch_to_asm+0x34/0x70
[ 1831.906053]  ? __switch_to_asm+0x40/0x70
[ 1831.906054]  filename_lookup.part.69+0xa0/0x170
[ 1831.906055]  ? __switch_to_asm+0x34/0x70
[ 1831.906056]  ? __check_object_size+0x158/0x184
[ 1831.906058]  ? strncpy_from_user+0x4a/0x170
[ 1831.906059]  vfs_statx+0x73/0xe0
[ 1831.906061]  __do_sys_newstat+0x39/0x70
[ 1831.906063]  ? recalc_sigpending+0x17/0x50
[ 1831.906064]  ? __set_task_blocked+0x6d/0x90
[ 1831.906064]  ? __set_current_blocked+0x3d/0x60
[ 1831.906065]  ? sigprocmask+0x72/0xa0
[ 1831.906066]  ? __x64_sys_rt_sigprocmask+0x76/0xd0
[ 1831.906067]  do_syscall_64+0x55/0x100
[ 1831.906068]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.906069] RIP: 0033:0x7efe49566325
[ 1831.906070] Code: Bad RIP value.
[ 1831.906071] RSP: 002b:00007ffd677f3518 EFLAGS: 00000246 ORIG_RAX:
0000000000000004
[ 1831.906072] RAX: ffffffffffffffda RBX: 00007ffd677f3660 RCX:
00007efe49566325
[ 1831.906072] RDX: 00007ffd677f3590 RSI: 00007ffd677f3590 RDI:
00007ffd677f3520
[ 1831.906073] RBP: 00007ffd677f3650 R08: 000000000000000a R09:
00007efe495c1950
[ 1831.906073] R10: 7974697275636573 R11: 0000000000000246 R12:
00007ffd677f3870
[ 1831.906074] R13: 00007ffd677f3520 R14: 0000000000000000 R15:
0000000000000009
[ 1831.906076] cc1             D    0 26405  26404 0x00000000
[ 1831.906077] Call Trace:
[ 1831.906078]  ? __schedule+0x21d/0x840
[ 1831.906101]  ? xfs_bwrite+0x25/0x60 [xfs]
[ 1831.906101]  schedule+0x28/0x80
[ 1831.906102]  schedule_timeout+0x1d8/0x370
[ 1831.906104]  ? blk_finish_plug+0x21/0x2e
[ 1831.906127]  ? xfs_bwrite+0x25/0x60 [xfs]
[ 1831.906128]  wait_for_completion+0xad/0x130
[ 1831.906129]  ? wake_up_q+0x70/0x70
[ 1831.906151]  ? __xfs_buf_submit+0xd7/0x230 [xfs]
[ 1831.906173]  xfs_buf_iowait+0x27/0xd0 [xfs]
[ 1831.906195]  __xfs_buf_submit+0xd7/0x230 [xfs]
[ 1831.906218]  xfs_bwrite+0x25/0x60 [xfs]
[ 1831.906240]  xfs_reclaim_inode+0x309/0x330 [xfs]
[ 1831.906263]  xfs_reclaim_inodes_ag+0x1b1/0x300 [xfs]
[ 1831.906285]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.906308]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.906331]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.906332]  super_cache_scan+0x155/0x1a0
[ 1831.906333]  do_shrink_slab+0x128/0x290
[ 1831.906335]  shrink_slab+0x233/0x2b0
[ 1831.906336]  shrink_node+0xe6/0x460
[ 1831.906337]  do_try_to_free_pages+0xc6/0x370
[ 1831.906338]  try_to_free_pages+0xf5/0x1c0
[ 1831.906339]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.906340]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.906342]  alloc_pages_vma+0x7c/0x1f0
[ 1831.906343]  __handle_mm_fault+0x8b5/0xf80
[ 1831.906345]  handle_mm_fault+0x155/0x1d0
[ 1831.906346]  __do_page_fault+0x1e6/0x460
[ 1831.906348]  ? page_fault+0x8/0x30
[ 1831.906349]  page_fault+0x1e/0x30
[ 1831.906350] RIP: 0033:0x7f49d7b4ba38
[ 1831.906351] Code: Bad RIP value.
[ 1831.906351] RSP: 002b:00007ffc9d5e4bd8 EFLAGS: 00010206
[ 1831.906352] RAX: 00007f49d67ec000 RBX: 0000000000000170 RCX:
00007f49d67ec040
[ 1831.906353] RDX: 0000000000000170 RSI: 0000000000000000 RDI:
00007f49d67ec000
[ 1831.906353] RBP: 00007f49d783d100 R08: 00000000031ee1f0 R09:
0000000000000000
[ 1831.906354] R10: 0000000000000000 R11: 00000000031ee1f0 R12:
00007f49d67eac00
[ 1831.906354] R13: 00007f49d67eac00 R14: 0000000000000000 R15:
00007f49d78472d0
[ 1831.906355] cc1             D    0 26411  26410 0x00000000
[ 1831.906356] Call Trace:
[ 1831.906357]  ? __schedule+0x21d/0x840
[ 1831.906358]  schedule+0x28/0x80
[ 1831.906359]  schedule_preempt_disabled+0xa/0x10
[ 1831.906360]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.906383]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.906384]  ? inode_lru_list_add+0x20/0x40
[ 1831.906385]  ? iput+0x16d/0x200
[ 1831.906408]  ? xfs_iunlock+0x61/0x110 [xfs]
[ 1831.906429]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.906452]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.906474]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.906476]  super_cache_scan+0x155/0x1a0
[ 1831.906477]  do_shrink_slab+0x128/0x290
[ 1831.906478]  shrink_slab+0x233/0x2b0
[ 1831.906479]  shrink_node+0xe6/0x460
[ 1831.906481]  do_try_to_free_pages+0xc6/0x370
[ 1831.906481]  try_to_free_pages+0xf5/0x1c0
[ 1831.906483]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.906484]  ? __alloc_pages_slowpath+0x173/0xdc0
[ 1831.906485]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.906486]  alloc_pages_vma+0x7c/0x1f0
[ 1831.906487]  wp_page_copy+0x4f0/0x740
[ 1831.906488]  do_wp_page+0x8a/0x5f0
[ 1831.906489]  __handle_mm_fault+0xafc/0xf80
[ 1831.906491]  handle_mm_fault+0x155/0x1d0
[ 1831.906492]  __do_page_fault+0x1e6/0x460
[ 1831.906493]  ? page_fault+0x8/0x30
[ 1831.906494]  page_fault+0x1e/0x30
[ 1831.906495] RIP: 0033:0x5b126b
[ 1831.906496] Code: Bad RIP value.
[ 1831.906496] RSP: 002b:00007ffcb1940470 EFLAGS: 00010256
[ 1831.906497] RAX: 0000000000000000 RBX: 00007fdf9a729000 RCX:
0000000000000001
[ 1831.906498] RDX: 0000000010000002 RSI: 0000000000000001 RDI:
0000000000000054
[ 1831.906498] RBP: 00007fdf9a715000 R08: 0000000000000000 R09:
000000008000833a
[ 1831.906499] R10: 0000000000000000 R11: 0000000002d22010 R12:
00007fdf9c68ddb0
[ 1831.906499] R13: 00007fdf9a725900 R14: 0000000000000000 R15:
00007fdf9a725900
[ 1831.906500] cc1             D    0 26415  26414 0x00000000
[ 1831.906501] Call Trace:
[ 1831.906502]  ? __schedule+0x21d/0x840
[ 1831.906503]  schedule+0x28/0x80
[ 1831.906504]  schedule_preempt_disabled+0xa/0x10
[ 1831.906505]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.906528]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.906551]  ? xfs_iunlock+0x61/0x110 [xfs]
[ 1831.906573]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.906595]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.906618]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.906619]  super_cache_scan+0x155/0x1a0
[ 1831.906620]  do_shrink_slab+0x128/0x290
[ 1831.906622]  shrink_slab+0x233/0x2b0
[ 1831.906623]  shrink_node+0xe6/0x460
[ 1831.906624]  do_try_to_free_pages+0xc6/0x370
[ 1831.906625]  try_to_free_pages+0xf5/0x1c0
[ 1831.906626]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.906627]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.906628]  alloc_pages_vma+0x7c/0x1f0
[ 1831.906629]  __handle_mm_fault+0x8b5/0xf80
[ 1831.906631]  handle_mm_fault+0x155/0x1d0
[ 1831.906631]  __do_page_fault+0x1e6/0x460
[ 1831.906633]  ? page_fault+0x8/0x30
[ 1831.906634]  page_fault+0x1e/0x30
[ 1831.906634] RIP: 0033:0x7f25af773a38
[ 1831.906636] Code: Bad RIP value.
[ 1831.906636] RSP: 002b:00007ffdf763bac8 EFLAGS: 00010202
[ 1831.906637] RAX: 00007f25ad1ee000 RBX: 0000000000000080 RCX:
00007f25ad1ee040
[ 1831.906638] RDX: 0000000000000080 RSI: 0000000000000000 RDI:
00007f25ad1ee000
[ 1831.906638] RBP: 000000007ff9f6ef R08: 00000000039dc8d0 R09:
0000000000000000
[ 1831.906639] R10: 0000000000000000 R11: 00000000039daf80 R12:
0000000000000003
[ 1831.906639] R13: 0000000000000022 R14: 00007f25af47f3d8 R15:
000000007ff9f6ef
[ 1831.906641] cc1             D    0 26430  26428 0x00000000
[ 1831.906641] Call Trace:
[ 1831.906643]  ? __schedule+0x21d/0x840
[ 1831.906643]  schedule+0x28/0x80
[ 1831.906644]  schedule_preempt_disabled+0xa/0x10
[ 1831.906645]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.906668]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.906669]  ? inode_lru_list_add+0x20/0x40
[ 1831.906670]  ? iput+0x16d/0x200
[ 1831.906693]  ? xfs_iunlock+0x61/0x110 [xfs]
[ 1831.906714]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.906737]  ? xfs_inode_set_reclaim_tag+0xd2/0x140 [xfs]
[ 1831.906759]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.906760]  super_cache_scan+0x155/0x1a0
[ 1831.906762]  do_shrink_slab+0x128/0x290
[ 1831.906763]  shrink_slab+0x233/0x2b0
[ 1831.906764]  shrink_node+0xe6/0x460
[ 1831.906765]  do_try_to_free_pages+0xc6/0x370
[ 1831.906766]  try_to_free_pages+0xf5/0x1c0
[ 1831.906767]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.906768]  ? ttwu_do_wakeup+0x19/0x150
[ 1831.906770]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.906771]  alloc_pages_vma+0x7c/0x1f0
[ 1831.906772]  __handle_mm_fault+0x8b5/0xf80
[ 1831.906773]  handle_mm_fault+0x155/0x1d0
[ 1831.906774]  __do_page_fault+0x1e6/0x460
[ 1831.906775]  ? page_fault+0x8/0x30
[ 1831.906776]  page_fault+0x1e/0x30
[ 1831.906777] RIP: 0033:0x7f3c73bba484
[ 1831.906778] Code: Bad RIP value.
[ 1831.906779] RSP: 002b:00007ffffaa9d5c8 EFLAGS: 00010202
[ 1831.906780] RAX: 00007f3c71ade000 RBX: 00007f3c72827000 RCX:
0000000000080000
[ 1831.906780] RDX: 00000000000d4f70 RSI: 00007f3c728fbff0 RDI:
00007f3c71bb3070
[ 1831.906781] RBP: 0000000000180000 R08: 00007f3c71bddff0 R09:
00007f3c72927000
[ 1831.906781] R10: 0000000000000007 R11: 00007f3c73c08680 R12:
00007f3c71ade000
[ 1831.906782] R13: 0000000000100000 R14: 00007ffffaa9db20 R15:
00007ffffaa9db20
[ 1831.906783] fixdep          D    0 26436  26319 0x00000000
[ 1831.906784] Call Trace:
[ 1831.906785]  ? __schedule+0x21d/0x840
[ 1831.906786]  schedule+0x28/0x80
[ 1831.906787]  rwsem_down_read_failed+0xe1/0x140
[ 1831.906788]  call_rwsem_down_read_failed+0x14/0x30
[ 1831.906789]  down_read+0x1c/0x30
[ 1831.906790]  path_openat+0xb9b/0x1650
[ 1831.906792]  ? generic_file_read_iter+0x853/0xc10
[ 1831.906812]  ? xfs_bmapi_read+0x129/0x340 [xfs]
[ 1831.906813]  do_filp_open+0x93/0x100
[ 1831.906815]  ? __check_object_size+0x158/0x184
[ 1831.906816]  do_sys_open+0x186/0x210
[ 1831.906817]  do_syscall_64+0x55/0x100
[ 1831.906818]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.906819] RIP: 0033:0x7fc96d8769c0
[ 1831.906820] Code: Bad RIP value.
[ 1831.906821] RSP: 002b:00007ffd1be5b150 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1831.906822] RAX: ffffffffffffffda RBX: 0000000000b9d071 RCX:
00007fc96d8769c0
[ 1831.906822] RDX: 0000000000000000 RSI: 0000000000b9d071 RDI:
00000000ffffff9c
[ 1831.906823] RBP: 0000000000b9d071 R08: 0000000000b9d071 R09:
00007fc96d8d1b40
[ 1831.906823] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[ 1831.906824] R13: 0000000000bab372 R14: 0000000000000021 R15:
000000000000000b
[ 1831.906825] cc1             D    0 26450  26449 0x00000000
[ 1831.906826] Call Trace:
[ 1831.906827]  ? __schedule+0x21d/0x840
[ 1831.906849]  ? xfs_buf_read_map+0xc1/0x180 [xfs]
[ 1831.906850]  schedule+0x28/0x80
[ 1831.906851]  schedule_timeout+0x1d8/0x370
[ 1831.906852]  ? blk_finish_plug+0x21/0x2e
[ 1831.906874]  ? xfs_buf_read_map+0xc1/0x180 [xfs]
[ 1831.906875]  wait_for_completion+0xad/0x130
[ 1831.906876]  ? wake_up_q+0x70/0x70
[ 1831.906898]  ? __xfs_buf_submit+0xd7/0x230 [xfs]
[ 1831.906920]  xfs_buf_iowait+0x27/0xd0 [xfs]
[ 1831.906942]  __xfs_buf_submit+0xd7/0x230 [xfs]
[ 1831.906965]  xfs_buf_read_map+0xc1/0x180 [xfs]
[ 1831.906988]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.907010]  xfs_imap_to_bp+0x67/0xd0 [xfs]
[ 1831.907031]  xfs_iread+0x82/0x1f0 [xfs]
[ 1831.907033]  ? inode_init_always+0x120/0x1d0
[ 1831.907055]  xfs_iget+0x20f/0x990 [xfs]
[ 1831.907077]  ? xfs_dir_lookup+0x184/0x1d0 [xfs]
[ 1831.907099]  xfs_lookup+0xa4/0x120 [xfs]
[ 1831.907100]  ? unlazy_walk+0x3a/0xa0
[ 1831.907123]  xfs_vn_lookup+0x70/0xa0 [xfs]
[ 1831.907124]  path_openat+0xaff/0x1650
[ 1831.907125]  do_filp_open+0x93/0x100
[ 1831.907127]  ? __handle_mm_fault+0x9dc/0xf80
[ 1831.907128]  ? __check_object_size+0x158/0x184
[ 1831.907129]  do_sys_open+0x186/0x210
[ 1831.907130]  do_syscall_64+0x55/0x100
[ 1831.907131]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.907132] RIP: 0033:0x7f3884a4e9c0
[ 1831.907133] Code: Bad RIP value.
[ 1831.907134] RSP: 002b:00007ffcfa97a360 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1831.907134] RAX: ffffffffffffffda RBX: 0000000002407db0 RCX:
00007f3884a4e9c0
[ 1831.907135] RDX: 0000000000000100 RSI: 00000000023b14f0 RDI:
00000000ffffff9c
[ 1831.907135] RBP: 0000000002215ae0 R08: 00000000023b2b20 R09:
0000000099568b0e
[ 1831.907136] R10: 0000000000000000 R11: 0000000000000246 R12:
00000000023b14f0
[ 1831.907136] R13: 0000000099568de8 R14: 00000000021cf190 R15:
00000000021b73b0
[ 1831.907138] cc1             D    0 26454  26453 0x00000000
[ 1831.907139] Call Trace:
[ 1831.907140]  ? __schedule+0x21d/0x840
[ 1831.907141]  schedule+0x28/0x80
[ 1831.907142]  schedule_timeout+0x1d8/0x370
[ 1831.907143]  __down+0x7f/0xd0
[ 1831.907144]  ? syscall_return_via_sysret+0x13/0x83
[ 1831.907145]  ? __switch_to_asm+0x40/0x70
[ 1831.907146]  ? __switch_to_asm+0x40/0x70
[ 1831.907168]  ? xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.907169]  down+0x3b/0x50
[ 1831.907191]  xfs_buf_lock+0x32/0xf0 [xfs]
[ 1831.907213]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.907235]  xfs_buf_get_map+0x40/0x2c0 [xfs]
[ 1831.907258]  xfs_buf_read_map+0x28/0x180 [xfs]
[ 1831.907280]  ? xfs_buf_trylock+0x19/0xd0 [xfs]
[ 1831.907303]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.907325]  xfs_read_agi+0x9e/0x140 [xfs]
[ 1831.907347]  xfs_ialloc_read_agi+0x34/0xd0 [xfs]
[ 1831.907368]  xfs_dialloc+0xe7/0x2b0 [xfs]
[ 1831.907391]  xfs_ialloc+0x6b/0x5a0 [xfs]
[ 1831.907414]  ? kmem_zone_alloc+0x61/0xe0 [xfs]
[ 1831.907437]  xfs_dir_ialloc+0x6c/0x220 [xfs]
[ 1831.907460]  xfs_create+0x224/0x620 [xfs]
[ 1831.907483]  xfs_generic_create+0x226/0x2c0 [xfs]
[ 1831.907484]  path_openat+0x1279/0x1650
[ 1831.907486]  ? current_time+0x4f/0x90
[ 1831.907487]  do_filp_open+0x93/0x100
[ 1831.907488]  ? __check_object_size+0x158/0x184
[ 1831.907489]  do_sys_open+0x186/0x210
[ 1831.907490]  do_syscall_64+0x55/0x100
[ 1831.907491]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.907492] RIP: 0033:0x7f4afda6e9c0
[ 1831.907493] Code: Bad RIP value.
[ 1831.907494] RSP: 002b:00007ffef4762170 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1831.907495] RAX: ffffffffffffffda RBX: 0000000003523800 RCX:
00007f4afda6e9c0
[ 1831.907495] RDX: 0000000000000241 RSI: 00007ffef4763faa RDI:
00000000ffffff9c
[ 1831.907496] RBP: 000000000128aafd R08: 0000000000000001 R09:
000000000310e660
[ 1831.907496] R10: 00000000000001b6 R11: 0000000000000246 R12:
0000000000000004
[ 1831.907497] R13: 000000000128aafd R14: 0000000000000000 R15:
0000000000000000
[ 1831.907498] rm              D    0 26462  26356 0x00000000
[ 1831.907498] Call Trace:
[ 1831.907500]  ? __schedule+0x21d/0x840
[ 1831.907501]  schedule+0x28/0x80
[ 1831.907501]  schedule_timeout+0x1d8/0x370
[ 1831.907503]  __down+0x7f/0xd0
[ 1831.907524]  ? xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.907525]  down+0x3b/0x50
[ 1831.907547]  xfs_buf_lock+0x32/0xf0 [xfs]
[ 1831.907570]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.907592]  xfs_buf_get_map+0x40/0x2c0 [xfs]
[ 1831.907614]  xfs_buf_read_map+0x28/0x180 [xfs]
[ 1831.907637]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.907659]  xfs_read_agi+0x9e/0x140 [xfs]
[ 1831.907682]  xfs_iunlink+0x4d/0x140 [xfs]
[ 1831.907705]  xfs_remove+0x1ec/0x2e0 [xfs]
[ 1831.907728]  xfs_vn_unlink+0x55/0xa0 [xfs]
[ 1831.907729]  ? may_delete+0x7f/0x190
[ 1831.907730]  vfs_unlink+0x109/0x1a0
[ 1831.907731]  do_unlinkat+0x225/0x310
[ 1831.907732]  do_syscall_64+0x55/0x100
[ 1831.907733]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.907734] RIP: 0033:0x7f05978905b7
[ 1831.907735] Code: Bad RIP value.
[ 1831.907736] RSP: 002b:00007fff97cd1258 EFLAGS: 00000202 ORIG_RAX:
0000000000000107
[ 1831.907737] RAX: ffffffffffffffda RBX: 00000000011d68c0 RCX:
00007f05978905b7
[ 1831.907737] RDX: 0000000000000000 RSI: 00000000011d5690 RDI:
00000000ffffff9c
[ 1831.907738] RBP: 00000000011d5600 R08: 0000000000000003 R09:
0000000000000000
[ 1831.907738] R10: 0000000000000003 R11: 0000000000000202 R12:
00007fff97cd1410
[ 1831.907739] R13: 0000000000000000 R14: 0000000000000000 R15:
00000000011d68c0
[ 1831.907739] rm              D    0 26472  26300 0x00000000
[ 1831.907740] Call Trace:
[ 1831.907742]  ? __schedule+0x21d/0x840
[ 1831.907742]  schedule+0x28/0x80
[ 1831.907743]  schedule_timeout+0x1d8/0x370
[ 1831.907744]  __down+0x7f/0xd0
[ 1831.907766]  ? xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.907767]  down+0x3b/0x50
[ 1831.907789]  xfs_buf_lock+0x32/0xf0 [xfs]
[ 1831.907811]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.907834]  xfs_buf_get_map+0x40/0x2c0 [xfs]
[ 1831.907856]  xfs_buf_read_map+0x28/0x180 [xfs]
[ 1831.907879]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.907901]  xfs_read_agi+0x9e/0x140 [xfs]
[ 1831.907924]  xfs_iunlink+0x4d/0x140 [xfs]
[ 1831.907947]  xfs_remove+0x1ec/0x2e0 [xfs]
[ 1831.907969]  xfs_vn_unlink+0x55/0xa0 [xfs]
[ 1831.907970]  ? may_delete+0x7f/0x190
[ 1831.907971]  vfs_unlink+0x109/0x1a0
[ 1831.907972]  do_unlinkat+0x225/0x310
[ 1831.907974]  do_syscall_64+0x55/0x100
[ 1831.907975]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.907975] RIP: 0033:0x7f26250485b7
[ 1831.907977] Code: Bad RIP value.
[ 1831.907977] RSP: 002b:00007fffce6faab8 EFLAGS: 00000206 ORIG_RAX:
0000000000000107
[ 1831.907978] RAX: ffffffffffffffda RBX: 00000000016728c0 RCX:
00007f26250485b7
[ 1831.907979] RDX: 0000000000000000 RSI: 0000000001671690 RDI:
00000000ffffff9c
[ 1831.907979] RBP: 0000000001671600 R08: 0000000000000003 R09:
0000000000000000
[ 1831.907980] R10: 0000000000000003 R11: 0000000000000206 R12:
00007fffce6fac70
[ 1831.907980] R13: 0000000000000000 R14: 0000000000000000 R15:
00000000016728c0
[ 1831.907981] gcc             D    0 26474  26473 0x00000000
[ 1831.907982] Call Trace:
[ 1831.907983]  ? __schedule+0x21d/0x840
[ 1831.907984]  schedule+0x28/0x80
[ 1831.907985]  rwsem_down_read_failed+0xe1/0x140
[ 1831.907987]  call_rwsem_down_read_failed+0x14/0x30
[ 1831.907988]  down_read+0x1c/0x30
[ 1831.907988]  lookup_slow+0x27/0x50
[ 1831.907989]  walk_component+0x1bf/0x4a0
[ 1831.907990]  path_lookupat.isra.55+0x6d/0x220
[ 1831.907992]  filename_lookup.part.69+0xa0/0x170
[ 1831.907993]  ? __check_object_size+0x158/0x184
[ 1831.907994]  ? strncpy_from_user+0x4a/0x170
[ 1831.907995]  ? getname_flags+0x6a/0x1e0
[ 1831.907996]  do_faccessat+0xa2/0x240
[ 1831.907997]  do_syscall_64+0x55/0x100
[ 1831.907998]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.907999] RIP: 0033:0x7f4af479ed87
[ 1831.908000] Code: Bad RIP value.
[ 1831.908000] RSP: 002b:00007fff3f11af58 EFLAGS: 00000246 ORIG_RAX:
0000000000000015
[ 1831.908001] RAX: ffffffffffffffda RBX: 000000000000005c RCX:
00007f4af479ed87
[ 1831.908002] RDX: 0000000000632e65 RSI: 0000000000000000 RDI:
000000000227b460
[ 1831.908002] RBP: 00007fff3f11b000 R08: 0000000000000000 R09:
00007f4af47f9af0
[ 1831.908003] R10: 7974697275636573 R11: 0000000000000246 R12:
0000000000498875
[ 1831.908003] R13: 00007fff3f11dd8d R14: 000000000227b460 R15:
0000000000000000
[ 1831.908004] cc1             D    0 26477  26476 0x00000000
[ 1831.908005] Call Trace:
[ 1831.908006]  ? __schedule+0x21d/0x840
[ 1831.908007]  schedule+0x28/0x80
[ 1831.908008]  schedule_preempt_disabled+0xa/0x10
[ 1831.908009]  __mutex_lock.isra.6+0x2c3/0x4b0
[ 1831.908032]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
[ 1831.908052]  ? xfs_bmapi_read+0x129/0x340 [xfs]
[ 1831.908054]  ? inode_lru_list_add+0x20/0x40
[ 1831.908054]  ? iput+0x16d/0x200
[ 1831.908077]  ? xfs_iunlock+0x61/0x110 [xfs]
[ 1831.908099]  ? xfs_perag_get+0x27/0xb0 [xfs]
[ 1831.908121]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
[ 1831.908144]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
[ 1831.908145]  super_cache_scan+0x155/0x1a0
[ 1831.908146]  do_shrink_slab+0x128/0x290
[ 1831.908148]  shrink_slab+0x233/0x2b0
[ 1831.908149]  shrink_node+0xe6/0x460
[ 1831.908150]  do_try_to_free_pages+0xc6/0x370
[ 1831.908151]  try_to_free_pages+0xf5/0x1c0
[ 1831.908152]  __alloc_pages_slowpath+0x3aa/0xdc0
[ 1831.908153]  __alloc_pages_nodemask+0x297/0x2c0
[ 1831.908154]  alloc_pages_vma+0x7c/0x1f0
[ 1831.908155]  __handle_mm_fault+0x8b5/0xf80
[ 1831.908157]  handle_mm_fault+0x155/0x1d0
[ 1831.908158]  __do_page_fault+0x1e6/0x460
[ 1831.908159]  ? page_fault+0x8/0x30
[ 1831.908160]  page_fault+0x1e/0x30
[ 1831.908161] RIP: 0033:0x7ff3864ab988
[ 1831.908162] Code: Bad RIP value.
[ 1831.908162] RSP: 002b:00007ffe12e37508 EFLAGS: 00010283
[ 1831.908163] RAX: 00007ff38634e000 RBX: 00007ff3870bb198 RCX:
0000000000000001
[ 1831.908164] RDX: 0000000000000014 RSI: 0000000000000000 RDI:
00007ff38634e000
[ 1831.908164] RBP: 0000000000000005 R08: 000000000239e9f0 R09:
0000000000000000
[ 1831.908165] R10: 0000000000000000 R11: 000000000239e9f0 R12:
0000000000a2c800
[ 1831.908165] R13: 00007ff3863269c8 R14: 000000007ffff9d8 R15:
00007ff38711c000
[ 1831.908166] fixdep          D    0 26479  26425 0x00000000
[ 1831.908167] Call Trace:
[ 1831.908168]  ? __schedule+0x21d/0x840
[ 1831.908169]  schedule+0x28/0x80
[ 1831.908170]  io_schedule+0x12/0x40
[ 1831.908171]  generic_file_read_iter+0x3a4/0xc10
[ 1831.908172]  ? page_cache_tree_insert+0xe0/0xe0
[ 1831.908195]  xfs_file_buffered_aio_read+0x4b/0xd0 [xfs]
[ 1831.908217]  xfs_file_read_iter+0x6e/0xd0 [xfs]
[ 1831.908219]  __vfs_read+0x133/0x190
[ 1831.908220]  vfs_read+0x8a/0x140
[ 1831.908221]  ksys_read+0x4f/0xb0
[ 1831.908222]  do_syscall_64+0x55/0x100
[ 1831.908224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.908224] RIP: 0033:0x7fa104b76c21
[ 1831.908225] Code: fe ff ff 48 8d 3d 6f 68 0a 00 48 83 ec 08 e8 56 3d 02 00
66 0f 1f 44 00 00 48 8d 05 d9 fa 0d 00 8b 00 85 c0 75 13 31 c0 0f 05 <48> 3d 00
f0 ff ff 77 57 f3 c3 0f 1f 44 00 00 41 54 55 49 89 d4 53
[ 1831.908226] RSP: 002b:00007ffea7b75238 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[ 1831.908227] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
00007fa104b76c21
[ 1831.908227] RDX: 00000000000002a6 RSI: 00000000014f5910 RDI:
0000000000000003
[ 1831.908228] RBP: 00000000014f5910 R08: 00000000014efa55 R09:
00007fa104bd1b40
[ 1831.908228] R10: 0000000000000000 R11: 0000000000000246 R12:
00000000000002a6
[ 1831.908229] R13: 00000000014fab76 R14: 0000000000000019 R15:
0000000000000007
[ 1831.908229] rm              D    0 26480  26371 0x00000000
[ 1831.908230] Call Trace:
[ 1831.908232]  ? __schedule+0x21d/0x840
[ 1831.908233]  ? __switch_to_asm+0x34/0x70
[ 1831.908233]  schedule+0x28/0x80
[ 1831.908234]  schedule_timeout+0x1d8/0x370
[ 1831.908235]  ? __switch_to_asm+0x40/0x70
[ 1831.908236]  ? __switch_to_asm+0x34/0x70
[ 1831.908237]  ? __switch_to_asm+0x40/0x70
[ 1831.908239]  ? __switch_to+0x159/0x4c0
[ 1831.908240]  ? __switch_to_asm+0x34/0x70
[ 1831.908241]  ? __switch_to_asm+0x40/0x70
[ 1831.908242]  __down+0x7f/0xd0
[ 1831.908264]  ? xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.908265]  down+0x3b/0x50
[ 1831.908287]  xfs_buf_lock+0x32/0xf0 [xfs]
[ 1831.908309]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.908331]  xfs_buf_get_map+0x40/0x2c0 [xfs]
[ 1831.908354]  xfs_buf_read_map+0x28/0x180 [xfs]
[ 1831.908377]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.908399]  xfs_imap_to_bp+0x67/0xd0 [xfs]
[ 1831.908421]  xfs_iunlink_remove+0x2b6/0x430 [xfs]
[ 1831.908445]  xfs_ifree+0x42/0x140 [xfs]
[ 1831.908475]  xfs_inactive_ifree+0x9e/0x1c0 [xfs]
[ 1831.908499]  xfs_inactive+0x9e/0x140 [xfs]
[ 1831.908522]  xfs_fs_destroy_inode+0xb1/0x1c0 [xfs]
[ 1831.908523]  do_unlinkat+0x256/0x310
[ 1831.908524]  do_syscall_64+0x55/0x100
[ 1831.908526]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.908526] RIP: 0033:0x7fce9b3a05b7
[ 1831.908528] Code: Bad RIP value.
[ 1831.908528] RSP: 002b:00007ffc5b1d3528 EFLAGS: 00000206 ORIG_RAX:
0000000000000107
[ 1831.908529] RAX: ffffffffffffffda RBX: 00000000020248c0 RCX:
00007fce9b3a05b7
[ 1831.908530] RDX: 0000000000000000 RSI: 0000000002023690 RDI:
00000000ffffff9c
[ 1831.908530] RBP: 0000000002023600 R08: 0000000000000003 R09:
0000000000000000
[ 1831.908531] R10: 0000000000000003 R11: 0000000000000206 R12:
00007ffc5b1d36e0
[ 1831.908531] R13: 0000000000000000 R14: 0000000000000000 R15:
00000000020248c0
[ 1831.908532] cc1             D    0 26483  26482 0x00000000
[ 1831.908533] Call Trace:
[ 1831.908535]  ? __schedule+0x21d/0x840
[ 1831.908535]  schedule+0x28/0x80
[ 1831.908536]  rwsem_down_read_failed+0xe1/0x140
[ 1831.908538]  call_rwsem_down_read_failed+0x14/0x30
[ 1831.908539]  down_read+0x1c/0x30
[ 1831.908540]  path_openat+0xb9b/0x1650
[ 1831.908541]  ? mem_cgroup_commit_charge+0x7f/0x550
[ 1831.908542]  do_filp_open+0x93/0x100
[ 1831.908543]  ? __handle_mm_fault+0x9dc/0xf80
[ 1831.908544]  ? __check_object_size+0x158/0x184
[ 1831.908546]  do_sys_open+0x186/0x210
[ 1831.908547]  do_syscall_64+0x55/0x100
[ 1831.908548]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.908549] RIP: 0033:0x7f3e426469c0
[ 1831.908550] Code: Bad RIP value.
[ 1831.908550] RSP: 002b:00007ffe6e0c7070 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1831.908551] RAX: ffffffffffffffda RBX: 00000000027634a0 RCX:
00007f3e426469c0
[ 1831.908552] RDX: 0000000000000100 RSI: 0000000002762300 RDI:
00000000ffffff9c
[ 1831.908552] RBP: 00000000027adae0 R08: 00000000027b5f40 R09:
00000000f43cde6b
[ 1831.908553] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000002762300
[ 1831.908553] R13: 00000000f43cde6b R14: 0000000002760fc0 R15:
0000000002760fc0
[ 1831.908554] as              D    0 26484  26482 0x00000000
[ 1831.908555] Call Trace:
[ 1831.908556]  ? __schedule+0x21d/0x840
[ 1831.908557]  schedule+0x28/0x80
[ 1831.908558]  schedule_timeout+0x17e/0x370
[ 1831.908559]  ? __next_timer_interrupt+0xc0/0xc0
[ 1831.908582]  xfs_iget+0x17f/0x990 [xfs]
[ 1831.908605]  xfs_ialloc+0xf5/0x5a0 [xfs]
[ 1831.908628]  ? kmem_zone_alloc+0x61/0xe0 [xfs]
[ 1831.908650]  xfs_dir_ialloc+0x6c/0x220 [xfs]
[ 1831.908673]  xfs_create+0x224/0x620 [xfs]
[ 1831.908696]  xfs_generic_create+0x226/0x2c0 [xfs]
[ 1831.908697]  path_openat+0x1279/0x1650
[ 1831.908699]  ? filemap_map_pages+0x139/0x3c0
[ 1831.908700]  do_filp_open+0x93/0x100
[ 1831.908701]  ? __handle_mm_fault+0xd6a/0xf80
[ 1831.908702]  ? __check_object_size+0x158/0x184
[ 1831.908703]  do_sys_open+0x186/0x210
[ 1831.908704]  do_syscall_64+0x55/0x100
[ 1831.908705]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.908706] RIP: 0033:0x7fb4160ce9c0
[ 1831.908707] Code: Bad RIP value.
[ 1831.908708] RSP: 002b:00007ffcbec13710 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1831.908709] RAX: ffffffffffffffda RBX: 0000000000a05280 RCX:
00007fb4160ce9c0
[ 1831.908709] RDX: 0000000000000242 RSI: 0000000000a29d50 RDI:
00000000ffffff9c
[ 1831.908710] RBP: 00007fb4162ac7ca R08: 0000000000000002 R09:
00007fb4162ac7cb
[ 1831.908710] R10: 00000000000001b6 R11: 0000000000000246 R12:
0000000000000000
[ 1831.908711] R13: 00007fb4162ac7c9 R14: 00000000ffffffff R15:
00007ffcbec13a20
[ 1831.908712] cc1             D    0 26487  26486 0x00000000
[ 1831.908713] Call Trace:
[ 1831.908714]  ? __schedule+0x21d/0x840
[ 1831.908715]  schedule+0x28/0x80
[ 1831.908716]  io_schedule+0x12/0x40
[ 1831.908717]  generic_file_read_iter+0x3a4/0xc10
[ 1831.908718]  ? page_cache_tree_insert+0xe0/0xe0
[ 1831.908740]  xfs_file_buffered_aio_read+0x4b/0xd0 [xfs]
[ 1831.908763]  xfs_file_read_iter+0x6e/0xd0 [xfs]
[ 1831.908764]  __vfs_read+0x133/0x190
[ 1831.908766]  vfs_read+0x8a/0x140
[ 1831.908767]  ksys_read+0x4f/0xb0
[ 1831.908768]  do_syscall_64+0x55/0x100
[ 1831.908769]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.908770] RIP: 0033:0x7fd0adf56c21
[ 1831.908771] Code: Bad RIP value.
[ 1831.908772] RSP: 002b:00007fff4be63908 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[ 1831.908772] RAX: ffffffffffffffda RBX: 00000000000002a6 RCX:
00007fd0adf56c21
[ 1831.908773] RDX: 00000000000002a6 RSI: 0000000002e1a8f0 RDI:
0000000000000005
[ 1831.908773] RBP: 0000000002e39ae0 R08: 000000000120d1f6 R09:
000000006feaa6fe
[ 1831.908774] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000002e1a8f0
[ 1831.908774] R13: 0000000002ef6800 R14: 0000000000000000 R15:
0000000000000000
[ 1831.908775] as              D    0 26488  26486 0x00000000
[ 1831.908776] Call Trace:
[ 1831.908777]  ? __schedule+0x21d/0x840
[ 1831.908778]  schedule+0x28/0x80
[ 1831.908779]  schedule_timeout+0x1d8/0x370
[ 1831.908780]  __down+0x7f/0xd0
[ 1831.908802]  ? xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.908803]  down+0x3b/0x50
[ 1831.908825]  xfs_buf_lock+0x32/0xf0 [xfs]
[ 1831.908847]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
[ 1831.908870]  xfs_buf_get_map+0x40/0x2c0 [xfs]
[ 1831.908892]  xfs_buf_read_map+0x28/0x180 [xfs]
[ 1831.908915]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
[ 1831.908937]  xfs_read_agi+0x9e/0x140 [xfs]
[ 1831.908959]  xfs_ialloc_read_agi+0x34/0xd0 [xfs]
[ 1831.908980]  xfs_dialloc+0xe7/0x2b0 [xfs]
[ 1831.909003]  xfs_ialloc+0x6b/0x5a0 [xfs]
[ 1831.909026]  ? kmem_zone_alloc+0x61/0xe0 [xfs]
[ 1831.909049]  xfs_dir_ialloc+0x6c/0x220 [xfs]
[ 1831.909072]  xfs_create+0x224/0x620 [xfs]
[ 1831.909095]  xfs_generic_create+0x226/0x2c0 [xfs]
[ 1831.909096]  path_openat+0x1279/0x1650
[ 1831.909097]  ? filemap_map_pages+0x139/0x3c0
[ 1831.909098]  do_filp_open+0x93/0x100
[ 1831.909099]  ? __handle_mm_fault+0xd6a/0xf80
[ 1831.909100]  ? __check_object_size+0x158/0x184
[ 1831.909102]  do_sys_open+0x186/0x210
[ 1831.909103]  do_syscall_64+0x55/0x100
[ 1831.909104]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1831.909105] RIP: 0033:0x7f435fabe9c0
[ 1831.909106] Code: Bad RIP value.
[ 1831.909106] RSP: 002b:00007ffd8f4c1980 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ 1831.909107] RAX: ffffffffffffffda RBX: 0000000001df5280 RCX:
00007f435fabe9c0
[ 1831.909108] RDX: 0000000000000242 RSI: 0000000001e19a00 RDI:
00000000ffffff9c
[ 1831.909108] RBP: 00007f435fc9c7ca R08: 0000000000000002 R09:
00007f435fc9c7cb
[ 1831.909109] R10: 00000000000001b6 R11: 0000000000000246 R12:
0000000000000000
[ 1831.909109] R13: 00007f435fc9c7c9 R14: 00000000ffffffff R15:
00007ffd8f4c1c90

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
