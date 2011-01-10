Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A8h311226388 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 02:43:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 806C0FCA0CE
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 00:45:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	z5ohsNAd3LsLWLsD for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 00:45:05 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52483388-1927428
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 19:14:59 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcDN4-0004x8-1M
	for xfs@oss.sgi.com; Mon, 10 Jan 2011 19:44:58 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PcDN1-00075o-9z
	for xfs@oss.sgi.com; Mon, 10 Jan 2011 19:44:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] libxlog: sync up with 2.6.38 kernel code
Date: Mon, 10 Jan 2011 19:44:50 +1100
Message-Id: <1294649091-27174-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1294649091-27174-1-git-send-email-david@fromorbit.com>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Update libxlog with the current 2.6.38 kernel code and well as
updating the necessary parts of libxfs and variaous header files to
ensure that it compiles correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile           |    5 +-
 include/atomic.h           |   31 ++
 include/hlist.h            |   76 +++++
 include/libxfs.h           |   17 +-
 include/libxlog.h          |   16 +-
 include/list.h             |   11 +
 include/xfs_buf_item.h     |   50 ++---
 include/xfs_extfree_item.h |   17 +-
 include/xfs_inode_item.h   |    2 -
 include/xfs_log.h          |   70 +++--
 include/xfs_log_priv.h     |  331 +++++++++++++++++------
 include/xfs_log_recover.h  |   25 +-
 include/xfs_trace.h        |    9 +
 include/xfs_trans.h        |  648 ++++++--------------------------------------
 include/xfs_types.h        |    2 +
 libxfs/logitem.c           |  365 +------------------------
 libxfs/trans.c             |  209 +++++----------
 libxfs/xfs.h               |   12 +-
 libxfs/xfs_mount.c         |    1 -
 libxfs/xfs_trans.c         |  492 ++++++++++++++++++++++++++++++---
 libxlog/xfs_log_recover.c  |  606 ++++++++++++++++++++++-------------------
 logprint/log_print_all.c   |   13 +-
 logprint/log_print_trans.c |    4 +-
 23 files changed, 1431 insertions(+), 1581 deletions(-)
 create mode 100644 include/atomic.h
 create mode 100644 include/hlist.h
 create mode 100644 include/xfs_trace.h

diff --git a/include/Makefile b/include/Makefile
index 63709e6..a84963c 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -19,7 +19,8 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 QAHFILES = libxfs.h libxlog.h \
-	bitops.h cache.h kmem.h list.h parent.h radix-tree.h swab.h \
+	atomic.h bitops.h cache.h kmem.h list.h hlist.h parent.h radix-tree.h \
+	swab.h \
 	xfs_ag.h xfs_alloc.h xfs_alloc_btree.h xfs_arch.h xfs_attr_leaf.h \
 	xfs_attr_sf.h xfs_bit.h xfs_bmap.h xfs_bmap_btree.h xfs_btree.h \
 	xfs_btree_trace.h xfs_buf_item.h xfs_da_btree.h xfs_dinode.h \
@@ -28,7 +29,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
 	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
-	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h \
+	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_trace.h \
 	xfs_trans.h xfs_trans_space.h xfs_types.h xfs_dfrag.h
 
 HFILES = handle.h jdm.h xqm.h xfs.h xfs_fs.h
diff --git a/include/atomic.h b/include/atomic.h
new file mode 100644
index 0000000..bdf1083
--- /dev/null
+++ b/include/atomic.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2011 RedHat, Inc.
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
+#ifndef __ATOMIC_H__
+#define __ATOMIC_H__
+
+typedef	int32_t	atomic_t;
+typedef	int64_t	atomic64_t;
+
+#define atomic_inc_return(x)	(++(*(x)))
+#define atomic_dec_return(x)	(--(*(x)))
+
+#define atomic64_read(x)	*(x)
+#define atomic64_set(x, v)	(*(x) = v)
+
+#endif /* __ATOMIC_H__ */
+
diff --git a/include/hlist.h b/include/hlist.h
new file mode 100644
index 0000000..6d814ab
--- /dev/null
+++ b/include/hlist.h
@@ -0,0 +1,76 @@
+/*
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
+#ifndef __HLIST_H__
+#define __HLIST_H__
+
+/*
+ * double-linked hash list with single head implementation taken from linux
+ * kernel headers.
+ */
+
+struct hlist_node {
+	struct hlist_node *next;
+	struct hlist_node **pprev;
+};
+struct hlist_head {
+	struct hlist_node *first;
+};
+
+#define HLIST_HEAD_INIT { .first = NULL }
+static inline void INIT_HLIST_NODE(struct hlist_node *h)
+{
+	h->next = NULL;
+	h->pprev = NULL;
+}
+
+static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
+{
+        struct hlist_node *first = h->first;
+	n->next = first;
+	if (first)
+		first->pprev = &n->next;
+	h->first = n;
+	n->pprev = &h->first;
+}
+
+static inline void __hlist_del(struct hlist_node *n)
+{
+	struct hlist_node *next = n->next;
+	struct hlist_node **pprev = n->pprev;
+	*pprev = next;
+	if (next)
+		next->pprev = pprev;
+}
+
+static inline void hlist_del(struct hlist_node *n)
+{
+	__hlist_del(n);
+}
+
+#define hlist_entry(ptr, type, member)  ({ \
+		const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
+		(type *)( (char *)__mptr - offsetof(type,member) );})
+
+
+#define hlist_for_each(pos, head) \
+	for (pos = (head)->first; pos; pos = pos->next)
+
+#define hlist_for_each_entry(tpos, pos, head, member)                    \
+        for (pos = (head)->first;                                        \
+	     pos && ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next)
+
+
+#endif	/* __LIST_H__ */
diff --git a/include/libxfs.h b/include/libxfs.h
index 13fbf79..69b24ac 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -25,11 +25,13 @@
 #include <xfs/platform_defs.h>
 
 #include <xfs/list.h>
+#include <xfs/hlist.h>
 #include <xfs/cache.h>
 #include <xfs/bitops.h>
 #include <xfs/kmem.h>
 #include <xfs/radix-tree.h>
 #include <xfs/swab.h>
+#include <xfs/atomic.h>
 
 #include <xfs/xfs_fs.h>
 #include <xfs/xfs_types.h>
@@ -55,6 +57,7 @@
 #include <xfs/xfs_btree.h>
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
+#include <xfs/xfs_trace.h>
 
 
 #ifndef XFS_SUPER_MAGIC
@@ -63,6 +66,10 @@
 
 #define xfs_isset(a,i)	((a)[(i)/(sizeof((a))*NBBY)] & (1<<((i)%(sizeof((a))*NBBY))))
 
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
 /*
  * Argument structure for libxfs_init().
  */
@@ -241,8 +248,11 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
 #define XFS_BUF_COUNT(bp)		((bp)->b_bcount)
 #define XFS_BUF_TARGET(bp)		((bp)->b_dev)
-#define XFS_BUF_SET_PTR(bp,p,cnt)	((bp)->b_addr = (char *)(p)); \
-						XFS_BUF_SET_COUNT(bp,cnt)
+#define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
+	(bp)->b_addr = (char *)(p);		\
+	XFS_BUF_SET_COUNT(bp,cnt);		\
+})
+
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_blkno = (blk))
 #define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
 
