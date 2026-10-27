Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115772;
	b=bFagqj3E+Pd/jbYZZhGPedtI/Fs8zi9psAb1Nvm1k0NMnFnz3klS6U5Xi+l5lONYlIL2
	 4AO5Qqtn/qQQimdD2cOzIbVqQYm8aC+3qWo5aSGcyfgkwWWOnXVe4XymnsX3UhardvKHu
	 8mUbcutRFLeTO2eQmmoOSZTK9UDJL8vKEQy/iK5vX6kIvG0BlHZ43bLtK3s/Poyh7kc+l
	 6RuYjr+DKTpl1sYcLMnzT+TvmlpciG+P+7qN8eniOR0eStY7KUtIYsP6PGFJYzwBpMD02
	 JZZS2Rs8zxPv81O5dIQLo9psh6mxTFMu1Rcpe1NNm1eRwUp6KxwjVTBups4BI5o/BAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115772;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=5f5IY/rS1v0T+zmibVpCsevRRbtpJG0eVg0qZDqTr5k=;
	b=IjT2ujH18cBqTmapgjLyl2N1ocgyX262zuZDGg5a1PswmYl9BXzRMRBayeBhSgPTw0rr
	 NEH1GvhOz5JPqNQWs1kdICYtYZxwxyTf3YdAjORjShBZlOTs2MjgzoJql0LsqoCIjO/X0
	 +ZC6lOUAOA9yuXIEPQsf02C6r9S1UPHsBORp2mNlP1DuiVgIrxIRiMDTzddD2s0fh4aGI
	 0zoyurKJMvjirnKzhv8iohdR2fFl24pihrdKcaaEkJ/QSDb01Ny3KHQjeKnvVWHC4oqlr
	 EG/9M85gKeSrZMu/zpXLDwdWO4mfP6H8HCR6mlNG+5sp9c1biuP1MH5jHwQHiNhkulA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=kOuj7rWA;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD55606A31E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CD55606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=kOuj7rWA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5f5IY/rS1v0T+zmibVpCsevRRbtpJG0eVg0qZDqTr5k=; b=kOuj7rWA2H5O96Mkbe8gYtZYXC
	Fv0C2hgdjvur794IF98JwgdNnbXM0gpiBHFYxiqmKlOntIeGAf0b/gWvI8F28llgQv4WPyT/dEkVP
	xRx8FQ1qPzkeUc5Hq2JyAipSI/zLlOl/SwhbZfFz5LPxwDLHpGpxTGpb2vdgvanpAcoFM4rFipUwx
	HNEW/q7zxVfhvakuP42AHl/ILVL9kXm+WsT+636BQlJhQW1wdoDbfcMheKCiTOe5gS2ktb6XxhGzS
	GYj9vH9oaTp66m5a9luTYTfLBTZAEOmsBcAEkJr8UnsIgCUUtTho/+e3UWX5poib+XdpeVc4Tvazb
	6yTMq1XA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjK7-00000005Fwt-3Huy;
	Tue, 27 Oct 2026 15:42:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] repair: remove the unused queues_started variable in do_inode_prefetch
Date: Tue, 27 Oct 2026 16:42:18 +0100
Message-ID: <20261027154237.1997484-5-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/prefetch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3e03ae7f0210..e76e1c946592 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1024,7 +1024,6 @@ do_inode_prefetch(
 {
 	int			i;
 	struct workqueue	queue;
-	int			queues_started = 0;
 
 	/*
 	 * If the previous phases of repair have not overflowed the buffer
@@ -1067,7 +1066,6 @@ do_inode_prefetch(
 		wargs->func = func;
 
 		queue_work(&queue, prefetch_ag_range_work, 0, wargs);
-		queues_started++;
 
 		if (wargs->end_ag >= mp->m_sb.sb_agcount)
 			break;
-- 
2.53.0

