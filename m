Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106B42FD7D3;
	Sun, 27 Sep 2026 11:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790506987; cv=none; b=DjjRfbpPN/U4py31CnpK6dojnw3fodw7E6hE8YCfTpkxB4hT8LcYy02jElTuJghv6od2iOWsKg4/IpJ6/3weWlsILrg17R7YBoK7d5GB6h2ylBmtGWASXVXcao7D2zXOaM4Uiz5ymkoTRN0pgd8A0d82zssk8nR5E4Im+0KX82Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790506987; c=relaxed/simple;
	bh=yR6n1rtmCVsNSEYovvqX/gTKIPaDXMTzJlWwWAhQ48E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFoPabI+PUH1wAw82oJV3rns6GPsaV0j1zHjPuzHW+a54S/7WfSBsODrAnKdWDT4XZyR59zme7y2gZMZnO08JwngbhFt4M9s7cSicetccptDOgzHHb37jbxkcMEjxGNRzeap1jTCBTqr+Om2tqc1hkmR0lnRfuNUpCcMCfJHlug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9o64bRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9o64bRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428E81F000FF;
	Sun, 27 Sep 2026 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790506985;
	bh=amqyLQk1B1QGBvWptDjINWsc/NXTL74WFOVLzATlfCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h9o64bRlO5nmiS0e5xu1xEpV2hVy7usOHWe2OT12Fdn6o9VNvfajlqxW78k1u4lkZ
	 w/R17cs2+DW7wOLxIlotLlR3TrlIclLT0kEFT9oCmVpoEPafYLle2vSjrkG3DRm0cK
	 D8/6ibWPILdVNI18UrB//lmaPYN7ygYZpT/MHODXVtovWcqrDpHqBCH8ewlWhyWRyq
	 ROBQ0YQX9fFQ8M0HGGN/BckTaRbqPZIpLNcGOZ8s47/nTbhlCAbpG2k34w1910Gj3o
	 y/F767uLt9UPhqXERJsbDKy1SsgxYf0V8NGuw5z1yTDnD2jik+7oUL7xf5ijhtscnp
	 WM81G0XHIpHIw==
Date: Sun, 27 Sep 2026 13:03:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Steve Shoecraft <spshoecraft@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
Message-ID: <arj3Mp6Cq2_qwaIb@cronus.toxiclabs.cc>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
 <ardhDI-Ko7b5RccH@infradead.org>
 <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>

On Sat, Sep 26, 2026 at 07:32:27AM -0500, Steve Shoecraft wrote:
> 
> Good catch on the magic - I had it changed in previous attempts and forgot on this one - release 0.90.0 has MXFS unique magic.
> 
> I’ve been writing device drivers since the 90s on FreeBSD.  This was a research project to see if an LLM could do it with the right harness.
> 
> Release conditions of course included 100% data integrity and 100% stability.   XFS was the right choice for the base.
> 
> Intent is a good clustered FS for Proxmox to compete with vSphere and VMFS.  Yes, I’m aware of the differences in implementations.

If you are not even bothering reviewing your own project source code as
you stated, don't expect anybody else to spend their time or have
interest on it.


> 
> 
> > On Sep 26, 2026, at 1:07 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > I don't think too many people are going to care about your LLM dump,
> > or even review it.  But please make sure you use different magic numbers
> > so that a mxfs image left in the wild is not mistaken for an xfs one.
