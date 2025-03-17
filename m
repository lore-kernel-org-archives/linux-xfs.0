Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FE779D2
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190544; cv=none; b=j512vGYOt7nDc8mGVUXO7YPlPREMXO2OchzuUsKit0vrDMFsc+6vYzond5S1yYxrHiU+AktjGaNB+jbi4fuVuLuK1eFAUHE35AktlBN/inFPNIj2dqh+Gt+oFFzyDnHMOuSoGU4m+p48qTvwBMW6XHPid7zQSDs43Z9i4wJhnG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190544; c=relaxed/simple;
	bh=Nm6C6igqpALv/wY3y/6yePARbyn/ZaTPgcSB1LsUvt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVjevMSAVjRfKVuL/e9Rxahx00xZEIGTi3JGzNgYuegJgJ3n6vUckOQuoNsJDlKYlzvm0JXCC7kCU3tM8Ku0jLLpEttQZhIF5EvSCujcSrt1BdPVV+xlAcWnTyDTcBR1GlaiHmmqSh9m0sOaa58LVYllympYBHyaJBTKC/4bO+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YXEHHkPe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YXEHHkPe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xBH+WATQqlpbOQSvh+47ZY1UK+7Q04Lq57yGSNk4jeA=; b=YXEHHkPe4X/Byxqz5WuF1L7iR9
	zF9dZRt04ntDlNNv4gdl6e7oToEYKjL6s2XmHHhlaTKKvQEsuZCjqzbfbupjpATM2/qVz4vuS2W2T
	iHWpXFjeF5kEJaNXDtcvP6WMEqzpmU1TDH8VZGqBhwkJzLbZrzhtMMOAvYN+IFHjqwo890WYCHT63
	A3pF15OXKV8Qe/nIM+9ROUMy22LShgvo8NWgeC4saUdUvC311JtA/ag4XFTFDKVXuHeZ4uXBL6er+
	+uuB2NqQo+DHwr5tQ7/PD2zlJ8ujNfhuXFDMhwcK/P9VpCoot8t/M8AG3RjM++2ZlPtVqyCONlk3l
	DOFautAA==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3LS-00000001IoH-2rEn;
	Mon, 17 Mar 2025 05:49:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: remove xfs_buf_free_maps
Date: Mon, 17 Mar 2025 06:48:34 +0100
Message-ID: <20250317054850.1132557-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054850.1132557-1-hch@lst.de>
References: <20250317054850.1132557-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_free_maps only has a single caller, so open code it there.  Stop
zeroing the b_maps pointer as the buffer is freed in the next line.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 878dc0f108d1..bf75964bbfe8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -88,23 +88,14 @@ xfs_buf_stale(
 	spin_unlock(&bp->b_lock);
 }
 
-static void
-xfs_buf_free_maps(
-	struct xfs_buf	*bp)
-{
-	if (bp->b_maps != &bp->__b_map) {
-		kfree(bp->b_maps);
-		bp->b_maps = NULL;
-	}
-}
-
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
 {
 	struct xfs_buf		*bp = container_of(cb, struct xfs_buf, b_rcu);
 
-	xfs_buf_free_maps(bp);
+	if (bp->b_maps != &bp->__b_map)
+		kfree(bp->b_maps);
 	kmem_cache_free(xfs_buf_cache, bp);
 }
 
-- 
2.45.2

