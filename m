Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4FA37AA79
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349695; cv=none; b=j8CufAAuG34UYRV5+o9TudOQu+yjT7/pgEDQzb57pTjqcucsIG3GDD5hKtTHwnMW2kpihqdxk25Twxq4Pwg9BQ6lNQc7KPcox8Xp+47+LxjriV7NTUoOHqzj8zFer44o8uzBW5Bxms2jyA07iQ9SwVTRa7/icIvizJ2+uCO+oGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349695; c=relaxed/simple;
	bh=BV0KjztgnZXL316vUtvwMEjFjSh4jwXk7yvAMPnLQrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ct2LySR3Ap6keahjPLX961lkkAyWCmGYwfAJHs63Bxh0AVWN34SUo/rjZma3GkKDXsxCL5t3uuTATxByeLz/+uLWhXfbcDGJHzEQMeEEdehq58Hl+AIzDHEvRWx2/ohV8ZeJVNavQSMnn5uTTNyL0Td3+MZUukmiJFwGe1T3usA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k1PX31Wz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k1PX31Wz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NyTcGUOSR40Optye+pC/3sSkojNIPWYzN1H0aSvcHV0=; b=k1PX31Wz9i2fCAzSIGvCaiTPyI
	cIkxhj6WwG7l3TWFf/Rc6yDQYVKFQ0IqswQO844u8YU4WruPwdFTafvuqvUOz9lrZgmidAP+p+EJY
	NO1UnY0hVKJ9CfXwtMm8nqR8Y6W15Pw9HpqCy7VKunWwVCVNCM060ErOaSYwIQtmwEC7fo/Vu7P4e
	PuNc7fRNkWPTwGCK4Spq+6O5n0YswddnlN5WCOr84GkFMOu2M18KHUTQDDgD0UaQMqKkxKD9EB2+4
	eBO37U+FVs7cFAS2v67wyult5btmfn0TTTNSgjEpZBvG5/RQGJSaB1A/EnsjQYp/EoTE41824bqTu
	TpehUPUQ==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jx-0000000DleG-1fSD;
	Fri, 25 Sep 2026 15:21:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] libxfs: return int from xfs_buf_item_init
Date: Fri, 25 Sep 2026 17:20:28 +0200
Message-ID: <20260925152107.3386097-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
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

