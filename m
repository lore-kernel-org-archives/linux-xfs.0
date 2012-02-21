Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LGthgf198019 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 10:55:43 -0600
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id bGLWLNLPAKylHu1K (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 08:55:42 -0800 (PST)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 21 Feb 2012 09:55:40 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E7BDD3E40036
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 09:54:43 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1LGsYT3065700 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 09:54:37 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q1LGsUqu032414
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 09:54:30 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 10:54:29 -0600
Message-Id: <20120221165429.22549.37299.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120221165341.22549.58434.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120221165341.22549.58434.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v4 PATCH 4/4] xfs: Add a new field to fs_quota_stat to get
	pquota information
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

>From 958f28b3f30576d0ce1e9ea1cb909b686d08cc61 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 09:07:00 -0600
Subject: [PATCH 4/4] Add a new field to fs_quota_stat and define a new version for
 the bigger size.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/quota/quota.c          |    6 +++++-
 fs/xfs/xfs_qm_syscalls.c  |   26 +++++++++++++-------------
 include/linux/dqblk_xfs.h |   28 +++++++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 7898cd6..ee571b9 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -203,8 +203,12 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
 
 	if (!sb->s_qcop->get_xstate)
 		return -ENOSYS;
+	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
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
index 8c65892..ffffdbc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -431,7 +431,6 @@ xfs_qm_scall_getqstat(
 	tempuqip = tempgqip = temppqip = B_FALSE;
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
-	out->qs_version = FS_QSTAT_VERSION;
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
@@ -444,8 +443,6 @@ xfs_qm_scall_getqstat(
 	out->qs_pad = 0;
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-	if (&out->qs_gquota != &out->qs_pquota)
-		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
 	if (q) {
 		uip = q->qi_uquotaip;
@@ -462,11 +459,6 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = B_TRUE;
 	}
-	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					0, 0, &pip) == 0)
-			temppqip = B_TRUE;
-	}
 	if (uip) {
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
@@ -479,11 +471,19 @@ xfs_qm_scall_getqstat(
 		if (tempgqip)
 			IRELE(gip);
 	}
-	if (pip) {
-		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
-		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
-		if (temppqip)
-			IRELE(pip);
+	if (out->qs_version >= FS_QSTAT_VERSION_2) {
+		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
+		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+						0, 0, &pip) == 0)
+				temppqip = B_TRUE;
+		}
+		if (pip) {
+			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
+			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+			if (temppqip)
+				IRELE(pip);
+		}
 	}
 	if (q) {
 		out->qs_incoredqs = q->qi_dquots;
diff --git a/include/linux/dqblk_xfs.h b/include/linux/dqblk_xfs.h
index f17e3bb..5be63fb 100644
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
@@ -155,13 +157,37 @@ typedef struct fs_quota_stat {
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
+#define FS_QSTAT_V2_SIZE	(FS_QSTAT_V1_SIZE + sizeof (fs_qfilestat_t))
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
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
