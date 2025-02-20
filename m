Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B079E130E58
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 06:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740032179; cv=none; b=eZZknBx2iKrABba1Wdx3JF9DTcZumBtWcj1EqdfegqAzbQmmTWh3nYVlAlmBMVJDNXMThJOAFD1kME0kATyaIFFfb/6rXL7F4l9Fsk3fiaYCQsCFLq491+t3gpz3gtkNseRBoDZWg3admlRVzcLjigcTeWIsXbonKrVAvAWnrto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740032179; c=relaxed/simple;
	bh=yn5fRav3YZ+N5GovL8Exq1okigKukQXwXi6bPKBJjZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHpc5z+MCVsKjEJfKnuI7beyYdNEL2+1iKMEiQqrprCAFbvePJa5sOCwxwrQs49kQU5a6w3wMeqh+Gf3GLQ+DLJN+zp7qdqmyiBAf7qaRvkalkn4luJkv6dfjrStk3BGnRBQgzCQNUrafOT1noCMCgeLnWkBB0Lj8muxpIvwGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D726368CFE; Thu, 20 Feb 2025 07:16:05 +0100 (CET)
Date: Thu, 20 Feb 2025 07:16:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs: implement buffered writes to zoned RT
 devices
Message-ID: <20250220061604.GA28550@lst.de>
References: <20250218081153.3889537-1-hch@lst.de> <20250218081153.3889537-28-hch@lst.de> <20250219214727.GV21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219214727.GV21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 19, 2025 at 01:47:27PM -0800, Darrick J. Wong wrote:
> I don't want to go adding opencoded logic loops all over the place, that
> would be pretty horrid.  But what if xfs_zone_alloc_ctx were instead a
> general freecounter reservation context?  Then we could hide all this
> "try to reserve space, push a garbage collector once if we can't, and
> try again once" logic into an xfs_reserve_space() function, and pass
> that reservation through the iomap functions to ->iomap_begin.
> 
> But a subtlety here is that the code under iomap_file_buffered_write
> might not actually need to create any delalloc reservations, in which
> case a worst case reservation could fail with ENOSPC even though we
> don't actually need to allocate a single byte.

I think the idea of per-reserving space before starting transactions
is generally a good idea, and I'd be happy to look into reworking the
conventional code towards that.  But I'd rather not do that as part
of this series if I can avoid it.

> Having said that, this is like the 5th time I've read through this patch
> and I don't see anything obviously wrong now, so my last question is:
> Zoned files cannot have preallocations so that's why we don't do this
> for FALLOC_FL_ALLOCATE_RANGE, right?

Exactly.  Should I add this to the commit log?  It's mentioned mostly
in the cover letter at the moment.

