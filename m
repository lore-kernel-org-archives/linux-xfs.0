Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C2D57F9A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5C4E8F804C
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pVRGT3vBttjag3fD for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006n9-RG
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gK-QG
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/11] xfs: force the log before shutting down
Date: Thu, 25 Sep 2014 22:34:11 +1000
Message-Id: <1411648461-29003-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1411648461-29003-1-git-send-email-david@fromorbit.com>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we have marked the filesystem for shutdown, we want to prevent
any further buffer IO from being submitted. However, we currently
force the log after marking the filesystem as shut down, hence
allowing IO to the log *after* we have marked both the filesystem
and the log as in an error state.

Clean this up by forcing the log before we mark the filesytem with
an error. This replaces the pure CIL flush that we currently have
which works around this same issue (i.e the CIL can't be flushed
once the shutdown flags are set) and hence enables us to clean up
the logic substantially.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b1131fe..a598955 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3924,13 +3924,14 @@ xfs_log_force_umount(
 	retval = 0;
 
 	/*
-	 * Flush the in memory commit item list before marking the log as
-	 * being shut down. We need to do it in this order to ensure all the
-	 * completed transactions are flushed to disk with the xfs_log_force()
-	 * call below.
+	 * Flush all the completed transactions to disk before marking the log
+	 * being shut down. We need to do it in this order to ensure that
+	 * completed operations are safely on disk before we shut down, and that
+	 * we don't have to issue any buffer IO after the shutdown flags are set
+	 * to guarantee this.
 	 */
 	if (!logerror)
-		xlog_cil_force(log);
+		_xfs_log_force(mp, XFS_LOG_SYNC, NULL);
 
 	/*
 	 * mark the filesystem and the as in a shutdown state and wake
@@ -3942,18 +3943,11 @@ xfs_log_force_umount(
 		XFS_BUF_DONE(mp->m_sb_bp);
 
 	/*
-	 * This flag is sort of redundant because of the mount flag, but
-	 * it's good to maintain the separation between the log and the rest
-	 * of XFS.
+	 * Mark the log and the iclogs with IO error flags to prevent any
+	 * further log IO from being issued or completed.
 	 */
 	log->l_flags |= XLOG_IO_ERROR;
-
-	/*
-	 * If we hit a log error, we want to mark all the iclogs IOERROR
-	 * while we're still holding the loglock.
-	 */
-	if (logerror)
-		retval = xlog_state_ioerror(log);
+	retval = xlog_state_ioerror(log);
 	spin_unlock(&log->l_icloglock);
 
 	/*
@@ -3966,19 +3960,6 @@ xfs_log_force_umount(
 	xlog_grant_head_wake_all(&log->l_reserve_head);
 	xlog_grant_head_wake_all(&log->l_write_head);
 
-	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
-		ASSERT(!logerror);
-		/*
-		 * Force the incore logs to disk before shutting the
-		 * log down completely.
-		 */
-		_xfs_log_force(mp, XFS_LOG_SYNC, NULL);
-
-		spin_lock(&log->l_icloglock);
-		retval = xlog_state_ioerror(log);
-		spin_unlock(&log->l_icloglock);
-	}
-
 	/*
 	 * Wake up everybody waiting on xfs_log_force. Wake the CIL push first
 	 * as if the log writes were completed. The abort handling in the log
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
