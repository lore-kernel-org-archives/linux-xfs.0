Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D381C6FF5;
	Fri, 17 Apr 2026 07:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776411058; cv=none; b=PBxgZTikpoXlFJQ0R0cH+KXK9hgncID8VcEI8oynaZvI7OwAFUzSRDw7eYM+8iwG3mGaqpjWHfkqhDHfT6zYSKGNApP+DTZfR56mT5DsbAhoMZFia9wa1l8TmzH3SmOvnG6KTq1mgveBZFnMkFmR0tjyMMuirTO96ctFSizfjgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776411058; c=relaxed/simple;
	bh=aodTMjFDDLH0XqR5x0JMN+7jrIXJsaPFvb1NeWpriGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjvhz51SnZYIOFwO1nXQb6VtTNiMgqcZMCFOOysfmDjgSrQw/TkGq9KNrzhdHXPmDkb/Pj911nQINaGlTCg0I9vnFlEolDz6VkeQ18sDFXVbW6olLgZs8PVR32EVnMlX8pCKBpwExdMZN1qVLL52jInP4RqxWO8zaV4N85ardms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sh0191ye; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sh0191ye"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=/l71e/ER/+VQEChh8Dmezn6S3hUrL+BwD90ojgmYkI0=; b=sh0191yeR65OL4SdSNMFvWgXMd
	vxwiL06OE7gqXpS8Cdb6nXvra9TNaXTFQvPSJ0fpa7juw73mRzf422X1RMlSJP17H+BZBqWPm9BGL
	hil2T9cCAkmDoAWqVzlTOVu8fxKGBJ9OQM1ifn64JQmgAweB44W85oZ6UZcOKu57djS6qwq8blyPP
	VEG77Js1CqxzaKHNud6Aio21CNFC5xSsBm2CxuqnYxSf8Rejsr5A5PthV5Vx2KmeGFs5jfTxPm4pH
	pyewxrnN0n6N9YqxFxYa4k3TRFsg36qaFsIZHdonXcfQNc9sAsk7f8Y5ZsmWp1qIRVbkCYbZmDQpJ
	pogLEkZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDdfC-00000003aW0-0FEU;
	Fri, 17 Apr 2026 07:30:54 +0000
Date: Fri, 17 Apr 2026 00:30:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: changfengnan <changfengnan@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Fengnan Chang <fengnanchang@gmail.com>,
	brauner <brauner@kernel.org>, djwong <djwong@kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, lidiangang@bytedance.com
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Message-ID: <aeHhrsGtJRhP521d@infradead.org>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
 <ad867C8dlaQGLS97@infradead.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.eee197c0.e67e.40c8.bd15.8fab5bbb42db@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.eee197c0.e67e.40c8.bd15.8fab5bbb42db@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 16, 2026 at 11:16:23AM +0800, changfengnan wrote:
> > But it already is a major improvement, and one that would apply outside
> > of narrow special cases.  So I'd really like to see that patch.
> You can see this in:
> https://lore.kernel.org/linux-fsdevel/20260416030642.26744-1-changfengnan@bytedance.com/T/#u

Thanks!

> > All direct I/O requires this.
> > 
> > > - No bounce buffering, fscrypt, or fsverity involved.
> > > - No custom `iomap_dio_ops` (dops) registered by the filesystem.
> > 
> > I'm really curious at what difference this makes.  It removes a few
> > branches, but should not have much of an effect while limiting the
> > applicability a lot.
> Yes, the impact shouldn’t be significant. 
> Since this is just a RFC version to confirm that I’m on the right path, there
> are many aspects that haven’t been fully thought through yet. I haven’t
> tested these scenarios yet, but I’ll add support for them later to
> check  exactly what the impact is.

Sure.  It might also make sense to skip some of this if it brings a big
enough benefit.

> > > +struct iomap_dio_fast_read {
> > > +        struct kiocb        *iocb;
> > > +        size_t                size;
> > > +        bool                should_dirty;
> > > +        struct work_struct        work;
> > > +        struct bio        bio ____cacheline_aligned_in_smp;
> > 
> > Does the cache line alignment matter here?  If yes, can you explain why
> > in a comment?
> 
> I copy this from struct blkdev_dio , I'll do some test to verfiy. 

Thanks.  Btw, another thing that might be worth is to drop the
work_struct and reuse iomap_fail_reads or something similar to it.
This would be a pretty big size reduction.  Additionally we should
be able to kill should_dirty and just rely on bio or kiocb flags.

