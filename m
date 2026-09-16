Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE61D4D0CC1;
	Wed, 16 Sep 2026 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579196; cv=none; b=pWAHU2T0hxMDl9RAF0llUHWwJfrqBBEIFiiQ8CQnZqZPL07kCRMXiiscmQo/w0OEYUjh+KL+1L9pbU1YKCIbs6YWc4jZ/R+1A9z2OoNsHBP9b2mkSmGBYO1GeLjqtj/wadOVg+X6eTcVsS8+SQUdBYp+j282xs3juhwAALvSLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579196; c=relaxed/simple;
	bh=FyUcoQeIMsI1Rh3cyd//GfmLeaZ9O39jLHsxIx0aJgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNBOh4n4GnjsDAkGgmMEryPXHbfYp4wIQrvRYo9//ueROYKezzQ0JflmIKX26mYrcdxtpfzhLCs3eHgG4DsgWTriWaIMbX6RxuQqMtKDQQnUt9Cn4tSs7GF4vsimFOy0kVQlCrEuzi65sZkUTMfZLb3R1k13fgdN1IXeu+bB5LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WHK95Rd+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WHK95Rd+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AL3TG6cS7IpvKn1WNOFBoSo//upiT7UQc8tclKdc+JQ=; b=WHK95Rd+UiwK0u/++Dx3yH/V+A
	N34k2YOl3NcQR7joTpd4WJSPvDhnxzG9lUCXns2MVuGjeIUTNaH7EdxxyXAqPRvljUq2WUveE1pDy
	Y3+OD7dIwBhRbHg92YSG2QkRDLhPcx2UnGbqfbMEb5sBPgpTqEpyAGYpUNkDcvOkB+WRmcUkN9hEq
	lIO0l9I0Wig/kXsK56MME+Ssh24Az8G9xv4vyibKTMqEf5iARfbc3b7IUnHg6LU/AqDKcFhXMyggM
	GXMv0YoHdkBb3smiaK3urFnEiUWCTPT650xmZdrdXkg9vnzT9YGUs8KF9hE6kxN/JtrjNj82fXMgl
	RbOiRwew==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6tI9-00000005XGQ-3v4u;
	Wed, 16 Sep 2026 17:19:30 +0000
Date: Wed, 16 Sep 2026 18:19:29 +0100
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
Message-ID: <aqrPobWbuOdsCnMc@casper.infradead.org>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
 <aqrDfoFFr8o0Mf0G@casper.infradead.org>
 <aqrJAX6nMTIo6Vnn@thinkstation>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrJAX6nMTIo6Vnn@thinkstation>

On Wed, Sep 16, 2026 at 06:09:17PM +0100, Kiryl Shutsemau wrote:
> On Wed, Sep 16, 2026 at 05:27:42PM +0100, Matthew Wilcox wrote:
> > On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> > > My proposal makes the distinction between making the folio writable and
> > > making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> > > on the filesystem side to track dirty state and drive writeback for the
> > > *folio*, while ->dirty_folio_range() marks part of the folio dirty.
> > 
> > Why do you think that's a meaningful distinction?  We create a writable
> > PTE because we've taken a page fault for write.  There's probably a few
> > naoseconds where the PTE is writable+clean before it becomes
> > writable+dirty, but even then sometimes we do both pte_mkwrite() and
> > pte_mkdirty() as an optimisation in the write fault path.
> 
> This is true for the PTE that the fault was for. But we don't necessarily
> want to dirty the other 511 pages at the same time.
> 
> The basic idea is to make the whole folio writable at fault and shift
> dirtying to be per-PTE on write to it.

Hmm.  Is that something that filesystem people want?  I suspect not.
I think they'd prefer to be told when we write-fault on each page.
But let's see if we can gather feedback from FS people.

> > It's very odd to be optimising for shared-writable-mmap.  This is a
> > horrid model for I/O.  https://cs.brown.edu/people/acrotty/pubs/p13-crotty.pdf
> 
> Sure.
> 
> But not everybody got the memo[1] :P
> 
> I think it worth considering if we want to make large folio adoption
> smoother.
> 
> [1] https://www.reddit.com/r/bcachefs/comments/1vepk4a/comment/p1sn4v1/

Since I'm an idiot, I'm not inclined to be helpful.  But I think my
proposal does fix this; we call page_mkwrite() for each page fault and
then the filesystem knows which pages are actually dirty without having
to be told under the PTL when they can't reserve space.
