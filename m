Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D177260F
	for <linux-xfs@vger.kernel.org>; Sun,  5 Apr 2026 22:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775427373; cv=none; b=JAJtcVfp3AZzFl39Nl1p0TRiV8WEgvXvUJEsjg5jUqA/EVrarr0vSXw9hozezcHxOsK7F4dMc8TX4VBYU2ZdKQevhZkIx4sf5Bg4oJCouhqYT7F65FNX+eZWfX3S2OVn9BYy9YXU2SEf0/zW6GHoKiloVpxgnltdPmbv/vrfuVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775427373; c=relaxed/simple;
	bh=O2N4leZeaqxKg2fYzKY0lVf6QGdeXI2nyCGKaAhmLwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZoGyEJjUc7guRVfRY/BLl1CK2LP4P8Wd2SizKIpY+YzSl6GqbsRitY1gLzWiSAyLxI7SEhIECjlZcoae/WlvXnzvziJgXIUCyw/f/eaSot5v5z0H5G35ODVPqDHUFCJaXqq8JvFVVRntWq1+grpp8SbqdSFuELBHcSYqguKvXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFDe/XtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFDe/XtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511B6C116C6;
	Sun,  5 Apr 2026 22:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775427372;
	bh=O2N4leZeaqxKg2fYzKY0lVf6QGdeXI2nyCGKaAhmLwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFDe/XtBynQAdq+dsL/xwPXOMJ+OrGwbmVsOHfKAY0g/qdZWSq//KFcRWqQnLGYV3
	 G3m76gAdqfXqeLx8hpKtmkwmTA6IX2UtHbV6bq+H7yaE7woY9uu7nEynGAZdwAC+oP
	 byBfWUPUngDgTGs6q0Tfkw59gEZJU/dbUncofF9fADMcUGHoap8xPai23YiyU//ZFW
	 6/bo/+dBpYy5a1GZR+W+6M1T6WA79dxkb0raGoqnw7E/i1BF+xzZZsbyoII0geVPNf
	 3e6mLP0OShQ6HOPiLc5BJHwYiFz1vxg3q+602nW1tIQLADcddTAAMpOfBhEuhVtYH+
	 +kGaeP2OdLWRQ==
Date: Mon, 6 Apr 2026 08:16:07 +1000
From: Dave Chinner <dgc@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <adLfJwoi1lZhnbjn@dread>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org>
 <adDgYCmgNsA9ff3e@dread>
 <341amd4w.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <341amd4w.ritesh.list@gmail.com>

On Sun, Apr 05, 2026 at 06:33:59AM +0530, Ritesh Harjani wrote:
> Dave Chinner <dgc@kernel.org> writes:
> 
> > On Fri, Apr 03, 2026 at 04:35:46PM +0100, Matthew Wilcox wrote:
> >> This is with commit 5619b098e2fb so after 7.0-rc6
> >> INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
> >> task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
> >> Call Trace:
> >>  <TASK>
> >>  __schedule+0x560/0xfc0
> >>  schedule+0x3e/0x140
> >>  schedule_timeout+0x84/0x110
> >>  ? __pfx_process_timeout+0x10/0x10
> >>  io_schedule_timeout+0x5b/0x80
> >>  xfs_buf_alloc+0x793/0x7d0
> >
> > -ENOMEM.
> >
> > It'll be looping here:
> >
> > fallback:
> >         for (;;) {
> >                 bp->b_addr = __vmalloc(size, gfp_mask);
> >                 if (bp->b_addr)
> >                         break;
> >                 if (flags & XBF_READ_AHEAD)
> >                         return -ENOMEM;
> >                 XFS_STATS_INC(bp->b_mount, xb_page_retries);
> >                 memalloc_retry_wait(gfp_mask);
> >         }
> >
> > If it is looping here long enough to trigger the hang check timer,
> > then the MM subsystem is not making progress reclaiming memory. This
> 
> Hi Dave,
> 
> If that's the case and if we expect the MM subsystem to do memory
> reclaim, shouldn't we be passing the __GFP_DIRECT_RECLAIM flag to our
> fallback loop? I see that we might have cleared this flag and also set
> __GFP_NORETRY, in the above if condition if allocation size is >PAGE_SIZE.
> 
> So shouldn't we do?
> 
>         if (size > PAGE_SIZE) {
>                 if (!is_power_of_2(size))
>                         goto fallback;
> -               gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> -               gfp_mask |= __GFP_NORETRY;
> +               gfp_t alloc_gfp = (gfp_mask & ~__GFP_DIRECT_RECLAIM) | __GFP_NORETRY;
> +               folio = folio_alloc(alloc_gfp, get_order(size));
> +       } else {
> +               folio = folio_alloc(gfp_mask, get_order(size));
>         }
> -       folio = folio_alloc(gfp_mask, get_order(size));
>         if (!folio) {
>                 if (size <= PAGE_SIZE)
>                         return -ENOMEM;
>                 trace_xfs_buf_backing_fallback(bp, _RET_IP_);
>                 goto fallback;
>         }

Possibly.

That said, we really don't want stuff like compaction to
run here -ever- because of how expensive it is for hot paths when
memory is low, and the only knob we have to control that is
__GFP_DIRECT_RECLAIM.

However, turning off direct reclaim should make no difference in
the long run because vmalloc is only trying to allocate a batch of
single page folios.

If we are in low memory situations where no single page folios are
not available, then even for a NORETRY/no direct reclaim allocation
the expectation is that the failed allocation attempt would be
kicking kswapd to perform background memory reclaim.

This is especially true when the allocation is GFP_NOFS/GFP_NOIO
even with direct reclaim turned on - if all the memory is held in
shrinkable fs/vfs caches then direct reclaim cannot reclaim anything
filesystem/IO related.

i.e. background reclaim making forwards progress is absolutely
necessary for any sort of "nofail" allocation loop to succeed
regardless of whether direct reclaim is enabled or not.

Hence if background memory reclaim is making progress, this
allocation loop should eventually succeed. If the allocation is not
succeeding, then it implies that some critical resource in the
allocation path is not being refilled either on allocation failure
or by background reclaim, and hence the allocation failure persists
because nothing alleviates the resource shortage that is triggering
the ENOMEM issue.

So the question is: where in the __vmalloc allocation path is the
ENOMEM error being generated from, and is it the same place every
time?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
