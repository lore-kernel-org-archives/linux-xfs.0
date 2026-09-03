Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DB389114;
	Thu,  3 Sep 2026 18:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460203; cv=none; b=X5iPkZDrwsTUFmVVEr9ox/GN3xJTgligk1aVqkxmD4MTazD+hHzh0X0FFDYDKfmE7PayZKD07FQ7+1gFKC3EXhSxcJj/46CnJLhhXq+BqwWz7bbzdmrOsOuTN/Qd6K/SvUuI7Ad363Avv2PMEKmeORg0EvmvSjuarrTqSshtTMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460203; c=relaxed/simple;
	bh=scTVfOEUItjdosptvl+093FHTl2lw3ZCIX81xPIg3T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbE/bngPP7AoKdSrCUAh8u1Gw6LuGJEYkiKFLT+PVqF6UvBvciaDX3Bpf2pvW0QDzIrfP5iC4SA+m/YtFVDuO01qWflG6xawHUHvX6rI2WlK9ByGKe2/kLnk3emjV51EzsLBsWN9vNyhJIA3+EjRvV9CwuIAxe/SED5WDTugze8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=bJdZVe6I; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kbCRJOxh; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="bJdZVe6I";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kbCRJOxh"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 6F8C61380127;
	Thu,  3 Sep 2026 14:29:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 03 Sep 2026 14:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460192; x=
	1788467392; bh=IXAbT3RhlQhLzfRcazVV9LtEcGIthgKmvu2c4KjzvuY=; b=b
	JdZVe6I4o5MKZYcnL79xg8tI+zVR1JDmMZgYVFSYtR8SqW35SnCD7g/95joxvX5X
	aXeiCt5fmfyFzCFRue3W5UV8XRQiKuUdwWOZwCtQqvOZT3DWv3JVv9JcG0K0dy6z
	+1IVzKjiCAydrk/jYoZ1N3nIx389GaoHaCK2qtKzAVusk0BCT4q9ut3ribRdqaFG
	3HOpf7GrmP3YSG5BASFZXnNUluqBvZ5WDJcF3TCq0hn7D6N+dW0IClv4L2Igw1yN
	0SRbbPhLWrY43keGKQ6H09PipuQM+A3hWHhhodd3Kn23f1D/Bpqli04sb3NZY55g
	qRsG7UEihGe/b4uDG3AVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460192; x=1788467392; bh=I
	XAbT3RhlQhLzfRcazVV9LtEcGIthgKmvu2c4KjzvuY=; b=kbCRJOxh0BQ9soMyK
	QxcADm17Z9hOm4OlolGPi0SrnBWReUD2ckX/nmzuoJlifUXT6nVBhFveGt7kp86I
	BnaLnr/WTe6DmCjOeP6bgSptQ3TrHOtcweAgVyJsMM4FEVVowAsHxo9HZh2GYxJP
	uhkXHeZIiWJoRdjnor/KDYrMnLyDXy8aPN9AaPhwQlrA9WGNax8Z6gR43tQYVFt7
	SI8w6ywcrUIaoGlEkDxAbqrzOTz/u+xfjzqrsLxoJU2QUR5Na6pquTBGZUvF+Svo
	GjArvPzD9Y1qBtyLUEtcEeooiKmLA9xiMHAKAYthIN241qIz4BAMOTGEXD1cJLv/
	JZoHg==
X-ME-Sender: <xms:oLyZamQVGNdkczEUw4ujq98e6mKSDthX3ByZkbfJBzaRrCB8NjcRIw>
    <xme:oLyZas2qWZCSsLMlpneve1pcewfBC8z-DSIzcuqlmd7JJZnOwZ29Gv1ahNWm-MEfq
    6mcQNjj8keHqV_x0S3pnkv8jxU4RaRw2WuxDTXm4A6DlRb95W6d3soc>
