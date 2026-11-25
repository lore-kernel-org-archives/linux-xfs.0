Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617894;
	b=R4ftCFsGjE4cgYVIDjcRm/bUZxGmL2qi9rGRZAS4N1xx8ccVQSYf23bZeooZDbxWP6Qg
	 hR8uD82bZMDuDopGdDYIt+vBzmgwJDdRwaxffKTwbEdRRawIOOd8b3DM/2i5tI0ji/Du0
	 V5mlHPvuE4vVYbJJkIurjtd8+5iUX+CjnUp2xVNIudhVy3pESLA9yF5trVmMmFLg5lVZe
	 1htJvaEy9EoDCQIfS+OIAaZIcxo2+b9TzjBWP0AdS/eGojrD1+B6jl1Qg15xpDLSq5f/w
	 A2jJ/i6Zno4T72lpqVUp1KsKt2cd45XhikZR8AnjZMnt5l2E6AYFHs49BxpxA5rydCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617894;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=Lz7jenRQfws7CavNDRlWYgHjYaNITKBtTTRKqoM06ws=;
	b=KaEvKzXAfTYmzNDOvmfCP+oYqaFYj4moW6BJI5BOpBUB/7z++x/lcWVV9ZVqCKP+9INh
	 Qq4eKAKd6xsL5nh1/Eo73ZCmNtEKDBSxNMPnmF3kCWojp1Wn28FPLf8JtoPrdERPqPADV
	 95wiNr7BjF06Pb34edzdmGgk7TWHK04Ctg3Bv8CxcEdr2nqbi6nTRt72Sz7JlxTur3UGm
	 sUmRvEzzR9ps7dchbFGu9/tbkWlH+PzWGhAHBjUswfFqEIyk9KUz4dhLM/iJVsgzAS+aM
	 1UrLrgp4wu11Qv+Z9u+AUNfH3Hz8QWitv1/l4vTpTHkhI1iNA+7iJznJqZnmT0329LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="QmJZe+a/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D417606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D417606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QmJZe+a/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lz7jenRQfws7CavNDRlWYgHjYaNITKBtTTRKqoM06ws=; b=QmJZe+a/yW680egGkVKx9d/3pK
	3Y+SF1lVcDKS0pZgnt2JEzegJ3Ww4MWqCdmdUi4E/zlAIzEcNieZ/ftSYYmuH1Dj/NmyDM/XjK7oH
	Wmeo9LF1Ue1YNJ3nTxy1wKcMwH2e1rIExLRX6TMstesgOjMxKJCFJ9qfsWYaPReJD7buWD0awbN4L
	BF2dsBWQJASU4gPAcKxDgogdTUeIG/PGobz5FxCtdjxplmXMIXuNLgy9/9eeMcvNxpgSE5YWy3W9R
	stZcAVQk6tdF6SeXCv+6UFfNG/WLJHGCC8jf4iT3VElE3Cn9gqAR2KUMTAm9W/LsZ+49V8jZIj/o3
	swni7m/A==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEu-0000000ADop-2dGj;
	Wed, 25 Nov 2026 14:44:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/15] xfs: factor out a xlog_write_region helper
Date: Wed, 25 Nov 2026 15:42:27 +0100
Message-ID: <20261125144430.728485-7-hch@lst.de>
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

Split out the body of the main loop of xlog_write_partial into a
separate function to keep the code compact.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 143 ++++++++++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9c2c02880384..2b4ec63baac5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2094,86 +2094,91 @@ xlog_write_get_more_iclog_space(
 }
 
 /*
- * Write log vectors into a single iclog which is smaller than the current chain
- * length. We write until we cannot fit a full record into the remaining space
- * and then stop. We return the log vector that is to be written that cannot
- * wholly fit in the iclog.
+ * Write a single log vector into one or more iclogs.  If the initial iclog is
+ * smaller than the current chain length, get a new iclog and write a
+ * continuation record.
  */
 static int
