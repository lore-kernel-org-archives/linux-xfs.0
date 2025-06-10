Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D7221ABBB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532626; cv=none; b=l1XiRsurTFr3btkmpMuJFB7NhELcPFhioJg6WAPZ5bf63DgOzWHQ+S+lX9zZ/FjgN6Uf0G6//QP6dUou1UFRmtbwch8TIpFdq6w2NVB7crQydT81pL6iC3dw3QHVc4BWhHY1w3qkk410wYeKoLNuETqiQxN5Vj/mzN3tThTasUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532626; c=relaxed/simple;
	bh=vl9bEIdDz0nP46z9MfgIkBJ2spv+FHcCpa3BV+WBKUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXv2j+544i8AuEOUHlBWIv+D9Y+aXo2B423vM4Lx42YjD8bPrXlPDAOrYM1W8AnmUjeCrt3G2UemifZp1fIIMaKenOhoYB9ooiF1h0m8SFzPV8zqf/6bnxRvF8FPdbEAxDwLb0DnaamoQiojZoKB4HIr3PQnpEt9NhQGPjsbIYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HWL+VKUY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HWL+VKUY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BczZLIdZ22CjzHFDaBtKgojQqP69J9ijFRIPqnifdhY=; b=HWL+VKUYwDRugVfYVeyhZ4tEOq
	mC3wA4WLsfAR5eyZZDTkNoulcYwvXAZhNNw7fKknHATf7Mufn0oUQje90RPsdKT2HFaOmmQd/gQTc
	KF8j3VQimO4DRGatg4PQmVUntXhvqfkKG2nkgtZ6HbCnILIIxL3iu9Ngm1V+TTImmcoWwVkLeLuzg
	wejoRbCXVbfTh4jCrYqXZ4rot+TqeqA3yCEPATFX3rGK1tAg6CuTOhdjWYB4zBFXPeB4EDkX2GHSk
	XhjGa4TZ/V02nEWEqcvBa9rTbaBmrPt4e3AtlBzWW2R5boZeaXHUjZPn1wYLVz2+rBsCXPXioULC/
	K2ydEHPA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrM9-00000005pJI-04mI;
	Tue, 10 Jun 2025 05:17:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/17] xfs: set lv_bytes in xlog_write_one_vec
Date: Tue, 10 Jun 2025 07:15:05 +0200
Message-ID: <20250610051644.2052814-9-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa1bd1fc79ba..621d22328622 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -802,14 +802,15 @@ xlog_write_one_vec(
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
2.47.2

