Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUG7x073459 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ADDD10651D
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QSVQ8eVyIvG2I0AF for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:40 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEh-0005ll-Rm
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:39 +0000
Message-Id: <20090210202939.667316000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/13] xfs: add CRC infrastructure
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-crc-bit
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
To: xfs@oss.sgi.com

 - add a mount feature bit for CRC enabled filesystems
 - add some helpers for generating and verifying the CRCs
 - add a copy_uuid helper
 - add a pre-io callback to xfs_buf for calculating the CRCs

The checksumming helpers are losely based on similar ones in sctp,
all other bits come from Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/Kconfig
===================================================================
--- xfs.orig/fs/xfs/Kconfig	2009-02-03 16:52:11.665916316 +0100
+++ xfs/fs/xfs/Kconfig	2009-02-05 19:04:41.218218577 +0100
@@ -2,6 +2,7 @@ config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
 	select EXPORTFS
+	select LIBCRC32C
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2009-02-05 17:53:06.742088475 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2009-02-05 19:04:31.269945065 +0100
@@ -72,6 +72,7 @@
 #include <linux/random.h>
 #include <linux/ctype.h>
 #include <linux/writeback.h>
+#include <linux/crc32c.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: xfs/fs/xfs/xfs_sb.h
===================================================================
--- xfs.orig/fs/xfs/xfs_sb.h	2009-02-03 16:52:12.358436358 +0100
+++ xfs/fs/xfs/xfs_sb.h	2009-02-05 19:04:31.272973243 +0100
@@ -80,10 +80,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
+#define XFS_SB_VERSION2_CRCBIT		0x00000020	/* metadata has CRCs */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
-	 XFS_SB_VERSION2_ATTR2BIT)
+	 XFS_SB_VERSION2_ATTR2BIT | \
+	 XFS_SB_VERSION2_CRCBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -495,6 +497,12 @@ static inline void xfs_sb_version_remove
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
 
+static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
+{
+	return (xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_CRCBIT));
+}
+
 /*
  * end of superblock version macros
  */
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-02-05 17:53:06.643944544 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-02-05 19:04:31.273973789 +0100
@@ -1108,6 +1108,14 @@ _xfs_buf_ioapply(
 		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
 	}
 
+	/*
+	 * call out to buffer specific pre-write I/O functions. Used for
+	 * validation of buffers and CRC calculations prior to I/O issue.
+	 */
+	if (bp->b_io_callback && (bp->b_flags & XBF_WRITE))
+		bp->b_io_callback(bp);
+
+
 	/* Special code path for reading a sub page size buffer in --
 	 * we populate up the whole page, and hence the other metadata
 	 * in the same page.  This optimization is only valid when the
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-01-21 21:03:27.825295146 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-02-05 19:04:31.273973789 +0100
@@ -174,6 +174,8 @@ typedef struct xfs_buf {
 	unsigned int		b_offset;	/* page offset in first page */
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	void			(*b_io_callback)(struct xfs_buf *);
+						/* pre-write I/O callback */
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
@@ -236,6 +238,16 @@ static inline int xfs_buf_geterror(xfs_b
 /* Buffer Utility Routines */
 extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
 
+/*
+ * Set the function that should be called immediately prior
+ * to a write I/O being issued on this buffer.
+ */
+static inline void
+xfs_buf_set_io_callback(xfs_buf_t *bp, void (*func)(xfs_buf_t *))
+{
+	bp->b_io_callback = func;
+}
+
 /* Pinning Buffer Storage in Memory */
 extern void xfs_buf_pin(xfs_buf_t *);
 extern void xfs_buf_unpin(xfs_buf_t *);
Index: xfs/fs/xfs/support/uuid.c
===================================================================
--- xfs.orig/fs/xfs/support/uuid.c	2009-01-21 21:03:27.838294778 +0100
+++ xfs/fs/xfs/support/uuid.c	2009-02-05 19:04:31.274944514 +0100
@@ -72,6 +72,12 @@ uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
 	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
 }
 
+void
+uuid_copy(uuid_t *dst, uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 /*
  * Given a 128-bit uuid, return a 64-bit value by adding the top and bottom
  * 64-bit words.  NOTE: This function can not be changed EVER.  Although
Index: xfs/fs/xfs/support/uuid.h
===================================================================
--- xfs.orig/fs/xfs/support/uuid.h	2009-01-21 21:03:27.838294778 +0100
+++ xfs/fs/xfs/support/uuid.h	2009-02-05 19:04:31.279944870 +0100
@@ -25,6 +25,7 @@ typedef struct {
 extern void uuid_create_nil(uuid_t *uuid);
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
+extern void uuid_copy(uuid_t *dst, uuid_t *src);
 extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
 extern __uint64_t uuid_hash64(uuid_t *uuid);
 extern int uuid_table_insert(uuid_t *uuid);
Index: xfs/fs/xfs/xfs_cksum.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/xfs_cksum.h	2009-02-05 19:04:31.282972630 +0100
@@ -0,0 +1,62 @@
+#ifndef _XFS_CKSUM_H
+#define _XFS_CKSUM_H 1
+
+#define XFS_CRC_SEED	(~(__uint32_t)0)
+
+/*
+ * Calculate the intermediate checksum for a buffer that has the CRC field
+ * inside it.  The offset of the 32bit crc fields is passed as the
+ * cksum_offset parameter.
+ */
+static inline __uint32_t
+xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+{
+	__uint32_t zero = 0;
+	__uint32_t crc;
+
+	/* Calculate CRC up to the checksum. */
+	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
+
+	/* Skip checksum field */
+	crc = crc32c(crc, &zero, sizeof(__u32));
+
+	/* Calculate the rest of the CRC. */
+	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
+		      length - (cksum_offset + sizeof(__be32)));
+}
+
+/*
+ * Convert the intermediate checksum to the final ondisk format.
+ *
+ * Note that crc32c is already endianess agnostic, so no additional
+ * byte swap is needed.
+ */
+static inline __be32
+xfs_end_cksum(__uint32_t crc)
+{
+	return (__force __be32)~crc;
+}
+
+/*
+ * Helper to generate the checksum for a buffer.
+ */
+static inline void
+xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+{
+	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
+
+	*(__be32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
+}
+
+/*
+ * Helper to verify the checksum for a buffer.
+ */
+static inline int
+xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
+{
+	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
+
+	return *(__be32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
+}
+
+#endif /* _XFS_CKSUM_H */
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-02-05 17:53:07.338944053 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-02-05 19:04:31.286943944 +0100
@@ -569,6 +569,11 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	ASSERT(sbp->sb_inodesize ==  256 || sbp->sb_inodesize ==  512 ||
 	       sbp->sb_inodesize == 1024 || sbp->sb_inodesize == 2048);
 
+	if (xfs_sb_version_hascrc(sbp))
+		printk("XFS: using CRCs\n");
+	else
+		printk("XFS: not using CRCs\n");
+
 	mp->m_agfrotor = mp->m_agirotor = 0;
 	spin_lock_init(&mp->m_agirotor_lock);
 	mp->m_maxagi = mp->m_sb.sb_agcount;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
