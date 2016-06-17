Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 453147EFB
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14FBD304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:45 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6m8DIrxbdoDBtBJ8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:42 -0700 (PDT)
Subject: [PATCH 118/119] xfs: support scrubbing refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:35 -0700
Message-ID: <146612703518.12839.12399566032000681767.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Plumb in the pieces necessary to check the refcount btree.  If rmap is
available, check the reference count by performing an interval query
against the rmapbt.

v2: Handle the case where the rmap records are not all at least the
length of the refcount extent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c       |  224 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   16 ++-
 fs/xfs/xfs_scrub_sysfs.c           |    2 
 4 files changed, 240 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index e8d8702..126dd57 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -37,6 +37,7 @@
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_scrub.h"
 
 /* Allowable refcount adjustment amounts. */
 enum xfs_refc_adjust_op {
@@ -1578,3 +1579,226 @@ xfs_refcount_free_cow_extent(
 
 	return __xfs_refcount_add(mp, dfops, &ri);
 }
+
+struct xfs_refcountbt_scrub_fragment {
+	struct xfs_rmap_irec		rm;
+	struct list_head		list;
+};
+
+struct xfs_refcountbt_scrub_rmap_check_info {
+	xfs_nlink_t			nr;
+	struct xfs_refcount_irec	rc;
+	struct list_head		fragments;
+};
+
+static int
+xfs_refcountbt_scrub_rmap_check(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_refcountbt_scrub_rmap_check_info	*rsrci = priv;
+	struct xfs_refcountbt_scrub_fragment		*frag;
+	xfs_agblock_t			rm_last;
+	xfs_agblock_t			rc_last;
+
+	rm_last = rec->rm_startblock + rec->rm_blockcount;
+	rc_last = rsrci->rc.rc_startblock + rsrci->rc.rc_blockcount;
+	if (rec->rm_startblock <= rsrci->rc.rc_startblock && rm_last >= rc_last)
+		rsrci->nr++;
+	else {
+		frag = kmem_zalloc(sizeof(struct xfs_refcountbt_scrub_fragment),
+				KM_SLEEP);
+		frag->rm = *rec;
+		list_add_tail(&frag->list, &rsrci->fragments);
+	}
+
+	return 0;
+}
+
+STATIC void
+xfs_refcountbt_process_rmap_fragments(
+	struct xfs_mount				*mp,
+	struct xfs_refcountbt_scrub_rmap_check_info	*rsrci)
+{
+	struct list_head				worklist;
+	struct xfs_refcountbt_scrub_fragment		*cur;
+	struct xfs_refcountbt_scrub_fragment		*n;
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
+	list_for_each_entry_safe(cur, n, &rsrci->fragments, list) {
+		if (cur->rm.rm_startblock > rsrci->rc.rc_startblock)
+			goto fail;
+		bno = cur->rm.rm_startblock + cur->rm.rm_blockcount;
+		if (rbno > bno)
+			rbno = bno;
+		list_del(&cur->list);
+		list_add_tail(&cur->list, &worklist);
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
+		list_for_each_entry_safe(cur, n, &worklist, list) {
+			bno = cur->rm.rm_startblock + cur->rm.rm_blockcount;
+			if (bno != rbno) {
+				if (next_rbno > bno)
+					next_rbno = bno;
+				continue;
+			}
+			list_del(&cur->list);
+			kmem_free(cur);
+			nr++;
+		}
+
+		/* Empty list?  We're done. */
+		if (list_empty(&rsrci->fragments))
+			break;
+
+		/* Try to add nr rmaps starting at rbno to the worklist. */
+		list_for_each_entry_safe(cur, n, &rsrci->fragments, list) {
+			bno = cur->rm.rm_startblock + cur->rm.rm_blockcount;
+			if (cur->rm.rm_startblock != rbno)
+				goto fail;
+			list_del(&cur->list);
+			list_add_tail(&cur->list, &worklist);
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
+	while (!list_empty(&worklist)) {
+		cur = list_first_entry(&worklist,
+				struct xfs_refcountbt_scrub_fragment, list);
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+	while (!list_empty(&rsrci->fragments)) {
+		cur = list_first_entry(&rsrci->fragments,
+				struct xfs_refcountbt_scrub_fragment, list);
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+}
+
+STATIC int
+xfs_refcountbt_scrub_helper(
+	struct xfs_btree_scrub		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	struct xfs_refcount_irec	irec;
+	struct xfs_refcountbt_scrub_rmap_check_info	rsrci;
+	struct xfs_refcountbt_scrub_fragment		*cur;
+	int				error;
+
+	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+	irec.rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
+	irec.rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_startblock < mp->m_sb.sb_agblocks);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_startblock < irec.rc_startblock +
+			irec.rc_blockcount);
+	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)irec.rc_startblock +
+			irec.rc_blockcount <= mp->m_sb.sb_agblocks);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount >= 1);
+
+	/* confirm the refcount */
+	if (!bs->rmap_cur)
+		return 0;
+
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = irec.rc_startblock;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = irec.rc_startblock + irec.rc_blockcount - 1;
+
+	rsrci.nr = 0;
+	rsrci.rc = irec;
+	INIT_LIST_HEAD(&rsrci.fragments);
+	error = xfs_rmapbt_query_range(bs->rmap_cur, &low, &high,
+			&xfs_refcountbt_scrub_rmap_check, &rsrci);
+	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
+		goto err;
+	error = 0;
+	xfs_refcountbt_process_rmap_fragments(mp, &rsrci);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount == rsrci.nr);
+
+err:
+	while (!list_empty(&rsrci.fragments)) {
+		cur = list_first_entry(&rsrci.fragments,
+				struct xfs_refcountbt_scrub_fragment, list);
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+	return error;
+}
+
+/* Scrub the refcount btree for some AG. */
+int
+xfs_refcountbt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_scrub	bs;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &bs.agf_bp);
+	if (error)
+		return error;
+
+	bs.cur = xfs_refcountbt_init_cursor(mp, NULL, bs.agf_bp, agno, NULL);
+	bs.scrub_rec = xfs_refcountbt_scrub_helper;
+	xfs_rmap_ag_owner(&bs.oinfo, XFS_RMAP_OWN_REFC);
+	error = xfs_btree_scrub(&bs);
+	xfs_btree_del_cursor(bs.cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(NULL, bs.agf_bp);
+
+	if (!error && bs.error)
+		error = bs.error;
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 44b0346..d2317f1 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -68,4 +68,6 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
 		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
 		xfs_extlen_t len);
 
