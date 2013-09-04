Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC6E729DFC
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D5618F8033
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	I2BUvg6n9CiXnBaG for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLD9-0007dR-S8
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLD9-0003se-RG
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/55] xfs: split out inode log item format definition
Date: Thu,  5 Sep 2013 08:05:23 +1000
Message-Id: <1378332359-14737-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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
 include/Makefile           |   3 +-
 include/libxlog.h          |   1 -
 include/xfs_extfree_item.h | 161 ---------------------------------------------
 include/xfs_log_format.h   |  83 +++++++++++++++++++++++
 4 files changed, 85 insertions(+), 163 deletions(-)
 delete mode 100644 include/xfs_extfree_item.h

diff --git a/include/Makefile b/include/Makefile
index f5c50b7..ad2ac46 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -27,7 +27,8 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_cksum.h \
 	xfs_da_btree.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
-	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
+	xfs_ialloc.h \
+	xfs_ialloc_btree.h \
 	xfs_icreate_item.h \
 	xfs_inode.h \
 	xfs_inum.h \
diff --git a/include/libxlog.h b/include/libxlog.h
index 08f5dbb..ee23212 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -48,7 +48,6 @@ struct xlog {
 };
 
 #include <xfs/xfs_log_recover.h>
-#include <xfs/xfs_extfree_item.h>
 #include <xfs/xfs_icreate_item.h>
 
 /*
diff --git a/include/xfs_extfree_item.h b/include/xfs_extfree_item.h
deleted file mode 100644
index 375f68e..0000000
--- a/include/xfs_extfree_item.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * Copyright (c) 2000,2005 Silicon Graphics, Inc.
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
-#ifndef	__XFS_EXTFREE_ITEM_H__
-#define	__XFS_EXTFREE_ITEM_H__
-
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
-
-typedef struct xfs_efi_log_format_32 {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
-} __attribute__((packed)) xfs_efi_log_format_32_t;
-
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
-
-/*
- * Max number of extents in fast allocation path.
- */
-#define	XFS_EFI_MAX_FAST_EXTENTS	16
-
-/*
- * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
- */
-#define	XFS_EFI_RECOVERED	1
-#define	XFS_EFI_COMMITTED	2
-
-/*
- * This is the "extent free intention" log item.  It is used
- * to log the fact that some extents need to be free.  It is
- * used in conjunction with the "extent free done" log item
- * described below.
- */
-typedef struct xfs_efi_log_item {
-	xfs_log_item_t		efi_item;
-	atomic_t		efi_next_extent;
-	unsigned long		efi_flags;	/* misc flags */
-	xfs_efi_log_format_t	efi_format;
-} xfs_efi_log_item_t;
-
-/*
- * This is the "extent free done" log item.  It is used to log
- * the fact that some extents earlier mentioned in an efi item
- * have been freed.
- */
-typedef struct xfs_efd_log_item {
-	xfs_log_item_t		efd_item;
-	xfs_efi_log_item_t	*efd_efip;
-	uint			efd_next_extent;
-	xfs_efd_log_format_t	efd_format;
-} xfs_efd_log_item_t;
-
-/*
- * Max number of extents in fast allocation path.
- */
-#define	XFS_EFD_MAX_FAST_EXTENTS	16
-
-extern struct kmem_zone	*xfs_efi_zone;
-extern struct kmem_zone	*xfs_efd_zone;
-
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
-xfs_efd_log_item_t	*xfs_efd_init(struct xfs_mount *, xfs_efi_log_item_t *,
-				      uint);
-int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
-					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
-
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 77a6024..d1e93d3 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -461,4 +461,87 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 	return (blf->blf_flags & XFS_BLFT_MASK) >> XFS_BLFT_SHIFT;
 }
 
+/*
+ * EFI/EFD log format definitions
+ */
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
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
