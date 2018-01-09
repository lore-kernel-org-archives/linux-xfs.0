Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbeAIVPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:15:46 -0500
Date: Tue, 9 Jan 2018 13:15:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 14/21] xfs: cross-reference with the bnobt
Message-ID: <20180109211536.GI5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985848.18741.1443595678961710395.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398985848.18741.1443595678961710395.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're scrubbing various btrees, cross-reference the records with
the bnobt to ensure that we don't also think the space is free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/agheader.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   19 ++++++++++
 fs/xfs/scrub/bmap.c     |   19 ++++++++++
 fs/xfs/scrub/btree.c    |    5 +++
 fs/xfs/scrub/ialloc.c   |    2 +
 fs/xfs/scrub/inode.c    |   15 ++++++++
 fs/xfs/scrub/refcount.c |    2 +
 fs/xfs/scrub/rmap.c     |    5 +++
 fs/xfs/scrub/scrub.h    |    4 ++
 9 files changed, 158 insertions(+)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1477aad..58e544b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -107,8 +107,23 @@ xfs_scrub_superblock_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_buf			*bp)
 {
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agnumber_t			agno = sc->sm->sm_agno;
+	xfs_agblock_t			agbno;
+	int				error;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	agbno = XFS_SB_BLOCK(mp);
+
+	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
+	if (!xfs_scrub_xref_process_error(sc, agno, agbno, &error))
+		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+
+	/* scrub teardown will take care of sc->sa for us */
 }
 
 /*
@@ -406,13 +421,52 @@ xfs_scrub_superblock(
 
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
+	xfs_agblock_t			agbno;
+	xfs_extlen_t			blocks;
+	int				error;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	agbno = XFS_AGF_BLOCK(mp);
+
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+
+	/* Check agf_freeblks */
+	if (sc->sa.bno_cur) {
+		blocks = 0;
+		error = xfs_alloc_query_all(sc->sa.bno_cur,
+				xfs_scrub_agf_record_bno_lengths, &blocks);
+		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur) &&
+		    blocks != be32_to_cpu(agf->agf_freeblks))
+			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
+	}
+
+	/* scrub teardown will take care of sc->sa for us */
 }
 
 /* Scrub the AGF. */
@@ -514,6 +568,8 @@ xfs_scrub_agfl_block_xref(
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -554,8 +610,25 @@ STATIC void
 xfs_scrub_agfl_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			agbno;
+	int				error;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	agbno = XFS_AGFL_BLOCK(mp);
+
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+
+	/*
+	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
+	 * active so that the agfl block xref can use it too.
+	 */
 }
 
 /* Scrub the AGFL. */
@@ -630,8 +703,22 @@ STATIC void
 xfs_scrub_agi_xref(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_mount		*mp = sc->mp;
+	xfs_agblock_t			agbno;
+	int				error;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	agbno = XFS_AGI_BLOCK(mp);
+
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+
+	/* scrub teardown will take care of sc->sa for us */
 }
 
 /* Scrub the AGI. */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 03ed403..564c76b 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -113,3 +113,22 @@ xfs_scrub_cntbt(
 {
 	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
 }
+
+/* xref check that the extent is not free */
+void
+xfs_scrub_xref_is_used_space(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+	bool				is_freesp;
+	int				error;
+
+	if (sc->sa.bno_cur)
+		return;
+
+	error = xfs_alloc_has_record(sc->sa.bno_cur, bno, len, &is_freesp);
+	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.bno_cur) &&
+	    is_freesp)
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.bno_cur, 0);
+}
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b693192..7e8e239 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -119,8 +119,27 @@ xfs_scrub_bmap_extent_xref(
 	struct xfs_btree_cur		*cur,
 	struct xfs_bmbt_irec		*irec)
 {
+	struct xfs_mount		*mp = info->sc->mp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_extlen_t			len;
+	int				error;
+
 	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+	len = irec->br_blockcount;
+
+	error = xfs_scrub_ag_init(info->sc, agno, &info->sc->sa);
+	if (!xfs_scrub_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		return;
+
+	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
+
+	xfs_scrub_ag_free(info->sc, &info->sc->sa);
 }
 
 /* Scrub a single extent record. */
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 3bb88d8..3dbac4c 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -378,9 +378,11 @@ xfs_scrub_btree_check_block_owner(
 	xfs_daddr_t			daddr)
 {
 	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
 	int				error = 0;
 
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
+	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		error = xfs_scrub_ag_init(bs->sc, agno, &bs->sc->sa);
@@ -389,6 +391,9 @@ xfs_scrub_btree_check_block_owner(
 			return error;
 	}
 
+	/* Cross-reference with the bnobt. */
+	xfs_scrub_xref_is_used_space(bs->sc, agbno, 1);
+
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		xfs_scrub_ag_free(bs->sc, &bs->sc->sa);
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 9294148..4526894 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -69,6 +69,8 @@ xfs_scrub_iallocbt_chunk_xref(
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, len);
 }
 
 /* Is this chunk worth checking? */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 2aa12e1..be9cf19 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -584,8 +584,23 @@ xfs_scrub_inode_xref(
 	xfs_ino_t			ino,
 	struct xfs_dinode		*dip)
 {
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	int				error;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	agno = XFS_INO_TO_AGNO(sc->mp, ino);
+	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
+
+	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
+	if (!xfs_scrub_xref_process_error(sc, agno, agbno, &error))
+		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, 1);
+
+	xfs_scrub_ag_free(sc, &sc->sa);
 }
 
 /* Scrub an inode. */
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 4c550b3..09a04ae 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -60,6 +60,8 @@ xfs_scrub_refcountbt_xref(
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, len);
 }
 
 /* Scrub a refcountbt record. */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8655948..54b0eac 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -57,8 +57,13 @@ xfs_scrub_rmapbt_xref(
 	struct xfs_scrub_context	*sc,
 	struct xfs_rmap_irec		*irec)
 {
+	xfs_agblock_t			agbno = irec->rm_startblock;
+	xfs_extlen_t			len = irec->rm_blockcount;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
+
+	xfs_scrub_xref_is_used_space(sc, agbno, len);
 }
 
 /* Scrub an rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 2a79614..006e396 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -123,4 +123,8 @@ xfs_scrub_quota(struct xfs_scrub_context *sc)
 }
 #endif
 
+/* cross-referencing helpers */
+void xfs_scrub_xref_is_used_space(struct xfs_scrub_context *sc,
+		xfs_agblock_t bno, xfs_extlen_t len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
