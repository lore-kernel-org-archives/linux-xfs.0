Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEA033BBCB;
	Fri, 27 Mar 2026 06:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774591705; cv=none; b=R6ZARch4P5LustJSQJ7VAnlpExzPMNWNSxfIsCO5GdC0zP9UgRqIBhFX5sQlqZy76HW8lT6qE1Jr9OPmUGHNQIvIBnkxak8e8d0cDsjpfuj08Oxd2R/bnwWBUqC2gyhvDnJCH3YxCj6QzRAgK0By2/tb+dDThYxd4UX62W5A+Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774591705; c=relaxed/simple;
	bh=0mmKdMcZzFhuV8XflR10dvFpHq5eAIdiNaOqwazrA+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vr53oAfTPnlgKe4yIeNLcKgpvyFgOIzAzLhjfoYsbefSQ0QvgHvHULAHP/xADMpoxncgLU2IcR/xJEtCKxfms77/KxNeN3vhioEA8KZ9LdmAruXp9XPDz8FGPNydYDj7h8eSaQGnHSMy87RMazc/0oVKVSsoZtOvsdfFC74DrWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fNvdwQ99; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fNvdwQ99"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4auPwXr38hQiW2Mjvq8DGPvmEYD2PwPE2/BPhquF3ws=; b=fNvdwQ99pb7P9cxIyDp9EJTeeI
	r9Z6b2hvCrftiuFAJM1IHDssE8RxA1zYKUJWY/+REpTHnEqCeFspq3jnhb2QdRkf4wh7pdm89e15w
	60639Kl7HWkYHTTLM8PwrgdgXOnKc2/ofnXc3tEiBeC3ojjmbLGuy34lrhu+hl1lnZre6f25ZSS/9
	p0Vow++Y0M8BYpCszbOCG+7yb2zCdejpZcPjHEK5i49jWoekJ94VMWiFJPvQhBHy9kSk5ycPJq7TT
	eAR6CAl2+tBKJLjmeyqYP5d7s1fkyJlhm92wHFtRIGFhGCx3jS17BgNjAZEHH2Le+CrHJ/k5vb5w5
	h6DkL3qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Mo-00000006jvz-0rGX;
	Fri, 27 Mar 2026 06:08:22 +0000
Date: Thu, 26 Mar 2026 23:08:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acYe1oCInkDLWGGu@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRG5f9QjdEKg2JB@dread>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 26, 2026 at 07:34:45AM +1100, Dave Chinner wrote:
> At this point, I'd suggest that we should not be making random
> one-off changes to the iomap and filesystem layers like this just
> for one operation that needs deferred IO completion work. This needs
> to considered from the overall perspective of how we defer
> completion work -  there are lots of different paths through
> filesystems and/or iomap that require/use task deferal for IO
> completion. We want them all to use the same mechanism - splitting
> deferal between multiple layers depending on IO type is not a
> particularly nice thing to be doing...

Yes and no.  The XFS/iomap write completions needs special handling
for merging operation, using different workqueues, and also the
serialization provided by the per-inode list.

Everything that just needs a dumb user context should be the same,
though.  And this mechanism should work just fine for the T10 PI
checksums.  It does not currently work for the defer to user on error
used by the fserror reporting, but should be adaptable to that by
allowing to also defer an I/O completion from an already running
end_io handler, although that might get ugly.

It should work really well for other places that defer bio completions
like the erofs decompression handler that recently came up, and it will
be very useful to implement actually working REQ_NOWAIT support for
file system writes.  So yes, I think we need to look more at the whole
picture, and I think this is a good building block considering the
whole picture.  I don't think we can coverge on just a single mechanism,
but having few and generic ones is good.

