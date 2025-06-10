Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538A19CC3C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532641; cv=none; b=IxlvowG99gmrg4BfdlJcOYB/cCAvRjeM3iMfcwvKNLE+3vkcS2GE3tNxCoocvwLLo0LsqcRnF2luxuwAR6AAjj/yMQG6sFilW6M4/T1lWply7Yt8qQSoCsKNw39d8TtOtkCkWhTztn75qr42t/H6uOSZa7x6pUlf/COolZoKVnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532641; c=relaxed/simple;
	bh=DisIRKTG6J9mB+ygR4o87JcBQp5br97LTVpDGvaPA3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb60HZoGC5+lhWbMVmquDpcr6hwAQNAJKcs6bK9RR7tM6NSKxPj0wn39PxcZWf7dYE46jJ5Ud9sUh9OLRPrKmUyowoRoKgFgylv0qXT8pR6W8UPK4kAlSVkcsW8Hr/7VyAi5VVIEqn+6BvSwHAxREMVWuXU1wbu8vIpGO4f54Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CLqyqNhv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CLqyqNhv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bq9Vkwt0UOYMLBMjBYapmB3yeKe6yXpCdDHZPK8+zfA=; b=CLqyqNhvK5KKqUp4xUFAghizJ4
	nMf5snPj1MdmboGDnR9pHYRAU29eTzUu9ZXdYMASt0fvBKvuSG72a74ZxB27kVY0epjNPerWKuxEf
	lEYRxBQ7ttk2rqds2OsoCNU+vnrflONoezELpNSVRrTgKXX8FnoiVPSt3hBbK0SaZ+juUbhK+3J61
	KNtewpHveX8DO/mKys+p5sMiQP3RRGddJ9c0TrVBmqr0fKto0c0iuUY4tL1U90aJ9MJkVMFvPxd0K
	OdENFbebKOEabxTXlZ8YqWkkP7R6KOkv2vINOabGqG6OE64osR1XwxygjsWDNq3n5t7RmZ1McxTY5
	p5xc0Whg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMM-00000005pLr-3bR9;
	Tue, 10 Jun 2025 05:17:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/17] xfs: remove xlog_write_full
Date: Tue, 10 Jun 2025 07:15:09 +0200
Message-ID: <20250610051644.2052814-13-hch@lst.de>
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

xlog_write_partial now only two trivial extra branches compared to the
fast path for the case where the iovec fits into the iclog.  Remove the
special fast path so that we always use the same code and rename
xlog_write_partial to xlog_write_vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 57 +++++-------------------------------------------
 1 file changed, 5 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aa158bc4d36b..b72f52ab9521 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1961,37 +1961,6 @@ xlog_write_region(
 	(*record_cnt)++;
 }
 
-/*
- * Write log vectors into a single iclog which is guaranteed by the caller
- * to have enough space to write the entire log vector into.
- */
-static void
-xlog_write_full(
-	struct xfs_log_vec	*lv,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	*iclog,
-	uint32_t		*log_offset,
-	uint32_t		*len,
-	uint32_t		*record_cnt,
-	uint32_t		*data_cnt)
-{
-	int			index;
-
-	ASSERT(*log_offset + *len <= iclog->ic_size ||
-		iclog->ic_state == XLOG_STATE_WANT_SYNC);
-
-	/*
-	 * Ordered log vectors have no regions to write so this
-	 * loop will naturally skip them.
-	 */
-	for (index = 0; index < lv->lv_niovecs; index++) {
-		xlog_write_region(ticket, iclog, log_offset,
-				&lv->lv_iovecp[index], len, record_cnt,
-				data_cnt);
-		ASSERT(lv->lv_iovecp[index].i_len == 0);
-	}
-}
-
 static int
 xlog_write_get_more_iclog_space(
 	struct xlog_ticket	*ticket,
@@ -2073,7 +2042,7 @@ xlog_write_remainder(
  * wholly fit in the iclog.
  */
 static int
-xlog_write_partial(
+xlog_write_vec(
 	struct xfs_log_vec	*lv,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclogp,
@@ -2216,26 +2185,10 @@ xlog_write(
 		xlog_cil_set_ctx_write_state(ctx, iclog);
 
 	list_for_each_entry(lv, lv_chain, lv_list) {
-		/*
-		 * If the entire log vec does not fit in the iclog, punt it to
-		 * the partial copy loop which can handle this case.
-		 */
-		if (lv->lv_niovecs &&
-		    lv->lv_bytes > iclog->ic_size - log_offset) {
-			error = xlog_write_partial(lv, ticket, &iclog,
-					&log_offset, &len, &record_cnt,
-					&data_cnt);
-			if (error) {
-				/*
-				 * We have no iclog to release, so just return
-				 * the error immediately.
-				 */
-				return error;
-			}
-		} else {
-			xlog_write_full(lv, ticket, iclog, &log_offset,
-					 &len, &record_cnt, &data_cnt);
-		}
+		error = xlog_write_vec(lv, ticket, &iclog, &log_offset, &len,
+				&record_cnt, &data_cnt);
+		if (error)
+			return error;
 	}
 	ASSERT(len == 0);
 
-- 
2.47.2

