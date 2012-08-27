Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R0U361204215 for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 19:30:03 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YcCZHHbipH9PEn0O for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 17:30:51 -0700 (PDT)
Date: Mon, 27 Aug 2012 10:30:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lockdep warning with sb_internal#2
Message-ID: <20120827003047.GA13691@dastard>
References: <alpine.DEB.2.00.1208260924310.13468@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1208260924310.13468@cobra.newdream.net>
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
To: Sage Weil <sage@inktank.com>
Cc: xfs@oss.sgi.com

On Sun, Aug 26, 2012 at 09:25:50AM -0700, Sage Weil wrote:
> In case nobody has seen this yet:

No, I haven't, but I haven't done a TOT lockdep run recently.

> [10777.847108] ======================================================
> [10777.873747] [ INFO: possible circular locking dependency detected ]
> [10777.900948] 3.6.0-rc2-ceph-00143-g995fc06 #1 Not tainted
> [10777.928082] -------------------------------------------------------
> [10777.956154] fill2/17839 is trying to acquire lock:
> [10777.982362]  ((&mp->m_flush_work)){+.+.+.}, at: [<ffffffff81072060>] wait_on_work+0x0/0x160
> [10778.033864] 
> [10778.033864] but task is already holding lock:
> [10778.080206]  (sb_internal#2){.+.+.+}, at: [<ffffffffa03dde5d>] xfs_trans_alloc+0x2d/0x50 [xfs]
> [10778.132743] 
> [10778.132743] which lock already depends on the new lock.

To tell the truth, I'm having trouble understanding what this means,
because:

> [10778.205654] the existing dependency chain (in reverse order) is:
> [10778.257150] 
> [10778.257150] -> #1 (sb_internal#2){.+.+.+}:
> [10778.306678]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
> [10778.336430]        [<ffffffff816350dd>] _raw_spin_lock_irq+0x3d/0x50
> [10778.367408]        [<ffffffff81633740>] wait_for_common+0x30/0x160
> [10778.398486]        [<ffffffff8163394d>] wait_for_completion+0x1d/0x20
> [10778.429780]        [<ffffffffa038b86d>] xfs_buf_iowait+0x6d/0xf0 [xfs]
> [10778.461388]        [<ffffffffa038ba20>] _xfs_buf_read+0x40/0x50 [xfs]
> [10778.493170]        [<ffffffffa038bad3>] xfs_buf_read_map+0xa3/0x110 [xfs]
> [10778.525708]        [<ffffffffa03e7f7d>] xfs_trans_read_buf_map+0x1fd/0x4a0 [xfs]
> [10778.585740]        [<ffffffffa03a4a18>] xfs_read_agf+0x78/0x1c0 [xfs]
> [10778.619869]        [<ffffffffa03a4b9a>] xfs_alloc_read_agf+0x3a/0xf0 [xfs]
> [10778.654683]        [<ffffffffa03a511a>] xfs_alloc_pagf_init+0x1a/0x40 [xfs]
> [10778.688992]        [<ffffffffa03af034>] xfs_bmap_btalloc_nullfb+0x224/0x370 [xfs]
> [10778.749210]        [<ffffffffa03af5b6>] xfs_bmap_btalloc+0x436/0x830 [xfs]
> [10778.783502]        [<ffffffffa03af9d4>] xfs_bmap_alloc+0x24/0x40 [xfs]
> [10778.816807]        [<ffffffffa03b4e6e>] xfs_bmapi_allocate+0xce/0x2d0 [xfs]
> [10778.850048]        [<ffffffffa03b7a8b>] xfs_bmapi_write+0x47b/0x7a0 [xfs]
> [10778.882237]        [<ffffffffa03c1128>] xfs_da_grow_inode_int+0xc8/0x2e0 [xfs]
> [10778.940695]        [<ffffffffa03c3d8c>] xfs_dir2_grow_inode+0x6c/0x140 [xfs]
> [10778.974521]        [<ffffffffa03c603d>] xfs_dir2_sf_to_block+0xbd/0x530 [xfs]
> [10779.007733]        [<ffffffffa03cc873>] xfs_dir2_sf_addname+0x3a3/0x520 [xfs]
> [10779.041104]        [<ffffffffa03c472c>] xfs_dir_createname+0x14c/0x1a0 [xfs]

sb_internal#2 reference is taken here:

> [10779.074438]        [<ffffffffa039dec3>] xfs_rename+0x4f3/0x6f0 [xfs]
> [10779.107092]        [<ffffffffa0396776>] xfs_vn_rename+0x66/0x70 [xfs]
> [10779.140318]        [<ffffffff8118a68d>] vfs_rename+0x31d/0x4f0
> [10779.172667]        [<ffffffff8118d026>] sys_renameat+0x1f6/0x230
> [10779.204781]        [<ffffffff8118d07b>] sys_rename+0x1b/0x20
> [10779.236289]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b

but this path doesn't touch mp->m_flush_work at all, and while it is in
a transaction context (i.e. holds sb_internal#2), it is blocked
waiting for an IO completion on a private completion queue. i.e:

	wait_for_completion(&bp->b_iowait);

> [10779.268294] 
> [10779.268294] -> #0 ((&mp->m_flush_work)){+.+.+.}:
> [10779.323093]        [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
> [10779.356168]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
> [10779.388639]        [<ffffffff810720a1>] wait_on_work+0x41/0x160
> [10779.420860]        [<ffffffff81072203>] flush_work_sync+0x43/0x90
> [10779.453189]        [<ffffffffa039cc7f>] xfs_flush_inodes+0x2f/0x40 [xfs]

sb_internal#2 reference is taken here:

> [10779.486315]        [<ffffffffa039fd2e>] xfs_create+0x3be/0x640 [xfs]
> [10779.518341]        [<ffffffffa039688f>] xfs_vn_mknod+0x8f/0x1c0 [xfs]
> [10779.549954]        [<ffffffffa03969f3>] xfs_vn_create+0x13/0x20 [xfs]
> [10779.581458]        [<ffffffff8118aeb5>] vfs_create+0xb5/0x120
> [10779.611999]        [<ffffffff8118bcc0>] do_last+0xda0/0xf00
> [10779.642156]        [<ffffffff8118bed3>] path_openat+0xb3/0x4c0
> [10779.671827]        [<ffffffff8118c6f2>] do_filp_open+0x42/0xa0
> [10779.700768]        [<ffffffff8117b040>] do_sys_open+0x100/0x1e0
> [10779.729733]        [<ffffffff8117b141>] sys_open+0x21/0x30
> [10779.758038]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b

but this path doesn't hit buffer IO wait queues at all - it has
blocked at:

	flush_work_sync(&mp->m_flush_work);

Which is serviced by a work queue that is completely separate to the
buffer IO completion work queues.  So apart from both threads
holding sb_internal#2, I can't see how they can deadlock.

It seems to me that lockdep is messed up internally if it thinks
mp->m_flush_work and bp->b_iowait are the same....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
