Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9C345CC2;
	Fri, 10 Apr 2026 06:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801860; cv=none; b=F+pGNNtubIVFnL0ltFCCrj9sJcPUA8gTjF6wuugC8nYXBl7tLGeFe3N3/YeyWaW2w6mvtv6gy0til1fp59Bp8UKHHaqv0qWmek5VhIDAzCinyNb8h1NWVoPb4va9P3ISCf670cGLAuL0JOvL6ZV75WSoUAx4XchzzGXkVnYOWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801860; c=relaxed/simple;
	bh=OdGHQwpqgvNgX+GVjjwYFcl6quDS0xZcNmCnDzSNWsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXprDF1B1jiJz7Z7D591cOkbyjSPlITl+pOlK/I9ginvitkUiDi2kxfP2jgUpM5Ph/Rn99jt7buOMR8V4cdZ0BDHHCQvdVSldrMjq4v7gZ9Tob4ukQCSjGfoWQ5xApdBNpHpRGTotP4ya0FrIg5trTrKeY3tIFqXI4GzYungf3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E27AC68CFE; Fri, 10 Apr 2026 08:17:25 +0200 (CEST)
Date: Fri, 10 Apr 2026 08:17:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <20260410061725.GA24667@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-5-hch@lst.de> <adgJqiA0vivaW7NA@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adgJqiA0vivaW7NA@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 09, 2026 at 09:18:50PM +0100, Matthew Wilcox wrote:
> On Thu, Apr 09, 2026 at 06:02:17PM +0200, Christoph Hellwig wrote:
> > @@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
> >  	}
> >  #endif
> >  
> > -	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> > -		bio_queue_completion(bio);
> > -	else if (bio->bi_end_io)
> > +	if (bio->bi_end_io)
> >  		bio->bi_end_io(bio);
> 
> What I liked about this before is that we had one central place that
> needed to be changed.  This change means that every bi_end_io now needs
> to check whether the BIO can be completed in its context.

Yes.  On the other hand we can actually use it when we don't know if
we need to offload beforehand, which enabls the two later conversions
and probably more.

> 
> > +++ b/fs/buffer.c
> > @@ -2673,6 +2673,9 @@ static void end_bio_bh_io_sync(struct bio *bio)
> >  {
> >  	struct buffer_head *bh = bio->bi_private;
> >  
> > +	if (buffer_dropbehind(bh) && bio_complete_in_task(bio))
> > +		return;
> 
> I really don't like this.  It assumes there's only one reason to
> complete in task context -- whether the buffer belongs to a dropbehind
> folio.  I want there to be other reasons.  Why would you introduce the
> new BH_dropbehind flag instead of checking BIO_COMPLETE_IN_TASK?

Because there's no BIO_COMPLETE_IN_TASK? left.

> >  	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
> >  
> > +	/* Page cache invalidation cannot be done in irq context. */
> > +	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
> > +		if (bio_complete_in_task(bio))
> > +			return;
> > +	}
> 
> I thought we agreed to kill off IOMAP_IOEND_DONTCACHE?

Only IFF we don't need it.  With this version there is no way to just
remove it.
