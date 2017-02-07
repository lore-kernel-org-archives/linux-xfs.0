Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54103 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbdBGRQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 12:16:19 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cb9N0-0006Xg-MJ
        for linux-xfs@vger.kernel.org; Tue, 07 Feb 2017 17:16:06 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: improve handling of busy extents in the low-level allocator
Date: Tue,  7 Feb 2017 18:14:59 +0100
Message-Id: <20170207171501.4268-4-hch@lst.de>
In-Reply-To: <20170207171501.4268-1-hch@lst.de>
References: <20170207171501.4268-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently we force the log and simply try again if we hit a busy extent,
but especially with online discard enabled it might take a while after
the log force for the busy extents to disappear, and we might have
already completed our second pass.

So instead we add a new waitqueue and a generation counter to the pag
structure so that we can do wakeups once we've removed busy extents,
and we replace the single retry with an unconditional one - after
all we hold the AGF buffer lock, so no other allocations or frees
can be racing with us in this AG.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 32 ++++++++++++++++++++++++++++----
 fs/xfs/xfs_extent_busy.h |  5 ++++-
 fs/xfs/xfs_mount.c       |  7 +++++++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 27c3ecb138e4..4d850e27095e 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -335,10 +335,11 @@ xfs_extent_busy_reuse(
  * args->minlen no suitable extent could be found, and the higher level
  * code needs to force out the log and retry the allocation.
  *
- * Return the current discard generation for the AG if the file system
- * has online discard enabled.  This value can be used to wait for
- * the trimmed extent to become fully available if the AG is running out
- * of space.
+ * Return the current busy generation for the AG if the extent is busy. This
+ * value can be used to wait for at least one of the currently busy extents
+ * to be cleared. Note that the busy list is not guaranteed to be empty after
+ * the gen is woken. The state of a specific extent must always be confirmed
+ * with another call to xfs_extent_busy_trim() before it can be used.
  */
 bool
 xfs_extent_busy_trim(
@@ -510,6 +511,7 @@ xfs_extent_busy_trim(
 		flen = fend - fbno;
 	}
 out:
+
 	if (fbno != *bno || flen != *len) {
 		trace_xfs_extent_busy_trim(args->mp, args->agno, *bno, *len,
 					  fbno, flen);
@@ -626,6 +628,28 @@ xfs_extent_busy_flush(
 	finish_wait(&pag->pagb_wait, &wait);
 }
 
+void
+xfs_extent_busy_wait_all(
+	struct xfs_mount	*mp)
+{
+	DEFINE_WAIT		(wait);
+	xfs_agnumber_t		agno;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		struct xfs_perag *pag = xfs_perag_get(mp, agno);
+
+		do {
+			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
+			if  (RB_EMPTY_ROOT(&pag->pagb_tree))
+				break;
+			schedule();
+		} while (1);
+		finish_wait(&pag->pagb_wait, &wait);
+
+		xfs_perag_put(pag);
+	}
+}
+
 /*
  * Callback for list_sort to sort busy extents by the AG they reside in.
  */
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index bcb99463cfbb..60195ea1b84a 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -64,7 +64,10 @@ xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
 
 void
 xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
-	unsigned discards);
+	unsigned busy_gen);
+
+void
+xfs_extent_busy_wait_all(struct xfs_mount *mp);
 
 int
 xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4e9feb1dc15d..e87618d47871 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -45,6 +45,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_extent_busy.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -1074,6 +1075,12 @@ xfs_unmountfs(
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/*
+	 * Wait for all busy extents to be freed, including completion of
+	 * any discard operation.
+	 */
+	xfs_extent_busy_wait_all(mp);
+
+	/*
 	 * We now need to tell the world we are unmounting. This will allow
 	 * us to detect that the filesystem is going away and we should error
 	 * out anything that we have been retrying in the background. This will
-- 
2.11.0

