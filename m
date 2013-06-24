Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2CF707F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:19:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1AB3D8F8035
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:19:43 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id 1hqAqXuFK9AD40u2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 20:19:42 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Sun, 23 Jun 2013 20:48:54 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 141643E40030
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:19 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5O2mcf3124718 for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:38 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5O2mct3008771
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:38 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v9 5/6] xfs: Add proper versioning support to fs_quota_stat
Date: Sun, 23 Jun 2013 21:48:26 -0500
Message-Id: <1372042107-27332-6-git-send-email-sekharan@us.ibm.com>
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

Added appropriate pads and code for backward compatibility.

Copied over the old version as it is different from the newer padded
version.

New callers of the system call have to set the version of the data
structure being passed, and kernel will fill as much data as requested.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/gfs2/quota.c                |    3 --
 fs/quota/quota.c               |   49 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_qm_syscalls.c       |    4 ---
 fs/xfs/xfs_super.c             |    5 +--
 include/uapi/linux/dqblk_xfs.h |   57 +++++++++++++++++++++++++++++++++++-----
 5 files changed, 99 insertions(+), 19 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c7c840e..ca0dccd 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1443,9 +1443,6 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
-	memset(fqs, 0, sizeof(struct fs_quota_stat));
-	fqs->qs_version = FS_QSTAT_VERSION;
-
 	switch (sdp->sd_args.ar_quota) {
 	case GFS2_QUOTA_ON:
 		fqs->qs_flags |= (FS_QUOTA_UDQ_ENFD | FS_QUOTA_GDQ_ENFD);
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index c7314f1..ae6526e 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -207,12 +207,57 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
 static int quota_getxstate(struct super_block *sb, void __user *addr)
 {
 	struct fs_quota_stat fqs;
-	int ret;
+	struct fs_quota_stat_v1 fqs_v1;
+	int ret, size;
+	void *fqsp;
 
 	if (!sb->s_qcop->get_xstate)
 		return -ENOSYS;
+
+	memset(&fqs, 0, sizeof(struct fs_quota_stat));
+	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
+		return -EFAULT;
+
+	switch (fqs.qs_version) {
+	case FS_QSTAT_VERSION_2:
+		size = FS_QSTAT_V2_SIZE;
+		break;
+	default:
+		fqs.qs_version = FS_QSTAT_VERSION;
+		/* fallthrough */
+	case FS_QSTAT_VERSION:
+		size = FS_QSTAT_V1_SIZE;
+		break;
+	}
+
 	ret = sb->s_qcop->get_xstate(sb, &fqs);
-	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
+	if (ret)
+		return ret;
+
+	if (fqs.qs_version == FS_QSTAT_VERSION) {
+		fqs_v1.qs_version = fqs.qs_version;
+		fqs_v1.qs_flags = fqs.qs_flags;
+		fqs_v1.qs_pad = 0;
+
+		fqs_v1.qs_uquota.qfs_ino = fqs.qs_uquota.qfs_ino;
+		fqs_v1.qs_uquota.qfs_nblks = fqs.qs_uquota.qfs_nblks;
+		fqs_v1.qs_uquota.qfs_nextents = fqs.qs_uquota.qfs_nextents;
+
+		fqs_v1.qs_gquota.qfs_ino = fqs.qs_gquota.qfs_ino;
+		fqs_v1.qs_gquota.qfs_nblks = fqs.qs_gquota.qfs_nblks;
+		fqs_v1.qs_gquota.qfs_nextents = fqs.qs_gquota.qfs_nextents;
+
+		fqs_v1.qs_incoredqs = fqs.qs_incoredqs;
+		fqs_v1.qs_btimelimit = fqs.qs_btimelimit;
+		fqs_v1.qs_itimelimit = fqs.qs_itimelimit;
+		fqs_v1.qs_rtbtimelimit = fqs.qs_rtbtimelimit;
+		fqs_v1.qs_bwarnlimit = fqs.qs_bwarnlimit;
+		fqs_v1.qs_iwarnlimit = fqs.qs_iwarnlimit;
+		fqsp = &fqs_v1;
+	} else
+		fqsp = &fqs;
+
+	if (copy_to_user(addr, fqsp, size))
 		return -EFAULT;
 	return ret;
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index d664a2d..1918f48 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -420,9 +420,6 @@ xfs_qm_scall_getqstat(
 	bool                    tempgqip = false;
 	bool                    temppqip = false;
 
-	memset(out, 0, sizeof(fs_quota_stat_t));
-
-	out->qs_version = FS_QSTAT_VERSION;
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
@@ -432,7 +429,6 @@ xfs_qm_scall_getqstat(
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
-	out->qs_pad = 0;
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
 	if (&out->qs_gquota != &out->qs_pquota)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1bcc017..ab90539 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -554,14 +554,13 @@ xfs_showargs(
 	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
 		seq_puts(m, "," MNTOPT_UQUOTANOENF);
 
-	/* Either project or group quotas can be active, not both */
-
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
 			seq_puts(m, "," MNTOPT_PRJQUOTA);
 		else
 			seq_puts(m, "," MNTOPT_PQUOTANOENF);
-	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
+	}
+	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_GQUOTA_ENFD)
 			seq_puts(m, "," MNTOPT_GRPQUOTA);
 		else
diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
index f17e3bb..e8ca23b 100644
--- a/include/uapi/linux/dqblk_xfs.h
+++ b/include/uapi/linux/dqblk_xfs.h
@@ -47,6 +47,7 @@
  * 512 bytes.
  */
 #define FS_DQUOT_VERSION	1	/* fs_disk_quota.d_version */
+
 typedef struct fs_disk_quota {
 	__s8		d_version;	/* version of this structure */
 	__s8		d_flags;	/* FS_{USER,PROJ,GROUP}_QUOTA */
@@ -137,31 +138,73 @@ typedef struct fs_disk_quota {
  * Provides a centralized way to get meta information about the quota subsystem.
  * eg. space taken up for user and group quotas, number of dquots currently
  * incore.
+ * User space caller should set qs_version to the appropriate version
+ * of the fs_quota_stat data structure they are providing. Not providing
+ * a version will be treated as FS_QSTAT_VERSION.
  */
 #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
+#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota; realignment */
 
 /*
  * Some basic information about 'quota files'.
  */
-typedef struct fs_qfilestat {
+struct fs_qfilestat_v1 {
 	__u64		qfs_ino;	/* inode number */
 	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
 	__u32		qfs_nextents;	/* number of extents */
-} fs_qfilestat_t;
+};
 
-typedef struct fs_quota_stat {
+struct fs_quota_stat_v1 {
 	__s8		qs_version;	/* version number for future changes */
 	__u16		qs_flags;	/* FS_QUOTA_{U,P,G}DQ_{ACCT,ENFD} */
 	__s8		qs_pad;		/* unused */
-	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
-	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
-#define qs_pquota	qs_gquota
+	struct fs_qfilestat_v1	qs_uquota;	/* user quota information */
+	struct fs_qfilestat_v1	qs_gquota;	/* group quota information */
 	__u32		qs_incoredqs;	/* number of dquots incore */
 	__s32		qs_btimelimit;  /* limit for blks timer */	
 	__s32		qs_itimelimit;  /* limit for inodes timer */	
 	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
 	__u16		qs_bwarnlimit;	/* limit for num warnings */
 	__u16		qs_iwarnlimit;	/* limit for num warnings */
-} fs_quota_stat_t;
+};
+
+/*
+ * Some basic information about 'quota files'. Version 2.
+ */
+struct fs_qfilestat {
+	__u64		qfs_ino;	/* inode number */
+	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
+	__u32		qfs_nextents;	/* number of extents */
+	__u8		qfs_pad[4];	/* pad for 8-byte alignment */
+};
+
+struct fs_quota_stat {
+	__s8			qs_version;	/* version for future changes */
+	__u8			qs_pad1;	/* pad for 16bit alignment */
+	__u16			qs_flags;	/* FS_QUOTA_.* flags */
+	__u8			qs_pad2[4];	/* pad for 8-byte alignment */
+	struct fs_qfilestat	qs_uquota;	/* user quota information */
+	struct fs_qfilestat	qs_gquota;	/* group quota information */
+	struct fs_qfilestat	qs_pquota;	/* project quota information */
+	__u32			qs_incoredqs;	/* number of dquots incore */
+	__s32			qs_btimelimit;  /* limit for blks timer */
+	__s32			qs_itimelimit;  /* limit for inodes timer */
+	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
+	__u16			qs_bwarnlimit;	/* limit for num warnings */
+	__u16			qs_iwarnlimit;	/* limit for num warnings */
+	__u8			qs_pad3[4];	/* pad for 8-byte alignment */
+	__u8			qs_pad4[64];	/* for future proofing */
+};
+
+/*
+ * Since Version 1 did not have padding at appropriate places,
+ * a new data structure has been defined for the older version to
+ * provide backward compatibility.
+ * Future extentions of this data structure won't require new
+ * data structure definitions as the current one can be extended
+ * with the logic and padding in place now.
+ */
+#define FS_QSTAT_V1_SIZE	(sizeof(struct fs_quota_stat_v1))
+#define FS_QSTAT_V2_SIZE	(sizeof(struct fs_quota_stat))
 
 #endif	/* _LINUX_DQBLK_XFS_H */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
