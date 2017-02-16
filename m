Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35350 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932975AbdBPVVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 16:21:21 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ceTUO-0007gK-Nq
        for linux-xfs@vger.kernel.org; Thu, 16 Feb 2017 21:21:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: remove XFS_ALLOCTYPE_ANY_AG and XFS_ALLOCTYPE_START_AG
Date: Thu, 16 Feb 2017 22:21:10 +0100
Message-Id: <20170216212110.4370-3-hch@lst.de>
In-Reply-To: <20170216212110.4370-1-hch@lst.de>
References: <20170216212110.4370-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS_ALLOCTYPE_ANY_AG  was only used for the RT allocator and is unused now,
and XFS_ALLOCTYPE_START_AG has been unused for a while.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 16 ++--------------
 fs/xfs/libxfs/xfs_alloc.h |  4 ----
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fe98fbc4adf1..369adcc18c02 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2664,21 +2664,11 @@ xfs_alloc_vextent(
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		args->type = XFS_ALLOCTYPE_NEAR_BNO;
 		/* FALLTHROUGH */
-	case XFS_ALLOCTYPE_ANY_AG:
-	case XFS_ALLOCTYPE_START_AG:
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
 		 */
-		if (type == XFS_ALLOCTYPE_ANY_AG) {
-			/*
-			 * Start with the last place we left off.
-			 */
-			args->agno = sagno = (mp->m_agfrotor / rotorstep) %
-					mp->m_sb.sb_agcount;
-			args->type = XFS_ALLOCTYPE_THIS_AG;
-			flags = XFS_ALLOC_FLAG_TRYLOCK;
-		} else if (type == XFS_ALLOCTYPE_FIRST_AG) {
+		if (type == XFS_ALLOCTYPE_FIRST_AG) {
 			/*
 			 * Start with allocation group given by bno.
 			 */
@@ -2687,8 +2677,6 @@ xfs_alloc_vextent(
 			sagno = 0;
 			flags = 0;
 		} else {
-			if (type == XFS_ALLOCTYPE_START_AG)
-				args->type = XFS_ALLOCTYPE_THIS_AG;
 			/*
 			 * Start with the given allocation group.
 			 */
@@ -2756,7 +2744,7 @@ xfs_alloc_vextent(
 			}
 			xfs_perag_put(args->pag);
 		}
-		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
+		if (bump_rotor) {
 			if (args->agno == sagno)
 				mp->m_agfrotor = (mp->m_agfrotor + 1) %
 					(mp->m_sb.sb_agcount * rotorstep);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 1d0f48a501a3..2a8d0fa6fbbe 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -29,9 +29,7 @@ extern struct workqueue_struct *xfs_alloc_wq;
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
-#define XFS_ALLOCTYPE_ANY_AG	0x01	/* allocate anywhere, use rotor */
 #define XFS_ALLOCTYPE_FIRST_AG	0x02	/* ... start at ag 0 */
-#define XFS_ALLOCTYPE_START_AG	0x04	/* anywhere, start in this a.g. */
 #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
 #define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
 #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
@@ -41,9 +39,7 @@ extern struct workqueue_struct *xfs_alloc_wq;
 typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
-	{ XFS_ALLOCTYPE_ANY_AG,		"ANY_AG" }, \
 	{ XFS_ALLOCTYPE_FIRST_AG,	"FIRST_AG" }, \
-	{ XFS_ALLOCTYPE_START_AG,	"START_AG" }, \
 	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
 	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
 	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
-- 
2.11.0

