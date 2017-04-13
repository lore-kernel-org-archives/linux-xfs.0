Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdDMIGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:06:04 -0400
Received: from 212095007060.public.telering.at ([212.95.7.60] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyZlS-0007es-Vx
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 08:06:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] xfs: remove xfs_bmap_alloc
Date: Thu, 13 Apr 2017 10:05:17 +0200
Message-Id: <20170413080517.12564-11-hch@lst.de>
In-Reply-To: <20170413080517.12564-1-hch@lst.de>
References: <20170413080517.12564-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Just opencode it in the only caller to make the code flow easier to
follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.c  | 22 ++++++----------------
 fs/xfs/libxfs/xfs_bmap.h  |  2 +-
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7486401ccbd3..02326142ccb0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2606,7 +2606,7 @@ xfs_alloc_vextent(
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
-	 * that out (xfs_bmap_alloc).
+	 * that out (xfs_bmap_btalloc).
 	 */
 	agsize = mp->m_sb.sb_agblocks;
 	if (args->maxlen > agsize)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9e3f0e6a9062..8e94030bcb8f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3842,20 +3842,6 @@ xfs_bmap_btalloc(
 	return 0;
 }
 
-/*
- * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
- * It figures out where to ask the underlying allocator to put the new extent.
- */
-STATIC int
-xfs_bmap_alloc(
-	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
-{
-	if (XFS_IS_REALTIME_INODE(ap->ip) &&
-	    xfs_alloc_is_userdata(ap->datatype))
-		return xfs_bmap_rtalloc(ap);
-	return xfs_bmap_btalloc(ap);
-}
-
 /* Trim extent to fit a logical block range. */
 void
 xfs_trim_extent(
@@ -4273,7 +4259,11 @@ xfs_bmapi_allocate(
 			return error;
 	}
 
-	error = xfs_bmap_alloc(bma);
+	if (XFS_IS_REALTIME_INODE(bma->ip) &&
+	    xfs_alloc_is_userdata(bma->datatype))
+		error = xfs_bmap_rtalloc(bma);
+	else
+		error = xfs_bmap_btalloc(bma);
 	if (error)
 		return error;
 
@@ -4451,7 +4441,7 @@ xfs_bmapi_write(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
-	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
+	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_*alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	bool			eof = false;	/* after the end of extents */
 	int			error;		/* error return */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f35a2b2c4f06..6de7d321f8a2 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -28,7 +28,7 @@ struct xfs_trans;
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
 /*
- * Argument structure for xfs_bmap_alloc.
+ * Argument structure for xfs_bmap_*alloc.
  */
 struct xfs_bmalloca {
 	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-- 
2.11.0

