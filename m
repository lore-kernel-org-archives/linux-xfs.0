Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5843C4AA57C
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381177; cv=none; b=awSb0niI66reu6nJS+QQ9DHvVVvlel77YGRu+hmUqBSbv5UljBzVPZRxgRtjHtusi8Bd0gvCeKpXEwU/uXIim9QmxkhtGZTt+Ql2SvwSAPoD4Pfo1113U1lons6HtaOqNFpcQpRyOrcC1WEj7mJrpAfDhme7E3mmrYy5fgQ1uDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381177; c=relaxed/simple;
	bh=WBmkqg4BWkTn7BtNrQ6Gl1X2WwLvjrsRi9Q9lFRLcVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uk6ol6o7z5jI7oyV8EgJmrSojncGc0YHtOcMXobmGhcUyvCLQagc/anrA1sUgmREwXvbrZ06A+0p2AJe40sdVOIstjGYByEUkQjIHt139l5Au99hH6LvLLpciOmruC0TiZWldDf9esQbRFhzLvi8qHIXOM/TH2mLZgWIoCnEuUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2GsepH3R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2GsepH3R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b8r1k5M3c49szAylejfJeL+y7GnbuQnzOveN00R9K1o=; b=2GsepH3REfi+EV+2waiNinYzTL
	MK2MM342nacbeoKT4twX4GgOH08rH3x+UTuDF4FKQGRi+ubp8+u+GwTZsSNEATp/f5NwXwoddlgag
	84psMl5EM/FHusBN3YITctr59UQhdMDdymIlKgtzqy6wMzrzzG7aBWiDrhuCBYFgca5b2ZKwJPLoY
	VXmBo1GnSraWWKB/Hu5O0xKQJnJAj0e8V6wioNEEFloOE9/5fOCmU9R0OupIWMkw67ES1HpwFWnSR
	FJWNin82GtRjNyitDUh6+vSc1OY/5+T0Jmk9Fws0Dg0we1pjKNcGhR5MzP9/DgJ8zX/pLQDnmpvpm
	yj345MPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xES4a-00000002Z6Y-2VEa;
	Wed, 07 Oct 2026 13:52:44 +0000
Date: Wed, 7 Oct 2026 06:52:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/3] xfs: factor out xrep_reset_fork_to_extents helper
 for scrub/repair
Message-ID: <asZOrBetW814MMDs@infradead.org>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <5a8c7689-492f-4119-a75f-5d5bb442786d@sandeen.net>
 <20261005202059.GD2705364@frogsfrogsfrogs>
 <d68afc86-6510-45c4-a225-784e7f629a33@redhat.com>
 <20261005211741.GF1615495@frogsfrogsfrogs>
 <asSwijU34G7m5RiQ@cronus.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asSwijU34G7m5RiQ@cronus.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 06, 2026 at 10:32:44AM +0200, Carlos Maiolino wrote:
> > There shouldn't be any, I just thought it looks cleaner. :)
> 
> Perhaps...
> 
> ilog_flags |= (whichfork == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA)
> 
> ?

Urgg.

> But the switch indeed looks nicer.

Agreed, switch over if over ternary operator.

But either version is rechnically correct, so for whichever version
lands:

Reviewed-by: Christoph Hellwig <hch@lst.de>

