Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780221019C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532629; cv=none; b=jxf4+BGUUz8mPhsyhBVuMBzS+i/j7ng/6Kd4OVUe/cNBS44ckHDAeQh+uabKcdeMrRrACw96fQYMVRi2OV5HARFlN18mU3SJfgTB62zfHwfR2aNrODG82bwCviyDVVB7V2X7OKzMfcG8XUTWaW29JPX7uFwkPEVjxHa1LdmytXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532629; c=relaxed/simple;
	bh=5+EO416halFYBkcxiiYdQAGgHCpmTa6T620ESfrBnUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEsZsoSdqfu8ZCMzJO1dHKhGVTvkHsZncChBjWU1+jrG8Dencq8poZDPNF8dVh7fWWq2eAi1VohM27FJdDTGmuphd91qIPPPxqzlmYvbFRqBlMItdPha2brBzOuzFpfnwdVMrCo+K6j6KVf6Qbr1opIqQBl0kfxxtHXaEOM5NAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vKt1jTps; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vKt1jTps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NQWqrupsCF13He2zGYrM4upOjW8tKuyqLa01PE80abI=; b=vKt1jTpsuh9hDKo844NxkGPbLg
	iJ2Zt2iyCfen4/OkCfAI8M4e4GJfCPNgNPk19nV6qSvqs3zbfB4TUQXQI93wfGZoDtzJ4Fqq9zvkQ
	SgxjxrCNMmmoL4Vrq5VHwc68tyoA+fcG0J/UwExp0Rh94OzKySepxbQL9sE8TOXtAw+7hPLCzYqwf
	MR2/OSunLRoYk7TfUbD/lW1wlY6cxSEPYbUR6u3nYx0PaIm8VON43fa0/jX86nJ3i4N3TsFXKfTyI
	rzVlSMsp5BVz+XpxsbttSvgN7/lEyy8dIZABa8arCXlYgNhfZZq3foaM1vEZ+H5tQabnCYfzosFEk
	rHhuiFDQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMB-00000005pK5-1IGl;
	Tue, 10 Jun 2025 05:17:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/17] xfs: create ophdrs on the fly in xlog_write
Date: Tue, 10 Jun 2025 07:15:06 +0200
Message-ID: <20250610051644.2052814-10-hch@lst.de>
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

Currently each log iovec starts with an xlog_op_header in the CIL buffer.
This wastes a little bit of memory, but more importantly makes managing
the alignment of the individual log regions rather painful.

But there is almost no information in the op_header that we actually need
keep while the item is in the CIL - the transaction ID gets overwritten
in xlog_write, the length can be derived from i_len in the xfs_log_iovec,
the client_id is set to the same value for all but one caller, leaving
only the values of oh_flags as relevant information.

Add a new i_op field to the xfs_log_vec to encode the flags and the
special oh_clientid value for the unmount record, and instead create the
xlog_op_header on the fly while writing to the iclog.  This in turns
matches what we already do for continuation records, allowing to share
the code to write an op header and a region into iclog in a single
helper.

The in-memory only debug i_flags field is shortened to 16-bits to better
pack this new value.

Note that before this change the i_len field in the xfs_log_iovec used to
include the length of ophdr but now doesn't.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |   8 --
 fs/xfs/xfs_log.c               | 148 ++++++++++++++++-----------------
 fs/xfs/xfs_log.h               |   4 +-
 fs/xfs/xfs_log_cil.c           | 117 +++++++-------------------
 fs/xfs/xfs_log_priv.h          |  15 ++++
 5 files changed, 123 insertions(+), 169 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0d637c276db0..4f12664d1005 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -194,14 +194,6 @@ typedef union xlog_in_core2 {
 	char			hic_sector[XLOG_HEADER_SIZE];
 } xlog_in_core_2_t;
 
