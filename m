Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B28F37FB3
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE78A8F8037
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4Hl2eTB21huAQsEg for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:11 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4o-0003Cg-OK
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4o-0000GT-K2
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 38/50] xfs: split out the remote symlink handling
Date: Wed, 19 Jun 2013 15:36:01 +1000
Message-Id: <1371620173-712-39-git-send-email-david@fromorbit.com>
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

The remote symlink format definition and manipulation needs to be
shared with userspace, but the in-kernel interfaces do not. Split
the remote symlink format handling out into xfs_symlink_remote.[ch]
fo it can easily be shared with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile             |    3 +-
 include/libxfs.h             |    2 +-
 include/xfs_symlink.h        |   67 ---------------
 include/xfs_symlink_remote.h |   60 ++++++++++++++
 libxfs/Makefile              |    4 +-
 libxfs/xfs_symlink.c         |  176 ----------------------------------------
 libxfs/xfs_symlink_remote.c  |  185 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 251 insertions(+), 246 deletions(-)
 delete mode 100644 include/xfs_symlink.h
 create mode 100644 include/xfs_symlink_remote.h
 delete mode 100644 libxfs/xfs_symlink.c
 create mode 100644 libxfs/xfs_symlink_remote.c

diff --git a/include/Makefile b/include/Makefile
index 265d07b..c434319 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -38,7 +38,8 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
 	xfs_quota.h \
 	xfs_dquot_format.h \
-	xfs_rtalloc.h xfs_sb.h xfs_symlink.h \
+	xfs_rtalloc.h xfs_sb.h \
+	xfs_symlink_remote.h \
 	xfs_trace.h \
 	xfs_trans_format.h \
 	xfs_trans_resv.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index aff56e5..0dbb3fc 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -55,7 +55,7 @@
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
-#include <xfs/xfs_symlink.h>
+#include <xfs/xfs_symlink_remote.h>
 #include <xfs/xfs_icreate_item_format.h>
 #include <xfs/xfs_trans_resv.h>
 #include <xfs/xfs_trans_format.h>
diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
deleted file mode 100644
index 4818edf..0000000
--- a/include/xfs_symlink.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
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
-#ifndef __XFS_SYMLINK_H
-#define __XFS_SYMLINK_H 1
-
-struct xfs_mount;
-struct xfs_trans;
-struct xfs_inode;
-struct xfs_buf;
-struct xfs_ifork;
-struct xfs_name;
-
-#define XFS_SYMLINK_MAGIC	0x58534c4d	/* XSLM */
-
-struct xfs_dsymlink_hdr {
-	__be32	sl_magic;
-	__be32	sl_offset;
-	__be32	sl_bytes;
-	__be32	sl_crc;
-	uuid_t	sl_uuid;
-	__be64	sl_owner;
-	__be64	sl_blkno;
-	__be64	sl_lsn;
-};
-
-/*
- * The maximum pathlen is 1024 bytes. Since the minimum file system
- * blocksize is 512 bytes, we can get a max of 3 extents back from
- * bmapi when crc headers are taken into account.
- */
-#define XFS_SYMLINK_MAPS 3
-
-#define XFS_SYMLINK_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
-			sizeof(struct xfs_dsymlink_hdr) : 0))
-
-int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
-bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-
-extern const struct xfs_buf_ops xfs_symlink_buf_ops;
-
-#ifdef __KERNEL__
-
-int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
-		const char *target_path, umode_t mode, struct xfs_inode **ipp);
-int xfs_readlink(struct xfs_inode *ip, char *link);
-int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
-
-#endif /* __KERNEL__ */
-#endif /* __XFS_SYMLINK_H */
diff --git a/include/xfs_symlink_remote.h b/include/xfs_symlink_remote.h
new file mode 100644
index 0000000..a49da42
--- /dev/null
+++ b/include/xfs_symlink_remote.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
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
+#ifndef __XFS_SYMLINK_REMOTE_H
+#define __XFS_SYMLINK_REMOTE_H 1
+
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_inode;
+struct xfs_buf;
+struct xfs_ifork;
+
+#define XFS_SYMLINK_MAGIC	0x58534c4d	/* XSLM */
+
+struct xfs_dsymlink_hdr {
+	__be32	sl_magic;
+	__be32	sl_offset;
+	__be32	sl_bytes;
+	__be32	sl_crc;
+	uuid_t	sl_uuid;
+	__be64	sl_owner;
+	__be64	sl_blkno;
+	__be64	sl_lsn;
+};
+
+/*
+ * The maximum pathlen is 1024 bytes. Since the minimum file system
+ * blocksize is 512 bytes, we can get a max of 3 extents back from
+ * bmapi when crc headers are taken into account.
+ */
+#define XFS_SYMLINK_MAPS 3
+
+#define XFS_SYMLINK_BUF_SPACE(mp, bufsize)	\
+	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
+			sizeof(struct xfs_dsymlink_hdr) : 0))
+
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+
+#endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 2cb3725..df0a5eb 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -20,7 +20,9 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
 	xfs_sb.c xfs_rtalloc.c xfs_attr.c xfs_attr_remote.c \
