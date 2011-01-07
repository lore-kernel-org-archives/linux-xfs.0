Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07CxtlZ052608 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 06:59:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8393D153A109
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 05:02:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xiHl5fekQMAYbZqG for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 05:02:05 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PbBxE-0003Ai-OO
	for xfs@oss.sgi.com; Fri, 07 Jan 2011 13:02:04 +0000
Date: Fri, 7 Jan 2011 08:02:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3] xfs: add FITRIM support
Message-ID: <20110107130204.GA12134@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Allow manual discards from userspace using the FITRIM ioctl.  This is not
intended to be run during normal workloads, as the freepsace btree walks
can cause large performance degradation.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-05 17:54:46.795005538 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-01-07 13:48:07.540253827 +0100
@@ -41,10 +41,6 @@
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-static int
-xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
-		    xfs_agblock_t bno, xfs_extlen_t len);
-
 /*
  * Prototypes for per-ag allocation routines
  */
@@ -94,7 +90,7 @@ xfs_alloc_lookup_ge(
  * Lookup the first record less than or equal to [bno, len]
  * in the btree given by cur.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_alloc_lookup_le(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
@@ -127,7 +123,7 @@ xfs_alloc_update(
 /*
  * Get the data from the pointed-to record.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_alloc_get_rec(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		*bno,	/* output: starting block of extent */
@@ -2615,7 +2611,7 @@ restart:
  * will require a synchronous transaction, but it can still be
  * used to distinguish between a partial or exact match.
  */
-static int
+int
 xfs_alloc_busy_search(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-01-05 17:54:46.796024256 +0100
+++ xfs/fs/xfs/xfs_alloc.h	2011-01-07 08:12:28.479274081 +0100
@@ -19,6 +19,7 @@
 #define	__XFS_ALLOC_H__
 
 struct xfs_buf;
+struct xfs_btree_cur;
 struct xfs_mount;
 struct xfs_perag;
 struct xfs_trans;
@@ -118,16 +119,16 @@ xfs_alloc_longest_free_extent(struct xfs
 		struct xfs_perag *pag);
 
 #ifdef __KERNEL__
-
 void
-xfs_alloc_busy_insert(xfs_trans_t *tp,
-		xfs_agnumber_t agno,
-		xfs_agblock_t bno,
-		xfs_extlen_t len);
+xfs_alloc_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
+	xfs_agblock_t bno, xfs_extlen_t len);
 
 void
 xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
 
+int
+xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_agblock_t bno, xfs_extlen_t len);
 #endif	/* __KERNEL__ */
 
 /*
@@ -205,4 +206,18 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len);	/* length of extent */
 
+int					/* error */
+xfs_alloc_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat);	/* success/failure */
+
+int					/* error */
+xfs_alloc_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		*bno,	/* output: starting block of extent */
+	xfs_extlen_t		*len,	/* output: length of extent */
+	int			*stat);	/* output: success/failure */
+
 #endif	/* __XFS_ALLOC_H__ */
Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2011-01-05 17:54:46.773007283 +0100
+++ xfs/fs/xfs/Makefile	2011-01-07 08:12:28.482026281 +0100
@@ -98,6 +98,7 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   kmem.o \
 				   xfs_aops.o \
 				   xfs_buf.o \