-/* not an on-disk structure, but needed by log recovery in userspace */
-typedef struct xfs_log_iovec {
-	void		*i_addr;	/* beginning address of region */
-	int		i_len;		/* length in bytes of region */
-	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
-
-
 /*
  * Transaction Header definitions.
  *
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 621d22328622..223f08a50ca7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -802,7 +802,7 @@ xlog_write_one_vec(
 	struct xfs_log_vec	lv = {
 		.lv_niovecs	= 1,
 		.lv_iovecp	= reg,
-		.lv_bytes	= reg->i_len,
+		.lv_bytes	= sizeof(struct xlog_op_header) + reg->i_len,
 	};
 	LIST_HEAD		(lv_chain);
 
@@ -823,23 +823,14 @@ xlog_write_unmount_record(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	struct  {
-		struct xlog_op_header ophdr;
-		struct xfs_unmount_log_format ulf;
-	} unmount_rec = {
-		.ophdr = {
-			.oh_clientid = XFS_LOG,
-			.oh_tid = cpu_to_be32(ticket->t_tid),
-			.oh_flags = XLOG_UNMOUNT_TRANS,
-		},
-		.ulf = {
-			.magic = XLOG_UNMOUNT_TYPE,
-		},
+	struct xfs_unmount_log_format ulf = {
+		.magic		= XLOG_UNMOUNT_TYPE,
 	};
-	struct xfs_log_iovec reg = {
-		.i_addr = &unmount_rec,
-		.i_len = sizeof(unmount_rec),
-		.i_type = XLOG_REG_TYPE_UNMOUNT,
+	struct xfs_log_iovec	reg = {
+		.i_addr		= &ulf,
+		.i_len		= sizeof(ulf),
+		.i_op		= XLOG_OP_UNMOUNT,
+		.i_type		= XLOG_REG_TYPE_UNMOUNT,
 	};
 
 	return xlog_write_one_vec(log, NULL, &reg, ticket);
@@ -1903,25 +1894,72 @@ xlog_print_trans(
 	}
 }
 
-static inline void
-xlog_write_iovec(
+static void
+xlog_write_region(
+	struct xlog_ticket	*ticket,
 	struct xlog_in_core	*iclog,
 	uint32_t		*log_offset,
-	void			*data,
-	uint32_t		write_len,
+	struct xfs_log_iovec	*reg,
 	int			*bytes_left,
 	uint32_t		*record_cnt,
 	uint32_t		*data_cnt)
 {
+	struct xlog_op_header	*ophdr = iclog->ic_datap + *log_offset;
+	uint32_t		rlen;
+
 	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
 	ASSERT(*log_offset % sizeof(int32_t) == 0);
-	ASSERT(write_len % sizeof(int32_t) == 0);
+	ASSERT(reg->i_len % sizeof(int32_t) == 0);
+
+	*log_offset += sizeof(struct xlog_op_header);
+	if (reg->i_op != XLOG_OP_CONT_TRANS)
+		*bytes_left -= sizeof(struct xlog_op_header);
+	*data_cnt += sizeof(struct xlog_op_header);
+
+	ASSERT(iclog->ic_size - *log_offset > 0);
+	rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
+	if (rlen) {
+		memcpy(iclog->ic_datap + *log_offset, reg->i_addr, rlen);
+		*log_offset += rlen;
+		*bytes_left -= rlen;
+		*data_cnt += rlen;
+		reg->i_addr += rlen;
+		reg->i_len -= rlen;
+	}
+
+	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+	ophdr->oh_len = cpu_to_be32(rlen);
+	ophdr->oh_clientid = XFS_TRANSACTION;
+	ophdr->oh_flags = 0;
+	ophdr->oh_res2 = 0;
+
+	switch (reg->i_op) {
+	case XLOG_OP_TRANS:
+		if (reg->i_len) {
+			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+			reg->i_op = XLOG_OP_CONT_TRANS;
+		}
+		break;
+	case XLOG_OP_CONT_TRANS:
+		ophdr->oh_flags |= XLOG_WAS_CONT_TRANS;
+		if (reg->i_len)
+			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+		else
+			ophdr->oh_flags |= XLOG_END_TRANS;
+		break;
+	case XLOG_OP_UNMOUNT:
+		ophdr->oh_clientid = XFS_LOG;
+		ophdr->oh_flags |= XLOG_UNMOUNT_TRANS;
+		break;
+	case XLOG_OP_START_TRANS:
+		ophdr->oh_flags |= XLOG_START_TRANS;
+		break;
+	case XLOG_OP_COMMIT_TRANS:
+		ophdr->oh_flags |= XLOG_COMMIT_TRANS;
+		break;
+	}
 
-	memcpy(iclog->ic_datap + *log_offset, data, write_len);
-	*log_offset += write_len;
-	*bytes_left -= write_len;
 	(*record_cnt)++;
-	*data_cnt += write_len;
 }
 
 /*
@@ -1948,12 +1986,10 @@ xlog_write_full(
 	 * loop will naturally skip them.
 	 */
 	for (index = 0; index < lv->lv_niovecs; index++) {
-		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-		struct xlog_op_header	*ophdr = reg->i_addr;
-
-		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-		xlog_write_iovec(iclog, log_offset, reg->i_addr,
-				reg->i_len, len, record_cnt, data_cnt);
+		xlog_write_region(ticket, iclog, log_offset,
+				&lv->lv_iovecp[index], len, record_cnt,
+				data_cnt);
+		ASSERT(lv->lv_iovecp[index].i_len == 0);
 	}
 }
 
