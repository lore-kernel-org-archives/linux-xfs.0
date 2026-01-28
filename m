Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4E2DB785
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769579588; cv=none; b=cy1EM31487Rpa5k2kzQ10/ApGmKmEiFA7mOMP/Dkj9uPSK032zJf2W3dtz60keY9WwXiiRpaz3n1yK993EtxU8XxlUa+8+2QlOxNk626J9apXtiW5Gc6Zg+KyQ1RYFk8hwW710H71XHA7OpGwMBiD+DnbjbcceZ4uGpcKUKFnmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769579588; c=relaxed/simple;
	bh=AkZUEFS052jqWmnwTqWLhOrVfgKNE+tCEqzGrfyfqhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdUGfQaVwsJ7AuzopVdmum1bKfNkgy7U0pTtQzkzX791ZhTL+uc7ZG7QiWTGpTgeSR0ViP5DbkukZi8pdLvayy5tPhRWju1Zb2B112YrORX4bikLIOCYzt03LJsRztDgiCT9pUt9XZb++sCKEJwXKDXq0i/DMhfsWsaEJIhdmHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BC8F06732A; Wed, 28 Jan 2026 06:52:57 +0100 (CET)
Date: Wed, 28 Jan 2026 06:52:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, Chris Mason <clm@meta.com>,
	Keith Busch <kbusch@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe
 in the GC scatch buffer
Message-ID: <20260128055257.GA1835@lst.de>
References: <20260127151026.299341-1-hch@lst.de> <20260127151026.299341-2-hch@lst.de> <20260128053511.GR5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128053511.GR5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 09:35:11PM -0800, Darrick J. Wong wrote:
> > +	unsigned int			scratch_available;
> >  	unsigned int			scratch_head;
> >  	unsigned int			scratch_tail;
> 
> Hrm.  I did some digging (because clearly I'm not that good at
> ringbuffer) and came up with this gem from akpm:
> 
> "A circular buffer implementation needs only head and tail indices.
> `size' above appears to be redundant.
> 
> "Implementation-wise, the head and tail indices should *not* be
> constrained to be less than the size of the buffer. They should be
> allowed to wrap all the way back to zero. This allows you to distinguish
> between the completely-empty and completely-full states while using 100%
> of the storage."
> 
> https://lkml.iu.edu/hypermail/linux/kernel/0409.1/2709.html
> 
> Can that apply here?

It could, see the version Keith posted.  But this one is actually
slightly simpler, while the unsigned overlflow version requires saves 4
bytes of memory per file system (+/- 4 bytes of padding for either
version which I haven't checked) and a single add and sub instruction
each for every GC operation.

My preference is this simpler version, but the other one should work
just fine as well.

