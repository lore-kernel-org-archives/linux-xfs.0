Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0136A7F6B
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4854304039
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:47 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3CAlN077bpC6DB82 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:46 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/11] quota: Add ->sysquota_{on, off} callbacks for VFS quotas
Date: Tue, 11 Nov 2014 22:04:20 +0100
Message-Id: <1415739865-2438-7-git-send-email-jack@suse.cz>
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

Add functions which translate ->sysquota_on / ->sysquota_off calls into
appropriate changes in VFS quota. This will enable filesystems
supporting VFS quota files in system inodes to be controlled via
Q_XQUOTA[ON|OFF] quotactls for better userspace compatibility.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 82 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/quotaops.h |  2 ++
 2 files changed, 84 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 6b4527216a7f..b7359c9da61e 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2380,6 +2380,88 @@ out:
 }
 EXPORT_SYMBOL(dquot_quota_on_mount);
 
+int dquot_sysquota_on(struct super_block *sb, unsigned int flags)
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
+EXPORT_SYMBOL(dquot_sysquota_on);
+
+int dquot_sysquota_off(struct super_block *sb, unsigned int flags)
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
+EXPORT_SYMBOL(dquot_sysquota_off);
+
 static inline qsize_t qbtos(qsize_t blocks)
 {
 	return blocks << QIF_DQBLKSIZE_BITS;
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 5947a9e54862..6f5dc7e397a7 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -93,6 +93,8 @@ int dquot_quota_on(struct super_block *sb, int type, int format_id,
 int dquot_quota_on_mount(struct super_block *sb, char *qf_name,
  	int format_id, int type);
 int dquot_quota_off(struct super_block *sb, int type);
+int dquot_sysquota_on(struct super_block *sb, unsigned int flags);
+int dquot_sysquota_off(struct super_block *sb, unsigned int flags);
 int dquot_writeback_dquots(struct super_block *sb, int type);
 int dquot_quota_sync(struct super_block *sb, int type);
 int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
