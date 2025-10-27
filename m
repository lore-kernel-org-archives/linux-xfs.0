Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE3F2F5B
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548784; cv=none; b=JVWOpQ6EDYG44vpkFdoJx7kKRx3GwT2lJ7E/zjjpv3bAv2/k1VBN4FB9kZl4opLstRpEvUHh8HwwgCUaYDHriQ0EERFCEoFmcwgdBYPDtvRv60F2Wo6b6rz+LDKtaM8cY/xrkFfcl1vsoffeehvENOg/hFkCC2t39ey7OEO2pc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548784; c=relaxed/simple;
	bh=KmY8ZoZ5pM5vjnH/duDuY7FHtWOTb46z4XGkevSvfFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3mCuUsmit6sWsEUX30SsQZMJykI8gbsRUIqy76FLRnnsBcwrL21GrhTTHuVANNxN27cdI/9DXov9dXGkSLZXUqmMFojVRhRDRWb38f7j2lYNKYWYq2hBrog+e9g4703N0BlxPQx3R9nrid4f1JhiMp2Y48dB1ALFpramPHK+7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OMX/T2cz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OMX/T2cz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pUnSFgcaJ6V+S4WujGj4lIP9DaaIjJorDUoJQW/9neI=; b=OMX/T2czphYAJLWIU/4aaU26Kg
	3auSwsUKJLipC6kS25Uj4G9OqQ3iE6zHa8PjuxH7WpRXVTN5VGEqQaT6wxVhRqqvcKelIYJl13pck
	w/BoDMaTNtxy1/Cs1MDaMDttQniO2awldBoAQ658P5XAyTWolDp0TgGDmZX/AZcvCoKO2yKdvEUh7
	wmeUeZxAnKNHx6nSnIXFsH16HBhu6Xh+6dYDYdafk6eAKl3bHRxZQPULwpVcm1SMDbQQQ+5bAUxWy
	HRKIBcc+9k+s7yq6Zz/hhPuygACVLIul/bgzU1Xq7JpxilhkIIfl6P9ABlTwZM1L0Svg4exX/bZ5Y
	SvSlyxkw==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHJ7-0000000DFg6-22o1;
	Mon, 27 Oct 2025 07:06:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 3/9] xfs: don't use xlog_in_core_2_t in struct xlog_in_core
Date: Mon, 27 Oct 2025 08:05:50 +0100
Message-ID: <20251027070610.729960-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Most accessed to the on-disk log record header are for the original
xlog_rec_header.  Make that the main structure, and case for the
single remaining place using other union legs.

This prepares for removing xlog_in_core_2_t entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 74 +++++++++++++++++++++----------------------
 fs/xfs/xfs_log_cil.c  |  6 ++--
 fs/xfs/xfs_log_priv.h |  9 ++----
 fs/xfs/xfs_trace.h    |  2 +-
 4 files changed, 44 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a569a4320a3a..d9476124def6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -534,8 +534,8 @@ xlog_state_release_iclog(
 	 */
 	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
-	    !iclog->ic_header.h_tail_lsn) {
-		iclog->ic_header.h_tail_lsn =
+	    !iclog->ic_header->h_tail_lsn) {
+		iclog->ic_header->h_tail_lsn =
 				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
 	}
 
