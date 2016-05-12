Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A8617CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 03:03:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFADA304043
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 01:03:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NkjLEYOODPsVMyWy for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 01:03:35 -0700 (PDT)
Date: Thu, 12 May 2016 18:03:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160512080321.GA18496@dastard>
References: <94cea603-2782-1c5a-e2df-42db4459a8ce@cn.fujitsu.com>
	<20160512055756.GE6648@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512055756.GE6648@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Michal Hocko <mhocko@kernel.org>, xfs@oss.sgi.com

[ cc Michal Hocko, just so he can see a lockdep reclaim state false
positive ]

On Wed, May 11, 2016 at 10:57:56PM -0700, Darrick J. Wong wrote:
> On Thu, May 12, 2016 at 01:53:44PM +0800, Qu Wenruo wrote:
> > Hi Darrick,
> > 
> > Thanks for your reflink work for xfs first, that's quite a good and useful
> > feature, also helps to debug btrfs problems.
> > (Without that, there is no good reference for reflink behavior)
> > 
> > But when testing your for-dave-for-4.6 branch, even I'm just testing btrfs
> > with xfstests, kernel report some strange lockdep from xfs:
.....
> > =================================
> > [ INFO: inconsistent lock state ]
> > 4.5.0-rc2+ #4 Tainted: G           O
> > ---------------------------------
> > inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
> > kswapd0/543 [HC0[0]:SC0[0]:HE1:SE1] takes:
> >  (&xfs_nondir_ilock_class){++++-+}, at: [<ffffffffa00781f7>]
> > xfs_ilock+0x177/0x200 [xfs]
> > {RECLAIM_FS-ON-R} state was registered at:
> >   [<ffffffff8110f369>] mark_held_locks+0x79/0xa0
> >   [<ffffffff81113a43>] lockdep_trace_alloc+0xb3/0x100
> >   [<ffffffff81224623>] kmem_cache_alloc+0x33/0x230
> >   [<ffffffffa008acc1>] kmem_zone_alloc+0x81/0x120 [xfs]
> >   [<ffffffffa005456e>] xfs_refcountbt_init_cursor+0x3e/0xa0 [xfs]
> >   [<ffffffffa0053455>] __xfs_refcount_find_shared+0x75/0x580 [xfs]
> >   [<ffffffffa00539e4>] xfs_refcount_find_shared+0x84/0xb0 [xfs]
> >   [<ffffffffa005dcb8>] xfs_getbmap+0x608/0x8c0 [xfs]
> >   [<ffffffffa007634b>] xfs_vn_fiemap+0xab/0xc0 [xfs]
> >   [<ffffffff81244208>] do_vfs_ioctl+0x498/0x670
> >   [<ffffffff81244459>] SyS_ioctl+0x79/0x90
> >   [<ffffffff81847cd7>] entry_SYSCALL_64_fastpath+0x12/0x6f

Ignoring whether reflink should be doing anything or not, that's a
"xfs_refcountbt_init_cursor() gets called both outside and inside
transactions" lockdep false positive case. The problem here is
lockdep has seen this allocation from within a transaction, hence a
GFP_NOFS allocation, and now it's seeing it in a GFP_KERNEL context.
Also note that we have an active reference to this inode.

> > irq event stamp: 510775
> > hardirqs last  enabled at (510775): [<ffffffff812245d0>]
> > __slab_alloc+0x50/0x70
> > hardirqs last disabled at (510774): [<ffffffff812245ae>]
> > __slab_alloc+0x2e/0x70
> > softirqs last  enabled at (510506): [<ffffffff810c8ea8>]
> > __do_softirq+0x358/0x430
> > softirqs last disabled at (510489): [<ffffffff810c911d>] irq_exit+0xad/0xb0
> > 
> > other info that might help us debug this:
> >  Possible unsafe locking scenario:
> > 
> >        CPU0
> >        ----
> >   lock(&xfs_nondir_ilock_class);
> >   <Interrupt>
> >     lock(&xfs_nondir_ilock_class);

So, because the reclaim annotations overload the interrupt level
detections and it's seen the inode ilock been taken in reclaim
("interrupt") context, this triggers a reclaim context warning where
it thinks it is unsafe to do this allocation in GFP_KERNEL context
holding the inode ilock...

