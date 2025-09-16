Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0033D307AD7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031008; cv=none; b=apUGC62+XHsqL/3vomTRuQVxSgTdzCnhb9CN6AaIJCjllHH7jS99REyd+6HhkelKQ7pOCecgFYOPvjoea9YoA1WuEnDXsUGWzQzYaiCrTX0HLLxAY8Huvjr2bJKvyn0aWJHLhWQ1YbnWLDgnTRoBRPRM+EdAgIBUJGF9iPnaB80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031008; c=relaxed/simple;
	bh=9PoK2FD0Swf7dGWtdHGRL8NQU9yG4rkRnCDX2EuA/Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Axpy1hekHA4f3ULAdfnw2xp70GwuSlAEm2yxvcJdV/oXcaYlF2hJzYeWknFFp7WyyxKd3MGELeJ5mcKLnGPd2A9/e9Omfq6+rf5T9qeFry1+y84QssLRwrvEDuHFnQFSI6oW+f6z2PRjhVFZ4l/XSRfEEHQPzeh2c9paAuL0Lbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3VwBVbeH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3VwBVbeH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nloGwS0w/hfX7qu5GEcRMUSYufluclYCO6G25MDN41Q=; b=3VwBVbeHF/6a2j8ldGpsrzklm+
	q4VMcjFMDMqRAgeTdZq0TnDrwVOm/bfWDik4O3n3uANmZdFa4nUQIZSVTI7SGTLpzAPrSUS6XcdwB
	jowkVpl1rtkdQnfcZuWiYqGcjU7vlGRpEuVhOl255X1/Dc3vUMPRuTkIlX8buDdRFiH0H1iacYWiD
	eW6heNTmUGYhTggZXrR8LWOIFQD2gqE62wIDFFRDpJMscUwaIS76Pr4hIU8a5HWzVIztxFWjUvBx7
	sXO84pjBoKeIDs2BkWp//4By/P/O0uiOGB9IZ0xNBnN6NVHBChH15z/ZJwEvEjMyJwg6WMaf1SSlY
	ToF4ycqA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyWAo-000000080Uk-2oeR;
	Tue, 16 Sep 2025 13:56:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: add a on-disk log header cycle array accessor
Date: Tue, 16 Sep 2025 06:56:26 -0700
Message-ID: <20250916135646.218644-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250916135646.218644-1-hch@lst.de>
References: <20250916135646.218644-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Accessing the cycle arrays in the original log record header vs the
extended header is messy and duplicated in multiple places.

