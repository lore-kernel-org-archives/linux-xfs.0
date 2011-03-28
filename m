Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SLv7UY187655
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:57:08 -0500
Received: from mx3.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 260451142355
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 15:00:12 -0700 (PDT)
Received: from mx3.twosigma.com (mx3.twosigma.com [208.77.213.34]) by
	cuda.sgi.com with ESMTP id uLFRnCjCH8p3XYlt for
	<linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 15:00:12 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Mon, 28 Mar 2011 17:34:09 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
In-Reply-To: <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
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
To: 'Michel Lespinasse' <walken@google.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

> Could you test if you see the deadlock before
> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?

Built and tested 72ddc8f72270758951ccefb7d190f364d20215ab.
Confirmed that the original bug does not present in this version.
Confirmed that removing MAP_POPULATE does cause the deadlock to occur.

Here is the stack of the test:
# cat /proc/3846/stack
[<ffffffff812e8a64>] call_rwsem_down_read_failed+0x14/0x30
[<ffffffff81271c1d>] xfs_ilock+0x9d/0x110
[<ffffffff81271cae>] xfs_ilock_map_shared+0x1e/0x50
[<ffffffff81294985>] __xfs_get_blocks+0xc5/0x4e0
[<ffffffff81294dcc>] xfs_get_blocks+0xc/0x10
[<ffffffff811322c2>] do_mpage_readpage+0x462/0x660
[<ffffffff8113250a>] mpage_readpage+0x4a/0x60
[<ffffffff81295433>] xfs_vm_readpage+0x13/0x20
[<ffffffff810bb850>] filemap_fault+0x2d0/0x4e0
[<ffffffff810d8680>] __do_fault+0x50/0x510
[<ffffffff810da542>] handle_mm_fault+0x1a2/0xe60
[<ffffffff8102a466>] do_page_fault+0x146/0x440
[<ffffffff8164e6cf>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

xfssyncd is stuck in D state.
# cat /proc/2484/stack
[<ffffffff8106ee1c>] down+0x3c/0x50
[<ffffffff81297802>] xfs_buf_lock+0x72/0x170
[<ffffffff8128762d>] xfs_getsb+0x1d/0x50
[<ffffffff8128e6af>] xfs_trans_getsb+0x5f/0x150
[<ffffffff8128821e>] xfs_mod_sb+0x4e/0xe0
[<ffffffff8126e4ea>] xfs_fs_log_dummy+0x5a/0xb0
[<ffffffff812a2a13>] xfs_sync_worker+0x83/0x90
[<ffffffff812a28e2>] xfssyncd+0x172/0x220
[<ffffffff81069576>] kthread+0x96/0xa0
[<ffffffff81003354>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
