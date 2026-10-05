Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A770481241
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205031; cv=none; b=qs+iNPflTLLQ5bJ8nf9Mn4BuZYk6ajBzgI+EXLI+QmQLjQ23sSTO9mRdHtxRO7qHktTvu+muzNpr05iI2K1XCj+HaZxp1QNSxXHHLUUp1t+qsjbRtsmv5alQKImt/3inW1jcfnXEgdBTk8NkjB3znmbR2Qpvzwe/WUn4N+Orl/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205031; c=relaxed/simple;
	bh=BV0KjztgnZXL316vUtvwMEjFjSh4jwXk7yvAMPnLQrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Muy6OaDVa8E2PlAbfRHM1OgIjwxnNiH+5Qybg4aIOyVy3TDlyuuCm1UuvGA+z+O8OaQpHtIlvrIp/6GV5Y6qggZUh5APamFBRyA33nmcEk7ZwRAvgHxX2A2F/pMS2SlaUrRVb6WCVrMzluzumQ9qMH/NZU4jrAZyp0ZRM27mapI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dpd6N8mL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dpd6N8mL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NyTcGUOSR40Optye+pC/3sSkojNIPWYzN1H0aSvcHV0=; b=Dpd6N8mLyVgrwvh/2heyuPOwfR
	GQyEYKjkVrmKr2WcJHnN/QM0yK2heTFp3Gz3cRpt4/2yQpZOuDwK78I8imX/gUAigyTRFeeNluZsY
	83mxu4JtaiXrCTrfEBvc+eoELKZE1+yQI4WLC2k3BsiFekNBhc8nmZP9lGTCbQPerZmXWdWQHd4Tz
	AHqWo0xVFut57e54LT87BAIgxdZzsFRoHVRTF+6BdmBZYh75uREJSA9Q0N8PakhexGacEKf3gbHhU
	flTp+2rmGQ0bVywDX3KIIvFkPPMJFCb8aObBhtTpPw5Xz1E3XhosQ9DmC4N2+o6Ck6C8ubyQNOMCE
	yv7yZQww==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFg-0000000GR7j-0uXx;
	Mon, 05 Oct 2026 12:57:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] libxfs: return int from xfs_buf_item_init
Date: Mon,  5 Oct 2026 14:56:19 +0200
Message-ID: <20261005125637.1340355-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Match the kernel version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/logitem.c      | 6 +++---
 libxfs/xfs_platform.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 0bb9088db351..2e050ad92a1e 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -71,7 +71,7 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
  * buffer (see xfs_buf_attach_iodone() below), then put the
  * buf log item at the front.
  */
-void
+int
 xfs_buf_item_init(
 	struct xfs_buf		*bp,
 	struct xfs_mount	*mp)
@@ -97,7 +97,7 @@ xfs_buf_item_init(
 				"reused buf item %p for pre-logged buffer %p\n",
 				lip, bp);
 #endif
-			return;
+			return 0;
 		}
 	}
 
@@ -112,9 +112,9 @@ xfs_buf_item_init(
 	bip->__bli_format.blf_blkno = (int64_t)xfs_buf_daddr(bp);
 	bip->__bli_format.blf_len = (unsigned short)bp->b_length;
 	bp->b_log_item = bip;
+	return 0;
 }
 
-
 /*
  * Mark bytes first through last inclusive as dirty in the buf
  * item's bitmap.
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 9aa898200da8..2e3d323505c5 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -408,7 +408,7 @@ void xfs_trans_del_item(struct xfs_log_item *);
 void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 
 /* xfs_buf_item.c */
-void xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
+int xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 
 /* xfs_trans_buf.c */
-- 
2.53.0

