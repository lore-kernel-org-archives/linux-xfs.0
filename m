Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56342 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdDAGll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:41:41 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/27] xfs: reject all unaligned direct writes to reflinked files
Date: Sat,  1 Apr 2017 08:40:13 +0200
Message-Id: <20170401064026.5783-15-hch@lst.de>
In-Reply-To: <20170401064026.5783-1-hch@lst.de>
References: <20170401064026.5783-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 54a4ef8af4e0dc5c983d17fcb9cf5fd25666d94e upstream.
[slight changes in context due to the new direct I/O code in 4.10+]

We currently fall back from direct to buffered writes if we detect a
remaining shared extent in the iomap_begin callback.  But by the time
iomap_begin is called for the potentially unaligned end block we might
have already written most of the data to disk, which we'd now write
again using buffered I/O.  To avoid this reject all writes to reflinked
files before starting I/O so that we are guaranteed to only write the
data once.

The alternative would be to unshare the unaligned start and/or end block
before doing the I/O. I think that's doable, and will actually be
required to support reflinks on DAX file system.  But it will take a
little more time and I'd rather get rid of the double write ASAP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c  | 45 ---------------------------------------------
 fs/xfs/xfs_file.c  |  9 +++++++++
 fs/xfs/xfs_trace.h |  2 +-
 3 files changed, 10 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6845ebfa3067..f5f51d40a2ec 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1263,44 +1263,6 @@ xfs_map_trim_size(
 	bh_result->b_size = mapping_size;
 }
 
-/* Bounce unaligned directio writes to the page cache. */
-static int
-xfs_bounce_unaligned_dio_write(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		offset_fsb,
-	struct xfs_bmbt_irec	*imap)
-{
-	struct xfs_bmbt_irec	irec;
-	xfs_fileoff_t		delta;
-	bool			shared;
-	bool			x;
-	int			error;
-
-	irec = *imap;
-	if (offset_fsb > irec.br_startoff) {
-		delta = offset_fsb - irec.br_startoff;
-		irec.br_blockcount -= delta;
-		irec.br_startblock += delta;
-		irec.br_startoff = offset_fsb;
-	}
-	error = xfs_reflink_trim_around_shared(ip, &irec, &shared, &x);
-	if (error)
-		return error;
-
-	/*
-	 * We're here because we're trying to do a directio write to a
-	 * region that isn't aligned to a filesystem block.  If any part
-	 * of the extent is shared, fall back to buffered mode to handle
-	 * the RMW.  This is done by returning -EREMCHG ("remote addr
-	 * changed"), which is caught further up the call stack.
-	 */
-	if (shared) {
-		trace_xfs_reflink_bounce_dio_write(ip, imap);
-		return -EREMCHG;
-	}
-	return 0;
-}
-
 STATIC int
 __xfs_get_blocks(
 	struct inode		*inode,
@@ -1438,13 +1400,6 @@ __xfs_get_blocks(
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
-		if (create && direct && !is_cow) {
-			error = xfs_bounce_unaligned_dio_write(ip, offset_fsb,
-					&imap);
-			if (error)
-				return error;
-		}
-
 		xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 780be7a7abe9..1209ad29e902 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -554,6 +554,15 @@ xfs_file_dio_aio_write(
 	if ((iocb->ki_pos & mp->m_blockmask) ||
 	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
 		unaligned_io = 1;
+
+		/*
+		 * We can't properly handle unaligned direct I/O to reflink
+		 * files yet, as we can't unshare a partial block.
+		 */
+		if (xfs_is_reflink_inode(ip)) {
+			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
+			return -EREMCHG;
+		}
 		iolock = XFS_IOLOCK_EXCL;
 	} else {
 		iolock = XFS_IOLOCK_SHARED;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b62764064af6..828f383df121 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3353,7 +3353,7 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
 DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
 
-DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
 DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
 
-- 
2.11.0

