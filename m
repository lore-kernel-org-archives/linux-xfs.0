Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E75F8026
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DE728F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wBMXe8EOI1o8ayDK for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:35 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004Ii-0F
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002Ko-VI
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/49] xfs: split out on-disk transaction definitions
Date: Fri, 19 Jul 2013 16:44:57 +1000
Message-Id: <1374216324-8781-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

There's a bunch of definitions in xfs_trans.h that define on-disk
formats - transaction headers taht get written into the log, log
item type definitions, etc. Split out everything into a separate
file so that all which remains in xfs_trans.h are kernel only
definitions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_log_format.h | 141 +++++++++++++++++++++++++++++++++++++++++++++++
 include/xfs_trans.h      | 139 ----------------------------------------------
 2 files changed, 141 insertions(+), 139 deletions(-)

diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 02639c7..bcd1c34 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -187,6 +187,147 @@ typedef struct xfs_log_iovec {
 
 
 /*
+ * Transaction Header definitions.
+ *
+ * This is the structure written in the log at the head of every transaction. It
+ * identifies the type and id of the transaction, and contains the number of
+ * items logged by the transaction so we know how many to expect during
+ * recovery.
+ *
+ * Do not change the below structure without redoing the code in
+ * xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans().
+ */
+typedef struct xfs_trans_header {
+	uint		th_magic;		/* magic number */
+	uint		th_type;		/* transaction type */
+	__int32_t	th_tid;			/* transaction id (unused) */
+	uint		th_num_items;		/* num items logged by trans */
+} xfs_trans_header_t;
+
+#define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
+
+/*
+ * Log item types.
+ */
+#define	XFS_LI_EFI		0x1236
+#define	XFS_LI_EFD		0x1237
+#define	XFS_LI_IUNLINK		0x1238
+#define	XFS_LI_INODE		0x123b	/* aligned ino chunks, var-size ibufs */
+#define	XFS_LI_BUF		0x123c	/* v2 bufs, variable sized inode bufs */
+#define	XFS_LI_DQUOT		0x123d
+#define	XFS_LI_QUOTAOFF		0x123e
+#define	XFS_LI_ICREATE		0x123f
+
+#define XFS_LI_TYPE_DESC \
+	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
+	{ XFS_LI_EFD,		"XFS_LI_EFD" }, \
+	{ XFS_LI_IUNLINK,	"XFS_LI_IUNLINK" }, \
+	{ XFS_LI_INODE,		"XFS_LI_INODE" }, \
+	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
+	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
+	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
+	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
+
+/*
+ * Transaction types.  Used to distinguish types of buffers.
+ */
+#define XFS_TRANS_SETATTR_NOT_SIZE	1
+#define XFS_TRANS_SETATTR_SIZE		2
+#define XFS_TRANS_INACTIVE		3
+#define XFS_TRANS_CREATE		4
+#define XFS_TRANS_CREATE_TRUNC		5
+#define XFS_TRANS_TRUNCATE_FILE		6
+#define XFS_TRANS_REMOVE		7
+#define XFS_TRANS_LINK			8
+#define XFS_TRANS_RENAME		9
+#define XFS_TRANS_MKDIR			10
+#define XFS_TRANS_RMDIR			11
+#define XFS_TRANS_SYMLINK		12
+#define XFS_TRANS_SET_DMATTRS		13
+#define XFS_TRANS_GROWFS		14
+#define XFS_TRANS_STRAT_WRITE		15
+#define XFS_TRANS_DIOSTRAT		16
+/* 17 was XFS_TRANS_WRITE_SYNC */
+#define	XFS_TRANS_WRITEID		18
+#define	XFS_TRANS_ADDAFORK		19
+#define	XFS_TRANS_ATTRINVAL		20
+#define	XFS_TRANS_ATRUNCATE		21
+#define	XFS_TRANS_ATTR_SET		22
+#define	XFS_TRANS_ATTR_RM		23
+#define	XFS_TRANS_ATTR_FLAG		24
+#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
+#define XFS_TRANS_QM_SBCHANGE		26
+/*
+ * Dummy entries since we use the transaction type to index into the
+ * trans_type[] in xlog_recover_print_trans_head()
+ */
+#define XFS_TRANS_DUMMY1		27
+#define XFS_TRANS_DUMMY2		28
+#define XFS_TRANS_QM_QUOTAOFF		29
+#define XFS_TRANS_QM_DQALLOC		30
+#define XFS_TRANS_QM_SETQLIM		31
+#define XFS_TRANS_QM_DQCLUSTER		32
+#define XFS_TRANS_QM_QINOCREATE		33
+#define XFS_TRANS_QM_QUOTAOFF_END	34
+#define XFS_TRANS_SB_UNIT		35
+#define XFS_TRANS_FSYNC_TS		36
+#define	XFS_TRANS_GROWFSRT_ALLOC	37
+#define	XFS_TRANS_GROWFSRT_ZERO		38
+#define	XFS_TRANS_GROWFSRT_FREE		39
+#define	XFS_TRANS_SWAPEXT		40
+#define	XFS_TRANS_SB_COUNT		41
+#define	XFS_TRANS_CHECKPOINT		42
+#define	XFS_TRANS_ICREATE		43
+#define	XFS_TRANS_TYPE_MAX		43
+/* new transaction types need to be reflected in xfs_logprint(8) */
+
+#define XFS_TRANS_TYPES \
+	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
+	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
+	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
+	{ XFS_TRANS_CREATE,		"CREATE" }, \
+	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
+	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
+	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
+	{ XFS_TRANS_LINK,		"LINK" }, \
+	{ XFS_TRANS_RENAME,		"RENAME" }, \
+	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
+	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
+	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
+	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
+	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
+	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
+	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
+	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
+	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
+	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
+	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
+	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
+	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
+	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
+	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
+	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
+	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
+	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
+	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
+	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
+	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
+	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
+	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
+	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
+	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
+	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
+	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
+	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
+	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
+	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+
+
+
+/*
  * Inode Log Item Format definitions.
  *
  * This is the structure used to lay out an inode log item in the
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 36a0026..f92c2de 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -21,143 +21,6 @@
 struct xfs_log_item;
 
 /*
- * This is the structure written in the log at the head of
- * every transaction. It identifies the type and id of the
- * transaction, and contains the number of items logged by
- * the transaction so we know how many to expect during recovery.
- *
- * Do not change the below structure without redoing the code in
- * xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans().
- */
-typedef struct xfs_trans_header {
-	uint		th_magic;		/* magic number */
-	uint		th_type;		/* transaction type */
-	__int32_t	th_tid;			/* transaction id (unused) */
-	uint		th_num_items;		/* num items logged by trans */
-} xfs_trans_header_t;
-
-#define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
-
-/*
- * Log item types.
- */
-#define	XFS_LI_EFI		0x1236
-#define	XFS_LI_EFD		0x1237
-#define	XFS_LI_IUNLINK		0x1238
-#define	XFS_LI_INODE		0x123b	/* aligned ino chunks, var-size ibufs */
-#define	XFS_LI_BUF		0x123c	/* v2 bufs, variable sized inode bufs */
-#define	XFS_LI_DQUOT		0x123d
-#define	XFS_LI_QUOTAOFF		0x123e
-#define	XFS_LI_ICREATE		0x123f
-
-#define XFS_LI_TYPE_DESC \
-	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
-	{ XFS_LI_EFD,		"XFS_LI_EFD" }, \
-	{ XFS_LI_IUNLINK,	"XFS_LI_IUNLINK" }, \
-	{ XFS_LI_INODE,		"XFS_LI_INODE" }, \
-	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
-	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
-	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
-	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
-
-/*
- * Transaction types.  Used to distinguish types of buffers.
- */
-#define XFS_TRANS_SETATTR_NOT_SIZE	1
-#define XFS_TRANS_SETATTR_SIZE		2
-#define XFS_TRANS_INACTIVE		3
-#define XFS_TRANS_CREATE		4
-#define XFS_TRANS_CREATE_TRUNC		5
-#define XFS_TRANS_TRUNCATE_FILE		6
-#define XFS_TRANS_REMOVE		7
-#define XFS_TRANS_LINK			8
-#define XFS_TRANS_RENAME		9
-#define XFS_TRANS_MKDIR			10
-#define XFS_TRANS_RMDIR			11
-#define XFS_TRANS_SYMLINK		12
-#define XFS_TRANS_SET_DMATTRS		13
-#define XFS_TRANS_GROWFS		14
-#define XFS_TRANS_STRAT_WRITE		15
-#define XFS_TRANS_DIOSTRAT		16
-/* 17 was XFS_TRANS_WRITE_SYNC */
-#define	XFS_TRANS_WRITEID		18
-#define	XFS_TRANS_ADDAFORK		19
-#define	XFS_TRANS_ATTRINVAL		20
-#define	XFS_TRANS_ATRUNCATE		21
-#define	XFS_TRANS_ATTR_SET		22
-#define	XFS_TRANS_ATTR_RM		23
-#define	XFS_TRANS_ATTR_FLAG		24
-#define	XFS_TRANS_CLEAR_AGI_BUCKET	25
-#define XFS_TRANS_QM_SBCHANGE		26
-/*
- * Dummy entries since we use the transaction type to index into the
- * trans_type[] in xlog_recover_print_trans_head()
- */
-#define XFS_TRANS_DUMMY1		27
-#define XFS_TRANS_DUMMY2		28
-#define XFS_TRANS_QM_QUOTAOFF		29
-#define XFS_TRANS_QM_DQALLOC		30
-#define XFS_TRANS_QM_SETQLIM		31
-#define XFS_TRANS_QM_DQCLUSTER		32
-#define XFS_TRANS_QM_QINOCREATE		33
-#define XFS_TRANS_QM_QUOTAOFF_END	34
-#define XFS_TRANS_SB_UNIT		35
-#define XFS_TRANS_FSYNC_TS		36
-#define	XFS_TRANS_GROWFSRT_ALLOC	37
-#define	XFS_TRANS_GROWFSRT_ZERO		38
-#define	XFS_TRANS_GROWFSRT_FREE		39
-#define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_TYPE_MAX		43
-/* new transaction types need to be reflected in xfs_logprint(8) */
-
-#define XFS_TRANS_TYPES \
-	{ XFS_TRANS_SETATTR_NOT_SIZE,	"SETATTR_NOT_SIZE" }, \
-	{ XFS_TRANS_SETATTR_SIZE,	"SETATTR_SIZE" }, \
-	{ XFS_TRANS_INACTIVE,		"INACTIVE" }, \
-	{ XFS_TRANS_CREATE,		"CREATE" }, \
-	{ XFS_TRANS_CREATE_TRUNC,	"CREATE_TRUNC" }, \
-	{ XFS_TRANS_TRUNCATE_FILE,	"TRUNCATE_FILE" }, \
-	{ XFS_TRANS_REMOVE,		"REMOVE" }, \
-	{ XFS_TRANS_LINK,		"LINK" }, \
-	{ XFS_TRANS_RENAME,		"RENAME" }, \
-	{ XFS_TRANS_MKDIR,		"MKDIR" }, \
-	{ XFS_TRANS_RMDIR,		"RMDIR" }, \
-	{ XFS_TRANS_SYMLINK,		"SYMLINK" }, \
-	{ XFS_TRANS_SET_DMATTRS,	"SET_DMATTRS" }, \
-	{ XFS_TRANS_GROWFS,		"GROWFS" }, \
-	{ XFS_TRANS_STRAT_WRITE,	"STRAT_WRITE" }, \
-	{ XFS_TRANS_DIOSTRAT,		"DIOSTRAT" }, \
-	{ XFS_TRANS_WRITEID,		"WRITEID" }, \
-	{ XFS_TRANS_ADDAFORK,		"ADDAFORK" }, \
-	{ XFS_TRANS_ATTRINVAL,		"ATTRINVAL" }, \
-	{ XFS_TRANS_ATRUNCATE,		"ATRUNCATE" }, \
-	{ XFS_TRANS_ATTR_SET,		"ATTR_SET" }, \
-	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
-	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
-	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
-	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
-	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
-	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
-	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
-	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
-	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
-	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
-	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
-	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
-	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
-	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
-	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
-	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
-	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
-
-/*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
  * flags to track the state of the log item.  It also tracks
@@ -172,7 +35,6 @@ struct xfs_log_item_desc {
 
 #define XFS_LID_DIRTY		0x1
 
-#define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
 /*
  * Values for t_flags.
  */
@@ -209,7 +71,6 @@ struct xfs_log_item_desc {
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
 
-
 /*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
