Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7526CE32
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311420; cv=none; b=jXc6WbtfJc0oS6GuYOv5BjTMNKG5jeA21EuQIzlWgrQMBQx/za5BtbvzNMmmmjpyu6PV6G9RbPwVKd2AnQKTk751yb9UYTwkM6grFRM1oRcnKQc7vaU6NuY3/3AfalqEPUZTV7T8i3w3T3cPtPEEFpPiAfsQLf6qe0HUDJfEsQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311420; c=relaxed/simple;
	bh=dvOAFzTxwrY6bFxSEPi92b/egU0kcdmwns2uMAxvub4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1oyKafCwjamhHYm+ls//hJDZpNSEFo8+qa96FnJjgF622KSATQ58pGSiqHabCSNZoqYwquxqiMEAsnJJPQRC77nB2qnQKtnkc5rrH7XNOu5wcFT1B1RtbqSw7JN08Mmd1iFgKl3SChJS4OawHpJGVSckd2BqaEMrABXBxgquiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tjydren8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tjydren8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UUBABLJr4mtqL9ceflWrMl71EE8nd53LuJv6gyD8LSs=; b=tjydren8LDgu7CI7vADL3bfWEk
	ITurdhW1unstk+t2enbGD1JzQuHSBRAQrnFlhEyiw4gXgW1qFjVeydJ8d2ATOE54t3vDaQcEgdDgb
	Zq+wUwT3aJsrvldXXFRBnKRUQlRi5Difmf+V7hERhh6P/K8ZMCOSc2WsEznhWavVwyH47YjOnDnPE
	N0sVS0UKSIUvy5TfBm9nrXvZoNiW4HRxK8E6cwBBunNfcfnPGaTYxmp6etmZ9sajItjZMiFmL9+MQ
	TRdYyejmCEvqSCUyx5oLHuTC29gp3IEzXCPwzXxnLIitAhay+taUF5bpxMqym3NiZ0kbRM7YXC53n
	tEg4DLxg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOrzm-000000002YK-0Lvc;
	Fri, 28 Nov 2025 06:30:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/25] include: remove struct xfs_qoff_logitem
Date: Fri, 28 Nov 2025 07:29:38 +0100
Message-ID: <20251128063007.1495036-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Not used anywhere, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 4f4bfff350a4..d7d390411964 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -59,12 +59,6 @@ typedef struct xfs_buf_log_item {
 #define XFS_BLI_INODE_ALLOC_BUF		(1<<3)
 #define XFS_BLI_ORDERED			(1<<4)
 
-typedef struct xfs_qoff_logitem {
-	xfs_log_item_t		qql_item;	/* common portion */
-	struct xfs_qoff_logitem	*qql_start_lip;	/* qoff-start logitem, if any */
-	xfs_qoff_logformat_t	qql_format;	/* logged structure */
-} xfs_qoff_logitem_t;
-
 typedef struct xfs_trans {
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
-- 
2.47.3

