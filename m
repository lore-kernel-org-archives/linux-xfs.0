Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793224778;
	b=4a7WyEeC/CXFaycOjHtwmAw3bpxRxdkupsobEa5szR2kN5qx+aylbCSUMbDuO8dRMc1V
	 5Bmkb5IQ4iSKkoeYxMy4VGdbKw20RTFV46JXrbotO/Rs1qhP5d3uVBMBnRaXiwrX3FNW6
	 lRYIHv2G6L5o5BWRTpHL1T3Hg8xFk599jK4C1hGYaNUygo3v6ySzlnumN2t6ZuTeJK+2Y
	 X67rbWlA8ADu6mtbgmnobdSfFpeTHFTHArx6xWF05aQv2S0r81qeiEx2ldWcjDBofDOrZ
	 lNZJ0qnDAlpN7TJVAMpcMh6HVvkrILvLFHIQ5ZWe32WGjcxDzEcfvRmm5HyhLo6zXsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793224778;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KN0FgIJMajTdk9Ymv64LA7EQejo37NTwYsXl8rzrDcw=;
	b=fo9inZ7VJsv9/W6lLZfxb/eKhwbQeBnuaBTV4905NK8eMRLCDth6/9tsZa5xP909KJ5E
	 g3MaN1JD+Cit1GuQGE/LDDD6gUtgUSgIyezgKFJ0/wovqZ9Sz463ZLBZih6XtuoMP3DjT
	 vGqS77mbgkr2gmivJQ77muw/LM90ia2jTxwp+e8Izb22weYgz/L2yNBiFla06wE4WdQ7i
	 TXDotrItejKZdgCCX+XYB3i0Jus4KKI1PGY3mChJdNLzsIaqu+GZgV2Wbb8DDSo1ldlJe
	 GMMijEqydnNxCRzY+h5OhjFDrYZ4Tne0lO38+UP09KbEhpYVTiW2KW+5kk6X/JjqAoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a3RA0sBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC24606A334;
	Wed, 28 Oct 2026 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a3RA0sBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735ED1F01825;
	Wed, 28 Oct 2026 21:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793224777;
	bh=KN0FgIJMajTdk9Ymv64LA7EQejo37NTwYsXl8rzrDcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a3RA0sBt4j+5IOAxEQxpVDoeAzK+P2lBLhl6gq2sX+rpplyk7XL+xEh8DUFIe7llV
	 7Xwjeho+6cJzY+Al3GxT+KpIrqYT4GruKZzBB1gefgy9Gm6mRgcxx4CtoAIwqa9gCk
	 ZOb2MydTxzI70JvhNAi/zd7B3b/0uyaMJCy5gjs666f5X12czMgE5UGdw6HEM9/HmT
	 roFeNjsFe73Sd1FC9UdXdQNt04xT8PcR2DZKB6YITl5USRXo3YWmrLpEotk9nHElM9
	 23qPe0bvRd63mi3/Y0Yk+bs/cjlLa1pNzQg1YCqRV+kfADzUNXig3J22jjQPaJ76zt
	 b5A4bYdaO7/sw==
Date: Thu, 29 Oct 2026 08:59:20 +1100
From: Dave Chinner <dgc@kernel.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, ryan.roberts@arm.com,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	dipietro.salvatore@gmail.com, rvvandan@amazon.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
	miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org,
	hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com,
	cem@kernel.org, dlemoal@kernel.org, naohiro.aota@wdc.com,
	jth@kernel.org, willy@infradead.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev, fuse-devel@lists.linux.dev,
	gfs2@lists.linux.dev, linux-xfs@vger.kernel.org,
	ntfs@lists.linux.dev, ntfs3@lists.linux.dev
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Message-ID: <auJwOJ-dQCHLAvMq@dread>
References: <20261027112702.3747009-1-dipiets@amazon.it>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>

On Tue, Oct 27, 2026 at 11:27:00AM +0000, Salvatore Dipietro wrote:
> Since iomap gained per-block dirty tracking, a large folio can be
> partially dirty: struct iomap_folio_state records exactly which
> blocks are dirty, and writeback only writes those ranges.  The mm
> dirty accounting, however, still charges the whole folio even if a
> single block is dirty (up to 512x over-accounting for a 2 MB folio
> over 4 KB blocks).
> 
> balance_dirty_pages() then throttles writers against a number that
> is unrelated to how much data actually needs writing back.  On
> workloads that repeatedly dirty small ranges of large folios --
> e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> is crossed and writers are throttled long before the real dirty data
> justifies it.  On the benchmark below, run on v7.3-rc7, the
> unpatched kernel charges ~159 TB of dirtied pages while writing
> ~6 TB to the array, a factor of 27; with this series the dirtied
> pages charged match the data actually written.
> 
> This series makes iomap charge and discharge the mm dirty counters
> per dirty page for folios that carry per-block dirty state, so a
> partially dirty large folio is accounted for the dirty part only:
> 
>   - Patch 1 adds the mm infrastructure: an AS_DIRTY_PER_BLOCK
>     mapping flag, an @accounted argument to __folio_mark_dirty()
>     and __filemap_dirty_folio() to skip the generic per-folio
>     charge, and an address_space_operations::accounted_dirty_pages()
>     callback used by the discharge and migration paths instead of
>     folio_nr_pages().  No filesystem opts in, so it is a no-op on
>     its own.
> 
>   - Patch 2 makes iomap charge per dirty page from the per-block
>     dirty bitmap and wires iomap_accounted_dirty_pages() into every
>     iomap-based filesystem.

