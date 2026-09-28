Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32378258EDA;
	Mon, 28 Sep 2026 05:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790573083; cv=none; b=cwKLpA0XcYOgAiy8OH3BSy4sf+xUIDUGqR4ZFKzdyeXxrZmlVVIukpm4lTYYZ5zcEEjJZ3a3RbUbcmYX4/m/YOXEzXiaIdvBI+zu++aqkmWd3eaaLZAopYQeaOSvOJxj6JRwISbNRvucsAJW0Zmj+KEBL7oKt/b9NYfQcSc6l9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790573083; c=relaxed/simple;
	bh=fxPNveahY4s0pefiAbkaRuHe6RiakOLjxH2H3LlXS/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jn0Z2nywl+a7gKhu0inO8sjLdrYZ0OeJbcf2xLv+8SZILnN/FwjjR2WRJ1DqguYPppIn88vAsZWR84SyM0eVL/7HGRUiJy2ejEPAkeiMXGlg/a9DNfvgT8tFecjRdO2bhlIIvlfVtK+sdLdtBSKv7e8SORje36NZmp8a64l0l54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B715F68BFE; Mon, 28 Sep 2026 07:24:36 +0200 (CEST)
Date: Mon, 28 Sep 2026 07:24:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <20260928052436.GA18925@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <arWpyhFyV3ouYAEx@dread> <20260925062710.GA3798@lst.de> <armf05yfzhSBUsUh@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <armf05yfzhSBUsUh@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 08:59:31AM +1000, Dave Chinner wrote:
> You haven't answered any of my concerns - you're just handwaving
> them away and....
> 
> > > and there's a
> > > whole new buffer cache interface to "read a buffer", and that is
> > > used to open code reading checksum buffers and joining them to a
> > > transaction rather than using the existing xfs_trans_read_buf...()
> > > interfaces.  That in itself needs careful consideration, and clear
> > > justification for why it must be duplicated to stand outside all the
> > > existing BLI/transaction APIs, especially given all the "use the new
> > > async buf read interface to do sync buffer reads" behaviour across
> > > the patchset that could just use the existing interfaces.
> > 
> > I'm not sure what to make of this.  The paragraph almost reads like
> > AI slop to me.
> 
> ... calling the concerns of an experienced engineer "AI slop".

No, I call your meandering writing style slop.

> I'm so disappointed right now.
> 
> You're better than this, Christoph. You know better than to attack
> the person instead of addressing the technical concerns they've
> raised. Calling the concerns of an experienced engineer "AI Slop" is
> also pretty insulting.

Stop this bullshit.   Replay to technical details in the patches if you
want, or wait for the requested document, but don't write weirdly
halluscinated high-level concerns.

> You also know this has a chilling effect - how many people are going
> to be willing to say anything negative about your code, if all they
> get from it is a bunch of insults in return?

They don't that response to technical concerns.  They get detailed
answers like Darrick did.  But that requires actually expressing
technical concerns.

<lots of ramblings snipped>

> > The buffer payload is somewhat new.  It is is the standard rt format,
> > a xfs_rtbuf_blkinfo followed by the real payload, which is an array
> > of checksums.
> 
> Yes, the buffer payload is new, and it uses a new BLF flag that
> indicates it contains regions with some new on-disk format. And
> there are interactions with fsync and data integrity requirements.
> Document them!

No, as explained before and clearly visible even from the full diff
it does not use any new BLF flag.   See why this discussion is so
hard?

> Documenting the design helps -everyone-, not just now, but well into
> the future as well.

And I've not disagree with this.  But next time you think you need one
just request it, and don't generate pages full of rambling and incorrect
text.

