Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04C2A7F56
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BE24AC003
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:48 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ig6yHtN7H1grNTVW for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:45 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phW-0004XU-Lu
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phW-00060R-Kz
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 01/50] xfs: separate out log format
	definitions
Date: Mon, 12 Aug 2013 20:49:22 +1000
Message-Id: <1376304611-22994-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

The on-disk format definitions for the log are spread randoms
through a couple of header files. Consolidate it all in a single
file that can be shared easily with userspace. This means that
xfs_log.h and xfs_log_priv.h no longer need to be shared with
userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.h         |  89 ++++++------------------
 fs/xfs/xfs_log_format.h  | 178 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h    | 146 ++------------------------------------
 fs/xfs/xfs_log_recover.c |   2 +
 4 files changed, 207 insertions(+), 208 deletions(-)
 create mode 100644 fs/xfs/xfs_log_format.h

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index fb630e4..e63d9e1 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -18,14 +18,29 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
-/* get lsn fields */
-#define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
-#define BLOCK_LSN(lsn) ((uint)(lsn))
+#include "xfs_log_format.h"
 
-/* this is used in a spot where we might otherwise double-endian-flip */
-#define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
+struct xfs_log_vec {
+	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_buf_len;	/* size of formatted buffer */
+};
+
+#define XFS_LOG_VEC_ORDERED	(-1)
+
+/*
+ * Structure used to pass callback function and the function's argument
+ * to the log manager.
+ */
+typedef struct xfs_log_callback {
+	struct xfs_log_callback	*cb_next;
+	void			(*cb_func)(void *, int);
+	void			*cb_arg;
+} xfs_log_callback_t;
 
-#ifdef __KERNEL__
 /*
  * By comparing each component, we don't have to worry about extra
  * endian issues in treating two 32 bit numbers as one 64 bit number
@@ -59,67 +74,6 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
  */
 #define XFS_LOG_SYNC		0x1
 
