Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FArCw3004037 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 05:53:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3E4E199FD6
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:52:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail08.adl2.internode.on.net
	[203.16.214.72]) by cuda.sgi.com with ESMTP id yGJhZCJvZCInCKRF
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:52:49 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	44229080-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:22:46 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LinxL-0004rI-H4
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 21:52:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] [XFS] Validate log feature fields correctly
Date: Sun, 15 Mar 2009 21:52:34 +1100
Message-Id: <1237114355-18647-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1237114355-18647-1-git-send-email-david@fromorbit.com>
References: <1237114355-18647-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dgc@evostor.com>

If the large log sector size feature bit is set in the
superblock by accident (say disk corruption), the then
fields that are now considered valid are not checked on
production kernels. The checks are present as ASSERT
statements so cause a panic on a debug kernel.

Change this so that the fields are validity checked if
the feature bit is set and abort the log mount if the
fields do not contain valid values.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c |   41 ++++++++++++++++++++++++++++++-----------
 1 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c8f3008..60e6e63 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -562,9 +562,8 @@ xfs_log_mount(
 	}
 
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
-	if (!mp->m_log) {
-		cmn_err(CE_WARN, "XFS: Log allocation failed: No memory!");
-		error = ENOMEM;
+	if (IS_ERR(mp->m_log)) {
+		error = -PTR_ERR(mp->m_log);
 		goto out;
 	}
 
@@ -1193,10 +1192,13 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xfs_buf_t		*bp;
 	int			i;
 	int			iclogsize;
+	int			error = ENOMEM;
 
 	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
-	if (!log)
-		return NULL;
+	if (!log) {
+		xlog_warn("XFS: Log allocation failed: No memory!");
+		goto out;
+	}
 
 	log->l_mp	   = mp;
 	log->l_targ	   = log_target;
@@ -1214,19 +1216,35 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_grant_reserve_cycle = 1;
 	log->l_grant_write_cycle = 1;
 
+	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
 		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
+		if (log->l_sectbb_log < 0 ||
+		    log->l_sectbb_log > mp->m_sectbb_log) {
+			xlog_warn("XFS: Log sector size (0x%x) out of range.",
+						log->l_sectbb_log);
+			goto out_free_log;
+		}
+
 		/* for larger sector sizes, must have v2 or external log */
-		ASSERT(log->l_sectbb_log == 0 ||
-			log->l_logBBstart == 0 ||
-			xfs_sb_version_haslogv2(&mp->m_sb));
-		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
+		if (log->l_sectbb_log != 0 &&
+		    (log->l_logBBstart != 0 &&
+		     !xfs_sb_version_haslogv2(&mp->m_sb))) {
+			xlog_warn("XFS: log sector size (0x%x) invalid "
+				  "for configuration.", log->l_sectbb_log);
+			goto out_free_log;
+		}
+		if (mp->m_sb.sb_logsectlog < BBSHIFT) {
+			xlog_warn("XFS: Log sector log (0x%x) too small.",
+						mp->m_sb.sb_logsectlog);
+			goto out_free_log;
+		}
 	}
 	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
 
 	xlog_get_iclog_buffer_size(mp, log);
 
+	error = ENOMEM;
 	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
 	if (!bp)
 		goto out_free_log;
@@ -1326,7 +1344,8 @@ out_free_iclog:
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
-	return NULL;
+out:
+	return ERR_PTR(-error);
 }	/* xlog_alloc_log */
 
 
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
