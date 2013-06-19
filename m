Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E299C7FC9
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD990304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4i5MEOeXf25HlD0p for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:10 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4e-0003CF-IK
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4U-0000FZ-4U
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/50] xfs: introduce xfs_inode_buf.c for inode buffer
	operations
Date: Wed, 19 Jun 2013 15:35:51 +1000
Message-Id: <1371620173-712-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The only thing remaining in xfs_inode.[ch] are the operations that
read, write or verify physical inodes in their underlying buffers.
Move all this code to xfs_inode_buf.[ch] and so we can stop sharing
xfs_inode.[ch] with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile        |    2 +-
 include/libxfs.h        |    2 +-
 include/xfs_inode.h     |   58 -------
 include/xfs_inode_buf.h |   52 ++++++
 libxfs/Makefile         |    2 +-
 libxfs/init.c           |    3 +-
 libxfs/xfs_inode.c      |  434 -----------------------------------------------
 libxfs/xfs_inode_buf.c  |  430 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 487 insertions(+), 496 deletions(-)
 delete mode 100644 include/xfs_inode.h
 create mode 100644 include/xfs_inode_buf.h
 delete mode 100644 libxfs/xfs_inode.c
 create mode 100644 libxfs/xfs_inode_buf.c

diff --git a/include/Makefile b/include/Makefile
index d2a94f1..1920190 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -27,7 +27,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
 	xfs_icreate_item.h \
-	xfs_inode.h \
+	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_item_format.h \
 	xfs_inum.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index c3c24f6..5e78378 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -48,7 +48,7 @@
 #include <xfs/xfs_dinode.h>
 #include <xfs/xfs_inode_fork.h>
 #include <xfs/xfs_inode_item_format.h>
-#include <xfs/xfs_inode.h>
+#include <xfs/xfs_inode_buf.h>
 #include <xfs/xfs_buf_item_format.h>
 #include <xfs/xfs_alloc.h>
 #include <xfs/xfs_btree.h>
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
deleted file mode 100644
index ec092b1..0000000
--- a/include/xfs_inode.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef	__XFS_INODE_H__
-#define	__XFS_INODE_H__
-
-struct posix_acl;
-struct xfs_dinode;
-struct xfs_inode;
-
-/*
- * Inode location information.  Stored in the inode and passed to
- * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
- */
-struct xfs_imap {
-	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
-	ushort		im_len;		/* length in BBs of inode chunk */
-	ushort		im_boffset;	/* inode offset in block in bytes */
-};
-
-#ifdef __KERNEL__
-
-#include "xfs_inode_ops.h"
-
-#endif /* __KERNEL__ */
-
-int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
-			       struct xfs_imap *, struct xfs_dinode **,
-			       struct xfs_buf **, uint, uint);
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
-			  struct xfs_inode *, uint);
-void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void		xfs_dinode_to_disk(struct xfs_dinode *,
-				   struct xfs_icdinode *);
-
-#if defined(DEBUG)
-void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
-#else
-#define	xfs_inobp_check(mp, bp)
-#endif /* DEBUG */
-
-extern const struct xfs_buf_ops xfs_inode_buf_ops;
-
-#endif	/* __XFS_INODE_H__ */
diff --git a/include/xfs_inode_buf.h b/include/xfs_inode_buf.h
new file mode 100644
index 0000000..aae9fc4
--- /dev/null
+++ b/include/xfs_inode_buf.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
+#ifndef	__XFS_INODE_BUF_H__
+#define	__XFS_INODE_BUF_H__
+
+struct xfs_inode;
+struct xfs_dinode;
+struct xfs_icdinode;
+
+/*
+ * Inode location information.  Stored in the inode and passed to
+ * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
+ */
+struct xfs_imap {
+	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
+	ushort		im_len;		/* length in BBs of inode chunk */
+	ushort		im_boffset;	/* inode offset in block in bytes */
+};
+
+int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
+			       struct xfs_imap *, struct xfs_dinode **,
+			       struct xfs_buf **, uint, uint);
+int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
+			  struct xfs_inode *, uint);
+void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
+void		xfs_dinode_to_disk(struct xfs_dinode *,
+				   struct xfs_icdinode *);
+
+#if defined(DEBUG)
+void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
+#else
+#define	xfs_inobp_check(mp, bp)
+#endif /* DEBUG */
+
+extern const struct xfs_buf_ops xfs_inode_buf_ops;
+
+#endif	/* __XFS_INODE_BUF_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index a4ccb03..2cb3725 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -13,7 +13,7 @@ LT_AGE = 0
 HFILES = xfs.h init.h xfs_dir2_priv.h crc32defs.h crc32table.h
 CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_alloc.c xfs_ialloc.c \
