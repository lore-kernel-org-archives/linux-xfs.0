Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:42128 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729245AbeLOFeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Dec 2018 00:34:37 -0500
Received: by mail-lj1-f177.google.com with SMTP id l15-v6so6661110lja.9
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 21:34:35 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Date: Sat, 15 Dec 2018 13:34:33 +0800
Message-ID: <CAJDdQW1bUSZ+3p-4XMbtzU0y5SifQnnwmStKGhb5dkozCaExoA@mail.gmail.com>
Subject: XFS: 3-way deadlock with xfs_dquot, xfs_buf and xfs_inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>

Hi Developpers and XFS,

There seems to be a deadlock involving 3 threads: 1) the fsync thread
has acquired the project quota lock, and is trying to get the xfs_buf
(it's a an agf); 2) the xfs_buf is attached to a transaction, and
xfs_end_io is trying to get the xfs_inode ilock; 3) the write thread
has acquired the xfs_inode ilock, and tries to get the xfs_dquot.
Below are the traces.

INFO: task xxx-super:14692 blocked for more than 120 seconds.
---------------------------------------
Call Trace:
 schedule+0x29/0x70
 schedule_timeout+0x239/0x2c0
 ? kmem_cache_alloc+0x1ba/0x1e0
 ? kmem_zone_alloc+0x97/0x130 [xfs]
 ? kmem_zone_alloc+0x97/0x130 [xfs]
 __down_common+0x108/0x154
 ? i40e_xmit_frame_ring+0x3f0/0x12d0 [i40e]
 ? _xfs_buf_find+0x176/0x340 [xfs]
 __down+0x1d/0x1f
 down+0x41/0x50
 xfs_buf_lock+0x3c/0xd0 [xfs]
 _xfs_buf_find+0x176/0x340 [xfs]
 xfs_buf_get_map+0x2a/0x240 [xfs]
 xfs_buf_read_map+0x30/0x160 [xfs]
 xfs_trans_read_buf_map+0x211/0x400 [xfs]
 xfs_read_agf+0x93/0x110 [xfs]
 xfs_alloc_read_agf+0x4b/0x110 [xfs]
 xfs_alloc_fix_freelist+0x34b/0x410 [xfs]
 ? xfs_bmap_add_extent_hole_delay+0xe0/0x5e0 [xfs]
 ? radix_tree_lookup+0xd/0x10
 ? xfs_perag_get+0x2a/0xb0 [xfs]
 ? radix_tree_lookup+0xd/0x10
 ? xfs_perag_get+0x2a/0xb0 [xfs]
 xfs_alloc_vextent+0x294/0x5f0 [xfs]
 xfs_bmap_btalloc+0x3f3/0x780 [xfs]
 xfs_bmap_alloc+0xe/0x10 [xfs]
 xfs_bmapi_write+0x499/0xab0 [xfs]
 xfs_iomap_write_allocate+0x177/0x390 [xfs] (xfs_qm_dqattach)
 xfs_map_blocks+0x1a6/0x210 [xfs]
 xfs_do_writepage+0x17b/0x550 [xfs]
 write_cache_pages+0x251/0x4d0
 ? xfs_aops_discard_page+0x150/0x150 [xfs]
 ? try_to_wake_up+0x1c8/0x320
 xfs_vm_writepages+0xc5/0xe0 [xfs]
 do_writepages+0x1e/0x40
__filemap_fdatawrite_range+0x65/0x80
 filemap_write_and_wait_range+0x41/0x90
 xfs_file_fsync+0x66/0x1e0 [xfs]
 do_fsync+0x65/0xa0
 ? SyS_write+0x9f/0xe0
 SyS_fsync+0x10/0x20
 system_call_fastpath+0x16/0x1b

Workqueue: xfs-data/md1 xfs_end_io
-------------------------------------
Call Trace:
 schedule+0x29/0x70
 rwsem_down_write_failed+0x115/0x220
 ? load_balance+0x1e2/0x990
 ? xfs_setfilesize+0x2d/0x100 [xfs]
 call_rwsem_down_write_failed+0x17/0x30
 down_write+0x2d/0x30
 xfs_ilock+0xc1/0x120 [xfs]
 xfs_setfilesize+0x2d/0x100 [xfs]
 xfs_setfilesize_ioend+0x4a/0x60 [xfs]
 xfs_end_io+0x43/0x80 [xfs]
 process_one_work+0x17b/0x470
 worker_thread+0x126/0x410
 ? rescuer_thread+0x460/0x460
 kthread+0xcf/0xe0
 ? kthread_create_on_node+0x140/0x140
 ret_from_fork+0x58/0x90
 kthread_create_on_node+0x140/0x140

INFO: task java:39107 blocked for more than 120 seconds.
-------------------------------------
 Call Trace:
 schedule_preempt_disabled+0x29/0x70
 __mutex_lock_slowpath+0xc5/0x1c0
 mutex_lock+0x1f/0x2f
 xfs_trans_dqresv+0x44/0x470 [xfs]
 xfs_trans_reserve_quota_bydquots+0x11e/0x180 [xfs]
 xfs_trans_reserve_quota_nblks+0x5f/0x70 [xfs]
 xfs_bmapi_reserve_delalloc+0x87/0x1f0 [xfs]
 xfs_bmapi_delay+0x12b/0x2a0 [xfs]
 xfs_iomap_write_delay+0x178/0x2e0 [xfs]
 __xfs_get_blocks+0x4c3/0x7d0 [xfs] (xfs_ilock)
 xfs_get_blocks+0x14/0x20 [xfs]
 __block_write_begin+0x1a7/0x490
 ? __xfs_get_blocks+0x7d0/0x7d0 [xfs]
 ? grab_cache_page_write_begin+0x9b/0xd0
 xfs_vm_write_begin+0x51/0xe0 [xfs]
 ? xfs_vm_write_end+0x29/0x80 [xfs]
 generic_file_buffered_write+0x11e/0x2a0
 xfs_file_buffered_aio_write+0x10b/0x260 [xfs]
 xfs_file_aio_write+0x18d/0x1a0 [xfs]
 do_sync_write+0x8d/0xd0
 vfs_write+0xbd/0x1e0
 SyS_write+0x7f/0xe0
 tracesys+0xdd/0xe2

Once they lockup, kworkers are blocked on xfs_dquot, leading to dirty
pages piling up on memory cgroup. Then a bunch of threads won't get
pages in path:
__alloc_pages_nodemask
mem_cgoup_reclaim
  shrink_zone
    shrink_page_list
      wait_on_page_writeback

It's 3.10.0-514.16.1.el7.x86_64 kernel, met about 10-20 times a week
on several hundred of servers.

Actually I'm not quite sure about the scenario, or whether it has been
fixed in mainline.

Thank you very much,
Benlong
