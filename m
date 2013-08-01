Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4824B29E0E
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 14:25:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A00F8F804C
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 12:25:30 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id YXFIL6H6mFoorgF4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 12:25:23 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 1 Aug 2013 20:25:22 +0100
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id B9FDF38C8039
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 15:25:17 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r71JPIm5177992 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:25:18 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r71JPFwR018492
	for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 13:25:15 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/2] xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Date: Thu,  1 Aug 2013 14:25:00 -0500
Message-Id: <1375385101-3673-2-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
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

Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.

On disk version still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 db/check.c          |    8 +++---
 include/xfs_quota.h |   59 ++++++++++++++++++++++++++------------------------
 libxfs/xfs_mount.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
 repair/versions.c   |   18 +++------------
 repair/xfs_repair.c |    5 +--
 5 files changed, 93 insertions(+), 49 deletions(-)

diff --git a/db/check.c b/db/check.c
index d490f81..d66dc68 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2851,11 +2851,11 @@ process_inode(
 			process_quota(IS_USER_QUOTA, id, blkmap);
 		else if (id->ino == mp->m_sb.sb_gquotino &&
 			 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
-			 (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD))
+			 (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD))
 			process_quota(IS_GROUP_QUOTA, id, blkmap);
 		else if (id->ino == mp->m_sb.sb_gquotino &&
 			 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
-			 (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD))
+			 (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD))
 			process_quota(IS_PROJECT_QUOTA, id, blkmap);
 	}
 	if (blkmap)
@@ -3623,11 +3623,11 @@ quota_init(void)
 	qgdo = mp->m_sb.sb_gquotino != 0 &&
 	       mp->m_sb.sb_gquotino != NULLFSINO &&
 	       (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
-	       (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
+	       (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD);
 	qpdo = mp->m_sb.sb_gquotino != 0 &&
 	       mp->m_sb.sb_gquotino != NULLFSINO &&
 	       (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
-	       (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
+	       (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD);
 	if (qudo)
 		qudata = xcalloc(QDATA_HASH_SIZE, sizeof(qdata_t *));
 	if (qgdo)
diff --git a/include/xfs_quota.h b/include/xfs_quota.h
index c61e31c..3ac9da5 100644
--- a/include/xfs_quota.h
+++ b/include/xfs_quota.h
@@ -159,30 +159,51 @@ typedef struct xfs_qoff_logformat {
 #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
 
 /*
+ * Start differentiating group quota and project quota in-core
+ * using distinct flags, instead of using the combined OQUOTA flags.
+ *
+ * Conversion to and from the combined OQUOTA flag (if necessary)
+ * is done only in xfs_sb_{to,from}_disk()
+ */
+#define XFS_GQUOTA_ENFD 0x0080  /* group quota limits enforced */
+#define XFS_GQUOTA_CHKD 0x0100  /* quotacheck run on group quotas */
+#define XFS_PQUOTA_ENFD 0x0200  /* project quota limits enforced */
+#define XFS_PQUOTA_CHKD 0x0400  /* quotacheck run on project quotas */
+
+#define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
+				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
+				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD|\
+				 XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD|\
+				 XFS_PQUOTA_CHKD)
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
-#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
 #define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
+#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
 #define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
-#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
+#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
+#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
 
 /*
  * Incore only flags for quotaoff - these bits get cleared when quota(s)
  * are in the process of getting turned off. These flags are in m_qflags but
  * never in sb_qflags.
  */
-#define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
+#define XFS_GQUOTA_ACTIVE	0x4000  /* gquotas are being turned off */
+#define XFS_PQUOTA_ACTIVE	0x2000  /* pquotas are being turned off */
 #define XFS_ALL_QUOTA_ACTIVE	\
-	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
+	(XFS_UQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
 
 /*
  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
@@ -191,8 +212,6 @@ typedef struct xfs_qoff_logformat {
 #define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
 						   XFS_GQUOTA_ACTIVE | \
 						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
 #define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
 #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
 #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
@@ -266,25 +285,9 @@ typedef struct xfs_qoff_logformat {
 	((XFS_IS_UQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
 	 (XFS_IS_GQUOTA_ON(mp) && \
-		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
-		 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))) || \
+		(mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD) == 0) || \
 	 (XFS_IS_PQUOTA_ON(mp) && \
-		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
-		 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))))
-
-#define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
-				 XFS_GQUOTA_ACCT)
-
+		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
 /*
  * The structure kept inside the xfs_trans_t keep track of dquot changes
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index db3785d..e7a9003 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -179,6 +179,14 @@ xfs_mount_validate_sb(
 		}
 	}
 
+	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
+			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
+		xfs_warn(mp,
+"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
@@ -315,6 +323,47 @@ xfs_sb_from_disk(
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }
 
+static void
+xfs_sb_quota_from_disk(struct xfs_sb *sbp)
+{
+	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+	if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
+		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+}
+
+static inline void
+xfs_sb_quota_to_disk(
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
@@ -336,6 +385,7 @@ xfs_sb_to_disk(
 	if (!fields)
 		return;
 
+	xfs_sb_quota_to_disk(to, from, &fields);
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -378,6 +428,8 @@ xfs_sb_verify(
 
 	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
+	xfs_sb_quota_from_disk(&sb);
+
 	/*
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
diff --git a/repair/versions.c b/repair/versions.c
index c11a728..b65747a 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -61,26 +61,16 @@ update_sb_version(xfs_mount_t *mp)
 		/*
 		 * protect against stray bits in the quota flag field
 		 */
-		if (sb->sb_qflags & ~(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|
-				XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|
-				XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|
-				XFS_PQUOTA_ACCT))  {
+		if (sb->sb_qflags & ~XFS_MOUNT_QUOTA_ALL) {
 			/*
 			 * update the incore superblock, if we're in
 			 * no_modify mode, it'll never get flushed out
 			 * so this is ok.
 			 */
 			do_warn(_("bogus quota flags 0x%x set in superblock"),
-				sb->sb_qflags & ~(XFS_UQUOTA_ACCT|
-				XFS_UQUOTA_ENFD|
-				XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|
-				XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|
-				XFS_PQUOTA_ACCT));
+				sb->sb_qflags & ~XFS_MOUNT_QUOTA_ALL);
 
-			sb->sb_qflags &= (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|
-				XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|
-				XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|
-				XFS_PQUOTA_ACCT);
+			sb->sb_qflags &= XFS_MOUNT_QUOTA_ALL;
 
 			if (!no_modify)
 				do_warn(_(", bogus flags will be cleared\n"));
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 4708c5c..ab06201 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -852,11 +852,10 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = XFS_BUF_TO_SBP(sbp);
 
-	if (be16_to_cpu(dsb->sb_qflags) & (XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)) {
+	if (be16_to_cpu(dsb->sb_qflags) & XFS_ALL_QUOTA_CHKD) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
-		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
-							XFS_OQUOTA_CHKD));
+		dsb->sb_qflags &= cpu_to_be16(~XFS_ALL_QUOTA_CHKD);
 	}
 
 	if (clear_sunit) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
