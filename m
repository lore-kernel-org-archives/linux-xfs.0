Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115775;
	b=QyYMq1Y0jzpfRKZ7vGPffyFbQv8HYu4MUqPxsGQzYRQIw31VeHmP9hUFsUgbGJSX2EW/
	 QzNLmGRVxtrkSeTWCvR+pafCXi5qnitQmWFYtayKSglDbYrDoIdlDsWyRgTYlGNSj1HgL
	 +2FLz0TAXTueHj0Cfy2N0e/oZpK/fUizXJJpFhwkL7sGrvCJnIvltqT7jQAcW/Uc14MZH
	 igclOF2WdwWvxvt6jn6PL4fIAvEJ0xx8rt3EBu1iRJ6NHGud99OLwDON5BQRm64JLT8jh
	 BnPvATHDzxE83w3mOTcMG/3T44NXkcN+svV4eTsptKh/5BLLTH5vi7W21nRVD4wqbog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115775;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=k2sS5UbhrFn1tsqfa2r5ZfP9yDCd6aqc6kJHXYLk15Y=;
	b=e20vd06gQqsvzWdiy86WEJfIruCTetRdxannq0oEmapZwfsAZZ6/MN3Uth+QT91olt0y
	 2+ebJNvB0DnKcBtbceOGXfDJL9QQKbd2yBdKFtmho7Kd+xOSOioK4mfnBL3jgsCyijor9
	 Q9npzBTJ4gt0iYIu1IuChj8QvevvJaYTsY/7niXIYmz/+WCNM2sQ/Uqey7zdK82DQHgmA
	 XFpEt3TLcMoq15VYX95Kli1GZQOLqyI33dvwuKQ79BtNv/T/V5TmWGsolPsy15Ginbax8
	 mNbp6vRSGYM8/muZZnsv8NOC2nMWKWre4GtI0PBSsDxFn3dx/3q+5wJSBbG3pCnwKCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TgLtbbA8;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29154606A31A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29154606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TgLtbbA8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k2sS5UbhrFn1tsqfa2r5ZfP9yDCd6aqc6kJHXYLk15Y=; b=TgLtbbA8+UkqEa+np3+PsUOEjU
	XZEFEAds/dqr+aG1OMpmEEJNT+rMUHj6xCzEVA+ezrdlwNWBA9aPSDRk5WrosUxk4jglbAutvZ8di
	OFb6Koe5VYbB98kO/v6FglbMZ6v0MFXbP1HXwPP5nD99jyheRABwpR8RP4lJENsN8bo/PMkpLp/V7
	XDcyTVJtfyNjDXSAs+wn1MSOGkcnacZVHWYE0jC9eF4Ne2E7V9Uod4/3WfmNOo5AkZ3eEM0+0w4ny
	ogZ5CSE4PE1Pdc7a880M9+WDc/vJILQBnQY5y0Et6ut48xdVtzuMstdkPxyFMOMcxtAanDzjmo32a
	ks5D/xdA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjKA-00000005FxN-1beg;
	Tue, 27 Oct 2026 15:42:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] stubs: use the i paramter to trace_xfs_trans_resv_calc_minlogsize
Date: Tue, 27 Oct 2026 16:42:19 +0100
Message-ID: <20261027154237.1997484-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027154237.1997484-1-hch@lst.de>
References: <20261027154237.1997484-1-hch@lst.de>
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

To avoid a compiler warning:

xfs_log_rlimit.c: In function 'libxfs_log_get_max_trans_res':
xfs_log_rlimit.c:162:33: warning: variable 'i' set but not used [-Wunused-but-set-variable=]
  162 |         unsigned int            i;

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/stubs/xfs_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/stubs/xfs_trace.h b/libxfs/stubs/xfs_trace.h
index be9183fc33ad..2c7eb7ff0566 100644
--- a/libxfs/stubs/xfs_trace.h
+++ b/libxfs/stubs/xfs_trace.h
@@ -228,7 +228,7 @@
 #define trace_xfs_trans_read_buf_recur(a)	((void) 0)
 #define trace_xfs_trans_read_buf(a)		((void) 0)
 #define trace_xfs_trans_commit(a,b)		((void) 0)
-#define trace_xfs_trans_resv_calc_minlogsize(a,b,c) ((void) 0)
+#define trace_xfs_trans_resv_calc_minlogsize(a,b,c) ((void)b)
 #define trace_xfs_log_get_max_trans_res(a,b)	((void) 0)
 
 #define trace_xfs_defer_cancel(a,b)		((void) 0)
-- 
2.53.0

