Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3FB36E498;
	Tue, 23 Jun 2026 14:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782225675; cv=none; b=bwW3/Q+/mHFFPWJBclTga7RzNy3OScADk3tVbny0vNTJjqhw+Un+PJ5wBmLUxiYFl6iHSEr1rhNjVwBSaE7ZZMPwHa7ivmJAC+ZA+N1xXg5F0qoZQywcZoZVDAE3mcStoK4JMUxhUlBw3tUi87TSMO8lH2hUijKMWS1mfRVZGCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782225675; c=relaxed/simple;
	bh=1TVmza4ah9fy7QE8dUFRGSBWXfuGA11lbIFLNEleDfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEk3jQUmgHYanK3bXx9UBGL7H56XZMcHdIxVfSNn5DUut1zxxV9M3v1k4Kl1qtkBK38GPScf6368gDzfPr8+OXPdtzxdYN15nyiCClGnzaVSmlTs5m/Sv2IjBXBxLJZOuE+yWd7esri3/gDUqL4eZG69JpJE+TO2MMRahgOfzww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lFxYT/La; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lFxYT/La"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4d9uZihVTITqECjNOckLRPY91GcChvumLhfsntVrCpo=; b=lFxYT/LawOdPucwQWwKoiiK7Qw
	r4UvtC1tdnd8Lc+W6PsMMeN2CV8qZqdTYVz6bT00Gy/jYPU55SqM8Sx9JYl7Fwa0cjH59GVzCf5qN
	Bj7E1N7FobfM9i+BmeaKY9H8GXsV3d7okFAcjPuynIQPXjhWzRSuIGV1Jq/Bc3KvD9Dmi0LuhbLwq
	+bUn/0fbP3zkFKCKYvD4OY3fSQc49IcqROHqaZbNnW4+3+sOQjiVYcnyogobkajILWEe3MaCIGAYk
	vx0bPxUNRvJwTAxQet9beoa1iNVjI4js0H7uiEm6ZyIHdkRcYpxI28008P887X/kE0H+zpWggwwul
	r5XnxeZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc2JK-00000006TPV-2XNB;
	Tue, 23 Jun 2026 14:41:10 +0000
Date: Tue, 23 Jun 2026 07:41:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Carlos Maiolino <cem@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
	hch@infradead.org, aalbersh@redhat.com, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>, ailiopoulos@suse.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <ajqbBiJqOije9z4N@infradead.org>
References: <20260219114405.31521-3-lukas@herbolt.com>
 <20260219114405.31521-6-lukas@herbolt.com>
 <ptb5fg2wmlanfsvwawgcye6a2ezevrdnxfq4oxhwoialvgfjld@is3nzrdegqzk>
 <ajj5t_viQ7YiTLj5@nidhogg.toxiclabs.cc>
 <yvjbtwfl4wfctmowoxpkzqhlqt42r2sns6p3t4j5ge3abv2ydr@degtb3bjzp4c>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yvjbtwfl4wfctmowoxpkzqhlqt42r2sns6p3t4j5ge3abv2ydr@degtb3bjzp4c>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 22, 2026 at 12:05:25PM +0200, Jan Kara wrote:
> > by accident. Properly aligning it to 64k to match its min_io_size is the
> > right thing to do to avoid lots of RMW cycles for once. But I'm pretty
> > sure you already know that :)
> 
> Yes, I agree the XFS logging with the old defaults performed well on that
> machine only due to the battery backed cache.

Which to me suggests it is reporting the wrong min_io_size.  But good
luck getting RAID controller firmware fixed.  Although maybe we should
quirk it in the driver?

> > Well, I don't think 'fsync heavy' applications are the default, or if
> > they are, specially on high-end systems, then I'd argue the application
> > ought to know what it's doing. I do agree that's no universal win
> > anywhere and yet seem to fix the sunit to the hardware reported size is
> > the right thing to do here.
> 
> Fair.

I think the real question is if the value/defaults have any benefits
for this setup.  And I somehow doubt it.

