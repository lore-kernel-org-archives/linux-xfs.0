Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D8avNF130778 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 03:36:57 -0500
Message-ID: <4FFFDDFD.6060905@oracle.com>
Date: Fri, 13 Jul 2012 16:36:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfs: Add a new field to fs_quota_stat to get pquota
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

Add a new field to fs_quota_stat and define a new version for bigger size.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 fs/quota/quota.c          |    7 ++++++-
 fs/xfs/xfs_qm_syscalls.c  |   23 +++++++++++++++--------
 include/linux/dqblk_xfs.h |   29 ++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 9a39120..8505696 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -203,8 +203,13 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
 
 	if (!sb->s_qcop->get_xstate)
 		return -ENOSYS;
+	/* just get the version */
+	if (copy_from_user(&fqs, addr, 1))
+		return -EFAULT;
+	if (!valid_qstat_version(fqs.qs_version))
+		fqs.qs_version = FS_QSTAT_VERSION;
 	ret = sb->s_qcop->get_xstate(sb, &fqs);
-	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
+	if (!ret && copy_to_user(addr, &fqs, qstatsize(fqs.qs_version)))
 		return -EFAULT;
 	return ret;
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 57f9650..fbcc54a 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -427,7 +427,6 @@ xfs_qm_scall_getqstat(
 	tempuqip = tempgqip = temppqip = B_FALSE;
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
-	out->qs_version = FS_QSTAT_VERSION;
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
@@ -440,8 +439,6 @@ xfs_qm_scall_getqstat(
 	out->qs_pad = 0;
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-	if (&out->qs_gquota != &out->qs_pquota)
-		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
 	if (q) {
 		uip = q->qi_uquotaip;
@@ -458,11 +455,6 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = B_TRUE;
 	}
-	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-			     0, 0, &pip) == 0)
-			temppqip = B_TRUE;
-	}
 	if (uip) {
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
@@ -481,6 +473,21 @@ xfs_qm_scall_getqstat(
 		if (temppqip)
 			IRELE(pip);
 	}
+	if (out->qs_version >= FS_QSTAT_VERSION_2) {
+		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
+		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+				     0, 0, &pip) == 0)
+				temppqip = B_TRUE;
+		}
+		if (pip) {
+			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
+			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+			if (temppqip)
+				IRELE(pip);
+		}
+	}
+
 	if (q) {
 		out->qs_incoredqs = q->qi_dquots;
 		out->qs_btimelimit = q->qi_btimelimit;
diff --git a/include/linux/dqblk_xfs.h b/include/linux/dqblk_xfs.h
index f17e3bb..4d0f3b0 100644
--- a/include/linux/dqblk_xfs.h
+++ b/include/linux/dqblk_xfs.h
@@ -18,6 +18,7 @@
 #define _LINUX_DQBLK_XFS_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 
 /*
  * Disk quota - quotactl(2) commands for the XFS Quota Manager (XQM).
@@ -139,6 +140,7 @@ typedef struct fs_disk_quota {
  * incore.
  */
 #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
+#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota */
 
 /*
  * Some basic information about 'quota files'.
@@ -155,13 +157,38 @@ typedef struct fs_quota_stat {
 	__s8		qs_pad;		/* unused */
 	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
 	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
-#define qs_pquota	qs_gquota
 	__u32		qs_incoredqs;	/* number of dquots incore */
 	__s32		qs_btimelimit;  /* limit for blks timer */	
 	__s32		qs_itimelimit;  /* limit for inodes timer */	
 	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
 	__u16		qs_bwarnlimit;	/* limit for num warnings */
 	__u16		qs_iwarnlimit;	/* limit for num warnings */
+	fs_qfilestat_t	qs_pquota;	/* project quota storage information */
 } fs_quota_stat_t;
 
+#define FS_QSTAT_V1_SIZE	(offsetof(fs_quota_stat_t, qs_pquota))
+#define FS_QSTAT_V2_SIZE	(FS_QSTAT_V1_SIZE + sizeof(fs_qfilestat_t))
+
+static inline int valid_qstat_version(int version)
+{
+	switch (version) {
+	case FS_QSTAT_VERSION:
+	case FS_QSTAT_VERSION_2:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static inline int qstatsize(int version)
+{
+	switch (version) {
+	case FS_QSTAT_VERSION_2:
+		return FS_QSTAT_V2_SIZE;
+	case FS_QSTAT_VERSION:
+	default:
+		return FS_QSTAT_V1_SIZE;
+	}
+}
+
 #endif	/* _LINUX_DQBLK_XFS_H */
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
