Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeJPLIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 07:08:06 -0400
Subject: [PATCH 16/26] vfs: plumb remap flags through the vfs dedupe
 functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Oct 2018 20:19:47 -0700
Message-ID: <153965998743.3607.1661657709759570842.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb a remap_flags argument through the vfs_dedupe_file_range_one
functions so that dedupe can take advantage of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c |    3 ++-
 fs/read_write.c     |    9 ++++++---
 include/linux/fs.h  |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)


diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0393815c8971..84dd957efa24 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -467,7 +467,8 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 
 	case OVL_DEDUPE:
 		ret = vfs_dedupe_file_range_one(real_in.file, pos_in,
-						real_out.file, pos_out, len);
+						real_out.file, pos_out, len,
+						flags);
 		break;
 	}
 	revert_creds(old_cred);
diff --git a/fs/read_write.c b/fs/read_write.c
index 791b406e8264..f6ab5beb935a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2019,10 +2019,12 @@ EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
 loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 				 struct file *dst_file, loff_t dst_pos,
-				 loff_t len)
+				 loff_t len, unsigned int remap_flags)
 {
 	loff_t ret;
 
+	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP));
+
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
 		return ret;
@@ -2053,7 +2055,7 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	}
 
 	ret = dst_file->f_op->remap_file_range(src_file, src_pos, dst_file,
-			dst_pos, len, REMAP_FILE_DEDUP);
+			dst_pos, len, remap_flags | REMAP_FILE_DEDUP);
 out_drop_write:
 	mnt_drop_write_file(dst_file);
 
@@ -2121,7 +2123,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 		}
 
 		deduped = vfs_dedupe_file_range_one(file, off, dst_file,
-						    info->dest_offset, len);
+						    info->dest_offset, len,
+						    0);
 		if (deduped == -EBADE)
 			info->status = FILE_DEDUPE_RANGE_DIFFERS;
 		else if (deduped < 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bc353a5224a4..c0ae85a7bd9d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1854,7 +1854,7 @@ extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 					struct file *dst_file, loff_t dst_pos,
-					loff_t len);
+					loff_t len, unsigned int remap_flags);
 
 
 struct super_operations {
