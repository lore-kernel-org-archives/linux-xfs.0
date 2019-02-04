Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55250 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbfBDR7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 12:59:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x14HnLa3039300
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:49 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qd97eppjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 17:59:48 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x14HxltR002437
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:47 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x14Hxl3Y030652
        for <linux-xfs@vger.kernel.org>; Mon, 4 Feb 2019 17:59:47 GMT
Subject: [PATCH 07/10] xfs: refactor unlinked list search and mapping to a
 separate function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Feb 2019 09:59:46 -0800
Message-ID: <154930318626.31814.6656693057965798100.stgit@magnolia>
In-Reply-To: <154930313674.31814.17994684613232167921.stgit@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
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
 fs/xfs/xfs_inode.c |  145 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 106 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f23f13f0f2e6..8af5f4e989ac 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2066,6 +2066,105 @@ xfs_iunlink(
 	return error;
 }
 
+/* Return the imap, dinode pointer, and buffer for an inode. */
+STATIC int
+xfs_iunlink_map_ino(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	imap->im_blkno = 0;
+	error = xfs_imap(mp, tp, ino, imap, 0);
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
+ * and inode cluster buffer of that inode as @ino, @imap, @dipp, and @bpp.
+ *
+ * @tp, @pag, @head_agino, and @target_agino are input parameters.
+ * @ino, @imap, @dipp, and @bpp are all output parameters.
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
+		error = xfs_iunlink_map_ino(tp, next_ino, imap, &last_dip,
+				&last_ibp);
+		if (error)
+			return error;
+
+		unlinked_agino = be32_to_cpu(last_dip->di_next_unlinked);
+		/*
+		 * Make sure this pointer is valid and isn't an obvious
+		 * infinite loop.
+		 */
+		if (!xfs_verify_agino(mp, pag->pag_agno, unlinked_agino) ||
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
+	*dipp = last_dip;
+	*bpp = last_ibp;
+	return 0;
+}
+
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
@@ -2080,7 +2179,7 @@ xfs_iunlink_remove(
 	struct xfs_buf		*last_ibp;
 	struct xfs_dinode	*last_dip = NULL;
 	struct xfs_perag	*pag;
-	xfs_ino_t		next_ino;
+	xfs_ino_t		prev_ino;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
@@ -2125,43 +2224,11 @@ xfs_iunlink_remove(
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
-				goto out;
-			}
-
-			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
-					       &last_ibp, 0, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap_to_bp returned error %d.",
-					__func__, error);
-				goto out;
-			}
-
-			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
-			if (!xfs_verify_agino(mp, agno, next_agino)) {
-				XFS_CORRUPTION_ERROR(__func__,
-						XFS_ERRLEVEL_LOW, mp,
-						last_dip, sizeof(*last_dip));
-				error = -EFSCORRUPTED;
-				goto out;
-			}
-		}
+		/* We need to search the list for the inode being freed. */
+		error = xfs_iunlink_map_prev(tp, pag, next_agino, agino,
+				&prev_ino, &imap, &last_dip, &last_ibp);
+		if (error)
+			goto out;
 
 		/*
 		 * Now last_ibp points to the buffer previous to us on the
@@ -2174,7 +2241,7 @@ xfs_iunlink_remove(
 
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, agno, last_ibp, last_dip, &imap,
-				next_ino, next_agino);
+				prev_ino, next_agino);
 	}
 	pag->pagi_unlinked_count--;
 out:
