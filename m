Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659BE523782
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 10:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951127; cv=none; b=BJBGlUrr0kMO74ZofLEYg9jdZ5AGvMggqr0MapVuCILzId59JGKjQz8sl6xNXfqLDcJYPdZwo2BoYJSKYln0gVkW2CWt7Uh7ymwzFjvVBInLjd1yPn+AcV09Ni2mIaeFWDUocn0HRfYbIQCHbzP9cFlnqrXpGKdbkm6oZ2b0xxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951127; c=relaxed/simple;
	bh=nLf/lRHoFum5m+0lJCGEXaO0612ccjY4r0VU9eyNeEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz/dEHO+8guZxKX8SKwH0OLxNkwrAtoCA6+yxPrUCUWxDHlzjCW5jAhyKN+eRKvwqK85LYH9vnQzVrW14++1k99GN7jt50i5r3t1t6yDEjWuQkHEqonaxmyDdHtiqtEPmkkE7amnN6AJmxhcOANocaKs6NumFc7sW/9rEl9aH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gEGy4cKh; arc=none smtp.client-ip=95.215.58.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gEGy4cKh"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nLf/lRHoFum5m+0lJCGEXaO0612ccjY4r0VU9eyNeEs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788951122; v=1; x=1789555922;
 b=gEGy4cKhwazS7GQTTOJxrKVaqvi9Tw316nM8CYxF2+90B3NyLQfSD73REwTRe3ZrB9sqzQmI
 5KJH7frLcHXHr2u+32wub9Dj/fusOLFmKHjPsS0nKDyEdQP0/3yUcn0YVXWBPKwsDbpF6peYpvL
 uiLcQG+fA4jVnMu6Bex95YD4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 5d49b818eb55d532;
	Wed, 09 Sep 2026 10:52:01 +0000
