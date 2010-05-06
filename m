Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o461i1ek065016 for <xfs@oss.sgi.com>; Wed, 5 May 2010 20:44:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFECB1B0A17B
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 18:46:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	oEIuuqgC2UrMJLrl for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 18:46:09 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23118559-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 11:16:08 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O9qAB-0005Dv-H3
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:46:07 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O9qA5-0000cc-OW
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:46:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/11] xfs: forced unmounts need to push the CIL
Date: Thu,  6 May 2010 11:45:49 +1000
Message-Id: <1273110351-2333-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1273110351-2333-1-git-send-email-david@fromorbit.com>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
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
index 88cdfac..7aabd79 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3684,6 +3684,11 @@ xlog_state_ioerror(
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
@@ -3717,6 +3722,16 @@ xfs_log_force_umount(
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
