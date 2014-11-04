Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B5EF7F55
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:58:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A01A2AC008
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:58:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 43ICwXkL9FEsijD0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 03:58:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/12] ext3: Convert to private i_dquot field
Date: Tue,  4 Nov 2014 12:19:48 +0100
Message-Id: <1415099993-18034-8-git-send-email-jack@suse.cz>
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

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ext3.h  |  4 ++++
 fs/ext3/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index fc3cdcf24aed..f483a80b3fe7 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -615,6 +615,10 @@ struct ext3_inode_info {
 	atomic_t i_sync_tid;
 	atomic_t i_datasync_tid;
 
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7015db0bafd1..964e2842889d 100644
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
 
@@ -764,6 +768,10 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
+static struct dquot **ext3_get_dquots(struct inode *inode)
+{
+	return EXT3_I(inode)->i_dquot;
+}
 
 static const struct dquot_operations ext3_quota_operations = {
 	.write_dquot	= ext3_write_dquot,
@@ -803,6 +811,7 @@ static const struct super_operations ext3_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext3_quota_read,
 	.quota_write	= ext3_quota_write,
+	.get_dquots	= ext3_get_dquots,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
@@ -2008,6 +2017,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	sb->s_qcop = &ext3_qctl_operations;
 	sb->dq_op = &ext3_quota_operations;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
