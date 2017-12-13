Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43793 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX5k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:57:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNlIlt099980
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:40 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2eue5b01du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNvdfZ032329
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:39 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBDNvc8W026341
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:38 GMT
Subject: [PATCH 12/15] xfs: cross-reference the rmapbt data with the
 refcountbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:57:35 -0800
Message-ID: <151320945569.30154.15245977208615797862.stgit@magnolia>
In-Reply-To: <151320938254.30154.1046660005648421683.stgit@magnolia>
References: <151320938254.30154.1046660005648421683.stgit@magnolia>
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
 fs/xfs/scrub/refcount.c |  315 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 313 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 8add281..6efae58 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -50,6 +50,274 @@ xfs_scrub_setup_ag_refcountbt(
 
 /* Reference count btree scrubber. */
 
+/*
+ * Confirming Reference Counts via Reverse Mappings
+ *
+ * We want to count the reverse mappings overlapping a refcount record
+ * (bno, len, refcount), allowing for the possibility that some of the
+ * overlap may come from smaller adjoining reverse mappings, while some
+ * comes from single extents which overlap the range entirely.  The
+ * outer loop is as follows:
+ *
+ * 1. For all reverse mappings overlapping the refcount extent,
+ *    a. If a given rmap completely overlaps, mark it as seen.
+ *    b. Otherwise, record the fragment for later processing.
+ *
+ * Once we've seen all the rmaps, we know that for all blocks in the
+ * refcount record we want to find $refcount owners and we've already
+ * visited $seen extents that overlap all the blocks.  Therefore, we
+ * need to find ($refcount - $seen) owners for every block in the
+ * extent; call that quantity $target_nr.  Proceed as follows:
+ *
+ * 2. Pull the first $target_nr fragments from the list; all of them
+ *    should start at or before the start of the extent.
+ *    Call this subset of fragments the working set.
+ * 3. Until there are no more unprocessed fragments,
+ *    a. Find the shortest fragments in the set and remove them.
+ *    b. Note the block number of the end of these fragments.
+ *    c. Pull the same number of fragments from the list.  All of these
+ *       fragments should start at the block number recorded in the
+ *       previous step.
+ *    d. Put those fragments in the set.
+ * 4. Check that there are $target_nr fragments remaining in the list,
+ *    and that they all end at or beyond the end of the refcount extent.
+ *
+ * If the refcount is correct, all the check conditions in the algorithm
+ * should always hold true.  If not, the refcount is incorrect.
+ */
+struct xfs_scrub_refcnt_frag {
+	struct list_head		list;
+	struct xfs_rmap_irec		rm;
+};
+
+struct xfs_scrub_refcnt_check {
+	struct xfs_scrub_context	*sc;
+	struct list_head		fragments;
+
+	/* refcount extent we're examining */
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	xfs_nlink_t			refcount;
+
+	/* number of owners seen */
+	xfs_nlink_t			seen;
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
+	struct xfs_scrub_refcnt_check	*refchk = priv;
+	struct xfs_scrub_refcnt_frag	*frag;
+	xfs_agblock_t			rm_last;
+	xfs_agblock_t			rc_last;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(refchk->sc, &error))
+		return error;
+
+	rm_last = rec->rm_startblock + rec->rm_blockcount - 1;
+	rc_last = refchk->bno + refchk->len - 1;
+
+	/* Confirm that a single-owner refc extent is a CoW stage. */
+	if (refchk->refcount == 1 && rec->rm_owner != XFS_RMAP_OWN_COW) {
+		xfs_scrub_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
+	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
+		/*
+		 * The rmap overlaps the refcount record, so we can confirm
+		 * one refcount owner seen.
+		 */
+		refchk->seen++;
+	} else {
+		/*
+		 * This rmap covers only part of the refcount record, so
+		 * save the fragment for later processing.
+		 */
+		frag = kmem_alloc(sizeof(struct xfs_scrub_refcnt_frag),
+				KM_MAYFAIL | KM_NOFS);
+		if (!frag)
+			return -ENOMEM;
+		memcpy(&frag->rm, rec, sizeof(frag->rm));
+		list_add_tail(&frag->list, &refchk->fragments);
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
+	struct xfs_scrub_refcnt_check	*refchk)
+{
+	struct list_head		worklist;
+	struct xfs_scrub_refcnt_frag	*frag;
+	struct xfs_scrub_refcnt_frag	*n;
+	xfs_agblock_t			bno;
+	xfs_agblock_t			rbno;
+	xfs_agblock_t			next_rbno;
+	xfs_nlink_t			nr;
+	xfs_nlink_t			target_nr;
+
+	target_nr = refchk->refcount - refchk->seen;
+	if (target_nr == 0)
+		return;
+
+	/*
+	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
+	 * references we haven't found yet.  Pull that many off the
+	 * fragment list and figure out where the smallest rmap ends
+	 * (and therefore the next rmap should start).  All the rmaps
+	 * we pull off should start at or before the beginning of the
+	 * refcount record's range.
+	 */
+	INIT_LIST_HEAD(&worklist);
+	rbno = NULLAGBLOCK;
+	nr = 1;
+
+	/* Find all the rmaps that start at or before the refc extent. */
+	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
+		if (frag->rm.rm_startblock > refchk->bno)
+			goto done;
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
+	/*
+	 * We should have found exactly $target_nr rmap fragments starting
+	 * at or before the refcount extent.
+	 */
+	if (nr != target_nr)
+		goto done;
+
+	while (!list_empty(&refchk->fragments)) {
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
+		if (list_empty(&refchk->fragments))
+			break;
+
+		/* Try to add nr rmaps starting at rbno to the worklist. */
+		list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
+			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
+			if (frag->rm.rm_startblock != rbno)
+				goto done;
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
+	if (rbno < refchk->bno + refchk->len)
+		goto done;
+
+	/* Actually record us having seen the remaining refcount. */
+	refchk->seen = refchk->refcount;
+done:
+	/* Delete fragments and work list. */
+	list_for_each_entry_safe(frag, n, &worklist, list) {
+		list_del(&frag->list);
+		kmem_free(frag);
+	}
+	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
+		list_del(&frag->list);
+		kmem_free(frag);
+	}
+}
+
+/* Use the rmap entries covering this extent to verify the refcount. */
+STATIC void
+xfs_scrub_refcountbt_xref_rmap(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+	struct xfs_scrub_refcnt_check	refchk = {
+		.sc = sc,
+		.bno = bno,
+		.len = len,
+		.refcount = refcount,
+		.seen = 0,
+	};
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	struct xfs_scrub_refcnt_frag	*frag;
+	struct xfs_scrub_refcnt_frag	*n;
+	int				error;
+
+	if (!sc->sa.rmap_cur)
+		return;
+
+	/* Cross-reference with the rmapbt to confirm the refcount. */
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno + len - 1;
+
+	INIT_LIST_HEAD(&refchk.fragments);
+	error = xfs_rmap_query_range(sc->sa.rmap_cur, &low, &high,
+			&xfs_scrub_refcountbt_rmap_check, &refchk);
+	if (!xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+		goto out_free;
+
+	xfs_scrub_refcountbt_process_rmap_fragments(&refchk);
+	if (refcount != refchk.seen)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+
+out_free:
+	list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
+		list_del(&frag->list);
+		kmem_free(frag);
+	}
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_refcountbt_xref(
@@ -61,6 +329,7 @@ xfs_scrub_refcountbt_xref(
 	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.ino_cur, bno, len);
 	xfs_scrub_xref_not_inodes(sc, &sc->sa.fino_cur, bno, len);
+	xfs_scrub_refcountbt_xref_rmap(sc, bno, len, refcount);
 }
 
 /* Scrub a refcountbt record. */
@@ -70,6 +339,7 @@ xfs_scrub_refcountbt_rec(
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_agblock_t			*cow_blocks = bs->private;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
 	xfs_agblock_t			bno;
 	xfs_extlen_t			len;
@@ -85,6 +355,8 @@ xfs_scrub_refcountbt_rec(
 	has_cowflag = (bno & XFS_REFC_COW_START);
 	if ((refcount == 1 && !has_cowflag) || (refcount != 1 && has_cowflag))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
+	if (has_cowflag)
+		(*cow_blocks) += len;
 
 	/* Check the extent. */
 	bno &= ~XFS_REFC_COW_START;
@@ -104,14 +376,53 @@ xfs_scrub_refcountbt_rec(
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
+	if (!xfs_scrub_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
+		return;
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    blocks != refcbt_blocks)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+
+	/* Check that we saw as many cow blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_COW);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur) &&
+	    blocks != cow_blocks)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+}
+
 /* Scrub the refcount btree for some AG. */
 int
 xfs_scrub_refcountbt(
 	struct xfs_scrub_context	*sc)
 {
 	struct xfs_owner_info		oinfo;
+	xfs_agblock_t			cow_blocks = 0;
+	int				error;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
-	return xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_rec,
-			&oinfo, NULL);
+	error = xfs_scrub_btree(sc, sc->sa.refc_cur, xfs_scrub_refcountbt_rec,
+			&oinfo, &cow_blocks);
+	if (error)
+		return error;
+
+	if (sc->sa.rmap_cur)
+		xfs_scrub_refcount_xref_rmap(sc, &oinfo, cow_blocks);
+
+	return error;
 }

