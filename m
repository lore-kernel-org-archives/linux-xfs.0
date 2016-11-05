Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51193 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcKEAII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:08 -0400
Subject: [PATCH 01/16] xfs_repair: fix some potential null pointer deferences
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:08:03 -0700
Message-ID: <147830448375.26713.12061252375252670165.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Fix some potential NULL pointer deferences that Coverity pointed out,
and remove a trivial dead integer check.

Coverity-id: 1375789, 1375790, 1375791, 1375792
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    2 +-
 repair/rmap.c   |    2 +-
 repair/slab.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 3604d1d..cbda556 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1925,7 +1925,7 @@ _("Insufficient memory to construct refcount cursor."));
 	refc_rec = pop_slab_cursor(refc_cur);
 	lptr = &btree_curs->level[0];
 
-	for (i = 0; i < lptr->num_blocks; i++)  {
+	for (i = 0; i < lptr->num_blocks && refc_rec != NULL; i++)  {
 		/*
 		 * block initialization, lay in block header
 		 */
diff --git a/repair/rmap.c b/repair/rmap.c
index 45e183a..7508973 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -790,7 +790,7 @@ compute_refcounts(
 		mark_inode_rl(mp, stack_top);
 
 		/* Set nbno to the bno of the next refcount change */
-		if (n < slab_count(rmaps))
+		if (n < slab_count(rmaps) && array_cur)
 			nbno = array_cur->rm_startblock;
 		else
 			nbno = NULLAGBLOCK;
diff --git a/repair/slab.h b/repair/slab.h
index 4aa5512..a2201f1 100644
--- a/repair/slab.h
+++ b/repair/slab.h
@@ -54,7 +54,7 @@ extern void *bag_item(struct xfs_bag *, size_t);
 
 #define foreach_bag_ptr_reverse(bag, idx, ptr) \
 	for ((idx) = bag_count(bag) - 1, (ptr) = bag_item((bag), (idx)); \
-	     (idx) >= 0 && (ptr) != NULL; \
+	     (ptr) != NULL; \
 	     (idx)--, (ptr) = bag_item((bag), (idx)))
 
 #endif /* SLAB_H_ */