Add a xlog_cycle_data helper to abstract it out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c         | 63 ++++++++++------------------------------
 fs/xfs/xfs_log_priv.h    | 18 ++++++++++++
 fs/xfs/xfs_log_recover.c | 17 ++---------
 3 files changed, 37 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1cd4e0c1f430..62824d71db5b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1525,18 +1525,13 @@ xlog_pack_data(
 	struct xlog_in_core	*iclog,
 	int			roundoff)
 {
-	int			i, j, k;
-	int			size = iclog->ic_offset + roundoff;
-	__be32			cycle_lsn;
-	char			*dp;
-
-	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
+	struct xlog_rec_header	*rhead = &iclog->ic_header;
+	__be32			cycle_lsn = CYCLE_LSN_DISK(rhead->h_lsn);
+	char			*dp = iclog->ic_datap;
+	int			i;
 
-	dp = iclog->ic_datap;
-	for (i = 0; i < BTOBB(size); i++) {
-		if (i >= XLOG_CYCLE_DATA_SIZE)
-			break;
-		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
+	for (i = 0; i < BTOBB(iclog->ic_offset + roundoff); i++) {
+		*xlog_cycle_data(rhead, i) = *(__be32 *)dp;
 		*(__be32 *)dp = cycle_lsn;
 		dp += BBSIZE;
 	}
@@ -1544,14 +1539,6 @@ xlog_pack_data(
 	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = iclog->ic_data;
 
-		for ( ; i < BTOBB(size); i++) {
-			j = i / XLOG_CYCLE_DATA_SIZE;
-			k = i % XLOG_CYCLE_DATA_SIZE;
-			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
-			*(__be32 *)dp = cycle_lsn;
-			dp += BBSIZE;
-		}
-
 		for (i = 1; i < log->l_iclog_heads; i++)
 			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
 	}
@@ -3323,13 +3310,12 @@ xlog_verify_iclog(
 	struct xlog_in_core	*iclog,
 	int			count)
 {
-	struct xlog_op_header	*ophead;
+	struct xlog_rec_header	*rhead = &iclog->ic_header;
 	xlog_in_core_t		*icptr;
-	xlog_in_core_2_t	*xhdr;
-	void			*base_ptr, *ptr, *p;
+	void			*base_ptr, *ptr;
 	ptrdiff_t		field_offset;
 	uint8_t			clientid;
-	int			len, i, j, k, op_len;
+	int			len, i, op_len;
 	int			idx;
 
 	/* check validity of iclog pointers */
@@ -3343,11 +3329,10 @@ xlog_verify_iclog(
 	spin_unlock(&log->l_icloglock);
 
 	/* check log magic numbers */
-	if (iclog->ic_header.h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
+	if (rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 		xfs_emerg(log->l_mp, "%s: invalid magic num", __func__);
 
-	base_ptr = ptr = &iclog->ic_header;
-	p = &iclog->ic_header;
+	base_ptr = ptr = rhead;
 	for (ptr += BBSIZE; ptr < base_ptr + count; ptr += BBSIZE) {
 		if (*(__be32 *)ptr == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			xfs_emerg(log->l_mp, "%s: unexpected magic num",
@@ -3355,29 +3340,19 @@ xlog_verify_iclog(
 	}
 
 	/* check fields */
-	len = be32_to_cpu(iclog->ic_header.h_num_logops);
+	len = be32_to_cpu(rhead->h_num_logops);
 	base_ptr = ptr = iclog->ic_datap;
-	ophead = ptr;
-	xhdr = iclog->ic_data;
 	for (i = 0; i < len; i++) {
-		ophead = ptr;
+		struct xlog_op_header	*ophead = ptr;
+		void			*p = &ophead->oh_clientid;
 
 		/* clientid is only 1 byte */
-		p = &ophead->oh_clientid;
 		field_offset = p - base_ptr;
 		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
-			if (idx >= XLOG_CYCLE_DATA_SIZE) {
-				j = idx / XLOG_CYCLE_DATA_SIZE;
-				k = idx % XLOG_CYCLE_DATA_SIZE;
-				clientid = xlog_get_client_id(
-					xhdr[j].hic_xheader.xh_cycle_data[k]);
-			} else {
-				clientid = xlog_get_client_id(
-					iclog->ic_header.h_cycle_data[idx]);
-			}
+			clientid = xlog_get_client_id(*xlog_cycle_data(rhead, idx));
 		}
 		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG) {
 			xfs_warn(log->l_mp,
@@ -3393,13 +3368,7 @@ xlog_verify_iclog(
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
 			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
-			if (idx >= XLOG_CYCLE_DATA_SIZE) {
-				j = idx / XLOG_CYCLE_DATA_SIZE;
-				k = idx % XLOG_CYCLE_DATA_SIZE;
-				op_len = be32_to_cpu(xhdr[j].hic_xheader.xh_cycle_data[k]);
-			} else {
-				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
-			}
+			op_len = be32_to_cpu(*xlog_cycle_data(rhead, idx));
 		}
 		ptr += sizeof(struct xlog_op_header) + op_len;
 	}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0cfc654d8e87..d2f17691ecca 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -711,4 +711,22 @@ xlog_item_space(
 	return round_up(nbytes, sizeof(uint64_t));
 }
 
+/*
+ * Cycles over XLOG_CYCLE_DATA_SIZE overflow into the extended header that was
+ * added for v2 logs.  Addressing for the cycles array there is off by one,
+ * because the first batch of cycles is in the original header.
+ */
+static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
+{
+	if (i >= XLOG_CYCLE_DATA_SIZE) {
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
+		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
+		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
+
+		return &xhdr[j].hic_xheader.xh_cycle_data[k];
+	}
+
+	return &rhead->h_cycle_data[i];
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bb2b3f976deb..ef0f6efc4381 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2863,23 +2863,12 @@ xlog_unpack_data(
 	char			*dp,
 	struct xlog		*log)
 {
-	int			i, j, k;
+	int			i;
 
-	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
-		  i < XLOG_CYCLE_DATA_SIZE; i++) {
-		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
+	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
+		*(__be32 *)dp = *xlog_cycle_data(rhead, i);
 		dp += BBSIZE;
 	}
-
-	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
-		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
-			j = i / XLOG_CYCLE_DATA_SIZE;
-			k = i % XLOG_CYCLE_DATA_SIZE;
-			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
-			dp += BBSIZE;
-		}
-	}
 }
 
 /*
-- 
2.47.2

