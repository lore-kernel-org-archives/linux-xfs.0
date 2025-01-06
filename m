Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08D4594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157399; cv=none; b=exVX1x7dogtrFg/WuDkZlsRB0gfvlDXVkHMJj89p/o2WQNKDuCu2ex4d/1owaB/rItgFu5/haAyL8gJbxyYeocm4URl4aynypRbac7NzwOZlSZXXHTh5CPzzppuiNFoKyaWlbHl9Ge901NWC/CekU7JBX8SG509PJyvcHiHWBSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157399; c=relaxed/simple;
	bh=L4Adl+c5Y9ARJGtsp2p89uBO8doua+fH834+ozFwGaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmcGApD5bROiJbwxMD0/+QCRc/9OzA4Xh/2vWQJ1ZXFPECpzHyWa3lPK/kWbNnJGaThahE1ni98j2MAyLMk5bPzNJ4z+qCxKTGIatZqBT8jpxz8UqKjCkidJJrP/407vKDb9TVKkQiovqvA+fl7OLkFVAv+2avXSQgd09kQaGd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iWlemlVb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iWlemlVb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9HNZgBF93fqEEMPunXRarlHYoqlYchaTuUhUqCTO/9M=; b=iWlemlVbRkd9LFiF+Njmii5lSd
	xoZV0b5qZ9JdXD62toDfbzB0OfsT4nfzN0LAxUE+Qb4WGqxEc57JBH/enlapZhSyN/nip3EFASTPy
	5OVtn1piH+5CafwnXSJoNI3lNwCLnqHjyqpqx3Ii/bK7QKR046/C6w0RdqsqgGEhcNeTDR0oa8ArE
	H5cEBTJl5uteWOhQUsM3ixsFcJX8hYC0KZdLopaIYJmjwMsYErHUlo4gS+jOFVZQJdYb8mO1l1InA
	bOhiCKMHYwIXZikX7GYW6EEhGoGclgXm1colNXocYNFFFj4H1m7cjmZ9f4gOOzznLCfwJP8z4vH3t
	fCaVWg7Q==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqf-00000000lKg-0LUp;
	Mon, 06 Jan 2025 09:56:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/15] xfs: move in-memory buftarg handling out of _xfs_buf_ioapply
Date: Mon,  6 Jan 2025 10:54:45 +0100
Message-ID: <20250106095613.847700-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No I/O to apply for in-memory buffers, so skip the function call
entirely.  Clean up the b_io_error initialization logic to allow
for this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 18e830c4e990..e886605b5721 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1607,12 +1607,6 @@ _xfs_buf_ioapply(
 	int		size;
 	int		i;
 
-	/*
-	 * Make sure we capture only current IO errors rather than stale errors
-	 * left over from previous use of the buffer (e.g. failed readahead).
-	 */
-	bp->b_error = 0;
-
 	if (bp->b_flags & XBF_WRITE) {
 		op = REQ_OP_WRITE;
 	} else {
@@ -1624,10 +1618,6 @@ _xfs_buf_ioapply(
 	/* we only use the buffer cache for meta-data */
 	op |= REQ_META;
 
-	/* in-memory targets are directly mapped, no IO required. */
-	if (xfs_buftarg_is_mem(bp->b_target))
-		return;
-
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
@@ -1740,7 +1730,11 @@ xfs_buf_submit(
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
 
-	/* clear the internal error state to avoid spurious errors */
+	/*
+	 * Make sure we capture only current IO errors rather than stale errors
+	 * left over from previous use of the buffer (e.g. failed readahead).
+	 */
+	bp->b_error = 0;
 	bp->b_io_error = 0;
 
 	/*
@@ -1757,6 +1751,10 @@ xfs_buf_submit(
 		goto done;
 	}
 
+	/* In-memory targets are directly mapped, no I/O required. */
+	if (xfs_buftarg_is_mem(bp->b_target))
+		goto done;
+
 	_xfs_buf_ioapply(bp);
 
 done:
-- 
2.45.2