-xlog_write_partial(
-	struct xfs_log_vec	*lv,
-	struct xlog_write_data	*data)
+xlog_write_region(
+	struct xlog_write_data	*data,
+	struct xfs_log_iovec	*reg)
 {
-	int			index = 0;
-	uint32_t		rlen;
+	uint32_t		rlen, offset;
 	int			error;
 
-	/* walk the logvec, copying until we run out of space in the iclog */
-	for (index = 0; index < lv->lv_niovecs; index++) {
-		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-		uint32_t		offset;
+	/*
+	 * The first region of a continuation must have a non-zero length,
+	 * otherwise log recovery will just skip over it and start recovering
+	 * from the next opheader it finds.  Because we mark the next opheader
+	 * as a continuation, recovery will then incorrectly add the
+	 * continuation to the previous region and that breaks stuff.
+	 *
+	 * Hence if there isn't space for region data after the opheader, then
+	 * we need to start afresh with a new iclog.
+	 */
+	if (xlog_write_space_left(data) <= sizeof(struct xlog_op_header)) {
+		error = xlog_write_get_more_iclog_space(data);
+		if (error)
+			return error;
+	}
+
+	rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
+
+	xlog_write_ophdr(data, reg, rlen);
+	xlog_write_iovec(data, reg->i_addr, rlen);
 
+	/*
+	 * If we wrote the whole region, move to the next region.
+	 *
+	 * Otherwise we now have a partially written iovec, but it can span
+	 * multiple iclogs so we loop here.  First we release the iclog we
+	 * currently have, then we get a new iclog and add a new opheader.  Then
+	 * we continue copying from where we were until we either complete the
+	 * iovec or fill the iclog. If we complete the iovec, then we increment
+	 * the index and go right back to the top of the outer loop.  If we fill
+	 * the iclog, we run the inner loop again.
+	 *
+	 * This is complicated by the tail of a region using all the space in an
+	 * iclog and hence requiring us to release the iclog and get a new one
+	 * before returning to the outer loop. We must always guarantee that we
+	 * exit this inner loop with at least space for log transaction
+	 * opheaders left in the current iclog, hence we cannot just terminate
+	 * the loop at the end of the of the continuation. So we loop while
+	 * there is no space left in the current iclog, and check for the end of
+	 * the continuation after getting a new iclog.
+	 */
+	for (offset = rlen; offset < reg->i_len; offset += rlen) {
 		/*
-		 * The first region of a continuation must have a non-zero
-		 * length otherwise log recovery will just skip over it and
-		 * start recovering from the next opheader it finds. Because we
-		 * mark the next opheader as a continuation, recovery will then
-		 * incorrectly add the continuation to the previous region and
-		 * that breaks stuff.
-		 *
-		 * Hence if there isn't space for region data after the
-		 * opheader, then we need to start afresh with a new iclog.
+		 * Ensure we include the continuation opheader in the space we
+		 * need in the new iclog by adding that size to the length we
+		 * require. This continuation opheader needs to be accounted to
+		 * the ticket as the space it consumes hasn't been accounted to
+		 * the lv we are writing.
 		 */
-		if (xlog_write_space_left(data) <=
-					sizeof(struct xlog_op_header)) {
-			error = xlog_write_get_more_iclog_space(data);
-			if (error)
-				return error;
-		}
+		data->bytes_left += sizeof(struct xlog_op_header);
+		error = xlog_write_get_more_iclog_space(data);
+		if (error)
+			return error;
+		rlen = xlog_write_cont_ophdr(data, reg->i_len - offset);
+		xlog_write_iovec(data, reg->i_addr + offset, rlen);
+	}
 
-		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
+	return 0;
+}
 
-		xlog_write_ophdr(data, reg, rlen);
-		xlog_write_iovec(data, reg->i_addr, rlen);
+static int
+xlog_write_partial(
+	struct xfs_log_vec	*lv,
+	struct xlog_write_data	*data)
+{
+	int			index;
 
-		/*
-		 * If we wrote the whole region, move to the next region.
-		 *
-		 * Otherwise we now have a partially written iovec, but it can
-		 * span multiple iclogs so we loop here. First we release the
-		 * iclog we currently have, then we get a new iclog and add a
-		 * new opheader. Then we continue copying from where we were
-		 * until we either complete the iovec or fill the iclog. If we
-		 * complete the iovec, then we increment the index and go right
-		 * back to the top of the outer loop. if we fill the iclog, we
-		 * run the inner loop again.
-		 *
-		 * This is complicated by the tail of a region using all the
-		 * space in an iclog and hence requiring us to release the iclog
-		 * and get a new one before returning to the outer loop. We must
-		 * always guarantee that we exit this inner loop with at least
-		 * space for log transaction opheaders left in the current
-		 * iclog, hence we cannot just terminate the loop at the end
-		 * of the of the continuation. So we loop while there is no
-		 * space left in the current iclog, and check for the end of the
-		 * continuation after getting a new iclog.
-		 */
-		for (offset = rlen; offset < reg->i_len; offset += rlen) {
-			/*
-			 * Ensure we include the continuation opheader in the
-			 * space we need in the new iclog by adding that size
-			 * to the length we require. This continuation opheader
-			 * needs to be accounted to the ticket as the space it
-			 * consumes hasn't been accounted to the lv we are
-			 * writing.
-			 */
-			data->bytes_left += sizeof(struct xlog_op_header);
-			error = xlog_write_get_more_iclog_space(data);
-			if (error)
-				return error;
-			rlen = xlog_write_cont_ophdr(data, reg->i_len - offset);
-			xlog_write_iovec(data, reg->i_addr + offset, rlen);
-		}
+	for (index = 0; index < lv->lv_niovecs; index++) {
+		int			error;
+
+		error = xlog_write_region(data, &lv->lv_iovecp[index]);
+		if (error)
+			return error;
 	}
 
 	return 0;
-- 
2.53.0

