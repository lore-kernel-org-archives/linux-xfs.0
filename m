Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DB51547D5
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736919488; cv=none; b=u051r1eDnzHF401QdOJfzx6YUguvQtcued+lcbgRByImoBHG80RiPpzSOYUAWrB6++ymf8sxj370gyMcieCTt/k1uxq3AAKXONgF5IqXJyFQdY0FfNBRdl3i8I7zsI09rO9UdQqqWAN4ZZZdEnoaUqax26WvCWPflHTCr0nuPtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736919488; c=relaxed/simple;
	bh=zc+mp8kpX/kM7dA8ZaS4GbC5qlKutnZ5DeATLUd4nGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQjtQ8iHeoHceX9kqg9L3eHt0ytsBsnJNIBkwvE4LSEEB6yne9DUMBkOiRWHI93StC/73BEeoOsNu1kXK+ZJtDI494GcmVKy7SM0kqiqD4k9Jcp0ZebF7ILHnToICb4EQEiaqCMc9ZaZ5eipEzt5sDW2tTJIyEBW3OLFz8O5BkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C205D68B05; Wed, 15 Jan 2025 06:38:01 +0100 (CET)
Date: Wed, 15 Jan 2025 06:38:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix buffer lookup vs release race
Message-ID: <20250115053800.GA28704@lst.de>
References: <20250113042542.2051287-1-hch@lst.de> <20250113042542.2051287-3-hch@lst.de> <Z4V9wg8dbLXvq8hy@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4V9wg8dbLXvq8hy@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 07:55:30AM +1100, Dave Chinner wrote:
> The idea behind the initial cacheline layout is that it should stay
> read-only as much as possible so that cache lookups can walk the
> buffer without causing shared/exclusive cacheline contention with
> existing buffer users.
> 
> This was really important back in the days when the cache used a
> rb-tree (i.e. the rbnode pointers dominated lookup profiles), and
> it's still likely important with the rhashtable on large caches.
> 
> i.e. Putting a spinlock in that first cache line will result in
> lookups and shrinker walks having cacheline contention as the
> shrinker needs exclusive access for the spin lock, whilst the lookup
> walk needs shared access for the b_rhash_head, b_rhash_key and
> b_length fields in _xfs_buf_obj_cmp() for lookless lookup
> concurrency.

Hmm, this contradict the comment on top of xfs_buf, which explicitly
wants the lock and count in the semaphore to stay in the first cache
line.  These, similar to the count that already is in the cacheline
and the newly moved lock (which would still keep the semaphore partial
layout) are modified for the uncontended lookup there.  Note that
since the comment was written b_sema actually moved entirely into
the first cache line, and this patch keeps it there, nicely aligning
b_lru_ref on my x86_64 no-debug config.

Now I'm usually pretty bad about these cacheline micro-optimizations
and I'm talking to the person who wrote that comment here, so that
rationale might not make sense, but then the comment doesn't either.

I'm kinda tempted to just stick to the rationale there for now and then
let someone smarter than me optimize the layout for the new world order.
