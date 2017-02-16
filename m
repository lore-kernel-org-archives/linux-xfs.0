Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51954 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932975AbdBPVVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 16:21:19 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ceTUL-0007g7-KG
        for linux-xfs@vger.kernel.org; Thu, 16 Feb 2017 21:21:18 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] xfs: simplify xfs_rtallocate_extent
Date: Thu, 16 Feb 2017 22:21:09 +0100
Message-Id: <20170216212110.4370-2-hch@lst.de>
In-Reply-To: <20170216212110.4370-1-hch@lst.de>
References: <20170216212110.4370-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We can deduce the allocation type from the bno argument, and do the
return without prod much simpler internally.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 13 ++++---------
 fs/xfs/xfs_rtalloc.c   | 27 ++++++++-------------------
 fs/xfs/xfs_rtalloc.h   |  1 -
 3 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7c3bfafffba8..c85dafed13c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -88,7 +88,6 @@ int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
-	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
 	int		error;		/* error return value */
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_extlen_t	prod = 0;	/* product factor for allocators */
@@ -155,18 +154,14 @@ xfs_bmap_rtalloc(
 	/*
 	 * Realtime allocation, done through xfs_rtallocate_extent.
 	 */
-	atype = ap->blkno == 0 ?  XFS_ALLOCTYPE_ANY_AG : XFS_ALLOCTYPE_NEAR_BNO;
 	do_div(ap->blkno, mp->m_sb.sb_rextsize);
 	rtb = ap->blkno;
 	ap->length = ralen;
-	if ((error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
-				&ralen, atype, ap->wasdel, prod, &rtb)))
-		return error;
-	if (rtb == NULLFSBLOCK && prod > 1 &&
-	    (error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1,
-					   ap->length, &ralen, atype,
-					   ap->wasdel, 1, &rtb)))
+	error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
+				&ralen, ap->wasdel, prod, &rtb);
+	if (error)
 		return error;
+
 	ap->blkno = rtb;
 	if (ap->blkno != NULLFSBLOCK) {
 		ap->blkno *= mp->m_sb.sb_rextsize;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 802bcc326d9f..0b04846e3f60 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1093,7 +1093,6 @@ xfs_rtallocate_extent(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_alloctype_t	type,		/* allocation type XFS_ALLOCTYPE... */
 	int		wasdel,		/* was a delayed allocation extent */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -1106,7 +1105,7 @@ xfs_rtallocate_extent(
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
-
+	
 	/*
 	 * If prod is set then figure out what to do to minlen and maxlen.
 	 */
@@ -1123,29 +1122,15 @@ xfs_rtallocate_extent(
 		}
 	}
 
+retry:
 	sumbp = NULL;
-	/*
-	 * Allocate by size, or near another block, or exactly at some block.
-	 */
-	switch (type) {
-	case XFS_ALLOCTYPE_ANY_AG:
+	if (bno == 0) {
 		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
 				&sumbp,	&sb, prod, &r);
-		break;
-	case XFS_ALLOCTYPE_NEAR_BNO:
+	} else {
 		error = xfs_rtallocate_extent_near(mp, tp, bno, minlen, maxlen,
 				len, &sumbp, &sb, prod, &r);
-		break;
-	case XFS_ALLOCTYPE_THIS_BNO:
-		error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen,
-				len, &sumbp, &sb, prod, &r);
-		break;
-	default:
-		error = -EIO;
-		ASSERT(0);
 	}
-	if (error)
-		return error;
 
 	/*
 	 * If it worked, update the superblock.
@@ -1158,7 +1143,11 @@ xfs_rtallocate_extent(
 			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FREXTENTS, -slen);
 		else
 			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -slen);
+	} else if (prod > 1) {
+		prod = 1;
+		goto retry;
 	}
+
 	*rtblock = r;
 	return 0;
 }
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 355dd9e1cb64..18c8e821a0e4 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -40,7 +40,6 @@ xfs_rtallocate_extent(
 	xfs_extlen_t		minlen,	/* minimum length to allocate */
 	xfs_extlen_t		maxlen,	/* maximum length to allocate */
 	xfs_extlen_t		*len,	/* out: actual length allocated */
-	xfs_alloctype_t		type,	/* allocation type XFS_ALLOCTYPE... */
 	int			wasdel,	/* was a delayed allocation extent */
 	xfs_extlen_t		prod,	/* extent product factor */
 	xfs_rtblock_t		*rtblock); /* out: start block allocated */
-- 
2.11.0

