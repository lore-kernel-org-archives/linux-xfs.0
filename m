Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3rnCQ184606 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:49 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF0C91A2DFE3
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:12 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bszN7QRlyzho4GJv for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:12 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxs-0008FS-6E
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:56:08 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvF-0004TI-PE
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: handle CIl transaction commit failures correctly
Date: Thu, 27 Jan 2011 14:53:20 +1100
Message-Id: <1296100401-17135-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1296100401-17135-1-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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

Failure to commit a transaction into the CIL is not handled
correctly. This currently can only happen when racing with a
shutdown and requires an explicit shutdown check, so it rare and can
be avoided. Remove the shutdown check and make the CIL commit a void
function to indicate it will always succeed, thereby removing the
incorrectly handled failure case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_log.h     |    2 +-
 fs/xfs/xfs_log_cil.c |    8 +-------
 fs/xfs/xfs_trans.c   |    5 +----
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 916eb7d..3bd3291 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -191,7 +191,7 @@ void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
 xlog_tid_t xfs_log_get_trans_ident(struct xfs_trans *tp);
 
-int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
+void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				struct xfs_log_vec *log_vector,
 				xfs_lsn_t *commit_lsn, int flags);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c7eac5a..9ca59be 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -625,7 +625,7 @@ out_abort:
  * background commit, returns without it held once background commits are
  * allowed again.
  */
-int
+void
 xfs_log_commit_cil(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -640,11 +640,6 @@ xfs_log_commit_cil(
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
 
-	if (XLOG_FORCED_SHUTDOWN(log)) {
-		xlog_cil_free_logvec(log_vector);
-		return XFS_ERROR(EIO);
-	}
-
 	/*
 	 * do all the hard work of formatting items (including memory
 	 * allocation) outside the CIL context lock. This prevents stalling CIL
@@ -704,7 +699,6 @@ xfs_log_commit_cil(
 	 */
 	if (push)
 		xlog_cil_push(log, 0);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 29f5e54..7692279 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1755,7 +1755,6 @@ xfs_trans_commit_cil(
 	int			flags)
 {
 	struct xfs_log_vec	*log_vector;
-	int			error;
 
 	/*
 	 * Get each log item to allocate a vector structure for
@@ -1766,9 +1765,7 @@ xfs_trans_commit_cil(
 	if (!log_vector)
 		return ENOMEM;
 
-	error = xfs_log_commit_cil(mp, tp, log_vector, commit_lsn, flags);
-	if (error)
-		return error;
+	xfs_log_commit_cil(mp, tp, log_vector, commit_lsn, flags);
 
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free(tp);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
