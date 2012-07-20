Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KN42pV165465 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 18:04:02 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id uM7sKBCzhO86oHoM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Jul 2012 16:04:01 -0700 (PDT)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 20 Jul 2012 17:04:01 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id C66D93E40039
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 23:03:56 +0000 (WET)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q6KN3vSV172928 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 17:03:57 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q6KN3vkl017633
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 17:03:57 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 20 Jul 2012 18:03:56 -0500
Message-Id: <20120720230356.20689.44947.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120720230350.20689.40213.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120720230350.20689.40213.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 1/4] xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and
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

No changes is made to the on-disk version of the superblock yet. On-disk
copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 db/check.c          |    8 ++++----
 include/xfs_quota.h |   47 +++++++++++++++++++++++++++++++++--------------
 include/xfs_sb.h    |   17 ++++++++++++++++-
 repair/versions.c   |   18 ++++--------------
 repair/xfs_repair.c |    4 ++--
 5 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/db/check.c b/db/check.c
index e601e0a..f00fae7 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2883,11 +2883,11 @@ process_inode(
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
@@ -3896,11 +3896,11 @@ quota_init(void)
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
index 5d1f57d..aa583a3 100644
--- a/include/xfs_quota.h
+++ b/include/xfs_quota.h
@@ -154,19 +154,42 @@ typedef struct xfs_qoff_logformat {
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
+#define XFS_VALID_QFLAGS(sbp) (xfs_sb_version_hasnooquota(sbp) ? \
+		(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|XFS_UQUOTA_CHKD| \
+		 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD| \
+		 XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD) : \
+		(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|XFS_UQUOTA_CHKD| \
+		 XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD| \
+		 XFS_PQUOTA_ACCT))
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
+#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
+#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
 
 /*
  * Incore only flags for quotaoff - these bits get cleared when quota(s)
@@ -184,8 +207,6 @@ typedef struct xfs_qoff_logformat {
 #define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
 						   XFS_GQUOTA_ACTIVE | \
 						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
 #define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
 #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
 #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
@@ -260,25 +281,23 @@ typedef struct xfs_qoff_logformat {
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
-
+				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
+				 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|\
+				 XFS_GQUOTA_CHKD)
 
 /*
  * The structure kept inside the xfs_trans_t keep track of dquot changes
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 5dcc2d7..69c6822 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -81,11 +81,13 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
+#define XFS_SB_VERSION2_NO_OQUOTA	0x00000100	/* sep prj quota inode */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
-	 XFS_SB_VERSION2_PROJID32BIT)
+	 XFS_SB_VERSION2_PROJID32BIT	| \
+	 XFS_SB_VERSION2_NO_OQUOTA)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -510,6 +512,19 @@ static inline void xfs_sb_version_addprojid32bit(xfs_sb_t *sbp)
 	sbp->sb_bad_features2 |= XFS_SB_VERSION2_PROJID32BIT;
 }
 
+static inline int xfs_sb_version_hasnooquota(xfs_sb_t *sbp)
+{
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_NO_OQUOTA);
+}
+
+static inline void xfs_sb_version_addnooquota(xfs_sb_t *sbp)
+{
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
+	sbp->sb_bad_features2 |= XFS_SB_VERSION2_NO_OQUOTA;
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/repair/versions.c b/repair/versions.c
index 957766a..e37eb10 100644
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
+		if (sb->sb_qflags & ~XFS_VALID_QFLAGS(sb)) {
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
+				sb->sb_qflags & ~XFS_VALID_QFLAGS(sb));
 
-			sb->sb_qflags &= (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|
-				XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|
-				XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|
-				XFS_PQUOTA_ACCT);
+			sb->sb_qflags &= XFS_VALID_QFLAGS(sb);
 
 			if (!no_modify)
 				do_warn(_(", bogus flags will be cleared\n"));
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 69b7eab..0b82e8e 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -856,10 +856,10 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = XFS_BUF_TO_SBP(sbp);
 
-	if (be16_to_cpu(dsb->sb_qflags) & (XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)) {
+	if (be16_to_cpu(dsb->sb_qflags) & (XFS_ALL_QUOTA_CHKD | XFS_OQUOTA_CHKD)) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
-		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
+		dsb->sb_qflags &= cpu_to_be16(~(XFS_ALL_QUOTA_CHKD |
 							XFS_OQUOTA_CHKD));
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
