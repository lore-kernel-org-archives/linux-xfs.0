Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QLG8lq093878 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 16:16:08 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PoZmo5GCLYn7DURJ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 14:16:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCHGl-0000tL-T4
	for xfs@oss.sgi.com; Mon, 26 Mar 2012 21:16:03 +0000
Message-Id: <20120326211603.856796827@bombadil.infradead.org>
Date: Mon, 26 Mar 2012 17:14:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: use shared ilock mode for direct IO writes by default
References: <20120326211421.518374058@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-direct-io-locking
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

From: Dave Chinner <dchinner@redhat.com>

For the direct IO write path, we only really need the ilock to be taken in
exclusive mode during IO submission if we need to do extent allocation
instaled of all the time.

Change the block mapping code to take the ilock in shared mode for the
initial block mapping, and only retake it exclusively when we actually
have to perform extent allocations.  We were already dropping the ilock
for the transaction allocation, so this doesn't introduce new race windows.

Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_aops.c  |   21 +++++++++++++++++----
 fs/xfs/xfs_iomap.c |   45 +++++++++++++++++++--------------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2012-03-26 21:06:52.184213212 +0200
+++ xfs/fs/xfs/xfs_aops.c	2012-03-26 21:16:40.744358040 +0200
@@ -1146,7 +1146,14 @@ __xfs_get_blocks(
 	if (!create && direct && offset >= i_size_read(inode))
 		return 0;
 
-	if (create) {
+	/*
+	 * Direct I/O is usually done on preallocated files, so try getting
+	 * a block mapping without an exclusive lock first.  For buffer
+	 * writes we already have the exclusive iolock anyway, so avoiding
+	 * a lock roundtrip here by taking the ilock exclusive from the
+	 * beginning is a useful micro optimization.
+	 */
+	if (create && !direct) {
 		lockmode = XFS_ILOCK_EXCL;
 		xfs_ilock(ip, lockmode);
 	} else {
@@ -1169,22 +1176,28 @@ __xfs_get_blocks(
 	     (imap.br_startblock == HOLESTARTBLOCK ||
 	      imap.br_startblock == DELAYSTARTBLOCK))) {
 		if (direct) {
+			xfs_iunlock(ip, lockmode);
+
 			error = xfs_iomap_write_direct(ip, offset, size,
 						       &imap, nimaps);
+			if (error)
+				return -error;
 		} else {
 			error = xfs_iomap_write_delay(ip, offset, size, &imap);
+			if (error)
+				goto out_unlock;
+
+			xfs_iunlock(ip, lockmode);
 		}
-		if (error)
-			goto out_unlock;
 
 		trace_xfs_get_blocks_alloc(ip, offset, size, 0, &imap);
 	} else if (nimaps) {
 		trace_xfs_get_blocks_found(ip, offset, size, 0, &imap);
+		xfs_iunlock(ip, lockmode);
 	} else {
 		trace_xfs_get_blocks_notfound(ip, offset, size);
 		goto out_unlock;
 	}
-	xfs_iunlock(ip, lockmode);
 
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK) {
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2012-03-26 21:06:52.200879787 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2012-03-26 21:21:34.406100475 +0200
@@ -142,11 +142,7 @@ xfs_iomap_write_direct(
 	int		committed;
 	int		error;
 
-	/*
-	 * Make sure that the dquots are there. This doesn't hold
-	 * the ilock across a disk read.
-	 */
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach(ip, 0);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -158,7 +154,7 @@ xfs_iomap_write_direct(
 	if ((offset + count) > XFS_ISIZE(ip)) {
 		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
 		if (error)
-			goto error_out;
+			return XFS_ERROR(error);
 	} else {
 		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = MIN(last_fsb, (xfs_fileoff_t)
@@ -190,7 +186,6 @@ xfs_iomap_write_direct(
 	/*
 	 * Allocate and setup the transaction
 	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 	error = xfs_trans_reserve(tp, resblks,
 			XFS_WRITE_LOG_RES(mp), resrtextents,
@@ -199,15 +194,16 @@ xfs_iomap_write_direct(
 	/*
 	 * Check for running out of space, note: need lock to return
 	 */
-	if (error)
+	if (error) {
 		xfs_trans_cancel(tp, 0);
+		return XFS_ERROR(error);
+	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		goto error_out;
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
 	if (error)
-		goto error1;
+		goto out_trans_cancel;
 
 	xfs_trans_ijoin(tp, ip, 0);
 
@@ -224,42 +220,39 @@ xfs_iomap_write_direct(
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flag,
 				&firstfsb, 0, imap, &nimaps, &free_list);
 	if (error)
-		goto error0;
+		goto out_bmap_cancel;
 
 	/*
 	 * Complete the transaction
 	 */
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
-		goto error0;
+		goto out_bmap_cancel;
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	if (error)
-		goto error_out;
+		goto out_unlock;
 
 	/*
 	 * Copy any maps to caller's array and return any error.
 	 */
 	if (nimaps == 0) {
-		error = ENOSPC;
-		goto error_out;
+		error = XFS_ERROR(ENOSPC);
+		goto out_unlock;
 	}
 
-	if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip))) {
+	if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
 		error = xfs_alert_fsblock_zero(ip, imap);
-		goto error_out;
-	}
 
-	return 0;
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 
-error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
+out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_unreserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
-
-error1:	/* Just cancel transaction */
+out_trans_cancel:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-
-error_out:
-	return XFS_ERROR(error);
+	goto out_unlock;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
