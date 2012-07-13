Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D8atAr130769 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 03:36:55 -0500
Message-ID: <4FFFDDF8.10401@oracle.com>
Date: Fri, 13 Jul 2012 16:36:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfs: Add pquotaino to on-disk super block
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>

Add pquotaino to on-disk super block. Add a new field to
the super block to add support for separate pquota with
a specific version.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 fs/xfs/xfs_itable.c       |    3 +-
 fs/xfs/xfs_mount.c        |   53 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_qm.c           |   27 +++++++++++++++-------
 fs/xfs/xfs_qm_syscalls.c  |   44 ++++++++++++++++++++++++++++---------
 fs/xfs/xfs_quota.h        |    8 ------
 fs/xfs/xfs_sb.h           |   17 ++++++++++++--
 fs/xfs/xfs_super.c        |   15 +++++++-----
 fs/xfs/xfs_trans_dquot.c  |    3 +-
 include/linux/dqblk_xfs.h |    1 +
 9 files changed, 130 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index eff577a..0fa60b4 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -42,7 +42,8 @@ xfs_internal_inum(
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
+		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
+		  ino == mp->m_sb.sb_pquotino)));
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4830c46..523d370 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -108,6 +108,7 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_pquotino),   0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -618,6 +619,36 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	if (xfs_sb_version_has_no_oquota(to)) {
+		if (to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
+			xfs_notice(mp, "Super block has XFS_OQUOTA bits with "
+				       "version NO_OQUOTA. Fixing it.\n");
+			to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+		}
+		to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
+	} else {
+		if (to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				     XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
+			xfs_notice(mp, "Super block has XFS_[G|P]UOTA bits in "
+				       "older version. Fixing it.\n");
+			to->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+					   XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD);
+		}
+		if (to->sb_qflags & XFS_OQUOTA_ENFD) {
+			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+					  XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+		}
+		if (to->sb_qflags & XFS_OQUOTA_CHKD) {
+			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+					  XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+		}
+		to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
+		if (to->sb_qflags & XFS_PQUOTA_ACCT) {
+			to->sb_pquotino = to->sb_gquotino;
+			to->sb_gquotino = NULLFSINO;
+		}
+	}
 }
 
 /*
@@ -633,6 +664,7 @@ xfs_sb_to_disk(
 {
 	xfs_caddr_t	to_ptr = (xfs_caddr_t)to;
 	xfs_caddr_t	from_ptr = (xfs_caddr_t)from;
+	xfs_ino_t	gquotino;
 	xfs_sb_field_t	f;
 	int		first;
 	int		size;
@@ -642,6 +674,16 @@ xfs_sb_to_disk(
 	if (!fields)
 		return;
 
+	/*
+	 * On-disk version earlier than NO_OQUOTA doesn't have sb_pquotino.
+	 * So we need to copy the value to gquotino field.
+	 */
+	if (!xfs_sb_version_has_no_oquota(from) &&
+	    (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD)))
+		gquotino = from->sb_pquotino;
+	else
+		gquotino = from->sb_gquotino;
+
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -651,7 +693,8 @@ xfs_sb_to_disk(
 
 		if (size == 1 || xfs_sb_info[f].type == 1)
 			memcpy(to_ptr + first, from_ptr + first, size);
-		else if (f == XFS_SBS_QFLAGS) {
+		else if ((f == XFS_SBS_QFLAGS) &&
+			 !xfs_sb_version_has_no_oquota(from)) {
 			/*
 			 * The in-core version of sb_qflags do not have
 			 * XFS_OQUOTA_* flags, whereas the on-disk version
@@ -666,7 +709,7 @@ xfs_sb_to_disk(
 					(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
 				tmp16 |= XFS_OQUOTA_CHKD;
 			*(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);
-		} else {
+		} else if (f == XFS_SBS_GQUOTINO) {
 			switch (size) {
 			case 2:
 				*(__be16 *)(to_ptr + first) =
@@ -1643,6 +1686,12 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	first = sizeof(xfs_sb_t);
 	last = 0;
 
+	if (!xfs_sb_version_has_no_oquota(&mp->m_sb) &&
+	    XFS_IS_PQUOTA_ON(mp)) {
+		fields &= (__int64_t)~XFS_SB_PQUOTINO;
+		fields |= (__int64_t)XFS_SB_GQUOTINO;
+	}
+
 	/* translate/copy */
 
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a18c5cd..9910bc3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -502,7 +502,8 @@ xfs_qm_need_dqattach(
 	if (!XFS_NOT_DQATTACHED(mp, ip))
 		return false;
 	if (ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	    ip->i_ino == mp->m_sb.sb_gquotino ||
+	    ip->i_ino == mp->m_sb.sb_pquotino)
 		return false;
 	return true;
 }
@@ -632,6 +633,7 @@ xfs_qm_dqdetach(
 
 	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_uquotino);
 	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_gquotino);
+	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_pquotino);
 	if (ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
@@ -827,21 +829,26 @@ xfs_qm_qino_alloc(
 	if (flags & XFS_QMOPT_SBVERSION) {
 		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
 		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
-		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
+				    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
+				    XFS_SB_QFLAGS)) ==
+		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO |
+			XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
 
 		xfs_sb_version_addquota(&mp->m_sb);
 		mp->m_sb.sb_uquotino = NULLFSINO;
 		mp->m_sb.sb_gquotino = NULLFSINO;
+		mp->m_sb.sb_pquotino = NULLFSINO;
 
 		/* qflags will get updated _after_ quotacheck */
 		mp->m_sb.sb_qflags = 0;
 	}
 	if (flags & XFS_QMOPT_UQUOTA)
 		mp->m_sb.sb_uquotino = (*ip)->i_ino;
-	else
+	else if (flags & XFS_QMOPT_GQUOTA)
 		mp->m_sb.sb_gquotino = (*ip)->i_ino;
+	else
+		mp->m_sb.sb_pquotino = (*ip)->i_ino;
+
 	spin_unlock(&mp->m_sb_lock);
 	xfs_mod_sb(tp, sbfields);
 
@@ -1147,7 +1154,8 @@ xfs_qm_dqusage_adjust(
 	 * rootino must have its resources accounted for, not so with the quota
 	 * inodes.
 	 */
-	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
+	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
+	    ino == mp->m_sb.sb_pquotino) {
 		*res = BULKSTAT_RV_NOTHING;
 		return XFS_ERROR(EINVAL);
 	}
@@ -1446,7 +1454,8 @@ xfs_qm_init_quotainos(
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
+			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
+			    XFS_SB_QFLAGS);
 	}
 
 	/*
@@ -1477,7 +1486,7 @@ xfs_qm_init_quotainos(
 	/* Why not define a XFS_SB_PQUOTINO? */
 	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
 		error = xfs_qm_qino_alloc(mp, &pip,
-					  sbflags | XFS_SB_GQUOTINO,
+					  sbflags | XFS_SB_PQUOTINO,
 					  flags | XFS_QMOPT_PQUOTA);
 		if (error) {
 			if (uip)
@@ -1679,7 +1688,7 @@ xfs_qm_write_sb_changes(
  * and returns the dquots corresponding to the uid and/or gid.
  *
  * in	: inode (unlocked)
- * out	: udquot, gdquot with references taken and unlocked
+ * out	: udquot, gdquot, pdquot with references taken and unlocked
  */
 int
 xfs_qm_vop_dqalloc(
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 84f2fae..57f9650 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -200,8 +200,7 @@ xfs_qm_scall_quotaoff(
 	/*
 	 * If quotas is completely disabled, close shop.
 	 */
-	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
-	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
+	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
 		mutex_unlock(&q->qi_quotaofflock);
 		xfs_qm_destroy_quotainfo(mp);
 		return (0);
@@ -286,7 +285,7 @@ xfs_qm_scall_trunc_qfiles(
 	xfs_mount_t	*mp,
 	uint		flags)
 {
-	int		error = 0, error2 = 0;
+	int		error = 0;
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x\n",
@@ -294,12 +293,20 @@ xfs_qm_scall_trunc_qfiles(
 		return XFS_ERROR(EINVAL);
 	}
 
-	if (flags & XFS_DQ_USER)
+	if (flags & XFS_DQ_USER) {
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
-	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
-		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+		if (error)
+			return error;
+	}
+	if (flags & XFS_DQ_GROUP) {
+		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+		if (error)
+			return error;
+	}
+	if (flags & XFS_DQ_PROJ)
+		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
 
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -413,17 +420,18 @@ xfs_qm_scall_getqstat(
 	struct fs_quota_stat	*out)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_inode	*uip, *gip;
-	boolean_t		tempuqip, tempgqip;
+	struct xfs_inode	*uip, *gip, *pip;
+	boolean_t		tempuqip, tempgqip, temppqip;
 
-	uip = gip = NULL;
-	tempuqip = tempgqip = B_FALSE;
+	uip = gip = pip = NULL;
+	tempuqip = tempgqip = temppqip = B_FALSE;
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
 	out->qs_version = FS_QSTAT_VERSION;
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
+		out->qs_pquota.qfs_ino = NULLFSINO;
 		return (0);
 	}
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
@@ -432,10 +440,13 @@ xfs_qm_scall_getqstat(
 	out->qs_pad = 0;
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
+	if (&out->qs_gquota != &out->qs_pquota)
+		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
 	if (q) {
 		uip = q->qi_uquotaip;
 		gip = q->qi_gquotaip;
+		pip = q->qi_pquotaip;
 	}
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
@@ -447,6 +458,11 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = B_TRUE;
 	}
+	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+			     0, 0, &pip) == 0)
+			temppqip = B_TRUE;
+	}
 	if (uip) {
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
@@ -459,6 +475,12 @@ xfs_qm_scall_getqstat(
 		if (tempgqip)
 			IRELE(gip);
 	}
+	if (pip) {
+		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
+		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
+		if (temppqip)
+			IRELE(pip);
+	}
 	if (q) {
 		out->qs_incoredqs = q->qi_dquots;
 		out->qs_btimelimit = q->qi_btimelimit;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 10cc0a3..63f22b2 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -284,14 +284,6 @@ typedef struct xfs_qoff_logformat {
 	 (XFS_IS_PQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
-#define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
-
 #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
 				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
 				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 8fd7894..e210a3e 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -81,11 +81,15 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
+#define XFS_SB_VERSION2_NO_OQUOTA	0x00000100	/* No OQUOTA and has *
+							 * separate project  *
+							 * quota field	     */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
-	 XFS_SB_VERSION2_PROJID32BIT)
+	 XFS_SB_VERSION2_PROJID32BIT	| \
+	 XFS_SB_VERSION2_NO_OQUOTA)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -250,7 +254,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_PQUOTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -276,6 +280,7 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -283,7 +288,7 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2)
+	 XFS_SB_BAD_FEATURES2 | XFS_SB_PQUOTINO)
 
 
 /*
@@ -504,6 +509,12 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
 }
 
+static inline int xfs_sb_version_has_no_oquota(xfs_sb_t *sbp)
+{
+	return xfs_sb_version_hasmorebits(sbp) &&
+	       (sbp->sb_features2 & XFS_SB_VERSION2_NO_OQUOTA);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ed249a7..7afdd38 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -399,12 +399,6 @@ xfs_parseargs(
 	}
 #endif
 
-	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
-	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
-		xfs_warn(mp, "cannot mount with both project and group quota");
-		return EINVAL;
-	}
-
 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
 		xfs_warn(mp, "sunit and swidth must be specified together");
 		return EINVAL;
@@ -1331,6 +1325,15 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_counters;
 
+	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
+	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
+	    !xfs_sb_version_has_no_oquota(&mp->m_sb)) {
+		xfs_warn(mp, "Super block does not support "
+			     "project and group quota together");
+		error = EINVAL;
+		goto out_free_sb;
+	}
+
 	error = xfs_finish_flags(mp);
 	if (error)
 		goto out_free_sb;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index e253089..923d860 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -163,7 +163,8 @@ xfs_trans_mod_dquot_byino(
 	if (!XFS_IS_QUOTA_RUNNING(mp) ||
 	    !XFS_IS_QUOTA_ON(mp) ||
 	    ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	    ip->i_ino == mp->m_sb.sb_gquotino ||
+	    ip->i_ino == mp->m_sb.sb_pquotino)
 		return;
 
 	if (tp->t_dqinfo == NULL)
diff --git a/include/linux/dqblk_xfs.h b/include/linux/dqblk_xfs.h
index 8655280..f17e3bb 100644
--- a/include/linux/dqblk_xfs.h
+++ b/include/linux/dqblk_xfs.h
@@ -155,6 +155,7 @@ typedef struct fs_quota_stat {
 	__s8		qs_pad;		/* unused */
 	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
 	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
+#define qs_pquota	qs_gquota
 	__u32		qs_incoredqs;	/* number of dquots incore */
 	__s32		qs_btimelimit;  /* limit for blks timer */	
 	__s32		qs_itimelimit;  /* limit for inodes timer */	
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
