Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285C1C19F35
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B0EB61041
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbhIBKAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:35 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48521 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233710AbhIBKAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:34 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id CDA5D80D5DB
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nJ2-RB
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pD3-JQ
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: reduce kvmalloc overhead for CIL shadow buffers
Date:   Thu,  2 Sep 2021 19:59:27 +1000
Message-Id: <20210902095927.911100-8-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=BYTb1cA_JtdTmwEp6ZAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Oh, let me count the ways that the kvmalloc API sucks dog eggs.

The problem is when we are logging lots of large objects, we hit
kvmalloc really damn hard with costly order allocations, and
behaviour utterly sucks:

     - 49.73% xlog_cil_commit
	 - 31.62% kvmalloc_node
	    - 29.96% __kmalloc_node
	       - 29.38% kmalloc_large_node
		  - 29.33% __alloc_pages
		     - 24.33% __alloc_pages_slowpath.constprop.0
			- 18.35% __alloc_pages_direct_compact
			   - 17.39% try_to_compact_pages
			      - compact_zone_order
				 - 15.26% compact_zone
				      5.29% __pageblock_pfn_to_page
				      3.71% PageHuge
				    - 1.44% isolate_migratepages_block
					 0.71% set_pfnblock_flags_mask
				   1.11% get_pfnblock_flags_mask
			   - 0.81% get_page_from_freelist
			      - 0.59% _raw_spin_lock_irqsave
				 - do_raw_spin_lock
				      __pv_queued_spin_lock_slowpath
			- 3.24% try_to_free_pages
			   - 3.14% shrink_node
			      - 2.94% shrink_slab.constprop.0
				 - 0.89% super_cache_count
				    - 0.66% xfs_fs_nr_cached_objects
				       - 0.65% xfs_reclaim_inodes_count
					    0.55% xfs_perag_get_tag
				   0.58% kfree_rcu_shrink_count
			- 2.09% get_page_from_freelist
			   - 1.03% _raw_spin_lock_irqsave
			      - do_raw_spin_lock
				   __pv_queued_spin_lock_slowpath
		     - 4.88% get_page_from_freelist
			- 3.66% _raw_spin_lock_irqsave
			   - do_raw_spin_lock
				__pv_queued_spin_lock_slowpath
	    - 1.63% __vmalloc_node
	       - __vmalloc_node_range
		  - 1.10% __alloc_pages_bulk
		     - 0.93% __alloc_pages
			- 0.92% get_page_from_freelist
			   - 0.89% rmqueue_bulk
			      - 0.69% _raw_spin_lock
				 - do_raw_spin_lock
				      __pv_queued_spin_lock_slowpath
	   13.73% memcpy_erms
	 - 2.22% kvfree

On this workload, that's almost a dozen CPUs all trying to compact
and reclaim memory inside kvmalloc_node at the same time. Yet it is
regularly falling back to vmalloc despite all that compaction, page
and shrinker reclaim that direct reclaim is doing. Copying all the
metadata is taking far less CPU time than allocating the storage!

Direct reclaim should be considered extremely harmful.

This is a high frequency, high throughput, CPU usage and latency
sensitive allocation. We've got memory there, and we're using
kvmalloc to allow memory allocation to avoid doing lots of work to
try to do contiguous allocations.

Except it still does *lots of costly work* that is unnecessary.

Worse: the only way to avoid the slowpath page allocation trying to
do compaction on costly allocations is to turn off direct reclaim
(i.e. remove __GFP_RECLAIM_DIRECT from the gfp flags).

Unfortunately, the stupid kvmalloc API then says "oh, this isn't a
GFP_KERNEL allocation context, so you only get kmalloc!". This
cuts off the vmalloc fallback, and this leads to almost instant OOM
problems which ends up in filesystems deadlocks, shutdowns and/or
kernel crashes.

I want some basic kvmalloc behaviour:

- kmalloc for a contiguous range with fail fast semantics - no
  compaction direct reclaim if the allocation enters the slow path.
- run normal vmalloc (i.e. GFP_KERNEL) if kmalloc fails

The really, really stupid part about this is these kvmalloc() calls
are run under memalloc_nofs task context, so all the allocations are
always reduced to GFP_NOFS regardless of the fact that kvmalloc
requires GFP_KERNEL to be passed in. IOWs, we're already telling
kvmalloc to behave differently to the gfp flags we pass in, but it
still won't allow vmalloc to be run with anything other than
GFP_KERNEL.

