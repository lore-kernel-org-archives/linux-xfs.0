Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9688B3EBF3A;
	Tue, 27 Jan 2026 05:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769492858; cv=none; b=GX4A8c/q60xsPWZuCdbJ3Ng5mXkVhLFdprs5YJkpVVt07omb5YyLVkGMjE+QQ+FFacotYTthl2UqBz0HBzSpn3IPRylU61B9YQ9HoWeyGboyQx6iOCzCah7r4xTz/aZp1VzYjFNORTY48lFnyqhtOJIOVjDSXi5o45gR3i9hQ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769492858; c=relaxed/simple;
	bh=veskkUAf5RT75BCyARWOgAORdbwz+JaTvU7rObIG+fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHRuVUgf2V/SLVDdhpCK78UxA5g7IJWxboywGSY9hw1idGmvhIZqYPDFOIhMCiSlhmNxVSi23+oJizyAQzrHg8b2xo510Wv/5bpSTxN6Av6kN8KoGCCzVm1WgsOTDBa/l8r5IT/d2//KiDNThRcSqDxLPeIluckP+QQ4sHOaiLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 69541227AAE; Tue, 27 Jan 2026 06:47:34 +0100 (CET)
Date: Tue, 27 Jan 2026 06:47:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Kundan Kumar <kundan.kumar@samsung.com>
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs
 helper from bio code
Message-ID: <20260127054734.GA25175@lst.de>
References: <20260123135858.GA24386@lst.de> <20260119074425.4005867-4-hch@lst.de> <20260119074425.4005867-1-hch@lst.de> <1754475.1769168237@warthog.procyon.org.uk> <1763225.1769180226@warthog.procyon.org.uk> <aXemDMAfgC6vCU9K@casper.infradead.org> <20260127051352.GA24293@lst.de> <aXhQoa8QsQfMvyZk@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXhQoa8QsQfMvyZk@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 05:44:01AM +0000, Matthew Wilcox wrote:
> > I'm confused.  Your example are all about something that would happen if
> > we actually split up what is currently struct page in some way.  But I
> > read Dave's mail as something is broken right now already.  Which of
> > those is the case?
> 
> What's broken right now is that the network buffers are now using frozen
> pages, so they have a zero refcount (Dave, do I remember the current
> state of play correctly?)

Nothing using this function right now ever deals with the page refcounts,
so that should not be an issue.

> > vmalloc is a tiny wrapper around alloc_page* + vmap/vm_map_area, and a
> > lot of code all over the kernel relies on that.  Trying to have a
> > separate "memory type" for vmalloc is going to break things left right
> > and center for not much obvious gain.  I'm not going to say you can't
> > do it, but I doubt that is actually ends up easy and particularly
> > useful.
> 
> Most of the code in the kernel doesn't drill down from vmalloc to page.
> I don't think it's going to be all that painful, but I also don't think
> I'll need to address vmalloc in the first half of this year.  Just trying
> to fill you in on the current plans.

Maybe not most of the kernel, but vmalloc_to_page and is_vmalloc_addr
are used in quite a lot of places, and usually need to handle both
actual vmalloc allocations, and page/folio allocations mapped into
vmalloc space.
