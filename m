Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD633A9639
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 08:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782461501; cv=none; b=PsvCFKwABe7pmVgZSipol/Kv//TYhIfRaRnBs3GD8l+bMbnyCDIdKCBEEzask0AhIe3bCSuxreLT3Kq+Uk/9vxGPjJT7LGAI18Cep4IA0OCJWKYbFPG6DN3PZLw+A6gZZ7jdVa6F8RvzSct8uM8yDKt7v99GWBicc0rJ3IO/hiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782461501; c=relaxed/simple;
	bh=XhQn9gL39IP50OZNY2ApdCIaX6nASLW9nMHRkySValE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYeFM0LWj6jBcqUMbdoWBCpyJEUs3eHjjhpUdAklkcMDzBRPDwSFm390Xeel+4EN1sxU72wD7zyA+qHvQraQW4T7CXnVMGWfF6YKQjuESnoo+UGyLMhzPGU1dCKPJCmq9d+Pz2S0ORBKPM63G+w7tFu4VpiECQmE7+lFRXhRjzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LynrcuNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LynrcuNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580141F000E9;
	Fri, 26 Jun 2026 08:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782461499;
	bh=nhIQ5FdvQQ/YesBo4sS4RkFRjXs3HmT3eZplSzHHzW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LynrcuNwvS2lmUoP5yaunGlWEKjx5YSadZp/s0nUhK8OrPLBytTeHUsEph2dprxPP
	 HBEWwsFlLi70jWJovk6fXaHmdkLeiJqszdRwehMhHHdN60PcRQYDTMZJCAD0eCEEc3
	 wnUBph+UY9zzT8QL9WmfqCZNIxk6WoPeLh4DZ0+nVSyV8Z+0XqMS16vNxHv2b3sHF6
	 lIe+SawVka+H1m5bq9hgrfNaeY6UhVL2+DDL7OLWEVyrCmUSz06cBi5LA17GzN43JY
	 5WpvJvwp0oVQnR8498OmUwLyB50LPLCZpT6vqIX0dxt8aE4huLp54R6dLC7LrdNRyu
	 KDcvR5SBE3ZiA==
Date: Fri, 26 Jun 2026 10:11:35 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: vmfunc <celeste@collar.sh>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long
 dirent names
Message-ID: <aj4z3v6RGnSbxlEI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260625222337.54449-1-celeste@collar.sh>
 <20260625225758.GN6078@frogsfrogsfrogs>
 <178243370553.73182.935356806206037088@collar.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178243370553.73182.935356806206037088@collar.sh>

On 2026-06-26 00:28:26, vmfunc wrote:
> On Thu, Jun 25, 2026 at 03:57:58PM -0700, Darrick J. Wong wrote:
> > Why wouldn't you fix the structure definitions to use the proper VLA
> > syntax (dh_name[]) instead of making the code less readable?
> 
> looked at that first but dh_name[] doesnt drop in cleanly here. the
> declared size isnt slack padding, its the count of name bytes carried
> inline in the fixed-size on-media header, n read_dirent() in
> restore/content.c reads the record back out using sizeof() of that member:
> 
> 	namep = dhdrp->dh_name + sizeof(dhdrp->dh_name);
> 	memcpy(dhdrp->dh_name, dhdr_v1.dh_name, sizeof(dhdr_v1.dh_name));
> 
> sizeof() on a flex array member is a constraint violation, so dh_name[]
> wont compile without rewriting that reader. it also breaks
> assert(sizeof(direnthdr_v1_t) == DIRENTHDR_SZ): the v1 header is 16 bytes
> of fields n dh_name[8] is exactly the pad that brings it up to
> DIRENTHDR_SZ (24). as a [] member it goes to 16 n the record size moves
> with it.
> 
> so a proper [] conversion means reworking the v1 on-media reader + the
> record-size invariants, felt out of proportion for fixing the fortify
> abort, so i kept this to the minimal change that preserves the layout n
> the rest of the hardening. happy to do the struct cleanup as a separate
> patch if u'd rather, just flagging its a format change not a pure
> readability one.
> 
> thanks,
> celeste
> 

My thoughts too, seems like easy enough fix to make fortified
version not crash.

-- 
- Andrey
