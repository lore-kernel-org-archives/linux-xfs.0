Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1F14E3EF7;
	Wed, 16 Sep 2026 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576087; cv=none; b=gLR/Y91AHydTy+HnD2JWAM31lRgtzmkzDi9YFEKnIV851yq8vyosYU0fSvPXQO9hXhVzs/JYzc50JjUv6SkSKU9Rb3+IYS80QDr3+28+dNAKp4U1IfMAAGKqVNwHRuaUcDqLQpga8vEqf7QbyApUPijTh47KJiAdhui9hkMoQ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576087; c=relaxed/simple;
	bh=v+YH3yZPXX23orZuHsSIFyNBZE+otvtheGPJKsk4S7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0uU6KBeEHfogfiqPdnF8el+4zw6dxG1mchl6L/xOjw481Y3rfLJ08xv1domCjUp9bK88eGtCiyG/TUWFVeF+YEehBULQbWSBlV23GktvFrNWjMpcKQvFnd5W5AusOmITNHK2gKyjUUtPlNuG2vbGFZzegrbhdu+ju4oKBiqKQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MYoC32Ma; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MYoC32Ma"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XeMuHz9L3o84HRGeotYyUHn6FZauhqILbGmQBe2dDms=; b=MYoC32Mabv+JwyI5UU+dcCFhDU
	1KhbGSiCxO2o+794mXo5pj31oJzpuTSaDCRUz++LppEHEYuSFp3rJF38uRQhDqybWIAZpBj9RsrPQ
	fNeKt9eGgjasvXYESP550Qj6JCqYGVVqNKFF4g054Kv5NESOoK01pVOtJGqA1cFFRJU/u16osc4iv
	98dIBU38gw25pwifsotx6OVfUatuMOMePjcXGj6Orb0E2oVLRRzDJBniHETHJMq52ygYLUUgZIYX/
	mSm+WDHueQYoRFUJ+a2UAZnaq9hZdqZ6n4R54r8c4C+WvXIEfcfrxXDnlOtKWGNGZWmqahUBALfmF
	g9fQcz7A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6sU2-00000005LUz-1s9o;
	Wed, 16 Sep 2026 16:27:42 +0000
Date: Wed, 16 Sep 2026 17:27:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>,
	Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqrDfoFFr8o0Mf0G@casper.infradead.org>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap6LFvuOuWf_BkGi@thinkstation>

On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> Boris pointed me to Matthew's proposal to remove ->dirty_folio:
> 
> https://lore.kernel.org/all/aoyWln-Gt-yvZQkE@casper.infradead.org

Thanks, Boris ;-)

> I agree that the current ->dirty_folio() makes little sense and that
> dirtying the folio can be bundled into ->page_mkwrite(), as they are
> matched 1-to-1.
> 
> My proposal makes the distinction between making the folio writable and
> making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> on the filesystem side to track dirty state and drive writeback for the
> *folio*, while ->dirty_folio_range() marks part of the folio dirty.

Why do you think that's a meaningful distinction?  We create a writable
PTE because we've taken a page fault for write.  There's probably a few
naoseconds where the PTE is writable+clean before it becomes
writable+dirty, but even then sometimes we do both pte_mkwrite() and
pte_mkdirty() as an optimisation in the write fault path.

> We can still drop ->dirty_folio(). A filesystem can provide
> ->dirty_folio_range() if it wants fine-grained (sub-folio) dirty
> tracking.
> 
> A separate question is whether we want to avoid installing a writable PMD
> entry for filesystems that want fine-grained dirty tracking. I have a
> patch for this, but it deserves a separate discussion once we agree that we
> want this for PTE-mapped folios first.
> 
> Any feedback?

It's very odd to be optimising for shared-writable-mmap.  This is a
horrid model for I/O.  https://cs.brown.edu/people/acrotty/pubs/p13-crotty.pdf

