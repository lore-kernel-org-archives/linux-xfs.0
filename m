Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2262244E652;
	Thu,  3 Sep 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460203; cv=none; b=jk9fUcUaaP/JdyStxYp/WhfGB1xLmVNvXw7L0fA8EKYDf6+nnqBrqg2YTKeCbinMvXr7BxYvQVsfBJqN92ZSk5GGrm9Bvcn0c+Xi4YmVC/A2LMxm3wkRxvGvdKX5Hn0gebKh1V+K8X1rTfmJKsR9mQg6N15kj7anAIQRu0S9Sgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460203; c=relaxed/simple;
	bh=s6YmXMhsMpKaQ7k8heM3VQkaEqiVhflX2lUvQHY4Pvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Htztfji8MkNQQoys6+H8JlASakozSoOgr5yFtJXFhr045qs3dXjdccjVJ1fM5H0uJ0TSe4h+SGAzQW+aCsNfkyDqBDKqPxlCaqFDnt04z7cX5WR578N4hAB8meKW8FsYInhTNBwUnaOYFNyGZytBtvWWb/dO2PPBIG6H71ieMak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=nuyJvhmf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ICPXCBfE; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="nuyJvhmf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ICPXCBfE"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id 7103013801B4;
	Thu,  3 Sep 2026 14:29:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 03 Sep 2026 14:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460194; x=
	1788467394; bh=G9VB0sdKC1XKz21nLpi2URn5ZyQ5pGM/85eGOTZORQs=; b=n
	uyJvhmfYQRHlIHNWbptwLQ+0wR/mTXr50Ep4IVzvnBN9VJAGlJfwTEEGbOSmD0sj
	8U2wKGhLv9SdB8zvnkG1GrKXEoegcSc+yGRCvoU6QlwwoNX0JAYKZqUevNj2kVtI
	G+6hWtTgtgr0ZXHhfFigDUYk2bccnYjGouRAjiRntPappxQmXaLRAqHktmdqEwGk
	82QA4MLyofmVulSGwYjzl9+i8FoCN+6TsusGfW+AfcJKRjfH3bFdWDD1sxUm/PMR
	f3t9i8yR/aq1IBkipjapx+gFYvWVRlH0Ou4YkXutcTEN/usEJiWvt5vM41gG4oNd
	beF9ced3G57SHnblDGYoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460194; x=1788467394; bh=G
	9VB0sdKC1XKz21nLpi2URn5ZyQ5pGM/85eGOTZORQs=; b=ICPXCBfErnIq545ty
	MYKmeRgwuDeQC/flzKJo3829hY3s8E5hZ4FX7tuxaW0UFig94Rj2yI1NQBVXq5vh
	7z1NLgeM3bikWeZqc6wVqhLIJPpvVRZ343ESwgBIlvXN6rWuJKvWieKEBnQR2R8J
	DdJhtRA81wb+lpJ+rK3zPgjpSoIqZ7eNNTEk9kif/pH82rKSCgblKNbfgQ0C9prX
	LBayyAyHKW1RNd5MOYwr/Yo30POrvtSI+pQNz9HkKGf5kCQABlHCFhe7kLHoPikP
	JJhMEAKRJjUn2Ug+cbIr7RAcBb6xgrQ2D8X8lWiB5BTzgGiBvM0TFzBHYsHBOCjK
	FQYHg==
X-ME-Sender: <xms:oryZatARA4foFu2wbRyk2avQuS5Sr-L2PRKfqFq5xhLcOmK7MIkRnA>
    <xme:oryZaskswPEIJK4OhJESs-L9fMAonkUcueo5D89YibfrT3-hRGzzkB8dFP_4NMKkR
    RHUcS3ZVlZhQMjOIszC95DRbq091bACFRzzWQYyzufp_7tLBiFUT6vY>
