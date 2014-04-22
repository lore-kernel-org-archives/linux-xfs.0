Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E09687F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 13:48:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E7C9AC00E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 11:48:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bsVsBbBgERKshwAG for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 11:48:38 -0700 (PDT)
Message-ID: <5356B986.2060906@sandeen.net>
Date: Tue, 22 Apr 2014 13:48:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: fix Q_XQUOTARM ioctl
References: <535580A1.20806@redhat.com>
In-Reply-To: <535580A1.20806@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>
Cc: Jan Kara <jack@suse.cz>

The Q_XQUOTARM quotactl was not working properly, because
we weren't passing around proper flags.  The xfs_fs_set_xstate()
ioctl handler used the same flags for Q_XQUOTAON/OFF as
well as for Q_XQUOTARM, but Q_XQUOTAON/OFF look for
XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
i.e. quota type + state, while Q_XQUOTARM looks only for
the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.

Unfortunately these flag spaces overlap a bit, so we
got semi-random results for Q_XQUOTARM; i.e. the value
for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.

Add a new quotactl op vector specifically for the QUOTARM
operation, since it operates with a different flag space.

This has been broken more or less forever, AFAICT.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2b363e2..ff3f0b3 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -278,6 +278,17 @@ static int quota_getxquota(struct super_block *sb, int type, qid_t id,
 	return ret;
 }
 
+static int quota_rmxquota(struct super_block *sb, void __user *addr)
+{
+	__u32 flags;
+
+	if (copy_from_user(&flags, addr, sizeof(flags)))
+		return -EFAULT;
+	if (!sb->s_qcop->rm_xquota)
+		return -ENOSYS;
+	return sb->s_qcop->rm_xquota(sb, flags);
+}
+
 /* Copy parameters and call proper function */
 static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 		       void __user *addr, struct path *path)
@@ -316,8 +327,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 		return sb->s_qcop->quota_sync(sb, type);
 	case Q_XQUOTAON:
 	case Q_XQUOTAOFF:
-	case Q_XQUOTARM:
 		return quota_setxstate(sb, cmd, addr);
+	case Q_XQUOTARM:
+		return quota_rmxquota(sb, addr);
 	case Q_XGETQSTAT:
 		return quota_getxstate(sb, addr);
 	case Q_XGETQSTATV:
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index af33caf..2ad1b98 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -100,16 +100,36 @@ xfs_fs_set_xstate(
 		if (!XFS_IS_QUOTA_ON(mp))
 			return -EINVAL;
 		return -xfs_qm_scall_quotaoff(mp, flags);
-	case Q_XQUOTARM:
-		if (XFS_IS_QUOTA_ON(mp))
-			return -EINVAL;
-		return -xfs_qm_scall_trunc_qfiles(mp, flags);
 	}
 
 	return -EINVAL;
 }
 
 STATIC int
+xfs_fs_rm_xquota(
+	struct super_block	*sb,
+	unsigned int		uflags)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+	unsigned int		flags = 0;
+	
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	if (XFS_IS_QUOTA_ON(mp))
+		return -EINVAL;
+
+	if (uflags & FS_USER_QUOTA)
+		flags |= XFS_DQ_USER;
+	if (uflags & FS_GROUP_QUOTA)
+		flags |= XFS_DQ_GROUP;
+	if (uflags & FS_USER_QUOTA)
+		flags |= XFS_DQ_PROJ;
+
+	return -xfs_qm_scall_trunc_qfiles(mp, flags);
+}	
+
+STATIC int
 xfs_fs_get_dqblk(
 	struct super_block	*sb,
 	struct kqid		qid,
@@ -149,6 +169,7 @@ const struct quotactl_ops xfs_quotactl_operations = {
 	.get_xstatev		= xfs_fs_get_xstatev,
 	.get_xstate		= xfs_fs_get_xstate,
 	.set_xstate		= xfs_fs_set_xstate,
+	.rm_xquota		= xfs_fs_rm_xquota,
 	.get_dqblk		= xfs_fs_get_dqblk,
 	.set_dqblk		= xfs_fs_set_dqblk,
 };
diff --git a/include/linux/quota.h b/include/linux/quota.h
index cc7494a..0f3c5d3 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -329,6 +329,7 @@ struct quotactl_ops {
 	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
 	int (*set_xstate)(struct super_block *, unsigned int, int);
 	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
+	int (*rm_xquota)(struct super_block *, unsigned int);
 };
 
 struct quota_format_type {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
