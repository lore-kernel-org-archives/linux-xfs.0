Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 069E77F85
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E6FB98F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	I5ulO8D1D4DHACWP for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:42 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVc-0003uI-04
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVb-0001K2-TM
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/48] libxfs: add support for crc headers on remote symlinks
Date: Fri,  7 Jun 2013 10:25:31 +1000
Message-Id: <1370564771-4929-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile       |    4 +-
 include/libxfs.h       |    1 +
 include/xfs_buf_item.h |    4 +-
 include/xfs_symlink.h  |   43 ++++++++++++++
 libxfs/Makefile        |    2 +-
 libxfs/xfs_symlink.c   |  154 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 204 insertions(+), 4 deletions(-)
 create mode 100644 include/xfs_symlink.h
 create mode 100644 libxfs/xfs_symlink.c

diff --git a/include/Makefile b/include/Makefile
index 8688a86..92161bd 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -28,8 +28,8 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
 	xfs_inode.h xfs_inode_item.h xfs_inum.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
-	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_trace.h \
-	xfs_trans.h xfs_trans_space.h xfs_dfrag.h
+	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_symlink.h \
+	xfs_trace.h xfs_trans.h xfs_trans_space.h xfs_dfrag.h
 
 HFILES = handle.h jdm.h xqm.h xfs.h xfs_fs.h xfs_types.h
 HFILES += $(PKG_PLATFORM).h
diff --git a/include/libxfs.h b/include/libxfs.h
index a4564fd..41cb585 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -56,6 +56,7 @@
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
+#include <xfs/xfs_symlink.h>
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index abae8c8..09cab4e 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -49,6 +49,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 #define XFS_BLF_AGFL_BUF	(1<<7)
 #define XFS_BLF_AGI_BUF		(1<<8)
 #define XFS_BLF_DINO_BUF	(1<<9)
+#define XFS_BLF_SYMLINK_BUF	(1<<10)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
@@ -58,7 +59,8 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 		 XFS_BLF_AGF_BUF | \
 		 XFS_BLF_AGFL_BUF | \
 		 XFS_BLF_AGI_BUF | \
-		 XFS_BLF_DINO_BUF)
+		 XFS_BLF_DINO_BUF | \
+		 XFS_BLF_SYMLINK_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
new file mode 100644
index 0000000..bb21e6a
--- /dev/null
+++ b/include/xfs_symlink.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
+ */
+#ifndef __XFS_SYMLINK_H
+#define __XFS_SYMLINK_H 1
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
+
+extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+
+#ifdef __KERNEL__
+
+int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
+		const char *target_path, umode_t mode, struct xfs_inode **ipp);
+int xfs_readlink(struct xfs_inode *ip, char *link);
+int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
+
+#endif /* __KERNEL__ */
+#endif /* __XFS_SYMLINK_H */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 28f71c8..75f365c 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -17,7 +17,7 @@ CFILES = cache.c init.c kmem.c logitem.c radix-tree.c rdwr.c trans.c util.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
 	xfs_mount.c xfs_rtalloc.c xfs_trans.c xfs_attr.c \
-	crc32.c
+	crc32.c xfs_symlink.c
 
 CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
diff --git a/libxfs/xfs_symlink.c b/libxfs/xfs_symlink.c
new file mode 100644
index 0000000..e018abc
--- /dev/null
+++ b/libxfs/xfs_symlink.c
@@ -0,0 +1,154 @@
+/*
+ * Copyright 2013 Red Hat, Inc.
+ * All rights reserved.
+ */
+
+#include "xfs.h"
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
+	int		fsblocks = 0;
+	int		len = pathlen;
+
+	do {
+		fsblocks++;
+		len -= XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+	} while (len > 0);
+
+	ASSERT(fsblocks <= XFS_SYMLINK_MAPS);
+	return fsblocks;
+}
+
+/*
+ * XXX: this need to be used by mkfs/proto.c to create symlinks.
+ */
+static int
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
+
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
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
