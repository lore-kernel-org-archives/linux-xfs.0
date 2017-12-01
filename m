Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mails2n0-route0.email.arizona.edu ([128.196.130.122]:31771 "EHLO
        mails2n0-route0.email.arizona.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751265AbdLAWom (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 17:44:42 -0500
From: Chandler <admin@genome.arizona.edu>
Subject: Filesystem crash
Message-ID: <3f4d2b55-9dd1-bc5a-2e49-cdfdc9a134b3@genome.arizona.edu>
Date: Fri, 1 Dec 2017 15:35:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi, we had our filesystem crash the other day after getting 100% full 
(although 53GB were still reported free).  I had to reboot the system 
and use xfs_repair.  It seem to me this shouldn't happen just because it 
got full, so maybe there is some other issue?  The filesystem resides on 
an MD RAID-5 array with 4x 2TB disks that are in good health, the array 
gets checked weekly by mdadm.  The only error messages in the system log 
were related to XFS (see below).  The OS is RHEL 6.9 with kernel 
2.6.32-642.11.1.el6.x86_64.
Thanks,
-- 
Chandler / Systems Administrator
Arizona Genomics Institute
www.genome.arizona.edu


Nov 24 04:09:05 sma kernel: XFS: Internal error XFS_WANT_CORRUPTED_GOTO 
at line 1339 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa03c67bd
Nov 24 04:09:05 sma kernel:
Nov 24 04:09:05 sma kernel: Pid: 31989, comm: flush-9:126 Not tainted 
2.6.32-642.11.1.el6.x86_64 #1
Nov 24 04:09:05 sma kernel: Call Trace:
Nov 24 04:09:05 sma kernel: [<ffffffffa03f068f>] ? 
xfs_error_report+0x3f/0x50 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03c67bd>] ? 
xfs_alloc_ag_vextent+0xfd/0x150 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03c3d09>] ? 
xfs_alloc_lookup_eq+0x19/0x20 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03c58cf>] ? 
xfs_alloc_ag_vextent_size+0x38f/0x630 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03c67bd>] ? 
xfs_alloc_ag_vextent+0xfd/0x150 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03c720c>] ? 
xfs_alloc_vextent+0x2bc/0x610 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03d1d08>] ? 
xfs_bmap_btalloc+0x398/0x700 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03d207e>] ? 
xfs_bmap_alloc+0xe/0x10 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03d8986>] ? 
xfs_bmapi+0x9b6/0x1040 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03cfe0d>] ? 
xfs_bmap_search_multi_extents+0xad/0x120 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa0415f87>] ? 
kmem_zone_alloc+0x77/0xf0 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03fc128>] ? 
xfs_iomap_write_allocate+0x168/0x3c0 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa0417ae3>] ? 
xfs_map_blocks+0x193/0x250 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa04185c9>] ? 
xfs_vm_writepage+0x1f9/0x590 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffff81142237>] ? __writepage+0x17/0x40
Nov 24 04:09:05 sma kernel: [<ffffffff811434fd>] ? 
write_cache_pages+0x1fd/0x4c0
Nov 24 04:09:05 sma kernel: [<ffffffff81142220>] ? __writepage+0x0/0x40
Nov 24 04:09:05 sma kernel: [<ffffffff811437e4>] ? 
generic_writepages+0x24/0x30
Nov 24 04:09:05 sma kernel: [<ffffffffa041790d>] ? 
xfs_vm_writepages+0x5d/0x80 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffff81143811>] ? do_writepages+0x21/0x40
Nov 24 04:09:05 sma kernel: [<ffffffff811c6e7d>] ? 
writeback_single_inode+0xdd/0x290
Nov 24 04:09:05 sma kernel: [<ffffffff811c727d>] ? 
writeback_sb_inodes+0xbd/0x170
Nov 24 04:09:05 sma kernel: [<ffffffff811c73db>] ? 
writeback_inodes_wb+0xab/0x1b0
Nov 24 04:09:05 sma kernel: [<ffffffff811c77d3>] ? wb_writeback+0x2f3/0x410
Nov 24 04:09:05 sma kernel: [<ffffffff8108fbb2>] ? del_timer_sync+0x22/0x30
Nov 24 04:09:05 sma kernel: [<ffffffff811c7a95>] ? 
wb_do_writeback+0x1a5/0x240
Nov 24 04:09:05 sma kernel: [<ffffffff811c7b93>] ? 
bdi_writeback_task+0x63/0x1b0
Nov 24 04:09:05 sma kernel: [<ffffffff810a6727>] ? bit_waitqueue+0x17/0xd0
Nov 24 04:09:05 sma kernel: [<ffffffff811529f0>] ? bdi_start_fn+0x0/0x100
Nov 24 04:09:05 sma kernel: [<ffffffff81152a76>] ? bdi_start_fn+0x86/0x100
Nov 24 04:09:05 sma kernel: [<ffffffff811529f0>] ? bdi_start_fn+0x0/0x100
Nov 24 04:09:05 sma kernel: [<ffffffff810a640e>] ? kthread+0x9e/0xc0
Nov 24 04:09:05 sma kernel: [<ffffffff8100c28a>] ? child_rip+0xa/0x20
Nov 24 04:09:05 sma kernel: [<ffffffff810a6370>] ? kthread+0x0/0xc0
Nov 24 04:09:05 sma kernel: [<ffffffff8100c280>] ? child_rip+0x0/0x20
Nov 24 04:09:05 sma kernel: XFS (md126p1): Internal error 
xfs_trans_cancel at line 1948 of file fs/xfs/xfs_trans.c.  Caller 
0xffffffffa03fc25d
Nov 24 04:09:05 sma kernel:
Nov 24 04:09:05 sma kernel: Pid: 31989, comm: flush-9:126 Not tainted 
2.6.32-642.11.1.el6.x86_64 #1
Nov 24 04:09:05 sma kernel: Call Trace:
Nov 24 04:09:05 sma kernel: [<ffffffffa03f068f>] ? 
xfs_error_report+0x3f/0x50 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03fc25d>] ? 
xfs_iomap_write_allocate+0x29d/0x3c0 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa040e495>] ? 
xfs_trans_cancel+0xf5/0x120 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa03fc25d>] ? 
xfs_iomap_write_allocate+0x29d/0x3c0 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa0417ae3>] ? 
xfs_map_blocks+0x193/0x250 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffffa04185c9>] ? 
xfs_vm_writepage+0x1f9/0x590 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffff81142237>] ? __writepage+0x17/0x40
Nov 24 04:09:05 sma kernel: [<ffffffff811434fd>] ? 
write_cache_pages+0x1fd/0x4c0
Nov 24 04:09:05 sma kernel: [<ffffffff81142220>] ? __writepage+0x0/0x40
Nov 24 04:09:05 sma kernel: [<ffffffff811437e4>] ? 
generic_writepages+0x24/0x30
Nov 24 04:09:05 sma kernel: [<ffffffffa041790d>] ? 
xfs_vm_writepages+0x5d/0x80 [xfs]
Nov 24 04:09:05 sma kernel: [<ffffffff81143811>] ? do_writepages+0x21/0x40
Nov 24 04:09:05 sma kernel: [<ffffffff811c6e7d>] ? 
writeback_single_inode+0xdd/0x290
Nov 24 04:09:05 sma kernel: [<ffffffff811c727d>] ? 
writeback_sb_inodes+0xbd/0x170
Nov 24 04:09:05 sma kernel: [<ffffffff811c73db>] ? 
writeback_inodes_wb+0xab/0x1b0
Nov 24 04:09:05 sma kernel: [<ffffffff811c77d3>] ? wb_writeback+0x2f3/0x410
Nov 24 04:09:05 sma kernel: [<ffffffff8108fbb2>] ? del_timer_sync+0x22/0x30
Nov 24 04:09:05 sma kernel: [<ffffffff811c7a95>] ? 
wb_do_writeback+0x1a5/0x240
Nov 24 04:09:05 sma kernel: [<ffffffff811c7b93>] ? 
bdi_writeback_task+0x63/0x1b0
Nov 24 04:09:05 sma kernel: [<ffffffff810a6727>] ? bit_waitqueue+0x17/0xd0
Nov 24 04:09:05 sma kernel: [<ffffffff811529f0>] ? bdi_start_fn+0x0/0x100
Nov 24 04:09:05 sma kernel: [<ffffffff81152a76>] ? bdi_start_fn+0x86/0x100
Nov 24 04:09:05 sma kernel: [<ffffffff811529f0>] ? bdi_start_fn+0x0/0x100
Nov 24 04:09:05 sma kernel: [<ffffffff810a640e>] ? kthread+0x9e/0xc0
Nov 24 04:09:05 sma kernel: [<ffffffff8100c28a>] ? child_rip+0xa/0x20
Nov 24 04:09:05 sma kernel: [<ffffffff810a6370>] ? kthread+0x0/0xc0
Nov 24 04:09:05 sma kernel: [<ffffffff8100c280>] ? child_rip+0x0/0x20
Nov 24 04:09:05 sma kernel: XFS (md126p1): xfs_do_force_shutdown(0x8) 
called from line 1949 of file fs/xfs/xfs_trans.c.  Return address = 
0xffffffffa040e4ae
Nov 24 04:09:06 sma kernel: XFS (md126p1): Corruption of in-memory data 
detected.  Shutting down filesystem
Nov 24 04:09:06 sma kernel: XFS (md126p1): Please umount the filesystem 
and rectify the problem(s)
Nov 24 04:09:06 sma kernel: XFS (md126p1): xfs_log_force: error 5 returned.
Nov 24 04:09:06 sma kernel: XFS (md126p1): xfs_log_force: error 5 returned.
Nov 24 04:09:16 sma kernel: XFS (md126p1): xfs_log_force: error 5 returned.
Nov 24 04:09:46 sma kernel: XFS (md126p1): xfs_log_force: error 5 returned.
this error continues to be repeated until system is rebooted
