Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617878;
	b=AwgIsShW4jimSd1HpLyCC92HqqMG/l9SJIpjpUkIHl/YSuK6F9VWCwz42eEf3zv9pwi5
	 CxLccgv2mVfEQMi4LC+eYPnaobokA97Jjp3qbLLlPrKIMxU2uDY13PjJhHLjxr5ZU8AVY
	 i6Ygs1TWNCmF7yxnjwt2NbXAUxKc/O78n3v/NAm6mMqcOOE2OdvCzE+Yw/RNBTo6A6YdT
	 gSmXsCFAr+UAUrLJKOzSg9W3GKz9bDYGr1DDwojFJMgEz4mmXz1wsVCKrouQancRHwT/B
	 p8gnaw7TLoG5k4O7XyzcgC7TsU5d5G/A4Q+7yZNuBjTUf3mLRetJZpNcs1VxokAPLJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617878;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=3KCaJXltQcQszbGChhE6y8GYxLuhX2dy23UjaM0rBfo=;
	b=Xtfm0lzwQr5Pl7V48k45bpayR2/OrK/2Q3FMN+F0eHhy4UvIveNrNqIC/r4SUCRrcbv3
	 A+15LY9xZ1REOBZeuD8Rd2KXuXQfvYiV4yPtSar9fHa+Z3+RjtE/itcKH7UK3lPzuVnSJ
	 KLKekXuitCmFkJGBdDdScWgCJlYkR1q3s25xM7Ac+wV87sfkAa/7h5uEpq5kWnxQl+z7S
	 IIfBfBXrsMIx70Ewn8e0RrtWU7bV1eYvGjVQThbee1uSM5G/pjWWiDQgvXISTPQTZrmGN
	 NaX6vpYqQa6O2IfMB4eqaYSW1Ao4F7/F6lZpHRn3u0zcNRGbm74/fTQUvPTHgvBJMlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="t/myTqHo";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB1606A330
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47DB1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=t/myTqHo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3KCaJXltQcQszbGChhE6y8GYxLuhX2dy23UjaM0rBfo=; b=t/myTqHo5bX06u/yaV17j2ht6/
	Z27k9AnKh2SZtO2D67aE/rrV+B/iqM5USCqVM5+G+5tIWeLpDhw1BhlkHLfLEsTpLw7w4BKHRS+zg
	KlV1HFM+9VQ396n/UcIarNM1vky60XwqdB4WmloXJFNxjN5TOf4Up1FEuWM5zqOWEKbmHrLX2v2hK
	rBpIJfetLypeLKFwkS11hzdplxomLeeV3mxu9n2OjyX0Y+2cvfdQMR7FxkSDrwuMtsS33AdV9xUSu
	lnupTjOJ10y2+oeOSazEW39vp7ArAbT4IG24Zy5ugPFz2lqeuVLbCyR4zocuLw8E9s+Ubo6iH7dWe
	VaLoccvQ==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEf-0000000ADi9-25Q4;
	Wed, 25 Nov 2026 14:44:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/15] xfs: don't bother setting oh_tid in callers of xlog_write
Date: Wed, 25 Nov 2026 15:42:22 +0100
Message-ID: <20261125144430.728485-2-hch@lst.de>
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

xlog_write always stamps oh_tid into the ophdr written to the log, so
don't bother setting in the callers as those values will always be
overwritten.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 1 -
 fs/xfs/xfs_log_cil.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 74b324f915a1..9029e7856f1c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -841,7 +841,6 @@ xlog_write_unmount_record(
 	} unmount_rec = {
 		.ophdr = {
 			.oh_clientid = XFS_LOG,
-			.oh_tid = cpu_to_be32(ticket->t_tid),
 			.oh_flags = XLOG_UNMOUNT_TRANS,
 		},
 		.ulf = {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b54a421cab63..7ba4ef32479c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1189,7 +1189,6 @@ xlog_cil_write_commit_record(
 	struct xlog		*log = ctx->cil->xc_log;
 	struct xlog_op_header	ophdr = {
 		.oh_clientid = XFS_TRANSACTION,
-		.oh_tid = cpu_to_be32(ctx->ticket->t_tid),
 		.oh_flags = XLOG_COMMIT_TRANS,
 	};
 	struct xfs_log_iovec	reg = {
@@ -1237,12 +1236,10 @@ xlog_cil_build_trans_hdr(
 	int			num_iovecs)
 {
 	struct xlog_ticket	*tic = ctx->ticket;
-	__be32			tid = cpu_to_be32(tic->t_tid);
 
 	memset(hdr, 0, sizeof(*hdr));
 
 	/* Log start record */
-	hdr->oph[0].oh_tid = tid;
 	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
 	hdr->oph[0].oh_flags = XLOG_START_TRANS;
 
@@ -1252,7 +1249,6 @@ xlog_cil_build_trans_hdr(
 	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
 
 	/* log opheader */
-	hdr->oph[1].oh_tid = tid;
 	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
 	hdr->oph[1].oh_len = cpu_to_be32(sizeof(struct xfs_trans_header));
 
-- 
2.53.0

