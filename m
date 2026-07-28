Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6645E3EDAAE
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226359; cv=none; b=g/LpNcl2zr+QT0rZCDCsBaUPfYfrYEOu+EM+y4GAmXWico0ZdUmYiZ7mi9CsxEqNrORcBo+7elpUxOtKygp4mB3C9QjiFftgtCNCBksKr4mSNg/HYA76ZKoIh5RMoEnBvkSI3+EABZ7sIq7LrVxd8F0IP63OL+BRGPqKG3IRysY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226359; c=relaxed/simple;
	bh=FPiNZH9g3Sex+eGf1q5wgkM1X7zvepd84olJ8JbLfcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKS76aGMrpes2lJehp95IkfNfokB5GKoa4RtRt3wXIXNiKKwRMctes8YSfHJk+xyJ8oca4lBkw1GTPJpYsZQpcidJBA8YgVEmYMDA+xTW5YaUz5Chhy0hyv0w3K1MFJDTilr96KC19dcNWjFSL/uXKtD52W6G68SvSNU6lG3byM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XWskuI4h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XWskuI4h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=b05IB2zOHVxnXERwXEe/1UjxKNLAaaZj4OF50Q1zjGU=; b=XWskuI4hah9XCoYUPvWnmP1TQN
	WqVn8f8ki1UUKa7BQuzYgmOuTYhvB3Jc+rGmEle7n5qxu5hMCSdnp0wZtRW055zo8Ev9XN1KZiM/r
	Ykyxdgs2CchtJiL8OsR6P8TvSkFxcSsBEXkFMIulb9gy97csoMMLbxz6hsu5GD4bgkpWyFtIbFaA3
	U9AcglmpuFtnEo3Wb/c6uZ6q2tF/CbexKBN1e57yh18UpjOAEMnig0qyo35ZhPtcirGldQyzSfPFy
	zC9KZs+Umu3HiDwkqsxhFwreyYwYGx9gyddng0Oxo9FJLrfMRoIVwBthMG27aOewdkH3Df17BHnEx
	dtdO+DGg==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocvV-00000004hBr-23tr;
	Tue, 28 Jul 2026 08:12:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: add lockless xfs_buf_readahead_map fast path
Date: Tue, 28 Jul 2026 10:11:20 +0200
Message-ID: <20260728081152.1778841-13-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728081152.1778841-1-hch@lst.de>
References: <20260728081152.1778841-1-hch@lst.de>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index bc23fa59680e..9d8a8b395a23 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -775,13 +775,23 @@ xfs_buf_readahead_map(
 
 	if (__xfs_find_get_buf(target, map, nmaps, flags, &bp))
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

