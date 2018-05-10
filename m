Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJP35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:29:57 -0400
Subject: [PATCH 07/14] xfs: split out dqget for inodes from regular dqget
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:29:35 -0700
Message-ID: <152596617538.27525.15959895170855226236.stgit@magnolia>
In-Reply-To: <152596612549.27525.9876256551560849585.stgit@magnolia>
References: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

There are two uses of dqget here -- one is to return the dquot for a
given type and id, and the other is to return the dquot for a given type
and inode.  Those are two separate things, so split them into two
smaller functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c       |  148 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_dquot.h       |   10 ++-
 fs/xfs/xfs_iomap.c       |    2 -
 fs/xfs/xfs_qm.c          |   39 +++++-------
 fs/xfs/xfs_qm_bhv.c      |    2 -
 fs/xfs/xfs_qm_syscalls.c |    4 +
 fs/xfs/xfs_quota.h       |    2 -
 fs/xfs/xfs_reflink.c     |    4 +
 8 files changed, 134 insertions(+), 77 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1ee05e5ab1d9..376923fd2174 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -790,24 +790,19 @@ xfs_qm_dqget_checks(
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
 
@@ -815,10 +810,82 @@ xfs_qm_dqget(
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
+	struct xfs_inode	*ip,
+	uint			type,
+	bool			can_alloc,
+	struct xfs_dquot	**O_dqpp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
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
@@ -834,37 +901,30 @@ xfs_qm_dqget(
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
@@ -878,8 +938,8 @@ xfs_qm_dqget(
 		goto restart;
 	}
 
- dqret:
-	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
+dqret:
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);
 	*O_dqpp = dqp;
 	return 0;
@@ -901,7 +961,7 @@ xfs_qm_dqget_next(
 
 	*dqpp = NULL;
 	for (; !error; error = xfs_dq_get_next_id(mp, type, &id)) {
-		error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
+		error = xfs_qm_dqget(mp, id, type, 0, &dqp);
 		if (error == -ENOENT)
 			continue;
 		else if (error != 0)
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 303e71dfcf70..8a5b30e952b0 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -169,8 +169,14 @@ extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
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
+extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
+					bool can_alloc,
+					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0880685a1143..c6ce6f9335b6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -576,7 +576,7 @@ xfs_file_iomap_begin_delay(
 		goto done;
 	}
 
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3893f541f88d..6122097da0b6 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -262,7 +262,7 @@ xfs_qm_dqattach_one(
 	xfs_inode_t	*ip,
 	xfs_dqid_t	id,
 	uint		type,
-	uint		doalloc,
+	bool		doalloc,
 	xfs_dquot_t	**IO_idqpp)
 {
 	xfs_dquot_t	*dqp;
@@ -288,7 +288,7 @@ xfs_qm_dqattach_one(
 	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
 	 * turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type, doalloc, &dqp);
+	error = xfs_qm_dqget_inode(ip, type, doalloc, &dqp);
 	if (error)
 		return error;
 
@@ -330,7 +330,7 @@ xfs_qm_need_dqattach(
 int
 xfs_qm_dqattach_locked(
 	xfs_inode_t	*ip,
-	uint		flags)
+	bool		doalloc)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error = 0;
@@ -342,8 +342,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_udquot);
+				doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
@@ -351,8 +350,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_gdquot);
+				doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
@@ -360,8 +358,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
 		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_pdquot);
+				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_pdquot);
@@ -386,7 +383,7 @@ xfs_qm_dqattach(
 		return 0;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach_locked(ip, false);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	return error;
@@ -1068,7 +1065,7 @@ xfs_qm_quotacheck_dqadjust(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	error = xfs_qm_dqget(mp, ip, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget_inode(ip, type, true, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1667,7 +1664,7 @@ xfs_qm_vop_dqalloc(
 	 * if necessary. The dquot(s) will not be locked.
 	 */
 	if (XFS_NOT_DQATTACHED(mp, ip)) {
-		error = xfs_qm_dqattach_locked(ip, XFS_QMOPT_DQALLOC);
+		error = xfs_qm_dqattach_locked(ip, true);
 		if (error) {
 			xfs_iunlock(ip, lockflags);
 			return error;
@@ -1686,10 +1683,8 @@ xfs_qm_vop_dqalloc(
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
@@ -1712,10 +1707,8 @@ xfs_qm_vop_dqalloc(
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
@@ -1731,10 +1724,8 @@ xfs_qm_vop_dqalloc(
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
index 2be6d2735ca9..531e8224dcb6 100644
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
index 0234cfc4d445..b9243f554697 100644
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
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index a4d392240cf4..1c79ebbe5236 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -91,7 +91,7 @@ extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
 		struct xfs_dquot *, struct xfs_dquot *,
 		struct xfs_dquot *, uint);
 extern int xfs_qm_dqattach(struct xfs_inode *);
-extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
+extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7e2b8078ade2..713e857d9ffa 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -305,7 +305,7 @@ xfs_reflink_reserve_cow(
 	 * Fork all the shared blocks from our write offset until the end of
 	 * the extent.
 	 */
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		return error;
 
@@ -431,7 +431,7 @@ xfs_reflink_allocate_cow(
 		if (error)
 			return error;
 
-		error = xfs_qm_dqattach_locked(ip, 0);
+		error = xfs_qm_dqattach_locked(ip, false);
 		if (error)
 			goto out;
 		goto retry;

