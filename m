Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 05E0F8189
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:35:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E54EAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Tt2btjvfHf89LtYE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:29 -0700 (PDT)
Subject: [PATCH 044/145] xfs: create rmap update intent log items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:35:22 -0700
Message-ID: <146612732200.16048.15503614314390802694.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Create rmap update intent/done log items to record redo information in
the log.  Because we need to roll transactions between updating the
bmbt mapping and updating the reverse mapping, we also have to track
the status of the metadata updates that will be recorded in the
post-roll transactions, just in case we crash before committing the
final transaction.  This mechanism enables log recovery to finish what
was already started.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_log_format.h |   67 ++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_rmap_btree.h |   19 +++++++++++++
 2 files changed, 84 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index e5baba3..b9627b7 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -110,7 +110,9 @@ static inline uint xlog_get_cycle(char *ptr)
 #define XLOG_REG_TYPE_COMMIT		18
 #define XLOG_REG_TYPE_TRANSHDR		19
 #define XLOG_REG_TYPE_ICREATE		20
-#define XLOG_REG_TYPE_MAX		20
+#define XLOG_REG_TYPE_RUI_FORMAT	21
+#define XLOG_REG_TYPE_RUD_FORMAT	22
+#define XLOG_REG_TYPE_MAX		22
 
 /*
  * Flags to log operation header
@@ -227,6 +229,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_DQUOT		0x123d
 #define	XFS_LI_QUOTAOFF		0x123e
 #define	XFS_LI_ICREATE		0x123f
+#define	XFS_LI_RUI		0x1240	/* rmap update intent */
+#define	XFS_LI_RUD		0x1241
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -236,7 +240,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
 	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
 	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
-	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
+	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }, \
+	{ XFS_LI_RUI,		"XFS_LI_RUI" }, \
+	{ XFS_LI_RUD,		"XFS_LI_RUD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -604,6 +610,63 @@ typedef struct xfs_efd_log_format_64 {
 } xfs_efd_log_format_64_t;
 
 /*
+ * RUI/RUD (reverse mapping) log format definitions
+ */
+struct xfs_map_extent {
+	__uint64_t		me_owner;
+	__uint64_t		me_startblock;
+	__uint64_t		me_startoff;
+	__uint32_t		me_len;
+	__uint32_t		me_flags;
+};
+
+/* rmap me_flags: upper bits are flags, lower byte is type code */
+#define XFS_RMAP_EXTENT_MAP		1
+#define XFS_RMAP_EXTENT_MAP_SHARED	2
+#define XFS_RMAP_EXTENT_UNMAP		3
+#define XFS_RMAP_EXTENT_UNMAP_SHARED	4
+#define XFS_RMAP_EXTENT_CONVERT		5
+#define XFS_RMAP_EXTENT_CONVERT_SHARED	6
+#define XFS_RMAP_EXTENT_ALLOC		7
+#define XFS_RMAP_EXTENT_FREE		8
+#define XFS_RMAP_EXTENT_TYPE_MASK	0xFF
+
+#define XFS_RMAP_EXTENT_ATTR_FORK	(1U << 31)
+#define XFS_RMAP_EXTENT_BMBT_BLOCK	(1U << 30)
+#define XFS_RMAP_EXTENT_UNWRITTEN	(1U << 29)
+
+#define XFS_RMAP_EXTENT_FLAGS		(XFS_RMAP_EXTENT_TYPE_MASK | \
+					 XFS_RMAP_EXTENT_ATTR_FORK | \
+					 XFS_RMAP_EXTENT_BMBT_BLOCK | \
+					 XFS_RMAP_EXTENT_UNWRITTEN)
+
+/*
+ * This is the structure used to lay out an rui log item in the
+ * log.  The rui_extents field is a variable size array whose
+ * size is given by rui_nextents.
+ */
+struct xfs_rui_log_format {
+	__uint16_t		rui_type;	/* rui log item type */
+	__uint16_t		rui_size;	/* size of this item */
+	__uint32_t		rui_nextents;	/* # extents to free */
+	__uint64_t		rui_id;		/* rui identifier */
+	struct xfs_map_extent	rui_extents[1];	/* array of extents to rmap */
+};
+
+/*
+ * This is the structure used to lay out an rud log item in the
+ * log.  The rud_extents array is a variable size array whose
+ * size is given by rud_nextents;
+ */
+struct xfs_rud_log_format {
+	__uint16_t		rud_type;	/* rud log item type */
+	__uint16_t		rud_size;	/* size of this item */
+	__uint32_t		rud_nextents;	/* # of extents freed */
+	__uint64_t		rud_rui_id;	/* id of corresponding rui */
+	struct xfs_map_extent	rud_extents[1];	/* array of extents rmapped */
+};
+
+/*
  * Dquot Log format definitions.
  *
  * The first two fields must be the type and size fitting into
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 6674340..aff60dc 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -87,4 +87,23 @@ int xfs_rmapbt_query_range(struct xfs_btree_cur *cur,
 		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
 		xfs_rmapbt_query_range_fn fn, void *priv);
 
+enum xfs_rmap_intent_type {
+	XFS_RMAP_MAP,
+	XFS_RMAP_MAP_SHARED,
+	XFS_RMAP_UNMAP,
+	XFS_RMAP_UNMAP_SHARED,
+	XFS_RMAP_CONVERT,
+	XFS_RMAP_CONVERT_SHARED,
+	XFS_RMAP_ALLOC,
+	XFS_RMAP_FREE,
+};
+
+struct xfs_rmap_intent {
+	struct list_head			ri_list;
+	enum xfs_rmap_intent_type		ri_type;
+	__uint64_t				ri_owner;
+	int					ri_whichfork;
+	struct xfs_bmbt_irec			ri_bmap;
+};
+
 #endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
