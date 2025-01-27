Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B677442A8C
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737990350; cv=none; b=A1Gkx3HHEfSmwR5Gyu9L65Vb8clUKdoeWcWsg1CYN8iUEPTDL3i/cDK60cj3cjiYC80V+S+cJlegZPTR1isDXurY7/kouAgNFyBtZ/bIwvwTu8domScpX8WkN2eAenOWN8HHH4uBSyta5tny/uOWWjSzSluC/vKnaEzf0lN1HQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737990350; c=relaxed/simple;
	bh=jd/3zYZkHKt7qvn5pg3VLvzSECnriLn54ioRMd35ATc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bRyNq5g6RQS4kgQx2/N51B2Dzcp4WJo0VP4c5JB1/w/SaFq6TFHyT0sDy2gkilvzQAcgl8zw1dr///XJX+PleR4tSLLBRzBPfxJ0n+TOFEw5JEZwZrIeI+beyiRdyJ0CAMPuR7/WX9KCTHfUkU+Uj9mpV8S73l/GzMEXRpD0xzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sRyinqo7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sRyinqo7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RN4fq789b3JPYsTCDG62q8o9B+hIvVrfQ72iDEmi688=; b=sRyinqo7q0SpMdNVCrTYvkwb7S
	PYP7LIqi7Ji+54iJSpGTySJLXGO1+/n4q5Kna6LAujOKK19kTtPjFeYyEFL6kuy+2c89MrC4yeymG
	WcB5zgcTY1QD8a11SmX2FsGuvPBn23mmCUJEDyRjf5ex8hM7aCnXIiD/OamlTl3z5wCW0QGsIiO7P
	BYD9oThTSD23+flM1me7R1znusHcK6OAvu9Qe9FVtr3KaPGpQIEpANcUQldjK5xRUqfseeuSzMsiN
	YgLNae7q8Qd3XqHqpeqrZR3tkzhIZoyJOl6UX4qUvorvghyHvqW2LemvGz7qmFF8LWbdhZgAjJCuW
	jeEgrYPA==;
Received: from 2a02-8389-2341-5b80-b8ca-be22-b5e2-4029.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b8ca:be22:b5e2:4029] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tcQgI-00000002YSj-3r7u;
	Mon, 27 Jan 2025 15:05:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	"Lai, Yi" <yi1.lai@linux.intel.com>
Subject: [PATCH] xfs: remove xfs_buf_cache.bc_lock
Date: Mon, 27 Jan 2025 16:05:39 +0100
Message-ID: <20250127150539.601009-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
the hashtable.  But as the rhashtable code already uses fine grained
internal locking for inserts and removals the extra protection isn't
actually required.

It also happens to fix a lock order inversion vs b_lock added by the
recent lookup race fix.

Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 20 ++++++++------------
 fs/xfs/xfs_buf.h |  1 -
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d1d4a0a22e13..1fffa2990bd9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -41,8 +41,7 @@ struct kmem_cache *xfs_buf_cache;
  *
  * xfs_buf_rele:
  *	b_lock
- *	  pag_buf_lock
- *	    lru_lock
+ *	  lru_lock
  *
  * xfs_buftarg_drain_rele
  *	lru_lock
@@ -502,7 +501,6 @@ int
 xfs_buf_cache_init(
 	struct xfs_buf_cache	*bch)
 {
-	spin_lock_init(&bch->bc_lock);
 	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
 }
 
@@ -652,17 +650,20 @@ xfs_buf_find_insert(
 	if (error)
 		goto out_free_buf;
 
-	spin_lock(&bch->bc_lock);
+	/* The new buffer keeps the perag reference until it is freed. */
+	new_bp->b_pag = pag;
+
+	rcu_read_lock();
 	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
 	if (IS_ERR(bp)) {
+		rcu_read_unlock();
 		error = PTR_ERR(bp);
-		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
 	if (bp && xfs_buf_try_hold(bp)) {
 		/* found an existing buffer */
-		spin_unlock(&bch->bc_lock);
+		rcu_read_unlock();
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
 			xfs_buf_rele(bp);
@@ -670,10 +671,8 @@ xfs_buf_find_insert(
 			*bpp = bp;
 		goto out_free_buf;
 	}
+	rcu_read_unlock();
 
-	/* The new buffer keeps the perag reference until it is freed. */
-	new_bp->b_pag = pag;
-	spin_unlock(&bch->bc_lock);
 	*bpp = new_bp;
 	return 0;
 
@@ -1090,7 +1089,6 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	spin_lock(&bch->bc_lock);
 	__xfs_buf_ioacct_dec(bp);
 	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
@@ -1102,7 +1100,6 @@ xfs_buf_rele_cached(
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 		else
 			bp->b_hold--;
-		spin_unlock(&bch->bc_lock);
 	} else {
 		bp->b_hold--;
 		/*
@@ -1120,7 +1117,6 @@ xfs_buf_rele_cached(
 		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
 				xfs_buf_hash_params);
-		spin_unlock(&bch->bc_lock);
 		if (pag)
 			xfs_perag_put(pag);
 		freebuf = true;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7e73663c5d4a..3b4ed42e11c0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -80,7 +80,6 @@ typedef unsigned int xfs_buf_flags_t;
 #define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
 
 struct xfs_buf_cache {
-	spinlock_t		bc_lock;
 	struct rhashtable	bc_hash;
 };
 
-- 
2.45.2

