Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24A130CD82
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540177; cv=none; b=jUjIs6kezYnqGdgNyCnlm/VpucLtaK1KrH1hqBqeRomGNg5bhayeazwM52sNSfjOxtaOipz4aQrEN8LwJ/SkqquYeIbVQNCCToVQacgnbKhe+Ni77ytZ6VyN7WN3C8bDloQlo3H9tsAq2EJ+St+Cz2TPnfkkfAQSug001uDFUlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540177; c=relaxed/simple;
	bh=hsW0h9Et87rwYaKOVwb/ppslLKKPYvfqkNxv+NWFnDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=islRau/NcGpU+rZ5lDyHWAVe9j9TfyqGeqlPKQn5mOrHlV1ZKskbpfr1qlahSdwtZrycFNe7OrTcWj71an76XUHPfxCLb5TcruUBZkJEobZ1j28EbcNRW94wkUO9vBlaOBICeCO5Ejtk54gNl/OjXLNjAsIlG6KsvT5qyBHnNOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t3PQ/Xo0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t3PQ/Xo0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lpmafMOoEylXGRdFaE8LWdQz42Km04q9AvZwTXSGjyI=; b=t3PQ/Xo01s/jq95BwZj0QtweBh
	ayV7xldXskBvNPbrwpnkxPq9es+JnuL2ij/NHCOc6DKxz7yg5rHqgWHaYbVe5j6cw/xmcmovrqmTM
	1TcljAMzKFdDwxGl9ZbmJqyX/ZtTFYfXv+zhT5v03WX95UWwvZeKO3G2M+08u8kcbV/sK0ck3B92X
	1oHQVMgEOGtMrAzS9OgIp7odSj6ZJ67Cr0HtxgCUhMHFzkN0CiVPrgGJX0gE+6ZeBWIq6PoSKEGpF
	ZWwYjHFk0WhvAKhLF9CYt+TOzINig8lGd8ds0kgC8x0b7PYdF64OaxE4Mt964npV2qE0wYSAJxPbZ
	MFNRSG4g==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkQ3-00000006KzQ-3aNS;
	Mon, 20 Jul 2026 09:36:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: split an assert in xfs_trans_log_buf
Date: Mon, 20 Jul 2026 11:36:12 +0200
Message-ID: <20260720093612.2186703-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the "irst <= last && last < BBTOB(bp->b_length)" assert into two to
make it clear which condition fired.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_buf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 1e025848811a..a5d25b703dfc 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -521,7 +521,8 @@ xfs_trans_log_buf(
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	ASSERT(first <= last && last < BBTOB(bp->b_length));
+	ASSERT(first <= last);
+	ASSERT(last < BBTOB(bp->b_length));
 	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
 
 	xfs_trans_dirty_buf(tp, bp);
-- 
2.53.0

