Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755245AbdJJM3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 08:29:46 -0400
Date: Tue, 10 Oct 2017 08:29:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: cancel dirty pages on invalidation
Message-ID: <20171010122945.GB23057@bfoster.bfoster>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-5-david@fromorbit.com>
 <20171009142445.GE18663@bfoster.bfoster>
 <20171009204816.GN3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009204816.GN3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 10, 2017 at 07:48:16AM +1100, Dave Chinner wrote:
> On Mon, Oct 09, 2017 at 10:24:46AM -0400, Brian Foster wrote:
> > On Mon, Oct 09, 2017 at 10:54:14AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Recently we've had warnings arise from the vm handing us pages
> > > without bufferheads attached to them. This should not ever occur
> > > in XFS, but we don't defend against it properly if it does. The only
> > > place where we remove bufferheads from a page is in
> > > xfs_vm_releasepage(), but we can't tell the difference here between
> > > "page is dirty so don't release" and "page is dirty but is being
> > > invalidated so release it".
> > > 
> > 
> > Ok, so we changed ->releasepage() in 99579ccec4 ("xfs: skip dirty pages
> > in ->releasepage()") to deal with the fact that the mm can send
> > legitimately dirty pages to ->releasepage(). That was apparently too
> > aggressive a change because truncated pages would also end up skipped
> > because the dirty bit is not cleared by the time the release occurs.
> > Commit 0a417b8dc1 ("xfs: Timely free truncated dirty pages") modified
> > ->releasepage() again to not skip all dirty pages and only warn for
> > delalloc/unwritten blocks on clean pages.
> > 
> > That was apparently insufficient because we have some codepaths where
> > not skipping dirty pages can allow us to strip the buffers from a page
> > incorrectly...
> 
> Right, Jan's patch fixed the truncate problem but re-opened the
> memory reclaim hole. It effectively reverted the original patch.
> 

(Bear with me, trying to work through my confusion...). So the original
patch documents XFS release page delalloc warnings and the conditions
that occur that make these warnings spurious. The objective of the patch
(as documented) was therefore to quiet the warnings. Jan's patch came
along to address the lru issue and quieted the warning in a different
way.

FWIW, my impression is that this patch is intending to fix some other
side effect of this ext/mm behavior also fixed by the original patch,
but at least wasn't documented by the commit log. What this additional
side effect is is the part I'm trying to understand...

> > > In some places that are invalidating pages ask for pages to be
> > > released and follow up afterward calling ->releasepage by checking
> > > whether the page was dirty and then aborting the invalidation. This
> > > is a possible vector for releasing buffers from a page but then
> > > leaving it in the mapping, so we really do need to avoid dirty pages
> > > in xfs_vm_releasepage().
> > > 
> > 
> > ... but I'm having a hard time parsing that first sentence to understand
> > how that is. Can you elaborate on and/or give a specific reference to
> > this problematic invalidation abort sequence?
> 
> e.g. invalidate_complete_page2():
> 
> /*                                                                               
>  * This is for invalidate_mapping_pages().  That function can be called at       
>  * any time, and is not supposed to throw away dirty pages.  But pages can       
> .....
>        if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
>                 return 0;
> 
>         spin_lock_irqsave(&mapping->tree_lock, flags);
>         if (PageDirty(page))
>                 goto failed;
> ....
> 
> It's not supposed to throw away dirty pages. But
> try_to_release_page() on a dirty page in XFS will currently do just
> that.
> 

If the page is legitimately dirty, shouldn't the underlying buffer be
dirty as well? ISTM that try_to_release_page() (which eventually gets to
try_to_free_buffers()) accommodates the case of a dirty page w/o dirty
buffers by checking the latter state and updating the former. So if the
page has dirty buffers, try_to_release_page() returns 0 and the
invalidate exits with -EBUSY. If the page does not have dirty buffers,
the buffers are dropped, the page dirty state is cancelled and the
invalidate proceeds.

So for XFS this (dirty page && !dirty bufs) state should not exist. A
dirty page should always have dirty buffers and vice versa. For XFS,
therefore, I don't see how this patch affects
invalidate_complete_page2() at all. What am I missing? Is there some
other problematic sequence?

AIUI, the historical warning problem in XFS was because we issued the
warning before/without any similar assessment of the validity of the
dirty state (i.e., we assumed the page should not be dirty in
->releasepage()).

> > Also, it looks like truncate_complete_page() eventually and
> > unconditionally clears the page dirty bit, it just happens after the
> > invalidate -> release attempt sequence that occurs down through
> > do_invalidatepage().
> 
> Right, we just need to do it earlier, but.....
> 
> > IIUC, this was the problem fixed by Jan's patch
> > mentioned above.  Is there any reason we can't do the dirty cancel a
> > little earlier there? Would that also address this problem?
> 
> .... we can't do that in generic code because ext3.
> 
> Essentially, there are ext3 specific behaviours encoded into the generic
> code. We can't fix the generic code because then we break ext3,
> and nobody is going to redesign the ext3 journalling code to fix
> the bogosities it has that require the generic invalidation/release
> paths to work the way they do.
> 

Hmm, I thought the ext3-specific wart was the fact that dirty pages w/o
dirty buffers could exist in the first place (why ->releasepage() must
handle dirty pages), not necessarily that a page being removed had to be
cleaned/invalidated in any particular order. No matter, I probably need
to understand the issue better first...

Brian

> That leaves us with having to work around the filesystem specific
> code in the generic paths in the filesystem specific code...
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
