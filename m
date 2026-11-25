Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617900;
	b=SoIwHJQE7k68nJHIIWWH18xPJzfQIXwpKT7qNusHI/5BypB6NeYxzwAeWc5m/QRrgzA6
	 3iKx6ebdwPX7bevlxa/U7pNEDh9NqFyBta3R8kOCs1UGtXkoB4rfjIwUlNOYeIv6teHSe
	 L8TTNeniktqaWEHAj+DiaK0vwMJ5FimhCSOK3cEMIA4lhwBGY/1Sx71F+zMtMdNQCnT4D
	 25QLrr/bfQERWSpDjf7irMMSvLsB3+MXmdiuV646jeakWqMg5DRJhQp4x/f2CBOqvLiKG
	 2vRsD14SoC3rcG34bK6kXvpffwTJwXPu93Xt6LpUMYMqEJ0IP4DYJe/L5RK/w7lPzuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617900;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=xiay1T0+ep6yhEVekizI8BXanjfvRprLnoD07BjfdLs=;
	b=sUCbVboi/QMX/uIiknsZaG1PpswySJ9n+q+ScmchamaZyrr3TDjwPrwMCMwemYzVzc8Y
	 +NxE2RmobEItgwhO0eRzdQ7DNAbNvcElmlQ7qj1Y27YsAg2tWT8X3tCT4RDVJnCAsOYRU
	 gwGRJHYJifBJXRNM1XCrgJpp8jd41KqOqV29LIIl5uq/Sm1hmm+eBdt+abZcixiMUGPNL
	 O4XjcaR12M2Xr8b5rAupkB/k8OWhcbVAOJBUQUniA3AnYfcyiUyQ23rpuipH/Y9QFMBQk
	 46cuG7/77ZYmEaJDGtvjexFMk+q3TY7ViP70G8FEN0cxRpw4j4FiZ4A6y9FPLLBsxgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wgg7iRGI;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD7606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1DD7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=wgg7iRGI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xiay1T0+ep6yhEVekizI8BXanjfvRprLnoD07BjfdLs=; b=wgg7iRGI78sZKoRT/Z6x4xcf2b
	YJzCTKOnoN9wVpuBx+osKM9dPWAzPpUqpp75HQ7aIg4NdEpWYtMB9i9lnkztr8TWR6Z5dqRWEs3GG
	3QB3djWrst0BbfwYITOpqJqgnEnXIkg90SP1YNdV81K+m8C/FK+V2rQ6rC/KZWzi2UqEAm4FcjjzV
	tQgMvWv8036xcgXObZou3/2V7ZBggEYR4I0KBCdhzgAB+sqY8+YovZ4PIQUUOdma1JBxxWXNIpwf4
	IAuTS/J8tOISkb7xZf/5TsU9X5sL6aIXv/rs9BpRqD+No70Xmo32WzKk8nEhBpTWsx88N6ysydXlu
	sGWwZ7dA==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEF1-0000000ADqt-0pIJ;
	Wed, 25 Nov 2026 14:44:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/15] xfs: build the entire ophdr in xlog_write_ophdr
Date: Wed, 25 Nov 2026 15:42:29 +0100
Message-ID: <20261125144430.728485-9-hch@lst.de>
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

xlog_write_ophdr already builds most of the ophr, but still passes
through the oh_clientid value set by the caller, and seeds oh_flags with
the caller provided value.  Derive the oh_clientid and initial oh_flags
values from the i_flags value provided by the caller, and thus build the
ophr entirely inside of xlog_write_ophdr.  This matches what
xlog_write_cont_ophdr does for the continuation header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 27 +++++++++++++++++++++++----
 fs/xfs/xfs_log_cil.c | 16 ----------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 811987d5478e..b896f3e52110 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -839,10 +839,6 @@ xlog_write_unmount_record(
 		struct xlog_op_header ophdr;
 		struct xfs_unmount_log_format ulf;
 	} unmount_rec = {
-		.ophdr = {
-			.oh_clientid = XFS_LOG,
-			.oh_flags = XLOG_UNMOUNT_TRANS,
-		},
 		.ulf = {
 			.magic = XLOG_UNMOUNT_TYPE,
 		},
@@ -1992,6 +1988,22 @@ xlog_write_space_advance(
 	return p;
 }
 
+static uint8_t
+xlog_ophdr_flag(
+	struct xfs_log_iovec	*reg)
+{
+	switch (reg->i_type) {
+	case XLOG_REG_TYPE_LRHEADER:
+		return XLOG_START_TRANS;
+	case XLOG_REG_TYPE_UNMOUNT:
+		return XLOG_UNMOUNT_TRANS;
+	case XLOG_REG_TYPE_COMMIT:
+		return XLOG_COMMIT_TRANS;
+	default:
+		return 0;
+	}
+}
+
 static void
 xlog_write_ophdr(
 	struct xlog_write_data	*data,
@@ -2002,8 +2014,15 @@ xlog_write_ophdr(
 
 	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 	ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
+	ophdr->oh_clientid = XFS_TRANSACTION;
+	ophdr->oh_flags = xlog_ophdr_flag(reg);
 	if (rlen != reg->i_len)
 		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+	ophdr->oh_res2 = 0;
+
+	/* for historic reasons unmount uses a non-standard clientid */
+	if (unlikely(reg->i_type == XLOG_REG_TYPE_UNMOUNT))
+		ophdr->oh_clientid = XFS_LOG;
 }
 
 static uint32_t
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c7c3fa29eaa8..ec49fc5d03bf 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -438,7 +438,6 @@ xlog_format_start(
 {
 	struct xfs_log_vec	*lv = lfb->lv;
 	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
-	struct xlog_op_header	*oph;
 	uint32_t		len;
 	void			*buf;
 
@@ -453,11 +452,6 @@ xlog_format_start(
 	vec->i_type = type;
 	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
 
-	oph = vec->i_addr;
-	oph->oh_clientid = XFS_TRANSACTION;
-	oph->oh_res2 = 0;
-	oph->oh_flags = 0;
-
 	buf = vec->i_addr + sizeof(struct xlog_op_header);
 	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
 	return buf;
@@ -1180,8 +1174,6 @@ xlog_cil_write_commit_record(
 {
 	struct xlog		*log = ctx->cil->xc_log;
 	struct xlog_op_header	ophdr = {
-		.oh_clientid = XFS_TRANSACTION,
-		.oh_flags = XLOG_COMMIT_TRANS,
 	};
 	struct xfs_log_iovec	reg = {
 		.i_addr = &ophdr,
@@ -1232,24 +1224,16 @@ xlog_cil_build_trans_hdr(
 	memset(hdr, 0, sizeof(*hdr));
 
 	/* Log start record */
-	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
-	hdr->oph[0].oh_flags = XLOG_START_TRANS;
-
-	/* log iovec region pointer */
 	hdr->lhdr[0].i_addr = &hdr->oph[0];
 	hdr->lhdr[0].i_len = sizeof(struct xlog_op_header);
 	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
 
-	/* log opheader */
-	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
-
 	/* transaction header in host byte order format */
 	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
 	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
 	hdr->thdr.th_tid = tic->t_tid;
 	hdr->thdr.th_num_items = num_iovecs;
 
-	/* log iovec region pointer */
 	hdr->lhdr[1].i_addr = &hdr->oph[1];
 	hdr->lhdr[1].i_len = sizeof(struct xlog_op_header) +
 				sizeof(struct xfs_trans_header);
-- 
2.53.0

