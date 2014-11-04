Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E254C7F54
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:58:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63253AC00A
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:58:25 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id c5jyOknbwtwawUUh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 03:58:23 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 12/12] vfs: Remove i_dquot field from inode
Date: Tue,  4 Nov 2014 12:19:53 +0100
Message-Id: <1415099993-18034-13-git-send-email-jack@suse.cz>
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

All filesystems using VFS quotas are now converted to use their private
i_dquot fields. Remove the i_dquot field from generic inode structure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 3 ---
 fs/quota/dquot.c   | 3 ---
 fs/super.c         | 6 ------
 include/linux/fs.h | 3 ---
 4 files changed, 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 26753ba7b6d6..2ed95f7caa4f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -143,9 +143,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_blocks = 0;
 	inode->i_bytes = 0;
 	inode->i_generation = 0;
-#ifdef CONFIG_QUOTA
-	memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
-#endif
 	inode->i_pipe = NULL;
 	inode->i_bdev = NULL;
 	inode->i_cdev = NULL;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8144ff2b561d..5bc5f254ac1f 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -895,9 +895,6 @@ EXPORT_SYMBOL(dqget);
 
 static inline struct dquot **i_dquot(struct inode *inode)
 {
-	/* Temporary workaround until all filesystems are converted. */
-	if (!inode->i_sb->s_op->get_dquots)
-		return inode->i_dquot;
 	return inode->i_sb->s_op->get_dquots(inode);
 }
 
diff --git a/fs/super.c b/fs/super.c
index 4512281df8ff..eae088f6aaae 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -218,12 +218,6 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
-	/*
-	 * For now MAXQUOTAS check in do_quotactl() will limit quota type
-	 * appropriately. When each fs sets allowed_types, we can remove the
-	 * line below
-	 */
-	s->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 	mutex_init(&s->s_dquot.dqio_mutex);
 	mutex_init(&s->s_dquot.dqonoff_mutex);
 	s->s_maxbytes = MAX_NON_LFS;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 97b0fec13168..402425688e4a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -593,9 +593,6 @@ struct inode {
 	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
 	struct file_lock	*i_flock;
 	struct address_space	i_data;
-#ifdef CONFIG_QUOTA
-	struct dquot		*i_dquot[MAXQUOTAS];
-#endif
 	struct list_head	i_devices;
 	union {
 		struct pipe_inode_info	*i_pipe;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
