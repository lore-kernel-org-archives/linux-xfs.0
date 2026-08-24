Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF7238AC87;
	Mon, 24 Aug 2026 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787600631; cv=none; b=cxr8KT21W2nCfFcN6+LQc1lorhNL9GZ6YOCArWiHzOn+QRoHewzsjIboNlokSL4wnx8dgkpRXoqOyHWllnlmhY28gbokUnScNlFtWyszk5mb3tWKmf2+ujav31/5mp6c3sls8+QDGRjsXL8XeR2d9mrHl1IgF9GOYTN1KypGMFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787600631; c=relaxed/simple;
	bh=Llt7Hxs/iF2jO5c1iN0epfq3XNgtRdOB92lpr6g55K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNHnHnTn8l9Gb0rnwSO+oDMDTiKI/9DWGIjHqD7/jBcY1QMKA3+ATjXWWEBpnuj0g/NiCEi2Czt1Mi7omFjmoGb4DnNloOMNa22PxNbpsTKqRDBZT2NJenVpvtaGbVk/yMnitWdbPn++I4Zdq4FR7s2reUpQXS9h/61ZVWS5a40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s2e7dRQg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s2e7dRQg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UA3EZoKUHtS+TORu65/C86IU676beKnyC7uoY8ic93A=; b=s2e7dRQgS+B9c/EGBNkjfoRUTN
	B4lKpe8gxCGePO01hYuQ3rMXebQOHCUrtKbdIsM4dKQ3K9g3A39BI8Sy0yXRvtiqTJaYAcI6vpR6F
	kTxG2YL/f7lwgKex29Q1N1IfpZa5msDJDl0VV915ozDnRwVH42I+wRney+/eRG0Kjy6264A4eYsU1
	qU0A2+xNQYvg9yIoGxm2AOoLbE8yyJMybPLA5/n6v78tAVU2lJOe1DLb8/fjE8A14Q9MAC3YBH4HV
	Z+07vsQhPO5vSh8hgfDYyQBjCGZwxC5M6MjanAVvIOL6sDUaRwP9b80KIzCvO6OlOD3zYUTeHuZCB
	ne8Q/VoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyaa3-00000007iyS-3fJN;
	Mon, 24 Aug 2026 19:43:39 +0000
Date: Mon, 24 Aug 2026 20:43:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <aoye694JQLwUuqxC@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>

On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
> > My proposal is this:
> > 
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> >    marked as dirty.
> 
> Yes, that would work nicely.
> 
> >  - The MM behaves similarly; we do not clear the writeback flag for
> >    folio_maybe_dma_pinned().
> > 
> > This will have the effect of writing pinned folios back every time the
> > inode is scheduled for writeback.  But since we have no idea whether
> > the folio is actually dirty (because the GUP user won't tell us),
> > this is the correct behaviour.
> > 
> > I'm probably missing some stuff here.  Let me know.
> 
> OK, so working through the end of the pinning, I think it still is
> correct: device finishes writing to pinned memory, device driver
> unpins the memory but the page has been left marked dirty the whole
> time and still is, so the next writeback still does the writeback,
> but this time sees no pins and so it marks the page clean.

Excellent!  By the way, what would you think to this?

@@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
         * Here, for that overflow case, use the sign bit to count a little
         * bit higher via unsigned math, and thus still get an accurate result.
         */
-       return ((unsigned int)folio_ref_count(folio)) >=
+       mapcount = folio_mapcount(folio);
+       return (folio_ref_count(folio) - mapcount) >=
                GUP_PIN_COUNTING_BIAS;
 }


It should improve the accuracy of folio_maybe_dma_pinned() for folios
which are mapped many, many times (eg a page of libc).  I'm a little
concerned about races turning that number negative since we don't
necessarily have the folio locked at that point.
