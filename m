Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfAaHza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 02:55:30 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/11] FOLD: improve xfs_bmapi_delalloc
Date: Thu, 31 Jan 2019 08:55:14 +0100
Message-Id: <20190131075524.4769-2-hch@lst.de>
In-Reply-To: <20190131075524.4769-1-hch@lst.de>
References: <20190131075524.4769-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Give it a more descriptive name, and remove a couple of parameters that
are better derived internally instead of burdening it on the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 24 ++++++++++++++++--------
 fs/xfs/libxfs/xfs_bmap.h |  5 +++--
 fs/xfs/xfs_iomap.c       | 14 ++------------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3229a82de1fb..65940b79019a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4477,21 +4477,29 @@ xfs_bmapi_write(
  * is not available.
  */
 int
-xfs_bmapi_delalloc(
+xfs_bmapi_convert_delalloc(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		bno,
-	int			flags,
-	xfs_extlen_t		total,
-	struct xfs_bmbt_irec	*imap,
-	int			*nimaps)
+	int			whichfork,
+	xfs_fileoff_t		offset_fsb,
+	struct xfs_bmbt_irec	*imap)
 {
+	int			flags = XFS_BMAPI_DELALLOC, nimaps = 1, error;
+
+	if (whichfork == XFS_COW_FORK)
+		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+
 	/*
-	 * The reval flag means to allocate the entire extent; pass a dummy
+	 * The DELALLOC flag always allocates the entire extent; pass a dummy
 	 * length of 1.
 	 */
 	flags |= XFS_BMAPI_DELALLOC;
-	return xfs_bmapi_write(tp, ip, bno, 1, flags, total, imap, nimaps);
+	error = xfs_bmapi_write(tp, ip, offset_fsb, 1, flags,
+			XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK),
+			imap, &nimaps);
+	if (!error && !nimaps)
+		error = -EFSCORRUPTED;
+	return error;
 }
 
 int
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 4e8bd2837cb0..c385987251cd 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -227,8 +227,9 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
 		int eof);
-int	xfs_bmapi_delalloc(struct xfs_trans *, struct xfs_inode *,
-		xfs_fileoff_t, int, xfs_extlen_t, struct xfs_bmbt_irec *, int *);
+int	xfs_bmapi_convert_delalloc(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork, xfs_fileoff_t offset_fsb,
+		struct xfs_bmbt_irec *imap);
 
 static inline void
 xfs_bmap_add_free(
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 066c2120f0ba..9849c3a5a435 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -689,14 +689,7 @@ xfs_iomap_write_allocate(
 	xfs_fileoff_t		map_start_fsb;
 	xfs_extlen_t		map_count_fsb;
 	struct xfs_trans	*tp;
-	int			nimaps;
 	int			error = 0;
-	int			flags = XFS_BMAPI_DELALLOC;
-	int			nres;
-
-	if (whichfork == XFS_COW_FORK)
-		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
-	nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 
 	/*
 	 * Make sure that the dquots are there.
@@ -744,11 +737,8 @@ xfs_iomap_write_allocate(
 		 * caller. We'll trim it down to the caller's most recently
 		 * validated range before we return.
 		 */
-		nimaps = 1;
-		error = xfs_bmapi_delalloc(tp, ip, offset_fsb, flags, nres,
-					   imap, &nimaps);
-		if (nimaps == 0)
-			error = -EFSCORRUPTED;
+		error = xfs_bmapi_convert_delalloc(tp, ip, whichfork,
+				offset_fsb, imap);
 		if (error)
 			goto trans_cancel;
 
-- 
2.20.1