+				   xfs_discard.o \
 				   xfs_export.o \
 				   xfs_file.o \
 				   xfs_fs_subr.o \
Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-01-07 13:49:08.512253478 +0100
@@ -0,0 +1,191 @@
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
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
+#include "xfs.h"
+#include "xfs_sb.h"
+#include "xfs_inum.h"
+#include "xfs_log.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_quota.h"
+#include "xfs_trans.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_btree.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_discard.h"
+#include "xfs_trace.h"
+
+STATIC int
+xfs_trim_extents(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_fsblock_t		start,
+	xfs_fsblock_t		len,
+	xfs_fsblock_t		minlen,
+	__uint64_t		*blocks_trimmed)
+{
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
+	int			error;
+	int			i;
+
+	pag = xfs_perag_get(mp, agno);
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error || !agbp)
+		goto out_put_perag;
+
+	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
+
+	/*
+	 * Force out the log.  This means any transactions that might have freed
+	 * space before we took the AGF buffer lock are now on disk, and the
+	 * volatile disk cache is flushed.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/*
+	 * Look up the longest btree in the AGF and start with it.
+	 */
+	error = xfs_alloc_lookup_le(cur, 0,
+				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+	if (error)
+		goto out_del_cursor;
+
+	/*
+	 * Loop until we are done with all extents that are large
+	 * enough to be worth discarding.
+	 */
+	while (i) {
+		xfs_agblock_t fbno;
+		xfs_extlen_t flen;
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto out_del_cursor;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
+		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+
+		/*
+		 * Too small?  Give up.
+		 */
+		if (flen < minlen) {
+			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
+			goto out_del_cursor;
+		}
+
+		/*
+		 * If the extent is entirely outside of the range we are
+		 * supposed to discard skip it.  Do not bother to trim
+		 * down partially overlapping ranges for now.
+		 */
+		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
+		    XFS_AGB_TO_FSB(mp, agno, fbno) >= start + len) {
+			trace_xfs_discard_exclude(mp, agno, fbno, flen);
+			goto next_extent;
+		}
+
+		/*
+		 * If any blocks in the range are still busy, skip the
+		 * discard and try again the next time.
+		 */
+		if (xfs_alloc_busy_search(mp, agno, fbno, flen)) {
+			trace_xfs_discard_busy(mp, agno, fbno, flen);
+			goto next_extent;
+		}
+
+		trace_xfs_discard_extent(mp, agno, fbno, flen);
+		error = -blkdev_issue_discard(bdev,
+				XFS_AGB_TO_DADDR(mp, agno, fbno),
+				XFS_FSB_TO_BB(mp, flen),
+				GFP_NOFS, 0);
+		if (error)
+			goto out_del_cursor;
+		*blocks_trimmed += flen;
+
+next_extent:
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto out_del_cursor;
+	}
+
+out_del_cursor:
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+out_put_perag:
+	xfs_perag_put(pag);
+	return error;
+}
+
+int
+xfs_ioc_trim(
+	struct xfs_mount		*mp,
+	struct fstrim_range __user	*urange)
+{
+	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
+	unsigned int		granularity = q->limits.discard_granularity;
+	struct fstrim_range	range;
+	xfs_fsblock_t		start, len, minlen;
+	xfs_agnumber_t		start_agno, end_agno, agno;
+	__uint64_t		blocks_trimmed = 0;
+	int			error, last_error = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&range, urange, sizeof(range)))
+		return -XFS_ERROR(EFAULT);
+
+	/*
+	 * Truncating down the len isn't actually quite correct, but using
+	 * XFS_B_TO_FSB would mean we trivially get overflows for values
+	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
+	 * used by the fstrim application.  In the end it really doesn't
+	 * matter as trimming blocks is an advisory interface.
+	 */
+	start = XFS_B_TO_FSBT(mp, range.start);
+	len = XFS_B_TO_FSBT(mp, range.len);
+	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
+
+	start_agno = XFS_FSB_TO_AGNO(mp, start);
+	if (start_agno >= mp->m_sb.sb_agcount)
+		return -XFS_ERROR(EINVAL);
+
+	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
+	if (end_agno >= mp->m_sb.sb_agcount)
+		end_agno = mp->m_sb.sb_agcount - 1;
+
+	for (agno = start_agno; agno <= end_agno; agno++) {
+		error = -xfs_trim_extents(mp, agno, start, len, minlen,
+					  &blocks_trimmed);
+		if (error)
+			last_error = error;
+	}
+
+	if (last_error)
+		return last_error;
+
+	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
+	if (copy_to_user(urange, &range, sizeof(range)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
Index: xfs/fs/xfs/linux-2.6/xfs_discard.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs/fs/xfs/linux-2.6/xfs_discard.h	2011-01-07 08:12:28.486026770 +0100
@@ -0,0 +1,8 @@
+#ifndef XFS_DISCARD_H
+#define XFS_DISCARD_H 1
+
+struct fstrim_range;
+
+extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
+
+#endif /* XFS_DISCARD_H */
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-01-05 18:18:20.035254106 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-01-07 13:48:07.424253827 +0100
@@ -1759,6 +1759,39 @@ DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_reco
 DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
 DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
 
+DECLARE_EVENT_CLASS(xfs_discard_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+)
+
+#define DEFINE_DISCARD_EVENT(name) \
+DEFINE_EVENT(xfs_discard_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(mp, agno, agbno, len))
+DEFINE_DISCARD_EVENT(xfs_discard_extent);
+DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
+DEFINE_DISCARD_EVENT(xfs_discard_exclude);
+DEFINE_DISCARD_EVENT(xfs_discard_busy);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2011-01-05 17:54:46.784005119 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2011-01-07 08:12:28.491010357 +0100
@@ -39,6 +39,7 @@
 #include "xfs_dfrag.h"
 #include "xfs_fsops.h"
 #include "xfs_vnodeops.h"
+#include "xfs_discard.h"
 #include "xfs_quota.h"
 #include "xfs_inode_item.h"
 #include "xfs_export.h"
@@ -1294,6 +1295,8 @@ xfs_file_ioctl(
 	trace_xfs_file_ioctl(ip);
 
 	switch (cmd) {
+	case FITRIM:
+		return xfs_ioc_trim(mp, arg);
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_RESVSP:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
