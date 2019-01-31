Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41072 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfAaXSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:18:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VNEFF4027940
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:29 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2q8d2eku6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNISXI027305
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:28 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0VNISk6029513
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:28 GMT
Subject: [PATCH 6/8] xfs: hoist unlinked list search and mapping to a
 separate function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Jan 2019 15:18:27 -0800
Message-ID: <154897670777.26065.9017810401812180528.stgit@magnolia>
In-Reply-To: <154897667054.26065.13164381203002725289.stgit@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
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
 fs/xfs/xfs_inode.c |  136 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 99 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ea38b66fbc59..d5b3f8fdac7e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2084,6 +2084,100 @@ xfs_iunlink(
 	return error;
 }
 
+/* Return the imap, dinode pointer, and buffer for an inode. */
+STATIC int
+xfs_iunlink_map_ino(
+	struct xfs_trans	*tp,
+	xfs_ino_t		next_ino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	imap->im_blkno = 0;
+	error = xfs_imap(mp, tp, next_ino, imap, 0);
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
+ * points to @target_ino.  Return the inode number, map, dinode pointer,
+ * and inode cluster buffer of that inode as @ino, @imap, @dipp, and @bpp.
+ *
+ * Do not call this function if @target_agino is the head of the list.
+ */
+STATIC int
+xfs_iunlink_map_prev(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_agino_t		head_agino,
+	xfs_agino_t		target_agino,
+	xfs_ino_t		*ino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_imap		last_imap;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*last_ibp = NULL;
+	struct xfs_dinode	*last_dip;
+	xfs_ino_t		next_ino = NULLFSINO;
+	xfs_agino_t		next_agino;
+	int			error;
+
+	ASSERT(head_agino != target_agino);
+
+	next_agino = head_agino;
+	while (next_agino != target_agino) {
+		xfs_agino_t	unlinked_agino;
+
+		if (last_ibp)
+			xfs_trans_brelse(tp, last_ibp);
+
+		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+		error = xfs_iunlink_map_ino(tp, next_ino, &last_imap,
+				&last_dip, &last_ibp);
+		if (error)
+			return error;
+
+		unlinked_agino = be32_to_cpu(last_dip->di_next_unlinked);
+		if (!xfs_verify_agino(mp, pag->pag_agno, next_agino) ||
+		    next_agino == unlinked_agino) {
+			XFS_CORRUPTION_ERROR(__func__,
+					XFS_ERRLEVEL_LOW, mp,
+					last_dip, sizeof(*last_dip));
+			error = -EFSCORRUPTED;
+			return error;
+		}
+		next_agino = unlinked_agino;
+	}
+
+	/* Should never happen, but don't return garbage. */
+	if (next_ino == NULLFSINO)
+		return -EFSCORRUPTED;
+
+	*ino = next_ino;
+	memcpy(imap, &last_imap, sizeof(last_imap));
+	*dipp = last_dip;
+	*bpp = last_ibp;
+	return 0;
+}
+
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
@@ -2153,43 +2247,11 @@ xfs_iunlink_remove(
 	} else {
 		struct xfs_imap	imap;
 
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
-				goto out_unlock;
-			}
-
-			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
-					       &last_ibp, 0, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap_to_bp returned error %d.",
-					__func__, error);
-				goto out_unlock;
-			}
-
-			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
-			if (!xfs_verify_agino(mp, agno, next_agino)) {
-				XFS_CORRUPTION_ERROR(__func__,
-						XFS_ERRLEVEL_LOW, mp,
-						last_dip, sizeof(*last_dip));
-				error = -EFSCORRUPTED;
-				goto out_unlock;
-			}
-		}
+		/* We need to search the list for the inode being freed. */
+		error = xfs_iunlink_map_prev(tp, pag, next_agino, agino,
+				&next_ino, &imap, &last_dip, &last_ibp);
+		if (error)
+			goto out_unlock;
 
 		/*
 		 * Now last_ibp points to the buffer previous to us on the
