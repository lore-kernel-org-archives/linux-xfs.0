Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09C42765DF
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 21:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775511963; cv=none; b=qnLyUGzwDSi2FI1WzZ6PGX4AP0sD0V+QCZ0FfXh5GwnURHaCJiXDdRdkLLYD388mCLt1jEVIElSJ0+ZclViszYvj6IZcokcooLUgCHuGs6H8KgsSHJmO2toFd3tvNRDkcD316ltqcbrB0lFCyo5MRK+Arw5PNcANL2DbqdvLqLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775511963; c=relaxed/simple;
	bh=TI1bJF9DNyhwHD5ieLf/U1MVqlvo4Pz2cyRMrDgXask=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwxtLwvVhT/1oeGAYdtkuBE/APKX7ec3jepb9slA+POMsQAWRrxPQnDwnuJ+T3MIwDOBnpMPXnpCwHWCzV53tSTZNEKvpuM9Yp0WZaDvAZ6OyWKBh76+zWHAS4DYpY8oXPlKrCpOawtDzwwh8BF5TIAX6mPsob76DwpoCUIzZ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZ6z3pYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZ6z3pYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D3FC4CEF7;
	Mon,  6 Apr 2026 21:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775511963;
	bh=TI1bJF9DNyhwHD5ieLf/U1MVqlvo4Pz2cyRMrDgXask=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UZ6z3pYTs0yqQAZ+vI+5360Xh4Id/YkR/w+SpHMt3UL1tISCLqN6UfZwU/l2HCV3b
	 fhI7j+Cg7lst7JC8Xx8g3b8upmjuvmFqXsIKQ8FHfHFXmqLZBxcLOcxfBk6Z5omQoY
	 7/nokPlj5ptrcJnkMRbhfgTg+Tc9nnUz4Ut+i/OPoUxU5gk4U11IvXk9tMtmEs4KKx
	 RXrTwPsEG6Okk3gRsRnkQYy7DKMiZh5gLXoXlC18EnVAl35t4m6CGdubekm2sY+SlQ
	 QittNQblkSu9IfhWuxctTy7Qi5hNaNBC90CU1K+uS26PCDefckEIca4cxEQwqhz8Rn
	 teciBPDLPfmWQ==
Date: Tue, 7 Apr 2026 07:45:58 +1000
From: Dave Chinner <dgc@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <adQplqmx-4RaEh2e@dread>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org>
 <adDgYCmgNsA9ff3e@dread>
 <341amd4w.ritesh.list@gmail.com>
 <adLfJwoi1lZhnbjn@dread>
 <y0j1kk6d.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0j1kk6d.ritesh.list@gmail.com>

On Mon, Apr 06, 2026 at 05:57:06AM +0530, Ritesh Harjani wrote:
> > However, turning off direct reclaim should make no difference in
> > the long run because vmalloc is only trying to allocate a batch of
> > single page folios.
> >
> > If we are in low memory situations where no single page folios are
> > not available, then even for a NORETRY/no direct reclaim allocation
> > the expectation is that the failed allocation attempt would be
> > kicking kswapd to perform background memory reclaim.
> >
> > This is especially true when the allocation is GFP_NOFS/GFP_NOIO
> > even with direct reclaim turned on - if all the memory is held in
> > shrinkable fs/vfs caches then direct reclaim cannot reclaim anything
> > filesystem/IO related.
> >
> 
> So, looking at the logs from Matthew, I think, this case might have
> benefitted from __GFP_DIRECT_RECLAIM, because we have many clean
> inactive file pages. So theoritically, IMO direct reclaim should be able
> to use one of those clean file pages (after it gets direct-reclaimed)
> 
>       nr_zone_inactive_file 62769
>       nr_zone_write_pending 0

You miss the point - this is not an isolated use case. e.g.  Look at
xlog_kvmalloc() - it's also ~__GFP_DIRECT_RECLAIM, NORETRY vmalloc()
loop. What's to stop that one from getting stuck in exactly the same
way?

To that point, kvmalloc(GFP_NOFAIL) now implements the semantics
that xlog_kvmalloc() requires - it turns of direct reclaim (and
hence costly compaction) for the kmalloc() allocation attempt, then
falls back to vmalloc(GFP_NOFAIL) if kmalloc fails.

That's also pretty much the exact semantics we are trying to
implement in in xfs_buf_alloc(), yes? i.e.  xfs_buf_alloc() does:

For buffers < PAGE_SIZE, it calls kmalloc() directly and returns.

For buffers == PAGESIZE, it calls folio_alloc(GFP_KERNEL).

For buffers > PAGE_SIZE, it calls folio_alloc(NORETRY, ~__GFP_DIRECT_RECLAIM)

if either folio_alloc() call fails, it effectively runs an open
coded __vmalloc() no-fail loop.

IOWs we are implementing essentially the same semantics as
kvmalloc(__GFP_NOFAIL), modulo the reclaim flags for the __vmalloc()
loop. If we are going to change the flags for the vmalloc() loop
to be the original, then we are essentially reimplementing
kvmalloc(GFP_NOFAIL) semantics exactly. At which point....

> > i.e. background reclaim making forwards progress is absolutely
> > necessary for any sort of "nofail" allocation loop to succeed
> > regardless of whether direct reclaim is enabled or not.
> >
> > Hence if background memory reclaim is making progress, this
> > allocation loop should eventually succeed. If the allocation is not
> > succeeding, then it implies that some critical resource in the
> > allocation path is not being refilled either on allocation failure
> > or by background reclaim, and hence the allocation failure persists
> > because nothing alleviates the resource shortage that is triggering
> > the ENOMEM issue.
> 
> I agree, background memory reclaim / kswapd thread should have made
> forward progress. 
> 
> I am not sure why in this case, we are we hitting hung tasks issues then.
> Could be because of multiple fsstress threads running in parallel (from
> ps -eax output), and maybe some other process ends up using the pages
> reclaimed by background kswapd (just a theory). 

I don't think that's the case, because kswapd is supposed to run
until watermarks are reached and that means all free page pools are
supposed to have at least some free pages in them...

That's why I think there's a reclaim bug lurking here - allocation
appears to be stalling on something that background reclaim is not
refilling.  And if allocation is stalling on buffer allocation, then
it can stall in other critical parts of XFS, too. Background reclaim
not doing sufficient work to make looping non-blocking, no-retry
allocations to succeed seems like a memory allocation/reclaim bug to
me, not an XFS issue...

> > So the question is: where in the __vmalloc allocation path is the
> > ENOMEM error being generated from, and is it the same place every
> > time?
> >
> 
> Although I can't say for sure, but in this case after looking at the
> code, and knowing that we are not passing __GFP_DIRECT_RECLAIM, it might
> be returning from here (after get_page_from_freelist() couldn't get a
> free page).
> 
> __alloc_pages_slowpath() {
>     ...
> 	/* Caller is not willing to reclaim, we can't balance anything */
> 	if (!can_direct_reclaim)
> 		goto nopage;

Sure, we can't balance anything, but we've set ALLOC_KSWAPD early in
this function and so every time we get to the above point in the
allocation code we've alreayd run this:

retry:
        /* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
        if (alloc_flags & ALLOC_KSWAPD)
                wake_all_kswapds(order, gfp_mask, ac);

Hence kswapds should be active and doing reclaim work to bring
everything back to minimum free pool watermarks.  That *should* be
sufficient for a no-direct-reclaim allocation loop to make progress.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
