Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B58C3246E6
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949733; cv=none; b=UrT961LWMS6/uufIwD/ixQFuztzsmFBNCEO4l0fBl90P9DIA9X6EQGIoAE5rIen4htZLN/6yxbdpIbkng9Vj1ZYgaIkcgyL93+J5FJ62UF3N3eB5p57sv3H8FKw6yxWP3bkQHwBtrV5q/MPN9Zr7h39jTSFhnEp8RNT6GaPxUtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949733; c=relaxed/simple;
	bh=jvqwpRFhmz+R24NxzTageKRnn+NjlpxbqG3raNoxap0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBXmt+TU2nP2t9opfSQkDgk7bNfUToGhKE03/5gJ43F5RV8J76BUrGB4hDHfliMdK903ho/jequNBegMr8nj5+C1EoiwLPy29niYRSo1w2XtWUBdVXSfiIrMeehTlV1Xv9uwK9bsiMc56AgScEhC3sfRsDt3tSnStx7C5oxHCEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=coxdFPvI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="coxdFPvI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0pPq0xH7jKMFJUdeeFdoFhznhGyERMyXMOqKPyEG4i4=; b=coxdFPvIo0ya/nW7l4Qy8AR1dI
	gglSzRYrgX6UPFdBlvcdaXGtDcN+4o33MGyvTwAJkk2jZdYIRbqd4vVw/mzvZq9DlQy4hic1uaC5H
	HtfxhK4wAh5ne8VvUanSC/QVzQQYcKkqckeT7x57Wp/d5Mra8CIwb2EA2/ZKYpNrMZQ9LRPp3F8zH
	12DsabG94OtHVoNmovj3/l5Ke3FMJWH4mZZrtP6c48qPtKsEWjJlLCrpZJ9KPUzFTJmpe/6v8AYmM
	NGtKvMHGkMFK2X/gvRcFP7NC86NGEjWshBLIzuKH7HvqqSPbOy9E7/XGTsWrFg+EC6SJ0Dty9iRHA
	3D9wESfQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9l5-00000008lE4-1TGw;
	Wed, 12 Nov 2025 12:15:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 08/10] xfs: add a xlog_write_space_left helper
Date: Wed, 12 Nov 2025 13:14:24 +0100
Message-ID: <20251112121458.915383-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Various places check how much space is left in the current iclog,
add a helper for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2b1744af8a67..7c751665bc44 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1878,13 +1878,18 @@ xlog_print_trans(
 	}
 }
 
+static inline uint32_t xlog_write_space_left(struct xlog_write_data *data)
+{
+	return data->iclog->ic_size - data->log_offset;
+}
+
 static inline void
 xlog_write_iovec(
 	struct xlog_write_data	*data,
 	void			*buf,
 	uint32_t		buf_len)
 {
-	ASSERT(data->log_offset < data->iclog->ic_log->l_iclog_size);
+	ASSERT(xlog_write_space_left(data) > 0);
 	ASSERT(data->log_offset % sizeof(int32_t) == 0);
 	ASSERT(buf_len % sizeof(int32_t) == 0);
 
@@ -1906,7 +1911,7 @@ xlog_write_full(
 {
 	int			index;
 
-	ASSERT(data->log_offset + data->bytes_left <= data->iclog->ic_size ||
+	ASSERT(data->bytes_left <= xlog_write_space_left(data) ||
 		data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	/*
@@ -1978,7 +1983,7 @@ xlog_write_partial(
 		 * Hence if there isn't space for region data after the
 		 * opheader, then we need to start afresh with a new iclog.
 		 */
-		if (data->iclog->ic_size - data->log_offset <=
+		if (xlog_write_space_left(data) <=
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(data);
 			if (error)
@@ -1986,8 +1991,7 @@ xlog_write_partial(
 		}
 
 		ophdr = reg->i_addr;
-		rlen = min_t(uint32_t, reg->i_len,
-			data->iclog->ic_size - data->log_offset);
+		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
 
 		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
@@ -2052,13 +2056,13 @@ xlog_write_partial(
 			 */
 			reg_offset += rlen;
 			rlen = reg->i_len - reg_offset;
-			if (rlen <= data->iclog->ic_size - data->log_offset)
+			if (rlen <= xlog_write_space_left(data))
 				ophdr->oh_flags |= XLOG_END_TRANS;
 			else
 				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
 			rlen = min_t(uint32_t, rlen,
-				data->iclog->ic_size - data->log_offset);
+					xlog_write_space_left(data));
 			ophdr->oh_len = cpu_to_be32(rlen);
 
 			xlog_write_iovec(data, reg->i_addr + reg_offset, rlen);
@@ -2135,7 +2139,7 @@ xlog_write(
 	if (error)
 		return error;
 
-	ASSERT(data.log_offset <= data.iclog->ic_size - 1);
+	ASSERT(xlog_write_space_left(&data) > 0);
 
 	/*
 	 * If we have a context pointer, pass it the first iclog we are
@@ -2151,7 +2155,7 @@ xlog_write(
 		 * the partial copy loop which can handle this case.
 		 */
 		if (lv->lv_niovecs &&
-		    lv->lv_bytes > data.iclog->ic_size - data.log_offset) {
+		    lv->lv_bytes > xlog_write_space_left(&data)) {
 			error = xlog_write_partial(lv, &data);
 			if (error) {
 				/*
-- 
2.47.3

