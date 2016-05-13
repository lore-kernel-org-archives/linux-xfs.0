Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD7477CA0
	for <xfs@oss.sgi.com>; Fri, 13 May 2016 11:03:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D48A304067
	for <xfs@oss.sgi.com>; Fri, 13 May 2016 09:03:49 -0700 (PDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com
	[74.125.82.65]) by cuda.sgi.com with ESMTP id WIkrimVOcbZojiTr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 May 2016 09:03:44 -0700 (PDT)
Received: by mail-wm0-f65.google.com with SMTP id e201so4581467wme.2
	for <xfs@oss.sgi.com>; Fri, 13 May 2016 09:03:44 -0700 (PDT)
Date: Fri, 13 May 2016 18:03:41 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160513160341.GW20141@dhcp22.suse.cz>
References: <94cea603-2782-1c5a-e2df-42db4459a8ce@cn.fujitsu.com>
	<20160512055756.GE6648@birch.djwong.org>
	<20160512080321.GA18496@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512080321.GA18496@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu 12-05-16 18:03:21, Dave Chinner wrote:
> [ cc Michal Hocko, just so he can see a lockdep reclaim state false
> positive ]

Thank you for CCing me!

I am sorry I didn't follow up on the previous discussion but I got side
tracked by something else. I have tried to cook up something really
simply. I didn't get to test it at all and it might be completely broken
but I just wanted to throw an idea for the discussion. I am CCing Peter
as well - he might have a better idea (the reference to the full email
is in the changelog. Is something like the following correct/acceptable?

This is on top of my scope gfp_nofs patch I have posted recently but I
can reorder them if this looks ok.
---
>From 9e980c2342f355e2bf1e12839c51e8e304e8842e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 13 May 2016 17:47:31 +0200
Subject: [PATCH] lockdep: allow to disable reclaim lockup detection

The current implementation of the reclaim lockup detection can lead to
false positives and those even happen and usually lead to tweak the
code to silence the lockdep by using GFP_NOFS even though the context
can use __GFP_FS just fine. See
http://lkml.kernel.org/r/20160512080321.GA18496@dastard as an example.

=================================
[ INFO: inconsistent lock state ]
4.5.0-rc2+ #4 Tainted: G           O
---------------------------------
inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
kswapd0/543 [HC0[0]:SC0[0]:HE1:SE1] takes:

(&xfs_nondir_ilock_class){++++-+}, at: [<ffffffffa00781f7>] xfs_ilock+0x177/0x200 [xfs]

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

       CPU0
       ----
  lock(&xfs_nondir_ilock_class);
  <Interrupt>
    lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

3 locks held by kswapd0/543:

stack backtrace:
CPU: 0 PID: 543 Comm: kswapd0 Tainted: G           O    4.5.0-rc2+ #4

Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006

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

To quote Dave:
"
Ignoring whether reflink should be doing anything or not, that's a
"xfs_refcountbt_init_cursor() gets called both outside and inside
transactions" lockdep false positive case. The problem here is
lockdep has seen this allocation from within a transaction, hence a
GFP_NOFS allocation, and now it's seeing it in a GFP_KERNEL context.
Also note that we have an active reference to this inode.

So, because the reclaim annotations overload the interrupt level
detections and it's seen the inode ilock been taken in reclaim
("interrupt") context, this triggers a reclaim context warning where
it thinks it is unsafe to do this allocation in GFP_KERNEL context
holding the inode ilock...
"

This sounds like a fundamental problem of the reclaim lock detection.
It is really impossible to annotate such a special usecase IMHO unless
the reclaim lockup detection is reworked completely. Until then it
is much better to provide a way to add "I know what I am doing flag"
and mark problematic places. This would prevent from abusing GFP_NOFS
flag which has a runtime effect even on configurations which have
lockdep disabled.

Introduce lockdep_trace_alloc_{disable,enable} which would tell
__lockdep_trace_alloc to skip an allocation request even when it has
__GFP_FS enabled. This means that the false positive shouldn't be
generated.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/lockdep.h  | 10 ++++++++++
 include/linux/sched.h    |  1 +
 kernel/locking/lockdep.c |  4 ++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4dca42fd32f5..4b04bf9ab560 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -354,6 +354,14 @@ static inline void lock_set_subclass(struct lockdep_map *lock,
 extern void lockdep_set_current_reclaim_state(gfp_t gfp_mask);
 extern void lockdep_clear_current_reclaim_state(void);
 extern void lockdep_trace_alloc(gfp_t mask);
+static inline void lockdep_trace_alloc_disable(void)
+{
+	current->lockdep_reclaim_disabled = 1;
+}
+static inline void lockdep_trace_alloc_enable(void)
+{
+	current->lockdep_reclaim_disabled = 0;
+}
 
 extern void lock_pin_lock(struct lockdep_map *lock);
 extern void lock_unpin_lock(struct lockdep_map *lock);
@@ -392,6 +400,8 @@ static inline void lockdep_on(void)
 # define lockdep_set_current_reclaim_state(g)	do { } while (0)
 # define lockdep_clear_current_reclaim_state()	do { } while (0)
 # define lockdep_trace_alloc(g)			do { } while (0)
+# define lockdep_trace_alloc_disable()		do { } while (0)
+# define lockdep_trace_alloc_enable()		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub) \
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e9521dc0475f..ec643916bad3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1644,6 +1644,7 @@ struct task_struct {
 	unsigned int lockdep_recursion;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	gfp_t lockdep_reclaim_gfp;
+	bool lockdep_reclaim_disabled;
 #endif
 #ifdef CONFIG_UBSAN
 	unsigned int in_ubsan;
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f60124d0871c..cf6ead3e7014 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2753,6 +2753,10 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 	if (!(gfp_mask & __GFP_FS) || (curr->flags & PF_MEMALLOC_NOFS))
 		return;
 
+	/* The caller explicitly asked to disable reclaim recursion tracking */
+	if (curr->lockdep_reclaim_disabled)
+		return;
+
 	/*
 	 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
 	 */
-- 
2.8.1

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
