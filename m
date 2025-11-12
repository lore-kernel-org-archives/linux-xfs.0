Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C70318120
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949710; cv=none; b=X3C1+MkMUaXZGs9KRxKPYRaWHkoy494j54FVnNW5/VJ+7Zc14dX6Cuo9S+I1HktpVMRnK3Mbs9JNYi8COm8b5btSzO46ULmWILPrg4JFX+dqJbc+Va702bT1FglUiVAKjuVWRh1spVeS5dXnFCcV4HMjdrb7wlTc2AxhgIvtIXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949710; c=relaxed/simple;
	bh=w8QUu7PIR10LAOrxwCNBvyZhtVEZ7aNx6nUE5NYtsPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj//wpV7K5d/lPQOOv+q/52ukyMGyKp2TIomu02mD1xOsf+vTmCaDZ+1sDRw2d23FEX5gRMzjx3g5vtE5uj37JO3A7MHbwwjwm/ZtboJZMgG0fl+JFfo6TV+UcfrXYWyA+OVLA9X3k95ucKbU4QBuk2sMZDlMk47sJskjb+V2IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CZF3SNQr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CZF3SNQr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QDzcE/YLyB34vY0n6DIUM/RBKt2m5y79ZDWPG3YnlkQ=; b=CZF3SNQr1NgZ/XSA10kBPtkFTM
	eI+hxITokdMY1a4s8n0WwYd60jTLBeQIa0nTiX7/xbSEykDThyJhzUmdTZy/r3dx44VkF3kmTx+ME
	yRw4BXz0/6FWcD100pv9DB0W8Fui3ddBu7sIEPkfFRvC8TnOLDLJOGngP64ATAgQeSscMuvuLXvx4
	n91exeMhgigsixlvJhJsZ6wSx2J4EKE8KHNhIHxANSn3in2NnuYeSLNDW3vxmn87QlAeYUEay1ofL
	pAUXRvUdLHCShNKpPn4eY4In7fQlJbiBTQZDX0a2SdfQG8L7Xt5YyorpxuoIVxyKBT7upSc8dcsj5
	Gr9qRtUA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9kh-00000008lAu-48i0;
	Wed, 12 Nov 2025 12:15:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Date: Wed, 12 Nov 2025 13:14:18 +0100
Message-ID: <20251112121458.915383-3-hch@lst.de>
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

lv_bytes is mostly just use by the CIL code, but has crept into the
low-level log writing code to decide on a full or partial iclog
write.  Ensure it is valid even for the special log writes that don't
go through the CIL by initializing it in xlog_write_one_vec.

Note that even without this fix, the checkpoint commits would never
trigger a partial iclog write, as they have no payload beyond the
opheader.

The unmount record on the other hand could in theory trigger a an
overflow of the iclog, but given that is has never been seen in
the wild this has probably been masked by the small size of it
and the fact that the unmount process does multiple log forces
before writing the unmount record and we thus usually operate on
an empty or almost empty iclog.

Fixes: 110dc24ad2ae ("xfs: log vector rounding leaks log space")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ed83a0e3578e..382c55f4d8d2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -858,14 +858,15 @@ xlog_write_one_vec(
 	struct xfs_log_vec	lv = {
 		.lv_niovecs	= 1,
 		.lv_iovecp	= reg,
+		.lv_bytes	= reg->i_len,
 	};
 	LIST_HEAD		(lv_chain);
 
 	/* account for space used by record data */
-	ticket->t_curr_res -= reg->i_len;
+	ticket->t_curr_res -= lv.lv_bytes;
 
 	list_add(&lv.lv_list, &lv_chain);
-	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
+	return xlog_write(log, ctx, &lv_chain, ticket, lv.lv_bytes);
 }
 
 /*
-- 
2.47.3

