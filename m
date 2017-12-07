Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64005 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752296AbdLGWtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 17:49:46 -0500
Date: Fri, 8 Dec 2017 09:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 3/4] xfs: defer agfl block frees on extent frees
Message-ID: <20171207224941.GK4094@dastard>
References: <20171207185810.48757-1-bfoster@redhat.com>
 <20171207185810.48757-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207185810.48757-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 07, 2017 at 01:58:09PM -0500, Brian Foster wrote:
> Defer AGFL block frees from deferred extent free context. This means
> that extents that are deferred freed via xfs_bmap_add_free() will
> add additional deferred items for AGFL block frees during completion
> processing. All such items complete before xfs_defer_finish()
> returns.
> 
> Update xfs_trans_free_extent() and xfs_free_extent() to receive an
> optional dfops pointer and pass it down to the AGFL fixup code via
> the allocation arguments structure. Update
> xfs_extent_free_finish_item() to pass along the dfops list currently
> being processed by xfs_defer_finish(). All other callers pass a NULL
> dfops and so do not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          | 9 ++++++---
>  fs/xfs/libxfs/xfs_alloc.h          | 5 +++--
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
>  fs/xfs/libxfs/xfs_rmap.c           | 2 +-
>  fs/xfs/xfs_extfree_item.c          | 2 +-
>  fs/xfs/xfs_fsops.c                 | 2 +-
>  fs/xfs/xfs_trans.h                 | 3 ++-
>  fs/xfs/xfs_trans_extfree.c         | 7 ++++---
>  9 files changed, 20 insertions(+), 14 deletions(-)

Rather than passing the dfops structure around, I'm starting to
wonder it it makes more sense to attach it to the struct xfs_trans
we pass around to all these functions? That would mean it doesn't
need to be manually plumbed into any of this code - it would be
directly available in any transaction context that has a dfops
associated with it.

That would mean all agfl fixups would be able to be deferred without
modifying any of the intermediate code paths as all allocation/free
transactions require a dfops structure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
