Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED83376BFB;
	Fri, 10 Jul 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783706600; cv=none; b=RfOntIWhwNC15co8bw7YHuqRYYjU/V0GpZsc/mYGentNtpd9YRG2oilUQYIh7lHHw71PgpquRaetCs8DhRuWQgxOx/4ClJAQJ+Kyao/xC6ThyuvxfBX7BGOfmrFWz2sl4/gFZytbCUsNU4HhhruVmZWX/T/wNfgjfk+ZI0BzkAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783706600; c=relaxed/simple;
	bh=jQ2ENi7efQIv9R2EbZKSeryq1m1JjIZToHHAmccFRis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOljFmmquBzBSPffiC7GdzzlwQ9D4QdfFzxqSFc/cqHYpNZmAIf9fTiJ68oiVzemZJFbJOAOvEjUgzxfEpbdYUzDmPjC5n9yeNvys1WT/55fuEgRa6BYhK62/vHqeb3Qt0mtuYGzS+R5uSeHSqgR42ZI3LcFKKpaTBEcHLfawXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vrVhH6CZ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vrVhH6CZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aavlYHK65oZ9/GvkqG4vhVx7lYGAHZXQDwnk4WMg/dU=; b=vrVhH6CZ43iMT+yYcxyiUFLLu7
	6n+lRXruBnU93GSLongig8SFlKm3AgZwxoDzqo0wCFEhLVi87OcdBvy8aEyLkK6uObGGpp63VQwi0
	hSuIpfQAUdKbz4EsnK6t5wjQvkQ/25WKWlk+JecIt/nOtDbO71fPl9LF/Y/NWdanurlhHNyyBxsjK
	XSgbg9xirVLA2JFSb6mTgsgwyUUGEvEy/Tq4u2cqbUgu7cHfzICrLfyLQIGbF4vEvE/JodppgC3p9
	nGpQPd0upaeQCTcahdsyxydddO8e2FVnQstNr/bwE9fIu3MRbNdbcIipOiQ0Iglr3voabEDxdG1xk
	h5/yoyDA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wiFZA-00000007b0h-2b7J;
	Fri, 10 Jul 2026 18:03:12 +0000
Date: Fri, 10 Jul 2026 19:03:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-mm@kvack.org, hch@infradead.org, ritesh.list@gmail.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	dgc@kernel.org, vbabka@suse.cz, djwong@kernel.org,
	brauner@kernel.org, alisaidi@amazon.com, blakgeof@amazon.com,
	abuehaze@amazon.com, dipietro.salvatore@gmail.com,
	stable@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
References: <20260710143437.12379-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710143437.12379-1-dipiets@amazon.it>

On Fri, Jul 10, 2026 at 02:34:37PM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.

https://lore.kernel.org/linux-mm/aeZzP6iQel-tkZOu@casper.infradead.org/

I just had a go at implementing what I thought might be the right design
(having a folio_alloc_orders(min, max, gfp)), but that's not really what
__filemap_get_folio_mpol() wants because it needs to integrate the actual
adding of folios to the page cache into the retry loop.

So instead, let's try this.  The idea is that we want to try direct reclaim
_twice_.  Once gently (ie with NORETRY specified) when we're trying to
allocate the maximum order folio.  But now that we've tried that once,
there's no point trying direct reclaim for other sizes, we just want to
ask the page allocator if it can give us memory of any subsequent size.

Until we come to the minimum order.  Then we want to try exactly as hard
as we were originally asked to try.  So revert to the original gfp flags
and don't set the NOWARN or NORETRY flags.

diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..23eecaf9b328 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1983,6 +1983,7 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio && (fgp_flags & FGP_CREAT)) {
 		unsigned int min_order = mapping_min_folio_order(mapping);
 		unsigned int order = max(min_order, FGF_GET_ORDER(fgp_flags));
+		gfp_t alloc_gfp = gfp | __GFP_NORETRY | __GFP_NOWARN;
 		int err;
 		index = mapping_align_index(mapping, index);
 
@@ -2004,12 +2005,11 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			order = __ffs(index);
 
 		do {
-			gfp_t alloc_gfp = gfp;
-
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order == min_order)
+				alloc_gfp = gfp;
 			folio = filemap_alloc_folio(alloc_gfp, order, policy);
+			alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
 			if (!folio)
 				continue;
 
