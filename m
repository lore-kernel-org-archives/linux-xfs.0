Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3337743FD13;
	Tue, 28 Jul 2026 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785260815; cv=none; b=oUbPO7S+7699yG8hZcvEgkvZrlHvBXXa9+yMoAk7YKJe2gTwODLcS0C/+PFL4G8gwgY4FIQWJgYFUZEv/yfFmgsYcW9w+o9gV/He4atYrGn9xbKqjddeNYieopYNkDOnA8MDUixfQ9RO1fPCQTYtynBBVNqqrMvOLR6Omn38RbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785260815; c=relaxed/simple;
	bh=O17mbSenAam+qxIfLh78tI9qukVXeK5o2tFzetI/xuU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQgomdekDArv4yWhUB2sUGn13bQgyTVV8i3sghLLmwmcs8x7kfygB7f2rIRrAPUpkgUDLwuxeoyR9CJPMqVY+nQ1yWP7jnhtqafszcRANT4BTFNFJU9XywmExZrZ583wQb2Y0KYUsHpH/63TAWnIFvNJLNi2vKupC9I0blyBmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LM7kNpF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LM7kNpF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58771F000E9;
	Tue, 28 Jul 2026 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785260814;
	bh=7EwoGWAQrBPJ/Slm4i6l/k4PD+Xmbo/spvYfnxe85CA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LM7kNpF1aiJjUc2MEFzkNehj2P1VTODvdDWXnE2tNQv+OCWyYQTbfRcHAWoEg2zNz
	 55euFZnSz94QWWyoAxrcEB7DvOFVjncmxiosh1zQohOOQCfJYJA2tFhsYEr2ptCSw6
	 AJXtHJvVv5zoX4Xh816ofGpKRjbXMKjePh7z5db0InB5nYLiGdU3qb1GjZBUBbjT6A
	 V6IcTTcbPiJMMPQl58Sy3x1NnYF9jTJ2zMe73ynJi1bzZ1gl1V/u9BuyCOGZTsnLro
	 qBZxbBHG+Uw/zaEEVoDTnAocXyp3yQrNi00yUrx/X/LeFfJlGwikC+0H1mtDSVvX17
	 SDaSOLb/1mRvA==
Date: Tue, 28 Jul 2026 10:46:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Carlos
 Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Joanne
 Koong <joannelkoong@gmail.com>, changfengnan@bytedance.com, Christian
 Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 workflows@vger.kernel.org
Subject: Re: selective Sashiko replies, was: Re: [PATCH 2/3] iomap: decouple
 simple direct I/O reads from iomap_dio_rw
Message-ID: <20260728104652.719d23d0@kernel.org>
In-Reply-To: <87h5ljf2h2.fsf@trenco.lwn.net>
References: <20260722124931.3159664-1-hch@lst.de>
	<20260722124931.3159664-3-hch@lst.de>
	<CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
	<20260723045347.GA6641@lst.de>
	<20260723151021.GC7380@frogsfrogsfrogs>
	<amI3Kf3lFz4FMqXh@mit.edu>
	<amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
	<20260728040120.GA19400@lst.de>
	<20260728072756.7ddc9fdd@kernel.org>
	<ami9NUgcJvr0zHuk@mit.edu>
	<87h5ljf2h2.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2026 11:28:25 -0600 Jonathan Corbet wrote:
> > On Tue, Jul 28, 2026 at 07:27:56AM -0500, Jakub Kicinski wrote:  
> >> 
> >> +1, maybe perhaps someone wants the off-list option, dunno. 
> >> But trimming the CC list of the on-list reply is a really weird idea.
> >> Submissions often CC multiple vger lists, and the bot only replies to one.  
> >
> > It's not (necessarily) "just one" mailing list.
> >
> > For better or for worse, there are people who have claimed that being
> > exposed to LLM reviews would "deman their humanity".  
> 
> Can I offer a slightly different perspective here?  I am not one of the
> people who has said such things about LLM reviews, but I perhaps
> understand at least part of where they are coming from.  It's not "being
> exposed" to reviews that is demeaning, it is being forced to justify
> one's work to a machine.

FWIW I think that's an entirely reasonable concern, and some people do
indeed get irritated having to fight the AI slop reviews.

I thought the complaint was about the cases where the author is notified
about the review, and so is at least one ML. But the CC list is cut
down, so that a human reviewer doesn't see the AI output. They find 
the same issue as the AI. And then the author responds with "AI already
told me: $lore-link". Which is really maximizing everyone's misery.
