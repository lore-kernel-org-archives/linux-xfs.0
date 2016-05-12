Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB48E7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 00:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94D2E304048
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 22:53:55 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id 2xZ0GsrEn3RNCba5 for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 22:53:52 -0700 (PDT)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <94cea603-2782-1c5a-e2df-42db4459a8ce@cn.fujitsu.com>
Date: Thu, 12 May 2016 13:53:44 +0800
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

Hi Darrick,

Thanks for your reflink work for xfs first, that's quite a good and 
useful feature, also helps to debug btrfs problems.
(Without that, there is no good reference for reflink behavior)

But when testing your for-dave-for-4.6 branch, even I'm just testing 
btrfs with xfstests, kernel report some strange lockdep from xfs:

------
run fstests generic/175 at 2016-05-12 13:22:06
BTRFS: device fsid 3d5c9c3b-2d08-4f0b-9663-00a88cd218da devid 1 transid 
3 /dev/sdb6
BTRFS info (device sdb6): disk space caching is enabled
BTRFS: has skinny extents
BTRFS: flagging fs with big metadata feature
BTRFS: creating UUID tree
BTRFS: device fsid bb75eb48-4c5f-4b75-a41d-f642d70c7294 devid 1 transid 
3 /dev/sdb6
BTRFS info (device sdb6): disk space caching is enabled
BTRFS: has skinny extents
BTRFS: flagging fs with big metadata feature
BTRFS: creating UUID tree


=================================
[ INFO: inconsistent lock state ]
4.5.0-rc2+ #4 Tainted: G           O
---------------------------------
inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
kswapd0/543 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (&xfs_nondir_ilock_class){++++-+}, at: [<ffffffffa00781f7>] 
xfs_ilock+0x177/0x200 [xfs]
{RECLAIM_FS-ON-R} state was registered at:
   [<ffffffff8110f369>] mark_held_locks+0x79/0xa0
   [<ffffffff81113a43>] lockdep_trace_alloc+0xb3/0x100
   [<ffffffff81224623>] kmem_cache_alloc+0x33/0x230
   [<ffffffffa008acc1>] kmem_zone_alloc+0x81/0x120 [xfs]
   [<ffffffffa005456e>] xfs_refcountbt_init_cursor+0x3e/0xa0 [xfs]
   [<ffffffffa0053455>] __xfs_refcount_find_shared+0x75/0x580 [xfs]
   [<ffffffffa00539e4>] xfs_refcount_find_shared+0x84/0xb0 [xfs]
   [<ffffffffa005dcb8>] xfs_getbmap+0x608/0x8c0 [xfs]
   [<ffffffffa007634b>] xfs_vn_fiemap+0xab/0xc0 [xfs]
   [<ffffffff81244208>] do_vfs_ioctl+0x498/0x670
   [<ffffffff81244459>] SyS_ioctl+0x79/0x90
   [<ffffffff81847cd7>] entry_SYSCALL_64_fastpath+0x12/0x6f
irq event stamp: 510775
hardirqs last  enabled at (510775): [<ffffffff812245d0>] 
__slab_alloc+0x50/0x70
hardirqs last disabled at (510774): [<ffffffff812245ae>] 
__slab_alloc+0x2e/0x70
softirqs last  enabled at (510506): [<ffffffff810c8ea8>] 
__do_softirq+0x358/0x430
softirqs last disabled at (510489): [<ffffffff810c911d>] irq_exit+0xad/0xb0

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&xfs_nondir_ilock_class);
   <Interrupt>
     lock(&xfs_nondir_ilock_class);

  *** DEADLOCK ***

3 locks held by kswapd0/543:
  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811e0b78>] 
shrink_slab.part.63.constprop.79+0x48/0x4e0
  #1:  (&type->s_umount_key#26){++++++}, at: [<ffffffff81232ffb>] 
trylock_super+0x1b/0x50
  #2:  (sb_internal){.+.+.?}, at: [<ffffffff812327f4>] 
__sb_start_write+0xb4/0xf0

stack backtrace:
CPU: 0 PID: 543 Comm: kswapd0 Tainted: G           O    4.5.0-rc2+ #4
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 
12/01/2006
  ffffffff82a34f10 ffff88003aa078d0 ffffffff813a14f9 ffff88003d8551c0
  ffff88003aa07920 ffffffff8110ec65 0000000000000000 0000000000000001
  ffff880000000001 000000000000000b 0000000000000008 ffff88003d855aa0
Call Trace:
  [<ffffffff813a14f9>] dump_stack+0x4b/0x72
  [<ffffffff8110ec65>] print_usage_bug+0x215/0x240
  [<ffffffff8110ee85>] mark_lock+0x1f5/0x660
  [<ffffffff8110e100>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
  [<ffffffff811102e0>] __lock_acquire+0xa80/0x1e50
  [<ffffffff8122474e>] ? kmem_cache_alloc+0x15e/0x230
  [<ffffffffa008acc1>] ? kmem_zone_alloc+0x81/0x120 [xfs]
  [<ffffffff811122e8>] lock_acquire+0xd8/0x1e0
  [<ffffffffa00781f7>] ? xfs_ilock+0x177/0x200 [xfs]
  [<ffffffffa0083a70>] ? xfs_reflink_cancel_cow_range+0x150/0x300 [xfs]
  [<ffffffff8110aace>] down_write_nested+0x5e/0xc0
  [<ffffffffa00781f7>] ? xfs_ilock+0x177/0x200 [xfs]
  [<ffffffffa00781f7>] xfs_ilock+0x177/0x200 [xfs]
  [<ffffffffa0083a70>] xfs_reflink_cancel_cow_range+0x150/0x300 [xfs]
  [<ffffffffa0085bdc>] xfs_fs_evict_inode+0xdc/0x1e0 [xfs]
  [<ffffffff8124d7d5>] evict+0xc5/0x190
  [<ffffffff8124d8d9>] dispose_list+0x39/0x60
  [<ffffffff8124eb2b>] prune_icache_sb+0x4b/0x60
  [<ffffffff8123317f>] super_cache_scan+0x14f/0x1a0
  [<ffffffff811e0d19>] shrink_slab.part.63.constprop.79+0x1e9/0x4e0
  [<ffffffff811e50ee>] shrink_zone+0x15e/0x170
  [<ffffffff811e5ef1>] kswapd+0x4f1/0xa80
  [<ffffffff811e5a00>] ? zone_reclaim+0x230/0x230
  [<ffffffff810e6882>] kthread+0xf2/0x110
  [<ffffffff810e6790>] ? kthread_create_on_node+0x220/0x220
  [<ffffffff8184803f>] ret_from_fork+0x3f/0x70
  [<ffffffff810e6790>] ? kthread_create_on_node+0x220/0x220
hrtimer: interrupt took 4824925 ns

BTRFS info (device sdb6): disk space caching is enabled
BTRFS: has skinny extents
------

The test machine is using normal xfs (without -m reflink=1) as its root.
As you can see, it's running generic/175 on *BTRFS*, not *XFS*, but 
still lockdep warning from xfs.

Hopes the output could help you.

Thanks,
Qu


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
