Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5687A8024
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38E748F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ONwtX8u0PDq92Qzk for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004IW-SU
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002KK-RS
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/49] xfs: separate out log format definitions
Date: Fri, 19 Jul 2013 16:44:51 +1000
Message-Id: <1374216324-8781-17-git-send-email-david@fromorbit.com>
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

The on-disk format definitions for the log are spread randoms
through a couple of header files. Consolidate it all in a single
file that can be shared easily with userspace. This means that
xfs_log.h and xfs_log_priv.h no longer need to be shared with
userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile          |   4 +-
 include/libxfs.h          |   4 +-
 include/libxlog.h         |   6 -
 include/xfs_log.h         | 190 -------------
 include/xfs_log_format.h  | 178 ++++++++++++
 include/xfs_log_priv.h    | 692 ----------------------------------------------
 libxfs/rdwr.c             |   2 -
 libxlog/xfs_log_recover.c |   3 +
 8 files changed, 186 insertions(+), 893 deletions(-)
 delete mode 100644 include/xfs_log.h
 create mode 100644 include/xfs_log_format.h
 delete mode 100644 include/xfs_log_priv.h

diff --git a/include/Makefile b/include/Makefile
index ba2c80d..efa3275 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -27,7 +27,9 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
 	xfs_icreate_item.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
-	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
+	xfs_log_format.h \
+	xfs_log_recover.h \
+	xfs_metadump.h \
 	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_symlink.h \
 	xfs_trace.h xfs_trans.h xfs_trans_space.h xfs_dfrag.h
 
diff --git a/include/libxfs.h b/include/libxfs.h
index e776211..c9918cd 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -59,6 +59,8 @@
 #include <xfs/xfs_symlink.h>
 #include <xfs/xfs_icreate_item.h>
 
+#include <xfs/xfs_log_format.h>
+
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
@@ -613,8 +615,6 @@ extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 #include <xfs/xfs_attr_remote.h>
 #include <xfs/xfs_quota.h>
 #include <xfs/xfs_trans_space.h>
