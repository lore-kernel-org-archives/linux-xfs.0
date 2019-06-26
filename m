Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:10 -0400
Subject: [PATCH 09/15] xfs: change xfs_iwalk_grab_ichunk to use startino,
 not lastino
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:44:53 -0700
Message-ID: <156158189316.495087.13142269111016512059.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that the inode chunk grabbing function is a static function in the
iwalk code, change its behavior so that @agino is the inode where we
want to /start/ the iteration.  This reduces cognitive friction with the
callers and simplifes the code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iwalk.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 99539421ee57..16744fa556c6 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -98,10 +98,10 @@ xfs_iwalk_ichunk_ra(
 }
 
 /*
- * Lookup the inode chunk that the given inode lives in and then get the record
- * if we found the chunk.  If the inode was not the last in the chunk and there
- * are some left allocated, update the data for the pointed-to record as well as
- * return the count of grabbed inodes.
+ * Lookup the inode chunk that the given @agino lives in and then get the
+ * record if we found the chunk.  Set the bits in @irec's free mask that
+ * correspond to the inodes before @agino so that we skip them.  This is how we
+ * restart an inode walk that was interrupted in the middle of an inode record.
  */
 STATIC int
 xfs_iwalk_grab_ichunk(
@@ -112,6 +112,7 @@ xfs_iwalk_grab_ichunk(
 {
 	int				idx;	/* index into inode chunk */
 	int				stat;
+	int				i;
 	int				error = 0;
 
 	/* Lookup the inode chunk that this inode lives in */
@@ -135,24 +136,20 @@ xfs_iwalk_grab_ichunk(
 		return 0;
 	}
 
-	idx = agino - irec->ir_startino + 1;
-	if (idx < XFS_INODES_PER_CHUNK &&
-	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
-		int	i;
+	idx = agino - irec->ir_startino;
 
-		/* We got a right chunk with some left inodes allocated at it.
-		 * Grab the chunk record.  Mark all the uninteresting inodes
-		 * free -- because they're before our start point.
-		 */
-		for (i = 0; i < idx; i++) {
-			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
-				irec->ir_freecount++;
-		}
-
-		irec->ir_free |= xfs_inobt_maskn(0, idx);
-		*icount = irec->ir_count - irec->ir_freecount;
+	/*
+	 * We got a right chunk with some left inodes allocated at it.  Grab
+	 * the chunk record.  Mark all the uninteresting inodes free because
+	 * they're before our start point.
+	 */
+	for (i = 0; i < idx; i++) {
+		if (XFS_INOBT_MASK(i) & ~irec->ir_free)
+			irec->ir_freecount++;
 	}
 
+	irec->ir_free |= xfs_inobt_maskn(0, idx);
+	*icount = irec->ir_count - irec->ir_freecount;
 	return 0;
 }
 
@@ -281,7 +278,7 @@ xfs_iwalk_ag_start(
 	 * We require a lookup cache of at least two elements so that we don't
 	 * have to deal with tearing down the cursor to walk the records.
 	 */
-	error = xfs_iwalk_grab_ichunk(*curpp, agino - 1, &icount,
+	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
 			&iwag->recs[iwag->nr_recs]);
 	if (error)
 		return error;