X-ME-Received: <xmr:oLyZamy8JXdk65FfrqWfFcm-YhebnVaoNqI7dB_fvCU9WgNwpMo8tSysjdU>
X-ME-Proxy-Cause: dmFkZTFt7tpQ23d6ma5ZKwjaUeV/XmiCXSwfUJTD/UMTaTx+tQ6P98fG4/H3PFA7hJFxaU
    SY7i6N6X86D7HaHpdbLHvMivEhulOmq3NoSfdg1pBrJA6v+lfq2ALheALUZjz6o7Nf8BIz
    DWIHLTWCbkC3w9bMwM7vsWb978omVdOmMplVzO2fLHjMRy1E/CxFkmf+2uWv7frAXfMOWG
    H/vdAXIPTaxMrzbmklMnL5PmRnZSJQIp5M1ihNDwszNqcLBuKJXCEkMPvIWqkfKnePof3W
    BlQ363pN/8dtwFHD474IAw0kAsBZ9JYvF7V9lEJnX7ro/M4XAHwxRodQrXyCYUn1NLN+PM
    0vfdcaBQjLc+HudZy9eIbs9FNURWggrBI09gzzjkvwtrJdKDbJanKkcjjxbA2wXLW5vmPV
    JHY7vjUWVS+tCavA8PcCB9/d4IboR/rmYFx7WSmkm5HX3rO99EzxgghTPold4UY7N8MLio
    ckoVvpjoVQYAuSOMa6WiILvVCXgNSpWb0YmrSVSnYN92LolbIS1ZBUCtfZZgzD+yHUUE+T
    3FBZrWGSTxV07/NgqDrk6AcNrJhpdb5ML5pWJ3Z4RwgqVY2AvQVvFXk+au178of9NJo1VX
    Jwuxz1BTVNt4FUyEe/8GbpTWtyYMn6RCqGxKo1ht9sgk2Nnrd0PTSdbQ5Fwg
X-ME-Proxy: <xmx:oLyZavuHxFCaE__idzlzleST_Hwy-4aB04oK_DIUgC8jEW3q8LHPAQ>
    <xmx:oLyZaoQjjhlR8coJrZ_7t3YPgze8Cuq1_c-6TgUlJgMjd6abvXYz7Q>
    <xmx:oLyZauJPYjUgw6MdakKpR9BRlup7X0NbjErrk6zDsKCZ7fX1m80wNg>
    <xmx:oLyZaoBnvdnVk_Tvhk9ijT6N82rviIKB8b6A451oA5FwPRg7zil38w>
    <xmx:oLyZapmtWYRjOs4e0_n9fIvuUjvPFeShLUaw9klDPO2pwpgb7Bt7NY2G>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:51 -0400 (EDT)
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
Subject: [RFC PATCH 1/5] mm: let folio_mkclean() report which pages had dirty PTEs
Date: Thu,  3 Sep 2026 19:29:39 +0100
Message-ID: <20260903182943.662461-2-kirill@shutemov.name>
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

folio_mkclean() walks every mapping of a folio and clears the dirty and
write bits of each page table entry. It has the per-entry dirty bit in
hand while doing that, but only counts how many entries it cleaned.

For a large folio those bits are the only record of which parts of the
folio were written through a mapping. Everything downstream has to
assume the whole folio changed because that information is dropped here.

Add folio_mkclean_dirtymap(), which takes a bitmap and sets a bit for every
page of the folio whose entry was dirty. folio_mkclean() becomes a
wrapper that passes no bitmap, so there is no change in behaviour yet.

A PMD entry has one dirty bit for the whole folio, so a PMD-mapped folio
reports all of its pages as dirty. That is the best that can be done:
the hardware does not track anything finer for a PMD.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/rmap.h |  7 ++++++
 mm/rmap.c            | 56 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..6fc0a6020252 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -927,6 +927,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
  * returns the number of cleaned PTEs.
  */
 int folio_mkclean(struct folio *);
+int folio_mkclean_dirtymap(struct folio *folio, unsigned long *dirty_map);
 
 int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
 		unsigned long pfn, unsigned long nr_pages);
@@ -990,6 +991,12 @@ static inline int folio_mkclean(struct folio *folio)
 {
 	return 0;
 }
+
+static inline int folio_mkclean_dirtymap(struct folio *folio,
+					 unsigned long *dirty_map)
+{
+	return 0;
+}
 #endif	/* CONFIG_MMU */
 
 #endif	/* _LINUX_RMAP_H */
