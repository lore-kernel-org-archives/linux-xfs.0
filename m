Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE16322A13
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949730; cv=none; b=PJwHYIh5zMxndv9U2i78Q7V77HXCFZ3Ux9m8pPN4DlTgxgLUvmJMOfKaxJ8fMg4Dq0Sz6YOQh++f8ZSEaWtgf7VYbCIJRTbxBKXzAZgQ5jJ3hX/328hEfFSuaKghYcTqcRUkzWO/oLbER9j0Q9sHU9VAorXhVNqCL69mVkz5+14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949730; c=relaxed/simple;
	bh=KZBS1K5RFzGO9PTP5OzIouD6+RVA1bT7nky5h7P5n1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNtWjAxXdqQYZ8CgqjyaKp8f1jqPlg2CoVLIpuKOEigp1QtzuJIVFnVJqq5EBysrXCTDHT1Q50d28nrAqGE/Mh7YxSnT/QWp/v7RAt9tyA94mnj4jAr/zkus9jzfYIMdgibdUNGp1w794pTcwVfCbgtdS8vYKJZBxmRlzn06tx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DD7EKl69; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DD7EKl69"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zCoeN5k0y98orZHwfXccYsamh72QEQlJD3BCITddLQ8=; b=DD7EKl690fYklv86IA6YWkA5bo
	rxLqI3+0c1wLqCmJS1LKQqpscNs2q+LtOi8GJqL2MH9AwZdR/ncilY1MVRPtl7dzhyxYRYVGP3dPu
	lVncmtGxX9Q2BRYskpOp1teFPN9DSaAc9Vf2FfaFYjAWrP67zkIWiS8pmwVv2b+1KsPWZrRGWQyB9
	+G1S/65y8aX2V0fFKfsRs0f3AOsroTVMyy8kjlsYrkZwtkeAJrWZcdXCG25jNGZfXRTHNsagyPrgK
	vGi3Z56c+lPzQyn901rbzNrMgxlwMlF08uvaDOv7/Heqb/UVl7Vyitp+vEheYFqe58jaHhRiPiiAK
	nPhmpBjA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9l2-00000008lDi-13I4;
	Wed, 12 Nov 2025 12:15:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] xfs: improve the calling convention for the xlog_write helpers
Date: Wed, 12 Nov 2025 13:14:23 +0100
Message-ID: <20251112121458.915383-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xlog_write chain passes around the same seven variables that are
often passed by reference. Add a xlog_write_data structure to contain
them to improve code generation and readability.

This change increases the generated code size by about 140 bytes for my
x86_64 build, which is hopefully worth the much easier to follow code:

$ size fs/xfs/xfs_log.o*
   text	   data	    bss	    dec	    hex	filename
  29300	   1730	    176	  31206	   79e6	fs/xfs/xfs_log.o
  29160	   1730	    176	  31066	   795a	fs/xfs/xfs_log.o.old

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 187 +++++++++++++++++++----------------------------
 1 file changed, 77 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 539b22dff2d1..2b1744af8a67 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -22,6 +22,15 @@
 #include "xfs_health.h"
 #include "xfs_zone_alloc.h"
 
+struct xlog_write_data {
+	struct xlog_ticket	*ticket;
+	struct xlog_in_core	*iclog;
+	uint32_t		bytes_left;
+	uint32_t		record_cnt;
+	uint32_t		data_cnt;
+	int			log_offset;
+};
+
 struct kmem_cache	*xfs_log_ticket_cache;
 
 /* Local miscellaneous function prototypes */
