Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B36C47FAE
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:55:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4237BAC012
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:55:22 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UvnshglIu9RjLfDm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:55:20 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 12/12] vfs: Remove i_dquot field from inode
Date: Fri, 10 Oct 2014 16:55:10 +0200
Message-Id: <1412952910-7142-13-git-send-email-jack@suse.cz>
In-Reply-To: <1412952910-7142-1-git-send-email-jack@suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

All filesystems using VFS quotas are now converted to use their private
i_dquot fields. Remove the i_dquot field from generic inode structure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         |  3 ---
 fs/super.c         | 10 ----------
 include/linux/fs.h |  3 ---
 3 files changed, 16 deletions(-)

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
diff --git a/fs/super.c b/fs/super.c
index 9ae340f857ee..b9a214d2fe98 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -215,22 +215,12 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
-	/*
-	 * For now MAXQUOTAS check in do_quotactl() will limit quota type
-	 * appropriately. When each fs sets allowed_types, we can remove the
-	 * line below
-	 */
-	s->s_dquot.allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP |
-				   QTYPE_MASK_PRJ;
 	mutex_init(&s->s_dquot.dqio_mutex);
 	mutex_init(&s->s_dquot.dqonoff_mutex);
 	s->s_maxbytes = MAX_NON_LFS;
 	s->s_op = &default_op;
 	s->s_time_gran = 1000000000;
 	s->cleancache_poolid = -1;
-#ifdef CONFIG_QUOTA
-	s->s_inode_fields[IF_DQUOTS] = offsetof(struct inode, i_dquot);
-#endif
 
 	s->s_shrink.seeks = DEFAULT_SEEKS;
 	s->s_shrink.scan_objects = super_cache_scan;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4b7b62543786..6a801ca46cf7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -595,9 +595,6 @@ struct inode {
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
