Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C0B2ED17C
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755773998; cv=none; b=mD53fcoxkOSg7FlZS7PFLvpLJ4gb1BExKWV3ObgEcgErOHyKUmAq3p7rieaiJ2E5ejBnZZjqMGW6Y28WjJrESWf5QmqhPzcySG2IBaN46pd3n2o+ZpGa0v3DCRpIWwDsMiYvxPM3CRYWRoSeAqd+J707OwPCssV7NFGLVdESyWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755773998; c=relaxed/simple;
	bh=GJ3uPF2uNEQcOaTWzSO3RE3IsvLDy0hhVhP8nmKP0os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muBBJ+z1AEB/Oxp+C/D7G8GEEf+Ru20plTYRc8bhUW4Yuxvhy7X522o3az9tJBVOMVzmQfmjnHnsZoPRaLvcTSN4vzNLfCf6F0yDA1fifNnXeuhouJ7yf4L6IgTm3QtfDQjENGTYepJ7AAKoNhE0JPsNo5Qj/1AB04VFRle+fRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMJNpNVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMJNpNVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF77C4CEEB;
	Thu, 21 Aug 2025 10:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755773997;
	bh=GJ3uPF2uNEQcOaTWzSO3RE3IsvLDy0hhVhP8nmKP0os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VMJNpNVo7/xcsnMtDJs6HaIoJaVrwiAKls6MDzbIASG3B1mgPcgCcwcPQBTKJS9PR
	 6r34dtTSRpZFoNjhQ+BGUjW4qSPOfxvvgssU8+5kJ13LU5WvxGOjaqbAWC18stOoKD
	 ZIk3hQ7X+YGmC6jPLSpox8jlDFHzVEE4sDauA1FKtXwWpgIO0XnzCgYKhhyvbQmRqa
	 XjYYR6htoXVlCWKTUQwmQHVwNEMhefnt53/Vta2Gnec5RFNoRPrCQJ5CEiyUHN8wT2
	 VwR+ceKPusi5qgSlESiX3msVyhmg3LOp6Y5vZ5O8EGqdW1rEDman89yrtJxOES20Y4
	 xBYYGEUSXMQ5g==
Date: Thu, 21 Aug 2025 12:59:54 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <qmwujttlrrwb6cbeifjbuahuw2ltujx4k5d7xlkaeds76v7d4e@7hnzg2kzhykl>
References: <9aG8Tf3X2d-4A9_uy7q50gPfuQH-xjOf3Bdbw4mJ5ITHbBXXDwYG2uqAYoSKE-pRy5iYgqRbd79paOGW-Sk_SA==@protonmail.internalid>
 <20250818051348.1486572-1-hch@lst.de>
 <bcwk3ezkikdmkgisfhukyxk3ojtkmbeonnepaxt3pmzof662b6@iddfobua7bme>
 <F_PoQgaWY6li_3B25eViM2xapPKR5U-P4BdzFW-krgO7YwRyn0g4hcXn2bF0TKqnoYJuMW2NrzQQH7oZUb4_CQ==@protonmail.internalid>
 <20250821084037.GA29746@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821084037.GA29746@lst.de>

On Thu, Aug 21, 2025 at 10:40:37AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 20, 2025 at 10:23:27AM +0200, Carlos Maiolino wrote:
> > Do we need to keep this comment that tied to an userspace tool?
> 
> It think it is a pretty good reminder why it is here.

Fair enough. I'm not opposing to it, just looks weird to me.

> 
> > The issue with randholes is that it uses posix_memalign, and the pointer
> > size constraint comes from that.
> >
> > I couldn't find any details on why this is required, but I'm assuming
> > it's to keep posix_memalign architecture/implementation independent?!
> >
> > So, perhaps instead of being 'randholes' specific, it should specify to
> > be posix compliant or because posix requires this way?
> 
> Posix does not require the alignment to be larger than void *.

Sorry, I'm not sure if I got what you mean here, perhaps I phrased it
wrong, but I didn't mean to infer posix requires an alignment larger
than void*, but that posix_memalign requires the 'alignment' to be a
multiple of sizeof(void*). Although the smallest alignment, well, would
be sizeof(void*) per se.

FWIW, I'm not questioning your patch anymore, I'm just curious about
these posix constraints.

> Applications that directly feed the value to posix_memalign do.
> And maybe that what could go into the comment.

yeah, that would be nice to have.

Cheers.
