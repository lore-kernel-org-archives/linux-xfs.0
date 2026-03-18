Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6E3E0C4B
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773845390; cv=none; b=P7EEkuesTexs98hSdLmnY/YC1tRU3F/C5tU9vVujQH0eI6aXZ8sNHALal7YImbbRDm5K+tT/kXuRhsqHr+jsdDjZ4bkBo3g6eNzqmxdj4VhlgybpCNH0fAF28vrafpIgL01I/dxjY6hdZueZxRDEp5WVq6GalCY3wXnLpFh+Nys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773845390; c=relaxed/simple;
	bh=1JctO8e1U7viKi5OgPs07AJ5lU5eyOV63/b0M4XIaYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rHkiV3WqB0S53k4YD8MMfutdRteclrwNtCP/xHh9dBlLjZxxsTdejWtHBnqjOeX/13DfvmZq2IDyOHO3eHNeAYjp2cYiX1fuUAofSCxCh3QGQ9BSlXbN8w+mszi9Wd9LRoTtgvfUXXDKqSHRzsEYReF8li1VQKxkHde7NM+cPqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B3E968C4E; Wed, 18 Mar 2026 15:49:45 +0100 (CET)
Date: Wed, 18 Mar 2026 15:49:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/4] xfs: use a lockref for the buffer reference count
Message-ID: <20260318144945.GB21119@lst.de>
References: <20260317134110.1691097-1-hch@lst.de> <20260317134110.1691097-3-hch@lst.de> <abnNSZy-N8ITNKul@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abnNSZy-N8ITNKul@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 18, 2026 at 08:53:13AM +1100, Dave Chinner wrote:
> > -	spin_lock(&bp->b_lock);
> > -	bp->b_hold++;
> > -	spin_unlock(&bp->b_lock);
> > +	lockref_get(&bp->b_lockref);
> >  }
> 
> Can we make xfs_buf_hold a static inline in xfs_buf.h now? It is
> called quite frequently and it's now just a one line wrapper
> around the lockref code...

Well, that plus the trace point.  For which we'd need to pull in
xfs_trace.h into xfs_buf.h, which I've been trying to avoid.

> 
> > @@ -1564,10 +1547,10 @@ xfs_buftarg_isolate(
> >  	struct list_head	*dispose = arg;
> >  
> >  	/*
> > -	 * We are inverting the lru lock vs bp->b_lock order here, so use a
> > -	 * trylock. If we fail to get the lock, just skip the buffer.
> > +	 * We are inverting the lru lock vs bp->b_lockref.lock order here, so
> > +	 * use a trylock. If we fail to get the lock, just skip the buffer.
> >  	 */
> > -	if (!spin_trylock(&bp->b_lock))
> > +	if (!spin_trylock(&bp->b_lockref.lock))
> >  		return LRU_SKIP;
> >  
> >  	/*
> 
> You modify this comment and whitespace in the previous patch without
> any code change, and then do it again in this patch with a code
> change. Can you collapse that just into a single change in this
> patch with the code change?

Sure, done.

> >  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
> >  	int			b_length;	/* size of buffer in BBs */
> > -	int			b_hold;		/* reference count */
> > +	struct lockref		b_lockref;	/* refcount + lock */
> >  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
> 
> IIUC, this adds a 4 byte hole to the structure - b_lockref is an aligned
> u64...

Yes.

> The first cacheline of the xfs_buf is explicitly packed
> packed with the fields that a hash lookup needs to
> minimise cacheline misses during lookup, so we really don't want to
> screw that up by wasting space in the first cacheline.
> 
> Indeed, seeing as we've simplified the structure of the cache index
> over time and are moving back to a global cache index, we probably
> need to take another look at exactly where the cacheline boundary
> sits and exactly what the lockless lookup fast path accesses. i.e.
> make sure that lookups only access the first cacheline, and there is
> nothing on that first cacheline that any other concurrent buffer
> access might contend on (e.g. lru list scanning, wait queues, pure
> read-only accesses, etc.)

With this change, the first 64-byte cache line ends after b_flags.
So even as-is it avoid having b_sema spread cache lines (all according
to b_sema).  So for now I'd like to avoid reordering things in this
series, even if I agree with the sentiment that a good analysis
here might be in order.  Maybe wait until willy's series to shrink
the semaphore lands, which will changes thing a bit again.

