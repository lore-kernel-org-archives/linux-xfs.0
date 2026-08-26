Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00DB255F2D;
	Wed, 26 Aug 2026 05:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787720861; cv=none; b=PPb/ibxywmQT6r82BxefEY3CT15NjegnvGIm6Kwu7j0zE00w4xuk/vHoI/+6YrYnVjGkzksAvKhvjvZDmzQxaQeOPEQev9/wDv53fvaaoqEJKYjXfTJh4n3xFcIvUvs/wNf+6dQI957ujSKFP+u3De8uYnTT4W2pA1Rwey0lI68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787720861; c=relaxed/simple;
	bh=tX+4BRduGnZbM+fbB2tkRfbXOFlva6+6kC8z/KSf3jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdC/QAC6WvpLhjCLoIIlFdCFEClUjmEUBUzUwvycPwl9CehdaLjxEaBnc0JNSGWIkNYgjOngGQ1dcxUqAPFU2/yf2nUiUgt9D/6KLFZBnWf55+MNzuO6OJjzwHrgjrbRvXncoR5th8Jv2XipcqXQ1u9YflpYMIx72pMJAudVfO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21E1A68BFE; Wed, 26 Aug 2026 07:07:34 +0200 (CEST)
Date: Wed, 26 Aug 2026 07:07:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826050733.GB15122@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3y8TtEGjniZ_4f@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

[adding rdma/hmm folks]

On Tue, Aug 25, 2026 at 08:54:25PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > The problem is GUP.  We have no way to force the GUP caller to go
> > > through page_mkwrite again.  So instead we make the GUP caller call
> > > folio_mark_dirty_lock() which many just don't, and generally we get away
> > > with it.  But it's a bug, and a bad interface.
> > 
> > We currently have get_user_pages*() and pin_user_pages*(), where only
> > the pin_*() version is properly usable for write access, right? And
> > dropping such pins should always go through unpin_*() helpers?
> 
> Right.  I'm stuffing cheese into my ears and pretending that people
> aren't calling get_user_pages() to do write accesses.  We should be
> able to use this work to flush out the last remaining ones -- we
> can put in various assertions that folios should still be dirty where
> we currently have folio_mark_dirty() calls.

Last time I checked quite a few places still did.  Including various
network file system O_DIRECT implementations (some got fixed, and
for NFS a series is outstanding) and some really odd looking networking
code.

I wish we could somehow force them to stop doing that, but I can't
think of any. 

> Yes.  I think the only alternative would be storing a checksum of the
> contents of the folio and seeing if it changed since the last write.
> As you say, this is userspace doing something incredibly odd (I really
> don't think people make a habit of mmap()ing files shared writable and
> then giving RDMA longterm write accesses to them.  Not on machines with
> poor quality flash storage anyway).
> 
> Or we could say "these pages only get written back on requested fsync()
> rather than periodically".

Take one step back.  For regular pins we should be able to just wait for
them given that they are by definition short lived, where short lived
is defined by typical I/O latency for a wide range of "typical".
We'll need the right helpers from the MM for that, and make sure
we have a good way to debug file system hangs caused by incorrect
use of the pinning, but all that is a solvable problem.
Splitting read vs write pincounts would be really helpful to reduce
the overhead of that.

The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
longer time.  And that also means IFF the user of FOLL_LONGTERM actually
wants to be able to persist data on a shared mmap, it has to manually
dirty folios one or more times during the FOLL_LONGTERM pin, because
otherwise the file system would never know there is dirty data.
The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
for that.

So what we'll need is:

 - a way for the file system to know if a dma pin on a folio is for a
   short-term writable pin vs everything else.
 - for the short term writable pin wait for it for data integrity syncs,
   or otherwise just skip it.
 - for FOLL_LONGTERM users we need an interface to (re-dirty) folios
   while the long term pin persists.  This also needs a way for the
   file system to reserve space.  Either as a rolling / bank switched
   reservation for the whole life time of the mapping (although for
   large mappings this might use up a lot of space), or to do that
   ahead of whatever triggers the dirtying.
   And maybe a way for file systems (or vm ops) to reject long
   term writable pins if they don't want to deal with all this.
