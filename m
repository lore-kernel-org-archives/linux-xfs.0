Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBAF3F1ABE;
	Fri, 25 Sep 2026 05:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790312488; cv=none; b=GcfOJbR1dKPOl4+5o/ckwo64zVxt1E6ECw/6L4wn/+xFkhDI7MNJ+qMhZuGsTOSvbra9CYDeXSkcIVCbOPP7/z0JrHeWzIWFS1IA3zWweR8A4A01KjsDyT9QkXq5beSDyvy2gYJCtpnc3voZgcVh3zVu3ZAQGVwkLM53hohrvZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790312488; c=relaxed/simple;
	bh=hU1V2dOyRwTLmCmF5l5z+LNo0xAxDEN/X8wzjkwHNqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGxiNSfc2YSCelsCABSs2ilSJt4i1ykDtA7gVgBFgHmM+O0UUmRzOgWIJpInujE4mgDmmFSaxuyu//pn4HaprqE9jVegmOMcn/3aSeLu9icjfT6Y+XLpweVx9K7GWQ2T9G+fvHhR/+FkQunsBjdDewWI0DRpORVqrGXbsZGV/2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zi8tr8as; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zi8tr8as"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k1UXdhXtnbNYrg0CsbXOsjWuQasm0HMU04JsawDn/Hc=; b=zi8tr8asxGDflKUbrz6d8tIXf9
	LkjmvU/NkihUMNSuL6B8joOWRVOcvyXTSlSfZ9MXZjfFPjnMRMm8dlfQtpVMT0sgQ81RYB2lnoIE4
	WmmGMziU4WwMLGfp2iGOrA1Yb7p/aTt8bwTMj6UEWEVIbZYcOnw4QXtJijQxg/2sbptgjgsGun5Rb
	UbkQsLJ97JWtJJLvlvIk4TUfv4gkSyvxIO2KablsxtyNNOom44fm1xbQ9UoDwHhudYwj8O7BpWz6P
	s7kKxWbRLurw2Qs0U58XVeBzWufFoDNlOTNdT11N4IuArfHV6ONcNZUVtXWG7iSTuFXonmq3EACOt
	STAqnAsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9y3q-0000000CfRY-1Bpg;
	Fri, 25 Sep 2026 05:01:26 +0000
Date: Thu, 24 Sep 2026 22:01:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/{349,350,351}: fix scsi_debug parameter quoting
 issues
Message-ID: <arYAJrKddwFUmghK@infradead.org>
References: <20260924060315.GF6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924060315.GF6253@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 23, 2026 at 11:03:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit a90ba59dca447d reworked the argument handling code inside
> _get_scsi_debug_dev to put all the remaining arguments (after we extract
> the first four arguments) inside an array that gets passed to modprobe:
> 
> 	opts+=("$@")
> 
> This code takes every command line argument and copies them into the
> array verbatim.  Contrast this to what it did before (excerpted):

Arrg, that's what I get from following good suggestions on shell
style..

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
