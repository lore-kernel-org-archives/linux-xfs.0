Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D8a2Rt130562 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 03:36:02 -0500
Message-ID: <4FFFDDB8.6000406@oracle.com>
Date: Fri, 13 Jul 2012 16:35:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
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
Cc: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>, Chandra Seetharaman <sekharan@us.ibm.com>

start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.  No changes is made to the on-disk version of the superblock yet.
On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 fs/xfs/xfs_mount.c       |   32 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_qm.c          |    9 ++++++---
 fs/xfs/xfs_qm_syscalls.c |   34 ++++++++++++++++++++--------------
 fs/xfs/xfs_quota.h       |   42 +++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_quotaops.c    |    6 ++++--
 fs/xfs/xfs_super.c       |   16 ++++++++--------
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 7 files changed, 102 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 536021f..4830c46 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -593,6 +593,20 @@ xfs_sb_from_disk(
 	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
 	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
 	to->sb_qflags = be16_to_cpu(from->sb_qflags);
+	if ((to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
+	    (to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+			      XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
+		xfs_notice(mp, "Super block has XFS_OQUOTA bits along with "
+			"XFS_PQUOTA and/or XFS_GQUOTA bits. Fixing it.\n");
+	}
+	if (to->sb_qflags & XFS_OQUOTA_ENFD)
+		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+	if (to->sb_qflags & XFS_OQUOTA_CHKD)
+		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+	to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
 	to->sb_flags = from->sb_flags;
 	to->sb_shared_vn = from->sb_shared_vn;
 	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
@@ -622,6 +636,7 @@ xfs_sb_to_disk(
 	xfs_sb_field_t	f;
 	int		first;
 	int		size;
+	__uint16_t	tmp16;
 
 	ASSERT(fields);
 	if (!fields)
@@ -634,8 +649,23 @@ xfs_sb_to_disk(
 
 		ASSERT(xfs_sb_info[f].type == 0 || xfs_sb_info[f].type == 1);
 
-		if (size == 1 || xfs_sb_info[f].type == 1) {
+		if (size == 1 || xfs_sb_info[f].type == 1)
 			memcpy(to_ptr + first, from_ptr + first, size);
+		else if (f == XFS_SBS_QFLAGS) {
+			/*
+			 * The in-core version of sb_qflags do not have
+			 * XFS_OQUOTA_* flags, whereas the on-disk version
+			 * does.  Save the in-core sb_qflags temporarily,
+			 * removing the new XFS_{PG}QUOTA_* flags and re-apply
+			 * the old on-disk flags.
+			 */
+			tmp16 = from->sb_qflags &
+					~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+					  XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
+			if (from->sb_qflags &
+					(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
+				tmp16 |= XFS_OQUOTA_CHKD;
+			*(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);
 		} else {
 			switch (size) {
 			case 2:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 249db19..cf9e1ee 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -297,8 +297,10 @@ xfs_qm_mount_quotas(
 	 */
 	if (!XFS_IS_UQUOTA_ON(mp))
 		mp->m_qflags &= ~XFS_UQUOTA_CHKD;
-	if (!(XFS_IS_GQUOTA_ON(mp) || XFS_IS_PQUOTA_ON(mp)))
-		mp->m_qflags &= ~XFS_OQUOTA_CHKD;
+	if (!XFS_IS_GQUOTA_ON(mp))
+		mp->m_qflags &= ~XFS_GQUOTA_CHKD;
+	if (!XFS_IS_PQUOTA_ON(mp))
+		mp->m_qflags &= ~XFS_PQUOTA_CHKD;
 
  write_changes:
 	/*
@@ -1260,7 +1262,8 @@ xfs_qm_quotacheck(
 					 &buffer_list);
 		if (error)
 			goto error_return;
-		flags |= XFS_OQUOTA_CHKD;
+		flags |= XFS_IS_GQUOTA_ON(mp) ?
+			 XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
 	}
 
 	do {
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 858a3b1..3f72a27 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -116,11 +116,11 @@ xfs_qm_scall_quotaoff(
 	}
 	if (flags & XFS_GQUOTA_ACCT) {
 		dqtype |= XFS_QMOPT_GQUOTA;
-		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
+		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
 		inactivate_flags |= XFS_GQUOTA_ACTIVE;
 	} else if (flags & XFS_PQUOTA_ACCT) {
 		dqtype |= XFS_QMOPT_PQUOTA;
-		flags |= (XFS_OQUOTA_CHKD | XFS_OQUOTA_ENFD);
+		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
 		inactivate_flags |= XFS_PQUOTA_ACTIVE;
 	}
 
@@ -339,9 +339,11 @@ xfs_qm_scall_quotaon(
 	    ||
 	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
 	    (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
-	    (flags & XFS_GQUOTA_ACCT) == 0 &&
+	    (flags & XFS_PQUOTA_ENFD))
+	    ||
+	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
 	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
-	    (flags & XFS_OQUOTA_ENFD))) {
+	    (flags & XFS_GQUOTA_ENFD))) {
 		xfs_debug(mp,
 			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
 			__func__, flags, mp->m_sb.sb_qflags);
@@ -770,9 +772,12 @@ xfs_qm_scall_getquota(
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && dqp->q_core.d_flags == XFS_DQ_USER) ||
-	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(dqp->q_core.d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
+	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
+		dqp->q_core.d_flags == XFS_DQ_USER) ||
+	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
+		dqp->q_core.d_flags == XFS_DQ_PROJ) ||
+	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
+		dqp->q_core.d_flags == XFS_DQ_GROUP)) {
 		dst->d_btimer = 0;
 		dst->d_itimer = 0;
 		dst->d_rtbtimer = 0;
@@ -780,9 +785,9 @@ xfs_qm_scall_getquota(
 
 #ifdef DEBUG
 	if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags == FS_USER_QUOTA) ||
-	     (XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(dst->d_flags & (FS_PROJ_QUOTA | FS_GROUP_QUOTA)))) &&
-	    dst->d_id != 0) {
+	     (XFS_IS_PQUOTA_ENFORCED(mp) && dst->d_flags == FS_PROJ_QUOTA) ||
+	     (XFS_IS_GQUOTA_ENFORCED(mp) && dst->d_flags == FS_GROUP_QUOTA)) &&
+		dst->d_id != 0) {
 		if (((int) dst->d_bcount > (int) dst->d_blk_softlimit) &&
 		    (dst->d_blk_softlimit > 0)) {
 			ASSERT(dst->d_btimer != 0);
@@ -833,10 +838,11 @@ xfs_qm_export_flags(
 		uflags |= FS_QUOTA_GDQ_ACCT;
 	if (flags & XFS_UQUOTA_ENFD)
 		uflags |= FS_QUOTA_UDQ_ENFD;
-	if (flags & (XFS_OQUOTA_ENFD)) {
-		uflags |= (flags & XFS_GQUOTA_ACCT) ?
-			FS_QUOTA_GDQ_ENFD : FS_QUOTA_PDQ_ENFD;
-	}
+	if (flags & XFS_PQUOTA_ENFD)
+		uflags |= FS_QUOTA_PDQ_ENFD;
+	if (flags & XFS_GQUOTA_ENFD)
+		uflags |= FS_QUOTA_GDQ_ENFD;
+
 	return (uflags);
 }
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b50ec5b..bba42e6 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -152,19 +152,40 @@ typedef struct xfs_qoff_logformat {
 #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
 
 /*
+ * Start differentiating group quota and project quota in-core
+ * using distinct flags, instread of using the combined OQUOTA flags.
+ *
+ * Conversion to and from the combined OQUOTA flag (if necessary)
+ * is done only in xfs_sb{to, from}_disk()
+ */
+#define XFS_GQUOTA_ENFD	0x0080	/* group quota limit enforced */
+#define XFS_GQUOTA_CHKD 0x0100	/* quotacheck run on group quotas */
+#define XFS_PQUOTA_ENFD	0x0200	/* project quota limits enforced */
+#define XFS_PQUOTA_CHKD	0x0800	/* quotacheck run on project quotas.
+				 * FIXME: here we cannot using 0x0400
+				 * because it is already reserved for
+				 * XFS_GQUOTA_ACTIVE.  Otherwise,
+				 * XFS_IS_GQUOTA_ON() is also true
+				 * although it does not enabled.
+				 */
+
+/*
  * Quota Accounting/Enforcement flags
  */
 #define XFS_ALL_QUOTA_ACCT	\
 		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
-#define XFS_ALL_QUOTA_ENFD	(XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD)
-#define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
+#define XFS_ALL_QUOTA_ENFD	\
+		(XFS_UQUOTA_ENFD | XFS_GQUOTA_ENFD | XFS_PQUOTA_ENFD)
+#define XFS_ALL_QUOTA_CHKD	\
+		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
 
 #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
 #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
 #define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
 #define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
 #define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
-#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
+#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
+#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
 
 /*
  * Incore only flags for quotaoff - these bits get cleared when quota(s)
@@ -259,24 +280,23 @@ typedef struct xfs_qoff_logformat {
 	((XFS_IS_UQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
 	 (XFS_IS_GQUOTA_ON(mp) && \
-		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
-		 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))) || \
+		(mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD) == 0) || \
 	 (XFS_IS_PQUOTA_ON(mp) && \
-		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
-		 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))))
+		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
 #define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
 				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
+				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
 
 #define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
 				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
+				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
 
 #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
 				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
-				 XFS_GQUOTA_ACCT)
+				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
+				 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|\
+				 XFS_GQUOTA_CHKD)
 
 
 /*
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index fed504f..6df4faf 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -75,8 +75,10 @@ xfs_fs_set_xstate(
 		flags |= XFS_GQUOTA_ACCT;
 	if (uflags & FS_QUOTA_UDQ_ENFD)
 		flags |= XFS_UQUOTA_ENFD;
-	if (uflags & (FS_QUOTA_PDQ_ENFD|FS_QUOTA_GDQ_ENFD))
-		flags |= XFS_OQUOTA_ENFD;
+	if (uflags & FS_QUOTA_PDQ_ENFD)
+		flags |= XFS_PQUOTA_ENFD;
+	if (uflags & FS_QUOTA_GDQ_ENFD)
+		flags |= XFS_GQUOTA_ENFD;
 
 	switch (op) {
 	case Q_XQUOTAON:
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0d9de41..61ac734 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -338,17 +338,17 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
 			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
 			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					 XFS_OQUOTA_ENFD);
+					 XFS_PQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
 			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
+			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
 			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					 XFS_OQUOTA_ENFD);
+					 XFS_GQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
+			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
 			xfs_warn(mp,
 	"delaylog is the default now, option is deprecated.");
@@ -541,12 +541,12 @@ xfs_showargs(
 	/* Either project or group quotas can be active, not both */
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+		if (mp->m_qflags & XFS_PQUOTA_ENFD)
 			seq_puts(m, "," MNTOPT_PRJQUOTA);
 		else
 			seq_puts(m, "," MNTOPT_PQUOTANOENF);
 	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_OQUOTA_ENFD)
+		if (mp->m_qflags & XFS_GQUOTA_ENFD)
 			seq_puts(m, "," MNTOPT_GRPQUOTA);
 		else
 			seq_puts(m, "," MNTOPT_GQUOTANOENF);
@@ -1070,8 +1070,8 @@ xfs_fs_statfs(
 	spin_unlock(&mp->m_sb_lock);
 
 	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
-			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
+	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
+			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index bcb6054..40460e8 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -638,8 +638,8 @@ xfs_trans_dqresv(
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
 	    dqp->q_core.d_id &&
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
-	     (XFS_IS_OQUOTA_ENFORCED(dqp->q_mount) &&
-	      (XFS_QM_ISPDQ(dqp) || XFS_QM_ISGDQ(dqp))))) {
+	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)) ||
+	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)))) {
 		if (nblks > 0) {
 			/*
 			 * dquot is locked already. See if we'd go over the
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
