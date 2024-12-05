Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DA841C92;
	Thu,  5 Dec 2024 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733381917; cv=none; b=PFDXQHNrADHNTOa59xB+okX7Mo93BA+Vc2OrdH61+RtcHqy4m1IapeNWP8NiHE0GFkUUcMdcOW9nH/Bi134/n1CmLGAS+AvEXu2J+ayDY1pbTCAISap+D3CosqkbdkN8mDd+AyeirxRwjwUa2XSEzsR9PuS7no+H5yVUgeUSg5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733381917; c=relaxed/simple;
	bh=JasKQmmrX4dQpPW6JH5KS6lL+wi9Ur0bfej5nSWQzaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbZFnfVPFBVYwEID83gVdmUam0Dn8BQCeM/kQd0FwWsqJUFHjX+WLb0miTGppRi4AnvxJKDa3hgRPlHLaB4Vo8jSyGkdjo1AI72/gVZJ288Lar7l/gWSkAWaG6qxYrybS7y1AS0qzhXGJKQFk5JZVKXVqLIqCbXx6cBZNQNKvro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NJECKODx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NJECKODx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GwystIXH4Mk5h2sto5NHO4qaBRq3lgHzlaEYhiJD2jo=; b=NJECKODxZ78RMCR1Gv+dYU95hy
	in1XHL1iqs9jOeyoKhKSmDjnk+oh6ijB0DShOSzvVKyHXmPIBCQHNiOotuRaBT4qzFvnlx3NR1lPJ
	ISL1WV/MaPc+tAzgFp5XcZ/pGvGds2T89ZUk1DqqH+vjHY/d48cFW75s5sVO6ji7nXqkPL/qfquhl
	5rGwtLtWLXDtQ3l2aOme00MpEBiTo+Tx3tXGo2anSyIgc+x3mQ5wui0MziRXpTmXKkji76rqe/tvx
	JQ42WZT2DLTkHhg1o70hPS0h8rxg8dWA9EPqDQGrWVrvmJ7s6AcxMJOUyXXrfScEovxQqC0m3TWFt
	5y/CQeDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ5on-0000000EwU5-21DR;
	Thu, 05 Dec 2024 06:58:33 +0000
Date: Wed, 4 Dec 2024 22:58:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <Z1FPGXpTIJ1Fc2Xy@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FNqV27x5hjnqQ9@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > and testing didn't trip over them until I started (ab)using precommit
> > hooks for spot checking of inode/dquot/buffer log items.
> 
> You give little time for the review process.

I don't really think that is true.  But if you feel you need more time
please clearly ask for it.  I've done that in the past and most of the
time the relevant people acted on it (not always).

> > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > towards the end of the six years the patchset has been under
> > development, and that introduced bugs.  Did it make things easier for a
> > second person to understand?  Yes.
> 
> No.

So you speak for other people here?

> I call bullshit. You guys are fast and loose with your patches. Giving
> little time for review and soaking.

I'm not sure who "you" is, but please say what is going wrong and what
you'd like to do better.

> > > becoming rather dodgy these days. Do things need to be this
> > > complicated?
> > 
> > Yeah, they do.  We left behind the kindly old world where people didn't
> > feed computers fuzzed datafiles and nobody got fired for a computer
> > crashing periodically.  Nowadays it seems that everything has to be
> > bulletproofed AND fast. :(
> 
> Cop-out answer.

What Darrick wrote feels a little snarky, but he has a very valid
point.  A lot of recent bug fixes come from better test coverage, where
better test coverage is mostly two new fuzzers hitting things, or
people using existing code for different things that weren't tested
much before.  And Darrick is single handedly responsible for a large
part of the better test coverage, both due to fuzzing and specific
xfstests.  As someone who's done a fair amount of new development
recently I'm extremely glad about all this extra coverage.

