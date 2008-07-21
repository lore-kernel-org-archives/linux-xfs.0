Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 22:57:34 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6L5vWfY016349
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 22:57:32 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBB8D139FF65
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 22:58:40 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id zDH5Je9iwK271TVJ for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 22:58:40 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KKoPt-0007gP-Il
	for xfs@oss.sgi.com; Mon, 21 Jul 2008 15:58:37 +1000
Date: Mon, 21 Jul 2008 15:58:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Use KM_NOFS for incore inode extent tree
	allocation
Message-ID: <20080721055837.GA6761@disturbed>
References: <1216615959-23010-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216615959-23010-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 02:52:39PM +1000, Dave Chinner wrote:
> If we allow incore extent tree allocations to recurse into the
> filesystem under memory pressure, new delayed allocations through
> xfs_iomap_write_delay() can deadlock on themselves if memory reclaim
> tries to write back dirty pages from that inode.
> 
> It will deadlock in xfs_iomap_write_allocate() trying to take the
> ilock we already hold. This can also show up as complex ABBA
> deadlocks when multiple threeads are triggering memory reclaim when
> trying to allocate extents.
> 
> The main cause of this is the fact that delayed allocation is
> not done in a transaction, so KM_NOFS is not automatically
> added to the allocations to prevent this recursion.
> 
> Mark all allocations done for the incore inode extent tree as
> KM_NOFS to ensure they never recurse back into the filesystem.

BTW, if you are wondering what this fixes, it's this hang:

http://oss.sgi.com/archives/xfs/2008-07/msg00091.html

And the stack traces look like:

> Call Trace:
> [<8048190c>] schedule+0x810/0x97c
> [<80483240>] __down_read+0xc4/0xec
> [<8013d860>] down_read+0x10/0x1c
> [<802cad44>] xfs_ilock+0x8c/0xa4
> [<802cac88>] xfs_ilock_map_shared+0x38/0x4c
> [<802d27f8>] xfs_iomap+0xd8/0x4dc
> [<802fe90c>] xfs_bmap+0x30/0x3c
> [<802f3cfc>] xfs_map_blocks+0x50/0x84
> [<802f52a4>] xfs_page_state_convert+0x56c/0x840
> [<802f565c>] xfs_vm_writepage+0xe4/0x140
> [<80153cf4>] pageout+0x150/0x1e8
> [<80154144>] shrink_page_list+0x2b8/0x504
> [<8015455c>] shrink_inactive_list+0xc0/0x304
> [<80154da8>] shrink_zone+0x100/0x148
> [<80154e6c>] shrink_zones+0x7c/0xac
> [<80154f94>] try_to_free_pages+0xf8/0x200
> [<8014f24c>] __alloc_pages+0x1a4/0x300
> [<80168a18>] kmem_getpages+0x58/0x138
> [<80169b1c>] cache_grow+0xd4/0x1c4
> [<80169db0>] cache_alloc_refill+0x1a4/0x210
> [<8016a2a0>] __kmalloc+0x98/0xc8
> [<802f3644>] kmem_alloc+0x94/0x130
> [<802d10d0>] xfs_iext_irec_new+0xb0/0x11c
> [<802d0134>] xfs_iext_add+0x1fc/0x254
> [<802cfedc>] xfs_iext_insert+0x34/0x90
> [<802a70c4>] xfs_bmap_add_extent_hole_delay+0x5dc/0x6fc
> [<802a3f0c>] xfs_bmap_add_extent+0x204/0x4e4
> [<802ace5c>] xfs_bmapi+0xa98/0x13e4
> [<802d3dc8>] xfs_iomap_write_delay+0x36c/0x4b8
> [<802d2aa0>] xfs_iomap+0x380/0x4dc
> [<802fe90c>] xfs_bmap+0x30/0x3c
> [<802f58b8>] __xfs_get_blocks+0xb0/0x300
> [<802f5b30>] xfs_get_blocks+0x28/0x34
> [<801718e0>] __block_prepare_write+0x208/0x548
> [<8017267c>] block_prepare_write+0x34/0x64
> [<802f5d6c>] xfs_vm_prepare_write+0x24/0x30
> [<8014bdf0>] generic_file_buffered_write+0x280/0x650
> [<802fe518>] xfs_write+0x768/0xaac
> [<802f8c80>] xfs_file_aio_write+0x88/0x94
> [<8016d8d4>] do_sync_write+0xcc/0x124
> [<8016d9e4>] vfs_write+0xb8/0x1a0
> [<8016dd10>] sys_pwrite64+0x6c/0xa8
> [<8010c180>] stack_done+0x20/0x3c

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