-#endif	/* __KERNEL__ */
-
-
-/* Log Clients */
-#define XFS_TRANSACTION		0x69
-#define XFS_VOLUME		0x2
-#define XFS_LOG			0xaa
-
-
-/* Region types for iovec's i_type */
-#define XLOG_REG_TYPE_BFORMAT		1
-#define XLOG_REG_TYPE_BCHUNK		2
-#define XLOG_REG_TYPE_EFI_FORMAT	3
-#define XLOG_REG_TYPE_EFD_FORMAT	4
-#define XLOG_REG_TYPE_IFORMAT		5
-#define XLOG_REG_TYPE_ICORE		6
-#define XLOG_REG_TYPE_IEXT		7
-#define XLOG_REG_TYPE_IBROOT		8
-#define XLOG_REG_TYPE_ILOCAL		9
-#define XLOG_REG_TYPE_IATTR_EXT		10
-#define XLOG_REG_TYPE_IATTR_BROOT	11
-#define XLOG_REG_TYPE_IATTR_LOCAL	12
-#define XLOG_REG_TYPE_QFORMAT		13
-#define XLOG_REG_TYPE_DQUOT		14
-#define XLOG_REG_TYPE_QUOTAOFF		15
-#define XLOG_REG_TYPE_LRHEADER		16
-#define XLOG_REG_TYPE_UNMOUNT		17
-#define XLOG_REG_TYPE_COMMIT		18
-#define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_ICREATE		20
-#define XLOG_REG_TYPE_MAX		20
-
-typedef struct xfs_log_iovec {
-	void		*i_addr;	/* beginning address of region */
-	int		i_len;		/* length in bytes of region */
-	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
-
-struct xfs_log_vec {
-	struct xfs_log_vec	*lv_next;	/* next lv in build list */
-	int			lv_niovecs;	/* number of iovecs in lv */
-	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
-	struct xfs_log_item	*lv_item;	/* owner */
-	char			*lv_buf;	/* formatted buffer */
-	int			lv_buf_len;	/* size of formatted buffer */
-};
-
-#define XFS_LOG_VEC_ORDERED	(-1)
-
-/*
- * Structure used to pass callback function and the function's argument
- * to the log manager.
- */
-typedef struct xfs_log_callback {
-	struct xfs_log_callback	*cb_next;
-	void			(*cb_func)(void *, int);
-	void			*cb_arg;
-} xfs_log_callback_t;
-
-
-#ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
 struct xlog_in_core;
@@ -188,5 +142,4 @@ void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_worker(struct work_struct *work);
 void	xfs_log_quiesce(struct xfs_mount *mp);
 
-#endif
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
new file mode 100644
index 0000000..9f9aeb6
--- /dev/null
+++ b/fs/xfs/xfs_log_format.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
+#ifndef	__XFS_LOG_FORMAT_H__
+#define __XFS_LOG_FORMAT_H__
+
+typedef __uint32_t xlog_tid_t;
+
+#define XLOG_MIN_ICLOGS		2
+#define XLOG_MAX_ICLOGS		8
+#define XLOG_HEADER_MAGIC_NUM	0xFEEDbabe	/* Invalid cycle number */
+#define XLOG_VERSION_1		1
+#define XLOG_VERSION_2		2		/* Large IClogs, Log sunit */
+#define XLOG_VERSION_OKBITS	(XLOG_VERSION_1 | XLOG_VERSION_2)
+#define XLOG_MIN_RECORD_BSIZE	(16*1024)	/* eventually 32k */
+#define XLOG_BIG_RECORD_BSIZE	(32*1024)	/* 32k buffers */
+#define XLOG_MAX_RECORD_BSIZE	(256*1024)
+#define XLOG_HEADER_CYCLE_SIZE	(32*1024)	/* cycle data in header */
+#define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
+#define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
+#define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
+#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
+                                 (log)->l_mp->m_sb.sb_logsunit)
+#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
+
+#define XLOG_HEADER_SIZE	512
+
+#define XLOG_REC_SHIFT(log) \
+	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
+	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
+#define XLOG_TOTAL_REC_SHIFT(log) \
+	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
+	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
+
+/* get lsn fields */
+#define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
+#define BLOCK_LSN(lsn) ((uint)(lsn))
+
+/* this is used in a spot where we might otherwise double-endian-flip */
+#define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
+
+static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
+{
+	return ((xfs_lsn_t)cycle << 32) | block;
+}
+
+static inline uint xlog_get_cycle(char *ptr)
+{
+	if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
+		return be32_to_cpu(*((__be32 *)ptr + 1));
+	else
+		return be32_to_cpu(*(__be32 *)ptr);
+}
+
+/* Log Clients */
+#define XFS_TRANSACTION		0x69
+#define XFS_VOLUME		0x2
+#define XFS_LOG			0xaa
+
+#define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
+
+/* Region types for iovec's i_type */
+#define XLOG_REG_TYPE_BFORMAT		1
+#define XLOG_REG_TYPE_BCHUNK		2
+#define XLOG_REG_TYPE_EFI_FORMAT	3
+#define XLOG_REG_TYPE_EFD_FORMAT	4
+#define XLOG_REG_TYPE_IFORMAT		5
+#define XLOG_REG_TYPE_ICORE		6
+#define XLOG_REG_TYPE_IEXT		7
+#define XLOG_REG_TYPE_IBROOT		8
+#define XLOG_REG_TYPE_ILOCAL		9
+#define XLOG_REG_TYPE_IATTR_EXT		10
+#define XLOG_REG_TYPE_IATTR_BROOT	11
+#define XLOG_REG_TYPE_IATTR_LOCAL	12
+#define XLOG_REG_TYPE_QFORMAT		13
+#define XLOG_REG_TYPE_DQUOT		14
+#define XLOG_REG_TYPE_QUOTAOFF		15
+#define XLOG_REG_TYPE_LRHEADER		16
+#define XLOG_REG_TYPE_UNMOUNT		17
+#define XLOG_REG_TYPE_COMMIT		18
+#define XLOG_REG_TYPE_TRANSHDR		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_MAX		20
+
+/*
+ * Flags to log operation header
+ *
+ * The first write of a new transaction will be preceded with a start
+ * record, XLOG_START_TRANS.  Once a transaction is committed, a commit
+ * record is written, XLOG_COMMIT_TRANS.  If a single region can not fit into
+ * the remainder of the current active in-core log, it is split up into
+ * multiple regions.  Each partial region will be marked with a
+ * XLOG_CONTINUE_TRANS until the last one, which gets marked with XLOG_END_TRANS.
+ *
+ */
+#define XLOG_START_TRANS	0x01	/* Start a new transaction */
+#define XLOG_COMMIT_TRANS	0x02	/* Commit this transaction */
+#define XLOG_CONTINUE_TRANS	0x04	/* Cont this trans into new region */
+#define XLOG_WAS_CONT_TRANS	0x08	/* Cont this trans into new region */
+#define XLOG_END_TRANS		0x10	/* End a continued transaction */
+#define XLOG_UNMOUNT_TRANS	0x20	/* Unmount a filesystem transaction */
+
+
+typedef struct xlog_op_header {
+	__be32	   oh_tid;	/* transaction id of operation	:  4 b */
+	__be32	   oh_len;	/* bytes in data region		:  4 b */
+	__u8	   oh_clientid;	/* who sent me this		:  1 b */
+	__u8	   oh_flags;	/*				:  1 b */
+	__u16	   oh_res2;	/* 32 bit align			:  2 b */
+} xlog_op_header_t;
+
+
+/* valid values for h_fmt */
+#define XLOG_FMT_UNKNOWN  0
+#define XLOG_FMT_LINUX_LE 1
+#define XLOG_FMT_LINUX_BE 2
+#define XLOG_FMT_IRIX_BE  3
+
+/* our fmt */
+#ifdef XFS_NATIVE_HOST
+#define XLOG_FMT XLOG_FMT_LINUX_BE
+#else
+#define XLOG_FMT XLOG_FMT_LINUX_LE
+#endif
+
+typedef struct xlog_rec_header {
+	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
+	__be32	  h_cycle;	/* write cycle of log			:  4 */
+	__be32	  h_version;	/* LR version				:  4 */
+	__be32	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
+	__be64	  h_lsn;	/* lsn of this LR			:  8 */
+	__be64	  h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
+	__le32	  h_crc;	/* crc of log record                    :  4 */
+	__be32	  h_prev_block; /* block number to previous LR		:  4 */
+	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
+	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
+	/* new fields */
+	__be32    h_fmt;        /* format of log record                 :  4 */
+	uuid_t	  h_fs_uuid;    /* uuid of FS                           : 16 */
+	__be32	  h_size;	/* iclog size				:  4 */
+} xlog_rec_header_t;
+
+typedef struct xlog_rec_ext_header {
+	__be32	  xh_cycle;	/* write cycle of log			: 4 */
+	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
+} xlog_rec_ext_header_t;
+
+/*
+ * Quite misnamed, because this union lays out the actual on-disk log buffer.
+ */
+typedef union xlog_in_core2 {
+	xlog_rec_header_t	hic_header;
+	xlog_rec_ext_header_t	hic_xheader;
+	char			hic_sector[XLOG_HEADER_SIZE];
+} xlog_in_core_2_t;
+
+/* not an on-disk structure, but needed by log recovery in userspace */
+typedef struct xfs_log_iovec {
+	void		*i_addr;	/* beginning address of region */
+	int		i_len;		/* length in bytes of region */
+	uint		i_type;		/* type of region */
+} xfs_log_iovec_t;
+
+#endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b9ea262..edd0964 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -24,51 +24,13 @@ struct xlog_ticket;
 struct xfs_mount;
 
 /*
- * Macros, structures, prototypes for internal log manager use.
+ * Flags for log structure
  */
