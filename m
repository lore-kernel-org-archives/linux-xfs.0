Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE5047CD8
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 16:03:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E783F8F8039
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:03:02 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 9rA8css72lpDOhBe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:58 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1afZdh-0000Gn-Hm
	for xfs@oss.sgi.com; Mon, 14 Mar 2016 21:02:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] xfs: remove buffered write support from __xfs_get_blocks
Date: Mon, 14 Mar 2016 22:02:50 +0100
Message-Id: <1457989370-6904-8-git-send-email-hch@lst.de>
In-Reply-To: <1457989370-6904-1-git-send-email-hch@lst.de>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 77 +++++++++++++++----------------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 32aae77..8b09e93 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1110,7 +1110,6 @@ __xfs_get_blocks(
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
 	int			create,
-	bool			direct,
 	bool			dax_fault)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1131,22 +1130,14 @@ __xfs_get_blocks(
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
@@ -1165,37 +1156,19 @@ __xfs_get_blocks(
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
@@ -1216,9 +1189,7 @@ __xfs_get_blocks(
 	}
 
 	/* trim mapping down to size requested */
-	if (direct || size > (1 << inode->i_blkbits))
-		xfs_map_trim_size(inode, iblock, bh_result,
-				  &imap, offset, size);
+	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
 
 	/*
 	 * For unwritten extents do not report a disk address in the buffered
@@ -1231,7 +1202,7 @@ __xfs_get_blocks(
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
 		/* direct IO needs special help */
-		if (create && direct) {
+		if (create) {
 			if (dax_fault)
 				ASSERT(!ISUNWRITTEN(&imap));
 			else
@@ -1260,14 +1231,7 @@ __xfs_get_blocks(
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
 
@@ -1283,7 +1247,8 @@ xfs_get_blocks(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
+	BUG_ON(create);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
 }
 
 int
@@ -1293,7 +1258,7 @@ xfs_get_blocks_direct(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
 }
 
 int
@@ -1303,7 +1268,7 @@ xfs_get_blocks_dax_fault(
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
