Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 661437F50
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 06:48:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 545668F8050
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:48:07 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id h3ujiExeHIGQMJQi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2015 04:48:02 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/17] quota: Add ->quota_{enable,
	disable} callbacks for VFS quotas
Date: Fri, 16 Jan 2015 13:47:37 +0100
Message-Id: <1421412471-4747-4-git-send-email-jack@suse.cz>
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

Add functions which translate ->quota_enable / ->quota_disable calls
into appropriate changes in VFS quota. This will enable filesystems
supporting VFS quota files in system inodes to be controlled via
Q_XQUOTA[ON|OFF] quotactls for better userspace compatibility.

Also provide a vector for quotactl using these functions which can be
used by filesystems with quota files stored in hidden system files.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 93 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/quotaops.h |  3 ++
 2 files changed, 96 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index d25c3243c196..e8300d927eb7 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2385,6 +2385,88 @@ out:
 }
 EXPORT_SYMBOL(dquot_quota_on_mount);
 
+int dquot_quota_enable(struct super_block *sb, unsigned int flags)
+{
+	int ret;
+	int type;
+	struct quota_info *dqopt = sb_dqopt(sb);
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE))
+		return -ENOSYS;
+	/* Accounting cannot be turned on while fs is mounted */
+	flags &= ~(FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT | FS_QUOTA_PDQ_ACCT);
+	if (!flags)
+		return -EINVAL;
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (!(flags & qtype_limit_flag(type)))
+			continue;
+		/* Can't enforce without accounting */
+		if (!sb_has_quota_usage_enabled(sb, type))
+			return -EINVAL;
+		ret = dquot_enable(dqopt->files[type], type,
+				   dqopt->info[type].dqi_fmt_id,
+				   DQUOT_LIMITS_ENABLED);
+		if (ret < 0)
+			goto out_err;
+	}
+	return 0;
+out_err:
+	/* Backout enforcement enablement we already did */
+	for (type--; type >= 0; type--)  {
+		if (flags & qtype_limit_flag(type))
+			dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
+	}
+	/* Error code translation for better compatibility with XFS */
+	if (ret == -EBUSY)
+		ret = -EEXIST;
+	return ret;
+}
+EXPORT_SYMBOL(dquot_quota_enable);
+
+int dquot_quota_disable(struct super_block *sb, unsigned int flags)
+{
+	int ret;
+	int type;
+	struct quota_info *dqopt = sb_dqopt(sb);
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE))
+		return -ENOSYS;
+	/*
+	 * We don't support turning off accounting via quotactl. In principle
+	 * quota infrastructure can do this but filesystems don't expect
+	 * userspace to be able to do it.
+	 */
+	if (flags &
+		  (FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT | FS_QUOTA_PDQ_ACCT))
+		return -EOPNOTSUPP;
+
+	/* Filter out limits not enabled */
+	for (type = 0; type < MAXQUOTAS; type++)
+		if (!sb_has_quota_limits_enabled(sb, type))
+			flags &= ~qtype_limit_flag(type);
+	/* Nothing left? */
+	if (!flags)
+		return -EEXIST;
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (flags & qtype_limit_flag(type)) {
+			ret = dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
+			if (ret < 0)
+				goto out_err;
+		}
+	}
+	return 0;
+out_err:
+	/* Backout enforcement disabling we already did */
+	for (type--; type >= 0; type--)  {
+		if (flags & qtype_limit_flag(type))
+			dquot_enable(dqopt->files[type], type,
+				     dqopt->info[type].dqi_fmt_id,
+				     DQUOT_LIMITS_ENABLED);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(dquot_quota_disable);
+
 static inline qsize_t qbtos(qsize_t blocks)
 {
 	return blocks << QIF_DQBLKSIZE_BITS;
@@ -2619,6 +2701,17 @@ const struct quotactl_ops dquot_quotactl_ops = {
 };
 EXPORT_SYMBOL(dquot_quotactl_ops);
 
+const struct quotactl_ops dquot_quotactl_sysfile_ops = {
+	.quota_enable	= dquot_quota_enable,
+	.quota_disable	= dquot_quota_disable,
+	.quota_sync	= dquot_quota_sync,
+	.get_info	= dquot_get_dqinfo,
+	.set_info	= dquot_set_dqinfo,
+	.get_dqblk	= dquot_get_dqblk,
+	.set_dqblk	= dquot_set_dqblk
+};
+EXPORT_SYMBOL(dquot_quotactl_sysfile_ops);
+
 static int do_proc_dqstats(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 20b77d115551..5dd75e16b2c1 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -93,6 +93,8 @@ int dquot_quota_on(struct super_block *sb, int type, int format_id,
 int dquot_quota_on_mount(struct super_block *sb, char *qf_name,
  	int format_id, int type);
 int dquot_quota_off(struct super_block *sb, int type);
+int dquot_quota_enable(struct super_block *sb, unsigned int flags);
+int dquot_quota_disable(struct super_block *sb, unsigned int flags);
 int dquot_writeback_dquots(struct super_block *sb, int type);
 int dquot_quota_sync(struct super_block *sb, int type);
 int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
@@ -166,6 +168,7 @@ static inline bool sb_has_quota_active(struct super_block *sb, int type)
  */
 extern const struct dquot_operations dquot_operations;
 extern const struct quotactl_ops dquot_quotactl_ops;
+extern const struct quotactl_ops dquot_quotactl_sysfile_ops;
 
 #else
 
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
