Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 19:03:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O22q4p006716
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 19:02:56 -0700
Message-ID: <46CE3C45.1080907@sgi.com>
Date: Fri, 24 Aug 2007 12:02:45 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_RETURN
References: <200708232109.50780.lists@gammarayburst.de>
In-Reply-To: <200708232109.50780.lists@gammarayburst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Markus Schoder <lists@gammarayburst.de>
Cc: xfs@oss.sgi.com

Markus Schoder wrote:
> Got a bunch of the below errors in the log. It occured during a Debian
> upgrade with aptitude. xfs_repair found a lost inode.
> 
> Kernel is stock 2.6.22.4 plus CFS patch. This is a 64bit kernel on an
> amd64 processor.
> 
> I am glad to provide more information if required.
> 
> Would be nice to keep me CC'ed if this is not against policy.
> 
> --
> Markus
> 
> Aug 23 00:15:09 gondolin kernel: [17152.830267] XFS internal error XFS_WANT_CORRUPTED_RETURN at line 281 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff802eb061
> Aug 23 00:15:09 gondolin kernel: [17152.830274]
> Aug 23 00:15:09 gondolin kernel: [17152.830275] Call Trace:
> Aug 23 00:15:09 gondolin kernel: [17152.830295]  [<ffffffff802e9bf7>] xfs_alloc_fixup_trees+0x307/0x3a0
> Aug 23 00:15:09 gondolin kernel: [17152.830301]  [<ffffffff80303ddd>] xfs_btree_setbuf+0x2d/0xb0
> Aug 23 00:15:09 gondolin kernel: [17152.830306]  [<ffffffff802eb061>] xfs_alloc_ag_vextent_near+0x581/0x9b0
> Aug 23 00:15:09 gondolin kernel: [17152.830313]  [<ffffffff802ebc95>] xfs_alloc_ag_vextent+0xd5/0x130
> Aug 23 00:15:09 gondolin kernel: [17152.830316]  [<ffffffff802ec4f5>] xfs_alloc_vextent+0x275/0x460
> Aug 23 00:15:09 gondolin kernel: [17152.830322]  [<ffffffff802f9630>] xfs_bmap_btalloc+0x410/0x7c0
> Aug 23 00:15:09 gondolin kernel: [17152.830327]  [<ffffffff8032d6fa>] xfs_mod_incore_sb_batch+0xea/0x130
> Aug 23 00:15:09 gondolin kernel: [17152.830335]  [<ffffffff802f6d1e>] xfs_bmap_isaeof+0x7e/0xd0
> Aug 23 00:15:09 gondolin kernel: [17152.830344]  [<ffffffff802fd8c9>] xfs_bmapi+0xc89/0x1340
> Aug 23 00:15:09 gondolin kernel: [17152.830359]  [<ffffffff80330298>] xfs_trans_reserve+0xa8/0x210
> Aug 23 00:15:09 gondolin kernel: [17152.830364]  [<ffffffff80320e58>] xfs_iomap_write_direct+0x2e8/0x500
> Aug 23 00:15:09 gondolin kernel: [17152.830374]  [<ffffffff8032028c>] xfs_iomap+0x31c/0x390
> Aug 23 00:15:09 gondolin kernel: [17152.830383]  [<ffffffff8033dafa>] xfs_map_blocks+0x3a/0x80
> Aug 23 00:15:09 gondolin kernel: [17152.830387]  [<ffffffff8033ec3e>] xfs_page_state_convert+0x2be/0x630
> Aug 23 00:15:09 gondolin kernel: [17152.830394]  [<ffffffff802a23cc>] alloc_buffer_head+0x4c/0x80
> Aug 23 00:15:09 gondolin kernel: [17152.830398]  [<ffffffff802a2be0>] alloc_page_buffers+0x60/0xe0
> Aug 23 00:15:09 gondolin kernel: [17152.830403]  [<ffffffff8033f10f>] xfs_vm_writepage+0x6f/0x120
> Aug 23 00:15:09 gondolin kernel: [17152.830408]  [<ffffffff8025dfba>] __writepage+0xa/0x30
> Aug 23 00:15:09 gondolin kernel: [17152.830411]  [<ffffffff8025e5fe>] write_cache_pages+0x23e/0x330
> Aug 23 00:15:09 gondolin kernel: [17152.830415]  [<ffffffff8025dfb0>] __writepage+0x0/0x30
> Aug 23 00:15:09 gondolin kernel: [17152.830424]  [<ffffffff8025e740>] do_writepages+0x20/0x40
> Aug 23 00:15:09 gondolin kernel: [17152.830427]  [<ffffffff80259715>] __filemap_fdatawrite_range+0x75/0xb0
> Aug 23 00:15:09 gondolin kernel: [17152.830434]  [<ffffffff802a1975>] do_fsync+0x45/0xe0
> Aug 23 00:15:09 gondolin kernel: [17152.830438]  [<ffffffff8026e2b6>] sys_msync+0x166/0x1d0
> Aug 23 00:15:09 gondolin kernel: [17152.830444]  [<ffffffff8021e302>] ia32_sysret+0x0/0xa
> 

It looks a lot like a reported bug:
   Suse#198124 and sgi-pv#956334

Where we had corruption in freespace btrees.

Can you also run xfs_check before running xfs_repair.

--Tim