@@ -43,10 +52,7 @@ STATIC void xlog_state_do_callback(
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
-	int			len,
-	struct xlog_in_core	**iclog,
-	struct xlog_ticket	*ticket,
-	int			*logoffsetp);
+	struct xlog_write_data	*data);
 STATIC void
 xlog_sync(
 	struct xlog		*log,
@@ -1874,23 +1880,19 @@ xlog_print_trans(
 
 static inline void
 xlog_write_iovec(
-	struct xlog_in_core	*iclog,
-	uint32_t		*log_offset,
-	void			*data,
-	uint32_t		write_len,
-	int			*bytes_left,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
+	struct xlog_write_data	*data,
+	void			*buf,
+	uint32_t		buf_len)
 {
-	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
-	ASSERT(*log_offset % sizeof(int32_t) == 0);
-	ASSERT(write_len % sizeof(int32_t) == 0);
+	ASSERT(data->log_offset < data->iclog->ic_log->l_iclog_size);
+	ASSERT(data->log_offset % sizeof(int32_t) == 0);
+	ASSERT(buf_len % sizeof(int32_t) == 0);
 
-	memcpy(iclog->ic_datap + *log_offset, data, write_len);
-	*log_offset += write_len;
-	*bytes_left -= write_len;
-	(*record_cnt)++;
-	*data_cnt += write_len;
+	memcpy(data->iclog->ic_datap + data->log_offset, buf, buf_len);
+	data->log_offset += buf_len;
+	data->bytes_left -= buf_len;
+	data->record_cnt++;
+	data->data_cnt += buf_len;
 }
 
 /*
@@ -1900,17 +1902,12 @@ xlog_write_iovec(
 static void
 xlog_write_full(
 	struct xfs_log_vec	*lv,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	*iclog,
-	uint32_t		*log_offset,
-	uint32_t		*len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
+	struct xlog_write_data	*data)
 {
 	int			index;
 
-	ASSERT(*log_offset + *len <= iclog->ic_size ||
-		iclog->ic_state == XLOG_STATE_WANT_SYNC);
+	ASSERT(data->log_offset + data->bytes_left <= data->iclog->ic_size ||
+		data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	/*
 	 * Ordered log vectors have no regions to write so this
@@ -1920,40 +1917,32 @@ xlog_write_full(
 		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
 		struct xlog_op_header	*ophdr = reg->i_addr;
 
-		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-		xlog_write_iovec(iclog, log_offset, reg->i_addr,
-				reg->i_len, len, record_cnt, data_cnt);
+		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
+		xlog_write_iovec(data, reg->i_addr, reg->i_len);
 	}
 }
 
 static int
 xlog_write_get_more_iclog_space(
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclogp,
-	uint32_t		*log_offset,
-	uint32_t		len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
+	struct xlog_write_data	*data)
 {
-	struct xlog_in_core	*iclog = *iclogp;
-	struct xlog		*log = iclog->ic_log;
+	struct xlog		*log = data->iclog->ic_log;
 	int			error;
 
 	spin_lock(&log->l_icloglock);
-	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
-	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-	error = xlog_state_release_iclog(log, iclog, ticket);
+	ASSERT(data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
+	xlog_state_finish_copy(log, data->iclog, data->record_cnt,
+			data->data_cnt);
+	error = xlog_state_release_iclog(log, data->iclog, data->ticket);
 	spin_unlock(&log->l_icloglock);
 	if (error)
 		return error;
 
-	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					log_offset);
+	error = xlog_state_get_iclog_space(log, data);
 	if (error)
 		return error;
-	*record_cnt = 0;
-	*data_cnt = 0;
-	*iclogp = iclog;
+	data->record_cnt = 0;
+	data->data_cnt = 0;
 	return 0;
 }
 
@@ -1966,14 +1955,8 @@ xlog_write_get_more_iclog_space(
 static int
 xlog_write_partial(
 	struct xfs_log_vec	*lv,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclogp,
-	uint32_t		*log_offset,
-	uint32_t		*len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
+	struct xlog_write_data	*data)
 {
-	struct xlog_in_core	*iclog = *iclogp;
 	struct xlog_op_header	*ophdr;
 	int			index = 0;
 	uint32_t		rlen;
@@ -1995,25 +1978,23 @@ xlog_write_partial(
 		 * Hence if there isn't space for region data after the
 		 * opheader, then we need to start afresh with a new iclog.
 		 */
-		if (iclog->ic_size - *log_offset <=
+		if (data->iclog->ic_size - data->log_offset <=
 					sizeof(struct xlog_op_header)) {
-			error = xlog_write_get_more_iclog_space(ticket,
-					&iclog, log_offset, *len, record_cnt,
-					data_cnt);
+			error = xlog_write_get_more_iclog_space(data);
 			if (error)
 				return error;
 		}
 
 		ophdr = reg->i_addr;
-		rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
+		rlen = min_t(uint32_t, reg->i_len,
+			data->iclog->ic_size - data->log_offset);
 
-		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
 		if (rlen != reg->i_len)
 			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
-		xlog_write_iovec(iclog, log_offset, reg->i_addr,
-				rlen, len, record_cnt, data_cnt);
+		xlog_write_iovec(data, reg->i_addr, rlen);
 
 		/* If we wrote the whole region, move to the next. */
 		if (rlen == reg->i_len)
@@ -2048,23 +2029,22 @@ xlog_write_partial(
 			 * consumes hasn't been accounted to the lv we are
 			 * writing.
 			 */
-			*len += sizeof(struct xlog_op_header);
-			error = xlog_write_get_more_iclog_space(ticket,
-					&iclog, log_offset, *len, record_cnt,
-					data_cnt);
+			data->bytes_left += sizeof(struct xlog_op_header);
+			error = xlog_write_get_more_iclog_space(data);
 			if (error)
 				return error;
 
-			ophdr = iclog->ic_datap + *log_offset;
-			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+			ophdr = data->iclog->ic_datap + data->log_offset;
+			ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 			ophdr->oh_clientid = XFS_TRANSACTION;
 			ophdr->oh_res2 = 0;
 			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
 
-			ticket->t_curr_res -= sizeof(struct xlog_op_header);
-			*log_offset += sizeof(struct xlog_op_header);
-			*data_cnt += sizeof(struct xlog_op_header);
-			*len -= sizeof(struct xlog_op_header);
+			data->ticket->t_curr_res -=
+				sizeof(struct xlog_op_header);
+			data->log_offset += sizeof(struct xlog_op_header);
+			data->data_cnt += sizeof(struct xlog_op_header);
+			data->bytes_left -= sizeof(struct xlog_op_header);
 
 			/*
 			 * If rlen fits in the iclog, then end the region
@@ -2072,26 +2052,19 @@ xlog_write_partial(
 			 */
 			reg_offset += rlen;
 			rlen = reg->i_len - reg_offset;
-			if (rlen <= iclog->ic_size - *log_offset)
+			if (rlen <= data->iclog->ic_size - data->log_offset)
 				ophdr->oh_flags |= XLOG_END_TRANS;
 			else
 				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
-			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
+			rlen = min_t(uint32_t, rlen,
+				data->iclog->ic_size - data->log_offset);
 			ophdr->oh_len = cpu_to_be32(rlen);
 
-			xlog_write_iovec(iclog, log_offset,
-					reg->i_addr + reg_offset,
-					rlen, len, record_cnt, data_cnt);
-
+			xlog_write_iovec(data, reg->i_addr + reg_offset, rlen);
 		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
 	}
 
-	/*
-	 * No more iovecs remain in this logvec so return the next log vec to
-	 * the caller so it can go back to fast path copying.
-	 */
-	*iclogp = iclog;
 	return 0;
 }
 
@@ -2144,12 +2117,12 @@ xlog_write(
 	uint32_t		len)
 
 {
-	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv;
-	uint32_t		record_cnt = 0;
-	uint32_t		data_cnt = 0;
-	int			error = 0;
-	int			log_offset;
+	struct xlog_write_data	data = {
+		.ticket		= ticket,
+		.bytes_left	= len,
+	};
+	int			error;
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2158,12 +2131,11 @@ xlog_write(
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	}
 
-	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					   &log_offset);
+	error = xlog_state_get_iclog_space(log, &data);
 	if (error)
 		return error;
 
-	ASSERT(log_offset <= iclog->ic_size - 1);
+	ASSERT(data.log_offset <= data.iclog->ic_size - 1);
 
 	/*
 	 * If we have a context pointer, pass it the first iclog we are
@@ -2171,7 +2143,7 @@ xlog_write(
 	 * ordering.
 	 */
 	if (ctx)
-		xlog_cil_set_ctx_write_state(ctx, iclog);
+		xlog_cil_set_ctx_write_state(ctx, data.iclog);
 
 	list_for_each_entry(lv, lv_chain, lv_list) {
 		/*
@@ -2179,10 +2151,8 @@ xlog_write(
 		 * the partial copy loop which can handle this case.
 		 */
 		if (lv->lv_niovecs &&
-		    lv->lv_bytes > iclog->ic_size - log_offset) {
-			error = xlog_write_partial(lv, ticket, &iclog,
-					&log_offset, &len, &record_cnt,
-					&data_cnt);
+		    lv->lv_bytes > data.iclog->ic_size - data.log_offset) {
+			error = xlog_write_partial(lv, &data);
 			if (error) {
 				/*
 				 * We have no iclog to release, so just return
@@ -2191,11 +2161,10 @@ xlog_write(
 				return error;
 			}
 		} else {
-			xlog_write_full(lv, ticket, iclog, &log_offset,
-					 &len, &record_cnt, &data_cnt);
+			xlog_write_full(lv, &data);
 		}
 	}
-	ASSERT(len == 0);
+	ASSERT(data.bytes_left == 0);
 
 	/*
 	 * We've already been guaranteed that the last writes will fit inside
@@ -2204,8 +2173,8 @@ xlog_write(
 	 * iclog with the number of bytes written here.
 	 */
 	spin_lock(&log->l_icloglock);
-	xlog_state_finish_copy(log, iclog, record_cnt, 0);
-	error = xlog_state_release_iclog(log, iclog, ticket);
+	xlog_state_finish_copy(log, data.iclog, data.record_cnt, 0);
+	error = xlog_state_release_iclog(log, data.iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
@@ -2527,10 +2496,7 @@ xlog_state_done_syncing(
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
-	int			len,
-	struct xlog_in_core	**iclogp,
-	struct xlog_ticket	*ticket,
-	int			*logoffsetp)
+	struct xlog_write_data	*data)
 {
 	int			log_offset;
 	struct xlog_rec_header	*head;
@@ -2565,7 +2531,7 @@ xlog_state_get_iclog_space(
 	 * must be written.
 	 */
 	if (log_offset == 0) {
-		ticket->t_curr_res -= log->l_iclog_hsize;
+		data->ticket->t_curr_res -= log->l_iclog_hsize;
 		head->h_cycle = cpu_to_be32(log->l_curr_cycle);
 		head->h_lsn = cpu_to_be64(
 			xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
@@ -2595,7 +2561,8 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog, ticket);
+			error = xlog_state_release_iclog(log, iclog,
+					data->ticket);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
@@ -2608,16 +2575,16 @@ xlog_state_get_iclog_space(
 	 * iclogs (to mark it taken), this particular iclog will release/sync
 	 * to disk in xlog_write().
 	 */
-	if (len <= iclog->ic_size - iclog->ic_offset)
-		iclog->ic_offset += len;
+	if (data->bytes_left <= iclog->ic_size - iclog->ic_offset)
+		iclog->ic_offset += data->bytes_left;
 	else
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
-	*iclogp = iclog;
+	data->iclog = iclog;
 
 	ASSERT(iclog->ic_offset <= iclog->ic_size);
 	spin_unlock(&log->l_icloglock);
 
-	*logoffsetp = log_offset;
+	data->log_offset = log_offset;
 	return 0;
 }
 
-- 
2.47.3

