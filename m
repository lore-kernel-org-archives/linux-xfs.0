Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HNMe9D014518 for <xfs@oss.sgi.com>; Mon, 17 May 2010 18:22:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8F3235370C
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:24:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	UiBhu21HA1Qeq1en for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 16:24:56 -0700 (PDT)
Received: from dastard (unverified [121.44.136.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24605628-1927428
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:54:55 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OE9g6-00059y-F2
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:54 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OE9fr-0000Ru-KL
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/12] xfs: forced unmounts need to push the CIL
Date: Tue, 18 May 2010 09:24:26 +1000
Message-Id: <1274138668-1662-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1274138668-1662-1-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 027ebfe..5215abc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3688,6 +3688,11 @@ xlog_state_ioerror(
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
@@ -3721,6 +3726,16 @@ xfs_log_force_umount(
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
