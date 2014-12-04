Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 043AD7F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 08:54:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D70468F8035
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 06:54:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id heA3MJUOGKTesIlE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 06:54:00 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB4ErxJX009096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 4 Dec 2014 09:54:00 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sB4ErxsH027499
	for <xfs@oss.sgi.com>; Thu, 4 Dec 2014 09:53:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: initialize log buf I/O completion wq on log alloc
Date: Thu,  4 Dec 2014 09:53:58 -0500
Message-Id: <1417704838-30057-1-git-send-email-bfoster@redhat.com>
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

Log buffer I/O completion passes through the high priority
m_log_workqueue rather than the default metadata buffer workqueue. The
log buffer wq is initialized at I/O submission time. The log buffers are
reused once initialized, however, so this is not necessary.

Initialize the log buffer I/O completion workqueue pointers once when
the log is allocated and log buffers initialized rather than on every
log buffer I/O submission.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e408bf5..4f09e0f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1395,6 +1395,8 @@ xlog_alloc_log(
 	ASSERT(xfs_buf_islocked(bp));
 	xfs_buf_unlock(bp);
 
+	/* use high priority wq for log I/O completion */
+	bp->b_ioend_wq = mp->m_log_workqueue;
 	bp->b_iodone = xlog_iodone;
 	log->l_xbuf = bp;
 
@@ -1427,6 +1429,8 @@ xlog_alloc_log(
 		ASSERT(xfs_buf_islocked(bp));
 		xfs_buf_unlock(bp);
 
+		/* use high priority wq for log I/O completion */
+		bp->b_ioend_wq = mp->m_log_workqueue;
 		bp->b_iodone = xlog_iodone;
 		iclog->ic_bp = bp;
 		iclog->ic_data = bp->b_addr;
@@ -1806,8 +1810,6 @@ xlog_sync(
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_SYNCIO;
-	/* use high priority completion wq */
-	bp->b_ioend_wq = log->l_mp->m_log_workqueue;
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
 		bp->b_flags |= XBF_FUA;
@@ -1856,8 +1858,6 @@ xlog_sync(
 		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
-		/* use high priority completion wq */
-		bp->b_ioend_wq = log->l_mp->m_log_workqueue;
 
 		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