-
-#define XLOG_MIN_ICLOGS		2
-#define XLOG_MAX_ICLOGS		8
-#define XLOG_HEADER_MAGIC_NUM	0xFEEDbabe	/* Invalid cycle number */
-#define XLOG_VERSION_1		1
-#define XLOG_VERSION_2		2		/* Large IClogs, Log sunit */
-#define XLOG_VERSION_OKBITS	(XLOG_VERSION_1 | XLOG_VERSION_2)
-#define XLOG_MIN_RECORD_BSIZE	(16*1024)	/* eventually 32k */
-#define XLOG_BIG_RECORD_BSIZE	(32*1024)	/* 32k buffers */
-#define XLOG_MAX_RECORD_BSIZE	(256*1024)
-#define XLOG_HEADER_CYCLE_SIZE	(32*1024)	/* cycle data in header */
-#define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
-#define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
-#define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
-#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
-                                 (log)->l_mp->m_sb.sb_logsunit)
-#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
-
-#define XLOG_HEADER_SIZE	512
-
-#define XLOG_REC_SHIFT(log) \
-	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
-	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
-#define XLOG_TOTAL_REC_SHIFT(log) \
-	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
-	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
-
-static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
-{
-	return ((xfs_lsn_t)cycle << 32) | block;
-}
-
-static inline uint xlog_get_cycle(char *ptr)
-{
-	if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
-		return be32_to_cpu(*((__be32 *)ptr + 1));
-	else
-		return be32_to_cpu(*(__be32 *)ptr);
-}
-
-#define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
-
-#ifdef __KERNEL__
+#define XLOG_ACTIVE_RECOVERY	0x2	/* in the middle of recovery */
+#define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
+#define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
+					   shutdown */
+#define XLOG_TAIL_WARN		0x10	/* log tail verify warning issued */
 
 /*
  * get client id from packed copy.
@@ -101,28 +63,8 @@ static inline uint xlog_get_client_id(__be32 i)
 #define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
 #define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
 #define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
-#endif	/* __KERNEL__ */
 
 /*
- * Flags to log operation header
- *
- * The first write of a new transaction will be preceded with a start
- * record, XLOG_START_TRANS.  Once a transaction is committed, a commit
- * record is written, XLOG_COMMIT_TRANS.  If a single region can not fit into
- * the remainder of the current active in-core log, it is split up into
- * multiple regions.  Each partial region will be marked with a
- * XLOG_CONTINUE_TRANS until the last one, which gets marked with XLOG_END_TRANS.
- *
- */
-#define XLOG_START_TRANS	0x01	/* Start a new transaction */
-#define XLOG_COMMIT_TRANS	0x02	/* Commit this transaction */
-#define XLOG_CONTINUE_TRANS	0x04	/* Cont this trans into new region */
-#define XLOG_WAS_CONT_TRANS	0x08	/* Cont this trans into new region */
-#define XLOG_END_TRANS		0x10	/* End a continued transaction */
-#define XLOG_UNMOUNT_TRANS	0x20	/* Unmount a filesystem transaction */
-
-#ifdef __KERNEL__
-/*
  * Flags to log ticket
  */
 #define XLOG_TIC_INITED		0x1	/* has been initialized */
