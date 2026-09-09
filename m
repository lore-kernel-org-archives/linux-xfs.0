Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55E64B5CBD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 10:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788948740; cv=none; b=aroO/brmbQG1ZVjcrli85OCLC4R4HpSvEp5oZH9ZPxxQEnZI/mAoeJ7h7K8hE1utSq2cNw7vLa7lEReb1Uojpq6G0DI33z9VDbK8w0sNhDyCZOJPLS7RLD65vOEB8+1cr8N7+dtwPqWBVWPXAZrf6aTM7naZcxmDrRMwi8PKvlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788948740; c=relaxed/simple;
	bh=SUb2T8Szd5lQADcRkFmfOpjvj3cL/MOp9zqZDunQQQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0oKXTnz7K9QSvUoC41a9ct8OejOyvCPZSRNkGeYw9gAax4tJGG6f2SrZF8RlIqefG/Lb8vDSg4fp9sEbdH60GmjwcRlpAfNasFCO77e2DQtwHn9Iyo0XwEdVOygqk4Ev6wj766f4MX+jaw8wIjWmo6j2rL2kmqE0qR4Ojg57rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jfGA6Ns4; arc=none smtp.client-ip=91.218.175.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jfGA6Ns4"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SUb2T8Szd5lQADcRkFmfOpjvj3cL/MOp9zqZDunQQQc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788948736; v=1; x=1789553536;
 b=jfGA6Ns4fWme+TvRv+Umhz2FneXp8Ee5AdFcBHRZr7/ku1cH+sSF5ySdy7eDuF1NBHhUPOzI
 CTLbZzGH/Vn/TWod8QE9fw9/u2KEzd+TNjZnKmKTtlOLLOM3rK3y10cuLz5jRRwxGmDSCsp7juG
 Nt5Ds7jCleQLtcvcFhg5jcL0=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 82308e7dde90318c;
	Wed, 09 Sep 2026 10:12:15 +0000
X-Mizu-Trace-ID: 82308e7dde90318c
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [RFC PATCH 1/5] mm: let folio_mkclean() report which pages had dirty PTEs
Date: Wed,  9 Sep 2026 03:12:10 -0700
Message-ID: <20260909101212.894871-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903182943.662461-2-kirill@shutemov.name>
References: 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu,  3 Sep 2026 19:29:39 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> folio_mkclean() walks every mapping of a folio and clears the dirty and
> write bits of each page table entry. It has the per-entry dirty bit in
> hand while doing that, but only counts how many entries it cleaned.
> 
> For a large folio those bits are the only record of which parts of the
> folio were written through a mapping. Everything downstream has to
> assume the whole folio changed because that information is dropped here.
> 
> Add folio_mkclean_dirtymap(), which takes a bitmap and sets a bit for every
> page of the folio whose entry was dirty. folio_mkclean() becomes a
> wrapper that passes no bitmap, so there is no change in behaviour yet.
> 
> A PMD entry has one dirty bit for the whole folio, so a PMD-mapped folio
> reports all of its pages as dirty. That is the best that can be done:
> the hardware does not track anything finer for a PMD.
> 
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/rmap.h |  7 ++++++
>  mm/rmap.c            | 56 +++++++++++++++++++++++++++++++++++---------
>  2 files changed, 52 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f00..6fc0a6020252 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -927,6 +927,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
>   * returns the number of cleaned PTEs.
>   */
>  int folio_mkclean(struct folio *);
> +int folio_mkclean_dirtymap(struct folio *folio, unsigned long *dirty_map);
>  
>  int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
>  		unsigned long pfn, unsigned long nr_pages);
> @@ -990,6 +991,12 @@ static inline int folio_mkclean(struct folio *folio)
>  {
>  	return 0;
>  }
> +
> +static inline int folio_mkclean_dirtymap(struct folio *folio,
> +					 unsigned long *dirty_map)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_MMU */
>  
>  #endif	/* _LINUX_RMAP_H */
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1f72d279ba68..aaf45ac79fa8 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1100,12 +1100,18 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	return rwc.contended ? -1 : pra.referenced;
>  }
>  
> -static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
> +struct mkclean_state {
> +	unsigned long *dirty_map;
> +	int cleaned;
> +};
> +
> +static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
> +				unsigned long *dirty_map)
>  {
> -	int cleaned = 0;
>  	struct vm_area_struct *vma = pvmw->vma;
> -	struct mmu_notifier_range range;
>  	unsigned long address = pvmw->address;
> +	struct mmu_notifier_range range;
> +	int cleaned = 0;
>  
>  	/*
>  	 * We have to assume the worse case ie pmd for invalidation. Note that
> @@ -1134,6 +1140,15 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  			if (!pte_dirty(entry) && !pte_write(entry))
>  				continue;
>  
> +			if (dirty_map && pte_dirty(entry)) {
> +				pgoff_t idx = linear_page_index(vma, address) -
> +					      pvmw->pgoff;
> +
> +				/* The walk only visits pages of this folio */
> +				VM_WARN_ON_ONCE(idx >= pvmw->nr_pages);
> +				__set_bit(idx, dirty_map);
> +			}
> +

