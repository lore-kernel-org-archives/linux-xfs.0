Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76DAF7F55
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 16:53:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E94EEAC004
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 14:53:07 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id VoeBz7JlMPG7E0M4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 14:53:06 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 21 Mar 2013 15:53:04 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 962EF19D8043
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:55 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2LLqwKi150218 for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:58 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2LLqw5f023329
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:58 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v7 1/5] xfs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Date: Thu, 21 Mar 2013 16:52:50 -0500
Message-Id: <1363902774-19292-2-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
References: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
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

Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
Start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
PQUOTA respectively.

No changes are made to the on-disk version of the superblock yet. On-disk
copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.

Read and write of the superblock does the conversion from *OQUOTA*
to *[PG]QUOTA* and vice versa.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c       |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c          |    9 ++++++---
 fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++------------------
 fs/xfs/xfs_quota.h       |   42 ++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_quotaops.c    |    6 ++++--
 fs/xfs/xfs_super.c       |   16 ++++++++--------
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 7 files changed, 110 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3806088..e779276 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -511,6 +511,8 @@ xfs_sb_from_disk(
 	struct xfs_sb	*to,
 	xfs_dsb_t	*from)
 {
+	bool force_quota_check = false;
+
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
 	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
 	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
@@ -546,6 +548,21 @@ xfs_sb_from_disk(
 	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
 	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
 	to->sb_qflags = be16_to_cpu(from->sb_qflags);
+	if ((to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
+			(to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
+		xfs_notice(NULL, "Super block has XFS_OQUOTA bits along with "
+		    "XFS_PQUOTA and/or XFS_GQUOTA bits. Quota check forced.\n");
+		force_quota_check = true;
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
@@ -557,6 +574,9 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+
+	if (force_quota_check)
+		to->sb_qflags &= ~(XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD);
 }
 
 /*
@@ -575,11 +595,30 @@ xfs_sb_to_disk(
 	xfs_sb_field_t	f;
 	int		first;
 	int		size;
+	__uint16_t	qflags = from->sb_qflags;
 
 	ASSERT(fields);
 	if (!fields)
 		return;
 
+	if (fields & XFS_SB_QFLAGS) {
+		/*
+		 * The in-core version of sb_qflags do not have
+		 * XFS_OQUOTA_* flags, whereas the on-disk version
+		 * does. So, convert incore XFS_{PG}QUOTA_* flags
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
+	}
+
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -589,6 +628,8 @@ xfs_sb_to_disk(
 
 		if (size == 1 || xfs_sb_info[f].type == 1) {
 			memcpy(to_ptr + first, from_ptr + first, size);
+		} else if (f == XFS_SBS_QFLAGS) {
+			*(__be16 *)(to_ptr + first) = cpu_to_be16(qflags);
 		} else {
 			switch (size) {
 			case 2:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e5b5cf9..b505be7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -298,8 +298,10 @@ xfs_qm_mount_quotas(
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
@@ -1263,7 +1265,8 @@ xfs_qm_quotacheck(
 					 &buffer_list);
 		if (error)
 			goto error_return;
-		flags |= XFS_OQUOTA_CHKD;
+		flags |= XFS_IS_GQUOTA_ON(mp) ?
+					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
 	}
 
 	do {
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index cf9a340..3b3211c 100644
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
@@ -769,9 +769,12 @@ xfs_qm_scall_getquota(
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
@@ -779,8 +782,8 @@ xfs_qm_scall_getquota(
 
 #ifdef DEBUG
 	if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags == FS_USER_QUOTA) ||
-	     (XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(dst->d_flags & (FS_PROJ_QUOTA | FS_GROUP_QUOTA)))) &&
+	     (XFS_IS_PQUOTA_ENFORCED(mp) && dst->d_flags == FS_PROJ_QUOTA) ||
+	     (XFS_IS_GQUOTA_ENFORCED(mp) && dst->d_flags == FS_GROUP_QUOTA)) &&
 	    dst->d_id != 0) {
 		if ((dst->d_bcount > dst->d_blk_softlimit) &&
 		    (dst->d_blk_softlimit > 0)) {
@@ -832,10 +835,10 @@ xfs_qm_export_flags(
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
index b50ec5b..e5141bd 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -152,28 +152,43 @@ typedef struct xfs_qoff_logformat {
 #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
 
 /*
+ * Start differentiating group quota and project quota in-core
+ * using distinct flags, instead of using the combined OQUOTA flags.
+ *
+ * Conversion to and from the combined OQUOTA flag (if necessary)
+ * is done only in xfs_sb_{to,from}_disk()
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
 
@@ -259,24 +274,23 @@ typedef struct xfs_qoff_logformat {
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
index c407121..f08b9df 100644
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
index 642c2d6..e9ea2bc 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -640,8 +640,8 @@ xfs_trans_dqresv(
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
