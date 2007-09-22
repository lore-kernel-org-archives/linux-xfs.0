Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Sep 2007 03:34:29 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8MAYNQ3016141
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2007 03:34:27 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8MAYPA5016254
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2007 12:34:25 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8MAYPUw016252
	for xfs@oss.sgi.com; Sat, 22 Sep 2007 12:34:25 +0200
Date: Sat, 22 Sep 2007 12:34:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xlog_op_header endianess annotations
Message-ID: <20070922103425.GB16223@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2007-08-23 20:44:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2007-08-23 20:44:30.000000000 +0200
@@ -1815,7 +1815,7 @@ xlog_write(xfs_mount_t *	mp,
 	     */
 	    if (ticket->t_flags & XLOG_TIC_INITED) {
 		logop_head		= (xlog_op_header_t *)ptr;
-		INT_SET(logop_head->oh_tid, ARCH_CONVERT, ticket->t_tid);
+		logop_head->oh_tid	= cpu_to_be32(ticket->t_tid);
 		logop_head->oh_clientid = ticket->t_clientid;
 		logop_head->oh_len	= 0;
 		logop_head->oh_flags    = XLOG_START_TRANS;
@@ -1829,7 +1829,7 @@ xlog_write(xfs_mount_t *	mp,
 
 	    /* Copy log operation header directly into data section */
 	    logop_head			= (xlog_op_header_t *)ptr;
-	    INT_SET(logop_head->oh_tid, ARCH_CONVERT, ticket->t_tid);
+	    logop_head->oh_tid		= cpu_to_be32(ticket->t_tid);
 	    logop_head->oh_clientid	= ticket->t_clientid;
 	    logop_head->oh_res2		= 0;
 
@@ -1864,13 +1864,14 @@ xlog_write(xfs_mount_t *	mp,
 
 	    copy_off = partial_copy_len;
 	    if (need_copy <= iclog->ic_size - log_offset) { /*complete write */
-		INT_SET(logop_head->oh_len, ARCH_CONVERT, copy_len = need_copy);
+	        copy_len = need_copy;
+		logop_head->oh_len = cpu_to_be32(copy_len);
 		if (partial_copy)
 		    logop_head->oh_flags|= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
 		partial_copy_len = partial_copy = 0;
 	    } else {					    /* partial write */
 		copy_len = iclog->ic_size - log_offset;
-		INT_SET(logop_head->oh_len, ARCH_CONVERT, copy_len);
+		logop_head->oh_len = cpu_to_be32(copy_len);
 		logop_head->oh_flags |= XLOG_CONTINUE_TRANS;
 		if (partial_copy)
 			logop_head->oh_flags |= XLOG_WAS_CONT_TRANS;
@@ -3510,7 +3511,7 @@ xlog_verify_iclog(xlog_t	 *log,
 		field_offset = (__psint_t)
 			       ((xfs_caddr_t)&(ophead->oh_len) - base_ptr);
 		if (syncing == B_FALSE || (field_offset & 0x1ff)) {
-			op_len = INT_GET(ophead->oh_len, ARCH_CONVERT);
+			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
 			idx = BTOBBT((__psint_t)&ophead->oh_len -
 				    (__psint_t)iclog->ic_datap);
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2007-08-23 20:44:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2007-08-23 20:44:30.000000000 +0200
@@ -286,11 +286,11 @@ typedef struct xlog_ticket {
 
 
 typedef struct xlog_op_header {
-	xlog_tid_t oh_tid;	/* transaction id of operation	:  4 b */
-	int	   oh_len;	/* bytes in data region		:  4 b */
-	__uint8_t  oh_clientid;	/* who sent me this		:  1 b */
-	__uint8_t  oh_flags;	/*				:  1 b */
-	ushort	   oh_res2;	/* 32 bit align			:  2 b */
+	__be32	   oh_tid;	/* transaction id of operation	:  4 b */
+	__be32	   oh_len;	/* bytes in data region		:  4 b */
+	__u8	   oh_clientid;	/* who sent me this		:  1 b */
+	__u8	   oh_flags;	/*				:  1 b */
+	__u16	   oh_res2;	/* 32 bit align			:  2 b */
 } xlog_op_header_t;
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-08-23 20:44:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-08-23 20:44:30.000000000 +0200
@@ -2918,7 +2918,7 @@ xlog_recover_process_data(
 			ASSERT(0);
 			return (XFS_ERROR(EIO));
 		}
-		tid = INT_GET(ohead->oh_tid, ARCH_CONVERT);
+		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
 		trans = xlog_recover_find_tid(rhash[hash], tid);
 		if (trans == NULL) {		   /* not found; add new tid */
@@ -2926,7 +2926,7 @@ xlog_recover_process_data(
 				xlog_recover_new_tid(&rhash[hash], tid,
 					INT_GET(rhead->h_lsn, ARCH_CONVERT));
 		} else {
-			ASSERT(dp+INT_GET(ohead->oh_len, ARCH_CONVERT) <= lp);
+			ASSERT(dp + be32_to_cpu(ohead->oh_len) <= lp);
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
 				flags &= ~XLOG_CONTINUE_TRANS;
@@ -2940,8 +2940,7 @@ xlog_recover_process_data(
 				break;
 			case XLOG_WAS_CONT_TRANS:
 				error = xlog_recover_add_to_cont_trans(trans,
-						dp, INT_GET(ohead->oh_len,
-							ARCH_CONVERT));
+						dp, be32_to_cpu(ohead->oh_len));
 				break;
 			case XLOG_START_TRANS:
 				xlog_warn(
@@ -2952,8 +2951,7 @@ xlog_recover_process_data(
 			case 0:
 			case XLOG_CONTINUE_TRANS:
 				error = xlog_recover_add_to_trans(trans,
-						dp, INT_GET(ohead->oh_len,
-							ARCH_CONVERT));
+						dp, be32_to_cpu(ohead->oh_len));
 				break;
 			default:
 				xlog_warn(
@@ -2965,7 +2963,7 @@ xlog_recover_process_data(
 			if (error)
 				return error;
 		}
-		dp += INT_GET(ohead->oh_len, ARCH_CONVERT);
+		dp += be32_to_cpu(ohead->oh_len);
 		num_logops--;
 	}
 	return 0;
