Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240011B81D
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275818; cv=none; b=FpqEOG+SNjWe2mSfNI7pQIfm3qzVL7h3liNWTCWJpitYdwkmj/9q5Pe3IcIhnGa0CEcPlGfszzDhwHt1vd8qdHUZD9srw9DInAFgFaMyhKzyJEyUDaTNx/Ivg2QD67eZ4RdgJcoqxpnEYqyLuBt+J88ADoI+ErQvhSW0rU8uiLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275818; c=relaxed/simple;
	bh=+7JK41R7sLifzkpL5DNA12Zh1PqWX9jmTgakkrLGzus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FeiwW7BORS61XJ5A+ZMH8rA/6oP3P8yS+bVZmdmBZ46DlQNVfboj7QaUzNe6smfBr4mErJPEyHLFphIcMKYpc43YvPhbJybjCJ04Hfb0X/Lqd+b6DjkmBfaKCdXKvVywKwVvIvfgu4RUG4LeIv6Mt9Z8K0qOk2W/31zHMItMVDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xBGHGj1Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xBGHGj1Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=V5jPIUfKsRr3xLsTmFNsrdIB2xqWv10CXj3w8yCOnis=; b=xBGHGj1YCvV8LW1bNvApAzq9s2
	+XE2hub7o2/AJNtq37KwJ2Q+3ma57HUBNiG6rICNZVXDFHwoT5eTlKlpRnzcviEeSqJD+EFL74+2j
	rE42kauLYoPjXb5Li/njzEu2xtBBkD5iXHLqKjftVAtQbGhTbdLgMX0DPoBZUo8WgrsZfnnuJ9I03
	kcLvGUkg6CTQMPpsFOkzfVLy0Zon9JmN0EDBmCLtyPJIv7m9zLj6bK1I2y5BQjbXVEJ/h84WCwYBd
	UsFCmk8v7Nn8BTE6HEXoidT98Asq2lyAA4h+fJPEx0R80aDE8gRpCpr5l8kkRkeksaOPk1tyusiSb
	s/QwandA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHf-00000004Cuq-3E2m;
	Fri, 26 Jan 2024 13:30:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 16/21] xfs: improve detection of lost xfile contents
Date: Fri, 26 Jan 2024 14:28:58 +0100
Message-Id: <20240126132903.2700077-17-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

shmem files are weird animals with respect to figuring out if we've lost
any data.  The memory failure code can set HWPoison on a page, but it
also sets writeback errors on the file mapping.  Replace the twisty
multi-line if logic with a single helper that looks in all the places
that I know of where memory errors can show up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 077f9ce6e81409..2d802c20a8ddfe 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -99,6 +99,31 @@ xfile_destroy(
 	kfree(xf);
 }
 
+/* Has this file lost any of the data stored in it? */
+static inline bool
+xfile_has_lost_data(
+	struct inode		*inode,
+	struct folio		*folio)
+{
+	struct address_space	*mapping = inode->i_mapping;
+
+	/* This folio itself has been poisoned. */
+	if (folio_test_hwpoison(folio))
+		return true;
+
+	/* A base page under this large folio has been poisoned. */
+	if (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))
+		return true;
+
+	/* Data loss has occurred anywhere in this shmem file. */
+	if (test_bit(AS_EIO, &mapping->flags))
+		return true;
+	if (filemap_check_wb_err(mapping, 0))
+		return true;
+
+	return false;
+}
+
 /*
  * Load an object.  Since we're treating this file as "memory", any error or
  * short IO is treated as a failure to allocate memory.
@@ -138,9 +163,7 @@ xfile_load(
 				PAGE_SIZE - offset_in_page(pos));
 			memset(buf, 0, len);
 		} else {
-			if (folio_test_hwpoison(folio) ||
-			    (folio_test_large(folio) &&
-			     folio_test_has_hwpoisoned(folio))) {
+			if (xfile_has_lost_data(inode, folio)) {
 				folio_unlock(folio);
 				folio_put(folio);
 				break;
@@ -201,9 +224,7 @@ xfile_store(
 		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
 				SGP_CACHE) < 0)
 			break;
-		if (folio_test_hwpoison(folio) ||
-		    (folio_test_large(folio) &&
-		     folio_test_has_hwpoisoned(folio))) {
+		if (xfile_has_lost_data(inode, folio)) {
 			folio_unlock(folio);
 			folio_put(folio);
 			break;
-- 
2.39.2

