Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817BA3EEAEB;
	Fri, 12 Jun 2026 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781270624; cv=none; b=jutnBgo/nzxodid9PQFw2mCnR1XPHL9047cuunvbqSBPGXJvIT2QOJs7J2xn0acbKS0I2Rf381Itj5MpBXqq81nZtUXSHlgir8mgz1s34S9wAVFeFGTtd1tUE6C0yZSfWVHXapBh7gApkmtqzra8YtvsJUnMAG/ex0WviRbp+Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781270624; c=relaxed/simple;
	bh=BxRUG9yCparzdVEFNUqMGYsgRIhB/MMDsOFELKdEY5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZikm1nv8bNMJ1UKwvxm9ZLlyK1KmFbnp6/YSehDqLJSmUaKj627Ory8wy+qhHkGkMTGi3a/q7M2wh3FFseW3MIalCAu+5eapIW65Ew1yUmgiG21zW8CefcJvKhedfKjhb9ETrDzs6DikD1EUEd6Dk5ighRU5l4KS6FDbRDSt1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWBSe3uU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWBSe3uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7DF1F000E9;
	Fri, 12 Jun 2026 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781270623;
	bh=Q1S8kYZanYqjeMjwN9+vX2OdI/tveSbKG5tSQXbtX3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RWBSe3uUTYDEnYDY6VMRpKsIV02r4tVXyXvdQlFjfnzn2UZTmpMziQyG/Pf6zr8ah
	 G9EK21TGC1CPNPWAVv4S/PjOW6cyznrGCkrEMHbkPj26M7o04lYHhCYqOUX38yODmN
	 gLIzuJwOANFr7dXKxhxOtFHhisXef9a1n64ltmdhTEENzR9anDF97YsHliSJttEVra
	 z5yo9FY0AKI4EjWa/ZU+CwPDqw0VGZRwW1+g6/dflG3ktYyUyOVkBq9ZICYRGI8e6U
	 ma1bchx6cRYkbEk9O2C8CHiDWhsPO15n7Y6mhbqflH0jh+OaU43rcDv8jD+gNrzRXo
	 v+hdrpt8CzEWw==
Date: Fri, 12 Jun 2026 15:23:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, brauner@kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <aiwIGv4xWH-bfDfT@nidhogg.toxiclabs.cc>
References: <20260610145218.141369-1-cem@kernel.org>
 <20260611055744.GA18538@lst.de>
 <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc>
 <aiqwy5DfHI79KXuZ@kbusch-mbp>
 <20260611133833.GA14645@lst.de>
 <airX6BmMQ14Rvjcb@nidhogg.toxiclabs.cc>
 <20260612052831.GA9010@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612052831.GA9010@lst.de>

On Fri, Jun 12, 2026 at 07:28:31AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 11, 2026 at 05:47:07PM +0200, Carlos Maiolino wrote:
> > On Thu, Jun 11, 2026 at 03:38:33PM +0200, Christoph Hellwig wrote:
> > > On Thu, Jun 11, 2026 at 06:57:47AM -0600, Keith Busch wrote:
> > > > It's entirely possible a device supports byte aligned addresses. The
> > > > block layer just doesn't let a driver report that. So either it really
> > > > was successful because you found a bug that skips the alignment checks,
> > > > or your device silently corrupted your payload.
> > 
> > I tried this on different hardware, I find it hard to say all those
> > devices were corrupting the payload.
> 
> I think in the other thread we agreed that we are currently missing
> the alignment check for fast-path bios not hitting the splitting code,
> so maybe that is something you see.  Additionally we're missing the
> checks for purely bio based drivers not calling the splitting helper
> at all, but I don't think that applies here.
> 
> > > > Anyway, my earlier suggestion should work. Ming thinks it may go to far,
> > > > though, in not taking the optimization when it was possible. So here's
> > > > an alternative suggestion that should get things working as expected:
> > > 
> > > The fix below looks like it is addressing a real bug.  I'm not sure if
> > > Carlos is hitting it, but we were missing the alignment checks for
> > > single-bvec fast path bios so far indeed.
> > 
> > You left context out so I'm assuming by the fix you meant Keith's patch.
> 
> Yes.

The fix indeed seems to fix the behavior I'm seeing. Keith could you Cc
me if you end up sending an official version?
