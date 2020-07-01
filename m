Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FEAC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 07:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4ED20722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 07:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593587080;
	bh=OJi4TwQ/AA4heWaYPz3OAf3XiDvTKL/p+rJQt1+v6FA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=c7j2DTwhQVEKACXoF4PbTKgdHytxZ2T9EmBS1ih/MDYg5L98R3tK5KRl5wh6E1T3G
	 pGI8WvRKo9TJ+fuuE0o7bIaKQhkuqZqtvhe+cvwQbIwyhC6c7IgxqQivLI2e+T04Tv
	 NtYro1Ru2pz0dtl0ksW1LsAVzOrFGpuFppcBpN2Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgGAHEg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 03:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgGAHEf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Jul 2020 03:04:35 -0400
Received: from kernel.org (unknown [87.71.40.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B516020775;
        Wed,  1 Jul 2020 07:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593587074;
        bh=OJi4TwQ/AA4heWaYPz3OAf3XiDvTKL/p+rJQt1+v6FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mevCwmWZHnD24MLcRKyCpDUKGLlk3ssUotGYzuCIzZjYQgbQlSv9TeXvxvDlqwVdh
         D8m8LSMHEzFX8CR2njEus2usi2yj1XsP7za5gWivl9PsapKNFRA4hPmr5EVMtwjvf7
         lo6uYhPLHZDfZbdR0RWYfFXy3N7svkwkF6tMpEPA=
Date:   Wed, 1 Jul 2020 10:04:22 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200701070422.GH1492837@kernel.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
 <20200629121816.GC25523@casper.infradead.org>
 <20200629125231.GJ32461@dhcp22.suse.cz>
 <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
 <20200629212830.GJ25523@casper.infradead.org>
 <20200630063436.GA2369@dhcp22.suse.cz>
 <20200701041203.GQ25523@casper.infradead.org>
 <20200701055346.GH2369@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701055346.GH2369@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 07:53:46AM +0200, Michal Hocko wrote:
> On Wed 01-07-20 05:12:03, Matthew Wilcox wrote:
> > On Tue, Jun 30, 2020 at 08:34:36AM +0200, Michal Hocko wrote:
> > > On Mon 29-06-20 22:28:30, Matthew Wilcox wrote:
> > > [...]
> > > > The documentation is hard to add a new case to, so I rewrote it.  What
> > > > do you think?  (Obviously I'll split this out differently for submission;
> > > > this is just what I have in my tree right now).
> > > 
> > > I am fine with your changes. Few notes below.
> > 
> > Thanks!
> > 
> > > > -It turned out though that above approach has led to
> > > > -abuses when the restricted gfp mask is used "just in case" without a
> > > > -deeper consideration which leads to problems because an excessive use
> > > > -of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
> > > > -reclaim issues.
> > > 
> > > I believe this is an important part because it shows that new people
> > > coming to the existing code shouldn't take it as correct and rather
> > > question it. Also having a clear indication that overuse is causing real
> > > problems that might be not immediately visible to subsystems outside of
> > > MM.
> > 
> > It seemed to say a lot of the same things as this paragraph:
> > 
> > +You may notice that quite a few allocations in the existing code specify
> > +``GFP_NOIO`` or ``GFP_NOFS``. Historically, they were used to prevent
> > +recursion deadlocks caused by direct memory reclaim calling back into
> > +the FS or IO paths and blocking on already held resources. Since 4.12
> > +the preferred way to address this issue is to use the new scope APIs
> > +described below.
> > 
> > Since this is in core-api/ rather than vm/, I felt that discussion of
> > the problems that it causes to the mm was a bit too much detail for the
> > people who would be reading this document.  Maybe I could move that
> > information into a new Documentation/vm/reclaim.rst file?

It would be nice to have Documentation/vm/reclaim.rst regardless ;-)

> Hmm, my experience is that at least some users of NOFS/NOIO use this
> flag just to be sure they do not do something wrong without realizing
> that this might have a very negative effect on the whole system
> operation. That was the main motivation to have an explicit note there.
> I am not sure having that in MM internal documentation will make it
> stand out for a general reader.

I'd add an explict note in the "Memory Scoping API" section. Please see
below.

> But I will not insist of course.
> 
> > Let's see if Our Grumpy Editor has time to give us his advice on this.
> > 
> > > > -FS/IO code then simply calls the appropriate save function before
> > > > -any critical section with respect to the reclaim is started - e.g.
> > > > -lock shared with the reclaim context or when a transaction context
> > > > -nesting would be possible via reclaim.  
> > > 
> > > [...]
> > > 
> > > > +These functions should be called at the point where any memory allocation
> > > > +would start to cause problems.  That is, do not simply wrap individual
> > > > +memory allocation calls which currently use ``GFP_NOFS`` with a pair
> > > > +of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
> > > > +find the lock which is taken that would cause problems if memory reclaim
> > > > +reentered the filesystem, place a call to memalloc_nofs_save() before it
> > > > +is acquired and a call to memalloc_nofs_restore() after it is released.
> > > > +Ideally also add a comment explaining why this lock will be problematic.
> > > 
> > > The above text has mentioned the transaction context nesting as well and
> > > that was a hint by Dave IIRC. It is imho good to have an example of
> > > other reentrant points than just locks. I believe another useful example
> > > would be something like loop device which is mixing IO and FS
> > > layers but I am not familiar with all the details to give you an
> > > useful text.
> > 
> > I'll let Mikulas & Dave finish fighting about that before I write
> > any text mentioning the loop driver.  How about this for mentioning
> > the filesystem transaction possibility?
> > 
> > @@ -103,12 +103,16 @@ flags specified by any particular call to allocate memory.
> >  
> >  These functions should be called at the point where any memory allocation
> >  would start to cause problems.  That is, do not simply wrap individual
> > -memory allocation calls which currently use ``GFP_NOFS`` with a pair
> > -of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
> > -find the lock which is taken that would cause problems if memory reclaim
> > +memory allocation calls which currently use ``GFP_NOFS`` with a pair of
> > +calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead, find
> > +the resource which is acquired that would cause problems if memory reclaim
> >  reentered the filesystem, place a call to memalloc_nofs_save() before it
> >  is acquired and a call to memalloc_nofs_restore() after it is released.
> >  Ideally also add a comment explaining why this lock will be problematic.
> > +A resource might be a lock which would need to be acquired by an attempt
> > +to reclaim memory, or it might be starting a transaction that should not
> > +nest over a memory reclaim transaction.  Deep knowledge of the filesystem
> > +or driver is often needed to place memory scoping calls correctly.

I'd s/often/always/ :)

> Ack

And

+ Using memory scoping APIs "just in case" may lead to problematic
reclaim behaviour and have a very negative effect on the whole system
operation.

> >  Please note that the proper pairing of save/restore functions
> >  allows nesting so it is safe to call memalloc_noio_save() and
> > 
> > > > @@ -104,16 +134,19 @@ ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
> > > >  alignment is also guaranteed to be at least the respective size.
> > > >  
> > > >  For large allocations you can use vmalloc() and vzalloc(), or directly
> > > > -request pages from the page allocator. The memory allocated by `vmalloc`
> > > > -and related functions is not physically contiguous.
> > > > +request pages from the page allocator.  The memory allocated by `vmalloc`
> > > > +and related functions is not physically contiguous.  The `vmalloc`
> > > > +family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
> > > > +flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
> > > > +the allocator which are hard to remove.  However, the scope APIs described
> > > > +above can be used to limit the `vmalloc` functions.
> > > 
> > > I would reiterate "Do not just wrap vmalloc by the scope api but rather
> > > rely on the real scope for the NOFS/NOIO context". Maybe we want to
> > > stress out that once a scope is defined it is sticky to _all_
> > > allocations and all allocators within that scope. The text is already
> > > saying that but maybe we want to make it explicit and make it stand out.
> > 
> > yes.  I went with:
> > 
> > @@ -139,7 +143,10 @@ and related functions is not physically contiguous.  The `vmalloc`
> >  family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
> >  flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
> >  the allocator which are hard to remove.  However, the scope APIs described
> > -above can be used to limit the `vmalloc` functions.
> > +above can be used to limit the `vmalloc` functions.  As described above,
> > +do not simply wrap individual calls in the scope APIs, but look for the
> > +underlying reason why the memory allocation may not call into filesystems
> > +or block devices.
> 
> ack
> 
> >  
> >  If you are not sure whether the allocation size is too large for
> >  `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
> > 
> > 
> > > [...]
> > > > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > > > index 6484569f50df..9fc091274d1d 100644
> > > > --- a/include/linux/sched/mm.h
> > > > +++ b/include/linux/sched/mm.h
> > > > @@ -186,9 +186,10 @@ static inline gfp_t current_gfp_context(gfp_t flags)
> > > >  		 * them.  noio implies neither IO nor FS and it is a weaker
> > > >  		 * context so always make sure it takes precedence.
> > > >  		 */
> > > > -		if (current->memalloc_nowait)
> > > > +		if (current->memalloc_nowait) {
> > > >  			flags &= ~__GFP_DIRECT_RECLAIM;
> > > > -		else if (current->memalloc_noio)
> > > > +			flags |= __GFP_NOWARN;
> > > 
> > > I dunno. I wouldn't make nowait implicitly NOWARN as well. At least not
> > > with the initial implementation. Maybe we will learn later that there is
> > > just too much unhelpful noise in the kernel log and will reconsider but
> > > I wouldn't just start with that. Also we might learn that there will be
> > > other modifiers for atomic (or should I say non-sleeping) scopes to be
> > > defined. E.g. access to memory reserves but let's just wait for real
> > > usecases.
> > 
> > Fair enough.  I'll drop that part.  Thanks!
> 
> thanks!
> -- 
> Michal Hocko
> SUSE Labs

-- 
Sincerely yours,
Mike.
