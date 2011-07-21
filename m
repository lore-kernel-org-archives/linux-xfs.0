Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LGTuJL035936 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 11:29:56 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C01F315110FB
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 09:29:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id K9bU9XB8trEbHtZl for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2011 09:29:55 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from kswapd
Date: Thu, 21 Jul 2011 17:28:50 +0100
Message-Id: <1311265730-5324-9-git-send-email-mgorman@suse.de>
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
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
To: Linux-MM <linux-mm@kvack.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>

Assuming that flusher threads will always write back dirty pages promptly
then it is always faster for reclaimers to wait for flushers. This patch
prevents kswapd writing back any filesystem pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c3d8341..6023494 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -720,7 +720,6 @@ static noinline_for_stack void free_page_list(struct list_head *free_pages)
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
 				      struct scan_control *sc,
-				      int priority,
 				      unsigned long *ret_nr_dirty)
 {
 	LIST_HEAD(ret_pages);
@@ -827,13 +826,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		if (PageDirty(page)) {
 			nr_dirty++;
 
-			/*
-			 * Only kswapd can writeback filesystem pages to
-			 * avoid risk of stack overflow but do not writeback
-			 * unless under significant pressure.
-			 */
-			if (page_is_file_cache(page) &&
-					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
+			/* Flusher must clean dirty filesystem-backed pages */
+			if (page_is_file_cache(page)) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principal to deactivate_page()
@@ -1479,14 +1473,13 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
-							priority, &nr_dirty);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, &nr_dirty);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_reclaim_mode(priority, sc, true);
 		nr_reclaimed += shrink_page_list(&page_list, zone, sc,
-							priority, &nr_dirty);
+							&nr_dirty);
 	}
 
 	local_irq_disable();
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
