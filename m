Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E21F1EB2F
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DRvc4KBJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W36M9/0mc1fnCus9qJ7IaxOcblw9HuTwdxkxDypdSPQ=; b=DRvc4KBJKsjNqxMvR41Op5TUnv
	OqtDw/WWlarA9ZUT1vJ7eLy2esqpJbnBO1lIcNAY4qQR1/OfJi/IoV0XxbJTryAiLNgijOsX4RsLP
	4g/yVOQ3w8JKa7R+pLdg3T7Pbqm9Ka7cgngnHVA+K2bO8FRfBx4mzTMUq9TU9Ffi7UU9faiEBh/7O
	3snLlx+xr527OBJFPZYY0nIB89H1txB1kVG5DUvT/yhzU38n2Vz3ZbmtpaMDjpAIz4gxDSUr2L36w
	gt3oXJRXzkXJwovSMU0vldiQ86TH4zm/V3NMf6QOobCKakY/p64FAJBhs2qKt+X7Q0uvlnr0rE1oC
	Dz6wyW8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLIBP-00D5WU-2r;
	Thu, 04 Jan 2024 07:30:27 +0000
Date: Wed, 3 Jan 2024 23:30:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org
Subject: Re: [PATCH 8/9] xfs: support in-memory btrees
Message-ID: <ZZZek95Tyfuxz8RQ@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
 <ZZZUkq145pW64Zzo@infradead.org>
 <20240104072752.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104072752.GC361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:27:52PM -0800, Darrick J. Wong wrote:
> > Btw, one thing I noticed is that we have a lot of confusion on what
> > part of the bc_ino/ag/mem union is used for a given btree.  For
> > On-disk inodes we abuse the long ptrs flag, and then we through in
> > the xfile flags.  If you're fine with it I can try to sort it out.
> > It's not really a blocker, but I think it would be a lot claner if
> > we used the chance to sort it out.  This will become even more
> > important with the rt rmap/reflink trees that will further increase
> > the confusion here.
> 
> Go for it! :)

Happy to do it you don't complain about all the rebase pain it'll
cause..

> > That means xfs_btree.c can use the target from it, and the owner
> > and we can remove the indirect calls for calculcating maxrecs/minrecs,
> > and then also add a field for the block size like this one and remove
> > a lof of the XFS_BTREE_IN_XFILE checks.
> 
> Sounds like a good idea.

Same here.

> 
> > > +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> > > +		return 0;
> > > +
> > >  	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
> > >  		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
> > 
> > Should the xfile check go into  xfs_buf_readahead instead?  That would
> > execute a little more useles code for in-memory btrees, but keep this
> > check in one place (where we could also write a nice comment explaining
> > it :))
> 
> Sure, why not?  It's too bad that readahead to an xfile can't
> asynchronously call xfile_get_page; maybe we wouldn't need so much
> caching.

Actualy page lookup or allocation never is async, so this would only
be about reading swap from disk.  And given what a mess the swap code
is I don't think we'll have an async read for that any time soon.
