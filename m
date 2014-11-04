Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFC0F7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:58:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C935AC008
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:58:25 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id R5x1hHzni2hI7xcW (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 03:58:23 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/12] jfs: Convert to private i_dquot field
Date: Tue,  4 Nov 2014 12:19:52 +0100
Message-Id: <1415099993-18034-12-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

CC: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: jfs-discussion@lists.sourceforge.net
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jfs/jfs_incore.h | 3 +++
 fs/jfs/super.c      | 9 +++++++++
 2 files changed, 12 insertions(+)

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
index 93e897e588a8..16c3a9556634 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -117,6 +117,9 @@ static struct inode *jfs_alloc_inode(struct super_block *sb)
 	jfs_inode = kmem_cache_alloc(jfs_inode_cachep, GFP_NOFS);
 	if (!jfs_inode)
 		return NULL;
+#ifdef CONFIG_QUOTA
+	memset(&jfs_inode->i_dquot, 0, sizeof(jfs_inode->i_dquot));
+#endif
 	return &jfs_inode->vfs_inode;
 }
 
@@ -537,6 +540,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &dquot_operations;
 	sb->s_qcop = &dquot_quotactl_ops;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 
 	/*
@@ -836,6 +840,10 @@ out:
 	return len - towrite;
 }
 
+static struct dquot **jfs_get_dquots(struct inode *inode)
+{
+	return JFS_IP(inode)->i_dquot;
+}
 #endif
 
 static const struct super_operations jfs_super_operations = {
@@ -854,6 +862,7 @@ static const struct super_operations jfs_super_operations = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= jfs_quota_read,
 	.quota_write	= jfs_quota_write,
+	.get_dquots	= jfs_get_dquots,
 #endif
 };
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