@@ -132,22 +74,6 @@ static inline uint xlog_get_client_id(__be32 i)
 	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
 	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
 
-#endif	/* __KERNEL__ */
-
-#define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
-
-/*
- * Flags for log structure
- */
-#define XLOG_ACTIVE_RECOVERY	0x2	/* in the middle of recovery */
-#define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
-#define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
-					   shutdown */
-#define XLOG_TAIL_WARN		0x10	/* log tail verify warning issued */
-
-typedef __uint32_t xlog_tid_t;
-
-#ifdef __KERNEL__
 /*
  * Below are states for covering allocation transactions.
  * By covering, we mean changing the h_tail_lsn in the last on-disk
@@ -223,7 +149,6 @@ typedef __uint32_t xlog_tid_t;
 
 #define XLOG_COVER_OPS		5
 
-
 /* Ticket reservation region accounting */ 
 #define XLOG_TIC_LEN_MAX	15
 
@@ -258,64 +183,6 @@ typedef struct xlog_ticket {
 	xlog_res_t	   t_res_arr[XLOG_TIC_LEN_MAX];  /* array of res : 8 * 15 */ 
 } xlog_ticket_t;
 
-#endif
-
-
-typedef struct xlog_op_header {
-	__be32	   oh_tid;	/* transaction id of operation	:  4 b */
-	__be32	   oh_len;	/* bytes in data region		:  4 b */
-	__u8	   oh_clientid;	/* who sent me this		:  1 b */
-	__u8	   oh_flags;	/*				:  1 b */
-	__u16	   oh_res2;	/* 32 bit align			:  2 b */
-} xlog_op_header_t;
-
-
-/* valid values for h_fmt */
-#define XLOG_FMT_UNKNOWN  0
-#define XLOG_FMT_LINUX_LE 1
-#define XLOG_FMT_LINUX_BE 2
-#define XLOG_FMT_IRIX_BE  3
-
-/* our fmt */
-#ifdef XFS_NATIVE_HOST
-#define XLOG_FMT XLOG_FMT_LINUX_BE
-#else
-#define XLOG_FMT XLOG_FMT_LINUX_LE
-#endif
-
-typedef struct xlog_rec_header {
-	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
-	__be32	  h_cycle;	/* write cycle of log			:  4 */
-	__be32	  h_version;	/* LR version				:  4 */
-	__be32	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
-	__be64	  h_lsn;	/* lsn of this LR			:  8 */
-	__be64	  h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
-	__le32	  h_crc;	/* crc of log record                    :  4 */
-	__be32	  h_prev_block; /* block number to previous LR		:  4 */
-	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
-	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
-	/* new fields */
-	__be32    h_fmt;        /* format of log record                 :  4 */
-	uuid_t	  h_fs_uuid;    /* uuid of FS                           : 16 */
-	__be32	  h_size;	/* iclog size				:  4 */
-} xlog_rec_header_t;
-
-typedef struct xlog_rec_ext_header {
-	__be32	  xh_cycle;	/* write cycle of log			: 4 */
-	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
-} xlog_rec_ext_header_t;
-
-#ifdef __KERNEL__
-
-/*
- * Quite misnamed, because this union lays out the actual on-disk log buffer.
- */
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
-
 /*
  * - A log record header is 512 bytes.  There is plenty of room to grow the
  *	xlog_rec_header_t into the reserved space.
@@ -686,6 +553,5 @@ static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
 	schedule();
 	remove_wait_queue(wq, &wait);
 }
-#endif	/* __KERNEL__ */
 
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7681b19..7d3fc9e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -55,6 +55,8 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
 
+#define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
+
 STATIC int
 xlog_find_zeroed(
 	struct xlog	*,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
