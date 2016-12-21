Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936090AbcLUREI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:08 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 21/30] ocfs2: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:38 -0500
Message-Id: <1482339827-7882-22-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ocfs2/dir.c          | 14 +++++++-------
 fs/ocfs2/inode.c        |  2 +-
 fs/ocfs2/namei.c        |  2 +-
 fs/ocfs2/quota_global.c |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 3ecb9f337b7d..b78105d404b3 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1174,7 +1174,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 				le16_add_cpu(&pde->rec_len,
 						le16_to_cpu(de->rec_len));
 			de->inode = 0;
-			dir->i_version++;
+			inode_inc_iversion_locked(dir);
 			ocfs2_journal_dirty(handle, bh);
 			goto bail;
 		}
@@ -1729,7 +1729,7 @@ int __ocfs2_add_entry(handle_t *handle,
 			if (ocfs2_dir_indexed(dir))
 				ocfs2_recalc_free_list(dir, handle, lookup);
 
-			dir->i_version++;
+			inode_inc_iversion_locked(dir);
 			ocfs2_journal_dirty(handle, insert_bh);
 			retval = 0;
 			goto bail;
@@ -1775,7 +1775,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 		 * readdir(2), then we might be pointing to an invalid
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
-		if (*f_version != inode->i_version) {
+		if (inode_cmp_iversion(inode, *f_version)) {
 			for (i = 0; i < i_size_read(inode) && i < offset; ) {
 				de = (struct ocfs2_dir_entry *)
 					(data->id_data + i);
@@ -1791,7 +1791,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 				i += le16_to_cpu(de->rec_len);
 			}
 			ctx->pos = offset = i;
-			*f_version = inode->i_version;
+			*f_version = inode_get_iversion(inode);
 		}
 
 		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
@@ -1869,7 +1869,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		 * readdir(2), then we might be pointing to an invalid
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
-		if (*f_version != inode->i_version) {
+		if (inode_cmp_iversion(inode, *f_version)) {
 			for (i = 0; i < sb->s_blocksize && i < offset; ) {
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
@@ -1886,7 +1886,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 			offset = i;
 			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
 				| offset;
-			*f_version = inode->i_version;
+			*f_version = inode_get_iversion(inode);
 		}
 
 		while (ctx->pos < i_size_read(inode)
@@ -1940,7 +1940,7 @@ static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
  */
 int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
 {
-	u64 version = inode->i_version;
+	u64 version = inode_get_iversion(inode);
 	ocfs2_dir_foreach_blk(inode, &version, ctx, true);
 	return 0;
 }
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 382401d3e88f..31f1e80cd980 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -302,7 +302,7 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	OCFS2_I(inode)->ip_attr = le32_to_cpu(fe->i_attr);
 	OCFS2_I(inode)->ip_dyn_features = le16_to_cpu(fe->i_dyn_features);
 
-	inode->i_version = 1;
+	inode_set_iversion(inode, 1);
 	inode->i_generation = le32_to_cpu(fe->i_generation);
 	inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 	inode->i_mode = le16_to_cpu(fe->i_mode);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3b0a10d9b36f..c045826b716a 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1520,7 +1520,7 @@ static int ocfs2_rename(struct inode *old_dir,
 			mlog_errno(status);
 			goto bail;
 		}
-		new_dir->i_version++;
+		inode_inc_iversion(new_dir);
 
 		if (S_ISDIR(new_inode->i_mode))
 			ocfs2_set_links_count(newfe, 0);
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index cec495a921e3..a9fad85597e1 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -288,7 +288,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 		mlog_errno(err);
 		return err;
 	}
-	gqinode->i_version++;
+	inode_get_iversion(gqinode);
 	ocfs2_mark_inode_dirty(handle, gqinode, oinfo->dqi_gqi_bh);
 	return len;
 }
-- 
2.7.4

