Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51B0429E7B
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E30FEAC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OWFagqDUB8yeDvFK for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:40 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANp-00030E-SI
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANf-00006U-Ox
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 37/60] xfs: split out inode log item format definition
Date: Wed, 19 Jun 2013 14:50:45 +1000
Message-Id: <1371617468-32559-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

The EFI/EFD item format definitions are shared with userspace. Split
the out of header files that contain kernel only defintions to make
it simple to shared them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.h        |   90 ++-------------------------------
 fs/xfs/xfs_extfree_item_format.h |  101 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 86 deletions(-)
 create mode 100644 fs/xfs/xfs_extfree_item_format.h

diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 4322224..0b49c87f 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -18,92 +18,12 @@
 #ifndef	__XFS_EXTFREE_ITEM_H__
 #define	__XFS_EXTFREE_ITEM_H__
 
-struct xfs_mount;
-struct kmem_zone;
-
-typedef struct xfs_extent {
-	xfs_dfsbno_t	ext_start;
-	xfs_extlen_t	ext_len;
-} xfs_extent_t;
-
-/*
- * Since an xfs_extent_t has types (start:64, len: 32)
- * there are different alignments on 32 bit and 64 bit kernels.
- * So we provide the different variants for use by a
- * conversion routine.
- */
-
-typedef struct xfs_extent_32 {
-	__uint64_t	ext_start;
-	__uint32_t	ext_len;
-} __attribute__((packed)) xfs_extent_32_t;
-
-typedef struct xfs_extent_64 {
-	__uint64_t	ext_start;
-	__uint32_t	ext_len;
-	__uint32_t	ext_pad;
-} xfs_extent_64_t;
-
-/*
- * This is the structure used to lay out an efi log item in the
- * log.  The efi_extents field is a variable size array whose
- * size is given by efi_nextents.
- */
-typedef struct xfs_efi_log_format {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_t		efi_extents[1];	/* array of extents to free */
-} xfs_efi_log_format_t;
+#include "xfs_extfree_item_format.h"
 
-typedef struct xfs_efi_log_format_32 {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
-} __attribute__((packed)) xfs_efi_log_format_32_t;
+/* kernel only EFI/EFD definitions */
 
-typedef struct xfs_efi_log_format_64 {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
-} xfs_efi_log_format_64_t;
-
-/*
- * This is the structure used to lay out an efd log item in the
- * log.  The efd_extents array is a variable size array whose
- * size is given by efd_nextents;
- */
-typedef struct xfs_efd_log_format {
-	__uint16_t		efd_type;	/* efd log item type */
-	__uint16_t		efd_size;	/* size of this item */
-	__uint32_t		efd_nextents;	/* # of extents freed */
-	__uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_t		efd_extents[1];	/* array of extents freed */
-} xfs_efd_log_format_t;
-
-typedef struct xfs_efd_log_format_32 {
-	__uint16_t		efd_type;	/* efd log item type */
-	__uint16_t		efd_size;	/* size of this item */
-	__uint32_t		efd_nextents;	/* # of extents freed */
-	__uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
-} __attribute__((packed)) xfs_efd_log_format_32_t;
-
-typedef struct xfs_efd_log_format_64 {
-	__uint16_t		efd_type;	/* efd log item type */
-	__uint16_t		efd_size;	/* size of this item */
-	__uint32_t		efd_nextents;	/* # of extents freed */
-	__uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
-} xfs_efd_log_format_64_t;
-
-
-#ifdef __KERNEL__
+struct xfs_mount;
+struct kmem_zone;
 
 /*
  * Max number of extents in fast allocation path.
@@ -160,6 +80,4 @@ int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
 void			xfs_efi_item_free(xfs_efi_log_item_t *);
 
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_extfree_item_format.h b/fs/xfs/xfs_extfree_item_format.h
new file mode 100644
index 0000000..ddd1fbb
--- /dev/null
+++ b/fs/xfs/xfs_extfree_item_format.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
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
+#ifndef	__XFS_EXTFREE_ITEM_FORMAT_H__
+#define	__XFS_EXTFREE_ITEM_FORMAT_H__
+
+typedef struct xfs_extent {
+	xfs_dfsbno_t	ext_start;
+	xfs_extlen_t	ext_len;
+} xfs_extent_t;
+
+/*
+ * Since an xfs_extent_t has types (start:64, len: 32)
+ * there are different alignments on 32 bit and 64 bit kernels.
+ * So we provide the different variants for use by a
+ * conversion routine.
+ */
+typedef struct xfs_extent_32 {
+	__uint64_t	ext_start;
+	__uint32_t	ext_len;
+} __attribute__((packed)) xfs_extent_32_t;
+
+typedef struct xfs_extent_64 {
+	__uint64_t	ext_start;
+	__uint32_t	ext_len;
+	__uint32_t	ext_pad;
+} xfs_extent_64_t;
+
+/*
+ * This is the structure used to lay out an efi log item in the
+ * log.  The efi_extents field is a variable size array whose
+ * size is given by efi_nextents.
+ */
+typedef struct xfs_efi_log_format {
+	__uint16_t		efi_type;	/* efi log item type */
+	__uint16_t		efi_size;	/* size of this item */
+	__uint32_t		efi_nextents;	/* # extents to free */
+	__uint64_t		efi_id;		/* efi identifier */
+	xfs_extent_t		efi_extents[1];	/* array of extents to free */
+} xfs_efi_log_format_t;
+
+typedef struct xfs_efi_log_format_32 {
+	__uint16_t		efi_type;	/* efi log item type */
+	__uint16_t		efi_size;	/* size of this item */
+	__uint32_t		efi_nextents;	/* # extents to free */
+	__uint64_t		efi_id;		/* efi identifier */
+	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
+} __attribute__((packed)) xfs_efi_log_format_32_t;
+
+typedef struct xfs_efi_log_format_64 {
+	__uint16_t		efi_type;	/* efi log item type */
+	__uint16_t		efi_size;	/* size of this item */
+	__uint32_t		efi_nextents;	/* # extents to free */
+	__uint64_t		efi_id;		/* efi identifier */
+	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
+} xfs_efi_log_format_64_t;
+
+/*
+ * This is the structure used to lay out an efd log item in the
+ * log.  The efd_extents array is a variable size array whose
+ * size is given by efd_nextents;
+ */
+typedef struct xfs_efd_log_format {
+	__uint16_t		efd_type;	/* efd log item type */
+	__uint16_t		efd_size;	/* size of this item */
+	__uint32_t		efd_nextents;	/* # of extents freed */
+	__uint64_t		efd_efi_id;	/* id of corresponding efi */
+	xfs_extent_t		efd_extents[1];	/* array of extents freed */
+} xfs_efd_log_format_t;
+
+typedef struct xfs_efd_log_format_32 {
+	__uint16_t		efd_type;	/* efd log item type */
+	__uint16_t		efd_size;	/* size of this item */
+	__uint32_t		efd_nextents;	/* # of extents freed */
+	__uint64_t		efd_efi_id;	/* id of corresponding efi */
+	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
+} __attribute__((packed)) xfs_efd_log_format_32_t;
+
+typedef struct xfs_efd_log_format_64 {
+	__uint16_t		efd_type;	/* efd log item type */
+	__uint16_t		efd_size;	/* size of this item */
+	__uint32_t		efd_nextents;	/* # of extents freed */
+	__uint64_t		efd_efi_id;	/* id of corresponding efi */
+	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
+} xfs_efd_log_format_64_t;
+
+#endif	/* __XFS_EXTFREE_ITEM_FORMAT_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
