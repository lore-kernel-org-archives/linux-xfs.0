Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8421F224AF9
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226345; cv=none; b=ijCA/bAkGtea8jrvgWTAmAYeVwRqRlAM8W6SZjbwkKfPx2L0B2eWXcA5LzgCnFaITFK5B6Ny8vqCDpRZVe4a8Whn/tedUUDGzlG4xg0HS905vwA5yMbSKuS0GoQjV8ChzZFY1lSByMAiUmIbYDT7lq+AAvDP67PAPDSwlAxtCE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226345; c=relaxed/simple;
	bh=yKGC7c0uOThqty5oo+WMopVzCJVtMkFGlPN+0zFxYOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA+PH+Fd7VDWlTtpxQIYuNvr/HdVax7r4aAAAK4ojMFakQJvxQ9JlNJ/107Pj5u/nRxMrygxfGTO1XX8UXaPvCzaEqH4U8tkOnpDB7soZg8rqelxSUabONVZqgn9kH7fIV6NZ4ylLvVqcJdX3kMhMns+b4aA1iLdNDTO4SvDREo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mQWdTgQ0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mQWdTgQ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0zQemfQy4hQiM1X7fbwRyCQzq4QOoZhuQfFzMmskCnE=; b=mQWdTgQ05VITBcBoP8ciNNidz3
	jVQMu9tN4mEMsqiB0hfk5kb2UDkyDDHpTOXycynIJbbNo2kos4vktvZlk/CH46NXA1xtLugMP/sXs
	r+HuOfVqWqE8u2uGcfVoRNGOzsICvpKTT/xHm/YNBEYzTph86yY5wiZZ4GJ4ac5KyPbxmDmOG7adX
	TG7LUnRY6GuHp1tTD7PhsfPwr9LbBTFQiecINDAP7TroZDhtu3JK0UZZ4cDQgL56VM2rZ0/aBgFjo
	tz5IE9q9rifaS9foO0rg8HrhgSdJj83OsYE0Cf296GM/vy6BA/iFEuYp8eSYCuuzXxJxiUomL8VGP
	cK4LRmQQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocvH-00000004h9J-3dCC;
	Tue, 28 Jul 2026 08:12:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/12] xfs: don't reverify buffers in xfs_buf_readahead_map
Date: Tue, 28 Jul 2026 10:11:16 +0200
Message-ID: <20260728081152.1778841-9-hch@lst.de>
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

xfs_buf_read_map calls xfs_buf_reverify to ensure the verifier has run
for a buffer before the data can be used when an earlier readahead read
the data before the buf_ops were assigned.

There is no point in doing this in xfs_buf_readahead_map for a buffer
already in memory as a later xfs_buf_read will do the same and can
actually propagate the error to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 69ace78f9e7f..d0dbe85fa20e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -777,7 +777,6 @@ xfs_buf_readahead_map(
 	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
 
 	if (bp->b_flags & XBF_DONE) {
-		xfs_buf_reverify(bp, ops);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

