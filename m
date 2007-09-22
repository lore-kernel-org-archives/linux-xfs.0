Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Sep 2007 03:34:24 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8MAYJQ3016099
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2007 03:34:20 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8MAYKA5016236
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2007 12:34:20 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8MAYKLu016234
	for xfs@oss.sgi.com; Sat, 22 Sep 2007 12:34:20 +0200
Date: Sat, 22 Sep 2007 12:34:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] clean up some xfs_log_priv.h macros
Message-ID: <20070922103420.GA16223@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - the various assign lsn macros are replaced by a single inline,
   xlog_assign_lsn, which is equivalent to ASSIGN_ANY_LSN_HOST except
   for a more sane calling convention.  ASSIGN_LSN_DISK is replaced
   by xlog_assign_lsn and a manual bytespap, and ASSIGN_LSN by the same,
   except we pass the cycle and block arguments explicitly instead of a
   log paramter.  The latter two variants only had 2, respectively one
   user anyway.
 - the GET_CYCLE is replaced by a xlog_get_cycle inline with exactly the
   same calling conventions.
 - GET_CLIENT_ID is replaced by xlog_get_client_id which leaves away
   the unused arch argument.  Instead of conditional defintions
   depending on host endianess we now do an unconditional swap and shift
   then, which generates equal code.
 - the unused XLOG_SET macro is removed.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2007-08-23 20:36:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2007-08-23 20:37:05.000000000 +0200
@@ -1142,7 +1142,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
 
 	log->l_prev_block  = -1;
-	ASSIGN_ANY_LSN_HOST(log->l_tail_lsn, 1, 0);
+	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
 	log->l_last_sync_lsn = log->l_tail_lsn;
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
@@ -1308,8 +1308,7 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
 	    threshold_block -= log->l_logBBsize;
 	    threshold_cycle += 1;
 	}
-	ASSIGN_ANY_LSN_HOST(threshold_lsn, threshold_cycle,
-		       threshold_block);
+	threshold_lsn = xlog_assign_lsn(threshold_cycle, threshold_block);
 
 	/* Don't pass in an lsn greater than the lsn of the last
 	 * log record known to be on disk.
@@ -2382,7 +2381,8 @@ restart:
 				    log->l_iclog_hsize,
 				    XLOG_REG_TYPE_LRHEADER);
 		INT_SET(head->h_cycle, ARCH_CONVERT, log->l_curr_cycle);
-		ASSIGN_LSN(head->h_lsn, log);
+		INT_SET(head->h_lsn, ARCH_CONVERT,
+			xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
 		ASSERT(log->l_curr_block >= 0);
 	}
 
@@ -3494,9 +3494,11 @@ xlog_verify_iclog(xlog_t	 *log,
 			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
 				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-				clientid = GET_CLIENT_ID(xhdr[j].hic_xheader.xh_cycle_data[k], ARCH_CONVERT);
+				clientid = xlog_get_client_id(
+					xhdr[j].hic_xheader.xh_cycle_data[k]);
 			} else {
-				clientid = GET_CLIENT_ID(iclog->ic_header.h_cycle_data[idx], ARCH_CONVERT);
+				clientid = xlog_get_client_id(
+					iclog->ic_header.h_cycle_data[idx]);
 			}
 		}
 		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2007-08-23 20:36:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2007-08-23 20:37:34.000000000 +0200
@@ -55,33 +55,22 @@ struct xfs_mount;
 	BTOBB(XLOG_MAX_ICLOGS << (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 
-/*
- *  set lsns
- */
 
-#define ASSIGN_ANY_LSN_HOST(lsn,cycle,block)  \
-    { \
-	(lsn) = ((xfs_lsn_t)(cycle)<<32)|(block); \
-    }
-#define ASSIGN_ANY_LSN_DISK(lsn,cycle,block)  \
-    { \
-	INT_SET(((uint *)&(lsn))[0], ARCH_CONVERT, (cycle)); \
-	INT_SET(((uint *)&(lsn))[1], ARCH_CONVERT, (block)); \
-    }
-#define ASSIGN_LSN(lsn,log) \
-    ASSIGN_ANY_LSN_DISK(lsn,(log)->l_curr_cycle,(log)->l_curr_block);
-
-#define XLOG_SET(f,b)		(((f) & (b)) == (b))
-
-#define GET_CYCLE(ptr, arch) \
-    (INT_GET(*(uint *)(ptr), arch) == XLOG_HEADER_MAGIC_NUM ? \
-	 INT_GET(*((uint *)(ptr)+1), arch) : \
-	 INT_GET(*(uint *)(ptr), arch) \
-    )
+static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
+{
+	return ((xfs_lsn_t)cycle << 32) | block;
+}
+
+static inline uint xlog_get_cycle(char *ptr)
+{
+	if (INT_GET(*(uint *)ptr, ARCH_CONVERT) == XLOG_HEADER_MAGIC_NUM)
+		return INT_GET(*((uint *)ptr + 1), ARCH_CONVERT);
+	else
+		return INT_GET(*(uint *)ptr, ARCH_CONVERT);
+}
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
-
 #ifdef __KERNEL__
 
 /*
@@ -96,14 +85,10 @@ struct xfs_mount;
  *
  * this has endian issues, of course.
  */
