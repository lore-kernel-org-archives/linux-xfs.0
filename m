Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AAlR1t181028 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:47:27 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECEA53774F2
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 03:48:53 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id o8oKLYQQdFCdYzsc for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 03:48:53 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/7] mm: vmscan: Remove dead code related to lumpy reclaim
	waiting on pages under writeback
Date: Wed, 10 Aug 2011 11:47:15 +0100
Message-Id: <1312973240-32576-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-1-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
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

Lumpy reclaim worked with two passes - the first which queued pages for
IO and the second which waited on writeback. As direct reclaim can no
longer write pages there is some dead code. This patch removes it but
direct reclaim will continue to wait on pages under writeback while in
synchronous reclaim mode.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1522b0f..7863f8e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -455,15 +455,6 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 			return PAGE_ACTIVATE;
 		}
 
-		/*
-		 * Wait on writeback if requested to. This happens when
-		 * direct reclaiming a large contiguous area and the
-		 * first attempt to free a range of pages fails.
-		 */
-		if (PageWriteback(page) &&
-		    (sc->reclaim_mode & RECLAIM_MODE_SYNC))
-			wait_on_page_writeback(page);
-
 		if (!PageWriteback(page)) {
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
@@ -764,12 +755,10 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 
 		if (PageWriteback(page)) {
 			/*
-			 * Synchronous reclaim is performed in two passes,
-			 * first an asynchronous pass over the list to
-			 * start parallel writeback, and a second synchronous
-			 * pass to wait for the IO to complete.  Wait here
-			 * for any page for which writeback has already
-			 * started.
+			 * Synchronous reclaim cannot queue pages for
+			 * writeback due to the possibility of stack overflow
+			 * but if it encounters a page under writeback, wait
+			 * for the IO to complete.
 			 */
 			if ((sc->reclaim_mode & RECLAIM_MODE_SYNC) &&
 			    may_enter_fs)
@@ -1363,7 +1352,7 @@ static noinline_for_stack void update_isolated_counts(struct zone *zone,
 }
 
 /*
- * Returns true if the caller should wait to clean dirty/writeback pages.
+ * Returns true if a direct reclaim should wait on pages under writeback.
  *
  * If we are direct reclaiming for contiguous pages and we do not reclaim
  * everything in the list, try again and wait for writeback IO to complete.
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