@@ -330,6 +340,7 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_flags;		/* misc flags */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	xfs_inode_log_format_t	ili_format;		/* logged structure */
+	int			ili_lock_flags;
 } xfs_inode_log_item_t;
 
 typedef struct xfs_buf_log_item {
@@ -353,7 +364,7 @@ typedef struct xfs_trans {
 	long		t_fdblocks_delta;	/* superblock fdblocks chg */
 	long		t_frextents_delta;	/* superblock freextents chg */
 	unsigned int	t_items_free;		/* log item descs free */
-	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
+	struct list_head	t_items;	/* first log item desc chunk */
 } xfs_trans_t;
 
 extern xfs_trans_t	*libxfs_trans_alloc (xfs_mount_t *, int);
diff --git a/include/libxlog.h b/include/libxlog.h
index 2a8a251..d1142ab 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -39,13 +39,12 @@ typedef struct log {
 	int		l_iclog_size;	 /* size of log in bytes */
 	int		l_iclog_size_log;/* log power size of log */
 	int		l_iclog_bufs;	 /* number of iclog buffers */
-	int		l_grant_reserve_cycle;	/* */
-	int		l_grant_reserve_bytes;	/* */
-	int		l_grant_write_cycle;	/* */
-	int		l_grant_write_bytes;	/* */
+	atomic64_t	l_grant_reserve_head;
+	atomic64_t	l_grant_write_head;
 	uint		l_sectbb_log;   /* log2 of sector size in bbs */
 	uint		l_sectbb_mask;  /* sector size (in BBs)
 					 * alignment mask */
+	int		l_sectBBsize;   /* size of log sector in 512 byte chunks */
 } xlog_t;
 
 #include <xfs/xfs_log_recover.h>
@@ -91,7 +90,10 @@ extern libxfs_init_t	x;
 
 extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
 extern void	xlog_put_bp(struct xfs_buf *);
-extern int	xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
+extern int	xlog_bread(xlog_t *log, xfs_daddr_t blk_no, int nbblks,
+				xfs_buf_t *bp, xfs_caddr_t *offset);
+extern int	xlog_bread_noalign(xlog_t *log, xfs_daddr_t blk_no, int nbblks,
+				xfs_buf_t *bp);
 
 extern int	xlog_find_zeroed(xlog_t *log, xfs_daddr_t *blk_no);
 extern int	xlog_find_cycle_start(xlog_t *log, xfs_buf_t *bp,
@@ -110,7 +112,7 @@ extern int	xlog_print_find_oldest(xlog_t *log, xfs_daddr_t *last_blk);
 /* for transactional view */
 extern void	xlog_recover_print_trans_head(xlog_recover_t *tr);
 extern void	xlog_recover_print_trans(xlog_recover_t *trans,
-				xlog_recover_item_t *itemq, int print);
+				struct list_head *itemq, int print);
 extern int	xlog_do_recovery_pass(xlog_t *log, xfs_daddr_t head_blk,
 				xfs_daddr_t tail_blk, int pass);
 extern int	xlog_recover_do_trans(xlog_t *log, xlog_recover_t *trans,
@@ -120,4 +122,6 @@ extern int	xlog_header_check_recover(xfs_mount_t *mp,
 extern int	xlog_header_check_mount(xfs_mount_t *mp,
 				xlog_rec_header_t *head);
 
+#define xlog_assign_atomic_lsn(l,a,b) ((void) 0)
+#define xlog_assign_grant_head(l,a,b) ((void) 0)
 #endif	/* LIBXLOG_H */
diff --git a/include/list.h b/include/list.h
index 2389a6c..3f087a4 100644
--- a/include/list.h
+++ b/include/list.h
@@ -27,6 +27,12 @@ struct list_head {
 	struct list_head *prev;
 };
 
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+		struct list_head name = LIST_HEAD_INIT(name)
+
+#define INIT_LIST_HEAD(list) list_head_init(list)
 static inline void list_head_init(struct list_head *list)
 {
 	list->next = list->prev = list;
@@ -68,6 +74,11 @@ static inline void list_del_init(struct list_head *entry)
 	list_head_init(entry);
 }
 
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
 static inline void list_move(struct list_head *list, struct list_head *head)
 {
 	__list_del(list->prev, list->next);
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index 5a41c34..a5efba9 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -26,7 +26,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
  * have been logged.
  * For 6.2 and beyond, this is XFS_LI_BUF.  We use this to log everything.
  */
-typedef struct xfs_buf_log_format_t {
+typedef struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
 	ushort		blf_flags;	/* misc state */
@@ -41,22 +41,22 @@ typedef struct xfs_buf_log_format_t {
  * This flag indicates that the buffer contains on disk inodes
  * and requires special recovery handling.
  */
-#define	XFS_BLI_INODE_BUF	0x1
+#define	XFS_BLF_INODE_BUF	0x1
 /*
  * This flag indicates that the buffer should not be replayed
  * during recovery because its blocks are being freed.
  */
-#define	XFS_BLI_CANCEL		0x2
+#define	XFS_BLF_CANCEL		0x2
 /*
  * This flag indicates that the buffer contains on disk
  * user or group dquots and may require special recovery handling.
  */
-#define	XFS_BLI_UDQUOT_BUF	0x4
-#define XFS_BLI_PDQUOT_BUF	0x8
-#define	XFS_BLI_GDQUOT_BUF	0x10
+#define	XFS_BLF_UDQUOT_BUF	0x4
+#define XFS_BLF_PDQUOT_BUF	0x8
+#define	XFS_BLF_GDQUOT_BUF	0x10
 
-#define	XFS_BLI_CHUNK		128
-#define	XFS_BLI_SHIFT		7
+#define	XFS_BLF_CHUNK		128
+#define	XFS_BLF_SHIFT		7
 #define	BIT_TO_WORD_SHIFT	5
 #define	NBWORD			(NBBY * sizeof(unsigned int))
 
@@ -69,23 +69,23 @@ typedef struct xfs_buf_log_format_t {
 #define	XFS_BLI_LOGGED		0x08
 #define	XFS_BLI_INODE_ALLOC_BUF	0x10
 #define XFS_BLI_STALE_INODE	0x20
+#define XFS_BLI_INODE_BUF	0x40
 
+#define XFS_BLI_FLAGS \
+	{ XFS_BLI_HOLD,		"HOLD" }, \
+	{ XFS_BLI_DIRTY,	"DIRTY" }, \
+	{ XFS_BLI_STALE,	"STALE" }, \
+	{ XFS_BLI_LOGGED,	"LOGGED" }, \
+	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
+	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
+	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }
 
 #ifdef __KERNEL__
 
 struct xfs_buf;
-struct ktrace;
 struct xfs_mount;
 struct xfs_buf_log_item;
 
-#if defined(XFS_BLI_TRACE)
-#define	XFS_BLI_TRACE_SIZE	32
-
-void	xfs_buf_item_trace(char *, struct xfs_buf_log_item *);
-#else
-#define	xfs_buf_item_trace(id, bip)
-#endif
-
 /*
  * This is the in core log item structure used to track information
  * needed to log buffers.  It tracks how many times the lock has been
@@ -97,9 +97,6 @@ typedef struct xfs_buf_log_item {
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* lock recursion count */
 	atomic_t		bli_refcount;	/* cnt of tp refs */
-#ifdef XFS_BLI_TRACE
-	struct ktrace		*bli_trace;	/* event trace buf */
-#endif
 #ifdef XFS_TRANS_DEBUG
 	char			*bli_orig;	/* original buffer copy */
 	char			*bli_logged;	/* bytes logged (bitmap) */
@@ -107,17 +104,6 @@ typedef struct xfs_buf_log_item {
 	xfs_buf_log_format_t	bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
-/*
- * This structure is used during recovery to record the buf log
- * items which have been canceled and should not be replayed.
- */
-typedef struct xfs_buf_cancel {
-	xfs_daddr_t		bc_blkno;
-	uint			bc_len;
-	int			bc_refcount;
-	struct xfs_buf_cancel	*bc_next;
-} xfs_buf_cancel_t;
-
 void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
@@ -126,7 +112,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, xfs_log_item_t *),
 			      xfs_log_item_t *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
-void	xfs_buf_iodone(struct xfs_buf *, xfs_buf_log_item_t *);
+void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 
 #ifdef XFS_TRANS_DEBUG
 void
diff --git a/include/xfs_extfree_item.h b/include/xfs_extfree_item.h
index 2f049f6..375f68e 100644
--- a/include/xfs_extfree_item.h
+++ b/include/xfs_extfree_item.h
@@ -33,12 +33,10 @@ typedef struct xfs_extent {
  * conversion routine.
  */
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_extent_32 {
 	__uint64_t	ext_start;
 	__uint32_t	ext_len;
 } __attribute__((packed)) xfs_extent_32_t;
-#endif
 
 typedef struct xfs_extent_64 {
 	__uint64_t	ext_start;
@@ -59,7 +57,6 @@ typedef struct xfs_efi_log_format {
 	xfs_extent_t		efi_extents[1];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_efi_log_format_32 {
 	__uint16_t		efi_type;	/* efi log item type */
 	__uint16_t		efi_size;	/* size of this item */
@@ -67,7 +64,6 @@ typedef struct xfs_efi_log_format_32 {
 	__uint64_t		efi_id;		/* efi identifier */
 	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
-#endif
 
 typedef struct xfs_efi_log_format_64 {
 	__uint16_t		efi_type;	/* efi log item type */
@@ -90,7 +86,6 @@ typedef struct xfs_efd_log_format {
 	xfs_extent_t		efd_extents[1];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_efd_log_format_32 {
 	__uint16_t		efd_type;	/* efd log item type */
 	__uint16_t		efd_size;	/* size of this item */
@@ -98,7 +93,6 @@ typedef struct xfs_efd_log_format_32 {
 	__uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
-#endif
 
 typedef struct xfs_efd_log_format_64 {
 	__uint16_t		efd_type;	/* efd log item type */
@@ -117,11 +111,10 @@ typedef struct xfs_efd_log_format_64 {
 #define	XFS_EFI_MAX_FAST_EXTENTS	16
 
 /*
- * Define EFI flags.
+ * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
  */
-#define	XFS_EFI_RECOVERED	0x1
-#define	XFS_EFI_COMMITTED	0x2
-#define	XFS_EFI_CANCELED	0x4
+#define	XFS_EFI_RECOVERED	1
+#define	XFS_EFI_COMMITTED	2
 
 /*
  * This is the "extent free intention" log item.  It is used
@@ -131,8 +124,8 @@ typedef struct xfs_efd_log_format_64 {
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
-	uint			efi_flags;	/* misc flags */
-	uint			efi_next_extent;
+	atomic_t		efi_next_extent;
+	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
 } xfs_efi_log_item_t;
 
diff --git a/include/xfs_inode_item.h b/include/xfs_inode_item.h
index 1ff04cc..81dcf94 100644
--- a/include/xfs_inode_item.h
+++ b/include/xfs_inode_item.h
@@ -40,7 +40,6 @@ typedef struct xfs_inode_log_format {
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_t;
 
-#ifndef HAVE_FORMAT32
 typedef struct xfs_inode_log_format_32 {
 	__uint16_t		ilf_type;	/* inode log item type */
 	__uint16_t		ilf_size;	/* size of this item */
@@ -56,7 +55,6 @@ typedef struct xfs_inode_log_format_32 {
 	__int32_t		ilf_len;	/* len of inode buffer */
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } __attribute__((packed)) xfs_inode_log_format_32_t;
-#endif
 
 typedef struct xfs_inode_log_format_64 {
 	__uint16_t		ilf_type;	/* inode log item type */
diff --git a/include/xfs_log.h b/include/xfs_log.h
index d47b91f..916eb7d 100644
--- a/include/xfs_log.h
+++ b/include/xfs_log.h
@@ -19,7 +19,6 @@
 #define __XFS_LOG_H__
 
 /* get lsn fields */
-
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
@@ -56,28 +55,18 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 /*
  * Flags to xfs_log_reserve()
  *
- *	XFS_LOG_SLEEP:	 If space is not available, sleep (default)
- *	XFS_LOG_NOSLEEP: If space is not available, return error
  *	XFS_LOG_PERM_RESERV: Permanent reservation.  When writes are
  *		performed against this type of reservation, the reservation
  *		is not decreased.  Long running transactions should use this.
  */
-#define XFS_LOG_SLEEP		0x0
-#define XFS_LOG_NOSLEEP		0x1
 #define XFS_LOG_PERM_RESERV	0x2
 
 /*
  * Flags to xfs_log_force()
  *
  *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
- *	XFS_LOG_FORCE:	Start in-core log write now.
- *	XFS_LOG_URGE:	Start write within some window of time.
- *
- * Note: Either XFS_LOG_FORCE or XFS_LOG_URGE must be set.
  */
 #define XFS_LOG_SYNC		0x1
-#define XFS_LOG_FORCE		0x2
-#define XFS_LOG_URGE		0x4
 
 #endif	/* __KERNEL__ */
 
@@ -110,15 +99,20 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 #define XLOG_REG_TYPE_TRANSHDR		19
 #define XLOG_REG_TYPE_MAX		19
 
-#define XLOG_VEC_SET_TYPE(vecp, t) ((vecp)->i_type = (t))
-
 typedef struct xfs_log_iovec {
-	xfs_caddr_t		i_addr;		/* beginning address of region */
+	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
 
-typedef void* xfs_log_ticket_t;
+struct xfs_log_vec {
+	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_buf_len;	/* size of formatted buffer */
+};
 
 /*
  * Structure used to pass callback function and the function's argument
@@ -134,17 +128,33 @@ typedef struct xfs_log_callback {
 #ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
+struct xlog_in_core;
+struct xlog_ticket;
+struct xfs_log_item;
+struct xfs_item_ops;
+struct xfs_trans;
+
+void	xfs_log_item_init(struct xfs_mount	*mp,
+			struct xfs_log_item	*item,
+			int			type,
+			struct xfs_item_ops	*ops);
+
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
-		       xfs_log_ticket_t ticket,
-		       void		**iclog,
+		       struct xlog_ticket *ticket,
+		       struct xlog_in_core **iclog,
 		       uint		flags);
 int	  _xfs_log_force(struct xfs_mount *mp,
-			 xfs_lsn_t	lsn,
 			 uint		flags,
 			 int		*log_forced);
 void	  xfs_log_force(struct xfs_mount	*mp,
-			xfs_lsn_t		lsn,
 			uint			flags);
+int	  _xfs_log_force_lsn(struct xfs_mount *mp,
+			     xfs_lsn_t		lsn,
+			     uint		flags,
+			     int		*log_forced);
+void	  xfs_log_force_lsn(struct xfs_mount	*mp,
+			    xfs_lsn_t		lsn,
+			    uint		flags);
 int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
 			xfs_daddr_t		start_block,
@@ -153,34 +163,38 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
 void	  xfs_log_move_tail(struct xfs_mount	*mp,
 			    xfs_lsn_t		tail_lsn);
 int	  xfs_log_notify(struct xfs_mount	*mp,
-			 void			*iclog,
+			 struct xlog_in_core	*iclog,
 			 xfs_log_callback_t	*callback_entry);
 int	  xfs_log_release_iclog(struct xfs_mount *mp,
-			 void			 *iclog_hndl);
+			 struct xlog_in_core	 *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   length,
 			  int		   count,
-			  xfs_log_ticket_t *ticket,
+			  struct xlog_ticket **ticket,
 			  __uint8_t	   clientid,
 			  uint		   flags,
 			  uint		   t_type);
 int	  xfs_log_write(struct xfs_mount *mp,
 			xfs_log_iovec_t  region[],
 			int		 nentries,
-			xfs_log_ticket_t ticket,
+			struct xlog_ticket *ticket,
 			xfs_lsn_t	 *start_lsn);
-int	  xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
-void      xfs_log_unmount_dealloc(struct xfs_mount *mp);
+void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
 int	  xfs_log_need_covered(struct xfs_mount *mp);
 
 void	  xlog_iodone(struct xfs_buf *);
 
-#endif
-
+struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
+void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-extern int xlog_debug;		/* set to 1 to enable real log */
+xlog_tid_t xfs_log_get_trans_ident(struct xfs_trans *tp);
 
+int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
+				struct xfs_log_vec *log_vector,
+				xfs_lsn_t *commit_lsn, int flags);
+bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
+#endif
 #endif	/* __XFS_LOG_H__ */
diff --git a/include/xfs_log_priv.h b/include/xfs_log_priv.h
index e7d8f84..d5f8be8 100644
--- a/include/xfs_log_priv.h
+++ b/include/xfs_log_priv.h
@@ -19,10 +19,8 @@
 #define __XFS_LOG_PRIV_H__
 
 struct xfs_buf;
-struct ktrace;
 struct log;
 struct xlog_ticket;
-struct xfs_buf_cancel;
 struct xfs_mount;
 
 /*
@@ -55,7 +53,6 @@ struct xfs_mount;
 	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 
-
 static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
 {
 	return ((xfs_lsn_t)cycle << 32) | block;
@@ -134,7 +131,11 @@ static inline uint xlog_get_client_id(__be32 i)
  */
 #define XLOG_TIC_INITED		0x1	/* has been initialized */
 #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
-#define XLOG_TIC_IN_Q		0x4
+
+#define XLOG_TIC_FLAGS \
+	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
+	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
+
 #endif	/* __KERNEL__ */
 
 #define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
@@ -147,8 +148,6 @@ static inline uint xlog_get_client_id(__be32 i)
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
 					   shutdown */
-typedef __uint32_t xlog_tid_t;
-
 
 #ifdef __KERNEL__
 /*
@@ -241,10 +240,10 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
-	struct xlog_ticket *t_next;	 /*			         :4|8 */
-	struct xlog_ticket *t_prev;	 /*				 :4|8 */
+	wait_queue_head_t  t_wait;	 /* ticket wait queue */
+	struct list_head   t_queue;	 /* reserve/write queue */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
+	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
 	char		   t_ocnt;	 /* original count		 : 1  */
@@ -309,6 +308,16 @@ typedef struct xlog_rec_ext_header {
 } xlog_rec_ext_header_t;
 
 #ifdef __KERNEL__
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
 /*
  * - A log record header is 512 bytes.  There is plenty of room to grow the
  *	xlog_rec_header_t into the reserved space.
@@ -338,9 +347,9 @@ typedef struct xlog_rec_ext_header {
  * We'll put all the read-only and l_icloglock fields in the first cacheline,
  * and move everything else out to subsequent cachelines.
  */
-typedef struct xlog_iclog_fields {
-	sv_t			ic_force_wait;
-	sv_t			ic_write_wait;
+typedef struct xlog_in_core {
+	wait_queue_head_t	ic_force_wait;
+	wait_queue_head_t	ic_write_wait;
 	struct xlog_in_core	*ic_next;
 	struct xlog_in_core	*ic_prev;
 	struct xfs_buf		*ic_bp;
@@ -348,11 +357,8 @@ typedef struct xlog_iclog_fields {
 	int			ic_size;
 	int			ic_offset;
 	int			ic_bwritecnt;
-	ushort_t		ic_state;
+	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*ic_trace;
-#endif
 
 	/* Callback structures need their own cacheline */
 	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
@@ -361,39 +367,108 @@ typedef struct xlog_iclog_fields {
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-} xlog_iclog_fields_t;
+	xlog_in_core_2_t	*ic_data;
+#define ic_header	ic_data->hic_header
+} xlog_in_core_t;
 
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
+/*
+ * The CIL context is used to aggregate per-transaction details as well be
+ * passed to the iclog for checkpoint post-commit processing.  After being
+ * passed to the iclog, another context needs to be allocated for tracking the
+ * next set of transactions to be aggregated into a checkpoint.
+ */
+struct xfs_cil;
+
+struct xfs_cil_ctx {
+	struct xfs_cil		*cil;
+	xfs_lsn_t		sequence;	/* chkpt sequence # */
+	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
+	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
+	struct xlog_ticket	*ticket;	/* chkpt ticket */
+	int			nvecs;		/* number of regions */
+	int			space_used;	/* aggregate size of regions */
+	struct list_head	busy_extents;	/* busy extents in chkpt */
+	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
+	xfs_log_callback_t	log_cb;		/* completion callback hook. */
+	struct list_head	committing;	/* ctx committing list */
+};
 
-typedef struct xlog_in_core {
-	xlog_iclog_fields_t	hic_fields;
-	xlog_in_core_2_t	*hic_data;
-} xlog_in_core_t;
+/*
+ * Committed Item List structure
+ *
+ * This structure is used to track log items that have been committed but not
+ * yet written into the log. It is used only when the delayed logging mount
+ * option is enabled.
+ *
+ * This structure tracks the list of committing checkpoint contexts so
+ * we can avoid the problem of having to hold out new transactions during a
+ * flush until we have a the commit record LSN of the checkpoint. We can
+ * traverse the list of committing contexts in xlog_cil_push_lsn() to find a
+ * sequence match and extract the commit LSN directly from there. If the
+ * checkpoint is still in the process of committing, we can block waiting for
+ * the commit LSN to be determined as well. This should make synchronous
+ * operations almost as efficient as the old logging methods.
+ */
+struct xfs_cil {
+	struct log		*xc_log;
+	struct list_head	xc_cil;
+	spinlock_t		xc_cil_lock;
+	struct xfs_cil_ctx	*xc_ctx;
+	struct rw_semaphore	xc_ctx_lock;
+	struct list_head	xc_committing;
+	wait_queue_head_t	xc_commit_wait;
+	xfs_lsn_t		xc_current_sequence;
+};
 
 /*
- * Defines to save our code from this glop.
+ * The amount of log space we allow the CIL to aggregate is difficult to size.
+ * Whatever we choose, we have to make sure we can get a reservation for the
+ * log space effectively, that it is large enough to capture sufficient
+ * relogging to reduce log buffer IO significantly, but it is not too large for
+ * the log or induces too much latency when writing out through the iclogs. We
+ * track both space consumed and the number of vectors in the checkpoint
+ * context, so we need to decide which to use for limiting.
+ *
+ * Every log buffer we write out during a push needs a header reserved, which
+ * is at least one sector and more for v2 logs. Hence we need a reservation of
+ * at least 512 bytes per 32k of log space just for the LR headers. That means
+ * 16KB of reservation per megabyte of delayed logging space we will consume,
+ * plus various headers.  The number of headers will vary based on the num of
+ * io vectors, so limiting on a specific number of vectors is going to result
+ * in transactions of varying size. IOWs, it is more consistent to track and
+ * limit space consumed in the log rather than by the number of objects being
+ * logged in order to prevent checkpoint ticket overruns.
+ *
+ * Further, use of static reservations through the log grant mechanism is
+ * problematic. It introduces a lot of complexity (e.g. reserve grant vs write
+ * grant) and a significant deadlock potential because regranting write space
+ * can block on log pushes. Hence if we have to regrant log space during a log
+ * push, we can deadlock.
+ *
+ * However, we can avoid this by use of a dynamic "reservation stealing"
+ * technique during transaction commit whereby unused reservation space in the
+ * transaction ticket is transferred to the CIL ctx commit ticket to cover the
+ * space needed by the checkpoint transaction. This means that we never need to
+ * specifically reserve space for the CIL checkpoint transaction, nor do we
+ * need to regrant space once the checkpoint completes. This also means the
+ * checkpoint transaction ticket is specific to the checkpoint context, rather
+ * than the CIL itself.
+ *
+ * With dynamic reservations, we can effectively make up arbitrary limits for
+ * the checkpoint size so long as they don't violate any other size rules.
+ * Recovery imposes a rule that no transaction exceed half the log, so we are
+ * limited by that.  Furthermore, the log transaction reservation subsystem
+ * tries to keep 25% of the log free, so we need to keep below that limit or we
+ * risk running out of free log space to start any new transactions.
+ *
+ * In order to keep background CIL push efficient, we will set a lower
+ * threshold at which background pushing is attempted without blocking current
+ * transaction commits.  A separate, higher bound defines when CIL pushes are
+ * enforced to ensure we stay within our maximum checkpoint size bounds.
+ * threshold, yet give us plenty of space for aggregation on large logs.
  */
-#define	ic_force_wait	hic_fields.ic_force_wait
-#define ic_write_wait	hic_fields.ic_write_wait
-#define	ic_next		hic_fields.ic_next
-#define	ic_prev		hic_fields.ic_prev
-#define	ic_bp		hic_fields.ic_bp
-#define	ic_log		hic_fields.ic_log
-#define	ic_callback	hic_fields.ic_callback
-#define	ic_callback_lock hic_fields.ic_callback_lock
-#define	ic_callback_tail hic_fields.ic_callback_tail
-#define	ic_trace	hic_fields.ic_trace
-#define	ic_size		hic_fields.ic_size
-#define	ic_offset	hic_fields.ic_offset
-#define	ic_refcnt	hic_fields.ic_refcnt
-#define	ic_bwritecnt	hic_fields.ic_bwritecnt
-#define	ic_state	hic_fields.ic_state
-#define ic_datap	hic_fields.ic_datap
-#define ic_header	hic_data->hic_header
+#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
+#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))
 
 /*
  * The reservation head lsn is not made up of a cycle number and block number.
@@ -404,17 +479,17 @@ typedef struct xlog_in_core {
 typedef struct log {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
+	struct xfs_ail		*l_ailp;	/* AIL log is working with */
+	struct xfs_cil		*l_cilp;	/* CIL log is working with */
 	struct xfs_buf		*l_xbuf;        /* extra buffer for log
 						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
 	uint			l_flags;
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
-	struct xfs_buf_cancel	**l_buf_cancel_table;
+	struct list_head	*l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
-	uint			l_sectbb_log;   /* log2 of sector size in BBs */
-	uint			l_sectbb_mask;  /* sector size (in BBs)
-						 * alignment mask */
+	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
 	int			l_iclog_size_log; /* log power size of log */
 	int			l_iclog_bufs;	/* number of iclog buffers */
@@ -423,33 +498,40 @@ typedef struct log {
 	int			l_logBBsize;    /* size of log in BB chunks */
 
 	/* The following block of fields are changed while holding icloglock */
-	sv_t			l_flush_wait ____cacheline_aligned_in_smp;
+	wait_queue_head_t	l_flush_wait ____cacheline_aligned_in_smp;
 						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
-	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
-						 * buffers */
-	xfs_lsn_t		l_last_sync_lsn;/* lsn of last LR on disk */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
 	int			l_curr_block;   /* current logical log block */
 	int			l_prev_block;   /* previous logical log block */
 
-	/* The following block of fields are changed while holding grant_lock */
-	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-	xlog_ticket_t		*l_reserve_headq;
-	xlog_ticket_t		*l_write_headq;
-	int			l_grant_reserve_cycle;
-	int			l_grant_reserve_bytes;
-	int			l_grant_write_cycle;
-	int			l_grant_write_bytes;
-
-#ifdef XFS_LOG_TRACE
-	struct ktrace		*l_grant_trace;
-#endif
+	/*
+	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
+	 * read without needing to hold specific locks. To avoid operations
+	 * contending with other hot objects, place each of them on a separate
+	 * cacheline.
+	 */
+	/* lsn of last LR on disk */
+	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
+	/* lsn of 1st LR with unflushed * buffers */
+	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
+
+	/*
+	 * ticket grant locks, queues and accounting have their own cachlines
+	 * as these are quite hot and can be operated on concurrently.
+	 */
+	spinlock_t		l_grant_reserve_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_reserveq;
+	atomic64_t		l_grant_reserve_head;
+
+	spinlock_t		l_grant_write_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_writeq;
+	atomic64_t		l_grant_write_head;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
@@ -458,30 +540,108 @@ typedef struct log {
 
 } xlog_t;
 
-#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
+#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
+	((log)->l_buf_cancel_table + ((__uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
+#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
 /* common routines */
 extern xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-extern int	 xlog_find_tail(xlog_t	*log,
-				xfs_daddr_t *head_blk,
-				xfs_daddr_t *tail_blk);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
-extern void	 xlog_recover_process_iunlinks(xlog_t *log);
 
-extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
-extern void	 xlog_put_bp(struct xfs_buf *);
-extern int	 xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
+extern kmem_zone_t *xfs_log_ticket_zone;
+struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
+				int count, char client, uint xflags,
+				int alloc_flags);
+
 
-extern kmem_zone_t	*xfs_log_ticket_zone;
+static inline void
+xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
+{
+	*ptr += bytes;
+	*len -= bytes;
+	*off += bytes;
+}
 
-/* iclog tracing */
-#define XLOG_TRACE_GRAB_FLUSH  1
-#define XLOG_TRACE_REL_FLUSH   2
-#define XLOG_TRACE_SLEEP_FLUSH 3
-#define XLOG_TRACE_WAKE_FLUSH  4
+void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
+int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
+				struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+				xlog_in_core_t **commit_iclog, uint flags);
+
+/*
+ * When we crack an atomic LSN, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from. This should always
+ * be used to smaple and crack LSNs taht are stored and updated in atomic
+ * variables.
+ */
+static inline void
+xlog_crack_atomic_lsn(atomic64_t *lsn, uint *cycle, uint *block)
+{
+	xfs_lsn_t val = atomic64_read(lsn);
+
+	*cycle = CYCLE_LSN(val);
+	*block = BLOCK_LSN(val);
+}
+
+/*
+ * Calculate and assign a value to an atomic LSN variable from component pieces.
+ */
+static inline void
+xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
+{
+	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
+}
+
+/*
+ * When we crack the grant head, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from.
+ */
+static inline void
+xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
+{
+	*cycle = val >> 32;
+	*space = val & 0xffffffff;
+}
+
+static inline void
+xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
+{
+	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
+}
+
+static inline int64_t
+xlog_assign_grant_head_val(int cycle, int space)
+{
+	return ((int64_t)cycle << 32) | space;
+}
+
+static inline void
+xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
+{
+	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
+}
+
+/*
+ * Committed Item List interfaces
+ */
+int	xlog_cil_init(struct log *log);
+void	xlog_cil_init_post_recovery(struct log *log);
+void	xlog_cil_destroy(struct log *log);
+
+/*
+ * CIL force routines
+ */
+xfs_lsn_t xlog_cil_force_lsn(struct log *log, xfs_lsn_t sequence);
+
+static inline void
+xlog_cil_force(struct log *log)
+{
+	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
+}
 
 /*
  * Unmount record type is used as a pseudo transaction type for the ticket.
@@ -489,6 +649,21 @@ extern kmem_zone_t	*xfs_log_ticket_zone;
  */
 #define XLOG_UNMOUNT_REC_TYPE	(-1U)
 
+/*
+ * Wrapper function for waiting on a wait queue serialised against wakeups
+ * by a spinlock. This matches the semantics of all the wait queues used in the
+ * log code.
+ */
+static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	add_wait_queue_exclusive(wq, &wait);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	spin_unlock(lock);
+	schedule();
+	remove_wait_queue(wq, &wait);
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/include/xfs_log_recover.h b/include/xfs_log_recover.h
index b225455..1c55ccb 100644
--- a/include/xfs_log_recover.h
+++ b/include/xfs_log_recover.h
@@ -28,29 +28,28 @@
 #define XLOG_RHASH(tid)	\
 	((((__uint32_t)tid)>>XLOG_RHASH_SHIFT) & (XLOG_RHASH_SIZE-1))
 
-#define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLI_CHUNK / 2 + 1)
+#define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK / 2 + 1)
 
 
 /*
  * item headers are in ri_buf[0].  Additional buffers follow.
  */
 typedef struct xlog_recover_item {
-	struct xlog_recover_item *ri_next;
-	struct xlog_recover_item *ri_prev;
-	int			 ri_type;
-	int			 ri_cnt;	/* count of regions found */
-	int			 ri_total;	/* total regions */
-	xfs_log_iovec_t		 *ri_buf;	/* ptr to regions buffer */
+	struct list_head	ri_list;
+	int			ri_type;
+	int			ri_cnt;	/* count of regions found */
+	int			ri_total;	/* total regions */
+	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
 } xlog_recover_item_t;
 
 struct xlog_tid;
 typedef struct xlog_recover {
-	struct xlog_recover *r_next;
-	xlog_tid_t	    r_log_tid;		/* log's transaction id */
-	xfs_trans_header_t  r_theader;		/* trans header for partial */
-	int		    r_state;		/* not needed */
-	xfs_lsn_t	    r_lsn;		/* xact lsn */
-	xlog_recover_item_t *r_itemq;		/* q for items */
+	struct hlist_node	r_list;
+	xlog_tid_t		r_log_tid;	/* log's transaction id */
+	xfs_trans_header_t	r_theader;	/* trans header for partial */
+	int			r_state;	/* not needed */
+	xfs_lsn_t		r_lsn;		/* xact lsn */
+	struct list_head	r_itemq;	/* q for items */
 } xlog_recover_t;
 
 #define ITEM_TYPE(i)	(*(ushort *)(i)->ri_buf[0].i_addr)
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
new file mode 100644
index 0000000..fef82d0
--- /dev/null
+++ b/include/xfs_trace.h
@@ -0,0 +1,9 @@
+#ifndef __TRACE_H__
+#define __TRACE_H__
+
+#define trace_xfs_log_recover_item_reorder_head(a,b,c,d)	((void) 0)
+#define trace_xfs_log_recover_item_reorder_tail(a,b,c,d)	((void) 0)
+#define trace_xfs_log_recover_item_add_cont(a,b,c,d)	((void) 0)
+#define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
+
+#endif /* __TRACE_H__ */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 1d89d50..c2042b7 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -49,6 +49,15 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_DQUOT		0x123d
 #define	XFS_LI_QUOTAOFF		0x123e
 
+#define XFS_LI_TYPE_DESC \
+	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
+	{ XFS_LI_EFD,		"XFS_LI_EFD" }, \
+	{ XFS_LI_IUNLINK,	"XFS_LI_IUNLINK" }, \
+	{ XFS_LI_INODE,		"XFS_LI_INODE" }, \
+	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
+	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
+	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }
+
 /*
  * Transaction types.  Used to distinguish types of buffers.
  */
@@ -68,7 +77,7 @@ typedef struct xfs_trans_header {
 #define XFS_TRANS_GROWFS		14
 #define XFS_TRANS_STRAT_WRITE		15
 #define XFS_TRANS_DIOSTRAT		16
-#define	XFS_TRANS_WRITE_SYNC		17
+/* 17 was XFS_TRANS_WRITE_SYNC */
 #define	XFS_TRANS_WRITEID		18
 #define	XFS_TRANS_ADDAFORK		19
 #define	XFS_TRANS_ATTRINVAL		20
@@ -97,9 +106,54 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_TYPE_MAX		41
+#define	XFS_TRANS_CHECKPOINT		42
+#define	XFS_TRANS_TYPE_MAX		42
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
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
 /*
  * This structure is used to track log items associated with
  * a transaction.  It points to the log item and keeps some
@@ -107,106 +161,14 @@ typedef struct xfs_trans_header {
  * the amount of space needed to log the item it describes
  * once we get to commit processing (see xfs_trans_commit()).
  */
-typedef struct xfs_log_item_desc {
+struct xfs_log_item_desc {
 	struct xfs_log_item	*lid_item;
-	ushort		lid_size;
-	unsigned char	lid_flags;
-	unsigned char	lid_index;
-} xfs_log_item_desc_t;
+	ushort			lid_size;
+	unsigned char		lid_flags;
+	struct list_head	lid_trans;
+};
 
 #define XFS_LID_DIRTY		0x1
-#define XFS_LID_PINNED		0x2
-#define XFS_LID_BUF_STALE	0x8
-
-/*
- * This structure is used to maintain a chunk list of log_item_desc
- * structures. The free field is a bitmask indicating which descriptors
- * in this chunk's array are free.  The unused field is the first value
- * not used since this chunk was allocated.
- */
-#define	XFS_LIC_NUM_SLOTS	15
-typedef struct xfs_log_item_chunk {
-	struct xfs_log_item_chunk	*lic_next;
-	ushort				lic_free;
-	ushort				lic_unused;
-	xfs_log_item_desc_t		lic_descs[XFS_LIC_NUM_SLOTS];
-} xfs_log_item_chunk_t;
-
-#define	XFS_LIC_MAX_SLOT	(XFS_LIC_NUM_SLOTS - 1)
-#define	XFS_LIC_FREEMASK	((1 << XFS_LIC_NUM_SLOTS) - 1)
-
-
-/*
- * Initialize the given chunk.  Set the chunk's free descriptor mask
- * to indicate that all descriptors are free.  The caller gets to set
- * lic_unused to the right value (0 matches all free).  The
- * lic_descs.lid_index values are set up as each desc is allocated.
- */
-static inline void xfs_lic_init(xfs_log_item_chunk_t *cp)
-{
-	cp->lic_free = XFS_LIC_FREEMASK;
-}
-
-static inline void xfs_lic_init_slot(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_descs[slot].lid_index = (unsigned char)(slot);
-}
-
-static inline int xfs_lic_vacancy(xfs_log_item_chunk_t *cp)
-{
-	return cp->lic_free & XFS_LIC_FREEMASK;
-}
-
-static inline void xfs_lic_all_free(xfs_log_item_chunk_t *cp)
-{
-	cp->lic_free = XFS_LIC_FREEMASK;
-}
-
-static inline int xfs_lic_are_all_free(xfs_log_item_chunk_t *cp)
-{
-	return ((cp->lic_free & XFS_LIC_FREEMASK) == XFS_LIC_FREEMASK);
-}
-
-static inline int xfs_lic_isfree(xfs_log_item_chunk_t *cp, int slot)
-{
-	return (cp->lic_free & (1 << slot));
-}
-
-static inline void xfs_lic_claim(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_free &= ~(1 << slot);
-}
-
-static inline void xfs_lic_relse(xfs_log_item_chunk_t *cp, int slot)
-{
-	cp->lic_free |= 1 << slot;
-}
-
-static inline xfs_log_item_desc_t *
-xfs_lic_slot(xfs_log_item_chunk_t *cp, int slot)
-{
-	return &(cp->lic_descs[slot]);
-}
-
-static inline int xfs_lic_desc_to_slot(xfs_log_item_desc_t *dp)
-{
-	return (uint)dp->lid_index;
-}
-
-/*
- * Calculate the address of a chunk given a descriptor pointer:
- * dp - dp->lid_index give the address of the start of the lic_descs array.
- * From this we subtract the offset of the lic_descs field in a chunk.
- * All of this yields the address of the chunk, which is
- * cast to a chunk pointer.
- */
-static inline xfs_log_item_chunk_t *
-xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
-{
-	return (xfs_log_item_chunk_t*) \
-		(((xfs_caddr_t)((dp) - (dp)->lid_index)) - \
-		(xfs_caddr_t)(((xfs_log_item_chunk_t*)0)->lic_descs));
-}
 
 #define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
 /*
@@ -222,8 +184,6 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 /*
  * Values for call flags parameter.
  */
-#define	XFS_TRANS_NOSLEEP		0x1
-#define	XFS_TRANS_WAIT			0x2
 #define	XFS_TRANS_RELEASE_LOG_RES	0x4
 #define	XFS_TRANS_ABORT			0x8
 
@@ -247,24 +207,6 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 
 
 /*
- * Various log reservation values.
- * These are based on the size of the file system block
- * because that is what most transactions manipulate.
- * Each adds in an additional 128 bytes per item logged to
- * try to account for the overhead of the transaction mechanism.
- *
- * Note:
- * Most of the reservations underestimate the number of allocation
- * groups into which they could free extents in the xfs_bmap_finish()
- * call.  This is because the number in the worst case is quite high
- * and quite unusual.  In order to fix this we need to change
- * xfs_bmap_finish() to free extents in only a single AG at a time.
- * This will require changes to the EFI code as well, however, so that
- * the EFI for the extents not freed is logged again in each transaction.
- * See bug 261917.
- */
-
-/*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
  * 2 trees * (2 blocks/level * max depth - 1) * block size
@@ -288,429 +230,36 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
 
-/*
- * In a write transaction we can allocate a maximum of 2
- * extents.  This gives:
- *    the inode getting the new extents: inode size
- *    the inode\'s bmap btree: max depth * block size
- *    the agfs of the ags from which the extents are allocated: 2 * sector
- *    the superblock free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- * And the bmap_finish transaction can free bmap blocks in a join:
- *    the agfs of the ags containing the blocks: 2 * sector size
- *    the agfls of the ags containing the blocks: 2 * sector size
- *    the super block free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define XFS_CALC_WRITE_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + XFS_ALLOCFREE_LOG_COUNT(mp, 2)))),\
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
 
 #define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
-
-/*
- * In truncating a file we free up to two extents at once.  We can modify:
- *    the inode being truncated: inode size
- *    the inode\'s bmap btree: (max depth + 1) * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_ITRUNCATE_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) + \
-	  (128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)))), \
-	 ((4 * (mp)->m_sb.sb_sectsize) + \
-	  (4 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 4) + \
-	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))) + \
-	  (128 * 5) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	   (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	    XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
-
-/*
- * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
- *    the two directory btrees: 2 * (max depth + v2) * dir block size
- *    the two directory bmap btrees: 2 * max depth * block size
- * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
- *    the agf for the ags in which the blocks live: 3 * sector size
- *    the agfl for the ags in which the blocks live: 3 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_RENAME_LOG_RES(mp) \
-	(MAX( \
-	 ((4 * (mp)->m_sb.sb_inodesize) + \
-	  (2 * XFS_DIROP_LOG_RES(mp)) + \
-	  (128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((3 * (mp)->m_sb.sb_sectsize) + \
-	  (3 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 3) + \
-	  (128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))))))
-
 #define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
-
-/*
- * For creating a link to an inode:
- *    the parent directory inode: inode size
- *    the linked inode: inode size
- *    the directory btree could split: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free some bmap blocks giving:
- *    the agf for the ag in which the blocks live: sector size
- *    the agfl for the ag in which the blocks live: sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_LINK_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (2 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((mp)->m_sb.sb_sectsize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
-
-/*
- * For removing a directory entry we can modify:
- *    the parent directory inode: inode size
- *    the removed inode: inode size
- *    the directory btree could join: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free the dir and bmap blocks giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_REMOVE_LOG_RES(mp)	\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (2 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
-
 #define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
-
-/*
- * For symlink we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: 1 block
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode\'s bmap btree: (max depth + v2) * block size
- *    the blocks for the symlink: 1 KB
- * Or in the first xact we allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_SYMLINK_LOG_RES(mp)		\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B(mp, 1) + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  1024 + \
-	  (128 * (4 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 (2 * (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), XFS_IN_MAXLEVELS(mp)) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
-
-/*
- * For create we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: block size
- *    the superblock for the nlink flag: sector size
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode\'s bmap btree: (max depth + v2) * block size
- * Or in the first xact we allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_CREATE_LOG_RES(mp)		\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B(mp, 1) + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (3 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 (3 * (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), XFS_IN_MAXLEVELS(mp)) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
-
-/*
- * Making a new directory is the same as creating a new file.
- */
-#define	XFS_CALC_MKDIR_LOG_RES(mp)	XFS_CALC_CREATE_LOG_RES(mp)
-
 #define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
-
-/*
- * In freeing an inode we can modify:
- *    the inode being freed: inode size
- *    the super block free inode counter: sector size
- *    the agi hash list and counters: sector size
- *    the inode btree entry: block size
- *    the on disk inode before ours in the agi hash list: inode cluster size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_IFREE_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize + \
-	 (mp)->m_sb.sb_sectsize + \
-	 XFS_FSB_TO_B((mp), 1) + \
-	 MAX((__uint16_t)XFS_FSB_TO_B((mp), 1), XFS_INODE_CLUSTER_SIZE(mp)) + \
-	 (128 * 5) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
-
 #define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
-
-/*
- * When only changing the inode we log the inode and possibly the superblock
- * We also add a bit of slop for the transaction stuff.
- */
-#define	XFS_CALC_ICHANGE_LOG_RES(mp)	((mp)->m_sb.sb_inodesize + \
-					 (mp)->m_sb.sb_sectsize + 512)
-
 #define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
-
-/*
- * Growing the data section of the filesystem.
- *	superblock
- *	agi and agf
- *	allocation btrees
- */
-#define	XFS_CALC_GROWDATA_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize * 3 + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
-
-/*
- * Growing the rt section of the filesystem.
- * In the first set of transactions (ALLOC) we allocate space to the
- * bitmap or summary files.
- *	superblock: sector size
- *	agf of the ag from which the extent is allocated: sector size
- *	bmap btree for bitmap/summary inode: max depth * blocksize
- *	bitmap/summary inode: inode size
- *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
- */
-#define	XFS_CALC_GROWRTALLOC_LOG_RES(mp) \
-	(2 * (mp)->m_sb.sb_sectsize + \
-	 XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) + \
-	 (mp)->m_sb.sb_inodesize + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * \
-	  (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
-
-/*
- * Growing the rt section of the filesystem.
- * In the second set of transactions (ZERO) we zero the new metadata blocks.
- *	one bitmap/summary block: blocksize
- */
-#define	XFS_CALC_GROWRTZERO_LOG_RES(mp) \
-	((mp)->m_sb.sb_blocksize + 128)
-
 #define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
-
-/*
- * Growing the rt section of the filesystem.
- * In the third set of transactions (FREE) we update metadata without
- * allocating any new blocks.
- *	superblock: sector size
- *	bitmap inode: inode size
- *	summary inode: inode size
- *	one bitmap block: blocksize
- *	summary blocks: new summary size
- */
-#define	XFS_CALC_GROWRTFREE_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize + \
-	 2 * (mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_blocksize + \
-	 (mp)->m_rsumsize + \
-	 (128 * 5))
-
 #define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
-
-/*
- * Logging the inode modification timestamp on a synchronous write.
- *	inode
- */
-#define	XFS_CALC_SWRITE_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + 128)
-
 #define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-
 /*
  * Logging the inode timestamps on an fsync -- same as SWRITE
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-
-/*
- * Logging the inode mode bits when writing a setuid/setgid file
- *	inode
- */
-#define	XFS_CALC_WRITEID_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + 128)
-
 #define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-
-/*
- * Converting the inode from non-attributed to attributed.
- *	the inode being converted: inode size
- *	agf block and superblock (for block allocation)
- *	the new block (directory sized)
- *	bmap blocks for the new directory block
- *	allocation btrees
- */
-#define	XFS_CALC_ADDAFORK_LOG_RES(mp)	\
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize * 2 + \
-	 (mp)->m_dirblksize + \
-	 XFS_FSB_TO_B(mp, (XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1)) + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * (4 + (XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) + \
-		 XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
-
-/*
- * Removing the attribute fork of a file
- *    the inode being truncated: inode size
- *    the inode\'s bmap btree: max depth * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_ATTRINVAL_LOG_RES(mp)	\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) + \
-	  (128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))), \
-	 ((4 * (mp)->m_sb.sb_sectsize) + \
-	  (4 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 4) + \
-	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))))))
-
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-
-/*
- * Setting an attribute.
- *	the inode getting the attribute
- *	the superblock for allocations
- *	the agfs extents are allocated from
- *	the attribute btree * max depth
- *	the inode allocation btree
- * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime.
- */
-#define	XFS_CALC_ATTRSET_LOG_RES(mp)	\
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_DA_NODE_MAXDEPTH) + \
-	  (128 * (2 + XFS_DA_NODE_MAXDEPTH)))
-
 #define	XFS_ATTRSET_LOG_RES(mp, ext)	\
 	((mp)->m_reservations.tr_attrset + \
 	 (ext * (mp)->m_sb.sb_sectsize) + \
 	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
 	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
-
-/*
- * Removing an attribute.
- *    the inode: inode size
- *    the attribute btree could join: max depth * block size
- *    the inode bmap btree could join or split: max depth * block size
- * And the bmap_finish transaction can free the attr blocks freed giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_ATTRRM_LOG_RES(mp)	\
-	(MAX( \
-	  ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_DA_NODE_MAXDEPTH) + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) + \
-	  (128 * (1 + XFS_DA_NODE_MAXDEPTH + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)))), \
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
-
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
-
-/*
- * Clearing a bad agino number in an agi hash bucket.
- */
-#define	XFS_CALC_CLEAR_AGI_BUCKET_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize + 128)
-
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 
 
@@ -745,8 +294,8 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 #define	XFS_ALLOC_BTREE_REF	2
 #define	XFS_BMAP_BTREE_REF	2
 #define	XFS_DIR_BTREE_REF	2
+#define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
-#define	XFS_INO_REF		1
 #define	XFS_DQUOT_REF		1
 
 #ifdef __KERNEL__
@@ -762,12 +311,14 @@ struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot_acct;
+struct xfs_busy_extent;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
 	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
 	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	uint				li_flags;	/* misc flags */
 	struct xfs_log_item		*li_bio_list;	/* buffer item list */
@@ -776,17 +327,25 @@ typedef struct xfs_log_item {
 							/* buffer item iodone */
 							/* callback func */
 	struct xfs_item_ops		*li_ops;	/* function list */
+
+	/* delayed logging */
+	struct list_head		li_cil;		/* CIL pointers */
+	struct xfs_log_vec		*li_lv;		/* active log vector */
+	xfs_lsn_t			li_seq;		/* CIL commit seq */
 } xfs_log_item_t;
 
 #define	XFS_LI_IN_AIL	0x1
 #define XFS_LI_ABORTED	0x2
 
+#define XFS_LI_FLAGS \
+	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
+	{ XFS_LI_ABORTED,	"ABORTED" }
+
 typedef struct xfs_item_ops {
 	uint (*iop_size)(xfs_log_item_t *);
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
-	void (*iop_unpin)(xfs_log_item_t *, int);
-	void (*iop_unpin_remove)(xfs_log_item_t *, struct xfs_trans *);
+	void (*iop_unpin)(xfs_log_item_t *, int remove);
 	uint (*iop_trylock)(xfs_log_item_t *);
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
@@ -798,8 +357,7 @@ typedef struct xfs_item_ops {
 #define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
-#define IOP_UNPIN(ip, flags)	(*(ip)->li_ops->iop_unpin)(ip, flags)
-#define IOP_UNPIN_REMOVE(ip,tp) (*(ip)->li_ops->iop_unpin_remove)(ip, tp)
+#define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
 #define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
 #define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
@@ -813,36 +371,7 @@ typedef struct xfs_item_ops {
 #define	XFS_ITEM_SUCCESS	0
 #define	XFS_ITEM_PINNED		1
 #define	XFS_ITEM_LOCKED		2
-#define	XFS_ITEM_FLUSHING	3
-#define XFS_ITEM_PUSHBUF	4
-
-/*
- * This structure is used to maintain a list of block ranges that have been
- * freed in the transaction.  The ranges are listed in the perag[] busy list
- * between when they're freed and the transaction is committed to disk.
- */
-
-typedef struct xfs_log_busy_slot {
-	xfs_agnumber_t		lbc_ag;
-	ushort			lbc_idx;	/* index in perag.busy[] */
-} xfs_log_busy_slot_t;
-
-#define XFS_LBC_NUM_SLOTS	31
-typedef struct xfs_log_busy_chunk {
-	struct xfs_log_busy_chunk	*lbc_next;
-	uint				lbc_free;	/* free slots bitmask */
-	ushort				lbc_unused;	/* first unused */
-	xfs_log_busy_slot_t		lbc_busy[XFS_LBC_NUM_SLOTS];
-} xfs_log_busy_chunk_t;
-
-#define	XFS_LBC_MAX_SLOT	(XFS_LBC_NUM_SLOTS - 1)
-#define	XFS_LBC_FREEMASK	((1U << XFS_LBC_NUM_SLOTS) - 1)
-
-#define	XFS_LBC_INIT(cp)	((cp)->lbc_free = XFS_LBC_FREEMASK)
-#define	XFS_LBC_CLAIM(cp, slot)	((cp)->lbc_free &= ~(1 << (slot)))
-#define	XFS_LBC_SLOT(cp, slot)	(&((cp)->lbc_busy[(slot)]))
-#define	XFS_LBC_VACANCY(cp)	(((cp)->lbc_free) & XFS_LBC_FREEMASK)
-#define	XFS_LBC_ISFREE(cp, slot) ((cp)->lbc_free & (1 << (slot)))
+#define XFS_ITEM_PUSHBUF	3
 
 /*
  * This is the type of function which can be given to xfs_trans_callback()
@@ -863,15 +392,13 @@ typedef struct xfs_trans {
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
-	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
+	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	xfs_lsn_t		t_lsn;		/* log seq num of start of
 						 * transaction. */
 	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
 						 * transaction. */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-	xfs_trans_callback_t	t_callback;	/* transaction callback */
-	void			*t_callarg;	/* callback arg */
 	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */
@@ -892,11 +419,9 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
-	unsigned int		t_items_free;	/* log item descs free */
-	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
+	struct list_head	t_items;	/* log item descriptors */
 	xfs_trans_header_t	t_header;	/* header for in-log trans */
-	unsigned int		t_busy_free;	/* busy descs free */
-	xfs_log_busy_chunk_t	t_busy;		/* busy/async free blocks */
+	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
 
@@ -923,7 +448,7 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces.
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
@@ -946,8 +471,9 @@ void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 int		xfs_trans_iget(struct xfs_mount *, xfs_trans_t *,
 			       xfs_ino_t , uint, uint, struct xfs_inode **);
-void		xfs_trans_ijoin(xfs_trans_t *, struct xfs_inode *, uint);
-void		xfs_trans_ihold(xfs_trans_t *, struct xfs_inode *);
+void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
+void		xfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, uint);
+void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
@@ -970,15 +496,9 @@ int		_xfs_trans_commit(xfs_trans_t *,
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
-void		xfs_trans_unlocked_item(struct xfs_mount *,
-					xfs_log_item_t *);
-xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
-					xfs_agnumber_t ag,
-					xfs_extlen_t idx);
 
 extern kmem_zone_t	*xfs_trans_zone;
+extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 #endif	/* __KERNEL__ */
 
diff --git a/include/xfs_types.h b/include/xfs_types.h
index 228b948..901d4ac 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -81,6 +81,8 @@ typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
 typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
+typedef __uint32_t	xlog_tid_t;	/* transaction ID type */
+
 /*
  * These types are 64 bits on disk but are either 32 or 64 bits in memory.
  * Disk based types:
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index d6ef10b..0856ca6 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -26,215 +26,6 @@ kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
  */
 
 /*
- * This is called to add the given log item to the transaction's
- * list of log items.  It must find a free log item descriptor
- * or allocate a new one and add the item to that descriptor.
- * The function returns a pointer to item descriptor used to point
- * to the new item.  The log item will now point to its new descriptor
- * with its li_desc field.
- */
-xfs_log_item_desc_t *
-xfs_trans_add_item(
-	xfs_trans_t		*tp,
-	xfs_log_item_t		*lip)
-{
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_chunk_t	*licp;
-	int			i = 0;
-
-	/*
-	 * If there are no free descriptors, allocate a new chunk
-	 * of them and put it at the front of the chunk list.
-	 */
-	if (tp->t_items_free == 0) {
-		licp = (xfs_log_item_chunk_t*)
-		       kmem_alloc(sizeof(xfs_log_item_chunk_t), KM_SLEEP);
-		ASSERT(licp != NULL);
-		/*
-		 * Initialize the chunk, and then
-		 * claim the first slot in the newly allocated chunk.
-		 */
-		xfs_lic_init(licp);
-		xfs_lic_claim(licp, 0);
-		licp->lic_unused = 1;
-		xfs_lic_init_slot(licp, 0);
-		lidp = xfs_lic_slot(licp, 0);
-
-		/*
-		 * Link in the new chunk and update the free count.
-		 */
-		licp->lic_next = tp->t_items.lic_next;
-		tp->t_items.lic_next = licp;
-		tp->t_items_free = XFS_LIC_NUM_SLOTS - 1;
-
-		/*
-		 * Initialize the descriptor and the generic portion
-		 * of the log item.
-		 *
-		 * Point the new slot at this item and return it.
-		 * Also point the log item at its currently active
-		 * descriptor and set the item's mount pointer.
-		 */
-		lidp->lid_item = lip;
-		lidp->lid_flags = 0;
-		lidp->lid_size = 0;
-		lip->li_desc = lidp;
-		lip->li_mountp = tp->t_mountp;
-		return lidp;
-	}
-
-	/*
-	 * Find the free descriptor. It is somewhere in the chunklist
-	 * of descriptors.
-	 */
-	licp = &tp->t_items;
-	while (licp != NULL) {
-		if (xfs_lic_vacancy(licp)) {
-			if (licp->lic_unused <= XFS_LIC_MAX_SLOT) {
-				i = licp->lic_unused;
-				ASSERT(xfs_lic_isfree(licp, i));
-				break;
-			}
-			for (i = 0; i <= XFS_LIC_MAX_SLOT; i++) {
-				if (xfs_lic_isfree(licp, i))
-					break;
-			}
-			ASSERT(i <= XFS_LIC_MAX_SLOT);
-			break;
-		}
-		licp = licp->lic_next;
-	}
-	ASSERT(licp != NULL);
-	/*
-	 * If we find a free descriptor, claim it,
-	 * initialize it, and return it.
-	 */
-	xfs_lic_claim(licp, i);
-	if (licp->lic_unused <= i) {
-		licp->lic_unused = i + 1;
-		xfs_lic_init_slot(licp, i);
-	}
-	lidp = xfs_lic_slot(licp, i);
-	tp->t_items_free--;
-	lidp->lid_item = lip;
-	lidp->lid_flags = 0;
-	lidp->lid_size = 0;
-	lip->li_desc = lidp;
-	lip->li_mountp = tp->t_mountp;
-	return lidp;
-}
-
-/*
- * Free the given descriptor.
- *
- * This requires setting the bit in the chunk's free mask corresponding
- * to the given slot.
- */
-void
-xfs_trans_free_item(
-	xfs_trans_t		*tp,
-	xfs_log_item_desc_t	*lidp)
-{
-	uint			slot;
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	**licpp;
-
-	slot = xfs_lic_desc_to_slot(lidp);
-	licp = xfs_lic_desc_to_chunk(lidp);
-	xfs_lic_relse(licp, slot);
-	lidp->lid_item->li_desc = NULL;
-	tp->t_items_free++;
-
-	/*
-	 * If there are no more used items in the chunk and this is not
-	 * the chunk embedded in the transaction structure, then free
-	 * the chunk. First pull it from the chunk list and then
-	 * free it back to the heap.  We didn't bother with a doubly
-	 * linked list here because the lists should be very short
-	 * and this is not a performance path.  It's better to save
-	 * the memory of the extra pointer.
-	 *
-	 * Also decrement the transaction structure's count of free items
-	 * by the number in a chunk since we are freeing an empty chunk.
-	 */
-	if (xfs_lic_are_all_free(licp) && (licp != &(tp->t_items))) {
-		licpp = &(tp->t_items.lic_next);
-		while (*licpp != licp) {
-			ASSERT(*licpp != NULL);
-			licpp = &((*licpp)->lic_next);
-		}
-		*licpp = licp->lic_next;
-		kmem_free(licp);
-		tp->t_items_free -= XFS_LIC_NUM_SLOTS;
-	}
-}
-
-/*
- * This is called to find the descriptor corresponding to the given
- * log item.  It returns a pointer to the descriptor.
- * The log item MUST have a corresponding descriptor in the given
- * transaction.	 This routine does not return NULL, it panics.
- *
- * The descriptor pointer is kept in the log item's li_desc field.
- * Just return it.
- */
-xfs_log_item_desc_t *
-xfs_trans_find_item(
-	xfs_trans_t		*tp,
-	xfs_log_item_t		*lip)
-{
-	ASSERT(lip->li_desc != NULL);
-
-	return lip->li_desc;
-}
-
-/*
- * This is called to unlock all of the items of a transaction and to free
- * all the descriptors of that transaction.
- *
- * It walks the list of descriptors and unlocks each item.  It frees
- * each chunk except that embedded in the transaction as it goes along.
- */
-void
-xfs_trans_free_items(
-	xfs_trans_t		*tp,
-	int			flags)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-	int			abort;
-
-	abort = flags & XFS_TRANS_ABORT;
-	licp = &tp->t_items;
-	/*
-	 * Special case the embedded chunk so we don't free it below.
-	 */
-	if (!xfs_lic_are_all_free(licp)) {
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
-		xfs_lic_all_free(licp);
-		licp->lic_unused = 0;
-	}
-	licp = licp->lic_next;
-
-	/*
-	 * Unlock each item in each chunk and free the chunks.
-	 */
-	while (licp != NULL) {
-		ASSERT(!xfs_lic_are_all_free(licp));
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
-	}
-
-	/*
-	 * Reset the transaction structure's free item count.
-	 */
-	tp->t_items_free = XFS_LIC_NUM_SLOTS;
-	tp->t_items.lic_next = NULL;
-}
-
-/*
  * Following functions from fs/xfs/xfs_trans_buf.c
  */
 
@@ -250,149 +41,21 @@ xfs_trans_buf_item_match(
 	xfs_daddr_t		blkno,
 	int			len)
 {
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_desc_t	*lidp;
-	xfs_buf_log_item_t	*blip;
-	xfs_buf_t		*bp;
-	int			i;
-
-#ifdef LI_DEBUG
-	fprintf(stderr, "buf_item_match (fast) log items for xact %p\n", tp);
-#endif
-
-	bp = NULL;
-	len = BBTOB(len);
-	licp = &tp->t_items;
-	if (!xfs_lic_are_all_free(licp)) {
-		for (i = 0; i < licp->lic_unused; i++) {
-			/*
-			 * Skip unoccupied slots.
-			 */
-			if (xfs_lic_isfree(licp, i)) {
-				continue;
-			}
-
-			lidp = xfs_lic_slot(licp, i);
-			blip = (xfs_buf_log_item_t *)lidp->lid_item;
-#ifdef LI_DEBUG
-			fprintf(stderr,
-				"\tfound log item, xact %p, blip=%p (%d/%d)\n",
-				tp, blip, i, licp->lic_unused);
-#endif
-			if (blip->bli_item.li_type != XFS_LI_BUF) {
-				continue;
-			}
-
-			bp = blip->bli_buf;
-#ifdef LI_DEBUG
-			fprintf(stderr,
-			"\tfound buf %p log item, xact %p, blip=%p (%d)\n",
-				bp, tp, blip, i);
-#endif
-			if ((XFS_BUF_TARGET(bp) == target->dev) &&
-			    (XFS_BUF_ADDR(bp) == blkno) &&
-			    (XFS_BUF_COUNT(bp) == len)) {
-				/*
-				 * We found it.	 Break out and
-				 * return the pointer to the buffer.
-				 */
-#ifdef LI_DEBUG
-				fprintf(stderr,
-					"\tfound REAL buf log item, bp=%p\n",
-					bp);
-#endif
-				break;
-			} else {
-				bp = NULL;
-			}
-		}
-	}
-#ifdef LI_DEBUG
-	if (!bp) fprintf(stderr, "\tfast search - got nothing\n");
-#endif
-	return bp;
+        struct xfs_log_item_desc *lidp;
+        struct xfs_buf_log_item *blip;
+
+        len = BBTOB(len);
+        list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+                blip = (struct xfs_buf_log_item *)lidp->lid_item;
+                if (blip->bli_item.li_type == XFS_LI_BUF &&
+                    XFS_BUF_TARGET(blip->bli_buf) == target->dev &&
+                    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
+                    XFS_BUF_COUNT(blip->bli_buf) == len)
+                        return blip->bli_buf;
+        }
+
+        return NULL;
 }
-
-/*
- * Check to see if a buffer matching the given parameters is already
- * a part of the given transaction.  Check all the chunks, we
- * want to be thorough.
- */
-xfs_buf_t *
-xfs_trans_buf_item_match_all(
-	xfs_trans_t		*tp,
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	int			len)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_desc_t	*lidp;
-	xfs_buf_log_item_t	*blip;
-	xfs_buf_t		*bp;
-	int			i;
-
-#ifdef LI_DEBUG
-	fprintf(stderr, "buf_item_match_all (slow) log items for xact %p\n",
-		tp);
-#endif
-
-	bp = NULL;
-	len = BBTOB(len);
-	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
-		if (xfs_lic_are_all_free(licp)) {
-			ASSERT(licp == &tp->t_items);
-			ASSERT(licp->lic_next == NULL);
-			return NULL;
-		}
-		for (i = 0; i < licp->lic_unused; i++) {
-			/*
-			 * Skip unoccupied slots.
-			 */
-			if (xfs_lic_isfree(licp, i)) {
-				continue;
-			}
-
-			lidp = xfs_lic_slot(licp, i);
-			blip = (xfs_buf_log_item_t *)lidp->lid_item;
-#ifdef LI_DEBUG
-			fprintf(stderr,
-				"\tfound log item, xact %p, blip=%p (%d/%d)\n",
-				tp, blip, i, licp->lic_unused);
-#endif
-			if (blip->bli_item.li_type != XFS_LI_BUF) {
-				continue;
-			}
-
-			bp = blip->bli_buf;
-			ASSERT(bp);
-			ASSERT(XFS_BUF_ADDR(bp));
-#ifdef LI_DEBUG
-			fprintf(stderr,
-			"\tfound buf %p log item, xact %p, blip=%p (%d)\n",
-				bp, tp, blip, i);
-#endif
-			if ((XFS_BUF_TARGET(bp) == target->dev) &&
-			    (XFS_BUF_ADDR(bp) == blkno) &&
-			    (XFS_BUF_COUNT(bp) == len)) {
-				/*
-				 * We found it.	 Break out and
-				 * return the pointer to the buffer.
-				 */
-#ifdef LI_DEBUG
-				fprintf(stderr,
-					"\tfound REAL buf log item, bp=%p\n",
-					bp);
-#endif
-				return bp;
-			}
-		}
-	}
-#ifdef LI_DEBUG
-	if (!bp) fprintf(stderr, "slow search - got nothing\n");
-#endif
-	return NULL;
-}
-
 /*
  * The following are from fs/xfs/xfs_buf_item.c
  */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 1c60f38..c5dd2ca 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -36,8 +36,7 @@ libxfs_trans_alloc(
 	}
 	ptr->t_mountp = mp;
 	ptr->t_type = type;
-	ptr->t_items_free = XFS_LIC_NUM_SLOTS;
-	xfs_lic_init(&ptr->t_items);
+	INIT_LIST_HEAD(&ptr->t_items);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "allocated new transaction %p\n", ptr);
 #endif
@@ -139,7 +138,6 @@ libxfs_trans_iput(
 	uint			lock_flags)
 {
 	xfs_inode_log_item_t	*iip;
-	xfs_log_item_desc_t	*lidp;
 
 	if (tp == NULL) {
 		libxfs_iput(ip, lock_flags);
@@ -149,12 +147,7 @@ libxfs_trans_iput(
 	ASSERT(ip->i_transp == tp);
 	iip = ip->i_itemp;
 	ASSERT(iip != NULL);
-
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)iip);
-	ASSERT(lidp != NULL);
-	ASSERT(lidp->lid_item == (xfs_log_item_t *)iip);
-	ASSERT(!(lidp->lid_flags & XFS_LID_DIRTY));
-	xfs_trans_free_item(tp, lidp);
+	xfs_trans_del_item(&iip->ili_item);
 
 	libxfs_iput(ip, lock_flags);
 }
@@ -183,6 +176,23 @@ libxfs_trans_ijoin(
 }
 
 void
+libxfs_trans_ijoin_ref(
+	xfs_trans_t		*tp,
+	xfs_inode_t		*ip,
+	int			lock_flags)
+{
+	ASSERT(ip->i_transp == tp);
+	ASSERT(ip->i_itemp != NULL);
+
+	xfs_trans_ijoin(tp, ip, lock_flags);
+	ip->i_itemp->ili_lock_flags = lock_flags;
+
+#ifdef XACT_DEBUG
+	fprintf(stderr, "ijoin_ref'd inode %llu, transaction %p\n", ip->i_ino, tp);
+#endif
+}
+
+void
 libxfs_trans_ihold(
 	xfs_trans_t		*tp,
 	xfs_inode_t		*ip)
@@ -190,7 +200,8 @@ libxfs_trans_ihold(
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 
-	ip->i_itemp->ili_flags |= XFS_ILI_HOLD;
+	ip->i_itemp->ili_lock_flags = 1;
+
 #ifdef XACT_DEBUG
 	fprintf(stderr, "ihold'd inode %llu, transaction %p\n", ip->i_ino, tp);
 #endif
@@ -224,19 +235,14 @@ xfs_trans_log_inode(
 	xfs_inode_t		*ip,
 	uint			flags)
 {
-	xfs_log_item_desc_t	*lidp;
-
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
 #endif
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(ip->i_itemp));
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
 	/*
 	 * Always OR in the bits from the ili_last_fields field.
@@ -266,7 +272,6 @@ libxfs_trans_log_buf(
 	uint			last)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_desc_t	*lidp;
 
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
@@ -277,11 +282,8 @@ libxfs_trans_log_buf(
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)bip);
-	ASSERT(lidp != NULL);
-
 	tp->t_flags |= XFS_TRANS_DIRTY;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	xfs_buf_item_log(bip, first, last);
 }
 
@@ -291,7 +293,6 @@ libxfs_trans_brelse(
 	xfs_buf_t		*bp)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_desc_t	*lidp;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -304,8 +305,6 @@ libxfs_trans_brelse(
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
 	if (bip->bli_recur > 0) {
 		bip->bli_recur--;
 		return;
@@ -313,9 +312,9 @@ libxfs_trans_brelse(
 	/* If dirty/stale, can't release till transaction committed */
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
-	if (lidp->lid_flags & XFS_LID_DIRTY)
+	if (bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY)
 		return;
-	xfs_trans_free_item(tp, lidp);
+	xfs_trans_del_item(&bip->bli_item);
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
 	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
@@ -327,7 +326,6 @@ libxfs_trans_binval(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_log_item_desc_t	*lidp;
 	xfs_buf_log_item_t	*bip;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
@@ -337,17 +335,15 @@ libxfs_trans_binval(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
-	ASSERT(lidp != NULL);
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
 	XFS_BUF_UNDELAYWRITE(bp);
 	XFS_BUF_STALE(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~XFS_BLI_DIRTY;
-	bip->bli_format.blf_flags &= ~XFS_BLI_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLI_CANCEL;
-	lidp->lid_flags |= XFS_LID_DIRTY;
+	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
+	bip->bli_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
@@ -402,10 +398,7 @@ libxfs_trans_get_buf(
 		return libxfs_getbuf(dev, d, len);
 
 	bdev.dev = dev;
-	if (tp->t_items.lic_next == NULL)
-		bp = xfs_trans_buf_item_match(tp, &bdev, d, len);
-	else
-		bp = xfs_trans_buf_item_match_all(tp, &bdev, d, len);
+	bp = xfs_trans_buf_item_match(tp, &bdev, d, len);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -447,10 +440,7 @@ libxfs_trans_getsb(
 
 	bdev.dev = mp->m_dev;
 	len = XFS_FSS_TO_BB(mp, 1);
-	if (tp->t_items.lic_next == NULL)
-		bp = xfs_trans_buf_item_match(tp, &bdev, XFS_SB_DADDR, len);
-	else
-		bp = xfs_trans_buf_item_match_all(tp, &bdev, XFS_SB_DADDR, len);
+	bp = xfs_trans_buf_item_match(tp, &bdev, XFS_SB_DADDR, len);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -494,10 +484,7 @@ libxfs_trans_read_buf(
 	}
 
 	bdev.dev = dev;
-	if (tp->t_items.lic_next == NULL)
-		bp = xfs_trans_buf_item_match(tp, &bdev, blkno, len);
-	else
-		bp = xfs_trans_buf_item_match_all(tp, &bdev, blkno, len);
+	bp = xfs_trans_buf_item_match(tp, &bdev, blkno, len);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
@@ -574,13 +561,11 @@ inode_item_done(
 	xfs_inode_t		*ip;
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
-	int			hold;
 	int			error;
 	extern kmem_zone_t	*xfs_ili_zone;
 
 	ip = iip->ili_inode;
 	mp = iip->ili_item.li_mountp;
-	hold = iip->ili_flags & XFS_ILI_HOLD;
 	ASSERT(ip != NULL);
 
 	if (!(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) {
@@ -613,11 +598,11 @@ inode_item_done(
 	libxfs_writebuf(bp, 0);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "flushing dirty inode %llu, buffer %p (hold=%u)\n",
-			ip->i_ino, bp, hold);
+			ip->i_ino, bp, iip->ili_lock_flags);
 #endif
 ili_done:
-	if (hold) {
-		iip->ili_flags &= ~XFS_ILI_HOLD;
+	if (iip->ili_lock_flags) {
+		iip->ili_lock_flags = 0;
 		return;
 	} else {
 		libxfs_iput(ip, 0);
@@ -659,63 +644,26 @@ buf_item_done(
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
-/*
- * This is called to perform the commit processing for each
- * item described by the given chunk.
- */
 static void
-trans_chunk_committed(
-	xfs_log_item_chunk_t	*licp)
+trans_committed(
+	xfs_trans_t		*tp)
 {
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	int			i;
-
-	lidp = licp->lic_descs;
-	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (xfs_lic_isfree(licp, i))
-			continue;
-		lip = lidp->lid_item;
+        struct xfs_log_item_desc *lidp, *next;
+
+        list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
+		struct xfs_log_item *lip = lidp->lid_item;
+
+                xfs_trans_del_item(lip);
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_done((xfs_buf_log_item_t *)lidp->lid_item);
+			buf_item_done((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
-			inode_item_done((xfs_inode_log_item_t *)lidp->lid_item);
+			inode_item_done((xfs_inode_log_item_t *)lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
 			ASSERT(0);
 		}
-	}
-}
-
-/*
- * Calls trans_chunk_committed() to process the items in each chunk.
- */
-static void
-trans_committed(
-	xfs_trans_t		*tp)
-{
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-
-	/*
-	 * Special case the chunk embedded in the transaction.
-	 */
-	licp = &(tp->t_items);
-	if (!(xfs_lic_are_all_free(licp))) {
-		trans_chunk_committed(licp);
-	}
-
-	/*
-	 * Process the items in each chunk in turn.
-	 */
-	licp = licp->lic_next;
-	while (licp != NULL) {
-		trans_chunk_committed(licp);
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
-	}
+        }
 }
 
 static void
@@ -729,9 +677,9 @@ buf_item_unlock(
 	XFS_BUF_SET_FSPRIVATE2(bip->bli_buf, NULL);
 
 	hold = bip->bli_flags & XFS_BLI_HOLD;
+	bip->bli_flags &= ~XFS_BLI_HOLD;
 	if (!hold)
 		libxfs_putbuf(bp);
-	bip->bli_flags &= ~XFS_BLI_HOLD;
 }
 
 static void
@@ -739,75 +687,44 @@ inode_item_unlock(
 	xfs_inode_log_item_t	*iip)
 {
 	xfs_inode_t		*ip = iip->ili_inode;
-	uint			hold;
 
 	/* Clear the transaction pointer in the inode. */
 	ip->i_transp = NULL;
 
-	hold = iip->ili_flags & XFS_ILI_HOLD;
-	if (!hold)
-		libxfs_iput(ip, 0);
 	iip->ili_flags = 0;
+	if (!iip->ili_lock_flags)
+		libxfs_iput(ip, 0);
+	else
+		iip->ili_lock_flags = 0;
 }
 
 /*
- * Unlock each item pointed to by a descriptor in the given chunk.
- * Free descriptors pointing to items which are not dirty if freeing_chunk
- * is zero. If freeing_chunk is non-zero, then we need to unlock all
- * items in the chunk.	Return the number of descriptors freed.
- * Originally based on xfs_trans_unlock_chunk() - adapted for libxfs
- * transactions though.
+ * Unlock all of the items of a transaction and free all the descriptors
+ * of that transaction.
  */
-int
-xfs_trans_unlock_chunk(
-	xfs_log_item_chunk_t	*licp,
-	int			freeing_chunk,
-	int			abort,
-	xfs_lsn_t		commit_lsn)	/* nb: unused */
+void
+xfs_trans_free_items(
+	struct xfs_trans	*tp,
+	int			flags)
 {
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	int			i;
-	int			freed;
-
-	freed = 0;
-	lidp = licp->lic_descs;
-	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-		lip = lidp->lid_item;
-		lip->li_desc = NULL;
+	struct xfs_log_item_desc *lidp, *next;
 
-		/*
-		 * Disassociate the logged item from this transaction
-		 */
+	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
+
+                xfs_trans_del_item(lip);
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_unlock((xfs_buf_log_item_t *)lidp->lid_item);
+			buf_item_unlock((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
-			inode_item_unlock((xfs_inode_log_item_t *)lidp->lid_item);
+			inode_item_unlock((xfs_inode_log_item_t *)lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
 			ASSERT(0);
 		}
-
-		/*
-		 * Free the descriptor if the item is not dirty
-		 * within this transaction and the caller is not
-		 * going to just free the entire thing regardless.
-		 */
-		if (!(freeing_chunk) &&
-		    (!(lidp->lid_flags & XFS_LID_DIRTY) || abort)) {
-			xfs_lic_relse(licp, i);
-			freed++;
-		}
 	}
-
-	return (freed);
 }
 
-
 /*
  * Commit the changes represented by this transaction
  */
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 8e94dad..a9e2bf1 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -108,8 +108,6 @@ typedef __uint32_t		inst_t;		/* an instruction */
 
 #define PAGE_CACHE_SIZE 	getpagesize()
 
-#define INIT_LIST_HEAD(x)
-
 static inline int __do_div(unsigned long long *n, unsigned base)
 {
 	int __res;
@@ -329,10 +327,9 @@ void xfs_mount_common(xfs_mount_t *, xfs_sb_t *);
  */
 
 /* xfs_trans_item.c */
-xfs_log_item_desc_t *xfs_trans_add_item (xfs_trans_t *, xfs_log_item_t *);
-xfs_log_item_desc_t *xfs_trans_find_item (xfs_trans_t *, xfs_log_item_t *);
-void xfs_trans_free_item (xfs_trans_t *, xfs_log_item_desc_t *);
-void xfs_trans_free_items (xfs_trans_t *, int);
+void xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
+void xfs_trans_del_item(struct xfs_log_item *);
+void xfs_trans_free_items(struct xfs_trans *, int);
 
 /* xfs_inode_item.c */
 void xfs_inode_item_init (xfs_inode_t *, xfs_mount_t *);
@@ -344,10 +341,7 @@ void xfs_buf_item_log (xfs_buf_log_item_t *, uint, uint);
 /* xfs_trans_buf.c */
 xfs_buf_t *xfs_trans_buf_item_match (xfs_trans_t *, xfs_buftarg_t *,
 			xfs_daddr_t, int);
-xfs_buf_t *xfs_trans_buf_item_match_all (xfs_trans_t *, xfs_buftarg_t *,
-			xfs_daddr_t, int);
 
 /* local source files */
 int  xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 void xfs_trans_mod_sb(xfs_trans_t *, uint, long);
-int  xfs_trans_unlock_chunk (xfs_log_item_chunk_t *, int, int, xfs_lsn_t);
diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index 02bff42..dde9678 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -270,7 +270,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
-	INIT_LIST_HEAD(&mp->m_del_inodes);
 
 	/*
 	 * Setup for attributes, in case they get created.
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index 9036995..635de8f 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -18,135 +19,491 @@
 
 #include <xfs.h>
 
+kmem_zone_t	*xfs_trans_zone;
+kmem_zone_t	*xfs_log_item_desc_zone;
+
 /*
- * Reservation functions here avoid a huge stack in xfs_trans_init
- * due to register overflow from temporaries in the calculations.
+ * Various log reservation values.
+ *
+ * These are based on the size of the file system block because that is what
+ * most transactions manipulate.  Each adds in an additional 128 bytes per
+ * item logged to try to account for the overhead of the transaction mechanism.
+ *
+ * Note:  Most of the reservations underestimate the number of allocation
+ * groups into which they could free extents in the xfs_bmap_finish() call.
+ * This is because the number in the worst case is quite high and quite
+ * unusual.  In order to fix this we need to change xfs_bmap_finish() to free
+ * extents in only a single AG at a time.  This will require changes to the
+ * EFI code as well, however, so that the EFI for the extents not freed is
+ * logged again in each transaction.  See SGI PV #261917.
+ *
+ * Reservation functions here avoid a huge stack in xfs_trans_init due to
+ * register overflow from temporaries in the calculations.
  */
 
+
+/*
+ * In a write transaction we can allocate a maximum of 2
+ * extents.  This gives:
+ *    the inode getting the new extents: inode size
+ *    the inode's bmap btree: max depth * block size
+ *    the agfs of the ags from which the extents are allocated: 2 * sector
+ *    the superblock free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And the bmap_finish transaction can free bmap blocks in a join:
+ *    the agfs of the ags containing the blocks: 2 * sector size
+ *    the agfls of the ags containing the blocks: 2 * sector size
+ *    the super block free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_write_reservation(xfs_mount_t *mp)
+xfs_calc_write_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_WRITE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 2))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * In truncating a file we free up to two extents at once.  We can modify:
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: (max depth + 1) * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_itruncate_reservation(xfs_mount_t *mp)
+xfs_calc_itruncate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ITRUNCATE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) +
+		     128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		    (4 * mp->m_sb.sb_sectsize +
+		     4 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 4) +
+		     128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
+		     128 * 5 +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * In renaming a files we can modify:
+ *    the four inodes involved: 4 * inode size
+ *    the two directory btrees: 2 * (max depth + v2) * dir block size
+ *    the two directory bmap btrees: 2 * max depth * block size
+ * And the bmap_finish transaction can free dir and bmap blocks (two sets
+ *	of bmap blocks) giving:
+ *    the agf for the ags in which the blocks live: 3 * sector size
+ *    the agfl for the ags in which the blocks live: 3 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_rename_reservation(xfs_mount_t *mp)
+xfs_calc_rename_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_RENAME_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((4 * mp->m_sb.sb_inodesize +
+		     2 * XFS_DIROP_LOG_RES(mp) +
+		     128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp))),
+		    (3 * mp->m_sb.sb_sectsize +
+		     3 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 3) +
+		     128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))));
 }
 
+/*
+ * For creating a link to an inode:
+ *    the parent directory inode: inode size
+ *    the linked inode: inode size
+ *    the directory btree could split: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free some bmap blocks giving:
+ *    the agf for the ag in which the blocks live: sector size
+ *    the agfl for the ag in which the blocks live: sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_link_reservation(xfs_mount_t *mp)
+xfs_calc_link_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_LINK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		    (mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * For removing a directory entry we can modify:
+ *    the parent directory inode: inode size
+ *    the removed inode: inode size
+ *    the directory btree could join: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free the dir and bmap blocks giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_remove_reservation(xfs_mount_t *mp)
+xfs_calc_remove_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_REMOVE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * For symlink we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: 1 block
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the blocks for the symlink: 1 kB
+ * Or in the first xact we allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_symlink_reservation(xfs_mount_t *mp)
+xfs_calc_symlink_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_SYMLINK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, 1) +
+		     XFS_DIROP_LOG_RES(mp) +
+		     1024 +
+		     128 * (4 + XFS_DIROP_LOG_COUNT(mp))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
+		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * For create we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: block size
+ *    the superblock for the nlink flag: sector size
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ * Or in the first xact we allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_create_reservation(xfs_mount_t *mp)
+xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_CREATE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, 1) +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (3 + XFS_DIROP_LOG_COUNT(mp))),
+		    (3 * mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
+		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * Making a new directory is the same as creating a new file.
+ */
 STATIC uint
-xfs_calc_mkdir_reservation(xfs_mount_t *mp)
+xfs_calc_mkdir_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_MKDIR_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return xfs_calc_create_reservation(mp);
 }
 
+/*
+ * In freeing an inode we can modify:
+ *    the inode being freed: inode size
+ *    the super block free inode counter: sector size
+ *    the agi hash list and counters: sector size
+ *    the inode btree entry: block size
+ *    the on disk inode before ours in the agi hash list: inode cluster size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_ifree_reservation(xfs_mount_t *mp)
+xfs_calc_ifree_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_IFREE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, 1) +
+		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
+		    XFS_INODE_CLUSTER_SIZE(mp)) +
+		128 * 5 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * When only changing the inode we log the inode and possibly the superblock
+ * We also add a bit of slop for the transaction stuff.
+ */
 STATIC uint
-xfs_calc_ichange_reservation(xfs_mount_t *mp)
+xfs_calc_ichange_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ICHANGE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		512;
+
 }
 
+/*
+ * Growing the data section of the filesystem.
+ *	superblock
+ *	agi and agf
+ *	allocation btrees
+ */
 STATIC uint
-xfs_calc_growdata_reservation(xfs_mount_t *mp)
+xfs_calc_growdata_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWDATA_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize * 3 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the first set of transactions (ALLOC) we allocate space to the
+ * bitmap or summary files.
+ *	superblock: sector size
+ *	agf of the ag from which the extent is allocated: sector size
+ *	bmap btree for bitmap/summary inode: max depth * blocksize
+ *	bitmap/summary inode: inode size
+ *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
+ */
 STATIC uint
-xfs_calc_growrtalloc_reservation(xfs_mount_t *mp)
+xfs_calc_growrtalloc_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTALLOC_LOG_RES(mp);
+	return 2 * mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
+		mp->m_sb.sb_inodesize +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the second set of transactions (ZERO) we zero the new metadata blocks.
+ *	one bitmap/summary block: blocksize
+ */
 STATIC uint
-xfs_calc_growrtzero_reservation(xfs_mount_t *mp)
+xfs_calc_growrtzero_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTZERO_LOG_RES(mp);
+	return mp->m_sb.sb_blocksize + 128;
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the third set of transactions (FREE) we update metadata without
+ * allocating any new blocks.
+ *	superblock: sector size
+ *	bitmap inode: inode size
+ *	summary inode: inode size
+ *	one bitmap block: blocksize
+ *	summary blocks: new summary size
+ */
 STATIC uint
-xfs_calc_growrtfree_reservation(xfs_mount_t *mp)
+xfs_calc_growrtfree_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTFREE_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize +
+		2 * mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_blocksize +
+		mp->m_rsumsize +
+		128 * 5;
 }
 
+/*
+ * Logging the inode modification timestamp on a synchronous write.
+ *	inode
+ */
 STATIC uint
-xfs_calc_swrite_reservation(xfs_mount_t *mp)
+xfs_calc_swrite_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_SWRITE_LOG_RES(mp);
+	return mp->m_sb.sb_inodesize + 128;
 }
 
+/*
+ * Logging the inode mode bits when writing a setuid/setgid file
+ *	inode
+ */
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return XFS_CALC_WRITEID_LOG_RES(mp);
+	return mp->m_sb.sb_inodesize + 128;
 }
 
+/*
+ * Converting the inode from non-attributed to attributed.
+ *	the inode being converted: inode size
+ *	agf block and superblock (for block allocation)
+ *	the new block (directory sized)
+ *	bmap blocks for the new directory block
+ *	allocation btrees
+ */
 STATIC uint
-xfs_calc_addafork_reservation(xfs_mount_t *mp)
+xfs_calc_addafork_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ADDAFORK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize * 2 +
+		mp->m_dirblksize +
+		XFS_FSB_TO_B(mp, XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (4 + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1 +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Removing the attribute fork of a file
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: max depth * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_attrinval_reservation(xfs_mount_t *mp)
+xfs_calc_attrinval_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRINVAL_LOG_RES(mp);
+	return MAX((mp->m_sb.sb_inodesize +
+		    XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		    128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))),
+		   (4 * mp->m_sb.sb_sectsize +
+		    4 * mp->m_sb.sb_sectsize +
+		    mp->m_sb.sb_sectsize +
+		    XFS_ALLOCFREE_LOG_RES(mp, 4) +
+		    128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))));
 }
 
+/*
+ * Setting an attribute.
+ *	the inode getting the attribute
+ *	the superblock for allocations
+ *	the agfs extents are allocated from
+ *	the attribute btree * max depth
+ *	the inode allocation btree
+ * Since attribute transaction space is dependent on the size of the attribute,
+ * the calculation is done partially at mount time and partially at runtime.
+ */
 STATIC uint
-xfs_calc_attrset_reservation(xfs_mount_t *mp)
+xfs_calc_attrset_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRSET_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		128 * (2 + XFS_DA_NODE_MAXDEPTH);
 }
 
+/*
+ * Removing an attribute.
+ *    the inode: inode size
+ *    the attribute btree could join: max depth * block size
+ *    the inode bmap btree could join or split: max depth * block size
+ * And the bmap_finish transaction can free the attr blocks freed giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_attrrm_reservation(xfs_mount_t *mp)
+xfs_calc_attrrm_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRRM_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		     128 * (1 + XFS_DA_NODE_MAXDEPTH +
+			    XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * Clearing a bad agino number in an agi hash bucket.
+ */
 STATIC uint
-xfs_calc_clear_agi_bucket_reservation(xfs_mount_t *mp)
+xfs_calc_clear_agi_bucket_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_CLEAR_AGI_BUCKET_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize + 128;
 }
 
 /*
@@ -155,11 +512,10 @@ xfs_calc_clear_agi_bucket_reservation(xfs_mount_t *mp)
  */
 void
 xfs_trans_init(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_trans_reservations_t	*resp;
+	struct xfs_trans_reservations *resp = &mp->m_reservations;
 
-	resp = &(mp->m_reservations);
 	resp->tr_write = xfs_calc_write_reservation(mp);
 	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
 	resp->tr_rename = xfs_calc_rename_reservation(mp);
@@ -184,6 +540,50 @@ xfs_trans_init(
 }
 
 /*
+ * Add the given log item to the transaction's list of log items.
+ *
+ * The log item will now point to its new descriptor with its li_desc field.
+ */
+void
+xfs_trans_add_item(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_log_item_desc *lidp;
+
+	ASSERT(lip->li_mountp = tp->t_mountp);
+	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
+
+	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
+
+	lidp->lid_item = lip;
+	lidp->lid_flags = 0;
+	lidp->lid_size = 0;
+	list_add_tail(&lidp->lid_trans, &tp->t_items);
+
+	lip->li_desc = lidp;
+}
+
+STATIC void
+xfs_trans_free_item_desc(
+	struct xfs_log_item_desc *lidp)
+{
+	list_del_init(&lidp->lid_trans);
+	kmem_zone_free(xfs_log_item_desc_zone, lidp);
+}
+
+/*
+ * Unlink and free the given descriptor.
+ */
+void
+xfs_trans_del_item(
+	struct xfs_log_item	*lip)
+{
+	xfs_trans_free_item_desc(lip->li_desc);
+	lip->li_desc = NULL;
+}
+
+/*
  * Roll from one trans in the sequence of PERMANENT transactions to
  * the next: permanent transactions are only flushed out when
  * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 9e0e567..23fe6fd 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -22,31 +22,60 @@
 #define xlog_clear_stale_blocks(log, tail_lsn)		(0)
 #define xfs_readonly_buftarg(buftarg)			(0)
 
-STATIC void	xlog_recover_insert_item_backq(xlog_recover_item_t **q,
-					       xlog_recover_item_t *item);
 
 /*
- * Sector aligned buffer routines for buffer create/read/write/access
+ * Verify the given count of basic blocks is valid number of blocks
+ * to specify for an operation involving the given XFS log buffer.
+ * Returns nonzero if the count is valid, 0 otherwise.
  */
 
-#define XLOG_SECTOR_ROUNDUP_BBCOUNT(log, bbs)	\
-	( ((log)->l_sectbb_mask && (bbs & (log)->l_sectbb_mask)) ? \
-	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
-#define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
+static inline int
+xlog_buf_bbcount_valid(
+	xlog_t		*log,
+	int		bbcount)
+{
+	return bbcount > 0 && bbcount <= log->l_logBBsize;
+}
 
+/*
+ * Allocate a buffer to hold log data.  The buffer needs to be able
+ * to map to a range of nbblks basic blocks at any valid (basic
+ * block) offset within the log.
+ */
 xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
-	int		num_bblks)
+	int		nbblks)
 {
-	ASSERT(num_bblks > 0);
-
-	if (log->l_sectbb_log) {
-		if (num_bblks > 1)
-			num_bblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
-		num_bblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, num_bblks);
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
+		return NULL;
 	}
-	return libxfs_getbufr(log->l_dev, (xfs_daddr_t)-1, num_bblks);
+
+	/*
+	 * We do log I/O in units of log sectors (a power-of-2
+	 * multiple of the basic block size), so we round up the
+	 * requested size to acommodate the basic blocks required
+	 * for complete log sectors.
+	 *
+	 * In addition, the buffer may be used for a non-sector-
+	 * aligned block offset, in which case an I/O of the
+	 * requested size could extend beyond the end of the
+	 * buffer.  If the requested size is only 1 basic block it
+	 * will never straddle a sector boundary, so this won't be
+	 * an issue.  Nor will this be a problem if the log I/O is
+	 * done in basic blocks (sector size 1).  But otherwise we
+	 * extend the buffer by one extra log sector to ensure
+	 * there's space to accomodate this possiblility.
+	 */
+	if (nbblks > 1 && log->l_sectBBsize > 1)
+		nbblks += log->l_sectBBsize;
+	if (log->l_sectBBsize)
+		nbblks = round_up(nbblks, log->l_sectBBsize);
+
+	return libxfs_getbufr(log->l_dev, (xfs_daddr_t)-1, nbblks);
 }
 
 void
@@ -56,25 +85,50 @@ xlog_put_bp(
 	libxfs_putbufr(bp);
 }
 
+/*
+ * Return the address of the start of the given block number's data
+ * in a log buffer.  The buffer covers a log sector-aligned region.
+ */
+STATIC xfs_caddr_t
+xlog_align(
+	xlog_t		*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	xfs_buf_t	*bp)
+{
+	xfs_daddr_t	offset = 0;
+
+	if (log->l_sectBBsize)
+		offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
+
+	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));
+	return XFS_BUF_PTR(bp) + BBTOB(offset);
+}
 
 /*
  * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
  */
 int
-xlog_bread(
+xlog_bread_noalign(
 	xlog_t		*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	xfs_buf_t	*bp)
 {
-	if (log->l_sectbb_log) {
-		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
-		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
+	if (log->l_sectBBsize > 1) {
+		blk_no = round_down(blk_no, log->l_sectBBsize);
+		nbblks = round_up(nbblks, log->l_sectBBsize);
 	}
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
-	ASSERT(bp);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
@@ -82,26 +136,24 @@ xlog_bread(
 	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
 }
 
-
-static xfs_caddr_t
-xlog_align(
+int
+xlog_bread(
 	xlog_t		*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	xfs_buf_t	*bp)
+	xfs_buf_t	*bp,
+	xfs_caddr_t	*offset)
 {
-	xfs_caddr_t	ptr;
+	int		error;
 
-	if (!log->l_sectbb_log)
-		return XFS_BUF_PTR(bp);
+	error = xlog_bread_noalign(log, blk_no, nbblks, bp);
+	if (error)
+		return error;
 
-	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
-	ASSERT(XFS_BUF_SIZE(bp) >=
-		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
-	return ptr;
+	*offset = xlog_align(log, blk_no, nbblks, bp);
+	return 0;
 }
 
-
 /*
  * This routine finds (to an approximation) the first block in the physical
  * log which contains the given cycle.  It uses a binary search algorithm.
@@ -118,39 +170,38 @@ xlog_find_cycle_start(
 {
 	xfs_caddr_t	offset;
 	xfs_daddr_t	mid_blk;
+	xfs_daddr_t	end_blk;
 	uint		mid_cycle;
 	int		error;
 
-	mid_blk = BLK_AVG(first_blk, *last_blk);
-	while (mid_blk != first_blk && mid_blk != *last_blk) {
-		if ((error = xlog_bread(log, mid_blk, 1, bp)))
+	end_blk = *last_blk;
+	mid_blk = BLK_AVG(first_blk, end_blk);
+	while (mid_blk != first_blk && mid_blk != end_blk) {
+		error = xlog_bread(log, mid_blk, 1, bp, &offset);
+		if (error)
 			return error;
-		offset = xlog_align(log, mid_blk, 1, bp);
 		mid_cycle = xlog_get_cycle(offset);
-		if (mid_cycle == cycle) {
-			*last_blk = mid_blk;
-			/* last_half_cycle == mid_cycle */
-		} else {
-			first_blk = mid_blk;
-			/* first_half_cycle == mid_cycle */
-		}
-		mid_blk = BLK_AVG(first_blk, *last_blk);
+		if (mid_cycle == cycle)
+			end_blk = mid_blk;   /* last_half_cycle == mid_cycle */
+		else
+			first_blk = mid_blk; /* first_half_cycle == mid_cycle */
+		mid_blk = BLK_AVG(first_blk, end_blk);
 	}
-	ASSERT((mid_blk == first_blk && mid_blk+1 == *last_blk) ||
-	       (mid_blk == *last_blk && mid_blk-1 == first_blk));
+	ASSERT((mid_blk == first_blk && mid_blk+1 == end_blk) ||
+	       (mid_blk == end_blk && mid_blk-1 == first_blk));
+
+	*last_blk = end_blk;
 
 	return 0;
 }
 
 /*
- * Check that the range of blocks does not contain the cycle number
- * given.  The scan needs to occur from front to back and the ptr into the
- * region must be updated since a later routine will need to perform another
- * test.  If the region is completely good, we end up returning the same
- * last block number.
- *
- * Set blkno to -1 if we encounter no errors.  This is an invalid block number
- * since we don't ever expect logs to get this large.
+ * Check that a range of blocks does not contain stop_on_cycle_no.
+ * Fill in *new_blk with the block offset where such a block is
+ * found, or with -1 (an invalid block number) if there is no such
+ * block in the range.  The scan needs to occur from front to back
+ * and the pointer into the region must be updated since a later
+ * routine will need to perform another test.
  */
 STATIC int
 xlog_find_verify_cycle(
@@ -167,12 +218,16 @@ xlog_find_verify_cycle(
 	xfs_caddr_t	buf = NULL;
 	int		error = 0;
 
+	/*
+	 * Greedily allocate a buffer big enough to handle the full
+	 * range of basic blocks we'll be examining.  If that fails,
+	 * try a smaller size.  We need to be able to read at least
+	 * a log sector, or we're out of luck.
+	 */
 	bufblks = 1 << ffs(nbblks);
-
 	while (!(bp = xlog_get_bp(log, bufblks))) {
-		/* can't get enough memory to do everything in one big buffer */
 		bufblks >>= 1;
-		if (bufblks <= log->l_sectbb_log)
+		if (bufblks < MAX(log->l_sectBBsize, 1))
 			return ENOMEM;
 	}
 
@@ -181,10 +236,10 @@ xlog_find_verify_cycle(
 
 		bcount = min(bufblks, (start_blk + nbblks - i));
 
-		if ((error = xlog_bread(log, i, bcount, bp)))
+		error = xlog_bread(log, i, bcount, bp, &buf);
+		if (error)
 			goto out;
 
-		buf = xlog_align(log, i, bcount, bp);
 		for (j = 0; j < bcount; j++) {
 			cycle = xlog_get_cycle(buf);
 			if (cycle == stop_on_cycle_no) {
@@ -238,9 +293,9 @@ xlog_find_verify_log_record(
 			return ENOMEM;
 		smallmem = 1;
 	} else {
-		if ((error = xlog_bread(log, start_blk, num_blks, bp)))
+		error = xlog_bread(log, start_blk, num_blks, bp, &offset);
+		if (error)
 			goto out;
-		offset = xlog_align(log, start_blk, num_blks, bp);
 		offset += ((num_blks - 1) << BBSHIFT);
 	}
 
@@ -255,9 +310,9 @@ xlog_find_verify_log_record(
 		}
 
 		if (smallmem) {
-			if ((error = xlog_bread(log, i, 1, bp)))
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
 				goto out;
-			offset = xlog_align(log, i, 1, bp);
 		}
 
 		head = (xlog_rec_header_t *)offset;
@@ -325,7 +380,7 @@ out:
  *
  * Return: zero if normal, non-zero if error.
  */
-int
+STATIC int
 xlog_find_head(
 	xlog_t 		*log,
 	xfs_daddr_t	*return_head_blk)
@@ -337,14 +392,13 @@ xlog_find_head(
 	uint		first_half_cycle, last_half_cycle;
 	uint		stop_on_cycle;
 	int		error, log_bbnum = log->l_logBBsize;
-	extern int	platform_has_uuid;
 
 	/* Is the end of the log device zeroed? */
 	if ((error = xlog_find_zeroed(log, &first_blk)) == -1) {
 		*return_head_blk = first_blk;
 
 		/* Is the whole lot zeroed? */
-		if (!first_blk && platform_has_uuid) {
+		if (!first_blk) {
 			/* Linux XFS shouldn't generate totally zeroed logs -
 			 * mkfs etc write a dummy unmount record to a fresh
 			 * log so we can store the uuid in there
@@ -362,15 +416,18 @@ xlog_find_head(
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return ENOMEM;
-	if ((error = xlog_bread(log, 0, 1, bp)))
+
+	error = xlog_bread(log, 0, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, 0, 1, bp);
+
 	first_half_cycle = xlog_get_cycle(offset);
 
 	last_blk = head_blk = log_bbnum - 1;	/* get cycle # of last block */
-	if ((error = xlog_bread(log, last_blk, 1, bp)))
+	error = xlog_bread(log, last_blk, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, last_blk, 1, bp);
+
 	last_half_cycle = xlog_get_cycle(offset);
 	ASSERT(last_half_cycle != 0);
 
@@ -418,7 +475,7 @@ xlog_find_head(
 		 * In this case we want to find the first block with cycle
 		 * number matching last_half_cycle.  We expect the log to be
 		 * some variation on
-		 *        x + 1 ... | x ...
+		 *        x + 1 ... | x ... | x
 		 * The first block with cycle number x (last_half_cycle) will
 		 * be where the new head belongs.  First we do a binary search
 		 * for the first occurrence of last_half_cycle.  The binary
@@ -428,11 +485,13 @@ xlog_find_head(
 		 * the log, then we look for occurrences of last_half_cycle - 1
 		 * at the end of the log.  The cases we're looking for look
 		 * like
-		 *        x + 1 ... | x | x + 1 | x ...
-		 *                               ^ binary search stopped here
+		 *                               v binary search stopped here
+		 *        x + 1 ... | x | x + 1 | x ... | x
+		 *                   ^ but we want to locate this spot
 		 * or
-		 *        x + 1 ... | x ... | x - 1 | x
 		 *        <---------> less than scan distance
+		 *        x + 1 ... | x ... | x - 1 | x
+		 *                           ^ we want to locate this spot
 		 */
 		stop_on_cycle = last_half_cycle;
 		if ((error = xlog_find_cycle_start(log, bp, first_blk,
@@ -488,16 +547,16 @@ xlog_find_head(
 		 * certainly not the head of the log.  By searching for
 		 * last_half_cycle-1 we accomplish that.
 		 */
-		start_blk = log_bbnum - num_scan_bblks + head_blk;
 		ASSERT(head_blk <= INT_MAX &&
-			(xfs_daddr_t) num_scan_bblks - head_blk >= 0);
+			(xfs_daddr_t) num_scan_bblks >= head_blk);
+		start_blk = log_bbnum - (num_scan_bblks - head_blk);
 		if ((error = xlog_find_verify_cycle(log, start_blk,
 					num_scan_bblks - (int)head_blk,
 					(stop_on_cycle - 1), &new_blk)))
 			goto bp_err;
 		if (new_blk != -1) {
 			head_blk = new_blk;
-			goto bad_blk;
+			goto validate_head;
 		}
 
 		/*
@@ -515,7 +574,7 @@ xlog_find_head(
 			head_blk = new_blk;
 	}
 
- bad_blk:
+validate_head:
 	/*
 	 * Now we need to make sure head_blk is not pointing to a block in
 	 * the middle of a log record.
@@ -537,7 +596,7 @@ xlog_find_head(
 		if ((error = xlog_find_verify_log_record(log, start_blk,
 							&head_blk, 0)) == -1) {
 			/* We hit the beginning of the log during our search */
-			start_blk = log_bbnum - num_scan_bblks + head_blk;
+			start_blk = log_bbnum - (num_scan_bblks - head_blk);
 			new_blk = log_bbnum;
 			ASSERT(start_blk <= INT_MAX &&
 				(xfs_daddr_t) log_bbnum-start_blk >= 0);
@@ -620,13 +679,14 @@ xlog_find_tail(
 	if (!bp)
 		return ENOMEM;
 	if (*head_blk == 0) {				/* special case */
-		if ((error = xlog_bread(log, 0, 1, bp)))
-			goto bread_err;
-		offset = xlog_align(log, 0, 1, bp);
+		error = xlog_bread(log, 0, 1, bp, &offset);
+		if (error)
+			goto done;
+
 		if (xlog_get_cycle(offset) == 0) {
 			*tail_blk = 0;
 			/* leave all other log inited values alone */
-			goto exit;
+			goto done;
 		}
 	}
 
@@ -635,9 +695,10 @@ xlog_find_tail(
 	 */
 	ASSERT(*head_blk < INT_MAX);
 	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
-		if ((error = xlog_bread(log, i, 1, bp)))
-			goto bread_err;
-		offset = xlog_align(log, i, 1, bp);
+		error = xlog_bread(log, i, 1, bp, &offset);
+		if (error)
+			goto done;
+
 		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
 			found = 1;
 			break;
@@ -651,9 +712,10 @@ xlog_find_tail(
 	 */
 	if (!found) {
 		for (i = log->l_logBBsize - 1; i >= (int)(*head_blk); i--) {
-			if ((error = xlog_bread(log, i, 1, bp)))
-				goto bread_err;
-			offset = xlog_align(log, i, 1, bp);
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
+				goto done;
+
 			if (XLOG_HEADER_MAGIC_NUM ==
 			    be32_to_cpu(*(__be32 *)offset)) {
 				found = 2;
@@ -686,12 +748,12 @@ xlog_find_tail(
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (found == 2)
 		log->l_curr_cycle++;
-	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
-	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
-	log->l_grant_reserve_cycle = log->l_curr_cycle;
-	log->l_grant_reserve_bytes = BBTOB(log->l_curr_block);
-	log->l_grant_write_cycle = log->l_curr_cycle;
-	log->l_grant_write_bytes = BBTOB(log->l_curr_block);
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+	xlog_assign_grant_head(&log->l_grant_reserve_head, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
+	xlog_assign_grant_head(&log->l_grant_write_head, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
 
 	/*
 	 * Look for unmount record.  If we find it, then we know there
@@ -721,14 +783,14 @@ xlog_find_tail(
 	}
 	after_umount_blk = (i + hblks + (int)
 		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
-	tail_lsn = log->l_tail_lsn;
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
-		if ((error = xlog_bread(log, umount_data_blk, 1, bp))) {
-			goto bread_err;
-		}
-		offset = xlog_align(log, umount_data_blk, 1, bp);
+		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
+		if (error)
+			goto done;
+
 		op_head = (xlog_op_header_t *)offset;
 		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
 			/*
@@ -736,12 +798,10 @@ xlog_find_tail(
 			 * log records will point recovery to after the
 			 * current unmount record.
 			 */
-			log->l_tail_lsn =
-				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
-			log->l_last_sync_lsn =
-				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
+			xlog_assign_atomic_lsn(&log->l_tail_lsn,
+					log->l_curr_cycle, after_umount_blk);
+			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
+					log->l_curr_cycle, after_umount_blk);
 			*tail_blk = after_umount_blk;
 
 			/*
@@ -773,12 +833,10 @@ xlog_find_tail(
 	 * But... if the -device- itself is readonly, just skip this.
 	 * We can't recover this device anyway, so it won't matter.
 	 */
-	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp))
 		error = xlog_clear_stale_blocks(log, tail_lsn);
-	}
 
-bread_err:
-exit:
+done:
 	xlog_put_bp(bp);
 
 	if (error)
@@ -820,9 +878,10 @@ xlog_find_zeroed(
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return ENOMEM;
-	if ((error = xlog_bread(log, 0, 1, bp)))
+	error = xlog_bread(log, 0, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, 0, 1, bp);
+
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
@@ -831,9 +890,10 @@ xlog_find_zeroed(
 	}
 
 	/* check partially zeroed log */
-	if ((error = xlog_bread(log, log_bbnum-1, 1, bp)))
+	error = xlog_bread(log, log_bbnum-1, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, log_bbnum-1, 1, bp);
+
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
 		xlog_put_bp(bp);
@@ -899,40 +959,50 @@ bp_err:
 
 STATIC xlog_recover_t *
 xlog_recover_find_tid(
-	xlog_recover_t		*q,
+	struct hlist_head	*head,
 	xlog_tid_t		tid)
 {
-	xlog_recover_t		*p = q;
+	xlog_recover_t		*trans;
+	struct hlist_node	*n;
 
-	while (p != NULL) {
-		if (p->r_log_tid == tid)
-		    break;
-		p = p->r_next;
+	hlist_for_each_entry(trans, n, head, r_list) {
+		if (trans->r_log_tid == tid)
+			return trans;
 	}
-	return p;
+	return NULL;
 }
 
 STATIC void
-xlog_recover_put_hashq(
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans)
+xlog_recover_new_tid(
+	struct hlist_head	*head,
+	xlog_tid_t		tid,
+	xfs_lsn_t		lsn)
 {
-	trans->r_next = *q;
-	*q = trans;
+	xlog_recover_t		*trans;
+
+	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
+	trans->r_log_tid   = tid;
+	trans->r_lsn	   = lsn;
+	INIT_LIST_HEAD(&trans->r_itemq);
+
+	INIT_HLIST_NODE(&trans->r_list);
+	hlist_add_head(&trans->r_list, head);
 }
 
 STATIC void
 xlog_recover_add_item(
-	xlog_recover_item_t	**itemq)
+	struct list_head	*head)
 {
 	xlog_recover_item_t	*item;
 
 	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
-	xlog_recover_insert_item_backq(itemq, item);
+	INIT_LIST_HEAD(&item->ri_list);
+	list_add_tail(&item->ri_list, head);
 }
 
 STATIC int
 xlog_recover_add_to_cont_trans(
+	struct log		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -941,8 +1011,7 @@ xlog_recover_add_to_cont_trans(
 	xfs_caddr_t		ptr, old_ptr;
 	int			old_len;
 
-	item = trans->r_itemq;
-	if (item == NULL) {
+	if (list_empty(&trans->r_itemq)) {
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (xfs_caddr_t) &trans->r_theader +
@@ -950,7 +1019,8 @@ xlog_recover_add_to_cont_trans(
 		memcpy(ptr, dp, len); /* d, s, l */
 		return 0;
 	}
-	item = item->ri_prev;
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
 
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
@@ -959,6 +1029,7 @@ xlog_recover_add_to_cont_trans(
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
+	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
 	return 0;
 }
 
@@ -977,6 +1048,7 @@ xlog_recover_add_to_cont_trans(
  */
 STATIC int
 xlog_recover_add_to_trans(
+	struct log		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -987,9 +1059,14 @@ xlog_recover_add_to_trans(
 
 	if (!len)
 		return 0;
-	item = trans->r_itemq;
-	if (item == NULL) {
-		ASSERT(*(uint *)dp == XFS_TRANS_HEADER_MAGIC);
+	if (list_empty(&trans->r_itemq)) {
+		/* we need to catch log corruptions here */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xlog_warn("XFS: xlog_recover_add_to_trans: "
+				  "bad header magic number");
+			ASSERT(0);
+			return XFS_ERROR(EIO);
+		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len); /* d, s, l */
@@ -1000,88 +1077,40 @@ xlog_recover_add_to_trans(
 	memcpy(ptr, dp, len);
 	in_f = (xfs_inode_log_format_t *)ptr;
 
-	if (item->ri_prev->ri_total != 0 &&
-	     item->ri_prev->ri_total == item->ri_prev->ri_cnt) {
+	/* take the tail entry */
+	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
+	if (item->ri_total != 0 &&
+	     item->ri_total == item->ri_cnt) {
+		/* tail item is in use, get a new one */
 		xlog_recover_add_item(&trans->r_itemq);
+		item = list_entry(trans->r_itemq.prev,
+					xlog_recover_item_t, ri_list);
 	}
-	item = trans->r_itemq;
-	item = item->ri_prev;
 
 	if (item->ri_total == 0) {		/* first region to be added */
-		item->ri_total	= in_f->ilf_size;
-		ASSERT(item->ri_total <= XLOG_MAX_REGIONS_IN_ITEM);
-		item->ri_buf = kmem_zalloc((item->ri_total *
-					    sizeof(xfs_log_iovec_t)), KM_SLEEP);
+		if (in_f->ilf_size == 0 ||
+		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
+			xlog_warn(
+	"XFS: bad number of regions (%d) in inode log format",
+				  in_f->ilf_size);
+			ASSERT(0);
+			return XFS_ERROR(EIO);
+		}
+
+		item->ri_total = in_f->ilf_size;
+		item->ri_buf =
+			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+				    KM_SLEEP);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;
 	item->ri_cnt++;
+	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
 }
 
-STATIC void
-xlog_recover_new_tid(
-	xlog_recover_t		**q,
-	xlog_tid_t		tid,
-	xfs_lsn_t		lsn)
-{
-	xlog_recover_t		*trans;
-
-	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
-	trans->r_log_tid   = tid;
-	trans->r_lsn	   = lsn;
-	xlog_recover_put_hashq(q, trans);
-}
-
-STATIC int
-xlog_recover_unlink_tid(
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans)
-{
-	xlog_recover_t		*tp;
-	int			found = 0;
-
-	ASSERT(trans != NULL);
-	if (trans == *q) {
-		*q = (*q)->r_next;
-	} else {
-		tp = *q;
-		while (tp) {
-			if (tp->r_next == trans) {
-				found = 1;
-				break;
-			}
-			tp = tp->r_next;
-		}
-		if (!found) {
-			xlog_warn(
-			     "XFS: xlog_recover_unlink_tid: trans not found");
-			ASSERT(0);
-			return XFS_ERROR(EIO);
-		}
-		tp->r_next = tp->r_next->r_next;
-	}
-	return 0;
-}
-
-STATIC void
-xlog_recover_insert_item_backq(
-	xlog_recover_item_t	**q,
-	xlog_recover_item_t	*item)
-{
-	if (*q == NULL) {
-		item->ri_prev = item->ri_next = item;
-		*q = item;
-	} else {
-		item->ri_next		= *q;
-		item->ri_prev		= (*q)->ri_prev;
-		(*q)->ri_prev		= item;
-		item->ri_prev->ri_next	= item;
-	}
-}
-
 /*
  * Free up any resources allocated by the transaction
  *
@@ -1089,41 +1118,43 @@ xlog_recover_insert_item_backq(
  */
 STATIC void
 xlog_recover_free_trans(
-	xlog_recover_t		*trans)
+	struct xlog_recover	*trans)
 {
-	xlog_recover_item_t	*first_item, *item, *free_item;
+	xlog_recover_item_t	*item, *n;
 	int			i;
 
-	item = first_item = trans->r_itemq;
-	do {
-		free_item = item;
-		item = item->ri_next;
-		 /* Free the regions in the item. */
-		for (i = 0; i < free_item->ri_cnt; i++) {
-			kmem_free(free_item->ri_buf[i].i_addr);
-		}
+	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
+		/* Free the regions in the item. */
+		list_del(&item->ri_list);
+		for (i = 0; i < item->ri_cnt; i++)
+			kmem_free(item->ri_buf[i].i_addr);
 		/* Free the item itself */
-		kmem_free(free_item->ri_buf);
-		kmem_free(free_item);
-	} while (first_item != item);
+		kmem_free(item->ri_buf);
+		kmem_free(item);
+	}
 	/* Free the transaction recover structure */
 	kmem_free(trans);
 }
 
+/*
+ * Perform the transaction.
+ *
+ * If the transaction modifies a buffer or inode, do it now.  Otherwise,
+ * EFIs and EFDs get queued up by adding entries into the AIL for them.
+ */
 STATIC int
 xlog_recover_commit_trans(
-	xlog_t			*log,
-	xlog_recover_t		**q,
-	xlog_recover_t		*trans,
+	struct log		*log,
+	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error;
+	int			error = 0;
 
-	if ((error = xlog_recover_unlink_tid(q, trans)))
-		return error;
+	hlist_del(&trans->r_list);
 	if ((error = xlog_recover_do_trans(log, trans, pass)))
 		return error;
-	xlog_recover_free_trans(trans);			/* no error */
+
+	xlog_recover_free_trans(trans);
 	return 0;
 }
 
@@ -1148,7 +1179,7 @@ xlog_recover_unmount_trans(
 STATIC int
 xlog_recover_process_data(
 	xlog_t			*log,
-	xlog_recover_t		*rhash[],
+	struct hlist_head	rhash[],
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
 	int			pass)
@@ -1182,27 +1213,32 @@ xlog_recover_process_data(
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
-		trans = xlog_recover_find_tid(rhash[hash], tid);
+		trans = xlog_recover_find_tid(&rhash[hash], tid);
 		if (trans == NULL) {		   /* not found; add new tid */
 			if (ohead->oh_flags & XLOG_START_TRANS)
 				xlog_recover_new_tid(&rhash[hash], tid,
 					be64_to_cpu(rhead->h_lsn));
 		} else {
-			ASSERT(dp + be32_to_cpu(ohead->oh_len) <= lp);
+			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
+				xlog_warn(
+			"XFS: xlog_recover_process_data: bad length");
+				return (XFS_ERROR(EIO));
+			}
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
 				flags &= ~XLOG_CONTINUE_TRANS;
 			switch (flags) {
 			case XLOG_COMMIT_TRANS:
 				error = xlog_recover_commit_trans(log,
-						&rhash[hash], trans, pass);
+								trans, pass);
 				break;
 			case XLOG_UNMOUNT_TRANS:
 				error = xlog_recover_unmount_trans(trans);
 				break;
 			case XLOG_WAS_CONT_TRANS:
-				error = xlog_recover_add_to_cont_trans(trans,
-						dp, be32_to_cpu(ohead->oh_len));
+				error = xlog_recover_add_to_cont_trans(log,
+						trans, dp,
+						be32_to_cpu(ohead->oh_len));
 				break;
 			case XLOG_START_TRANS:
 				xlog_warn(
@@ -1212,7 +1248,7 @@ xlog_recover_process_data(
 				break;
 			case 0:
 			case XLOG_CONTINUE_TRANS:
-				error = xlog_recover_add_to_trans(trans,
+				error = xlog_recover_add_to_trans(log, trans,
 						dp, be32_to_cpu(ohead->oh_len));
 				break;
 			default:
@@ -1238,7 +1274,6 @@ xlog_unpack_data(
 	xlog_t			*log)
 {
 	int			i, j, k;
-	xlog_in_core_2_t	*xhdr;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -1247,7 +1282,7 @@ xlog_unpack_data(
 	}
 
 	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		xhdr = (xlog_in_core_2_t *)rhead;
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -1255,8 +1290,6 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
-
-	xlog_unpack_data_checksum(rhead, dp, log);
 }
 
 STATIC int
@@ -1312,12 +1345,12 @@ xlog_do_recovery_pass(
 {
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
-	xfs_caddr_t		bufaddr, offset;
+	xfs_caddr_t		offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
-	xlog_recover_t		*rhash[XLOG_RHASH_SIZE];
+	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 
 	ASSERT(head_blk != tail_blk);
 
@@ -1334,9 +1367,11 @@ xlog_do_recovery_pass(
 		hbp = xlog_get_bp(log, 1);
 		if (!hbp)
 			return ENOMEM;
-		if ((error = xlog_bread(log, tail_blk, 1, hbp)))
+
+		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
+		if (error)
 			goto bread_err1;
-		offset = xlog_align(log, tail_blk, 1, hbp);
+
 		rhead = (xlog_rec_header_t *)offset;
 		error = xlog_valid_rec_header(log, rhead, tail_blk);
 		if (error)
@@ -1353,7 +1388,7 @@ xlog_do_recovery_pass(
 			hblks = 1;
 		}
 	} else {
-		ASSERT(log->l_sectbb_log == 0);
+		ASSERT(log->l_sectBBsize == 1);
 		hblks = 1;
 		hbp = xlog_get_bp(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
@@ -1370,9 +1405,10 @@ xlog_do_recovery_pass(
 	memset(rhash, 0, sizeof(rhash));
 	if (tail_blk <= head_blk) {
 		for (blk_no = tail_blk; blk_no < head_blk; ) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no, hblks, hbp);
+
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
@@ -1380,10 +1416,11 @@ xlog_do_recovery_pass(
 
 			/* blocks in data section */
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			error = xlog_bread(log, blk_no + hblks, bblks, dbp);
+			error = xlog_bread(log, blk_no + hblks, bblks, dbp,
+					   &offset);
 			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no + hblks, bblks, dbp);
+
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log,
 						rhash, rhead, offset, pass)))
@@ -1401,15 +1438,15 @@ xlog_do_recovery_pass(
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = NULL;
+			offset = XFS_BUF_PTR(hbp);
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
 				/* Read header in one read */
-				error = xlog_bread(log, blk_no, hblks, hbp);
+				error = xlog_bread(log, blk_no, hblks, hbp,
+						   &offset);
 				if (error)
 					goto bread_err2;
-				offset = xlog_align(log, blk_no, hblks, hbp);
 			} else {
 				/* This LR is split across physical log end */
 				if (blk_no != log->l_logBBsize) {
@@ -1417,12 +1454,13 @@ xlog_do_recovery_pass(
 					ASSERT(blk_no <= INT_MAX);
 					split_hblks = log->l_logBBsize - (int)blk_no;
 					ASSERT(split_hblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_hblks, hbp)))
+					error = xlog_bread(log, blk_no,
+							   split_hblks, hbp,
+							   &offset);
+					if (error)
 						goto bread_err2;
-					offset = xlog_align(log, blk_no,
-							split_hblks, hbp);
 				}
+
 				/*
 				 * Note: this black magic still works with
 				 * large sector sizes (non-512) only because:
@@ -1436,17 +1474,21 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				wrapped_hblks = hblks - split_hblks;
-				bufaddr = XFS_BUF_PTR(hbp);
-				XFS_BUF_SET_PTR(hbp,
-						bufaddr + BBTOB(split_hblks),
+				error = XFS_BUF_SET_PTR(hbp,
+						offset + BBTOB(split_hblks),
 						BBTOB(hblks - split_hblks));
-				error = xlog_bread(log, 0, wrapped_hblks, hbp);
 				if (error)
 					goto bread_err2;
-				XFS_BUF_SET_PTR(hbp, bufaddr, BBTOB(hblks));
-				if (!offset)
-					offset = xlog_align(log, 0,
-							wrapped_hblks, hbp);
+
+				error = xlog_bread_noalign(log, 0,
+							   wrapped_hblks, hbp);
+				if (error)
+					goto bread_err2;
+
+				error = XFS_BUF_SET_PTR(hbp, offset,
+							BBTOB(hblks));
+				if (error)
+					goto bread_err2;
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
@@ -1459,14 +1501,14 @@ xlog_do_recovery_pass(
 
 			/* Read in data for log record */
 			if (blk_no + bblks <= log->l_logBBsize) {
-				error = xlog_bread(log, blk_no, bblks, dbp);
+				error = xlog_bread(log, blk_no, bblks, dbp,
+						   &offset);
 				if (error)
 					goto bread_err2;
-				offset = xlog_align(log, blk_no, bblks, dbp);
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = NULL;
+				offset = XFS_BUF_PTR(dbp);
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
@@ -1476,12 +1518,13 @@ xlog_do_recovery_pass(
 					split_bblks =
 						log->l_logBBsize - (int)blk_no;
 					ASSERT(split_bblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_bblks, dbp)))
+					error = xlog_bread(log, blk_no,
+							split_bblks, dbp,
+							&offset);
+					if (error)
 						goto bread_err2;
-					offset = xlog_align(log, blk_no,
-							split_bblks, dbp);
 				}
+
 				/*
 				 * Note: this black magic still works with
 				 * large sector sizes (non-512) only because:
@@ -1494,18 +1537,21 @@ xlog_do_recovery_pass(
 				 *   _first_, then the log start (LR header end)
 				 *   - order is important.
 				 */
-				bufaddr = XFS_BUF_PTR(dbp);
-				XFS_BUF_SET_PTR(dbp,
-						bufaddr + BBTOB(split_bblks),
+				error = XFS_BUF_SET_PTR(dbp,
+						offset + BBTOB(split_bblks),
 						BBTOB(bblks - split_bblks));
-				error = xlog_bread(log, wrapped_hblks,
-						bblks - split_bblks, dbp);
 				if (error)
 					goto bread_err2;
-				XFS_BUF_SET_PTR(dbp, bufaddr, h_size);
-				if (!offset)
-					offset = xlog_align(log, wrapped_hblks,
-						bblks - split_bblks, dbp);
+
+				error = xlog_bread_noalign(log, wrapped_hblks,
+						bblks - split_bblks,
+						dbp);
+				if (error)
+					goto bread_err2;
+
+				error = XFS_BUF_SET_PTR(dbp, offset, h_size);
+				if (error)
+					goto bread_err2;
 			}
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log, rhash,
@@ -1519,17 +1565,21 @@ xlog_do_recovery_pass(
 
 		/* read first part of physical log */
 		while (blk_no < head_blk) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no, hblks, hbp);
+
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
+
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			if ((error = xlog_bread(log, blk_no+hblks, bblks, dbp)))
+			error = xlog_bread(log, blk_no+hblks, bblks, dbp,
+					   &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no+hblks, bblks, dbp);
+
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log, rhash,
 							rhead, offset, pass)))
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 7bd4617..62727bf 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -36,10 +36,10 @@ xlog_print_find_oldest(
 
 	first_blk = 0;		/* read first block */
 	bp = xlog_get_bp(log, 1);
-	xlog_bread(log, 0, 1, bp);
+	xlog_bread_noalign(log, 0, 1, bp);
 	first_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
 	*last_blk = log->l_logBBsize-1;	/* read last block */
-	xlog_bread(log, *last_blk, 1, bp);
+	xlog_bread_noalign(log, *last_blk, 1, bp);
 	last_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
 	ASSERT(last_half_cycle != 0);
 
@@ -486,19 +486,16 @@ xlog_recover_print_item(
 void
 xlog_recover_print_trans(
 	xlog_recover_t		*trans,
-	xlog_recover_item_t	*itemq,
+	struct list_head	*itemq,
 	int			print)
 {
-	xlog_recover_item_t	*first_item, *item;
+	xlog_recover_item_t	*item;
 
 	if (print < 3)
 		return;
 
 	print_xlog_record_line();
 	xlog_recover_print_trans_head(trans);
-	item = first_item = itemq;
-	do {
+	list_for_each_entry(item, itemq, ri_list)
 		xlog_recover_print_item(item);
-		item = item->ri_next;
-	} while (first_item != item);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 8b21257..7405772 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -25,7 +25,7 @@ xlog_recover_print_trans_head(
 	printf(_("TRANS: tid:0x%x  type:%s  #items:%d  trans:0x%x  q:0x%lx\n"),
 	       tr->r_log_tid, trans_type[tr->r_theader.th_type],
 	       tr->r_theader.th_num_items,
-	       tr->r_theader.th_tid, (long)tr->r_itemq);
+	       tr->r_theader.th_tid, (long)&tr->r_itemq);
 }
 
 int
@@ -34,7 +34,7 @@ xlog_recover_do_trans(
 	xlog_recover_t	*trans,
 	int		pass)
 {
-	xlog_recover_print_trans(trans, trans->r_itemq, 3);
+	xlog_recover_print_trans(trans, &trans->r_itemq, 3);
 	return 0;
 }
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
