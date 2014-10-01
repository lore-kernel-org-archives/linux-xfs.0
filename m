Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92B107F9F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:31:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D871AC011
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 12:31:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id PpvEHbpFvUHo88sd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 12:31:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/12] ext3: Convert to private i_dquot field
Date: Wed,  1 Oct 2014 21:31:29 +0200
Message-Id: <1412191894-9113-8-git-send-email-jack@suse.cz>
In-Reply-To: <1412191894-9113-1-git-send-email-jack@suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ext3.h  |  4 ++++
 fs/ext3/super.c | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index e85ff15a060e..04f30a1f96cb 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -613,6 +613,10 @@ struct ext3_inode_info {
 	atomic_t i_sync_tid;
 	atomic_t i_datasync_tid;
 
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 622e88249024..93373aaa9b77 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -485,6 +485,10 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	atomic_set(&ei->i_datasync_tid, 0);
 	atomic_set(&ei->i_sync_tid, 0);
+#ifdef CONFIG_QUOTA
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
+#endif
+
 	return &ei->vfs_inode;
 }
 
@@ -807,6 +811,13 @@ static const struct super_operations ext3_sops = {
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
+static const int ext3_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = (int)offsetof(struct ext3_inode_info, i_dquot) -
+		      (int)offsetof(struct ext3_inode_info, vfs_inode),
+#endif
+};
+
 static const struct export_operations ext3_export_ops = {
 	.fh_to_dentry = ext3_fh_to_dentry,
 	.fh_to_parent = ext3_fh_to_parent,
@@ -2008,7 +2019,9 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->s_qcop = &ext3_qctl_operations;
 	sb->dq_op = &ext3_quota_operations;
+	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
 #endif
+	sb_init_inode_fields(sb, ext3_inode_fields);
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
