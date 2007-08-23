Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 13:33:16 -0700 (PDT)
Received: from mx1.pretago.de (mx1.pretago.de [89.110.132.151])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NKXA4p017641
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 13:33:13 -0700
Received: from localhost (localhost [127.0.0.1])
	by mx1.pretago.de (Postfix) with ESMTP id EA1142EC069
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 22:09:51 +0200 (CEST)
Received: from mx1.pretago.de ([127.0.0.1])
	by localhost (mx1.pretago.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OM3R04Gt8mWa for <xfs@oss.sgi.com>;
	Thu, 23 Aug 2007 22:09:51 +0200 (CEST)
Received: from gondolin.gammarayburst.de (unknown [87.127.185.82])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: p127p4)
	by mx1.pretago.de (Postfix) with ESMTP id 619612EC066
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 22:09:51 +0200 (CEST)
From: Markus Schoder <lists@gammarayburst.de>
Subject: XFS internal error XFS_WANT_CORRUPTED_RETURN
Date: Thu, 23 Aug 2007 21:09:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708232109.50780.lists@gammarayburst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Got a bunch of the below errors in the log. It occured during a Debian
upgrade with aptitude. xfs_repair found a lost inode.

Kernel is stock 2.6.22.4 plus CFS patch. This is a 64bit kernel on an
amd64 processor.

I am glad to provide more information if required.

Would be nice to keep me CC'ed if this is not against policy.

--
Markus

Aug 23 00:15:09 gondolin kernel: [17152.830267] XFS internal error XFS_WANT_CORRUPTED_RETURN at line 281 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff802eb061
Aug 23 00:15:09 gondolin kernel: [17152.830274]
Aug 23 00:15:09 gondolin kernel: [17152.830275] Call Trace:
Aug 23 00:15:09 gondolin kernel: [17152.830295]  [<ffffffff802e9bf7>] xfs_alloc_fixup_trees+0x307/0x3a0
Aug 23 00:15:09 gondolin kernel: [17152.830301]  [<ffffffff80303ddd>] xfs_btree_setbuf+0x2d/0xb0
Aug 23 00:15:09 gondolin kernel: [17152.830306]  [<ffffffff802eb061>] xfs_alloc_ag_vextent_near+0x581/0x9b0
Aug 23 00:15:09 gondolin kernel: [17152.830313]  [<ffffffff802ebc95>] xfs_alloc_ag_vextent+0xd5/0x130
Aug 23 00:15:09 gondolin kernel: [17152.830316]  [<ffffffff802ec4f5>] xfs_alloc_vextent+0x275/0x460
Aug 23 00:15:09 gondolin kernel: [17152.830322]  [<ffffffff802f9630>] xfs_bmap_btalloc+0x410/0x7c0
Aug 23 00:15:09 gondolin kernel: [17152.830327]  [<ffffffff8032d6fa>] xfs_mod_incore_sb_batch+0xea/0x130
Aug 23 00:15:09 gondolin kernel: [17152.830335]  [<ffffffff802f6d1e>] xfs_bmap_isaeof+0x7e/0xd0
Aug 23 00:15:09 gondolin kernel: [17152.830344]  [<ffffffff802fd8c9>] xfs_bmapi+0xc89/0x1340
Aug 23 00:15:09 gondolin kernel: [17152.830359]  [<ffffffff80330298>] xfs_trans_reserve+0xa8/0x210
Aug 23 00:15:09 gondolin kernel: [17152.830364]  [<ffffffff80320e58>] xfs_iomap_write_direct+0x2e8/0x500
Aug 23 00:15:09 gondolin kernel: [17152.830374]  [<ffffffff8032028c>] xfs_iomap+0x31c/0x390
Aug 23 00:15:09 gondolin kernel: [17152.830383]  [<ffffffff8033dafa>] xfs_map_blocks+0x3a/0x80
Aug 23 00:15:09 gondolin kernel: [17152.830387]  [<ffffffff8033ec3e>] xfs_page_state_convert+0x2be/0x630
Aug 23 00:15:09 gondolin kernel: [17152.830394]  [<ffffffff802a23cc>] alloc_buffer_head+0x4c/0x80
Aug 23 00:15:09 gondolin kernel: [17152.830398]  [<ffffffff802a2be0>] alloc_page_buffers+0x60/0xe0
Aug 23 00:15:09 gondolin kernel: [17152.830403]  [<ffffffff8033f10f>] xfs_vm_writepage+0x6f/0x120
Aug 23 00:15:09 gondolin kernel: [17152.830408]  [<ffffffff8025dfba>] __writepage+0xa/0x30
Aug 23 00:15:09 gondolin kernel: [17152.830411]  [<ffffffff8025e5fe>] write_cache_pages+0x23e/0x330
Aug 23 00:15:09 gondolin kernel: [17152.830415]  [<ffffffff8025dfb0>] __writepage+0x0/0x30
Aug 23 00:15:09 gondolin kernel: [17152.830424]  [<ffffffff8025e740>] do_writepages+0x20/0x40
Aug 23 00:15:09 gondolin kernel: [17152.830427]  [<ffffffff80259715>] __filemap_fdatawrite_range+0x75/0xb0
Aug 23 00:15:09 gondolin kernel: [17152.830434]  [<ffffffff802a1975>] do_fsync+0x45/0xe0
Aug 23 00:15:09 gondolin kernel: [17152.830438]  [<ffffffff8026e2b6>] sys_msync+0x166/0x1d0
Aug 23 00:15:09 gondolin kernel: [17152.830444]  [<ffffffff8021e302>] ia32_sysret+0x0/0xa
