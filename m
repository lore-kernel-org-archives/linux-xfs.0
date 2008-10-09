Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 05:59:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99Cx82Z016267
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 05:59:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B7E813C7019
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 06:00:48 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id qQdx1whfEeAOaILs for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 06:00:48 -0700 (PDT)
Date: Thu, 9 Oct 2008 15:00:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix barrier fail detection
Message-ID: <20081009130042.GA21071@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, toei.rei@stargazer.at

Currently we disable barriers as soon as we get a buffer in xlog_iodone
that has the XBF_ORDERED flag cleared.  But this can be the case not only
for buffers where the barrier failed, but also the first buffer of a
split log write in case of a log wraparound.  Due to the disabled
barriers we can easily get directory corruption on unclean shutdowns.
So instead of using this check add a new buffer flag for failed barrier
writes.

This is a regression vs 2.6.26 caused by patch to use the right macro
to check for the ORDERED flag, as we previously got true returned for
every buffer.

Thanks to Toei Rei for reporting the bug.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-10-09 13:36:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-10-09 13:38:38.000000000 +0200
@@ -1007,6 +1007,7 @@ xfs_buf_iodone_work(
 	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
 		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
 		bp->b_flags &= ~XBF_ORDERED;
+		bp->b_flags |= _XFS_BARRIER_FAILED;
 		xfs_buf_iorequest(bp);
 	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-10-09 13:36:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2008-10-09 13:38:15.000000000 +0200
@@ -85,6 +85,14 @@ typedef enum {
 	 * modifications being lost.
 	 */
 	_XBF_PAGE_LOCKED = (1 << 22),
+
+	/*
+	 * If we try a barrier write, but it fails we have to communicate
+	 * this to the upper layers.  Unfortunately b_error gets overwritten
+	 * when the buffer is re-issued so we have to add another flag to
+	 * keep this information.
+	 */
+	_XFS_BARRIER_FAILED = (1 << 23),
 } xfs_buf_flags_t;
 
 typedef enum {
Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-10-09 13:38:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-10-09 13:39:32.000000000 +0200
@@ -1037,7 +1037,8 @@ xlog_iodone(xfs_buf_t *bp)
 	 * layer, it means the underlyin device no longer supports
 	 * barrier I/O. Warn loudly and turn off barriers.
 	 */
-	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ISORDERED(bp)) {
+	if (bp->b_flags & _XFS_BARRIER_FAILED) {
+		bp->b_flags &= ~_XFS_BARRIER_FAILED;
 		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"
