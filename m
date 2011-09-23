Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NEcf23110341 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 09:38:42 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D2C9186921
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 07:38:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A08diUQgvHxDDb7z for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2011 07:38:40 -0700 (PDT)
Date: Fri, 23 Sep 2011 16:38:17 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 1/4 v2] mm: exclude reserved pages from dirtyable memory
Message-ID: <20110923143816.GA2606@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-2-git-send-email-jweiner@redhat.com>
	<20110921140423.GG4849@suse.de> <20110921150328.GJ4849@suse.de>
	<20110922090326.GB29046@redhat.com> <20110922105400.GL4849@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110922105400.GL4849@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Minchan Kim <minchan.kim@gmail.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

The amount of dirtyable pages should not include the full number of
free pages: there is a number of reserved pages that the page
allocator and kswapd always try to keep free.

The closer (reclaimable pages - dirty pages) is to the number of
reserved pages, the more likely it becomes for reclaim to run into
dirty pages:

       +----------+ ---
       |   anon   |  |
       +----------+  |
       |          |  |
       |          |  -- dirty limit new    -- flusher new
       |   file   |  |                     |
       |          |  |                     |
       |          |  -- dirty limit old    -- flusher old
       |          |                        |
       +----------+                       --- reclaim
       | reserved |
       +----------+
       |  kernel  |
       +----------+

This patch introduces a per-zone dirty reserve that takes both the
lowmem reserve as well as the high watermark of the zone into account,
and a global sum of those per-zone values that is subtracted from the
global amount of dirtyable pages.  The lowmem reserve is unavailable
to page cache allocations and kswapd tries to keep the high watermark
free.  We don't want to end up in a situation where reclaim has to
clean pages in order to balance zones.

Not treating reserved pages as dirtyable on a global level is only a
conceptual fix.  In reality, dirty pages are not distributed equally
across zones and reclaim runs into dirty pages on a regular basis.

But it is important to get this right before tackling the problem on a
per-zone level, where the distance between reclaim and the dirty pages
is mostly much smaller in absolute numbers.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 include/linux/mmzone.h |    6 ++++++
 include/linux/swap.h   |    1 +
 mm/page-writeback.c    |    6 ++++--
 mm/page_alloc.c        |   19 +++++++++++++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1ed4116..37a61e7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -317,6 +317,12 @@ struct zone {
 	 */
 	unsigned long		lowmem_reserve[MAX_NR_ZONES];
 
+	/*
+	 * This is a per-zone reserve of pages that should not be
+	 * considered dirtyable memory.
+	 */
+	unsigned long		dirty_balance_reserve;
+
 #ifdef CONFIG_NUMA
 	int node;
 	/*
diff --git a/include/linux/swap.h b/include/linux/swap.h
index b156e80..9021453 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -209,6 +209,7 @@ struct swap_list_t {
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
+extern unsigned long dirty_balance_reserve;
 extern unsigned int nr_free_buffer_pages(void);
 extern unsigned int nr_free_pagecache_pages(void);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index da6d263..c8acf8a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -170,7 +170,8 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
 		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z);
+		     zone_reclaimable_pages(z) -
+		     zone->dirty_balance_reserve;
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -194,7 +195,8 @@ static unsigned long determine_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
+	    dirty_balance_reserve;
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1dba05e..f8cba89 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -96,6 +96,14 @@ EXPORT_SYMBOL(node_states);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
+/*
+ * When calculating the number of globally allowed dirty pages, there
+ * is a certain number of per-zone reserves that should not be
+ * considered dirtyable memory.  This is the sum of those reserves
+ * over all existing zones that contribute dirtyable memory.
+ */
+unsigned long dirty_balance_reserve __read_mostly;
+
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
@@ -5076,8 +5084,19 @@ static void calculate_totalreserve_pages(void)
 			if (max > zone->present_pages)
 				max = zone->present_pages;
 			reserve_pages += max;
+			/*
+			 * Lowmem reserves are not available to
+			 * GFP_HIGHUSER page cache allocations and
+			 * kswapd tries to balance zones to their high
+			 * watermark.  As a result, neither should be
+			 * regarded as dirtyable memory, to prevent a
+			 * situation where reclaim has to clean pages
+			 * in order to balance the zones.
+			 */
+			zone->dirty_balance_reserve = max;
 		}
 	}
+	dirty_balance_reserve = reserve_pages;
 	totalreserve_pages = reserve_pages;
 }
 
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
