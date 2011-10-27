Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RM8AjO122628 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 17:08:10 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04DEF1FE5D6
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:08:09 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id EO5WoHDdUpE9G9DE for
	<xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:08:09 -0700 (PDT)
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Oct 2011 18:05:40 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9RM5VS6280938 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 18:05:31 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p9RM5TpD005870
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 16:05:29 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 27 Oct 2011 17:05:29 -0500
Message-Id: <20111027220529.2638.41757.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
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
 fs/xfs/xfs_dquot.h |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 25d7280..815e231 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -372,7 +372,7 @@ xfs_qm_dqalloc(
 	 * Return if this type of quotas is turned off while we didn't
 	 * have an inode lock
 	 */
-	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
+	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 		return (ESRCH);
 	}
@@ -474,7 +474,7 @@ xfs_qm_dqtobp(
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
 	xfs_ilock(quotip, XFS_ILOCK_SHARED);
-	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
+	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 34b7e94..ef7a312 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -102,6 +102,19 @@ static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
 	complete(&dqp->q_flush);
 }
 
+static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
+{
+	type &= XFS_DQ_ALLTYPES;
+	switch(type) {
+	case XFS_DQ_USER:
+		return XFS_IS_UQUOTA_ON(mp);
+	case XFS_DQ_GROUP:
+	case XFS_DQ_PROJ:
+	default:
+		return XFS_IS_OQUOTA_ON(mp);
+	}
+}
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
@@ -112,10 +125,6 @@ static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
 				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
-#define XFS_IS_THIS_QUOTA_OFF(d) (! (XFS_QM_ISUDQ(d) ? \
-				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
-				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
-
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
 extern int		xfs_qm_dqpurge(xfs_dquot_t *);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
