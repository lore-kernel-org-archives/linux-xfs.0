Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75D9C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 06:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24FE20672
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 06:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593498881;
	bh=D10iARWZDI3YSIcw+X+ecEeLOE8PvDUMKP0EU10sBJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=P+2uBkpqYjzM+7feK04kFjXk23xNjeQLwsJhk8o3IdkHMEx6snr1QBikuFl3z2uAh
	 YgfSTQGkxO5vDXZag2qfCph+OQFVaDXDLaVAV0e8/6mfSpx2/1dRcfZ/kbIXTn9OPU
	 V0Qu7WjUDmfUrUt+nC7sA0SgXtxQ+QQ5Y8JiGioY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgF3Gel (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 02:34:41 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37738 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730002AbgF3Gek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 02:34:40 -0400
Received: by mail-ed1-f66.google.com with SMTP id g20so14848237edm.4;
        Mon, 29 Jun 2020 23:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=08Q8MYk57nf50eKT+zhrwFWx+pjsPYwbCvTbWZUGRNw=;
        b=atz+7P5k0N2fPCWv3a05Zbcs0cVs80vG1GQFatjVS7hafxlOLddiGRSO/PHMvY0OR4
         EZbWR4qFZL0l/rkVFzCc0VkoEewEDyvlYVoxF90ixT9IFi/ceGXl8MTUl99ER+lvekRo
         HBKCXIWihxcCq4FmsUAwoJ9vXqqZe06S2QKco1dSDVD4kmjH3s4Pl66+yeFUAHrdbufA
         KSxGHbwdruyItkSrbfrzLoibiGlW8JLF/xi1X19aXi9kCHHEzu158NogMxtRcBlEUskC
         Z/5jxNAxMfpv71+QDd5pB3kh+aOkWF799eCYN0njebICVkeDoKW7BYMFGzVU46w5laKR
         vaow==
X-Gm-Message-State: AOAM5315yh9z4i1AOTWWp9t0/u6XspR7+8sw7VxzGkrQegMKZEbOJFvX
        hny8mONRmvxPAamB4iDjAqunTOMB
X-Google-Smtp-Source: ABdhPJxunSgADBb9QQJsLofbqJtzUkXANO3RuWCzGJaJcXjb9jx7A2J8au+Axw9+k1JYJgQTjlCqOw==
X-Received: by 2002:aa7:d2c9:: with SMTP id k9mr13314912edr.98.1593498878441;
        Mon, 29 Jun 2020 23:34:38 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id n16sm1248495ejo.54.2020.06.29.23.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 23:34:37 -0700 (PDT)
Date:   Tue, 30 Jun 2020 08:34:36 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200630063436.GA2369@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
 <20200629121816.GC25523@casper.infradead.org>
 <20200629125231.GJ32461@dhcp22.suse.cz>
 <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
 <20200629212830.GJ25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629212830.GJ25523@casper.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon 29-06-20 22:28:30, Matthew Wilcox wrote:
[...]
> The documentation is hard to add a new case to, so I rewrote it.  What
> do you think?  (Obviously I'll split this out differently for submission;
> this is just what I have in my tree right now).

I am fine with your changes. Few notes below.

> -It turned out though that above approach has led to
> -abuses when the restricted gfp mask is used "just in case" without a
> -deeper consideration which leads to problems because an excessive use
> -of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
> -reclaim issues.

I believe this is an important part because it shows that new people
coming to the existing code shouldn't take it as correct and rather
question it. Also having a clear indication that overuse is causing real
problems that might be not immediately visible to subsystems outside of
MM.

> -FS/IO code then simply calls the appropriate save function before
> -any critical section with respect to the reclaim is started - e.g.
> -lock shared with the reclaim context or when a transaction context
> -nesting would be possible via reclaim.  

[...]

> +These functions should be called at the point where any memory allocation
> +would start to cause problems.  That is, do not simply wrap individual
> +memory allocation calls which currently use ``GFP_NOFS`` with a pair
> +of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
> +find the lock which is taken that would cause problems if memory reclaim
> +reentered the filesystem, place a call to memalloc_nofs_save() before it
> +is acquired and a call to memalloc_nofs_restore() after it is released.
> +Ideally also add a comment explaining why this lock will be problematic.

The above text has mentioned the transaction context nesting as well and
that was a hint by Dave IIRC. It is imho good to have an example of
other reentrant points than just locks. I believe another useful example
would be something like loop device which is mixing IO and FS layers but
I am not familiar with all the details to give you an useful text.

[...]
> @@ -104,16 +134,19 @@ ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
>  alignment is also guaranteed to be at least the respective size.
>  
>  For large allocations you can use vmalloc() and vzalloc(), or directly
> -request pages from the page allocator. The memory allocated by `vmalloc`
> -and related functions is not physically contiguous.
> +request pages from the page allocator.  The memory allocated by `vmalloc`
> +and related functions is not physically contiguous.  The `vmalloc`
> +family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
> +flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
> +the allocator which are hard to remove.  However, the scope APIs described
> +above can be used to limit the `vmalloc` functions.

I would reiterate "Do not just wrap vmalloc by the scope api but rather
rely on the real scope for the NOFS/NOIO context". Maybe we want to
stress out that once a scope is defined it is sticky to _all_
allocations and all allocators within that scope. The text is already
saying that but maybe we want to make it explicit and make it stand out.

[...]
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 6484569f50df..9fc091274d1d 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -186,9 +186,10 @@ static inline gfp_t current_gfp_context(gfp_t flags)
>  		 * them.  noio implies neither IO nor FS and it is a weaker
>  		 * context so always make sure it takes precedence.
>  		 */
> -		if (current->memalloc_nowait)
> +		if (current->memalloc_nowait) {
>  			flags &= ~__GFP_DIRECT_RECLAIM;
> -		else if (current->memalloc_noio)
> +			flags |= __GFP_NOWARN;

I dunno. I wouldn't make nowait implicitly NOWARN as well. At least not
with the initial implementation. Maybe we will learn later that there is
just too much unhelpful noise in the kernel log and will reconsider but
I wouldn't just start with that. Also we might learn that there will be
other modifiers for atomic (or should I say non-sleeping) scopes to be
defined. E.g. access to memory reserves but let's just wait for real
usecases.


Thanks a lot Matthew!
-- 
Michal Hocko
SUSE Labs
