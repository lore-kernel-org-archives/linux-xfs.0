Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o475dKgR148915 for <xfs@oss.sgi.com>; Fri, 7 May 2010 00:39:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E664318A3C
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 22:41:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	txuk9a9suEHNbWCz for <xfs@oss.sgi.com>;
	Thu, 06 May 2010 22:41:29 -0700 (PDT)
Received: from dastard (unverified [121.45.169.108])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23556264-1927428
	for <xfs@oss.sgi.com>; Fri, 07 May 2010 15:11:28 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OAGJJ-0006rr-QY
	for xfs@oss.sgi.com; Fri, 07 May 2010 15:41:17 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OAGJD-00066j-5y
	for xfs@oss.sgi.com; Fri, 07 May 2010 15:41:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/12] xfs: forced unmounts need to push the CIL
Date: Fri,  7 May 2010 15:40:58 +1000
Message-Id: <1273210860-23414-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1273210860-23414-1-git-send-email-david@fromorbit.com>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If the filesystem is being shut down and the there is no log error,
the current code forces out the current log buffers. This code now needs
to push the CIL before it forces out the log buffers to acheive the same
result.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 23f2a05..7144a9e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3691,6 +3691,11 @@ xlog_state_ioerror(
  *	c. nothing new gets queued up after (a) and (b) are done.
  *	d. if !logerror, flush the iclogs to disk, then seal them off
  *	   for business.
+ *
+ * Note: for delayed logging the !logerror case needs to flush the regions
+ * held in memory out to the iclogs before flushing them to disk. This needs
+ * to be done before the log is marked as shutdown, otherwise the flush to the
+ * iclogs will fail.
  */
 int
 xfs_log_force_umount(
@@ -3724,6 +3729,16 @@ xfs_log_force_umount(
 		return 1;
 	}
 	retval = 0;
+
+	/*
+	 * Flush the in memory commit item list before marking the log as
+	 * being shut down. We need to do it in this order to ensure all the
+	 * completed transactions are flushed to disk with the xfs_log_force()
+	 * call below.
+	 */
+	if (!logerror && (mp->m_flags & XFS_MOUNT_DELAYLOG))
+		xlog_cil_push(log, 1);
+
 	/*
 	 * We must hold both the GRANT lock and the LOG lock,
 	 * before we mark the filesystem SHUTDOWN and wake
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
