Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJPa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:30:28 -0400
Subject: [PATCH 12/14] xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:30:07 -0700
Message-ID: <152596620696.27525.12367252310138284137.stgit@magnolia>
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

DQALLOC is only ever used with xfs_qm_dqget*, and the only flag that the
_dqget family of functions cares about is DQALLOC.  Therefore, change
it to a boolean 'can alloc?' flag for the dqget interfaces where that
makes sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    1 -
 fs/xfs/xfs_dquot.c             |   21 ++++++++-------------
 fs/xfs/xfs_dquot.h             |    2 +-
 fs/xfs/xfs_qm.c                |   12 +++++-------
 fs/xfs/xfs_qm_bhv.c            |    2 +-
 fs/xfs/xfs_qm_syscalls.c       |    9 ++++-----
 6 files changed, 19 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 619905f3bcac..d4af2804b178 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -107,7 +107,6 @@ typedef uint16_t	xfs_qwarncnt_t;
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
  * persistent values (ie. their values can and will change between versions)
  */
-#define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
 #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5593a344732c..85f9ffd99998 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -582,16 +582,15 @@ xfs_qm_dqread_alloc(
 
 /*
  * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
- * and release the buffer immediately.
- *
- * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
+ * and release the buffer immediately.  If @can_alloc is true, fill any
+ * holes in the on-disk metadata.
  */
 static int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			flags,
+	bool			can_alloc,
 	struct xfs_dquot	**dqpp)
 {
 	struct xfs_dquot	*dqp;
@@ -603,7 +602,7 @@ xfs_qm_dqread(
 
 	/* Try to read the buffer, allocating if necessary. */
 	error = xfs_dquot_disk_read(mp, dqp, &bp);
-	if (error == -ENOENT && (flags & XFS_QMOPT_DQALLOC))
+	if (error == -ENOENT && can_alloc)
 		error = xfs_qm_dqread_alloc(mp, dqp, &bp);
 	if (error)
 		goto err;
@@ -793,7 +792,7 @@ xfs_qm_dqget(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
+	bool			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -812,7 +811,7 @@ xfs_qm_dqget(
 		return 0;
 	}
 
-	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
 	if (error)
 		return error;
 
@@ -889,16 +888,12 @@ xfs_qm_dqget_inode(
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
 
@@ -919,7 +914,7 @@ xfs_qm_dqget_inode(
 	 * we re-acquire the lock.
 	 */
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
@@ -978,7 +973,7 @@ xfs_qm_dqget_next(
 
 	*dqpp = NULL;
 	for (; !error; error = xfs_dq_get_next_id(mp, type, &id)) {
-		error = xfs_qm_dqget(mp, id, type, 0, &dqp);
+		error = xfs_qm_dqget(mp, id, type, false, &dqp);
 		if (error == -ENOENT)
 			continue;
 		else if (error != 0)
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 38a42874a98c..113a16c37122 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -170,7 +170,7 @@ extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
 extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 					uint type);
 extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
-					uint type, uint flags,
+					uint type, bool can_alloc,
 					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
 					bool can_alloc,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fac649518101..50ba0ea6165f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -323,7 +323,7 @@ xfs_qm_need_dqattach(
 /*
  * Given a locked inode, attach dquot(s) to it, taking U/G/P-QUOTAON
  * into account.
- * If XFS_QMOPT_DQALLOC, the dquot(s) will be allocated if needed.
+ * If @doalloc is true, the dquot(s) will be allocated if needed.
  * Inode may get unlocked and relocked in here, and the caller must deal with
  * the consequences.
  */
@@ -1067,7 +1067,7 @@ xfs_qm_quotacheck_dqadjust(
 	int			error;
 
 	id = xfs_qm_id_for_quotatype(ip, type);
-	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget(mp, id, type, true, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1680,8 +1680,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER,
-					XFS_QMOPT_DQALLOC, &uq);
+			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1704,8 +1703,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (ip->i_d.di_gid != gid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP,
-					XFS_QMOPT_DQALLOC, &gq);
+			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1722,7 +1720,7 @@ xfs_qm_vop_dqalloc(
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
-					XFS_QMOPT_DQALLOC, &pq);
+					true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 531e8224dcb6..36b89e2c5eb9 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -72,7 +72,7 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
+	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b9243f554697..3e05d300b14e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -425,7 +425,7 @@ xfs_qm_scall_setqlim(
 	 * a reference to the dquot, so it's safe to do this unlock/lock without
 	 * it being reclaimed in the mean time.
 	 */
-	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget(mp, id, type, true, &dqp);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_unlock;
@@ -696,11 +696,10 @@ xfs_qm_scall_getquota(
 	int			error;
 
 	/*
-	 * Try to get the dquot. We don't want it allocated on disk, so
-	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
-	 * exist, we'll get ENOENT back.
+	 * Try to get the dquot. We don't want it allocated on disk, so don't
+	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
 	 */
-	error = xfs_qm_dqget(mp, id, type, 0, &dqp);
+	error = xfs_qm_dqget(mp, id, type, false, &dqp);
 	if (error)
 		return error;
 

