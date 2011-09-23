Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NEfiTL110642 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 09:41:45 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0D8C1413559
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 07:47:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QjcxY9vC4xZIXmDF for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2011 07:47:19 -0700 (PDT)
Date: Fri, 23 Sep 2011 16:41:07 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: [patch 1/2/4] mm: writeback: cleanups in preparation for per-zone
	dirty limits
Message-ID: <20110923144107.GB2606@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-3-git-send-email-jweiner@redhat.com>
	<20110921160226.1bf74494.akpm@google.com>
	<20110922085242.GA29046@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110922085242.GA29046@redhat.com>
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
To: Andrew Morton <akpm@google.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>, Minchan Kim <minchan.kim@gmail.com>

On Thu, Sep 22, 2011 at 10:52:42AM +0200, Johannes Weiner wrote:
> On Wed, Sep 21, 2011 at 04:02:26PM -0700, Andrew Morton wrote:
> > Should we rename determine_dirtyable_memory() to
> > global_dirtyable_memory(), to get some sense of its relationship with
> > zone_dirtyable_memory()?
> 
> Sounds good.

---

The next patch will introduce per-zone dirty limiting functions in
addition to the traditional global dirty limiting.

Rename determine_dirtyable_memory() to global_dirtyable_memory()
before adding the zone-specific version, and fix up its documentation.

Also, move the functions to determine the dirtyable memory and the
function to calculate the dirty limit based on that together so that
their relationship is more apparent and that they can be commented on
as a group.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/page-writeback.c |   92 +++++++++++++++++++++++++-------------------------
 1 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c8acf8a..78604a6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -186,12 +186,12 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 }
 
 /**
- * determine_dirtyable_memory - amount of memory that may be used
+ * global_dirtyable_memory - number of globally dirtyable pages
  *
- * Returns the numebr of pages that can currently be freed and used
- * by the kernel for direct mappings.
+ * Returns the global number of pages potentially available for dirty
+ * page cache.  This is the base value for the global dirty limits.
  */
-static unsigned long determine_dirtyable_memory(void)
+static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
@@ -205,6 +205,47 @@ static unsigned long determine_dirtyable_memory(void)
 }
 
 /*
+ * global_dirty_limits - background-writeback and dirty-throttling thresholds
+ *
+ * Calculate the dirty thresholds based on sysctl parameters
+ * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
+ * - vm.dirty_ratio             or  vm.dirty_bytes
+ * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
+ * real-time tasks.
+ */
+void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
+{
+	unsigned long background;
+	unsigned long dirty;
+	unsigned long uninitialized_var(available_memory);
+	struct task_struct *tsk;
+
+	if (!vm_dirty_bytes || !dirty_background_bytes)
+		available_memory = global_dirtyable_memory();
+
+	if (vm_dirty_bytes)
+		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
+	else
+		dirty = (vm_dirty_ratio * available_memory) / 100;
+
+	if (dirty_background_bytes)
+		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
+	else
+		background = (dirty_background_ratio * available_memory) / 100;
+
+	if (background >= dirty)
+		background = dirty / 2;
+	tsk = current;
+	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
+		background += background / 4;
+		dirty += dirty / 4;
+	}
+	*pbackground = background;
+	*pdirty = dirty;
+	trace_global_dirty_state(background, dirty);
+}
+
+/*
  * couple the period to the dirty_ratio:
  *
  *   period/2 ~ roundup_pow_of_two(dirty limit)
@@ -216,7 +257,7 @@ static int calc_period_shift(void)
 	if (vm_dirty_bytes)
 		dirty_total = vm_dirty_bytes / PAGE_SIZE;
 	else
-		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
+		dirty_total = (vm_dirty_ratio * global_dirtyable_memory()) /
 				100;
 	return 2 + ilog2(dirty_total - 1);
 }
@@ -416,47 +457,6 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
 	return max(thresh, global_dirty_limit);
 }
 
-/*
- * global_dirty_limits - background-writeback and dirty-throttling thresholds
- *
- * Calculate the dirty thresholds based on sysctl parameters
- * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
- * - vm.dirty_ratio             or  vm.dirty_bytes
- * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
- * real-time tasks.
- */
-void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
-{
-	unsigned long background;
-	unsigned long dirty;
-	unsigned long uninitialized_var(available_memory);
-	struct task_struct *tsk;
-
-	if (!vm_dirty_bytes || !dirty_background_bytes)
-		available_memory = determine_dirtyable_memory();
-
-	if (vm_dirty_bytes)
-		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
-	else
-		dirty = (vm_dirty_ratio * available_memory) / 100;
-
-	if (dirty_background_bytes)
-		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
-	else
-		background = (dirty_background_ratio * available_memory) / 100;
-
-	if (background >= dirty)
-		background = dirty / 2;
-	tsk = current;
-	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
-		background += background / 4;
-		dirty += dirty / 4;
-	}
-	*pbackground = background;
-	*pdirty = dirty;
-	trace_global_dirty_state(background, dirty);
-}
-
 /**
  * bdi_dirty_limit - @bdi's share of dirty throttling threshold
  * @bdi: the backing_dev_info to query
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
