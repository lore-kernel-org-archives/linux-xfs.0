Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5TI7O8v154068 for <xfs@oss.sgi.com>; Fri, 29 Jun 2012 13:07:24 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id NLtOG8KnH3GeDyG2 for
	<xfs@oss.sgi.com>; Fri, 29 Jun 2012 11:07:21 -0700 (PDT)
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 2/2] xfs: rename xfs_fs_* to xfs_*
Date: Sat, 30 Jun 2012 02:06:42 +0800
Message-Id: <1340993202-5560-2-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1340993202-5560-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1340993202-5560-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
To: XFS <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>

s/xfs_fs_/xfs_/
This too long name is unnecessary.

CC: Ben Myers <bpm@sgi.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/xfs/Makefile       |    2 +-
 fs/xfs/xfs_export.c   |   20 +++++------
 fs/xfs/xfs_file.c     |    2 +-
 fs/xfs/xfs_fs_subr.c  |   96 -------------------------------------------------
 fs/xfs/xfs_fsops.c    |    8 ++---
 fs/xfs/xfs_fsops.h    |    8 ++---
 fs/xfs/xfs_ioctl.c    |   10 +++---
 fs/xfs/xfs_ioctl32.c  |    2 +-
 fs/xfs/xfs_log.c      |    2 +-
 fs/xfs/xfs_mount.c    |    4 +--
 fs/xfs/xfs_mount.h    |    2 +-
 fs/xfs/xfs_quotaops.c |   16 ++++-----
 fs/xfs/xfs_subr.c     |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c    |   76 +++++++++++++++++++--------------------
 fs/xfs/xfs_sync.c     |    4 +--
 15 files changed, 174 insertions(+), 174 deletions(-)
 delete mode 100644 fs/xfs/xfs_fs_subr.c
 create mode 100644 fs/xfs/xfs_subr.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d2bf974..8688592 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -37,7 +37,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_file.o \
 				   xfs_filestream.o \
 				   xfs_fsops.o \
-				   xfs_fs_subr.o \
+				   xfs_subr.o \
 				   xfs_globals.o \
 				   xfs_iget.o \
 				   xfs_ioctl.o \
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 4267922..0e25c37 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -51,7 +51,7 @@ static int xfs_fileid_length(int fileid_type)
 }
 
 STATIC int
