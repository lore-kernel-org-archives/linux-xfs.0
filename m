Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OBEXHE233510 for <xfs@oss.sgi.com>; Thu, 24 May 2012 06:14:34 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id eONm3LNyYg9eBFpl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 May 2012 04:14:31 -0700 (PDT)
Message-ID: <4FBE1823.2050303@profihost.ag>
Date: Thu, 24 May 2012 13:14:43 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: xfs: blocked task in xfs_buf_lock
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, gregkh@linuxfoundation.org, stable@vger.kernel.org

Hi list,

while testing ceph cluster and using XFS as the underlying filesystem,
i've seen xfs blocking tasks several times.

Kernel: 3.0.30 plus a patch labeled "xfs: don't wait for all pending I/O
in ->write_inode" you (Christoph) send me some month ago.

INFO: task ceph-osd:3065 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ceph-osd        D ffff8803b0e61d88     0  3065      1 0x00000004
 ffff88032f3ab7f8 0000000000000086 ffff8803bffdac08 ffff880300000000
 ffff8803b0e61820 0000000000010800 ffff88032f3abfd8 ffff88032f3aa010
 ffff88032f3abfd8 0000000000010800 ffffffff81a0b020 ffff8803b0e61820
Call Trace:
 [<ffffffff815e0e1a>] schedule+0x3a/0x60
 [<ffffffff815e127d>] schedule_timeout+0x1fd/0x2e0
 [<ffffffff812696c4>] ? xfs_iext_bno_to_ext+0x84/0x160
 [<ffffffff81074db1>] ? down_trylock+0x31/0x50
 [<ffffffff812696c4>] ? xfs_iext_bno_to_ext+0x84/0x160
 [<ffffffff815e20b9>] __down+0x69/0xb0
 [<ffffffff8128c4a6>] ? _xfs_buf_find+0xf6/0x280
 [<ffffffff81074e6b>] down+0x3b/0x50
 [<ffffffff8128b7b0>] xfs_buf_lock+0x40/0xe0
 [<ffffffff8128c4a6>] _xfs_buf_find+0xf6/0x280
 [<ffffffff8128c689>] xfs_buf_get+0x59/0x190
 [<ffffffff8128ccf7>] xfs_buf_read+0x27/0x100
 [<ffffffff81282f97>] xfs_trans_read_buf+0x1e7/0x420
 [<ffffffff81239371>] xfs_read_agf+0x61/0x1a0
 [<ffffffff812394e4>] xfs_alloc_read_agf+0x34/0xd0
 [<ffffffff8123c877>] xfs_alloc_fix_freelist+0x3f7/0x470
 [<ffffffff81288005>] ? kmem_free+0x35/0x40
 [<ffffffff8127ff6e>] ? xfs_trans_free_item_desc+0x2e/0x30
 [<ffffffff812800a7>] ? xfs_trans_free_items+0x87/0xb0
 [<ffffffff8127cc73>] ? xfs_perag_get+0x33/0xb0
 [<ffffffff8123c97f>] ? xfs_free_extent+0x8f/0x120
 [<ffffffff8123c990>] xfs_free_extent+0xa0/0x120
 [<ffffffff81287f07>] ? kmem_zone_alloc+0x77/0xf0
 [<ffffffff81245ead>] xfs_bmap_finish+0x15d/0x1a0
 [<ffffffff8126d15e>] xfs_itruncate_finish+0x15e/0x340
 [<ffffffff81285495>] xfs_setattr+0x365/0x980
 [<ffffffff812926e6>] xfs_vn_setattr+0x16/0x20
 [<ffffffff8111e0ad>] notify_change+0x11d/0x300
 [<ffffffff81103ccc>] do_truncate+0x5c/0x90
 [<ffffffff8110ea35>] ? get_write_access+0x15/0x50
 [<ffffffff81103ef7>] sys_truncate+0x127/0x130
 [<ffffffff815e367b>] system_call_fastpath+0x16/0x1b
INFO: task flush-8:16:3089 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:16      D ffff8803af0d9d88     0  3089      2 0x00000000
 ffff88032e835940 0000000000000046 0000000100000fe0 ffff880300000000
 ffff8803af0d9820 0000000000010800 ffff88032e835fd8 ffff88032e834010
 ffff88032e835fd8 0000000000010800 ffff8803b0f7e080 ffff8803af0d9820
Call Trace:
 [<ffffffff810be570>] ? __lock_page+0x70/0x70
 [<ffffffff815e0e1a>] schedule+0x3a/0x60
 [<ffffffff815e0ec7>] io_schedule+0x87/0xd0
 [<ffffffff810be579>] sleep_on_page+0x9/0x10
 [<ffffffff815e1412>] __wait_on_bit_lock+0x52/0xb0
 [<ffffffff810be562>] __lock_page+0x62/0x70
 [<ffffffff8106fb80>] ? autoremove_wake_function+0x40/0x40
 [<ffffffff810c8fd0>] ? pagevec_lookup_tag+0x20/0x30
 [<ffffffff810c7f66>] write_cache_pages+0x386/0x4d0
 [<ffffffff810c6c10>] ? set_page_dirty+0x70/0x70
 [<ffffffff810fd7ab>] ? kmem_cache_free+0x1b/0xe0
 [<ffffffff810c80fc>] generic_writepages+0x4c/0x70
 [<ffffffff81288bcf>] xfs_vm_writepages+0x4f/0x60
 [<ffffffff810c813c>] do_writepages+0x1c/0x40
 [<ffffffff81128854>] writeback_single_inode+0xf4/0x260
 [<ffffffff81128c45>] writeback_sb_inodes+0xe5/0x1b0
 [<ffffffff811290a8>] writeback_inodes_wb+0x98/0x160
 [<ffffffff81129ac3>] wb_writeback+0x2f3/0x460
 [<ffffffff815e089e>] ? __schedule+0x3ae/0x850
 [<ffffffff8105df47>] ? lock_timer_base+0x37/0x70
 [<ffffffff81129e4f>] wb_do_writeback+0x21f/0x270
 [<ffffffff81129f3a>] bdi_writeback_thread+0x9a/0x230
 [<ffffffff81129ea0>] ? wb_do_writeback+0x270/0x270
 [<ffffffff81129ea0>] ? wb_do_writeback+0x270/0x270
 [<ffffffff8106f646>] kthread+0x96/0xa0
 [<ffffffff815e46d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106f5b0>] ? kthread_worker_fn+0x130/0x130
 [<ffffffff815e46d0>] ? gs_change+0xb/0xb

Thanks and greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
