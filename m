Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048183AEF4E
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779084152; cv=none; b=tuyIUiEKZ++E5jARWvdO35sJI/+kQ351A4G+QLDJJczJnQ5O2dD7/6Tx6T59jD4RUueR9P/V0ffzcMYGyBMfmC58Xq1hqwou47o6F1DXByRlPguYSzOrZCHqVlMLzyNNKle5YUJIm2TzahEhsp92aZYJJagM/5I8evK1RPWxzm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779084152; c=relaxed/simple;
	bh=FbwG05mJy6vKPcPZg7S7hIeU7dluy+vyY2B5wrjcpT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udkY27NkQPTLqdJGZtnrKzVMvJm3Uihoy8/FcHxNowOo7eccMiXi2I6meflCY6z5Mq4PnsjPbrnX5cOQmA8BXckJmdxKNUwuWAICeo950KGOreOkfv7U9v+UKZWYFnH1wuf7rsUImCmprctnVF6zNQfy0ONEagEe/UUBIcwSAKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aIqk1KBI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aIqk1KBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uCh1204SoE2G9g/G0lDDawVihLElLoLH7Er2Y+C3cLU=; b=aIqk1KBIlKUnS++Fj9/oRBIbNh
	JmGyPd3715JPgXz/zDgZ0AQuk6TlIobZLJKr8mGsdifjJ/yNnFumuEeD3Yd5RwUhYJj49Ve9dAXWr
	ysuWO37w7gvZzULNz6r3YkjFVsHbwXAiVi7j6exLJw4vzr430ROlUctti2uKHs/MfCCzxrMPEyyhG
	eYl88BnoMEktxZow9zXnWNEM6xFdCc8JgnRU4nkxJcW66ZOcfaqIf1bPT2hnjgze2VpCf/zBR7x6u
	Be8XuyqHf6kkGFk8QPE2T7MP08OVd1Y9IXnqYdPaifvSHXnkDPEZb02MqdpjNAuWdhrGwPAZ4hhQP
	L+HscImQ==;
Received: from 213-147-166-103.nat.highway.webapn.at ([213.147.166.103] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOr3X-0000000ENRX-0QtF;
	Mon, 18 May 2026 06:02:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix a buffer lookup against removal race
Date: Mon, 18 May 2026 08:02:05 +0200
Message-ID: <20260518060209.502179-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518060209.502179-1-hch@lst.de>
References: <20260518060209.502179-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When a buffer is freed either by LRU eviction or because it is unset,
the lockref is marked as dead instantly, which prevents the buffer from
being used after finding it in the buffer hash in xfs_buf_lookup and
xfs_buf_find_insert.  But the latter will then not add the new buffer to
the hash because it already found an existing buffer.

Fix this using in two places:  Remove the buffer from the hash before
marking the lockref dead so that that no buffer with a dead lockref can
be found in the hash, but if we find one in xfs_buf_find_insert due to
store reordering, handle this case correctly instead of returning an
unhashed buffer.

Fixes: 67fe4303972e ("xfs: don't keep a reference for buffers on the LRU")
Reported-by: Andrey Albershteyn <aalbersh@redhat.com>
Reported-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 580d40a5ee57..0cea458f1353 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -472,6 +472,7 @@ xfs_buf_find_insert(
 	/* The new buffer keeps the perag reference until it is freed. */
 	new_bp->b_pag = pag;
 
+retry:
 	rcu_read_lock();
 	bp = rhashtable_lookup_get_insert_fast(&btp->bt_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
@@ -480,8 +481,16 @@ xfs_buf_find_insert(
 		error = PTR_ERR(bp);
 		goto out_free_buf;
 	}
-	if (bp && lockref_get_not_dead(&bp->b_lockref)) {
-		/* found an existing buffer */
+	if (bp) {
+		/*
+		 * If there is an existing buffer with a dead lockref, retry
+		 * until the new buffer is added, or a usable buffer is found.
+		 */
+		if (!lockref_get_not_dead(&bp->b_lockref)) {
+			rcu_read_unlock();
+			cpu_relax();
+			goto retry;
+		}
 		rcu_read_unlock();
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
@@ -820,15 +829,20 @@ xfs_buf_destroy(
 	ASSERT(__lockref_is_dead(&bp->b_lockref));
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
+	if (bp->b_pag)
+		xfs_perag_put(bp->b_pag);
+	xfs_buf_free(bp);
+}
+
+static inline void
+xfs_buf_kill(
+	struct xfs_buf		*bp)
+{
+	lockref_mark_dead(&bp->b_lockref);
 	if (!xfs_buf_is_uncached(bp)) {
 		rhashtable_remove_fast(&bp->b_target->bt_hash,
 				&bp->b_rhash_head, xfs_buf_hash_params);
-
-		if (bp->b_pag)
-			xfs_perag_put(bp->b_pag);
 	}
-
-	xfs_buf_free(bp);
 }
 
 /*
@@ -851,7 +865,7 @@ xfs_buf_rele(
 	return;
 
 kill:
-	lockref_mark_dead(&bp->b_lockref);
+	xfs_buf_kill(bp);
 	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
 	spin_unlock(&bp->b_lockref.lock);
 
@@ -1433,7 +1447,7 @@ xfs_buftarg_drain_rele(
 		return LRU_SKIP;
 	}
 
-	lockref_mark_dead(&bp->b_lockref);
+	xfs_buf_kill(bp);
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
@@ -1545,7 +1559,7 @@ xfs_buftarg_isolate(
 		return LRU_ROTATE;
 	}
 
-	lockref_mark_dead(&bp->b_lockref);
+	xfs_buf_kill(bp);
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
-- 
2.53.0

