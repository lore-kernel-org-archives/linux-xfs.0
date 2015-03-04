Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60DEB7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 09:15:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48DB38F8054
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 07:15:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4DY5YCpsRp8jhsRg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 07:15:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/8] quota: Make ->set_info use structure with neccesary info
	to VFS and XFS
Date: Wed,  4 Mar 2015 16:15:11 +0100
Message-Id: <1425482113-1977-7-git-send-email-jack@suse.cz>
In-Reply-To: <1425482113-1977-1-git-send-email-jack@suse.cz>
References: <1425482113-1977-1-git-send-email-jack@suse.cz>
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
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Change ->set_info to take new qc_info structure which contains all the
necessary information both for XFS and VFS. Convert Q_SETINFO handler
to use this structure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 27 ++++++++++++++++-----------
 fs/quota/quota.c         | 21 ++++++++++++++++++++-
 include/linux/quota.h    | 21 +++++++++++++++++++--
 include/linux/quotaops.h |  2 +-
 4 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index cf4edd87e854..f37b74eab807 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2649,33 +2649,38 @@ int dquot_get_state(struct super_block *sb, struct qc_state *state)
 EXPORT_SYMBOL(dquot_get_state);
 
 /* Generic routine for setting common part of quota file information */
-int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
+int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii)
 {
 	struct mem_dqinfo *mi;
 	int err = 0;
 
+	if ((ii->i_fieldmask & QC_WARNS_MASK) ||
+	    (ii->i_fieldmask & QC_RT_SPC_TIMER))
+		return -EINVAL;
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (!sb_has_quota_active(sb, type)) {
 		err = -ESRCH;
 		goto out;
 	}
 	mi = sb_dqopt(sb)->info + type;
-	if (ii->dqi_valid & IIF_FLAGS) {
-		if (ii->dqi_flags & ~DQF_SETINFO_MASK ||
-		    (ii->dqi_flags & DQF_ROOT_SQUASH &&
+	if (ii->i_fieldmask & QC_FLAGS) {
+		if ((ii->i_flags & QCI_ROOT_SQUASH &&
 		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD)) {
 			err = -EINVAL;
 			goto out;
 		}
 	}
 	spin_lock(&dq_data_lock);
-	if (ii->dqi_valid & IIF_BGRACE)
-		mi->dqi_bgrace = ii->dqi_bgrace;
-	if (ii->dqi_valid & IIF_IGRACE)
-		mi->dqi_igrace = ii->dqi_igrace;
-	if (ii->dqi_valid & IIF_FLAGS)
-		mi->dqi_flags = (mi->dqi_flags & ~DQF_SETINFO_MASK) |
-				(ii->dqi_flags & DQF_SETINFO_MASK);
+	if (ii->i_fieldmask & QC_SPC_TIMER)
+		mi->dqi_bgrace = ii->i_spc_timelimit;
+	if (ii->i_fieldmask & QC_INO_TIMER)
+		mi->dqi_igrace = ii->i_ino_timelimit;
+	if (ii->i_fieldmask & QC_FLAGS) {
+		if (ii->i_flags & QCI_ROOT_SQUASH)
+			mi->dqi_flags |= DQF_ROOT_SQUASH;
+		else
+			mi->dqi_flags &= ~DQF_ROOT_SQUASH;
+	}
 	spin_unlock(&dq_data_lock);
 	mark_info_dirty(sb, type);
 	/* Force write to disk */
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 20d11cd21247..741d5a178268 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -149,12 +149,31 @@ static int quota_getinfo(struct super_block *sb, int type, void __user *addr)
 static int quota_setinfo(struct super_block *sb, int type, void __user *addr)
 {
 	struct if_dqinfo info;
+	struct qc_info qinfo;
 
 	if (copy_from_user(&info, addr, sizeof(info)))
 		return -EFAULT;
 	if (!sb->s_qcop->set_info)
 		return -ENOSYS;
-	return sb->s_qcop->set_info(sb, type, &info);
+	if (info.dqi_valid & ~(IIF_FLAGS | IIF_BGRACE | IIF_IGRACE))
+		return -EINVAL;
+	memset(&qinfo, 0, sizeof(qinfo));
+	if (info.dqi_valid & IIF_FLAGS) {
+		if (info.dqi_flags & ~DQF_SETINFO_MASK)
+			return -EINVAL;
+		if (info.dqi_flags & DQF_ROOT_SQUASH)
+			qinfo.i_flags |= QCI_ROOT_SQUASH;
+		qinfo.i_fieldmask |= QC_FLAGS;
+	}
+	if (info.dqi_valid & IIF_BGRACE) {
+		qinfo.i_spc_timelimit = info.dqi_bgrace;
+		qinfo.i_fieldmask |= QC_SPC_TIMER;
+	}
+	if (info.dqi_valid & IIF_IGRACE) {
+		qinfo.i_ino_timelimit = info.dqi_igrace;
+		qinfo.i_fieldmask |= QC_INO_TIMER;
+	}
+	return sb->s_qcop->set_info(sb, type, &qinfo);
 }
 
 static inline qsize_t qbtos(qsize_t blocks)
diff --git a/include/linux/quota.h b/include/linux/quota.h
index a07f2ed25284..3d521199a0bd 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -344,7 +344,10 @@ struct qc_dqblk {
 	int d_rt_spc_warns;	/* # warnings issued wrt RT space */
 };
 
-/* Field specifiers for ->set_dqblk() in struct qc_dqblk */
+/*
+ * Field specifiers for ->set_dqblk() in struct qc_dqblk and also for
+ * ->set_info() in struct qc_info
+ */
 #define	QC_INO_SOFT	(1<<0)
 #define	QC_INO_HARD	(1<<1)
 #define	QC_SPC_SOFT	(1<<2)
@@ -365,6 +368,7 @@ struct qc_dqblk {
 #define	QC_INO_COUNT	(1<<13)
 #define	QC_RT_SPACE	(1<<14)
 #define QC_ACCT_MASK (QC_SPACE | QC_INO_COUNT | QC_RT_SPACE)
+#define QC_FLAGS	(1<<15)
 
 #define QCI_SYSFILE		(1 << 0)	/* Quota file is hidden from userspace */
 #define QCI_ROOT_SQUASH		(1 << 1)	/* Root squash turned on */
@@ -397,6 +401,19 @@ struct qc_state {
 	struct qc_type_state s_state[XQM_MAXQUOTAS];
 };
 
+/* Structure for communicating via ->set_info */
+struct qc_info {
+	int i_fieldmask;	/* mask of fields to change in ->set_info() */
+	unsigned int i_flags;		/* Flags QCI_* */
+	unsigned int i_spc_timelimit;	/* Time after which space softlimit is
+					 * enforced */
+	unsigned int i_ino_timelimit;	/* Ditto for inode softlimit */
+	unsigned int i_rt_spc_timelimit;/* Ditto for real-time space */
+	unsigned int i_spc_warnlimit;	/* Limit for number of space warnings */
+	unsigned int i_ino_warnlimit;	/* Limit for number of inode warnings */
+	unsigned int i_rt_spc_warnlimit;	/* Ditto for real-time space */
+};
+
 /* Operations handling requests from userspace */
 struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, struct path *);
@@ -404,7 +421,7 @@ struct quotactl_ops {
 	int (*quota_enable)(struct super_block *, unsigned int);
 	int (*quota_disable)(struct super_block *, unsigned int);
 	int (*quota_sync)(struct super_block *, int);
-	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
+	int (*set_info)(struct super_block *, int, struct qc_info *);
 	int (*get_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*get_state)(struct super_block *, struct qc_state *);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 6509a29523e2..9f4b07ba9e8c 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -96,7 +96,7 @@ int dquot_quota_off(struct super_block *sb, int type);
 int dquot_writeback_dquots(struct super_block *sb, int type);
 int dquot_quota_sync(struct super_block *sb, int type);
 int dquot_get_state(struct super_block *sb, struct qc_state *state);
-int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
+int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii);
 int dquot_get_dqblk(struct super_block *sb, struct kqid id,
 		struct qc_dqblk *di);
 int dquot_set_dqblk(struct super_block *sb, struct kqid id,
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
