Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFr7hK061598 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:53:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D0061D33788
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FqUHS7JH57X6uWX0 for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:43 -0700 (PDT)
Message-Id: <20100315155442.826947550@bombadil.infradead.org>
Date: Mon, 15 Mar 2010 11:51:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: reindent xlog_write
References: <20100315155151.642965370@bombadil.infradead.org>
Content-Disposition: inline; filename=xlog_write-reindent
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

Reindent xlog_write to normal one tab indents and move all variable
declarations into the closest enclosing block.

Split from a bigger patch by Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-03-15 13:36:00.380253575 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-03-15 13:41:12.056255113 +0100
@@ -1852,127 +1852,141 @@ xlog_write(
 	struct xlog_in_core	**commit_iclog,
 	uint			flags)
 {
-    xlog_t	     *log = mp->m_log;
-    xlog_in_core_t   *iclog = NULL;  /* ptr to current in-core log */
-    xlog_op_header_t *logop_head;    /* ptr to log operation header */
-    __psint_t	     ptr;	     /* copy address into data region */
-    int		     len;	     /* # xlog_write() bytes 2 still copy */
-    int		     index;	     /* region index currently copying */
-    int		     log_offset;     /* offset (from 0) into data region */
-    int		     start_rec_copy; /* # bytes to copy for start record */
-    int		     partial_copy;   /* did we split a region? */
-    int		     partial_copy_len;/* # bytes copied if split region */
-    int		     copy_len;	     /* # bytes actually memcpy'ing */
-    int		     copy_off;	     /* # bytes from entry start */
-    int		     contwr;	     /* continued write of in-core log? */
-    int		     error;
-    int		     record_cnt = 0, data_cnt = 0;
-
-    partial_copy_len = partial_copy = 0;
-    contwr = *start_lsn = 0;
-
-    len = xlog_write_calc_vec_length(ticket, reg, nentries);
-    if (ticket->t_curr_res < len) {
-	xlog_print_tic_res(mp, ticket);
+	struct log		*log = mp->m_log;
+	struct xlog_in_core	*iclog = NULL;
+	int			len;
+	int			index;
+	int			partial_copy = 0;
+	int			partial_copy_len = 0;
+	int			contwr = 0;
+	int			record_cnt = 0;
+	int			data_cnt = 0;
+	int			error;
+
+	*start_lsn = 0;
+
+	len = xlog_write_calc_vec_length(ticket, reg, nentries);
+	if (ticket->t_curr_res < len) {
+		xlog_print_tic_res(mp, ticket);
 #ifdef DEBUG
-	xlog_panic(
-		"xfs_log_write: reservation ran out. Need to up reservation");
+		xlog_panic(
+	"xfs_log_write: reservation ran out. Need to up reservation");
 #else
-	/* Customer configurable panic */
-	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
-		"xfs_log_write: reservation ran out. Need to up reservation");
-	/* If we did not panic, shutdown the filesystem */
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		/* Customer configurable panic */
+		xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
+	"xfs_log_write: reservation ran out. Need to up reservation");
+
+		/* If we did not panic, shutdown the filesystem */
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 #endif
-    } else
+	}
+
 	ticket->t_curr_res -= len;
 
