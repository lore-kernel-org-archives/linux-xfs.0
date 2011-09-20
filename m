Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KDkIsU063103 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 08:46:18 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B6D2175448
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:46:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YeJBgY5jNovlAoYP for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:46:17 -0700 (PDT)
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 1/4] mm: exclude reserved pages from dirtyable memory
Date: Tue, 20 Sep 2011 15:45:12 +0200
Message-Id: <1316526315-16801-2-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

The amount of dirtyable pages should not include the total number of
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

Not treating reserved pages as dirtyable on a global level is only a
conceptual fix.  In reality, dirty pages are not distributed equally
across zones and reclaim runs into dirty pages on a regular basis.

But it is important to get this right before tackling the problem on a
per-zone level, where the distance between reclaim and the dirty pages
is mostly much smaller in absolute numbers.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 include/linux/mmzone.h |    1 +
 mm/page-writeback.c    |    8 +++++---
 mm/page_alloc.c        |    1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1ed4116..e28f8e0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -316,6 +316,7 @@ struct zone {
 	 * sysctl_lowmem_reserve_ratio sysctl changes.
 	 */
 	unsigned long		lowmem_reserve[MAX_NR_ZONES];
+	unsigned long		totalreserve_pages;
 
 #ifdef CONFIG_NUMA
 	int node;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index da6d263..9f896db 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -169,8 +169,9 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z);
+		x += zone_page_state(z, NR_FREE_PAGES) -
+			zone->totalreserve_pages;
+		x += zone_reclaimable_pages(z);
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -194,7 +195,8 @@ static unsigned long determine_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
+	x += global_reclaimable_pages();
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1dba05e..7e8e2ee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5075,6 +5075,7 @@ static void calculate_totalreserve_pages(void)
 
 			if (max > zone->present_pages)
 				max = zone->present_pages;
+			zone->totalreserve_pages = max;
 			reserve_pages += max;
 		}
 	}
-- 
1.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
