Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbeDVPG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:06:28 -0400
Subject: [PATCH 05/13] xfs: split out dqget for inodes from regular dqget
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:06:24 -0700
Message-ID: <152440958392.29601.4865223638433656924.stgit@magnolia>
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

There are two uses of dqget here -- one is to return the dquot for a
given type and id, and the other is to return the dquot for a given type
and inode.  Those are two separate things, so split them into two
smaller functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |  148 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_dquot.h       |   11 +++
 fs/xfs/xfs_qm.c          |   22 ++-----
 fs/xfs/xfs_qm_bhv.c      |    2 -
 fs/xfs/xfs_qm_syscalls.c |    4 +
 5 files changed, 124 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9a3a05e..62415f1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -781,24 +781,19 @@ xfs_qm_dqget_checks(
 }
 
 /*
- * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
- * a locked dquot, doing an allocation (if requested) as needed.
- * When both an inode and an id are given, the inode's id takes precedence.
- * That is, if the id changes while we don't hold the ilock inside this
- * function, the new dquot is returned, not necessarily the one requested
- * in the id argument.
+ * Given the file system, id, and type (UDQUOT/GDQUOT), return a a locked
+ * dquot, doing an allocation (if requested) as needed.
  */
 int
 xfs_qm_dqget(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip,	  /* locked inode (optional) */
-	xfs_dqid_t	id,	  /* uid/projid/gid depending on type */
-	uint		type,	  /* XFS_DQ_USER/XFS_DQ_PROJ/XFS_DQ_GROUP */
-	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
-	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	uint			flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
+	struct xfs_dquot	**O_dqpp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root *tree = xfs_dquot_tree(qi, type);
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	int			error;
 
@@ -806,10 +801,82 @@ xfs_qm_dqget(
 	if (error)
 		return error;
 
-	if (ip) {
-		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-		ASSERT(xfs_inode_dquot(ip, type) == NULL);
+restart:
+	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
+	if (dqp) {
+		*O_dqpp = dqp;
+		return 0;
+	}
+
+	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	if (error)
+		return error;
+
+	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
+	if (error) {
+		/*
+		 * Duplicate found. Just throw away the new dquot and start
+		 * over.
+		 */
+		xfs_qm_dqdestroy(dqp);
+		XFS_STATS_INC(mp, xs_qm_dquot_dups);
+		goto restart;
+	}
+
+	trace_xfs_dqget_miss(dqp);
+	*O_dqpp = dqp;
+	return 0;
+}
+
+/* Return the quota id for a given inode and type. */
+xfs_dqid_t
+xfs_qm_id_for_quotatype(
+	struct xfs_inode	*ip,
+	uint			type)
+{
+	switch (type) {
+	case XFS_DQ_USER:
+		return ip->i_d.di_uid;
+	case XFS_DQ_GROUP:
+		return ip->i_d.di_gid;
+	case XFS_DQ_PROJ:
+		return xfs_get_projid(ip);
 	}
+	ASSERT(0);
+	return 0;
+}
+
+/*
+ * Return the dquot for a given inode and type.  If @can_alloc is true, then
+ * allocate blocks if needed.  The inode's ILOCK must be held and it must not
+ * have already had an inode attached.
+ */
+int
+xfs_qm_dqget_inode(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	uint			type,
+	uint			can_alloc,
+	struct xfs_dquot	**O_dqpp)
+{
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
+	struct xfs_dquot	*dqp;
+	xfs_dqid_t		id;
+	uint			flags = 0;
+	int			error;
+
+	error = xfs_qm_dqget_checks(mp, type);
+	if (error)
+		return error;
+
+	if (can_alloc)
+		flags |= XFS_QMOPT_DQALLOC;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_inode_dquot(ip, type) == NULL);
+
+	id = xfs_qm_id_for_quotatype(ip, type);
 
 restart:
 	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
@@ -825,37 +892,30 @@ xfs_qm_dqget(
 	 * lock here means dealing with a chown that can happen before
 	 * we re-acquire the lock.
 	 */
-	if (ip)
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
-
-	if (ip)
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
 
-	if (ip) {
-		/*
-		 * A dquot could be attached to this inode by now, since
-		 * we had dropped the ilock.
-		 */
-		if (xfs_this_quota_on(mp, type)) {
-			struct xfs_dquot	*dqp1;
-
-			dqp1 = xfs_inode_dquot(ip, type);
-			if (dqp1) {
-				xfs_qm_dqdestroy(dqp);
-				dqp = dqp1;
-				xfs_dqlock(dqp);
-				goto dqret;
-			}
-		} else {
-			/* inode stays locked on return */
+	/*
+	 * A dquot could be attached to this inode by now, since we had
+	 * dropped the ilock.
+	 */
+	if (xfs_this_quota_on(mp, type)) {
+		struct xfs_dquot	*dqp1;
+
+		dqp1 = xfs_inode_dquot(ip, type);
+		if (dqp1) {
 			xfs_qm_dqdestroy(dqp);
-			return -ESRCH;
+			dqp = dqp1;
+			xfs_dqlock(dqp);
+			goto dqret;
 		}
+	} else {
+		/* inode stays locked on return */
+		xfs_qm_dqdestroy(dqp);
+		return -ESRCH;
 	}
 
 	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
@@ -869,8 +929,8 @@ xfs_qm_dqget(
 		goto restart;
 	}
 
- dqret:
-	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
+dqret:
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);
 	*O_dqpp = dqp;
 	return 0;
@@ -892,7 +952,7 @@ xfs_qm_dqget_next(
 
 	*dqpp = NULL;
 	for (; !error; error = xfs_dq_get_next_id(mp, type, &id)) {
-		error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
+		error = xfs_qm_dqget(mp, id, type, 0, &dqp);
 		if (error == -ENOENT)
 			continue;
 		else if (error != 0)
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 303e71d..1458de3 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -169,8 +169,15 @@ extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
 extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
 					       struct xfs_dquot *);
-extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *,
-					xfs_dqid_t, uint, uint, xfs_dquot_t **);
+extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
+					uint type);
+extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
+					uint type, uint flags,
+					struct xfs_dquot **dqpp);
+extern int		xfs_qm_dqget_inode(struct xfs_mount *mp,
+					struct xfs_inode *ip, uint type,
+					uint can_alloc,
+					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d919b85..385d315 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -291,7 +291,7 @@ xfs_qm_dqattach_one(
 	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
 	 * turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type, doalloc, &dqp);
+	error = xfs_qm_dqget_inode(ip->i_mount, ip, type, doalloc, &dqp);
 	if (error)
 		return error;
 
@@ -1074,7 +1074,7 @@ xfs_qm_quotacheck_dqadjust(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	error = xfs_qm_dqget(mp, ip, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget_inode(mp, ip, type, XFS_QMOPT_DQALLOC, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1693,10 +1693,8 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, NULL, uid,
-						 XFS_DQ_USER,
-						 XFS_QMOPT_DQALLOC,
-						 &uq);
+			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER,
+					XFS_QMOPT_DQALLOC, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1719,10 +1717,8 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (ip->i_d.di_gid != gid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, NULL, gid,
-						 XFS_DQ_GROUP,
-						 XFS_QMOPT_DQALLOC,
-						 &gq);
+			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP,
+					XFS_QMOPT_DQALLOC, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1738,10 +1734,8 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
-						 XFS_DQ_PROJ,
-						 XFS_QMOPT_DQALLOC,
-						 &pq);
+			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
+					XFS_QMOPT_DQALLOC, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 2be6d27..531e822 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -72,7 +72,7 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, NULL, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
+	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 0234cfc..b9243f5 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -425,7 +425,7 @@ xfs_qm_scall_setqlim(
 	 * a reference to the dquot, so it's safe to do this unlock/lock without
 	 * it being reclaimed in the mean time.
 	 */
-	error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_unlock;
@@ -700,7 +700,7 @@ xfs_qm_scall_getquota(
 	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
 	 * exist, we'll get ENOENT back.
 	 */
-	error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
+	error = xfs_qm_dqget(mp, id, type, 0, &dqp);
 	if (error)
 		return error;
 

