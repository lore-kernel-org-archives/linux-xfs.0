Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8AE46DFE7;
	Thu, 10 Sep 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052049; cv=none; b=erSpZegYOTOhMXQ5rX37NDDTMl4ZoHp2AYc4BIzYJWuGehK9pgpMUgMwScPJ5vfEmzbSGBVhrhryeGOgaPP+WilrGBRQCvYbLixFfk0YDRHtT5xaZ8+OTHB6pxVhenXK3BzqQ5CmIDwhI6wj1uq5LgaRQdtXOD4fz1BHHTUvpV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052049; c=relaxed/simple;
	bh=fcXtOsOP81GFPzGzpYS/+Qh+3EOCpHB8AKoaYZt/07M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLXNHq9H0kTofzh8IvjcIoIfnHym/llWMW7LuGup0DXPbgLd0yrLziIR/3m4SQP87LXH4y5CHBGuQLT6omTdsJmRVrExzFAFILsdp0J9ivzq/TanSp7otGsc9/yP1eY4+1FOCrjFxL/22QvV0ksTdcV9yu3NviOKcTJ6QOtYvmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=M9/FpRdK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aLHbZkVf; arc=none smtp.client-ip=202.12.124.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="M9/FpRdK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aLHbZkVf"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id AE31D1300DB6;
	Thu, 10 Sep 2026 10:54:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 10 Sep 2026 10:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789052044; x=
	1789059244; bh=bOIokwILTqK/X59HRf9SOGvAGJFWog6Q6sfc83byU+c=; b=M
	9/FpRdK+sGsp4XM4/xr57O1s8r3rQKnDq47bmYwJ1lM5bFtHZ4JVddjHfD1SsTk8
	9sk/tRlhtWwpSA2wTI2xxWjZmDmv/UvBO1GylTDoyFlot5wNQ9hXe1XxWfLpvZoq
	RmvLOL24P3ADpvTVjv9iEvtaefzHhK+KAyyfAJuZjOXJOxMY45auWIyHHI8IQ49C
	4440IMejGOhBYXDabK7IwWYb5CMaOufdpBYlnLmgGoPuhUBxJkrAtNTsoSENEi0J
	DpGQqS3P7n2+EQD7wJX4Mn579Q/SWWSy0KEYSkYVcHZWJee9VtHsuv3xcsEnxWTd
	OXcuL+F+uY5qAaOuTZy7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789052044; x=1789059244; bh=bOIokwILTqK/X59HRf9SOGvAGJFWog6Q6sf
	c83byU+c=; b=aLHbZkVfvMmVXEqlzds87AkC1l8cr/RqplBfwhpb8vgtkdFEQcV
	j436FsP/yrXuTK3XrRc23KbANp4LG3AMWl9JKnA1WALlVnrp0NjM1lDYgEyZuMoN
	X0SRTedB00tYpRaNFTAePuSKkc+e6MmLSsZMnbhl2uFE/zodTmQTRv23yOIUI6Td
	qCFUMPRul42MBFuBdbdsQvseCFlm1HFDubOKXmK4Av1PCxFtwkLJR+Bdugs+ZBt8
	TkD5jfYjp6lylEu+rLTVVSReNKlyl512LwIrLuCks7Bkj5M1uIU8hNSxU41K/+N8
	BoiYTb4fYStGn/ueV60NzMJrM7GKNp6BrOQ==
X-ME-Sender: <xms:jMSialbvEOPJ7VCAbeFqHioo4q0O_s4gCDhzCtiOt3g-smczyborPw>
    <xme:jMSiaq089m5anI5ZOLZUgRyZSs-CtbSDYSVzaaanIF-4AGVGXCKE0mnVo_j6J6twn
    WSugtgkZdYbz-DlM39Kwt_382Oaker8DMtLcSF_7zUrSgAiwyXBRbU>
