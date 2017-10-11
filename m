Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756760AbdJKJCV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 05:02:21 -0400
Date: Wed, 11 Oct 2017 05:02:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: cancel dirty pages on invalidation
Message-ID: <20171011090219.GA32909@bfoster.bfoster>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-5-david@fromorbit.com>
 <20171009142445.GE18663@bfoster.bfoster>
 <20171009204816.GN3666@dastard>
 <20171010122945.GB23057@bfoster.bfoster>
 <20171011000400.GW3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011000400.GW3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 11:04:00AM +1100, Dave Chinner wrote:
> On Tue, Oct 10, 2017 at 08:29:45AM -0400, Brian Foster wrote:
> > On Tue, Oct 10, 2017 at 07:48:16AM +1100, Dave Chinner wrote:
> > > On Mon, Oct 09, 2017 at 10:24:46AM -0400, Brian Foster wrote:
> > > > On Mon, Oct 09, 2017 at 10:54:14AM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Recently we've had warnings arise from the vm handing us pages
> > > > > without bufferheads attached to them. This should not ever occur
> > > > > in XFS, but we don't defend against it properly if it does. The only
> > > > > place where we remove bufferheads from a page is in
> > > > > xfs_vm_releasepage(), but we can't tell the difference here between
> > > > > "page is dirty so don't release" and "page is dirty but is being
> > > > > invalidated so release it".
> > > > > 
> > > > 
> > > > Ok, so we changed ->releasepage() in 99579ccec4 ("xfs: skip dirty pages
> > > > in ->releasepage()") to deal with the fact that the mm can send
> > > > legitimately dirty pages to ->releasepage(). That was apparently too
> > > > aggressive a change because truncated pages would also end up skipped
> > > > because the dirty bit is not cleared by the time the release occurs.
> > > > Commit 0a417b8dc1 ("xfs: Timely free truncated dirty pages") modified
> > > > ->releasepage() again to not skip all dirty pages and only warn for
> > > > delalloc/unwritten blocks on clean pages.
> > > > 
> > > > That was apparently insufficient because we have some codepaths where
> > > > not skipping dirty pages can allow us to strip the buffers from a page
> > > > incorrectly...
> > > 
> > > Right, Jan's patch fixed the truncate problem but re-opened the
> > > memory reclaim hole. It effectively reverted the original patch.
> > > 
> > 
> > (Bear with me, trying to work through my confusion...). So the original
> > patch documents XFS release page delalloc warnings and the conditions
> > that occur that make these warnings spurious. The objective of the patch
> > (as documented) was therefore to quiet the warnings. Jan's patch came
> > along to address the lru issue and quieted the warning in a different
> > way.
> > 
> > FWIW, my impression is that this patch is intending to fix some other
> > side effect of this ext/mm behavior also fixed by the original patch,
> > but at least wasn't documented by the commit log. What this additional
> > side effect is is the part I'm trying to understand...
> > 
> > > > > In some places that are invalidating pages ask for pages to be
> > > > > released and follow up afterward calling ->releasepage by checking
> > > > > whether the page was dirty and then aborting the invalidation. This
> > > > > is a possible vector for releasing buffers from a page but then
> > > > > leaving it in the mapping, so we really do need to avoid dirty pages
> > > > > in xfs_vm_releasepage().
> > > > > 
> > > > 
> > > > ... but I'm having a hard time parsing that first sentence to understand
> > > > how that is. Can you elaborate on and/or give a specific reference to
> > > > this problematic invalidation abort sequence?
> > > 
> > > e.g. invalidate_complete_page2():
> > > 
> > > /*                                                                               
> > >  * This is for invalidate_mapping_pages().  That function can be called at       
> > >  * any time, and is not supposed to throw away dirty pages.  But pages can       
> > > .....
> > >        if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
> > >                 return 0;
> > > 
> > >         spin_lock_irqsave(&mapping->tree_lock, flags);
> > >         if (PageDirty(page))
> > >                 goto failed;
> > > ....
> > > 
> > > It's not supposed to throw away dirty pages. But
> > > try_to_release_page() on a dirty page in XFS will currently do just
> > > that.
> > > 
> > 
> > If the page is legitimately dirty, shouldn't the underlying buffer be
> > dirty as well?
> 
> The answer is "yes for all filesystems but ext3". In ext3, journal
> checkpoints can write back the buffers directly and clean them
> without updating the page state on IO completion. So we end up in
> the state where the page state and bufferhead state is not coherent.
> 
> Hence the generic code can't check for the page being clean before
> releasing the page/buffers, because then it would never end up
> noticing and correcting ext3 pages in this state.
> 

Ok. I may not grok the details, but I understand there is some
quirkiness to ext3 that causes the mm to not rely on the page dirty
state for using ->releasepage().

> > ISTM that try_to_release_page() (which eventually gets to
> > try_to_free_buffers()) accommodates the case of a dirty page w/o
> > dirty buffers by checking the latter state and updating the
> > former. So if the page has dirty buffers, try_to_release_page()
> > returns 0 and the invalidate exits with -EBUSY.  If the page does
> > not have dirty buffers, the buffers are dropped, the page dirty
> > state is cancelled and the invalidate proceeds.
> >
> > So for XFS this (dirty page && !dirty bufs) state should not exist.
> 
> But it does!
> 
> Take a dirty page, and truncate it:
> 
> truncate_complete_page
>   do_invalidatepage
>     xfs_vm_invalidatepage
>       block_invalidatepage
>         discard_buffers		<<<<<<<<< clears all buffer state!
>   try_to_release_page
>     xfs_vm_releasepage
>       xfs_count_page_state   <<< finds clean buffers, no warnings
> 
> That's why the truncate path doesn't issue warnings about
> invalidating and releasing dirty pages.
> 

So the above clears the buffer dirty state, then attempts to release the
page, then clears the page dirty state. I can see that we're (XFS)
exposed to the page in a transiently inconsistent state, but the state
itself does appear to be transient in this codepath. IOW, by the time
truncate_complete_page() completes and the page is unlocked, the page
and buffer state are in-sync (neither are dirty).

Note that I can also see how this would have prevented freeing buffers
with the original PageDirty() check (causing Jan's problem), and how
canceling the page dirty state in ->invalidatepage() allows us to
reinstate that PageDirty() check. Alas, that is not my question...

> > A
> > dirty page should always have dirty buffers and vice versa. For XFS,
> > therefore, I don't see how this patch affects
> > invalidate_complete_page2() at all.
> 
> That's what I was trying to point out! i.e. that the patch fixes
> spurious false positive warnigns but doesn't affect the high level
> invalidate_complete_page2() or other invalidation code.
> 

Um, Ok? Then what what is the purpose of the patch? That is what I'm
trying to understand. What problem with the current code does this fix?

> >
> > What am I missing? Is there some
> > other problematic sequence?
> 
> Memory reclaim, dirty page over delalloc/unwritten extent:
> 

Ok..

> shrink_inactive_list
>   shrink_list
>     buffer_heads_over_limit
>       try_to_release_page
>         xfs_vm_releasepage()
> 	  xfs_count_page_state   <<< finds delalloc/unwritten buffer
> 	  WARN_ON(delalloc)
> 

The xfs_vm_releasepage() code looks like this:

	...
        xfs_count_page_state(page, &delalloc, &unwritten);

        if (delalloc) {
                WARN_ON_ONCE(!PageDirty(page));
                return 0;
        }
	...

So if we get here with a dirty page over a delalloc extent, for example,
how exactly does that trigger a spurious warning? AFAICT the warning
will not trigger because the page is dirty. We decide not to release the
page precisely because it has delalloc buffers.

> That warning is still emitted after Jan's patch. That warning is
> meaningless - we've been called to release a valid page from code
> that is only called on dirty pages to work around ext3's "journal
> cleaned the buffers" dirty state incoherency problem.  We've been
> told that this is not going to be fixed in the high level code, so
> we have to handle it ourselves.
> 

Understood.

> That is, trying to release a dirty page with valid state from this
> path on XFS is simply wrong. We shouldn't pollute logs with warnings
> about dirty pages with delalloc/unwritten state in this case because
> /the page and buffers have a valid state/. Hence from this path we
> need to avoid issuing a warning - it's a false positive.
> 

See above. Also AFAICT, try_to_free_buffers() only attempts to release
the page if the buffers are not dirty. So ISTM that this also currently
works as expected.

> Similarly for invalidate_complete_page2() calling
> try_to_release_page with a dirty page - we're supposed to skip them
> and not release them at all as documented by the
> invalidate_complete_page2 API. However, we'll issue warnings:
> 
> invalidate_complete_page2
>   try_to_release_page
>     xfs_vm_releasepage
>       xfs_count_page_state	<<< finds delalloc/unwritten buffer
>       WARN_ON(unwritten)
>   <skips page correctly>
> 

This seems like the same situation from the perspective of
xfs_vm_releasepage(). It basically prioritizes checking the buffer state
over the page state when checking whether we can release the page, and
cancels the page dirty state if so. This is all implemented in
try_to_free_buffers(), we just happen to have an earlier
delalloc/unwritten shortcut check in xfs_vm_releasepage() that allows
checking for an inconsistent page state (i.e., delalloc blocks have been
left on a page that has already been cleaned).

> Because, again, we've been handed a dirty page in a valid state that
> we're not supposed to free. The warning is, again, a false positive.
> 
> If xfs_vm_releasepage gets handed a clean page with dirty buffer
> state on it, then we most definitely need to warn. But we should not
> warn when we are handed dirty pages with valid state from paths that
> actually want us to leave dirty pages completely alone.
> 

Agree, but I don't see how this occurs with the current code. We only
ever warn if the page is clean. As it is, I'm slightly confused as to
whether you are attempting to explain how/why this patch works or
whether there is an issue with the current code. I'm really after the
latter, so I can try and understand the problem before reviewing how
this patch potentially fixes it.

So if I'm still missing something here, can you please reduce the
explanation to cover specifically what is wrong with the current code,
using an example/reproducer description if possible? I think if you can
point me at the sequence of events that cause whatever problem we're
trying to fix, I can probably work out an understanding from the code...

Brian

> > AIUI, the historical warning problem in XFS was because we issued the
> > warning before/without any similar assessment of the validity of the
> > dirty state (i.e., we assumed the page should not be dirty in
> > ->releasepage()).
> 
> And that's precisely what Jan's patch made the code do again. We
> *know* we are going to get handed dirty pages with valid
> delalloc/unwritten state by ->releasepage now, and issuing warnigns
> in those cases is wrong.
> 
> > Hmm, I thought the ext3-specific wart was the fact that dirty pages w/o
> > dirty buffers could exist in the first place (why ->releasepage() must
> > handle dirty pages), not necessarily that a page being removed had to be
> > cleaned/invalidated in any particular order. No matter, I probably need
> > to understand the issue better first...
> 
> Yup, and that means ->releasepage needs to be called before doing
> anything that assumes the page is clean and can be freed. i.e. we
> have to get the ext3 buffer state propagated back to the the page
> state before we take action on the page....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
