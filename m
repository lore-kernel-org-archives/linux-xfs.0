Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617920;
	b=ZoHeuW6rKgTLCTUq5Cf4gw+3oQyz+n6jvEvuRxgv5OPwBBweci/eiZowoAj3W564DMUz
	 P8swdIauNk4e1t3Dinwu+8kR4gvS8JGOSeuIUlabdwvVkt9CUmH9kSPIPsjj9U49SxcgK
	 jCDk3CO2A6LnXP+Pe4hDTkGoI9VUn0TTGj4kRRB2J06SlxSCwXnJBfjghg/evH3bRYN/S
	 /5Y1Fmfnye1na/AOuzgzV8ShW/CNQkUx3lrtm3HhhlkJ0JTfYDyA7xOFCagh1VfVw64np
	 vR4y9x0ioG1Kq2t0Psa0M8IyO9qlJyU0hkb2pZ+jPCmeiC5a3g4Csgr5H+3pM3dfk3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617920;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=bMz+wgvKggZ9XKhAGZqQ0v+1NG2pKHTr8oC8zfY1AHk=;
	b=VA5/GaLgKn+lA3DBkbPhtOJnWrWfsNGaWGjYNHrN82ejsFJLlIuLofNqWd7stJDxW9Ls
	 OxlyTEzoR8HoVAdqL2DX7PD1W9rGJZFBLISjj+2SM35r6gpHwx0oWhL54s1xgsHx1NAGe
	 h5wEJbPHe79KB4axe2FocOLX+bXbIOra0/UoBlP3JDzvjH5lehBZb6el9pHlgu8TrY/Wp
	 /6eZaZXF/xYsF+968vST7xqseCf3mNkxRdknCeAbQC6Il5hwLTp4dWCtRONT2p1hDUZV0
	 NSBzwxJX12nfDmt00eLIqviDiBiYlQLNgtIaZ3i9Qw8kvNNyVUFZB2BWYFiFKpGtrZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Di8wgDaz;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B6A606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30B6A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Di8wgDaz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bMz+wgvKggZ9XKhAGZqQ0v+1NG2pKHTr8oC8zfY1AHk=; b=Di8wgDazMlr92LccNbcEQuyIlh
	2zgtszWgrSdLremQgp8pwTayMF9ZFl7h9hcDoDLoDmnV001lmKUMnGNWJD57BOmsknmBG54fEsixr
	DyiQ3mpHy+LLBu12Api9ibvXEwgvRvvOk8QeVPs4OlKG2V83sGd3aCH2T3EgJWG0EPFAmJLOEd2R+
	3PNIvXeBV4xwd/2hjYGBSO1pTfPCOEYVCaMFjUTz+zJzmc2hXrWLZuWcS09rJrmy0NkTOh+JOVrUa
	Z1blq/wDK/yrss7IoCB7jIKzlM9s0jUDF/K1XZZYiqEp1lyLlGD/nxBbkMQKC7ORj14k+wM+xmyVI
	5ZpJTRJQ==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEFJ-0000000ADvv-3GPX;
	Wed, 25 Nov 2026 14:45:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/15] xfs: remove the lv_bytes field from struct xfs_log_vec
Date: Wed, 25 Nov 2026 15:42:33 +0100
Message-ID: <20261125144430.728485-13-hch@lst.de>
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

lv_bytes is the sum of i_len in all log iovecs.  Replace it with a new
xfs_log_vec_bytes helper that iterators over the iovecs to prepare for
an accounting change in i_len.  Factor a few callers to calculate the
value once instead of multiple times to avoid extra work even if it is
fairly minimal.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      |  8 ++++----
 fs/xfs/xfs_log_cil.c  | 24 +++++++++++-------------
 fs/xfs/xfs_log_priv.h | 10 +++++++++-
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9ce2872faf29..0a59cbdcc3cb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -814,15 +814,15 @@ xlog_write_one_vec(
 	struct xfs_log_vec	lv = {
 		.lv_niovecs	= 1,
 		.lv_iovecp	= reg,
-		.lv_bytes	= reg->i_len,
 	};
 	LIST_HEAD		(lv_chain);
+	unsigned int		bytes = xfs_log_vec_bytes(&lv);
 
 	/* account for space used by record data */
-	ticket->t_curr_res -= lv.lv_bytes;
+	ticket->t_curr_res -= bytes;
 
 	list_add(&lv.lv_list, &lv_chain);
-	return xlog_write(log, ctx, &lv_chain, ticket, lv.lv_bytes);
+	return xlog_write(log, ctx, &lv_chain, ticket, bytes);
 }
 
 /*
@@ -1947,7 +1947,7 @@ xlog_print_trans(
 			continue;
 		xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
 		xfs_warn(mp, "  alloc_size = %d", lv->lv_alloc_size);
-		xfs_warn(mp, "  bytes	= %d", lv->lv_bytes);
+		xfs_warn(mp, "  bytes	= %u", xfs_log_vec_bytes(lv));
 		xfs_warn(mp, "  buf used= %d", lv->lv_buf_used);
 
 		/* dump each iovec for the log item */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f8ca67a63763..20c1d229cc61 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -351,7 +351,6 @@ xlog_cil_alloc_shadow_bufs(
 				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
 			else
 				lv->lv_buf_used = 0;
-			lv->lv_bytes = 0;
 		}
 
 		/* Ensure the lv is set up according to ->iop_size */
