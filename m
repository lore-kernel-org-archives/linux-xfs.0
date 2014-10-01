Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92C3F7FA0
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:31:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E420AC012
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 12:31:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9HW53c4tcqZ9YTGo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 12:31:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/12] jfs: Convert to private i_dquot field
Date: Wed,  1 Oct 2014 21:31:33 +0200
Message-Id: <1412191894-9113-12-git-send-email-jack@suse.cz>
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

CC: Dave Kleikamp <shaggy@kernel.org>
CC: jfs-discussion@lists.sourceforge.net
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jfs/jfs_incore.h |  3 +++
 fs/jfs/super.c      | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index cf47f09e8ac8..fa7e795bd8ae 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -94,6 +94,9 @@ struct jfs_inode_info {
 			unchar _inline_ea[128];	/* 128: inline extended attr */
 		} link;
 	} u;
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
 	u32 dev;	/* will die when we get wide dev_t */
 	struct inode	vfs_inode;
 };
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index adf8cb045b9e..d32b1ee9836d 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -54,6 +54,7 @@ static struct kmem_cache *jfs_inode_cachep;
 
 static const struct super_operations jfs_super_operations;
 static const struct export_operations jfs_export_operations;
+static const int jfs_inode_fields[IF_FIELD_NR];
 static struct file_system_type jfs_fs_type;
 
 #define MAX_COMMIT_THREADS 64
@@ -117,6 +118,9 @@ static struct inode *jfs_alloc_inode(struct super_block *sb)
 	jfs_inode = kmem_cache_alloc(jfs_inode_cachep, GFP_NOFS);
 	if (!jfs_inode)
 		return NULL;
+#ifdef CONFIG_QUOTA
+	memset(&jfs_inode->i_dquot, 0, sizeof(jfs_inode->i_dquot));
+#endif
 	return &jfs_inode->vfs_inode;
 }
 
@@ -537,7 +541,9 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
 	sb->s_qcop = &dquot_quotactl_ops;
+	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
 #endif
+	sb_init_inode_fields(sb, jfs_inode_fields);
 
 	/*
 	 * Initialize direct-mapping inode/address-space
@@ -857,6 +863,13 @@ static const struct super_operations jfs_super_operations = {
 #endif
 };
 
+static const int jfs_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = (int)offsetof(struct js_inode_info, i_dquot) -
+		      (int)offsetof(struct jfs_inode_info, vfs_inode),
+#endif
+};
+
 static const struct export_operations jfs_export_operations = {
 	.fh_to_dentry	= jfs_fh_to_dentry,
 	.fh_to_parent	= jfs_fh_to_parent,
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
