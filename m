Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbeD3Foi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:44:38 -0400
Subject: [PATCH 10/13] xfs: replace XFS_QMOPT_DQALLOC with XFS_DQGET_{ALLOC,
 EXISTS}
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Apr 2018 22:44:17 -0700
Message-ID: <152506705736.21553.3142275765217711989.stgit@magnolia>
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

DQALLOC is only ever used with xfs_qm_dqget*, and the only flag that the
_dqget family of functions cares about is DQALLOC.  Therefore, change
the name to make it clear that it's only a dqget flag.  Since these are
modes and no longer bit flags, define a XFS_DQGET_EXISTS flag and
convert all the callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    1 -
 fs/xfs/xfs_dquot.c             |    8 ++++----
 fs/xfs/xfs_dquot.h             |    2 +-
 fs/xfs/xfs_qm.c                |   12 +++++-------
 fs/xfs/xfs_qm_bhv.c            |    2 +-
 fs/xfs/xfs_qm_syscalls.c       |    9 ++++-----
 6 files changed, 15 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index c80b22629c78..bfe03fd3aa8e 100644
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
index 7a343b571ea9..301a96d70785 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -521,7 +521,7 @@ xfs_dquot_from_disk(
 
 /*
  * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
- * and release the buffer immediately.  If @can_alloc is specified, fill any
+ * and release the buffer immediately.  If @can_alloc is true, fill any
  * holes in the on-disk metadata.
  */
 STATIC int
@@ -759,7 +759,7 @@ xfs_qm_dqget(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			flags,	/* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
+	bool			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -778,7 +778,7 @@ xfs_qm_dqget(
 		return 0;
 	}
 
-	error = xfs_dquot_setup(mp, id, type, flags & XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_dquot_setup(mp, id, type, can_alloc, &dqp);
 	if (error)
 		return error;
 
@@ -918,7 +918,7 @@ xfs_qm_dqget_next(
 
 	*dqpp = NULL;
 	for (; !error; error = xfs_dq_get_next_id(mp, type, &id)) {
-		error = xfs_qm_dqget(mp, id, type, 0, &dqp);
+		error = xfs_qm_dqget(mp, id, type, false, &dqp);
 		if (error == -ENOENT)
 			continue;
 		else if (error != 0)
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 486a1b475574..6959f0135f36 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -172,7 +172,7 @@ extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
 extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 					uint type);
 extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
-					uint type, uint can_alloc,
+					uint type, bool can_alloc,
 					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
 					bool can_alloc,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9f646222c4ac..c6b1e9bd7a3e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -326,7 +326,7 @@ xfs_qm_need_dqattach(
 /*
  * Given a locked inode, attach dquot(s) to it, taking U/G/P-QUOTAON
  * into account.
- * If XFS_QMOPT_DQALLOC, the dquot(s) will be allocated if needed.
+ * If @doalloc is true, the dquot(s) will be allocated if needed.
  * Inode may get unlocked and relocked in here, and the caller must deal with
  * the consequences.
  */
@@ -1072,7 +1072,7 @@ xfs_qm_quotacheck_dqadjust(
 	int			error;
 
 	id = xfs_qm_id_for_quotatype(ip, type);
-	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget(mp, id, type, true, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1686,8 +1686,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER,
-					XFS_QMOPT_DQALLOC, &uq);
+			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1710,8 +1709,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (ip->i_d.di_gid != gid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP,
-					XFS_QMOPT_DQALLOC, &gq);
+			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1728,7 +1726,7 @@ xfs_qm_vop_dqalloc(
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
-					XFS_QMOPT_DQALLOC, &pq);
+					true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 531e8224dcb6..1fa3d6d6db40 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -72,7 +72,7 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
+	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, true, &dqp)) {
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
 

