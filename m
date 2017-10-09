Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:11089 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755084AbdJIUsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 16:48:21 -0400
Date: Tue, 10 Oct 2017 07:48:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: cancel dirty pages on invalidation
Message-ID: <20171009204816.GN3666@dastard>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-5-david@fromorbit.com>
 <20171009142445.GE18663@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009142445.GE18663@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 10:24:46AM -0400, Brian Foster wrote:
> On Mon, Oct 09, 2017 at 10:54:14AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recently we've had warnings arise from the vm handing us pages
> > without bufferheads attached to them. This should not ever occur
> > in XFS, but we don't defend against it properly if it does. The only
> > place where we remove bufferheads from a page is in
> > xfs_vm_releasepage(), but we can't tell the difference here between
> > "page is dirty so don't release" and "page is dirty but is being
> > invalidated so release it".
> > 
> 
> Ok, so we changed ->releasepage() in 99579ccec4 ("xfs: skip dirty pages
> in ->releasepage()") to deal with the fact that the mm can send
> legitimately dirty pages to ->releasepage(). That was apparently too
> aggressive a change because truncated pages would also end up skipped
> because the dirty bit is not cleared by the time the release occurs.
> Commit 0a417b8dc1 ("xfs: Timely free truncated dirty pages") modified
> ->releasepage() again to not skip all dirty pages and only warn for
> delalloc/unwritten blocks on clean pages.
> 
> That was apparently insufficient because we have some codepaths where
> not skipping dirty pages can allow us to strip the buffers from a page
> incorrectly...

Right, Jan's patch fixed the truncate problem but re-opened the
memory reclaim hole. It effectively reverted the original patch.

> > In some places that are invalidating pages ask for pages to be
> > released and follow up afterward calling ->releasepage by checking
> > whether the page was dirty and then aborting the invalidation. This
> > is a possible vector for releasing buffers from a page but then
> > leaving it in the mapping, so we really do need to avoid dirty pages
> > in xfs_vm_releasepage().
> > 
> 
> ... but I'm having a hard time parsing that first sentence to understand
> how that is. Can you elaborate on and/or give a specific reference to
> this problematic invalidation abort sequence?

e.g. invalidate_complete_page2():

/*                                                                               
 * This is for invalidate_mapping_pages().  That function can be called at       
 * any time, and is not supposed to throw away dirty pages.  But pages can       
.....
       if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
                return 0;

        spin_lock_irqsave(&mapping->tree_lock, flags);
        if (PageDirty(page))
                goto failed;
....

It's not supposed to throw away dirty pages. But
try_to_release_page() on a dirty page in XFS will currently do just
that.

> Also, it looks like truncate_complete_page() eventually and
> unconditionally clears the page dirty bit, it just happens after the
> invalidate -> release attempt sequence that occurs down through
> do_invalidatepage().

Right, we just need to do it earlier, but.....

> IIUC, this was the problem fixed by Jan's patch
> mentioned above.  Is there any reason we can't do the dirty cancel a
> little earlier there? Would that also address this problem?

.... we can't do that in generic code because ext3.

Essentially, there are ext3 specific behaviours encoded into the generic
code. We can't fix the generic code because then we break ext3,
and nobody is going to redesign the ext3 journalling code to fix
the bogosities it has that require the generic invalidation/release
paths to work the way they do.

That leaves us with having to work around the filesystem specific
code in the generic paths in the filesystem specific code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
