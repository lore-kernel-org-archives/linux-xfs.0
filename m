Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617891;
	b=3YTie/iYoURplsoacuWTahJ+c2vbGaW6bcuSy/GI+VTGUosMEVxI84ZRX7bjGD/CEume
	 q5MzwN81RY6Ca08QjZaCrQE+Zk5ohLfVIm1cExiAqjDfbUvR5qwWi5gdNe6GiJ9Tvem88
	 0dT+2Koup/vXNmuO38+uq4aW1M/nYYarXXPWv4Ms12A+58A1pTrjjytsWaOr9X+va2yRX
	 43FaAe8iCG29ael6hIsY0LoI4fmOy9SALpZmQKLENn22ZrqPlPQRwjiGVoJ7nkZMCBYMi
	 WlDaeG5QDS2o36JS7bf+qXLHEYurewEbZkhwGep6RAOjvpjjl+jqMB0hQ8OXlIkT/Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617891;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=Pjx2Htc2u+b7xbHIZSOTYX676ZKNPCvE/XTWOpyjuGs=;
	b=ht0AQeQkUfhLD9tD+5TTK0sSmtbTGmIf8z3es5hspeGSd10ux54g34JO8WqU66jGpX+Y
	 sosHMLIT0Pn0su4/FFqR6NsM7TkiyPuANkoRHtcW+DyK9NPXuT9dPr4GxOwJ3MYx1s0hN
	 q2TLt7PJjPIrrbaVjcDl9LVbzf7o8uptraRFr+xrXQ2OaUCVpBoU8llrn6N2gy7Ek7/L8
	 HDsyi1GC1mOsVEb+Y+/PcOEIuyS8NZOpJlokG+DycR71oJO8oqD3w0mwFkLg/FVnnwHyA
	 aNo81tO8+Y29fnRj8FVjDqkyTgPKH8IYoyXJb/Xs/Ygb7WH8SoJmJs8lsqdRJ+Q1hkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nLgfwBb3;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C656D606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C656D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nLgfwBb3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pjx2Htc2u+b7xbHIZSOTYX676ZKNPCvE/XTWOpyjuGs=; b=nLgfwBb3B9Q/epdY1dcvdE+0M5
	CTXPL93d/O0c47eum8pWrM9xDJDoxR2WyXziTC7yt92aZtWlBlWZtla79q3PjUslASU2ES+s5MxxX
	rwe+5IZrjrY2Nf/1CGGy/NLcWfAMUAqyWJ1IMuaN4AVMza4UHue49hg+nfo0554bxYxKDUX9irejx
	1GlB+ei5B+vQPipEc1Tslt6/Ezq2IE+VW16yOjwuz+pDwkklwmFXjsh/FCvi86stz/8qHT4NBGJkq
	yxQevL4KngiJ6oUSMMKZ0DYNSSA0wvPYO9hKTjRecVy2c2sx7lz3IAsUajJ3soCDo6ChTc279B1ob
	rfshSYkw==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEq-0000000ADmq-0RKs;
	Wed, 25 Nov 2026 14:44:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/15] xfs: factor out a xlog_write_cont_ophdr helper
Date: Wed, 25 Nov 2026 15:42:26 +0100
Message-ID: <20261125144430.728485-6-hch@lst.de>
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

Factor out the continuation opheader formatting code into a helper so
that the formatting logic is separate from the processing loop in
xlog_write_partial.  This prepares for generating the opheaders on the
fly, but also helps the code structure as-is.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 54 +++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 68934406a48d..9c2c02880384 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2006,6 +2006,33 @@ xlog_write_ophdr(
 		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 }
 
+static uint32_t
+xlog_write_cont_ophdr(
+	struct xlog_write_data	*data,
+	uint32_t		rlen)
+{
+	struct xlog_op_header	*ophdr;
+
+	ophdr = xlog_write_space_advance(data, sizeof(struct xlog_op_header));
+	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
+	ophdr->oh_clientid = XFS_TRANSACTION;
+	ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
+	ophdr->oh_res2 = 0;
+
+	/*
+	 * If rlen fits in the iclog, then end the region continuation.
+	 * Otherwise we're going around again.
+	 */
+	if (rlen <= xlog_write_space_left(data)) {
+		ophdr->oh_flags |= XLOG_END_TRANS;
+	} else {
+		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+		rlen = xlog_write_space_left(data);
+	}
+	ophdr->oh_len = cpu_to_be32(rlen);
+	return rlen;
+}
+
 static inline void
 xlog_write_iovec(
 	struct xlog_write_data	*data,
@@ -2077,7 +2104,6 @@ xlog_write_partial(
 	struct xfs_log_vec	*lv,
 	struct xlog_write_data	*data)
 {
-	struct xlog_op_header	*ophdr;
 	int			index = 0;
 	uint32_t		rlen;
 	int			error;
@@ -2145,31 +2171,7 @@ xlog_write_partial(
 			error = xlog_write_get_more_iclog_space(data);
 			if (error)
 				return error;
-
-			ophdr = xlog_write_space_advance(data,
-					sizeof(struct xlog_op_header));
-			ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
-			ophdr->oh_clientid = XFS_TRANSACTION;
-			ophdr->oh_res2 = 0;
-			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
-
-			data->ticket->t_curr_res -=
-				sizeof(struct xlog_op_header);
-
-			/*
-			 * If rlen fits in the iclog, then end the region
-			 * continuation. Otherwise we're going around again.
-			 */
-			rlen = reg->i_len - offset;
-			if (rlen <= xlog_write_space_left(data))
-				ophdr->oh_flags |= XLOG_END_TRANS;
-			else
-				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
-
-			rlen = min_t(uint32_t, rlen,
-					xlog_write_space_left(data));
-			ophdr->oh_len = cpu_to_be32(rlen);
-
+			rlen = xlog_write_cont_ophdr(data, reg->i_len - offset);
 			xlog_write_iovec(data, reg->i_addr + offset, rlen);
 		}
 	}
-- 
2.53.0

