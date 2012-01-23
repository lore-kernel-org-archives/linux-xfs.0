Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHVXfa122726 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:31:33 -0600
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id 09hJjrdtgifYgoT2 for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:31:32 -0800 (PST)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:31:31 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 0D63E1FF0049
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:29 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHVQ1J269800 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 12:31:26 -0500
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q0NHVP7t004524
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:25 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:31:25 -0600
Message-Id: <20120123173125.31546.2342.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 1/4] Define a new function xfs_this_quota_on()
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Create a new function xfs_this_quota_on() that takes a xfs_mount
data srtucture and a disk quota type and returns true if the specified
type of quota is ON in the xfs_mount data structure.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c |    4 ++--
 fs/xfs/xfs_dquot.h |   18 ++++++++++++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index a1d91d8..221b22e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -115,6 +115,20 @@ static inline void xfs_dqunlock_nonotify(struct xfs_dquot *dqp)
 	mutex_unlock(&dqp->q_qlock);
 }
 
+static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
+{
+	type &= XFS_DQ_ALLTYPES;
+	switch(type) {
+	case XFS_DQ_USER:
+		return XFS_IS_UQUOTA_ON(mp);
+	case XFS_DQ_GROUP:
+	case XFS_DQ_PROJ:
+		return XFS_IS_OQUOTA_ON(mp);
+	default:
+		return 0;
+	}
+}
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
@@ -125,10 +139,6 @@ static inline void xfs_dqunlock_nonotify(struct xfs_dquot *dqp)
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
 				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
-#define XFS_IS_THIS_QUOTA_OFF(d) (! (XFS_QM_ISUDQ(d) ? \
-				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
-				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
-
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index b4ff40b..4c8b3d2 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -358,7 +358,7 @@ xfs_qm_dqalloc(
 	 * Return if this type of quotas is turned off while we didn't
 	 * have an inode lock
 	 */
-	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
+	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 		return (ESRCH);
 	}
@@ -460,7 +460,7 @@ xfs_qm_dqtobp(
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
 	xfs_ilock(quotip, XFS_ILOCK_SHARED);
-	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
+	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
