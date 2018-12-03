Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36456 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeLCWZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 17:25:10 -0500
Received: from ip-64-134-180-251.public.wayport.net ([64.134.180.251] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTweL-0004gS-Sx
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 22:25:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/11] xfs: make xfs_bmbt_to_iomap more useful
Date: Mon,  3 Dec 2018 17:24:57 -0500
Message-Id: <20181203222503.30649-6-hch@lst.de>
In-Reply-To: <20181203222503.30649-1-hch@lst.de>
References: <20181203222503.30649-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Move checking for invalid zero blocks and setting of various iomap flags
into this helper.  Also make it deal with "raw" delalloc extents to
avoid clutter in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 84 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_iomap.h |  4 +--
 fs/xfs/xfs_pnfs.c  |  2 +-
 3 files changed, 41 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6acfed2ae858..9f1fd224bb06 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -35,18 +35,40 @@
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
 						<< mp->m_writeio_log)
 
-void
+static int
+xfs_alert_fsblock_zero(
+	xfs_inode_t	*ip,
+	xfs_bmbt_irec_t	*imap)
+{
+	xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
+			"Access to block zero in inode %llu "
+			"start_block: %llx start_off: %llx "
+			"blkcnt: %llx extent-state: %x",
+		(unsigned long long)ip->i_ino,
+		(unsigned long long)imap->br_startblock,
+		(unsigned long long)imap->br_startoff,
+		(unsigned long long)imap->br_blockcount,
+		imap->br_state);
+	return -EFSCORRUPTED;
+}
+
+int
 xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
 	struct iomap		*iomap,
-	struct xfs_bmbt_irec	*imap)
+	struct xfs_bmbt_irec	*imap,
+	bool			shared)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
+	if (unlikely(!imap->br_startblock && !XFS_IS_REALTIME_INODE(ip)))
+		return xfs_alert_fsblock_zero(ip, imap);
+
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->addr = IOMAP_NULL_ADDR;
 		iomap->type = IOMAP_HOLE;
-	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
+	} else if (imap->br_startblock == DELAYSTARTBLOCK ||
+		   isnullstartblock(imap->br_startblock)) {
 		iomap->addr = IOMAP_NULL_ADDR;
 		iomap->type = IOMAP_DELALLOC;
 	} else {
@@ -60,6 +82,13 @@ xfs_bmbt_to_iomap(
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
 	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+
+	if (xfs_ipincount(ip) &&
+	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		iomap->flags |= IOMAP_F_DIRTY;
+	if (shared)
+		iomap->flags |= IOMAP_F_SHARED;
+	return 0;
 }
 
 static void
@@ -138,23 +167,6 @@ xfs_iomap_eof_align_last_fsb(
 	return 0;
 }
 
-STATIC int
-xfs_alert_fsblock_zero(
-	xfs_inode_t	*ip,
-	xfs_bmbt_irec_t	*imap)
-{
-	xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
-			"Access to block zero in inode %llu "
-			"start_block: %llx start_off: %llx "
-			"blkcnt: %llx extent-state: %x",
-		(unsigned long long)ip->i_ino,
-		(unsigned long long)imap->br_startblock,
-		(unsigned long long)imap->br_startoff,
-		(unsigned long long)imap->br_blockcount,
-		imap->br_state);
-	return -EFSCORRUPTED;
-}
-
 int
 xfs_iomap_write_direct(
 	xfs_inode_t	*ip,
@@ -649,17 +661,7 @@ xfs_file_iomap_begin_delay(
 	iomap->flags |= IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &got);
 done:
-	if (isnullstartblock(got.br_startblock))
-		got.br_startblock = DELAYSTARTBLOCK;
-
-	if (!got.br_startblock) {
-		error = xfs_alert_fsblock_zero(ip, &got);
-		if (error)
-			goto out_unlock;
-	}
-
-	xfs_bmbt_to_iomap(ip, iomap, &got);
-
+	error = xfs_bmbt_to_iomap(ip, iomap, &got, false);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
@@ -1097,15 +1099,7 @@ xfs_file_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
-	if (xfs_ipincount(ip) && (ip->i_itemp->ili_fsync_fields
-				& ~XFS_ILOG_TIMESTAMP))
-		iomap->flags |= IOMAP_F_DIRTY;
-
-	xfs_bmbt_to_iomap(ip, iomap, &imap);
-
-	if (shared)
-		iomap->flags |= IOMAP_F_SHARED;
-	return 0;
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 
 out_found:
 	ASSERT(nimaps);
@@ -1228,12 +1222,10 @@ xfs_xattr_iomap_begin(
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 
-	if (!error) {
-		ASSERT(nimaps);
-		xfs_bmbt_to_iomap(ip, iomap, &imap);
-	}
-
-	return error;
+	if (error)
+		return error;
+	ASSERT(nimaps);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, false);
 }
 
 const struct iomap_ops xfs_xattr_iomap_ops = {
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index c6170548831b..ed27e41b687c 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -17,8 +17,8 @@ int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
 			struct xfs_bmbt_irec *, unsigned int *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
-void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
-		struct xfs_bmbt_irec *);
+int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
+		struct xfs_bmbt_irec *, bool shared);
 xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
 static inline xfs_filblks_t
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f44c3599527d..bde2c9f56a46 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -185,7 +185,7 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-	xfs_bmbt_to_iomap(ip, iomap, &imap);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-- 
2.19.1
