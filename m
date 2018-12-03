Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36460 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbeLCWZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 17:25:11 -0500
Received: from ip-64-134-180-251.public.wayport.net ([64.134.180.251] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTweM-0004sH-Qr
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 22:25:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/11] xfs: don't use delalloc extents for COW on files with extsize hints
Date: Mon,  3 Dec 2018 17:24:58 -0500
Message-Id: <20181203222503.30649-7-hch@lst.de>
In-Reply-To: <20181203222503.30649-1-hch@lst.de>
References: <20181203222503.30649-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

While using delalloc for extsize hints is generally a good idea, the
current code that does so only for COW doesn't help us much and creates
a lot of special cases.  Switch it to use real allocations like we
do for direct I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   | 28 +++++++++++++++++-----------
 fs/xfs/xfs_reflink.c |  5 ++++-
 fs/xfs/xfs_reflink.h |  5 ++---
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9f1fd224bb06..d851abac16a9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1039,22 +1039,28 @@ xfs_file_iomap_begin(
 	 * been done up front, so we don't need to do them here.
 	 */
 	if (xfs_is_reflink_inode(ip)) {
+		struct xfs_bmbt_irec	orig = imap;
+
 		/* if zeroing doesn't need COW allocation, then we are done. */
 		if ((flags & IOMAP_ZERO) &&
 		    !needs_cow_for_zeroing(&imap, nimaps))
 			goto out_found;
 
-		if (flags & IOMAP_DIRECT) {
-			/* may drop and re-acquire the ilock */
-			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
-					&lockmode);
-			if (error)
-				goto out_unlock;
-		} else {
-			error = xfs_reflink_reserve_cow(ip, &imap);
-			if (error)
-				goto out_unlock;
-		}
+		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode,
+						 flags);
+		if (error)
+			goto out_unlock;
+
+		/*
+		 * For buffered writes we need to report the address of the
+		 * previous block (if there was any) so that the higher level
+		 * write code can perform read-modify-write operations.  For
+		 * direct I/O code, which must be block aligned we need to
+		 * report the newly allocated address.
+		 */
+		if (!(flags & IOMAP_DIRECT) &&
+		    orig.br_startblock != HOLESTARTBLOCK)
+			imap = orig;
 
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a8c32632090c..bdbaff1b3fb7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -397,7 +397,8 @@ xfs_reflink_allocate_cow(
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	bool			*shared,
-	uint			*lockmode)
+	uint			*lockmode,
+	unsigned		flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = imap->br_startoff;
@@ -471,6 +472,8 @@ xfs_reflink_allocate_cow(
 	if (nimaps == 0)
 		return -ENOSPC;
 convert:
+	if (!(flags & IOMAP_DIRECT))
+		return 0;
 	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
 
 out_unreserve:
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 6d73daef1f13..d76fc520cac8 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -12,10 +12,9 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 
-extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
 extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
+		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
+		unsigned flags);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 
-- 
2.19.1