@@ -376,7 +375,7 @@ xfs_cil_prepare_item(
 {
 	/* Account for the new LV being passed in */
 	if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
-		*diff_len += lv->lv_bytes;
+		*diff_len += xfs_log_vec_bytes(lv);
 
 	/*
 	 * If there is no old LV, this is the first time we've seen the item in
@@ -392,7 +391,7 @@ xfs_cil_prepare_item(
 	} else if (lip->li_lv != lv) {
 		ASSERT(lv->lv_buf_used != XFS_LOG_VEC_ORDERED);
 
-		*diff_len -= lip->li_lv->lv_bytes;
+		*diff_len -= xfs_log_vec_bytes(lip->li_lv);
 		lv->lv_item->li_lv_shadow = lip->li_lv;
 	}
 
@@ -481,7 +480,6 @@ xlog_format_commit(
 	}
 	len += sizeof(struct xlog_op_header);
 	lv->lv_buf_used += len;
-	lv->lv_bytes += len;
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
@@ -568,14 +566,13 @@ xlog_cil_insert_format_items(
 			 * set the item up as though it is a new insertion so
 			 * that the space reservation accounting is correct.
 			 */
-			*diff_len -= lv->lv_bytes;
+			*diff_len -= xfs_log_vec_bytes(lv);
 
 			/* Ensure the lv is set up according to ->iop_size */
 			lv->lv_niovecs = shadow->lv_niovecs;
 
 			/* reset the lv buffer information for new formatting */
 			lv->lv_buf_used = 0;
-			lv->lv_bytes = 0;
 			lv->lv_buf = (char *)lv +
 					xlog_cil_iovec_space(lv->lv_niovecs);
 		} else {
@@ -1212,7 +1209,7 @@ struct xlog_cil_trans_hdr {
  * in xlog_write() for handling empty opheaders for start, commit and unmount
  * records much simpler.
  */
-static void
+static int
 xlog_cil_build_trans_hdr(
 	struct xfs_cil_ctx	*ctx,
 	struct xlog_cil_trans_hdr *hdr,
@@ -1220,6 +1217,7 @@ xlog_cil_build_trans_hdr(
 	int			num_iovecs)
 {
 	struct xlog_ticket	*tic = ctx->ticket;
+	int			len;
 
 	memset(hdr, 0, sizeof(*hdr));
 
@@ -1241,9 +1239,10 @@ xlog_cil_build_trans_hdr(
 
 	lvhdr->lv_niovecs = 2;
 	lvhdr->lv_iovecp = &hdr->lhdr[0];
-	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
 
-	tic->t_curr_res -= lvhdr->lv_bytes;
+	len = xfs_log_vec_bytes(lvhdr);
+	tic->t_curr_res -= len;
+	return len;
 }
 
 /*
@@ -1300,7 +1299,7 @@ xlog_cil_build_lv_chain(
 
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
-			*num_bytes += lv->lv_bytes;
+			*num_bytes += xfs_log_vec_bytes(lv);
 		*num_iovecs += lv->lv_niovecs;
 		list_add_tail(&lv->lv_list, &ctx->lv_chain);
 
@@ -1478,8 +1477,7 @@ xlog_cil_push_work(
 	 * Add the lvhdr to the head of the lv chain we pass to xlog_write() so
 	 * it gets written into the iclog first.
 	 */
-	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
-	num_bytes += lvhdr.lv_bytes;
+	num_bytes += xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
 	list_add(&lvhdr.lv_list, &ctx->lv_chain);
 
 	/*
@@ -1767,7 +1765,7 @@ xlog_cil_process_intents(
 			continue;
 		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
 		trace_xfs_cil_whiteout_mark(ilip);
-		len += ilip->li_lv->lv_bytes;
+		len += xfs_log_vec_bytes(ilip->li_lv);
 		kvfree(ilip->li_lv);
 		ilip->li_lv = NULL;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4ad66603b7a2..2d87f9eae493 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -26,7 +26,6 @@ struct xfs_log_vec {
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
 	struct xfs_log_item	*lv_item;	/* owner */
 	char			*lv_buf;	/* formatted buffer */
-	int			lv_bytes;	/* accounted space in buffer */
 	int			lv_buf_used;	/* buffer space used so far */
 	int			lv_alloc_size;	/* size of allocated lv */
 };
@@ -746,4 +745,13 @@ static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
 	return &rhead->h_cycle_data[i];
 }
 
+static inline unsigned int xfs_log_vec_bytes(struct xfs_log_vec *lv)
+{
+	unsigned int	bytes = 0, i;
+
+	for (i = 0; i < lv->lv_niovecs; i++)
+		bytes += lv->lv_iovecp[i].i_len;
+	return bytes;
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
-- 
2.53.0

