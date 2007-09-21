Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Sep 2007 02:23:55 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8L9Nkgf022997
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 02:23:50 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8L9NkA5009955
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 11:23:47 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8L9NkOR009953
	for xfs@oss.sgi.com; Fri, 21 Sep 2007 11:23:46 +0200
Date: Fri, 21 Sep 2007 11:23:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xlog_rec_header/xlog_rec_ext_header endianess annotations
Message-ID: <20070921092346.GA9917@lst.de>
References: <20070920143335.GD13755@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920143335.GD13755@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Sep 20, 2007 at 04:33:35PM +0200, Christoph Hellwig wrote:
> Mostly trivial conversion with one exceptions:  h_num_logops was kept
> in native endian previously and only converted to big endian in
> xlog_sync, but we always keep it big endian now.  With todays cpus
> fast byteswap instructions that's not an issue but the new variant
> keeps the code clean and maintainable.

Here's an updated patch to apply ontop of Eric's spinlock changes.

Btw, did this series get through to anyone?  I didn't recieve it back
from the list and the archives don't seem to have it either..


Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2007-09-21 10:51:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2007-09-21 10:53:41.000000000 +0200
@@ -1227,12 +1227,12 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 		head = &iclog->ic_header;
 		memset(head, 0, sizeof(xlog_rec_header_t));
-		INT_SET(head->h_magicno, ARCH_CONVERT, XLOG_HEADER_MAGIC_NUM);
-		INT_SET(head->h_version, ARCH_CONVERT,
+		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+		head->h_version = cpu_to_be32(
 			XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? 2 : 1);
-		INT_SET(head->h_size, ARCH_CONVERT, log->l_iclog_size);
+		head->h_size = cpu_to_be32(log->l_iclog_size);
 		/* new fields */
-		INT_SET(head->h_fmt, ARCH_CONVERT, XLOG_FMT);
+		head->h_fmt = cpu_to_be32(XLOG_FMT);
 		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
 
 
@@ -1378,7 +1378,7 @@ xlog_sync(xlog_t		*log,
 {
 	xfs_caddr_t	dptr;		/* pointer to byte sized element */
 	xfs_buf_t	*bp;
-	int		i, ops;
+	int		i;
 	uint		count;		/* byte count of bwrite */
 	uint		count_init;	/* initial count before roundup */
 	int		roundoff;       /* roundoff to BB or stripe */
@@ -1417,21 +1417,17 @@ xlog_sync(xlog_t		*log,
 
 	/* real byte length */
 	if (v2) {
-		INT_SET(iclog->ic_header.h_len, 
-			ARCH_CONVERT,
-			iclog->ic_offset + roundoff);
+		iclog->ic_header.h_len =
+			cpu_to_be32(iclog->ic_offset + roundoff);
 	} else {
-		INT_SET(iclog->ic_header.h_len, ARCH_CONVERT, iclog->ic_offset);
+		iclog->ic_header.h_len =
+			cpu_to_be32(iclog->ic_offset);
 	}
 
-	/* put ops count in correct order */
-	ops = iclog->ic_header.h_num_logops;
-	INT_SET(iclog->ic_header.h_num_logops, ARCH_CONVERT, ops);
-
 	bp = iclog->ic_bp;
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long)1);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
-	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT)));
+	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
 
 	XFS_STATS_ADD(xs_log_blocks, BTOBB(count));
 
