Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:59100 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbfA2BX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 20:23:26 -0500
Date: Tue, 29 Jan 2019 12:23:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202441] Possibly vfs cache related replicable xfs
 regression since 4.19.0  on sata hdd:s
Message-ID: <20190129012319.GX4205@dastard>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
 <bug-202441-201763-rG3F1A17Ag@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202441-201763-rG3F1A17Ag@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 12:43:39AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> 
> --- Comment #4 from Roger (rogan6710@gmail.com) ---
> "If all else fails, read the man page" ;)
> The complete dmesg output is a litte bit too big for the 
> system here. they only allow 65535 characters

Attach it to the bug rather than pasting in line. Can be much bigger
that way.

> Last Output:
> [ 1831.904739] sysrq: SysRq : Show Blocked State
> [ 1831.904745]   task                        PC stack   pid father
> [ 1831.904752] kswapd0         D    0    85      2 0x80000000
> [ 1831.904753] Call Trace:
> [ 1831.904758]  ? __schedule+0x21d/0x840
> [ 1831.904760]  schedule+0x28/0x80
> [ 1831.904761]  schedule_preempt_disabled+0xa/0x10
> [ 1831.904762]  __mutex_lock.isra.6+0x2c3/0x4b0
> [ 1831.904806]  ? xfs_perag_get_tag+0x3d/0xe0 [xfs]
> [ 1831.904830]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]

Waiting on something else reclaiming inodes from that AG.

> [ 1831.904930] xfsaild/sdc1    D    0  1446      2 0x80000000
> [ 1831.904931] Call Trace:
> [ 1831.904932]  ? __schedule+0x21d/0x840
> [ 1831.904933]  schedule+0x28/0x80
> [ 1831.904956]  xfs_log_force+0x166/0x2e0 [xfs]

Waiting on a log force.

> [ 1831.905012] Xorg            D    0  1496   1495 0x00000000
> [ 1831.905013] Call Trace:
> [ 1831.905014]  ? __schedule+0x21d/0x840
> [ 1831.905015]  schedule+0x28/0x80
> [ 1831.905016]  schedule_preempt_disabled+0xa/0x10
> [ 1831.905017]  __mutex_lock.isra.6+0x2c3/0x4b0
> [ 1831.905039]  ? xfs_perag_get_tag+0x3d/0xe0 [xfs]
> [ 1831.905061]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
> [ 1831.905084]  ? xfs_perag_get+0x27/0xb0 [xfs]
> [ 1831.905106]  ? xfs_inode_set_reclaim_tag+0x67/0x140 [xfs]
> [ 1831.905128]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> [ 1831.905130]  super_cache_scan+0x155/0x1a0
> [ 1831.905131]  do_shrink_slab+0x128/0x290
> [ 1831.905132]  shrink_slab+0x233/0x2b0
> [ 1831.905133]  shrink_node+0xe6/0x460
> [ 1831.905135]  do_try_to_free_pages+0xc6/0x370
> [ 1831.905136]  try_to_free_pages+0xf5/0x1c0
> [ 1831.905137]  __alloc_pages_slowpath+0x3aa/0xdc0
> [ 1831.905139]  ? enqueue_entity+0x36d/0x7e0
> [ 1831.905140]  __alloc_pages_nodemask+0x297/0x2c0
> [ 1831.905142]  kmalloc_order+0x14/0x40
> [ 1831.905143]  kmalloc_order_trace+0x1e/0xa0
> [ 1831.905198]  dc_create_state+0x19/0x30 [amdgpu]
> [ 1831.905234]  amdgpu_dm_atomic_check+0xc6/0x3b0 [amdgpu]
> [ 1831.905248]  drm_atomic_check_only+0x460/0x660 [drm]
> [ 1831.905258]  ? drm_atomic_set_fb_for_plane+0x53/0x80 [drm]
> [ 1831.905267]  drm_atomic_nonblocking_commit+0x13/0x50 [drm]
> [ 1831.905276]  drm_atomic_helper_page_flip+0x5b/0x90 [drm_kms_helper]
> [ 1831.905285]  drm_mode_page_flip_ioctl+0x553/0x5b0 [drm]
> [ 1831.905294]  ? drm_mode_cursor2_ioctl+0x10/0x10 [drm]
> [ 1831.905301]  drm_ioctl_kernel+0xa1/0xf0 [drm]
> [ 1831.905310]  drm_ioctl+0x206/0x3a0 [drm]

