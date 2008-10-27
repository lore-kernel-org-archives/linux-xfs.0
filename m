Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:57:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDfNTI024588
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:24 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A0EB54BB0D
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id aZ5Pr7OgC8LKn4Y0 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:23 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSLS-0000ps-TU
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:41:22 +0000
Date: Mon, 27 Oct 2008 09:41:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/6] remove dead code for old inode item recovery
Message-ID: <20081027134122.GC3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-remove-dead-log-recovery-code
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We have removed the support for old-style inode items a while ago and
xlog_recover_do_inode_trans is now only called for XFS_LI_INODE items.
That means we can remove the call to xfs_imap there and with it the
XFS_IMAP_LOOKUP that is set by all other callers.  We can also mark
xfs_imap static now.

(First sent on October 21st)


Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-10-25 13:26:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-10-25 13:28:32.000000000 +0200
@@ -2245,7 +2245,6 @@ xlog_recover_do_inode_trans(
 	xfs_inode_log_format_t	*in_f;
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
-	xfs_imap_t		imap;
 	xfs_dinode_t		*dip;
 	xfs_ino_t		ino;
 	int			len;
@@ -2273,48 +2272,29 @@ xlog_recover_do_inode_trans(
 	}
 	ino = in_f->ilf_ino;
 	mp = log->l_mp;
-	if (ITEM_TYPE(item) == XFS_LI_INODE) {
-		imap.im_blkno = (xfs_daddr_t)in_f->ilf_blkno;
-		imap.im_len = in_f->ilf_len;
-		imap.im_boffset = in_f->ilf_boffset;
-	} else {
-		/*
-		 * It's an old inode format record.  We don't know where
-		 * its cluster is located on disk, and we can't allow
-		 * xfs_imap() to figure it out because the inode btrees
-		 * are not ready to be used.  Therefore do not pass the
-		 * XFS_IMAP_LOOKUP flag to xfs_imap().  This will give
-		 * us only the single block in which the inode lives
-		 * rather than its cluster, so we must make sure to
-		 * invalidate the buffer when we write it out below.
-		 */
-		imap.im_blkno = 0;
-		error = xfs_imap(log->l_mp, NULL, ino, &imap, 0);
-		if (error)
-			goto error;
-	}
 
 	/*
 	 * Inode buffers can be freed, look out for it,
 	 * and do not replay the inode.
 	 */
-	if (xlog_check_buffer_cancelled(log, imap.im_blkno, imap.im_len, 0)) {
+	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
+					in_f->ilf_len, 0)) {
 		error = 0;
 		goto error;
 	}
 
-	bp = xfs_buf_read_flags(mp->m_ddev_targp, imap.im_blkno, imap.im_len,
-								XFS_BUF_LOCK);
+	bp = xfs_buf_read_flags(mp->m_ddev_targp, in_f->ilf_blkno,
+				in_f->ilf_len, XFS_BUF_LOCK);
 	if (XFS_BUF_ISERROR(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
-				  bp, imap.im_blkno);
+				  bp, in_f->ilf_blkno);
 		error = XFS_BUF_GETERROR(bp);
 		xfs_buf_relse(bp);
 		goto error;
 	}
 	error = 0;
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, in_f->ilf_boffset);
 
 	/*
 	 * Make sure the place we're flushing out to really looks
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-10-25 13:24:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-10-25 13:28:32.000000000 +0200
@@ -1262,8 +1262,7 @@ xfs_dilocate(
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
 	}
-	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) ||
-	    !(flags & XFS_IMAP_LOOKUP)) {
+	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 		*bno = XFS_AGB_TO_FSB(mp, agno, agbno);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-10-25 13:26:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-10-25 13:28:32.000000000 +0200
@@ -237,7 +237,7 @@ xfs_inotobp(
 	int		error;
 
 	imap.im_blkno = 0;
-	error = xfs_imap(mp, tp, ino, &imap, imap_flags | XFS_IMAP_LOOKUP);
+	error = xfs_imap(mp, tp, ino, &imap, imap_flags);
 	if (error)
 		return error;
 
@@ -868,8 +868,7 @@ xfs_iread(
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
 	imap.im_blkno = bno;
-	error = xfs_imap(mp, tp, ip->i_ino, &imap,
-				XFS_IMAP_LOOKUP | imap_flags);
+	error = xfs_imap(mp, tp, ip->i_ino, &imap, imap_flags);
 	if (error)
 		goto out_destroy_inode;
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:26:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:28:32.000000000 +0200
@@ -159,8 +159,7 @@ typedef struct xfs_icdinode {
 /*
  * Flags for xfs_inotobp, xfs_imap() and xfs_dilocate().
  */
-#define XFS_IMAP_LOOKUP		0x1
-#define XFS_IMAP_BULKSTAT	0x2
+#define XFS_IMAP_BULKSTAT	0x1
 
 /*
  * Fork handling.

-- 
