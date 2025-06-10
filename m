Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05A19CC3C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532637; cv=none; b=PqhFEZZtrSqDZCWXW6gYQK4MV56X+hAM0sJjVUSeJq9mMi4PiJG8No4gG6hgFZ5f4ngOtwzA4zhDkM/N/9h/k9N69nNhbSjk4Kj2G3zfXH9cycUkSleKRvtv9s0aLLErYB50no/vxY4ZRcTgjh8x0TBg7gPa6jcD4cNxUG2dwZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532637; c=relaxed/simple;
	bh=igWbx+9fKqH8qjXC1cZXA9vWlpcVq1Uep3KEoJ+q1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnHW6Qf5h7GDZ1no1LvzzvskbgyJ9Z/V7+wVwxSdWPOwpbWdS47A6skxdN28IH67kcGgCx+YkqjbJHjRS8VAaGK+zaQQ5EmM9riyU4F/LejrYNcX5Ea+SYPbnkvNWIt2jTj5JfvB1HszPsdDeO6kLhnyVkkfIBv2Q0Xz4xKc7v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l9MX7eIX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l9MX7eIX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LlM8+C+EvqDI05DTm3f11vGRVB5kilML0ItomZhg2dc=; b=l9MX7eIXXTsjA98uiy0NKBdgZA
	Zjst36L/zwifQwr8L+aN8vtzDbz5tVGEhV9Us/2ntXHfalASlGN5yAXg8vb7zhn0p1dbZRtna00f+
	KTK1vRIkLVltLsp2K+V4QZdWW3IHeuBt9kSsmWJVv8xwDXczTj3zLOGTg8WsdGWOy9mnraFXICDMY
	Ri5b28brH0yeGQuBEtbWUE3Dn4Z4hWZHeI9RJaPiSgx7eMA1P/umn0v5JE05yyYqXYeMxoMTCENK6
	B2ZzAUyZKZwNMG88BrCJLbl0poaqXzjojb/5cOiOUoIOCJQwash33j4zu64skZbA70avsCxwbwQ86
	WjGLQZRg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMJ-00000005pLh-0ixe;
	Tue, 10 Jun 2025 05:17:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/17] xfs: factor the split iclog handling out of xlog_write_partial
Date: Tue, 10 Jun 2025 07:15:08 +0200
Message-ID: <20250610051644.2052814-12-hch@lst.de>
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

Add a new xlog_write_remainder handler that writes a continuation op
header and copies all fitting data out of xlog_write_partial into a
separate helper to clean up xlog_write_partial a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 94 +++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00b1174d4a30..aa158bc4d36b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2023,6 +2023,49 @@ xlog_write_get_more_iclog_space(
 	return 0;
 }
 
+/*
+ * Write the remainder or at least the start of it for an iovec spans more than
+ * a single iclog.
+ *
+ * First we release the iclog we currently have, then we get a new iclog and add
+ * a new opheader.  If we did not finish the iovec, the caller will call us
+ * again until we are done.
+ *
+ * This is complicated by the tail of a region using all the space in an iclog
+ * and hence requiring us to release the iclog and get a new one before
+ * returning to the outer loop.  We must always guarantee that we exit this
+ * with at least space for log transaction opheaders left in the current iclog.
+ */
+static int
+xlog_write_remainder(
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclogp,
+	uint32_t		*log_offset,
+	uint32_t		*len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt,
+	struct xfs_log_iovec	*reg)
+{
+	int			error;
+
+	/*
+	 * Ensure we include the continuation opheader in the space we need in
+	 * the new iclog by adding that size to the length we require.  This
+	 * continuation opheader needs to be accounted to the ticket as the
+	 * space it consumes hasn't been accounted to the lv we are writing.
+	 */
+	*len += sizeof(struct xlog_op_header);
+	error = xlog_write_get_more_iclog_space(ticket, iclogp, log_offset,
+			*len, record_cnt, data_cnt);
+	if (error)
+		return error;
+
+	xlog_write_region(ticket, *iclogp, log_offset, reg, len,
+			record_cnt, data_cnt);
+	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	return 0;
+}
+
 /*
  * Write log vectors into a single iclog which is smaller than the current chain
  * length. We write until we cannot fit a full record into the remaining space
@@ -2041,11 +2084,11 @@ xlog_write_partial(
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	int			index = 0;
-	int			error;
 
 	/* walk the logvec, copying until we run out of space in the iclog */
 	for (index = 0; index < lv->lv_niovecs; index++) {
 		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
+		int			error;
 
 		/*
 		 * The first region of a continuation must have a non-zero
@@ -2067,52 +2110,23 @@ xlog_write_partial(
 				return error;
 		}
 
+		/*
+		 * Write the amount that fits into this iclog.
+		 */
 		xlog_write_region(ticket, iclog, log_offset, reg, len,
 				record_cnt, data_cnt);
 
-		/* If we wrote the whole region, move to the next. */
-		if (reg->i_len == 0)
-			continue;
-
 		/*
-		 * We now have a partially written iovec, but it can span
-		 * multiple iclogs so we loop here. First we release the iclog
-		 * we currently have, then we get a new iclog and add a new
-		 * opheader. Then we continue copying from where we were until
-		 * we either complete the iovec or fill the iclog. If we
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
+		 * We now have an at least partially written iovec, but it can
+		 * span multiple iclogs so we loop over iclogs here until we
+		 * complete the iovec.
 		 */
-		do {
-			/*
-			 * Ensure we include the continuation opheader in the
-			 * space we need in the new iclog by adding that size
-			 * to the length we require. This continuation opheader
-			 * needs to be accounted to the ticket as the space it
-			 * consumes hasn't been accounted to the lv we are
-			 * writing.
-			 */
-			*len += sizeof(struct xlog_op_header);
-			error = xlog_write_get_more_iclog_space(ticket, &iclog,
-					log_offset, *len, record_cnt, data_cnt);
+		while (reg->i_len > 0) {
+			error = xlog_write_remainder(ticket, &iclog, log_offset,
+					len, record_cnt, data_cnt, reg);
 			if (error)
 				return error;
-
-			xlog_write_region(ticket, iclog, log_offset, reg, len,
-					record_cnt, data_cnt);
-			ticket->t_curr_res -= sizeof(struct xlog_op_header);
-		} while (reg->i_len > 0);
+		}
 	}
 
 	/*
-- 
2.47.2

