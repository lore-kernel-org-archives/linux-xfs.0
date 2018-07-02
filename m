Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbeGBO6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/22] xfs: remove the now unused XFS_BMAPI_IGSTATE flag
Date: Mon,  2 Jul 2018 08:58:02 -0600
Message-Id: <20180702145813.22496-12-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++----
 fs/xfs/libxfs/xfs_bmap.h | 3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7205268b30bc..68ea1f4b9c3f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3788,8 +3788,7 @@ xfs_bmapi_update_map(
 		   mval[-1].br_startblock != HOLESTARTBLOCK &&
 		   mval->br_startblock == mval[-1].br_startblock +
 					  mval[-1].br_blockcount &&
-		   ((flags & XFS_BMAPI_IGSTATE) ||
-			mval[-1].br_state == mval->br_state)) {
+		   mval[-1].br_state == mval->br_state) {
 		ASSERT(mval->br_startoff ==
 		       mval[-1].br_startoff + mval[-1].br_blockcount);
 		mval[-1].br_blockcount += mval->br_blockcount;
@@ -3834,7 +3833,7 @@ xfs_bmapi_read(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
-			   XFS_BMAPI_IGSTATE|XFS_BMAPI_COWFORK)));
+			   XFS_BMAPI_COWFORK)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
@@ -4279,7 +4278,6 @@ xfs_bmapi_write(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
-	ASSERT(!(flags & XFS_BMAPI_IGSTATE));
 	ASSERT(tp != NULL ||
 	       (flags & (XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK)) ==
 			(XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK));
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 9b49ddf99c41..44639588d1c7 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -68,8 +68,6 @@ struct xfs_extent_free_item
 #define XFS_BMAPI_METADATA	0x002	/* mapping metadata not user data */
 #define XFS_BMAPI_ATTRFORK	0x004	/* use attribute fork not data */
 #define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
-#define XFS_BMAPI_IGSTATE	0x010	/* Ignore state - */
-					/* combine contig. space */
 #define XFS_BMAPI_CONTIG	0x020	/* must allocate only one extent */
 /*
  * unwritten extent conversion - this needs write cache flushing and no additional
@@ -116,7 +114,6 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
 	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
-	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
-- 
2.18.0

