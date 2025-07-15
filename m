Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A2F1EDA09
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582739; cv=none; b=ZPyWABvJZU1ph4LJJFZykc8aGY32OuvaElBCzovGaer8AAjfOihHuqdg2jLOB5frNBId2i3NXyLgLFc8Dr6WcaQthtjAIRwcC4eZEmPU0Z+NYZ7CyLCguLIHaIwNbh3mW191/30f9lIgWDILbduOQWyi5S5ExrYQ6fJ65ieeva4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582739; c=relaxed/simple;
	bh=LZks89VWzAx3Xi0AGExBpwe5ARnZeQgris4VY9RAH/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxRJY2GsLz6wp4gx0qBbg6hFep/lywelF832wk30TeEJnLaJGUbHtzJH7pOibOoYB6q7WHr9/VT4qJs0gc0O6QEabW4PdTlgKv03DUFUwbpD4rcqvL7wLDtBEZqLYyrKAguzvOrruLQlMNqtAd2cPLo+lj3QuSOld6MWFrxhBNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tcpUh7NM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tcpUh7NM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EJtlH+hO1K6RsfT2/AsevOlyuLvDEFRKuesvlTjL86Q=; b=tcpUh7NMvWJ3c0tC83r4gwuZJv
	Of0J72+l+m8FxOvvm3teJTBSAcURMIeXg3mN6md8RnoAb1vXCMqiyKI+9/wGGiUnlZ0Xisipngp9k
	G4xpT37OrFvJfx2/8M2A9jGISFIaPVxfAHmWO2k4em6A82dNL/CeI4FvtPaZoA3OP5OPQX+C+JB6g
	mH/eSIMBpbEIgxdI/CdBH5sGLfN6S5qxj9rjOsVlEzvDhc1+pu/diLFVoMJKgfGTDbN5Z328gaBsW
	cK0XmaFesUHaaTMqh6SA7G3AiyVZ6FgmY5GJftsh4G/O+qJG+aS7IazKvflG85xEHpdEt49MSJUAI
	HDOGC07g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepV-000000054wO-1und;
	Tue, 15 Jul 2025 12:32:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/18] xfs: add a xlog_write_space_left helper
Date: Tue, 15 Jul 2025 14:30:21 +0200
Message-ID: <20250715123125.1945534-17-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
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
---
 fs/xfs/xfs_log.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8a91f1b4d927..062eefac1a36 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1909,13 +1909,18 @@ xlog_print_trans(
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
 
@@ -1937,7 +1942,7 @@ xlog_write_full(
 {
 	int			index;
 
-	ASSERT(data->log_offset + data->bytes_left <= data->iclog->ic_size ||
+	ASSERT(data->bytes_left <= xlog_write_space_left(data) ||
 		data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	/*
@@ -2009,7 +2014,7 @@ xlog_write_partial(
 		 * Hence if there isn't space for region data after the
 		 * opheader, then we need to start afresh with a new iclog.
 		 */
-		if (data->iclog->ic_size - data->log_offset <=
+		if (xlog_write_space_left(data) <=
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(data);
 			if (error)
@@ -2017,8 +2022,7 @@ xlog_write_partial(
 		}
 
 		ophdr = reg->i_addr;
-		rlen = min_t(uint32_t, reg->i_len,
-			data->iclog->ic_size - data->log_offset);
+		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
 
 		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
@@ -2083,13 +2087,13 @@ xlog_write_partial(
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
@@ -2166,7 +2170,7 @@ xlog_write(
 	if (error)
 		return error;
 
-	ASSERT(data.log_offset <= data.iclog->ic_size - 1);
+	ASSERT(xlog_write_space_left(&data) > 0);
 
 	/*
 	 * If we have a context pointer, pass it the first iclog we are
@@ -2182,7 +2186,7 @@ xlog_write(
 		 * the partial copy loop which can handle this case.
 		 */
 		if (lv->lv_niovecs &&
-		    lv->lv_bytes > data.iclog->ic_size - data.log_offset) {
+		    lv->lv_bytes > xlog_write_space_left(&data)) {
 			error = xlog_write_partial(lv, &data);
 			if (error) {
 				/*
-- 
2.47.2

