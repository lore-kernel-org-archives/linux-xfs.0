Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95C637F75
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 06:48:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A6B98F8052
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:48:11 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id p2CaAV0rw8v1WZkL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2015 04:48:08 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 16/17] xfs: Add support for Q_SETINFO
Date: Fri, 16 Jan 2015 13:47:50 +0100
Message-Id: <1421412471-4747-17-git-send-email-jack@suse.cz>
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
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

Add support to XFS so that time limits can be set through Q_SETINFO
quotactl.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm.h          |  2 ++
 fs/xfs/xfs_qm_syscalls.c | 25 +++++++++++++++++++++++++
 fs/xfs/xfs_quotaops.c    | 16 ++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index d308e9610548..c1a9761d37db 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -170,6 +170,8 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct qc_dqblk *);
 extern int		xfs_qm_scall_getstate(struct xfs_mount *,
 					struct qc_state *);
+extern int		xfs_qm_scall_setinfo(struct xfs_mount *, uint,
+					struct qc_info *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5ccafb4c7e79..9ede1ffec8d8 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -451,6 +451,31 @@ int xfs_qm_scall_getstate(struct xfs_mount *mp, struct qc_state *state)
 	return 0;
 }
 
+#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK | QC_WARNS_MASK)
+
+/*
+ * Adjust quota timers & warnings
+ */
+int xfs_qm_scall_setinfo(struct xfs_mount *mp, uint type, struct qc_info *info)
+{
+	struct qc_dqblk newlim;
+
+	if (info->i_fieldmask & ~XFS_QC_SETINFO_MASK)
+		return -EINVAL;
+	if ((info->i_fieldmask & XFS_QC_SETINFO_MASK) == 0)
+		return 0;
+
+	newlim.d_fieldmask = info->i_fieldmask;
+	newlim.d_spc_timer = info->i_spc_timelimit;
+	newlim.d_ino_timer = info->i_ino_timelimit;
+	newlim.d_rt_spc_timer = info->i_rt_spc_timelimit;
+	newlim.d_ino_warns = info->i_ino_warnlimit;
+	newlim.d_spc_warns = info->i_spc_warnlimit;
+	newlim.d_rt_spc_warns = info->i_rt_spc_warnlimit;
+
+	return xfs_qm_scall_setqlim(mp, 0, type, &newlim);
+}
+
 #define XFS_QC_MASK \
 	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 698e6faac519..a25f482955a7 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -45,6 +45,21 @@ static int xfs_fs_get_quota_state(struct super_block *sb, struct qc_state *s)
 	return xfs_qm_scall_getstate(XFS_M(sb), s);
 }
 
+static int xfs_fs_set_info(struct super_block *sb, int type,
+			   struct qc_info *info)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
+
+	return xfs_qm_scall_setinfo(mp, xfs_quota_type(type), info);
+}
+
 static unsigned int xfs_quota_flags(unsigned int uflags)
 {
 	unsigned int flags = 0;
@@ -159,6 +174,7 @@ xfs_fs_set_dqblk(
 
 const struct quotactl_ops xfs_quotactl_operations = {
 	.get_state		= xfs_fs_get_quota_state,
+	.set_info		= xfs_fs_set_info,
 	.quota_enable		= xfs_quota_enable,
 	.quota_disable		= xfs_quota_disable,
 	.rm_xquota		= xfs_fs_rm_xquota,
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
