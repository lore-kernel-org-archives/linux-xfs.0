Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757125AbdLWAoO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:44:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0gWWQ097542
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:14 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2f1ct0r0e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0iD2j008537
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:13 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN0iDYS001563
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:44:13 GMT
Subject: [PATCH 13/21] xfs: introduce scrubber cross-referencing stubs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:44:12 -0800
Message-ID: <151398985228.18741.6364419677377927534.stgit@magnolia>
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

Create some stubs that will be used to cross-reference metadata records.
The actual cross-referencing will be filled in by subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/alloc.c    |   14 ++++++++++
 fs/xfs/scrub/bmap.c     |   28 ++++++++++++++++++++
 fs/xfs/scrub/ialloc.c   |   17 ++++++++++++
 fs/xfs/scrub/inode.c    |   13 +++++++++
 fs/xfs/scrub/refcount.c |   15 +++++++++++
 fs/xfs/scrub/rmap.c     |   13 +++++++++
 7 files changed, 163 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 97beb47..5be9059 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -37,7 +37,10 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 
-/* Walk all the blocks in the AGFL. */
+/*
+ * Walk all the blocks in the AGFL.  The fn function can return any negative
+ * error code or XFS_BTREE_QUERY_RANGE_ABORT.
+ */
 int
 xfs_scrub_walk_agfl(
 	struct xfs_scrub_context	*sc,
@@ -98,6 +101,14 @@ xfs_scrub_walk_agfl(
 
 /* Superblock */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_superblock_xref(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+}
+
 /*
  * Scrub the filesystem superblock.
  *
@@ -386,11 +397,23 @@ xfs_scrub_superblock(
 			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
 		xfs_scrub_block_set_corrupt(sc, bp);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_superblock_xref(sc, bp);
+out:
 	return error;
 }
 
 /* AGF */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agf_xref(
+	struct xfs_scrub_context	*sc)
+{
+}
+
 /* Scrub the AGF. */
 int
 xfs_scrub_agf(
@@ -469,6 +492,10 @@ xfs_scrub_agf(
 	if (agfl_count != 0 && fl_count != agfl_count)
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_agf_xref(sc);
 out:
 	return error;
 }
@@ -481,6 +508,14 @@ struct xfs_scrub_agfl_info {
 	xfs_agblock_t			*entries;
 };
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agfl_block_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno)
+{
+}
+
 /* Scrub an AGFL block. */
 STATIC int
 xfs_scrub_agfl_block(
@@ -498,6 +533,11 @@ xfs_scrub_agfl_block(
 	else
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_agfl_block_xref(sc, agbno);
+out:
 	return 0;
 }
 
@@ -512,6 +552,13 @@ xfs_scrub_agblock_cmp(
 	return (int)*a - (int)*b;
 }
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agfl_xref(
+	struct xfs_scrub_context	*sc)
+{
+}
+
 /* Scrub the AGFL. */
 int
 xfs_scrub_agfl(
@@ -532,6 +579,11 @@ xfs_scrub_agfl(
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_agfl_xref(sc);
+
 	/* Allocate buffer to ensure uniqueness of AGFL entries. */
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	agflcount = be32_to_cpu(agf->agf_flcount);
@@ -574,6 +626,13 @@ xfs_scrub_agfl(
 
 /* AGI */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_agi_xref(
+	struct xfs_scrub_context	*sc)
+{
+}
+
 /* Scrub the AGI. */
 int
 xfs_scrub_agi(
@@ -652,6 +711,10 @@ xfs_scrub_agi(
 	if (agi->agi_pad32 != cpu_to_be32(0))
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_agi_xref(sc);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 059663e..0d95b84 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -50,6 +50,15 @@ xfs_scrub_setup_ag_allocbt(
 
 /* Free space btree scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_allocbt_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+}
+
 /* Scrub a bnobt/cntbt record. */
 STATIC int
 xfs_scrub_allocbt_rec(
@@ -70,6 +79,11 @@ xfs_scrub_allocbt_rec(
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_allocbt_xref(bs->sc, bno, len);
+out:
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 0261e11..d960b7a 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -99,6 +99,26 @@ struct xfs_scrub_bmap_info {
 	int				whichfork;
 };
 
+/* Cross-reference a single rtdev extent record. */
+STATIC void
+xfs_scrub_bmap_rt_extent_xref(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_bmbt_irec		*irec)
+{
+}
+
+/* Cross-reference a single datadev extent record. */
+STATIC void
+xfs_scrub_bmap_extent_xref(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_bmbt_irec		*irec)
+{
+}
+
 /* Scrub a single extent record. */
 STATIC int
 xfs_scrub_bmap_extent(
@@ -158,6 +178,14 @@ xfs_scrub_bmap_extent(
 		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
+	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	if (info->is_rt)
+		xfs_scrub_bmap_rt_extent_xref(info, ip, cur, irec);
+	else
+		xfs_scrub_bmap_extent_xref(info, ip, cur, irec);
+out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
 	return error;
 }
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 496d6f2..599d62a 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -58,6 +58,17 @@ xfs_scrub_setup_ag_iallocbt(
 
 /* Inode btree scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_iallocbt_chunk_xref(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len)
+{
+}
+
 /* Is this chunk worth checking? */
 STATIC bool
 xfs_scrub_iallocbt_chunk(
@@ -76,6 +87,11 @@ xfs_scrub_iallocbt_chunk(
 	    !xfs_verify_agbno(mp, agno, bno + len - 1))
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
+out:
 	return true;
 }
 
@@ -303,7 +319,6 @@ xfs_scrub_iallocbt_rec(
 	error = xfs_scrub_iallocbt_check_freemask(bs, &irec);
 	if (error)
 		goto out;
-
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 304e8bc..6cd6b34 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -577,6 +577,15 @@ xfs_scrub_inode_map_raw(
 	return error;
 }
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_inode_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_dinode		*dip)
+{
+}
+
 /* Scrub an inode. */
 int
 xfs_scrub_inode(
@@ -626,6 +635,10 @@ xfs_scrub_inode(
 			xfs_scrub_ino_set_preen(sc, ino, bp);
 	}
 
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_inode_xref(sc, ino, dip);
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 2f88a8d..5a3aa9b 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -50,6 +50,16 @@ xfs_scrub_setup_ag_refcountbt(
 
 /* Reference count btree scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_refcountbt_xref(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xfs_scrub_refcountbt_rec(
@@ -83,6 +93,11 @@ xfs_scrub_refcountbt_rec(
 	if (refcount == 0)
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_refcountbt_xref(bs->sc, bno, len, refcount);
+out:
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 97846c4..80edddb 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -51,6 +51,14 @@ xfs_scrub_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+/* Cross-reference with the other btrees. */
+STATIC void
+xfs_scrub_rmapbt_xref(
+	struct xfs_scrub_context	*sc,
+	struct xfs_rmap_irec		*irec)
+{
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xfs_scrub_rmapbt_rec(
@@ -121,6 +129,11 @@ xfs_scrub_rmapbt_rec(
 		    irec.rm_owner > XFS_RMAP_OWN_FS)
 			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xfs_scrub_rmapbt_xref(bs->sc, &irec);
 out:
 	return error;
 }

