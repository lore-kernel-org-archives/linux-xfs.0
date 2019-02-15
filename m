Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfBOOrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 09:47:41 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/10] xfs: move transaction handling to xfs_bmapi_convert_delalloc
Date: Fri, 15 Feb 2019 15:47:21 +0100
Message-Id: <20190215144725.8894-7-hch@lst.de>
In-Reply-To: <20190215144725.8894-1-hch@lst.de>
References: <20190215144725.8894-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

No need to deal with the transaction and the inode locking in the
caller. Note that we also switch to passing whichfork as the second
paramter, matching what most related functions do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 +++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_bmap.h |  5 +++--
 fs/xfs/xfs_iomap.c       | 32 ++++----------------------------
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5fdfa9f55fde..fc4f1d3145c4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4446,16 +4446,30 @@ xfs_bmapi_write(
  */
 int
 xfs_bmapi_convert_delalloc(
-	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		offset_fsb,
 	int			whichfork,
-	struct xfs_bmbt_irec	*imap)
+	xfs_fileoff_t		offset_fsb,
+	struct xfs_bmbt_irec	*imap,
+	unsigned int		*seq)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmalloca	bma = { NULL };
+	struct xfs_trans	*tp;
 	int			error;
 
+	/*
+	 * Space for the extent and indirect blocks was reserved when the
+	 * delalloc extent was created so there's no need to do so here.
+	 */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
 		/*
@@ -4464,7 +4478,8 @@ xfs_bmapi_convert_delalloc(
 		 * might have moved the extent to the data fork in the meantime.
 		 */
 		WARN_ON_ONCE(whichfork != XFS_COW_FORK);
-		return -EAGAIN;
+		error = -EAGAIN;
+		goto out_trans_cancel;
 	}
 
 	/*
@@ -4473,7 +4488,8 @@ xfs_bmapi_convert_delalloc(
 	 */
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		*imap = bma.got;
-		return 0;
+		*seq = READ_ONCE(ifp->if_seq);
+		goto out_trans_cancel;
 	}
 
 	bma.tp = tp;
@@ -4502,6 +4518,7 @@ xfs_bmapi_convert_delalloc(
 
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	*imap = bma.got;
+	*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK) {
 		error = xfs_refcount_alloc_cow_extent(tp, bma.blkno,
@@ -4512,8 +4529,19 @@ xfs_bmapi_convert_delalloc(
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
+	if (error)
+		goto out_finish;
+
+	xfs_bmapi_finish(&bma, whichfork, 0);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
 out_finish:
 	xfs_bmapi_finish(&bma, whichfork, error);
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b5eca7a26949..78b190b6e908 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -223,8 +223,9 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
 		int eof);
-int	xfs_bmapi_convert_delalloc(struct xfs_trans *, struct xfs_inode *,
-		xfs_fileoff_t, int, struct xfs_bmbt_irec *);
+int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
+		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap,
+		unsigned int *seq);
 
 static inline void
 xfs_bmap_add_free(
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index fd3aacd4bf02..39be741cac5a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -684,11 +684,9 @@ xfs_iomap_write_allocate(
 	unsigned int		*seq)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb;
 	xfs_fileoff_t		map_start_fsb;
 	xfs_extlen_t		map_count_fsb;
-	struct xfs_trans	*tp;
 	int			error = 0;
 
 	/*
@@ -716,17 +714,8 @@ xfs_iomap_write_allocate(
 		/*
 		 * Allocate in a loop because it may take several attempts to
 		 * allocate real blocks for a contiguous delalloc extent if free
-		 * space is sufficiently fragmented. Note that space for the
-		 * extent and indirect blocks was reserved when the delalloc
-		 * extent was created so there's no need to do so here.
+		 * space is sufficiently fragmented.
 		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
-					XFS_TRANS_RESERVE, &tp);
-		if (error)
-			return error;
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
 
 		/*
 		 * ilock was dropped since imap was populated which means it
@@ -737,17 +726,10 @@ xfs_iomap_write_allocate(
 		 * caller. We'll trim it down to the caller's most recently
 		 * validated range before we return.
 		 */
-		error = xfs_bmapi_convert_delalloc(tp, ip, offset_fsb,
-						   whichfork, imap);
-		if (error)
-			goto trans_cancel;
-
-		error = xfs_trans_commit(tp);
+		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset_fsb,
+				imap, seq);
 		if (error)
-			goto error0;
-
-		*seq = READ_ONCE(ifp->if_seq);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error;
 
 		/*
 		 * See if we were able to allocate an extent that covers at
@@ -766,12 +748,6 @@ xfs_iomap_write_allocate(
 			return 0;
 		}
 	}
-
-trans_cancel:
-	xfs_trans_cancel(tp);
-error0:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
 }
 
 int
-- 
2.20.1
