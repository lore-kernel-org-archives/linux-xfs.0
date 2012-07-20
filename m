Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KN4e8S165641 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 18:04:40 -0500
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id ZkyM0zIroQbH9OeD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Jul 2012 16:04:39 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 20 Jul 2012 19:04:17 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id CE61838C8042
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 19:03:18 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q6KN3I3Z373204 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 19:03:18 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q6KN30fB010117 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 20:03:01 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 20 Jul 2012 18:02:47 -0500
Message-Id: <20120720230247.20477.68011.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v6 PATCH 4/5] xfs: Add proper versioning support to fs_quota_stat
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

Add proper versioning support for fs_quota_stat.

Leave the earlier version as version 1 and add version 2 to add a new
field "fs_qfilestat_t qs_pquota"

Callers of the system call have to just set the version of the data
structure being passed, and kernel will fill as much data as possible.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/quota/quota.c          |    6 +++++-
 include/linux/dqblk_xfs.h |   28 +++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 9a39120..ee929ca 100644
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
