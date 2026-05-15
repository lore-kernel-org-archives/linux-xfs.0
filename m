Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6382940B6C1
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778851945; cv=none; b=tkji68vBcoCpRudZFQ3FIZvDI4D8V31aFLwTKQqk0mf2LO6vD+5VJ+9Xm5LX4JQWGN/Dm6mMHTJ/bFwE9M54EY7e6APTsAVQjvLRTQyWSjFS6ISccnt4Z2Pjt9SR4ebWkdyfhiTkslBoOhgjLUbQ8e0o2918W71rxa9HMViaE10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778851945; c=relaxed/simple;
	bh=Co8cd2fGWwt8lIZXeRNBZOqu3PQxLsJRZBQMRY4rEhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCQpoQK7e54YEhKLPa4jlYyLqbhOT96ZkITKzbeZQYVG/65Goj8a57hTPbZliyg1TBAIzQkHL6Nfg9a9tXvPS+S7bWaKXx/Owx0HQ8O+iYLbNCVhgrkZpkTnVL2Es2xSyV3/IVulSmnS7twpBIiXuu60S6UVut5+NzwFV3DbAf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WUzdt+Jr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WUzdt+Jr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z3C6ZMbRHylIU3Tu9qH+JmjB2KlhctEIM0Jbfsf+l+k=; b=WUzdt+JrGyV/NmhEiEdpYOEBFn
	Dht0ZnA78/PJdDMRouV6rRQQv8SxRV8gBJt7UACCuW/qQJD3i6PiF79l3KNguN3thBBC20NkWP9Pv
	+IF9Sj9QqdJlq0b91ENAqnWkvmtT/XttoVJtQA+A2toW57PnqBeqbn5ZfKvoZL+U2MyXbaRVFiLfB
	jSOTxIg1R1QS4sPMTiS8BDq+f2Mtr0lS7LXmUMBEgkZANWb8+Cx1y/tCV2fnZGO2fMcquGUAK6Rts
	IIhrCYDQAzy6ENabGtdMytqEEGflS2rEJucrD6eOKE4NbpT+P4EWA3TnpYYRUMs4YBUDgGZetXTh6
	1fK4ly1Q==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNseK-00000008S66-2vv8;
	Fri, 15 May 2026 13:32:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix a buffer lookup against removal race
Date: Fri, 15 May 2026 15:31:58 +0200
Message-ID: <20260515133212.4039831-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515133212.4039831-1-hch@lst.de>
References: <20260515133212.4039831-1-hch@lst.de>
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
 fs/xfs/xfs_buf.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 580d40a5ee57..a095a5c0a01f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -472,6 +472,7 @@ xfs_buf_find_insert(
 	/* The new buffer keeps the perag reference until it is freed. */
 	new_bp->b_pag = pag;
 
+retry:
 	rcu_read_lock();
 	bp = rhashtable_lookup_get_insert_fast(&btp->bt_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
@@ -480,8 +481,15 @@ xfs_buf_find_insert(
 		error = PTR_ERR(bp);
 		goto out_free_buf;
 	}
-	if (bp && lockref_get_not_dead(&bp->b_lockref)) {
-		/* found an existing buffer */
+	if (bp) {
+		/*
+		 * If there is an existing buffer with a dead lockref, retry
+		 * until the new buffer is added or usable buffer is found.
+		 */
+		if (!lockref_get_not_dead(&bp->b_lockref)) {
+			rcu_read_unlock();
+			goto retry;
+		}
 		rcu_read_unlock();
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
@@ -820,15 +828,20 @@ xfs_buf_destroy(
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
 	if (!xfs_buf_is_uncached(bp)) {
 		rhashtable_remove_fast(&bp->b_target->bt_hash,
 				&bp->b_rhash_head, xfs_buf_hash_params);
-
-		if (bp->b_pag)
-			xfs_perag_put(bp->b_pag);
 	}
-
-	xfs_buf_free(bp);
+	lockref_mark_dead(&bp->b_lockref);
 }
 
 /*
@@ -851,7 +864,7 @@ xfs_buf_rele(
 	return;
 
 kill:
-	lockref_mark_dead(&bp->b_lockref);
+	xfs_buf_kill(bp);
 	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
 	spin_unlock(&bp->b_lockref.lock);
 
@@ -1433,7 +1446,7 @@ xfs_buftarg_drain_rele(
 		return LRU_SKIP;
 	}
 
-	lockref_mark_dead(&bp->b_lockref);
+	xfs_buf_kill(bp);
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
@@ -1545,7 +1558,7 @@ xfs_buftarg_isolate(
 		return LRU_ROTATE;
 	}
 
-	lockref_mark_dead(&bp->b_lockref);
+	xfs_buf_kill(bp);
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
 	return LRU_REMOVED;
-- 
2.53.0

