Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941621AbcJSOUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2016 10:20:49 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: move inode locking from xfs_reflink_remap_range to xfs_file_share_range
Date: Wed, 19 Oct 2016 14:47:26 +0200
Message-Id: <1476881248-18669-4-git-send-email-hch@lst.de>
In-Reply-To: <1476881248-18669-1-git-send-email-hch@lst.de>
References: <1476881248-18669-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

We need the iolock protection to stabilizie the IS_SWAPFILE and IS_IMMUTABLE
values, as well as preventing new buffered writers re-dirtying the file data
that we just wrote out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    | 62 ++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_reflink.c | 15 -------------
 2 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 012a960..0960264 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -996,38 +996,54 @@ xfs_file_share_range(
 	inode_out = file_inode(file_out);
 	bs = inode_out->i_sb->s_blocksize;
 
+	/* Lock both files against IO */
+	same_inode = (inode_in == inode_out);
+	if (same_inode) {
+		xfs_ilock(XFS_I(inode_in), XFS_IOLOCK_EXCL);
+		xfs_ilock(XFS_I(inode_in), XFS_MMAPLOCK_EXCL);
+	} else {
+		xfs_lock_two_inodes(XFS_I(inode_in), XFS_I(inode_out),
+				XFS_IOLOCK_EXCL);
+		xfs_lock_two_inodes(XFS_I(inode_in), XFS_I(inode_out),
+				XFS_MMAPLOCK_EXCL);
+	}
+
 	/* Don't touch certain kinds of inodes */
+	ret = -EPERM;
 	if (IS_IMMUTABLE(inode_out))
-		return -EPERM;
-	if (IS_SWAPFILE(inode_in) ||
-	    IS_SWAPFILE(inode_out))
-		return -ETXTBSY;
-
-	same_inode = (inode_in == inode_out);
+		goto out_unlock;
+	ret = -ETXTBSY;
+	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
+		goto out_unlock;
 
 	/* Don't reflink dirs, pipes, sockets... */
+	ret = -EISDIR;
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
-		return -EISDIR;
+		goto out_unlock;
+	ret = -EINVAL;
 	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
-		return -EINVAL;
+		goto out_unlock;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Don't share DAX file data for now. */
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Are we going all the way to the end? */
 	isize = i_size_read(inode_in);
-	if (isize == 0)
-		return 0;
+	if (isize == 0) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	if (len == 0)
 		len = isize - pos_in;
 
 	/* Ensure offsets don't wrap and the input is inside i_size */
 	if (pos_in + len < pos_in || pos_out + len < pos_out ||
 	    pos_in + len > isize)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Don't allow dedupe past EOF in the dest file */
 	if (is_dedupe) {
@@ -1035,7 +1051,7 @@ xfs_file_share_range(
 
 		disize = i_size_read(inode_out);
 		if (pos_out >= disize || pos_out + len > disize)
-			return -EINVAL;
+			goto out_unlock;
 	}
 
 	/* If we're linking to EOF, continue to the block boundary. */
@@ -1047,28 +1063,32 @@ xfs_file_share_range(
 	/* Only reflink if we're aligned to block boundaries */
 	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
 	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Don't allow overlapped reflink within the same file */
 	if (same_inode && pos_out + blen > pos_in && pos_out < pos_in + blen)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Wait for the completion of any pending IOs on srcfile */
 	ret = xfs_file_wait_for_io(inode_in, pos_in, len);
 	if (ret)
-		goto out;
+		goto out_unlock;
 	ret = xfs_file_wait_for_io(inode_out, pos_out, len);
 	if (ret)
-		goto out;
+		goto out_unlock;
 
 	if (is_dedupe)
 		flags |= XFS_REFLINK_DEDUPE;
 	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
 			pos_out, len, flags);
-	if (ret < 0)
-		goto out;
 
-out:
+out_unlock:
+	xfs_iunlock(XFS_I(inode_in), XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(XFS_I(inode_in), XFS_IOLOCK_EXCL);
+	if (!same_inode) {
+		xfs_iunlock(XFS_I(inode_out), XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(XFS_I(inode_out), XFS_IOLOCK_EXCL);
+	}
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5965e94..d012746 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1341,15 +1341,6 @@ xfs_reflink_remap_range(
 
 	trace_xfs_reflink_remap_range(src, srcoff, len, dest, destoff);
 
-	/* Lock both files against IO */
-	if (src->i_ino == dest->i_ino) {
-		xfs_ilock(src, XFS_IOLOCK_EXCL);
-		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
-	} else {
-		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
-		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
-	}
-
 	/*
 	 * Check that the extents are the same.
 	 */
@@ -1401,12 +1392,6 @@ xfs_reflink_remap_range(
 		goto out_error;
 
 out_error:
-	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
-	xfs_iunlock(src, XFS_IOLOCK_EXCL);
-	if (src->i_ino != dest->i_ino) {
-		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
-		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
-	}
 	if (error)
 		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
 	return error;
-- 
2.1.4

