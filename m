Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617925;
	b=TdjRJx1RPBSQoN07y2CP3PT9GkkPMsSkxoh2R6ekGHHOb4szhI4naFORvK9sZxyFJQID
	 E67GuqQtQZ2vSbrFLqjwpQ+swXjdya0SRimDEwbbVfFaX2M0yaCZDQNpyvEFLqJSdY5Le
	 cI8dLrQf0FVNonbT04dAv0I/pgyNpoA561lzNfpP9nILZ2cbyVGt8DWUkslZpIFTrYZ42
	 aqKR2BIs/VzaXbIunW7P4qSDU9cptTxPZ7hW4fcwZSXMXGq4NezmZUxsd6Uavr3j7CTsg
	 h3q1qVeigGy5fOunfVX5eRC/I3JltVPWed3II2OsCBjHGPYo2GtQJE31K8nPM6Gjd7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617925;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=fSROBoSboG1UC7B9I/H8h8f2MVEOVbBzhZ4XW/0ZMwU=;
	b=e0FOc0cGEkfGtwXZNYsas9cYqeX4h6NSNiMY3TP0zEypO/gu+EZM4qs71UN82qqjpbtY
	 WtXwXnrMs7MuW1dBCbsJq9mTuvDGg3TE98AaeGfKJC382T++1Dh0W0VnxNIsCb4ZMIBRX
	 A7yQ2/Aqha/PnJe8TIkBZjgAPQxi67pbU6ofulXKgred2ZP4ZKbXSD3daOx8v/5tE2jHe
	 BoT4UkYfOnpgHjiAFbbyo1lpRH/zKoCMcdK0m1E8QKkY4SdAWkGndDx0R4ZYGbjfv9N0R
	 mSJTQsqPWqqd1AFfp65YVA7SwO1dKG2sdzc9teRp6Xe1Iq/ufnm3Mt+rjGnJYJDnDyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=2+NZdEe1;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6284B606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6284B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=2+NZdEe1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fSROBoSboG1UC7B9I/H8h8f2MVEOVbBzhZ4XW/0ZMwU=; b=2+NZdEe1qDKlRnbfhCX/PtQdFw
	dScysckYEcvRvZYrx5Nr6gCMbJ60aPvpAZOlRo3oATwBK2v18abRCmOWwt/U0j9j3dUwuYtcoCy39
	Cz/0bniHObyoTSw/8MYMEQ+LYRPW5LiuYEN/iZj9PBNb0seIOIwFJYdWKS6KRFhzyuuBHtxrDdPAN
	k5/Wf0AondU2KGu2gcHSJabgpdNtZcGLvKPcbcCm4J2oG/AqCuDCZUUtxlmRSL/oZlv2UkgPj9Qjs
	Mb2tqqAqcXEtt0c3fod8ZSAanbjztdsl8zvbv2ph2qql7041Zf0BR900KT8Q/Emi9VnRyw1ikkgXC
	nRc/fx2g==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEFQ-0000000ADxZ-3EQg;
	Wed, 25 Nov 2026 14:45:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: move building the checkpoint header into xlog_cil_write_chain
Date: Wed, 25 Nov 2026 15:42:35 +0100
Message-ID: <20261125144430.728485-15-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125144430.728485-1-hch@lst.de>
References: <20261125144430.728485-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Keeping the building of the checkpoint header log vec inside of
xlog_cil_write_chain nicely contains the life-time of the on-disk
structures to a small section and allows building them at declaration
time without needing the xlog_cil_trans_hdr wrapper structure.

