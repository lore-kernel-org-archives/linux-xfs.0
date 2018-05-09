Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933815AbeEIHtj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:49:39 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/33] xfs: remove the now unused XFS_BMAPI_IGSTATE flag
Date: Wed,  9 May 2018 09:48:15 +0200
Message-Id: <20180509074830.16196-19-hch@lst.de>
In-Reply-To: <20180509074830.16196-1-hch@lst.de>
References: <20180509074830.16196-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++----
 fs/xfs/libxfs/xfs_bmap.h | 3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a7c2f03ea11..30a2242a1eba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3785,8 +3785,7 @@ xfs_bmapi_update_map(
 		   mval[-1].br_startblock != HOLESTARTBLOCK &&
 		   mval->br_startblock == mval[-1].br_startblock +
 					  mval[-1].br_blockcount &&
-		   ((flags & XFS_BMAPI_IGSTATE) ||
-			mval[-1].br_state == mval->br_state)) {
+		   mval[-1].br_state == mval->br_state) {
 		ASSERT(mval->br_startoff ==
 		       mval[-1].br_startoff + mval[-1].br_blockcount);
 		mval[-1].br_blockcount += mval->br_blockcount;
@@ -3831,7 +3830,7 @@ xfs_bmapi_read(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
-			   XFS_BMAPI_IGSTATE|XFS_BMAPI_COWFORK)));
+			   XFS_BMAPI_COWFORK)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
@@ -4275,7 +4274,6 @@ xfs_bmapi_write(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
-	ASSERT(!(flags & XFS_BMAPI_IGSTATE));
 	ASSERT(tp != NULL ||
 	       (flags & (XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK)) ==
 			(XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK));
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2b766b37096d..2c6da709a521 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -79,8 +79,6 @@ struct xfs_extent_free_item
 #define XFS_BMAPI_METADATA	0x002	/* mapping metadata not user data */
 #define XFS_BMAPI_ATTRFORK	0x004	/* use attribute fork not data */
 #define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
-#define XFS_BMAPI_IGSTATE	0x010	/* Ignore state - */
-					/* combine contig. space */
 #define XFS_BMAPI_CONTIG	0x020	/* must allocate only one extent */
 /*
  * unwritten extent conversion - this needs write cache flushing and no additional
@@ -121,7 +119,6 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
 	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
-	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
-- 
2.17.0

