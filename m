Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70E277CC7
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9168AC007
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:57 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id EloqFAYbc3PIRYSB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:55 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] xfs: remove buffered write support from __xfs_get_blocks
Date: Tue, 12 Apr 2016 13:53:00 -0700
Message-Id: <1460494382-14547-7-git-send-email-hch@lst.de>
In-Reply-To: <1460494382-14547-1-git-send-email-hch@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 77 +++++++++++++++----------------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e481c80..cb4f75c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1130,7 +1130,6 @@ __xfs_get_blocks(
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
 	int			create,
-	bool			direct,
 	bool			dax_fault)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1151,22 +1150,14 @@ __xfs_get_blocks(
 	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
 	size = bh_result->b_size;
 
-	if (!create && direct && offset >= i_size_read(inode))
+	if (!create && offset >= i_size_read(inode))
 		return 0;
 
 	/*
 	 * Direct I/O is usually done on preallocated files, so try getting
-	 * a block mapping without an exclusive lock first.  For buffered
-	 * writes we already have the exclusive iolock anyway, so avoiding
-	 * a lock roundtrip here by taking the ilock exclusive from the
-	 * beginning is a useful micro optimization.
+	 * a block mapping without an exclusive lock first.
 	 */
-	if (create && !direct) {
-		lockmode = XFS_ILOCK_EXCL;
-		xfs_ilock(ip, lockmode);
-	} else {
-		lockmode = xfs_ilock_data_map_shared(ip);
-	}
+	lockmode = xfs_ilock_data_map_shared(ip);
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 	if (offset + size > mp->m_super->s_maxbytes)
@@ -1185,37 +1176,19 @@ __xfs_get_blocks(
 	     (imap.br_startblock == HOLESTARTBLOCK ||
 	      imap.br_startblock == DELAYSTARTBLOCK) ||
 	     (IS_DAX(inode) && ISUNWRITTEN(&imap)))) {
-		if (direct || xfs_get_extsz_hint(ip)) {
-			/*
-			 * xfs_iomap_write_direct() expects the shared lock. It
-			 * is unlocked on return.
-			 */
-			if (lockmode == XFS_ILOCK_EXCL)
-				xfs_ilock_demote(ip, lockmode);
-
-			error = xfs_iomap_write_direct(ip, offset, size,
-						       &imap, nimaps);
-			if (error)
-				return error;
-			new = 1;
+		/*
+		 * xfs_iomap_write_direct() expects the shared lock. It
+		 * is unlocked on return.
+		 */
+		if (lockmode == XFS_ILOCK_EXCL)
+			xfs_ilock_demote(ip, lockmode);
 
-		} else {
-			/*
-			 * Delalloc reservations do not require a transaction,
-			 * we can go on without dropping the lock here. If we
-			 * are allocating a new delalloc block, make sure that
-			 * we set the new flag so that we mark the buffer new so
-			 * that we know that it is newly allocated if the write
-			 * fails.
-			 */
-			if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
-				new = 1;
-			error = xfs_iomap_write_delay(ip, offset, size, &imap);
-			if (error)
-				goto out_unlock;
+		error = xfs_iomap_write_direct(ip, offset, size,
+					       &imap, nimaps);
+		if (error)
+			return error;
+		new = 1;
 
-			xfs_iunlock(ip, lockmode);
-		}
 		trace_xfs_get_blocks_alloc(ip, offset, size,
 				ISUNWRITTEN(&imap) ? XFS_IO_UNWRITTEN
 						   : XFS_IO_DELALLOC, &imap);
@@ -1236,9 +1209,7 @@ __xfs_get_blocks(
 	}
 
 	/* trim mapping down to size requested */
-	if (direct || size > (1 << inode->i_blkbits))
-		xfs_map_trim_size(inode, iblock, bh_result,
-				  &imap, offset, size);
+	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
 
 	/*
 	 * For unwritten extents do not report a disk address in the buffered
@@ -1251,7 +1222,7 @@ __xfs_get_blocks(
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
 		/* direct IO needs special help */
-		if (create && direct) {
+		if (create) {
 			if (dax_fault)
 				ASSERT(!ISUNWRITTEN(&imap));
 			else
@@ -1280,14 +1251,7 @@ __xfs_get_blocks(
 	     (new || ISUNWRITTEN(&imap))))
 		set_buffer_new(bh_result);
 
-	if (imap.br_startblock == DELAYSTARTBLOCK) {
-		BUG_ON(direct);
-		if (create) {
-			set_buffer_uptodate(bh_result);
-			set_buffer_mapped(bh_result);
-			set_buffer_delay(bh_result);
-		}
-	}
+	BUG_ON(imap.br_startblock == DELAYSTARTBLOCK);
 
 	return 0;
 
@@ -1303,7 +1267,8 @@ xfs_get_blocks(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
+	BUG_ON(create);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
 }
 
 int
@@ -1313,7 +1278,7 @@ xfs_get_blocks_direct(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
 }
 
 int
@@ -1323,7 +1288,7 @@ xfs_get_blocks_dax_fault(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
 }
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
