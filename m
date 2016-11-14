Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49539 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933664AbcKNRN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:13:27 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6Kow-0005bF-6r
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:13:26 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/14] xfs: cleanup xfs_reflink_find_cow_mapping
Date: Mon, 14 Nov 2016 18:12:40 +0100
Message-Id: <1479143565-30615-10-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use xfs_iext_lookup_extent to look up the extent, drop a useless check,
drop a unneeded return value and clean up the general style a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c    | 16 ++++++++--------
 fs/xfs/xfs_reflink.c | 30 +++++++++---------------------
 fs/xfs/xfs_reflink.h |  2 +-
 3 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index dd6cacf..ab266d6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -777,7 +777,7 @@ xfs_map_cow(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_bmbt_irec	imap;
-	bool			is_cow = false, need_alloc = false;
+	bool			is_cow = false;
 	int			error;
 
 	/*
@@ -795,7 +795,7 @@ xfs_map_cow(
 	 * Else we need to check if there is a COW mapping at this offset.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
+	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (!is_cow)
@@ -805,7 +805,7 @@ xfs_map_cow(
 	 * And if the COW mapping has a delayed extent here we need to
 	 * allocate real space for it now.
 	 */
-	if (need_alloc) {
+	if (isnullstartblock(imap.br_startblock)) {
 		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK, offset,
 				&imap);
 		if (error)
@@ -1311,7 +1311,6 @@ __xfs_get_blocks(
 	ssize_t			size;
 	int			new = 0;
 	bool			is_cow = false;
-	bool			need_alloc = false;
 
 	BUG_ON(create && !direct);
 
@@ -1337,9 +1336,11 @@ __xfs_get_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	if (create && direct && xfs_is_reflink_inode(ip))
-		is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap,
-					&need_alloc);
+	if (create && direct && xfs_is_reflink_inode(ip)) {
+		is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap);
+		ASSERT(!is_cow || !isnullstartblock(imap.br_startblock));
+	}
+
 	if (!is_cow) {
 		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 					&imap, &nimaps, XFS_BMAPI_ENTIRE);
@@ -1356,7 +1357,6 @@ __xfs_get_blocks(
 			xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb,
 					&imap);
 	}
-	ASSERT(!need_alloc);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 35e02ce..6056fd1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -427,37 +427,25 @@ bool
 xfs_reflink_find_cow_mapping(
 	struct xfs_inode		*ip,
 	xfs_off_t			offset,
-	struct xfs_bmbt_irec		*imap,
-	bool				*need_alloc)
+	struct xfs_bmbt_irec		*imap)
 {
-	struct xfs_bmbt_irec		irec;
-	struct xfs_ifork		*ifp;
-	struct xfs_bmbt_rec_host	*gotp;
-	xfs_fileoff_t			bno;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	xfs_fileoff_t			offset_fsb;
+	struct xfs_bmbt_irec		got;
 	xfs_extnum_t			idx;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(xfs_is_reflink_inode(ip));
 
-	/* Find the extent in the CoW fork. */
-	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
-	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
-	if (!gotp)
+	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
+	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
 		return false;
-
-	xfs_bmbt_get_all(gotp, &irec);
-	if (bno >= irec.br_startoff + irec.br_blockcount ||
-	    bno < irec.br_startoff)
+	if (got.br_startoff > offset_fsb)
 		return false;
 
 	trace_xfs_reflink_find_cow_mapping(ip, offset, 1, XFS_IO_OVERWRITE,
-			&irec);
-
-	/* If it's still delalloc, we must allocate later. */
-	*imap = irec;
-	*need_alloc = !!(isnullstartblock(irec.br_startblock));
-
+			&got);
+	*imap = got;
 	return true;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 97ea9b4..cff5fc3 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -31,7 +31,7 @@ extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
 extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
 		xfs_off_t offset, xfs_off_t count);
 extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
-		struct xfs_bmbt_irec *imap, bool *need_alloc);
+		struct xfs_bmbt_irec *imap);
 extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
-- 
2.1.4

