Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04EE1EDA09
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582747; cv=none; b=IIPosYR0o0fM1KDBsdBe7NnPPx/jNN0KAl8RIGD0caRfC90qa1uMUcyQTIY4Dm63cZI8J4Cmtc4JxRdCZlOYuwTAHU1gznx8ZXyUtMPBwVHRfS+TGH11rtP840DfD30Y6QmSw0B9iVEqM9SJN+IVGPhg83D3q8q3IOFuW0/qDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582747; c=relaxed/simple;
	bh=T+zdwgDAaYS2dus57slfYtb2nl5tVw72nHatVqjVH3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCOeYxjRcGO5fBBebm5WU+5WJi1DoUt9o2+a1av6M3waGDyu04fQ1H6ar7BXnvqA89Gw1j31JNy3v73hv343vhJ2Qcrqf1y5Z32ZfN/9ALYGcsyqc2cZdFLI89YFb/xADE2Ej8wUkPt2TDPNtmDCiAfG2kuwFVn0B5gbqZR1lNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hgJiO0k5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hgJiO0k5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QcQ45ukXduoDE+649ewLkelA+Tx24yG8hBp5sGrO3ug=; b=hgJiO0k5esd90ubJKwdjJchrNw
	l0BOAr8zieON5/Qsn5y3v7mc55dqY/VS4zUD2MgCZxYkGlkMoOHUpDoK3cmPExSV98xlC+PwXePsh
	FhUGpDm/dUAKJvnjQFft/bBguXvtqVJP8CrOhqLvnFKy+/phFMmG9oNhVnb3GoWsbNZAVSK7vQXQE
	F+Cxt8cDdY8oEnqojzz1XMqEysm+1VLhG6X0Alz8tyaaYexf0xUJl1fEyO/yBfW+OpfRXJZWgmYoZ
	aSY4h/R+whuvv0/L5o1Eb+NWUhb061s4y8p8Be8mEB95s20aYTa90RcGTSjpAsnAwWxUTpIP1BpFy
	MlCPDRKw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepd-000000054yt-0ZU5;
	Tue, 15 Jul 2025 12:32:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 18/18] xfs: factor out a xlog_write_space_advance helper
Date: Tue, 15 Jul 2025 14:30:23 +0200
Message-ID: <20250715123125.1945534-19-hch@lst.de>
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

Add a new xlog_write_space_advance that returns the current place in the
iclog that data is written to, and advances the various counters by the
amount taken from xlog_write_iovec, and also use it xlog_write_partial,
which open codes the counter adjustments, but misses the asserts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 48fc17cad60a..802329d2e360 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1914,21 +1914,31 @@ static inline uint32_t xlog_write_space_left(struct xlog_write_data *data)
 	return data->iclog->ic_size - data->log_offset;
 }
 
+static void *
+xlog_write_space_advance(
+	struct xlog_write_data	*data,
+	unsigned int		len)
+{
+	void			*p = data->iclog->ic_datap + data->log_offset;
+
+	ASSERT(xlog_write_space_left(data) >= len);
+	ASSERT(data->log_offset % sizeof(int32_t) == 0);
+	ASSERT(len % sizeof(int32_t) == 0);
+
+	data->data_cnt += len;
+	data->log_offset += len;
+	data->bytes_left -= len;
+	return p;
+}
+
 static inline void
 xlog_write_iovec(
 	struct xlog_write_data	*data,
 	void			*buf,
 	uint32_t		buf_len)
 {
-	ASSERT(xlog_write_space_left(data) >= buf_len);
-	ASSERT(data->log_offset % sizeof(int32_t) == 0);
-	ASSERT(buf_len % sizeof(int32_t) == 0);
-
-	memcpy(data->iclog->ic_datap + data->log_offset, buf, buf_len);
-	data->log_offset += buf_len;
-	data->bytes_left -= buf_len;
+	memcpy(xlog_write_space_advance(data, buf_len), buf, buf_len);
 	data->record_cnt++;
-	data->data_cnt += buf_len;
 }
 
 /*
@@ -2069,7 +2079,8 @@ xlog_write_partial(
 			if (error)
 				return error;
 
-			ophdr = data->iclog->ic_datap + data->log_offset;
+			ophdr = xlog_write_space_advance(data,
+					sizeof(struct xlog_op_header));
 			ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 			ophdr->oh_clientid = XFS_TRANSACTION;
 			ophdr->oh_res2 = 0;
@@ -2077,9 +2088,6 @@ xlog_write_partial(
 
 			data->ticket->t_curr_res -=
 				sizeof(struct xlog_op_header);
-			data->log_offset += sizeof(struct xlog_op_header);
-			data->data_cnt += sizeof(struct xlog_op_header);
-			data->bytes_left -= sizeof(struct xlog_op_header);
 
 			/*
 			 * If rlen fits in the iclog, then end the region
-- 
2.47.2

