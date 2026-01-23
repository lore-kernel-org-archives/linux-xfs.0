Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A630E0E0;
	Fri, 23 Jan 2026 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769176746; cv=none; b=JyLUdKUW29W2mm1nMBH634B+QVqpziZGc5m1gMUjXkslKQslENBtWF2e6HW94BKL6woOmUasfjJS5cbsI+92r/0dcMP2Qy4kUZLzJ2z3OEZPpMI1WmGPFcJKjUqeaykNJ4kt1nqVnO3x7vEOAVbJmc7xKzXZLPstQDwdXeyKYY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769176746; c=relaxed/simple;
	bh=KsDWJy9IIzRYwrCXF2vcDTPb6iqadM+bu8+EwSQNB3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9agmW+WSG+NYl0h8monX0azhT356rSScaSafuse+XEaORUzAi8fGdLxVm+HXpNqsYlAvX/E31rNLG4LFzCkg3H/7o0Zjo3+FpRYgmFdDo9KsKqeBgFB5Zg5ohrWKXUerqE0UHU9v9Ohv52OYDh79Pn41UXPH8yXwnqz79/Tcwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7930E227AAE; Fri, 23 Jan 2026 14:58:58 +0100 (CET)
Date: Fri, 23 Jan 2026 14:58:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Kundan Kumar <kundan.kumar@samsung.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs
 helper from bio code
Message-ID: <20260123135858.GA24386@lst.de>
References: <20260119074425.4005867-4-hch@lst.de> <20260119074425.4005867-1-hch@lst.de> <1754475.1769168237@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1754475.1769168237@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 23, 2026 at 11:37:17AM +0000, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > +static unsigned int get_contig_folio_len(struct page **pages,
> > +		unsigned int *num_pages, size_t left, size_t offset)
> > +{
> > +	struct folio *folio = page_folio(pages[0]);
> 
> You can't do this.  You cannot assume that pages[0] is of folio type.
> vmsplice() is unfortunately a thing and the page could be a network read
> buffer.

Hmm, this just moves around existing code added in commit ed9832bc08db
("block: introduce folio awareness and add a bigger size from folio").

How do we get these network read buffers into either a user address
space or a (non-bvec) iter passed to O_DIRECT reads/writes?

Can we come up with testcase for xfstests or blktests for this?

How do we find out if a given page is a folio and that we can do this?