@@ -2005,15 +2041,12 @@ xlog_write_partial(
 	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
-	struct xlog_op_header	*ophdr;
 	int			index = 0;
-	uint32_t		rlen;
 	int			error;
 
 	/* walk the logvec, copying until we run out of space in the iclog */
 	for (index = 0; index < lv->lv_niovecs; index++) {
 		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-		uint32_t		reg_offset = 0;
 
 		/*
 		 * The first region of a continuation must have a non-zero
@@ -2035,19 +2068,11 @@ xlog_write_partial(
 				return error;
 		}
 
-		ophdr = reg->i_addr;
-		rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
-
-		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
-		if (rlen != reg->i_len)
-			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
-
-		xlog_write_iovec(iclog, log_offset, reg->i_addr,
-				rlen, len, record_cnt, data_cnt);
+		xlog_write_region(ticket, iclog, log_offset, reg, len,
+				record_cnt, data_cnt);
 
 		/* If we wrote the whole region, move to the next. */
-		if (rlen == reg->i_len)
+		if (reg->i_len == 0)
 			continue;
 
 		/*
@@ -2086,35 +2111,10 @@ xlog_write_partial(
 			if (error)
 				return error;
 
-			ophdr = iclog->ic_datap + *log_offset;
-			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-			ophdr->oh_clientid = XFS_TRANSACTION;
-			ophdr->oh_res2 = 0;
-			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
-
+			xlog_write_region(ticket, iclog, log_offset, reg, len,
+					record_cnt, data_cnt);
 			ticket->t_curr_res -= sizeof(struct xlog_op_header);
-			*log_offset += sizeof(struct xlog_op_header);
-			*data_cnt += sizeof(struct xlog_op_header);
-
-			/*
-			 * If rlen fits in the iclog, then end the region
-			 * continuation. Otherwise we're going around again.
-			 */
-			reg_offset += rlen;
-			rlen = reg->i_len - reg_offset;
-			if (rlen <= iclog->ic_size - *log_offset)
-				ophdr->oh_flags |= XLOG_END_TRANS;
-			else
-				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
-
-			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
-			ophdr->oh_len = cpu_to_be32(rlen);
-
-			xlog_write_iovec(iclog, log_offset,
-					reg->i_addr + reg_offset,
-					rlen, len, record_cnt, data_cnt);
-
-		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
+		} while (reg->i_len > 0);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e03dbff3ef8e..110f02690f85 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -34,7 +34,7 @@ xlog_calc_iovec_len(int len)
 	return roundup(len, sizeof(uint32_t));
 }
 
-void *xlog_format_start(struct xlog_format_buf *lfb, uint type);
+void *xlog_format_start(struct xlog_format_buf *lfb, uint16_t type);
 void xlog_format_commit(struct xlog_format_buf *lfb, unsigned int data_len);
 
 /*
@@ -43,7 +43,7 @@ void xlog_format_commit(struct xlog_format_buf *lfb, unsigned int data_len);
 static inline void *
 xlog_format_copy(
 	struct xlog_format_buf	*lfb,
-	uint			type,
+	uint16_t		type,
 	void			*data,
 	unsigned int		len)
 {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5a0f80cdfa5a..f8d9e5e93b79 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -301,15 +301,14 @@ xlog_cil_alloc_shadow_bufs(
 		 * the next one is naturally aligned.  We'll need to account for
 		 * that slack space here.
 		 *
-		 * We also add the xlog_op_header to each region when
-		 * formatting, but that's not accounted to the size of the item
-		 * at this point. Hence we'll need an addition number of bytes
-		 * for each vector to hold an opheader.
-		 *
 		 * Then round nbytes up to 64-bit alignment so that the initial
 		 * buffer alignment is easy to calculate and verify.
+		 *
+		 * Note that this does not include the per-iovec ophdr, which only
+		 * exists in the iclog buffer, but not the CIL buffer.
 		 */
