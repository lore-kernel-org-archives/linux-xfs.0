Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEED2F50A2
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669844; cv=none; b=ChZqrQ9va483GlNCQEvjIGfBvDM6DLa261sl5gBFk8JxaQNWkfpsA0bnCnxJdOknsLd2J+PdBD6Amm14f7R5PUgmOoP68S5sOurfQoErHWIneyZqjpHtCwWr1Xsk6P3hF+JA00GuWfOzIluCi0ncp14581PO7UTxJiOJ5Tw+YbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669844; c=relaxed/simple;
	bh=OIlkrjlL0RywYjwBcpTwOY6gPSmdeCSpdzQDujOEeAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4ThqbippTnlv8g7MbwHydfiZ6Asyg5aJIrDXDACbY2HObXihT+chX1PZTGHghHcU83aUeWv6QJSxdMbzhYCouDE4Sh62E8ij8/lBYWcjgExWqN0IwtgZiTYVc0kJ/bEg20I+/CGgmSQvC0Yiu1eWKBCNelI6J3FeqZdcjl6C6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DvoINL0B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DvoINL0B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7+hwl/SlXIx0lMvWFtin6Ez6kKgf+idGyTOBa6lU39k=; b=DvoINL0B1yEcURUTtZ9BmdO9bA
	PKypHnhav/WHDPzmVfSqmwhWNz/l0HwmcZDt1M6QjL6oKwfECpa5zInRTlG2U8DdQT7D99cK3D2fh
	h45XP+iqUsrwt5d3EoGKsAtGZkCtFObAlMbgVPwfKucK3LS7m+yqsREPZImxm0Ip7yadyqih+6XKg
	W7Zhur8Ox9kMOUBMTvmBYdaiLH0Uea/pY2T2jHS0HSbbpLU54/NN1ueCN9LyJB/rQD7KxKPNWEuhM
	bFyL31lNo6wJyYLLLhUlTlbFtrjTxMjNGmRLqoHa7mDMnPFYrB2tuZPwaDe2TQ1TIMcmJC6PZnQCh
	Xmh2KGtw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1UQ-00000007gsk-240y;
	Wed, 16 Jul 2025 12:44:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
Date: Wed, 16 Jul 2025 14:43:12 +0200
Message-ID: <20250716124352.2146673-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716124352.2146673-1-hch@lst.de>
References: <20250716124352.2146673-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_reserve_more just tries to allocate additional blocks and/or
rtextents and is otherwise unrelated to the transaction reservation
logic.  Open code the block and rtextent reservation in
xfs_trans_reserve_more to prepare for simplifying xfs_trans_reserve.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8b15bfe68774..2213cb2278d2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1146,9 +1146,18 @@ xfs_trans_reserve_more(
 	unsigned int		blocks,
 	unsigned int		rtextents)
 {
-	struct xfs_trans_res	resv = { };
-
-	return xfs_trans_reserve(tp, &resv, blocks, rtextents);
+	bool			rsvd = tp->t_flags & XFS_TRANS_RESERVE;
+
+	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
+		return -ENOSPC;
+	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents)) {
+		if (blocks)
+			xfs_add_fdblocks(tp->t_mountp, blocks);
+		return -ENOSPC;
+	}
+	tp->t_blk_res += blocks;
+	tp->t_rtx_res += rtextents;
+	return 0;
 }
 
 /*
-- 
2.47.2

