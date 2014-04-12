Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95F217F4E
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 17:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18BE7AC001
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 15:55:25 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id DViDyXA1bfmN22fQ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 15:55:23 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add a new spinlock i_raw_lock to protect the ext4's raw
	inode
Date: Sat, 12 Apr 2014 18:55:14 -0400
Message-Id: <1397343317-14669-1-git-send-email-tytso@mit.edu>
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
To: xfs@oss.sgi.com
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>

To avoid potential data races, use a spinlock which protects the raw
(on-disk) inode.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  | 2 ++
 fs/ext4/inode.c | 5 ++++-
 fs/ext4/super.c | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 86c2cda..1d08a1b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -875,6 +875,8 @@ struct ext4_inode_info {
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
 
+	spinlock_t i_raw_lock;	/* protects updates to the raw inode */
+
 	/*
 	 * File creation time. Its function is same as that of
 	 * struct timespec i_{a,c,m}time in the generic inode.
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2eb5fad..1ee8ff6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4311,7 +4311,9 @@ static int ext4_do_update_inode(handle_t *handle,
 	uid_t i_uid;
 	gid_t i_gid;
 
-	/* For fields not not tracking in the in-memory inode,
+	spin_lock(&ei->i_raw_lock);
+
+	/* For fields not tracked in the in-memory inode,
 	 * initialise them to zero for new inodes. */
 	if (ext4_test_inode_state(inode, EXT4_STATE_NEW))
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
@@ -4419,6 +4421,7 @@ static int ext4_do_update_inode(handle_t *handle,
 
 	ext4_update_inode_fsync_trans(handle, inode, need_datasync);
 out_brelse:
+	spin_unlock(&ei->i_raw_lock);
 	brelse(bh);
 	ext4_std_error(inode->i_sb, err);
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c4895c1..1f8cb18 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -879,6 +879,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	ei->vfs_inode.i_version = 1;
+	spin_lock_init(&ei->i_raw_lock);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
 	ext4_es_init_tree(&ei->i_es_tree);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