+extern int xfs_refcountbt_scrub(struct xfs_mount *mp, xfs_agnumber_t agno);
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index abf1ebf..c5d2942 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -197,6 +197,16 @@ xfs_refcountbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
 }
 
+STATIC __int64_t
+xfs_refcountbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k2->refc.rc_startblock) -
+			  be32_to_cpu(k1->refc.rc_startblock);
+}
+
 STATIC bool
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
@@ -259,7 +269,6 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_write		= xfs_refcountbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_refcountbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -288,13 +297,13 @@ xfs_refcountbt_recs_inorder(
 		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
 		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
 		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
+		a = a; b = b;
 		trace_xfs_refcount_rec_order_error(cur->bc_mp,
 				cur->bc_private.a.agno, &a, &b);
 	}
 
 	return ret;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
@@ -311,10 +320,9 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_scrub_sysfs.c b/fs/xfs/xfs_scrub_sysfs.c
index c2256f3..ad51e05 100644
--- a/fs/xfs/xfs_scrub_sysfs.c
+++ b/fs/xfs/xfs_scrub_sysfs.c
@@ -179,6 +179,7 @@ XFS_AGDATA_SCRUB_ATTR(cntbt, NULL);
 XFS_AGDATA_SCRUB_ATTR(inobt, NULL);
 XFS_AGDATA_SCRUB_ATTR(finobt, xfs_sb_version_hasfinobt);
 XFS_AGDATA_SCRUB_ATTR(rmapbt, xfs_sb_version_hasrmapbt);
+XFS_AGDATA_SCRUB_ATTR(refcountbt, xfs_sb_version_hasreflink);
 
 static struct attribute *xfs_agdata_scrub_attrs[] = {
 	XFS_AGDATA_SCRUB_LIST(bnobt),
@@ -186,6 +187,7 @@ static struct attribute *xfs_agdata_scrub_attrs[] = {
 	XFS_AGDATA_SCRUB_LIST(inobt),
 	XFS_AGDATA_SCRUB_LIST(finobt),
 	XFS_AGDATA_SCRUB_LIST(rmapbt),
+	XFS_AGDATA_SCRUB_LIST(refcountbt),
 	NULL,
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
