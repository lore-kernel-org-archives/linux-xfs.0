Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RM8gLN122671 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 17:08:42 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53DD51CC3FE6
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:08:42 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id oniSHVDsVBPL7yWl for
	<xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:08:42 -0700 (PDT)
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Oct 2011 18:05:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9RM5aER2637828
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 18:05:37 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9RM5atf008763 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 18:05:36 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 27 Oct 2011 17:05:34 -0500
Message-Id: <20111027220534.2638.54570.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 2/4] Define a new function xfs_inode_dquot()
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

Define a new function xfs_inode_dquot() that takes a inode pointer
and a disk quota type and returns the quota pointer for the specified
quota type.

This simplifies the xfs_qm_dqget() error path significantly.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c |   33 +++++++++------------------------
 fs/xfs/xfs_dquot.h |   14 ++++++++++++++
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 815e231..3c983a7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -808,7 +808,7 @@ xfs_qm_dqget(
 	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
 	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
 {
-	xfs_dquot_t	*dqp;
+	xfs_dquot_t	*dqp, *dqp1;
 	xfs_dqhash_t	*h;
 	uint		version;
 	int		error;
@@ -839,10 +839,7 @@ xfs_qm_dqget(
 	       type == XFS_DQ_GROUP);
 	if (ip) {
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-		if (type == XFS_DQ_USER)
-			ASSERT(ip->i_udquot == NULL);
-		else
-			ASSERT(ip->i_gdquot == NULL);
+		ASSERT(xfs_inode_dquot(ip, type) == NULL);
 	}
 #endif
 	mutex_lock(&h->qh_lock);
@@ -921,30 +918,18 @@ xfs_qm_dqget(
 		 * A dquot could be attached to this inode by now, since
 		 * we had dropped the ilock.
 		 */
-		if (type == XFS_DQ_USER) {
-			if (!XFS_IS_UQUOTA_ON(mp)) {
-				/* inode stays locked on return */
-				xfs_qm_dqdestroy(dqp);
-				return XFS_ERROR(ESRCH);
-			}
-			if (ip->i_udquot) {
+		if (xfs_this_quota_on(mp, type)) {
+			dqp1 = xfs_inode_dquot(ip, type);
+			if (dqp1) {
 				xfs_qm_dqdestroy(dqp);
-				dqp = ip->i_udquot;
+				dqp = dqp1;
 				xfs_dqlock(dqp);
 				goto dqret;
 			}
 		} else {
-			if (!XFS_IS_OQUOTA_ON(mp)) {
-				/* inode stays locked on return */
-				xfs_qm_dqdestroy(dqp);
-				return XFS_ERROR(ESRCH);
-			}
-			if (ip->i_gdquot) {
-				xfs_qm_dqdestroy(dqp);
-				dqp = ip->i_gdquot;
-				xfs_dqlock(dqp);
-				goto dqret;
-			}
+			/* inode stays locked on return */
+			xfs_qm_dqdestroy(dqp);
+			return XFS_ERROR(ESRCH);
 		}
 	}
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index ef7a312..c09510a 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -115,6 +115,20 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 	}
 }
 
+static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
+{
+	type &= XFS_DQ_ALLTYPES;
+	switch(type) {
+	case XFS_DQ_USER:
+		return ip->i_udquot;
+	case XFS_DQ_PROJ:
+	case XFS_DQ_GROUP:
+		return ip->i_gdquot;
+	default:
+		return NULL;
+	}
+}
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
