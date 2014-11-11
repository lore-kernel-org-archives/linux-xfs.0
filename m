Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5C807F74
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36867AC009
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:48 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Rzi6FfEUm1RGshef (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:46 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/11] quota: Split ->set_xstate callback into two
Date: Tue, 11 Nov 2014 22:04:18 +0100
Message-Id: <1415739865-2438-5-git-send-email-jack@suse.cz>
In-Reply-To: <1415739865-2438-1-git-send-email-jack@suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Split ->set_xstate callback into two callbacks - one for turning quotas
on (->sysquota_on) and one for turning quotas off (->sysquota_off). That
way we don't have to pass quotactl command into the callback which seems
cleaner.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 20 ++++++++++++++----
 fs/xfs/xfs_quotaops.c | 58 ++++++++++++++++++++++++++++++++-------------------
 include/linux/quota.h |  3 ++-
 3 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 75621649dbd7..fb22cebff946 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -195,15 +195,26 @@ static int quota_setquota(struct super_block *sb, int type, qid_t id,
 	return sb->s_qcop->set_dqblk(sb, qid, &fdq);
 }
 
-static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
+static int quota_sysquota_on(struct super_block *sb, void __user *addr)
 {
 	__u32 flags;
 
 	if (copy_from_user(&flags, addr, sizeof(flags)))
 		return -EFAULT;
-	if (!sb->s_qcop->set_xstate)
+	if (!sb->s_qcop->sysquota_on)
 		return -ENOSYS;
-	return sb->s_qcop->set_xstate(sb, flags, cmd);
+	return sb->s_qcop->sysquota_on(sb, flags);
+}
+
+static int quota_sysquota_off(struct super_block *sb, void __user *addr)
+{
+	__u32 flags;
+
+	if (copy_from_user(&flags, addr, sizeof(flags)))
+		return -EFAULT;
+	if (!sb->s_qcop->sysquota_off)
+		return -ENOSYS;
+	return sb->s_qcop->sysquota_off(sb, flags);
 }
 
 static int quota_getxstate(struct super_block *sb, void __user *addr)
@@ -326,8 +337,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 			return -ENOSYS;
 		return sb->s_qcop->quota_sync(sb, type);
 	case Q_XQUOTAON:
+		return quota_sysquota_on(sb, addr);
 	case Q_XQUOTAOFF:
-		return quota_setxstate(sb, cmd, addr);
+		return quota_sysquota_off(sb, addr);
 	case Q_XQUOTARM:
 		return quota_rmxquota(sb, addr);
 	case Q_XGETQSTAT:
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 9ad73240ed54..a3836ac0f2f8 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -66,19 +66,9 @@ xfs_fs_get_xstatev(
 	return xfs_qm_scall_getqstatv(mp, fqs);
 }
 
-STATIC int
-xfs_fs_set_xstate(
-	struct super_block	*sb,
-	unsigned int		uflags,
-	int			op)
+static unsigned int generic_to_xfs_flags(unsigned int uflags)
 {
-	struct xfs_mount	*mp = XFS_M(sb);
-	unsigned int		flags = 0;
-
-	if (sb->s_flags & MS_RDONLY)
-		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
+	unsigned int flags = 0;
 
 	if (uflags & FS_QUOTA_UDQ_ACCT)
 		flags |= XFS_UQUOTA_ACCT;
@@ -93,16 +83,39 @@ xfs_fs_set_xstate(
 	if (uflags & FS_QUOTA_PDQ_ENFD)
 		flags |= XFS_PQUOTA_ENFD;
 
-	switch (op) {
-	case Q_XQUOTAON:
-		return xfs_qm_scall_quotaon(mp, flags);
-	case Q_XQUOTAOFF:
-		if (!XFS_IS_QUOTA_ON(mp))
-			return -EINVAL;
-		return xfs_qm_scall_quotaoff(mp, flags);
-	}
+	return flags;
+}
+
+STATIC int
+xfs_sysquota_on(
+	struct super_block	*sb,
+	unsigned int		uflags)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+
+	return xfs_qm_scall_quotaon(mp, generic_to_xfs_flags(uflags));
+}
+
+STATIC int
+xfs_sysquota_off(
+	struct super_block	*sb,
+	unsigned int		uflags)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -EINVAL;
 
-	return -EINVAL;
+	return xfs_qm_scall_quotaoff(mp, generic_to_xfs_flags(uflags));
 }
 
 STATIC int
@@ -168,7 +181,8 @@ xfs_fs_set_dqblk(
 const struct quotactl_ops xfs_quotactl_operations = {
 	.get_xstatev		= xfs_fs_get_xstatev,
 	.get_xstate		= xfs_fs_get_xstate,
-	.set_xstate		= xfs_fs_set_xstate,
+	.sysquota_on		= xfs_sysquota_on,
+	.sysquota_off		= xfs_sysquota_off,
 	.rm_xquota		= xfs_fs_rm_xquota,
 	.get_dqblk		= xfs_fs_get_dqblk,
 	.set_dqblk		= xfs_fs_set_dqblk,
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 80d345a3524c..3a046676e4aa 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -326,8 +326,9 @@ struct quotactl_ops {
 	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*get_dqblk)(struct super_block *, struct kqid, struct fs_disk_quota *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct fs_disk_quota *);
+	int (*sysquota_on)(struct super_block *, unsigned int);
+	int (*sysquota_off)(struct super_block *, unsigned int);
 	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
-	int (*set_xstate)(struct super_block *, unsigned int, int);
 	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
 	int (*rm_xquota)(struct super_block *, unsigned int);
 };
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
