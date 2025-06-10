Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D9F7083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532644; cv=none; b=rZ5zE9piJ84bSDASshsMmL6tEQvyY5Pe5oOx9w9BEZhWmudMU6dZMQiFlcZCO//lkonF7z4fDdKosH46gTsBAeBa2GYwVESQhiIx13qWasQHBtQNoaq/gBCm8OC70nXdwS9lF0gxzd0Y1BBO/+6CnCnwoti1zdh6HKINlM4SSJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532644; c=relaxed/simple;
	bh=eFsEcrn/96GIl3o7kkbvUeZiEHdIioFcrUmvi+ioygg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaA1cnxS8xDRqRk0s9lzXOh6yA1mfZiOdYeKvXoEaHAvIZaMOGw1xQVk7JQSRipiL/iLg0GznOKa3ygbpjHDNdigO59wrmE33jY5vGWzRTurBjFSgnLDHarI3douRTFFc39k9aQiCqMasyAK8ktA1VfMty5DHozCu0x37wonsr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F0yp9AcV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F0yp9AcV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5JdpCehKD3S+cnodCaVgwHcZ65toMaSNGWklpj19Lm4=; b=F0yp9AcVNdaaHH7Mnl3XEpx0gc
	OrchsFUanoEUQyJ7DmXsmytxPhRjVKM2OOinLVCik5g17YnxiFungWL5c0KD6BFQvSoQQ02khUnR8
	TA2pSEcyENZLOcYhGyQO/unMey9JN7ZI1GAynvl4xcoj7cXw3SKGVPtYsmtstQ/b4S2KEMzOgAW0Q
	ju0R8vMjihDAmKY5kSMEOnulXc3JAI+i1JUx714NqYNML/RLP+qJ5OmqoybBU3uDyoe/HLBi5HOsJ
	XBZLLsakM5lknWgIVKNtnOw/fEp396VXGun2dMS4o6RH5pm2VyVMJVGs1jJ5QqyrVyUL9gClALokF
	igaZTbmQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMQ-00000005pMQ-1jUS;
	Tue, 10 Jun 2025 05:17:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/17] xfs: improve argument handling for the xlog_write helpers