So, this patch open codes the kvmalloc() in the commit path to have
the above described behaviour. The result is we more than halve the
CPU time spend doing kvmalloc() in this path and transaction commits
with 64kB objects in them more than doubles. i.e. we get ~5x
reduction in CPU usage per costly-sized kvmalloc() invocation and
the profile looks like this:

  - 37.60% xlog_cil_commit
	16.01% memcpy_erms
      - 8.45% __kmalloc
	 - 8.04% kmalloc_order_trace
	    - 8.03% kmalloc_order
	       - 7.93% alloc_pages
		  - 7.90% __alloc_pages
		     - 4.05% __alloc_pages_slowpath.constprop.0
			- 2.18% get_page_from_freelist
			- 1.77% wake_all_kswapds
....
				    - __wake_up_common_lock
				       - 0.94% _raw_spin_lock_irqsave
		     - 3.72% get_page_from_freelist
			- 2.43% _raw_spin_lock_irqsave
      - 5.72% vmalloc
	 - 5.72% __vmalloc_node_range
	    - 4.81% __get_vm_area_node.constprop.0
	       - 3.26% alloc_vmap_area
		  - 2.52% _raw_spin_lock
	       - 1.46% _raw_spin_lock
	      0.56% __alloc_pages_bulk
      - 4.66% kvfree
	 - 3.25% vfree
	    - __vfree
	       - 3.23% __vunmap
		  - 1.95% remove_vm_area
		     - 1.06% free_vmap_area_noflush
			- 0.82% _raw_spin_lock
		     - 0.68% _raw_spin_lock
		  - 0.92% _raw_spin_lock
	 - 1.40% kfree
	    - 1.36% __free_pages
	       - 1.35% __free_pages_ok
		  - 1.02% _raw_spin_lock_irqsave

It's worth noting that over 50% of the CPU time spent allocating
these shadow buffers is now spent on spinlocks. So the shadow buffer
allocation overhead is greatly reduced by getting rid of direct
reclaim from kmalloc, and could probably be made even less costly if
vmalloc() didn't use global spinlocks to protect it's structures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fff68aad254e..81ebf03bfa5c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -185,6 +185,39 @@ xlog_cil_iovec_space(
 			sizeof(uint64_t));
 }
 
+/*
+ * shadow buffers can be large, so we need to use kvmalloc() here to ensure
+ * success. Unfortunately, kvmalloc() only allows GFP_KERNEL contexts to fall
+ * back to vmalloc, so we can't actually do anything useful with gfp flags to
+ * control the kmalloc() behaviour within kvmalloc(). Hence kmalloc() will do
+ * direct reclaim and compaction in the slow path, both of which are
+ * horrendously expensive. We just want kmalloc to fail fast and fall back to
+ * vmalloc if it can't get somethign straight away from the free lists or buddy
+ * allocator. Hence we have to open code kvmalloc outselves here.
+ *
+ * Also, we are in memalloc_nofs_save task context here, so despite the use of
+ * GFP_KERNEL here, we are actually going to be doing GFP_NOFS allocations. This
+ * is actually the only way to make vmalloc() do GFP_NOFS allocations, so lets
+ * just all pretend this is a GFP_KERNEL context operation....
+ */
+static inline void *
+xlog_cil_kvmalloc(
+	size_t		size)
+{
+	gfp_t		flags = GFP_KERNEL;
+	void		*p;
+
+	flags &= ~__GFP_DIRECT_RECLAIM;
+	flags |= __GFP_NOWARN | __GFP_NORETRY;
+	do {
+		p = kmalloc(buf_size, flags);
+		if (!p)
+			p = vmalloc(buf_size);
+	} while (!p);
+
+	return p;
+}
+
 /*
  * Allocate or pin log vector buffers for CIL insertion.
  *
@@ -293,25 +326,16 @@ xlog_cil_alloc_shadow_bufs(
 		 */
 		if (!lip->li_lv_shadow ||
 		    buf_size > lip->li_lv_shadow->lv_size) {
-
 			/*
 			 * We free and allocate here as a realloc would copy
-			 * unnecessary data. We don't use kmem_zalloc() for the
+			 * unnecessary data. We don't use kvzalloc() for the
 			 * same reason - we don't need to zero the data area in
 			 * the buffer, only the log vector header and the iovec
 			 * storage.
 			 */
 			kmem_free(lip->li_lv_shadow);
+			lv = xlog_cil_kvmalloc(buf_size);
 
-			/*
-			 * We are in transaction context, which means this
-			 * allocation will pick up GFP_NOFS from the
-			 * memalloc_nofs_save/restore context the transaction
-			 * holds. This means we can use GFP_KERNEL here so the
-			 * generic kvmalloc() code will run vmalloc on
-			 * contiguous page allocation failure as we require.
-			 */
-			lv = kvmalloc(buf_size, GFP_KERNEL);
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
 			INIT_LIST_HEAD(&lv->lv_list);
-- 
2.31.1

