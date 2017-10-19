Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754239AbdJSOXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:15 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/16] xfs: update i_size after unwritten conversion in dio completion
Date: Thu, 19 Oct 2017 16:22:48 +0200
Message-Id: <20171019142259.20082-6-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eryu Guan <eguan@redhat.com>

commit ee70daaba82d70766d0723b743d9fdeb3b06102a upstream.

Since commit d531d91d6990 ("xfs: always use unwritten extents for
direct I/O writes"), we start allocating unwritten extents for all
direct writes to allow appending aio in XFS.

But for dio writes that could extend file size we update the in-core
inode size first, then convert the unwritten extents to real
allocations at dio completion time in xfs_dio_write_end_io(). Thus a
racing direct read could see the new i_size and find the unwritten
extents first and read zeros instead of actual data, if the direct
writer also takes a shared iolock.

Fix it by updating the in-core inode size after the unwritten extent
conversion. To do this, introduce a new boolean argument to
xfs_iomap_write_unwritten() to tell if we want to update in-core
i_size or not.

Suggested-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: backported to the old direct I/O code before Linux 4.10]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 25 +++++++++++++++++--------
 fs/xfs/xfs_iomap.c |  7 +++++--
 fs/xfs/xfs_iomap.h |  2 +-
 fs/xfs/xfs_pnfs.c  |  2 +-
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d23889e0bedc..2b9d7c5800ee 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -335,7 +335,8 @@ xfs_end_io(
 		error = xfs_reflink_end_cow(ip, offset, size);
 		break;
 	case XFS_IO_UNWRITTEN:
-		error = xfs_iomap_write_unwritten(ip, offset, size);
+		/* writeback should never update isize */
+		error = xfs_iomap_write_unwritten(ip, offset, size, false);
 		break;
 	default:
 		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
@@ -1532,6 +1533,21 @@ xfs_end_io_direct_write(
 		return 0;
 	}
 
+	if (flags & XFS_DIO_FLAG_COW)
+		error = xfs_reflink_end_cow(ip, offset, size);
+
+	/*
+	 * Unwritten conversion updates the in-core isize after extent
+	 * conversion but before updating the on-disk size. Updating isize any
+	 * earlier allows a racing dio read to find unwritten extents before
+	 * they are converted.
+	 */
+	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
+		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
+
+		return xfs_iomap_write_unwritten(ip, offset, size, true);
+	}
+
 	/*
 	 * We need to update the in-core inode size here so that we don't end up
 	 * with the on-disk inode size being outside the in-core inode size. We
@@ -1548,13 +1564,6 @@ xfs_end_io_direct_write(
 		i_size_write(inode, offset + size);
 	spin_unlock(&ip->i_flags_lock);
 
-	if (flags & XFS_DIO_FLAG_COW)
-		error = xfs_reflink_end_cow(ip, offset, size);
-	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
-		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
-
-		error = xfs_iomap_write_unwritten(ip, offset, size);
-	}
 	if (flags & XFS_DIO_FLAG_APPEND) {
 		trace_xfs_end_io_direct_write_append(ip, offset, size);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 65740d1cbd92..f286f63c430c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -836,7 +836,8 @@ int
 xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
-	xfs_off_t	count)
+	xfs_off_t	count,
+	bool		update_isize)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -847,6 +848,7 @@ xfs_iomap_write_unwritten(
 	xfs_trans_t	*tp;
 	xfs_bmbt_irec_t imap;
 	struct xfs_defer_ops dfops;
+	struct inode	*inode = VFS_I(ip);
 	xfs_fsize_t	i_size;
 	uint		resblks;
 	int		error;
@@ -906,7 +908,8 @@ xfs_iomap_write_unwritten(
 		i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
 		if (i_size > offset + count)
 			i_size = offset + count;
-
+		if (update_isize && i_size > i_size_read(inode))
+			i_size_write(inode, i_size);
 		i_size = xfs_new_eof(ip, i_size);
 		if (i_size) {
 			ip->i_d.di_size = i_size;
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 6d45cf01fcff..d71703af5c76 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -27,7 +27,7 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
 int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
 			struct xfs_bmbt_irec *);
-int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
+int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 93a7aafa56d6..cecd37569ddb 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -279,7 +279,7 @@ xfs_fs_commit_blocks(
 					(end - 1) >> PAGE_SHIFT);
 		WARN_ON_ONCE(error);
 
-		error = xfs_iomap_write_unwritten(ip, start, length);
+		error = xfs_iomap_write_unwritten(ip, start, length, false);
 		if (error)
 			goto out_drop_iolock;
 	}
-- 
2.14.2

