Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFr89D061622 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:53:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E6DF142E94C
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pbbcJxtWKuLkWvoE for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:44 -0700 (PDT)
Message-Id: <20100315155443.458780783@bombadil.infradead.org>
Date: Mon, 15 Mar 2010 11:51:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: clean up xlog_write_adv_cnt
References: <20100315155151.642965370@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xlog_write_adv_cnt
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Replace the awkward xlog_write_adv_cnt with an inline helper that makes
it more obvious that it's modifying it's paramters, and replace the use
of an integer type for "ptr" with a real void pointer.  Also move
xlog_write_adv_cnt to xfs_log_priv.h as it will be used outside of
xfs_log.c in the delayed logging series.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-03-15 13:43:23.000000000 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-03-15 13:48:05.503006054 +0100
@@ -44,11 +44,6 @@
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
-#define xlog_write_adv_cnt(ptr, len, off, bytes) \
-	{ (ptr) += (bytes); \
-	  (len) -= (bytes); \
-	  (off) += (bytes);}
-
 /* Local miscellaneous function prototypes */
 STATIC int	 xlog_commit_record(struct log *log, struct xlog_ticket *ticket,
 				    xlog_in_core_t **, xfs_lsn_t *);
@@ -100,7 +95,7 @@ STATIC xlog_ticket_t	*xlog_ticket_alloc(
 					 uint	flags);
 
 #if defined(DEBUG)
-STATIC void	xlog_verify_dest_ptr(xlog_t *log, __psint_t ptr);
+STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
 STATIC void	xlog_verify_grant_head(xlog_t *log, int equals);
 STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
@@ -1669,11 +1664,9 @@ xlog_write_calc_vec_length(
  */
 static int
 xlog_write_start_rec(
-	__psint_t		ptr,
+	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket)
 {
-	struct xlog_op_header	*ophdr = (struct xlog_op_header *)ptr;
-
 	if (!(ticket->t_flags & XLOG_TIC_INITED))
 		return 0;
 
@@ -1691,12 +1684,10 @@ xlog_write_start_rec(
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
 	struct log		*log,
-	__psint_t		ptr,
+	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket,
 	uint			flags)
 {
-	struct xlog_op_header	*ophdr = (struct xlog_op_header *)ptr;
-
 	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
 	ophdr->oh_clientid = ticket->t_clientid;
 	ophdr->oh_res2 = 0;
@@ -1903,7 +1894,7 @@ xlog_write(
 	lv = log_vector;
 	vecp = lv->lv_iovecp;
 	while (lv && index < lv->lv_niovecs) {
-		__psint_t	ptr;
+		void		*ptr;
 		int		log_offset;
 
 		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
@@ -1912,7 +1903,7 @@ xlog_write(
 			return error;
 
 		ASSERT(log_offset <= iclog->ic_size - 1);
-		ptr = (__psint_t) ((char *)iclog->ic_datap+log_offset);
+		ptr = iclog->ic_datap + log_offset;
 
 		/* start_lsn is the first lsn written to. That's all we need. */
 		if (!*start_lsn)
@@ -1930,12 +1921,12 @@ xlog_write(
 			int     		copy_off;
 
 			ASSERT(reg->i_len % sizeof(__int32_t) == 0);
-			ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
+			ASSERT((unsigned long)ptr % sizeof(__int32_t) == 0);
 
 			start_rec_copy = xlog_write_start_rec(ptr, ticket);
 			if (start_rec_copy) {
 				record_cnt++;
-				xlog_write_adv_cnt(ptr, len, log_offset,
+				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 						   start_rec_copy);
 			}
 
@@ -1943,7 +1934,7 @@ xlog_write(
 			if (!ophdr)
 				return XFS_ERROR(EIO);
 
-			xlog_write_adv_cnt(ptr, len, log_offset,
+			xlog_write_adv_cnt(&ptr, &len, &log_offset,
 					   sizeof(struct xlog_op_header));
 
 			len += xlog_write_setup_copy(ticket, ophdr,
@@ -1956,9 +1947,8 @@ xlog_write(
 
 			/* copy region */
 			ASSERT(copy_len >= 0);
-			memcpy((xfs_caddr_t)ptr, reg->i_addr + copy_off,
-			       copy_len);
-			xlog_write_adv_cnt(ptr, len, log_offset, copy_len);
+			memcpy(ptr, reg->i_addr + copy_off, copy_len);
+			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
 
 			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
 			record_cnt++;
@@ -3440,20 +3430,22 @@ xlog_ticket_alloc(
  * part of the log in case we trash the log structure.
  */
 void
-xlog_verify_dest_ptr(xlog_t     *log,
-		     __psint_t  ptr)
+xlog_verify_dest_ptr(
+	struct log	*log,
+	char		*ptr)
 {
 	int i;
 	int good_ptr = 0;
 
-	for (i=0; i < log->l_iclog_bufs; i++) {
-		if (ptr >= (__psint_t)log->l_iclog_bak[i] &&
-		    ptr <= (__psint_t)log->l_iclog_bak[i]+log->l_iclog_size)
+	for (i = 0; i < log->l_iclog_bufs; i++) {
+		if (ptr >= log->l_iclog_bak[i] &&
+		    ptr <= log->l_iclog_bak[i]+log->l_iclog_size)
 			good_ptr++;
 	}
-	if (! good_ptr)
+
+	if (!good_ptr)
 		xlog_panic("xlog_verify_dest_ptr: invalid ptr");
-}	/* xlog_verify_dest_ptr */
+}
 
 STATIC void
 xlog_verify_grant_head(xlog_t *log, int equals)
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2010-03-15 13:48:00.139261678 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2010-03-15 13:48:20.042033287 +0100
@@ -449,6 +449,14 @@ extern void	 xlog_pack_data(xlog_t *log,
 
 extern kmem_zone_t	*xfs_log_ticket_zone;
 
+static inline void
+xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
+{
+	*ptr += bytes;
+	*len -= bytes;
+	*off += bytes;
+}
+
 /*
  * Unmount record type is used as a pseudo transaction type for the ticket.
  * It's value must be outside the range of XFS_TRANS_* values.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