-	xfs_inode.c \
+	xfs_inode_buf.c \
 	xfs_inode_fork.c \
 	xfs_btree.c xfs_alloc_btree.c \
 	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index cd5b8a0..db7eeea 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -32,6 +32,8 @@ int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
 
 static void manage_zones(int);	/* setup global zones */
 
+kmem_zone_t	*xfs_inode_zone;
+
 /*
  * dev_map - map open devices to fd.
  */
@@ -369,7 +371,6 @@ manage_zones(int release)
 {
 	extern kmem_zone_t	*xfs_buf_zone;
 	extern kmem_zone_t	*xfs_ili_zone;
-	extern kmem_zone_t	*xfs_inode_zone;
 	extern kmem_zone_t	*xfs_ifork_zone;
 	extern kmem_zone_t	*xfs_buf_item_zone;
 	extern kmem_zone_t	*xfs_da_state_zone;
diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
deleted file mode 100644
index 9f9f538..0000000
--- a/libxfs/xfs_inode.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-
-#include <xfs.h>
-
-kmem_zone_t *xfs_inode_zone;
-
-/*
- * Check that none of the inode's in the buffer have a next
- * unlinked field of 0.
- */
-#if defined(DEBUG)
-STATIC void
-xfs_inobp_check(
-	xfs_mount_t	*mp,
-	xfs_buf_t	*bp)
-{
-	int		i;
-	int		j;
-	xfs_dinode_t	*dip;
-
-	j = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
-
-	for (i = 0; i < j; i++) {
-		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
-					i * mp->m_sb.sb_inodesize);
-		if (!dip->di_next_unlinked)  {
-			xfs_alert(mp,
-	"Detected bogus zero next_unlinked field in incore inode buffer 0x%p.",
-				bp);
-			ASSERT(dip->di_next_unlinked);
-		}
-	}
-}
-#endif
-
-static void
-xfs_inode_buf_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	int		i;
-	int		ni;
-
-	/*
-	 * Validate the magic number and version of every inode in the buffer
-	 */
-	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
-	for (i = 0; i < ni; i++) {
-		int		di_ok;
-		xfs_dinode_t	*dip;
-
-		dip = (struct xfs_dinode *)xfs_buf_offset(bp,
-					(i << mp->m_sb.sb_inodelog));
-		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_version);
-		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
-						XFS_ERRTAG_ITOBP_INOTOBP,
-						XFS_RANDOM_ITOBP_INOTOBP))) {
-			xfs_buf_ioerror(bp, EFSCORRUPTED);
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
-					     mp, dip);
-#ifdef DEBUG
-			xfs_emerg(mp,
-				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
-				(unsigned long long)bp->b_bn, i,
-				be16_to_cpu(dip->di_magic));
-			ASSERT(0);
-#endif
-		}
-	}
-	xfs_inobp_check(mp, bp);
-}
-
-
-static void
-xfs_inode_buf_read_verify(
-	struct xfs_buf	*bp)
-{
-	xfs_inode_buf_verify(bp);
-}
-
-static void
-xfs_inode_buf_write_verify(
-	struct xfs_buf	*bp)
-{
-	xfs_inode_buf_verify(bp);
-}
-
-const struct xfs_buf_ops xfs_inode_buf_ops = {
-	.verify_read = xfs_inode_buf_read_verify,
-	.verify_write = xfs_inode_buf_write_verify,
-};
-
-
-/*
- * This routine is called to map an inode to the buffer containing the on-disk
- * version of the inode.  It returns a pointer to the buffer containing the
- * on-disk inode in the bpp parameter, and in the dipp parameter it returns a
- * pointer to the on-disk inode within that buffer.
- *
- * If a non-zero error is returned, then the contents of bpp and dipp are
- * undefined.
- */
-int
-xfs_imap_to_bp(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_imap		*imap,
-	struct xfs_dinode       **dipp,
-	struct xfs_buf		**bpp,
-	uint			buf_flags,
-	uint			iget_flags)
-{
-	struct xfs_buf		*bp;
-	int			error;
-
-	buf_flags |= XBF_UNMAPPED;
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   (int)imap->im_len, buf_flags, &bp,
-				   &xfs_inode_buf_ops);
-	if (error) {
-		if (error == EAGAIN) {
-			ASSERT(buf_flags & XBF_TRYLOCK);
-			return error;
-		}
-
-		if (error == EFSCORRUPTED &&
-		    (iget_flags & XFS_IGET_UNTRUSTED))
-			return XFS_ERROR(EINVAL);
-
-		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
-			__func__, error);
-		return error;
-	}
-
-	*bpp = bp;
-	*dipp = (struct xfs_dinode *)xfs_buf_offset(bp, imap->im_boffset);
-	return 0;
-}
-
-void
-xfs_dinode_from_disk(
-	xfs_icdinode_t		*to,
-	xfs_dinode_t		*from)
-{
-	to->di_magic = be16_to_cpu(from->di_magic);
-	to->di_mode = be16_to_cpu(from->di_mode);
-	to->di_version = from ->di_version;
-	to->di_format = from->di_format;
-	to->di_onlink = be16_to_cpu(from->di_onlink);
-	to->di_uid = be32_to_cpu(from->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	to->di_nlink = be32_to_cpu(from->di_nlink);
-	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
-	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
-	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
-	to->di_atime.t_nsec = be32_to_cpu(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = be32_to_cpu(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = be32_to_cpu(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = be32_to_cpu(from->di_ctime.t_nsec);
-	to->di_size = be64_to_cpu(from->di_size);
-	to->di_nblocks = be64_to_cpu(from->di_nblocks);
-	to->di_extsize = be32_to_cpu(from->di_extsize);
-	to->di_nextents = be32_to_cpu(from->di_nextents);
-	to->di_anextents = be16_to_cpu(from->di_anextents);
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat	= from->di_aformat;
-	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
-	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
-	to->di_flags	= be16_to_cpu(from->di_flags);
-	to->di_gen	= be32_to_cpu(from->di_gen);
-
-	if (to->di_version == 3) {
-		to->di_changecount = be64_to_cpu(from->di_changecount);
-		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
-		to->di_flags2 = be64_to_cpu(from->di_flags2);
-		to->di_ino = be64_to_cpu(from->di_ino);
-		to->di_lsn = be64_to_cpu(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
-	}
-}
-
-void
-xfs_dinode_to_disk(
-	xfs_dinode_t		*to,
-	xfs_icdinode_t		*from)
-{
-	to->di_magic = cpu_to_be16(from->di_magic);
-	to->di_mode = cpu_to_be16(from->di_mode);
-	to->di_version = from ->di_version;
-	to->di_format = from->di_format;
-	to->di_onlink = cpu_to_be16(from->di_onlink);
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_nlink = cpu_to_be32(from->di_nlink);
-	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
-	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-	to->di_flushiter = cpu_to_be16(from->di_flushiter);
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
-	to->di_size = cpu_to_be64(from->di_size);
-	to->di_nblocks = cpu_to_be64(from->di_nblocks);
-	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
-	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
-	to->di_dmstate = cpu_to_be16(from->di_dmstate);
-	to->di_flags = cpu_to_be16(from->di_flags);
-	to->di_gen = cpu_to_be32(from->di_gen);
-
-	if (from->di_version == 3) {
-		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
-		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_ino = cpu_to_be64(from->di_ino);
-		to->di_lsn = cpu_to_be64(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
-	}
-}
-
-static bool
-xfs_dinode_verify(
-	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
-	struct xfs_dinode	*dip)
-{
-	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
-		return false;
-
-	/* only version 3 or greater inodes are extensively verified here */
-	if (dip->di_version < 3)
-		return true;
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
-	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      offsetof(struct xfs_dinode, di_crc)))
-		return false;
-	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
-		return false;
-	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
-		return false;
-	return true;
-}
-
-void
-xfs_dinode_calc_crc(
-	struct xfs_mount	*mp,
-	struct xfs_dinode	*dip)
-{
-	__uint32_t		crc;
-
-	if (dip->di_version < 3)
-		return;
-
-	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
-	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
-			      offsetof(struct xfs_dinode, di_crc));
-	dip->di_crc = xfs_end_cksum(crc);
-}
-
-/*
- * Read the disk inode attributes into the in-core inode structure.
- *
- * If we are initialising a new inode and we are not utilising the
- * XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new inode core
- * with a random generation number. If we are keeping inodes around, we need to
- * read the inode cluster to get the existing generation number off disk.
- */
-int
-xfs_iread(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	uint		iget_flags)
-{
-	xfs_buf_t	*bp;
-	xfs_dinode_t	*dip;
-	int		error;
-
-	/*
-	 * Fill in the location information in the in-core inode.
-	 */
-	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
-	if (error)
-		return error;
-
-	/* shortcut IO on inode allocation if possible */
-	if ((iget_flags & XFS_IGET_CREATE) &&
-	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
-		/* initialise the on-disk inode core */
-		memset(&ip->i_d, 0, sizeof(ip->i_d));
-		ip->i_d.di_magic = XFS_DINODE_MAGIC;
-		ip->i_d.di_gen = prandom_u32();
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			ip->i_d.di_version = 3;
-			ip->i_d.di_ino = ip->i_ino;
-			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
-		} else
-			ip->i_d.di_version = 2;
-		return 0;
-	}
-
-	/*
-	 * Get pointers to the on-disk inode and the buffer containing it.
-	 */
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0, iget_flags);
-	if (error)
-		return error;
-
-	/* even unallocated inodes are verified */
-	if (!xfs_dinode_verify(mp, ip, dip)) {
-		xfs_alert(mp, "%s: validation failed for inode %lld failed",
-				__func__, ip->i_ino);
-
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
-		error = XFS_ERROR(EFSCORRUPTED);
-		goto out_brelse;
-	}
-
-	/*
-	 * If the on-disk inode is already linked to a directory
-	 * entry, copy all of the inode into the in-core inode.
-	 * xfs_iformat_fork() handles copying in the inode format
-	 * specific information.
-	 * Otherwise, just get the truly permanent information.
-	 */
-	if (dip->di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, dip);
-		error = xfs_iformat_fork(ip, dip);
-		if (error)  {
-#ifdef DEBUG
-			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
-				__func__, error);
-#endif /* DEBUG */
-			goto out_brelse;
-		}
-	} else {
-		/*
-		 * Partial initialisation of the in-core inode. Just the bits
-		 * that xfs_ialloc won't overwrite or relies on being correct.
-		 */
-		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
-		ip->i_d.di_version = dip->di_version;
-		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
-		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
-
-		if (dip->di_version == 3) {
-			ip->i_d.di_ino = be64_to_cpu(dip->di_ino);
-			uuid_copy(&ip->i_d.di_uuid, &dip->di_uuid);
-		}
-
-		/*
-		 * Make sure to pull in the mode here as well in
-		 * case the inode is released without being used.
-		 * This ensures that xfs_inactive() will see that
-		 * the inode is already free and not try to mess
-		 * with the uninitialized part of it.
-		 */
-		ip->i_d.di_mode = 0;
-	}
-
-	/*
-	 * The inode format changed when we moved the link count and
-	 * made it 32 bits long.  If this is an old format inode,
-	 * convert it in memory to look like a new one.  If it gets
-	 * flushed to disk we will convert back before flushing or
-	 * logging it.  We zero out the new projid field and the old link
-	 * count field.  We'll handle clearing the pad field (the remains
-	 * of the old uuid field) when we actually convert the inode to
-	 * the new format. We don't change the version number so that we
-	 * can distinguish this from a real new format inode.
-	 */
-	if (ip->i_d.di_version == 1) {
-		ip->i_d.di_nlink = ip->i_d.di_onlink;
-		ip->i_d.di_onlink = 0;
-		xfs_set_projid(&ip->i_d, 0);
-	}
-
-	ip->i_delayed_blks = 0;
-
-	/*
-	 * Mark the buffer containing the inode as something to keep
-	 * around for a while.  This helps to keep recently accessed
-	 * meta-data in-core longer.
-	 */
-	xfs_buf_set_ref(bp, XFS_INO_REF);
-
-	/*
-	 * Use xfs_trans_brelse() to release the buffer containing the on-disk
-	 * inode, because it was acquired with xfs_trans_read_buf() in
-	 * xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
-	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
-	 * will only release the buffer if it is not dirty within the
-	 * transaction.  It will be OK to release the buffer in this case,
-	 * because inodes on disk are never destroyed and we will be locking the
-	 * new in-core inode before putting it in the cache where other
-	 * processes can find it.  Thus we don't have to worry about the inode
-	 * being changed just because we released the buffer.
-	 */
- out_brelse:
-	xfs_trans_brelse(tp, bp);
-	return error;
-}
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
new file mode 100644
index 0000000..96299e7
--- /dev/null
+++ b/libxfs/xfs_inode_buf.c
@@ -0,0 +1,430 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
+
+#include <xfs.h>
+
+/*
+ * Check that none of the inode's in the buffer have a next
+ * unlinked field of 0.
+ */
+#if defined(DEBUG)
+STATIC void
+xfs_inobp_check(
+	xfs_mount_t	*mp,
+	xfs_buf_t	*bp)
+{
+	int		i;
+	int		j;
+	xfs_dinode_t	*dip;
+
+	j = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
+
+	for (i = 0; i < j; i++) {
+		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
+					i * mp->m_sb.sb_inodesize);
+		if (!dip->di_next_unlinked)  {
+			xfs_alert(mp,
+	"Detected bogus zero next_unlinked field in incore inode buffer 0x%p.",
+				bp);
+			ASSERT(dip->di_next_unlinked);
+		}
+	}
+}
+#endif
+
+static void
+xfs_inode_buf_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	int		i;
+	int		ni;
+
+	/*
+	 * Validate the magic number and version of every inode in the buffer
+	 */
+	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
+	for (i = 0; i < ni; i++) {
+		int		di_ok;
+		xfs_dinode_t	*dip;
+
+		dip = (struct xfs_dinode *)xfs_buf_offset(bp,
+					(i << mp->m_sb.sb_inodelog));
+		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_version);
+		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
+						XFS_ERRTAG_ITOBP_INOTOBP,
+						XFS_RANDOM_ITOBP_INOTOBP))) {
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
+					     mp, dip);
+#ifdef DEBUG
+			xfs_emerg(mp,
+				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
+				(unsigned long long)bp->b_bn, i,
+				be16_to_cpu(dip->di_magic));
+			ASSERT(0);
+#endif
+		}
+	}
+	xfs_inobp_check(mp, bp);
+}
+
+static void
+xfs_inode_buf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inode_buf_verify(bp);
+}
+
+static void
+xfs_inode_buf_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inode_buf_verify(bp);
+}
+
+const struct xfs_buf_ops xfs_inode_buf_ops = {
+	.verify_read = xfs_inode_buf_read_verify,
+	.verify_write = xfs_inode_buf_write_verify,
+};
+
+/*
+ * This routine is called to map an inode to the buffer containing the on-disk
+ * version of the inode.  It returns a pointer to the buffer containing the
+ * on-disk inode in the bpp parameter, and in the dipp parameter it returns a
+ * pointer to the on-disk inode within that buffer.
+ *
+ * If a non-zero error is returned, then the contents of bpp and dipp are
+ * undefined.
+ */
+int
+xfs_imap_to_bp(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_imap		*imap,
+	struct xfs_dinode       **dipp,
+	struct xfs_buf		**bpp,
+	uint			buf_flags,
+	uint			iget_flags)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	buf_flags |= XBF_UNMAPPED;
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+				   (int)imap->im_len, buf_flags, &bp,
+				   &xfs_inode_buf_ops);
+	if (error) {
+		if (error == EAGAIN) {
+			ASSERT(buf_flags & XBF_TRYLOCK);
+			return error;
+		}
+
+		if (error == EFSCORRUPTED &&
+		    (iget_flags & XFS_IGET_UNTRUSTED))
+			return XFS_ERROR(EINVAL);
+
+		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
+			__func__, error);
+		return error;
+	}
+
+	*bpp = bp;
+	*dipp = (struct xfs_dinode *)xfs_buf_offset(bp, imap->im_boffset);
+	return 0;
+}
+
+void
+xfs_dinode_from_disk(
+	xfs_icdinode_t		*to,
+	xfs_dinode_t		*from)
+{
+	to->di_magic = be16_to_cpu(from->di_magic);
+	to->di_mode = be16_to_cpu(from->di_mode);
+	to->di_version = from ->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = be16_to_cpu(from->di_onlink);
+	to->di_uid = be32_to_cpu(from->di_uid);
+	to->di_gid = be32_to_cpu(from->di_gid);
+	to->di_nlink = be32_to_cpu(from->di_nlink);
+	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
+	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
+	to->di_atime.t_nsec = be32_to_cpu(from->di_atime.t_nsec);
+	to->di_mtime.t_sec = be32_to_cpu(from->di_mtime.t_sec);
+	to->di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
+	to->di_ctime.t_sec = be32_to_cpu(from->di_ctime.t_sec);
+	to->di_ctime.t_nsec = be32_to_cpu(from->di_ctime.t_nsec);
+	to->di_size = be64_to_cpu(from->di_size);
+	to->di_nblocks = be64_to_cpu(from->di_nblocks);
+	to->di_extsize = be32_to_cpu(from->di_extsize);
+	to->di_nextents = be32_to_cpu(from->di_nextents);
+	to->di_anextents = be16_to_cpu(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat	= from->di_aformat;
+	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
+	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
+	to->di_flags	= be16_to_cpu(from->di_flags);
+	to->di_gen	= be32_to_cpu(from->di_gen);
+
+	if (to->di_version == 3) {
+		to->di_changecount = be64_to_cpu(from->di_changecount);
+		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_flags2 = be64_to_cpu(from->di_flags2);
+		to->di_ino = be64_to_cpu(from->di_ino);
+		to->di_lsn = be64_to_cpu(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+	}
+}
+
+void
+xfs_dinode_to_disk(
+	xfs_dinode_t		*to,
+	xfs_icdinode_t		*from)
+{
+	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_mode = cpu_to_be16(from->di_mode);
+	to->di_version = from ->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = cpu_to_be16(from->di_onlink);
+	to->di_uid = cpu_to_be32(from->di_uid);
+	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_nlink = cpu_to_be32(from->di_nlink);
+	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
+	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+	to->di_flushiter = cpu_to_be16(from->di_flushiter);
+	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
+	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
+	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
+	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
+	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
+	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	to->di_size = cpu_to_be64(from->di_size);
+	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_nextents = cpu_to_be32(from->di_nextents);
+	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_gen = cpu_to_be32(from->di_gen);
+
+	if (from->di_version == 3) {
+		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_ino = cpu_to_be64(from->di_ino);
+		to->di_lsn = cpu_to_be64(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+	}
+}
+
+static bool
+xfs_dinode_verify(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
+		return false;
+
+	/* only version 3 or greater inodes are extensively verified here */
+	if (dip->di_version < 3)
+		return true;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+			      offsetof(struct xfs_dinode, di_crc)))
+		return false;
+	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
+		return false;
+	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	return true;
+}
+
+void
+xfs_dinode_calc_crc(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	__uint32_t		crc;
+
+	if (dip->di_version < 3)
+		return;
+
+	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
+	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
+			      offsetof(struct xfs_dinode, di_crc));
+	dip->di_crc = xfs_end_cksum(crc);
+}
+
+/*
+ * Read the disk inode attributes into the in-core inode structure.
+ *
+ * If we are initialising a new inode and we are not utilising the
+ * XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new inode core
+ * with a random generation number. If we are keeping inodes around, we need to
+ * read the inode cluster to get the existing generation number off disk.
+ */
+int
+xfs_iread(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip,
+	uint		iget_flags)
+{
+	xfs_buf_t	*bp;
+	xfs_dinode_t	*dip;
+	int		error;
+
+	/*
+	 * Fill in the location information in the in-core inode.
+	 */
+	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
+	if (error)
+		return error;
+
+	/* shortcut IO on inode allocation if possible */
+	if ((iget_flags & XFS_IGET_CREATE) &&
+	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+		/* initialise the on-disk inode core */
+		memset(&ip->i_d, 0, sizeof(ip->i_d));
+		ip->i_d.di_magic = XFS_DINODE_MAGIC;
+		ip->i_d.di_gen = prandom_u32();
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			ip->i_d.di_version = 3;
+			ip->i_d.di_ino = ip->i_ino;
+			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		} else
+			ip->i_d.di_version = 2;
+		return 0;
+	}
+
+	/*
+	 * Get pointers to the on-disk inode and the buffer containing it.
+	 */
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0, iget_flags);
+	if (error)
+		return error;
+
+	/* even unallocated inodes are verified */
+	if (!xfs_dinode_verify(mp, ip, dip)) {
+		xfs_alert(mp, "%s: validation failed for inode %lld failed",
+				__func__, ip->i_ino);
+
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto out_brelse;
+	}
+
+	/*
+	 * If the on-disk inode is already linked to a directory
+	 * entry, copy all of the inode into the in-core inode.
+	 * xfs_iformat_fork() handles copying in the inode format
+	 * specific information.
+	 * Otherwise, just get the truly permanent information.
+	 */
+	if (dip->di_mode) {
+		xfs_dinode_from_disk(&ip->i_d, dip);
+		error = xfs_iformat_fork(ip, dip);
+		if (error)  {
+#ifdef DEBUG
+			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
+				__func__, error);
+#endif /* DEBUG */
+			goto out_brelse;
+		}
+	} else {
+		/*
+		 * Partial initialisation of the in-core inode. Just the bits
+		 * that xfs_ialloc won't overwrite or relies on being correct.
+		 */
+		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
+		ip->i_d.di_version = dip->di_version;
+		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
+		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
+
+		if (dip->di_version == 3) {
+			ip->i_d.di_ino = be64_to_cpu(dip->di_ino);
+			uuid_copy(&ip->i_d.di_uuid, &dip->di_uuid);
+		}
+
+		/*
+		 * Make sure to pull in the mode here as well in
+		 * case the inode is released without being used.
+		 * This ensures that xfs_inactive() will see that
+		 * the inode is already free and not try to mess
+		 * with the uninitialized part of it.
+		 */
+		ip->i_d.di_mode = 0;
+	}
+
+	/*
+	 * The inode format changed when we moved the link count and
+	 * made it 32 bits long.  If this is an old format inode,
+	 * convert it in memory to look like a new one.  If it gets
+	 * flushed to disk we will convert back before flushing or
+	 * logging it.  We zero out the new projid field and the old link
+	 * count field.  We'll handle clearing the pad field (the remains
+	 * of the old uuid field) when we actually convert the inode to
+	 * the new format. We don't change the version number so that we
+	 * can distinguish this from a real new format inode.
+	 */
+	if (ip->i_d.di_version == 1) {
+		ip->i_d.di_nlink = ip->i_d.di_onlink;
+		ip->i_d.di_onlink = 0;
+		xfs_set_projid(&ip->i_d, 0);
+	}
+
+	ip->i_delayed_blks = 0;
+
+	/*
+	 * Mark the buffer containing the inode as something to keep
+	 * around for a while.  This helps to keep recently accessed
+	 * meta-data in-core longer.
+	 */
+	xfs_buf_set_ref(bp, XFS_INO_REF);
+
+	/*
+	 * Use xfs_trans_brelse() to release the buffer containing the on-disk
+	 * inode, because it was acquired with xfs_trans_read_buf() in
+	 * xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
+	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
+	 * will only release the buffer if it is not dirty within the
+	 * transaction.  It will be OK to release the buffer in this case,
+	 * because inodes on disk are never destroyed and we will be locking the
+	 * new in-core inode before putting it in the cache where other
+	 * processes can find it.  Thus we don't have to worry about the inode
+	 * being changed just because we released the buffer.
+	 */
+ out_brelse:
+	xfs_trans_brelse(tp, bp);
+	return error;
+}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
