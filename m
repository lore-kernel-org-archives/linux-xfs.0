Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:39:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDdcWH023304
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:39 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75EFD1487F23
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id B8ZIIqDy6rnJSXzY for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSJm-0000Ja-2F
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:39:38 +0000
Date: Mon, 27 Oct 2008 09:39:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] split up xlog_recover_process_iunlinks
Message-ID: <20081027133938.GH1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-split-xlog_recover_process_iunlinks
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Split out the body of the main loop into a separate helper to make the
code readable.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-10-25 13:22:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-10-25 13:26:44.000000000 +0200
@@ -3147,6 +3147,70 @@ out_error:
 	return;
 }
 
+STATIC xfs_agino_t
+xlog_recover_process_one_iunlink(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	xfs_agino_t			agino,
+	int				bucket)
+{
+	struct xfs_buf			*ibp;
+	struct xfs_dinode		*dip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	int				error;
+
+	ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	error = xfs_iget(mp, NULL, ino, 0, 0, &ip, 0);
+	if (error)
+		goto fail;
+
+	/*
+	 * Get the on disk inode to find the next inode in the bucket.
+	 */
+	ASSERT(ip != NULL);
+	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
+	if (error)
+		goto fail;
+
+	ASSERT(dip != NULL);
+	ASSERT(ip->i_d.di_nlink == 0);
+
+	/* setup for the next pass */
+	agino = be32_to_cpu(dip->di_next_unlinked);
+	xfs_buf_relse(ibp);
+
+	/*
+	 * Prevent any DMAPI event from being sent when the reference on
+	 * the inode is dropped.
+	 */
+	ip->i_d.di_dmevmask = 0;
+
+	/*
+	 * If this is a new inode, handle it specially.  Otherwise, just
+	 * drop our reference to the inode.  If there are no other
+	 * references, this will send the inode to xfs_inactive() which
+	 * will truncate the file and free the inode.
+	 */
+	if (ip->i_d.di_mode == 0)
+		xfs_iput_new(ip, 0);
+	else
+		IRELE(ip);
+	return agino;
+
+ fail:
+	/*
+	 * We can't read in the inode this bucket points to, or this inode
+	 * is messed up.  Just ditch this bucket of inodes.  We will lose
+	 * some inodes and space, but at least we won't hang.
+	 *
+	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
+	 * clear the inode pointer in the bucket.
+	 */
+	xlog_recover_clear_agi_bucket(mp, agno, bucket);
+	return NULLAGINO;
+}
+
 /*
  * xlog_iunlink_recover
  *
@@ -3167,11 +3231,7 @@ xlog_recover_process_iunlinks(
 	xfs_agnumber_t	agno;
 	xfs_agi_t	*agi;
 	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_dinode_t	*dip;
-	xfs_inode_t	*ip;
 	xfs_agino_t	agino;
-	xfs_ino_t	ino;
 	int		bucket;
 	int		error;
 	uint		mp_dmevmask;
@@ -3205,10 +3265,8 @@ xlog_recover_process_iunlinks(
 		agi = XFS_BUF_TO_AGI(agibp);
 
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
-
 			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 			while (agino != NULLAGINO) {
-
 				/*
 				 * Release the agi buffer so that it can
 				 * be acquired in the normal course of the
@@ -3216,68 +3274,8 @@ xlog_recover_process_iunlinks(
 				 */
 				xfs_buf_relse(agibp);
 
-				ino = XFS_AGINO_TO_INO(mp, agno, agino);
-				error = xfs_iget(mp, NULL, ino, 0, 0, &ip, 0);
-				ASSERT(error || (ip != NULL));
-
-				if (!error) {
-					/*
-					 * Get the on disk inode to find the
-					 * next inode in the bucket.
-					 */
-					error = xfs_itobp(mp, NULL, ip, &dip,
-							&ibp, 0, 0,
-							XFS_BUF_LOCK);
-					ASSERT(error || (dip != NULL));
-				}
-
-				if (!error) {
-					ASSERT(ip->i_d.di_nlink == 0);
-
-					/* setup for the next pass */
-					agino = be32_to_cpu(
-							dip->di_next_unlinked);
-					xfs_buf_relse(ibp);
-					/*
-					 * Prevent any DMAPI event from
-					 * being sent when the
-					 * reference on the inode is
-					 * dropped.
-					 */
-					ip->i_d.di_dmevmask = 0;
-
-					/*
-					 * If this is a new inode, handle
-					 * it specially.  Otherwise,
-					 * just drop our reference to the
-					 * inode.  If there are no
-					 * other references, this will
-					 * send the inode to
-					 * xfs_inactive() which will
-					 * truncate the file and free
-					 * the inode.
-					 */
-					if (ip->i_d.di_mode == 0)
-						xfs_iput_new(ip, 0);
-					else
-						IRELE(ip);
-				} else {
-					/*
-					 * We can't read in the inode
-					 * this bucket points to, or
-					 * this inode is messed up.  Just
-					 * ditch this bucket of inodes.  We
-					 * will lose some inodes and space,
-					 * but at least we won't hang.  Call
-					 * xlog_recover_clear_agi_bucket()
-					 * to perform a transaction to clear
-					 * the inode pointer in the bucket.
-					 */
-					xlog_recover_clear_agi_bucket(mp, agno,
-							bucket);
-
-					agino = NULLAGINO;
-				}
+				agino = xlog_recover_process_one_iunlink(mp,
+							agno, agino, bucket);
 
 				/*
 				 * Reacquire the agibuffer and continue around

-- 
