Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54316 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbdLHDoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 22:44:06 -0500
Subject: [PATCH 3/5] xfs: queue deferred rmap ops for cow staging extent
 alloc/free in the right order
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 07 Dec 2017 19:39:24 -0800
Message-ID: <151270436416.12194.13108400111854379733.stgit@magnolia>
In-Reply-To: <151270433736.12194.14709247629624139846.stgit@magnolia>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Under the deferred rmap operation scheme, there's a certain order in
which the rmap deferred ops have to be queued to maintain integrity
during log replay.  For alloc/map operations that order is cui -> rui;
for free/unmap operations that order is cui -> rui -> efi.  However, the
initial refcount code got the ordering wrong in the free side of things
because it queued refcount free op and an EFI and the refcount free op
queued a rmap free op, resulting in the order cui -> efi -> rui.

If we fail before the efd finishes, the efi recovery will try to do a
wildcard rmap removal and the subsequent rui will fail to find the rmap
and blow up.  This didn't ever happen due to other screws up in handling
unknown owner rmap removals, but those other screw ups broke recovery in
other ways, so fix the ordering to follow the intended rules.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   52 +++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 585b35d..c40d267 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1488,27 +1488,12 @@ __xfs_refcount_cow_alloc(
 	xfs_extlen_t		aglen,
 	struct xfs_defer_ops	*dfops)
 {
-	int			error;
-
 	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_private.a.agno,
 			agbno, aglen);
 
 	/* Add refcount btree reservation */
-	error = xfs_refcount_adjust_cow(rcur, agbno, aglen,
+	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
 			XFS_REFCOUNT_ADJUST_COW_ALLOC, dfops);
-	if (error)
-		return error;
-
-	/* Add rmap entry */
-	if (xfs_sb_version_hasrmapbt(&rcur->bc_mp->m_sb)) {
-		error = xfs_rmap_alloc_extent(rcur->bc_mp, dfops,
-				rcur->bc_private.a.agno,
-				agbno, aglen, XFS_RMAP_OWN_COW);
-		if (error)
-			return error;
-	}
-
-	return error;
 }
 
 /*
@@ -1521,27 +1506,12 @@ __xfs_refcount_cow_free(
 	xfs_extlen_t		aglen,
 	struct xfs_defer_ops	*dfops)
 {
-	int			error;
-
 	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_private.a.agno,
 			agbno, aglen);
 
 	/* Remove refcount btree reservation */
-	error = xfs_refcount_adjust_cow(rcur, agbno, aglen,
+	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
 			XFS_REFCOUNT_ADJUST_COW_FREE, dfops);
-	if (error)
-		return error;
-
-	/* Remove rmap entry */
-	if (xfs_sb_version_hasrmapbt(&rcur->bc_mp->m_sb)) {
-		error = xfs_rmap_free_extent(rcur->bc_mp, dfops,
-				rcur->bc_private.a.agno,
-				agbno, aglen, XFS_RMAP_OWN_COW);
-		if (error)
-			return error;
-	}
-
-	return error;
 }
 
 /* Record a CoW staging extent in the refcount btree. */
@@ -1552,11 +1522,19 @@ xfs_refcount_alloc_cow_extent(
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
+	int				error;
+
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
-	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_ALLOC_COW,
+	error = __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_ALLOC_COW,
 			fsb, len);
+	if (error)
+		return error;
+
+	/* Add rmap entry */
+	return xfs_rmap_alloc_extent(mp, dfops, XFS_FSB_TO_AGNO(mp, fsb),
+			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1567,9 +1545,17 @@ xfs_refcount_free_cow_extent(
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
+	int				error;
+
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
+	/* Remove rmap entry */
+	error = xfs_rmap_free_extent(mp, dfops, XFS_FSB_TO_AGNO(mp, fsb),
+			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	if (error)
+		return error;
+
 	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_FREE_COW,
 			fsb, len);
 }

