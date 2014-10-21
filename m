Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 909EC7F60
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:38:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F3A8AC009
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 07:38:56 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id nUD87niCbZWWBXFL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 07:38:54 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/12] ext2: Convert to private i_dquot field
Date: Tue, 21 Oct 2014 16:38:30 +0200
Message-Id: <1413902316-17997-7-git-send-email-jack@suse.cz>
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
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

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  |  3 +++
 fs/ext2/super.c | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index d9a17d0b124d..e4279ead4a05 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -689,6 +689,9 @@ struct ext2_inode_info {
 	struct mutex truncate_mutex;
 	struct inode	vfs_inode;
 	struct list_head i_orphan;	/* unlinked but open inodes */
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
 };
 
 /*
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 170dc41e8bf4..ef2a6cce75d8 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -166,6 +166,10 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 		return NULL;
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+#ifdef CONFIG_QUOTA
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
+#endif
+
 	return &ei->vfs_inode;
 }
 
@@ -303,6 +307,10 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
 #ifdef CONFIG_QUOTA
 static ssize_t ext2_quota_read(struct super_block *sb, int type, char *data, size_t len, loff_t off);
 static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *data, size_t len, loff_t off);
+static struct dquot **ext2_get_dquots(struct inode *inode)
+{
+	return EXT2_I(inode)->i_dquot;
+}
 #endif
 
 static const struct super_operations ext2_sops = {
@@ -320,6 +328,7 @@ static const struct super_operations ext2_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext2_quota_read,
 	.quota_write	= ext2_quota_write,
+	.get_dquots	= ext2_get_dquots,
 #endif
 };
 
@@ -1090,6 +1099,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
 	sb->s_qcop = &dquot_quotactl_ops;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 
 	root = ext2_iget(sb, EXT2_ROOT_INO);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
