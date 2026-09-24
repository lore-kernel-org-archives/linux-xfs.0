Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946814503E1;
	Thu, 24 Sep 2026 10:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244131; cv=none; b=ebrz+hMGp0KLbBrPOPTSguScTY/A8zjpuRnaGd2IfjfQTepZzW45aRE+qbLZK+pBOMmUxAwaSlgng6D2efSv5EoUrWrqFKAZTHoR3hTAKlqoZYuoOBs93pLlkVW4k8aLHAestOhQYz91WK/BYk5hqSc6rnCXPEgWWqZG/ATrhm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244131; c=relaxed/simple;
	bh=axeRLzJb/vpMF0Yrxdv8HE5kXDseiyOHu+jR9OE5ibA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zm1eBoFZ6LKRBUajJrcGT4qjWl7ZA1nWvQ1E1vApnvB6LcPsCKuGDo4FA1Y0mEh0rY/6+1LSfpWcAUcwnmx+qN8ExuOK4N/FEcUROW84a7RjzsQYY3flEm7E0dbqbLdE+x+8qkalBOHxSU5DThxVOXs/dgAIq8fI+aqPMBQam/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=byrzSqkn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="byrzSqkn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=897aejqL2WTRE+qc0lHLzhfCi0XqM2YaqMd2i3cg7iw=; b=byrzSqknnEvljLJBpP0LNE00PY
	rqBfb4q3xtSegg350GwONyeQPTtjecSkmbTTGyG8UEpSm6RQeckKItjzb1JAE1DfC2gwXCC4YZjSi
	XX9QZrGZywMcF0hVsZCHU8SsnSZmF3hPhSV8FyhKoaIT8JsRAkK7BJBIS0e5Qan97D02uqkKVfgqw
	rt28TzuFL6sqSVbWzG6sXOf40gRMIGVvZSq5Bm9Uk80vlJwYhWovOhquwt2p1wutdwDXd4aeCU6qw
	S2Ks/nXqZluF9ILuzgJ6Sqon7lNwJHfFFXyZxGMEIJdYCVfyvV82/xHnRvmcmlWz+IFxqJHgPjT+b
	9SlP5f1A==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gHD-0000000Aeey-05zR;
	Thu, 24 Sep 2026 10:02:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 16/21] xfs: add data checksum support to zoned garbage collection
Date: Thu, 24 Sep 2026 11:59:48 +0200
Message-ID: <20260924100032.2733101-17-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Transfer the checksum from the old location to the new one.  The
implementation mirrors that of user data reads and writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 65 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 5fdcf98a2133..1cebd2ee2136 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -21,6 +21,7 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
+#include "xfs_rtcsum.h"
 #include "xfs_trace.h"
 
 /*
@@ -106,6 +107,10 @@ struct xfs_gc_bio {
 	/* Realtime group currently being reclaimed */
 	struct xfs_rtgroup		*victim_rtg;
 
+	/* Buffer for data checksums */
+	struct xfs_buf			*csum_bp;
+	void				*csum_buf;
+
 	/* Bio used for reads and writes, including the bvec used by it */
 	struct bio			bio;	/* must be last */
 };
@@ -660,6 +665,20 @@ xfs_zone_gc_alloc_blocks(
 	return true;
 }
 
+static void
+xfs_zone_gc_free_chunk(
+	struct xfs_gc_bio	*chunk)
+{
+	atomic_dec(&chunk->victim_rtg->rtg_gccount);
+	xfs_rtgroup_rele(chunk->victim_rtg);
+	list_del(&chunk->entry);
+	xfs_open_zone_put(chunk->oz);
+	if (chunk->csum_bp)
+		xfs_buf_rele(chunk->csum_bp);
+	xfs_irele(chunk->ip);
+	bio_put(&chunk->bio);
+}
+
 static void
 xfs_zone_gc_add_data(
 	struct xfs_gc_bio	*chunk)
@@ -725,6 +744,11 @@ xfs_zone_gc_start_chunk(
 	if (!xfs_zone_gc_iter_irec(mp, iter, &irec, &ip))
 		return false;
 
+	if (xfs_has_rtcsum(mp)) {
+		irec.rm_blockcount = min(irec.rm_blockcount,
+			xfs_rtcsum_max_len(mp, irec.rm_startblock));
+	}
+
 	if (!xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
 			&is_seq)) {
 		xfs_irele(ip);
@@ -748,6 +772,7 @@ xfs_zone_gc_start_chunk(
 	chunk->data = data;
 	chunk->oz = data->oz;
 	chunk->victim_rtg = iter->victim_rtg;
+	chunk->csum_bp = NULL;
 	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
 	atomic_inc(&chunk->victim_rtg->rtg_gccount);
 
@@ -764,22 +789,22 @@ xfs_zone_gc_start_chunk(
 	list_add_tail(&chunk->entry, &data->reading);
 	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
 
+	if (xfs_is_rtcsum_inode(ip)) {
+		int error;
+
+		error = xfs_rtcsum_read_async(mp, chunk->old_startblock,
+				&chunk->csum_bp);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+			xfs_zone_gc_free_chunk(chunk);
+			return false;
+		}
+	}
+
 	submit_bio(bio);
 	return true;
 }
 
-static void
-xfs_zone_gc_free_chunk(
-	struct xfs_gc_bio	*chunk)
-{
-	atomic_dec(&chunk->victim_rtg->rtg_gccount);
-	xfs_rtgroup_rele(chunk->victim_rtg);
-	list_del(&chunk->entry);
-	xfs_open_zone_put(chunk->oz);
-	xfs_irele(chunk->ip);
-	bio_put(&chunk->bio);
-}
-
 static void
 xfs_zone_gc_submit_write(
 	struct xfs_zone_gc_data	*data,
@@ -832,6 +857,9 @@ xfs_zone_gc_split_write(
 	split_chunk->old_startblock = chunk->old_startblock;
 	split_chunk->new_daddr = chunk->new_daddr;
 	split_chunk->oz = chunk->oz;
+	split_chunk->csum_bp = chunk->csum_bp;
+	if (split_chunk->csum_bp)
+		xfs_buf_hold(split_chunk->csum_bp);
 	atomic_inc(&chunk->oz->oz_ref);
 
 	split_chunk->victim_rtg = chunk->victim_rtg;
@@ -919,6 +947,19 @@ xfs_zone_gc_finish_chunk(
 
 	if (chunk->is_seq)
 		chunk->new_daddr = chunk->bio.bi_iter.bi_sector;
+
+	if (xfs_is_rtcsum_inode(ip)) {
+		unsigned int	boff;
+
+		error = xfs_buf_read_async_wait(chunk->csum_bp);
+		if (error)
+			goto free;
+
+		boff = xfs_rtb_to_rtcsumoff(mp, chunk->old_startblock);
+		error = xfs_rtcsum_log(chunk->oz, chunk->new_daddr, chunk->len,
+				chunk->csum_bp->b_addr + boff);
+	}
+
 	error = xfs_zoned_end_io(ip, chunk->offset, chunk->len,
 			chunk->new_daddr, chunk->oz, chunk->old_startblock);
 free:
-- 
2.53.0