@@ -1457,11 +1457,11 @@ xlog_alloc_log(
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
-		iclog->ic_data = kvzalloc(log->l_iclog_size,
+		iclog->ic_header = kvzalloc(log->l_iclog_size,
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
-		if (!iclog->ic_data)
+		if (!iclog->ic_header)
 			goto out_free_iclog;
-		head = &iclog->ic_header;
+		head = iclog->ic_header;
 		memset(head, 0, sizeof(xlog_rec_header_t));
 		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 		head->h_version = cpu_to_be32(
@@ -1476,7 +1476,7 @@ xlog_alloc_log(
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
 		INIT_LIST_HEAD(&iclog->ic_callbacks);
-		iclog->ic_datap = (void *)iclog->ic_data + log->l_iclog_hsize;
+		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
@@ -1504,7 +1504,7 @@ xlog_alloc_log(
 out_free_iclog:
 	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
 		prev_iclog = iclog->ic_next;
-		kvfree(iclog->ic_data);
+		kvfree(iclog->ic_header);
 		kfree(iclog);
 		if (prev_iclog == log->l_iclog)
 			break;
@@ -1524,7 +1524,7 @@ xlog_pack_data(
 	struct xlog_in_core	*iclog,
 	int			roundoff)
 {
-	struct xlog_rec_header	*rhead = &iclog->ic_header;
+	struct xlog_rec_header	*rhead = iclog->ic_header;
 	__be32			cycle_lsn = CYCLE_LSN_DISK(rhead->h_lsn);
 	char			*dp = iclog->ic_datap;
 	int			i;
@@ -1536,7 +1536,7 @@ xlog_pack_data(
 	}
 
 	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = iclog->ic_data;
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)iclog->ic_header;
 
 		for (i = 1; i < log->l_iclog_heads; i++)
 			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
@@ -1658,11 +1658,11 @@ xlog_write_iclog(
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (is_vmalloc_addr(iclog->ic_data)) {
-		if (!bio_add_vmalloc(&iclog->ic_bio, iclog->ic_data, count))
+	if (is_vmalloc_addr(iclog->ic_header)) {
+		if (!bio_add_vmalloc(&iclog->ic_bio, iclog->ic_header, count))
 			goto shutdown;
 	} else {
-		bio_add_virt_nofail(&iclog->ic_bio, iclog->ic_data, count);
+		bio_add_virt_nofail(&iclog->ic_bio, iclog->ic_header, count);
 	}
 
 	/*
@@ -1791,19 +1791,19 @@ xlog_sync(
 	size = iclog->ic_offset;
 	if (xfs_has_logv2(log->l_mp))
 		size += roundoff;
-	iclog->ic_header.h_len = cpu_to_be32(size);
+	iclog->ic_header->h_len = cpu_to_be32(size);
 
 	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
-	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
+	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header->h_lsn));
 
 	/* Do we need to split this write into 2 parts? */
 	if (bno + BTOBB(count) > log->l_logBBsize)
-		xlog_split_iclog(log, &iclog->ic_header, bno, count);
+		xlog_split_iclog(log, iclog->ic_header, bno, count);
 
 	/* calculcate the checksum */
-	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
+	iclog->ic_header->h_crc = xlog_cksum(log, iclog->ic_header,
 			iclog->ic_datap, XLOG_REC_SIZE, size);
 	/*
 	 * Intentionally corrupt the log record CRC based on the error injection
@@ -1814,11 +1814,11 @@ xlog_sync(
 	 */
 #ifdef DEBUG
 	if (XFS_TEST_ERROR(log->l_mp, XFS_ERRTAG_LOG_BAD_CRC)) {
-		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
+		iclog->ic_header->h_crc &= cpu_to_le32(0xAAAAAAAA);
 		iclog->ic_fail_crc = true;
 		xfs_warn(log->l_mp,
 	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
-			 be64_to_cpu(iclog->ic_header.h_lsn));
+			 be64_to_cpu(iclog->ic_header->h_lsn));
 	}
 #endif
 	xlog_verify_iclog(log, iclog, count);
@@ -1845,7 +1845,7 @@ xlog_dealloc_log(
 	iclog = log->l_iclog;
 	for (i = 0; i < log->l_iclog_bufs; i++) {
 		next_iclog = iclog->ic_next;
-		kvfree(iclog->ic_data);
+		kvfree(iclog->ic_header);
 		kfree(iclog);
 		iclog = next_iclog;
 	}
@@ -1867,7 +1867,7 @@ xlog_state_finish_copy(
 {
 	lockdep_assert_held(&log->l_icloglock);
 
-	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
+	be32_add_cpu(&iclog->ic_header->h_num_logops, record_cnt);
 	iclog->ic_offset += copy_bytes;
 }
 
@@ -2290,7 +2290,7 @@ xlog_state_activate_iclog(
 	 * We don't need to cover the dummy.
 	 */
 	if (*iclogs_changed == 0 &&
-	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
+	    iclog->ic_header->h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
 		*iclogs_changed = 1;
 	} else {
 		/*
@@ -2302,11 +2302,11 @@ xlog_state_activate_iclog(
 
 	iclog->ic_state	= XLOG_STATE_ACTIVE;
 	iclog->ic_offset = 0;
-	iclog->ic_header.h_num_logops = 0;
-	memset(iclog->ic_header.h_cycle_data, 0,
-		sizeof(iclog->ic_header.h_cycle_data));
-	iclog->ic_header.h_lsn = 0;
-	iclog->ic_header.h_tail_lsn = 0;
+	iclog->ic_header->h_num_logops = 0;
+	memset(iclog->ic_header->h_cycle_data, 0,
+		sizeof(iclog->ic_header->h_cycle_data));
+	iclog->ic_header->h_lsn = 0;
+	iclog->ic_header->h_tail_lsn = 0;
 }
 
 /*
@@ -2398,7 +2398,7 @@ xlog_get_lowest_lsn(
 		    iclog->ic_state == XLOG_STATE_DIRTY)
 			continue;
 
-		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
 		if ((lsn && !lowest_lsn) || XFS_LSN_CMP(lsn, lowest_lsn) < 0)
 			lowest_lsn = lsn;
 	} while ((iclog = iclog->ic_next) != log->l_iclog);
@@ -2433,7 +2433,7 @@ xlog_state_iodone_process_iclog(
 		 * If this is not the lowest lsn iclog, then we will leave it
 		 * for another completion to process.
 		 */
-		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		header_lsn = be64_to_cpu(iclog->ic_header->h_lsn);
 		lowest_lsn = xlog_get_lowest_lsn(log);
 		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 			return false;
@@ -2616,7 +2616,7 @@ xlog_state_get_iclog_space(
 		goto restart;
 	}
 
-	head = &iclog->ic_header;
+	head = iclog->ic_header;
 
 	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
 	log_offset = iclog->ic_offset;
@@ -2781,7 +2781,7 @@ xlog_state_switch_iclogs(
 	if (!eventual_size)
 		eventual_size = iclog->ic_offset;
 	iclog->ic_state = XLOG_STATE_WANT_SYNC;
-	iclog->ic_header.h_prev_block = cpu_to_be32(log->l_prev_block);
+	iclog->ic_header->h_prev_block = cpu_to_be32(log->l_prev_block);
 	log->l_prev_block = log->l_curr_block;
 	log->l_prev_cycle = log->l_curr_cycle;
 
@@ -2825,7 +2825,7 @@ xlog_force_and_check_iclog(
 	struct xlog_in_core	*iclog,
 	bool			*completed)
 {
-	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
 	int			error;
 
 	*completed = false;
@@ -2837,7 +2837,7 @@ xlog_force_and_check_iclog(
 	 * If the iclog has already been completed and reused the header LSN
 	 * will have been rewritten by completion
 	 */
-	if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
+	if (be64_to_cpu(iclog->ic_header->h_lsn) != lsn)
 		*completed = true;
 	return 0;
 }
@@ -2970,7 +2970,7 @@ xlog_force_lsn(
 		goto out_error;
 
 	iclog = log->l_iclog;
-	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
+	while (be64_to_cpu(iclog->ic_header->h_lsn) != lsn) {
 		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
 		iclog = iclog->ic_next;
 		if (iclog == log->l_iclog)
@@ -3236,7 +3236,7 @@ xlog_verify_dump_tail(
 {
 	xfs_alert(log->l_mp,
 "ran out of log space tail 0x%llx/0x%llx, head lsn 0x%llx, head 0x%x/0x%x, prev head 0x%x/0x%x",
-			iclog ? be64_to_cpu(iclog->ic_header.h_tail_lsn) : -1,
+			iclog ? be64_to_cpu(iclog->ic_header->h_tail_lsn) : -1,
 			atomic64_read(&log->l_tail_lsn),
 			log->l_ailp->ail_head_lsn,
 			log->l_curr_cycle, log->l_curr_block,
@@ -3255,7 +3255,7 @@ xlog_verify_tail_lsn(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
+	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header->h_tail_lsn);
 	int		blocks;
 
 	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
@@ -3309,7 +3309,7 @@ xlog_verify_iclog(
 	struct xlog_in_core	*iclog,
 	int			count)
 {
-	struct xlog_rec_header	*rhead = &iclog->ic_header;
+	struct xlog_rec_header	*rhead = iclog->ic_header;
 	xlog_in_core_t		*icptr;
 	void			*base_ptr, *ptr;
 	ptrdiff_t		field_offset;
@@ -3507,7 +3507,7 @@ xlog_iclogs_empty(
 		/* endianness does not matter here, zero is zero in
 		 * any language.
 		 */
-		if (iclog->ic_header.h_num_logops)
+		if (iclog->ic_header->h_num_logops)
 			return 0;
 		iclog = iclog->ic_next;
 	} while (iclog != log->l_iclog);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f443757e93c2..778ac47adb8c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -940,7 +940,7 @@ xlog_cil_set_ctx_write_state(
 	struct xlog_in_core	*iclog)
 {
 	struct xfs_cil		*cil = ctx->cil;
-	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
 
 	ASSERT(!ctx->commit_lsn);
 	if (!ctx->start_lsn) {
@@ -1458,9 +1458,9 @@ xlog_cil_push_work(
 	 */
 	spin_lock(&log->l_icloglock);
 	if (ctx->start_lsn != ctx->commit_lsn) {
-		xfs_lsn_t	plsn;
+		xfs_lsn_t	plsn = be64_to_cpu(
+			ctx->commit_iclog->ic_prev->ic_header->h_lsn);
 
-		plsn = be64_to_cpu(ctx->commit_iclog->ic_prev->ic_header.h_lsn);
 		if (plsn && XFS_LSN_CMP(plsn, ctx->commit_lsn) < 0) {
 			/*
 			 * Waiting on ic_force_wait orders the completion of
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d2f17691ecca..f1aed6e8f747 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -158,10 +158,8 @@ struct xlog_ticket {
 };
 
 /*
- * - A log record header is 512 bytes.  There is plenty of room to grow the
- *	xlog_rec_header_t into the reserved space.
- * - ic_data follows, so a write to disk can start at the beginning of
- *	the iclog.
+ * In-core log structure.
+ *
  * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
  * - ic_next is the pointer to the next iclog in the ring.
  * - ic_log is a pointer back to the global log structure.
@@ -198,8 +196,7 @@ typedef struct xlog_in_core {
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-	xlog_in_core_2_t	*ic_data;
-#define ic_header	ic_data->hic_header
+	struct xlog_rec_header	*ic_header;
 #ifdef DEBUG
 	bool			ic_fail_crc : 1;
 #endif
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 79b8641880ab..aa3a3870f894 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4934,7 +4934,7 @@ DECLARE_EVENT_CLASS(xlog_iclog_class,
 		__entry->refcount = atomic_read(&iclog->ic_refcnt);
 		__entry->offset = iclog->ic_offset;
 		__entry->flags = iclog->ic_flags;
-		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		__entry->lsn = be64_to_cpu(iclog->ic_header->h_lsn);
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx flags %s caller %pS",
-- 
2.47.3

