Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 18:21:13 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l731L7bm015320
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 18:21:08 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l731LAA5006750
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2007 03:21:10 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l731LAfW006748
	for xfs@oss.sgi.com; Fri, 3 Aug 2007 03:21:10 +0200
Date: Fri, 3 Aug 2007 03:21:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] replace some large xfs_log_priv.h macros by proper functions
Message-ID: <20070803012110.GA6590@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

... or in the case of XLOG_TIC_ADD_OPHDR remove a useless macro
entirely.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2007-08-03 01:02:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2007-08-03 01:10:41.000000000 +0200
@@ -252,6 +252,29 @@ xlog_grant_add_space(struct log *log, in
 	xlog_grant_add_space_reserve(log, bytes);
 }
 
+static void
+xlog_tic_reset_res(xlog_ticket_t *tic)
+{
+	tic->t_res_num = 0;
+	tic->t_res_arr_sum = 0;
+	tic->t_res_num_ophdrs = 0;
+}
+
+static void
+xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
+{
+	if (tic->t_res_num == XLOG_TIC_LEN_MAX) {
+		/* add to overflow and start again */
+		tic->t_res_o_flow += tic->t_res_arr_sum;
+		tic->t_res_num = 0;
+		tic->t_res_arr_sum = 0;
+	}
+
+	tic->t_res_arr[tic->t_res_num].r_len = len;
+	tic->t_res_arr[tic->t_res_num].r_type = type;
+	tic->t_res_arr_sum += len;
+	tic->t_res_num++;
+}
 
 /*
  * NOTES:
@@ -1765,14 +1788,14 @@ xlog_write(xfs_mount_t *	mp,
     len = 0;
     if (ticket->t_flags & XLOG_TIC_INITED) {    /* acct for start rec of xact */
 	len += sizeof(xlog_op_header_t);
-	XLOG_TIC_ADD_OPHDR(ticket);
+	ticket->t_res_num_ophdrs++;
     }
 
     for (index = 0; index < nentries; index++) {
 	len += sizeof(xlog_op_header_t);	    /* each region gets >= 1 */
-	XLOG_TIC_ADD_OPHDR(ticket);
+	ticket->t_res_num_ophdrs++;
 	len += reg[index].i_len;
-	XLOG_TIC_ADD_REGION(ticket, reg[index].i_len, reg[index].i_type);
+	xlog_tic_add_region(ticket, reg[index].i_len, reg[index].i_type);
     }
     contwr = *start_lsn = 0;
 
@@ -1881,7 +1904,7 @@ xlog_write(xfs_mount_t *	mp,
 		len += sizeof(xlog_op_header_t); /* from splitting of region */
 		/* account for new log op header */
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
-		XLOG_TIC_ADD_OPHDR(ticket);
+		ticket->t_res_num_ophdrs++;
 	    }
 	    xlog_verify_dest_ptr(log, ptr);
 
@@ -2379,7 +2402,7 @@ restart:
 	 */
 	if (log_offset == 0) {
 		ticket->t_curr_res -= log->l_iclog_hsize;
-		XLOG_TIC_ADD_REGION(ticket,
+		xlog_tic_add_region(ticket,
 				    log->l_iclog_hsize,
 				    XLOG_REG_TYPE_LRHEADER);
 		INT_SET(head->h_cycle, ARCH_CONVERT, log->l_curr_cycle);
@@ -2567,7 +2590,7 @@ xlog_regrant_write_log_space(xlog_t	   *
 #endif
 
 	tic->t_curr_res = tic->t_unit_res;
-	XLOG_TIC_RESET_RES(tic);
+	xlog_tic_reset_res(tic);
 
 	if (tic->t_cnt > 0)
 		return 0;
@@ -2708,7 +2731,7 @@ xlog_regrant_reserve_log_space(xlog_t	  
 	s = GRANT_LOCK(log);
 	xlog_grant_sub_space(log, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
-	XLOG_TIC_RESET_RES(ticket);
+	xlog_tic_reset_res(ticket);
 	xlog_trace_loggrant(log, ticket,
 			    "xlog_regrant_reserve_log_space: sub current res");
 	xlog_verify_grant_head(log, 1);
@@ -2725,7 +2748,7 @@ xlog_regrant_reserve_log_space(xlog_t	  
 	xlog_verify_grant_head(log, 0);
 	GRANT_UNLOCK(log, s);
 	ticket->t_curr_res = ticket->t_unit_res;
-	XLOG_TIC_RESET_RES(ticket);
+	xlog_tic_reset_res(ticket);
 }	/* xlog_regrant_reserve_log_space */
 
 
@@ -3348,7 +3371,7 @@ xlog_ticket_get(xlog_t		*log,
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 	sv_init(&(tic->t_sema), SV_DEFAULT, "logtick");
 
-	XLOG_TIC_RESET_RES(tic);
+	xlog_tic_reset_res(tic);
 
 	return tic;
 }	/* xlog_ticket_get */
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2007-08-03 01:02:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2007-08-03 01:10:17.000000000 +0200
@@ -249,22 +249,6 @@ typedef __uint32_t xlog_tid_t;
 
 /* Ticket reservation region accounting */ 
 #define XLOG_TIC_LEN_MAX	15
-#define XLOG_TIC_RESET_RES(t) ((t)->t_res_num = \
-				(t)->t_res_arr_sum = (t)->t_res_num_ophdrs = 0)
-#define XLOG_TIC_ADD_OPHDR(t) ((t)->t_res_num_ophdrs++)
-#define XLOG_TIC_ADD_REGION(t, len, type)				\
-	do {								\
-		if ((t)->t_res_num == XLOG_TIC_LEN_MAX) { 		\
-			/* add to overflow and start again */		\
-			(t)->t_res_o_flow += (t)->t_res_arr_sum;	\
-			(t)->t_res_num = 0;				\
-			(t)->t_res_arr_sum = 0;				\
-		}							\
-		(t)->t_res_arr[(t)->t_res_num].r_len = (len);		\
-		(t)->t_res_arr[(t)->t_res_num].r_type = (type);		\
-		(t)->t_res_arr_sum += (len);				\
-		(t)->t_res_num++;					\
-	} while (0)
 
 /*
  * Reservation region
