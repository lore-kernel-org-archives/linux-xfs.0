Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FFB54705C
	for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2026 07:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791702583; cv=none; b=kSQneEJeQB6gtbhT6I7vL0rGHLPsLXWY2VNpcZOHUXGX7p9g6Xi1KkElR+RG9hLiVw8xph247kDNsgX3BHp/G7yJwHDsoCR7KSJXlw+y3hexx26hpf9xrmVtOQ9ZaBmYNxxB2K2flMkWmLkWA+wuJGYEGnW8C/WhMwCwpja0iVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791702583; c=relaxed/simple;
	bh=q5da4aGeaoWB6jxMq1r9rrKJfudeiXLUYo0GlWygxTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvT9WUcs12Jid9Q6C/2lFmugMDPNP2f0rv3A0YqajPYvV1gwZpSnQTCzJ1gn9KMgdApIc/ThLVIlxiZmlykOIecjYlsTeIFvbQqIZVLRpRE2z307Ic1mqmRUnWvj/pIvx2d843SF46c73Vd7syvj7Es3ecPmTlTNq1vHzRKiI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jm1rDuZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jm1rDuZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAB91F0089B;
	Sun, 11 Oct 2026 07:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791702582;
	bh=pGc0TCl5Q4N8L/qpvL4UR+CKheDsLMCcmkHIeTyy4HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jm1rDuZsMEZBE1b+U2BNm1DO/nRgnBXXBzpgNywenTpETy1q98jEsstIwfQweufUg
	 gbyzwj+rfsM6flZeDZVzRb27tAy60IULSO/heoD0TRKUwnSG9BNAi4hwdlqgLBt/DH
	 XSwXdse23QqOEHws/jjwoi65J16uDhojKSU4btzLNBHaOYPxTj18lEPk9aCcSkgE0j
	 JP4nCWufzKq3jENh1ct32byPaOSJ6PpuQ3MZtvI9yS8m589XzJkclZQMBydHw4SCQK
	 S22jMKlW4p4sC3BrKHqK7AILPmtw6+qa+bPsp9Qvei1cD84OaUm9rIBCdyEd++fCiN
	 y9Q4W+SS5ZJ+Q==
Date: Sun, 11 Oct 2026 09:09:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: "djwong@kernel.org" <djwong@kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Message-ID: <ass13wWEOO9woOOw@cronus.toxiclabs.cc>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
 <20261006144851.GX2705364@frogsfrogsfrogs>
 <asd7554UisFwlOsc@cronus.toxiclabs.cc>
 <e042c937a34eb92afdc0208a2f6571076f096ba6.camel@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e042c937a34eb92afdc0208a2f6571076f096ba6.camel@wdc.com>

On Sun, Oct 11, 2026 at 01:32:58AM +0000, Wilfred Mallawa wrote:
> [snip]
> 
> > > 
> > > The original patch is more appropriate IMO but seeing as we're
> > > about to
> > > return from main and terminate the process, why do we care?  And if
> > > we
> > > do, shouldn't mkfs also free the other getstr() strings attached to
> > > the
> > > cli struct?  And shouldn't the exit(1) paths do likewise?
> > > 
> > > (To be clear, my answers are "I don't", "no", and "no" but I could
> > > be
> > > convinced.)
> > 
> > Leaving them as-is is fine for now, might not be fine in the future,
> > I'd
> > say if we are leaking them, we should fix it, even if it's falling to
> > the end of the program.
> > 
> 
> Just to clarify, should I can spin up a V2 that frees all of the
> getstr() allocations in xfs_mkfs? or shall we drop this for now?

I'm happy getting rid of leaks even if they are just before we exit().
Final decision is from the maintainer thought. Andrey has been OOO past
few days, so perhaps wait for him to come back and decide?!

Cheers.
