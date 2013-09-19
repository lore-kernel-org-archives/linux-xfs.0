Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1C1B29E0B
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 14:15:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B40088F8089
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iccBJxGt4buOu4wy for
	<xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:15:22 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8JJFMBC024635
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8JJFLJx021940
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:15:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/4] xfs: push down inactive transaction mgmt for remote
	symlinks
Date: Thu, 19 Sep 2013 15:15:18 -0400
Message-Id: <1379618121-35105-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
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

Push down the transaction management for remote symlinks from
xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
cleaned up to avoid transaction management intended for the
calling context (i.e., trans duplication, reservation, item
attachment).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c   | 15 +++++-----
 fs/xfs/xfs_symlink.c | 81 ++++++++++++++++++++++------------------------------
 fs/xfs/xfs_symlink.h |  2 +-
 3 files changed, 43 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e3d7538..30db70e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1724,9 +1724,14 @@ xfs_inactive(
 	if (error)
 		return VN_INACTIVE_CACHE;
 
+	if (S_ISLNK(ip->i_d.di_mode)) {
+		error = xfs_inactive_symlink(ip);
+		if (error)
+			goto out;
+	}
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	resp = (truncate || S_ISLNK(ip->i_d.di_mode)) ?
-		&M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
+	resp = truncate ? &M_RES(mp)->tr_itruncate : &M_RES(mp)->tr_ifree;
 
 	error = xfs_trans_reserve(tp, resp, 0, 0);
 	if (error) {
@@ -1738,11 +1743,7 @@ xfs_inactive(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (S_ISLNK(ip->i_d.di_mode)) {
-		error = xfs_inactive_symlink(ip, &tp);
-		if (error)
-			goto out_cancel;
-	} else if (truncate) {
+	if (truncate) {
 		ip->i_d.di_size = 0;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f622a97..2ce31a5 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -424,8 +424,7 @@ xfs_symlink(
  */
 STATIC int
 xfs_inactive_symlink_rmt(
-	xfs_inode_t	*ip,
-	xfs_trans_t	**tpp)
+	xfs_inode_t	*ip)
 {
 	xfs_buf_t	*bp;
 	int		committed;
@@ -437,11 +436,9 @@ xfs_inactive_symlink_rmt(
 	xfs_mount_t	*mp;
 	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
 	int		nmaps;
-	xfs_trans_t	*ntp;
 	int		size;
 	xfs_trans_t	*tp;
 
-	tp = *tpp;
 	mp = ip->i_mount;
 	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
 	/*
@@ -453,6 +450,14 @@ xfs_inactive_symlink_rmt(
 	 */
 	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
 
+	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+	if (error)
+		goto error_trans_cancel;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
 	/*
 	 * Lock the inode, fix the size, and join it to the transaction.
 	 * Hold it so in the normal path, we still have it locked for
@@ -471,7 +476,7 @@ xfs_inactive_symlink_rmt(
 	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
 				mval, &nmaps, 0);
 	if (error)
-		goto error0;
+		goto error_unlock;
 	/*
 	 * Invalidate the block(s). No validation is done.
 	 */
@@ -481,22 +486,24 @@ xfs_inactive_symlink_rmt(
 			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
 		if (!bp) {
 			error = ENOMEM;
-			goto error1;
+			goto error_bmap_cancel;
 		}
 		xfs_trans_binval(tp, bp);
 	}
 	/*
 	 * Unmap the dead block(s) to the free_list.
 	 */
-	if ((error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
-			&first_block, &free_list, &done)))
-		goto error1;
+	error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
+			    &first_block, &free_list, &done);
+	if (error)
+		goto error_bmap_cancel;
 	ASSERT(done);
 	/*
 	 * Commit the first transaction.  This logs the EFI and the inode.
 	 */
-	if ((error = xfs_bmap_finish(&tp, &free_list, &committed)))
-		goto error1;
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto error_bmap_cancel;
 	/*
 	 * The transaction must have been committed, since there were
 	 * actually extents freed by xfs_bunmapi.  See xfs_bmap_finish.
@@ -508,29 +515,16 @@ xfs_inactive_symlink_rmt(
 	 * Mark it dirty so it will be logged and moved forward in the log as
 	 * part of every commit.
 	 */
-	xfs_trans_ijoin(tp, ip, 0);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
-	 * Get a new, empty transaction to return to our caller.
-	 */
-	ntp = xfs_trans_dup(tp);
-	/*
 	 * Commit the transaction containing extent freeing and EFDs.
-	 * If we get an error on the commit here or on the reserve below,
-	 * we need to unlock the inode since the new transaction doesn't
-	 * have the inode attached.
 	 */
-	error = xfs_trans_commit(tp, 0);
-	tp = ntp;
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		goto error0;
+		goto error_trans_cancel;
 	}
-	/*
-	 * transaction commit worked ok so we can drop the extra ticket
-	 * reference that we gained in xfs_trans_dup()
-	 */
-	xfs_log_ticket_put(tp->t_ticket);
 
 	/*
 	 * Remove the memory for extent descriptions (just bookkeeping).
@@ -538,23 +532,14 @@ xfs_inactive_symlink_rmt(
 	if (ip->i_df.if_bytes)
 		xfs_idata_realloc(ip, -ip->i_df.if_bytes, XFS_DATA_FORK);
 	ASSERT(ip->i_df.if_bytes == 0);
-	/*
-	 * Put an itruncate log reservation in the new transaction
-	 * for our caller.
-	 */
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
-	if (error) {
-		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		goto error0;
-	}
-
-	xfs_trans_ijoin(tp, ip, 0);
-	*tpp = tp;
 	return 0;
 
- error1:
+error_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
- error0:
+error_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+error_trans_cancel:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
 	return error;
 }
 
@@ -563,16 +548,13 @@ xfs_inactive_symlink_rmt(
  */
 int
 xfs_inactive_symlink(
-	struct xfs_inode	*ip,
-	struct xfs_trans	**tp)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			pathlen;
 
 	trace_xfs_inactive_symlink(ip);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -590,14 +572,19 @@ xfs_inactive_symlink(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		if (ip->i_df.if_bytes > 0)
+		if (ip->i_df.if_bytes > 0) 
 			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
 					  XFS_DATA_FORK);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(ip->i_df.if_bytes == 0);
 		return 0;
 	}
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
 	/* remove the remote symlink */
-	return xfs_inactive_symlink_rmt(ip, tp);
+	return xfs_inactive_symlink_rmt(ip);
 }
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index 99338ba..e75245d 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -22,6 +22,6 @@
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
-int xfs_inactive_symlink(struct xfs_inode *ip, struct xfs_trans **tpp);
+int xfs_inactive_symlink(struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_H */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
