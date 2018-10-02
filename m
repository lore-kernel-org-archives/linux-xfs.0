Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbeJCA0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 20:26:39 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g7OgT-0007ds-5O
        for linux-xfs@vger.kernel.org; Tue, 02 Oct 2018 17:42:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfs: handle zeroing in xfs_file_iomap_begin_delay
Date: Tue,  2 Oct 2018 10:42:03 -0700
Message-Id: <20181002174207.25275-5-hch@lst.de>
In-Reply-To: <20181002174207.25275-1-hch@lst.de>
References: <20181002174207.25275-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We only need to allocate blocks for zeroing for reflink inodes,
and for we currently have a special case for reflink files in
the otherwise direct I/O path that I'd like to get rid of.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6320aca39f39..9b572a1fbd42 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -62,6 +62,21 @@ xfs_bmbt_to_iomap(
 	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
 }
 
+static void
+xfs_hole_to_iomap(
+	struct xfs_inode	*ip,
+	struct iomap		*iomap,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	iomap->addr = IOMAP_NULL_ADDR;
+	iomap->type = IOMAP_HOLE;
+	iomap->offset = XFS_FSB_TO_B(ip->i_mount, offset_fsb);
+	iomap->length = XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb);
+	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
+	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+}
+
 xfs_extlen_t
 xfs_eof_alignment(
 	struct xfs_inode	*ip,
@@ -502,6 +517,7 @@ xfs_file_iomap_begin_delay(
 	struct inode		*inode,
 	loff_t			offset,
 	loff_t			count,
+	unsigned		flags,
 	struct iomap		*iomap)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -538,13 +554,23 @@ xfs_file_iomap_begin_delay(
 			goto out_unlock;
 	}
 
+	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
+
 	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
-	if (!eof && got.br_startoff <= offset_fsb) {
-		if (xfs_is_reflink_inode(ip)) {
+	if (eof)
+		got.br_startoff = end_fsb; /* fake hole until the end */
+
+	if (got.br_startoff <= offset_fsb) {
+		/*
+		 * For reflink files we may need a delalloc reservation when
+		 * overwriting shared extents.   This includes zeroing of
+		 * existing extents that contain data.
+		 */
+		if (xfs_is_reflink_inode(ip) &&
+		    ((flags & IOMAP_WRITE) ||
+		     got.br_state != XFS_EXT_UNWRITTEN)) {
 			bool		shared;
 
-			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
-					maxbytes_fsb);
 			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
 			error = xfs_reflink_reserve_cow(ip, &got, &shared);
 			if (error)
@@ -555,6 +581,11 @@ xfs_file_iomap_begin_delay(
 		goto done;
 	}
 
+	if (flags & IOMAP_ZERO) {
+		xfs_hole_to_iomap(ip, iomap, offset_fsb, got.br_startoff);
+		goto out_unlock;
+	}
+
 	error = xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		goto out_unlock;
@@ -1009,10 +1040,11 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
+	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && !(flags & IOMAP_DIRECT) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
-		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
+		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
+				iomap);
 	}
 
 	/*
-- 
2.19.0
