Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 23:27:01 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A6Qvop009019
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 23:26:58 -0700
Message-ID: <48EEF60D.4020602@sgi.com>
Date: Fri, 10 Oct 2008 17:28:29 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] fix barrier fail detection in XFS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>, Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, toei.rei@stargazer.at

Hi Linus,

Please include the following patch.

This is an important fix posted by Christoph Hellwig today.
Without this fix, XFS can turn off barriers when we wrap our ondisk log.
Which could lead to corruption after unclean unmounts/shutdowns
on machines without a persistent write cache etc.

--Tim

---------------
Fix barrier fail detection in XFS

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
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: David Chinner <david@fromorbit.com>
Signed-off-by: Tim Shimmin <tes@sgi.com>

Index: 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-09-19 13:47:36.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.c	2008-10-10 15:07:51.316145158 +1100
@@ -1001,12 +1001,13 @@ xfs_buf_iodone_work(
 	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
 	 * ordered flag and reissue them.  Because we can't tell the higher
 	 * layers directly that they should not issue ordered I/O anymore, they
-	 * need to check if the ordered flag was cleared during I/O completion.
+	 * need to check if the _XFS_BARRIER_FAILED flag was set during I/O completion.
 	 */
 	if ((bp->b_error == EOPNOTSUPP) &&
 	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
 		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
 		bp->b_flags &= ~XBF_ORDERED;
+		bp->b_flags |= _XFS_BARRIER_FAILED;
 		xfs_buf_iorequest(bp);
 	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
Index: 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-09-19 13:47:36.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/linux-2.6/xfs_buf.h	2008-10-10 11:54:23.269373217 +1100
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
Index: 2.6.x-xfs-quilt/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_log.c	2008-09-22 11:54:19.000000000 +1000
+++ 2.6.x-xfs-quilt/fs/xfs/xfs_log.c	2008-10-10 15:09:56.967725107 +1100
@@ -1033,11 +1033,12 @@ xlog_iodone(xfs_buf_t *bp)
 	l = iclog->ic_log;
 
 	/*
-	 * If the ordered flag has been removed by a lower
-	 * layer, it means the underlyin device no longer supports
+	 * If the _XFS_BARRIER_FAILED flag was set by a lower
+	 * layer, it means the underlying device no longer supports
 	 * barrier I/O. Warn loudly and turn off barriers.
 	 */
-	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ISORDERED(bp)) {
+	if (bp->b_flags & _XFS_BARRIER_FAILED) {
+		bp->b_flags &= ~_XFS_BARRIER_FAILED;
 		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"
