Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 359FF7F4C
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:14:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5EC0AC001
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:14:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4zADMdYsXraVypfx for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:14:11 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbr-0008Sf-LY
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:14:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbh-0005FJ-CY
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 21/30] xfs: implement extended feature masks
Date: Fri, 17 May 2013 21:13:16 +1000
Message-Id: <1368789205-19969-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The version 5 superblock has extended feature masks for compatible,
incompatible and read-only compatible feature sets. Implement the
masking and mount-time checking for these feature masks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_sb.h           |   70 ++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_mount.c         |   53 ++++++++++++++++++++++++---------
 logprint/log_print_trans.c |   18 ++++++++++++
 3 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index d6709db..51db6f2 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -168,8 +168,10 @@ typedef struct xfs_sb {
 	__uint32_t	sb_features_compat;
 	__uint32_t	sb_features_ro_compat;
 	__uint32_t	sb_features_incompat;
+	__uint32_t	sb_features_log_incompat;
 
 	__uint32_t	sb_crc;		/* superblock crc */
+	__uint32_t	sb_pad;
 
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
@@ -250,8 +252,10 @@ typedef struct xfs_dsb {
 	__be32		sb_features_compat;
 	__be32		sb_features_ro_compat;
 	__be32		sb_features_incompat;
+	__be32		sb_features_log_incompat;
 
 	__le32		sb_crc;		/* superblock crc */
+	__be32		sb_pad;
 
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
@@ -276,7 +280,8 @@ typedef enum {
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
 	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
-	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT, XFS_SBS_CRC,
+	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
+	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
 	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
@@ -306,6 +311,7 @@ typedef enum {
 #define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
 #define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
 #define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
+#define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
 #define XFS_SB_CRC		XFS_SB_MVAL(CRC)
 #define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
@@ -316,7 +322,8 @@ typedef enum {
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
 	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
-	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | XFS_SB_PQUOTINO)
+	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
+	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
 
 
 /*
@@ -559,6 +566,65 @@ static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+
+/*
+ * Extended v5 superblock feature masks. These are to be used for new v5
+ * superblock features only.
+ *
+ * Compat features are new features that old kernels will not notice or affect
+ * and so can mount read-write without issues.
+ *
+ * RO-Compat (read only) are features that old kernels can read but will break
+ * if they write. Hence only read-only mounts of such filesystems are allowed on
+ * kernels that don't support the feature bit.
+ *
+ * InCompat features are features which old kernels will not understand and so
+ * must not mount.
+ *
+ * Log-InCompat features are for changes to log formats or new transactions that
+ * can't be replayed on older kernels. The fields are set when the filesystem is
+ * mounted, and a clean unmount clears the fields.
+ */
+#define XFS_SB_FEAT_COMPAT_ALL 0
+#define XFS_SB_FEAT_COMPAT_UNKNOWN	~XFS_SB_FEAT_COMPAT_ALL
+static inline bool
+xfs_sb_has_compat_feature(
+	struct xfs_sb	*sbp,
+	__uint32_t	feature)
+{
+	return (sbp->sb_features_compat & feature) != 0;
+}
+
+#define XFS_SB_FEAT_RO_COMPAT_ALL 0
+#define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
+static inline bool
+xfs_sb_has_ro_compat_feature(
+	struct xfs_sb	*sbp,
+	__uint32_t	feature)
+{
+	return (sbp->sb_features_ro_compat & feature) != 0;
+}
+
+#define XFS_SB_FEAT_INCOMPAT_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
+static inline bool
+xfs_sb_has_incompat_feature(
+	struct xfs_sb	*sbp,
+	__uint32_t	feature)
+{
+	return (sbp->sb_features_incompat & feature) != 0;
+}
+
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
+static inline bool
+xfs_sb_has_incompat_log_feature(
+	struct xfs_sb	*sbp,
+	__uint32_t	feature)
+{
+	return (sbp->sb_features_log_incompat & feature) != 0;
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index 07b892b..f66f63d 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -73,7 +73,9 @@ static const struct {
     { offsetof(xfs_sb_t, sb_features_compat), 0 },
     { offsetof(xfs_sb_t, sb_features_ro_compat), 0 },
     { offsetof(xfs_sb_t, sb_features_incompat), 0 },
+    { offsetof(xfs_sb_t, sb_features_log_incompat), 0 },
     { offsetof(xfs_sb_t, sb_crc),	 0 },
+    { offsetof(xfs_sb_t, sb_pad),	 0 },
     { offsetof(xfs_sb_t, sb_pquotino),	 0 },
     { offsetof(xfs_sb_t, sb_lsn),	 0 },
     { sizeof(xfs_sb_t),			 0 }
@@ -140,18 +142,44 @@ xfs_mount_validate_sb(
 	}
 
 	/*
-	 * Do not allow Version 5 superblocks to mount right now, even though
-	 * support is in place. We need to implement the proper feature masks
-	 * first.
+	 * Version 5 superblock feature mask validation. Reject combinations the
+	 * kernel cannot support up front before checking anything else.
 	 */
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+	if (check_inprogress && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
 		xfs_alert(mp,
-	"Version 5 superblock detected. Experimental support not yet enabled!");
-		return XFS_ERROR(EINVAL);
+"Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!\n"
+"Use of these features is at your own risk!");
+
+		if (xfs_sb_has_compat_feature(sbp,
+					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"Superblock has unknown compatible features (0x%x) enabled.\n"
+"Using a more recent xfsprogs is recommended.",
+				(sbp->sb_features_compat &
+						XFS_SB_FEAT_COMPAT_UNKNOWN));
+		}
+
+		if (xfs_sb_has_ro_compat_feature(sbp,
+					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"Superblock has unknown read-only compatible features (0x%x) enabled.\n"
+"Using a more recent xfsprogs is recommended.",
+				(sbp->sb_features_ro_compat &
+						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		}
+		if (xfs_sb_has_incompat_feature(sbp,
+					XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
+			xfs_warn(mp,
+"Superblock has unknown incompatible features (0x%x) enabled.\n"
+"Filesystem can not be safely operated on by this xfsprogs installation",
+				(sbp->sb_features_incompat &
+						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
+			return XFS_ERROR(EINVAL);
+		}
 	}
 
 	if (unlikely(
-	    sbp->sb_logstart == 0 && mp->m_logdev == mp->m_dev)) {
+	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
 		"filesystem is marked as having an external log; "
 		"specify logdev on the mount command line.");
@@ -159,7 +187,7 @@ xfs_mount_validate_sb(
 	}
 
 	if (unlikely(
-	    sbp->sb_logstart != 0 && mp->m_logdev != mp->m_dev)) {
+	    sbp->sb_logstart != 0 && mp->m_logdev_targp != mp->m_ddev_targp)) {
 		xfs_warn(mp,
 		"filesystem is marked as having an internal log; "
 		"do not specify logdev on the mount command line.");
@@ -214,12 +242,6 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(ENOSYS);
 	}
 
-
-	if (check_inprogress && sbp->sb_inprogress) {
-		xfs_warn(mp, "Offline file system operation in progress!");
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-
 	/*
 	 * Version 1 directory format has never worked on Linux.
 	 */
@@ -285,6 +307,9 @@ xfs_sb_from_disk(
 	to->sb_features_compat = be32_to_cpu(from->sb_features_compat);
 	to->sb_features_ro_compat = be32_to_cpu(from->sb_features_ro_compat);
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
+	to->sb_features_log_incompat =
+				be32_to_cpu(from->sb_features_log_incompat);
+	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 86e1c42..2dd3a10 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -68,6 +68,24 @@ xfs_log_print_trans(
 
 	if (head_blk == tail_blk)
 		return;
+
+	/*
+	 * Version 5 superblock log feature mask validation. We know the
+	 * log is dirty so check if there are any unknown log features
+	 * in what we need to recover. If there are unknown features
+	 * (e.g. unsupported transactions) then warn about it.
+	 */
+	if (XFS_SB_VERSION_NUM(&log->l_mp->m_sb) == XFS_SB_VERSION_5 &&
+	    xfs_sb_has_incompat_log_feature(&log->l_mp->m_sb,
+				XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
+		printf(_(
+"Superblock has unknown incompatible log features (0x%x) enabled.\n"
+"Output may be incomplete or inaccurate. It is recommended that you\n"
+"upgrade your xfsprogs installation to match the filesystem features.\n"),
+			(log->l_mp->m_sb.sb_features_log_incompat &
+				XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+	}
+
 	if ((error = xlog_do_recovery_pass(log, head_blk, tail_blk, XLOG_RECOVER_PASS1))) {
 		fprintf(stderr, _("%s: failed in xfs_do_recovery_pass, error: %d\n"),
 			progname, error);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
