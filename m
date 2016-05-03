Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 296677CF4
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 16:29:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E766AC001
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 14:29:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Y5HZSRwG75jpJ8KB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 14:29:42 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/14] xfs: use xfs_zero_range in xfs_zero_eof
Date: Tue,  3 May 2016 23:29:05 +0200
Message-Id: <1462310947-16132-13-git-send-email-hch@lst.de>
In-Reply-To: <1462310947-16132-1-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
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

We now skip holes in it, so no need to have the caller do it as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 128 +-----------------------------------------------------
 1 file changed, 1 insertion(+), 127 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 85369a9..6ad30dd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -381,49 +381,6 @@ out:
 }
 
 /*
- * This routine is called to handle zeroing any space in the last block of the
- * file that is beyond the EOF.  We do this since the size is being increased
- * without writing anything to that block and we don't want to read the
- * garbage on the disk.
- */
-STATIC int				/* error (positive) */
-xfs_zero_last_block(
-	struct xfs_inode	*ip,
-	xfs_fsize_t		offset,
-	xfs_fsize_t		isize,
-	bool			*did_zeroing)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		last_fsb = XFS_B_TO_FSBT(mp, isize);
-	int			zero_offset = XFS_B_FSB_OFFSET(mp, isize);
-	int			zero_len;
-	int			nimaps = 1;
-	int			error = 0;
-	struct xfs_bmbt_irec	imap;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_bmapi_read(ip, last_fsb, 1, &imap, &nimaps, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		return error;
-
-	ASSERT(nimaps > 0);
-
-	/*
-	 * If the block underlying isize is just a hole, then there
-	 * is nothing to zero.
-	 */
-	if (imap.br_startblock == HOLESTARTBLOCK)
-		return 0;
-
-	zero_len = mp->m_sb.sb_blocksize - zero_offset;
-	if (isize + zero_len > offset)
-		zero_len = offset - isize;
-	*did_zeroing = true;
-	return xfs_zero_range(ip, isize, zero_len, NULL);
-}
-
-/*
  * Zero any on disk space between the current EOF and the new, larger EOF.
  *
  * This handles the normal case of zeroing the remainder of the last block in
@@ -441,94 +398,11 @@ xfs_zero_eof(
 	xfs_fsize_t		isize,		/* current inode size */
 	bool			*did_zeroing)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		start_zero_fsb;
-	xfs_fileoff_t		end_zero_fsb;
-	xfs_fileoff_t		zero_count_fsb;
-	xfs_fileoff_t		last_fsb;
-	xfs_fileoff_t		zero_off;
-	xfs_fsize_t		zero_len;
-	int			nimaps;
-	int			error = 0;
-	struct xfs_bmbt_irec	imap;
-
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(offset > isize);
 
 	trace_xfs_zero_eof(ip, isize, offset - isize);
-
-	/*
-	 * First handle zeroing the block on which isize resides.
-	 *
-	 * We only zero a part of that block so it is handled specially.
-	 */
-	if (XFS_B_FSB_OFFSET(mp, isize) != 0) {
-		error = xfs_zero_last_block(ip, offset, isize, did_zeroing);
-		if (error)
-			return error;
-	}
-
-	/*
-	 * Calculate the range between the new size and the old where blocks
-	 * needing to be zeroed may exist.
-	 *
-	 * To get the block where the last byte in the file currently resides,
-	 * we need to subtract one from the size and truncate back to a block
-	 * boundary.  We subtract 1 in case the size is exactly on a block
-	 * boundary.
-	 */
-	last_fsb = isize ? XFS_B_TO_FSBT(mp, isize - 1) : (xfs_fileoff_t)-1;
-	start_zero_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)isize);
-	end_zero_fsb = XFS_B_TO_FSBT(mp, offset - 1);
-	ASSERT((xfs_sfiloff_t)last_fsb < (xfs_sfiloff_t)start_zero_fsb);
-	if (last_fsb == end_zero_fsb) {
-		/*
-		 * The size was only incremented on its last block.
-		 * We took care of that above, so just return.
-		 */
-		return 0;
-	}
-
-	ASSERT(start_zero_fsb <= end_zero_fsb);
-	while (start_zero_fsb <= end_zero_fsb) {
-		nimaps = 1;
-		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_bmapi_read(ip, start_zero_fsb, zero_count_fsb,
-					  &imap, &nimaps, 0);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			return error;
-
-		ASSERT(nimaps > 0);
-
-		if (imap.br_state == XFS_EXT_UNWRITTEN ||
-		    imap.br_startblock == HOLESTARTBLOCK) {
-			start_zero_fsb = imap.br_startoff + imap.br_blockcount;
-			ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
-			continue;
-		}
-
-		/*
-		 * There are blocks we need to zero.
-		 */
-		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
-		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
-
-		if ((zero_off + zero_len) > offset)
-			zero_len = offset - zero_off;
-
-		error = xfs_zero_range(ip, zero_off, zero_len, NULL);
-		if (error)
-			return error;
-
-		*did_zeroing = true;
-		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
-		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
-	}
-
-	return 0;
+	return xfs_zero_range(ip, isize, offset - isize, did_zeroing);
 }
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