-xfs_fs_encode_fh(
+xfs_encode_fh(
 	struct inode	*inode,
 	__u32		*fh,
 	int		*max_len,
@@ -159,7 +159,7 @@ xfs_nfs_get_inode(
 }
 
 STATIC struct dentry *
-xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+xfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 		 int fh_len, int fileid_type)
 {
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
@@ -183,7 +183,7 @@ xfs_fs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 }
 
 STATIC struct dentry *
-xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
+xfs_fh_to_parent(struct super_block *sb, struct fid *fid,
 		 int fh_len, int fileid_type)
 {
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
@@ -204,7 +204,7 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
 }
 
 STATIC struct dentry *
-xfs_fs_get_parent(
+xfs_get_parent(
 	struct dentry		*child)
 {
 	int			error;
@@ -218,7 +218,7 @@ xfs_fs_get_parent(
 }
 
 STATIC int
-xfs_fs_nfs_commit_metadata(
+xfs_nfs_commit_metadata(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -236,9 +236,9 @@ xfs_fs_nfs_commit_metadata(
 }
 
 const struct export_operations xfs_export_operations = {
-	.encode_fh		= xfs_fs_encode_fh,
-	.fh_to_dentry		= xfs_fs_fh_to_dentry,
-	.fh_to_parent		= xfs_fs_fh_to_parent,
-	.get_parent		= xfs_fs_get_parent,
-	.commit_metadata	= xfs_fs_nfs_commit_metadata,
+	.encode_fh		= xfs_encode_fh,
+	.fh_to_dentry		= xfs_fh_to_dentry,
+	.fh_to_parent		= xfs_fh_to_parent,
+	.get_parent		= xfs_get_parent,
+	.commit_metadata	= xfs_nfs_commit_metadata,
 };
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c4559c6..da9c4c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -571,7 +571,7 @@ restart:
 
 	/*
 	 * Updating the timestamps will grab the ilock again from
-	 * xfs_fs_dirty_inode, so we have to call it after dropping the
+	 * xfs_dirty_inode, so we have to call it after dropping the
 	 * lock above.  Eventually we should look into a way to avoid
 	 * the pointless lock roundtrip.
 	 */
diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
deleted file mode 100644
index 652b875..0000000
--- a/fs/xfs/xfs_fs_subr.c
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_vnodeops.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-#include "xfs_trace.h"
-
-/*
- * note: all filemap functions return negative error codes. These
- * need to be inverted before returning to the xfs core functions.
- */
-void
-xfs_tosspages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	/* can't toss partial tail pages, so mask them out */
-	last &= ~(PAGE_SIZE - 1);
-	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
-}
-
-int
-xfs_flushinval_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-
-	trace_xfs_pagecache_inval(ip, first, last);
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = filemap_write_and_wait_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	if (!ret)
-		truncate_inode_pages_range(mapping, first, last);
-	return -ret;
-}
-
-int
-xfs_flush_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	uint64_t	flags,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-	int		ret2;
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = -filemap_fdatawrite_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	if (flags & XBF_ASYNC)
-		return ret;
-	ret2 = xfs_wait_on_pages(ip, first, last);
-	if (!ret)
-		ret = ret2;
-	return ret;
-}
-
-int
-xfs_wait_on_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-
-	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
-		return -filemap_fdatawait_range(mapping, first,
-					last == -1 ? XFS_ISIZE(ip) - 1 : last);
-	}
-	return 0;
-}
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c25b094..09c39c5 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -45,7 +45,7 @@
  */
 
 int
