Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fDga205177 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 508E11DC53D
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hba4f68hXimpJO5P for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZC-0006Ps-MB
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:02 +0000
Message-Id: <20101210084302.641592786@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/10] xfs: simplify xfs_map_blocks
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-map_blocks
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

No need to lock the extent map exclusive when performing an overwrite,
we know the extent map must already have been loaded by get_blocks.
Apply the non-blocking inode semantics to all mapping types instead of
just delayed allocations.  Remove the handling of not yet allocated
blocks for the IO_UNWRITTEN case - if an extent is marked as unwritten
allocated in the buffer it must already have an extent on disk.

Add asserts to verify all the assumptions above in debug builds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-10-31 15:10:59.000000000 -0400
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-10-31 15:13:27.777719469 -0400
@@ -313,81 +313,54 @@ xfs_map_blocks(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			error = 0;
-	int			lockmode = 0;
 	int			bmapi_flags = XFS_BMAPI_ENTIRE;
 	int			nimaps = 1;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
-	switch (type) {
-	case IO_OVERWRITE:
-		lockmode = xfs_ilock_map_shared(ip);
-		break;
-	case IO_UNWRITTEN:
-		lockmode = XFS_ILOCK_EXCL;
+	if (type == IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
-		xfs_ilock(ip, lockmode);
-		break;
-	case IO_DELALLOC:
-		lockmode = XFS_ILOCK_SHARED;
-
-		if (!xfs_ilock_nowait(ip, lockmode)) {
-			if (nonblocking)
-				return -XFS_ERROR(EAGAIN);
-			xfs_ilock(ip, lockmode);
-		}
-		break;
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+		if (nonblocking)
+			return -XFS_ERROR(EAGAIN);
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
 	}
 
+	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 	ASSERT(offset <= mp->m_maxioffset);
+
 	if (offset + count > mp->m_maxioffset)
 		count = mp->m_maxioffset - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-
 	error = xfs_bmapi(NULL, ip, offset_fsb, end_fsb - offset_fsb,
 			  bmapi_flags,  NULL, 0, imap, &nimaps, NULL);
-	if (error)
-		goto out;
-
-	switch (type) {
-	case IO_UNWRITTEN:
-		/* If we found an extent, return it */
-		if (nimaps &&
-		    (imap->br_startblock != HOLESTARTBLOCK) &&
-		    (imap->br_startblock != DELAYSTARTBLOCK)) {
-			trace_xfs_map_blocks_found(ip, offset, count, type, imap);
-			break;
-		}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-		error = xfs_iomap_write_delay(ip, offset, count, imap);
-		if (!error)
-			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
-		break;
-	case IO_DELALLOC:
-		/* If we found an extent, return it */
-		xfs_iunlock(ip, lockmode);
-		lockmode = 0;
-
-		if (nimaps && !isnullstartblock(imap->br_startblock)) {
-			trace_xfs_map_blocks_found(ip, offset, count, type, imap);
-			break;
-		}
+	if (error)
+		return -XFS_ERROR(error);
 
+	if (type == IO_DELALLOC &&
+	    (!nimaps || isnullstartblock(imap->br_startblock))) {
 		error = xfs_iomap_write_allocate(ip, offset, count, imap);
 		if (!error)
 			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
-		break;
-	default:
-		if (nimaps)
-			trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+		return -XFS_ERROR(error);
 	}
 
-out:
-	if (lockmode)
-		xfs_iunlock(ip, lockmode);
-	return -XFS_ERROR(error);
+#ifdef DEBUG
+	if (type == IO_UNWRITTEN) {
+		ASSERT(nimaps);
+		ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+		ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
+	}
+#endif
+	if (nimaps)
+		trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+	return 0;
 }
 
 STATIC int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
