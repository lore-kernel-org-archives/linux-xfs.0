Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6891A2BE03C;
	Sun,  6 Sep 2026 23:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788735918; cv=none; b=ERXFQQKbdfh27dd80oc2E3mQ+F7EXA3M6m2K5Rh8XrlqCDB10z5CvWcPy+4/0rLrIQo0WojEHyWCn5Q6oB8wxWsxg8XHbqhSVkfFaoztarAzl3ULrdc//vasG4vH7QYSMBtCbAFjp/yWfP716zd/sO+yaOjm6D/U8rHHLHSn9Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788735918; c=relaxed/simple;
	bh=y9jBvSyYrbjCnWD+ynO0ZAOlYOFyxf/8hw7FIhm2yZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDDHk8yp5cM7gJrt+2XSNeNYpJfg2UPBBivG+bmQntpaQ/W1c0juzq1KtE6qXA0dqcwI6P2Oq13i4gmJTXL1z8kaoJYncQoi6gf3GvMMCwaD4ts7DG88mR3vt76VNZZTDK+/s2+XCIE4Ejmz+dRL3JP0G1lfWXJn36NKLRHlmFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKpgL+U4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKpgL+U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B921F00A3A;
	Sun,  6 Sep 2026 23:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788735917;
	bh=azoo0pX+3AIYzE2g/eGc3kL5OniqDxseTzcbFubdQLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JKpgL+U4xlNFixXBnAA2Wa3j8oJlvb3HTDY/coujxaGy/qHOJQh2CmKsxLkS9wo9R
	 uhwE4PG1QlCwceNT55FSQy3XrsxhCp1+kyeJZ40sqoOVtu8kelfuKIxzgocLIpGdo7
	 G4obCwQW0MzajzT0pPNZk43gdWUI9ECvp46xtGiooOd5DgB14rMVKbof/EtlxOR4P4
	 UBRK8cRL3A3FTO+K4RxYf5s3QzHFH8DelKXPWqtJNo0K59JC5KxUKt3g9niGpQRgqQ
	 KDLCp+FRrJTuMFurhbWUD+CoijRR9YL5pfH5usQ3AMMCWVn/6M4F1L2LfhPisCF3HS
	 FSiyRpjbdZRUQ==
Date: Mon, 7 Sep 2026 09:05:04 +1000
From: Dave Chinner <dgc@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
	hch@infradead.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
	jackmanb@google.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
	ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
	surenb@google.com, vbabka@kernel.org, willy@infradead.org,
	ziy@nvidia.com, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <ap3xoHb-GtxZXkMd@dread>
References: <20260904115629.3993331-1-dipiets@amazon.it>
 <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>

On Sat, Sep 05, 2026 at 05:42:39PM -0700, Andrew Morton wrote:
> On Fri, 4 Sep 2026 11:56:28 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> 
> > Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > introduced high-order folio allocations in the iomap buffered write
> > path.  When memory is fragmented, each failed costly-order allocation
> > enters __alloc_pages_slowpath() which runs direct compaction and
> > drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> > pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> Is there anything particularly unusual about this test case?
> 
> > Results (average of 3 runs, TPS):
> > 
> >   Config                   Avg TPS      % vs Baseline
> >   baseline (no patch)       59,408       -
> >   With this patch          155,409      +161.6%
> 
> Is this back to pre-5d8edfb900d5 performance?
> 
> > Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> > Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> > Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> > Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> 
> That's three years old.  v6.10.  
> 
> This is not good.  Can you think of an exceptional reason why this took
> so long to surface, or is it simply that our testing isn't good?

Neither.  We've know about these excessive high-order allocation->
direct reclaim compaction costs for a lot longer than this, and have
quite a number of filesystem based workloads that have been easily
able to reproduce it on demand.  XFS first worked around direct
compaction overhead back around ~5.17/18.

So why has it taken so long for this to be (kinda) fixed in the
memory reclaim code?

It is not for lack of awareness or trying.

I've responded to about half a dozen "direct compaction is
expensive" bug reports in the past couple of years where I've said
"this needs to be fixed in the reclaim code, not at the individual
call sites". Not just fs stuff, but graphics and other subsystems,
too.

However, convincing the MM manintainers to do anything w.r.t.
changing memory reclaim takes forever, and requires excessive
amounts of persistence before anything happens despite clear
evidence of the issue and the performance numbers showing how costly
direct compaction actually is.

A directly relatable example of this is kvmalloc() semantics. We
needed kvmalloc() use fail fast semantics for the high order
kmalloc() because it is much less costly to fall back to vmalloc()
than do direct compaction....

This was what the XFS changes in 5.17 worked around, and that fix
didn't get pulled into the kvmalloc() implementation until 6.15 with
commit 46459154f997 ("mm: kvmalloc: make kmalloc fast path real fast
path").

IOWs, it often takes years from "bad behaviour known" to "fixed in
MM infrastructure", and most of that time is spent trying to
convince the MM maintainers that the (relatively simple) fix needs
to be done in the MM code itself...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
