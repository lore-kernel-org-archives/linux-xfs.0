Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617928;
	b=TIhnmftlJ246H5IX9R5dqq6CXJZIFI0RFPygq/5bpbgPZuTO497RYZST/s5SuUpn92hF
	 W3ac3dAqU1rpVzV25XuM3SqrZG6mKY93niFDI6/fVLd9NNweciLWy8G6Jofab+oAJbwSu
	 tU3aOZ8zGJ7MeoRVoGn6lxIpIXLDMiTl+ATunsYYa/jOR2s0pBybRmjXCUa+O62UvxPSG
	 z+0b7SxGNSnoDdBFxOiq9htbPHdR7QUnt5cnlzDJT9QO5yqeOtijy8Hdbe85Wpudt7kk3
	 cWtmFCDiizXFUMyWyUdX7UTwEfAM4BbFwehSaNsaHFSf9oO6Zh88ZOUq/+2dvRWy+CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617928;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=M4vCJlCTdzvodnoV0+tCD1Xx9A9EgLH859ImmVeGxg4=;
	b=a0OkLqqoWInKcFkjQDwTh65Bh/7+MFhq8GbD8j3Q6wr4Qk8i9IKbMOZuXCwyqnERKw9H
	 ExQuJf3Tzomj9ekpXz5AyNDK+i+YS+C+YqI/2FbBS6PbunJaCMgVdMwCA8+cQ5ANN/1uY
	 Kgl+zyByMOq9gc7zn1u69ixaNw8VPDaAaXFRM1gJj45RDAg93FNk/d2mfs21bieiJBjC7
	 T5tyN69tY6kRqr8HrcyKGC6beEXnNWSJUbifdOhBBG917iC5sS7znOphYUD831qxBasKH
	 aADmy9oknlk8hhD9CDNroDMabf6RuOHROaaVMkzWpPBcKH7ZQJc7uf9D9fWb4UpZh0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=eQ9T0ZX+;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE64606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BE64606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=eQ9T0ZX+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M4vCJlCTdzvodnoV0+tCD1Xx9A9EgLH859ImmVeGxg4=; b=eQ9T0ZX+mv3vPedlciJCzIgaj2
	ZLA1WnUhqhuoh2kllRWZSDa/rPxqzGXYymFaeJDn1Ebc1Zn71bTfj4kTdJkQ5ZqhmrluFjASfAYyo
	OaMxmMWSaUnp9++YvHq7W/u6uRJ0q0rI21WOCGbyEGWqAAMGnNsKgSXJGDfmLznNixEGAKrHSmJgO
	PYibqPq1hH8WWDSFFDD/8goBMwZxl6TQqC2JwF6nsr2ELGL1BptiDjjL6jXhbGEEGQTYiysqqq0PX
	wpv8qVmo0YoKBbIR+Ulfi96VYL93QTbqmm0lCSjHVPN71Z2t0H19X8JouPnKvrP1M6OPDR45i507O
	Vv8aM9Bg==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEFT-0000000ADyT-1bw3;
	Wed, 25 Nov 2026 14:45:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/15] xfs: cleanup log vec used tracking
Date: Wed, 25 Nov 2026 15:42:36 +0100
Message-ID: <20261125144430.728485-16-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125144430.728485-1-hch@lst.de>
References: <20261125144430.728485-1-hch@lst.de>
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

The lv_buf_used is used for two unrelated things: one to propagate the
fact that a log vec is for an ordered buffer, and also to track the
amount of data copied into the linear buffer of a non-ordered logvec.

