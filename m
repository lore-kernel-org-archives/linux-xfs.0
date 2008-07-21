Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:02:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LB26TK013037
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:02:07 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B831190FA17
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:03:15 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id t8fVYwIM9Dhn5jWR for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:03:15 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Use KM_NOFS for incore inode extent tree allocation V2
Date: Mon, 21 Jul 2008 21:03:12 +1000
Message-Id: <1216638192-6292-1-git-send-email-david@fromorbit.com>
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
deadlocks when multiple threads are triggering memory reclaim when
trying to allocate extents.

The main cause of this is the fact that delayed allocation is
not done in a transaction, so KM_NOFS is not automatically
added to the allocations to prevent this recursion.

Mark all allocations done for the incore inode extent tree as
KM_NOFS to ensure they never recurse back into the filesystem.

Version 2:
o KM_NOFS implies KM_SLEEP, so just use KM_NOFS

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_inode.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bedc661..89b8638 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3707,7 +3707,7 @@ xfs_iext_add_indirect_multi(
 	 * (all extents past */
 	if (nex2) {
 		byte_diff = nex2 * sizeof(xfs_bmbt_rec_t);
-		nex2_ep = (xfs_bmbt_rec_t *) kmem_alloc(byte_diff, KM_SLEEP);
+		nex2_ep = (xfs_bmbt_rec_t *) kmem_alloc(byte_diff, KM_NOFS);
 		memmove(nex2_ep, &erp->er_extbuf[idx], byte_diff);
 		erp->er_extcount -= nex2;
 		xfs_iext_irec_update_extoffs(ifp, erp_idx + 1, -nex2);
@@ -4007,8 +4007,7 @@ xfs_iext_realloc_direct(
 			ifp->if_u1.if_extents =
 				kmem_realloc(ifp->if_u1.if_extents,
 						rnew_size,
-						ifp->if_real_bytes,
-						KM_SLEEP);
+						ifp->if_real_bytes, KM_NOFS);
 		}
 		if (rnew_size > ifp->if_real_bytes) {
 			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
@@ -4067,7 +4066,7 @@ xfs_iext_inline_to_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* number of extents in file */
 {
-	ifp->if_u1.if_extents = kmem_alloc(new_size, KM_SLEEP);
+	ifp->if_u1.if_extents = kmem_alloc(new_size, KM_NOFS);
 	memset(ifp->if_u1.if_extents, 0, new_size);
 	if (ifp->if_bytes) {
 		memcpy(ifp->if_u1.if_extents, ifp->if_u2.if_inline_ext,
@@ -4099,7 +4098,7 @@ xfs_iext_realloc_indirect(
 	} else {
 		ifp->if_u1.if_ext_irec = (xfs_ext_irec_t *)
 			kmem_realloc(ifp->if_u1.if_ext_irec,
-				new_size, size, KM_SLEEP);
+				new_size, size, KM_NOFS);
 	}
 }
 
@@ -4341,11 +4340,10 @@ xfs_iext_irec_init(
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 
-	erp = (xfs_ext_irec_t *)
-		kmem_alloc(sizeof(xfs_ext_irec_t), KM_SLEEP);
+	erp = kmem_alloc(sizeof(xfs_ext_irec_t), KM_NOFS);
 
 	if (nextents == 0) {
-		ifp->if_u1.if_extents = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
+		ifp->if_u1.if_extents = kmem_alloc(XFS_IEXT_BUFSZ, KM_NOFS);
 	} else if (!ifp->if_real_bytes) {
 		xfs_iext_inline_to_direct(ifp, XFS_IEXT_BUFSZ);
 	} else if (ifp->if_real_bytes < XFS_IEXT_BUFSZ) {
@@ -4393,7 +4391,7 @@ xfs_iext_irec_new(
 
 	/* Initialize new extent record */
 	erp = ifp->if_u1.if_ext_irec;
-	erp[erp_idx].er_extbuf = kmem_alloc(XFS_IEXT_BUFSZ, KM_SLEEP);
+	erp[erp_idx].er_extbuf = kmem_alloc(XFS_IEXT_BUFSZ, KM_NOFS);
 	ifp->if_real_bytes = nlists * XFS_IEXT_BUFSZ;
 	memset(erp[erp_idx].er_extbuf, 0, XFS_IEXT_BUFSZ);
 	erp[erp_idx].er_extcount = 0;
-- 
1.5.6
