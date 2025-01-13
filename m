Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D718C008
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742353; cv=none; b=VzdkbnEGRrB7pKFlw4KqgwqyZz2TmFwnQNSQsvV8Z98hnF2scdriSrXyulT7NmDVOr/wtjvLyIzfM+OXCyTmsYfxP7AG0W5mH5R6b2sqPhODfONlSjvQRzfz3WVOBtw4aijFavJlbkaeneld6QgTAuVJ5dX7crF5rQkU1pRO//A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742353; c=relaxed/simple;
	bh=PbmK+eaNerpLudT78dMChVRNwEM/yBGFrKrOUgo2pSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCWCGGD73Ca+2EyB64t7F1DsRwQJLh3O8K/HWLQqClhqEtbXNBQSKfM/9HmH7v9hPDhvfs30s0tizqM/pkQM4H5Zs81JKwXbiZ2IbRC9wV5uhYu0xTO7YNjuiAlNEw4mwtfLT+MrU4GQ27QFBtqYxYk8Dxv7Msu9afUeGuHIdYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=REnJC7C4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="REnJC7C4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=moBlRA5CR89VeGACvpuLWFu5vkfpeyoUiyj6RSA42VE=; b=REnJC7C4XiT7IZffv5oQNN/SVu
	eTunxCGeTMkC8HR3jpKP8lK8YZBgXhfTgpYHqf5WxMJAz7Kf3PdnRXUsQyxh0ykVvCuPDnxbobPBi
	rWMmAcGwAsXxgeTsIUHVZrXiLaE26BlHwliVIiXqNW1yiCrgC5QR9zV+fO54kK5shE5R1t/Z4WVNG
	2SGT6f0pf3X2Zos+xpmbNzz5hbFaAYYHb4KNNJjsYw2qp6uxIi9pECPRzjsqw3G4WUIjG96+S9YIL
	SxiEwTUZfnjsJzVYNZgxYufuBFWGCQqbiRskVFtCDCfyCu6e49fbSvCOPqhALoOjBBrCE2tEpKiPA
	+WmfJaSg==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC1N-00000003ygu-3lwv;
	Mon, 13 Jan 2025 04:25:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: check for dead buffers in xfs_buf_find_insert
Date: Mon, 13 Jan 2025 05:24:26 +0100
Message-ID: <20250113042542.2051287-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113042542.2051287-1-hch@lst.de>
References: <20250113042542.2051287-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting
new buffers") converted xfs_buf_find_insert to use
rhashtable_lookup_get_insert_fast and thus an operation that returns the
existing buffer when an insert would duplicate the hash key.  But this
code path misses the check for a buffer with a reference count of zero,
which could lead to reusing an about to be freed buffer.  Fix this by
using the same atomic_inc_not_zero pattern as xfs_buf_insert.

Fixes: 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting new buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6f313fbf7669..f80e39fde53b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -664,9 +664,8 @@ xfs_buf_find_insert(
 		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
-	if (bp) {
+	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
 		/* found an existing buffer */
-		atomic_inc(&bp->b_hold);
 		spin_unlock(&bch->bc_lock);
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
-- 
2.45.2

