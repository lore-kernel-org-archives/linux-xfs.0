Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932112AbeGFFIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 01:08:09 -0400
Date: Thu, 5 Jul 2018 22:08:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: fuzz every field of every structure and test
 kernel crashes
Message-ID: <20180706050805.GT32415@magnolia>
References: <153067982461.28315.11621030236927888645.stgit@magnolia>
 <153067983717.28315.16483133462251633709.stgit@magnolia>
 <20180706043109.GC2780@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180706043109.GC2780@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jul 06, 2018 at 12:31:09PM +0800, Eryu Guan wrote:
> On Tue, Jul 03, 2018 at 09:50:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fuzz every field of every structure and then try to write the
> > filesystem, to see how many of these writes can crash the kernel.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The "re-repair" failures are gone, but I still see some test failures
> like (xfs/1398 for example)
> 
> +re-mount failed (32) with magic = zeroes.
> +re-mount failed (32) with magic = ones.
> ...
> 
> Looks like the re-mount is expected to fail as we skipped all the repair work.

Yeah, these tests are going to throw a /lot/ of errors as we try to see
if we can get the kernel to blow up on deliberately garbage filesystems.
They're not expected to pass ever, except in the sense that the kernel
doesn't just crash. :)

> Also, there're _check_dmesg failures too (they were buried among other
> failures so I didn't notice them in last review), like this "Internal
> error" from xfs/1397

But yeah, I will add _check_dmesg to all of the tests before the next
submission (unless you commit it before then).

--D

> [1513573.879719] [U] ++ Try to write filesystem again
> [1513574.092652] XFS (dm-1): Internal error XFS_WANT_CORRUPTED_GOTO at line 756 of file fs/xfs/libxfs/xfs_rmap.c.  Caller xfs_rmap_finish_one+0x206/0x2b0 [xfs]
> [1513574.094001] CPU: 1 PID: 7087 Comm: kworker/u4:2 Tainted: G        W  OE     4.18.0-rc1 #1
> [1513574.094839] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.fc28 04/01/2014
> [1513574.095650] Workqueue: writeback wb_workfn (flush-253:1)
> [1513574.096145] Call Trace:
> [1513574.096390]  dump_stack+0x5c/0x80
> [1513574.096719]  xfs_rmap_map+0x18c/0x8d0 [xfs]
> [1513574.097138]  ? xfs_free_extent_fix_freelist+0x7d/0xb0 [xfs]
> [1513574.097662]  ? _cond_resched+0x15/0x30
> [1513574.098021]  ? kmem_cache_alloc+0x16a/0x1d0
> [1513574.098435]  ? kmem_zone_alloc+0x61/0xe0 [xfs]
> [1513574.098877]  xfs_rmap_finish_one+0x206/0x2b0 [xfs]
> [1513574.099355]  ? xfs_trans_free+0x55/0xc0 [xfs]
> [1513574.099788]  xfs_trans_log_finish_rmap_update+0x2f/0x40 [xfs]
> [1513574.100346]  xfs_rmap_update_finish_item+0x2d/0x40 [xfs]
> [1513574.100865]  xfs_defer_finish+0x164/0x470 [xfs]
> [1513574.101318]  ? xfs_rmap_update_cancel_item+0x10/0x10 [xfs]
> [1513574.101852]  xfs_iomap_write_allocate+0x182/0x370 [xfs]
> [1513574.102371]  xfs_map_blocks+0x209/0x290 [xfs]
> [1513574.102819]  xfs_do_writepage+0x147/0x690 [xfs]
> [1513574.103265]  ? clear_page_dirty_for_io+0x224/0x290
> [1513574.103718]  write_cache_pages+0x1dc/0x450
> [1513574.104141]  ? xfs_vm_readpage+0x70/0x70 [xfs]
> [1513574.104594]  ? btrfs_wq_submit_bio+0xc9/0xf0 [btrfs]
> [1513574.105098]  xfs_vm_writepages+0x59/0x90 [xfs]
> [1513574.105534]  do_writepages+0x41/0xd0
> [1513574.105886]  ? __switch_to_asm+0x40/0x70
> [1513574.106281]  ? __switch_to_asm+0x34/0x70
> [1513574.106673]  ? __switch_to_asm+0x40/0x70
> [1513574.107067]  ? __switch_to_asm+0x34/0x70
> [1513574.107453]  ? __switch_to_asm+0x40/0x70
> [1513574.107843]  ? __switch_to_asm+0x34/0x70
> [1513574.108235]  ? __switch_to_asm+0x40/0x70
> [1513574.108623]  ? __switch_to_asm+0x34/0x70
> [1513574.109016]  ? __switch_to_asm+0x40/0x70
> [1513574.109406]  ? __switch_to_asm+0x40/0x70
> [1513574.109790]  __writeback_single_inode+0x3d/0x350
> [1513574.110247]  writeback_sb_inodes+0x1d0/0x460
> [1513574.110669]  __writeback_inodes_wb+0x5d/0xb0
> [1513574.111172]  wb_writeback+0x255/0x2f0
> [1513574.111535]  ? get_nr_inodes+0x35/0x50
> [1513574.111904]  ? cpumask_next+0x16/0x20
> [1513574.112273]  wb_workfn+0x186/0x400
> [1513574.112608]  ? sched_clock+0x5/0x10
> [1513574.112955]  process_one_work+0x1a1/0x350
> [1513574.113343]  worker_thread+0x30/0x380
> [1513574.113702]  ? wq_update_unbound_numa+0x1a0/0x1a0
> [1513574.114158]  kthread+0x112/0x130
> [1513574.114484]  ? kthread_create_worker_on_cpu+0x70/0x70
> [1513574.114980]  ret_from_fork+0x35/0x40
> [1513574.115352] XFS (dm-1): xfs_do_force_shutdown(0x8) called from line 222 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0000000000b9898a
> [1513574.309527] XFS (dm-1): Corruption of in-memory data detected.  Shutting down filesystem
> [1513574.313154] XFS (dm-1): Please umount the filesystem and rectify the problem(s)
> 
> Should the dmesg check be disabled as well?
> 
> Thanks,
> Eryu
> 
> P.S.
> BTW, patch 1/1 looks fine, I'll take it for this week's update.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