X-ME-Received: <xmr:oryZarh842RR1VPqOfuCMrHgqcJ2VuEyH1PUyabb-RHmwXOap5YKzz_1Vf8>
X-ME-Proxy-Cause: dmFkZTFt7tpQ23d6ma5ZKwjaUeV/XmiCXSwfUJTD/UMTaTx+tQ6P98fG4/H3PFA7hJFxaU
    SY7i6N6X86D7HaHpdbLHvMivEhulOmq3NoSfdg1pBrJA6v+lfq2ALheALUZjz6o7Nf8BIz
    DWIHLTWCbkC3w9bMwM7vsWb978omVdOmMplVzO2fLHjMRy1E/CxFkmf+2uWv7frAXfMOWG
    H/vdAXIPTaxMrzbmklMnL5PmRnZSJQIp5M1ihNDwszNqcLBuKJXCEkMPvIWqkfKnePof3W
    BlQ363pN/8dtwFHD474IAw0kAsBZ9JYvF7V9lEJnX7ro/M4XAHwxRodQrXyCYUn1NLN+Uj
    NdPYldr8Mq2IRZx0YyuQhIoiitm1QZtl4Syt/IqGnJWW5uRScoV3lGNcaWi5MYWySny51c
    TwILw9eVYuCxGIrYrqLo3zB0wXMnvyhES/hTXL4WkawgjP16PklJlBhJZkkqHSu5ZSeipJ
    vNQsPjbp1knfB3s+6DOtSIcyjNQSo+fvk74i8TsMuVFro5h5T4RQZDS/9sWdiKOQTAS3KJ
    Q+KPaFI3YoSacqM82ZxFZTjYhHPwfNu0Ug3d4Hx5T5s+kXfQFEYWmgo290U3VCybc+7Eq5
    +rvAeQmDrD+p82sLjT/fTXuwlbtObV0rjSi9zthMlSSAgvNSR/aZPKslN9wg
X-ME-Proxy: <xmx:oryZalewYzORhqKbB5Zj7WbERpeBIRt0Q3-YYYvHIBh9mD0vfpU8UQ>
    <xmx:oryZarD6ZJIAT5DzD2JxzFviaA5RLK0tpScfxtUS8sDJpcpIOIYLbg>
    <xmx:oryZap51vTL3PUAyrokmXqDyzMW3G3hHAzP8MALPWzBlvgdU8YoFhw>
    <xmx:oryZaoxgw26mMunJmi0SmpSRs3-71ZLeVUddZDvAvYBdgbwHZ-nZYg>
    <xmx:oryZapW6Pnnpi5qOYIUW4M92_I6galdmzyJT-n5zEjsg3YjBTzI1ZuiK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:53 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 2/5] mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
Date: Thu,  3 Sep 2026 19:29:40 +0100
Message-ID: <20260903182943.662461-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: <20260903182943.662461-1-kirill@shutemov.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Every way of dirtying part of a folio through a mapping ends up at
folio_mark_dirty(), which has no way to say which part changed, so
a_ops->dirty_folio() dirties all of it. A filesystem that tracks dirty
state per block then writes back the whole folio for a single stored
byte.

Add a_ops->dirty_folio_range() and folio_mark_dirty_range() to pass the
range on. The new operation can express everything a_ops->dirty_folio()
can, so folio_mark_dirty() goes through it with a range covering the
folio and a filesystem needs only one of the two. Filesystems without it
dirty the whole folio.

Use it in folio_clear_dirty_for_io(), where the page table dirty bits
were being turned into a whole-folio dirty. It now collects them with
folio_mkclean_dirtymap() and hands the filesystem the runs that were
dirty. A folio that is not already dirty still dirties whole, because
the clean to dirty transition needs the accounting in folio_mark_dirty().

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/fs.h  |  3 ++
 include/linux/mm.h  |  1 +
 mm/page-writeback.c | 87 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 072d8cd09a0b..1d98b6c0b880 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -406,6 +406,9 @@ struct address_space_operations {
 
 	/* Mark a folio dirty.  Return true if this dirtied it */
 	bool (*dirty_folio)(struct address_space *, struct folio *);
+	/* Mark [off, off + len) of a folio dirty */
+	bool (*dirty_folio_range)(struct address_space *mapping,
+				  struct folio *folio, size_t off, size_t len);
 
 	void (*readahead)(struct readahead_control *);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87feaa5a2b78..7628262c17e1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3337,6 +3337,7 @@ struct kvec;
 struct page *get_dump_page(unsigned long addr, int *locked);
 
 bool folio_mark_dirty(struct folio *folio);
+bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len);
 bool folio_mark_dirty_lock(struct folio *folio);
 bool set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6c9c7ba89b8a..39b54c25a9fa 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2751,6 +2751,21 @@ bool folio_redirty_for_writepage(struct writeback_control *wbc,
 }
 EXPORT_SYMBOL(folio_redirty_for_writepage);
 
