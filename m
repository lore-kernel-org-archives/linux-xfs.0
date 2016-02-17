Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 160EE7CA7
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:52:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C916AC010
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:52:47 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id CaAKgQWV4r7vtUBh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:52:44 -0800 (PST)
Received: from 212095007014.public.telering.at ([212.95.7.14] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aVxql-0003HO-DL
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 08:52:43 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: remove transaction types
Date: Wed, 17 Feb 2016 09:52:39 +0100
Message-Id: <1455699159-20906-3-git-send-email-hch@lst.de>
In-Reply-To: <1455699159-20906-1-git-send-email-hch@lst.de>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
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

These aren't used for CIL-style logging and can be dropped.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |  5 +++
 fs/xfs/libxfs/xfs_shared.h     | 97 ------------------------------------------
 fs/xfs/xfs_log.c               | 57 +------------------------
 fs/xfs/xfs_log.h               |  3 +-
 fs/xfs/xfs_log_cil.c           |  1 -
 fs/xfs/xfs_log_priv.h          |  1 -
 fs/xfs/xfs_trace.h             |  5 +--
 fs/xfs/xfs_trans.c             |  2 +-
 8 files changed, 10 insertions(+), 161 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index d54a801..e8f49c0 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -212,6 +212,11 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
 
 /*
+ * The only type valid for th_type in CIL-enabled file system logs:
+ */
+#define XFS_TRANS_CHECKPOINT	40
+
+/*
  * Log item types.
  */
 #define	XFS_LI_EFI		0x1236
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 7d4ab64..16002b5 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -56,103 +56,6 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 
 /*
- * Transaction types.  Used to distinguish types of buffers. These never reach
- * the log.
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
-#define XFS_TRANS_SB_CHANGE		26
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
-#define XFS_TRANS_FSYNC_TS		35
-#define	XFS_TRANS_GROWFSRT_ALLOC	36
-#define	XFS_TRANS_GROWFSRT_ZERO		37
-#define	XFS_TRANS_GROWFSRT_FREE		38
-#define	XFS_TRANS_SWAPEXT		39
-#define	XFS_TRANS_CHECKPOINT		40
-#define	XFS_TRANS_ICREATE		41
-#define	XFS_TRANS_CREATE_TMPFILE	42
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
-	{ XFS_TRANS_SB_CHANGE,		"SBCHANGE" }, \
-	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
-	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
-	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
-	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
-	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
-	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
-	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
-	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
-	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
-	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
-	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
-	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
-	{ XFS_TRANS_ICREATE,		"ICREATE" }, \
-	{ XFS_TRANS_CREATE_TMPFILE,	"CREATE_TMPFILE" }, \
-	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
-
-/*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
  * flags to track the state of the log item.  It also tracks
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 40b700d..9c76951 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -435,8 +435,7 @@ xfs_log_reserve(
 	int		 	cnt,
 	struct xlog_ticket	**ticp,
 	__uint8_t	 	client,
-	bool			permanent,
-	uint		 	t_type)
+	bool			permanent)
 {
 	struct xlog		*log = mp->m_log;
 	struct xlog_ticket	*tic;
@@ -456,7 +455,6 @@ xfs_log_reserve(
 	if (!tic)
 		return -ENOMEM;
 
-	tic->t_trans_type = t_type;
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -823,8 +821,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		error = xfs_log_reserve(mp, 600, 1, &tic,
-					XFS_LOG, 0, XLOG_UNMOUNT_REC_TYPE);
+		error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
 		if (!error) {
 			/* the data section must be 32 bit size aligned */
 			struct {
@@ -2029,57 +2026,8 @@ xlog_print_tic_res(
 	    "commit",
 	    "trans header"
 	};
-	static char *trans_type_str[XFS_TRANS_TYPE_MAX] = {
-	    "SETATTR_NOT_SIZE",
-	    "SETATTR_SIZE",
-	    "INACTIVE",
-	    "CREATE",
-	    "CREATE_TRUNC",
-	    "TRUNCATE_FILE",
-	    "REMOVE",
-	    "LINK",
-	    "RENAME",
-	    "MKDIR",
-	    "RMDIR",
-	    "SYMLINK",
-	    "SET_DMATTRS",
-	    "GROWFS",
-	    "STRAT_WRITE",
-	    "DIOSTRAT",
-	    "WRITE_SYNC",
-	    "WRITEID",
-	    "ADDAFORK",
-	    "ATTRINVAL",
-	    "ATRUNCATE",
-	    "ATTR_SET",
-	    "ATTR_RM",
-	    "ATTR_FLAG",
-	    "CLEAR_AGI_BUCKET",
-	    "QM_SBCHANGE",
-	    "DUMMY1",
-	    "DUMMY2",
-	    "QM_QUOTAOFF",
-	    "QM_DQALLOC",
-	    "QM_SETQLIM",
-	    "QM_DQCLUSTER",
-	    "QM_QINOCREATE",
-	    "QM_QUOTAOFF_END",
-	    "FSYNC_TS",
-	    "GROWFSRT_ALLOC",
-	    "GROWFSRT_ZERO",
-	    "GROWFSRT_FREE",
-	    "SWAPEXT",
-	    "CHECKPOINT",
-	    "ICREATE",
-	    "CREATE_TMPFILE"
-	};
 
 	xfs_warn(mp, "xlog_write: reservation summary:");
-	xfs_warn(mp, "  trans type  = %s (%u)",
-		 ((ticket->t_trans_type <= 0 ||
-		   ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
-		  "bad-trans-type" : trans_type_str[ticket->t_trans_type-1]),
-		 ticket->t_trans_type);
 	xfs_warn(mp, "  unit res    = %d bytes",
 		 ticket->t_unit_res);
 	xfs_warn(mp, "  current res = %d bytes",
@@ -3705,7 +3653,6 @@ xlog_ticket_alloc(
 	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
 	tic->t_flags		= XLOG_TIC_INITED;
-	tic->t_trans_type	= 0;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index aa533a7..80ba0c0 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -161,8 +161,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   count,
 			  struct xlog_ticket **ticket,
 			  __uint8_t	   clientid,
-			  bool		   permanent,
-			  uint		   t_type);
+			  bool		   permanent);
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
 void      xfs_log_unmount(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4e76493..5e54e79 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -51,7 +51,6 @@ xlog_cil_ticket_alloc(
 
 	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
 				KM_SLEEP|KM_NOFS);
-	tic->t_trans_type = XFS_TRANS_CHECKPOINT;
 
 	/*
 	 * set the current reservation to zero so we know to steal the basic
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ed88963..765f084 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -175,7 +175,6 @@ typedef struct xlog_ticket {
 	char		   t_cnt;	 /* current count		 : 1  */
 	char		   t_clientid;	 /* who does this belong to;	 : 1  */
 	char		   t_flags;	 /* properties of reservation	 : 1  */
-	uint		   t_trans_type; /* transaction type             : 4  */
 
         /* reservation array fields */
 	uint		   t_res_num;                    /* num in array : 4 */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c8d5842..f081294 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -944,7 +944,6 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_ARGS(log, tic),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(unsigned, trans_type)
 		__field(char, ocnt)
 		__field(char, cnt)
 		__field(int, curr_res)
@@ -962,7 +961,6 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	),
 	TP_fast_assign(
 		__entry->dev = log->l_mp->m_super->s_dev;
-		__entry->trans_type = tic->t_trans_type;
 		__entry->ocnt = tic->t_ocnt;
 		__entry->cnt = tic->t_cnt;
 		__entry->curr_res = tic->t_curr_res;
@@ -980,14 +978,13 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
-	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
+	TP_printk("dev %d:%d t_ocnt %u t_cnt %u t_curr_res %u "
 		  "t_unit_res %u t_flags %s reserveq %s "
 		  "writeq %s grant_reserve_cycle %d "
 		  "grant_reserve_bytes %d grant_write_cycle %d "
 		  "grant_write_bytes %d curr_cycle %d curr_block %d "
 		  "tail_cycle %d tail_block %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->trans_type, XFS_TRANS_TYPES),
 		  __entry->ocnt,
 		  __entry->cnt,
 		  __entry->curr_res,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index cbbef3a..5052714 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -177,7 +177,7 @@ xfs_trans_reserve(
 						resp->tr_logres,
 						resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
-						permanent, 0);
+						permanent);
 		}
 
 		if (error)
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