Ok, that looks familiar. GPU in a "nonblocking" code path,
doing a blocking memory allocation. Yeah, dc_create_state() is doing
a GFP_KERNEL allocation, which means the memory allocation is
allowed to block waiting for memory reclaim....

> [ 1831.905380] mc              D    0  1866   1740 0x00000000
> [ 1831.905381] Call Trace:
> [ 1831.905383]  schedule+0x28/0x80
> [ 1831.905384]  schedule_preempt_disabled+0xa/0x10
> [ 1831.905429]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
> [ 1831.905522]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> [ 1831.905523]  super_cache_scan+0x155/0x1a0
> [ 1831.905524]  do_shrink_slab+0x128/0x290
> [ 1831.905526]  shrink_slab+0x233/0x2b0
> [ 1831.905527]  shrink_node+0xe6/0x460
> [ 1831.905528]  do_try_to_free_pages+0xc6/0x370
> [ 1831.905529]  try_to_free_pages+0xf5/0x1c0
> [ 1831.905530]  __alloc_pages_slowpath+0x3aa/0xdc0
> [ 1831.905537]  __alloc_pages_nodemask+0x297/0x2c0
> [ 1831.905538]  __do_page_cache_readahead+0xb1/0x1b0
> [ 1831.905539]  ondemand_readahead+0x1f9/0x2c0
> [ 1831.905541]  generic_file_read_iter+0x738/0xc10
> [ 1831.905542]  ? page_cache_tree_insert+0xe0/0xe0
> [ 1831.905543]  nfs_file_read+0x5d/0x80

Oh, NFS read. XFS clears GFP_FS from it's mapping mask so page cache
demand doesn't end up blocked on filesystem reclaim.

> [ 1831.905574] kworker/u16:4   D    0 14955      2 0x80000000
> [ 1831.905577] Workqueue: writeback wb_workfn (flush-8:32)
> [ 1831.905578] Call Trace:
> [ 1831.905580]  schedule+0x28/0x80
> [ 1831.905581]  schedule_timeout+0x1d8/0x370
> [ 1831.905607]  __down+0x7f/0xd0
> [ 1831.905630]  down+0x3b/0x50
> [ 1831.905652]  xfs_buf_lock+0x32/0xf0 [xfs]
> [ 1831.905675]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
> [ 1831.905698]  xfs_buf_get_map+0x40/0x2c0 [xfs]
> [ 1831.905720]  xfs_buf_read_map+0x28/0x180 [xfs]
> [ 1831.905743]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
> [ 1831.905764]  xfs_read_agf+0x94/0x120 [xfs]
> [ 1831.905785]  xfs_alloc_read_agf+0x47/0x1b0 [xfs]
> [ 1831.905805]  xfs_alloc_fix_freelist+0x377/0x430 [xfs]
> [ 1831.905851]  xfs_alloc_vextent+0x121/0x580 [xfs]
> [ 1831.905871]  xfs_bmap_btalloc+0x420/0x890 [xfs]
> [ 1831.905893]  xfs_bmapi_write+0x5f5/0xb80 [xfs]
> [ 1831.905916]  xfs_iomap_write_allocate+0x176/0x380 [xfs]
> [ 1831.905939]  xfs_map_blocks+0x186/0x450 [xfs]
> [ 1831.905962]  xfs_do_writepage+0x123/0x440 [xfs]
> [ 1831.905963]  write_cache_pages+0x1dd/0x470

Writeback blocked waiting for the AGF to be unlocked so it can do
allocation.

> [ 1831.906033] make            D    0 25592  24315 0x00000000
> [ 1831.906034] Call Trace:
> [ 1831.906037]  schedule+0x28/0x80
> [ 1831.906037]  rwsem_down_read_failed+0xe1/0x140
> [ 1831.906040]  call_rwsem_down_read_failed+0x14/0x30
> [ 1831.906041]  down_read+0x1c/0x30
> [ 1831.906042]  lookup_slow+0x27/0x50
> [ 1831.906043]  walk_component+0x1bf/0x4a0
> [ 1831.906048]  path_lookupat.isra.55+0x6d/0x220
> [ 1831.906054]  filename_lookup.part.69+0xa0/0x170
> [ 1831.906059]  vfs_statx+0x73/0xe0

Blocked in VFS pathname walk.

