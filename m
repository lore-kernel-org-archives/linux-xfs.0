Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 060EF7F56
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 17:27:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA4E98F80B6
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 15:27:28 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id WlfcKQFEMS7tIRjz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 15:27:27 -0700 (PDT)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 6 Aug 2013 16:27:27 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 3F7733E4004F
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 16:26:54 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r76MRHJP166988 for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:17 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r76MRHAb011681
	for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:17 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Date: Tue,  6 Aug 2013 17:27:07 -0500
Message-Id: <1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>

XFS now supports three types of quotas (user, group and project).

Current version of Q_XGETSTAT has support for only two types of quotas.
In order to support three types of quotas, the interface, specifically
struct fs_quota_stat, need to be expanded. Current version of fs_quota_stat
does not allow expansion without breaking backward compatibility.

So, a quotactl command and new fs_quota_stat structure need to be added.

This patch adds a new command Q_XGETQSTATV to quotactl() which takes
a new data structure fs_quota_statv. This new data structure provides
support for future expansion and backward compatibility.

Callers of the new quotactl command have to set the version of the data
structure being passed, and kernel will fill as much data as requested.
If the kernel does not support the user-space provided version, EINVAL
will be returned. User-space can reduce the version number and call the same
quotactl again.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/quota/quota.c               |   29 +++++++++++++++++++++++++
 include/linux/quota.h          |    1 +
 include/uapi/linux/dqblk_xfs.h |   46 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index c7314f1..e61a460 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -27,6 +27,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 	case Q_SYNC:
 	case Q_GETINFO:
 	case Q_XGETQSTAT:
+	case Q_XGETQSTATV:
 	case Q_XQUOTASYNC:
 		break;
 	/* allow to query information for dquots we "own" */
@@ -217,6 +218,31 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
 	return ret;
 }
 
+static int quota_getxstatev(struct super_block *sb, void __user *addr)
+{
+	struct fs_quota_statv fqs;
+	int ret;
+
+	if (!sb->s_qcop->get_xstatev)
+		return -ENOSYS;
+
+	memset(&fqs, 0, sizeof(fqs));
+	if (copy_from_user(&fqs, addr, 1)) /* Just read qs_version */
+		return -EFAULT;
+
+	/* If this kernel doesn't support user specified version, fail */
+	switch (fqs.qs_version) {
+	case FS_QSTATV_VERSION1:
+		break;
+	default:
+		return -EINVAL;
+	}
+	ret = sb->s_qcop->get_xstatev(sb, &fqs);
+	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
+		return -EFAULT;
+	return ret;
+}
+
 static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 			   void __user *addr)
 {
@@ -293,6 +319,8 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 		return quota_setxstate(sb, cmd, addr);
 	case Q_XGETQSTAT:
 		return quota_getxstate(sb, addr);
+	case Q_XGETQSTATV:
+		return quota_getxstatev(sb, addr);
 	case Q_XSETQLIM:
 		return quota_setxquota(sb, type, id, addr);
 	case Q_XGETQUOTA:
@@ -317,6 +345,7 @@ static int quotactl_cmd_write(int cmd)
 	case Q_GETINFO:
 	case Q_SYNC:
 	case Q_XGETQSTAT:
+	case Q_XGETQSTATV:
 	case Q_XGETQUOTA:
 	case Q_XQUOTASYNC:
 		return 0;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index d133711..cc7494a 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -328,6 +328,7 @@ struct quotactl_ops {
 	int (*set_dqblk)(struct super_block *, struct kqid, struct fs_disk_quota *);
 	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
 	int (*set_xstate)(struct super_block *, unsigned int, int);
+	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
 };
 
 struct quota_format_type {
diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
index 8655280..17f5063 100644
--- a/include/uapi/linux/dqblk_xfs.h
+++ b/include/uapi/linux/dqblk_xfs.h
@@ -38,6 +38,7 @@
 #define Q_XGETQSTAT	XQM_CMD(5)	/* get quota subsystem status */
 #define Q_XQUOTARM	XQM_CMD(6)	/* free disk space used by dquots */
 #define Q_XQUOTASYNC	XQM_CMD(7)	/* delalloc flush, updates dquots */
+#define Q_XGETQSTATV	XQM_CMD(8)	/* newer version of get quota */
 
 /*
  * fs_disk_quota structure:
@@ -163,4 +164,49 @@ typedef struct fs_quota_stat {
 	__u16		qs_iwarnlimit;	/* limit for num warnings */
 } fs_quota_stat_t;
 
+/*
+ * fs_quota_statv is the used by Q_XGETQSTATV for a given file system. It 
+ * provides a centralized way to get meta information about the quota
+ * subsystem. eg. space taken up for user, group, and project quotas, number
+ * of dquots currently incore.
+ *
+ * This version has proper versioning support with appropriate padding for
+ * future expansions, and ability to expand for future without creating any
+ * backwward compatibility issues.
+ *
+ * For Q_XGETQSTATV, user space caller need to specify fs_quota_statv.qs_version
+ * to the version of data they are interested in. Kernel will fill the data
+ * fields relevant to that version.
+ *
+ * If kernel does not support user space caller specified version, EINVAL will
+ * be returned. User space caller can then reduce the version number and retry
+ * the same command.
+ */
+#define FS_QSTATV_VERSION1	1	/* fs_quota_statv.qs_version */
+/*
+ * Some basic information about 'quota files' for Q_XGETQSTATV command
+ */
+struct fs_qfilestatv {
+	__u64		qfs_ino;	/* inode number */
+	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
+	__u32		qfs_nextents;	/* number of extents */
+	__u32		qfs_pad;	/* pad for 8-byte alignment */
+};
+
+struct fs_quota_statv {
+	__s8			qs_version;	/* version for future changes */
+	__u8			qs_pad1;	/* pad for 16bit alignment */
+	__u16			qs_flags;	/* FS_QUOTA_.* flags */
+	__u32			qs_incoredqs;	/* number of dquots incore */
+	struct fs_qfilestatv	qs_uquota;	/* user quota information */
+	struct fs_qfilestatv	qs_gquota;	/* group quota information */
+	struct fs_qfilestatv	qs_pquota;	/* project quota information */
+	__s32			qs_btimelimit;  /* limit for blks timer */
+	__s32			qs_itimelimit;  /* limit for inodes timer */
+	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
+	__u16			qs_bwarnlimit;	/* limit for num warnings */
+	__u16			qs_iwarnlimit;	/* limit for num warnings */
+	__u64			qs_pad2[8];	/* for future proofing */
+};
+
 #endif	/* _LINUX_DQBLK_XFS_H */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