> >  *** DEADLOCK ***
> > 
> > 3 locks held by kswapd0/543:
> >  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811e0b78>]
> > shrink_slab.part.63.constprop.79+0x48/0x4e0
> >  #1:  (&type->s_umount_key#26){++++++}, at: [<ffffffff81232ffb>]
> > trylock_super+0x1b/0x50
> >  #2:  (sb_internal){.+.+.?}, at: [<ffffffff812327f4>]
> > __sb_start_write+0xb4/0xf0
> > 
> > stack backtrace:
> > CPU: 0 PID: 543 Comm: kswapd0 Tainted: G           O    4.5.0-rc2+ #4
> > Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox
> > 12/01/2006
> >  ffffffff82a34f10 ffff88003aa078d0 ffffffff813a14f9 ffff88003d8551c0
> >  ffff88003aa07920 ffffffff8110ec65 0000000000000000 0000000000000001
> >  ffff880000000001 000000000000000b 0000000000000008 ffff88003d855aa0
> > Call Trace:
> >  [<ffffffff813a14f9>] dump_stack+0x4b/0x72
> >  [<ffffffff8110ec65>] print_usage_bug+0x215/0x240
> >  [<ffffffff8110ee85>] mark_lock+0x1f5/0x660
> >  [<ffffffff8110e100>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
> >  [<ffffffff811102e0>] __lock_acquire+0xa80/0x1e50
> >  [<ffffffff8122474e>] ? kmem_cache_alloc+0x15e/0x230
> >  [<ffffffffa008acc1>] ? kmem_zone_alloc+0x81/0x120 [xfs]
> >  [<ffffffff811122e8>] lock_acquire+0xd8/0x1e0
> >  [<ffffffffa00781f7>] ? xfs_ilock+0x177/0x200 [xfs]
> >  [<ffffffffa0083a70>] ? xfs_reflink_cancel_cow_range+0x150/0x300 [xfs]
> >  [<ffffffff8110aace>] down_write_nested+0x5e/0xc0
> >  [<ffffffffa00781f7>] ? xfs_ilock+0x177/0x200 [xfs]
> >  [<ffffffffa00781f7>] xfs_ilock+0x177/0x200 [xfs]
> >  [<ffffffffa0083a70>] xfs_reflink_cancel_cow_range+0x150/0x300 [xfs]
> >  [<ffffffffa0085bdc>] xfs_fs_evict_inode+0xdc/0x1e0 [xfs]
> >  [<ffffffff8124d7d5>] evict+0xc5/0x190
> >  [<ffffffff8124d8d9>] dispose_list+0x39/0x60
> >  [<ffffffff8124eb2b>] prune_icache_sb+0x4b/0x60
> >  [<ffffffff8123317f>] super_cache_scan+0x14f/0x1a0
> >  [<ffffffff811e0d19>] shrink_slab.part.63.constprop.79+0x1e9/0x4e0
> >  [<ffffffff811e50ee>] shrink_zone+0x15e/0x170
> >  [<ffffffff811e5ef1>] kswapd+0x4f1/0xa80
> >  [<ffffffff811e5a00>] ? zone_reclaim+0x230/0x230
> >  [<ffffffff810e6882>] kthread+0xf2/0x110
> >  [<ffffffff810e6790>] ? kthread_create_on_node+0x220/0x220
> >  [<ffffffff8184803f>] ret_from_fork+0x3f/0x70
> >  [<ffffffff810e6790>] ? kthread_create_on_node+0x220/0x220
> > hrtimer: interrupt took 4824925 ns

The reclaim -> lock context that it's complaining about here is on
an inode being reclaimed - it has no active references and so, by
definition, cannot deadlock with a context holding an active
reference to an inode ilock. Hence there cannot possibly be a
deadlock here, but we can't tell lockdep that easily in any way
without going back to the bad old ways of creating a new lockdep
class for inode ilocks the moment they enter ->evict. This then
disables "entire lifecycle" lockdep checking on the xfs inode ilock,
which is why we got rid of it in the first place.

Our "traditional" solution to this is to add KM_NOFS to the
allocation to force GFP_NOFS allocation in all contexts so that we
shut up lockdep and people don't keep endlessly reporting the same
non-problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
