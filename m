Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q78MNGJJ076536 for <xfs@oss.sgi.com>; Wed, 8 Aug 2012 17:23:16 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AFOI4ijRrhmPtbVp for <xfs@oss.sgi.com>;
	Wed, 08 Aug 2012 15:23:14 -0700 (PDT)
Date: Thu, 9 Aug 2012 08:23:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs hang when filesystem filled
Message-ID: <20120808222305.GV2877@dastard>
References: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
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
To: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 07, 2012 at 02:54:48PM +0900, Guk-Bong, Kwon wrote:
> HI all
> 
> I tested xfs over nfs using bonnie++
> 
> xfs and nfs hang when xfs filesystem filled
> 
> What's the problem?

It appears to be blocked in writeback, getting ENOSPC errors when
they shouldn't occur.

> see below
> --------------------------------
> 
> 1. nfs server
> 
>     a. uname -a
>         - Linux nfs_server 2.6.32.58 #1 SMP Thu Mar 22 13:33:34 KST 2012 x86_64
>         Intel(R) Xeon(R) CPU E5606 @ 2.13GHz GenuineIntel GNU/Linux

Old kernel. Upgrade.

> ================================================================================
> /test   0.0.0.0/0.0.0.0(rw,async,wdelay,hide,nocrossmnt,insecure,no_root_squash,no_all_squash,no_subtree_check,secure_locks,acl,fsid=1342087477,anonuid=65534,anongid=65534)
> ================================================================================

You're using the async export option, which means the server/client
write throttling mechanisms built into the NFs protocol are not
active. That leads to clients swamping the server with dirty data
and not backing off when the server is overloaded, and leads to
-data loss- when the server fails.

IOWs, you're massively overcomitting allocation from lots of
threads which means you are probably depleting the free space pool,
and that leads to -data loss- and potentially deadlocks. If this is
what your production systems do, then a) increase the reserve pool,
and b) fix your producton systems not to do this.

> Aug  2 18:17:58 anystor1 kernel: Call Trace:
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811738ce>] ?  xfs_btree_is_lastrec+0x4e/0x60
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135edad>] ?  schedule_timeout+0x1ed/0x250
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135fcd1>] ? __down+0x61/0xa0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff810572d6>] ? down+0x46/0x50
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811af6a4>] ?  _xfs_buf_find+0x134/0x220
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811af7fe>] ?  xfs_buf_get_flags+0x6e/0x190
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a525e>] ?  xfs_trans_get_buf+0x10e/0x160
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff81161954>] ?  xfs_alloc_fix_freelist+0x144/0x450
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8119e597>] ?  xfs_icsb_disable_counter+0x17/0x160
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8116d2f2>] ?  xfs_bmap_add_extent_delay_real+0x8d2/0x11a0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a4b83>] ?  xfs_trans_log_buf+0x63/0xa0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8119e731>] ?  xfs_icsb_balance_counter_locked+0x31/0xf0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff81161ed1>] ?  xfs_alloc_vextent+0x1b1/0x4c0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8116e946>] ?  xfs_bmap_btalloc+0x596/0xa70
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8117125a>] ? xfs_bmapi+0x9fa/0x1230
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811965f6>] ?  xlog_state_release_iclog+0x56/0xe0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811a3a0f>] ?  xfs_trans_reserve+0x9f/0x210
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff81192d0e>] ?  xfs_iomap_write_allocate+0x24e/0x3d0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811c29c0>] ? elv_insert+0xf0/0x260
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8119396b>] ? xfs_iomap+0x2cb/0x300
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811aba05>] ? xfs_map_blocks+0x25/0x30
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811acb64>] ?  xfs_page_state_convert+0x414/0x6d0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811ad137>] ?  xfs_vm_writepage+0x77/0x130
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107c8ca>] ? __writepage+0xa/0x40
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107d0af>] ?  write_cache_pages+0x1df/0x3d0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8107c8c0>] ? __writepage+0x0/0x40
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff81076f4c>] ?  __filemap_fdatawrite_range+0x4c/0x60
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811da3a1>] ?  radix_tree_gang_lookup+0x71/0xf0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b029d>] ?  xfs_flush_pages+0xad/0xc0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b795a>] ?  xfs_sync_inode_data+0xca/0xf0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7aa0>] ?  xfs_inode_ag_walk+0x80/0x140
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7890>] ?  xfs_sync_inode_data+0x0/0xf0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7be8>] ?  xfs_inode_ag_iterator+0x88/0xd0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7890>] ?  xfs_sync_inode_data+0x0/0xf0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff8135ed1d>] ?  schedule_timeout+0x15d/0x250
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7f40>] ? xfs_sync_data+0x30/0x60
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7f8e>] ?  xfs_flush_inodes_work+0x1e/0x50
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b726c>] ? xfssyncd+0x13c/0x1d0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff811b7130>] ? xfssyncd+0x0/0x1d0
> Aug  2 18:17:58 anystor1 kernel: [<ffffffff810529d6>] ? kthread+0x96/0xb0

There's your problem - writeback of data is blocked waiting on a
metadata buffer, and everything else is blocked behind it. Upgrade
your kernel.

In summary, you are doing something silly on a very old kernel and
you broke it. As a prize, you get to keep all the broken pieces.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
