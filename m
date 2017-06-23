Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753701AbdFWNfB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 09:35:01 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 6/6] gfs2: Implement SEEK_HOLE / SEEK_DATA via iomap
Date: Fri, 23 Jun 2017 15:34:44 +0200
Message-Id: <1498224884-346-7-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498224884-346-1-git-send-email-agruenba@redhat.com>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>

So far, holes were not reported by lseek SEEK_HOLE / SEEK_DATA on gfs2.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/file.c  | 14 +++++++++++---
 fs/gfs2/inode.c | 35 +++++++++++++++++++++++++++++++++++
 fs/gfs2/inode.h |  1 +
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index c2062a1..62ce320 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -60,9 +60,7 @@ static loff_t gfs2_llseek(struct file *file, loff_t offset, int whence)
 	loff_t error;
 
 	switch (whence) {
-	case SEEK_END: /* These reference inode->i_size */
-	case SEEK_DATA:
-	case SEEK_HOLE:
+	case SEEK_END:
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
@@ -70,8 +68,18 @@ static loff_t gfs2_llseek(struct file *file, loff_t offset, int whence)
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 		break;
+
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		error = gfs2_seek_hole_data(file, offset, whence);
+		break;
+
 	case SEEK_CUR:
 	case SEEK_SET:
+		/*
+		 * These don't reference inode->i_size and don't depend on the
+		 * block mapping, so we don't need the glock.
+		 */
 		error = generic_file_llseek(file, offset, whence);
 		break;
 	default:
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9ed2e91..07e64cc 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2046,6 +2046,41 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	return ret;
 }
 
+loff_t gfs2_seek_hole_data(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	loff_t ret;
+
+	inode_lock(inode);
+	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	if (ret)
+		goto out;
+	if (gfs2_is_stuffed(ip)) {
+		u64 size = i_size_read(inode);
+
+		if (offset >= size) {
+			ret = -ENXIO;
+			goto out_dequeue;
+		}
+		ret = offset;
+		if (whence == SEEK_HOLE)
+			ret = size;
+	} else {
+		ret = iomap_seek_hole_data(inode, offset, whence, &gfs2_iomap_ops);
+	}
+
+out_dequeue:
+	gfs2_glock_dq_uninit(&gh);
+out:
+	inode_unlock(inode);
+
+	if (ret < 0)
+		return ret;
+	return vfs_setpos(file, ret, inode->i_sb->s_maxbytes);
+}
+
 const struct inode_operations gfs2_file_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index aace8ce..c2866ec 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -109,6 +109,7 @@ extern int gfs2_setattr_simple(struct inode *inode, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
 extern int gfs2_open_common(struct inode *inode, struct file *file);
+extern loff_t gfs2_seek_hole_data(struct file *file, loff_t offset, int whence);
 
 extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
-- 
2.7.5

