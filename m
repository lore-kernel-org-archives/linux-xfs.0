Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SFXRiw236259 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:33:28 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F171D14F9718
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MC02FRNbTlo7na4d for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:26 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 4/4] fs: handle SEEK_HOLE/SEEK_DATA properly in all fs's that
	define their own llseek
Date: Tue, 28 Jun 2011 11:33:18 -0400
Message-Id: <1309275199-10801-4-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk

This converts everybody to handle SEEK_HOLE/SEEK_DATA properly.  In some cases
we just return -EINVAL, in others we do the normal generic thing, and in others
we're simply making sure that the properly due-dilligence is done.  For example
in NFS/CIFS we need to make sure the file size is update properly for the
SEEK_HOLE and SEEK_DATA case, but since it calls the generic llseek stuff itself
that is all we have to do.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/block_dev.c   |   11 ++++++++---
 fs/ceph/dir.c    |    8 +++++++-
 fs/ceph/file.c   |   20 ++++++++++++++++++--
 fs/cifs/cifsfs.c |    7 +++++--
 fs/fuse/file.c   |   21 +++++++++++++++++++--
 fs/hpfs/dir.c    |    4 ++++
 fs/nfs/file.c    |    7 +++++--
 7 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 610e8e0..966617a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -355,20 +355,25 @@ static loff_t block_llseek(struct file *file, loff_t offset, int origin)
 	mutex_lock(&bd_inode->i_mutex);
 	size = i_size_read(bd_inode);
 
+	retval = -EINVAL;
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += size;
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
+		case SEEK_SET:
+			break;
+		default:
+			goto out;
 	}
-	retval = -EINVAL;
 	if (offset >= 0 && offset <= size) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 		}
 		retval = offset;
 	}
+out:
 	mutex_unlock(&bd_inode->i_mutex);
 	return retval;
 }
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ef8f08c..79cd77c 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -446,14 +446,19 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int origin)
 	loff_t retval;
 
 	mutex_lock(&inode->i_mutex);
+	retval = -EINVAL;
 	switch (origin) {
 	case SEEK_END:
 		offset += inode->i_size + 2;   /* FIXME */
 		break;
 	case SEEK_CUR:
 		offset += file->f_pos;
+	case SEEK_SET:
+		break;
+	default:
+		goto out;
 	}
-	retval = -EINVAL;
+
 	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
@@ -477,6 +482,7 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int origin)
 		if (offset > old_offset)
 			fi->dir_release_count--;
 	}
+out:
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 9542f07..774feb1 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -770,13 +770,16 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int origin)
 
 	mutex_lock(&inode->i_mutex);
 	__ceph_do_pending_vmtruncate(inode);
-	switch (origin) {
-	case SEEK_END:
+	if (origin != SEEK_CUR || origin != SEEK_SET) {
 		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE);
 		if (ret < 0) {
 			offset = ret;
 			goto out;
 		}
+	}
+
+	switch (origin) {
+	case SEEK_END:
 		offset += inode->i_size;
 		break;
 	case SEEK_CUR:
@@ -792,6 +795,19 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int origin)
 		}
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		if (offset >= inode->i_size) {
+			ret = -ENXIO;
+			goto out;
+		}
+		break;
+	case SEEK_HOLE:
+		if (offset >= inode->i_size) {
+			ret = -ENXIO;
+			goto out;
+		}
+		offset = inode->i_size;
+		break;
 	}
 
 	if (offset < 0 || offset > inode->i_sb->s_maxbytes) {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 35f9154..5feb6bb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -746,8 +746,11 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 {
-	/* origin == SEEK_END => we must revalidate the cached file length */
-	if (origin == SEEK_END) {
+	/*
+	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
+	 * the cached file length
+	 */
+	if (origin != SEEK_SET || origin != SEEK_CUR) {
 		int rc;
 		struct inode *inode = file->f_path.dentry->d_inode;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 82a6646..73b89df 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1600,15 +1600,32 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	mutex_lock(&inode->i_mutex);
-	switch (origin) {
-	case SEEK_END:
+	if (origin != SEEK_CUR || origin != SEEK_SET) {
 		retval = fuse_update_attributes(inode, NULL, file, NULL);
 		if (retval)
 			goto exit;
+	}
+
+	switch (origin) {
+	case SEEK_END:
 		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
 		offset += file->f_pos;
+		break;
+	case SEEK_DATA:
+		if (offset >= i_size_read(inode)) {
+			retval = -ENXIO;
+			goto exit;
+		}
+		break;
+	case SEEK_HOLE:
+		if (offset >= i_size_read(inode)) {
+			retval = -ENXIO;
+			goto exit;
+		}
+		offset = i_size_read(inode);
+		break;
 	}
 	retval = -EINVAL;
 	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index f46ae02..96a8ed9 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -29,6 +29,10 @@ static loff_t hpfs_dir_lseek(struct file *filp, loff_t off, int whence)
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct super_block *s = i->i_sb;
 
+	/* Somebody else will have to figure out what to do here */
+	if (whence == SEEK_DATA || whence == SEEK_HOLE)
+		return -EINVAL;
+
 	hpfs_lock(s);
 
 	/*printk("dir lseek\n");*/
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 2f093ed..2c1705b 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -187,8 +187,11 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
 			filp->f_path.dentry->d_name.name,
 			offset, origin);
 
-	/* origin == SEEK_END => we must revalidate the cached file length */
-	if (origin == SEEK_END) {
+	/*
+	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
+	 * the cached file length
+	 */
+	if (origin != SEEK_SET || origin != SEEK_CUR) {
 		struct inode *inode = filp->f_mapping->host;
 
 		int retval = nfs_revalidate_file_size(inode, filp);
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
