Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB6F27F6D
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 09:20:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA2C8304051
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 07:20:59 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id nIi1PUu5faEygdqJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 07:20:58 -0800 (PST)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/4] mm: numa: Remove migrate_ratelimited
Date: Sat,  7 Mar 2015 15:20:49 +0000
Message-Id: <1425741651-29152-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1425741651-29152-1-git-send-email-mgorman@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linuxppc-dev@lists.ozlabs.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>

This code is dead since commit 9e645ab6d089 ("sched/numa: Continue PTE
scanning even if migrate rate limited") so remove it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/migrate.h |  5 -----
 mm/migrate.c            | 20 --------------------
 2 files changed, 25 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 78baed5f2952..cac1c0904d5f 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -69,7 +69,6 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 extern bool pmd_trans_migrating(pmd_t pmd);
 extern int migrate_misplaced_page(struct page *page,
 				  struct vm_area_struct *vma, int node);
-extern bool migrate_ratelimited(int node);
 #else
 static inline bool pmd_trans_migrating(pmd_t pmd)
 {
@@ -80,10 +79,6 @@ static inline int migrate_misplaced_page(struct page *page,
 {
 	return -EAGAIN; /* can't migrate now */
 }
-static inline bool migrate_ratelimited(int node)
-{
-	return false;
-}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_NUMA_BALANCING) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
diff --git a/mm/migrate.c b/mm/migrate.c
index 85e042686031..6aa9a4222ea9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1554,30 +1554,10 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
  * page migration rate limiting control.
  * Do not migrate more than @pages_to_migrate in a @migrate_interval_millisecs
  * window of time. Default here says do not migrate more than 1280M per second.
- * If a node is rate-limited then PTE NUMA updates are also rate-limited. However
- * as it is faults that reset the window, pte updates will happen unconditionally
- * if there has not been a fault since @pteupdate_interval_millisecs after the
- * throttle window closed.
  */
 static unsigned int migrate_interval_millisecs __read_mostly = 100;
-static unsigned int pteupdate_interval_millisecs __read_mostly = 1000;
 static unsigned int ratelimit_pages __read_mostly = 128 << (20 - PAGE_SHIFT);
 
-/* Returns true if NUMA migration is currently rate limited */
-bool migrate_ratelimited(int node)
-{
-	pg_data_t *pgdat = NODE_DATA(node);
-
-	if (time_after(jiffies, pgdat->numabalancing_migrate_next_window +
-				msecs_to_jiffies(pteupdate_interval_millisecs)))
-		return false;
-
-	if (pgdat->numabalancing_migrate_nr_pages < ratelimit_pages)
-		return false;
-
-	return true;
-}
-
 /* Returns true if the node is migrate rate-limited after the update */
 static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
 					unsigned long nr_pages)
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
