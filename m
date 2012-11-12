Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBs6YY217977 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:54:06 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OP4CBLnIla3A1G7J for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:56:06 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsc2-00055D-7d
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:34 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsbw-00014Q-TC
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/32] xfs: add CRC infrastructure
Date: Mon, 12 Nov 2012 22:54:23 +1100
Message-Id: <1352721264-3700-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

 - add a mount feature bit for CRC enabled filesystems
 - add some helpers for generating and verifying the CRCs
 - add a copy_uuid helper

The checksumming helpers are losely based on similar ones in sctp,
all other bits come from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Kconfig     |    1 +
 fs/xfs/uuid.h      |    6 +++++
 fs/xfs/xfs_cksum.h |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_linux.h |    1 +
 fs/xfs/xfs_sb.h    |   10 ++++++++-
 5 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_cksum.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 6100ec0..5a7ffe5 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -2,6 +2,7 @@ config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
 	select EXPORTFS
+	select LIBCRC32C
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 4732d71..104db0f 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -26,4 +26,10 @@ extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
 extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
 
+static inline void
+uuid_copy(uuid_t *dst, uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/fs/xfs/xfs_cksum.h b/fs/xfs/xfs_cksum.h
new file mode 100644
index 0000000..fad1676
--- /dev/null
+++ b/fs/xfs/xfs_cksum.h
@@ -0,0 +1,63 @@
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
+ * The CRC32c calculation uses LE format even on BE machines, but returns the
+ * result in host endian format. Hence we need to byte swap it back to LE format
+ * so that it is consistent on disk.
+ */
+static inline __le32
+xfs_end_cksum(__uint32_t crc)
+{
+	return ~cpu_to_le32(crc);
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
+	*(__le32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
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
+	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
+}
+
+#endif /* _XFS_CKSUM_H */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 0a134ca..fe7e4df 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -44,6 +44,7 @@
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
+#include <linux/crc32c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/file.h>
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index f429d9d..666e89c 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -81,11 +81,13 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
+#define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
-	 XFS_SB_VERSION2_PROJID32BIT)
+	 XFS_SB_VERSION2_PROJID32BIT	| \
+	 XFS_SB_VERSION2_CRCBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -503,6 +505,12 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
