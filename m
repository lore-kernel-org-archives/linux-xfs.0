Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18606 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753971AbcKEAZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:25:26 -0400
Subject: [PATCH 08/39] xfs: create an ioctl to scrub AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:25:22 -0700
Message-ID: <147830552225.4165.7962310326252326007.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create an ioctl that can be used to scrub internal filesystem metadata.
The new ioctl takes the metadata type, an (optional) AG number, an
(optional) inode number and generation, and a flags argument.  This will
be used by the upcoming XFS online scrub tool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 6857355..27878cf 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -578,6 +578,40 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
+/* metadata scrubbing */
+struct xfs_scrub_metadata {
+	__u32 sm_type;		/* What to check? */
+	__u32 sm_flags;		/* Flags; none defined right now. */
+	union {
+		__u32		__agno;
+		struct {
+			__u64	__ino;
+			__u32	__gen;
+		} i;
+		__u64		__reserved[7];	/* pad to 64 bytes */
+	} p;
+};
+#define sm_agno	p.__agno
+#define sm_ino	p.i.__ino
+#define sm_gen	p.i.__gen
+
+/*
+ * Metadata types and flags for scrub operation.
+ */
+#define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
+#define XFS_SCRUB_TYPE_MAX	0
+
+#define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
+#define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
+#define XFS_SCRUB_FLAG_PREEN	0x4	/* o: could be optimized */
+#define XFS_SCRUB_FLAG_XREF_FAIL 0x8	/* o: errors during cross-referencing */
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_FLAG_REPAIR)
+#define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_FLAG_CORRUPT | \
+				 XFS_SCRUB_FLAG_PREEN | \
+				 XFS_SCRUB_FLAG_XREF_FAIL)
+#define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
+
 /*
  * ioctl limits
  */
@@ -587,6 +621,7 @@ typedef struct xfs_swapext
 #  define XFS_XATTR_LIST_MAX 65536
 #endif
 
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -618,6 +653,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 #define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct fsmap_head)
+#define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

