Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DEB517F88
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:31:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 84F0BAC015
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 12:31:48 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 7pIdOnDgPGYmB2GN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 12:31:47 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/12] ext4: Convert to private i_dquot field
Date: Wed,  1 Oct 2014 21:31:30 +0200
Message-Id: <1412191894-9113-9-git-send-email-jack@suse.cz>
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
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  4 ++++
 fs/ext4/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0c225cdb52c..571a9f409e94 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -940,6 +940,10 @@ struct ext4_inode_info {
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
 
+#ifdef CONFIG_QUOTA
+	struct dquot *i_dquot[MAXQUOTAS];
+#endif
+
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b28b36e7915..a4cccf9fba60 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -895,6 +895,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
@@ -1143,6 +1144,13 @@ static const struct super_operations ext4_nojournal_sops = {
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
+static const int ext4_inode_fields[IF_FIELD_NR] = {
+#ifdef CONFIG_QUOTA
+	[IF_DQUOTS] = offsetof(struct ext4_inode_info, i_dquot) -
+		      offsetof(struct ext4_inode_info, vfs_inode),
+#endif
+};
+
 static const struct export_operations ext4_export_ops = {
 	.fh_to_dentry = ext4_fh_to_dentry,
 	.fh_to_parent = ext4_fh_to_parent,
@@ -3916,7 +3924,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &ext4_qctl_sysfile_operations;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
+	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
 #endif
+	sb_init_inode_fields(sb, ext4_inode_fields);
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
