Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbeDVPHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:10 -0400
Subject: [PATCH 10/13] xfs: replace XFS_QMOPT_DQALLOC with XFS_DQGET_{ALLOC,
 EXISTS}
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:07:05 -0700
Message-ID: <152440962542.29601.4228199041127085137.stgit@magnolia>
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

DQALLOC is only ever used with xfs_qm_dqget*, and the only flag that the
_dqget family of functions cares about is DQALLOC.  Therefore, change
the name to make it clear that it's only a dqget flag.  Since these are
modes and no longer bit flags, define a XFS_DQGET_EXISTS flag and
convert all the callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    4 +++
 fs/xfs/xfs_dquot.c             |   18 ++++++++-------
 fs/xfs/xfs_dquot.h             |    4 ++-
 fs/xfs/xfs_iomap.c             |    2 +-
 fs/xfs/xfs_qm.c                |   47 +++++++++++++++++++---------------------
 fs/xfs/xfs_qm_bhv.c            |    3 ++-
 fs/xfs/xfs_qm_syscalls.c       |    4 ++-
 fs/xfs/xfs_quota.h             |    3 ++-
 fs/xfs/xfs_reflink.c           |    4 ++-
 9 files changed, 45 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index c80b226..56c8787 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -102,12 +102,14 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
 #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
 
+#define XFS_DQGET_EXISTS	(0)	/* disk dquot must already exist */
+#define XFS_DQGET_ALLOC	(1)	/* allocate dquot ondisk if needed */
+
 /*
  * Flags to tell various functions what to do. Not all of these are meaningful
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
  * persistent values (ie. their values can and will change between versions)
  */
-#define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
 #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a82d928..7ce3dbd 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -522,7 +522,7 @@ xfs_qm_dqinit_from_buf(
 
 /*
  * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
- * and release the buffer immediately.  If @can_alloc is specified, fill any
+ * and release the buffer immediately.  If @dqmode is DQALLOC, fill any
  * holes in the on-disk metadata.
  */
 STATIC int
