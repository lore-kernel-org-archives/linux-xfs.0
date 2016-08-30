Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C70F7CA2
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 09:48:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7DFB2AC004
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:48:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2i2IQe7cWMIMKMpm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:48:52 -0700 (PDT)
Date: Tue, 30 Aug 2016 22:48:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
	fs/xfs/xfs_trans.c
Message-ID: <20160830144849.GL27776@eguan.usersys.redhat.com>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
	<20160830023905.GU19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160830023905.GU19025@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 30, 2016 at 12:39:05PM +1000, Dave Chinner wrote:
> > [root@hp-dl360g9-15 ~]# xfs_info /
> > meta-data=/dev/mapper/systemvg-root isize=256    agcount=16, agsize=2927744 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=0        finobt=0 spinodes=0
> > data     =                       bsize=4096   blocks=46843904, imaxpct=25
> >          =                       sunit=64     swidth=192 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> > log      =internal               bsize=4096   blocks=22912, version=2
> >          =                       sectsz=512   sunit=64 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Does it reproduce on a CRC enabled filesystem?

Yes, it does. And I tried to reduce the test time by reducing the
workload (less processes forked 30->10, less iterations in each process
10->5) but failed. I'll continue work on that.

[root@hp-dl360g9-15 ~]# xfs_info /mnt/xfs/
meta-data=/dev/mapper/systemvg-lv50g isize=512    agcount=16, agsize=819200 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
data     =                       bsize=4096   blocks=13107200, imaxpct=25
         =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=6400, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[39200.052565] XFS (dm-3): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_iomap_write_allocate+0x2d7/0x380 [xfs]
[39200.117990] CPU: 2 PID: 13175 Comm: kworker/u33:0 Tainted: G        W       4.8.0-rc3 #1
[39200.155312] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[39200.184549] Workqueue: writeback wb_workfn (flush-253:3)
[39200.208417]  0000000000000286 00000000ee09c3c6 ffff88005208b7a0 ffffffff8135c53c
[39200.241625]  ffff880316eb8bc8 0000000000000001 ffff88005208b7b8 ffffffffa02e99cb
[39200.274892]  ffffffffa02f5537 ffff88005208b7e0 ffffffffa03053e6 ffff880fe8d28f00
[39200.308115] Call Trace:
[39200.319060]  [<ffffffff8135c53c>] dump_stack+0x63/0x87
[39200.342241]  [<ffffffffa02e99cb>] xfs_error_report+0x3b/0x40 [xfs]
[39200.370008]  [<ffffffffa02f5537>] ? xfs_iomap_write_allocate+0x2d7/0x380 [xfs]
[39200.402497]  [<ffffffffa03053e6>] xfs_trans_cancel+0xb6/0xe0 [xfs]
[39200.430260]  [<ffffffffa02f5537>] xfs_iomap_write_allocate+0x2d7/0x380 [xfs]
[39200.461871]  [<ffffffffa02df949>] xfs_map_blocks+0x1a9/0x220 [xfs]
[39200.489701]  [<ffffffffa02e0c5b>] xfs_do_writepage+0x16b/0x560 [xfs]
[39200.518171]  [<ffffffff811a7d8f>] write_cache_pages+0x26f/0x510
[39200.544290]  [<ffffffff81330cbb>] ? blk_queue_bio+0x1ab/0x3a0
[39200.570043]  [<ffffffffa02e0af0>] ? xfs_vm_set_page_dirty+0x1e0/0x1e0 [xfs]
[39200.606240]  [<ffffffffa02e08e6>] xfs_vm_writepages+0xb6/0xe0 [xfs]
[39200.636151]  [<ffffffff811a8c5e>] do_writepages+0x1e/0x30
[39200.660355]  [<ffffffff8125a1f5>] __writeback_single_inode+0x45/0x330
[39200.689176]  [<ffffffff8125aa32>] writeback_sb_inodes+0x282/0x570
[39200.716875]  [<ffffffff8125adac>] __writeback_inodes_wb+0x8c/0xc0
[39200.744181]  [<ffffffff8125b066>] wb_writeback+0x286/0x320
[39200.768725]  [<ffffffff8125b889>] wb_workfn+0x109/0x3f0
[39200.792110]  [<ffffffff810a6642>] process_one_work+0x152/0x400
[39200.818480]  [<ffffffff810a6f35>] worker_thread+0x125/0x4b0
[39200.843463]  [<ffffffff810a6e10>] ? rescuer_thread+0x380/0x380
[39200.869279]  [<ffffffff810aca28>] kthread+0xd8/0xf0
[39200.891301]  [<ffffffff816f8dbf>] ret_from_fork+0x1f/0x40
[39200.916321]  [<ffffffff810ac950>] ? kthread_park+0x60/0x60
[39200.941595] XFS (dm-3): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa03053ff
[39201.097512] XFS (dm-3): Corruption of in-memory data detected.  Shutting down filesystem
[39201.137777] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
[39201.170534] Buffer I/O error on dev dm-3, logical block 2653783, lost async page write
[39201.206111] Buffer I/O error on dev dm-3, logical block 2653784, lost async page write
[39201.241644] Buffer I/O error on dev dm-3, logical block 2653785, lost async page write
[39201.276902] Buffer I/O error on dev dm-3, logical block 2653786, lost async page write
[39201.312405] Buffer I/O error on dev dm-3, logical block 2653787, lost async page write
[39201.347927] Buffer I/O error on dev dm-3, logical block 2653788, lost async page write
[39201.383415] Buffer I/O error on dev dm-3, logical block 2653789, lost async page write
[39201.419254] Buffer I/O error on dev dm-3, logical block 2653790, lost async page write
[39201.454723] Buffer I/O error on dev dm-3, logical block 2653791, lost async page write
[39222.364615] XFS (dm-3): xfs_log_force: error -5 returned.
[39252.572790] XFS (dm-3): xfs_log_force: error -5 returned.
[39282.780966] XFS (dm-3): xfs_log_force: error -5 returned.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
