Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506163446C9;
	Thu, 23 Jul 2026 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818268; cv=none; b=gi+m4g33iYRDEJDnX1q3UhYkr4U+dwFUYRMBZbgoodGy6OpIcADsBU9ZIcg2D+tXMst1xFvWXVptZT1QFXMStc9akFWJuTFMj82YqIPrSBgnfPgIo5FQ2yyMyq2fMhp5CWF1QMyVxQFHvrEj3ZdPVzIULcExyoynkAgBW/XmlXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818268; c=relaxed/simple;
	bh=jQPLpsdMu/yfiiV5rxg6uPfYtILyDvkjzgqflX8bIxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oguwMGT7TlP7GX8/hq4teJpz/qwqUZRZu46ToZXglUcikePzOoNpzTLDHkUHnZ5OmPxDySgzbQD0xBwGjq5+bDTzB/iN/czYTBL0inNEGd5vu2x9aKzgxVx2YWb4wHxfyb62BJnKbwHgYkKyvQ4jhJS/qZ9fugKnODTqn4B5x40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YtBe9l5R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YtBe9l5R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lJXUsNBXWwm2bvnxO3tIqRJCgoqpf2VLkPKeacsR5EM=; b=YtBe9l5RFdFVJrHm0IZV7nNz0x
	WgxS/mhH3RfWTxXBvo0PxG0KHmxGgL8eMHK9qw813NPGK2xnfMGOhBy2ats/JHaUqsLhmfPHFwqZj
	ccjsCT9vTlEbXiufXE8eKvX7eTd6niyKNSLwm/9/WX2oHsj3L4hYT1w4VeQERazNtiOKHI3Fe/Mnn
	JFZnu2EJeRhwhjwyx/HQilDP8sUyWH+Ot+XFCihfhHflcxOeeXOk+LhwCZq3sIypejLoiVXmBDQH5
	oj0zgTzaobZM/1GzAupzFJspok14MQmY6wFkIkKXASY+TDM/wLAJt7vri4agDwUBX2uvjPICvLh0b
	26jjG72g==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulL-0000000EXLq-1oOb;
	Thu, 23 Jul 2026 14:51:03 +0000
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
Subject: [PATCH 13/22] iomap: add a iomap_ioend_flags helper
Date: Thu, 23 Jul 2026 16:49:38 +0200
Message-ID: <20260723145000.116419-14-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
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
---
 fs/iomap/ioend.c      | 10 +++-------
 include/linux/iomap.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 34f71c8b5ebd..b1bca36de430 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -216,7 +216,7 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 {
 	struct iomap_ioend *ioend = wpc->wb_ctx;
 	size_t poff = offset_in_folio(folio, pos);
-	unsigned int ioend_flags = 0;
+	unsigned int ioend_flags = iomap_ioend_flags(&wpc->iomap);
 	unsigned int map_len = min_t(u64, dirty_len,
 		wpc->iomap.offset + wpc->iomap.length - pos);
 	int error;
@@ -226,20 +226,16 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
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
 	if (folio_test_dropbehind(folio))
 		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index ff9afdd39682..2541ebfabca0 100644
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
2.53.0