The patch reads the PTE first and then records pte_dirty(entry) in the bitmap
before invalidating the PTE.

Holding the page-table lock prevents another kernel thread from changing
the PTE, but it does not prevent the CPU from setting the hardware dirty
bit.

This sequence is possible:

  Writeback CPU                  Application CPU
  -------------                  ---------------
  ptep_get(): writable, clean
                                 store through the PTE
                                 hardware sets dirty
  ptep_clear_flush(): returns dirty PTE
  pte_mkclean()
  reinstall clean, read-only PTE

The bitmap was populated from the first, clean snapshot. The dirty state
returned by ptep_clear_flush() is discarded.

With range-aware iomap writeback:

- The folio can still be selected for writeback.
- The affected filesystem block is absent from the iomap dirty bitmap.
- Writeback clears the folio dirty state without writing that block.
- Later eviction can discard the modified data.

The old whole-folio behavior did not need to know which PTE became
dirty, so this timing window was harmless. Sub-folio tracking makes the
final dirty state correctness-critical.

The PMD path has the identical race between pmdp_get() and
pmdp_invalidate().


>  			flush_cache_page(vma, address, pte_pfn(entry));
>  			entry = ptep_clear_flush(vma, address, pte);
>  			entry = pte_wrprotect(entry);
> @@ -1155,6 +1170,9 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  			if (!pmd_dirty(entry) && !pmd_write(entry))
>  				continue;
>  
> +			if (dirty_map && pmd_dirty(entry))
> +				bitmap_set(dirty_map, 0, pvmw->nr_pages);
> +
>  			flush_cache_range(vma, address,
>  					  address + HPAGE_PMD_SIZE);
>  			entry = pmdp_invalidate(vma, address, pmd);
> @@ -1181,9 +1199,9 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>  			     unsigned long address, void *arg)
>  {
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
> -	int *cleaned = arg;
> +	struct mkclean_state *state = arg;
>  
> -	*cleaned += page_vma_mkclean_one(&pvmw);
> +	state->cleaned += page_vma_mkclean_one(&pvmw, state->dirty_map);
>  
>  	return true;
>  }
> @@ -1196,12 +1214,23 @@ static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
>  	return true;
>  }
>  
> -int folio_mkclean(struct folio *folio)
> +/**
> + * folio_mkclean_dirtymap - Write-protect a folio and report what was dirty.
> + * @folio: The folio to clean.
> + * @dirty_map: Bitmap of at least folio_nr_pages(@folio) bits, or NULL.
> + *
> + * Write-protects and cleans every mapping of @folio.  With @dirty_map, sets a
> + * bit for each page whose entry was dirty; a PMD-mapped folio has one dirty
> + * bit for all of it, so every page is reported.
> + *
> + * Return: the number of page table entries cleaned.
> + */
> +int folio_mkclean_dirtymap(struct folio *folio, unsigned long *dirty_map)
>  {
> -	int cleaned = 0;
> +	struct mkclean_state state = { .dirty_map = dirty_map };
>  	struct address_space *mapping;
>  	struct rmap_walk_control rwc = {
> -		.arg = (void *)&cleaned,
> +		.arg = (void *)&state,
>  		.rmap_one = page_mkclean_one,
>  		.invalid_vma = invalid_mkclean_vma,
>  	};
> @@ -1217,7 +1246,12 @@ int folio_mkclean(struct folio *folio)
>  
>  	rmap_walk(folio, &rwc);
>  
> -	return cleaned;
> +	return state.cleaned;
> +}
> +
> +int folio_mkclean(struct folio *folio)
> +{
> +	return folio_mkclean_dirtymap(folio, NULL);
>  }
>  EXPORT_SYMBOL_GPL(folio_mkclean);
>  
> @@ -1241,7 +1275,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
>  		.flags		= PVMW_SYNC,
>  	};
>  
> -	state->cleaned += page_vma_mkclean_one(&pvmw);
> +	state->cleaned += page_vma_mkclean_one(&pvmw, NULL);
>  
>  	return true;
>  }
> @@ -1324,7 +1358,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
>  	pvmw.address = vma_address(vma, pgoff, nr_pages);
>  	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
>  
> -	return page_vma_mkclean_one(&pvmw);
> +	return page_vma_mkclean_one(&pvmw, NULL);
>  }
>  
>  static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
> -- 
> 2.54.0
> 
> 
