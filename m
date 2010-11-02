Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA20BbjT252432 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 19:11:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E086E137DF70
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 17:29:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	khWxK61v3eVc2OAd for <xfs@oss.sgi.com>;
	Mon, 01 Nov 2010 17:29:05 -0700 (PDT)
Date: Tue, 2 Nov 2010 11:12:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.32] scheduling while atomic
Message-ID: <20101102001244.GP2715@dastard>
References: <4CCED8B2.2030604@nangu.tv>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CCED8B2.2030604@nangu.tv>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Hamrle <martin.hamrle@nangu.tv>
Cc: xfs@oss.sgi.com

On Mon, Nov 01, 2010 at 04:11:46PM +0100, Martin Hamrle wrote:
> Hi,
> 
> I have box with xfs on sw raid5. There is permanent high read / write
> load. After almost month uptime kernel crashed with this traceback.

trimmed the stack so we can read it:

BUG: scheduling while atomic: tscpd/22653/0xffff8802
....
Pid: 22653, comm: tscpd Not tainted 2.6.32-bpo.3-amd64 #1
Call Trace:
[<ffffffff812ed71e>] ? schedule+0xce/0x7da
[<ffffffff811787fb>] ? __make_request+0x3a4/0x428
[<ffffffff81176f2b>] ? generic_make_request+0x299/0x2f9
[<ffffffff812ee253>] ? schedule_timeout+0x2e/0xdd
[<ffffffff8105a432>] ? lock_timer_base+0x26/0x4b
[<ffffffff812ee118>] ? wait_for_common+0xde/0x14f
[<ffffffff8104a188>] ? default_wake_function+0x0/0x9
[<ffffffffa036d74a>] ? unplug_slaves+0x7f/0xb4 [raid456]
[<ffffffffa0306968>] ? xfs_buf_iowait+0x27/0x30 [xfs]
[<ffffffffa0307fd5>] ? xfs_buf_read_flags+0x4a/0x7a [xfs]
[<ffffffffa02ff5cd>] ? xfs_trans_read_buf+0x189/0x27e [xfs]
[<ffffffffa02d91b9>] ? xfs_btree_read_buf_block+0x4a/0x8f [xfs]
[<ffffffffa02da1e3>] ? xfs_btree_lookup_get_block+0x87/0xac [xfs]
[<ffffffffa02da7a9>] ? xfs_btree_lookup+0x12a/0x3cc [xfs]
[<ffffffffa030477e>] ? kmem_zone_zalloc+0x1e/0x2e [xfs]
[<ffffffffa02ff506>] ? xfs_trans_read_buf+0xc2/0x27e [xfs]
[<ffffffffa02c66f2>] ? xfs_alloc_fixup_trees+0x39/0x296 [xfs]
[<ffffffffa02c8600>] ? xfs_alloc_ag_vextent_near+0x96b/0x9e0 [xfs]
[<ffffffffa02c86a0>] ? xfs_alloc_ag_vextent+0x2b/0xef [xfs]
[<ffffffffa02c8d3d>] ? xfs_alloc_vextent+0x144/0x3e3 [xfs]
[<ffffffffa02d1983>] ? xfs_bmap_extents_to_btree+0x1df/0x3a6 [xfs]
[<ffffffff810e43fd>] ? virt_to_head_page+0x9/0x2b
[<ffffffffa02d2484>] ? xfs_bmap_add_extent_delay_real+0x93a/0x101d [xfs]
[<ffffffffa02c6af5>] ? xfs_alloc_search_busy+0x2d/0x97 [xfs]
[<ffffffffa02c8f55>] ? xfs_alloc_vextent+0x35c/0x3e3 [xfs]
[<ffffffffa02d2d77>] ? xfs_bmap_add_extent+0x210/0x3a3 [xfs]
[<ffffffffa02d60cb>] ? xfs_bmapi+0xa42/0x104d [xfs]
[<ffffffff810e3033>] ? get_partial_node+0x15/0x79
[<ffffffffa02fe63f>] ? xfs_trans_reserve+0xc8/0x19d [xfs]
[<ffffffffa02f0d8f>] ? xfs_iomap_write_allocate+0x245/0x387 [xfs]
[<ffffffffa02f1804>] ? xfs_iomap+0x213/0x287 [xfs]
[<ffffffffa0304fbd>] ? xfs_map_blocks+0x25/0x2c [xfs]
[<ffffffff8118a654>] ? radix_tree_delete+0xbf/0x1ba
[<ffffffffa0305be5>] ? xfs_page_state_convert+0x299/0x565 [xfs]
[<ffffffffa0305f49>] ? xfs_vm_releasepage+0x98/0xa5 [xfs]
[<ffffffffa030612c>] ? xfs_vm_writepage+0xb0/0xe5 [xfs]
[<ffffffff810bd12c>] ? shrink_page_list+0x369/0x617
[<ffffffff810bdaf1>] ? shrink_list+0x44a/0x725
[<ffffffffa02dbc9d>] ? xfs_btree_delrec+0x630/0xe0e [xfs]
[<ffffffff810b4b7c>] ? mempool_alloc+0x55/0x106
[<ffffffff810be04c>] ? shrink_zone+0x280/0x342
[<ffffffff810bf110>] ? try_to_free_pages+0x232/0x38e
[<ffffffff810bc177>] ? isolate_pages_global+0x0/0x20f
[<ffffffff810b92c5>] ? __alloc_pages_nodemask+0x3bb/0x5ce
[<ffffffff8101184e>] ? reschedule_interrupt+0xe/0x20
[<ffffffffa02ec658>] ? xfs_iext_bno_to_ext+0xba/0x140 [xfs]
[<ffffffff810e5190>] ? new_slab+0x42/0x1ca
[<ffffffff810e5508>] ? __slab_alloc+0x1f0/0x39b
[<ffffffffa030471a>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
[<ffffffffa030471a>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
[<ffffffff810e59e5>] ? kmem_cache_alloc+0x7f/0xf0
[<ffffffffa030471a>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
[<ffffffffa030476e>] ? kmem_zone_zalloc+0xe/0x2e [xfs]
[<ffffffffa02fe740>] ? _xfs_trans_alloc+0x2c/0x67 [xfs]
[<ffffffffa02fe976>] ? xfs_trans_alloc+0x90/0x9a [xfs]
[<ffffffffa02feb0b>] ? xfs_trans_unlocked_item+0x20/0x39 [xfs]
[<ffffffffa02bfb1e>] ? xfs_qm_dqattach+0x32/0x3b [xfs]
[<ffffffffa02f0bfd>] ? xfs_iomap_write_allocate+0xb3/0x387 [xfs]
[<ffffffffa010eb6b>] ? md_make_request+0xb6/0xf1 [md_mod]
[<ffffffffa03053c4>] ? xfs_start_page_writeback+0x24/0x37 [xfs]
[<ffffffffa02f1804>] ? xfs_iomap+0x213/0x287 [xfs]
[<ffffffffa0304fbd>] ? xfs_map_blocks+0x25/0x2c [xfs]
[<ffffffffa0305be5>] ? xfs_page_state_convert+0x299/0x565 [xfs]
[<ffffffff81047f25>] ? finish_task_switch+0x3a/0xa7
[<ffffffffa030612c>] ? xfs_vm_writepage+0xb0/0xe5 [xfs]
[<ffffffff810b94e2>] ? __writepage+0xa/0x25
[<ffffffff810b9b69>] ? write_cache_pages+0x20b/0x327
[<ffffffff810b94d8>] ? __writepage+0x0/0x25
[<ffffffff8110637e>] ? writeback_single_inode+0xe7/0x2da
[<ffffffff81107057>] ? writeback_inodes_wb+0x423/0x4fe
[<ffffffff810ba2cf>] ? balance_dirty_pages_ratelimited_nr+0x192/0x332
[<ffffffff810b3ea2>] ? generic_file_buffered_write+0x1f5/0x278
[<ffffffffa030ba8e>] ? xfs_write+0x4df/0x6ea [xfs]
[<ffffffff810cf993>] ? vma_adjust+0x1a3/0x40f
[<ffffffff810ed1da>] ? do_sync_write+0xce/0x113
[<ffffffff81064a36>] ? autoremove_wake_function+0x0/0x2e
[<ffffffff810d0dc4>] ? mmap_region+0x3b5/0x4f3
[<ffffffff810edb52>] ? vfs_write+0xa9/0x102
[<ffffffff810edc67>] ? sys_write+0x45/0x6e
[<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

With a trace like that, it's almost certain that you've blown
the stack and that is why the system is crashing. Can you turn on
stack depth checking (might require a kernel rebuild) so we can tell
if these problems are a result of overruning the stack?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
