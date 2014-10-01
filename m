Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 896007F83
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:31:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 579E030406A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 12:31:45 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id l3rMMSeKXBcZUAgN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 12:31:43 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/12] ext2: Convert to private i_dquot field
Date: Wed,  1 Oct 2014 21:31:28 +0200
Message-Id: <1412191894-9113-7-git-send-email-jack@suse.cz>
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
 fs/ext2/ext2.h  |  3 +++
 fs/ext2/super.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

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
index b88edc05c230..f43b2f28b9bc 100644
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
 
@@ -323,6 +327,13 @@ static const struct super_operations ext2_sops = {
 #endif
 };
 
+static const int ext2_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = offsetof(struct ext2_inode_info, i_dquot) -
+		      offsetof(struct ext2_inode_info, vfs_inode),
+#endif
+};
+
 static struct inode *ext2_nfs_get_inode(struct super_block *sb,
 		u64 ino, u32 generation)
 {
@@ -1090,7 +1101,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
 	sb->s_qcop = &dquot_quotactl_ops;
+	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
 #endif
+	sb_init_inode_fields(sb, ext2_inode_fields);
 
 	root = ext2_iget(sb, EXT2_ROOT_INO);
 	if (IS_ERR(root)) {
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
