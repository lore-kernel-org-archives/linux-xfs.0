Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754023AbeDVPHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:04 -0400
Subject: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:06:58 -0700
Message-ID: <152440961880.29601.15798100669042989214.stgit@magnolia>
In-Reply-To: <152440954198.29601.14390250048915099607.stgit@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the _qm_dqread functionality to _qm_dqensure, then remove the flags
argument from xfs_qm_dqread since the only DQALLOC users were internal
to xfs_dquot.c anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   39 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_dquot.h |    6 +++---
 fs/xfs/xfs_qm.c    |    4 ++--
 3 files changed, 29 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ef4cd56..a82d928 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -522,16 +522,15 @@ xfs_qm_dqinit_from_buf(
 
 /*
  * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
- * and release the buffer immediately.
- *
- * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
+ * and release the buffer immediately.  If @can_alloc is specified, fill any
+ * holes in the on-disk metadata.
  */
-int
-xfs_qm_dqread(
+STATIC int
+xfs_qm_dqensure(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			flags,
+	uint			can_alloc,
 	struct xfs_dquot	**dqpp)
 {
 	struct xfs_dquot	*dqp;
@@ -544,7 +543,7 @@ xfs_qm_dqread(
 
 	/* Try to read the buffer... */
 	error = xfs_qm_dqread_ondisk(mp, dqp, &bp);
-	if (error == -ENOENT && (flags & XFS_QMOPT_DQALLOC)) {
+	if (error == -ENOENT && can_alloc) {
 		/* ...or allocate a new block and buffer. */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
@@ -557,10 +556,10 @@ xfs_qm_dqread(
 
 		error = xfs_trans_commit(tp);
 	}
-	ASSERT(xfs_buf_islocked(bp));
 	if (error)
 		goto err;
 
+	ASSERT(xfs_buf_islocked(bp));
 	xfs_qm_dqinit_from_buf(dqp, bp);
 
 	/*
@@ -583,6 +582,20 @@ xfs_qm_dqread(
 }
 
 /*
+ * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
+ * and release the buffer immediately.
+ */
+int
+xfs_qm_dqread(
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_dquot	**dqpp)
+{
+	return xfs_qm_dqensure(mp, id, type, 0, dqpp);
+}
+
+/*
  * Advance to the next id in the current chunk, or if at the
  * end of the chunk, skip ahead to first id in next allocated chunk
  * using the SEEK_DATA interface.
@@ -746,7 +759,7 @@ xfs_qm_dqget(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
+	uint			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -765,7 +778,7 @@ xfs_qm_dqget(
 		return 0;
 	}
 
-	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	error = xfs_qm_dqensure(mp, id, type, can_alloc, &dqp);
 	if (error)
 		return error;
 
@@ -820,16 +833,12 @@ xfs_qm_dqget_inode(
 	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	xfs_dqid_t		id;
-	uint			flags = 0;
 	int			error;
 
 	error = xfs_qm_dqget_checks(mp, type);
 	if (error)
 		return error;
 
-	if (can_alloc)
-		flags |= XFS_QMOPT_DQALLOC;
-
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(xfs_inode_dquot(ip, type) == NULL);
 
@@ -850,7 +859,7 @@ xfs_qm_dqget_inode(
 	 * we re-acquire the lock.
 	 */
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	error = xfs_qm_dqensure(mp, id, type, can_alloc, &dqp);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 1458de3..6bc5ed8 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -160,8 +160,8 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
 
-extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
-					uint, struct xfs_dquot	**);
+extern int		xfs_qm_dqread(struct xfs_mount *mp, xfs_dqid_t id,
+					uint type, struct xfs_dquot **dqpp);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
@@ -172,7 +172,7 @@ extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
 extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 					uint type);
 extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
-					uint type, uint flags,
+					uint type, uint can_alloc,
 					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_inode(struct xfs_mount *mp,
 					struct xfs_inode *ip, uint type,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 123ea5f..e3d9b38 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -572,7 +572,7 @@ xfs_qm_set_defquota(
 	struct xfs_def_quota    *defq;
 	int			error;
 
-	error = xfs_qm_dqread(mp, 0, type, 0, &dqp);
+	error = xfs_qm_dqread(mp, 0, type, &dqp);
 
 	if (!error) {
 		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
@@ -650,7 +650,7 @@ xfs_qm_init_quotainfo(
 			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
 			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
 			  XFS_DQ_PROJ),
-			0, &dqp);
+			&dqp);
 
 	if (!error) {
 		xfs_disk_dquot_t	*ddqp = &dqp->q_core;

