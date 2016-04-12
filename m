Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A7347CBB
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 17:27:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6914304062
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:36 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ZJiJxbxBpkkcRpXX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:33 -0700 (PDT)
Received: from [67.51.76.21] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aq6mR-0006CH-UL
	for xfs@oss.sgi.com; Tue, 12 Apr 2016 22:27:32 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] kill xfs_zero_remaining_bytes
Date: Tue, 12 Apr 2016 15:26:53 -0700
Message-Id: <1460500013-28334-7-git-send-email-hch@lst.de>
In-Reply-To: <1460500013-28334-1-git-send-email-hch@lst.de>
References: <1460500013-28334-1-git-send-email-hch@lst.de>
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

---
 fs/xfs/xfs_bmap_util.c | 133 ++++++-------------------------------------------
 1 file changed, 14 insertions(+), 119 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5d030b0..0efabc1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1096,101 +1096,6 @@ error1:	/* Just cancel transaction */
 	return error;
 }
 
-/*
- * Zero file bytes between startoff and endoff inclusive.
- * The iolock is held exclusive and no blocks are buffered.
- *
- * This function is used by xfs_free_file_space() to zero
- * partial blocks when the range to free is not block aligned.
- * When unreserving space with boundaries that are not block
- * aligned we round up the start and round down the end
- * boundaries and then use this function to zero the parts of
- * the blocks that got dropped during the rounding.
- */
-STATIC int
-xfs_zero_remaining_bytes(
-	xfs_inode_t		*ip,
-	xfs_off_t		startoff,
-	xfs_off_t		endoff)
-{
-	xfs_bmbt_irec_t		imap;
-	xfs_fileoff_t		offset_fsb;
-	xfs_off_t		lastoffset;
-	xfs_off_t		offset;
-	xfs_buf_t		*bp;
-	xfs_mount_t		*mp = ip->i_mount;
-	int			nimap;
-	int			error = 0;
-
-	/*
-	 * Avoid doing I/O beyond eof - it's not necessary
-	 * since nothing can read beyond eof.  The space will
-	 * be zeroed when the file is extended anyway.
-	 */
-	if (startoff >= XFS_ISIZE(ip))
-		return 0;
-
-	if (endoff > XFS_ISIZE(ip))
-		endoff = XFS_ISIZE(ip);
-
-	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
-		uint lock_mode;
-
-		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-		nimap = 1;
-
-		lock_mode = xfs_ilock_data_map_shared(ip);
-		error = xfs_bmapi_read(ip, offset_fsb, 1, &imap, &nimap, 0);
-		xfs_iunlock(ip, lock_mode);
-
-		if (error || nimap < 1)
-			break;
-		ASSERT(imap.br_blockcount >= 1);
-		ASSERT(imap.br_startoff == offset_fsb);
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-
-		if (imap.br_startblock == HOLESTARTBLOCK ||
-		    imap.br_state == XFS_EXT_UNWRITTEN) {
-			/* skip the entire extent */
-			lastoffset = XFS_FSB_TO_B(mp, imap.br_startoff +
-						      imap.br_blockcount) - 1;
-			continue;
-		}
-
-		lastoffset = XFS_FSB_TO_B(mp, imap.br_startoff + 1) - 1;
-		if (lastoffset > endoff)
-			lastoffset = endoff;
-
-		/* DAX can just zero the backing device directly */
-		if (IS_DAX(VFS_I(ip))) {
-			error = dax_zero_page_range(VFS_I(ip), offset,
-						    lastoffset - offset + 1,
-						    xfs_get_blocks_direct);
-			if (error)
-				return error;
-			continue;
-		}
-
-		error = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
-				mp->m_rtdev_targp : mp->m_ddev_targp,
-				xfs_fsb_to_db(ip, imap.br_startblock),
-				BTOBB(mp->m_sb.sb_blocksize),
-				0, &bp, NULL);
-		if (error)
-			return error;
-
-		memset(bp->b_addr +
-				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
-		       0, lastoffset - offset + 1);
-
-		error = xfs_bwrite(bp);
-		xfs_buf_relse(bp);
-		if (error)
-			return error;
-	}
-	return error;
-}
-
 static int
 xfs_unmap_extent(
 	struct xfs_inode	*ip,
@@ -1316,7 +1221,7 @@ xfs_free_file_space(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
-	int			done, error;
+	int			done = 0, error;
 
 	trace_xfs_free_file_space(ip);
 
@@ -1348,31 +1253,21 @@ xfs_free_file_space(
 			return error;
 	}
 
-	if ((done = (endoffset_fsb <= startoffset_fsb)))
-		/*
-		 * One contiguous piece to clear
-		 */
-		error = xfs_zero_remaining_bytes(ip, offset, offset + len - 1);
-	else {
-		/*
-		 * Some full blocks, possibly two pieces to clear
-		 */
-		if (offset < XFS_FSB_TO_B(mp, startoffset_fsb))
-			error = xfs_zero_remaining_bytes(ip, offset,
-				XFS_FSB_TO_B(mp, startoffset_fsb) - 1);
-		if (!error &&
-		    XFS_FSB_TO_B(mp, endoffset_fsb) < offset + len)
-			error = xfs_zero_remaining_bytes(ip,
-				XFS_FSB_TO_B(mp, endoffset_fsb),
-				offset + len - 1);
-	}
-
-	while (!error && !done) {
-		error = xfs_unmap_extent(ip, startoffset_fsb,
-				endoffset_fsb - startoffset_fsb, &done);
+	if (endoffset_fsb > startoffset_fsb) {
+		while (!done) {
+			error = xfs_unmap_extent(ip, startoffset_fsb,
+					endoffset_fsb - startoffset_fsb, &done);
+			if (error)
+				return error;
+		}
 	}
 
-	return error;
+	/*
+	 * Now that we've unmap all full blocks we'll have to zero out any
+	 * partial block at the beginning and/or end.  xfs_zero_range is
+	 * smart enough to skip any holes, including those we just created.
+	 */
+	return xfs_zero_range(ip, offset, len, NULL);
 }
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