+/*
+ * Hand a dirtied range of @folio to the filesystem.  ->dirty_folio_range() can
+ * express everything ->dirty_folio() can, so a filesystem that implements it
+ * does not need both, and a whole-folio dirty comes through here as a range
+ * covering the folio.
+ */
+static bool mapping_dirty_range(struct address_space *mapping,
+				struct folio *folio, size_t off, size_t len)
+{
+	if (!mapping->a_ops->dirty_folio_range)
+		return mapping->a_ops->dirty_folio(mapping, folio);
+
+	return mapping->a_ops->dirty_folio_range(mapping, folio, off, len);
+}
+
 /**
  * folio_mark_dirty - Mark a folio as being modified.
  * @folio: The folio.
@@ -2782,13 +2797,39 @@ bool folio_mark_dirty(struct folio *folio)
 		 */
 		if (folio_test_reclaim(folio))
 			folio_clear_reclaim(folio);
-		return mapping->a_ops->dirty_folio(mapping, folio);
+		return mapping_dirty_range(mapping, folio, 0,
+					   folio_size(folio));
 	}
 
 	return noop_dirty_folio(mapping, folio);
 }
 EXPORT_SYMBOL(folio_mark_dirty);
 
+/**
+ * folio_mark_dirty_range - Mark part of a folio as being modified.
+ * @folio: The folio.
+ * @off: Offset of the modified range within the folio.
+ * @len: Length of the modified range.
+ *
+ * Like folio_mark_dirty(), but tells a filesystem that tracks dirty state per
+ * block that only [@off, @off + @len) changed, so writeback can skip the rest
+ * of the folio.  Filesystems without that tracking dirty the whole folio.
+ *
+ * Return: True if the folio was newly dirtied, false if it was already dirty.
+ */
+bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len)
+{
+	struct address_space *mapping = folio_mapping(folio);
+
+	if (likely(mapping)) {
+		if (folio_test_reclaim(folio))
+			folio_clear_reclaim(folio);
+		return mapping_dirty_range(mapping, folio, off, len);
+	}
+
+	return noop_dirty_folio(mapping, folio);
+}
+
 /*
  * folio_mark_dirty() is racy if the caller has no reference against
  * folio->mapping->host, and if the folio is unlocked.  This is because another
@@ -2844,6 +2885,41 @@ void __folio_cancel_dirty(struct folio *folio)
 }
 EXPORT_SYMBOL(__folio_cancel_dirty);
 
+/*
+ * Write-protect every mapping of @folio and hand the filesystem the parts that
+ * were dirty in a page table.
+ *
+ * Without ->dirty_folio_range() there is nowhere to put per-block state, so
+ * any PTE dirty bit dirties the whole folio.  Same when the folio is not
+ * already dirty, because then the dirty transition needs the full accounting
+ * in folio_mark_dirty(), and for a folio too large for the bitmap, which the
+ * page cache does not make.
+ */
+static void folio_mkclean_for_io(struct folio *folio,
+				 struct address_space *mapping)
+{
+	DECLARE_BITMAP(map, 1UL << MAX_PAGECACHE_ORDER);
+	unsigned int nr = folio_nr_pages(folio);
+	unsigned int start, end;
+
+	if (!mapping->a_ops->dirty_folio_range || !folio_test_dirty(folio) ||
+	    WARN_ON_ONCE(nr > (1UL << MAX_PAGECACHE_ORDER))) {
+		if (folio_mkclean(folio))
+			folio_mark_dirty(folio);
+		return;
+	}
+
+	bitmap_zero(map, nr);
+	if (!folio_mkclean_dirtymap(folio, map))
+		return;
+
+	for_each_set_bitrange(start, end, map, nr) {
+		mapping_dirty_range(mapping, folio,
+				    (size_t)start << PAGE_SHIFT,
+				    (size_t)(end - start) << PAGE_SHIFT);
+	}
+}
+
 /*
  * Clear a folio's dirty flag, while caring for dirty memory accounting.
  * Returns true if the folio was previously dirty.
@@ -2875,9 +2951,9 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 *
 		 * We use this sequence to make sure that
 		 *  (a) we account for dirty stats properly
-		 *  (b) we tell the low-level filesystem to
-		 *      mark the whole folio dirty if it was
-		 *      dirty in a pagetable. Only to then
+		 *  (b) we tell the low-level filesystem which
+		 *      parts of the folio were dirty in a
+		 *      pagetable. Only to then
 		 *  (c) clean the folio again and return 1 to
 		 *      cause the writeback.
 		 *
@@ -2895,8 +2971,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (folio_mkclean(folio))
-			folio_mark_dirty(folio);
+		folio_mkclean_for_io(folio, mapping);
 		/*
 		 * We carefully synchronise fault handlers against
 		 * installing a dirty pte and marking the folio dirty
-- 
2.54.0

