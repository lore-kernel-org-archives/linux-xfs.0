Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6622F3DDB1F
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 11:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458135; cv=none; b=JBXOyxrigyYG8IsMFc2PR2DCEuVKewNbdOYc1TdkUHnxKDJRotalRH52ejxoZMSbn8QaPmhZH+F87fou1wwPv9gP8foTpvKFND6KOU2o8gR+pqBUa2xXsQ88INfrVSho+Ekq4plFtIyKApLYQD5KNYeWoG83QRHMvHpvSXxeiSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458135; c=relaxed/simple;
	bh=Go+B0QmUwhTJRQlabgZaFWlugQsSDZ/7yDaeWgTKOQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9tNUbRTUptWAkmXgEjeXn6+mh3866nuGYXQdMrLvnk2ZqVbAzxX+0nfqD+/FX6EwDTFryQONS3opNTTTL5cyaj7uG7ZZriZDNXIivLW0nLENV79EMev+Q/Kb63Z1MYflaeSYJyMNjuYNUXubW/SPS9XEY+1ZTlFJ0OO9UkqWuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITNrDvMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITNrDvMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8661F000FF;
	Thu,  8 Oct 2026 11:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791458134;
	bh=ldG/q9sVg0cwYSOaO45e2EEVbunEgQyZW1s4PyS7Ed4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ITNrDvMJjEaeonu5TX42IX1oWUoBJzcbmOl/3t0aipxLonQjjAjVzwEQtSx2GrViM
	 Rw2jXdhs7TbTkhQ4BnCGu/9b/WlarfzFWiozfJnbvz//9+zCM2X0M4gQ7R+EHQhGzn
	 Q8VfM+utdJH/S7KVBCYfiFLyxpH726d7mzifzQXGP9/Z7SZ/HfFW05me0MYLD4TNVg
	 jBHj7a9lM23jI/ED25vWrdfpSPLLMN8XRVKnWmwN9Lz1XE+wQ30HHbGGAQKzwQqDA0
	 yxqiHtWDLOu8PxrL6ZAIfnfK7KedL33kXS4uKvoIiaO37qNYSov2qP53HV84Rh3Cjk
	 WbXsoB0vqB1Dg==
Date: Thu, 8 Oct 2026 13:15:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, 
	Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: re-use refcount scrub/repair code for rtrefcount
Message-ID: <asd6ChmrXw4UWku6@cronus.toxiclabs.cc>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-4-sandeen@redhat.com>
 <asZOVQfQU3TpEBgv@infradead.org>
 <7206d033-2082-4591-81e7-43a5c5bd631a@sandeen.net>
 <20261007153757.GC2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007153757.GC2705364@frogsfrogsfrogs>

On Wed, Oct 07, 2026 at 08:37:57AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 07, 2026 at 10:32:20AM -0500, Eric Sandeen wrote:
> > On 10/7/26 8:51 AM, Christoph Hellwig wrote:
> > > On Fri, Oct 02, 2026 at 04:08:11PM -0500, Eric Sandeen wrote:
> > >> Some code in scrub/rtrefcount.c is copied from scrub/refcount.c; it
> > >> differs only in function & structure names and a couple types and
> > >> macros, which share the same underlying types and values.
> > >>
> > >> Similarly for code in fs/xfs/scrub/[rt]refcount_repair.c
> > >>
> > >> Export the refcount versions, use them for rtrefcount scrubbing,
> > > 
> > > Not really an export fortunately :)
> > 
> > Oh, uh, yeah. I didn't mean like EXPORT_SYMBOL just un-STATIC. :( 
> > 
> > Maybe Carlos fix it to:
> > 
> > Make the refcount versions non-static and use them for rtrefcount scrubbing.

yup, no big deal.

> > 
> > on commit, or I can send another version if needed.
> 
> s/Export/Share/ ?

I went Eric's way, at least looked better for my taste. If you have
any objections, let me know.

> 
> --D
> 
> > > 
> > >> eliminate the copies, and add build-time asserts so that the type/value
> > >> matches mentioned above do not drift.
> > > 
> > >>  5 files changed, 72 insertions(+), 316 deletions(-)
> > > 
> > > Nice code savings!
> > > 
> > > Looks good modulo the commit log nitpick:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > 
> > Thanks,
> > -Eric
> > 
> 
