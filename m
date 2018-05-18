Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbeERDwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 23:52:00 -0400
Date: Thu, 17 May 2018 20:51:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 03/22] xfs: add helpers to collect and sift btree block
 pointers during repair
Message-ID: <20180518035155.GZ23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363794.1556.12771807615463619233.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642363794.1556.12771807615463619233.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some helpers to assemble a list of fs block extents.  Generally,
repair functions will iterate the rmapbt to make a list (1) of all
extents owned by the nominal owner of the metadata structure; then they
will iterate all other structures with the same rmap owner to make a
list (2) of active blocks; and finally we have a subtraction function to
subtract all the blocks in (2) from (1), with the result that (1) is now
a list of blocks that were owned by the old btree and must be disposed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: document the design of how repair functions are supposed to work,
    implement review comments
---
 fs/xfs/scrub/repair.c |  217 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   28 ++++++
 2 files changed, 245 insertions(+)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index be21a2984001..fca8e3c7887d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -368,3 +368,220 @@ xfs_repair_init_btblock(
 
 	return 0;
 }
+
+/*
+ * Reconstructing per-AG Btrees
+ *
+ * When a space btree is corrupt, we don't bother trying to fix it.  Instead,
+ * we scan secondary space metadata to derive the records that should be in
+ * the damaged btree, initialize a fresh btree root, and insert the records.
+ * Note that for rebuilding the rmapbt we scan all the primary data to
+ * generate the new records.
+ *
+ * However, that leaves the matter of removing all the metadata describing the
+ * old broken structure.  For primary metadata we use the rmap data to collect
+ * every extent with a matching rmap owner (exlist); we then iterate all other
+ * metadata structures with the same rmap owner to collect the extents that
+ * cannot be removed (sublist).  We then subtract sublist from exlist to
+ * derive the blocks that were used by the old btree.  These blocks can be
+ * reaped.
+ *
+ * For rmapbt reconstructions we must use different tactics for extent
+ * collection.  First we iterate all primary metadata (this excludes the old
+ * rmapbt, obviously) to generate new rmap records.  The gaps in the rmap
+ * records are collected as exlist.  The bnobt records are collected as
+ * sublist.  As with the other btrees we subtract sublist from exlist, and the
+ * result (since the rmapbt lives in the free space) are the blocks from the
+ * old rmapbt.
+ */
+
+/* Collect a dead btree extent for later disposal. */
+int
+xfs_repair_collect_btree_extent(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len)
+{
+	struct xfs_repair_extent	*rex;
+
+	trace_xfs_repair_collect_btree_extent(sc->mp,
+			XFS_FSB_TO_AGNO(sc->mp, fsbno),
+			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
+
+	rex = kmem_alloc(sizeof(struct xfs_repair_extent), KM_MAYFAIL);
+	if (!rex)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&rex->list);
+	rex->fsbno = fsbno;
+	rex->len = len;
+	list_add_tail(&rex->list, &exlist->list);
+
+	return 0;
+}
+
+/*
+ * An error happened during the rebuild so the transaction will be cancelled.
+ * The fs will shut down, and the administrator has to unmount and run repair.
+ * Therefore, free all the memory associated with the list so we can die.
+ */
+void
+xfs_repair_cancel_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist)
+{
+	struct xfs_repair_extent	*rex;
+	struct xfs_repair_extent	*n;
+
+	for_each_xfs_repair_extent_safe(rex, n, exlist) {
+		list_del(&rex->list);
+		kmem_free(rex);
+	}
+}
+
+/* Compare two btree extents. */
+static int
+xfs_repair_btree_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_extent	*ap;
+	struct xfs_repair_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_extent, list);
+	bp = container_of(b, struct xfs_repair_extent, list);
+
+	if (ap->fsbno > bp->fsbno)
+		return 1;
+	if (ap->fsbno < bp->fsbno)
+		return -1;
+	return 0;
+}
+
+/*
+ * Remove all the blocks mentioned in @sublist from the extents in @exlist.
+ *
+ * The intent is that callers will iterate the rmapbt for all of its records
+ * for a given owner to generate @exlist; and iterate all the blocks of the
+ * metadata structures that are not being rebuilt and have the same rmapbt
+ * owner to generate @sublist.  This routine subtracts all the extents
+ * mentioned in sublist from all the extents linked in @exlist, which leaves
+ * @exlist as the list of blocks that are not accounted for, which we assume
+ * are the dead blocks of the old metadata structure.  The blocks mentioned in
+ * @exlist can be reaped.
+ */
+#define LEFT_ALIGNED	(1 << 0)
+#define RIGHT_ALIGNED	(1 << 1)
+int
+xfs_repair_subtract_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	struct xfs_repair_extent_list	*sublist)
+{
+	struct list_head		*lp;
+	struct xfs_repair_extent	*ex;
+	struct xfs_repair_extent	*newex;
+	struct xfs_repair_extent	*subex;
+	xfs_fsblock_t			sub_fsb;
+	xfs_extlen_t			sub_len;
+	int				state;
+	int				error = 0;
+
+	if (list_empty(&exlist->list) || list_empty(&sublist->list))
+		return 0;
+	ASSERT(!list_empty(&sublist->list));
+
+	list_sort(NULL, &exlist->list, xfs_repair_btree_extent_cmp);
+	list_sort(NULL, &sublist->list, xfs_repair_btree_extent_cmp);
+
+	/*
+	 * Now that we've sorted both lists, we iterate exlist once, rolling
+	 * forward through sublist and/or exlist as necessary until we find an
+	 * overlap or reach the end of either list.  We do not reset lp to the
+	 * head of exlist nor do we reset subex to the head of sublist.  The
+	 * list traversal is similar to merge sort, but we're deleting
+	 * instead.  In this manner we avoid O(n^2) operations.
+	 */
+	subex = list_first_entry(&sublist->list, struct xfs_repair_extent,
+			list);
+	lp = exlist->list.next;
+	while (lp != &exlist->list) {
+		ex = list_entry(lp, struct xfs_repair_extent, list);
+
+		/*
+		 * Advance subex and/or ex until we find a pair that
+		 * intersect or we run out of extents.
+		 */
+		while (subex->fsbno + subex->len <= ex->fsbno) {
+			if (list_is_last(&subex->list, &sublist->list))
+				goto out;
+			subex = list_next_entry(subex, list);
+		}
+		if (subex->fsbno >= ex->fsbno + ex->len) {
+			lp = lp->next;
+			continue;
+		}
+
+		/* trim subex to fit the extent we have */
+		sub_fsb = subex->fsbno;
+		sub_len = subex->len;
+		if (subex->fsbno < ex->fsbno) {
+			sub_len -= ex->fsbno - subex->fsbno;
+			sub_fsb = ex->fsbno;
+		}
+		if (sub_len > ex->len)
+			sub_len = ex->len;
+
+		state = 0;
+		if (sub_fsb == ex->fsbno)
+			state |= LEFT_ALIGNED;
+		if (sub_fsb + sub_len == ex->fsbno + ex->len)
+			state |= RIGHT_ALIGNED;
+		switch (state) {
+		case LEFT_ALIGNED:
+			/* Coincides with only the left. */
+			ex->fsbno += sub_len;
+			ex->len -= sub_len;
+			break;
+		case RIGHT_ALIGNED:
+			/* Coincides with only the right. */
+			ex->len -= sub_len;
+			lp = lp->next;
+			break;
+		case LEFT_ALIGNED | RIGHT_ALIGNED:
+			/* Total overlap, just delete ex. */
+			lp = lp->next;
+			list_del(&ex->list);
+			kmem_free(ex);
+			break;
+		case 0:
+			/*
+			 * Deleting from the middle: add the new right extent
+			 * and then shrink the left extent.
+			 */
+			newex = kmem_alloc(sizeof(struct xfs_repair_extent),
+					KM_MAYFAIL);
+			if (!newex) {
+				error = -ENOMEM;
+				goto out;
+			}
+			INIT_LIST_HEAD(&newex->list);
+			newex->fsbno = sub_fsb + sub_len;
+			newex->len = ex->fsbno + ex->len - newex->fsbno;
+			list_add(&newex->list, &ex->list);
+			ex->len = sub_fsb - ex->fsbno;
+			lp = lp->next;
+			break;
+		default:
+			ASSERT(0);
+			break;
+		}
+	}
+
+out:
+	return error;
+}
+#undef LEFT_ALIGNED
+#undef RIGHT_ALIGNED
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 40990fa5f381..ba1fdd7b9a79 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -43,6 +43,34 @@ int xfs_repair_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
 
+struct xfs_repair_extent {
+	struct list_head		list;
+	xfs_fsblock_t			fsbno;
+	xfs_extlen_t			len;
+};
+
+struct xfs_repair_extent_list {
+	struct list_head		list;
+};
+
+static inline void
+xfs_repair_init_extent_list(
+	struct xfs_repair_extent_list	*exlist)
+{
+	INIT_LIST_HEAD(&exlist->list);
+}
+
+#define for_each_xfs_repair_extent_safe(rbe, n, exlist) \
+	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
+int xfs_repair_collect_btree_extent(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist, xfs_fsblock_t fsbno,
+		xfs_extlen_t len);
+void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist);
+int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *exlist,
+		struct xfs_repair_extent_list *sublist);
+
 /* Metadata repairers */
 
 int xfs_repair_probe(struct xfs_scrub_context *sc);