It also reduces code size and matches the flow in xlog_write_one_vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c | 136 +++++++++++++++++++------------------------
 1 file changed, 59 insertions(+), 77 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 541584f7d3b6..490d114bf3e4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1116,23 +1116,72 @@ xlog_cil_order_write(
 }
 
 /*
- * Write out the log vector change now attached to the CIL context. This will
- * write a start record that needs to be strictly ordered in ascending CIL
- * sequence order so that log recovery will always use in-order start LSNs when
- * replaying checkpoints.
+ * Write out the log vector chain now attached to the CIL context.
+ *
+ * This will write a start record that needs to be strictly ordered in ascending
+ * CIL sequence order so that log recovery will always use in-order start LSNs
+ * when replaying checkpoints.
  */
 static int
 xlog_cil_write_chain(
 	struct xfs_cil_ctx	*ctx,
-	uint32_t		chain_len)
+	uint32_t		chain_len,
+	uint32_t		num_iovecs)
 {
-	struct xlog		*log = ctx->cil->xc_log;
+	struct xfs_trans_header	thdr = {
+		.th_magic	= XFS_TRANS_HEADER_MAGIC,
+		.th_type	= XFS_TRANS_CHECKPOINT,
+		.th_tid		= ctx->ticket->t_tid,
+		.th_num_items	= num_iovecs,
+	};
+	struct xfs_log_iovec	lhdr[2] = {
+		{
+			/* Log start record */
+			.i_type	= XLOG_REG_TYPE_LRHEADER,
+		},
+		{
+			/* Transaction header */
+			.i_addr	= &thdr,
+			.i_len	= sizeof(thdr),
+			.i_type	= XLOG_REG_TYPE_TRANSHDR,
+		},
+	};
+	struct xfs_log_vec	lvhdr = {
+		.lv_niovecs	= ARRAY_SIZE(lhdr),
+		.lv_iovecp	= lhdr,
+
+	};
+	int			len = xfs_log_vec_bytes(&lvhdr);
 	int			error;
 
+	/*
+	 * Build a checkpoint transaction header and write it to the log before
+	 * the chain of changed log item to begin the transaction.
+	 *
+	 * This is the only place we write a transaction header, so we also wrap
+	 * the transaction header. We keep the start record in it's own log
+	 * vector rather than compacting them into a single region as this ends
+	 * up making the logic in xlog_write() for handling empty regions for
+	 * start, commit and unmount records much simpler.
+	 *
+	 * We need to account for the space used by the transaction header here
+	 * as it is not accounted for in xlog_write().
+	 */
+	list_add(&lvhdr.lv_list, &ctx->lv_chain);
+	chain_len += len;
+	ctx->ticket->t_curr_res -= len;
+
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
-	if (error)
-		return error;
-	return xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket, chain_len);
+	if (!error)
+		error = xlog_write(ctx->cil->xc_log, ctx, &ctx->lv_chain,
+				ctx->ticket, chain_len);
+
+	/*
+	 * Take the lvhdr back off the lv_chain immediately after writing to the
+	 * log as it should not be passed to log I/O completion.
+	 */
+	list_del(&lvhdr.lv_list);
+	return error;
 }
 
 /*
@@ -1163,55 +1212,6 @@ xlog_cil_write_commit_record(
 	return error;
 }
 
-struct xlog_cil_trans_hdr {
-	struct xfs_trans_header	thdr;
-	struct xfs_log_iovec	lhdr[2];
-};
-
-/*
- * Build a checkpoint transaction header to begin the journal transaction.  We
- * need to account for the space used by the transaction header here as it is
- * not accounted for in xlog_write().
- *
- * This is the only place we write a transaction header, so we also wrap the
- * transaction header. We keep the start record in it's own log vector rather
- * than compacting them into a single region as this ends up making the logic
- * in xlog_write() for handling empty opheaders for start, commit and unmount
- * records much simpler.
- */
-static int
-xlog_cil_build_trans_hdr(
-	struct xfs_cil_ctx	*ctx,
-	struct xlog_cil_trans_hdr *hdr,
-	struct xfs_log_vec	*lvhdr,
-	int			num_iovecs)
-{
-	struct xlog_ticket	*tic = ctx->ticket;
-	int			len;
-
-	memset(hdr, 0, sizeof(*hdr));
-
-	/* Log start record */
-	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
-
-	/* transaction header in host byte order format */
-	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
-	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
-	hdr->thdr.th_tid = tic->t_tid;
-	hdr->thdr.th_num_items = num_iovecs;
-
-	hdr->lhdr[1].i_addr = &hdr->thdr;
-	hdr->lhdr[1].i_len = sizeof(struct xfs_trans_header);
-	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
-
-	lvhdr->lv_niovecs = 2;
-	lvhdr->lv_iovecp = &hdr->lhdr[0];
-
-	len = xfs_log_vec_bytes(lvhdr);
-	tic->t_curr_res -= len;
-	return len;
-}
-
 /*
  * CIL item reordering compare function. We want to order in ascending ID order,
  * but we want to leave items with the same ID in the order they were added to
@@ -1322,8 +1322,6 @@ xlog_cil_push_work(
 	int			num_iovecs = 0;
 	int			num_bytes = 0;
 	int			error = 0;
-	struct xlog_cil_trans_hdr thdr;
-	struct xfs_log_vec	lvhdr = {};
 	xfs_csn_t		push_seq;
 	bool			push_commit_stable;
 	LIST_HEAD		(whiteouts);
@@ -1437,23 +1435,7 @@ xlog_cil_push_work(
 	 */
 	list_sort(NULL, &ctx->lv_chain, xlog_cil_order_cmp);
 
-	/*
-	 * Build a checkpoint transaction header and write it to the log to
-	 * begin the transaction. We need to account for the space used by the
-	 * transaction header here as it is not accounted for in xlog_write().
-	 * Add the lvhdr to the head of the lv chain we pass to xlog_write() so
-	 * it gets written into the iclog first.
-	 */
-	num_bytes += xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
-	list_add(&lvhdr.lv_list, &ctx->lv_chain);
-
-	/*
-	 * Take the lvhdr back off the lv_chain immediately after calling
-	 * xlog_cil_write_chain() as it should not be passed to log IO
-	 * completion.
-	 */
-	error = xlog_cil_write_chain(ctx, num_bytes);
-	list_del(&lvhdr.lv_list);
+	error = xlog_cil_write_chain(ctx, num_bytes, num_iovecs);
 	if (error)
 		goto out_abort_free_ticket;
 
-- 
2.53.0