X-Mizu-Trace-ID: 5d49b818eb55d532
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
Subject: Re: [RFC PATCH 2/5] mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
Date: Wed,  9 Sep 2026 03:51:56 -0700
Message-ID: <20260909105157.1627242-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903182943.662461-3-kirill@shutemov.name>
References: 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu,  3 Sep 2026 19:29:40 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Every way of dirtying part of a folio through a mapping ends up at
> folio_mark_dirty(), which has no way to say which part changed, so
> a_ops->dirty_folio() dirties all of it. A filesystem that tracks dirty
> state per block then writes back the whole folio for a single stored
> byte.
> 
> Add a_ops->dirty_folio_range() and folio_mark_dirty_range() to pass the
> range on. The new operation can express everything a_ops->dirty_folio()
> can, so folio_mark_dirty() goes through it with a range covering the
> folio and a filesystem needs only one of the two. Filesystems without it
> dirty the whole folio.
> 
> Use it in folio_clear_dirty_for_io(), where the page table dirty bits
> were being turned into a whole-folio dirty. It now collects them with
> folio_mkclean_dirtymap() and hands the filesystem the runs that were
> dirty. A folio that is not already dirty still dirties whole, because
> the clean to dirty transition needs the accounting in folio_mark_dirty().
> 
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/fs.h  |  3 ++
>  include/linux/mm.h  |  1 +
>  mm/page-writeback.c | 87 +++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 85 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 072d8cd09a0b..1d98b6c0b880 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -406,6 +406,9 @@ struct address_space_operations {
>  
>  	/* Mark a folio dirty.  Return true if this dirtied it */
>  	bool (*dirty_folio)(struct address_space *, struct folio *);
> +	/* Mark [off, off + len) of a folio dirty */
> +	bool (*dirty_folio_range)(struct address_space *mapping,
> +				  struct folio *folio, size_t off, size_t len);
>  
>  	void (*readahead)(struct readahead_control *);
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 87feaa5a2b78..7628262c17e1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3337,6 +3337,7 @@ struct kvec;
>  struct page *get_dump_page(unsigned long addr, int *locked);
>  
>  bool folio_mark_dirty(struct folio *folio);
> +bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len);
>  bool folio_mark_dirty_lock(struct folio *folio);
>  bool set_page_dirty(struct page *page);
>  int set_page_dirty_lock(struct page *page);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 6c9c7ba89b8a..39b54c25a9fa 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2751,6 +2751,21 @@ bool folio_redirty_for_writepage(struct writeback_control *wbc,
>  }
>  EXPORT_SYMBOL(folio_redirty_for_writepage);
>  
> +/*
> + * Hand a dirtied range of @folio to the filesystem.  ->dirty_folio_range() can
> + * express everything ->dirty_folio() can, so a filesystem that implements it
> + * does not need both, and a whole-folio dirty comes through here as a range
> + * covering the folio.
> + */
> +static bool mapping_dirty_range(struct address_space *mapping,
> +				struct folio *folio, size_t off, size_t len)
> +{
> +	if (!mapping->a_ops->dirty_folio_range)
> +		return mapping->a_ops->dirty_folio(mapping, folio);
> +
> +	return mapping->a_ops->dirty_folio_range(mapping, folio, off, len);
> +}
> +
>  /**
>   * folio_mark_dirty - Mark a folio as being modified.
>   * @folio: The folio.
> @@ -2782,13 +2797,39 @@ bool folio_mark_dirty(struct folio *folio)
>  		 */
>  		if (folio_test_reclaim(folio))
>  			folio_clear_reclaim(folio);
> -		return mapping->a_ops->dirty_folio(mapping, folio);
> +		return mapping_dirty_range(mapping, folio, 0,
> +					   folio_size(folio));
>  	}
>  
>  	return noop_dirty_folio(mapping, folio);
>  }
>  EXPORT_SYMBOL(folio_mark_dirty);
>  
> +/**
> + * folio_mark_dirty_range - Mark part of a folio as being modified.
> + * @folio: The folio.
> + * @off: Offset of the modified range within the folio.
> + * @len: Length of the modified range.
> + *
> + * Like folio_mark_dirty(), but tells a filesystem that tracks dirty state per
> + * block that only [@off, @off + @len) changed, so writeback can skip the rest
> + * of the folio.  Filesystems without that tracking dirty the whole folio.
> + *
> + * Return: True if the folio was newly dirtied, false if it was already dirty.
> + */
> +bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len)
> +{
> +	struct address_space *mapping = folio_mapping(folio);
> +
> +	if (likely(mapping)) {
> +		if (folio_test_reclaim(folio))
> +			folio_clear_reclaim(folio);
> +		return mapping_dirty_range(mapping, folio, off, len);
> +	}
> +
> +	return noop_dirty_folio(mapping, folio);
> +}
> +
>  /*
>   * folio_mark_dirty() is racy if the caller has no reference against
>   * folio->mapping->host, and if the folio is unlocked.  This is because another
> @@ -2844,6 +2885,41 @@ void __folio_cancel_dirty(struct folio *folio)
>  }
>  EXPORT_SYMBOL(__folio_cancel_dirty);
>  
> +/*
> + * Write-protect every mapping of @folio and hand the filesystem the parts that
> + * were dirty in a page table.
> + *
> + * Without ->dirty_folio_range() there is nowhere to put per-block state, so
> + * any PTE dirty bit dirties the whole folio.  Same when the folio is not
> + * already dirty, because then the dirty transition needs the full accounting
> + * in folio_mark_dirty(), and for a folio too large for the bitmap, which the
> + * page cache does not make.
> + */
> +static void folio_mkclean_for_io(struct folio *folio,
> +				 struct address_space *mapping)
> +{
> +	DECLARE_BITMAP(map, 1UL << MAX_PAGECACHE_ORDER);
> +	unsigned int nr = folio_nr_pages(folio);
> +	unsigned int start, end;
> +
> +	if (!mapping->a_ops->dirty_folio_range || !folio_test_dirty(folio) ||
> +	    WARN_ON_ONCE(nr > (1UL << MAX_PAGECACHE_ORDER))) {
> +		if (folio_mkclean(folio))
> +			folio_mark_dirty(folio);
> +		return;
> +	}
> +
> +	bitmap_zero(map, nr);
> +	if (!folio_mkclean_dirtymap(folio, map))
> +		return;
> +
> +	for_each_set_bitrange(start, end, map, nr) {
> +		mapping_dirty_range(mapping, folio,
> +				    (size_t)start << PAGE_SHIFT,
> +				    (size_t)(end - start) << PAGE_SHIFT);

folio_mark_dirty() clears PG_reclaim, but mapping_dirty_range() doesnt.
Do you need to clear PG_reclaim here?

> +	}
> +}
> +
>  /*
>   * Clear a folio's dirty flag, while caring for dirty memory accounting.
>   * Returns true if the folio was previously dirty.
> @@ -2875,9 +2951,9 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		 *
>  		 * We use this sequence to make sure that
>  		 *  (a) we account for dirty stats properly
> -		 *  (b) we tell the low-level filesystem to
> -		 *      mark the whole folio dirty if it was
> -		 *      dirty in a pagetable. Only to then
> +		 *  (b) we tell the low-level filesystem which
> +		 *      parts of the folio were dirty in a
> +		 *      pagetable. Only to then
>  		 *  (c) clean the folio again and return 1 to
>  		 *      cause the writeback.
>  		 *
> @@ -2895,8 +2971,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		 * as a serialization point for all the different
>  		 * threads doing their things.
>  		 */
> -		if (folio_mkclean(folio))
> -			folio_mark_dirty(folio);
> +		folio_mkclean_for_io(folio, mapping);
>  		/*
>  		 * We carefully synchronise fault handlers against
>  		 * installing a dirty pte and marking the folio dirty
> -- 
> 2.54.0
> 
> 