> [ 1831.906076] cc1             D    0 26405  26404 0x00000000
> [ 1831.906077] Call Trace:
> [ 1831.906101]  schedule+0x28/0x80
> [ 1831.906102]  schedule_timeout+0x1d8/0x370
> [ 1831.906128]  wait_for_completion+0xad/0x130
> [ 1831.906173]  xfs_buf_iowait+0x27/0xd0 [xfs]
> [ 1831.906195]  __xfs_buf_submit+0xd7/0x230 [xfs]
> [ 1831.906218]  xfs_bwrite+0x25/0x60 [xfs]
> [ 1831.906240]  xfs_reclaim_inode+0x309/0x330 [xfs]
> [ 1831.906263]  xfs_reclaim_inodes_ag+0x1b1/0x300 [xfs]
> [ 1831.906331]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> [ 1831.906332]  super_cache_scan+0x155/0x1a0
> [ 1831.906333]  do_shrink_slab+0x128/0x290
> [ 1831.906335]  shrink_slab+0x233/0x2b0
> [ 1831.906336]  shrink_node+0xe6/0x460
> [ 1831.906337]  do_try_to_free_pages+0xc6/0x370
> [ 1831.906338]  try_to_free_pages+0xf5/0x1c0
> [ 1831.906339]  __alloc_pages_slowpath+0x3aa/0xdc0
> [ 1831.906340]  __alloc_pages_nodemask+0x297/0x2c0
> [ 1831.906342]  alloc_pages_vma+0x7c/0x1f0
> [ 1831.906343]  __handle_mm_fault+0x8b5/0xf80
> [ 1831.906345]  handle_mm_fault+0x155/0x1d0
> [ 1831.906346]  __do_page_fault+0x1e6/0x460
> [ 1831.906349]  page_fault+0x1e/0x30

And there's our reclaimer that is doing IO. Page fault on an
executable page.

> [ 1831.906355] cc1             D    0 26411  26410 0x00000000
> [ 1831.906356] Call Trace:
> [ 1831.906358]  schedule+0x28/0x80
> [ 1831.906359]  schedule_preempt_disabled+0xa/0x10
> [ 1831.906360]  __mutex_lock.isra.6+0x2c3/0x4b0
> [ 1831.906383]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]
> [ 1831.906474]  xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
> [ 1831.906476]  super_cache_scan+0x155/0x1a0
> [ 1831.906477]  do_shrink_slab+0x128/0x290
> [ 1831.906478]  shrink_slab+0x233/0x2b0
> [ 1831.906479]  shrink_node+0xe6/0x460
> [ 1831.906481]  do_try_to_free_pages+0xc6/0x370
> [ 1831.906481]  try_to_free_pages+0xf5/0x1c0
> [ 1831.906483]  __alloc_pages_slowpath+0x3aa/0xdc0
> [ 1831.906485]  __alloc_pages_nodemask+0x297/0x2c0
> [ 1831.906486]  alloc_pages_vma+0x7c/0x1f0
> [ 1831.906487]  wp_page_copy+0x4f0/0x740
> [ 1831.906488]  do_wp_page+0x8a/0x5f0
> [ 1831.906489]  __handle_mm_fault+0xafc/0xf80
> [ 1831.906491]  handle_mm_fault+0x155/0x1d0
> [ 1831.906492]  __do_page_fault+0x1e6/0x460

same thing, but blocked on the per-ag reclaim lock.

> [ 1831.906500] cc1             D    0 26415  26414 0x00000000
> [ 1831.906501] Call Trace:
> [ 1831.906503]  schedule+0x28/0x80
> [ 1831.906504]  schedule_preempt_disabled+0xa/0x10
> [ 1831.906505]  __mutex_lock.isra.6+0x2c3/0x4b0
> [ 1831.906528]  xfs_reclaim_inodes_ag+0x299/0x300 [xfs]

same thing.

> [ 1831.906641] cc1             D    0 26430  26428 0x00000000

same thing.

> [ 1831.906783] fixdep          D    0 26436  26319 0x00000000
> [ 1831.906784] Call Trace:
> [ 1831.906786]  schedule+0x28/0x80
> [ 1831.906787]  rwsem_down_read_failed+0xe1/0x140
> [ 1831.906788]  call_rwsem_down_read_failed+0x14/0x30
> [ 1831.906789]  down_read+0x1c/0x30
> [ 1831.906790]  path_openat+0xb9b/0x1650
> [ 1831.906813]  do_filp_open+0x93/0x100
> [ 1831.906816]  do_sys_open+0x186/0x210

