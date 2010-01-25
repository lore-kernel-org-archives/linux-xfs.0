Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P6Lx2k037544 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:21:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C6421C767A7
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 22:23:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	LF0L7eGfmeOCJ9rx for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 22:23:01 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11565361-1927428
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 16:53:00 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZILY-0002xW-Gh
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:48 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZILX-0003o9-F2
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: kill the unused XFS_QMOPT_* flush flags
Date: Mon, 25 Jan 2010 17:22:43 +1100
Message-Id: <1264400564-19704-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1264400564-19704-1-git-send-email-david@fromorbit.com>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
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

dquots are never flushed asynchronously. Remove the flag and the
async write support from the flush function. Make the default flush
a delwri flush to make the inode flush code, which leaves the
XFS_QMOPT_SYNC the only flag remaining.  Convert that to use
SYNC_WAIT instead, just like the inode flush code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c      |   13 ++++++-------
 fs/xfs/quota/xfs_dquot_item.c |    2 +-
 fs/xfs/quota/xfs_qm.c         |   14 ++++++--------
 fs/xfs/xfs_quota.h            |    8 +-------
 4 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 1620a56..5f79dd7 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1187,7 +1187,7 @@ xfs_qm_dqflush(
 	 * block, nada.
 	 */
 	if (!XFS_DQ_IS_DIRTY(dqp) ||
-	    (!(flags & XFS_QMOPT_SYNC) && atomic_read(&dqp->q_pincount) > 0)) {
+	    (!(flags & SYNC_WAIT) && atomic_read(&dqp->q_pincount) > 0)) {
 		xfs_dqfunlock(dqp);
 		return 0;
 	}
@@ -1251,18 +1251,17 @@ xfs_qm_dqflush(
 		xfs_log_force(mp, 0);
 	}
 
-	if (flags & XFS_QMOPT_DELWRI) {
-		xfs_bdwrite(mp, bp);
-	} else {
+	if (flags & SYNC_WAIT)
 		error = xfs_bwrite(mp, bp);
-	}
+	else
+		xfs_bdwrite(mp, bp);
 
 	trace_xfs_dqflush_done(dqp);
 
 	/*
 	 * dqp is still locked, but caller is free to unlock it now.
 	 */
-	return (error);
+	return error;
 
 }
 
@@ -1443,7 +1442,7 @@ xfs_qm_dqpurge(
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_qm_dqflush(dqp, XFS_QMOPT_SYNC);
+		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
 		if (error)
 			xfs_fs_cmn_err(CE_WARN, mp,
 				"xfs_qm_dqpurge: dquot %p flush failed", dqp);
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index dda0fb0..4e4ee9a 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -153,7 +153,7 @@ xfs_qm_dquot_logitem_push(
 	 * lock without sleeping, then there must not have been
 	 * anyone in the process of flushing the dquot.
 	 */
-	error = xfs_qm_dqflush(dqp, XFS_QMOPT_DELWRI);
+	error = xfs_qm_dqflush(dqp, 0);
 	if (error)
 		xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
 			"xfs_qm_dquot_logitem_push: push error %d on dqp %p",
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 11cfd82..8112a26 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -450,7 +450,7 @@ xfs_qm_unmount_quotas(
 STATIC int
 xfs_qm_dqflush_all(
 	xfs_mount_t	*mp,
-	int		flags)
+	int		sync_mode)
 {
 	int		recl;
 	xfs_dquot_t	*dqp;
@@ -486,7 +486,7 @@ again:
 		 * across a disk write.
 		 */
 		xfs_qm_mplist_unlock(mp);
-		error = xfs_qm_dqflush(dqp, flags);
+		error = xfs_qm_dqflush(dqp, sync_mode);
 		xfs_dqunlock(dqp);
 		if (error)
 			return error;
@@ -926,13 +926,11 @@ xfs_qm_sync(
 {
 	int		recl, restarts;
 	xfs_dquot_t	*dqp;
-	uint		flush_flags;
 	int		error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	flush_flags = (flags & SYNC_WAIT) ? XFS_QMOPT_SYNC : XFS_QMOPT_DELWRI;
 	restarts = 0;
 
   again:
@@ -992,7 +990,7 @@ xfs_qm_sync(
 		 * across a disk write
 		 */
 		xfs_qm_mplist_unlock(mp);
-		error = xfs_qm_dqflush(dqp, flush_flags);
+		error = xfs_qm_dqflush(dqp, (flags & SYNC_WAIT));
 		xfs_dqunlock(dqp);
 		if (error && XFS_FORCED_SHUTDOWN(mp))
 			return 0;	/* Need to prevent umount failure */
@@ -1796,7 +1794,7 @@ xfs_qm_quotacheck(
 	 * successfully.
 	 */
 	if (!error)
-		error = xfs_qm_dqflush_all(mp, XFS_QMOPT_DELWRI);
+		error = xfs_qm_dqflush_all(mp, 0);
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside
@@ -2018,7 +2016,7 @@ xfs_qm_shake_freelist(
 			 * We flush it delayed write, so don't bother
 			 * releasing the mplock.
 			 */
-			error = xfs_qm_dqflush(dqp, XFS_QMOPT_DELWRI);
+			error = xfs_qm_dqflush(dqp, 0);
 			if (error) {
 				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
 			"xfs_qm_dqflush_all: dquot %p flush failed", dqp);
@@ -2201,7 +2199,7 @@ xfs_qm_dqreclaim_one(void)
 			 * We flush it delayed write, so don't bother
 			 * releasing the freelist lock.
 			 */
-			error = xfs_qm_dqflush(dqp, XFS_QMOPT_DELWRI);
+			error = xfs_qm_dqflush(dqp, 0);
 			if (error) {
 				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
 			"xfs_qm_dqreclaim: dquot %p flush failed", dqp);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 21d11d9..fdcab3f 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -223,15 +223,9 @@ typedef struct xfs_qoff_logformat {
 #define XFS_QMOPT_RES_INOS	0x0800000
 
 /*
- * flags for dqflush and dqflush_all.
- */
-#define XFS_QMOPT_SYNC		0x1000000
-#define XFS_QMOPT_DELWRI	0x4000000
-
-/*
  * flags for dqalloc.
  */
-#define XFS_QMOPT_INHERIT	0x8000000
+#define XFS_QMOPT_INHERIT	0x1000000
 
 /*
  * flags to xfs_trans_mod_dquot.
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
