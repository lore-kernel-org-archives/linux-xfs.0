Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42221862;
	Wed, 26 Aug 2026 00:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702572; cv=none; b=Lg6EDfqH3EmWa8/xtxoKa+ae8SDs3HYRI3lwzNqDXoD3Q2SO4nrdz49c7jizKUc+MVAYrEuh2YAbzW+Z11JUAgLh30Vk0rvGOtVXaM4Bx1LCLdI51wiqGKmsxpnukXzuLphNVLkZHZm6EkYdiV+DVYEAKh6wInaFvWeQboAiV/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702572; c=relaxed/simple;
	bh=7wdlMJetXtztzawFTGBNjsp0NLyzHpGNH3uaTytMYwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPswxlQxDzMrCincHI75Yn+fBQEiXAmZFpeO11a4ueCX38uXH9MnYPS2q2fpuiyv3FvtrldxROg04zU15qOcqYA0ZB1/9R9WWf/jI0D13N+KWRbOyQwzINkLeqpZHMHc9u8MLrfO+SEd73fAfZXDLPFR81v4S9eLr9Hd4KYgw5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RyHg/Tab; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RyHg/Tab"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=NBdgN2DyXgys503Hsd3B8DyE4gvlVeQWSt6yuz5SVBE=; b=RyHg/TabT5xtxP4rCiWs83zs0l
	uFXEjv2TRABsE5z6Q41aS5XpFB+yOekqiSG3YLozinWwVU00yOdxwb32Lta44pBWrdbF9pObup8cR
	RwhUzLZ7ZyL68VGQIhcBZd3L9c28j/g2kip2rCD6EP3AtrRica4AJfwKuHfBkYq+qT5EfhpvYUMZl
	Wc1I9HqTnXkMBdIQTMCVptCTN6nu79viSUu1cbtHySUnJXWXaT/mz74cASY4sK6VNOCtxViWEQ8zS
	EcwNpxjtAd4PcE8fenqUh+6I8sc8kpxuj/873GqwjNw8pr0yYPOKX+x/jGpujRFD5zGOYJni8hhWi
	9awlrIaw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz16D-00000009ytH-141Y;
	Wed, 26 Aug 2026 00:02:37 +0000
Date: Wed, 26 Aug 2026 01:02:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao4tHXnIySccVRIz@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
 <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>

On Tue, Aug 25, 2026 at 10:06:30PM +0200, Jann Horn wrote:
> On Tue, Aug 25, 2026 at 9:54 PM Matthew Wilcox <willy@infradead.org> wrote:
> > On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > Could we strictly ban using get_user_pages*() for write access, and
> > > use the unpin_*() helpers to somehow enforce that folios are always
> > > dirtied on unpin? I guess the problem with that is that we have no
> > > state that tracks whether the pin was read-only, and finding free bits
> > > in struct page to keep track of this is hard?
> >
> > We'd need a count, not just a bit or two.  A pincount for all folios
> > is on its way (eventually) but I wans't planning on tracking writable vs
> > read-only pins.
> 
> My thinking was that once a folio has been pinned writably one time,
> it should be fine to mark it as dirty every time it is unpinned, even
> if some of those pins were read-only?

Ah, so the point of this proposal is to mark the folio dirty when it's
pinned.  Nobody clears the dirty flag at any point until it's written
back after being unpinned.
