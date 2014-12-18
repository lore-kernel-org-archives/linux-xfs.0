Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D3A07F60
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:37:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D183D304084
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:37:57 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CzA84dA1FlbrvelM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:37:56 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/25] quota: Split ->set_xstate callback into two
Date: Thu, 18 Dec 2014 16:37:18 +0100
Message-Id: <1418917059-23870-5-git-send-email-jack@suse.cz>
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
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
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Split ->set_xstate callback into two callbacks - one for turning quotas
on (->quota_enable) and one for turning quotas off (->quota_disable). That
way we don't have to pass quotactl command into the callback which seems
cleaner.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 20 ++++++++++++++----
 fs/xfs/xfs_quotaops.c | 58 ++++++++++++++++++++++++++++++++-------------------
 include/linux/quota.h |  3 ++-
 3 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2aa4151f99d2..5b307e2b5719 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -198,15 +198,26 @@ static int quota_setquota(struct super_block *sb, int type, qid_t id,
 	return sb->s_qcop->set_dqblk(sb, qid, &fdq);
 }
 
-static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
+static int quota_enable(struct super_block *sb, void __user *addr)
 {
 	__u32 flags;
 
 	if (copy_from_user(&flags, addr, sizeof(flags)))
 		return -EFAULT;
-	if (!sb->s_qcop->set_xstate)
+	if (!sb->s_qcop->quota_enable)
 		return -ENOSYS;
-	return sb->s_qcop->set_xstate(sb, flags, cmd);
+	return sb->s_qcop->quota_enable(sb, flags);
+}
+
+static int quota_disable(struct super_block *sb, void __user *addr)
+{
+	__u32 flags;
+
+	if (copy_from_user(&flags, addr, sizeof(flags)))
+		return -EFAULT;
+	if (!sb->s_qcop->quota_disable)
+		return -ENOSYS;
+	return sb->s_qcop->quota_disable(sb, flags);
 }
 
 static int quota_getxstate(struct super_block *sb, void __user *addr)
@@ -335,8 +346,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 			return -ENOSYS;
 		return sb->s_qcop->quota_sync(sb, type);
 	case Q_XQUOTAON:
+		return quota_enable(sb, addr);
 	case Q_XQUOTAOFF:
-		return quota_setxstate(sb, cmd, addr);
+		return quota_disable(sb, addr);
 	case Q_XQUOTARM:
 		return quota_rmxquota(sb, addr);
 	case Q_XGETQSTAT:
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 8fcd20dbf89a..a46bb8094307 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -64,19 +64,9 @@ xfs_fs_get_xstatev(
 	return xfs_qm_scall_getqstatv(mp, fqs);
 }
 
-STATIC int
-xfs_fs_set_xstate(
-	struct super_block	*sb,
-	unsigned int		uflags,
-	int			op)
+static unsigned int xfs_quota_flags(unsigned int uflags)
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
@@ -91,16 +81,39 @@ xfs_fs_set_xstate(
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
+xfs_quota_enable(
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
+	return xfs_qm_scall_quotaon(mp, xfs_quota_flags(uflags));
+}
+
+STATIC int
+xfs_quota_disable(
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
+	return xfs_qm_scall_quotaoff(mp, xfs_quota_flags(uflags));
 }
 
 STATIC int
@@ -166,7 +179,8 @@ xfs_fs_set_dqblk(
 const struct quotactl_ops xfs_quotactl_operations = {
 	.get_xstatev		= xfs_fs_get_xstatev,
 	.get_xstate		= xfs_fs_get_xstate,
-	.set_xstate		= xfs_fs_set_xstate,
+	.quota_enable		= xfs_quota_enable,
+	.quota_disable		= xfs_quota_disable,
 	.rm_xquota		= xfs_fs_rm_xquota,
 	.get_dqblk		= xfs_fs_get_dqblk,
 	.set_dqblk		= xfs_fs_set_dqblk,
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 50978b781a19..5eaea03665b4 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -326,13 +326,14 @@ struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
 	int (*quota_on_meta)(struct super_block *, int, int);
 	int (*quota_off)(struct super_block *, int);
+	int (*quota_enable)(struct super_block *, unsigned int);
+	int (*quota_disable)(struct super_block *, unsigned int);
 	int (*quota_sync)(struct super_block *, int);
 	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*get_dqblk)(struct super_block *, struct kqid, struct fs_disk_quota *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct fs_disk_quota *);
 	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
-	int (*set_xstate)(struct super_block *, unsigned int, int);
 	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
 	int (*rm_xquota)(struct super_block *, unsigned int);
 };
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
