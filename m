Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:07:09 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EG73bm016258
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:07:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6EG71NK008486
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 18:07:02 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6EG71JB008484
	for xfs@oss.sgi.com; Sat, 14 Jul 2007 18:07:01 +0200
Date: Sat, 14 Jul 2007 18:07:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sparse pointer vs 0 warnings
Message-ID: <20070714160701.GC7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Sparse now warns about comparing pointers to 0, so change all instance
where that happens to NULL instead.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2007-07-14 15:56:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2007-07-14 15:58:16.000000000 +0200
@@ -2198,13 +2198,13 @@ xlog_state_do_callback(
 			}
 			cb = iclog->ic_callback;
 
-			while (cb != 0) {
+			while (cb) {
 				iclog->ic_callback_tail = &(iclog->ic_callback);
 				iclog->ic_callback = NULL;
 				LOG_UNLOCK(log, s);
 
 				/* perform callbacks in the order given */
-				for (; cb != 0; cb = cb_next) {
+				for (; cb; cb = cb_next) {
 					cb_next = cb->cb_next;
 					cb->cb_func(cb->cb_arg, aborted);
 				}
@@ -2215,7 +2215,7 @@ xlog_state_do_callback(
 			loopdidcallbacks++;
 			funcdidcallbacks++;
 
-			ASSERT(iclog->ic_callback == 0);
+			ASSERT(iclog->ic_callback == NULL);
 			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
 				iclog->ic_state = XLOG_STATE_DIRTY;
 
@@ -3255,10 +3255,10 @@ xlog_ticket_put(xlog_t		*log,
 #else
 	/* When we debug, it is easier if tickets are cycled */
 	ticket->t_next     = NULL;
-	if (log->l_tail != 0) {
+	if (log->l_tail) {
 		log->l_tail->t_next = ticket;
 	} else {
-		ASSERT(log->l_freelist == 0);
+		ASSERT(log->l_freelist == NULL);
 		log->l_freelist = ticket;
 	}
 	log->l_tail	    = ticket;
@@ -3476,7 +3476,7 @@ xlog_verify_iclog(xlog_t	 *log,
 	s = LOG_LOCK(log);
 	icptr = log->l_iclog;
 	for (i=0; i < log->l_iclog_bufs; i++) {
-		if (icptr == 0)
+		if (icptr == NULL)
 			xlog_panic("xlog_verify_iclog: invalid ptr");
 		icptr = icptr->ic_next;
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-07-14 15:58:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-07-14 15:59:35.000000000 +0200
@@ -1366,7 +1366,7 @@ xlog_recover_add_to_cont_trans(
 	int			old_len;
 
 	item = trans->r_itemq;
-	if (item == 0) {
+	if (item == NULL) {
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (xfs_caddr_t) &trans->r_theader +
@@ -1412,7 +1412,7 @@ xlog_recover_add_to_trans(
 	if (!len)
 		return 0;
 	item = trans->r_itemq;
-	if (item == 0) {
+	if (item == NULL) {
 		ASSERT(*(uint *)dp == XFS_TRANS_HEADER_MAGIC);
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
@@ -1467,12 +1467,12 @@ xlog_recover_unlink_tid(
 	xlog_recover_t		*tp;
 	int			found = 0;
 
-	ASSERT(trans != 0);
+	ASSERT(trans != NULL);
 	if (trans == *q) {
 		*q = (*q)->r_next;
 	} else {
 		tp = *q;
-		while (tp != 0) {
+		while (tp) {
 			if (tp->r_next == trans) {
 				found = 1;
 				break;
@@ -1495,7 +1495,7 @@ xlog_recover_insert_item_backq(
 	xlog_recover_item_t	**q,
 	xlog_recover_item_t	*item)
 {
-	if (*q == 0) {
+	if (*q == NULL) {
 		item->ri_prev = item->ri_next = item;
 		*q = item;
 	} else {
@@ -1899,7 +1899,7 @@ xlog_recover_do_reg_buffer(
 			break;
 		nbits = xfs_contig_bits(data_map, map_size, bit);
 		ASSERT(nbits > 0);
-		ASSERT(item->ri_buf[i].i_addr != 0);
+		ASSERT(item->ri_buf[i].i_addr != NULL);
 		ASSERT(item->ri_buf[i].i_len % XFS_BLI_CHUNK == 0);
 		ASSERT(XFS_BUF_COUNT(bp) >=
 		       ((uint)bit << XFS_BLI_SHIFT)+(nbits<<XFS_BLI_SHIFT));
