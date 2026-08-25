Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DECD35F191;
	Tue, 25 Aug 2026 19:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686026; cv=none; b=D0kNkmqWklmYSKLA+8fV1nacgOcPo2OUXPNixp1wX3J3hiNkphtUr/51LtQ0oDsbBnxCy210cpjMIcGAwavLJalaAB3j9Zasr3NObF1QDQIHBh6wwD8Bt5xwNKhmDu2cK3s3Tcm95qunu6zZFA0ySqJNnLqpKGzUtQ1DwDiO44I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686026; c=relaxed/simple;
	bh=WBzRw9pyA8uT/uhPGiQdUXHfvWpDeE1cHqpVj88AVtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTkrIAKm1kLwNeu+xTYkgBCvHKvG3yk9Wq5n1pNFihnZlKQaOEXtp/Z6CsQCzGKVBIZUQ8ph+v+V/LVz/3LE91xQ8y3+z2O8bM6C/9fzNJUI2tVM9V8G9uzzXal/ga5ntb4zzFHraKtmeUlv5DdKmhOOXHrsKeG+i0aGJ1GvQ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Egn/lsSt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Egn/lsSt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xxTtAvTtvM+uHl0dQvDvN3ybbm7YPGi9Fc/YNAJO1Pc=; b=Egn/lsStH5Uq2YFZENOdHYax3E
	wmqqenTC9QVGzw8ggQipiJJLpJ5Dosv6JXO2A9T5xNyFoR56mpErpr5QSNz2fOMyuRMsaptXAD2yH
	yhMbx8D+DJ/3D+YGCGhgZd+70RG9kiCkAu8sudQHIEuJjVM0bCmf3EHYPd46VNr97SjNz+1Zcy3En
	3WumdcHmn4O4O1Ptd3y6zA5IlFaTR4G/bwARAi2pDdCrOMdgmitRMjnyxn28Tw15q9Rx/O/IzSZtq
	t3MoOGkLiuBijPcQh6sMxwYifcVwJQ4oNFQkh0PbJ+JlMmEo7xzPMAXBmcRfRFD7hO/tTDRGSuLLn
	MTLtKS5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wywnQ-00000009bVE-1vU0;
	Tue, 25 Aug 2026 19:26:56 +0000
Date: Tue, 25 Aug 2026 20:26:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3sgEET8GuY7Rw2@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>

On Tue, Aug 25, 2026 at 08:08:48AM +0930, Qu Wenruo wrote:
> > The problem is GUP.  We have no way to force the GUP caller to go
> > through page_mkwrite again.  So instead we make the GUP caller call
> > folio_mark_dirty_lock() which many just don't, and generally we get away
> > with it.  But it's a bug, and a bad interface.
> > 
> > There's also the problem that GUP users bypass the folio_wait_stable()
> > mechanism.  If a page is written to while somebody is creating a
> > checksum over that page, the checksum will be corrupted.  If we want
> > to fix this, we have to bounce-buffer the page.  There's no way to
> > prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> > 
> > My proposal is this:
> > 
> >   - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >     If it's true, do the writeback, but retain/recreate whatever data
> >     structures you need in order to write the folio again; behave as if
> >     ->page_mkdirty() had been called again for each page in the folio is
> >     marked as dirty.
> 
> This may make COW more complex.

It's probably wise to be explicit when talking about COW.  Anyone from
the MM side of the house is probably thinking "but this is only relevant
for shared writable mmap and we don't do a COW".  You're talking about
filesystems doing a COW of the on-disc data, not about the MM COWing the
pagecache page into an anonymous page.

> For folio_maybe_dma_pinned() case, we will need to do extra space
> reservation similar to page_mkdirty() again, so that the folio can be
> written back again.

Yes, you will.

> I'm not sure if we will have a good timing for re-reserving space inside
> btrfs.

Why is it hard to do it immediately at writeback time?  I think you're
in an even less restrictive locking environment than page_mkwrite is
called in because you're not under any MM locks.  According to
Documentation/filesystems/locking.rst, ->writepages is called with
absolutely no locks held.

> Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?

Actually ... no, because the VFS no longer knows which pages in the
folio are dirty.  That's information the MM had, and communicated to
the FS which (if it cares) has stored in its folio->private.  But the
VFS no longer has access to that information.

