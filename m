Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fQZS100592
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:24 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8jv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gNuI010056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:23 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2gNn6031462
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:42:23 GMT
Subject: [PATCH 05/24] xfs: add helpers to collect and sift btree block
 pointers during repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:42:22 -0700
Message-ID: <152401934228.12079.1946503577760049470.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
 fs/xfs/scrub/repair.c |  207 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   31 +++++++
 2 files changed, 238 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 01b9ee5..4d8fd33 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -355,3 +355,210 @@ xfs_repair_init_btblock(
 
 	return 0;
 }
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
+ * Dispose of btree blocks from the old btree so that we can start using the
+ * new btree once the transaction commits.
+ */
+int
+xfs_repair_reap_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_extent_list	*exlist,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		type)
+{
+	struct xfs_repair_extent	*rex;
+	struct xfs_repair_extent	*n;
+	int				error = 0;
+
+	for_each_xfs_repair_extent_safe(rex, n, exlist) {
+		/* TODO: free the extent */
+		list_del(&rex->list);
+		kmem_free(rex);
+	}
+
+	return error;
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
+	else if (ap->fsbno < bp->fsbno)
+		return -1;
+	return 0;
+}
+
+/*
+ * Remove all the blocks mentioned in sublist from the extents in exlist.
+ *
+ * The intent is that callers will iterate the rmapbt for all of its records
+ * for a given owner to generate exlist; and iterate all the blocks of the
+ * metadata structures that are not being rebuilt and have the same rmapbt
+ * owner to generate sublist.  This routine subtracts all the extents
+ * mentioned in sublist from all the extents linked in exlist, which leaves
+ * exlist as the list of blocks that are not accounted for, which we assume
+ * are the dead blocks of the old metadata structure.  The blocks mentioned in
+ * exlist can be reaped.
+ */
+#define XFS_REPAIR_EXT_LEFT_CONTIG	(1 << 0)
+#define XFS_REPAIR_EXT_RIGHT_CONTIG	(1 << 1)
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
+			state |= XFS_REPAIR_EXT_LEFT_CONTIG;
+		if (sub_fsb + sub_len == ex->fsbno + ex->len)
+			state |= XFS_REPAIR_EXT_RIGHT_CONTIG;
+		switch (state) {
+		case XFS_REPAIR_EXT_LEFT_CONTIG:
+			/* Coincides with only the left. */
+			ex->fsbno += sub_len;
+			ex->len -= sub_len;
+			break;
+		case XFS_REPAIR_EXT_RIGHT_CONTIG:
+			/* Coincides with only the right. */
+			ex->len -= sub_len;
+			lp = lp->next;
+			break;
+		case XFS_REPAIR_EXT_LEFT_CONTIG | XFS_REPAIR_EXT_RIGHT_CONTIG:
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
+			newex->len = ex->len - (sub_fsb - ex->fsbno) - sub_len;
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
+#undef XFS_REPAIR_EXT_LEFT_CONTIG
+#undef XFS_REPAIR_EXT_RIGHT_CONTIG
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 40990fa..b288201 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -43,6 +43,37 @@ int xfs_repair_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
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
+int xfs_repair_reap_btree_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist,
+		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
+void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *btlist);
+int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
+		struct xfs_repair_extent_list *exlist,
+		struct xfs_repair_extent_list *sublist);
+
 /* Metadata repairers */
 
 int xfs_repair_probe(struct xfs_scrub_context *sc);

