Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B78C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C04F206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N/qKOkHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAABCG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:02:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgAABCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:02:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x7G9103979
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=P2IO9EAyLHrav5Xww/NAoSFMbL6BhzAJHfjlBiplIEc=;
 b=N/qKOkHWzleWF65ucT7wVhCN8TDAVe3lQZnf7TbSsNCKZRpZnIASJ6UTPDF77lCrIGnZ
 kzLJfZo28oXnPhJQN5jHw2TI4dXJiAUsMPB6LWCye/czJ/jVWPxa+arWtwQI/Nj17e4P
 /8FCLmr7L20qbFSQioFccibZJuFjeEEpOPKfM8P2HuyIUbMz2Q1m/Q4thrnW/DH2Gupt
 AHcPDYU6nERj2G7ZDOi0+LbET+h/jbfwB1mdsX9joNNTeR9ocuMIau+LrxpZiPHR7x2Y
 VBWa9WGRdq7WXzkCpFo/JIe8rScXdyeSf5exbWLIQU4LO4UhTuFP1tT0M7XhTvXdGAAM OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk254-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wREp026655
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medf6px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:02 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011210i019351
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:01 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:02:01 -0800
Subject: [PATCH 3/5] xfs: remove the for_each_xbitmap_ helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:01:59 -0800
Message-ID: <157784051947.1357533.11016643772712829070.stgit@magnolia>
In-Reply-To: <157784050067.1357533.242585262978035395.stgit@magnolia>
References: <157784050067.1357533.242585262978035395.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the for_each_xbitmap_ macros in favor of proper iterator
functions.  We'll soon be switching this data structure over to an
interval tree implementation, which means that we can't allow callers to
modify the bitmap during iteration without telling us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |   73 ++++++++++++++++++++++++----------------
 fs/xfs/scrub/bitmap.c          |   59 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.h          |   22 ++++++++----
 fs/xfs/scrub/repair.c          |   60 +++++++++++++++++----------------
 4 files changed, 148 insertions(+), 66 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index f35596cc26fb..b618a87b8dcf 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -560,6 +560,40 @@ xrep_agfl_update_agf(
 			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
 }
 
