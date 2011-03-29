Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2TJsTIi246605
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:54:29 -0500
Received: from mx5.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 977C11444D54
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 12:57:39 -0700 (PDT)
Received: from mx5.twosigma.com (mx5.twosigma.com [208.77.212.35]) by
	cuda.sgi.com with SMTP id qNmEQfXGUFKfF8lg for
	<linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 12:57:39 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Tue, 29 Mar 2011 15:54:12 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B535D@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
In-Reply-To: <20110329192434.GA10536@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, 'Michel Lespinasse' <walken@google.com>

> Can you check if the brute force patch below helps?  

Not sure if this helps at all, but here is the stack from all three processes involved.  This is without MAP_POPULATE and with the patch you just sent.

# ps aux | grep 'D[+]*[[:space:]]'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2314  0.2  0.0      0     0 ?        D    19:44   0:00 [flush-8:0]
root      2402  0.0  0.0      0     0 ?        D    19:44   0:00 [xfssyncd/sda9]
root      3861  2.6  9.9 16785280 4912848 pts/0 D+  19:45   0:07 ./vmtest /xfs/hugefile.dat 17179869184

# for p in 2314 2402 3861; do echo $p; cat /proc/$p/stack; done
2314
[<ffffffff810d634a>] congestion_wait+0x7a/0x130
[<ffffffff8129721c>] kmem_alloc+0x6c/0xf0
[<ffffffff8127c07e>] xfs_inode_item_format+0x36e/0x3b0
[<ffffffff8128401f>] xfs_log_commit_cil+0x4f/0x3b0
[<ffffffff8128ff31>] _xfs_trans_commit+0x1f1/0x2b0
[<ffffffff8127c716>] xfs_iomap_write_allocate+0x1a6/0x340
[<ffffffff81298883>] xfs_map_blocks+0x193/0x2c0
[<ffffffff812992fa>] xfs_vm_writepage+0x1ca/0x520
[<ffffffff810c4bd2>] __writepage+0x12/0x40
[<ffffffff810c53dd>] write_cache_pages+0x1dd/0x4f0
[<ffffffff810c573c>] generic_writepages+0x4c/0x70
[<ffffffff812986b8>] xfs_vm_writepages+0x58/0x70
[<ffffffff810c577c>] do_writepages+0x1c/0x40
[<ffffffff811247d1>] writeback_single_inode+0xf1/0x240
[<ffffffff81124edd>] writeback_sb_inodes+0xdd/0x1b0
[<ffffffff81125966>] writeback_inodes_wb+0x76/0x160
[<ffffffff81125d93>] wb_writeback+0x343/0x550
[<ffffffff81126126>] wb_do_writeback+0x186/0x2e0
[<ffffffff81126342>] bdi_writeback_thread+0xc2/0x310
[<ffffffff81067846>] kthread+0x96/0xa0
[<ffffffff8165a414>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
2402
[<ffffffff8106d0ec>] down+0x3c/0x50
[<ffffffff8129a7bd>] xfs_buf_lock+0x5d/0x170
[<ffffffff8128a87d>] xfs_getsb+0x1d/0x50
[<ffffffff81291bcf>] xfs_trans_getsb+0x5f/0x150
[<ffffffff8128b80e>] xfs_mod_sb+0x4e/0xe0
[<ffffffff81271dbf>] xfs_fs_log_dummy+0x4f/0x90
[<ffffffff812a61c1>] xfs_sync_worker+0x81/0x90
[<ffffffff812a6092>] xfssyncd+0x172/0x220
[<ffffffff81067846>] kthread+0x96/0xa0
[<ffffffff8165a414>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
3861
[<ffffffff812ec744>] call_rwsem_down_read_failed+0x14/0x30
[<ffffffff812754dd>] xfs_ilock+0x9d/0x110
[<ffffffff8127556e>] xfs_ilock_map_shared+0x1e/0x50
[<ffffffff81297c45>] __xfs_get_blocks+0xc5/0x4e0
[<ffffffff8129808c>] xfs_get_blocks+0xc/0x10
[<ffffffff81135ca2>] do_mpage_readpage+0x462/0x660
[<ffffffff81135eea>] mpage_readpage+0x4a/0x60
[<ffffffff812986e3>] xfs_vm_readpage+0x13/0x20
[<ffffffff810bd150>] filemap_fault+0x2d0/0x4e0
[<ffffffff810db0a0>] __do_fault+0x50/0x4f0
[<ffffffff810db85e>] handle_pte_fault+0x7e/0xc90
[<ffffffff810ddbf8>] handle_mm_fault+0x138/0x230
[<ffffffff8102b37c>] do_page_fault+0x12c/0x420
[<ffffffff81658fcf>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