diff --git a/mm/rmap.c b/mm/rmap.c
index 1f72d279ba68..aaf45ac79fa8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1100,12 +1100,18 @@ int folio_referenced(struct folio *folio, int is_locked,
 	return rwc.contended ? -1 : pra.referenced;
 }
 
-static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
+struct mkclean_state {
+	unsigned long *dirty_map;
+	int cleaned;
+};
+
+static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
+				unsigned long *dirty_map)
 {
-	int cleaned = 0;
 	struct vm_area_struct *vma = pvmw->vma;
-	struct mmu_notifier_range range;
 	unsigned long address = pvmw->address;
+	struct mmu_notifier_range range;
+	int cleaned = 0;
 
 	/*
 	 * We have to assume the worse case ie pmd for invalidation. Note that
@@ -1134,6 +1140,15 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 			if (!pte_dirty(entry) && !pte_write(entry))
 				continue;
 
+			if (dirty_map && pte_dirty(entry)) {
+				pgoff_t idx = linear_page_index(vma, address) -
+					      pvmw->pgoff;
+
+				/* The walk only visits pages of this folio */
+				VM_WARN_ON_ONCE(idx >= pvmw->nr_pages);
+				__set_bit(idx, dirty_map);
+			}
+
 			flush_cache_page(vma, address, pte_pfn(entry));
 			entry = ptep_clear_flush(vma, address, pte);
 			entry = pte_wrprotect(entry);
@@ -1155,6 +1170,9 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 			if (!pmd_dirty(entry) && !pmd_write(entry))
 				continue;
 
+			if (dirty_map && pmd_dirty(entry))
+				bitmap_set(dirty_map, 0, pvmw->nr_pages);
+
 			flush_cache_range(vma, address,
 					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
@@ -1181,9 +1199,9 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 			     unsigned long address, void *arg)
 {
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
-	int *cleaned = arg;
+	struct mkclean_state *state = arg;
 
-	*cleaned += page_vma_mkclean_one(&pvmw);
+	state->cleaned += page_vma_mkclean_one(&pvmw, state->dirty_map);
 
 	return true;
 }
@@ -1196,12 +1214,23 @@ static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
 	return true;
 }
 
-int folio_mkclean(struct folio *folio)
+/**
+ * folio_mkclean_dirtymap - Write-protect a folio and report what was dirty.
+ * @folio: The folio to clean.
+ * @dirty_map: Bitmap of at least folio_nr_pages(@folio) bits, or NULL.
+ *
+ * Write-protects and cleans every mapping of @folio.  With @dirty_map, sets a
+ * bit for each page whose entry was dirty; a PMD-mapped folio has one dirty
+ * bit for all of it, so every page is reported.
+ *
+ * Return: the number of page table entries cleaned.
+ */
+int folio_mkclean_dirtymap(struct folio *folio, unsigned long *dirty_map)
 {
-	int cleaned = 0;
+	struct mkclean_state state = { .dirty_map = dirty_map };
 	struct address_space *mapping;
 	struct rmap_walk_control rwc = {
-		.arg = (void *)&cleaned,
+		.arg = (void *)&state,
 		.rmap_one = page_mkclean_one,
 		.invalid_vma = invalid_mkclean_vma,
 	};
@@ -1217,7 +1246,12 @@ int folio_mkclean(struct folio *folio)
 
 	rmap_walk(folio, &rwc);
 
-	return cleaned;
+	return state.cleaned;
+}
+
+int folio_mkclean(struct folio *folio)
+{
+	return folio_mkclean_dirtymap(folio, NULL);
 }
 EXPORT_SYMBOL_GPL(folio_mkclean);
 
@@ -1241,7 +1275,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.flags		= PVMW_SYNC,
 	};
 
-	state->cleaned += page_vma_mkclean_one(&pvmw);
+	state->cleaned += page_vma_mkclean_one(&pvmw, NULL);
 
 	return true;
 }
@@ -1324,7 +1358,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 	pvmw.address = vma_address(vma, pgoff, nr_pages);
 	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
 
-	return page_vma_mkclean_one(&pvmw);
+	return page_vma_mkclean_one(&pvmw, NULL);
 }
 
 static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
-- 
2.54.0

