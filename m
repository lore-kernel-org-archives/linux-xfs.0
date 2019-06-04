Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFDVuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:50:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lnffi053384
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:09 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugstfp8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lo0pI044987
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2swnghkjne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:08 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54Lo7YJ030975
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:07 GMT
Subject: [PATCH 06/10] xfs: change xfs_iwalk_grab_ichunk to use startino,
 not lastino
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:50:06 -0700
Message-ID: <155968500594.1657646.11152617991338213789.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that the inode chunk grabbing function is a static function in the
iwalk code, change its behavior so that @agino is the inode where we
want to /start/ the iteration.  This reduces cognitive friction with the
callers and simplifes the code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index bef0c4907781..9ad017ddbae7 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -99,10 +99,10 @@ xfs_iwalk_ichunk_ra(
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
@@ -113,6 +113,7 @@ xfs_iwalk_grab_ichunk(
 {
 	int				idx;	/* index into inode chunk */
 	int				stat;
+	int				i;
 	int				error = 0;
 
 	/* Lookup the inode chunk that this inode lives in */
@@ -136,24 +137,20 @@ xfs_iwalk_grab_ichunk(
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
