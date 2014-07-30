Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F1E67F86
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 20:49:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 61BED30405F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:49:10 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zoRQKmvJdfCI2yp8 for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 18:49:08 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCJ0c-0001HD-Qu
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCJ0c-0002uf-QD
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: dquot recovery needs verifiers
Date: Wed, 30 Jul 2014 11:48:49 +1000
Message-Id: <1406684929-11133-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1406684929-11133-1-git-send-email-david@fromorbit.com>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
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

dquot recovery should add verifiers to the dquot buffers that it
recovers changes into. Unfortunately, it doesn't attached the
verifiers to the buffers in a consistent manner. For example,
xlog_recover_dquot_pass2() reads dquot buffers without a verifier
and then writes it without ever having attached a verifier to the
buffer.

Further, dquot buffer recovery may write a dquot buffer that has not
been modified, or indeed, shoul dbe written because quotas are not
enabled and hence changes to the buffer were not replayed. In this
case, we again write buffers without verifiers attached because that
doesn't happen until after the buffer changes have been replayed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0a015cc..d651199 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2403,8 +2403,11 @@ xlog_recover_do_reg_buffer(
  * Simple algorithm: if we have found a QUOTAOFF log item of the same type
  * (ie. USR or GRP), then just toss this buffer away; don't recover it.
  * Else, treat it as a regular buffer and do recovery.
+ *
+ * Return false if the buffer was tossed and true if we recovered the buffer to
+ * indicate to the caller if the buffer needs writing.
  */
-STATIC void
+STATIC bool
 xlog_recover_do_dquot_buffer(
 	struct xfs_mount		*mp,
 	struct xlog			*log,
@@ -2419,9 +2422,8 @@ xlog_recover_do_dquot_buffer(
 	/*
 	 * Filesystems are required to send in quota flags at mount time.
 	 */
-	if (mp->m_qflags == 0) {
-		return;
-	}
+	if (!mp->m_qflags == 0)
+		return false;
 
 	type = 0;
 	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
@@ -2434,9 +2436,10 @@ xlog_recover_do_dquot_buffer(
 	 * This type of quotas was turned off, so ignore this buffer
 	 */
 	if (log->l_quotaoffs_flag & type)
-		return;
+		return false;
 
 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
+	return true;
 }
 
 /*
@@ -2529,14 +2532,18 @@ xlog_recover_buffer_pass2(
 
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
 		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
+		if (error)
+			goto out_release;
 	} else if (buf_f->blf_flags &
 		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-		xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
+		bool	dirty;
+
+		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
+		if (!dirty)
+			goto out_release;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 	}
-	if (error)
-		goto out_release;
 
 	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
@@ -3026,9 +3033,16 @@ xlog_recover_dquot_pass2(
 		return -EIO;
 	ASSERT(dq_f->qlf_len == 1);
 
+	/*
+	 * At this point we are assuming that the dquots have been allocated
+	 * and hence the buffer has valid dquots stamped in it. It should,
+	 * therefore, pass verifier validation. If the dquot is bad, then the
+	 * we'll return an error here, so we don't need to specifically check
+	 * the dquot in the buffer after the verifier has run.
+	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
 				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
-				   NULL);
+				   &xfs_dquot_buf_ops);
 	if (error)
 		return error;
 
@@ -3036,18 +3050,6 @@ xlog_recover_dquot_pass2(
 	ddq = (xfs_disk_dquot_t *)xfs_buf_offset(bp, dq_f->qlf_boffset);
 
 	/*
-	 * At least the magic num portion should be on disk because this
-	 * was among a chunk of dquots created earlier, and we did some
-	 * minimal initialization then.
-	 */
-	error = xfs_dqcheck(mp, ddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
-			   "xlog_recover_dquot_pass2");
-	if (error) {
-		xfs_buf_relse(bp);
-		return -EIO;
-	}
-
-	/*
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
