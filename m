Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0133.outbound.protection.outlook.com ([104.47.2.133]:62528
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751793AbeCWMkB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Mar 2018 08:40:01 -0400
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
References: <20180315230313.GM18129@dastard>
 <6628c551-f607-367b-1ee6-f458266c1d92@virtuozzo.com>
 <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
 <20180320001827.GB1150@dastard>
 <ec116ce6-c22b-66e1-0e01-55f895997c7d@virtuozzo.com>
 <20180320143452.GT18129@dastard>
 <5eb88165-c108-5989-3cb5-1f260cec5e53@virtuozzo.com>
 <20180322050152.GA18129@dastard>
 <3320c962-35c5-c5ed-2a9f-0acb2b875579@virtuozzo.com>
 <20180322234613.GD18129@dastard>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <c1fc50fe-25e7-a92a-a2a8-3e40e7de9b0a@virtuozzo.com>
Date: Fri, 23 Mar 2018 15:39:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180322234613.GD18129@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On 23.03.2018 02:46, Dave Chinner wrote:
> On Thu, Mar 22, 2018 at 07:52:37PM +0300, Kirill Tkhai wrote:
>> Here is the problem I'm solving: https://lkml.org/lkml/2018/3/21/365.
> 
> Oh, finally you tell me what the problem is that you're trying to
> solve. I *asked this several times* and got no response. Thank you
> for wasting so much of my time.
> 
>> Current shrinker is not scalable. Then there are many memcg and mounts,
>> the time of iteration shrink_slab() in case of global reclaim can
>> take much time. There is times of shrink_slab() by the link. A node
>> with 200 containers may waste 4 seconds on global reclaim just to
>> iterate over all shrinkers for all cgroups, call shrinker::count_objects()
>> and receive 0 zero objects.
> 
> So, your problem is the way the memcgs were tacked onto the side
> of the list_lru infrastructure and are iterated, which has basically
> nothing to do with the way the low level XFS inode shrinker behaves.
> 
> /me looks at the patches
> 
> /me shudders at the thought of external "cache has freeable items"
> control for the shrinking of vfs caches.
> 
> Biggest problem I see with this is the scope for coherency bugs ini
> the "memcg shrinker has freeable items" tracking. If that happens,
> there's no way of getting that memcg to run it's shrinker ever
> again. That seems very, very fragile and likely to be an endless
> source of OOM bugs. The whole point of the shrinker polling
> infrastructure is that it is not susceptible to this sort of bug.
> 
> Really, the problem is that there's no separate list of memcg aware
> shrinkers, so every registered shrinker has to be iterated just to
> find the one shrinker that is memcg aware.

I don't think the logic is difficult. There are generic rules,
and the only task is to teach them memcg-aware shrinkers. Currently,
they are only super block and workingsets shrinkers, and both of
them are based on generic list_lru infrastructure. Shrinker-related
bit is also cleared in generic code (shrink_slab()) only, and
the algorhythm doesn't allow to clear it without double check.
The only principle modification I'm thinking about is we should
clear the bit only when the shrinker is called with maximum
parameters: priority and GFP.

There are a lot of performance improving synchronizations in kernel,
and they had been refused, the kernel would have remained in the age
of big kernel lock.

> So why not just do the simple thing which is create a separate
> "memcg-aware" shrinker list (i.e. create shrinker_list_memcg
> alongside shrinker_list) and only iterate the shrinker_list_memcg
> when a memcg is passed to shrink_slab()?
> 
> That means we'll only run 2 shrinkers per memcg at most (sueprblock
> and working set) per memcg reclaim call. That's a simple 10-20 line
> change, not a whole mess of new code and issues...

It was the first optimization, which came to my head, by there is no
almost a performance profit, since memcg-aware shrinkers still be called
per every memcg, and they are the biggest part of shrinkers in the system.
 
>> Can't we call shrink of shared objects only for top memcg? Something like
>> this:
> 
> What's a "shared object", and how is it any different to a normal
> slab cache object?

Sorry, it's erratum. I'm speaking about cached objects. I mean something like
the below. The patch makes cached objects be cleared outside the memcg iteration
cycle (it has not sense to call them for every memcg since cached object logic
just ignores memcg).