-
-#ifndef XFS_NATIVE_HOST
-#define GET_CLIENT_ID(i,arch) \
-    ((i) & 0xff)
-#else
-#define GET_CLIENT_ID(i,arch) \
-    ((i) >> 24)
-#endif
+static inline uint xlog_get_client_id(uint i)
+{
+	return INT_GET(i, ARCH_CONVERT) >> 24;
+}
 
 #define GRANT_LOCK(log)		mutex_spinlock(&(log)->l_grant_lock)
 #define GRANT_UNLOCK(log, s)	mutex_spinunlock(&(log)->l_grant_lock, s)
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-08-23 20:36:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-08-23 20:37:05.000000000 +0200
@@ -311,7 +311,7 @@ xlog_find_cycle_start(
 		if ((error = xlog_bread(log, mid_blk, 1, bp)))
 			return error;
 		offset = xlog_align(log, mid_blk, 1, bp);
-		mid_cycle = GET_CYCLE(offset, ARCH_CONVERT);
+		mid_cycle = xlog_get_cycle(offset);
 		if (mid_cycle == cycle) {
 			*last_blk = mid_blk;
 			/* last_half_cycle == mid_cycle */
@@ -371,7 +371,7 @@ xlog_find_verify_cycle(
 
 		buf = xlog_align(log, i, bcount, bp);
 		for (j = 0; j < bcount; j++) {
-			cycle = GET_CYCLE(buf, ARCH_CONVERT);
+			cycle = xlog_get_cycle(buf);
 			if (cycle == stop_on_cycle_no) {
 				*new_blk = i+j;
 				goto out;
@@ -550,13 +550,13 @@ xlog_find_head(
 	if ((error = xlog_bread(log, 0, 1, bp)))
 		goto bp_err;
 	offset = xlog_align(log, 0, 1, bp);
-	first_half_cycle = GET_CYCLE(offset, ARCH_CONVERT);
+	first_half_cycle = xlog_get_cycle(offset);
 
 	last_blk = head_blk = log_bbnum - 1;	/* get cycle # of last block */
 	if ((error = xlog_bread(log, last_blk, 1, bp)))
 		goto bp_err;
 	offset = xlog_align(log, last_blk, 1, bp);
-	last_half_cycle = GET_CYCLE(offset, ARCH_CONVERT);
+	last_half_cycle = xlog_get_cycle(offset);
 	ASSERT(last_half_cycle != 0);
 
 	/*
@@ -808,7 +808,7 @@ xlog_find_tail(
 		if ((error = xlog_bread(log, 0, 1, bp)))
 			goto bread_err;
 		offset = xlog_align(log, 0, 1, bp);
-		if (GET_CYCLE(offset, ARCH_CONVERT) == 0) {
+		if (xlog_get_cycle(offset) == 0) {
 			*tail_blk = 0;
 			/* leave all other log inited values alone */
 			goto exit;
@@ -922,10 +922,12 @@ xlog_find_tail(
 			 * log records will point recovery to after the
 			 * current unmount record.
 			 */
-			ASSIGN_ANY_LSN_HOST(log->l_tail_lsn, log->l_curr_cycle,
-					after_umount_blk);
-			ASSIGN_ANY_LSN_HOST(log->l_last_sync_lsn, log->l_curr_cycle,
-					after_umount_blk);
+			log->l_tail_lsn =
+				xlog_assign_lsn(log->l_curr_cycle,
+						after_umount_blk);
+			log->l_last_sync_lsn =
+				xlog_assign_lsn(log->l_curr_cycle,
+						after_umount_blk);
 			*tail_blk = after_umount_blk;
 
 			/*
@@ -1007,7 +1009,7 @@ xlog_find_zeroed(
 	if ((error = xlog_bread(log, 0, 1, bp)))
 		goto bp_err;
 	offset = xlog_align(log, 0, 1, bp);
-	first_cycle = GET_CYCLE(offset, ARCH_CONVERT);
+	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
 		xlog_put_bp(bp);
@@ -1018,7 +1020,7 @@ xlog_find_zeroed(
 	if ((error = xlog_bread(log, log_bbnum-1, 1, bp)))
 		goto bp_err;
 	offset = xlog_align(log, log_bbnum-1, 1, bp);
-	last_cycle = GET_CYCLE(offset, ARCH_CONVERT);
+	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
 		xlog_put_bp(bp);
 		return 0;
@@ -1102,8 +1104,9 @@ xlog_add_record(
 	INT_SET(recp->h_cycle, ARCH_CONVERT, cycle);
 	INT_SET(recp->h_version, ARCH_CONVERT,
 			XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? 2 : 1);
-	ASSIGN_ANY_LSN_DISK(recp->h_lsn, cycle, block);
-	ASSIGN_ANY_LSN_DISK(recp->h_tail_lsn, tail_cycle, tail_block);
+	INT_SET(recp->h_lsn, ARCH_CONVERT, xlog_assign_lsn(cycle, block));
+	INT_SET(recp->h_tail_lsn, ARCH_CONVERT,
+		xlog_assign_lsn(tail_cycle, tail_block));
 	INT_SET(recp->h_fmt, ARCH_CONVERT, XLOG_FMT);
 	memcpy(&recp->h_fs_uuid, &log->l_mp->m_sb.sb_uuid, sizeof(uuid_t));
 }
