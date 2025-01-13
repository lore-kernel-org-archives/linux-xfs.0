Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0B523ED51
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777568; cv=none; b=QatPXTpWq0B0yCM/KMjXO6Ex4ONpIa8WFye2//KAWucXOsjmbH0GXL+kNiRj645BU1ZFcQq347/lrBhUlRhB8kx9ZXSMuImUoookn++RTfw4yUtMwbw0kUC85BUVOZAUz1RArmNgdidEMmCU6mn6q1VOKO6c7CZiqjUiBUZMyls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777568; c=relaxed/simple;
	bh=7wVYLJ/gO/wRkUHCG5/c7eUny+EmqSfVD427KL2qktg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4y1KNLTKGq4e/pE1NXsTNx8Z1E/bhNNghzxbPW+4SKsOUlWk2nnTE7yjGBG119s5IJYACVRqHB7vkAHCt9CvSWNIk/h8kDlXF+WWA0OpYACDk40anXhEzLdZnjX6WPbGzeuIqUR+e5knZgeaLd6Wtg6v4ax9S2m9DRJzNP1OzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zHyNPi5l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zHyNPi5l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AgCUqeXhBFQLcUa9+0xayxE8P1uXAtuZ48kNU+TSgjI=; b=zHyNPi5lDs40ZVfL/xd4QdErCR
	nQ0gWnxYc3/BeWByHBZw/IiX9HWKjYO1I7vFfsfkj/nU1qk6u2bEjKxQUqxn0wVP7hK+hvwPlw3s7
	bp5PxLJMRCbmuiwShcvCIHtkzbPeCUtmjaO3u/lIjvfh0B6yKgDgRrBE19QfmClHbRe1twyWmTP06
	hr7QfcIwPCNqS2VNYlw/alqaR1yKbOQV80I2t9t7x8m2PgJmKJO2q/76vo6WgrsgXNXfkeO9v+Opo
	O81PSK1be4pDcln0xwVHBCoOIkDcSl9jriisv4mkSqjWKYHr59dUKgceDNv/8/SMd30kcRx2zE4fA
	aFKQc7/A==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBO-00000005MnI-0jcv;
	Mon, 13 Jan 2025 14:12:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/15] xfs: simplify xfs_buf_delwri_pushbuf
Date: Mon, 13 Jan 2025 15:12:09 +0100
Message-ID: <20250113141228.113714-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5abada2b4a4a..fba494b9b9da 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2384,14 +2384,9 @@ xfs_buf_delwri_submit(
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
@@ -2400,33 +2395,21 @@ xfs_buf_delwri_pushbuf(
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

