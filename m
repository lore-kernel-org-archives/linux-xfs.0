Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90131D90AD
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157390; cv=none; b=AGfzrr6PNWhayXY2KHdRlHRiElrrGmhsttiU3UcdEqIPk3ndCDWb/Dl1O+snd37Ig/BDtAUX+63fpr0JZXmV7YdNyWRR4EKHHAj7sbQPgeUXfDAoWRgi9Moown2NBbRw0Td7bYqBnVJm+bICq0opNlQlDh4r6B7lc2odP1Om8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157390; c=relaxed/simple;
	bh=pSISvmmrMYjxEQWZXDTBxOFMF3hq5oq4hAdJNuA+Nn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcTA1+8V3QZFW/4XavxC0DoCJN0NErFIYbfTtsmNFR8hBFjKKK4PFHzh6kIdPgWWLLqnZSm1JxUuHrh7JU1vGXe/UvlADSQuO1hb78pIELxgiIHmgC+kYRuGfAfmyO9bwItQdhjpQx9asO4fhAJY4JRpbQ60gshZrE0xgXVrsSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P9FHtoSN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P9FHtoSN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e5iV/ZajpeKhTCgpCaXd28WRuvESmASZM0Ej4BSY7CU=; b=P9FHtoSNexBW3x26V9URFNo+Ke
	FldeZOALmvf0ucOKHlY4CP0YdHjJhLxF7HCYpDnfIkk0A6gBVazE1EDbT7YzKPOV2miczT1Lthemf
	m0CA1h3LRnJEvZnGXWu7sWleTvyEMSOlbSQitTI/tNe2BT51XRZURLC9mhqR75cEi8ZS4Zb7la4R6
	zlifHqb5K3RzUnWOsuArf+rTLIoiOtDl31gZKKUEujc/0Z48AoZUR/9JnfiRHts1llQyeWk9nHnpI
	iASVrkTEV3ieFiUcEjaITydAaNnwrJs4sgOivQUAaXHxSFUYp5ZrokQ+tllBOAghthRCdcprAVQ0H
	EaaUEa8A==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqV-00000000lFt-43J4;
	Mon, 06 Jan 2025 09:56:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/15] xfs: simplify xfs_buf_delwri_pushbuf
Date: Mon,  6 Jan 2025 10:54:42 +0100
Message-ID: <20250106095613.847700-6-hch@lst.de>
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

xfs_buf_delwri_pushbuf synchronously writes a buffer that is on a delwri
list already.  Instead of doing a complicated dance with the delwri
and wait list, just leave them alone and open code the actual buffer
write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a3484421a6d8..7edd7a1e9dae 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2391,14 +2391,9 @@ xfs_buf_delwri_submit(
  * Push a single buffer on a delwri queue.
  *
  * The purpose of this function is to submit a single buffer of a delwri queue
- * and return with the buffer still on the original queue. The waiting delwri
- * buffer submission infrastructure guarantees transfer of the delwri queue
- * buffer reference to a temporary wait list. We reuse this infrastructure to
- * transfer the buffer back to the original queue.
+ * and return with the buffer still on the original queue.
  *
- * Note the buffer transitions from the queued state, to the submitted and wait
- * listed state and back to the queued state during this call. The buffer
- * locking and queue management logic between _delwri_pushbuf() and
+ * The buffer locking and queue management logic between _delwri_pushbuf() and
  * _delwri_queue() guarantee that the buffer cannot be queued to another list
  * before returning.
  */
@@ -2407,33 +2402,21 @@ xfs_buf_delwri_pushbuf(
 	struct xfs_buf		*bp,
 	struct list_head	*buffer_list)
 {
-	LIST_HEAD		(submit_list);
 	int			error;
 
 	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
 
 	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
 
-	/*
-	 * Isolate the buffer to a new local list so we can submit it for I/O
-	 * independently from the rest of the original list.
-	 */
 	xfs_buf_lock(bp);
-	list_move(&bp->b_list, &submit_list);
-	xfs_buf_unlock(bp);
-
-	/*
-	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
-	 * the buffer on the wait list with the original reference. Rather than
-	 * bounce the buffer from a local wait list back to the original list
-	 * after I/O completion, reuse the original list as the wait list.
-	 */
-	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
+	bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
+	bp->b_flags |= XBF_WRITE;
+	xfs_buf_submit(bp);
 
 	/*
-	 * The buffer is now locked, under I/O and wait listed on the original
-	 * delwri queue. Wait for I/O completion, restore the DELWRI_Q flag and
-	 * return with the buffer unlocked and on the original queue.
+	 * The buffer is now locked, under I/O but still on the original delwri
+	 * queue. Wait for I/O completion, restore the DELWRI_Q flag and
+	 * return with the buffer unlocked and still on the original queue.
 	 */
 	error = xfs_buf_iowait(bp);
 	bp->b_flags |= _XBF_DELWRI_Q;
-- 
2.45.2

