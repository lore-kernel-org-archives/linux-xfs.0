Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65431345CCA;
	Wed, 26 Aug 2026 08:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731273; cv=none; b=DzQRcPQ6T7Y9o9sQDaIgDYsBBKKj/iS/aj+APTJBAfPbzByHsCdp7txUqiBZTBslJW54tie5b6W0DPurXKiNUZwe6XDF8E0Vb/j4/nIupAzqWW1JslcwXYWMWijPbYdMt7jtbL7wKNhMOrprFZ5ShnSeb4kxw4bZLQ9EkCVW5QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731273; c=relaxed/simple;
	bh=vXBz3FNO6JY23vjI834Qvs3ZsQvSpP/wBQGWVm7vG3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQ7VcID5nzWYUPG0PTgaWAWqmMgZJ0arHOJwrbHflY0iSbUiryDeJRzYQWXUin4juWs8V25PW9KJFmIU5/aq22kacFn6XQBz+6itFVv5zdoJAFVY/3WRem6FAbUsBU9dgh9i9jf5kcaYoJDNLwHZX5V9VWTUMrbhUGatqxCpeXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8F0F068B05; Wed, 26 Aug 2026 10:01:04 +0200 (CEST)
Date: Wed, 26 Aug 2026 10:01:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Pedro Falcato <pfalcato@suse.de>,
	Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826080103.GC19050@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com> <ao3sgEET8GuY7Rw2@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3sgEET8GuY7Rw2@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 25, 2026 at 08:26:56PM +0100, Matthew Wilcox wrote:
> > >     ->page_mkdirty() had been called again for each page in the folio is
> > >     marked as dirty.
> > 
> > This may make COW more complex.
> 
> It's probably wise to be explicit when talking about COW.  Anyone from
> the MM side of the house is probably thinking "but this is only relevant
> for shared writable mmap and we don't do a COW".  You're talking about
> filesystems doing a COW of the on-disc data, not about the MM COWing the
> pagecache page into an anonymous page.

Heh.  There's way too many COWs around (says that one on vacation
all around lower case cows).

> > I'm not sure if we will have a good timing for re-reserving space inside
> > btrfs.
> 
> Why is it hard to do it immediately at writeback time?  I think you're
> in an even less restrictive locking environment than page_mkwrite is
> called in because you're not under any MM locks.  According to
> Documentation/filesystems/locking.rst, ->writepages is called with
> absolutely no locks held.

Re-reserving can fail.  So if we want to be fail-safe we need to do
it ahead of time.  Then again as per my other mail we might only
have to do it for long-term pins where the place of dirtying is
explicitly controlled.

> 
> > Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?
> 
> Actually ... no, because the VFS no longer knows which pages in the
> folio are dirty.  That's information the MM had, and communicated to
> the FS which (if it cares) has stored in its folio->private.  But the
> VFS no longer has access to that information.

All of this is quite a mess.  We'd need to allocate it a head of time
to be safe, but for that the file system would have to manage
multiple overlapping reservations for the same region of the file.
Which I don't think anyone does right now.

For RDMA/HMM we might be able to tell the file system ahead of
time with some rework, but none of these good ideas are going to
work for vmsplice.  So the only option is to grab space from
a reserved pool covering the max writeback size, which can be
refilled when freeing them.  Assuming we can actually free them
an no one took a snapshot permanently pinning the old blocks in
the meantime.