-	crc32.c xfs_symlink.c xfs_trans_resv.c
+	xfs_symlink_remote.c \
+	xfs_trans_resv.c \
+	crc32.c
 
 CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
diff --git a/libxfs/xfs_symlink.c b/libxfs/xfs_symlink.c
deleted file mode 100644
index f2e69f9..0000000
--- a/libxfs/xfs_symlink.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- * Copyright 2013 Red Hat, Inc.
- * All rights reserved.
- */
-
-#include "xfs.h"
-
-/*
- * Each contiguous block has a header, so it is not just a simple pathlen
- * to FSB conversion.
- */
-int
-xfs_symlink_blocks(
-	struct xfs_mount *mp,
-	int		pathlen)
-{
-	int buflen = XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
-
-	return (pathlen + buflen - 1) / buflen;
-}
-
-/*
- * This is used by mkfs/proto.c to create symlinks.
- */
-int
-xfs_symlink_hdr_set(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino,
-	uint32_t		offset,
-	uint32_t		size,
-	struct xfs_buf		*bp)
-{
-	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return 0;
-
-	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
-	dsl->sl_offset = cpu_to_be32(offset);
-	dsl->sl_bytes = cpu_to_be32(size);
-	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
-	dsl->sl_owner = cpu_to_be64(ino);
-	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
-	bp->b_ops = &xfs_symlink_buf_ops;
-
-	return sizeof(struct xfs_dsymlink_hdr);
-}
-
-/*
- * Checking of the symlink header is split into two parts. the verifier does
- * CRC, location and bounds checking, the unpacking function checks the path
- * parameters and owner.
- */
-bool
-xfs_symlink_hdr_ok(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino,
-	uint32_t		offset,
-	uint32_t		size,
-	struct xfs_buf		*bp)
-{
-	struct xfs_dsymlink_hdr *dsl = bp->b_addr;
-
-	if (offset != be32_to_cpu(dsl->sl_offset))
-		return false;
-	if (size != be32_to_cpu(dsl->sl_bytes))
-		return false;
-	if (ino != be64_to_cpu(dsl->sl_owner))
-		return false;
-
-	/* ok */
-	return true;
-
-}
-
-static bool
-xfs_symlink_verify(
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return false;
-	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
-		return false;
-	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_uuid))
-		return false;
-	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
-		return false;
-	if (be32_to_cpu(dsl->sl_offset) +
-				be32_to_cpu(dsl->sl_bytes) >= MAXPATHLEN)
-		return false;
-	if (dsl->sl_owner == 0)
-		return false;
-
-	return true;
-}
-
-static void
-xfs_symlink_read_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-
-	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return;
-
-	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-				  offsetof(struct xfs_dsymlink_hdr, sl_crc)) ||
-	    !xfs_symlink_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
-}
-
-static void
-xfs_symlink_write_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_buf_log_item	*bip = bp->b_fspriv;
-
-	/* no verification of non-crc buffers */
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return;
-
-	if (!xfs_symlink_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-		return;
-	}
-
-	if (bip) {
-		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
-		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
-	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 offsetof(struct xfs_dsymlink_hdr, sl_crc));
-}
-
-const struct xfs_buf_ops xfs_symlink_buf_ops = {
-	.verify_read = xfs_symlink_read_verify,
-	.verify_write = xfs_symlink_write_verify,
-};
-
-void
-xfs_symlink_local_to_remote(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	char			*buf;
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
-		bp->b_ops = NULL;
-		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-		return;
-	}
-
-	/*
-	 * As this symlink fits in an inode literal area, it must also fit in
-	 * the smallest buffer the filesystem supports.
-	 */
-	ASSERT(BBTOB(bp->b_length) >=
-			ifp->if_bytes + sizeof(struct xfs_dsymlink_hdr));
-
-	bp->b_ops = &xfs_symlink_buf_ops;
-
-	buf = bp->b_addr;
-	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
-	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
-}
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
new file mode 100644
index 0000000..539db0c
--- /dev/null
+++ b/libxfs/xfs_symlink_remote.c
@@ -0,0 +1,185 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2012-2013 Red Hat, Inc.
+ * All rights reserved.
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
+#include <xfs.h>
+
+/*
+ * Each contiguous block has a header, so it is not just a simple pathlen
+ * to FSB conversion.
+ */
+int
+xfs_symlink_blocks(
+	struct xfs_mount *mp,
+	int		pathlen)
+{
+	int buflen = XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+
+	return (pathlen + buflen - 1) / buflen;
+}
+
+int
+xfs_symlink_hdr_set(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		offset,
+	uint32_t		size,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return 0;
+
+	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
+	dsl->sl_offset = cpu_to_be32(offset);
+	dsl->sl_bytes = cpu_to_be32(size);
+	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
+	dsl->sl_owner = cpu_to_be64(ino);
+	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
+	bp->b_ops = &xfs_symlink_buf_ops;
+
+	return sizeof(struct xfs_dsymlink_hdr);
+}
+
+/*
+ * Checking of the symlink header is split into two parts. the verifier does
+ * CRC, location and bounds checking, the unpacking function checks the path
+ * parameters and owner.
+ */
+bool
+xfs_symlink_hdr_ok(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	uint32_t		offset,
+	uint32_t		size,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dsymlink_hdr *dsl = bp->b_addr;
+
+	if (offset != be32_to_cpu(dsl->sl_offset))
+		return false;
+	if (size != be32_to_cpu(dsl->sl_bytes))
+		return false;
+	if (ino != be64_to_cpu(dsl->sl_owner))
+		return false;
+
+	/* ok */
+	return true;
+}
+
+static bool
+xfs_symlink_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
+		return false;
+	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
+		return false;
+	if (be32_to_cpu(dsl->sl_offset) +
+				be32_to_cpu(dsl->sl_bytes) >= MAXPATHLEN)
+		return false;
+	if (dsl->sl_owner == 0)
+		return false;
+
+	return true;
+}
+
+static void
+xfs_symlink_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+
+	/* no verification of non-crc buffers */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				  offsetof(struct xfs_dsymlink_hdr, sl_crc)) ||
+	    !xfs_symlink_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+}
+
+static void
+xfs_symlink_write_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	/* no verification of non-crc buffers */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (!xfs_symlink_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (bip) {
+		struct xfs_dsymlink_hdr *dsl = bp->b_addr;
+		dsl->sl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	}
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_dsymlink_hdr, sl_crc));
+}
+
+const struct xfs_buf_ops xfs_symlink_buf_ops = {
+	.verify_read = xfs_symlink_read_verify,
+	.verify_write = xfs_symlink_write_verify,
+};
+
+void
+xfs_symlink_local_to_remote(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	char			*buf;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		bp->b_ops = NULL;
+		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		return;
+	}
+
+	/*
+	 * As this symlink fits in an inode literal area, it must also fit in
+	 * the smallest buffer the filesystem supports.
+	 */
+	ASSERT(BBTOB(bp->b_length) >=
+			ifp->if_bytes + sizeof(struct xfs_dsymlink_hdr));
+
+	bp->b_ops = &xfs_symlink_buf_ops;
+
+	buf = bp->b_addr;
+	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
+	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
+}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
