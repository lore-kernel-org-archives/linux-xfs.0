Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51291 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753784AbdDKO0z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:26:55 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 9/9] nowait aio: Return -EOPNOTSUPP if filesystem does not support
Date: Tue, 11 Apr 2017 09:26:19 -0500
Message-Id: <20170411142619.27205-10-rgoldwyn@suse.de>
In-Reply-To: <20170411142619.27205-1-rgoldwyn@suse.de>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The check is in generic_file_write_iter(), which is called by
most filesystems, either through fsops.write_iter() or through
the function defined by write_iter(). If not, we perform the
check in the defined .write_iter() function which is called
for direct IO.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/9p/vfs_file.c | 3 +++
 fs/ceph/file.c   | 3 +++
 fs/cifs/file.c   | 3 +++
 fs/fuse/file.c   | 3 +++
 fs/nfs/direct.c  | 3 +++
 fs/ocfs2/file.c  | 3 +++
 mm/filemap.c     | 3 +++
 7 files changed, 21 insertions(+)

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
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 26cc95421cca..af28419b1731 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1267,6 +1267,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int err, want, got;
 	loff_t pos;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EROFS;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index aa3debbba826..a828ab3e7775 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2638,6 +2638,9 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * write request.
 	 */
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EOPNOTSUPP;
+
 	rc = generic_write_checks(iocb, from);
 	if (rc <= 0)
 		return rc;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ec238fb5a584..72786e798319 100644
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
index aab32fc3d6a8..ab419caebd5f 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -991,6 +991,9 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
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
diff --git a/mm/filemap.c b/mm/filemap.c
index 46e01b8f6880..48b83d1d4a30 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3026,6 +3026,9 @@ ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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

