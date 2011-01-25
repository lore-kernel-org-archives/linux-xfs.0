Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8ouwo224481 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:50:56 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 470211056557
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:53:18 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FN6Et64gaA6NvISn for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:53:18 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PheeJ-0003xl-1v
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:53:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Phebw-0007gZ-RC
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: handle CIl transaction commit failures correctly
Date: Tue, 25 Jan 2011 19:50:43 +1100
Message-Id: <1295945444-29488-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_log.h     |    2 +-
 fs/xfs/xfs_log_cil.c |    7 +------
 fs/xfs/xfs_trans.c   |    4 +---
 3 files changed, 3 insertions(+), 10 deletions(-)

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
index c7eac5a..4f9ba86 100644
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
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 27ecb74..f1ce10f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1769,9 +1769,7 @@ xfs_trans_commit_cil(
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
