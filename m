Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09ABF29E11
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0338304048
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WGvUNYihrgC5tDUm for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLD9-0007dZ-UN
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLD9-0003st-Tc
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/55] xfs: split out on-disk transaction definitions
Date: Thu,  5 Sep 2013 08:05:26 +1000
Message-Id: <1378332359-14737-23-git-send-email-david@fromorbit.com>
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

There's a bunch of definitions in xfs_trans.h that define on-disk
formats - transaction headers taht get written into the log, log
item type definitions, etc. Split out everything into a separate
file so that all which remains in xfs_trans.h are kernel only
definitions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_log_format.h | 207 +++++++++++++++++++++++++++++++++++++++++++++++
 include/xfs_trans.h      | 207 +----------------------------------------------
 2 files changed, 208 insertions(+), 206 deletions(-)

diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 51d4932..13a0734 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -187,6 +187,213 @@ typedef struct xfs_log_iovec {
 
 
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
+/*
+ * This structure is used to track log items associated with
+ * a transaction.  It points to the log item and keeps some
+ * flags to track the state of the log item.  It also tracks
+ * the amount of space needed to log the item it describes
+ * once we get to commit processing (see xfs_trans_commit()).
+ */
+struct xfs_log_item_desc {
+	struct xfs_log_item	*lid_item;
+	struct list_head	lid_trans;
+	unsigned char		lid_flags;
+};
+
+#define XFS_LID_DIRTY		0x1
+
+/*
+ * Values for t_flags.
+ */
+#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
+#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
+#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
+#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
+#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
+#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
+#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
+					   count in superblock */
+
+/*
+ * Values for call flags parameter.
+ */
+#define	XFS_TRANS_RELEASE_LOG_RES	0x4
+#define	XFS_TRANS_ABORT			0x8
+
+/*
+ * Field values for xfs_trans_mod_sb.
+ */
+#define	XFS_TRANS_SB_ICOUNT		0x00000001
+#define	XFS_TRANS_SB_IFREE		0x00000002
+#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
+#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
+#define	XFS_TRANS_SB_FREXTENTS		0x00000010
+#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
+#define	XFS_TRANS_SB_DBLOCKS		0x00000040
+#define	XFS_TRANS_SB_AGCOUNT		0x00000080
+#define	XFS_TRANS_SB_IMAXPCT		0x00000100
+#define	XFS_TRANS_SB_REXTSIZE		0x00000200
+#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
+#define	XFS_TRANS_SB_RBLOCKS		0x00000800
+#define	XFS_TRANS_SB_REXTENTS		0x00001000
+#define	XFS_TRANS_SB_REXTSLOG		0x00002000
+
+/*
+ * Here we centralize the specification of XFS meta-data buffer
+ * reference count values.  This determine how hard the buffer
+ * cache tries to hold onto the buffer.
+ */
+#define	XFS_AGF_REF		4
+#define	XFS_AGI_REF		4
+#define	XFS_AGFL_REF		3
+#define	XFS_INO_BTREE_REF	3
+#define	XFS_ALLOC_BTREE_REF	2
+#define	XFS_BMAP_BTREE_REF	2
+#define	XFS_DIR_BTREE_REF	2
+#define	XFS_INO_REF		2
+#define	XFS_ATTR_BTREE_REF	1
+#define	XFS_DQUOT_REF		1
+
+
+/*
  * Inode Log Item Format definitions.
  *
  * This is the structure used to lay out an inode log item in the
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 36a0026..de5a8e7 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -18,197 +18,8 @@
 #ifndef	__XFS_TRANS_H__
 #define	__XFS_TRANS_H__
 
-struct xfs_log_item;
-
-/*
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
- * This structure is used to track log items associated with
- * a transaction.  It points to the log item and keeps some
- * flags to track the state of the log item.  It also tracks
- * the amount of space needed to log the item it describes
- * once we get to commit processing (see xfs_trans_commit()).
- */
-struct xfs_log_item_desc {
-	struct xfs_log_item	*lid_item;
-	struct list_head	lid_trans;
-	unsigned char		lid_flags;
-};
-
-#define XFS_LID_DIRTY		0x1
-
-#define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
-/*
- * Values for t_flags.
- */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_FREEZE_PROT	0x40	/* Transaction has elevated writer
-					   count in superblock */
-
-/*
- * Values for call flags parameter.
- */
-#define	XFS_TRANS_RELEASE_LOG_RES	0x4
-#define	XFS_TRANS_ABORT			0x8
-
-/*
- * Field values for xfs_trans_mod_sb.
- */
-#define	XFS_TRANS_SB_ICOUNT		0x00000001
-#define	XFS_TRANS_SB_IFREE		0x00000002
-#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
-#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
-#define	XFS_TRANS_SB_FREXTENTS		0x00000010
-#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
-#define	XFS_TRANS_SB_DBLOCKS		0x00000040
-#define	XFS_TRANS_SB_AGCOUNT		0x00000080
-#define	XFS_TRANS_SB_IMAXPCT		0x00000100
-#define	XFS_TRANS_SB_REXTSIZE		0x00000200
-#define	XFS_TRANS_SB_RBMBLOCKS		0x00000400
-#define	XFS_TRANS_SB_RBLOCKS		0x00000800
-#define	XFS_TRANS_SB_REXTENTS		0x00001000
-#define	XFS_TRANS_SB_REXTSLOG		0x00002000
 
+struct xfs_log_item;
 
 /*
  * Per-extent log reservation for the allocation btree changes
@@ -283,22 +94,6 @@ struct xfs_log_item_desc {
 #define	XFS_ATTRSET_LOG_COUNT		3
 #define	XFS_ATTRRM_LOG_COUNT		3
 
-/*
- * Here we centralize the specification of XFS meta-data buffer
- * reference count values.  This determine how hard the buffer
- * cache tries to hold onto the buffer.
- */
-#define	XFS_AGF_REF		4
-#define	XFS_AGI_REF		4
-#define	XFS_AGFL_REF		3
-#define	XFS_INO_BTREE_REF	3
-#define	XFS_ALLOC_BTREE_REF	2
-#define	XFS_BMAP_BTREE_REF	2
-#define	XFS_DIR_BTREE_REF	2
-#define	XFS_INO_REF		2
-#define	XFS_ATTR_BTREE_REF	1
-#define	XFS_DQUOT_REF		1
-
 #ifdef __KERNEL__
 
 struct xfs_buf;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
