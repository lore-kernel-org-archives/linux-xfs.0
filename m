Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAB51BCA1C;
	Fri, 23 Jan 2026 07:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152483; cv=none; b=TSYwVifkOu/Il1QI5OIZRQEp6xPH4KCu8tWFeFro1tBh3GzH/+x0kL4UIfzBtJSZCaKcx16AM33KeSFNkq/cZGttTAApNmHwUElRV251JKCeuo12K808CnIaQsQkNGn/9ERzL979350leryW+/EDJHJ/LKuvanEBCbFyev47ars=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152483; c=relaxed/simple;
	bh=effg95L1CoBAcFYk0I3NStO5k7pF74Ya4SBPhAIcGnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOCsfBkPSfv40oYFxeXtw/qbpl86Cg9YlClIur7NtUDhz2xVJzk6l42OpDcm1WRqEmUwHx1ShCVHEomqI0yAv3LuU1qPFgmbUVOJNV+OOQM7jy2g7xrybduEP2HQAq0I4ffedUD4rskkTSNExzGAfk6MiJ00XEEFPi2ZndF3Tuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DB005227AAE; Fri, 23 Jan 2026 08:14:38 +0100 (CET)
Date: Fri, 23 Jan 2026 08:14:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs
 helper from bio code
Message-ID: <20260123071438.GB27176@lst.de>
References: <20260119074425.4005867-1-hch@lst.de> <20260119074425.4005867-4-hch@lst.de> <20260122174703.GX5945@frogsfrogsfrogs> <20260123054448.GB24902@lst.de> <20260123070933.GS5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123070933.GS5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 11:09:33PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 23, 2026 at 06:44:48AM +0100, Christoph Hellwig wrote:
> > On Thu, Jan 22, 2026 at 09:47:03AM -0800, Darrick J. Wong wrote:
> > > > -	struct page **pages = (struct page **)bv;
> > > 
> > > Huh.  We type-abuse an array of bio_vec's as an array of struct page
> > > pointers??
> > > 
> > > As a straight hoist the patch looks correct but I'm confused about this.
> > 
> > Yes.  This uses the larger space allocated for bio_vecs to first
> > place the pages at the end, and then filling in the bio_vecs from the
> > beginning.  I think the comments describe it pretty well, but if you
> > have ideas for enhancement, this might be a good time to update them.
> 
> I'm not sure, since the alternative is to wrap the whole mess in a
> union, which makes the type-abuse more explicit but then is still pretty
> ugly.  The only improvement I can really think of would be a huge
> comment wherever we start this, which I think Kent's original code from
> 2011 had ("deep magic", etc).

I don't think a union would be good here.  It primarily operates on
the bio_vecs embedded in the bio, which certainly should not be a
union.

