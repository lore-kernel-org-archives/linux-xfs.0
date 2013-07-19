Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D75057F75
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6967304043
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pC3txyFp3BevM5zR for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:34 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0482-00047x-Io
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0482-0001wv-Hd
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/49] xfs: split out inode log item format definition
Date: Fri, 19 Jul 2013 16:24:35 +1000
Message-Id: <1374215120-7271-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_extfree_item.h | 88 ++---------------------------------------------
 fs/xfs/xfs_log_format.h   | 83 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 4322224..0ffbce3 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -18,93 +18,11 @@
 #ifndef	__XFS_EXTFREE_ITEM_H__
 #define	__XFS_EXTFREE_ITEM_H__
 
+/* kernel only EFI/EFD definitions */
+
 struct xfs_mount;
 struct kmem_zone;
 
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
 /*
  * Max number of extents in fast allocation path.
  */
@@ -160,6 +78,4 @@ int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
 void			xfs_efi_item_free(xfs_efi_log_item_t *);
 
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index 77a6024..d1e93d3 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
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
