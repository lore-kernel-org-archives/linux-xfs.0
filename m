Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF021C678D4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 06:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCCGng (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 01:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCCGnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 01:43:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6098E4615E;
        Thu,  2 Mar 2023 22:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=l0bVDDYKxFKWLQLx8FmnnA/uH0iOvM3wk3Zb4vJB2U0=; b=PByG0sF+ZdDNq4JqiMQ1GLR3IR
        WCjVdVLJT6FO+0wWkF5Q82qoz39sZ72ka3WgtabITFdXl9JGzaZVO+9pKE4ZPFeyK0mdm777Y1C9D
        8BLDLzCRY5RPo/Pj8LT8sFN9KPozjSTO929TZOA2NvoiU3GrN6kIn7dR4+mbG3dVQBGM44lD66FB3
        cWnUgNyWttRBFxeXMnfcHZJR2ifSpcS7ecd5ZPsIZvn/UcRwiCUn3ZwwC1mJ4KUqc5PoNLuF8OGSV
        IAbr7DoFb+QZ55ZkrWpArLnGDl1wlknDvun+6mOXYg4yRYADYwZgnBySHO0CsqahjLvDxz1nchq04
        OtYk260A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pXz8P-002wO6-HQ; Fri, 03 Mar 2023 06:43:17 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/2] filemap: Add folio_copy_tail()
Date:   Fri,  3 Mar 2023 06:43:14 +0000
Message-Id: <20230303064315.701090-2-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230303064315.701090-1-willy@infradead.org>
References: <20230303064315.701090-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a helper function for filesystems which support file tails.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 57 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c21b3ad1068c..618fe184c248 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -764,6 +764,7 @@ static inline struct page *grab_cache_page(struct address_space *mapping,
 	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
 }
 
+void folio_copy_tail(struct folio *, loff_t pos, void *src, size_t max);
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
 struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
diff --git a/mm/filemap.c b/mm/filemap.c
index 40be33b5ee46..b02d9c390d3c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4145,3 +4145,60 @@ bool filemap_release_folio(struct folio *folio, gfp_t gfp)
 	return try_to_free_buffers(folio);
 }
 EXPORT_SYMBOL(filemap_release_folio);
+
+/**
+ * folio_copy_tail - Copy an in-memory file tail into a page cache folio.
+ * @folio: The folio to copy into.
+ * @pos: The file position of the first byte of data in the tail.
+ * @src: The address of the tail data.
+ * @max: The size of the buffer used for the tail data.
+ *
+ * Supports file tails starting at @pos that are a maximum of @max
+ * bytes in size.  Zeroes the remainder of the folio.
+ */
+void folio_copy_tail(struct folio *folio, loff_t pos, void *src, size_t max)
+{
+	loff_t isize = i_size_read(folio->mapping->host);
+	size_t offset, len = isize - pos;
+	char *dst;
+
+	if (folio_pos(folio) > isize) {
+		len = 0;
+	} else if (folio_pos(folio) > pos) {
+		len -= folio_pos(folio) - pos;
+		src += folio_pos(folio) - pos;
+		max -= folio_pos(folio) - pos;
+		pos = folio_pos(folio);
+	}
+	/*
+	 * i_size is larger than the number of bytes stored in the tail?
+	 * Assume the remainder is zero-padded.
+	 */
+	if (WARN_ON_ONCE(len > max))
+		len = max;
+	offset = offset_in_folio(folio, pos);
+	dst = kmap_local_folio(folio, offset);
+	if (folio_test_highmem(folio) && folio_test_large(folio)) {
+		size_t poff = offset_in_page(offset);
+		size_t plen = min(poff + len, PAGE_SIZE) - poff;
+
+		for (;;) {
+			memcpy(dst, src, plen);
+			memset(dst + plen, 0, PAGE_SIZE - poff - plen);
+			offset += PAGE_SIZE - poff;
+			if (offset == folio_size(folio))
+				break;
+			kunmap_local(dst);
+			dst = kmap_local_folio(folio, offset);
+			len -= plen;
+			poff = 0;
+			plen = min(len, PAGE_SIZE);
+		}
+	} else {
+		memcpy(dst, src, len);
+		memset(dst + len, 0, folio_size(folio) - len - offset);
+	}
+	kunmap_local(dst);
+	flush_dcache_folio(folio);
+}
+EXPORT_SYMBOL_GPL(folio_copy_tail);
-- 
2.39.1