@@ -1494,10 +1490,10 @@ xlog_sync(xlog_t		*log,
 		 * a new cycle.  Watch out for the header magic number
 		 * case, though.
 		 */
-		for (i=0; i<split; i += BBSIZE) {
-			INT_MOD(*(uint *)dptr, ARCH_CONVERT, +1);
-			if (INT_GET(*(uint *)dptr, ARCH_CONVERT) == XLOG_HEADER_MAGIC_NUM)
-				INT_MOD(*(uint *)dptr, ARCH_CONVERT, +1);
+		for (i = 0; i < split; i += BBSIZE) {
+			be32_add((__be32 *)dptr, 1);
+			if (be32_to_cpu(*(__be32 *)dptr) == XLOG_HEADER_MAGIC_NUM)
+				be32_add((__be32 *)dptr, 1);
 			dptr += BBSIZE;
 		}
 
@@ -1586,7 +1582,7 @@ xlog_state_finish_copy(xlog_t		*log,
 {
 	spin_lock(&log->l_icloglock);
 
-	iclog->ic_header.h_num_logops += record_cnt;
+	be32_add(&iclog->ic_header.h_num_logops, record_cnt);
 	iclog->ic_offset += copy_bytes;
 
 	spin_unlock(&log->l_icloglock);
@@ -1813,7 +1809,7 @@ xlog_write(xfs_mount_t *	mp,
 
 	/* start_lsn is the first lsn written to. That's all we need. */
 	if (! *start_lsn)
-	    *start_lsn = INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT);
+	    *start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
 	/* This loop writes out as many regions as can fit in the amount
 	 * of space which was allocated by xlog_state_get_iclog_space().
@@ -1983,7 +1979,8 @@ xlog_state_clean_log(xlog_t *log)
 			 * We don't need to cover the dummy.
 			 */
 			if (!changed &&
-			   (INT_GET(iclog->ic_header.h_num_logops, ARCH_CONVERT) == XLOG_COVER_OPS)) {
+			   (be32_to_cpu(iclog->ic_header.h_num_logops) ==
+			   		XLOG_COVER_OPS)) {
 				changed = 1;
 			} else {
 				/*
@@ -2051,7 +2048,7 @@ xlog_get_lowest_lsn(
 	lowest_lsn = 0;
 	do {
 	    if (!(lsn_log->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))) {
-		lsn = INT_GET(lsn_log->ic_header.h_lsn, ARCH_CONVERT);
+		lsn = be64_to_cpu(lsn_log->ic_header.h_lsn);
 		if ((lsn && !lowest_lsn) ||
 		    (XFS_LSN_CMP(lsn, lowest_lsn) < 0)) {
 			lowest_lsn = lsn;
@@ -2152,11 +2149,9 @@ xlog_state_do_callback(
 				 */
 
 				lowest_lsn = xlog_get_lowest_lsn(log);
-				if (lowest_lsn && (
-					XFS_LSN_CMP(
-						lowest_lsn,
-						INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT)
-					)<0)) {
+				if (lowest_lsn &&
+				    XFS_LSN_CMP(lowest_lsn,
+				    		be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
 					iclog = iclog->ic_next;
 					continue; /* Leave this iclog for
 						   * another thread */
@@ -2171,11 +2166,10 @@ xlog_state_do_callback(
 				 * No one else can be here except us.
 				 */
 				spin_lock(&log->l_grant_lock);
-				ASSERT(XFS_LSN_CMP(
-						log->l_last_sync_lsn,
-						INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT)
-					)<=0);
-				log->l_last_sync_lsn = INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT);
+				ASSERT(XFS_LSN_CMP(log->l_last_sync_lsn,
+				       be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
+				log->l_last_sync_lsn =
+					be64_to_cpu(iclog->ic_header.h_lsn);
 				spin_unlock(&log->l_grant_lock);
 
 				/*
@@ -2392,8 +2386,8 @@ restart:
 		xlog_tic_add_region(ticket,
 				    log->l_iclog_hsize,
 				    XLOG_REG_TYPE_LRHEADER);
-		INT_SET(head->h_cycle, ARCH_CONVERT, log->l_curr_cycle);
-		INT_SET(head->h_lsn, ARCH_CONVERT,
+		head->h_cycle = cpu_to_be32(log->l_curr_cycle);
+		head->h_lsn = cpu_to_be64(
 			xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
 		ASSERT(log->l_curr_block >= 0);
 	}
@@ -2823,7 +2817,7 @@ xlog_state_release_iclog(xlog_t		*log,
 	    iclog->ic_state == XLOG_STATE_WANT_SYNC) {
 		sync++;
 		iclog->ic_state = XLOG_STATE_SYNCING;
-		INT_SET(iclog->ic_header.h_tail_lsn, ARCH_CONVERT, log->l_tail_lsn);
+		iclog->ic_header.h_tail_lsn = cpu_to_be64(log->l_tail_lsn);
 		xlog_verify_tail_lsn(log, iclog, log->l_tail_lsn);
 		/* cycle incremented when incrementing curr_block */
 	}
@@ -2861,7 +2855,7 @@ xlog_state_switch_iclogs(xlog_t		*log,
 	if (!eventual_size)
 		eventual_size = iclog->ic_offset;
 	iclog->ic_state = XLOG_STATE_WANT_SYNC;
-	INT_SET(iclog->ic_header.h_prev_block, ARCH_CONVERT, log->l_prev_block);
+	iclog->ic_header.h_prev_block = cpu_to_be32(log->l_prev_block);
 	log->l_prev_block = log->l_curr_block;
 	log->l_prev_cycle = log->l_curr_cycle;
 
@@ -2957,7 +2951,7 @@ xlog_state_sync_all(xlog_t *log, uint fl
 				 * the previous sync.
 				 */
 				iclog->ic_refcnt++;
-				lsn = INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT);
+				lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 				xlog_state_switch_iclogs(log, iclog, 0);
 				spin_unlock(&log->l_icloglock);
 
@@ -2965,7 +2959,7 @@ xlog_state_sync_all(xlog_t *log, uint fl
 					return XFS_ERROR(EIO);
 				*log_flushed = 1;
 				spin_lock(&log->l_icloglock);
-				if (INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT) == lsn &&
+				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn &&
 				    iclog->ic_state != XLOG_STATE_DIRTY)
 					goto maybe_sleep;
 				else
@@ -3049,9 +3043,9 @@ try_again:
     }
 
     do {
-	if (INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT) != lsn) {
-	    iclog = iclog->ic_next;
-	    continue;
+	if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
+		iclog = iclog->ic_next;
+		continue;
 	}
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY) {
@@ -3460,18 +3454,18 @@ xlog_verify_iclog(xlog_t	 *log,
 	spin_unlock(&log->l_icloglock);
 
 	/* check log magic numbers */
-	ptr = (xfs_caddr_t) &(iclog->ic_header);
-	if (INT_GET(*(uint *)ptr, ARCH_CONVERT) != XLOG_HEADER_MAGIC_NUM)
+	if (be32_to_cpu(iclog->ic_header.h_magicno) != XLOG_HEADER_MAGIC_NUM)
 		xlog_panic("xlog_verify_iclog: invalid magic num");
 
-	for (ptr += BBSIZE; ptr < ((xfs_caddr_t)&(iclog->ic_header))+count;
+	ptr = (xfs_caddr_t) &iclog->ic_header;
+	for (ptr += BBSIZE; ptr < ((xfs_caddr_t)&iclog->ic_header) + count;
 	     ptr += BBSIZE) {
-		if (INT_GET(*(uint *)ptr, ARCH_CONVERT) == XLOG_HEADER_MAGIC_NUM)
+		if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
 			xlog_panic("xlog_verify_iclog: unexpected magic num");
 	}
 
 	/* check fields */
-	len = INT_GET(iclog->ic_header.h_num_logops, ARCH_CONVERT);
+	len = be32_to_cpu(iclog->ic_header.h_num_logops);
 	ptr = iclog->ic_datap;
 	base_ptr = ptr;
 	ophead = (xlog_op_header_t *)ptr;
@@ -3512,9 +3506,9 @@ xlog_verify_iclog(xlog_t	 *log,
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-				op_len = INT_GET(xhdr[j].hic_xheader.xh_cycle_data[k], ARCH_CONVERT);
+				op_len = be32_to_cpu(xhdr[j].hic_xheader.xh_cycle_data[k]);
 			} else {
-				op_len = INT_GET(iclog->ic_header.h_cycle_data[idx], ARCH_CONVERT);
+				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
 			}
 		}
 		ptr += sizeof(xlog_op_header_t) + op_len;
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2007-09-21 10:51:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2007-09-21 10:51:04.000000000 +0200
@@ -63,10 +63,10 @@ static inline xfs_lsn_t xlog_assign_lsn(
 
 static inline uint xlog_get_cycle(char *ptr)
 {
-	if (INT_GET(*(uint *)ptr, ARCH_CONVERT) == XLOG_HEADER_MAGIC_NUM)
-		return INT_GET(*((uint *)ptr + 1), ARCH_CONVERT);
+	if (be32_to_cpu(*(__be32 *)ptr) == XLOG_HEADER_MAGIC_NUM)
+		return be32_to_cpu(*((__be32 *)ptr + 1));
 	else
-		return INT_GET(*(uint *)ptr, ARCH_CONVERT);
+		return be32_to_cpu(*(__be32 *)ptr);
 }
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
@@ -85,9 +85,9 @@ static inline uint xlog_get_cycle(char *
  *
  * this has endian issues, of course.
  */
-static inline uint xlog_get_client_id(uint i)
+static inline uint xlog_get_client_id(__be32 i)
 {
-	return INT_GET(i, ARCH_CONVERT) >> 24;
+	return be32_to_cpu(i) >> 24;
 }
 
 #define xlog_panic(args...)	cmn_err(CE_PANIC, ## args)
@@ -287,25 +287,25 @@ typedef struct xlog_op_header {
 #endif
 
 typedef struct xlog_rec_header {
-	uint	  h_magicno;	/* log record (LR) identifier		:  4 */
-	uint	  h_cycle;	/* write cycle of log			:  4 */
-	int	  h_version;	/* LR version				:  4 */
-	int	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
-	xfs_lsn_t h_lsn;	/* lsn of this LR			:  8 */
-	xfs_lsn_t h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
-	uint	  h_chksum;	/* may not be used; non-zero if used	:  4 */
-	int	  h_prev_block; /* block number to previous LR		:  4 */
-	int	  h_num_logops;	/* number of log operations in this LR	:  4 */
-	uint	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
+	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
+	__be32	  h_cycle;	/* write cycle of log			:  4 */
+	__be32	  h_version;	/* LR version				:  4 */
+	__be32	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
+	__be64	  h_lsn;	/* lsn of this LR			:  8 */
+	__be64	  h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
+	__be32	  h_chksum;	/* may not be used; non-zero if used	:  4 */
+	__be32	  h_prev_block; /* block number to previous LR		:  4 */
+	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
+	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
 	/* new fields */
-	int       h_fmt;        /* format of log record                 :  4 */
-	uuid_t    h_fs_uuid;    /* uuid of FS                           : 16 */
-	int       h_size;	/* iclog size				:  4 */
+	__be32    h_fmt;        /* format of log record                 :  4 */
+	uuid_t	  h_fs_uuid;    /* uuid of FS                           : 16 */
+	__be32	  h_size;	/* iclog size				:  4 */
 } xlog_rec_header_t;
 
 typedef struct xlog_rec_ext_header {
-	uint	  xh_cycle;	/* write cycle of log			: 4 */
-	uint	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
+	__be32	  xh_cycle;	/* write cycle of log			: 4 */
+	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
 } xlog_rec_ext_header_t;
 
 #ifdef __KERNEL__
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-09-21 10:51:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-09-21 10:51:04.000000000 +0200
@@ -198,7 +198,7 @@ xlog_header_check_dump(
 	cmn_err(CE_DEBUG, "    log : uuid = ");
 	for (b = 0; b < 16; b++)
 		cmn_err(CE_DEBUG, "%02x",((uchar_t *)&head->h_fs_uuid)[b]);
-	cmn_err(CE_DEBUG, ", fmt = %d\n", INT_GET(head->h_fmt, ARCH_CONVERT));
+	cmn_err(CE_DEBUG, ", fmt = %d\n", be32_to_cpu(head->h_fmt));
 }
 #else
 #define xlog_header_check_dump(mp, head)
@@ -212,14 +212,14 @@ xlog_header_check_recover(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	ASSERT(INT_GET(head->h_magicno, ARCH_CONVERT) == XLOG_HEADER_MAGIC_NUM);
+	ASSERT(be32_to_cpu(head->h_magicno) == XLOG_HEADER_MAGIC_NUM);
 
 	/*
 	 * IRIX doesn't write the h_fmt field and leaves it zeroed
 	 * (XLOG_FMT_UNKNOWN). This stops us from trying to recover
 	 * a dirty log created in IRIX.
 	 */
-	if (unlikely(INT_GET(head->h_fmt, ARCH_CONVERT) != XLOG_FMT)) {
+	if (unlikely(be32_to_cpu(head->h_fmt) != XLOG_FMT)) {
 		xlog_warn(
 	"XFS: dirty log written in incompatible format - can't recover");
 		xlog_header_check_dump(mp, head);
@@ -245,7 +245,7 @@ xlog_header_check_mount(
 	xfs_mount_t		*mp,
 	xlog_rec_header_t	*head)
 {
-	ASSERT(INT_GET(head->h_magicno, ARCH_CONVERT) == XLOG_HEADER_MAGIC_NUM);
+	ASSERT(be32_to_cpu(head->h_magicno) == XLOG_HEADER_MAGIC_NUM);
 
 	if (uuid_is_nil(&head->h_fs_uuid)) {
 		/*
@@ -447,8 +447,7 @@ xlog_find_verify_log_record(
 
 		head = (xlog_rec_header_t *)offset;
 
-		if (XLOG_HEADER_MAGIC_NUM ==
-		    INT_GET(head->h_magicno, ARCH_CONVERT))
+		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(head->h_magicno))
 			break;
 
 		if (!smallmem)
@@ -480,7 +479,7 @@ xlog_find_verify_log_record(
 	 * record do we update last_blk.
 	 */
 	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
-		uint	h_size = INT_GET(head->h_size, ARCH_CONVERT);
+		uint	h_size = be32_to_cpu(head->h_size);
 
 		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
 		if (h_size % XLOG_HEADER_CYCLE_SIZE)
@@ -489,8 +488,8 @@ xlog_find_verify_log_record(
 		xhdrs = 1;
 	}
 
-	if (*last_blk - i + extra_bblks
-			!= BTOBB(INT_GET(head->h_len, ARCH_CONVERT)) + xhdrs)
+	if (*last_blk - i + extra_bblks !=
+	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
 		*last_blk = i;
 
 out:
@@ -823,8 +822,7 @@ xlog_find_tail(
 		if ((error = xlog_bread(log, i, 1, bp)))
 			goto bread_err;
 		offset = xlog_align(log, i, 1, bp);
-		if (XLOG_HEADER_MAGIC_NUM ==
-		    INT_GET(*(uint *)offset, ARCH_CONVERT)) {
+		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
 			found = 1;
 			break;
 		}
@@ -841,7 +839,7 @@ xlog_find_tail(
 				goto bread_err;
 			offset = xlog_align(log, i, 1, bp);
 			if (XLOG_HEADER_MAGIC_NUM ==
-			    INT_GET(*(uint*)offset, ARCH_CONVERT)) {
+			    be32_to_cpu(*(__be32 *)offset)) {
 				found = 2;
 				break;
 			}
@@ -855,7 +853,7 @@ xlog_find_tail(
 
 	/* find blk_no of tail of log */
 	rhead = (xlog_rec_header_t *)offset;
-	*tail_blk = BLOCK_LSN(INT_GET(rhead->h_tail_lsn, ARCH_CONVERT));
+	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
 	/*
 	 * Reset log values according to the state of the log when we
@@ -869,11 +867,11 @@ xlog_find_tail(
 	 */
 	log->l_prev_block = i;
 	log->l_curr_block = (int)*head_blk;
-	log->l_curr_cycle = INT_GET(rhead->h_cycle, ARCH_CONVERT);
+	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (found == 2)
 		log->l_curr_cycle++;
-	log->l_tail_lsn = INT_GET(rhead->h_tail_lsn, ARCH_CONVERT);
-	log->l_last_sync_lsn = INT_GET(rhead->h_lsn, ARCH_CONVERT);
+	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
+	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
 	log->l_grant_reserve_cycle = log->l_curr_cycle;
 	log->l_grant_reserve_bytes = BBTOB(log->l_curr_block);
 	log->l_grant_write_cycle = log->l_curr_cycle;
@@ -891,8 +889,8 @@ xlog_find_tail(
 	 * unmount record rather than the block after it.
 	 */
 	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
-		int	h_size = INT_GET(rhead->h_size, ARCH_CONVERT);
-		int	h_version = INT_GET(rhead->h_version, ARCH_CONVERT);
+		int	h_size = be32_to_cpu(rhead->h_size);
+		int	h_version = be32_to_cpu(rhead->h_version);
 
 		if ((h_version & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
@@ -906,10 +904,10 @@ xlog_find_tail(
 		hblks = 1;
 	}
 	after_umount_blk = (i + hblks + (int)
-		BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT))) % log->l_logBBsize;
+		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
 	tail_lsn = log->l_tail_lsn;
 	if (*head_blk == after_umount_blk &&
-	    INT_GET(rhead->h_num_logops, ARCH_CONVERT) == 1) {
+	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
 		if ((error = xlog_bread(log, umount_data_blk, 1, bp))) {
 			goto bread_err;
@@ -1100,14 +1098,13 @@ xlog_add_record(
 	xlog_rec_header_t	*recp = (xlog_rec_header_t *)buf;
 
 	memset(buf, 0, BBSIZE);
-	INT_SET(recp->h_magicno, ARCH_CONVERT, XLOG_HEADER_MAGIC_NUM);
-	INT_SET(recp->h_cycle, ARCH_CONVERT, cycle);
-	INT_SET(recp->h_version, ARCH_CONVERT,
+	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+	recp->h_cycle = cpu_to_be32(cycle);
+	recp->h_version = cpu_to_be32(
 			XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? 2 : 1);
-	INT_SET(recp->h_lsn, ARCH_CONVERT, xlog_assign_lsn(cycle, block));
-	INT_SET(recp->h_tail_lsn, ARCH_CONVERT,
-		xlog_assign_lsn(tail_cycle, tail_block));
-	INT_SET(recp->h_fmt, ARCH_CONVERT, XLOG_FMT);
+	recp->h_lsn = cpu_to_be64(xlog_assign_lsn(cycle, block));
+	recp->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(tail_cycle, tail_block));
+	recp->h_fmt = cpu_to_be32(XLOG_FMT);
 	memcpy(&recp->h_fs_uuid, &log->l_mp->m_sb.sb_uuid, sizeof(uuid_t));
 }
 
@@ -2259,7 +2256,7 @@ xlog_recover_do_buffer_trans(
 	 * overlap with future reads of those inodes.
 	 */
 	if (XFS_DINODE_MAGIC ==
-	    INT_GET(*((__uint16_t *)(xfs_buf_offset(bp, 0))), ARCH_CONVERT) &&
+	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
 	    (XFS_BUF_COUNT(bp) != MAX(log->l_mp->m_sb.sb_blocksize,
 			(__uint32_t)XFS_INODE_CLUSTER_SIZE(log->l_mp)))) {
 		XFS_BUF_STALE(bp);
@@ -2629,8 +2626,7 @@ xlog_recover_do_dquot_trans(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = INT_GET(recddq->d_flags, ARCH_CONVERT) &
-			(XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return (0);
@@ -2943,8 +2939,8 @@ xlog_recover_process_data(
 	unsigned long		hash;
 	uint			flags;
 
-	lp = dp + INT_GET(rhead->h_len, ARCH_CONVERT);
-	num_logops = INT_GET(rhead->h_num_logops, ARCH_CONVERT);
+	lp = dp + be32_to_cpu(rhead->h_len);
+	num_logops = be32_to_cpu(rhead->h_num_logops);
 
 	/* check the log format matches our own - else we can't recover */
 	if (xlog_header_check_recover(log->l_mp, rhead))
@@ -2967,7 +2963,7 @@ xlog_recover_process_data(
 		if (trans == NULL) {		   /* not found; add new tid */
 			if (ohead->oh_flags & XLOG_START_TRANS)
 				xlog_recover_new_tid(&rhash[hash], tid,
-					INT_GET(rhead->h_lsn, ARCH_CONVERT));
+					be64_to_cpu(rhead->h_lsn));
 		} else {
 			ASSERT(dp + be32_to_cpu(ohead->oh_len) <= lp);
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
@@ -3358,16 +3354,16 @@ xlog_pack_data_checksum(
 	int		size)
 {
 	int		i;
-	uint		*up;
+	__be32		*up;
 	uint		chksum = 0;
 
-	up = (uint *)iclog->ic_datap;
+	up = (__be32 *)iclog->ic_datap;
 	/* divide length by 4 to get # words */
 	for (i = 0; i < (size >> 2); i++) {
-		chksum ^= INT_GET(*up, ARCH_CONVERT);
+		chksum ^= be32_to_cpu(*up);
 		up++;
 	}
-	INT_SET(iclog->ic_header.h_chksum, ARCH_CONVERT, chksum);
+	iclog->ic_header.h_chksum = cpu_to_be32(chksum);
 }
 #else
 #define xlog_pack_data_checksum(log, iclog, size)
@@ -3384,7 +3380,7 @@ xlog_pack_data(
 {
 	int			i, j, k;
 	int			size = iclog->ic_offset + roundoff;
-	uint			cycle_lsn;
+	__be32			cycle_lsn;
 	xfs_caddr_t		dp;
 	xlog_in_core_2_t	*xhdr;
 
@@ -3395,8 +3391,8 @@ xlog_pack_data(
 	dp = iclog->ic_datap;
 	for (i = 0; i < BTOBB(size) &&
 		i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
-		iclog->ic_header.h_cycle_data[i] = *(uint *)dp;
-		*(uint *)dp = cycle_lsn;
+		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
+		*(__be32 *)dp = cycle_lsn;
 		dp += BBSIZE;
 	}
 
@@ -3405,8 +3401,8 @@ xlog_pack_data(
 		for ( ; i < BTOBB(size); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			xhdr[j].hic_xheader.xh_cycle_data[k] = *(uint *)dp;
-			*(uint *)dp = cycle_lsn;
+			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
+			*(__be32 *)dp = cycle_lsn;
 			dp += BBSIZE;
 		}
 
@@ -3423,21 +3419,21 @@ xlog_unpack_data_checksum(
 	xfs_caddr_t		dp,
 	xlog_t			*log)
 {
-	uint			*up = (uint *)dp;
+	__be32			*up = (__be32 *)dp;
 	uint			chksum = 0;
 	int			i;
 
 	/* divide length by 4 to get # words */
-	for (i=0; i < INT_GET(rhead->h_len, ARCH_CONVERT) >> 2; i++) {
-		chksum ^= INT_GET(*up, ARCH_CONVERT);
+	for (i=0; i < be32_to_cpu(rhead->h_len) >> 2; i++) {
+		chksum ^= be32_to_cpu(*up);
 		up++;
 	}
-	if (chksum != INT_GET(rhead->h_chksum, ARCH_CONVERT)) {
+	if (chksum != be32_to_cpu(rhead->h_chksum)) {
 	    if (rhead->h_chksum ||
 		((log->l_flags & XLOG_CHKSUM_MISMATCH) == 0)) {
 		    cmn_err(CE_DEBUG,
 			"XFS: LogR chksum mismatch: was (0x%x) is (0x%x)\n",
-			    INT_GET(rhead->h_chksum, ARCH_CONVERT), chksum);
+			    be32_to_cpu(rhead->h_chksum), chksum);
 		    cmn_err(CE_DEBUG,
 "XFS: Disregard message if filesystem was created with non-DEBUG kernel");
 		    if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
@@ -3461,18 +3457,18 @@ xlog_unpack_data(
 	int			i, j, k;
 	xlog_in_core_2_t	*xhdr;
 
-	for (i = 0; i < BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT)) &&
+	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
-		*(uint *)dp = *(uint *)&rhead->h_cycle_data[i];
+		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
 		dp += BBSIZE;
 	}
 
 	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
 		xhdr = (xlog_in_core_2_t *)rhead;
-		for ( ; i < BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT)); i++) {
+		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			*(uint *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
+			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
 			dp += BBSIZE;
 		}
 	}
@@ -3488,24 +3484,21 @@ xlog_valid_rec_header(
 {
 	int			hlen;
 
-	if (unlikely(
-	    (INT_GET(rhead->h_magicno, ARCH_CONVERT) !=
-			XLOG_HEADER_MAGIC_NUM))) {
+	if (unlikely(be32_to_cpu(rhead->h_magicno) != XLOG_HEADER_MAGIC_NUM)) {
 		XFS_ERROR_REPORT("xlog_valid_rec_header(1)",
 				XFS_ERRLEVEL_LOW, log->l_mp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	if (unlikely(
 	    (!rhead->h_version ||
-	    (INT_GET(rhead->h_version, ARCH_CONVERT) &
-			(~XLOG_VERSION_OKBITS)) != 0))) {
+	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xlog_warn("XFS: %s: unrecognised log version (%d).",
-			__FUNCTION__, INT_GET(rhead->h_version, ARCH_CONVERT));
+			__FUNCTION__, be32_to_cpu(rhead->h_version));
 		return XFS_ERROR(EIO);
 	}
 
 	/* LR body must have data or it wouldn't have been written */
-	hlen = INT_GET(rhead->h_len, ARCH_CONVERT);
+	hlen = be32_to_cpu(rhead->h_len);
 	if (unlikely( hlen <= 0 || hlen > INT_MAX )) {
 		XFS_ERROR_REPORT("xlog_valid_rec_header(2)",
 				XFS_ERRLEVEL_LOW, log->l_mp);
@@ -3565,9 +3558,8 @@ xlog_do_recovery_pass(
 		error = xlog_valid_rec_header(log, rhead, tail_blk);
 		if (error)
 			goto bread_err1;
-		h_size = INT_GET(rhead->h_size, ARCH_CONVERT);
-		if ((INT_GET(rhead->h_version, ARCH_CONVERT)
-				& XLOG_VERSION_2) &&
+		h_size = be32_to_cpu(rhead->h_size);
+		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
 			if (h_size % XLOG_HEADER_CYCLE_SIZE)
@@ -3604,7 +3596,7 @@ xlog_do_recovery_pass(
 				goto bread_err2;
 
 			/* blocks in data section */
-			bblks = (int)BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT));
+			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
 			error = xlog_bread(log, blk_no + hblks, bblks, dbp);
 			if (error)
 				goto bread_err2;
@@ -3679,7 +3671,7 @@ xlog_do_recovery_pass(
 			if (error)
 				goto bread_err2;
 
-			bblks = (int)BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT));
+			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
 			blk_no += hblks;
 
 			/* Read in data for log record */
@@ -3750,7 +3742,7 @@ xlog_do_recovery_pass(
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
-			bblks = (int)BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT));
+			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
 			if ((error = xlog_bread(log, blk_no+hblks, bblks, dbp)))
 				goto bread_err2;
 			offset = xlog_align(log, blk_no+hblks, bblks, dbp);
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-09-21 10:50:53.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-09-21 10:51:04.000000000 +0200
@@ -5739,17 +5739,21 @@ xfsidbg_xiclog(xlog_in_core_t *iclog)
 	kdb_printf("xlog_in_core/header at 0x%p/0x%p\n",
 		iclog, iclog->hic_data);
 	kdb_printf("magicno: %x  cycle: %d  version: %d  lsn: 0x%Lx\n",
-		INT_GET(iclog->ic_header.h_magicno, ARCH_CONVERT), INT_GET(iclog->ic_header.h_cycle, ARCH_CONVERT),
-		INT_GET(iclog->ic_header.h_version, ARCH_CONVERT), INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT));
+		be32_to_cpu(iclog->ic_header.h_magicno),
+		be32_to_cpu(iclog->ic_header.h_cycle),
+		be32_to_cpu(iclog->ic_header.h_version),
+		be64_to_cpu(iclog->ic_header.h_lsn));
 	kdb_printf("tail_lsn: 0x%Lx  len: %d  prev_block: %d  num_ops: %d\n",
-		INT_GET(iclog->ic_header.h_tail_lsn, ARCH_CONVERT), INT_GET(iclog->ic_header.h_len, ARCH_CONVERT),
-		INT_GET(iclog->ic_header.h_prev_block, ARCH_CONVERT), INT_GET(iclog->ic_header.h_num_logops, ARCH_CONVERT));
+		be64_to_cpu(iclog->ic_header.h_tail_lsn),
+		be32_to_cpu(iclog->ic_header.h_len),
+		be32_to_cpu(iclog->ic_header.h_prev_block),
+		be32_to_cpu(iclog->ic_header.h_num_logops));
 	kdb_printf("cycle_data: ");
 	for (i=0; i<(iclog->ic_size>>BBSHIFT); i++) {
-		kdb_printf("%x  ", INT_GET(iclog->ic_header.h_cycle_data[i], ARCH_CONVERT));
+		kdb_printf("%x  ", be32_to_cpu(iclog->ic_header.h_cycle_data[i]));
 	}
 	kdb_printf("\n");
-	kdb_printf("size: %d\n", INT_GET(iclog->ic_header.h_size, ARCH_CONVERT));
+	kdb_printf("size: %d\n", be32_to_cpu(iclog->ic_header.h_size));
 	kdb_printf("\n");
 	kdb_printf("--------------------------------------------------\n");
 	kdb_printf("data: 0x%p  &forcesema: 0x%p  next: 0x%p bp: 0x%p\n",
Index: linux-2.6-xfs/fs/xfs/xfs_log.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.h	2007-09-20 16:33:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.h	2007-09-21 10:51:04.000000000 +0200
@@ -22,8 +22,9 @@
 
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
+
 /* this is used in a spot where we might otherwise double-endian-flip */
-#define CYCLE_LSN_DISK(lsn) (((uint *)&(lsn))[0])
+#define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
 
 #ifdef __KERNEL__
 /*
