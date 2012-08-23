Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54Kr1135665 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MvrZZGEEVTua3VuL for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbK-0003Ig-9i
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbA-0003hI-6J
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 072/102] xfs: use shared ilock mode for direct IO writes by
	default
Date: Thu, 23 Aug 2012 15:02:30 +1000
Message-Id: <1345698180-13612-73-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 507630b29f13a3d8689895618b12015308402e22

For the direct IO write path, we only really need the ilock to be taken in
exclusive mode during IO submission if we need to do extent allocation
instead of all the time.

Change the block mapping code to take the ilock in shared mode for the
initial block mapping, and only retake it exclusively when we actually
have to perform extent allocations.  We were already dropping the ilock
for the transaction allocation, so this doesn't introduce new race windows.

Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   30 +++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c          |   45 ++++++++++++++++++-------------------------
 2 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 390e511..2ce0e07 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1194,7 +1194,14 @@ __xfs_get_blocks(
 	if (!create && direct && offset >= i_size_read(inode))
 		return 0;
 
-	if (create) {
+	/*
+	 * Direct I/O is usually done on preallocated files, so try getting
+	 * a block mapping without an exclusive lock first.  For buffered
+	 * writes we already have the exclusive iolock anyway, so avoiding
+	 * a lock roundtrip here by taking the ilock exclusive from the
+	 * beginning is a useful micro optimization.
+	 */
+	if (create && !direct) {
 		lockmode = XFS_ILOCK_EXCL;
 		xfs_ilock(ip, lockmode);
 	} else {
@@ -1217,22 +1224,37 @@ __xfs_get_blocks(
 	     (imap.br_startblock == HOLESTARTBLOCK ||
 	      imap.br_startblock == DELAYSTARTBLOCK))) {
 		if (direct) {
+			/*
+			 * Drop the ilock in preparation for starting the block
+			 * allocation transaction.  It will be retaken
+			 * exclusively inside xfs_iomap_write_direct for the
+			 * actual allocation.
+			 */
+			xfs_iunlock(ip, lockmode);
 			error = xfs_iomap_write_direct(ip, offset, size,
 						       &imap, nimaps);
+			if (error)
+				return -error;
 		} else {
+			/*
+			 * Delalloc reservations do not require a transaction,
+			 * we can go on without dropping the lock here.
+			 */
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
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9ee9467..29e2d85 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
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
 
 	xfs_trans_ijoin(tp, ip);
 
@@ -226,42 +222,39 @@ xfs_iomap_write_direct(
 	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
