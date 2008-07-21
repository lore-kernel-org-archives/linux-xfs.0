Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 21:52:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6L4pxmm011839
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 21:52:02 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1DFDE6A561
	for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 21:53:04 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id BIWAJzv3HdbSKixK for <xfs@oss.sgi.com>; Sun, 20 Jul 2008 21:53:04 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Use KM_NOFS for incore inode extent tree allocation
Date: Mon, 21 Jul 2008 14:52:39 +1000
Message-Id: <1216615959-23010-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

If we allow incore extent tree allocations to recurse into the
filesystem under memory pressure, new delayed allocations through
xfs_iomap_write_delay() can deadlock on themselves if memory reclaim
tries to write back dirty pages from that inode.

It will deadlock in xfs_iomap_write_allocate() trying to take the
ilock we already hold. This can also show up as complex ABBA
deadlocks when multiple threeads are triggering memory reclaim when
trying to allocate extents.

The main cause of this is the fact that delayed allocation is
not done in a transaction, so KM_NOFS is not automatically
added to the allocations to prevent this recursion.

Mark all allocations done for the incore inode extent tree as
KM_NOFS to ensure they never recurse back into the filesystem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bedc661..20b6f87 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3707,7 +3707,8 @@ xfs_iext_add_indirect_multi(
 	 * (all extents past */
 	if (nex2) {
 		byte_diff = nex2 * sizeof(xfs_bmbt_rec_t);
-		nex2_ep = (xfs_bmbt_rec_t *) kmem_alloc(byte_diff, KM_SLEEP);
+		nex2_ep = (xfs_bmbt_rec_t *) kmem_alloc(byte_diff,
+							KM_SLEEP|KM_NOFS);
 		memmove(nex2_ep, &erp->er_extbuf[idx], byte_diff);
 		erp->er_extcount -= nex2;
 		xfs_iext_irec_update_extoffs(ifp, erp_idx + 1, -nex2);
@@ -4008,7 +4009,7 @@ xfs_iext_realloc_direct(
 				kmem_realloc(ifp->if_u1.if_extents,
 						rnew_size,
 						ifp->if_real_bytes,
-						KM_SLEEP);
+						KM_SLEEP|KM_NOFS);
 		}
 		if (rnew_size > ifp->if_real_bytes) {
 			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
@@ -4067,7 +4068,7 @@ xfs_iext_inline_to_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* number of extents in file */
 {
-	ifp->if_u1.if_extents = kmem_alloc(new_size, KM_SLEEP);
+	ifp->if_u1.if_extents = kmem_alloc(new_size, KM_SLEEP|KM_NOFS);
 	memset(ifp->if_u1.if_extents, 0, new_size);
 	if (ifp->if_bytes) {
 		memcpy(ifp->if_u1.if_extents, ifp->if_u2.if_inline_ext,
@@ -4099,7 +4100,7 @@ xfs_iext_realloc_indirect(
 	} else {
 		ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
 			kmem_realloc(ifp->if_u1.if_ext_irec,
-				new_size, size, KM_SLEEP);
+				new_size, size, KM_SLEEP|KM_NOFS);
 	}
 }
 
@@ -4342,10 +4343,11 @@ xfs_iext_irec_init(
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 
 	erp = (xfs_ext_irec_t *)
-		kmem_alloc(sizeof(xfs_ext_irec_t), KM_SLEEP);
+		kmem_alloc(sizeof(xfs_ext_irec_t), KM_SLEEP|KM_NOFS);
 
 	if (nextents == 0) {
-		ifp->if_u1.if_extents = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
+		ifp->if_u1.if_extents = kmem_alloc(XFS_IEXT_BUFSZ,
+							KM_SLEEP|KM_NOFS);
 	} else if (!ifp->if_real_bytes) {
 		xfs_iext_inline_to_direct(ifp, XFS_IEXT_BUFSZ);
 	} else if (ifp->if_real_bytes < XFS_IEXT_BUFSZ) {
@@ -4393,7 +4395,7 @@ xfs_iext_irec_new(
 
 	/* Initialize new extent record */
 	erp = ifp->if_u1.if_ext_irec;
-	erp[erp_idx].er_extbuf = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
+	erp[erp_idx].er_extbuf = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP|KM_NOFS);
 	ifp->if_real_bytes = nlists * XFS_IEXT_BUFSZ;
 	memset(erp[erp_idx].er_extbuf, 0, XFS_IEXT_BUFSZ);
 	erp[erp_idx].er_extcount = 0;
-- 
1.5.6
