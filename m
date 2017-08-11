Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50664 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdHKHLa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:30 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7BTOw032025
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BThn009784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BTVf020744
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:29 GMT
Subject: [PATCH 12/16] xfs: cross-reference the rmapbt data with the
 refcountbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:27 -0700
Message-ID: <150243548785.29473.13105228426609188631.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Cross reference the refcount data with the rmap data to check that the
number of rmaps for a given block match the refcount of that block, and
that CoW blocks (which are owned entirely by the refcountbt) are tracked
as well.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/refcount.c |  237 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 235 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f8f51e2..999820b 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -51,6 +51,165 @@ xfs_scrub_setup_ag_refcountbt(
 
 /* Reference count btree scrubber. */
 
+struct xfs_scrub_refcountbt_fragment {
+	struct list_head		list;
+	struct xfs_rmap_irec		rm;
+};
+
+struct xfs_scrub_refcountbt_rmap_check_info {
+	struct xfs_scrub_btree		*bs;
+	xfs_filblks_t			cow_blocks;
+	struct xfs_refcount_irec	rc;
+	struct list_head		fragments;
+	xfs_nlink_t			nr;
+};
+
+/*
+ * Decide if the given rmap is large enough that we can redeem it
+ * towards refcount verification now, or if it's a fragment, in
+ * which case we'll hang onto it in the hopes that we'll later
+ * discover that we've collected exactly the correct number of
+ * fragments as the refcountbt says we should have.
+ */
+STATIC int
+xfs_scrub_refcountbt_rmap_check(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci = priv;
+	struct xfs_scrub_refcountbt_fragment		*frag;
+	xfs_agblock_t			rm_last;
+	xfs_agblock_t			rc_last;
+
+	rm_last = rec->rm_startblock + rec->rm_blockcount;
+	rc_last = rsrci->rc.rc_startblock + rsrci->rc.rc_blockcount;
+	xfs_scrub_btree_xref_check_ok(rsrci->bs->sc, cur, 0,
+			rsrci->rc.rc_refcount != 1 ||
+			rec->rm_owner == XFS_RMAP_OWN_COW);
+	if (rec->rm_startblock <= rsrci->rc.rc_startblock &&
+	    rm_last >= rc_last) {
+		rsrci->nr++;
+	} else {
+		frag = kmem_alloc(sizeof(struct xfs_scrub_refcountbt_fragment),
+				KM_MAYFAIL | KM_NOFS);
+		if (!frag)
+			return -ENOMEM;
+		frag->rm = *rec;
+		list_add_tail(&frag->list, &rsrci->fragments);
+	}
+
+	return 0;
+}
+
+/*
+ * Given a bunch of rmap fragments, iterate through them, keeping
+ * a running tally of the refcount.  If this ever deviates from
+ * what we expect (which is the refcountbt's refcount minus the
+ * number of extents that totally covered the refcountbt extent),
+ * we have a refcountbt error.
+ */
+STATIC void
+xfs_scrub_refcountbt_process_rmap_fragments(
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci)
+{
+	struct list_head				worklist;
+	struct xfs_scrub_refcountbt_fragment		*frag;
+	struct xfs_scrub_refcountbt_fragment		*n;
+	xfs_agblock_t					bno;
+	xfs_agblock_t					rbno;
+	xfs_agblock_t					next_rbno;
+	xfs_nlink_t					nr;
+	xfs_nlink_t					target_nr;
+
+	target_nr = rsrci->rc.rc_refcount - rsrci->nr;
+	if (target_nr == 0)
+		return;
+
+	/*
+	 * There are (rsrci->rc.rc_refcount - rsrci->nr refcount)
+	 * references we haven't found yet.  Pull that many off the
+	 * fragment list and figure out where the smallest rmap ends
+	 * (and therefore the next rmap should start).  All the rmaps
+	 * we pull off should start at or before the beginning of the
+	 * refcount record's range.
+	 */
+	INIT_LIST_HEAD(&worklist);
+	rbno = NULLAGBLOCK;
+	nr = 1;
+	list_for_each_entry_safe(frag, n, &rsrci->fragments, list) {
+		if (frag->rm.rm_startblock > rsrci->rc.rc_startblock)
+			goto fail;
+		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+		if (rbno > bno)
+			rbno = bno;
+		list_del(&frag->list);
+		list_add_tail(&frag->list, &worklist);
+		if (nr == target_nr)
+			break;
+		nr++;
+	}
+
+	if (nr != target_nr)
+		goto fail;
+
+	while (!list_empty(&rsrci->fragments)) {
+		/* Discard any fragments ending at rbno. */
+		nr = 0;
+		next_rbno = NULLAGBLOCK;
+		list_for_each_entry_safe(frag, n, &worklist, list) {
+			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+			if (bno != rbno) {
+				if (next_rbno > bno)
+					next_rbno = bno;
+				continue;
+			}
+			list_del(&frag->list);
+			kmem_free(frag);
+			nr++;
+		}
+
+		/* Empty list?  We're done. */
+		if (list_empty(&rsrci->fragments))
+			break;
+
+		/* Try to add nr rmaps starting at rbno to the worklist. */
+		list_for_each_entry_safe(frag, n, &rsrci->fragments, list) {
+			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+			if (frag->rm.rm_startblock != rbno)
+				goto fail;
+			list_del(&frag->list);
+			list_add_tail(&frag->list, &worklist);
+			if (next_rbno > bno)
+				next_rbno = bno;
+			nr--;
+			if (nr == 0)
+				break;
+		}
+
+		rbno = next_rbno;
+	}
+
+	/*
+	 * Make sure the last extent we processed ends at or beyond
+	 * the end of the refcount extent.
+	 */
+	if (rbno < rsrci->rc.rc_startblock + rsrci->rc.rc_blockcount)
+		goto fail;
+
+	rsrci->nr = rsrci->rc.rc_refcount;
+fail:
+	/* Delete fragments and work list. */
+	list_for_each_entry_safe(frag, n, &worklist, list) {
+		list_del(&frag->list);
+		kmem_free(frag);
+	}
+	list_for_each_entry_safe(frag, n, &rsrci->fragments, list) {
+		list_del(&frag->list);
+		kmem_free(frag);
+	}
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xfs_scrub_refcountbt_helper(
@@ -61,6 +220,11 @@ xfs_scrub_refcountbt_helper(
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
 	struct xfs_refcount_irec	irec;
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci = bs->private;
+	struct xfs_scrub_refcountbt_fragment		*frag;
+	struct xfs_scrub_refcountbt_fragment		*n;
 	unsigned long long		rec_end;
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
@@ -75,6 +239,8 @@ xfs_scrub_refcountbt_helper(
 	eoag = be32_to_cpu(agf->agf_length);
 
 	has_cowflag = !!(irec.rc_startblock & XFS_REFC_COW_START);
+	if (has_cowflag)
+		rsrci->cow_blocks += irec.rc_blockcount;
 	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
 			(irec.rc_refcount == 1 && has_cowflag) ||
 			(irec.rc_refcount != 1 && !has_cowflag));
@@ -123,17 +289,84 @@ xfs_scrub_refcountbt_helper(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt to confirm the refcount. */
+	if (psa->rmap_cur) {
+		memset(&low, 0, sizeof(low));
+		low.rm_startblock = irec.rc_startblock;
+		memset(&high, 0xFF, sizeof(high));
+		high.rm_startblock = irec.rc_startblock +
+				irec.rc_blockcount - 1;
+
+		rsrci->bs = bs;
+		rsrci->nr = 0;
+		rsrci->rc = irec;
+		ASSERT(list_empty(&rsrci->fragments));
+		error = xfs_rmap_query_range(psa->rmap_cur, &low, &high,
+				&xfs_scrub_refcountbt_rmap_check, rsrci);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->rmap_cur)) {
+			xfs_scrub_refcountbt_process_rmap_fragments(rsrci);
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->rmap_cur, 0,
+					irec.rc_refcount == rsrci->nr);
+		}
+
+		list_for_each_entry_safe(frag, n, &rsrci->fragments, list) {
+			list_del(&frag->list);
+			kmem_free(frag);
+		}
+	}
+
 	return error;
 }
 
+/* Make sure we have as many refc blocks as the rmap says. */
+STATIC void
+xfs_scrub_refcount_xref_rmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	xfs_filblks_t			cow_blocks)
+{
+	xfs_extlen_t			refcbt_blocks = 0;
+	xfs_filblks_t			blocks;
+	int				error;
+
+	/* Check that we saw as many refcbt blocks as the rmap knows about. */
+	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
+	if (!xfs_scrub_btree_op_ok(sc, sc->sa.refc_cur, 0, &error))
+		return;
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+		xfs_scrub_btree_xref_check_ok(sc, sc->sa.rmap_cur, 0,
+				blocks == refcbt_blocks);
+
+	/* Check that we saw as many cow blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_COW);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+		xfs_scrub_btree_xref_check_ok(sc, sc->sa.rmap_cur, 0,
+				blocks == cow_blocks);
+}
+
 /* Scrub the refcount btree for some AG. */
 int
 xfs_scrub_refcountbt(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
+	struct xfs_scrub_refcountbt_rmap_check_info rsrci;
+	int				error;
 
+	INIT_LIST_HEAD(&rsrci.fragments);
+	rsrci.cow_blocks = 0;
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
-	return xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_helper,
-			&oinfo, NULL);
+	error = xfs_scrub_btree(sc, sc->sa.refc_cur,
+			xfs_scrub_refcountbt_helper, &oinfo, &rsrci);
+	if (error)
+		return error;
+
+	if (sc->sa.rmap_cur)
+		xfs_scrub_refcount_xref_rmap(sc, &oinfo, rsrci.cow_blocks);
+
+	return error;
 }