@@ -530,7 +530,7 @@ xfs_qm_dqensure(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			can_alloc,
+	unsigned int		dqmode,
 	struct xfs_dquot	**dqpp)
 {
 	struct xfs_dquot	*dqp;
@@ -543,7 +543,7 @@ xfs_qm_dqensure(
 
 	/* Try to read the buffer... */
 	error = xfs_qm_dqread_ondisk(mp, dqp, &bp);
-	if (error == -ENOENT && can_alloc) {
+	if (error == -ENOENT && dqmode == XFS_DQGET_ALLOC) {
 		/* ...or allocate a new block and buffer. */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
@@ -759,7 +759,7 @@ xfs_qm_dqget(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	uint			can_alloc,
+	unsigned int		dqmode,
 	struct xfs_dquot	**O_dqpp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -778,7 +778,7 @@ xfs_qm_dqget(
 		return 0;
 	}
 
-	error = xfs_qm_dqensure(mp, id, type, can_alloc, &dqp);
+	error = xfs_qm_dqensure(mp, id, type, dqmode, &dqp);
 	if (error)
 		return error;
 
@@ -817,7 +817,7 @@ xfs_qm_id_for_quotatype(
 }
 
 /*
- * Return the dquot for a given inode and type.  If @can_alloc is true, then
+ * Return the dquot for a given inode and type.  If @dqmode is DQALLOC, then
  * allocate blocks if needed.  The inode's ILOCK must be held and it must not
  * have already had an inode attached.
  */
@@ -826,7 +826,7 @@ xfs_qm_dqget_inode(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*ip,
 	uint			type,
-	uint			can_alloc,
+	unsigned int		dqmode,
 	struct xfs_dquot	**O_dqpp)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -859,7 +859,7 @@ xfs_qm_dqget_inode(
 	 * we re-acquire the lock.
 	 */
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqensure(mp, id, type, can_alloc, &dqp);
+	error = xfs_qm_dqensure(mp, id, type, dqmode, &dqp);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
@@ -918,7 +918,7 @@ xfs_qm_dqget_next(
 
 	*dqpp = NULL;
 	for (; !error; error = xfs_dq_get_next_id(mp, type, &id)) {
-		error = xfs_qm_dqget(mp, id, type, 0, &dqp);
+		error = xfs_qm_dqget(mp, id, type, XFS_DQGET_EXISTS, &dqp);
 		if (error == -ENOENT)
 			continue;
 		else if (error != 0)
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 6bc5ed8..fe99e43 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -172,11 +172,11 @@ extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
 extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 					uint type);
 extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
-					uint type, uint can_alloc,
+					uint type, unsigned int dqmode,
 					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_inode(struct xfs_mount *mp,
 					struct xfs_inode *ip, uint type,
-					uint can_alloc,
+					unsigned int dqmode,
 					struct xfs_dquot **dqpp);
 extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 58b04ea..b6ca5ec 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -576,7 +576,7 @@ xfs_file_iomap_begin_delay(
 		goto done;
 	}
 
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach_locked(ip, XFS_DQGET_EXISTS);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e3d9b38..1b94da0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -262,14 +262,14 @@ xfs_qm_unmount_quotas(
 
 STATIC int
 xfs_qm_dqattach_one(
-	xfs_inode_t	*ip,
-	xfs_dqid_t	id,
-	uint		type,
-	uint		doalloc,
-	xfs_dquot_t	**IO_idqpp)
+	struct xfs_inode	*ip,
+	xfs_dqid_t		id,
+	uint			type,
+	unsigned int		dqmode,
+	struct xfs_dquot	**IO_idqpp)
 {
-	xfs_dquot_t	*dqp;
-	int		error;
+	struct xfs_dquot	*dqp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
@@ -291,7 +291,7 @@ xfs_qm_dqattach_one(
 	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
 	 * turned off suddenly.
 	 */
-	error = xfs_qm_dqget_inode(ip->i_mount, ip, type, doalloc, &dqp);
+	error = xfs_qm_dqget_inode(ip->i_mount, ip, type, dqmode, &dqp);
 	if (error)
 		return error;
 
@@ -326,17 +326,17 @@ xfs_qm_need_dqattach(
 /*
  * Given a locked inode, attach dquot(s) to it, taking U/G/P-QUOTAON
  * into account.
- * If XFS_QMOPT_DQALLOC, the dquot(s) will be allocated if needed.
+ * If @dqmode is XFS_DQGET_ALLOC, the dquot(s) will be allocated if needed.
  * Inode may get unlocked and relocked in here, and the caller must deal with
  * the consequences.
  */
 int
 xfs_qm_dqattach_locked(
-	xfs_inode_t	*ip,
-	uint		flags)
+	struct xfs_inode	*ip,
+	unsigned int		dqmode)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
 
 	if (!xfs_qm_need_dqattach(ip))
 		return 0;
@@ -345,8 +345,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_udquot);
+				dqmode, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
@@ -354,8 +353,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_gdquot);
+				dqmode, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
@@ -363,8 +361,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
 		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
-						flags & XFS_QMOPT_DQALLOC,
-						&ip->i_pdquot);
+				dqmode, &ip->i_pdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_pdquot);
@@ -389,7 +386,7 @@ xfs_qm_dqattach(
 		return 0;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach_locked(ip, XFS_DQGET_EXISTS);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	return error;
@@ -1075,7 +1072,7 @@ xfs_qm_quotacheck_dqadjust(
 	int			error;
 
 	id = xfs_qm_id_for_quotatype(ip, type);
-	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget(mp, id, type, XFS_DQGET_ALLOC, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1670,7 +1667,7 @@ xfs_qm_vop_dqalloc(
 	 * if necessary. The dquot(s) will not be locked.
 	 */
 	if (XFS_NOT_DQATTACHED(mp, ip)) {
-		error = xfs_qm_dqattach_locked(ip, XFS_QMOPT_DQALLOC);
+		error = xfs_qm_dqattach_locked(ip, XFS_DQGET_ALLOC);
 		if (error) {
 			xfs_iunlock(ip, lockflags);
 			return error;
@@ -1690,7 +1687,7 @@ xfs_qm_vop_dqalloc(
 			 */
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER,
-					XFS_QMOPT_DQALLOC, &uq);
+					XFS_DQGET_ALLOC, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1714,7 +1711,7 @@ xfs_qm_vop_dqalloc(
 		if (ip->i_d.di_gid != gid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP,
-					XFS_QMOPT_DQALLOC, &gq);
+					XFS_DQGET_ALLOC, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1731,7 +1728,7 @@ xfs_qm_vop_dqalloc(
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
-					XFS_QMOPT_DQALLOC, &pq);
+					XFS_DQGET_ALLOC, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 531e822..580cdf1 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -72,7 +72,8 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
+	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ,
+			XFS_DQGET_EXISTS, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b9243f5..285d50e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -425,7 +425,7 @@ xfs_qm_scall_setqlim(
 	 * a reference to the dquot, so it's safe to do this unlock/lock without
 	 * it being reclaimed in the mean time.
 	 */
-	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	error = xfs_qm_dqget(mp, id, type, XFS_DQGET_ALLOC, &dqp);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_unlock;
@@ -700,7 +700,7 @@ xfs_qm_scall_getquota(
 	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
 	 * exist, we'll get ENOENT back.
 	 */
-	error = xfs_qm_dqget(mp, id, type, 0, &dqp);
+	error = xfs_qm_dqget(mp, id, type, XFS_DQGET_EXISTS, &dqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index a4d3922..fb67409 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -91,7 +91,8 @@ extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
 		struct xfs_dquot *, struct xfs_dquot *,
 		struct xfs_dquot *, uint);
 extern int xfs_qm_dqattach(struct xfs_inode *);
-extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
+extern int xfs_qm_dqattach_locked(struct xfs_inode *ip,
+		unsigned int dqmode);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index fd8e6af..fabb61b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -305,7 +305,7 @@ xfs_reflink_reserve_cow(
 	 * Fork all the shared blocks from our write offset until the end of
 	 * the extent.
 	 */
-	error = xfs_qm_dqattach_locked(ip, 0);
+	error = xfs_qm_dqattach_locked(ip, XFS_DQGET_EXISTS);
 	if (error)
 		return error;
 
@@ -431,7 +431,7 @@ xfs_reflink_allocate_cow(
 		if (error)
 			return error;
 
-		error = xfs_qm_dqattach_locked(ip, 0);
+		error = xfs_qm_dqattach_locked(ip, XFS_DQGET_EXISTS);
 		if (error)
 			goto out;
 		goto retry;

