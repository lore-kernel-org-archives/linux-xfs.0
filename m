Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E30370ACB
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956728; cv=none; b=oVwAXs/25MFex8h6IGpcp0KFLV4OCCv1KLIpoljA+k9bzJ0I1oomFN3wHEm2f8RZiuqmrnjk/ESMuNqJc1QgvtTqW0SNGwBXcsT7k9xiF7NBxLk4BJI6JQM9SPv+oiC6tw6WhPCd0BFzn1d1Hh9NguJgxM9B9tTiO8xQ40eACmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956728; c=relaxed/simple;
	bh=2suLIaAgjJraBIG1iWI6T6zutOO8SWQQkFXyteDmNCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S645VJLpdWldzQX+7UY/s+ZEOcijz7UC1TtaIeEPIkOcVSW17IH2wvMabJK3O8ouBxZGaX9V5/HnncrhYBHmcWzc3BkuuCllR7mZJkwcAZZPMoAhbUmZR8xJ99ImwYGTUiMFAE3F70vjbOLEchANXr9vocmWa8afhC6ZShyYzgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B013B68BEB; Thu, 28 May 2026 10:25:17 +0200 (CEST)
Date: Thu, 28 May 2026 10:25:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: drop the experimental warning for the zoned
 allocator
Message-ID: <20260528082517.GA6620@lst.de>
References: <20260527123941.2319377-1-hch@lst.de> <20260527123941.2319377-4-hch@lst.de> <4038eaae-4551-4a22-8f75-3b4037a6a5af@kernel.org> <ahf6Ahku3KY9W1Gy@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahf6Ahku3KY9W1Gy@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 28, 2026 at 10:20:52AM +0200, Carlos Maiolino wrote:
> > Do we want to compact the numbering and change this to 19 ?
> 
> I'd agree with Christoph and not reuse the warn number but perhaps I'm
> just being overly cautious as we don't have a 'stable' version which
> zoned support would be backported to :P

There's a lot of holes in this number space.  I can send an incremental
patch to compact it.

