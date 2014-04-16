Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1555F7F56
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:18:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2006304089
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:18:03 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id do6SAqeaDqcBQSo9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:18:02 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:36 +1000
Subject: [PATCH 02/19] lockdep: lockdep_set_current_reclaim_state should
	save old value
Message-ID: <20140416040336.10604.59714.stgit@notabene.brown>
In-Reply-To: <20140416033623.10604.69237.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, xfs@oss.sgi.com

Currently kswapd sets current->lockdep_reclaim_gfp but the first
memory allocation call will clear it.  So the setting does no good.
Thus the lockdep_set_current_reclaim_state call in kswapd() is
ineffective.

With this patch we always save the old value and then restore it,
so lockdep gets to properly check the locks that kswapd takes.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 include/linux/lockdep.h  |    8 ++++----
 kernel/locking/lockdep.c |    8 +++++---
 mm/page_alloc.c          |    5 +++--
 mm/vmscan.c              |   10 ++++++----
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc5da60..18eedd692d16 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -351,8 +351,8 @@ static inline void lock_set_subclass(struct lockdep_map *lock,
 	lock_set_class(lock, lock->name, lock->key, subclass, ip);
 }
 
-extern void lockdep_set_current_reclaim_state(gfp_t gfp_mask);
-extern void lockdep_clear_current_reclaim_state(void);
+extern gfp_t lockdep_set_current_reclaim_state(gfp_t gfp_mask);
+extern void lockdep_restore_current_reclaim_state(gfp_t old_mask);
 extern void lockdep_trace_alloc(gfp_t mask);
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0, .lockdep_reclaim_gfp = 0,
@@ -379,8 +379,8 @@ static inline void lockdep_on(void)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
-# define lockdep_set_current_reclaim_state(g)	do { } while (0)
-# define lockdep_clear_current_reclaim_state()	do { } while (0)
+# define lockdep_set_current_reclaim_state(g)	(0)
+# define lockdep_restore_current_reclaim_state(g) do { } while (0)
 # define lockdep_trace_alloc(g)			do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a54783fa0..e05b82e92373 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3645,14 +3645,16 @@ int lock_is_held(struct lockdep_map *lock)
 }
 EXPORT_SYMBOL_GPL(lock_is_held);
 
-void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
+gfp_t lockdep_set_current_reclaim_state(gfp_t gfp_mask)
 {
+	gfp_t old = current->lockdep_reclaim_gfp;
 	current->lockdep_reclaim_gfp = gfp_mask;
+	return old;
 }
 
-void lockdep_clear_current_reclaim_state(void)
+void lockdep_restore_current_reclaim_state(gfp_t gfp_mask)
 {
-	current->lockdep_reclaim_gfp = 0;
+	current->lockdep_reclaim_gfp = gfp_mask;
 }
 
 #ifdef CONFIG_LOCK_STAT
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a3d1f5da2f21..ff8b91aa0b87 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2327,20 +2327,21 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order, struct zonelist *zonelist,
 	struct reclaim_state reclaim_state;
 	int progress;
 	unsigned int pflags;
+	gfp_t old_mask;
 
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
 	current_set_flags_nested(&pflags, PF_MEMALLOC);
-	lockdep_set_current_reclaim_state(gfp_mask);
+	old_mask = lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	current->reclaim_state = &reclaim_state;
 
 	progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
 	current->reclaim_state = NULL;
-	lockdep_clear_current_reclaim_state();
+	lockdep_restore_current_reclaim_state(old_mask);
 	current_restore_flags_nested(&pflags, PF_MEMALLOC);
 
 	cond_resched();
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 94acf53d9abf..67165f839936 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3344,16 +3344,17 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 	struct task_struct *p = current;
 	unsigned long nr_reclaimed;
 	unsigned int pflags;
+	gfp_t old_mask;
 
 	current_set_flags_nested(&pflags, PF_MEMALLOC);
-	lockdep_set_current_reclaim_state(sc.gfp_mask);
+	old_mask = lockdep_set_current_reclaim_state(sc.gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	p->reclaim_state = NULL;
-	lockdep_clear_current_reclaim_state();
+	lockdep_restore_current_reclaim_state(old_mask);
 	current_restore_flags_nested(&pflags, PF_MEMALLOC);
 
 	return nr_reclaimed;
@@ -3532,6 +3533,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	};
 	unsigned long nr_slab_pages0, nr_slab_pages1;
 	unsigned int pflags;
+	gfp_t old_mask;
 
 	cond_resched();
 	/*
@@ -3540,7 +3542,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * and RECLAIM_SWAP.
 	 */
 	current_set_flags_nested(&pflags, PF_MEMALLOC | PF_SWAPWRITE);
-	lockdep_set_current_reclaim_state(gfp_mask);
+	old_mask = lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
@@ -3590,7 +3592,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	p->reclaim_state = NULL;
 	current_restore_flags_nested(&pflags, PF_MEMALLOC | PF_SWAPWRITE);
-	lockdep_clear_current_reclaim_state();
+	lockdep_restore_current_reclaim_state(old_mask);
 	return sc.nr_reclaimed >= nr_pages;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
