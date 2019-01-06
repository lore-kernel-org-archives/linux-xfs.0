Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44268 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbfAFW4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jan 2019 17:56:43 -0500
Date: Mon, 7 Jan 2019 09:56:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible circular locking dependency detected between fs_reclaim
 and sb_internal
Message-ID: <20190106225639.GU4205@dastard>
References: <42952405-0062-6e20-e464-bf165ccbf32a@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42952405-0062-6e20-e464-bf165ccbf32a@lca.pw>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qian Cai <cai@lca.pw>
Cc: dchinner@redhat.com, darrick.wong@oracle.com, Peter Zijlstra <peterz@infradead.org>, bfoster@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org

On Sun, Jan 06, 2019 at 12:28:39AM -0500, Qian Cai wrote:
> It looks like due to 8683edb7755 (xfs: avoid lockdep false positives in
> xfs_trans_alloc), it triggers lockdep in some other ways.
> 
> [81388.050050] WARNING: possible circular locking dependency detected
> [81388.056272] 4.20.0+ #47 Tainted: G        W    L
> [81388.061182] ------------------------------------------------------
> [81388.067402] fsfreeze/64059 is trying to acquire lock:
> [81388.072487] 000000004f938084 (fs_reclaim){+.+.}, at:
> fs_reclaim_acquire.part.19+0x5/0x30
> [81388.080649]
> [81388.080649] but task is already holding lock:
> [81388.086517] 00000000339e9c6f (sb_internal){++++}, at:
> percpu_down_write+0xbb/0x410
> [81388.094140]
> [81388.094140] which lock already depends on the new lock.
> [81388.094140]
> [81388.102367]
> [81388.102367] the existing dependency chain (in reverse order) is:
> [81388.109897]
> [81388.109897] -> #1 (sb_internal){++++}:
> [81388.115163]        __lock_acquire+0x460/0x850
> [81388.119549]        lock_acquire+0x1e0/0x3f0
> [81388.123764]        __sb_start_write+0x150/0x1e0
> [81388.128437]        xfs_trans_alloc+0x49b/0x5e0 [xfs]
> [81388.133540]        xfs_setfilesize_trans_alloc+0xa6/0x1a0 [xfs]
> [81388.139602]        xfs_submit_ioend+0x239/0x3e0 [xfs]
> [81388.144790]        xfs_vm_writepage+0xbc/0x100 [xfs]
> [81388.149793]        pageout.isra.2+0x919/0x13c0
> [81388.154264]        shrink_page_list+0x3807/0x58a0
> [81388.158997]        shrink_inactive_list+0x4b3/0xfc0
> [81388.163909]        shrink_node_memcg+0x5e5/0x1660
> [81388.168642]        shrink_node+0x2a3/0xaa0
> [81388.172766]        balance_pgdat+0x7cc/0xea0
> [81388.177067]        kswapd+0x65e/0xc40
> [81388.180757]        kthread+0x1d2/0x1f0
> [81388.184535]        ret_from_fork+0x27/0x50

Writeback of data from kswapd, allocating a transaction. This
is such a horrible thing to be doing from many, many perspectives.

/me recently proposed a patch to remove ->writepage from XFS to
avoid this sort of crap altogether.

> [81388.188655]
> [81388.188655] -> #0 (fs_reclaim){+.+.}:
> [81388.193832]        validate_chain.isra.14+0xd43/0x1910
> [81388.199004]        __lock_acquire+0x460/0x850
> [81388.203391]        lock_acquire+0x1e0/0x3f0
> [81388.207602]        fs_reclaim_acquire.part.19+0x29/0x30
> [81388.212862]        fs_reclaim_acquire+0x19/0x20
> [81388.217424]        kmem_cache_alloc+0x2f/0x330
> [81388.222004]        kmem_zone_alloc+0x6e/0x110 [xfs]
> [81388.227023]        xfs_trans_alloc+0xfd/0x5e0 [xfs]
> [81388.232034]        xfs_sync_sb+0x76/0x100 [xfs]
> [81388.236701]        xfs_log_sbcount+0x8e/0xa0 [xfs]
> [81388.241631]        xfs_quiesce_attr+0x112/0x1d0 [xfs]
> [81388.246821]        xfs_fs_freeze+0x38/0x50 [xfs]
> [81388.251469]        freeze_super+0x122/0x190
> [81388.255682]        do_vfs_ioctl+0xa04/0xbe0

Freezing the filesystem, after all the data has been cleaned. IOWs
memory reclaim will never run the above writeback path when
the freeze process is trying to allocate a transaction here because
there are no dirty data pages in the filesystem at this point.

Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
it /doesn't deadlock/ by taking freeze references for the
transaction. We've just drained all the transactions
in progress and written back all the dirty metadata, too, and so the
filesystem is completely clean and only needs the superblock to be
updated to complete the freeze process. And to do that, it does not
take a freeze reference because calling sb_start_intwrite() here
would deadlock.

IOWs, this is a false positive, caused by the fact that
xfs_trans_alloc() is called from both above and below memory reclaim
as well as within /every level/ of freeze processing. Lockdep is
unable to describe the staged flush logic in the freeze process that
prevents deadlocks from occurring, and hence we will pretty much
always see false positives in the freeze path....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