+struct xrep_agfl_fill {
+	struct xbitmap		used_extents;
+	struct xfs_scrub	*sc;
+	__be32			*agfl_bno;
+	xfs_agblock_t		flcount;
+	unsigned int		fl_off;
+};
+
+/* Fill the AGFL with whatever blocks are in this extent. */
+static int
+xrep_agfl_fill(
+	uint64_t		start,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xrep_agfl_fill	*af = priv;
+	struct xfs_scrub	*sc = af->sc;
+	xfs_fsblock_t		fsbno = start;
+
+	while (fsbno < start + len && af->fl_off < af->flcount)
+		af->agfl_bno[af->fl_off++] =
+				cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, fsbno++));
+
+	trace_xrep_agfl_insert(sc->mp, sc->sa.agno,
+			XFS_FSB_TO_AGBNO(sc->mp, start), len);
+
+	xbitmap_set(&af->used_extents, start, fsbno - 1);
+
+	if (af->fl_off == af->flcount)
+		return -ECANCELED;
+
+	return 0;
+}
+
 /* Write out a totally new AGFL. */
 STATIC void
 xrep_agfl_init_header(
@@ -568,13 +602,12 @@ xrep_agfl_init_header(
 	struct xbitmap		*agfl_extents,
 	xfs_agblock_t		flcount)
 {
+	struct xrep_agfl_fill	af = {
+		.sc		= sc,
+		.flcount	= flcount,
+	};
 	struct xfs_mount	*mp = sc->mp;
-	__be32			*agfl_bno;
-	struct xbitmap_range	*br;
-	struct xbitmap_range	*n;
 	struct xfs_agfl		*agfl;
-	xfs_agblock_t		agbno;
-	unsigned int		fl_off;
 
 	ASSERT(flcount <= xfs_agfl_size(mp));
 
@@ -593,35 +626,15 @@ xrep_agfl_init_header(
 	 * blocks than fit in the AGFL, they will be freed in a subsequent
 	 * step.
 	 */
-	fl_off = 0;
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
-	for_each_xbitmap_extent(br, n, agfl_extents) {
-		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
-
-		trace_xrep_agfl_insert(mp, sc->sa.agno, agbno, br->len);
-
-		while (br->len > 0 && fl_off < flcount) {
-			agfl_bno[fl_off] = cpu_to_be32(agbno);
-			fl_off++;
-			agbno++;
-
-			/*
-			 * We've now used br->start by putting it in the AGFL,
-			 * so bump br so that we don't reap the block later.
-			 */
-			br->start++;
-			br->len--;
-		}
-
-		if (br->len)
-			break;
-		list_del(&br->list);
-		kmem_free(br);
-	}
+	xbitmap_init(&af.used_extents);
+	af.agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp),
+	xbitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	xbitmap_disunion(agfl_extents, &af.used_extents);
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
+	xbitmap_destroy(&af.used_extents);
 }
 
 /* Repair the AGFL. */
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index f88694f22d05..e198983db610 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -12,6 +12,9 @@
 #include "xfs_btree.h"
 #include "scrub/bitmap.h"
 
+#define for_each_xbitmap_extent(bex, n, bitmap) \
+	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
+
 /*
  * Set a range of this bitmap.  Caller must ensure the range is not set.
  *
@@ -312,3 +315,59 @@ xbitmap_hweight(
 
 	return ret;
 }
+
+/* Call a function for every run of set bits in this bitmap. */
+int
+xbitmap_walk(
+	struct xbitmap		*bitmap,
+	xbitmap_walk_fn	fn,
+	void			*priv)
+{
+	struct xbitmap_range	*bex, *n;
+	int			error;
+
+	for_each_xbitmap_extent(bex, n, bitmap) {
+		error = fn(bex->start, bex->len, priv);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+struct xbitmap_walk_bits {
+	xbitmap_walk_bits_fn	fn;
+	void			*priv;
+};
+
+/* Walk all the bits in a run. */
+static int
+xbitmap_walk_bits_in_run(
+	uint64_t			start,
+	uint64_t			len,
+	void				*priv)
+{
+	struct xbitmap_walk_bits	*wb = priv;
+	uint64_t			i;
+	int				error;
+
+	for (i = start; i < start + len; i++) {
+		error = wb->fn(i, wb->priv);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+/* Call a function for every set bit in this bitmap. */
+int
+xbitmap_walk_bits(
+	struct xbitmap			*bitmap,
+	xbitmap_walk_bits_fn		fn,
+	void				*priv)
+{
+	struct xbitmap_walk_bits	wb = {.fn = fn, .priv = priv};
+
+	return xbitmap_walk(bitmap, xbitmap_walk_bits_in_run, &wb);
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 900646b72de1..53601d281ffb 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -19,13 +19,6 @@ struct xbitmap {
 void xbitmap_init(struct xbitmap *bitmap);
 void xbitmap_destroy(struct xbitmap *bitmap);
 
-#define for_each_xbitmap_extent(bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
-
-#define for_each_xbitmap_block(b, bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list) \
-		for ((b) = (bex)->start; (b) < (bex)->start + (bex)->len; (b)++)
-
 int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
 int xbitmap_set_btcur_path(struct xbitmap *bitmap,
@@ -34,4 +27,19 @@ int xbitmap_set_btblocks(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
 uint64_t xbitmap_hweight(struct xbitmap *bitmap);
 
+/*
+ * Return codes for the bitmap iterator functions are 0 to continue iterating,
+ * and non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * iteration caller.  The special value -ECANCELED can be used to stop
+ * iteration, because neither bitmap iterator ever generates that error code on
+ * its own.  Callers must not modify the bitmap while walking it.
+ */
+typedef int (*xbitmap_walk_fn)(uint64_t start, uint64_t len, void *priv);
+int xbitmap_walk(struct xbitmap *bitmap, xbitmap_walk_fn fn,
+		void *priv);
+
+typedef int (*xbitmap_walk_bits_fn)(uint64_t bit, void *priv);
+int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
+		void *priv);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 6ca2c638aaa0..088dbd7df096 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -505,15 +505,21 @@ xrep_reap_invalidate_block(
 	xfs_trans_binval(sc->tp, bp);
 }
 
+struct xrep_reap_block {
+	struct xfs_scrub		*sc;
+	const struct xfs_owner_info	*oinfo;
+	enum xfs_ag_resv_type		resv;
+	unsigned int			deferred;
+};
+
 /* Dispose of a single block. */
 STATIC int
 xrep_reap_block(
-	struct xfs_scrub		*sc,
-	xfs_fsblock_t			fsbno,
-	const struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type		resv,
-	unsigned int			*deferred)
+	uint64_t			fsbno,
+	void				*priv)
 {
+	struct xrep_reap_block		*rb = priv;
+	struct xfs_scrub		*sc = rb->sc;
 	struct xfs_btree_cur		*cur;
 	struct xfs_buf			*agf_bp = NULL;
 	xfs_agnumber_t			agno;
@@ -525,6 +531,10 @@ xrep_reap_block(
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
 
+	ASSERT(sc->ip != NULL || agno == sc->sa.agno);
+
+	trace_xrep_dispose_btree_extent(sc->mp, agno, agbno, 1);
+
 	/*
 	 * If we are repairing per-inode metadata, we need to read in the AGF
 	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
@@ -542,7 +552,8 @@ xrep_reap_block(
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
 
 	/* Can we find any other rmappings? */
-	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
+	error = xfs_rmap_has_other_keys(cur, agbno, 1, rb->oinfo,
+			&has_other_rmap);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_free;
@@ -561,8 +572,9 @@ xrep_reap_block(
 	 * to run xfs_repair.
 	 */
 	if (has_other_rmap) {
-		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
-	} else if (resv == XFS_AG_RESV_AGFL) {
+		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1,
+				rb->oinfo);
+	} else if (rb->resv == XFS_AG_RESV_AGFL) {
 		xrep_reap_invalidate_block(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
 	} else {
@@ -574,16 +586,16 @@ xrep_reap_block(
 		 * reservation.
 		 */
 		xrep_reap_invalidate_block(sc, fsbno);
-		__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, false);
-		(*deferred)++;
-		need_roll = *deferred > 100;
+		__xfs_bmap_add_free(sc->tp, fsbno, 1, rb->oinfo, false);
+		rb->deferred++;
+		need_roll = rb->deferred > 100;
 	}
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error || !need_roll)
 		return error;
 
-	*deferred = 0;
+	rb->deferred = 0;
 	if (sc->ip)
 		return xfs_trans_roll_inode(&sc->tp, sc->ip);
 	return xrep_roll_ag_trans(sc);
@@ -602,27 +614,17 @@ xrep_reap_extents(
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type)
 {
-	struct xbitmap_range		*bmr;
-	struct xbitmap_range		*n;
-	xfs_fsblock_t			fsbno;
-	unsigned int			deferred = 0;
+	struct xrep_reap_block		rb = {
+		.sc			= sc,
+		.oinfo			= oinfo,
+		.resv			= type,
+	};
 	int				error = 0;
 
 	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
 
-	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
-		ASSERT(sc->ip != NULL ||
-		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.agno);
-		trace_xrep_dispose_btree_extent(sc->mp,
-				XFS_FSB_TO_AGNO(sc->mp, fsbno),
-				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
-
-		error = xrep_reap_block(sc, fsbno, oinfo, type, &deferred);
-		if (error)
-			break;
-	}
-
-	if (error || deferred == 0)
+	error = xbitmap_walk_bits(bitmap, xrep_reap_block, &rb);
+	if (error || rb.deferred == 0)
 		return error;
 
 	if (sc->ip)

