Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026CE45C6FD;
	Fri, 14 Aug 2026 09:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699579; cv=none; b=jqJaoGHg+wp23IPa54dhdRH5mYRYTwi9Ma6kknnt3RHUr1SZ+KYZiaxTZG7SA+j16g054PYz3SRENnO4wE6C1B5yfakGpifF2YX/L6ZUxOZ4O0/bFLr7nEn1Ze7e/Q79rMY8iPilxDqoyr10xnWqXidXpzswgNcPkrU8yTKM39s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699579; c=relaxed/simple;
	bh=x5KSzFtHaSuLva9/HOEoCWV3PRhXt6+42FwNvOlBKnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDZYNKhGrP5/PttnmnQ0G5YCmFwCSTcpwMF9uMBm4RPnwIQCyPj00dHBAX+pvLdhiWRcK7KEz+f/IQQytufq4wtK0MVRyFsOOkhTu9XfoyqOk99wqXyVXmMXcXdokYpaaFqJTIqzviI2I6c5OLsDBbo5loO1qRbo/bBxT4V4plQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOQQqfzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOQQqfzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B491F00A3A;
	Fri, 14 Aug 2026 09:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699577;
	bh=QUXeMqxPDFfB1YOreWMQBvO4KxPIdaHtnGf4i8sQDz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOQQqfzhEfsuYP/m3e+Ed/w5/0NRir1nxh8SN/yzQgQCVWm8iC99JZWZIyc0i+4Mb
	 ZA5aZEJY8WgXXyqnPCMbCDGWY8dzkQSpjxjebuMoRC8tM/ZhsfYdYATzgMRykKlQg1
	 WLVPd+l4dnj9AZyUCRjloQhYl47UlOzqRXAJ+8N8ZMZyTGjry7RrAWtX4pLSCPNxT7
	 kNbe4lC84BUyLqsNGBHwPf3LA0Vwq70rtO4xEy4gx9bV6ywnkq791wnD5tms0Nvfxy
	 UdqxHUEVU6Nwt4ufyPKO4f8+5dgPVxxOq38HZV7NeyapxYT+KAMilkiFKaoPSvU/w7
	 wwlPOhUQtTllA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 09/25] iomap: add a iomap_ioend_flags helper
Date: Fri, 14 Aug 2026 11:24:26 +0200
Message-ID: <20260814092448.1818082-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Add a helper to initialize the ioend flags to the values that can be
directly derived from the iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/ioend.c      | 12 ++++--------
 include/linux/iomap.h | 12 ++++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index fb636dce43af..d71e7f5609c6 100644
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
-	case IOMAP_UNWRITTEN:
-		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
-		break;
-	case IOMAP_MAPPED:
-		break;
 	case IOMAP_HOLE:
 		return map_len;
+	case IOMAP_UNWRITTEN:
+	case IOMAP_MAPPED:
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
 	}
 
-	if (wpc->iomap.flags & IOMAP_F_SHARED)
-		ioend_flags |= IOMAP_IOEND_SHARED;
 	if (folio_test_dropbehind(folio))
 		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..7328e30fb8ad 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -415,6 +415,18 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
 	 IOMAP_IOEND_DONTCACHE)
 
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
2.54.0

