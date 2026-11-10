Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.77
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794282738;
	b=T498mBpTzfoDluvV7S98d0aiYAKsGtigKFC79rxnGQbbXoLVvUsMs5AG31zoRFrsEV7U
	 4qzpjQwfLmrAUSwEYPDAgOtMzqOMOkGF6Yx1+QpZQ9CdFP503uk0ynTOf0Dt7seksznyb
	 Vbs6b5LlR24J59G5XJNSKtO6GJj3rU70Pt0nYnoINPxlrDCmgfU+iU2UaFfWmGxnyFps/
	 gmaA+PdDjIWhupAX7kgtA6emXlQ1675KSUCpwPBM0y7veKOqStPVM9mMsZrFJf5pmf80u
	 stDjLELJvFDTo9tuQXYsPy84Fdlw4MHBeySz4j5OrMaXIyPwQWZaEL38PqZmw+p/c5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794282738;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LnJWD/eQmPATzcQ3ya5TLYOaFRBgryPz/dxqLK+YACk=;
	b=qWbv5E1gR3X4MpJC1FmkkjElwsjQ5LZpxZOcH/NA76kSlOv5zqCRkF4zdPVavRJqKWPr
	 LFzhoylEPGWJNvos2N+aY50yNDqJAJEzHWQZFlLGY7xGEYhqDPTm7SOtUCUQSIbhhUtwz
	 fo9Z+8Vv2VLRxUXZWXM5HkQ3Y7Y+rj7QVQcAGm2FdFC3lN/5/AaCwGm37JOJkYO8vsFbt
	 c7PX1ZcXMAvawz5xW5Kh0G4knVBSFXMfhh0GbmhL5Kn/AyRq3YmZXAgDH+LZTBovs/IuV
	 tnezIStuVw03NeQ73OCGfvulG8jwHhyRFShVj41q6F8V1vKQG4mM+KTJ5L+oTEPnNZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=xiaopeng.com;
	spf=pass smtp.mailfrom=xiaopeng.com;
	dkim=pass header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=a3pcsMJF;
	arc=none smtp.remote-ip=115.124.28.77
Received: from out28-77.mail.aliyun.com (out28-77.mail.aliyun.com [115.124.28.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E151C606A32A;
	Tue, 10 Nov 2026 03:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E151C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=a3pcsMJF
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1794282735; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=LnJWD/eQmPATzcQ3ya5TLYOaFRBgryPz/dxqLK+YACk=;
	b=a3pcsMJFG309kdgtvljhnVorU7N7qH6gd3Rrrtvf3QWyltU5Fx3PAMbRqQrzgn4SyUYJaELG3lVnGbynXEuvjd+CS1mVZAYEhgIfKUGuWFk9TLwpAa8BMeok1jzaOg2ZJWblnQR3pbH9cINZOZzQgCO6eSsq2Jf9BfDFCHNYGvk=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04436259|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0321415-0.00146777-0.966391;FP=14329174377433204728|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033040092104;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=28;RT=28;SR=0;TI=SMTPD_---.k-eCFpa_1794282731;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.k-eCFpa_1794282731 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:52:13 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Carlos Maiolino <cem@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Liu Chao <liuc63@xiaopeng.com>
Subject: [RFC PATCH 3/3] mm: enable filesystem page-cache large folios without THP
Date: Tue, 10 Nov 2026 11:52:05 +0800
Message-ID: <20261110035205.3036-4-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110035205.3036-1-fangxy@xiaopeng.com>
References: <20261110035205.3036-1-fangxy@xiaopeng.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ten filesystems already opt in to file-backed large folios by calling
mapping_set_large_folios() or mapping_set_folio_order_range() from their
inode setup, unconditionally.  Every accessor that reports those orders
is nevertheless compiled out when CONFIG_TRANSPARENT_HUGEPAGE is
disabled, so the opt-in silently has no effect today.

Gate the page cache order accessors on CONFIG_LARGE_FOLIO in addition to
CONFIG_TRANSPARENT_HUGEPAGE.  Both conditions are still spelled out even
though CONFIG_LARGE_FOLIO defaults to y when TRANSPARENT_HUGEPAGE is
enabled, so that file-backed large folios do not silently disappear if
that default is ever relaxed.

PREFERRED_MAX_PAGECACHE_ORDER is left as it is.  Deriving it from
CONFIG_PGTABLE_HAS_HUGE_LEAVES would let HUGETLB_PAGE raise the ceiling
on its own, to HPAGE_PMD_ORDER capped by MAX_XAS_ORDER.  On arm64 with
64K base pages that works out to order 11, a 128M folio, eight times
what an LF-only build advertises today; the figure is arithmetic, not a
measurement.  Without THP such folios cannot be PMD-mapped, so keeping
the existing order-8 limit avoids substantially increasing the maximum
page-cache allocation size without an established use case.

CONFIG_LARGE_FOLIO no longer only builds the split machinery, so its
Kconfig help text is updated to match.  The default also carries a
comment recording why THP must keep pulling this option in:
mm/folio_split.o is built from CONFIG_LARGE_FOLIO, while huge_memory.o,
built for THP, calls into it.  XFS also gates mounting
block sizes larger than the page size on
mapping_max_folio_size_supported(), which means large-block-size XFS
cannot be mounted at all when CONFIG_LARGE_FOLIO is disabled; the
rejection now points at the missing option instead of only reporting the
block size as unsupported.

shmem keeps its THP dependency.  shmem_alloc_and_add_folio() forces
orders to zero without THP, so the mapping is only opened large-folio
capable when CONFIG_TRANSPARENT_HUGEPAGE is enabled.  Advertising the
larger order while allocating order 0 would not be cosmetic:
generic_perform_write() sizes its write chunk from
mapping_max_folio_size() and passes that length to ->write_begin()
before clamping it to folio_size(), while shmem_write_begin() rejects
pos + len > i_size outright for F_SEAL_GROW.  A cross-EOF write would
then fail as a whole instead of being partially satisfied up to i_size.
THP=y kernels already behave that way; the point is not to spread that
behaviour to a configuration which gains no large folios from it.
Enabling shmem's large folios -- allocation, swap and split alike -- is
left to a separate series.

The stale comment on mapping_large_folio_support() is updated to match:
large folios are now gated on CONFIG_LARGE_FOLIO rather than on THP, and
CONFIG_LARGE_FOLIO is a default rather than a select from THP.

With CONFIG_TRANSPARENT_HUGEPAGE enabled the generated code is unchanged.
Without it, file-backed large folios become reachable for the first time.

Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
---
 fs/xfs/xfs_super.c      |  2 ++
 include/linux/pagemap.h | 17 +++++++++++------
 mm/Kconfig              | 15 +++++++++++----
 mm/shmem.c              | 11 ++++++++++-
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa..29548faec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1864,6 +1864,8 @@ xfs_fs_fill_super(
 			xfs_warn(mp,
 "block size (%u bytes) not supported; Only block size (%zu) or less is supported",
 				mp->m_sb.sb_blocksize, max_folio_size);
+			if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
+				xfs_warn(mp, "CONFIG_LARGE_FOLIO is not set");
 			error = -ENOSYS;
 			goto out_free_sb;
 		}
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37..2102733c1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -393,7 +393,8 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  */
 static inline size_t mapping_max_folio_size_supported(void)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
+	    IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
 	return PAGE_SIZE;
 }
@@ -418,7 +419,8 @@ static inline void mapping_set_folio_order_range(struct address_space *mapping,
 						 unsigned int min,
 						 unsigned int max)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return;
 
 	if (min > MAX_PAGECACHE_ORDER)
@@ -459,7 +461,8 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
 static inline unsigned int
 mapping_max_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
 }