-xfs_fs_geometry(
+xfs_geometry(
 	xfs_mount_t		*mp,
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
@@ -496,7 +496,7 @@ xfs_growfs_log(
  */
 
 int
-xfs_fs_counts(
+xfs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
 {
@@ -638,7 +638,7 @@ out:
  * and can be written back.
  */
 int
-xfs_fs_log_dummy(
+xfs_log_dummy(
 	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
@@ -659,7 +659,7 @@ xfs_fs_log_dummy(
 }
 
 int
-xfs_fs_goingdown(
+xfs_goingdown(
 	xfs_mount_t	*mp,
 	__uint32_t	inflags)
 {
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 1b6a98b..3a24888 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -18,13 +18,13 @@
 #ifndef __XFS_FSOPS_H__
 #define	__XFS_FSOPS_H__
 
-extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_t *geo, int nversion);
+extern int xfs_geometry(xfs_mount_t *mp, xfs_fsop_geom_t *geo, int nversion);
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
-extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
+extern int xfs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
-extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern int xfs_fs_log_dummy(struct xfs_mount *mp);
+extern int xfs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
+extern int xfs_log_dummy(struct xfs_mount *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3a05a41..fb61ec5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -702,14 +702,14 @@ xfs_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t         fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	error = xfs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return -error;
 
 	/*
 	 * Caller should have passed an argument of type
 	 * xfs_fsop_geom_v1_t.  This is a proper subset of the
-	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
+	 * xfs_fsop_geom_t that xfs_geometry() fills in.
 	 */
 	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
 		return -XFS_ERROR(EFAULT);
@@ -724,7 +724,7 @@ xfs_ioc_fsgeometry(
 	xfs_fsop_geom_t		fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 4);
+	error = xfs_geometry(mp, &fsgeo, 4);
 	if (error)
 		return -error;
 
@@ -1438,7 +1438,7 @@ xfs_file_ioctl(
 	case XFS_IOC_FSCOUNTS: {
 		xfs_fsop_counts_t out;
 
-		error = xfs_fs_counts(mp, &out);
+		error = xfs_counts(mp, &out);
 		if (error)
 			return -error;
 
@@ -1526,7 +1526,7 @@ xfs_file_ioctl(
 		if (get_user(in, (__uint32_t __user *)arg))
 			return -XFS_ERROR(EFAULT);
 
-		error = xfs_fs_goingdown(mp, in);
+		error = xfs_goingdown(mp, in);
 		return -error;
 	}
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4f2da0..0d6267e 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -71,7 +71,7 @@ xfs_compat_ioc_fsgeometry_v1(
 	xfs_fsop_geom_t		  fsgeo;
 	int			  error;
 
-	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	error = xfs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return -error;
 	/* The 32-bit variant simply has some padding at the end */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7f4f937..94e7aaf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -931,7 +931,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	int		needed = 0;
 	struct xlog	*log = mp->m_log;
 
-	if (!xfs_fs_writable(mp))
+	if (!xfs_writable(mp))
 		return 0;
 
 	spin_lock(&log->l_icloglock);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9536fd1..359a695 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1540,7 +1540,7 @@ xfs_unmountfs(
 }
 
 int
-xfs_fs_writable(xfs_mount_t *mp)
+xfs_writable(xfs_mount_t *mp)
 {
 	return !(xfs_test_for_freeze(mp) || XFS_FORCED_SHUTDOWN(mp) ||
 		(mp->m_flags & XFS_MOUNT_RDONLY));
@@ -1561,7 +1561,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	xfs_trans_t	*tp;
 	int		error;
 
-	if (!xfs_fs_writable(mp))
+	if (!xfs_writable(mp))
 		return 0;
 
 	xfs_icsb_sync_counters(mp, 0);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8724336..76ce45a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -383,7 +383,7 @@ extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
-extern int	xfs_fs_writable(xfs_mount_t *);
+extern int	xfs_writable(xfs_mount_t *);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index fed504f..18f64b0 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -42,7 +42,7 @@ xfs_quota_type(int type)
 }
 
 STATIC int
-xfs_fs_get_xstate(
+xfs_get_xstate(
 	struct super_block	*sb,
 	struct fs_quota_stat	*fqs)
 {
@@ -54,7 +54,7 @@ xfs_fs_get_xstate(
 }
 
 STATIC int
-xfs_fs_set_xstate(
+xfs_set_xstate(
 	struct super_block	*sb,
 	unsigned int		uflags,
 	int			op)
@@ -95,7 +95,7 @@ xfs_fs_set_xstate(
 }
 
 STATIC int
-xfs_fs_get_dqblk(
+xfs_get_dqblk(
 	struct super_block	*sb,
 	int			type,
 	qid_t			id,
@@ -112,7 +112,7 @@ xfs_fs_get_dqblk(
 }
 
 STATIC int
-xfs_fs_set_dqblk(
+xfs_set_dqblk(
 	struct super_block	*sb,
 	int			type,
 	qid_t			id,
@@ -131,8 +131,8 @@ xfs_fs_set_dqblk(
 }
 
 const struct quotactl_ops xfs_quotactl_operations = {
-	.get_xstate		= xfs_fs_get_xstate,
-	.set_xstate		= xfs_fs_set_xstate,
-	.get_dqblk		= xfs_fs_get_dqblk,
-	.set_dqblk		= xfs_fs_set_dqblk,
+	.get_xstate		= xfs_get_xstate,
+	.set_xstate		= xfs_set_xstate,
+	.get_dqblk		= xfs_get_dqblk,
+	.set_dqblk		= xfs_set_dqblk,
 };
diff --git a/fs/xfs/xfs_subr.c b/fs/xfs/xfs_subr.c
new file mode 100644
index 0000000..652b875
--- /dev/null
+++ b/fs/xfs/xfs_subr.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2000-2002,2005-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_vnodeops.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trace.h"
+
+/*
+ * note: all filemap functions return negative error codes. These
+ * need to be inverted before returning to the xfs core functions.
+ */
+void
+xfs_tosspages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	int		fiopt)
+{
+	/* can't toss partial tail pages, so mask them out */
+	last &= ~(PAGE_SIZE - 1);
+	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
+}
+
+int
+xfs_flushinval_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	int		fiopt)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+	int		ret = 0;
+
+	trace_xfs_pagecache_inval(ip, first, last);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	ret = filemap_write_and_wait_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
+	if (!ret)
+		truncate_inode_pages_range(mapping, first, last);
+	return -ret;
+}
+
+int
+xfs_flush_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	uint64_t	flags,
+	int		fiopt)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+	int		ret = 0;
+	int		ret2;
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	ret = -filemap_fdatawrite_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
+	if (flags & XBF_ASYNC)
+		return ret;
+	ret2 = xfs_wait_on_pages(ip, first, last);
+	if (!ret)
+		ret = ret2;
+	return ret;
+}
+
+int
+xfs_wait_on_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+		return -filemap_fdatawait_range(mapping, first,
+					last == -1 ? XFS_ISIZE(ip) - 1 : last);
+	}
+	return 0;
+}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36d139b..3b0ada2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -538,7 +538,7 @@ free_orig:
 }
 
 STATIC int
-xfs_fs_show_options(
+xfs_show_options(
 	struct seq_file		*seq,
 	struct dentry		*dentry)
 {
@@ -856,7 +856,7 @@ xfs_destroy_mount_workqueues(
 
 /* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
-xfs_fs_alloc_inode(
+xfs_alloc_inode(
 	struct super_block	*sb)
 {
 	BUG();
@@ -868,7 +868,7 @@ xfs_fs_alloc_inode(
  * the linux inode, we can reclaim the inode.
  */
 STATIC void
-xfs_fs_destroy_inode(
+xfs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -909,7 +909,7 @@ out_reclaim:
  * when freeing the inode.
  */
 STATIC void
-xfs_fs_inode_init_once(
+xfs_inode_init_once(
 	void			*inode)
 {
 	struct xfs_inode	*ip = inode;
@@ -940,7 +940,7 @@ xfs_fs_inode_init_once(
  * error handling here.
  */
 STATIC void
-xfs_fs_dirty_inode(
+xfs_dirty_inode(
 	struct inode		*inode,
 	int			flags)
 {
@@ -983,7 +983,7 @@ trouble:
 }
 
 STATIC void
-xfs_fs_evict_inode(
+xfs_evict_inode(
 	struct inode		*inode)
 {
 	xfs_inode_t		*ip = XFS_I(inode);
@@ -1023,7 +1023,7 @@ xfs_fs_evict_inode(
  * we drop the final reference on.
  */
 STATIC int
-xfs_fs_drop_inode(
+xfs_drop_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1041,7 +1041,7 @@ xfs_free_fsname(
 }
 
 STATIC void
-xfs_fs_put_super(
+xfs_put_super(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
@@ -1058,7 +1058,7 @@ xfs_fs_put_super(
 }
 
 STATIC int
-xfs_fs_sync_fs(
+xfs_sync_fs(
 	struct super_block	*sb,
 	int			wait)
 {
@@ -1088,7 +1088,7 @@ xfs_fs_sync_fs(
 }
 
 STATIC int
-xfs_fs_statfs(
+xfs_statfs(
 	struct dentry		*dentry,
 	struct kstatfs		*statp)
 {
@@ -1159,7 +1159,7 @@ xfs_restore_resvblks(struct xfs_mount *mp)
 }
 
 STATIC int
-xfs_fs_remount(
+xfs_remount(
 	struct super_block	*sb,
 	int			*flags,
 	char			*options)
@@ -1260,18 +1260,18 @@ xfs_fs_remount(
  * record to dirty the log in case of a crash while frozen.
  */
 STATIC int
-xfs_fs_freeze(
+xfs_freeze(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return -xfs_fs_log_dummy(mp);
+	return -xfs_log_dummy(mp);
 }
 
 STATIC int
-xfs_fs_unfreeze(
+xfs_unfreeze(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
@@ -1331,7 +1331,7 @@ xfs_finish_flags(
 }
 
 STATIC int
-xfs_fs_fill_super(
+xfs_fill_super(
 	struct super_block	*sb,
 	void			*data,
 	int			silent)
@@ -1460,24 +1460,24 @@ out_destroy_workqueues:
 }
 
 STATIC struct dentry *
-xfs_fs_mount(
+xfs_mount(
 	struct file_system_type	*fs_type,
 	int			flags,
 	const char		*dev_name,
 	void			*data)
 {
-	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
+	return mount_bdev(fs_type, flags, dev_name, data, xfs_fill_super);
 }
 
 static int
-xfs_fs_nr_cached_objects(
+xfs_nr_cached_objects(
 	struct super_block	*sb)
 {
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
 static void
-xfs_fs_free_cached_objects(
+xfs_free_cached_objects(
 	struct super_block	*sb,
 	int			nr_to_scan)
 {
@@ -1485,26 +1485,26 @@ xfs_fs_free_cached_objects(
 }
 
 static const struct super_operations xfs_super_operations = {
-	.alloc_inode		= xfs_fs_alloc_inode,
-	.destroy_inode		= xfs_fs_destroy_inode,
-	.dirty_inode		= xfs_fs_dirty_inode,
-	.evict_inode		= xfs_fs_evict_inode,
-	.drop_inode		= xfs_fs_drop_inode,
-	.put_super		= xfs_fs_put_super,
-	.sync_fs		= xfs_fs_sync_fs,
-	.freeze_fs		= xfs_fs_freeze,
-	.unfreeze_fs		= xfs_fs_unfreeze,
-	.statfs			= xfs_fs_statfs,
-	.remount_fs		= xfs_fs_remount,
-	.show_options		= xfs_fs_show_options,
-	.nr_cached_objects	= xfs_fs_nr_cached_objects,
-	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.alloc_inode		= xfs_alloc_inode,
+	.destroy_inode		= xfs_destroy_inode,
+	.dirty_inode		= xfs_dirty_inode,
+	.evict_inode		= xfs_evict_inode,
+	.drop_inode		= xfs_drop_inode,
+	.put_super		= xfs_put_super,
+	.sync_fs		= xfs_sync_fs,
+	.freeze_fs		= xfs_freeze,
+	.unfreeze_fs		= xfs_unfreeze,
+	.statfs			= xfs_statfs,
+	.remount_fs		= xfs_remount,
+	.show_options		= xfs_show_options,
+	.nr_cached_objects	= xfs_nr_cached_objects,
+	.free_cached_objects	= xfs_free_cached_objects,
 };
 
-static struct file_system_type xfs_fs_type = {
+static struct file_system_type xfs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "xfs",
-	.mount			= xfs_fs_mount,
+	.mount			= xfs_mount,
 	.kill_sb		= kill_block_super,
 	.fs_flags		= FS_REQUIRES_DEV,
 };
@@ -1586,7 +1586,7 @@ xfs_init_zones(void)
 	xfs_inode_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
 			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD,
-			xfs_fs_inode_init_once);
+			xfs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
@@ -1730,7 +1730,7 @@ init_xfs_fs(void)
 	if (error)
 		goto out_sysctl_unregister;
 
-	error = register_filesystem(&xfs_fs_type);
+	error = register_filesystem(&xfs_type);
 	if (error)
 		goto out_qm_exit;
 	return 0;
@@ -1759,7 +1759,7 @@ STATIC void __exit
 exit_xfs_fs(void)
 {
 	xfs_qm_exit();
-	unregister_filesystem(&xfs_fs_type);
+	unregister_filesystem(&xfs_type);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 1e9ee06..bc64705 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -314,7 +314,7 @@ xfs_quiesce_data(
 
 	/* mark the log as covered if needed */
 	if (xfs_log_need_covered(mp))
-		error2 = xfs_fs_log_dummy(mp);
+		error2 = xfs_log_dummy(mp);
 
 	return error ? error : error2;
 }
@@ -396,7 +396,7 @@ xfs_sync_worker(
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
 		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
+			error = xfs_log_dummy(mp);
 		else
 			xfs_log_force(mp, 0);
 
-- 
1.7.9.2.323.gf051a

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
