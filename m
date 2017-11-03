Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41245 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdKCOqv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:51 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdFC-00028h-Ax
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:51 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/21] xfs: move xfs_bmbt_irec and xfs_exntst_t to xfs_types.h
Date: Fri,  3 Nov 2017 17:45:39 +0300
Message-Id: <20171103144539.2187-22-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Neither defines an on-disk format, so move them out of xfs_format.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 18 ------------------
 fs/xfs/libxfs/xfs_types.h  | 12 ++++++++++++
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fbe7d3c31345..2e047e76db2f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1577,24 +1577,6 @@ static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
 	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
 }
 
-/*
- * Possible extent states.
- */
-typedef enum {
-	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
-} xfs_exntst_t;
-
-/*
- * Incore version of above.
- */
-typedef struct xfs_bmbt_irec
-{
-	xfs_fileoff_t	br_startoff;	/* starting file offset */
-	xfs_fsblock_t	br_startblock;	/* starting block number */
-	xfs_filblks_t	br_blockcount;	/* number of blocks */
-	xfs_exntst_t	br_state;	/* extent state */
-} xfs_bmbt_irec_t;
-
 /*
  * Key structure for non-leaf levels of the tree.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 983878019097..3c560695c546 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -147,4 +147,16 @@ struct xfs_iext_cursor {
 	int			pos;
 };
 
+typedef enum {
+	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
+} xfs_exntst_t;
+
+typedef struct xfs_bmbt_irec
+{
+	xfs_fileoff_t	br_startoff;	/* starting file offset */
+	xfs_fsblock_t	br_startblock;	/* starting block number */
+	xfs_filblks_t	br_blockcount;	/* number of blocks */
+	xfs_exntst_t	br_state;	/* extent state */
+} xfs_bmbt_irec_t;
+
 #endif	/* __XFS_TYPES_H__ */
-- 
2.14.2