---
diff --git a/fs/super.c b/fs/super.c
index 0660083427fa..c7321c42ab1f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -61,8 +61,8 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	long	fs_objects = 0;
 	long	total_objects;
 	long	freed = 0;
-	long	dentries;
-	long	inodes;
+	long	dentries = 0;
+	long	inodes = 0;
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
@@ -76,19 +76,27 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!trylock_super(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects)
-		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
+	if (sc->cached) {
+		if (sb->s_op->nr_cached_objects) {
+			fs_objects = sb->s_op->nr_cached_objects(sb, sc);
+			if (!fs_objects)
+				fs_objects = 1;
+
+			sc->nr_to_scan = fs_objects + 1;
+			freed = sb->s_op->free_cached_objects(sb, sc);
+		}
+		goto unlock;
+	}
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
 	dentries = list_lru_shrink_count(&sb->s_dentry_lru, sc);
-	total_objects = dentries + inodes + fs_objects + 1;
+	total_objects = dentries + inodes + 1;
 	if (!total_objects)
 		total_objects = 1;
 
 	/* proportion the scan between the caches */
 	dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
 	inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
-	fs_objects = mult_frac(sc->nr_to_scan, fs_objects, total_objects);
 
 	/*
 	 * prune the dcache first as the icache is pinned by it, then
@@ -101,12 +109,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	freed = prune_dcache_sb(sb, sc);
 	sc->nr_to_scan = inodes + 1;
 	freed += prune_icache_sb(sb, sc);
-
-	if (fs_objects) {
-		sc->nr_to_scan = fs_objects + 1;
-		freed += sb->s_op->free_cached_objects(sb, sc);
-	}
-
+unlock:
 	up_read(&sb->s_umount);
 	return freed;
 }
@@ -127,11 +130,13 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	 * ensures the safety of call to list_lru_shrink_count() and
 	 * s_op->nr_cached_objects().
 	 */
-	if (sb->s_op && sb->s_op->nr_cached_objects)
-		total_objects = sb->s_op->nr_cached_objects(sb, sc);
-
-	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
-	total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
+	if (sc->cached) {
+		if (sb->s_op && sb->s_op->nr_cached_objects)
+			total_objects = sb->s_op->nr_cached_objects(sb, sc);
+	} else {
+		total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
+		total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
+	}
 
 	total_objects = vfs_pressure_ratio(total_objects);
 	return total_objects;
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index a3894918a436..c817173e19be 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -28,6 +28,7 @@ struct shrink_control {
 
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
+	u8 cached:1;
 
 	/* current memcg being shrunk (for memcg aware shrinkers) */
 	struct mem_cgroup *memcg;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8fcd9f8d7390..e117830f07fd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -482,6 +482,33 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
 	return freed;
 }
 
+static void shrink_cached_slab(gfp_t gfp_mask, int nid, int priority)
+{
+	struct shrinker *shrinker;
+
+	if (!down_read_trylock(&shrinker_rwsem))
+		return;
+
+	list_for_each_entry(shrinker, &shrinker_list, list) {
+		struct shrink_control sc = {
+			.gfp_mask = gfp_mask,
+			.nid = nid,
+			.cached = 1,
+		};
+
+		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE))
+			continue;
+		if (!(shrinker->flags & SHRINKER_NUMA_AWARE))
+			sc.nid = 0;
+		if (rwsem_is_contended(&shrinker_rwsem))
+			break;
+
+		do_shrink_slab(&sc, shrinker, priority);
+	}
+
+	up_read(&shrinker_rwsem);
+}
+
 void drop_slab_node(int nid)
 {
 	unsigned long freed;
@@ -493,6 +520,8 @@ void drop_slab_node(int nid)
 		do {
 			freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
 		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+
+		shrink_cached_slab(GFP_KERNEL, nid, 0);
 	} while (freed > 10);
 }
 
@@ -2573,6 +2602,8 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 			shrink_slab(sc->gfp_mask, pgdat->node_id, NULL,
 				    sc->priority);
 
+		shrink_cached_slab(sc->gfp_mask, pgdat->node_id, sc->priority);
+
 		if (reclaim_state) {
 			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 			reclaim_state->reclaimed_slab = 0;

