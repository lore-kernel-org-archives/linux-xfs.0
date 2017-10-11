Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31534 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751910AbdJKL7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 07:59:01 -0400
Date: Wed, 11 Oct 2017 22:58:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: cancel dirty pages on invalidation
Message-ID: <20171011115858.GZ3666@dastard>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-5-david@fromorbit.com>
 <20171009142445.GE18663@bfoster.bfoster>
 <20171009204816.GN3666@dastard>
 <20171010122945.GB23057@bfoster.bfoster>
 <20171011000400.GW3666@dastard>
 <20171011090219.GA32909@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011090219.GA32909@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 05:02:20AM -0400, Brian Foster wrote:
> On Wed, Oct 11, 2017 at 11:04:00AM +1100, Dave Chinner wrote:
> > On Tue, Oct 10, 2017 at 08:29:45AM -0400, Brian Foster wrote:
> > > On Tue, Oct 10, 2017 at 07:48:16AM +1100, Dave Chinner wrote:
> > > > On Mon, Oct 09, 2017 at 10:24:46AM -0400, Brian Foster wrote:
> > > > > On Mon, Oct 09, 2017 at 10:54:14AM +1100, Dave Chinner wrote:
> > shrink_inactive_list
> >   shrink_list
> >     buffer_heads_over_limit
> >       try_to_release_page
> >         xfs_vm_releasepage()
> > 	  xfs_count_page_state   <<< finds delalloc/unwritten buffer
> > 	  WARN_ON(delalloc)
> > 
> 
> The xfs_vm_releasepage() code looks like this:
> 
> 	...
>         xfs_count_page_state(page, &delalloc, &unwritten);
> 
>         if (delalloc) {
>                 WARN_ON_ONCE(!PageDirty(page));
>                 return 0;
>         }
> 	...
> 
> So if we get here with a dirty page over a delalloc extent, for example,
> how exactly does that trigger a spurious warning? AFAICT the warning
> will not trigger because the page is dirty. We decide not to release the
> page precisely because it has delalloc buffers.

And, you know, it's not until you pasted it here that I saw the
"!" in that WARN_ON_ONCE.

I've looked at repeatedly over many weeks, and not *once* have I
registered that it's a "NOT page dirty" warning.

So we can ignore the spurious warning issue. You're right, that
clearly doesn't happen.

But, realistically, we shouldn't be relying on bufferhead state to
determine what the correct action to take is. We can still have
dirty pages that do not have delalloc or unwritten extents on them
that we should not be attempting to free. The current code happily
hands them to try_to_free_buffers() rather than says "no, we don't
free dirty pages".

i.e. if xfs_invalidatepage() is trashing the dirty state on the
buffers, then we should also be trashing the dirty state on the page
so they are clean and coherent when passed to xfs_vm_releasepage.
That leaves us with the simple rule in xfs_vm_releasepage():

	Never release a dirty page because they always contain valid
	data that needs to be written back first.

That's what I'm trying to do - move the control decisions to page
level, rather than having them split and, at times, be incoherent
at bufferhead level. We're wanting to get rid of bufferheads so we
should be making decisions in this code based on page state, not
the bufferhead state...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
