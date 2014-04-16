Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45F3B29DF7
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:18:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 116A08F8049
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:18:20 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id b8vNFfjVA9GrXHJO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:18:18 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:36 +1000
Subject: [PATCH 04/19] Make effect of PF_FSTRANS to disable __GFP_FS universal.
Message-ID: <20140416040336.10604.58240.stgit@notabene.brown>
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
Cc: Ming Lei <ming.lei@canonical.com>, xfs@oss.sgi.com

Currently both xfs and nfs will handle PF_FSTRANS by disabling
__GFP_FS.

Make this effect global by repurposing memalloc_noio_flags (which
does the same thing for PF_MEMALLOC_NOIO and __GFP_IO) to generally
impost the task flags on a gfp_t.
Due to this repurposing we change the name of memalloc_noio_flags
to gfp_from_current().

As PF_FSTRANS now uniformly removes __GFP_FS we can remove special
code for this from xfs and nfs.

As we can now expect other code to set PF_FSTRANS, its meaning is more
general, so the WARN_ON in xfs_vm_writepage() which checks PF_FSTRANS
is not set is no longer appropriate.  PF_FSTRANS may be set for other
reasons than an XFS transaction.

As lockdep cares about __GFP_FS, we need to translate PF_FSTRANS to
__GFP_FS before calling lockdep_alloc_trace() in various places.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/nfs/file.c         |    3 +--
 fs/xfs/kmem.h         |    2 --
 fs/xfs/xfs_aops.c     |    7 -------
 include/linux/sched.h |    5 ++++-
 mm/page_alloc.c       |    3 ++-
 mm/slab.c             |    2 ++
 mm/slob.c             |    2 ++
 mm/slub.c             |    1 +
 mm/vmscan.c           |    4 ++--
 9 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 5bb790a69c71..ed863f52bae7 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -472,8 +472,7 @@ static int nfs_release_page(struct page *page, gfp_t gfp)
 	/* Only do I/O if gfp is a superset of GFP_KERNEL, and we're not
 	 * doing this memory reclaim for a fs-related allocation.
 	 */
-	if (mapping && (gfp & GFP_KERNEL) == GFP_KERNEL &&
-	    !(current->flags & PF_FSTRANS)) {
+	if (mapping && (gfp & GFP_KERNEL) == GFP_KERNEL) {
 		int how = FLUSH_SYNC;
 
 		/* Don't let kswapd deadlock waiting for OOM RPC calls */
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 64db0e53edea..882b86270ebe 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -50,8 +50,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 		lflags = GFP_ATOMIC | __GFP_NOWARN;
 	} else {
 		lflags = GFP_KERNEL | __GFP_NOWARN;
-		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
-			lflags &= ~__GFP_FS;
 	}
 
 	if (flags & KM_ZERO)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index db2cfb067d0b..207a7f86d5d7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -952,13 +952,6 @@ xfs_vm_writepage(
 			PF_MEMALLOC))
 		goto redirty;
 
-	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called while in a filesystem transaction.
-	 */
-	if (WARN_ON(current->flags & PF_FSTRANS))
-		goto redirty;
-
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
 	end_index = offset >> PAGE_CACHE_SHIFT;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 56fa52a0654c..f3291ed33c27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1860,10 +1860,13 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define used_math() tsk_used_math(current)
 
 /* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags */
-static inline gfp_t memalloc_noio_flags(gfp_t flags)
+/* __GFP_FS isn't allowed if PF_FSTRANS is set in current->flags */
+static inline gfp_t gfp_from_current(gfp_t flags)
 {
 	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
 		flags &= ~__GFP_IO;
+	if (unlikely(current->flags & PF_FSTRANS))
+		flags &= ~__GFP_FS;
 	return flags;
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff8b91aa0b87..5e9225df3447 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2718,6 +2718,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	struct mem_cgroup *memcg = NULL;
 
 	gfp_mask &= gfp_allowed_mask;
+	gfp_mask = gfp_from_current(gfp_mask);
 
 	lockdep_trace_alloc(gfp_mask);
 
@@ -2765,7 +2766,7 @@ retry_cpuset:
 		 * can deadlock because I/O on the device might not
 		 * complete.
 		 */
-		gfp_mask = memalloc_noio_flags(gfp_mask);
+		gfp_mask = gfp_from_current(gfp_mask);
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
diff --git a/mm/slab.c b/mm/slab.c
index b264214c77ea..914d88661f3d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3206,6 +3206,7 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	int slab_node = numa_mem_id();
 
 	flags &= gfp_allowed_mask;
+	flags = gfp_from_current(flags);
 
 	lockdep_trace_alloc(flags);
 
@@ -3293,6 +3294,7 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 	void *objp;
 
 	flags &= gfp_allowed_mask;
+	flags = gfp_from_current(flags);
 
 	lockdep_trace_alloc(flags);
 
diff --git a/mm/slob.c b/mm/slob.c
index 4bf8809dfcce..18206f54d227 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -431,6 +431,7 @@ __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 	void *ret;
 
 	gfp &= gfp_allowed_mask;
+	flags = gfp_from_current(flags);
 
 	lockdep_trace_alloc(gfp);
 
@@ -539,6 +540,7 @@ void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 	void *b;
 
 	flags &= gfp_allowed_mask;
+	flags = gfp_from_current(flags);
 
 	lockdep_trace_alloc(flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index 25f14ad8f817..ff7c15e977da 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -961,6 +961,7 @@ static inline void kfree_hook(const void *x)
 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 {
 	flags &= gfp_allowed_mask;
+	flags = gfp_from_current(flags);
 	lockdep_trace_alloc(flags);
 	might_sleep_if(flags & __GFP_WAIT);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 67165f839936..05de3289d031 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2592,7 +2592,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
-		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
+		.gfp_mask = (gfp_mask = gfp_from_current(gfp_mask)),
 		.may_writepage = !laptop_mode,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
@@ -3524,7 +3524,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
+		.gfp_mask = (gfp_mask = gfp_from_current(gfp_mask)),
 		.order = order,
 		.priority = ZONE_RECLAIM_PRIORITY,
 	};


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