Use a field in the on-stack xlog_format_buf structure for the buffer
usage tracking, and replace the lv_buf_used field in struct xfs_log_vec
with a boolean to indicate that it is an ordered buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      |  2 +-
 fs/xfs/xfs_log_cil.c  | 28 +++++++++++-----------------
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 58a2fcc7275b..9fe9b2527404 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1943,7 +1943,7 @@ xlog_print_trans(
 		xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
 		xfs_warn(mp, "  alloc_size = %d", lv->lv_alloc_size);
 		xfs_warn(mp, "  bytes	= %u", xfs_log_vec_bytes(lv));
-		xfs_warn(mp, "  buf used= %d", lv->lv_buf_used);
+		xfs_warn(mp, "  ordered	= %u", lv->lv_ordered);
 
 		/* dump each iovec for the log item */
 		vec = lv->lv_iovecp;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 490d114bf3e4..9271119af911 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -338,22 +338,17 @@ xlog_cil_alloc_shadow_bufs(
 			INIT_LIST_HEAD(&lv->lv_list);
 			lv->lv_item = lip;
 			lv->lv_alloc_size = alloc_size;
-			if (ordered)
-				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
-			else
+			if (!ordered)
 				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
 			lip->li_lv_shadow = lv;
 		} else {
 			/* same or smaller, optimise common overwrite case */
 			lv = lip->li_lv_shadow;
-			if (ordered)
-				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
-			else
-				lv->lv_buf_used = 0;
 		}
 
 		/* Ensure the lv is set up according to ->iop_size */
 		lv->lv_niovecs = niovecs;
+		lv->lv_ordered = ordered;
 
 		/* The allocated data region lies beyond the iovec region */
 		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
@@ -373,7 +368,7 @@ xfs_cil_prepare_item(
 	int			*diff_len)
 {
 	/* Account for the new LV being passed in */
-	if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
+	if (!lv->lv_ordered)
 		*diff_len += xfs_log_vec_bytes(lv);
 
 	/*
@@ -388,7 +383,7 @@ xfs_cil_prepare_item(
 			lv->lv_item->li_ops->iop_pin(lv->lv_item);
 		lv->lv_item->li_lv_shadow = NULL;
 	} else if (lip->li_lv != lv) {
-		ASSERT(lv->lv_buf_used != XFS_LOG_VEC_ORDERED);
+		ASSERT(!lv->lv_ordered);
 
 		*diff_len -= xfs_log_vec_bytes(lip->li_lv);
 		lv->lv_item->li_lv_shadow = lip->li_lv;
@@ -410,6 +405,7 @@ xfs_cil_prepare_item(
 struct xlog_format_buf {
 	struct xfs_log_vec	*lv;
 	unsigned int		idx;
+	unsigned int		buf_used;	/* buffer space used */
 };
 
 /*
@@ -430,10 +426,10 @@ xlog_format_start(
 
 	ASSERT(lfb->idx < lv->lv_niovecs);
 
-	lv->lv_buf_used = round_up(lv->lv_buf_used, sizeof(uint64_t));
+	lfb->buf_used = round_up(lfb->buf_used, sizeof(uint64_t));
 
 	vec->i_type = type;
-	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
+	vec->i_addr = lv->lv_buf + lfb->buf_used;
 	return vec->i_addr;
 }
 
@@ -454,12 +450,11 @@ xlog_format_commit(
 	len = xlog_calc_iovec_len(data_len);
 	if (len - data_len != 0)
 		memset(vec->i_addr + data_len, 0, len - data_len);
-
-	lv->lv_buf_used += len;
 	vec->i_len = len;
+	lfb->buf_used += len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_buf_used <=
+	ASSERT((void *)lv->lv_buf + lfb->buf_used <=
 		(void *)lv + lv->lv_alloc_size);
 
 	lfb->idx++;
@@ -520,7 +515,7 @@ xlog_cil_insert_format_items(
 		 * The formatting size information is already attached to
 		 * the shadow lv on the log item.
 		 */
-		if (shadow->lv_buf_used == XFS_LOG_VEC_ORDERED) {
+		if (shadow->lv_ordered) {
 			if (!lv) {
 				lv = shadow;
 				lv->lv_item = lip;
@@ -548,7 +543,6 @@ xlog_cil_insert_format_items(
 			lv->lv_niovecs = shadow->lv_niovecs;
 
 			/* reset the lv buffer information for new formatting */
-			lv->lv_buf_used = 0;
 			lv->lv_buf = (char *)lv +
 					xlog_cil_iovec_space(lv->lv_niovecs);
 		} else {
@@ -1265,7 +1259,7 @@ xlog_cil_build_lv_chain(
 		lv->lv_order_id = item->li_order_id;
 
 		/* we don't write ordered log vectors */
-		if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
+		if (!lv->lv_ordered)
 			*num_bytes += xfs_log_vec_bytes(lv);
 		*num_iovecs += lv->lv_niovecs;
 		list_add_tail(&lv->lv_list, &ctx->lv_chain);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2be318c2eacf..35dd75f181e3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -26,8 +26,8 @@ struct xfs_log_vec {
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
 	struct xfs_log_item	*lv_item;	/* owner */
 	char			*lv_buf;	/* formatted buffer */
-	int			lv_buf_used;	/* buffer space used so far */
 	int			lv_alloc_size;	/* size of allocated lv */
+	bool			lv_ordered;	/* ordered logvec? */
 };
 
 /*
-- 
2.53.0