-		nbytes = xlog_item_space(niovecs, nbytes);
+		nbytes = round_up(nbytes + niovecs * sizeof(uint64_t),
+				sizeof(uint64_t));
 
 		/*
 		 * The data buffer needs to start 64-bit aligned, so round up
@@ -414,52 +413,20 @@ struct xlog_format_buf {
 	unsigned int		idx;
 };
 
-/*
- * We need to make sure the buffer pointer returned is naturally aligned for the
- * biggest basic data type we put into it. We have already accounted for this
- * padding when sizing the buffer.
- *
- * However, this padding does not get written into the log, and hence we have to
- * track the space used by the log vectors separately to prevent log space hangs
- * due to inaccurate accounting (i.e. a leak) of the used log space through the
- * CIL context ticket.
- *
- * We also add space for the xlog_op_header that describes this region in the
- * log. This prepends the data region we return to the caller to copy their data
- * into, so do all the static initialisation of the ophdr now. Because the ophdr
- * is not 8 byte aligned, we have to be careful to ensure that we align the
- * start of the buffer such that the region we return to the call is 8 byte
- * aligned and packed against the tail of the ophdr.
- */
 void *
 xlog_format_start(
 	struct xlog_format_buf	*lfb,
-	uint			type)
+	uint16_t		type)
 {
 	struct xfs_log_vec	*lv = lfb->lv;
 	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
-	struct xlog_op_header	*oph;
-	uint32_t		len;
-	void			*buf;
+	void			*buf = lv->lv_buf + lv->lv_buf_used;
 
 	ASSERT(lfb->idx < lv->lv_niovecs);
-
-	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
-	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
-		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
-					sizeof(struct xlog_op_header);
-	}
+	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
 
 	vec->i_type = type;
-	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
-
-	oph = vec->i_addr;
-	oph->oh_clientid = XFS_TRANSACTION;
-	oph->oh_res2 = 0;
-	oph->oh_flags = 0;
-
-	buf = vec->i_addr + sizeof(struct xlog_op_header);
-	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
+	vec->i_addr = buf;
 	return buf;
 }
 
