Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A228BEC
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712806720; cv=none; b=tKa/fYl7nS5fZnaNlwTxbvabQrvAOLgt0dVU5GWhx1845xJ/VtPqYGMs2dqphcxldXQO7NgCy2C/HWd8qUGMsKuTwCwmKXwUYi3kIQP2x24ih8p8AgwGfYjgYd7Mki+mxn83ksRkiR+4PbgCZ1MXgA/EVPbyHyz0f2bJ5ZAgxGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712806720; c=relaxed/simple;
	bh=t2Fk2yJeDQXsItrg8VVVRjY6QWG+GcPwYxqgSXDHOQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUE4aC0AMs8Ax+6SQ6A+0LWZSnMRsU1L0tASn9+jkSXqunL4jEuKjPIlyaAJ9skT1riU49T8u4T98UWChaeR3R/CznqixZl1jZz3gSH0guiy4Hl6J4eH2EeDnzAc4ZO/5QZ9/a9MTLrywTDvn+m0cHgKhseDr340/xSMdDOHFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cLoi3ExT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cLoi3ExT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J1tbHFVicLDjR8WO8NUxjcg8cG3X7gldbNyzykjtGPo=; b=cLoi3ExTZT2SXv9agmAIS1l9EX
	NR10Ut/GH+hzcYkh+XV7dfS60pXYU0tRoXip5NHVvl/dtNwjn4ci8j0m7Ldmo2m8jbOhoH2Bp7COw
	iL3XO17mXef2KokCJlhb9GS5AijhVyuZ+9t/RBknPNrjldffhdH8JZl/q3W3+i0pfqC1PTYGzy8QD
	fZurFgl/tPcJ8dLZjU4BVityFJ9z/RGE7P0uCtb0WI1EUaIBjkTZvjLnD4wPAV+gyZT7P2XJGRVaL
	H6ufF016ntwcYWtWRY8Cm3N4x4WDuEUbeC1khUKBs64VxZBkpu9BBAZa+9S3KgMJD6ST8r6fJRfOC
	aLKo/XIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rulGo-0000000ABvA-2XTf;
	Thu, 11 Apr 2024 03:38:38 +0000
Date: Wed, 10 Apr 2024 20:38:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: introduce vectored scrub mode
Message-ID: <ZhdbPhnf1Usplqfu@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972051.3634974.4637574179795648493.stgit@frogsfrogsfrogs>
 <Zhapez1auz_thPN1@infradead.org>
 <20240411005941.GQ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411005941.GQ6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 05:59:41PM -0700, Darrick J. Wong wrote:
> I thought about designing this interface that way, where userspace
> passes a pointer to an empty buffer, and the kernel formats that with
> xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
> was.  I didn't like that, because now the kernel has to have a way to
> communicate that the buffer needed to have been at least X size, even
> though for our cases XFS_SCRUB_TYPE_NR + 2 would always be enough.
> 
> Better, I thought, to let userspace figure out what it wants to run, and
> tell that explicitly to the kernel, and then the kernel can just do
> that.  The downside is that now we need the barriers.

And the downside is the userspace needs to known about all the passes
and dependencies.  Which I guess it does anyway due to the older
scrub interface, but maybe that's worth documenting?

> 
> > > +	BUILD_BUG_ON(sizeof(struct xfs_scrub_vec_head) ==
> > > +		     sizeof(struct xfs_scrub_metadata));
> > > +	BUILD_BUG_ON(XFS_IOC_SCRUB_METADATA == XFS_IOC_SCRUBV_METADATA);
> > 
> > What is the point of these BUILD_BUG_ONs?
> 
> Reusing the same ioctl number instead of burning another one.  It's not
> really necessary I suppose.

I find reusing the numbers really confusings even if it does work due
to the size encoding.  If you're fine with getting rid of it I'm all
for it.

