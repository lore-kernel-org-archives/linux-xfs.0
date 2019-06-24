Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50746 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfFXFx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 01:53:28 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/12] xfs: remove the fork fields in the writepage_ctx and ioend
Date: Mon, 24 Jun 2019 07:52:51 +0200
Message-Id: <20190624055253.31183-11-hch@lst.de>
In-Reply-To: <20190624055253.31183-1-hch@lst.de>
References: <20190624055253.31183-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

In preparation for moving the writeback code to iomap.c, replace the
XFS-specific COW fork concept with the iomap IOMAP_F_SHARED flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 40 +++++++++++++++++++++-------------------
 fs/xfs/xfs_aops.h |  2 +-
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5d302ebe2a33..d9a7a9e6b912 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -28,7 +28,6 @@
  */
 struct xfs_writepage_ctx {
 	struct iomap		iomap;
-	int			fork;
 	unsigned int		data_seq;
 	unsigned int		cow_seq;
 	struct xfs_ioend	*ioend;
@@ -204,7 +203,7 @@ xfs_end_ioend(
 	 */
 	error = blk_status_to_errno(ioend->io_bio->bi_status);
 	if (unlikely(error)) {
-		if (ioend->io_fork == XFS_COW_FORK)
+		if (ioend->io_flags & IOMAP_F_SHARED)
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
 		goto done;
 	}
@@ -212,7 +211,7 @@ xfs_end_ioend(
 	/*
 	 * Success: commit the COW or unwritten blocks if needed.
 	 */
-	if (ioend->io_fork == XFS_COW_FORK)
+	if (ioend->io_flags & IOMAP_F_SHARED)
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
@@ -233,7 +232,8 @@ xfs_ioend_can_merge(
 {
 	if (ioend->io_bio->bi_status != next->io_bio->bi_status)
 		return false;
-	if ((ioend->io_fork == XFS_COW_FORK) ^ (next->io_fork == XFS_COW_FORK))
+	if ((ioend->io_flags & IOMAP_F_SHARED) ^
+	    (next->io_flags & IOMAP_F_SHARED))
 		return false;
 	if ((ioend->io_type == IOMAP_UNWRITTEN) ^
 	    (next->io_type == IOMAP_UNWRITTEN))
@@ -319,7 +319,7 @@ xfs_end_bio(
 	struct xfs_mount	*mp = ip->i_mount;
 	unsigned long		flags;
 
-	if (ioend->io_fork == XFS_COW_FORK ||
+	if ((ioend->io_flags & IOMAP_F_SHARED) ||
 	    ioend->io_type == IOMAP_UNWRITTEN ||
 	    xfs_ioend_is_append(ioend)) {
 		spin_lock_irqsave(&ip->i_ioend_lock, flags);
@@ -350,7 +350,7 @@ xfs_imap_valid(
 	 * covers the offset. Be careful to check this first because the caller
 	 * can revalidate a COW mapping without updating the data seqno.
 	 */
-	if (wpc->fork == XFS_COW_FORK)
+	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		return true;
 
 	/*
@@ -380,6 +380,7 @@ static int
 xfs_convert_blocks(
 	struct xfs_writepage_ctx *wpc,
 	struct xfs_inode	*ip,
+	int			whichfork,
 	loff_t			offset)
 {
 	int			error;
@@ -391,8 +392,8 @@ xfs_convert_blocks(
 	 * delalloc extent if free space is sufficiently fragmented.
 	 */
 	do {
-		error = xfs_bmapi_convert_delalloc(ip, wpc->fork, offset,
-				&wpc->iomap, wpc->fork == XFS_COW_FORK ?
+		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
+				&wpc->iomap, whichfork == XFS_COW_FORK ?
 					&wpc->cow_seq : &wpc->data_seq);
 		if (error)
 			return error;
@@ -413,6 +414,7 @@ xfs_map_blocks(
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
 	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
+	int			whichfork = XFS_DATA_FORK;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
@@ -461,7 +463,7 @@ xfs_map_blocks(
 		wpc->cow_seq = READ_ONCE(ip->i_cowfp->if_seq);
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-		wpc->fork = XFS_COW_FORK;
+		whichfork = XFS_COW_FORK;
 		goto allocate_blocks;
 	}
 
@@ -484,8 +486,6 @@ xfs_map_blocks(
 	wpc->data_seq = READ_ONCE(ip->i_df.if_seq);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	wpc->fork = XFS_DATA_FORK;
-
 	/* landed in a hole or beyond EOF? */
 	if (imap.br_startoff > offset_fsb) {
 		imap.br_blockcount = imap.br_startoff - offset_fsb;
@@ -510,10 +510,10 @@ xfs_map_blocks(
 		goto allocate_blocks;
 
 	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0);
-	trace_xfs_map_blocks_found(ip, offset, count, wpc->fork, &imap);
+	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_convert_blocks(wpc, ip, offset);
+	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
 	if (error) {
 		/*
 		 * If we failed to find the extent in the COW fork we might have
@@ -522,7 +522,8 @@ xfs_map_blocks(
 		 * the former case, but prevent additional retries to avoid
 		 * looping forever for the latter case.
 		 */
-		if (error == -EAGAIN && wpc->fork == XFS_COW_FORK && !retries++)
+		if (error == -EAGAIN && (wpc->iomap.flags & IOMAP_F_SHARED) &&
+		    !retries++)
 			goto retry;
 		ASSERT(error != -EAGAIN);
 		return error;
@@ -533,7 +534,7 @@ xfs_map_blocks(
 	 * original delalloc one.  Trim the return extent to the next COW
 	 * boundary again to force a re-lookup.
 	 */
-	if (wpc->fork != XFS_COW_FORK && cow_fsb != NULLFILEOFF) {
+	if (!(wpc->iomap.flags & IOMAP_F_SHARED) && cow_fsb != NULLFILEOFF) {
 		loff_t		cow_offset = XFS_FSB_TO_B(mp, cow_fsb);
 
 		if (cow_offset < wpc->iomap.offset + wpc->iomap.length)
@@ -542,7 +543,7 @@ xfs_map_blocks(
 
 	ASSERT(wpc->iomap.offset <= offset);
 	ASSERT(wpc->iomap.offset + wpc->iomap.length > offset);
-	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->fork, &imap);
+	trace_xfs_map_blocks_alloc(ip, offset, count, whichfork, &imap);
 	return 0;
 }
 
@@ -567,7 +568,7 @@ xfs_submit_ioend(
 	int			status)
 {
 	/* Convert CoW extents to regular */
-	if (!status && ioend->io_fork == XFS_COW_FORK) {
+	if (!status && (ioend->io_flags & IOMAP_F_SHARED)) {
 		/*
 		 * Yuk. This can do memory allocation, but is not a
 		 * transactional operation so everything is done in GFP_KERNEL
@@ -621,8 +622,8 @@ xfs_alloc_ioend(
 
 	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
 	INIT_LIST_HEAD(&ioend->io_list);
-	ioend->io_fork = wpc->fork;
 	ioend->io_type = wpc->iomap.type;
+	ioend->io_flags = wpc->iomap.flags;
 	ioend->io_inode = inode;
 	ioend->io_size = 0;
 	ioend->io_offset = offset;
@@ -676,7 +677,8 @@ xfs_add_to_ioend(
 	sector = (wpc->iomap.addr + offset - wpc->iomap.offset) >> 9;
 
 	if (!wpc->ioend ||
-	    wpc->fork != wpc->ioend->io_fork ||
+	    (wpc->iomap.flags & IOMAP_F_SHARED) !=
+	    (wpc->ioend->io_flags & IOMAP_F_SHARED) ||
 	    wpc->iomap.type != wpc->ioend->io_type ||
 	    sector != bio_end_sector(wpc->ioend->io_bio) ||
 	    offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 23c087f0bcbf..bf95837c59af 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -13,8 +13,8 @@ extern struct bio_set xfs_ioend_bioset;
  */
 struct xfs_ioend {
 	struct list_head	io_list;	/* next ioend in chain */
-	int			io_fork;	/* inode fork written back */
 	u16			io_type;
+	u16			io_flags;
 	struct inode		*io_inode;	/* file being written to */
 	size_t			io_size;	/* size of the extent */
 	xfs_off_t		io_offset;	/* offset in the file */
-- 
2.20.1
