Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 488CA7F5A
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:58:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B70BDAC00B
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:58:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FH0C28VCs8LltLFi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 03:58:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/12] quota: Allow each filesystem to specify which quota
	types it supports
Date: Tue,  4 Nov 2014 12:19:43 +0100
Message-Id: <1415099993-18034-3-git-send-email-jack@suse.cz>
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Currently all filesystems supporting VFS quota support user and group
quotas. With introduction of project quotas this is going to change so
make sure filesystem isn't called for quota type it doesn't support by
introduction of a bitmask determining which quota types each filesystem
supports.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 13 +++++++++++--
 fs/super.c            |  6 ++++++
 include/linux/fs.h    |  1 +
 include/linux/quota.h |  5 +++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 75621649dbd7..2aa4151f99d2 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -47,8 +47,11 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 
 static void quota_sync_one(struct super_block *sb, void *arg)
 {
-	if (sb->s_qcop && sb->s_qcop->quota_sync)
-		sb->s_qcop->quota_sync(sb, *(int *)arg);
+	int type = *(int *)arg;
+
+	if (sb->s_qcop && sb->s_qcop->quota_sync &&
+	    (sb->s_quota_types & (1 << type)))
+		sb->s_qcop->quota_sync(sb, type);
 }
 
 static int quota_sync_all(int type)
@@ -297,8 +300,14 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 
 	if (type >= (XQM_COMMAND(cmd) ? XQM_MAXQUOTAS : MAXQUOTAS))
 		return -EINVAL;
+	/*
+	 * Quota not supported on this fs? Check this before s_quota_types
+	 * since they needn't be set if quota is not supported at all.
+	 */
 	if (!sb->s_qcop)
 		return -ENOSYS;
+	if (!(sb->s_quota_types & (1 << type)))
+		return -EINVAL;
 
 	ret = check_quotactl_permission(sb, type, cmd, id);
 	if (ret < 0)
diff --git a/fs/super.c b/fs/super.c
index eae088f6aaae..4512281df8ff 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -218,6 +218,12 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
+	/*
+	 * For now MAXQUOTAS check in do_quotactl() will limit quota type
+	 * appropriately. When each fs sets allowed_types, we can remove the
+	 * line below
+	 */
+	s->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 	mutex_init(&s->s_dquot.dqio_mutex);
 	mutex_init(&s->s_dquot.dqonoff_mutex);
 	s->s_maxbytes = MAX_NON_LFS;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a957d4366c24..770b466f2b44 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1208,6 +1208,7 @@ struct super_block {
 	struct backing_dev_info *s_bdi;
 	struct mtd_info		*s_mtd;
 	struct hlist_node	s_instances;
+	unsigned int		s_quota_types;	/* Bitmask of supported quota types */
 	struct quota_info	s_dquot;	/* Diskquota specific options */
 
 	struct sb_writers	s_writers;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 80d345a3524c..50978b781a19 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -56,6 +56,11 @@ enum quota_type {
 	PRJQUOTA = 2,		/* element used for project quotas */
 };
 
+/* Masks for quota types when used as a bitmask */
+#define QTYPE_MASK_USR (1 << USRQUOTA)
+#define QTYPE_MASK_GRP (1 << GRPQUOTA)
+#define QTYPE_MASK_PRJ (1 << PRJQUOTA)
+
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef long long qsize_t;	/* Type in which we store sizes */
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
