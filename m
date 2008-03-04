Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 14:05:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m24M5VBS001732
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 14:05:32 -0800
Received: from web32504.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 1D48D650992
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2008 14:06:00 -0800 (PST)
Received: from web32504.mail.mud.yahoo.com (web32504.mail.mud.yahoo.com [68.142.207.214]) by cuda.sgi.com with SMTP id pERavPbWZQ7iWdsY for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 14:06:00 -0800 (PST)
Date: Tue, 4 Mar 2008 14:05:59 -0800 (PST)
From: Ravi Wijayaratne <ravi_wija@yahoo.com>
Subject: corruption in xfs_end_bio_unwritten 
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <629727.55106.qm@web32504.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I am seeing data corruption in xfs_end_bio_unwritten. Possibly the corruption is happening before.
Here is what I see.

The ioend->io_offset and ioend->io_size is completely beyond the range of the size of the file or
the device altogether. The problem occurs under heavy I/O stress on 4 20GB files that was created
using XFS_IOC_RESVSP64 ioctl. For a sparse file of the same size the problem does not occur. Also
the problem is not seen on moderate the low system I/O loads(Created by I/O meter) 

It trips on the VOP_BMP(..) call that eventually calls xfs_btree_check_lblock. I am aware that
this function has changed in the tip to call xfs_iomap_write_unwritten directly instead of calling
xfs_iomap via VOP_BMAP. I believe that even if I change the code to what is in the tip I would
still stumble some where on the fact that a write to a undefined range was completed. The call
stack that was dumped by XFS_ERROR_REPORT was as follows

Any thoughts how I could fix this?

Thanks in advance

Ravi

1> Oct 22 21:12:57 Foo kernel: Filesystem "dm-0": XFS internal error xfs_btree_check_lblock at
line 215 of file fs/xfs/xfs_btree.c.  Caller 0x781f907a
<4> Oct 22 21:12:57 Foo kernel:  [<781fc212>] xfs_btree_check_lblock+0x52/0x1c0
<4> Oct 22 21:12:57 Foo kernel:  [<781f907a>] xfs_bmbt_lookup+0x1fa/0x5f0
<4> Oct 22 21:12:57 Foo kernel:  [<781f907a>] xfs_bmbt_lookup+0x1fa/0x5f0
<4> Oct 22 21:12:57 Foo kernel:  [<781ed172>] xfs_bmap_add_extent_unwritten_real+0xd62/0xfd0
<4> Oct 22 21:12:57 Foo kernel:  [<781ee030>] xfs_bmap_add_extent+0x6f0/0x1f10
<4> Oct 22 21:12:57 Foo kernel:  [<78324250>] dm_request+0xf0/0x13c
<4> Oct 22 21:12:57 Foo kernel:  [<78324160>] dm_request+0x0/0x13c
<4> Oct 22 21:12:57 Foo kernel:  [<78263561>] generic_make_request+0x161/0x210
<4> Oct 22 21:12:57 Foo kernel:  [<782c97e5>] scsi_delete_timer+0x15/0x60
<4> Oct 22 21:12:57 Foo kernel:  [<781150b6>] find_busiest_group+0x256/0x310
<4> Oct 22 21:12:57 Foo kernel:  [<782653f5>] submit_bio+0x55/0x100
<4> Oct 22 21:12:57 Foo kernel:  [<781678a7>] bio_add_page+0x37/0x50
<4> Oct 22 21:12:57 Foo kernel:  [<781f6a54>] xfs_bmbt_get_state+0x14/0x30
<4> Oct 22 21:12:57 Foo kernel:  [<781f02de>] xfs_bmap_do_search_extents+0x2fe/0x480
<4> Oct 22 21:12:57 Foo kernel:  [<782462b7>] xfs_buf_iorequest+0x347/0x440
<4> Oct 22 21:12:57 Foo kernel:  [<78247538>] kmem_zone_alloc+0x58/0xd0
<4> Oct 22 21:12:57 Foo kernel:  [<781f1f73>] xfs_bmapi+0x19b3/0x2e20
<4> Oct 22 21:12:57 Foo kernel:  [<78220466>] xlog_write+0x6e6/0x800
<4> Oct 22 21:12:57 Foo kernel:  [<78228158>] xfs_icsb_modify_counters_locked+0x18/0x20
<4> Oct 22 21:12:57 Foo kernel:  [<7822db93>] xfs_trans_tail_ail+0x13/0x30
<4> Oct 22 21:12:58 Foo kernel:  [<7821f2d8>] xlog_assign_tail_lsn+0x28/0x60
<4> Oct 22 21:12:58 Foo kernel:  [<7821f337>] xlog_state_release_iclog+0x27/0x530
<4> Oct 22 21:12:58 Foo kernel:  [<7822f069>] xfs_trans_unlock_items+0xa9/0xb0
<4> Oct 22 21:12:58 Foo kernel:  [<78221861>] xfs_log_release_iclog+0x11/0x40
<4> Oct 22 21:12:58 Foo kernel:  [<7822d8b9>] _xfs_trans_commit+0x8e9/0xa60
<4> Oct 22 21:12:58 Foo kernel:  [<782207bc>] xlog_grant_push_ail+0x3c/0x150
<4> Oct 22 21:12:58 Foo kernel:  [<78220ece>] xfs_log_reserve+0x5fe/0x780
<4> Oct 22 21:12:58 Foo kernel:  [<7822eb41>] xfs_trans_ijoin+0x31/0x70
<4> Oct 22 21:12:58 Foo kernel:  [<7823ad6d>] xfs_iomap_write_unwritten+0x1bd/0x300
<4> Oct 22 21:12:58 Foo kernel:  [<7823a633>] xfs_iomap+0x513/0x850
<4> Oct 22 21:12:58 Foo kernel:  [<78149631>] test_clear_page_writeback+0x51/0xc0
<4> Oct 22 21:12:58 Foo kernel:  [<78166059>] end_buffer_async_write+0xa9/0x140
<4> Oct 22 21:12:58 Foo kernel:  [<7823ca58>] xfs_end_bio_unwritten+0x48/0x60
<4> Oct 22 21:12:58 Foo kernel:  [<7812c712>] run_workqueue+0x72/0xf0
<4> Oct 22 21:12:58 Foo kernel:  [<7823ca10>] xfs_end_bio_unwritten+0x0/0x60
<4> Oct 22 21:12:58 Foo kernel:  [<7812cf5b>] worker_thread+0x13b/0x160
<4> Oct 22 21:12:58 Foo kernel:  [<78115b40>] default_wake_function+0x0/0x10
<4> Oct 22 21:12:58 Foo kernel:  [<7812ce20>] worker_thread+0x0/0x160
<4> Oct 22 21:12:58 Foo kernel:  [<7812fd7b>] kthread+0xab/0xe0
<4> Oct 22 21:12:58 Foo kernel:  [<7812fcd0>] kthread+0x0/0xe0
<4> Oct 22 21:12:58 Foo kernel:  [<78100df5>] kernel_thread_helper+0x5/0x10


------------------------------
Ravi Wijayaratne


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
