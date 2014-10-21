Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E40977F4E
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:38:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7387BAC001
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 07:38:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id PNCpuhIev5vk4zcp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 07:38:54 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/12] ext4: Convert to private i_dquot field
Date: Tue, 21 Oct 2014 16:38:32 +0200
Message-Id: <1413902316-17997-9-git-send-email-jack@suse.cz>
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
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  | 4 ++++
 fs/ext4/super.c | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c55a1faaed58..db3f772e57ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -941,6 +941,10 @@ struct ext4_inode_info {
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
index 1eda6ab0ef9d..7207799e5939 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -892,6 +892,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
+	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
@@ -1068,6 +1069,11 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 			     unsigned int flags);
 static int ext4_enable_quotas(struct super_block *sb);
 
+static struct dquot **ext4_get_dquots(struct inode *inode)
+{
+	return EXT4_I(inode)->i_dquot;
+}
+
 static const struct dquot_operations ext4_quota_operations = {
 	.get_reserved_space = ext4_get_reserved_space,
 	.write_dquot	= ext4_write_dquot,
@@ -1117,6 +1123,7 @@ static const struct super_operations ext4_sops = {
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext4_quota_read,
 	.quota_write	= ext4_quota_write,
+	.get_dquots	= ext4_get_dquots,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
@@ -3928,6 +3935,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &ext4_qctl_sysfile_operations;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
+	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