@@ -470,36 +437,35 @@ xlog_format_commit(
 {
 	struct xfs_log_vec	*lv = lfb->lv;
 	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
-	struct xlog_op_header	*oph = vec->i_addr;
 	int			len;
 
 	/*
 	 * Always round up the length to the correct alignment so callers don't
 	 * need to know anything about this log vec layout requirement. This
 	 * means we have to zero the area the data to be written does not cover.
-	 * This is complicated by fact the payload region is offset into the
-	 * logvec region by the opheader that tracks the payload.
 	 */
 	len = xlog_calc_iovec_len(data_len);
-	if (len - data_len != 0) {
-		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
-
-		memset(buf + data_len, 0, len - data_len);
-	}
+	if (len - data_len != 0)
+		memset(vec->i_addr + data_len, 0, len - data_len);
 
 	/*
-	 * The opheader tracks aligned payload length, whilst the logvec tracks
-	 * the overall region length.
+	 * We need to make sure the next buffer pointer is naturally aligned for
+	 * the biggest basic data type we put into it. We have already accounted
+	 * for this padding when sizing the buffer.
+	 *
+	 * However, this padding does not get written into the log, and hence we
+	 * have to track the space used by the log vectors separately to prevent
+	 * log space hangs due to inaccurate accounting (i.e. a leak) of the
+	 * used log space through the CIL context ticket.  The used log space
+	 * also needs to account for the op_header that gets added to each
+	 * region.
 	 */
-	oph->oh_len = cpu_to_be32(len);
-
-	len += sizeof(struct xlog_op_header);
-	lv->lv_buf_used += len;
-	lv->lv_bytes += len;
+	lv->lv_buf_used += round_up(len, sizeof(uint64_t));
+	lv->lv_bytes += sizeof(struct xlog_op_header) + len;
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
+	ASSERT((void *)lv->lv_buf + lv->lv_buf_used <=
 		(void *)lv + lv->lv_alloc_size);
 
 	lfb->idx++;
@@ -1184,15 +1150,9 @@ xlog_cil_write_commit_record(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xlog		*log = ctx->cil->xc_log;
-	struct xlog_op_header	ophdr = {
-		.oh_clientid = XFS_TRANSACTION,
-		.oh_tid = cpu_to_be32(ctx->ticket->t_tid),
-		.oh_flags = XLOG_COMMIT_TRANS,
-	};
 	struct xfs_log_iovec	reg = {
-		.i_addr = &ophdr,
-		.i_len = sizeof(struct xlog_op_header),
-		.i_type = XLOG_REG_TYPE_COMMIT,
+		.i_op		= XLOG_OP_COMMIT_TRANS,
+		.i_type		= XLOG_REG_TYPE_COMMIT,
 	};
 	int			error;
 
@@ -1209,7 +1169,6 @@ xlog_cil_write_commit_record(
 }
 
 struct xlog_cil_trans_hdr {
-	struct xlog_op_header	oph[2];
 	struct xfs_trans_header	thdr;
 	struct xfs_log_iovec	lhdr[2];
 };
@@ -1234,25 +1193,13 @@ xlog_cil_build_trans_hdr(
 	int			num_iovecs)
 {
 	struct xlog_ticket	*tic = ctx->ticket;
-	__be32			tid = cpu_to_be32(tic->t_tid);
 
 	memset(hdr, 0, sizeof(*hdr));
 
 	/* Log start record */
-	hdr->oph[0].oh_tid = tid;
-	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
-	hdr->oph[0].oh_flags = XLOG_START_TRANS;
-
-	/* log iovec region pointer */
-	hdr->lhdr[0].i_addr = &hdr->oph[0];
-	hdr->lhdr[0].i_len = sizeof(struct xlog_op_header);
+	hdr->lhdr[0].i_op = XLOG_OP_START_TRANS;
 	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
 
-	/* log opheader */
-	hdr->oph[1].oh_tid = tid;
-	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
-	hdr->oph[1].oh_len = cpu_to_be32(sizeof(struct xfs_trans_header));
-
 	/* transaction header in host byte order format */
 	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
 	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
@@ -1260,14 +1207,14 @@ xlog_cil_build_trans_hdr(
 	hdr->thdr.th_num_items = num_iovecs;
 
 	/* log iovec region pointer */
-	hdr->lhdr[1].i_addr = &hdr->oph[1];
-	hdr->lhdr[1].i_len = sizeof(struct xlog_op_header) +
-				sizeof(struct xfs_trans_header);
+	hdr->lhdr[1].i_addr = &hdr->thdr;
+	hdr->lhdr[1].i_len = sizeof(struct xfs_trans_header);
 	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
 
 	lvhdr->lv_niovecs = 2;
-	lvhdr->lv_iovecp = &hdr->lhdr[0];
-	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
+	lvhdr->lv_iovecp = hdr->lhdr;
+	lvhdr->lv_bytes = 2 * sizeof(struct xlog_op_header) +
+			sizeof(struct xfs_trans_header);
 
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 463daf51da15..17bbe69655a4 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -13,6 +13,21 @@ struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
 
+enum xlog_op_type {
+	XLOG_OP_TRANS		= 0,
+	XLOG_OP_CONT_TRANS,
+	XLOG_OP_START_TRANS,
+	XLOG_OP_COMMIT_TRANS,
+	XLOG_OP_UNMOUNT,
+} __packed;
+
+struct xfs_log_iovec {
+	void			*i_addr;/* beginning address of region */
+	int			i_len;	/* length in bytes of region */
+	enum xlog_op_type	i_op;	/* log operation */
+	uint16_t		i_type;	/* type of region (debug only) */
+};
+
 /*
  * get client id from packed copy.
  *
-- 
2.47.2

