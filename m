Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C663E324B2A
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949740; cv=none; b=bfJB7vulkOA/kX5ahQXf4wAZlyy3gQ1uTzK6O7dqm2NMOj60cgyggrjG7o4VsUYX49Fl/TjGqMW6m3ISSZ+9GAqo/fc3SCTL12R4ynNfdxR0FZ49k44Q/VVbPEIWkITfSLXVOxk7x3YnOG3YPAgXYZHZ5MsAVAhHgPe5x2hn18U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949740; c=relaxed/simple;
	bh=6efgM+wT+biG1zTBe25CCFnAXnkdECbbzI02xyYZBdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJtY3tTQcRIsyRr5Ufbbaumgw/x5zMhiBpEfzl9m0OlGmKv0SfUVngdd4EYhW0uNgPzLajmRZ7nUt0oRmrVlWI55nCiRTKgsG8m/lCq/8hEs1RTG09iXfHSXWNL7+LlNJU2mTQc8u1Rpdj/gt7WuWdWJMjvRfsu02iMFeGF+Zpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i9nqdLjv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i9nqdLjv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qpb2GMPfZHPcNr3yTZbFaOzfWS/m2F75aTqevSQ+CV4=; b=i9nqdLjvLkxno4sXeGHZoIANPc
	AIsystAEafqcEjYrcK4KofRVPdvKDv7OmV0vf08rbaVWWJmVIGuLteW66U8yLJsHYiJqe9zQs8zv/
	i31ov47O0xNIdjHShLKLwYlpXtnxsfseFpzBb5MWw1wGP69xkewwwyoJDvMARKUkxub65aIp5gxXI
	pLnJMPPaU6+iETKx80gS9l3oPX6UePD5TSezHMVkzLiyxozTbNz2To/4BZ2zWYzQR9BU5Q68ywacl
	ms2XKBe9D9CV9D8um/O8r/fUjoDwFb9V2cXqh5qAliGISLhrVYRKqdBakLC5ICpuj2PmUIOOVtLlO
	Cwyq0VKQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9lB-00000008lEx-2pXQ;
	Wed, 12 Nov 2025 12:15:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 10/10] xfs: factor out a xlog_write_space_advance helper
Date: Wed, 12 Nov 2025 13:14:26 +0100
Message-ID: <20251112121458.915383-11-hch@lst.de>
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

Add a new xlog_write_space_advance that returns the current place in the
iclog that data is written to, and advances the various counters by the
amount taken from xlog_write_iovec, and also use it xlog_write_partial,
which open codes the counter adjustments, but misses the asserts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8b8fdef6414d..511756429336 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1883,21 +1883,31 @@ static inline uint32_t xlog_write_space_left(struct xlog_write_data *data)
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
@@ -2038,7 +2048,8 @@ xlog_write_partial(
 			if (error)
 				return error;
 
-			ophdr = data->iclog->ic_datap + data->log_offset;
+			ophdr = xlog_write_space_advance(data,
+					sizeof(struct xlog_op_header));
 			ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 			ophdr->oh_clientid = XFS_TRANSACTION;
 			ophdr->oh_res2 = 0;
@@ -2046,9 +2057,6 @@ xlog_write_partial(
 
 			data->ticket->t_curr_res -=
 				sizeof(struct xlog_op_header);
-			data->log_offset += sizeof(struct xlog_op_header);
-			data->data_cnt += sizeof(struct xlog_op_header);
-			data->bytes_left -= sizeof(struct xlog_op_header);
 
 			/*
 			 * If rlen fits in the iclog, then end the region
-- 
2.47.3

