Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68C3B5314;
	Tue, 25 Aug 2026 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685258; cv=none; b=krF6fxLx/yeG8ri4A3qf8/IpRsLZqzhfl8lEiBx+fsjV6jB84xK/wYMQ+SsxwchvoyqjvYgXbe+xRpaQIXG0xydMfWX1EK2qYy0JoYIE6vZJZXmGmTSFGbLV8eQ4GpwVUSQG3MWqqli2VuvX383PgafVnjxTAVxMR4s1NwDdflM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685258; c=relaxed/simple;
	bh=69sArnDF5j6CJhMR1APAkBbocbJ/kEGVeJhCURjiFFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6k1Eq4vjkmjWJgB+EDWlCSjPtDh5uv49w1kT1QpeAuiNBBPTWrax/hrJXxF7dNrIWmO4oJsf6jZp+o3ZtZA/SKdAC+A7r4IN8DUeNGZtNSBtxOdZ6utkxvMVPwkFRvFqga+5kmJ5mDxuYIFDpnmZlcSGfBJjoZWhl3yFrcqa7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kj68+8Df; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kj68+8Df"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qyn5Bs3PPyuDeSA5xUHQrWKpUB1haYkwcsmOVbrXEMo=; b=Kj68+8Dfk4HZzgB1WdbRbLhwH6
	df92mqmYj32/te7T8+qREnij7Pl1gR403+AdUFKxsknUKEu9L3B+KbU/ri8eeASHVdOsbeB+0HJ2z
	ZAeQx7c8RB38jNBfwcBI/K2trrKMnCBlysyohZV3Tmj8uLWvwGQfAUouKKgZwQ2LzIMBl7y1Cd64t
	x1FLFvd3cQ+zu7+rqgn1baZqLS6+GnTm6EABlcWadkzINYra3mb4d6WubH9cd5d5dajLOktQmaNLK
	dNMPLq6k+9WqEYOt0SMP3N/eikoYIc20jPHEw2TgVI6blzlUYKsS4h1Id17VXjkCUwFXzSiGwR16p
	o4eU33rg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wywb0-00000009aFD-1haE;
	Tue, 25 Aug 2026 19:14:06 +0000
Date: Tue, 25 Aug 2026 20:14:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3pfoZbGl50nGN2@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <20260825073918.GA25441@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825073918.GA25441@lst.de>

On Tue, Aug 25, 2026 at 09:39:18AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> > My proposal is this:
> > 
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> >    marked as dirty.
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
> We've been through this a few times, I remember me and Jan discussing
> it maybe a year or so on the list last.  This is what I remember:
> 
>  - the best thing would be to just not write folio_maybe_dma_pinned
>    folios at all.  Jan brought up cases where that might not be
>    possible, so we might have to write anyway.  IIRC the major
>    one is that we actually do allow FOLL_LONGTERM even on file
>    backed mappings, and those could be pinned forever.
>  - when we write them anyway we really have to bounce buffer the
>    data.  Basically copy and do something like in-kernel direct I/O
>  - Even that can be tricky, because we'd still need a space reservation
>    for that write at it would otherwise consume the space reservation
>    at dirty time, but we still might have to write it again.  One
>    option might be to only do the force bounce buffer write for
>    FOLL_LONGTERM as the others should go away, and FOLL_LONGTERM
>    gets a call into the fs to reserve extra space.  This would not
>    be enough for a lot of writes, but enough to allow for
>    "bank switching" over GC cycles.
> 
> So, not perfect, but probably better than the status quo.  But a lot
> of work that someone needs to do for being a bit better than the
> status quo.

Thanks for summarising the previous discussion.  I understand what
you're saying about the space reservation; that's why we have to
bring filesystems into the conversation rather than doing it entireely
within the VFS.  They have to know that they must create a new space
reservation immediately after writing back this folio.  That should
be feasible in the writeback path because we're not under any mad
locking scheme like holding the PTL.

I think the only disagreement I have is about the upsides:

 - Filesystems no longer need to implement ->dirty_folio()
 - The page pinning API becomes a bit easier to use (no need to call
   folio_mark_dirty() / folio_mark_dirty_locked())

I'm just trying to figure out if we can do this in small chunks, or
if we have to do the whole thing at once.
