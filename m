Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdLMX7r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:59:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNl9wb024492
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:46 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eudq6060w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:46 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNvEQ1031655
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:14 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBDNvEYL026214
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:14 GMT
Subject: [PATCH 08/15] xfs: cross-reference with the bnobt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:57:11 -0800
Message-ID: <151320943123.30154.6109914449635128557.stgit@magnolia>
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

When we're scrubbing various btrees, cross-reference the records with
the bnobt to ensure that we don't also think the space is free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   19 +++++++++++
 fs/xfs/scrub/bmap.c     |   21 +++++++++++-
 fs/xfs/scrub/btree.c    |   12 +++++++
 fs/xfs/scrub/ialloc.c   |    1 +
 fs/xfs/scrub/inode.c    |   15 ++++++++
 fs/xfs/scrub/refcount.c |    1 +
 fs/xfs/scrub/rmap.c     |    4 ++
 fs/xfs/scrub/scrub.h    |    5 +++
 9 files changed, 161 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index b4297e9..6241475 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -107,6 +107,20 @@ xfs_scrub_superblock_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agnumber_t			agno = sc->sm->sm_agno;
+	xfs_agblock_t			bno;
+	int				error;
+
+	bno = XFS_SB_BLOCK(mp);
+
+	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
+	if (!xfs_scrub_xref_process_error(sc, agno, bno, &error))
+		return;
+
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+
+	/* scrub teardown will take care of sc->sa for us */
 }
 
 /*
@@ -391,11 +405,51 @@ xfs_scrub_superblock(
 
 /* AGF */
 
+/* Tally freespace record lengths. */
+STATIC int
+xfs_scrub_agf_record_bno_lengths(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	xfs_extlen_t			*blocks = priv;
+
+	(*blocks) += rec->ar_blockcount;
+	return 0;
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_agf_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	struct xfs_btree_cur		**pcur;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			blocks;
+	int				error;
+
+	bno = XFS_AGF_BLOCK(mp);
+
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		return;
+
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+
+	/* Check agf_freeblks */
+	pcur = &sc->sa.bno_cur;
+	if (*pcur) {
+		blocks = 0;
+		error = xfs_alloc_query_all(*pcur,
+				xfs_scrub_agf_record_bno_lengths, &blocks);
+		if (xfs_scrub_should_xref(sc, &error, pcur) &&
+		    blocks != be32_to_cpu(agf->agf_freeblks))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+	}
+
+	/* scrub teardown will take care of sc->sa for us */
 }
 
 /* Scrub the AGF. */
@@ -498,6 +552,7 @@ xfs_scrub_agfl_block_xref(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno)
 {
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -541,6 +596,22 @@ STATIC void
 xfs_scrub_agfl_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			bno;
+	int				error;
+
+	bno = XFS_AGFL_BLOCK(mp);
+
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		return;
+
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+
+	/*
+	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
+	 * active so that the agfl block xref can use it too.
+	 */
 }
 
 /* Scrub the AGFL. */
@@ -615,6 +686,19 @@ STATIC void
 xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			bno;
+	int				error;
+
+	bno = XFS_AGI_BLOCK(mp);
+
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		return;
+
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
+
+	/* scrub teardown will take care of sc->sa for us */
 }
 
 /* Scrub the AGI. */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 0d95b84..3d6f8cc 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -114,3 +114,22 @@ xfs_scrub_cntbt(
 {
 	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
 }
+
+/* xref check that the extent is not free */
+void
+xfs_scrub_xref_not_free(
+	struct xfs_scrub_context	*sc,
+	struct xfs_btree_cur		**pcur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				is_freesp;
+	int				error;
+
+	if (!(*pcur))
+		return;
+
+	error = xfs_alloc_has_record(*pcur, bno, len, &is_freesp);
+	if (xfs_scrub_should_xref(sc, &error, pcur) && is_freesp)
+		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
+}
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 684f08b..7ce135b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -31,12 +31,12 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_inode_fork.h"
-#include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -117,6 +117,25 @@ xfs_scrub_bmap_extent_xref(
 	struct xfs_btree_cur		*cur,
 	struct xfs_bmbt_irec		*irec)
 {
+	struct xfs_scrub_ag		sa = { 0 };
+	struct xfs_mount		*mp = info->sc->mp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_extlen_t			len;
+	int				error;
+
+	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+	len = irec->br_blockcount;
+
+	error = xfs_scrub_ag_init(info->sc, agno, &sa);
+	if (!xfs_scrub_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		return;
+
+	xfs_scrub_xref_not_free(info->sc, &sa.bno_cur, agbno, len);
+
+	xfs_scrub_ag_free(info->sc, &sa);
 }
 
 /* Scrub a single extent record. */
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 40fc26f..67b6248 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -378,9 +378,12 @@ xfs_scrub_btree_check_block_owner(
 	struct xfs_scrub_ag		sa = { 0 };
 	struct xfs_scrub_ag		*psa;
 	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
 
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
+	bno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		error = xfs_scrub_ag_init(bs->sc, agno, &sa);
@@ -392,6 +395,15 @@ xfs_scrub_btree_check_block_owner(
 		psa = &bs->sc->sa;
 	}
 
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, bno, 1, &is_freesp);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->bno_cur) &&
+		    is_freesp)
+			xfs_scrub_btree_xref_set_corrupt(bs->sc, psa->bno_cur,
+					0);
+	}
+
 	if (psa == &sa)
 		xfs_scrub_ag_free(bs->sc, &sa);
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 599d62a..4c4ef17c 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -67,6 +67,7 @@ xfs_scrub_iallocbt_chunk_xref(
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len)
 {
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
 }
 
 /* Is this chunk worth checking? */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e31d981..e6038c1 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -584,6 +584,21 @@ xfs_scrub_inode_xref(
 	xfs_ino_t			ino,
 	struct xfs_dinode		*dip)
 {
+	struct xfs_scrub_ag		sa = { 0 };
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	int				error;
+
+	agno = XFS_INO_TO_AGNO(sc->mp, ino);
+	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
+
+	error = xfs_scrub_ag_init(sc, agno, &sa);
+	if (!xfs_scrub_xref_process_error(sc, agno, agbno, &error))
+		return;
+
+	xfs_scrub_xref_not_free(sc, &sa.bno_cur, agbno, 1);
+
+	xfs_scrub_ag_free(sc, &sa);
 }
 
 /* Scrub an inode. */
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 5a3aa9b..19c303d 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -58,6 +58,7 @@ xfs_scrub_refcountbt_xref(
 	xfs_extlen_t			len,
 	xfs_nlink_t			refcount)
 {
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
 }
 
 /* Scrub a refcountbt record. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 80edddb..5c9646b 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -57,6 +57,10 @@ xfs_scrub_rmapbt_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_rmap_irec		*irec)
 {
+	xfs_agblock_t			bno = irec->rm_startblock;
+	xfs_extlen_t			len = irec->rm_blockcount;
+
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, len);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 2a79614..e75ff0e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -123,4 +123,9 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
 }
 #endif
 
+/* cross-referencing helpers */
+void xfs_scrub_xref_not_free(struct xfs_scrub_context *sc,
+		struct xfs_btree_cur **pcur, xfs_agblock_t bno,
+		xfs_extlen_t len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

