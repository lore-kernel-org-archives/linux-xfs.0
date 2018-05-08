Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbeEHAF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 20:05:57 -0400
Date: Mon, 7 May 2018 17:05:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/13] xfs: remove direct calls to _qm_dqread
Message-ID: <20180508000535.GZ11261@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506705098.21553.6894396720813018127.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152506705098.21553.6894396720813018127.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de, Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

The quota initialization code needs an "uncached" variant of _dqget to
read in default quota limits and timers before the dquot cache is fully
set up.  We've already split up _dqget into its component pieces so
create a fourth variant to address this need, and make dqread internal
to xfs_dquot.c again.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   24 +++++++++++++++++++++++-
 fs/xfs/xfs_dquot.h |    5 +++--
 fs/xfs/xfs_qm.c    |   25 +++++++++++++------------
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 54c16f76d12d..0cb4b553db28 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -586,7 +586,7 @@ xfs_qm_dqread_alloc(
  *
  * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
  */
-int
+static int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
@@ -832,6 +832,28 @@ xfs_qm_dqget(
 	return 0;
 }
 
+/*
+ * Given a dquot id and type, read and initialize a dquot from the on-disk
+ * metadata.  This function is only for use during quota initialization so
+ * it ignores the dquot cache assuming that the dquot shrinker isn't set up.
+ * The caller is responsible for _qm_dqdestroy'ing the returned dquot.
+ */
+int
+xfs_qm_dqget_uncached(
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_dquot	**dqpp)
+{
+	int			error;
+
+	error = xfs_qm_dqget_checks(mp, type);
+	if (error)
+		return error;
+
+	return xfs_qm_dqread(mp, id, type, 0, dqpp);
+}
+
 /* Return the quota id for a given inode and type. */
 xfs_dqid_t
 xfs_qm_id_for_quotatype(
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 8a5b30e952b0..38a42874a98c 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -160,8 +160,6 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
 
-extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
-					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
@@ -179,6 +177,9 @@ extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
 					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
+extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
+					xfs_dqid_t id, uint type,
+					struct xfs_dquot **dqpp);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b9244b8983b3..ea06762aa6c1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -563,8 +563,7 @@ xfs_qm_set_defquota(
 	struct xfs_def_quota    *defq;
 	int			error;
 
-	error = xfs_qm_dqread(mp, 0, type, 0, &dqp);
-
+	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
 	if (!error) {
 		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
 
@@ -590,11 +589,12 @@ xfs_qm_set_defquota(
  */
 STATIC int
 xfs_qm_init_quotainfo(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_quotainfo_t *qinf;
-	int		error;
-	xfs_dquot_t	*dqp;
+	struct xfs_quotainfo	*qinf;
+	struct xfs_dquot	*dqp;
+	uint			type;
+	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
@@ -637,12 +637,13 @@ xfs_qm_init_quotainfo(
 	 * user/group/proj quota types, otherwise a default value is used.
 	 * This should be split into different fields per quota type.
 	 */
-	error = xfs_qm_dqread(mp, 0,
-			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
-			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
-			  XFS_DQ_PROJ),
-			0, &dqp);
-
+	if (XFS_IS_UQUOTA_RUNNING(mp))
+		type = XFS_DQ_USER;
+	else if (XFS_IS_GQUOTA_RUNNING(mp))
+		type = XFS_DQ_GROUP;
+	else
+		type = XFS_DQ_PROJ;
+	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
 	if (!error) {
 		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
 
