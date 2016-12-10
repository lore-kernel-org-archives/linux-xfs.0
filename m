Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751288AbcLJGQo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Dec 2016 01:16:44 -0500
Date: Sat, 10 Dec 2016 14:16:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
 selecting an AG
Message-ID: <20161210061641.GQ29149@eguan.usersys.redhat.com>
References: <1481303709-12632-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481303709-12632-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Fri, Dec 09, 2016 at 06:15:09PM +0100, Christoph Hellwig wrote:
> We need to make sure that the indirect blocks (e.g. bmap btree blocks)
> can be allocated from the same AG [1] when comitting to an AG for a
> file data block allocation.  To do that we calculate the worst possible
> indirect len and subtract that from the free space in the AG.
> 
> I don't really like how this makes the space allocator call back into
> the bmap code (even if only for a trivial helper), but I can't think
> of a better idea.
> 
> [1] strictly speaking the same AG or one with a higher AG number, but
> that is so incredibly hard to express that we settle for the same AG.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I hit "Internal error xfs_trans_cancel" and force shutdown while running
xfs/109 in a loop with xfs_2k_reflink test config, first hit at 62nd
iteration then hit at 32nd iteration. Detailed log appended at the end.

Thanks,
Eryu

[225344.831364] run fstests xfs/109 at 2016-12-10 13:57:00
[225345.157908] XFS (dm-4): Unmounting Filesystem
[225345.181257] XFS (dm-4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[225345.190230] XFS (dm-4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[225345.198400] XFS (dm-4): Mounting V5 Filesystem
[225345.237656] XFS (dm-4): Ending clean mount
[225345.257859] XFS (dm-4): Unmounting Filesystem
[225345.396752] XFS (dm-4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[225345.405718] XFS (dm-4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[225345.413849] XFS (dm-4): Mounting V5 Filesystem
[225345.454561] XFS (dm-4): Ending clean mount
[225351.615787] XFS (dm-4): Unmounting Filesystem
[225351.644122] XFS (dm-4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[225351.653083] XFS (dm-4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[225351.661217] XFS (dm-4): Mounting V5 Filesystem
[225351.834617] XFS (dm-4): Ending clean mount
[225355.113963] XFS (dm-4): Internal error XFS_WANT_CORRUPTED_GOTO at line 3504 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_bmap_add_extent_delay_real+0x659/0x2090 [xfs]
[225355.129263] CPU: 0 PID: 14779 Comm: kworker/u49:2 Tainted: G           OE   4.9.0-rc1.xfs+ #7
[225355.137864] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[225355.147684] Workqueue: writeback wb_workfn (flush-253:4)
[225355.153153]  ffffc90003d874b0 ffffffff81363bec ffff88016f71c2b8 ffff88016f71c2b8
[225355.160704]  ffffc90003d874c8 ffffffffa07d018b ffffffffa0790fd9 ffffc90003d87578
[225355.168257]  ffffffffa079fba0 ffffc90003d874ec ffffc90003d875e4 0000000003d875e4
[225355.175811] Call Trace:
[225355.178352]  [<ffffffff81363bec>] dump_stack+0x63/0x87
[225355.183602]  [<ffffffffa07d018b>] xfs_error_report+0x3b/0x40 [xfs]
[225355.189885]  [<ffffffffa0790fd9>] ? xfs_bmap_add_extent_delay_real+0x659/0x2090 [xfs]
[225355.197818]  [<ffffffffa079fba0>] xfs_btree_insert+0x1b0/0x1c0 [xfs]
[225355.204279]  [<ffffffffa07b701b>] ? xfs_iext_insert+0x7b/0x110 [xfs]
[225355.210736]  [<ffffffffa0790fd9>] xfs_bmap_add_extent_delay_real+0x659/0x2090 [xfs]
[225355.218496]  [<ffffffffa079670b>] xfs_bmapi_write+0x78b/0xba0 [xfs]
[225355.224875]  [<ffffffffa07dc876>] xfs_iomap_write_allocate+0x196/0x3a0 [xfs]
[225355.232030]  [<ffffffffa07c5cbb>] xfs_map_blocks+0x1eb/0x260 [xfs]
[225355.238318]  [<ffffffffa07c6d7c>] xfs_do_writepage+0x1cc/0x6e0 [xfs]
[225355.244755]  [<ffffffff811ad8df>] write_cache_pages+0x26f/0x510
[225355.250761]  [<ffffffff81339daa>] ? blk_queue_bio+0x17a/0x3a0
[225355.256616]  [<ffffffffa07c6bb0>] ? xfs_vm_writepages+0xe0/0xe0 [xfs]
[225355.263168]  [<ffffffffa07c6b86>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[225355.269516]  [<ffffffff811ae8fe>] do_writepages+0x1e/0x30
[225355.275000]  [<ffffffff81260795>] __writeback_single_inode+0x45/0x330
[225355.281523]  [<ffffffff81260fd0>] writeback_sb_inodes+0x280/0x570
[225355.287699]  [<ffffffff8126148f>] wb_writeback+0x10f/0x320
[225355.293266]  [<ffffffff81261e29>] wb_workfn+0x109/0x3f0
[225355.298577]  [<ffffffff810a8be2>] process_one_work+0x152/0x400
[225355.304494]  [<ffffffff810a94d5>] worker_thread+0x125/0x4b0
[225355.310149]  [<ffffffff810a93b0>] ? rescuer_thread+0x380/0x380
[225355.316064]  [<ffffffff810af039>] kthread+0xd9/0xf0
[225355.321026]  [<ffffffff810aef60>] ? kthread_park+0x60/0x60
[225355.326597]  [<ffffffff8170ff95>] ret_from_fork+0x25/0x30
[225355.332179] XFS (dm-4): Internal error xfs_trans_cancel at line 983 of file fs/xfs/xfs_trans.c.  Caller xfs_iomap_write_allocate+0x2ed/0x3a0 [xfs]
[225355.345433] CPU: 0 PID: 14779 Comm: kworker/u49:2 Tainted: G           OE   4.9.0-rc1.xfs+ #7
[225355.354033] Hardware name: IBM System x3550 M3 -[7944OEJ]-/90Y4784     , BIOS -[D6E150CUS-1.11]- 02/08/2011
[225355.363849] Workqueue: writeback wb_workfn (flush-253:4)
[225355.369277]  ffffc90003d877b8 ffffffff81363bec ffff88016f71cae0 0000000000000001
[225355.376830]  ffffc90003d877d0 ffffffffa07d018b ffffffffa07dc9cd ffffc90003d877f8
[225355.384385]  ffffffffa07ee876 ffff88025244c380 ffff8802795d6000 ffffc90003d87878
[225355.391938] Call Trace:
[225355.394475]  [<ffffffff81363bec>] dump_stack+0x63/0x87
[225355.399724]  [<ffffffffa07d018b>] xfs_error_report+0x3b/0x40 [xfs]
[225355.406015]  [<ffffffffa07dc9cd>] ? xfs_iomap_write_allocate+0x2ed/0x3a0 [xfs]
[225355.413345]  [<ffffffffa07ee876>] xfs_trans_cancel+0xb6/0xe0 [xfs]
[225355.419637]  [<ffffffffa07dc9cd>] xfs_iomap_write_allocate+0x2ed/0x3a0 [xfs]
[225355.426792]  [<ffffffffa07c5cbb>] xfs_map_blocks+0x1eb/0x260 [xfs]
[225355.433080]  [<ffffffffa07c6d7c>] xfs_do_writepage+0x1cc/0x6e0 [xfs]
[225355.439515]  [<ffffffff811ad8df>] write_cache_pages+0x26f/0x510
[225355.445518]  [<ffffffff81339daa>] ? blk_queue_bio+0x17a/0x3a0
[225355.451375]  [<ffffffffa07c6bb0>] ? xfs_vm_writepages+0xe0/0xe0 [xfs]
[225355.457927]  [<ffffffffa07c6b86>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[225355.464278]  [<ffffffff811ae8fe>] do_writepages+0x1e/0x30
[225355.469762]  [<ffffffff81260795>] __writeback_single_inode+0x45/0x330
[225355.476286]  [<ffffffff81260fd0>] writeback_sb_inodes+0x280/0x570
[225355.482463]  [<ffffffff8126148f>] wb_writeback+0x10f/0x320
[225355.488030]  [<ffffffff81261e29>] wb_workfn+0x109/0x3f0
[225355.493340]  [<ffffffff810a8be2>] process_one_work+0x152/0x400
[225355.499254]  [<ffffffff810a94d5>] worker_thread+0x125/0x4b0
[225355.504908]  [<ffffffff810a93b0>] ? rescuer_thread+0x380/0x380
[225355.510823]  [<ffffffff810af039>] kthread+0xd9/0xf0
[225355.515784]  [<ffffffff810aef60>] ? kthread_park+0x60/0x60
[225355.521352]  [<ffffffff8170ff95>] ret_from_fork+0x25/0x30
[225355.526901] XFS (dm-4): xfs_do_force_shutdown(0x8) called from line 984 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa07ee88f
[225355.540790] XFS (dm-4): Corruption of in-memory data detected.  Shutting down filesystem
[225355.548976] XFS (dm-4): Please umount the filesystem and rectify the problem(s)
[225355.556445] buffer_io_error: 502 callbacks suppressed
[225355.561593] Buffer I/O error on dev dm-4, logical block 71048, lost async page write
[225355.569420] Buffer I/O error on dev dm-4, logical block 71049, lost async page write
[225355.577250] Buffer I/O error on dev dm-4, logical block 71050, lost async page write
[225355.585077] Buffer I/O error on dev dm-4, logical block 71051, lost async page write
[225355.592906] Buffer I/O error on dev dm-4, logical block 71052, lost async page write
[225355.600733] Buffer I/O error on dev dm-4, logical block 71053, lost async page write
[225355.608561] Buffer I/O error on dev dm-4, logical block 71054, lost async page write
[225355.616387] Buffer I/O error on dev dm-4, logical block 71055, lost async page write
[225355.624218] Buffer I/O error on dev dm-4, logical block 71056, lost async page write
[225355.632048] Buffer I/O error on dev dm-4, logical block 71057, lost async page write
[225355.967859] XFS (dm-4): xfs_log_force: error -5 returned.
[225355.991059] XFS (dm-4): Unmounting Filesystem
[225355.995525] XFS (dm-4): xfs_log_force: error -5 returned.
[225356.001435] XFS (dm-4): xfs_log_force: error -5 returned.
[225356.374195] XFS (dm-3): Unmounting Filesystem