@@ -467,7 +470,8 @@ mapping_max_folio_order(const struct address_space *mapping)
 static inline unsigned int
 mapping_min_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
@@ -500,8 +504,9 @@ static inline pgoff_t mapping_align_index(const struct address_space *mapping,
 }
 
 /*
- * Large folio support currently depends on THP.  These dependencies are
- * being worked on but are not yet fixed.
+ * Large folio support is opt-in per mapping and requires CONFIG_LARGE_FOLIO.
+ * It does not depend on THP; CONFIG_LARGE_FOLIO defaults to y when
+ * CONFIG_TRANSPARENT_HUGEPAGE is enabled.
  */
 static inline bool mapping_large_folio_support(const struct address_space *mapping)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 9f97ad698..7bbed71af 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -831,13 +831,20 @@ config LARGE_FOLIO
 	bool "Large folio support for the page cache (without THP)" if !TRANSPARENT_HUGEPAGE
 	depends on MMU
 	select XARRAY_MULTI
+	# Keep LARGE_FOLIO enabled whenever THP is enabled:
+	# huge_memory.o is built for TRANSPARENT_HUGEPAGE and calls into
+	# folio_split.o, which is built for LARGE_FOLIO.
 	default y if TRANSPARENT_HUGEPAGE
 	default n
 	help
-	  Build the folio split implementation for page-cache large folios
-	  even when transparent hugepages are disabled.  Transparent
-	  hugepages imply this option; this option alone does not enable
-	  large folio allocation, it only makes splitting them possible.
+	  Enable page-cache large folios even when transparent hugepages
+	  are disabled.  This option defaults to y when transparent
+	  hugepages are enabled.
+
+	  With this option enabled, filesystems that opt in per mapping get
+	  large folios in the page cache, and those folios can be split.
+	  Without it, page-cache folios stay order-0 even when a filesystem
+	  asks for a larger order.
 
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
diff --git a/mm/shmem.c b/mm/shmem.c
index 4686875a3..399c8c9f1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3327,7 +3327,16 @@ static struct inode *__shmem_get_inode(const struct mnt_idmap *idmap,
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-	mapping_set_large_folios(inode->i_mapping);
+	/*
+	 * shmem large folios currently depend on THP:
+	 * shmem_alloc_and_add_folio() forces order 0 without it, and
+	 * advertising a larger mapping size makes
+	 * generic_perform_write() pass a length that shmem_write_begin()
+	 * rejects wholesale for F_SEAL_GROW before the folio size is
+	 * known.
+	 */
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
-- 
2.50.1

