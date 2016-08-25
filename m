Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 49D1D812B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:48:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0B1DAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id B5EmZe7wbi0IXzYO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:48:38 -0700 (PDT)
Subject: [PATCH 19/71] xfs: create bmbt update intent log items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:48:32 -0700
Message-ID: <147216891287.4420.13513263762009543259.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create bmbt update intent/done log items to record redo information in
the log.  Because we need to roll transactions multiple times for
reflink operations, between we also have to track the status of the
metadata updates that will be recorded in the post-roll transactions,
just in case we crash before committing the final transaction.  This
mechanism enables log recovery to finish what was already started.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_log_format.h |   51 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index ebf5dc0..fffcc0f 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -114,7 +114,9 @@ static inline uint xlog_get_cycle(char *ptr)
 #define XLOG_REG_TYPE_RUD_FORMAT	22
 #define XLOG_REG_TYPE_CUI_FORMAT	23
 #define XLOG_REG_TYPE_CUD_FORMAT	24
-#define XLOG_REG_TYPE_MAX		24
+#define XLOG_REG_TYPE_BUI_FORMAT	25
+#define XLOG_REG_TYPE_BUD_FORMAT	26
+#define XLOG_REG_TYPE_MAX		26
 
 /*
  * Flags to log operation header
@@ -235,6 +237,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_RUD		0x1241
 #define	XFS_LI_CUI		0x1242	/* refcount update intent */
 #define	XFS_LI_CUD		0x1243
+#define	XFS_LI_BUI		0x1244	/* bmbt update intent */
+#define	XFS_LI_BUD		0x1245
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -248,7 +252,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_RUI,		"XFS_LI_RUI" }, \
 	{ XFS_LI_RUD,		"XFS_LI_RUD" }, \
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
-	{ XFS_LI_CUD,		"XFS_LI_CUD" }
+	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
+	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -712,6 +718,47 @@ struct xfs_cud_log_format {
 };
 
 /*
+ * BUI/BUD (inode block mapping) log format definitions
+ */
+
+/* bmbt me_flags: upper bits are flags, lower byte is type code */
+#define XFS_BMAP_EXTENT_MAP		1
+#define XFS_BMAP_EXTENT_UNMAP		2
+#define XFS_BMAP_EXTENT_TYPE_MASK	0xFF
+
+#define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
+#define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+
+#define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
+					 XFS_BMAP_EXTENT_ATTR_FORK | \
+					 XFS_BMAP_EXTENT_UNWRITTEN)
+
+/*
+ * This is the structure used to lay out an bui log item in the
+ * log.  The bui_extents field is a variable size array whose
+ * size is given by bui_nextents.
+ */
+struct xfs_bui_log_format {
+	__uint16_t		bui_type;	/* bui log item type */
+	__uint16_t		bui_size;	/* size of this item */
+	__uint32_t		bui_nextents;	/* # extents to free */
+	__uint64_t		bui_id;		/* bui identifier */
+	struct xfs_map_extent	bui_extents[1];	/* array of extents to bmap */
+};
+
+/*
+ * This is the structure used to lay out an bud log item in the
+ * log.  The bud_extents array is a variable size array whose
+ * size is given by bud_nextents;
+ */
+struct xfs_bud_log_format {
+	__uint16_t		bud_type;	/* bud log item type */
+	__uint16_t		bud_size;	/* size of this item */
+	__uint32_t		__pad;
+	__uint64_t		bud_bui_id;	/* id of corresponding bui */
+};
+
+/*
  * Dquot Log format definitions.
  *
  * The first two fields must be the type and size fitting into

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
