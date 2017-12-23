Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757012AbdLWAtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:49:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0lvwb100723
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:49:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2f1ct0r0rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:49:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0iKPG031016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:20 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0iJWc026891
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:19 GMT
Subject: [PATCH 14/21] xfs: cross-reference with the bnobt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:44:18 -0800
Message-ID: <151398985848.18741.1443595678961710395.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
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
index 5be9059..3bb0f96 100644
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
@@ -407,11 +421,51 @@ xfs_scrub_superblock(
 
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
@@ -514,6 +568,7 @@ xfs_scrub_agfl_block_xref(
 	struct xfs_scrub_context	*sc,
 	xfs_agblock_t			bno)
 {
+	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -557,6 +612,22 @@ STATIC void
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
@@ -631,6 +702,19 @@ STATIC void
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
index d960b7a..a74771c 100644
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
index 9151499..ae58fcc 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -381,9 +381,12 @@ xfs_scrub_btree_check_block_owner(
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
@@ -395,6 +398,15 @@ xfs_scrub_btree_check_block_owner(
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
index 6cd6b34..a00d179 100644
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

