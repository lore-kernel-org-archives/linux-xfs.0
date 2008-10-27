Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:39:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDd8pC022801
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:08 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69BD254BAE3
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id pRDwE1yaOcM8XBun for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:39:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSJH-0000IY-MN
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:39:07 +0000
Date: Mon, 27 Oct 2008 09:39:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] sanitize xlog_in_core_t definition
Message-ID: <20081027133907.GD1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-xlog_iclog_fields_t
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Move all fields from xlog_iclog_fields_t into xlog_in_core_t instead of having
them in a substructure and the using #defines to make it look like they were
directly in xlog_in_core_t.  Also document that xlog_in_core_2_t is grossly
misnamed, and make all references to it typesafe.

(First sent on Semptember 15th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-09-25 13:58:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-09-25 20:02:34.000000000 +0200
@@ -1024,12 +1024,6 @@ xlog_iodone(xfs_buf_t *bp)
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long) 2);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 	aborted = 0;
-
-	/*
-	 * Some versions of cpp barf on the recursive definition of
-	 * ic_log -> hic_fields.ic_log and expand ic_log twice when
-	 * it is passed through two macros.  Workaround broken cpp.
-	 */
 	l = iclog->ic_log;
 
 	/*
@@ -1287,7 +1281,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
 		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 		iclog->ic_bp = bp;
-		iclog->hic_data = bp->b_addr;
+		iclog->ic_data = bp->b_addr;
 #ifdef DEBUG
 		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
 #endif
@@ -1307,7 +1301,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		atomic_set(&iclog->ic_refcnt, 0);
 		spin_lock_init(&iclog->ic_callback_lock);
 		iclog->ic_callback_tail = &(iclog->ic_callback);
-		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
+		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
@@ -3418,7 +3412,7 @@ xlog_verify_iclog(xlog_t	 *log,
 	ptr = iclog->ic_datap;
 	base_ptr = ptr;
 	ophead = (xlog_op_header_t *)ptr;
-	xhdr = (xlog_in_core_2_t *)&iclog->ic_header;
+	xhdr = iclog->ic_data;
 	for (i = 0; i < len; i++) {
 		ophead = (xlog_op_header_t *)ptr;
 
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2008-09-25 13:58:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2008-09-25 20:02:35.000000000 +0200
@@ -309,6 +309,16 @@ typedef struct xlog_rec_ext_header {
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
@@ -338,7 +348,7 @@ typedef struct xlog_rec_ext_header {
  * We'll put all the read-only and l_icloglock fields in the first cacheline,
  * and move everything else out to subsequent cachelines.
  */
-typedef struct xlog_iclog_fields {
+typedef struct xlog_in_core {
 	sv_t			ic_force_wait;
 	sv_t			ic_write_wait;
 	struct xlog_in_core	*ic_next;
@@ -361,41 +371,11 @@ typedef struct xlog_iclog_fields {
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-} xlog_iclog_fields_t;
-
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
-
-typedef struct xlog_in_core {
-	xlog_iclog_fields_t	hic_fields;
-	xlog_in_core_2_t	*hic_data;
+	xlog_in_core_2_t	*ic_data;
+#define ic_header	ic_data->hic_header
 } xlog_in_core_t;
 
 /*
- * Defines to save our code from this glop.
- */
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
-
-/*
  * The reservation head lsn is not made up of a cycle number and block number.
  * Instead, it uses a cycle number and byte number.  Logs don't expect to
  * overflow 31 bits worth of byte offset, so using a byte number will mean
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-25 13:58:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-25 20:02:39.000000000 +0200
@@ -3359,7 +3359,6 @@ xlog_pack_data(
 	int			size = iclog->ic_offset + roundoff;
 	__be32			cycle_lsn;
 	xfs_caddr_t		dp;
-	xlog_in_core_2_t	*xhdr;
 
 	xlog_pack_data_checksum(log, iclog, size);
 
@@ -3374,7 +3373,8 @@ xlog_pack_data(
 	}
 
 	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		xhdr = (xlog_in_core_2_t *)&iclog->ic_header;
+		xlog_in_core_2_t *xhdr = iclog->ic_data;
+
 		for ( ; i < BTOBB(size); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -3432,7 +3432,6 @@ xlog_unpack_data(
 	xlog_t			*log)
 {
 	int			i, j, k;
-	xlog_in_core_2_t	*xhdr;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -3441,7 +3440,7 @@ xlog_unpack_data(
 	}
 
 	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		xhdr = (xlog_in_core_2_t *)rhead;
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-25 13:58:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-25 20:02:39.000000000 +0200
@@ -5763,7 +5763,7 @@ xfsidbg_xiclog(xlog_in_core_t *iclog)
 	};
 
 	kdb_printf("xlog_in_core/header at 0x%p/0x%p\n",
-		iclog, iclog->hic_data);
+		iclog, iclog->ic_data);
 	kdb_printf("magicno: %x  cycle: %d  version: %d  lsn: 0x%Lx\n",
 		be32_to_cpu(iclog->ic_header.h_magicno),
 		be32_to_cpu(iclog->ic_header.h_cycle),

-- 
