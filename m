Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB4037C903;
	Wed,  9 Sep 2026 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934198; cv=none; b=V5z+TnG0ZuyeFaaZAZKPzymOoLuh23ngmxsRL7x05120bz8OojF/6mJHr/UO9h5fwM6wrwXw4uOh0jhbm9I1MPCjy8tTxAlV48SlOClymVfv07/mhh4z++P7ED/cE7aynHJKe/pmf09Ju0oxGNT56yuGpgIfrG29eMbpe56I0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934198; c=relaxed/simple;
	bh=N5H5b0B72EHNkTcOFbBMTBkEZuOqi82U0GgZBGNvK9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBDDOgQNzEabWESN/2Ug51tfhCJLT7/eOrcWr9Lwg+HsHKz3uauwue7y/goUigonftdGJoohqou3fz6pDZ5jMlN0YsK/1WRmbEaiAB79eNkJfW5s7a2iCTYPVBqYNYvdm9oqt41kCD3hZnNS2AH/A9Rg0Q5GC+4ho0bpA9oXR8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sFg5VTpx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sFg5VTpx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oLlbBBLmsb7+ZCz2Sp/mFagvN1v4yqDlr2v2yFg+0kc=; b=sFg5VTpxnFgKwuHD+cKcXHzBQ0
	/7jn2KIbIXsyHpvvLzPZRmQ3Yurb+VGl1C7kznE6GfIqLnvtdK1sZT9Ik7Y0Ut4vKzUXJWfYcMoo9
	NrnfP1DXoFvHhEPunX2Gnok2xcaMbRNki/4mFu9z2RhkNEO5oun7fVwkfNGnr339YeDFi3FbOksT6
	6Va5BzMyhJ+7dyoMgDALxiVMwlTIVJt/qzOZBwiylwJ75e6MZlesP8Kte6tZt5bVxby933N+Kzb/T
	XZ7gAFNY0cCtRCDcw1/Bd3x96ZfQZs+0mESBjmCNPA6o2GnPvfTQ0a2cMvSGOIVicKSKlhUnd+UC9
	emMNJn9g==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BVL-0000000Aqh1-1Ela;
	Wed, 09 Sep 2026 06:09:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 05/16] iomap: add a iomap_ioend_flags helper
Date: Wed,  9 Sep 2026 09:08:54 +0300
Message-ID: <20260909060924.1102037-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to initialize the ioend flags to the values that can be
directly derived from the iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/ioend.c      | 10 +++-------
 include/linux/iomap.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 7bbbb417f915..2d77c11e3c18 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -215,7 +215,7 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 {
 	struct iomap_ioend *ioend = wpc->wb_ctx;
 	size_t poff = offset_in_folio(folio, pos);
-	unsigned int ioend_flags = 0;
+	unsigned int ioend_flags = iomap_ioend_flags(&wpc->iomap);
 	unsigned int map_len = min_t(u64, dirty_len,
 		wpc->iomap.offset + wpc->iomap.length - pos);
 	int error;
@@ -225,20 +225,16 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	WARN_ON_ONCE(!folio->private && map_len < dirty_len);
 
 	switch (wpc->iomap.type) {
+	case IOMAP_HOLE:
+		return map_len;
 	case IOMAP_UNWRITTEN:
-		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
-		break;
 	case IOMAP_MAPPED:
 		break;
-	case IOMAP_HOLE:
-		return map_len;
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
 	}
 
-	if (wpc->iomap.flags & IOMAP_F_SHARED)
-		ioend_flags |= IOMAP_IOEND_SHARED;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..8e09b2d4eda0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -491,6 +491,18 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_NOMERGE_FLAGS \
 	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
+/* ioend flags directly implied by iomap flags */
+static inline u16 iomap_ioend_flags(const struct iomap *iomap)
+{
+	unsigned int flags = 0;
+
+	if (iomap->type == IOMAP_UNWRITTEN)
+		flags |= IOMAP_IOEND_UNWRITTEN;
+	if (iomap->flags & IOMAP_F_SHARED)
+		flags |= IOMAP_IOEND_SHARED;
+	return flags;
+}
+
 /*
  * Structure for writeback I/O completions.
  *
-- 
2.53.0

