Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFBEF7F60
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:38:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D8E3AC003
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 07:38:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CjzqyTFJYObJaxMd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 07:38:54 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/12] ocfs2: Convert to private i_dquot field
Date: Tue, 21 Oct 2014 16:38:33 +0200
Message-Id: <1413902316-17997-10-git-send-email-jack@suse.cz>
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

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel@oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.h |  4 ++++
 fs/ocfs2/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a9b76de46047..1bb2e27eaad7 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -80,6 +80,10 @@ struct ocfs2_inode_info
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
 };
 
 /*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 93c85bc745e1..9a97986d54f5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -143,6 +143,11 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
 
+static struct dquot **ocfs2_get_dquots(struct inode *inode)
+{
+	return OCFS2_I(inode)->i_dquot;
+}
+
 static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
@@ -155,6 +160,7 @@ static const struct super_operations ocfs2_sops = {
 	.show_options   = ocfs2_show_options,
 	.quota_read	= ocfs2_quota_read,
 	.quota_write	= ocfs2_quota_write,
+	.get_dquots	= ocfs2_get_dquots,
 };
 
 enum {
@@ -563,6 +569,9 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
 
 	oi->i_sync_tid = 0;
 	oi->i_datasync_tid = 0;
+#ifdef CONFIG_QUOTA
+	memset(&oi->i_dquot, 0, sizeof(oi->i_dquot));
+#endif
 
 	jbd2_journal_init_jbd_inode(&oi->ip_jinode, &oi->vfs_inode);
 	return &oi->vfs_inode;
@@ -2073,6 +2082,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_export_op = &ocfs2_export_ops;
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