Blocked in pathwalk.

> [ 1831.906825] cc1             D    0 26450  26449 0x00000000
> [ 1831.906826] Call Trace:
> [ 1831.906850]  schedule+0x28/0x80
> [ 1831.906851]  schedule_timeout+0x1d8/0x370
> [ 1831.906875]  wait_for_completion+0xad/0x130
> [ 1831.906920]  xfs_buf_iowait+0x27/0xd0 [xfs]
> [ 1831.906942]  __xfs_buf_submit+0xd7/0x230 [xfs]
> [ 1831.906965]  xfs_buf_read_map+0xc1/0x180 [xfs]
> [ 1831.906988]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
> [ 1831.907010]  xfs_imap_to_bp+0x67/0xd0 [xfs]
> [ 1831.907031]  xfs_iread+0x82/0x1f0 [xfs]
> [ 1831.907055]  xfs_iget+0x20f/0x990 [xfs]
> [ 1831.907099]  xfs_lookup+0xa4/0x120 [xfs]
> [ 1831.907123]  xfs_vn_lookup+0x70/0xa0 [xfs]
> [ 1831.907124]  path_openat+0xaff/0x1650
> [ 1831.907125]  do_filp_open+0x93/0x100

Blocked in open(), waiting for inode buffer read.

> [ 1831.907138] cc1             D    0 26454  26453 0x00000000
> [ 1831.907139] Call Trace:
> [ 1831.907141]  schedule+0x28/0x80
> [ 1831.907142]  schedule_timeout+0x1d8/0x370
> [ 1831.907143]  __down+0x7f/0xd0
> [ 1831.907169]  down+0x3b/0x50
> [ 1831.907191]  xfs_buf_lock+0x32/0xf0 [xfs]
> [ 1831.907213]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
> [ 1831.907235]  xfs_buf_get_map+0x40/0x2c0 [xfs]
> [ 1831.907258]  xfs_buf_read_map+0x28/0x180 [xfs]
> [ 1831.907303]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
> [ 1831.907325]  xfs_read_agi+0x9e/0x140 [xfs]
> [ 1831.907347]  xfs_ialloc_read_agi+0x34/0xd0 [xfs]
> [ 1831.907368]  xfs_dialloc+0xe7/0x2b0 [xfs]
> [ 1831.907391]  xfs_ialloc+0x6b/0x5a0 [xfs]

INode allocation in open call, blocked waiting on AGI buffer lock.

> [ 1831.907498] rm              D    0 26462  26356 0x00000000
> [ 1831.907498] Call Trace:
> [ 1831.907501]  schedule+0x28/0x80
> [ 1831.907501]  schedule_timeout+0x1d8/0x370
> [ 1831.907503]  __down+0x7f/0xd0
> [ 1831.907525]  down+0x3b/0x50
> [ 1831.907547]  xfs_buf_lock+0x32/0xf0 [xfs]
> [ 1831.907570]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
> [ 1831.907592]  xfs_buf_get_map+0x40/0x2c0 [xfs]
> [ 1831.907614]  xfs_buf_read_map+0x28/0x180 [xfs]
> [ 1831.907637]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
> [ 1831.907659]  xfs_read_agi+0x9e/0x140 [xfs]
> [ 1831.907682]  xfs_iunlink+0x4d/0x140 [xfs]
> [ 1831.907705]  xfs_remove+0x1ec/0x2e0 [xfs]
> [ 1831.907728]  xfs_vn_unlink+0x55/0xa0 [xfs]

Unlink, blocked on AGI buffer lock.

> [ 1831.907739] rm              D    0 26472  26300 0x00000000

Ditto.

> [ 1831.907981] gcc             D    0 26474  26473 0x00000000
> [ 1831.907982] Call Trace:
> [ 1831.907984]  schedule+0x28/0x80
> [ 1831.907985]  rwsem_down_read_failed+0xe1/0x140
> [ 1831.907987]  call_rwsem_down_read_failed+0x14/0x30
> [ 1831.907988]  down_read+0x1c/0x30
> [ 1831.907988]  lookup_slow+0x27/0x50
> [ 1831.907989]  walk_component+0x1bf/0x4a0
> [ 1831.907990]  path_lookupat.isra.55+0x6d/0x220
> [ 1831.907992]  filename_lookup.part.69+0xa0/0x170
> [ 1831.907996]  do_faccessat+0xa2/0x240