X-ME-Received: <xmr:jMSiavHKQ24SL3aUN9GSQ6UPShYD0C_nS84b3YHsa7o-tsE95NdT6tkwnww>
X-ME-Proxy-Cause: dmFkZTEEbSxJ0Zyi0MkWocW/9YZllMHwTnpiywc2Knx0LknOEhJGm34Bnb+ldyFqQwvqZA
    tXHcDUUGGgDtRBcobbl20JtRFwlF584y2WyECkOUekf/MSaUnYYpt20GRitfOOyYTO35h2
    Y0Wc9UVfGiIIsJnxLUXKn8PHdd93jc5nUHD6elK9r6qVBQGOAq7ALiFUnFpFtSLd5p0FNB
    ByUt0Bd0xDHA6uh7Mo3pyJNoQeMjX2JuIIXybv+tfzG1Bd5HHOsfIkPohGXLLkFRGVKMAC
    DBKKMdXjPeYc2aclhKqUHs+YaZyhogpzYGykkhy+KqIxDWidDTgHhdz6WJvoCWF8peo/t3
    BN1xyBMPXbgSJ3cuOryQFY6iQSDxKQooweWv3O69igH/6rvcSx4f1ndmtnkDHxrHr53S9N
    NdYVtpYSsal+wvpdaTP0Svzq8F1QXxraC/lVJcJ6tFTHS4FN8BMti4PWNShRhCJetFLmMO
    VrxJxWCTB7ngs1Jzgg5j/8Y/D7ennq1634EDl6UvMiz5AVwGIm4HENF4UwAV9p6bQhgKtC
    FlBWin0p8aPitlBgkuW1DrnWFERa8ayPIyF+csvfOHcM/cjZLD+saAHO6UdqrXN0cEaDiG
    sq/a9Rwa5Nxkg58esN2xyqJW3Zf7eFibXG5oOoYj8e7Q39UmNhykUQd5eF4w
X-ME-Proxy: <xmx:jMSianOjmKHwixA6A76NSYz1GrKUtmPrpq1hJBF-fLGaLbumnIgyuA>
    <xmx:jMSiakAGv3rVbTim-K1RqcUHuQykc2ByzBpiVmmixr7P-nT38MNGYg>
    <xmx:jMSiamzelPBdY8x9uH626HTBO6K1_yrXmE97rlXtCqdp4BvcHizyBQ>
    <xmx:jMSiagdv9lzwpgvspxqljGOWlf2E9aXhWBjCNTtTo0fkDofd7WQLJg>
    <xmx:jMSiauRo3rJu-zJdxYaS5pxSm9_zeuXJuzUckX_zCYY9t91j2P8bV4Pc>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 10:54:03 -0400 (EDT)
Date: Thu, 10 Sep 2026 15:54:01 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 2/5] mm: add a_ops->dirty_folio_range() and use the
 mkclean dirty harvest
Message-ID: <aqLC3Uo6TaZ_3_v1@thinkstation>
References: <20260903182943.662461-3-kirill@shutemov.name>
 <20260909105157.1627242-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909105157.1627242-1-usama.arif@linux.dev>

