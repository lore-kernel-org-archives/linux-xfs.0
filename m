Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617883;
	b=wmk9QKvLzI2xFQn0scOAcMMVmsVZ0HEnTiGU0wWtI3mXLor6c2v3dmLNWfMPVzS2lw2j
	 ltJe2puzdyaP7ld+5RQbRHd4qXue3Xdyl1e61arpWprsTZesxZLAJMLfRwfkhmiQhi254
	 wmv710AwpqM+Hqtm6yAA78FLPaVFqfaeIdSt0s7bPwIYoGcsKgDT+wksF35+rgLNtuatx
	 q2xqVvrSHv4wBkZXBoTAQAgUTwDNgFg/g/FX04fbilkVLbfvCqk09P23wdlZ0DhONfyf7
	 L1buL2RhUhmA6Ja8wjF/KY31hsckWVdZ38U+Zg/qSlEiBqI31X7e5AzYFMPp6ZOn+5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617883;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=h+jW2thRCQuYgdrGMvcODXfeXOel7aN/j7StR6m9GEM=;
	b=JhvHO7vP8yj/rNfELKqUz7uRtvYPM9UOJNqlN9K9dfvu2sWb/QwlvdKO6mtZNywRPiMi
	 nN1RgWcSMa7DoN8Ot5/vib5NzwUD+OfK73ZSVTxyZHZlQ7WGO4lilpA4MdsgZLt8L/Ecg
	 e+Qd879fkIKuBUWoScl0hJKKumNMUqOAADo9GpZ1NeFI2r3I6DkK5xAsvgs9ikTrWQKj7
	 7BBxiWihJ20DbZrhjWXHukU63W2Z1yAAI70IXtrBuPh+vW7XDmrj5Gkj9eGyVklzsfSZu
	 Ynv3cBXEo5vqJuLdHNYcGTjaunD3o9L5iiDC7AJTpNuH5pMVCC3Y5QyJedausUtTUaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YRX8KcVu;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F1606A323
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 922F1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=YRX8KcVu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h+jW2thRCQuYgdrGMvcODXfeXOel7aN/j7StR6m9GEM=; b=YRX8KcVuB6jj35JhF+ctL7CZ0Q
	TtMcsMxLGImiKT5cff9JDvNzzu/RcSUel0ufSsTnZQ9y8bJcTHYYnpSiNsUMAPCZ74+eNG1G6g6Va
	S72OM07S+fTkkJ/hv3IZf4Tgg+vJQHTpkPYyqr3H5eTUKj+vaZPEUCta+xBJwA1ZkibbT0eTeOk85
	9DPcM9DrU4OFTQgbBxhTJjgbrYEhRLMDbjqnG1NST0/ifPT0Im8GnDrintNX6emT+sMadzhvo6s5x
	cxv727Mi+DJTBZT0k7goQ/e7KFQX9yqHGH1n9JE2zhSfIQdnva4AqHZGQSHFSFHNcNpGGTsSIZ2y5
	hJx7RfQQ==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEk-0000000ADkO-352U;
	Wed, 25 Nov 2026 14:44:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] xfs: refactor the continuation loop in xlog_write_partial
Date: Wed, 25 Nov 2026 15:42:24 +0100
Message-ID: <20261125144430.728485-4-hch@lst.de>
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

Looping on a flag that is the effect of the size calculations is a bit
unintuitive.  Switch to a for loop that loops over the length of the
region instead, which has the same result but clearly documents what
we are looping for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7a067cfe59e6..e6dbd532bbdd 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2074,7 +2074,7 @@ xlog_write_partial(
 	/* walk the logvec, copying until we run out of space in the iclog */
 	for (index = 0; index < lv->lv_niovecs; index++) {
 		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-		uint32_t		reg_offset = 0;
+		uint32_t		offset;
 
 		/*
 		 * The first region of a continuation must have a non-zero
@@ -2104,16 +2104,14 @@ xlog_write_partial(
 
 		xlog_write_iovec(data, reg->i_addr, rlen);
 
-		/* If we wrote the whole region, move to the next. */
-		if (rlen == reg->i_len)
-			continue;
-
 		/*
-		 * We now have a partially written iovec, but it can span
-		 * multiple iclogs so we loop here. First we release the iclog
-		 * we currently have, then we get a new iclog and add a new
-		 * opheader. Then we continue copying from where we were until
-		 * we either complete the iovec or fill the iclog. If we
+		 * If we wrote the whole region, move to the next region.
+		 *
+		 * Otherwise we now have a partially written iovec, but it can
+		 * span multiple iclogs so we loop here. First we release the
+		 * iclog we currently have, then we get a new iclog and add a
+		 * new opheader. Then we continue copying from where we were
+		 * until we either complete the iovec or fill the iclog. If we
 		 * complete the iovec, then we increment the index and go right
 		 * back to the top of the outer loop. if we fill the iclog, we
 		 * run the inner loop again.
@@ -2128,7 +2126,7 @@ xlog_write_partial(
 		 * space left in the current iclog, and check for the end of the
 		 * continuation after getting a new iclog.
 		 */
-		do {
+		for (offset = rlen; offset < reg->i_len; offset += rlen) {
 			/*
 			 * Ensure we include the continuation opheader in the
 			 * space we need in the new iclog by adding that size
@@ -2156,8 +2154,7 @@ xlog_write_partial(
 			 * If rlen fits in the iclog, then end the region
 			 * continuation. Otherwise we're going around again.
 			 */
-			reg_offset += rlen;
-			rlen = reg->i_len - reg_offset;
+			rlen = reg->i_len - offset;
 			if (rlen <= xlog_write_space_left(data))
 				ophdr->oh_flags |= XLOG_END_TRANS;
 			else
@@ -2167,8 +2164,8 @@ xlog_write_partial(
 					xlog_write_space_left(data));
 			ophdr->oh_len = cpu_to_be32(rlen);
 
-			xlog_write_iovec(data, reg->i_addr + reg_offset, rlen);
-		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
+			xlog_write_iovec(data, reg->i_addr + offset, rlen);
+		}
 	}
 
 	return 0;
-- 
2.53.0

