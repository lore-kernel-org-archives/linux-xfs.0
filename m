Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668073ADBA2;
	Mon, 31 Aug 2026 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158457; cv=none; b=s019rOfwwrDQqX8N/Sqlnu/qbzGOPFwdYzYiAyfIpNVuaztXI5bJucOleErBUKBVXagD6pTkZYP7cVJQn44zoqkCdvLOE935mlywp34VeqgxGMmD35CZaQFtn3UPW5jYhMtYlPxUd9GEE+t0hzrAELpY4Ti40Cr4/si9I1WbEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158457; c=relaxed/simple;
	bh=N5H5b0B72EHNkTcOFbBMTBkEZuOqi82U0GgZBGNvK9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPdhSvPkYfMk8tuOmfeW6gysH1XKu/CBxQyrNcA6tls9yRXKlVLT6T1HPsQ3x7TG95TTbN1KFcIuz4KdLTevEyh9vHi1H5lq4V7rS3W1NphC5ILD0rDd9Tnx3DghuFEYd/PnPbkiDK3qWq1zTLuCtUt/hnkNLeMTV/MAxAAvfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2Aw3sgEF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2Aw3sgEF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oLlbBBLmsb7+ZCz2Sp/mFagvN1v4yqDlr2v2yFg+0kc=; b=2Aw3sgEF2Xcbr91mheLOV+Phng
	mrS/Pw9aEo7Q3NBBrurBXkWlBC2nBtX5lypU7PlPkLHi+geSKqHEb9iB/fEUwy0iOO928erl5Fno4
	k9gF0YZc5PMEz/8PmkQ7lUAojExSDp3+kyHBxqSFByn5xaoZX0UAgiRWeufmW1qRdq5t3fataRwfD
	mhnobjL2R2D1+Mmb19pgp03jxeN0lshanXU3/ASXI/45gmWPqmyA7RatZzzplSHgDyFX8gXDH7gf4
	mleM9ph4V7USjkjWA1gpQtTmTljdxmjVLrJdaV8Fc0kT8WOvqe+n87LYVj6pe5AXtIbxUsvppCdzc
	n033hd0Q==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vhN-00000008cva-3LSG;
	Mon, 31 Aug 2026 06:40:54 +0000
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
Subject: [PATCH 06/17] iomap: add a iomap_ioend_flags helper
Date: Mon, 31 Aug 2026 09:39:54 +0300
Message-ID: <20260831064010.2574896-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
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