On Wed, Sep 09, 2026 at 03:51:56AM -0700, Usama Arif wrote:
> On Thu,  3 Sep 2026 19:29:40 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > Every way of dirtying part of a folio through a mapping ends up at
> > folio_mark_dirty(), which has no way to say which part changed, so
> > a_ops->dirty_folio() dirties all of it. A filesystem that tracks dirty
> > state per block then writes back the whole folio for a single stored
> > byte.
> > 
> > Add a_ops->dirty_folio_range() and folio_mark_dirty_range() to pass the
> > range on. The new operation can express everything a_ops->dirty_folio()
> > can, so folio_mark_dirty() goes through it with a range covering the
> > folio and a filesystem needs only one of the two. Filesystems without it
> > dirty the whole folio.
> > 
> > Use it in folio_clear_dirty_for_io(), where the page table dirty bits
> > were being turned into a whole-folio dirty. It now collects them with
> > folio_mkclean_dirtymap() and hands the filesystem the runs that were
> > dirty. A folio that is not already dirty still dirties whole, because
> > the clean to dirty transition needs the accounting in folio_mark_dirty().
> > 
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  include/linux/fs.h  |  3 ++
> >  include/linux/mm.h  |  1 +
> >  mm/page-writeback.c | 87 +++++++++++++++++++++++++++++++++++++++++----
> >  3 files changed, 85 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 072d8cd09a0b..1d98b6c0b880 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -406,6 +406,9 @@ struct address_space_operations {
> >  
> >  	/* Mark a folio dirty.  Return true if this dirtied it */
> >  	bool (*dirty_folio)(struct address_space *, struct folio *);
> > +	/* Mark [off, off + len) of a folio dirty */
> > +	bool (*dirty_folio_range)(struct address_space *mapping,
> > +				  struct folio *folio, size_t off, size_t len);
> >  
> >  	void (*readahead)(struct readahead_control *);
> >  
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 87feaa5a2b78..7628262c17e1 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3337,6 +3337,7 @@ struct kvec;
> >  struct page *get_dump_page(unsigned long addr, int *locked);
> >  
> >  bool folio_mark_dirty(struct folio *folio);
> > +bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len);
> >  bool folio_mark_dirty_lock(struct folio *folio);
> >  bool set_page_dirty(struct page *page);
> >  int set_page_dirty_lock(struct page *page);
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 6c9c7ba89b8a..39b54c25a9fa 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -2751,6 +2751,21 @@ bool folio_redirty_for_writepage(struct writeback_control *wbc,
> >  }
> >  EXPORT_SYMBOL(folio_redirty_for_writepage);
> >  
> > +/*
> > + * Hand a dirtied range of @folio to the filesystem.  ->dirty_folio_range() can
> > + * express everything ->dirty_folio() can, so a filesystem that implements it
> > + * does not need both, and a whole-folio dirty comes through here as a range
> > + * covering the folio.
> > + */
> > +static bool mapping_dirty_range(struct address_space *mapping,
> > +				struct folio *folio, size_t off, size_t len)
> > +{
> > +	if (!mapping->a_ops->dirty_folio_range)
> > +		return mapping->a_ops->dirty_folio(mapping, folio);
> > +
> > +	return mapping->a_ops->dirty_folio_range(mapping, folio, off, len);
> > +}
> > +
> >  /**
> >   * folio_mark_dirty - Mark a folio as being modified.
> >   * @folio: The folio.
> > @@ -2782,13 +2797,39 @@ bool folio_mark_dirty(struct folio *folio)
> >  		 */
> >  		if (folio_test_reclaim(folio))
> >  			folio_clear_reclaim(folio);
> > -		return mapping->a_ops->dirty_folio(mapping, folio);
> > +		return mapping_dirty_range(mapping, folio, 0,
> > +					   folio_size(folio));
> >  	}
> >  
> >  	return noop_dirty_folio(mapping, folio);
> >  }
> >  EXPORT_SYMBOL(folio_mark_dirty);
> >  
> > +/**
> > + * folio_mark_dirty_range - Mark part of a folio as being modified.
> > + * @folio: The folio.
> > + * @off: Offset of the modified range within the folio.
> > + * @len: Length of the modified range.
> > + *
> > + * Like folio_mark_dirty(), but tells a filesystem that tracks dirty state per
> > + * block that only [@off, @off + @len) changed, so writeback can skip the rest
> > + * of the folio.  Filesystems without that tracking dirty the whole folio.
> > + *
> > + * Return: True if the folio was newly dirtied, false if it was already dirty.
> > + */
> > +bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len)
> > +{
> > +	struct address_space *mapping = folio_mapping(folio);
> > +
> > +	if (likely(mapping)) {
> > +		if (folio_test_reclaim(folio))
> > +			folio_clear_reclaim(folio);
> > +		return mapping_dirty_range(mapping, folio, off, len);
> > +	}
> > +
> > +	return noop_dirty_folio(mapping, folio);
> > +}
> > +
> >  /*
> >   * folio_mark_dirty() is racy if the caller has no reference against
> >   * folio->mapping->host, and if the folio is unlocked.  This is because another
> > @@ -2844,6 +2885,41 @@ void __folio_cancel_dirty(struct folio *folio)
> >  }
> >  EXPORT_SYMBOL(__folio_cancel_dirty);
> >  
> > +/*
> > + * Write-protect every mapping of @folio and hand the filesystem the parts that
> > + * were dirty in a page table.
> > + *
> > + * Without ->dirty_folio_range() there is nowhere to put per-block state, so
> > + * any PTE dirty bit dirties the whole folio.  Same when the folio is not
> > + * already dirty, because then the dirty transition needs the full accounting
> > + * in folio_mark_dirty(), and for a folio too large for the bitmap, which the
> > + * page cache does not make.
> > + */
> > +static void folio_mkclean_for_io(struct folio *folio,
> > +				 struct address_space *mapping)
> > +{
> > +	DECLARE_BITMAP(map, 1UL << MAX_PAGECACHE_ORDER);
> > +	unsigned int nr = folio_nr_pages(folio);
> > +	unsigned int start, end;
> > +
> > +	if (!mapping->a_ops->dirty_folio_range || !folio_test_dirty(folio) ||
> > +	    WARN_ON_ONCE(nr > (1UL << MAX_PAGECACHE_ORDER))) {
> > +		if (folio_mkclean(folio))
> > +			folio_mark_dirty(folio);
> > +		return;
> > +	}
> > +
> > +	bitmap_zero(map, nr);
> > +	if (!folio_mkclean_dirtymap(folio, map))
> > +		return;
> > +
> > +	for_each_set_bitrange(start, end, map, nr) {
> > +		mapping_dirty_range(mapping, folio,
> > +				    (size_t)start << PAGE_SHIFT,
> > +				    (size_t)(end - start) << PAGE_SHIFT);
> 
> folio_mark_dirty() clears PG_reclaim, but mapping_dirty_range() doesnt.
> Do you need to clear PG_reclaim here?

Yes, good catch.

Fixup below moves the clearing into mapping_dirty_range(), which is the
one place that reaches the aops, and drops the copies in
folio_mark_dirty() and folio_mark_dirty_range().

Will be folded into v2.

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 39b54c25a9fa..4995219eb8be 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2760,6 +2760,20 @@ EXPORT_SYMBOL(folio_redirty_for_writepage);
 static bool mapping_dirty_range(struct address_space *mapping,
 				struct folio *folio, size_t off, size_t len)
 {
+	/*
+	 * readahead/folio_deactivate could remain
+	 * PG_readahead/PG_reclaim due to race with folio_end_writeback
+	 * About readahead, if the folio is written, the flags would be
+	 * reset. So no problem.
+	 * About folio_deactivate, if the folio is redirtied,
+	 * the flag will be reset. So no problem. but if the
+	 * folio is used by readahead it will confuse readahead
+	 * and make it restart the size rampup process. But it's
+	 * a trivial problem.
+	 */
+	if (folio_test_reclaim(folio))
+		folio_clear_reclaim(folio);
+
 	if (!mapping->a_ops->dirty_folio_range)
 		return mapping->a_ops->dirty_folio(mapping, folio);
 
@@ -2784,19 +2798,6 @@ bool folio_mark_dirty(struct folio *folio)
 	struct address_space *mapping = folio_mapping(folio);
 
 	if (likely(mapping)) {
-		/*
-		 * readahead/folio_deactivate could remain
-		 * PG_readahead/PG_reclaim due to race with folio_end_writeback
-		 * About readahead, if the folio is written, the flags would be
-		 * reset. So no problem.
-		 * About folio_deactivate, if the folio is redirtied,
-		 * the flag will be reset. So no problem. but if the
-		 * folio is used by readahead it will confuse readahead
-		 * and make it restart the size rampup process. But it's
-		 * a trivial problem.
-		 */
-		if (folio_test_reclaim(folio))
-			folio_clear_reclaim(folio);
 		return mapping_dirty_range(mapping, folio, 0,
 					   folio_size(folio));
 	}
@@ -2821,11 +2822,8 @@ bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len)
 {
 	struct address_space *mapping = folio_mapping(folio);
 
-	if (likely(mapping)) {
-		if (folio_test_reclaim(folio))
-			folio_clear_reclaim(folio);
+	if (likely(mapping))
 		return mapping_dirty_range(mapping, folio, off, len);
-	}
 
 	return noop_dirty_folio(mapping, folio);
 }
-- 
  Kiryl Shutsemau / Kirill A. Shutemov
