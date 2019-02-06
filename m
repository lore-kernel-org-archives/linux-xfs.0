Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731214AbfBFQzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 11:55:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x16GrvAh151851
        for <linux-xfs@vger.kernel.org>; Wed, 6 Feb 2019 16:55:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qd98na7qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 06 Feb 2019 16:55:19 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x16GtIAl006438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 6 Feb 2019 16:55:18 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x16GtIZT027400
        for <linux-xfs@vger.kernel.org>; Wed, 6 Feb 2019 16:55:18 GMT
Subject: [PATCH 6/9] xfs: refactor unlinked list search and mapping to a
 separate function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 06 Feb 2019 08:55:17 -0800
Message-ID: <154947211711.22369.10227484386880189461.stgit@magnolia>
In-Reply-To: <154947207759.22369.11575570374120223292.stgit@magnolia>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's a loop that searches an unlinked bucket list to find the inode
that points to a given inode.  Hoist this into a separate function;
later we'll use our iunlink backref cache to bypass the slow list
operation.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |  135 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 96 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index eb51fa33f91a..161d8da459aa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2082,6 +2082,96 @@ xfs_iunlink(
 	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
 }
 
+/* Return the imap, dinode pointer, and buffer for an inode. */
+STATIC int
+xfs_iunlink_map_ino(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	imap->im_blkno = 0;
+	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
+	if (error) {
+		xfs_warn(mp, "%s: xfs_imap returned error %d.",
+				__func__, error);
+		return error;
+	}
+
+	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0, 0);
+	if (error) {
+		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
+				__func__, error);
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Walk the unlinked chain from @head_agino until we find the inode that
+ * points to @target_agino.  Return the inode number, map, dinode pointer,
+ * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
+ *
+ * @tp, @pag, @head_agino, and @target_agino are input parameters.
+ * @agino, @imap, @dipp, and @bpp are all output parameters.
+ *
+ * Do not call this function if @target_agino is the head of the list.
+ */
+STATIC int
+xfs_iunlink_map_prev(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		head_agino,
+	xfs_agino_t		target_agino,
+	xfs_agino_t		*agino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agino_t		next_agino;
+	int			error;
+
+	ASSERT(head_agino != target_agino);
+
+	next_agino = head_agino;
+	while (next_agino != target_agino) {
+		xfs_agino_t	unlinked_agino;
+
+		if (*bpp)
+			xfs_trans_brelse(tp, *bpp);
+
+		*agino = next_agino;
+		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
+				bpp);
+		if (error)
+			return error;
+
+		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
+		/*
+		 * Make sure this pointer is valid and isn't an obvious
+		 * infinite loop.
+		 */
+		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
+		    next_agino == unlinked_agino) {
+			XFS_CORRUPTION_ERROR(__func__,
+					XFS_ERRLEVEL_LOW, mp,
+					*dipp, sizeof(**dipp));
+			error = -EFSCORRUPTED;
+			return error;
+		}
+		next_agino = unlinked_agino;
+	}
+
+	return 0;
+}
+
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
@@ -2093,9 +2183,8 @@ xfs_iunlink_remove(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi;
 	struct xfs_buf		*agibp;
-	struct xfs_buf		*last_ibp;
+	struct xfs_buf		*last_ibp = NULL;
 	struct xfs_dinode	*last_dip = NULL;
-	xfs_ino_t		next_ino;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
@@ -2138,43 +2227,11 @@ xfs_iunlink_remove(
 		struct xfs_imap	imap;
 		xfs_agino_t	prev_agino;
 
-		/*
-		 * We need to search the list for the inode being freed.
-		 */
-		last_ibp = NULL;
-		while (next_agino != agino) {
-			if (last_ibp)
-				xfs_trans_brelse(tp, last_ibp);
-
-			imap.im_blkno = 0;
-			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
-
-			error = xfs_imap(mp, tp, next_ino, &imap, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap returned error %d.",
-					 __func__, error);
-				return error;
-			}
-
-			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
-					       &last_ibp, 0, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap_to_bp returned error %d.",
-					__func__, error);
-				return error;
-			}
-
-			prev_agino = next_agino;
-			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
-			if (!xfs_verify_agino(mp, agno, next_agino)) {
-				XFS_CORRUPTION_ERROR(__func__,
-						XFS_ERRLEVEL_LOW, mp,
-						last_dip, sizeof(*last_dip));
-				return -EFSCORRUPTED;
-			}
-		}
+		/* We need to search the list for the inode being freed. */
+		error = xfs_iunlink_map_prev(tp, agno, next_agino, agino,
+				&prev_agino, &imap, &last_dip, &last_ibp);
+		if (error)
+			return error;
 
 		/*
 		 * Now last_ibp points to the buffer previous to us on the
