Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA2C418357
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 07:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786692624; cv=none; b=RJdg8ckHmVbbvz9E6B++W7gi6CjivZDFTFng7kYdSb0aTMUvf3T5y/BoG2124fwA+mN5Ad/Im9d7qXv8kGbWrnaJMwa5p0StUBSSq6hqCy3Zy132fY+fCwpsumsR0BvwoVD6nmkGsSTvtnx5jyHwi1z0S0TPfLCmeUGdlyuRfR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786692624; c=relaxed/simple;
	bh=UOhL2SEVGN7DvoCe3wL4DAPI9ny+JVk559ws6kguEy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvfPBHnqFlRK2Qba1OEAkbuhXgdCWYkDErcGgqbcmFCKNFPHu5mIm76pXSA1c9vajVFBahGqrTQfPJzanq9PjAJx0KPXVIYjtUM/WY+gk4ZQLyDQoxPAkBJBDtSuP2Ow1E23gQfiuzffh022mSGjXXg3/Qd2LYDF8Ckc80Yw0jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Va+k8oGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Va+k8oGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58521F00A3A;
	Fri, 14 Aug 2026 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786692615;
	bh=aQBSsh75OLcrl354x/64LYAkiDCqavFHyytqP9ZvYPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Va+k8oGvs2PQFjlESywwxNn/dL+w56yfXXWQaCX53AyulvIjzIT+kJgG9lhzBiK25
	 Ca/JSJRMz0Cbm+UuWl8MbawSdAzAyGoSbdH84wjkTVlD2opT9yOzJFwe2ARXb/4d8H
	 3/kumAUzshKDtjo+aqdFwkEIbeSU9yaaQvGv7ULtIdc+4LLY6ta5TL0pEgaurodr9P
	 IKRf/MVJgaVfUHxLPxgzS/rZ6mYAh4sMdGEKpgXq/4dEtRzcCOT08MAmgtxoLCmOih
	 v4BTIdW/GbED5JsL23jf4l/YFenCkPOzG+v17tjWZ39rHPoGV4K3auTmv9t7ZN4hWf
	 +lSQzJ0yE4tbg==
Date: Fri, 14 Aug 2026 17:30:07 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: xfs: properly account xfs_buf items as reclaimable
Message-ID: <an7D_9YRVDG-0Qjq@dread>
References: <20260813204929.2253988-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813204929.2253988-1-sandeen@redhat.com>

On Thu, Aug 13, 2026 at 03:40:51PM -0500, Eric Sandeen wrote:
> It was reported that xfs_buf items are not accounted for as
> reclaimable,

Actually, they are:

        xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
                                         SLAB_HWCACHE_ALIGN |
>>>>>>                                   SLAB_RECLAIM_ACCOUNT,
                                         NULL);

So the xfs_buf items themselves are accounted as reclaimable slab
objects, and these are what the xfs_buf shrinker itself acts on.

> and therefore various statistics in /proc/meminfo
> and /proc/vmstat do not reflect their reclaimable nature as
> other slab-allocated items with shrinkers would do, which in
> turn affects the accuracy of stats such as MemAvailable.
> 
> 2 patches here to add accounting for xfs_bufs allocated via
> xfs_buf_alloc_kmem() and via xfs_buf_alloc_folio().

That's accounting for the memory attached to the xfs_buf, not the
xfs_buf itself. We don't use the size of that memory for reclaim
purposes, hence we haven't ever tracked it. It is, however, fed back
into shrinker based memory reclaim via mm_account_reclaimed_pages()
in xfs_buf_free() and hence memory reclaim correctly tracks how much
memory was released by the xfs_buf shrinker scan, even if the user
visible stats don't show it.

> I was not sure how to handle xfs_buf_alloc_vmalloc but I think
> that's a relatively rare path, and the above two will capture
> the majority of xfs_buf allocations.

I think both folio and vmalloc should be accounted in the same
manner - as a number of pages based on the size of the buffer (i.e.
same as mm_account_reclaimed_pages() does already). It doesn't
matter if it is vmalloc or a high order folio, the amount of memory
is the same.  If it gets accounted to the node of the first folio,
then it will at least always be consistently accounted, if not
always 100% accurate for the vmalloc case.

> I've cc:d linux-mm just because i think this is the first
> user of NR_KERNEL_MISC_RECLAIMABLE in the tree?

These are fs buffers - shouldn't they be accounted as something that
reports as "cached" or "buffers" in /proc/meminfo? I mean, if you're
going to do this to make meminfo/vmstat report the memory usage,
shouldn't we make the effort to classify the memory usage correctly
for the user?

Cheers,

Dave.

-- 
Dave Chinner
dgc@kernel.org