This feels to me like a pretty gross layering violation.

iomap is tracking dirty filesystem block state, for the purposes of
efficiently writing back dirty blocks.

iomap was designed to keep filesystem state entirely separate from
the page cache, including the tracking of sub-page dirty filesystem
state.  One of the underlying design principles of iomap (all those
years ago) was to avoid needing the page cache to know anything
about filesystem block sizes at all. having the page cache track
anything at filesystem block granularity was inefficient, wasteful
in terms of memory needed to track each block, had coherency
problems with filesystem state vs cached mm/pagecache state, etc.

iomap tracks block dirty state per folio for writeback efficiency,
not for pagecache drity tracking optimisation. Large folios are a
pagecache optimisation, and they were really only made possible by
the isolation iomap provides between filesystem state and page cache
state.

Pushing the mm dirty folio accounting implementations directly into
iomap breaks that isolation - it once again tightly couples the
filesystem dirty block tracking to mm pagecache accounting and
accounting. Hence I think this approach is a non-starter - nothing
should bleed across the filemap interfaces in either direction....

> This was benchmarked with PostgreSQL using the pgbench simple-update
> workload on v7.3-rc7.  Average throughput rises 46.8% (139.8k ->
> 205.2k tps) and run-to-run variability drops from a 23.60% to a
> 3.98% coefficient of variation: the worst iteration improves from
> 97.9k to 191.5k tps, while the best gains 8%, 199.4k -> 215.9k.

If postgresql is only doing 8/16kb writes, then how is it getting
the page cache populated with large folios? That's the underlying
fundamental problem here, yes?

I ask, because iomap caps the folio size to the write() IO length,
so for 8/16kB writes it will only be asking for 8-16kB folios and so
there won't be huge 2MB folios in the page cache to cause
issues. Hence there must be something else populating the cache
first....

> Ten iterations per kernel, same database and workload (tps):
> 
>   Kernel                     Avg     Min     Max      CV   iters   iters
>                                                              1-5    6-10
>   ______________________  ______  ______  ______  ______  ______  ______
>   v7.3-rc7                139.8k   97.9k  199.4k  23.60%  164.4k  115.2k
>   v7.3-rc7 + this series  205.2k  191.5k  215.9k   3.98%  200.1k  210.2k
> 
> On unpatched v7.3-rc7 the worst iteration lands ~51% below the best,
> and throughput decays as the run progresses: iterations 6-10 average
> 30% below iterations 1-5.  With this series the decay is gone -- the
> second half is similar to the first -- and the coefficient of
> variation stays at 3.98%.
> 
> The over-accounting has existed since commit 4ce02c679722 ("iomap: Add
> per-block dirty state tracking to improve performance"), merged in
> v6.6, where the ifs bitmap started recording partial dirty state while
> the mm counters kept charging whole folios.
> 
> The throughput collapse bisects to the v6.17 readahead series, first
> bad commit c4602f9fa77f ("mm/readahead: store folio order in struct
> file_ra_state"), which lets readahead stay at the largest folio order
> once it has ramped up, so a single dirty block charges far more than
> is written.

.... and that implies there is a sequential read portion of the
benchmark that is first populating the page cache with large folios.

Do you get the same sort of improvement if you make postgres use
POSIX_FADV_RANDOM on these files? This will cap the size of folios
in the cache to whatever the postgresql read() IO size is. Yes, it
will slow down whatever the sequential read portion of the benchmark
is, but I don't care about that right now.

What I want to know is if the application preventing readahead from
populating large folios gets you back all the write performance
without needing to modify any kernel code at all.  i.e. if we make a
different choice for initial folio sizes in readahead, then does the
write performance improve?

Alternatively, if there is distinct sequential read vs random write
phases to postgres behaviour, then does issuing POSIX_FADV_DONTNEED
between them restore the random write performance?

If choosing smaller folios for readhaead makes the problem go away,
then the answer may be to add FADV_RANDOM_WRITE which allows full
readahead but caps page cache folio size to, say, 64kB.  That would
allow sequential buffered reads to run at full speed, prevent the
worst of the issues with PAGE_SIZE folios in the page cache, but
also not perform terribly for random 8-16kB writes....

Indeed, we could use the fadvise64(count) parameter for something
like FADV_RANDOM_WRITE to provide an IO size hint that would be used
to derive the folio size we use for that file during readahead....

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
