Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD36835C6BF;
	Tue, 25 Aug 2026 07:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643566; cv=none; b=WTvkHtQpcViLhijz9fWtEFyDtLXj6LOze5yb8wHnjotYsPuUOJnYTysxSvl2yD27WX+mvDYFrJHxvopj4JJ1mot5jvsJX2zTttoMU54oWaAz9Z/ZMk/06E4D6rk7SHxBKyGl4D3pWizUz+U51Uxi82+34aF/idbpUfcWTJlFa1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643566; c=relaxed/simple;
	bh=FfvjvkLs0U7ka28hFK9+vOUzA3Rh5GmLkBzfnEwF1w8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIBcIoz0oYrbi7e5n2b2o6WMxnqIxBZ3n0voxai9s6mEIHDIO/W97Q/f2FnzQPx28AAERPYzAgNNUiqZUque0qIp2Xn9UlMItWQe3/jl3lgO2Ouqmgs4eYlOlCiteCca5M7nmlaMBZfuz5MBmSoVwb2TFw5xqoeZO6LH46Vt8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E5BD68BFE; Tue, 25 Aug 2026 09:39:19 +0200 (CEST)
Date: Tue, 25 Aug 2026 09:39:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260825073918.GA25441@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.
>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().
> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

We've been through this a few times, I remember me and Jan discussing
it maybe a year or so on the list last.  This is what I remember:

 - the best thing would be to just not write folio_maybe_dma_pinned
   folios at all.  Jan brought up cases where that might not be
   possible, so we might have to write anyway.  IIRC the major
   one is that we actually do allow FOLL_LONGTERM even on file
   backed mappings, and those could be pinned forever.
 - when we write them anyway we really have to bounce buffer the
   data.  Basically copy and do something like in-kernel direct I/O
 - Even that can be tricky, because we'd still need a space reservation
   for that write at it would otherwise consume the space reservation
   at dirty time, but we still might have to write it again.  One
   option might be to only do the force bounce buffer write for
   FOLL_LONGTERM as the others should go away, and FOLL_LONGTERM
   gets a call into the fs to reserve extra space.  This would not
   be enough for a lot of writes, but enough to allow for
   "bank switching" over GC cycles.

So, not perfect, but probably better than the status quo.  But a lot
of work that someone needs to do for being a bit better than the
status quo.
