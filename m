Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5193988FF
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127148; cv=none; b=UsyHQMo0QQztYCPN36xCMamewD8oRWvKG3rg8N71E0beK+Ob9jUpuu8+H6lwo6r+TnBRJV4RjPcwINa86/6DjGUvqLc0UvtLVA8kv5szU7Ozc6CBlEg6V9lO7TmsfCG9IqX+jXd79mEsZYlljYZDwe+Nu/MsMRcogAfIH6X6AG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127148; c=relaxed/simple;
	bh=bgAv56cenJN7BzqBnorrgmoJ3cgo5mhWBMrRC540NP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewPn9w8cp/yr/91rs3Uogcs8I5UCdnG8x+KvzlLBfICBmAvTG75RcuX96Sbl9QJ+5WoqeIWooPIxQd4d7lV2lvgRZVRbtqBbB07D5qBIHknl7yMBwyktyuC1GnhzZYiRiyWQfIzbth4K6aJ7HZQMZnBl+T5olIte/5TvFf+jJ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FOW0W0Uo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FOW0W0Uo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aIU4SatggCXPmLD+DmRZVhzuEKCi5oBJgV+VKhSG/Oc=; b=FOW0W0Uo9ldFRL0970OpC8UZ6Z
	S1Q1txJ8fqzcT8IHR2jPVNNK3TKzHjVwiuw+aw2w9hCZcGDmVljOiVXefcx41tRgH2yYh4qx2bUXt
	Onx7OdmmCAIP3lzYDIAwoXrX/Qko+RAVjX5YyghU64mgLG8VfZApIlmBzGWtUrUVRzj+teW5gsVSk
	NArUYilxQ/649ZEtw7chUKpzwCeAOYF8HzXR48Mexm/gE2UzcoCg1dHNj96PfVSN6mPZoakN88OCL
	ccgtlf5HMgRZvCjmrCD8qg0FLV4+VDWARL1buJsUd0EW78knTnur1TgBbcOf2QjsxsT60PkOlH4pA
	3nyMYnVQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0yI-0000000FDYs-3AaA;
	Wed, 15 Jul 2026 14:52:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: add lockless xfs_buf_readahead_map fast path
Date: Wed, 15 Jul 2026 16:51:05 +0200
Message-ID: <20260715145147.95654-13-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Readahead currently always locks the buffer, which can cause contention
with actual users of the buffer.  Add a fast path without taking any
locks if the buffer is uptodate and not stale.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f5701f74061f..2e498e9e05e9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -756,13 +756,23 @@ xfs_buf_readahead_map(
 
 	if (xfs_find_get_buf(target, map, nmaps, flags, &bp))
 		return;
-	if (xfs_buf_find_lock(bp, XBF_TRYLOCK))
+
+	/*
+	 * Do a lockless fast path check for a valid uptodate buffer and avoid
+	 * locking entirely in this case.
+	 */
+	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE)
 		goto out_rele;
 
-	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
-	if (bp->b_flags & XBF_DONE)
+	/* Otherwise lock the buffer to stabilize the state */
+	if (!xfs_buf_trylock(bp))
+		goto out_rele;
+
+	/* Let the actual reader deal with stale buffers. */
+	if (bp->b_flags & (XBF_STALE | XBF_DONE))
 		goto out_unlock;
 
+	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
 	XFS_STATS_INC(target->bt_mount, xb_get_read);
 	bp->b_ops = ops;
 	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_DONE);
-- 
2.53.0

