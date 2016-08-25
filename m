Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47B7D80F5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1929D8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id U7IQwrqFAEXx5ZSk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:53 -0700 (PDT)
Subject: [PATCH 12/71] xfs: create refcount update intent log items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:47:47 -0700
Message-ID: <147216886741.4420.9217180914915429445.stgit@birch.djwong.org>
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

Create refcount update intent/done log items to record redo
information in the log.  Because we need to roll transactions between
updating the bmbt mapping and updating the reverse mapping, we also
have to track the status of the metadata updates that will be recorded
in the post-roll transactions, just in case we crash before committing
the final transaction.  This mechanism enables log recovery to finish
what was already started.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_log_format.h |   53 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 96c7010..ebf5dc0 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -112,7 +112,9 @@ static inline uint xlog_get_cycle(char *ptr)
 #define XLOG_REG_TYPE_ICREATE		20
 #define XLOG_REG_TYPE_RUI_FORMAT	21
 #define XLOG_REG_TYPE_RUD_FORMAT	22
-#define XLOG_REG_TYPE_MAX		22
+#define XLOG_REG_TYPE_CUI_FORMAT	23
+#define XLOG_REG_TYPE_CUD_FORMAT	24
+#define XLOG_REG_TYPE_MAX		24
 
 /*
  * Flags to log operation header
@@ -231,6 +233,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_ICREATE		0x123f
 #define	XFS_LI_RUI		0x1240	/* rmap update intent */
 #define	XFS_LI_RUD		0x1241
+#define	XFS_LI_CUI		0x1242	/* refcount update intent */
+#define	XFS_LI_CUD		0x1243
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -242,7 +246,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
 	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }, \
 	{ XFS_LI_RUI,		"XFS_LI_RUI" }, \
-	{ XFS_LI_RUD,		"XFS_LI_RUD" }
+	{ XFS_LI_RUD,		"XFS_LI_RUD" }, \
+	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
+	{ XFS_LI_CUD,		"XFS_LI_CUD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -663,6 +669,49 @@ struct xfs_rud_log_format {
 };
 
 /*
+ * CUI/CUD (refcount update) log format definitions
+ */
+struct xfs_phys_extent {
+	__uint64_t		pe_startblock;
+	__uint32_t		pe_len;
+	__uint32_t		pe_flags;
+};
+
+/* refcount pe_flags: upper bits are flags, lower byte is type code */
+#define XFS_REFCOUNT_EXTENT_INCREASE	1
+#define XFS_REFCOUNT_EXTENT_DECREASE	2
+#define XFS_REFCOUNT_EXTENT_ALLOC_COW	3
+#define XFS_REFCOUNT_EXTENT_FREE_COW	4
+#define XFS_REFCOUNT_EXTENT_TYPE_MASK	0xFF
+
+#define XFS_REFCOUNT_EXTENT_FLAGS	(XFS_REFCOUNT_EXTENT_TYPE_MASK)
+
+/*
+ * This is the structure used to lay out a cui log item in the
+ * log.  The cui_extents field is a variable size array whose
+ * size is given by cui_nextents.
+ */
+struct xfs_cui_log_format {
+	__uint16_t		cui_type;	/* cui log item type */
+	__uint16_t		cui_size;	/* size of this item */
+	__uint32_t		cui_nextents;	/* # extents to free */
+	__uint64_t		cui_id;		/* cui identifier */
+	struct xfs_phys_extent	cui_extents[1];	/* array of extents */
+};
+
+/*
+ * This is the structure used to lay out a cud log item in the
+ * log.  The cud_extents array is a variable size array whose
+ * size is given by cud_nextents;
+ */
+struct xfs_cud_log_format {
+	__uint16_t		cud_type;	/* cud log item type */
+	__uint16_t		cud_size;	/* size of this item */
+	__uint32_t		__pad;
+	__uint64_t		cud_cui_id;	/* id of corresponding cui */
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
