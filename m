Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753359AbdLHOUW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Dec 2017 09:20:22 -0500
Date: Fri, 8 Dec 2017 09:20:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 3/4] xfs: defer agfl block frees on extent frees
Message-ID: <20171208142020.GD55826@bfoster.bfoster>
References: <20171207185810.48757-1-bfoster@redhat.com>
 <20171207185810.48757-4-bfoster@redhat.com>
 <20171207224941.GK4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207224941.GK4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 08, 2017 at 09:49:41AM +1100, Dave Chinner wrote:
> On Thu, Dec 07, 2017 at 01:58:09PM -0500, Brian Foster wrote:
> > Defer AGFL block frees from deferred extent free context. This means
> > that extents that are deferred freed via xfs_bmap_add_free() will
> > add additional deferred items for AGFL block frees during completion
> > processing. All such items complete before xfs_defer_finish()
> > returns.
> > 
> > Update xfs_trans_free_extent() and xfs_free_extent() to receive an
> > optional dfops pointer and pass it down to the AGFL fixup code via
> > the allocation arguments structure. Update
> > xfs_extent_free_finish_item() to pass along the dfops list currently
> > being processed by xfs_defer_finish(). All other callers pass a NULL
> > dfops and so do not change behavior.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c          | 9 ++++++---
> >  fs/xfs/libxfs/xfs_alloc.h          | 5 +++--
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
> >  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
> >  fs/xfs/libxfs/xfs_rmap.c           | 2 +-
> >  fs/xfs/xfs_extfree_item.c          | 2 +-
> >  fs/xfs/xfs_fsops.c                 | 2 +-
> >  fs/xfs/xfs_trans.h                 | 3 ++-
> >  fs/xfs/xfs_trans_extfree.c         | 7 ++++---
> >  9 files changed, 20 insertions(+), 14 deletions(-)
> 
> Rather than passing the dfops structure around, I'm starting to
> wonder it it makes more sense to attach it to the struct xfs_trans
> we pass around to all these functions? That would mean it doesn't
> need to be manually plumbed into any of this code - it would be
> directly available in any transaction context that has a dfops
> associated with it.
> 

Yeah, that sounds like a nice cleanup.

> That would mean all agfl fixups would be able to be deferred without
> modifying any of the intermediate code paths as all allocation/free
> transactions require a dfops structure....
> 

Ok.. so separate from the refactoring, it sounds like you're suggesting
that we should try to always defer AGFL frees rather than doing so very
selectively (as the current code does). I may still try to implement
that incrementally, but I suppose that may depend on what falls out from
the above cleanup. Otherwise that sounds reasonable to me.

I'm heading into some time off, but I'll look more into the above and
other fixups once I get back to this. Thanks for the review!

Brian

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