-    for (index = 0; index < nentries; ) {
-	if ((error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					       &contwr, &log_offset)))
-		return error;
-
-	ASSERT(log_offset <= iclog->ic_size - 1);
-	ptr = (__psint_t) ((char *)iclog->ic_datap+log_offset);
-
-	/* start_lsn is the first lsn written to. That's all we need. */
-	if (! *start_lsn)
-	    *start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
-
-	/* This loop writes out as many regions as can fit in the amount
-	 * of space which was allocated by xlog_state_get_iclog_space().
-	 */
-	while (index < nentries) {
-	    ASSERT(reg[index].i_len % sizeof(__int32_t) == 0);
-	    ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
-
-	    start_rec_copy = xlog_write_start_rec(ptr, ticket);
-	    if (start_rec_copy) {
-		record_cnt++;
-		xlog_write_adv_cnt(ptr, len, log_offset, start_rec_copy);
-	    }
-
-	    logop_head = xlog_write_setup_ophdr(log, ptr, ticket, flags);
-	    if (!logop_head)
-	    	return XFS_ERROR(EIO);
-	    xlog_write_adv_cnt(ptr, len, log_offset, sizeof(xlog_op_header_t));
-
-	    len += xlog_write_setup_copy(ticket, logop_head,
-	    				 iclog->ic_size - log_offset,
-					 reg[index].i_len, &copy_off,
-					 &copy_len, &partial_copy,
-					 &partial_copy_len);
-	    xlog_verify_dest_ptr(log, ptr);
-
-	    /* copy region */
-	    ASSERT(copy_len >= 0);
-	    memcpy((xfs_caddr_t)ptr, reg[index].i_addr + copy_off, copy_len);
-	    xlog_write_adv_cnt(ptr, len, log_offset, copy_len);
-
-	    /* make copy_len total bytes copied, including headers */
-	    copy_len += start_rec_copy + sizeof(xlog_op_header_t);
-	    record_cnt++;
-	    data_cnt += contwr ? copy_len : 0;
-
-	    error = xlog_write_copy_finish(log, iclog, flags,
-	    				   &record_cnt, &data_cnt,
-					   &partial_copy, &partial_copy_len,
-					   log_offset, commit_iclog);
-	    if (error)
-	    	return error;
-
-	    /*
-	     * if we had a partial copy, we need to get more iclog
-	     * space but we don't want to increment the region
-	     * index because there is still more is this region to write.
-	     *
-	     * If we completed writing this region, and we flushed
-	     * the iclog (indicated by resetting of the record
-	     * count), then we also need to get more log space. If
-	     * this was the last record, though, we are done and
-	     * can just return.
-	     */
-	    if (partial_copy)
-	    	break;
-
-	    index++;
-	    if (record_cnt == 0) {
-		if (index == nentries)
-		    return 0;
-		break;
-	    }
-	} /* while (index < nentries) */
-    } /* for (index = 0; index < nentries; ) */
-    ASSERT(len == 0);
+	for (index = 0; index < nentries; ) {
+		__psint_t	ptr;
+		int		log_offset;
+
+		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+						   &contwr, &log_offset);
+		if (error)
+			return error;
+
+		ASSERT(log_offset <= iclog->ic_size - 1);
+		ptr = (__psint_t) ((char *)iclog->ic_datap+log_offset);
+
+		/* start_lsn is the first lsn written to. That's all we need. */
+		if (!*start_lsn)
+			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+
+		/*
+		 * This loop writes out as many regions as can fit in the amount
+		 * of space which was allocated by xlog_state_get_iclog_space().
+		 */
+		while (index < nentries) {
+			struct xlog_op_header	*ophdr;
+			int			start_rec_copy;
+			int			copy_len;
+			int     		copy_off;
+
+			ASSERT(reg[index].i_len % sizeof(__int32_t) == 0);
+			ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
+
+			start_rec_copy = xlog_write_start_rec(ptr, ticket);
+			if (start_rec_copy) {
+				record_cnt++;
+				xlog_write_adv_cnt(ptr, len, log_offset,
+						   start_rec_copy);
+			}
+
+			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
+			if (!ophdr)
+				return XFS_ERROR(EIO);
+
+			xlog_write_adv_cnt(ptr, len, log_offset,
+					   sizeof(struct xlog_op_header));
+
+			len += xlog_write_setup_copy(ticket, ophdr,
+						     iclog->ic_size-log_offset,
+						     reg[index].i_len,
+						     &copy_off, &copy_len,
+						     &partial_copy,
+						     &partial_copy_len);
+			xlog_verify_dest_ptr(log, ptr);
+
+			/* copy region */
+			ASSERT(copy_len >= 0);
+			memcpy((xfs_caddr_t)ptr, reg[index].i_addr + copy_off,
+			       copy_len);
+			xlog_write_adv_cnt(ptr, len, log_offset, copy_len);
+
+			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
+			record_cnt++;
+			data_cnt += contwr ? copy_len : 0;
+
+			error = xlog_write_copy_finish(log, iclog, flags,
+						       &record_cnt, &data_cnt,
+						       &partial_copy,
+						       &partial_copy_len,
+						       log_offset,
+						       commit_iclog);
+			if (error)
+				return error;
+
+			/*
+			 * if we had a partial copy, we need to get more iclog
+			 * space but we don't want to increment the region
+			 * index because there is still more is this region to
+			 * write.
+			 *
+			 * If we completed writing this region, and we flushed
+			 * the iclog (indicated by resetting of the record
+			 * count), then we also need to get more log space. If
+			 * this was the last record, though, we are done and
+			 * can just return.
+			 */
+			if (partial_copy)
+				break;
+
+			index++;
+			if (record_cnt == 0) {
+				if (index == nentries)
+					return 0;
+				break;
+			}
+		}
+	}
+
+	ASSERT(len == 0);
+
+	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
+	if (!commit_iclog)
+		return xlog_state_release_iclog(log, iclog);
 
-    xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
-    if (commit_iclog) {
 	ASSERT(flags & XLOG_COMMIT_TRANS);
 	*commit_iclog = iclog;
 	return 0;
-    }
-    return xlog_state_release_iclog(log, iclog);
-}	/* xlog_write */
+}
 
 
 /*****************************************************************************

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
