Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A61CD7F76
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 06:48:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6883B304048
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:48:11 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id tX3dT6gYcxGfHGQh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2015 04:48:07 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/17] quota: Make VFS quotas use new interface for getting
	quota info
Date: Fri, 16 Jan 2015 13:47:44 +0100
Message-Id: <1421412471-4747-11-git-send-email-jack@suse.cz>
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

Create new internal interface for getting information about quota which
contains everything needed for both VFS quotas and XFS quotas. Make VFS
use this and hook it up to Q_GETINFO.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c          |  2 +-
 fs/ext4/super.c          |  2 +-
 fs/quota/dquot.c         | 41 +++++++++++++++++++++++++++--------------
 fs/quota/quota.c         | 25 +++++++++++++++++++++----
 fs/reiserfs/super.c      |  2 +-
 include/linux/quota.h    | 33 ++++++++++++++++++++++++++++++++-
 include/linux/quotaops.h |  2 +-
 7 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9b4e7d750d4f..a7ae4c623be0 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -787,7 +787,7 @@ static const struct quotactl_ops ext3_qctl_operations = {
 	.quota_on	= ext3_quota_on,
 	.quota_off	= dquot_quota_off,
 	.quota_sync	= dquot_quota_sync,
-	.get_info	= dquot_get_dqinfo,
+	.get_state	= dquot_get_state,
 	.set_info	= dquot_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
 	.set_dqblk	= dquot_set_dqblk
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ac64edbe501d..c6e70831e135 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1076,7 +1076,7 @@ static const struct quotactl_ops ext4_qctl_operations = {
 	.quota_on	= ext4_quota_on,
 	.quota_off	= ext4_quota_off,
 	.quota_sync	= dquot_quota_sync,
-	.get_info	= dquot_get_dqinfo,
+	.get_state	= dquot_get_state,
 	.set_info	= dquot_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
 	.set_dqblk	= dquot_set_dqblk
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 02d571cb010a..57b9a62254d6 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2616,26 +2616,39 @@ out:
 EXPORT_SYMBOL(dquot_set_dqblk);
 
 /* Generic routine for getting common part of quota file information */
-int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
+int dquot_get_state(struct super_block *sb, struct qc_state *state)
 {
 	struct mem_dqinfo *mi;
+	struct qc_type_state *tstate;
+	struct quota_info *dqopt = sb_dqopt(sb);
+	int type;
   
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!sb_has_quota_active(sb, type)) {
-		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-		return -ESRCH;
+	memset(state, 0, sizeof(*state));
+	for (type = 0; type < MAXQUOTAS; type++) {
+		if (!sb_has_quota_active(sb, type))
+			continue;
+		tstate = state->s_state + type;
+		mi = sb_dqopt(sb)->info + type;
+		tstate->flags = QCI_ACCT_ENABLED;
+		spin_lock(&dq_data_lock);
+		if (mi->dqi_flags & DQF_SYS_FILE)
+			tstate->flags |= QCI_SYSFILE;
+		if (mi->dqi_flags & DQF_ROOT_SQUASH)
+			tstate->flags |= QCI_ROOT_SQUASH;
+		if (sb_has_quota_limits_enabled(sb, type));
+			tstate->flags |= QCI_LIMITS_ENFORCED;
+		tstate->spc_timelimit = mi->dqi_bgrace;
+		tstate->ino_timelimit = mi->dqi_igrace;
+		tstate->ino = dqopt->files[type]->i_ino;
+		tstate->blocks = dqopt->files[type]->i_blocks;
+		tstate->nextents = 1;	/* We don't know... */
+		spin_unlock(&dq_data_lock);
 	}
-	mi = sb_dqopt(sb)->info + type;
-	spin_lock(&dq_data_lock);
-	ii->dqi_bgrace = mi->dqi_bgrace;
-	ii->dqi_igrace = mi->dqi_igrace;
-	ii->dqi_flags = mi->dqi_flags & DQF_GETINFO_MASK;
-	ii->dqi_valid = IIF_ALL;
-	spin_unlock(&dq_data_lock);
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
-EXPORT_SYMBOL(dquot_get_dqinfo);
+EXPORT_SYMBOL(dquot_get_state);
 
 /* Generic routine for setting common part of quota file information */
 int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2679,7 +2692,7 @@ const struct quotactl_ops dquot_quotactl_ops = {
 	.quota_on	= dquot_quota_on,
 	.quota_off	= dquot_quota_off,
 	.quota_sync	= dquot_quota_sync,
-	.get_info	= dquot_get_dqinfo,
+	.get_state	= dquot_get_state,
 	.set_info	= dquot_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
 	.set_dqblk	= dquot_set_dqblk
@@ -2690,7 +2703,7 @@ const struct quotactl_ops dquot_quotactl_sysfile_ops = {
 	.quota_enable	= dquot_quota_enable,
 	.quota_disable	= dquot_quota_disable,
 	.quota_sync	= dquot_quota_sync,
-	.get_info	= dquot_get_dqinfo,
+	.get_state	= dquot_get_state,
 	.set_info	= dquot_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
 	.set_dqblk	= dquot_set_dqblk
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 5ec04321aace..f4ec476cc4c4 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -118,13 +118,30 @@ static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
 
 static int quota_getinfo(struct super_block *sb, int type, void __user *addr)
 {
-	struct if_dqinfo info;
+	struct qc_state state;
+	struct qc_type_state *tstate;
+	struct if_dqinfo uinfo;
 	int ret;
 
-	if (!sb->s_qcop->get_info)
+	/* This checks whether qc_state has enough entries... */
+	BUILD_BUG_ON(MAXQUOTAS > XQM_MAXQUOTAS);
+	if (!sb->s_qcop->get_state)
 		return -ENOSYS;
-	ret = sb->s_qcop->get_info(sb, type, &info);
-	if (!ret && copy_to_user(addr, &info, sizeof(info)))
+	ret = sb->s_qcop->get_state(sb, &state);
+	if (ret)
+		return ret;
+	tstate = state.s_state + type;
+	if (!(tstate->flags & QCI_ACCT_ENABLED))
+		return -ESRCH;
+	memset(&uinfo, 0, sizeof(uinfo));
+	uinfo.dqi_bgrace = tstate->spc_timelimit;
+	uinfo.dqi_igrace = tstate->ino_timelimit;
+	if (tstate->flags & QCI_SYSFILE)
+		uinfo.dqi_flags |= DQF_SYS_FILE;
+	if (tstate->flags & QCI_ROOT_SQUASH)
+		uinfo.dqi_flags |= DQF_ROOT_SQUASH;
+	uinfo.dqi_valid = IIF_ALL;
+	if (!ret && copy_to_user(addr, &uinfo, sizeof(uinfo)))
 		return -EFAULT;
 	return ret;
 }
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 71fbbe3e2dab..68b5f182984e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -805,7 +805,7 @@ static const struct quotactl_ops reiserfs_qctl_operations = {
 	.quota_on = reiserfs_quota_on,
 	.quota_off = dquot_quota_off,
 	.quota_sync = dquot_quota_sync,
-	.get_info = dquot_get_dqinfo,
+	.get_state = dquot_get_state,
 	.set_info = dquot_set_dqinfo,
 	.get_dqblk = dquot_get_dqblk,
 	.set_dqblk = dquot_set_dqblk,
diff --git a/include/linux/quota.h b/include/linux/quota.h
index d534e8ed308a..6ecac0f3b2ca 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -366,6 +366,37 @@ struct qc_dqblk {
 #define	QC_RT_SPACE	(1<<14)
 #define QC_ACCT_MASK (QC_SPACE | QC_INO_COUNT | QC_RT_SPACE)
 
+#define QCI_SYSFILE		(1 << 0)	/* Quota file is hidden from userspace */
+#define QCI_ROOT_SQUASH		(1 << 1)	/* Root squash turned on */
+#define QCI_ACCT_ENABLED	(1 << 2)	/* Quota accounting enabled */
+#define QCI_LIMITS_ENFORCED	(1 << 3)	/* Quota limits enforced */
+
+/* Structures for communicating via ->get_state */
+struct qc_type_state {
+	unsigned int flags;		/* Flags QCI_* */
+	unsigned int spc_timelimit;	/* Time after which space softlimit is
+					 * enforced */
+	unsigned int ino_timelimit;	/* Ditto for inode softlimit */
+	unsigned int rt_spc_timelimit;	/* Ditto for real-time space */
+	unsigned int spc_warnlimit;	/* Limit for number of space warnings */
+	unsigned int ino_warnlimit;	/* Ditto for inodes */
+	unsigned int rt_spc_warnlimit;	/* Ditto for real-time space */
+	unsigned long long ino;		/* Inode number of quota file */
+	blkcnt_t blocks;		/* Number of 512-byte blocks in the file */
+	blkcnt_t nextents;		/* Number of extents in the file */
+};
+
+struct qc_state {
+	unsigned int s_incoredqs;	/* Number of dquots in core */
+	/*
+	 * Per quota type information. The array should really have
+	 * max(MAXQUOTAS, XQM_MAXQUOTAS) entries. BUILD_BUG_ON in
+	 * quota_getinfo() makes sure XQM_MAXQUOTAS is large enough.  Once VFS
+	 * supports project quotas, this can be changed to MAXQUOTAS
+	 */
+	struct qc_type_state s_state[XQM_MAXQUOTAS];
+};
+
 /* Operations handling requests from userspace */
 struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
@@ -373,10 +404,10 @@ struct quotactl_ops {
 	int (*quota_enable)(struct super_block *, unsigned int);
 	int (*quota_disable)(struct super_block *, unsigned int);
 	int (*quota_sync)(struct super_block *, int);
-	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*get_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
+	int (*get_state)(struct super_block *, struct qc_state *);
 	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
 	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
 	int (*rm_xquota)(struct super_block *, unsigned int);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index e3fe6935f412..881517091c67 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -97,7 +97,7 @@ int dquot_quota_enable(struct super_block *sb, unsigned int flags);
 int dquot_quota_disable(struct super_block *sb, unsigned int flags);
 int dquot_writeback_dquots(struct super_block *sb, int type);
 int dquot_quota_sync(struct super_block *sb, int type);
-int dquot_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
+int dquot_get_state(struct super_block *sb, struct qc_state *state);
 int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 int dquot_get_dqblk(struct super_block *sb, struct kqid id,
 		struct qc_dqblk *di);
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