-#include <xfs/xfs_log.h>
-#include <xfs/xfs_log_priv.h>
 
 #define XFS_INOBT_IS_FREE_DISK(rp,i)		\
 			((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
diff --git a/include/libxlog.h b/include/libxlog.h
index ff711e9..961c4b5 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -53,12 +53,6 @@ struct xlog {
 #include <xfs/xfs_extfree_item.h>
 #include <xfs/xfs_icreate_item.h>
 
-typedef union {
-	xlog_rec_header_t       hic_header;
-	xlog_rec_ext_header_t   hic_xheader;
-	char                    hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
-
 /*
  * macros mapping kernel code to user code
  */
diff --git a/include/xfs_log.h b/include/xfs_log.h
deleted file mode 100644
index 70cc014..0000000
--- a/include/xfs_log.h
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef	__XFS_LOG_H__
-#define __XFS_LOG_H__
-
-/* get lsn fields */
-#define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
-#define BLOCK_LSN(lsn) ((uint)(lsn))
-
-/* this is used in a spot where we might otherwise double-endian-flip */
-#define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
-
-#ifdef __KERNEL__
-/*
- * By comparing each component, we don't have to worry about extra
- * endian issues in treating two 32 bit numbers as one 64 bit number
- */
-static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
-{
-	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
-		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
-
-	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
-		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
-
-	return 0;
-}
-
-#define	XFS_LSN_CMP(x,y) _lsn_cmp(x,y)
-
-/*
- * Macros, structures, prototypes for interface to the log manager.
- */
-
-/*
- * Flags to xfs_log_done()
- */
-#define XFS_LOG_REL_PERM_RESERV	0x1
-
-/*
- * Flags to xfs_log_force()
- *
- *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
- */
-#define XFS_LOG_SYNC		0x1
-
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
-/* Log manager interfaces */
-struct xfs_mount;
-struct xlog_in_core;
-struct xlog_ticket;
-struct xfs_log_item;
-struct xfs_item_ops;
-struct xfs_trans;
-
-void	xfs_log_item_init(struct xfs_mount	*mp,
-			struct xfs_log_item	*item,
-			int			type,
-			const struct xfs_item_ops *ops);
-
-xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
-		       struct xlog_ticket *ticket,
-		       struct xlog_in_core **iclog,
-		       uint		flags);
-int	  _xfs_log_force(struct xfs_mount *mp,
-			 uint		flags,
-			 int		*log_forced);
-void	  xfs_log_force(struct xfs_mount	*mp,
-			uint			flags);
-int	  _xfs_log_force_lsn(struct xfs_mount *mp,
-			     xfs_lsn_t		lsn,
-			     uint		flags,
-			     int		*log_forced);
-void	  xfs_log_force_lsn(struct xfs_mount	*mp,
-			    xfs_lsn_t		lsn,
-			    uint		flags);
-int	  xfs_log_mount(struct xfs_mount	*mp,
-			struct xfs_buftarg	*log_target,
-			xfs_daddr_t		start_block,
-			int		 	num_bblocks);
-int	  xfs_log_mount_finish(struct xfs_mount *mp);
-xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
-void	  xfs_log_space_wake(struct xfs_mount *mp);
-int	  xfs_log_notify(struct xfs_mount	*mp,
-			 struct xlog_in_core	*iclog,
-			 xfs_log_callback_t	*callback_entry);
-int	  xfs_log_release_iclog(struct xfs_mount *mp,
-			 struct xlog_in_core	 *iclog);
-int	  xfs_log_reserve(struct xfs_mount *mp,
-			  int		   length,
-			  int		   count,
-			  struct xlog_ticket **ticket,
-			  __uint8_t	   clientid,
-			  bool		   permanent,
-			  uint		   t_type);
-int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
-int	  xfs_log_unmount_write(struct xfs_mount *mp);
-void      xfs_log_unmount(struct xfs_mount *mp);
-int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
-int	  xfs_log_need_covered(struct xfs_mount *mp);
-
-void	  xlog_iodone(struct xfs_buf *);
-
-struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
-void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
-
-int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
-				xfs_lsn_t *commit_lsn, int flags);
-bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
-
-void	xfs_log_work_queue(struct xfs_mount *mp);
-void	xfs_log_worker(struct work_struct *work);
-void	xfs_log_quiesce(struct xfs_mount *mp);
-
-#endif
-#endif	/* __XFS_LOG_H__ */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
new file mode 100644
index 0000000..9f9aeb6
--- /dev/null
+++ b/include/xfs_log_format.h
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
diff --git a/include/xfs_log_priv.h b/include/xfs_log_priv.h
deleted file mode 100644
index 16d8d12..0000000
--- a/include/xfs_log_priv.h
+++ /dev/null
@@ -1,692 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef	__XFS_LOG_PRIV_H__
-#define __XFS_LOG_PRIV_H__
-
-struct xfs_buf;
-struct xlog;
-struct xlog_ticket;
-struct xfs_mount;
-
-/*
- * Macros, structures, prototypes for internal log manager use.
- */
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
-
-/*
- * get client id from packed copy.
- *
- * this hack is here because the xlog_pack code copies four bytes
- * of xlog_op_header containing the fields oh_clientid, oh_flags
- * and oh_res2 into the packed copy.
- *
- * later on this four byte chunk is treated as an int and the
- * client id is pulled out.
- *
- * this has endian issues, of course.
- */
-static inline uint xlog_get_client_id(__be32 i)
-{
-	return be32_to_cpu(i) >> 24;
-}
-
-/*
- * In core log state
- */
-#define XLOG_STATE_ACTIVE    0x0001 /* Current IC log being written to */
-#define XLOG_STATE_WANT_SYNC 0x0002 /* Want to sync this iclog; no more writes */
-#define XLOG_STATE_SYNCING   0x0004 /* This IC log is syncing */
-#define XLOG_STATE_DONE_SYNC 0x0008 /* Done syncing to disk */
-#define XLOG_STATE_DO_CALLBACK \
-			     0x0010 /* Process callback functions */
-#define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
-#define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
-#define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
-#define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
-#define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
-#endif	/* __KERNEL__ */
-
-/*
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
- * Flags to log ticket
- */
-#define XLOG_TIC_INITED		0x1	/* has been initialized */
-#define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
-
-#define XLOG_TIC_FLAGS \
-	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
-	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
-
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
-/*
- * Below are states for covering allocation transactions.
- * By covering, we mean changing the h_tail_lsn in the last on-disk
- * log write such that no allocation transactions will be re-done during
- * recovery after a system crash. Recovery starts at the last on-disk
- * log write.
- *
- * These states are used to insert dummy log entries to cover
- * space allocation transactions which can undo non-transactional changes
- * after a crash. Writes to a file with space
- * already allocated do not result in any transactions. Allocations
- * might include space beyond the EOF. So if we just push the EOF a
- * little, the last transaction for the file could contain the wrong
- * size. If there is no file system activity, after an allocation
- * transaction, and the system crashes, the allocation transaction
- * will get replayed and the file will be truncated. This could
- * be hours/days/... after the allocation occurred.
- *
- * The fix for this is to do two dummy transactions when the
- * system is idle. We need two dummy transaction because the h_tail_lsn
- * in the log record header needs to point beyond the last possible
- * non-dummy transaction. The first dummy changes the h_tail_lsn to
- * the first transaction before the dummy. The second dummy causes
- * h_tail_lsn to point to the first dummy. Recovery starts at h_tail_lsn.
- *
- * These dummy transactions get committed when everything
- * is idle (after there has been some activity).
- *
- * There are 5 states used to control this.
- *
- *  IDLE -- no logging has been done on the file system or
- *		we are done covering previous transactions.
- *  NEED -- logging has occurred and we need a dummy transaction
- *		when the log becomes idle.
- *  DONE -- we were in the NEED state and have committed a dummy
- *		transaction.
- *  NEED2 -- we detected that a dummy transaction has gone to the
- *		on disk log with no other transactions.
- *  DONE2 -- we committed a dummy transaction when in the NEED2 state.
- *
- * There are two places where we switch states:
- *
- * 1.) In xfs_sync, when we detect an idle log and are in NEED or NEED2.
- *	We commit the dummy transaction and switch to DONE or DONE2,
- *	respectively. In all other states, we don't do anything.
- *
- * 2.) When we finish writing the on-disk log (xlog_state_clean_log).
- *
- *	No matter what state we are in, if this isn't the dummy
- *	transaction going out, the next state is NEED.
- *	So, if we aren't in the DONE or DONE2 states, the next state
- *	is NEED. We can't be finishing a write of the dummy record
- *	unless it was committed and the state switched to DONE or DONE2.
- *
- *	If we are in the DONE state and this was a write of the
- *		dummy transaction, we move to NEED2.
- *
- *	If we are in the DONE2 state and this was a write of the
- *		dummy transaction, we move to IDLE.
- *
- *
- * Writing only one dummy transaction can get appended to
- * one file space allocation. When this happens, the log recovery
- * code replays the space allocation and a file could be truncated.
- * This is why we have the NEED2 and DONE2 states before going idle.
- */
-
-#define XLOG_STATE_COVER_IDLE	0
-#define XLOG_STATE_COVER_NEED	1
-#define XLOG_STATE_COVER_DONE	2
-#define XLOG_STATE_COVER_NEED2	3
-#define XLOG_STATE_COVER_DONE2	4
-
-#define XLOG_COVER_OPS		5
-
-
-/* Ticket reservation region accounting */ 
-#define XLOG_TIC_LEN_MAX	15
-
-/*
- * Reservation region
- * As would be stored in xfs_log_iovec but without the i_addr which
- * we don't care about.
- */
-typedef struct xlog_res {
-	uint	r_len;	/* region length		:4 */
-	uint	r_type;	/* region's transaction type	:4 */
-} xlog_res_t;
-
-typedef struct xlog_ticket {
-	struct list_head   t_queue;	 /* reserve/write queue */
-	struct task_struct *t_task;	 /* task that owns this ticket */
-	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
-	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
-	int		   t_curr_res;	 /* current reservation in bytes : 4  */
-	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
-	char		   t_ocnt;	 /* original count		 : 1  */
-	char		   t_cnt;	 /* current count		 : 1  */
-	char		   t_clientid;	 /* who does this belong to;	 : 1  */
-	char		   t_flags;	 /* properties of reservation	 : 1  */
-	uint		   t_trans_type; /* transaction type             : 4  */
-
-        /* reservation array fields */
-	uint		   t_res_num;                    /* num in array : 4 */
-	uint		   t_res_num_ophdrs;		 /* num op hdrs  : 4 */
-	uint		   t_res_arr_sum;		 /* array sum    : 4 */
-	uint		   t_res_o_flow;		 /* sum overflow : 4 */
-	xlog_res_t	   t_res_arr[XLOG_TIC_LEN_MAX];  /* array of res : 8 * 15 */ 
-} xlog_ticket_t;
-
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
-/*
- * - A log record header is 512 bytes.  There is plenty of room to grow the
- *	xlog_rec_header_t into the reserved space.
- * - ic_data follows, so a write to disk can start at the beginning of
- *	the iclog.
- * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
- * - ic_next is the pointer to the next iclog in the ring.
- * - ic_bp is a pointer to the buffer used to write this incore log to disk.
- * - ic_log is a pointer back to the global log structure.
- * - ic_callback is a linked list of callback function/argument pairs to be
- *	called after an iclog finishes writing.
- * - ic_size is the full size of the header plus data.
- * - ic_offset is the current number of bytes written to in this iclog.
- * - ic_refcnt is bumped when someone is writing to the log.
- * - ic_state is the state of the iclog.
- *
- * Because of cacheline contention on large machines, we need to separate
- * various resources onto different cachelines. To start with, make the
- * structure cacheline aligned. The following fields can be contended on
- * by independent processes:
- *
- *	- ic_callback_*
- *	- ic_refcnt
- *	- fields protected by the global l_icloglock
- *
- * so we need to ensure that these fields are located in separate cachelines.
- * We'll put all the read-only and l_icloglock fields in the first cacheline,
- * and move everything else out to subsequent cachelines.
- */
-typedef struct xlog_in_core {
-	wait_queue_head_t	ic_force_wait;
-	wait_queue_head_t	ic_write_wait;
-	struct xlog_in_core	*ic_next;
-	struct xlog_in_core	*ic_prev;
-	struct xfs_buf		*ic_bp;
-	struct xlog		*ic_log;
-	int			ic_size;
-	int			ic_offset;
-	int			ic_bwritecnt;
-	unsigned short		ic_state;
-	char			*ic_datap;	/* pointer to iclog data */
-
-	/* Callback structures need their own cacheline */
-	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
-	xfs_log_callback_t	*ic_callback;
-	xfs_log_callback_t	**ic_callback_tail;
-
-	/* reference counts need their own cacheline */
-	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-	xlog_in_core_2_t	*ic_data;
-#define ic_header	ic_data->hic_header
-} xlog_in_core_t;
-
-/*
- * The CIL context is used to aggregate per-transaction details as well be
- * passed to the iclog for checkpoint post-commit processing.  After being
- * passed to the iclog, another context needs to be allocated for tracking the
- * next set of transactions to be aggregated into a checkpoint.
- */
-struct xfs_cil;
-
-struct xfs_cil_ctx {
-	struct xfs_cil		*cil;
-	xfs_lsn_t		sequence;	/* chkpt sequence # */
-	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
-	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
-	struct xlog_ticket	*ticket;	/* chkpt ticket */
-	int			nvecs;		/* number of regions */
-	int			space_used;	/* aggregate size of regions */
-	struct list_head	busy_extents;	/* busy extents in chkpt */
-	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
-	xfs_log_callback_t	log_cb;		/* completion callback hook. */
-	struct list_head	committing;	/* ctx committing list */
-};
-
-/*
- * Committed Item List structure
- *
- * This structure is used to track log items that have been committed but not
- * yet written into the log. It is used only when the delayed logging mount
- * option is enabled.
- *
- * This structure tracks the list of committing checkpoint contexts so
- * we can avoid the problem of having to hold out new transactions during a
- * flush until we have a the commit record LSN of the checkpoint. We can
- * traverse the list of committing contexts in xlog_cil_push_lsn() to find a
- * sequence match and extract the commit LSN directly from there. If the
- * checkpoint is still in the process of committing, we can block waiting for
- * the commit LSN to be determined as well. This should make synchronous
- * operations almost as efficient as the old logging methods.
- */
-struct xfs_cil {
-	struct xlog		*xc_log;
-	struct list_head	xc_cil;
-	spinlock_t		xc_cil_lock;
-	struct xfs_cil_ctx	*xc_ctx;
-	struct rw_semaphore	xc_ctx_lock;
-	struct list_head	xc_committing;
-	wait_queue_head_t	xc_commit_wait;
-	xfs_lsn_t		xc_current_sequence;
-	struct work_struct	xc_push_work;
-	xfs_lsn_t		xc_push_seq;
-};
-
-/*
- * The amount of log space we allow the CIL to aggregate is difficult to size.
- * Whatever we choose, we have to make sure we can get a reservation for the
- * log space effectively, that it is large enough to capture sufficient
- * relogging to reduce log buffer IO significantly, but it is not too large for
- * the log or induces too much latency when writing out through the iclogs. We
- * track both space consumed and the number of vectors in the checkpoint
- * context, so we need to decide which to use for limiting.
- *
- * Every log buffer we write out during a push needs a header reserved, which
- * is at least one sector and more for v2 logs. Hence we need a reservation of
- * at least 512 bytes per 32k of log space just for the LR headers. That means
- * 16KB of reservation per megabyte of delayed logging space we will consume,
- * plus various headers.  The number of headers will vary based on the num of
- * io vectors, so limiting on a specific number of vectors is going to result
- * in transactions of varying size. IOWs, it is more consistent to track and
- * limit space consumed in the log rather than by the number of objects being
- * logged in order to prevent checkpoint ticket overruns.
- *
- * Further, use of static reservations through the log grant mechanism is
- * problematic. It introduces a lot of complexity (e.g. reserve grant vs write
- * grant) and a significant deadlock potential because regranting write space
- * can block on log pushes. Hence if we have to regrant log space during a log
- * push, we can deadlock.
- *
- * However, we can avoid this by use of a dynamic "reservation stealing"
- * technique during transaction commit whereby unused reservation space in the
- * transaction ticket is transferred to the CIL ctx commit ticket to cover the
- * space needed by the checkpoint transaction. This means that we never need to
- * specifically reserve space for the CIL checkpoint transaction, nor do we
- * need to regrant space once the checkpoint completes. This also means the
- * checkpoint transaction ticket is specific to the checkpoint context, rather
- * than the CIL itself.
- *
- * With dynamic reservations, we can effectively make up arbitrary limits for
- * the checkpoint size so long as they don't violate any other size rules.
- * Recovery imposes a rule that no transaction exceed half the log, so we are
- * limited by that.  Furthermore, the log transaction reservation subsystem
- * tries to keep 25% of the log free, so we need to keep below that limit or we
- * risk running out of free log space to start any new transactions.
- *
- * In order to keep background CIL push efficient, we will set a lower
- * threshold at which background pushing is attempted without blocking current
- * transaction commits.  A separate, higher bound defines when CIL pushes are
- * enforced to ensure we stay within our maximum checkpoint size bounds.
- * threshold, yet give us plenty of space for aggregation on large logs.
- */
-#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
-#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))
-
-/*
- * ticket grant locks, queues and accounting have their own cachlines
- * as these are quite hot and can be operated on concurrently.
- */
-struct xlog_grant_head {
-	spinlock_t		lock ____cacheline_aligned_in_smp;
-	struct list_head	waiters;
-	atomic64_t		grant;
-};
-
-/*
- * The reservation head lsn is not made up of a cycle number and block number.
- * Instead, it uses a cycle number and byte number.  Logs don't expect to
- * overflow 31 bits worth of byte offset, so using a byte number will mean
- * that round off problems won't occur when releasing partial reservations.
- */
-struct xlog {
-	/* The following fields don't need locking */
-	struct xfs_mount	*l_mp;	        /* mount point */
-	struct xfs_ail		*l_ailp;	/* AIL log is working with */
-	struct xfs_cil		*l_cilp;	/* CIL log is working with */
-	struct xfs_buf		*l_xbuf;        /* extra buffer for log
-						 * wrapping */
-	struct xfs_buftarg	*l_targ;        /* buftarg of log */
-	struct delayed_work	l_work;		/* background flush work */
-	uint			l_flags;
-	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
-	struct list_head	*l_buf_cancel_table;
-	int			l_iclog_hsize;  /* size of iclog header */
-	int			l_iclog_heads;  /* # of iclog header sectors */
-	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
-	int			l_iclog_size;	/* size of log in bytes */
-	int			l_iclog_size_log; /* log power size of log */
-	int			l_iclog_bufs;	/* number of iclog buffers */
-	xfs_daddr_t		l_logBBstart;   /* start block of log */
-	int			l_logsize;      /* size of log in bytes */
-	int			l_logBBsize;    /* size of log in BB chunks */
-
-	/* The following block of fields are changed while holding icloglock */
-	wait_queue_head_t	l_flush_wait ____cacheline_aligned_in_smp;
-						/* waiting for iclog flush */
-	int			l_covered_state;/* state of "covering disk
-						 * log entries" */
-	xlog_in_core_t		*l_iclog;       /* head log queue	*/
-	spinlock_t		l_icloglock;    /* grab to change iclog state */
-	int			l_curr_cycle;   /* Cycle number of log writes */
-	int			l_prev_cycle;   /* Cycle number before last
-						 * block increment */
-	int			l_curr_block;   /* current logical log block */
-	int			l_prev_block;   /* previous logical log block */
-
-	/*
-	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
-	 * read without needing to hold specific locks. To avoid operations
-	 * contending with other hot objects, place each of them on a separate
-	 * cacheline.
-	 */
-	/* lsn of last LR on disk */
-	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
-	/* lsn of 1st LR with unflushed * buffers */
-	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
-
-	struct xlog_grant_head	l_reserve_head;
-	struct xlog_grant_head	l_write_head;
-
-	/* The following field are used for debugging; need to hold icloglock */
-#ifdef DEBUG
-	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
-#endif
-
-};
-
-#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
-	((log)->l_buf_cancel_table + ((__uint64_t)blkno % XLOG_BC_TABLE_SIZE))
-
-#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
-
-/* common routines */
-extern int
-xlog_recover(
-	struct xlog		*log);
-extern int
-xlog_recover_finish(
-	struct xlog		*log);
-
-extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
-			    char *dp, int size);
-
-extern kmem_zone_t *xfs_log_ticket_zone;
-struct xlog_ticket *
-xlog_ticket_alloc(
-	struct xlog	*log,
-	int		unit_bytes,
-	int		count,
-	char		client,
-	bool		permanent,
-	xfs_km_flags_t	alloc_flags);
-
-
-static inline void
-xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
-{
-	*ptr += bytes;
-	*len -= bytes;
-	*off += bytes;
-}
-
-void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
-int
-xlog_write(
-	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
-	struct xlog_ticket	*tic,
-	xfs_lsn_t		*start_lsn,
-	struct xlog_in_core	**commit_iclog,
-	uint			flags);
-
-/*
- * When we crack an atomic LSN, we sample it first so that the value will not
- * change while we are cracking it into the component values. This means we
- * will always get consistent component values to work from. This should always
- * be used to sample and crack LSNs that are stored and updated in atomic
- * variables.
- */
-static inline void
-xlog_crack_atomic_lsn(atomic64_t *lsn, uint *cycle, uint *block)
-{
-	xfs_lsn_t val = atomic64_read(lsn);
-
-	*cycle = CYCLE_LSN(val);
-	*block = BLOCK_LSN(val);
-}
-
-/*
- * Calculate and assign a value to an atomic LSN variable from component pieces.
- */
-static inline void
-xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
-{
-	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
-}
-
-/*
- * When we crack the grant head, we sample it first so that the value will not
- * change while we are cracking it into the component values. This means we
- * will always get consistent component values to work from.
- */
-static inline void
-xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
-{
-	*cycle = val >> 32;
-	*space = val & 0xffffffff;
-}
-
-static inline void
-xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
-{
-	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
-}
-
-static inline int64_t
-xlog_assign_grant_head_val(int cycle, int space)
-{
-	return ((int64_t)cycle << 32) | space;
-}
-
-static inline void
-xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
-{
-	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
-}
-
-/*
- * Committed Item List interfaces
- */
-int
-xlog_cil_init(struct xlog *log);
-void
-xlog_cil_init_post_recovery(struct xlog *log);
-void
-xlog_cil_destroy(struct xlog *log);
-
-/*
- * CIL force routines
- */
-xfs_lsn_t
-xlog_cil_force_lsn(
-	struct xlog *log,
-	xfs_lsn_t sequence);
-
-static inline void
-xlog_cil_force(struct xlog *log)
-{
-	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
-}
-
-/*
- * Unmount record type is used as a pseudo transaction type for the ticket.
- * It's value must be outside the range of XFS_TRANS_* values.
- */
-#define XLOG_UNMOUNT_REC_TYPE	(-1U)
-
-/*
- * Wrapper function for waiting on a wait queue serialised against wakeups
- * by a spinlock. This matches the semantics of all the wait queues used in the
- * log code.
- */
-static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
-{
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue_exclusive(wq, &wait);
-	__set_current_state(TASK_UNINTERRUPTIBLE);
-	spin_unlock(lock);
-	schedule();
-	remove_wait_queue(wq, &wait);
-}
-#endif	/* __KERNEL__ */
-
-#endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 93beb23..92a90f1 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -17,8 +17,6 @@
  */
 
 #include <xfs/libxfs.h>
-#include <xfs/xfs_log.h>
-#include <xfs/xfs_log_priv.h>
 #include "init.h"
 
 #define BDSTRAT_SIZE	(256 * 1024)
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 7f5a41c..13ca327 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -26,6 +26,7 @@
 	(0); \
 })
 
+#define BLK_AVG(blk1, blk2)    ((blk1+blk2) >> 1)
 
 /*
  * Verify the given count of basic blocks is valid number of blocks
@@ -1032,6 +1033,8 @@ xlog_recover_add_item(
 	list_add_tail(&item->ri_list, head);
 }
 
+#define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
+
 STATIC int
 xlog_recover_add_to_cont_trans(
 	struct xlog		*log,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