Blocked in pathname walk.

> [ 1831.908004] cc1             D    0 26477  26476 0x00000000

Pagefault -> per ag shrinker lock again.

> [ 1831.908166] fixdep          D    0 26479  26425 0x00000000
> [ 1831.908167] Call Trace:
> [ 1831.908169]  schedule+0x28/0x80
> [ 1831.908170]  io_schedule+0x12/0x40
> [ 1831.908171]  generic_file_read_iter+0x3a4/0xc10
> [ 1831.908195]  xfs_file_buffered_aio_read+0x4b/0xd0 [xfs]
> [ 1831.908217]  xfs_file_read_iter+0x6e/0xd0 [xfs]
> [ 1831.908219]  __vfs_read+0x133/0x190
> [ 1831.908220]  vfs_read+0x8a/0x140

waiting on read IO. Disk is busy.

> [ 1831.908229] rm              D    0 26480  26371 0x00000000
> [ 1831.908230] Call Trace:
> [ 1831.908233]  schedule+0x28/0x80
> [ 1831.908234]  schedule_timeout+0x1d8/0x370
> [ 1831.908242]  __down+0x7f/0xd0
> [ 1831.908265]  down+0x3b/0x50
> [ 1831.908287]  xfs_buf_lock+0x32/0xf0 [xfs]
> [ 1831.908309]  xfs_buf_find.isra.30+0x3b4/0x5e0 [xfs]
> [ 1831.908331]  xfs_buf_get_map+0x40/0x2c0 [xfs]
> [ 1831.908354]  xfs_buf_read_map+0x28/0x180 [xfs]
> [ 1831.908377]  xfs_trans_read_buf_map+0xb4/0x2f0 [xfs]
> [ 1831.908399]  xfs_imap_to_bp+0x67/0xd0 [xfs]
> [ 1831.908421]  xfs_iunlink_remove+0x2b6/0x430 [xfs]
> [ 1831.908445]  xfs_ifree+0x42/0x140 [xfs]
> [ 1831.908475]  xfs_inactive_ifree+0x9e/0x1c0 [xfs]
> [ 1831.908499]  xfs_inactive+0x9e/0x140 [xfs]
> [ 1831.908522]  xfs_fs_destroy_inode+0xb1/0x1c0 [xfs]

Unlink, holds AGI buffer lock, blocked on inode buffer lock.
 
> [ 1831.908532] cc1             D    0 26483  26482 0x00000000

Blocked in path walk.

> [ 1831.908554] as              D    0 26484  26482 0x00000000
> [ 1831.908555] Call Trace:
> [ 1831.908557]  schedule+0x28/0x80
> [ 1831.908558]  schedule_timeout+0x17e/0x370
> [ 1831.908582]  xfs_iget+0x17f/0x990 [xfs]
> [ 1831.908605]  xfs_ialloc+0xf5/0x5a0 [xfs]
> [ 1831.908650]  xfs_dir_ialloc+0x6c/0x220 [xfs]
> [ 1831.908673]  xfs_create+0x224/0x620 [xfs]
> [ 1831.908696]  xfs_generic_create+0x226/0x2c0 [xfs]
> [ 1831.908697]  path_openat+0x1279/0x1650
> [ 1831.908700]  do_filp_open+0x93/0x100

Blocked in inode allocation, most likely waiting to for a recently
freed inode to be reclaimed fully

> [ 1831.908712] cc1             D    0 26487  26486 0x00000000

Waiting on read.

> [ 1831.908775] as              D    0 26488  26486 0x00000000

waiting on AGI buffer lock for allocation.

OK, so your disks are busy and it would appear that the problem is
memory reclaim driving the inode cache hard into reclaiming dirty
inodes and having to wait for IO to complete before it can make
progress. That's currently the only behaviour we have that stands
between "systems works" and "system can be driven into OOM kill
death by direct reclaim". i.e. it prevents memory reclaim from
skipping and making insufficient progress and winding the reclaim
priority up until it triggers the OOM killer because it takes a lot
of time to write back dirty inodes...

It looks like 4.18->4.19 has put a lot more pressure on the inode
caches and is driving them to block on dirty inodes much, much more
often. It would be instructive to know if this behaviour appeared in
4.19-rc1 or not, because the memory reclaim shrinker algorithms were
significantly changed in the 4.19 merge window....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
