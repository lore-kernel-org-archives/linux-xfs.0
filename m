Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7E7F7F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 21:59:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90CDD304032
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 19:59:20 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id HyRN4VJGeIZ8vow6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 19:59:19 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Sun, 23 Jun 2013 20:48:36 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 1A13619D8043
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:24 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5O2mXia158736 for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5O2mXhj008529
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:33 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v9 2/6] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Date: Sun, 23 Jun 2013 21:48:23 -0500
Message-Id: <1372042107-27332-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
PQUOTA respectively.

On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.

Read and write of the superblock does the conversion from *OQUOTA*
to *[PG]QUOTA*.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_mount.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c          |    9 ++++++---
 fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++------------------
 fs/xfs/xfs_quota.h       |   42 ++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_quotaops.c    |    6 ++++--
 fs/xfs/xfs_super.c       |   16 ++++++++--------
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 7 files changed, 115 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6a19434..e2e14cb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -336,6 +336,14 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EWRONGFS);
 	}
 
+	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
+			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
+		xfs_notice(mp,
+"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	/*
 	 * Version 5 superblock feature mask validation. Reject combinations the
 	 * kernel cannot support up front before checking anything else. For
@@ -622,6 +630,35 @@ xfs_sb_from_disk(
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }
 
+static inline void
+xfs_handle_quota_to_disk(
+	xfs_dsb_t	*to,
+	xfs_sb_t	*from,
+	__int64_t	*fields)
+{
+	__uint16_t	qflags = from->sb_qflags;
+
+	if (*fields & XFS_SB_QFLAGS) {
+		/*
+		 * The in-core version of sb_qflags do not have
+		 * XFS_OQUOTA_* flags, whereas the on-disk version
+		 * does.  So, convert incore XFS_{PG}QUOTA_* flags
+		 * to on-disk XFS_OQUOTA_* flags.
+		 */
+		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
+
+		if (from->sb_qflags &
+				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
+			qflags |= XFS_OQUOTA_ENFD;
+		if (from->sb_qflags &
+				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
+			qflags |= XFS_OQUOTA_CHKD;
+		to->sb_qflags = cpu_to_be16(qflags);
+		*fields &= ~XFS_SB_QFLAGS;
+	}
+}
+
 /*
  * Copy in core superblock to ondisk one.
  *
@@ -643,6 +680,7 @@ xfs_sb_to_disk(
 	if (!fields)
 		return;
 
+	xfs_handle_quota_to_disk(to, from, &fields);
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -835,6 +873,14 @@ reread:
 	 */
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 
+	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+	if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
 	 */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f5f9925..de7ecbd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -299,8 +299,10 @@ xfs_qm_mount_quotas(
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
@@ -1297,7 +1299,8 @@ xfs_qm_quotacheck(
 					 &buffer_list);
 		if (error)
 			goto error_return;
-		flags |= XFS_OQUOTA_CHKD;
+		flags |= XFS_IS_GQUOTA_ON(mp) ?
+					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
 	}
 
 	do {
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b03b2ab..5e51227 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -117,11 +117,11 @@ xfs_qm_scall_quotaoff(
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
 
@@ -335,14 +335,14 @@ xfs_qm_scall_quotaon(
 	 * quota acct on ondisk without m_qflags' knowing.
 	 */
 	if (((flags & XFS_UQUOTA_ACCT) == 0 &&
-	    (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
-	    (flags & XFS_UQUOTA_ENFD))
-	    ||
+	     (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
+	     (flags & XFS_UQUOTA_ENFD)) ||
 	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
-	    (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
-	    (flags & XFS_GQUOTA_ACCT) == 0 &&
-	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
-	    (flags & XFS_OQUOTA_ENFD))) {
+	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
+	     (flags & XFS_PQUOTA_ENFD)) ||
+	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
+	     (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
+	     (flags & XFS_GQUOTA_ENFD))) {
 		xfs_debug(mp,
 			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
 			__func__, flags, mp->m_sb.sb_qflags);
@@ -776,9 +776,12 @@ xfs_qm_scall_getquota(
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && dqp->q_core.d_flags == XFS_DQ_USER) ||
-	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(dqp->q_core.d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
+	if ((!XFS_IS_UQUOTA_ENFORCED(mp) &&
+	     dqp->q_core.d_flags == XFS_DQ_USER) ||
+	    (!XFS_IS_PQUOTA_ENFORCED(mp) &&
+	     dqp->q_core.d_flags == XFS_DQ_PROJ) ||
+	    (!XFS_IS_GQUOTA_ENFORCED(mp) &&
+	     dqp->q_core.d_flags == XFS_DQ_GROUP)) {
 		dst->d_btimer = 0;
 		dst->d_itimer = 0;
 		dst->d_rtbtimer = 0;
@@ -786,8 +789,8 @@ xfs_qm_scall_getquota(
 
 #ifdef DEBUG
 	if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags == FS_USER_QUOTA) ||
-	     (XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(dst->d_flags & (FS_PROJ_QUOTA | FS_GROUP_QUOTA)))) &&
+	     (XFS_IS_PQUOTA_ENFORCED(mp) && dst->d_flags == FS_PROJ_QUOTA) ||
+	     (XFS_IS_GQUOTA_ENFORCED(mp) && dst->d_flags == FS_GROUP_QUOTA)) &&
 	    dst->d_id != 0) {
 		if ((dst->d_bcount > dst->d_blk_softlimit) &&
 		    (dst->d_blk_softlimit > 0)) {
@@ -839,10 +842,10 @@ xfs_qm_export_flags(
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
 	return (uflags);
 }
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c38068f..0596860 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -161,28 +161,43 @@ typedef struct xfs_qoff_logformat {
 #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
 
 /*
+ * Start differentiating group quota and project quota using
+ * distinct flags, instead of using the combined OQUOTA flags.
+ *
+ * Conversion to and from the combined OQUOTA flag (if necessary)
+ * is done only in xfs_readsb() and xfs_sb_to_disk()
+ */
+#define XFS_GQUOTA_ENFD	0x0080  /* group quota limits enforced */
+#define XFS_GQUOTA_CHKD	0x0100  /* quotacheck run on group quotas */
+#define XFS_PQUOTA_ENFD	0x0200  /* project quota limits enforced */
+#define XFS_PQUOTA_CHKD	0x0400  /* quotacheck run on project quotas */
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
  * are in the process of getting turned off. These flags are in m_qflags but
  * never in sb_qflags.
  */
-#define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
+#define XFS_PQUOTA_ACTIVE	0x2000  /* pquotas are being turned off */
+#define XFS_GQUOTA_ACTIVE	0x4000  /* gquotas are being turned off */
 #define XFS_ALL_QUOTA_ACTIVE	\
 	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
 
@@ -268,24 +283,23 @@ typedef struct xfs_qoff_logformat {
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
index 71926d6..056d62e 100644
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
index 3033ba5..2a76ba2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -359,17 +359,17 @@ xfs_parseargs(
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
@@ -563,12 +563,12 @@ xfs_showargs(
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
@@ -1136,8 +1136,8 @@ xfs_fs_statfs(
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
index 7ea7485..80c81fe 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -632,8 +632,8 @@ xfs_trans_dqresv(
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
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