Date: Tue, 10 Jun 2025 07:15:10 +0200
Message-ID: <20250610051644.2052814-14-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 171 +++++++++++++++++++----------------------------
 1 file changed, 70 insertions(+), 101 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b72f52ab9521..18316612b16f 100644
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
@@ -1896,37 +1902,33 @@ xlog_print_trans(
 
 static void
 xlog_write_region(
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	*iclog,
-	uint32_t		*log_offset,
-	struct xfs_log_iovec	*reg,
-	int			*bytes_left,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
+	struct xlog_write_data	*data,
+	struct xfs_log_iovec	*reg)
 {
-	struct xlog_op_header	*ophdr = iclog->ic_datap + *log_offset;
+	struct xlog_in_core	*iclog = data->iclog;
+	struct xlog_op_header	*ophdr = iclog->ic_datap + data->log_offset;
 	uint32_t		rlen;
 
-	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
-	ASSERT(*log_offset % sizeof(int32_t) == 0);
+	ASSERT(data->log_offset < iclog->ic_log->l_iclog_size);
+	ASSERT(data->log_offset % sizeof(int32_t) == 0);
 	ASSERT(reg->i_len % sizeof(int32_t) == 0);
 
-	*log_offset += sizeof(struct xlog_op_header);
-	*bytes_left -= sizeof(struct xlog_op_header);
-	*data_cnt += sizeof(struct xlog_op_header);
+	data->log_offset += sizeof(struct xlog_op_header);
+	data->bytes_left -= sizeof(struct xlog_op_header);
+	data->data_cnt += sizeof(struct xlog_op_header);
 
-	ASSERT(iclog->ic_size - *log_offset > 0);
-	rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
+	ASSERT(iclog->ic_size - data->log_offset > 0);
+	rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - data->log_offset);
 	if (rlen) {
-		memcpy(iclog->ic_datap + *log_offset, reg->i_addr, rlen);
-		*log_offset += rlen;
-		*bytes_left -= rlen;
-		*data_cnt += rlen;
+		memcpy(iclog->ic_datap + data->log_offset, reg->i_addr, rlen);
+		data->log_offset += rlen;
+		data->bytes_left -= rlen;
+		data->data_cnt += rlen;
 		reg->i_addr += rlen;
 		reg->i_len -= rlen;
 	}
 
-	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 	ophdr->oh_len = cpu_to_be32(rlen);
 	ophdr->oh_clientid = XFS_TRANSACTION;
 	ophdr->oh_flags = 0;
@@ -1958,37 +1960,30 @@ xlog_write_region(
 		break;
 	}
 
-	(*record_cnt)++;
+	data->record_cnt++;
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
 
@@ -2007,12 +2002,7 @@ xlog_write_get_more_iclog_space(
  */
 static int
 xlog_write_remainder(
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclogp,
-	uint32_t		*log_offset,
-	uint32_t		*len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
+	struct xlog_write_data	*data,
 	struct xfs_log_iovec	*reg)
 {
 	int			error;
@@ -2023,15 +2013,13 @@ xlog_write_remainder(
 	 * continuation opheader needs to be accounted to the ticket as the
 	 * space it consumes hasn't been accounted to the lv we are writing.
 	 */
-	*len += sizeof(struct xlog_op_header);
-	error = xlog_write_get_more_iclog_space(ticket, iclogp, log_offset,
-			*len, record_cnt, data_cnt);
+	data->bytes_left += sizeof(struct xlog_op_header);
+	error = xlog_write_get_more_iclog_space(data);
 	if (error)
 		return error;
 
-	xlog_write_region(ticket, *iclogp, log_offset, reg, len,
-			record_cnt, data_cnt);
-	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	xlog_write_region(data, reg);
+	data->ticket->t_curr_res -= sizeof(struct xlog_op_header);
 	return 0;
 }
 
@@ -2043,15 +2031,9 @@ xlog_write_remainder(
  */
 static int
 xlog_write_vec(
-	struct xfs_log_vec	*lv,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclogp,
-	uint32_t		*log_offset,
-	uint32_t		*len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
+	struct xlog_write_data	*data,
+	struct xfs_log_vec	*lv)
 {
-	struct xlog_in_core	*iclog = *iclogp;
 	int			index = 0;
 
 	/* walk the logvec, copying until we run out of space in the iclog */
@@ -2070,11 +2052,9 @@ xlog_write_vec(
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
@@ -2082,8 +2062,7 @@ xlog_write_vec(
 		/*
 		 * Write the amount that fits into this iclog.
 		 */
-		xlog_write_region(ticket, iclog, log_offset, reg, len,
-				record_cnt, data_cnt);
+		xlog_write_region(data, reg);
 
 		/*
 		 * We now have an at least partially written iovec, but it can
@@ -2091,18 +2070,12 @@ xlog_write_vec(
 		 * complete the iovec.
 		 */
 		while (reg->i_len > 0) {
-			error = xlog_write_remainder(ticket, &iclog, log_offset,
-					len, record_cnt, data_cnt, reg);
+			error = xlog_write_remainder(data, reg);
 			if (error)
 				return error;
 		}
 	}
 
-	/*
-	 * No more iovecs remain in this logvec so return the next log vec to
-	 * the caller so it can go back to fast path copying.
-	 */
-	*iclogp = iclog;
 	return 0;
 }
 
@@ -2155,12 +2128,12 @@ xlog_write(
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
@@ -2169,12 +2142,11 @@ xlog_write(
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
@@ -2182,15 +2154,14 @@ xlog_write(
 	 * ordering.
 	 */
 	if (ctx)
-		xlog_cil_set_ctx_write_state(ctx, iclog);
+		xlog_cil_set_ctx_write_state(ctx, data.iclog);
 
 	list_for_each_entry(lv, lv_chain, lv_list) {
-		error = xlog_write_vec(lv, ticket, &iclog, &log_offset, &len,
-				&record_cnt, &data_cnt);
+		error = xlog_write_vec(&data, lv);
 		if (error)
 			return error;
 	}
-	ASSERT(len == 0);
+	ASSERT(data.bytes_left == 0);
 
 	/*
 	 * We've already been guaranteed that the last writes will fit inside
@@ -2199,8 +2170,8 @@ xlog_write(
 	 * iclog with the number of bytes written here.
 	 */
 	spin_lock(&log->l_icloglock);
-	xlog_state_finish_copy(log, iclog, record_cnt, 0);
-	error = xlog_state_release_iclog(log, iclog, ticket);
+	xlog_state_finish_copy(log, data.iclog, data.record_cnt, 0);
+	error = xlog_state_release_iclog(log, data.iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
@@ -2522,14 +2493,11 @@ xlog_state_done_syncing(
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
-	int			len,
-	struct xlog_in_core	**iclogp,
-	struct xlog_ticket	*ticket,
-	int			*logoffsetp)
+	struct xlog_write_data	*data)
 {
-	int		  log_offset;
-	xlog_rec_header_t *head;
-	xlog_in_core_t	  *iclog;
+	int			log_offset;
+	struct xlog_rec_header	*head;
+	struct xlog_in_core	*iclog;
 
 restart:
 	spin_lock(&log->l_icloglock);
@@ -2560,7 +2528,7 @@ xlog_state_get_iclog_space(
 	 * must be written.
 	 */
 	if (log_offset == 0) {
-		ticket->t_curr_res -= log->l_iclog_hsize;
+		data->ticket->t_curr_res -= log->l_iclog_hsize;
 		head->h_cycle = cpu_to_be32(log->l_curr_cycle);
 		head->h_lsn = cpu_to_be64(
 			xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
@@ -2589,7 +2557,8 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog, ticket);
+			error = xlog_state_release_iclog(log, iclog,
+					data->ticket);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
@@ -2602,16 +2571,16 @@ xlog_state_get_iclog_space(
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
2.47.2

