Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782825;
	b=bshM2mDowaZOiIUVPPgL6X4WZC6MtXGLktQVG0NssJwi6YVwVYEjzA1Ut1CzI4yDxO6P
	 icmHes7Z1tSRoZCdN79+csJjhRtoK0792GJ5qAzDbtDV0Xt2rcheOi9pNyPjxagNJgZwt
	 GEwjR6WqtdBN7CECMCWy7q07Li45WOyJlmJijd9d0qzP+H3O13BD6WRL0ojLReH7LI+YR
	 NNQIIMEiYZ2Eu6J2nt4xg6RgsDUfhiO/D3PGLddr8xUkyWVJ1L8GvPwyvNgSi5Pjzkd4R
	 criQcI4McJpoN7icd+MHrOAKlFfx9reYdDChyhHcXd4jJV3opuvyi2Tgvcup2aAUHQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782825;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=GYXQUBzOr1PjB/GSyrXP3Q7Lkpc8us6orGJkalvu4+Y=;
	b=h6mIIs2aZD8Eu1lQpLf7irvmYDThhe+r/79sHAg6W06Uw1X5NIKfQAy04YrqcrcJoEGN
	 zZtrI2LWHv4fySxyIb+t9NcVYBRqfq0Lkiv1OHIv6C4WbrCozb6zRpYzUvBrNZMcsTKg9
	 +GnhxMgREjhRLXXGrDsNwCLcg+fgV9TAvC1sSEWmaQy1K2MNbcHZpzXhg98snfVauBZMM
	 Aq4zsnkPezBxRydnoorT6suc3g8fNesw8i4LN3Lf7WBUww35KkGnvVgtaof4xnYhrCyqi
	 cAytGk6kmO3FQhKTfrFfkZuiTLC+9STCIPlWizAvtDPPP2/pDTGFsJYHTh1YXGf7Bfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nk9vy8Xk;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370D9606A32E;
	Wed,  4 Nov 2026 09:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 370D9606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nk9vy8Xk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GYXQUBzOr1PjB/GSyrXP3Q7Lkpc8us6orGJkalvu4+Y=; b=nk9vy8XkYP6WRhy0SoxGiUS5Ag
	kuw1lxa3ZP4CdXZ6Vk21DWMYrR4Cazp3lJE/dsVVKVvQHvKOlQIKg0gQkl2VZPk3jAHEA00G23ck7
	5wjUgjAM/cE2hoE/5ns4LkXNxSgzKS4fL1HpgzdwIqccPotWKpJ7ozjJW4+BOG2pter+j7n46ripT
	VB3TM0MASWwo0aGIZ44fbavtNt+ax1QMWCBnbnSNwhGY1Qbr8R7eY1qzxHv/swkV909cuMre3uBkU
	k1N5c8EewhJ9yNKWBNVni4z9Kb+RsbZEBbu22Mu5gTpjxEL8sw+NF+KTJC00UfuikY9WVD1Y6b9o/
	w63Y/QYg==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWr2-00000004oVT-2QmS;
	Wed, 04 Nov 2026 09:00:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 18/25] xfs: add data checksum support to zoned garbage collection
Date: Wed,  4 Nov 2026 09:57:22 +0100
Message-ID: <20261104085929.317544-19-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
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

Transfer the checksum from the old location to the new one.  The
implementation mirrors that of user data reads and writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 66 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index cea5447a886d..9296f584282a 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -21,6 +21,7 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
+#include "xfs_rtcsum.h"
 #include "xfs_trace.h"
 
 /*
@@ -106,6 +107,9 @@ struct xfs_gc_bio {
 	/* Realtime group currently being reclaimed */
 	struct xfs_rtgroup		*victim_rtg;
 
+	/* Buffer for data checksums */
+	struct xfs_buf			*csum_bp;
+
 	/* Bio used for reads and writes, including the bvec used by it */
 	struct bio			bio;	/* must be last */
 };
@@ -660,6 +664,20 @@ xfs_zone_gc_alloc_blocks(
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
@@ -725,6 +743,11 @@ xfs_zone_gc_start_chunk(
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
@@ -748,6 +771,7 @@ xfs_zone_gc_start_chunk(
 	chunk->data = data;
 	chunk->oz = data->oz;
 	chunk->victim_rtg = iter->victim_rtg;
+	chunk->csum_bp = NULL;
 	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
 	atomic_inc(&chunk->victim_rtg->rtg_gccount);
 
@@ -764,22 +788,22 @@ xfs_zone_gc_start_chunk(
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
@@ -832,6 +856,9 @@ xfs_zone_gc_split_write(
 	split_chunk->old_startblock = chunk->old_startblock;
 	split_chunk->new_daddr = chunk->new_daddr;
 	split_chunk->oz = chunk->oz;
+	split_chunk->csum_bp = chunk->csum_bp;
+	if (split_chunk->csum_bp)
+		xfs_buf_hold(split_chunk->csum_bp);
 	atomic_inc(&chunk->oz->oz_ref);
 
 	split_chunk->victim_rtg = chunk->victim_rtg;
@@ -919,6 +946,21 @@ xfs_zone_gc_finish_chunk(
 
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
+		if (error)
+			goto free;
+	}
+
 	error = xfs_zoned_end_io(ip, chunk->offset, chunk->len,
 			chunk->new_daddr, chunk->oz, chunk->old_startblock);
 free:
-- 
2.53.0

