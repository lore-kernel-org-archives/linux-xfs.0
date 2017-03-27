Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54926 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdC0Ija (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:39:30 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/26] xfs: reject all unaligned direct writes to reflinked files
Date: Mon, 27 Mar 2017 10:38:23 +0200
Message-Id: <20170327083837.11027-13-hch@lst.de>
In-Reply-To: <20170327083837.11027-1-hch@lst.de>
References: <20170327083837.11027-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 54a4ef8af4e0dc5c983d17fcb9cf5fd25666d94e upstream.

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
 fs/xfs/xfs_file.c  |  9 +++++++++
 fs/xfs/xfs_iomap.c | 12 +-----------
 fs/xfs/xfs_trace.h |  2 +-
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 032c8a74824a..2a695a8f4fe7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -527,6 +527,15 @@ xfs_file_dio_aio_write(
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
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 32b113c4e973..e8811bd1019b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1026,17 +1026,7 @@ xfs_file_iomap_begin(
 		if (error)
 			goto out_unlock;
 
-		/*
-		 * We're here because we're trying to do a directio write to a
-		 * region that isn't aligned to a filesystem block.  If the
-		 * extent is shared, fall back to buffered mode to handle the
-		 * RMW.
-		 */
-		if (!(flags & IOMAP_REPORT) && shared) {
-			trace_xfs_reflink_bounce_dio_write(ip, &imap);
-			error = -EREMCHG;
-			goto out_unlock;
-		}
+		ASSERT((flags & IOMAP_REPORT) || !shared);
 	}
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d3d11905c55c..375c5e030e5b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3250,7 +3250,7 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
 DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
 
-DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
+DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
 DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
 
-- 
2.11.0

