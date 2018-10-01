Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbeJATPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 15:15:22 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g6xSL-0004JL-7c
        for linux-xfs@vger.kernel.org; Mon, 01 Oct 2018 12:37:45 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] xfs: remove the unused shared argument to xfs_reflink_reserve_cow
Date: Mon,  1 Oct 2018 05:37:38 -0700
Message-Id: <20181001123741.32005-5-hch@lst.de>
In-Reply-To: <20181001123741.32005-1-hch@lst.de>
References: <20181001123741.32005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   |  6 ++----
 fs/xfs/xfs_reflink.c | 12 +++++-------
 fs/xfs/xfs_reflink.h |  2 +-
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7cbebcf61fa7..8ba97e67b474 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -561,12 +561,10 @@ xfs_file_iomap_begin_delay(
 		if (xfs_is_reflink_inode(ip) &&
 		    ((flags & IOMAP_WRITE) ||
 		     got.br_state != XFS_EXT_UNWRITTEN)) {
-			bool		shared;
-
 			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
 					maxbytes_fsb);
 			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
-			error = xfs_reflink_reserve_cow(ip, &got, &shared);
+			error = xfs_reflink_reserve_cow(ip, &got);
 			if (error)
 				goto out_unlock;
 		}
@@ -1091,7 +1089,7 @@ xfs_file_iomap_begin(
 			if (error)
 				goto out_unlock;
 		} else {
-			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
+			error = xfs_reflink_reserve_cow(ip, &imap);
 			if (error)
 				goto out_unlock;
 		}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5289e22cb081..06e38e88ddee 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -241,7 +241,7 @@ xfs_reflink_trim_around_shared(
 /*
  * Trim the passed in imap to the next shared/unshared extent boundary, and
  * if imap->br_startoff points to a shared extent reserve space for it in the
- * COW fork.  In this case *shared is set to true, else to false.
+ * COW fork.
  *
  * Note that imap will always contain the block numbers for the existing blocks
  * in the data fork, as the upper layers need them for read-modify-write
@@ -250,14 +250,14 @@ xfs_reflink_trim_around_shared(
 int
 xfs_reflink_reserve_cow(
 	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*imap,
-	bool			*shared)
+	struct xfs_bmbt_irec	*imap)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec	got;
 	int			error = 0;
 	bool			eof = false, trimmed;
 	struct xfs_iext_cursor	icur;
+	bool			shared;
 
 	/*
 	 * Search the COW fork extent list first.  This serves two purposes:
@@ -273,18 +273,16 @@ xfs_reflink_reserve_cow(
 	if (!eof && got.br_startoff <= imap->br_startoff) {
 		trace_xfs_reflink_cow_found(ip, imap);
 		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
-
-		*shared = true;
 		return 0;
 	}
 
 	/* Trim the mapping to the nearest shared extent boundary. */
-	error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+	error = xfs_reflink_trim_around_shared(ip, imap, &shared, &trimmed);
 	if (error)
 		return error;
 
 	/* Not shared?  Just report the (potentially capped) extent. */
-	if (!*shared)
+	if (!shared)
 		return 0;
 
 	/*
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c585ad9552b2..b77f4079022a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -13,7 +13,7 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
 
 extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap, bool *shared);
+		struct xfs_bmbt_irec *imap);
 extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
-- 
2.19.0
