Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DAD6802B
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 08:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0C87AC002
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 06:34:46 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dBT3tSbKKkZHDane (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 06:34:45 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 15/16] xfs: Add support for Q_SETINFO
Date: Mon, 26 Jan 2015 15:34:32 +0100
Message-Id: <1422282873-3381-16-git-send-email-jack@suse.cz>
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
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
 fs/xfs/xfs_quotaops.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index df9835396c4f..bbe8ddf1f700 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -111,6 +111,42 @@ xfs_quota_type(int type)
 	}
 }
 
+#define XFS_QC_SETINFO_MASK (QC_TIMER_MASK | QC_WARNS_MASK)
+
+/*
+ * Adjust quota timers & warnings
+ */
+static int
+xfs_fs_set_info(
+	struct super_block *sb,
+	int type,
+	struct qc_info *info)
+{
+	struct xfs_mount *mp = XFS_M(sb);
+	struct qc_dqblk newlim;
+
+	if (sb->s_flags & MS_RDONLY)
+		return -EROFS;
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
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
+	return xfs_qm_scall_setqlim(mp, 0, xfs_quota_type(type), &newlim);
+}
+
 static unsigned int
 xfs_quota_flags(unsigned int uflags)
 {
@@ -226,6 +262,7 @@ xfs_fs_set_dqblk(
 
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
