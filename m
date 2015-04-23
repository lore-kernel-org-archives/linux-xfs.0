Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF4807F5D
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 14:09:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B054AC006
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 12:09:00 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 2F7AYKbHDAJnKgkL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 12:08:58 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] xfs: move non-inline symlinks to the pagecache
Date: Thu, 23 Apr 2015 21:07:43 +0200
Message-Id: <1429816064-10033-6-git-send-email-hch@lst.de>
In-Reply-To: <1429816064-10033-1-git-send-email-hch@lst.de>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
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
Cc: viro@zeniv.linux.org.uk

We can use the generic symlink in pagecache code for XFS non-inline
symlinks.  Because links are always shorter than a page we will
get the zero termination for the link for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c    |  40 ++++++++++++++---
 fs/xfs/xfs_symlink.c | 120 ---------------------------------------------------
 fs/xfs/xfs_symlink.h |   1 -
 fs/xfs/xfs_trace.h   |   1 -
 4 files changed, 34 insertions(+), 128 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d3505ff..57c0998 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -419,21 +419,32 @@ xfs_vn_rename(
  * uio is kmalloced for this reason...
  */
 STATIC void *
-xfs_vn_follow_link(
+xfs_vn_follow_link_inline(
 	struct dentry		*dentry,
 	struct nameidata	*nd)
 {
+	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
+	xfs_fsize_t		pathlen;
 	char			*link;
 	int			error = -ENOMEM;
 
+	error = -ENOMEM;
 	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
 	if (!link)
 		goto out_err;
 
-	error = xfs_readlink(XFS_I(dentry->d_inode), link);
-	if (unlikely(error))
+	error = -EIO;
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) 
 		goto out_kfree;
 
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	pathlen = ip->i_d.di_size;
+	if (pathlen) {
+		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
+		link[pathlen] = '\0';
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
 	nd_set_link(nd, link);
 	return NULL;
 
@@ -1179,7 +1190,20 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 
 static const struct inode_operations xfs_symlink_inode_operations = {
 	.readlink		= generic_readlink,
-	.follow_link		= xfs_vn_follow_link,
+	.follow_link		= page_follow_link_light,
+	.put_link		= page_put_link,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= generic_setxattr,
+	.getxattr		= generic_getxattr,
+	.removexattr		= generic_removexattr,
+	.listxattr		= xfs_vn_listxattr,
+	.update_time		= xfs_vn_update_time,
+};
+
+static const struct inode_operations xfs_inline_symlink_inode_operations = {
+	.readlink		= generic_readlink,
+	.follow_link		= xfs_vn_follow_link_inline,
 	.put_link		= kfree_put_link,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
@@ -1190,6 +1214,7 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.update_time		= xfs_vn_update_time,
 };
 
+
 STATIC void
 xfs_diflags_to_iflags(
 	struct inode		*inode,
@@ -1308,9 +1333,12 @@ xfs_setup_iops(
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
-		inode->i_op = &xfs_symlink_inode_operations;
-		if (!(ip->i_df.if_flags & XFS_IFINLINE))
+		if (ip->i_df.if_flags & XFS_IFINLINE) {
+			inode->i_op = &xfs_inline_symlink_inode_operations;
+		} else {
 			inode->i_mapping->a_ops = &xfs_address_space_operations;
+			inode->i_op = &xfs_symlink_inode_operations;
+		}
 		break;
 	default:
 		inode->i_op = &xfs_inode_operations;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7fa94dc..c1d7775 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -42,126 +42,6 @@
 #include "xfs_log.h"
 
 /* ----- Kernel only functions below ----- */
-STATIC int
-xfs_readlink_bmap(
-	struct xfs_inode	*ip,
-	char			*link)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;
-	char			*cur_chunk;
-	int			pathlen = ip->i_d.di_size;
-	int			nmaps = XFS_SYMLINK_MAPS;
-	int			byte_cnt;
-	int			n;
-	int			error = 0;
-	int			fsblocks = 0;
-	int			offset;
-
-	fsblocks = xfs_symlink_blocks(mp, pathlen);
-	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
-	if (error)
-		goto out;
-
-	offset = 0;
-	for (n = 0; n < nmaps; n++) {
-		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
-				  &xfs_symlink_buf_ops);
-		if (!bp)
-			return -ENOMEM;
-		error = bp->b_error;
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_buf_relse(bp);
-
-			/* bad CRC means corrupted metadata */
-			if (error == -EFSBADCRC)
-				error = -EFSCORRUPTED;
-			goto out;
-		}
-		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
-		if (pathlen < byte_cnt)
-			byte_cnt = pathlen;
-
-		cur_chunk = bp->b_addr;
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
-							byte_cnt, bp)) {
-				error = -EFSCORRUPTED;
-				xfs_alert(mp,
-"symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
-					offset, byte_cnt, ip->i_ino);
-				xfs_buf_relse(bp);
-				goto out;
-
-			}
-
-			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
-		}
-
-		memcpy(link + offset, bp->b_addr, byte_cnt);
-
-		pathlen -= byte_cnt;
-		offset += byte_cnt;
-
-		xfs_buf_relse(bp);
-	}
-	ASSERT(pathlen == 0);
-
-	link[ip->i_d.di_size] = '\0';
-	error = 0;
-
- out:
-	return error;
-}
-
-int
-xfs_readlink(
-	struct xfs_inode *ip,
-	char		*link)
-{
-	struct xfs_mount *mp = ip->i_mount;
-	xfs_fsize_t	pathlen;
-	int		error = 0;
-
-	trace_xfs_readlink(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-	pathlen = ip->i_d.di_size;
-	if (!pathlen)
-		goto out;
-
-	if (pathlen < 0 || pathlen > MAXPATHLEN) {
-		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
-			 __func__, (unsigned long long) ip->i_ino,
-			 (long long) pathlen);
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-		goto out;
-	}
-
-
-	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
-		link[pathlen] = '\0';
-	} else {
-		error = xfs_readlink_bmap(ip, link);
-	}
-
- out:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
-}
-
 int
 xfs_symlink(
 	struct xfs_inode	*dp,
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index e75245d..d6816af 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -21,7 +21,6 @@
 
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
-int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_H */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 615781b..6aaff5c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -658,7 +658,6 @@ DEFINE_INODE_EVENT(xfs_iget_miss);
 
 DEFINE_INODE_EVENT(xfs_getattr);
 DEFINE_INODE_EVENT(xfs_setattr);
-DEFINE_INODE_EVENT(xfs_readlink);
 DEFINE_INODE_EVENT(xfs_inactive_symlink);
 DEFINE_INODE_EVENT(xfs_alloc_file_space);
 DEFINE_INODE_EVENT(xfs_free_file_space);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
