Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D09E7F7E
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C27C7AC003
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zCNFVCvBUW4elWEv for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004Y7-2j
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00061y-1q
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 19/50] xfs: split out the remote
	symlink handling
Date: Mon, 12 Aug 2013 20:49:40 +1000
Message-Id: <1376304611-22994-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/Makefile             |   3 +-
 fs/xfs/xfs_format.h         |  42 ++++++++++
 fs/xfs/xfs_symlink.c        | 172 --------------------------------------
 fs/xfs/xfs_symlink.h        |  42 +---------
 fs/xfs/xfs_symlink_remote.c | 199 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 244 insertions(+), 214 deletions(-)
 create mode 100644 fs/xfs/xfs_symlink_remote.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a73af1c..20b1d94 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -50,6 +50,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mru_cache.o \
 				   xfs_rename.o \
 				   xfs_super.o \
+				   xfs_symlink.o \
 				   xfs_trans.o \
 				   xfs_utils.o \
 				   xfs_vnodeops.o \
@@ -81,7 +82,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_inode_buf.o \
 				   xfs_log_recover.o \
 				   xfs_mount.o \
-				   xfs_symlink.o \
+				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o
 
 # low-level transaction/log code
diff --git a/fs/xfs/xfs_format.h b/fs/xfs/xfs_format.h
index 6205374..35c08ff 100644
--- a/fs/xfs/xfs_format.h
+++ b/fs/xfs/xfs_format.h
@@ -27,6 +27,12 @@
  * xfs_log_format.h. Everything else goes here.
  */
 
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_inode;
+struct xfs_buf;
+struct xfs_ifork;
+
 /*
  * RealTime Device format definitions
  */
@@ -123,5 +129,41 @@ typedef struct xfs_dqblk {
 
 #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
 
+/*
+ * Remote symlink format and access functions.
+ */
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
 
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index dd7c099..18f24de 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -32,8 +32,6 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_inode_item.h"
-#include "xfs_itable.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
@@ -41,178 +39,8 @@
 #include "xfs_quota.h"
 #include "xfs_utils.h"
 #include "xfs_trans_space.h"
-#include "xfs_log_priv.h"
 #include "xfs_trace.h"
 #include "xfs_symlink.h"
-#include "xfs_cksum.h"
-#include "xfs_buf_item.h"
-
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
-static int
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
 
 /* ----- Kernel only functions below ----- */
 STATIC int
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index c8e3a02..99338ba 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -17,51 +17,11 @@
 #ifndef __XFS_SYMLINK_H
 #define __XFS_SYMLINK_H 1
 
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
+/* Kernel only symlink defintions */
 
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip, struct xfs_trans **tpp);
 
-#endif /* __KERNEL__ */
 #endif /* __XFS_SYMLINK_H */
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
new file mode 100644
index 0000000..a318524
--- /dev/null
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -0,0 +1,199 @@
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
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_symlink.h"
+#include "xfs_cksum.h"
+#include "xfs_buf_item.h"
+
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
