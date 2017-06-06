Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41027 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751456AbdFFLUD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 07:20:03 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 04/10] fs: Introduce RWF_NOWAIT
Date: Tue,  6 Jun 2017 06:19:33 -0500
Message-Id: <20170606111939.27272-5-rgoldwyn@suse.de>
In-Reply-To: <20170606111939.27272-1-rgoldwyn@suse.de>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

RWF_NOWAIT informs kernel to bail out if an AIO request will block
for reasons such as file allocations, or a writeback triggered,
or would block while allocating requests while performing
direct I/O.

RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.

The check for -EOPNOTSUPP is placed in generic_file_write_iter(). This
is called by most filesystems, either through fsops.write_iter() or through
the function defined by write_iter(). If not, we perform the check defined
by .write_iter() which is called for direct IO specifically.

Filesystems xfs, btrfs and ext4 would be supported in the following patches.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/9p/vfs_file.c        | 3 +++
 fs/aio.c                | 6 ++++++
 fs/ceph/file.c          | 3 +++
 fs/cifs/file.c          | 3 +++
 fs/fuse/file.c          | 3 +++
 fs/nfs/direct.c         | 3 +++
 fs/ocfs2/file.c         | 3 +++
 include/linux/fs.h      | 5 ++++-
 include/uapi/linux/fs.h | 1 +
 mm/filemap.c            | 3 +++
 10 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 3de3b4a89d89..403681db7723 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -411,6 +411,9 @@ v9fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	loff_t origin;
 	int err = 0;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	retval = generic_write_checks(iocb, from);
 	if (retval <= 0)
 		return retval;
diff --git a/fs/aio.c b/fs/aio.c
index 020fa0045e3c..34027b67e2f4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1592,6 +1592,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		goto out_put_req;
 	}
 
+	if ((req->common.ki_flags & IOCB_NOWAIT) &&
+			!(req->common.ki_flags & IOCB_DIRECT)) {
+		ret = -EOPNOTSUPP;
+		goto out_put_req;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 29308a80d66f..366b0bb71f97 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1300,6 +1300,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int err, want, got;
 	loff_t pos;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EROFS;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0fd081bd2a2f..ff84fa9ddb6c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2725,6 +2725,9 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * write request.
 	 */
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	rc = generic_write_checks(iocb, from);
 	if (rc <= 0)
 		return rc;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3ee4fdc3da9e..812c7bd0c290 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1425,6 +1425,9 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct fuse_io_priv io = FUSE_IO_PRIV_SYNC(file);
 	ssize_t res;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	if (is_bad_inode(inode))
 		return -EIO;
 
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 6fb9fad2d1e6..c8e7dd76126c 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -979,6 +979,9 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
 		file, iov_iter_count(iter), (long long) iocb->ki_pos);
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	result = generic_write_checks(iocb, iter);
 	if (result <= 0)
 		return result;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bfeb647459d9..e7f8ba890305 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2235,6 +2235,9 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	if (count == 0)
 		return 0;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 
 	inode_lock(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0ab585cd56..2a7d14af6d12 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -268,6 +268,7 @@ struct writeback_control;
 #define IOCB_DSYNC		(1 << 4)
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
+#define IOCB_NOWAIT		(1 << 7)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3060,7 +3061,7 @@ static inline int iocb_flags(struct file *file)
 
 static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
 {
-	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
+	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT)))
 		return -EOPNOTSUPP;
 
 	if (flags & RWF_HIPRI)
@@ -3069,6 +3070,8 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
 		ki->ki_flags |= IOCB_DSYNC;
 	if (flags & RWF_SYNC)
 		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+	if (flags & RWF_NOWAIT)
+		ki->ki_flags |= IOCB_NOWAIT;
 	return 0;
 }
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 24e61a54feaa..29969fb7f9a7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -360,5 +360,6 @@ struct fscrypt_key {
 #define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
 #define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
 #define RWF_SYNC			0x00000004 /* per-IO O_SYNC */
+#define RWF_NOWAIT			0x00000008 /* per-IO, return -EAGAIN if operation would block */
 
 #endif /* _UAPI_LINUX_FS_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index 87aba7698584..097213275461 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3006,6 +3006,9 @@ ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	inode_lock(inode);
 	ret = generic_write_checks(iocb, from);
 	if (ret > 0)
-- 
2.12.0

