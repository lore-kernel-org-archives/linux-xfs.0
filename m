Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56230 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbeAIVUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:20:14 -0500
Date: Tue, 9 Jan 2018 13:20:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 15/21] xfs: cross-reference bnobt records with cntbt
Message-ID: <20180109212008.GJ5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398986464.18741.745289369411639057.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398986464.18741.745289369411639057.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub should make sure that each bnobt record has a corresponding
cntbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 58e544b..3b66cd4 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -434,6 +434,38 @@ xfs_scrub_agf_record_bno_lengths(
 	return 0;
 }
 
+/* Cross reference the AGF with the cntbt (freespace by length btree) */
+STATIC void
+xfs_scrub_agf_xref_cntbt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_agf			*agf)
+{
+	xfs_agblock_t			agbno;
+	xfs_extlen_t			blocks;
+	int				have;
+	int				error;
+
+	if (!sc->sa.cnt_cur)
+		return;
+
+	/* Any freespace at all? */
+	error = xfs_alloc_lookup_le(sc->sa.cnt_cur, 0, -1U, &have);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+		return;
+	if (!have) {
+		if (agf->agf_freeblks != be32_to_cpu(0))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+		return;
+	}
+
+	/* Check agf_longest */
+	error = xfs_alloc_get_rec(sc->sa.cnt_cur, &agbno, &blocks, &have);
+	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.cnt_cur))
+		return;
+	if (!have || blocks != be32_to_cpu(agf->agf_longest))
+		xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_agf_xref(
@@ -466,6 +498,9 @@ xfs_scrub_agf_xref(
 			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
+	/* Cross-reference with the cntbt. */
+	xfs_scrub_agf_xref_cntbt(sc, agf);
+
 	/* scrub teardown will take care of sc->sa for us */
 }
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 564c76b..4101560 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -49,6 +50,48 @@ xfs_scrub_setup_ag_allocbt(
 }
 
 /* Free space btree scrubber. */
+/*
+ * Ensure there's a corresponding cntbt/bnobt record matching this
+ * bnobt/cntbt record, respectively.
+ */
+STATIC void
+xfs_scrub_allocbt_xref_other(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	struct xfs_btree_cur		**pcur;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				has_otherrec;
+	int				error;
+
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		pcur = &sc->sa.cnt_cur;
+	else
+		pcur = &sc->sa.bno_cur;
+	if (!*pcur)
+		return;
+
+	error = xfs_alloc_lookup_le(*pcur, agbno, len, &has_otherrec);
+	if (!xfs_scrub_should_check_xref(sc, &error, pcur))
+		return;
+	if (!has_otherrec) {
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		return;
+	}
+
+	error = xfs_alloc_get_rec(*pcur, &fbno, &flen, &has_otherrec);
+	if (!xfs_scrub_should_check_xref(sc, &error, pcur))
+		return;
+	if (!has_otherrec) {
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+		return;
+	}
+
+	if (fbno != agbno || flen != len)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
 
 /* Cross-reference with the other btrees. */
 STATIC void
@@ -59,6 +102,8 @@ xfs_scrub_allocbt_xref(
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_allocbt_xref_other(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
