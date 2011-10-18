Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I09i6x032929 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 19:09:44 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 368141CF5C7
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:09:43 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id i2q6mlJkDb3ojwcq for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:09:43 -0700 (PDT)
Received: from /spool/local by us.ibm.com with XMail ESMTP
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 17 Oct 2011 18:09:42 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9I09ctO152096 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 18:09:38 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p9I09cA5011846
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 18:09:38 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 17 Oct 2011 19:09:38 -0500
Message-Id: <20111018000938.14942.44199.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 1/3] Remove in core use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.

No changes is made to the on-disk version of the superblock yey. On-disk
copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_mount.c       |   14 ++++++++++++++
 fs/xfs/xfs_qm.c          |   11 +++++++----
 fs/xfs/xfs_qm_syscalls.c |   26 ++++++++++++++------------
 fs/xfs/xfs_quota.h       |   37 ++++++++++++++++++++++++++-----------
 fs/xfs/xfs_quotaops.c    |    6 ++++--
 fs/xfs/xfs_super.c       |   19 ++++++++++---------
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 7 files changed, 77 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..366bbb7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -591,6 +591,14 @@ xfs_sb_from_disk(
 	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
 	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
 	to->sb_qflags = be16_to_cpu(from->sb_qflags);
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
@@ -625,6 +633,12 @@ xfs_sb_to_disk(
 	if (!fields)
 		return;
 
+	if (from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
+		from->sb_qflags |= XFS_OQUOTA_ENFD;
+	if (from->sb_qflags & (XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
+		from->sb_qflags |= XFS_OQUOTA_CHKD;
+	from->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
+					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5cff443..cb2ed78 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -343,8 +343,10 @@ xfs_qm_mount_quotas(
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
@@ -1638,7 +1640,8 @@ xfs_qm_quotacheck(
 					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
 		if (error)
 			goto error_return;
-		flags |= XFS_OQUOTA_CHKD;
+		flags |= XFS_IS_GQUOTA_ON(mp) ?
+					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
 	}
 
 	do {
@@ -1688,7 +1691,7 @@ xfs_qm_quotacheck(
 	 * quotachecked status, since we won't be doing accounting for
 	 * that type anymore.
 	 */
-	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
+	mp->m_qflags &= ~(XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD | XFS_UQUOTA_CHKD);
 	mp->m_qflags |= flags;
 
  error_return:
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5cc3dde..3a67805 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -120,11 +120,11 @@ xfs_qm_scall_quotaoff(
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
 
@@ -343,9 +343,11 @@ xfs_qm_scall_quotaon(
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
@@ -795,8 +797,8 @@ xfs_qm_export_dquot(
 	 * so return zeroes in that case.
 	 */
 	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_USER) ||
-	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(src->d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
+	    (!XFS_IS_PQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_PROJ) || 
+	    (!XFS_IS_GQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_GROUP)) {
 		dst->d_btimer = 0;
 		dst->d_itimer = 0;
 		dst->d_rtbtimer = 0;
@@ -804,8 +806,8 @@ xfs_qm_export_dquot(
 
 #ifdef DEBUG
 	if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags == FS_USER_QUOTA) ||
-	     (XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(dst->d_flags & (FS_PROJ_QUOTA | FS_GROUP_QUOTA)))) &&
+	     (XFS_IS_PQUOTA_ENFORCED(mp) && dst->d_flags == FS_PROJ_QUOTA) ||
+	     (XFS_IS_GQUOTA_ENFORCED(mp) && dst->d_flags == FS_GROUP_QUOTA)) &&
 	    dst->d_id != 0) {
 		if (((int) dst->d_bcount >= (int) dst->d_blk_softlimit) &&
 		    (dst->d_blk_softlimit > 0)) {
@@ -854,10 +856,10 @@ xfs_qm_export_flags(
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
index a595f29..41483d8 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -154,19 +154,35 @@ typedef struct xfs_qoff_logformat {
 #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
 
 /*
+ * If the superblock version is earlier than XFS_SB_VERSION_NO_OQUOTA,
+ * following flags will only be used in m_qflags and incore sb_qflags
+ * From XFS_SB_VERSION_NO_OQUOTA, these flags will be stored in
+ * on-disk sb_qflags too.
+ * Also from XFS_SB_VERSION_NO_OQUOTA, XFS_OQUOTA_.* will not be used 
+ * in on-disk sb_qflags.
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
@@ -260,24 +276,23 @@ typedef struct xfs_qoff_logformat {
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
index 7e76f53..be5389e 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -76,8 +76,10 @@ xfs_fs_set_xstate(
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
index ba16248..b1c8d5b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -328,7 +328,8 @@ xfs_parseargs(
 			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
 					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
 					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
+					  XFS_UQUOTA_ENFD | XFS_PQUOTA_ENFD |
+					  XFS_GQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
 			   !strcmp(this_char, MNTOPT_UQUOTA) ||
 			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
@@ -341,17 +342,17 @@ xfs_parseargs(
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
 			mp->m_flags |= XFS_MOUNT_DELAYLOG;
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
@@ -552,12 +553,12 @@ xfs_showargs(
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
@@ -1104,8 +1105,8 @@ xfs_fs_statfs(
 	spin_unlock(&mp->m_sb_lock);
 
 	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
-	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
-			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
+	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
+			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4d00ee6..bea957d 100644
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
