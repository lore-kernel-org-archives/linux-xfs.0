Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B330C7CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 08:28:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43867AC003
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 06:28:13 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id iHVoZS3REWfuZLlc (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2016 06:28:07 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
Date: Thu,  4 Feb 2016 15:28:05 +0100
Message-Id: <1454596087-6814-2-git-send-email-jack@suse.cz>
In-Reply-To: <1454596087-6814-1-git-send-email-jack@suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
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
Cc: Mark Fasheh <mfasheh@suse.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Add infrastructure for supporting get_nextdqblk() callback for VFS
quotas. Translate the operation into a callback to appropriate
filesystem and consequently to quota format callback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c          |  1 +
 fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
 fs/reiserfs/super.c      |  1 +
 include/linux/quota.h    |  3 +++
 include/linux/quotaops.h |  3 +++
 5 files changed, 47 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f1b56ff01208..51649f442bf6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
 	.write_info	= ext4_write_info,
 	.alloc_dquot	= dquot_alloc,
 	.destroy_dquot	= dquot_destroy,
+	.get_next_id	= dquot_get_next_id,
 };
 
 static const struct quotactl_ops ext4_qctl_operations = {
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index fbd70af98820..f5c4967b62f1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2031,6 +2031,21 @@ int dquot_commit_info(struct super_block *sb, int type)
 }
 EXPORT_SYMBOL(dquot_commit_info);
 
+int dquot_get_next_id(struct super_block *sb, struct kqid *qid)
+{
+	struct quota_info *dqopt = sb_dqopt(sb);
+	int err;
+
+	if (!dqopt->ops[qid->type]->get_next_id)
+		return -ENOSYS;
+	mutex_lock(&dqopt->dqio_mutex);
+	err = dqopt->ops[qid->type]->get_next_id(sb, qid);
+	mutex_unlock(&dqopt->dqio_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL(dquot_get_next_id);
+
 /*
  * Definitions of diskquota operations.
  */
@@ -2042,6 +2057,7 @@ const struct dquot_operations dquot_operations = {
 	.write_info	= dquot_commit_info,
 	.alloc_dquot	= dquot_alloc,
 	.destroy_dquot	= dquot_destroy,
+	.get_next_id	= dquot_get_next_id,
 };
 EXPORT_SYMBOL(dquot_operations);
 
@@ -2565,6 +2581,27 @@ int dquot_get_dqblk(struct super_block *sb, struct kqid qid,
 }
 EXPORT_SYMBOL(dquot_get_dqblk);
 
+int dquot_get_next_dqblk(struct super_block *sb, struct kqid *qid,
+			 struct qc_dqblk *di)
+{
+	struct dquot *dquot;
+	int err;
+
+	if (!sb->dq_op->get_next_id)
+		return -ENOSYS;
+	err = sb->dq_op->get_next_id(sb, qid);
+	if (err < 0)
+		return err;
+	dquot = dqget(sb, *qid);
+	if (IS_ERR(dquot))
+		return PTR_ERR(dquot);
+	do_get_dqblk(dquot, di);
+	dqput(dquot);
+
+	return 0;
+}
+EXPORT_SYMBOL(dquot_get_next_dqblk);
+
 #define VFS_QC_MASK \
 	(QC_SPACE | QC_SPC_SOFT | QC_SPC_HARD | \
 	 QC_INO_COUNT | QC_INO_SOFT | QC_INO_HARD | \
@@ -2765,6 +2802,7 @@ const struct quotactl_ops dquot_quotactl_ops = {
 	.get_state	= dquot_get_state,
 	.set_info	= dquot_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
+	.get_nextdqblk	= dquot_get_next_dqblk,
 	.set_dqblk	= dquot_set_dqblk
 };
 EXPORT_SYMBOL(dquot_quotactl_ops);
@@ -2776,6 +2814,7 @@ const struct quotactl_ops dquot_quotactl_sysfile_ops = {
 	.get_state	= dquot_get_state,
 	.set_info	= dquot_set_dqinfo,
 	.get_dqblk	= dquot_get_dqblk,
+	.get_nextdqblk	= dquot_get_next_dqblk,
 	.set_dqblk	= dquot_set_dqblk
 };
 EXPORT_SYMBOL(dquot_quotactl_sysfile_ops);
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 05db7473bcb5..b62f495add62 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -802,6 +802,7 @@ static const struct dquot_operations reiserfs_quota_operations = {
 	.write_info = reiserfs_write_info,
 	.alloc_dquot	= dquot_alloc,
 	.destroy_dquot	= dquot_destroy,
+	.get_next_id	= dquot_get_next_id,
 };
 
 static const struct quotactl_ops reiserfs_qctl_operations = {
diff --git a/include/linux/quota.h b/include/linux/quota.h
index fba92f5c1a63..9dfb6bce8c9e 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -306,6 +306,7 @@ struct quota_format_ops {
 	int (*read_dqblk)(struct dquot *dquot);		/* Read structure for one user */
 	int (*commit_dqblk)(struct dquot *dquot);	/* Write structure for one user */
 	int (*release_dqblk)(struct dquot *dquot);	/* Called when last reference to dquot is being dropped */
+	int (*get_next_id)(struct super_block *sb, struct kqid *qid);	/* Get next ID with existing structure in the quota file */
 };
 
 /* Operations working with dquots */
@@ -321,6 +322,8 @@ struct dquot_operations {
 	 * quota code only */
 	qsize_t *(*get_reserved_space) (struct inode *);
 	int (*get_projid) (struct inode *, kprojid_t *);/* Get project ID */
+	/* Get next ID with active quota structure */
+	int (*get_next_id) (struct super_block *sb, struct kqid *qid);
 };
 
 struct path;
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 7a57c28eb5e7..f00fa86ac966 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -82,6 +82,7 @@ int dquot_commit(struct dquot *dquot);
 int dquot_acquire(struct dquot *dquot);
 int dquot_release(struct dquot *dquot);
 int dquot_commit_info(struct super_block *sb, int type);
+int dquot_get_next_id(struct super_block *sb, struct kqid *qid);
 int dquot_mark_dquot_dirty(struct dquot *dquot);
 
 int dquot_file_open(struct inode *inode, struct file *file);
@@ -99,6 +100,8 @@ int dquot_get_state(struct super_block *sb, struct qc_state *state);
 int dquot_set_dqinfo(struct super_block *sb, int type, struct qc_info *ii);
 int dquot_get_dqblk(struct super_block *sb, struct kqid id,
 		struct qc_dqblk *di);
+int dquot_get_next_dqblk(struct super_block *sb, struct kqid *id,
+		struct qc_dqblk *di);
 int dquot_set_dqblk(struct super_block *sb, struct kqid id,
 		struct qc_dqblk *di);
 
-- 
2.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
