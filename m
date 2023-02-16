Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB21C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBPVnp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPVno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:43:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B03B3CF
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3732F60C8B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E9DC433D2;
        Thu, 16 Feb 2023 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676583821;
        bh=TwaX1D2IXvGhIKlJlZqcO0Ygr4sPSkUYB5UeRiOGpzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBc7Gs0ARDvZZlJZQ2PSFOn0Iou3R0AepkFcYKSNCnZ0vj9IZhnpb8MBlLEM9xG26
         GXXGvtxm8VYQDKh6DGa6U9u169uh5oqSK5o4Q5UY2AQao/6bZ09iSTTLeExQNvrMTt
         7N0fQdV5JR4OQVULoMgqM+bgOh40TwYkqkBXWdhEWKnmvoOiRqs+16iHTIzbyhDcU6
         TpSCozjJVGCgoBYig6udFjtN753VIBdUCx1vOGX3j7pI8EV0opzXaiCACaxHkoar12
         IVF9264jPcIEEh5rytp7/l+4zNklog3jZiVCxcgCOwfNlIy+jie5blxUBLpumEqFkP
         hjAaBCC19Ud8g==
Date:   Thu, 16 Feb 2023 13:43:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: per-ag centric allocation algorithms
Message-ID: <Y+6jjQj63en2seA5@magnolia>
References: <20230215011109.GO360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215011109.GO360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 15, 2023 at 12:11:09PM +1100, Dave Chinner wrote:
> Hi Darrick,
> 
> As you requested yesterday on #xfs, please find below a pull request
> for the allocator rework series. It is unchanged from the last
> version I posted except for updates to RVB tags and a rebase on the
> current linux-xfs/for-next branch. Details of the changes made in
> the series are captured in the tag identifying the branch for you to
> pull.
> 
> PLease let me know if I've screwed anything up in the tree or
> commit metadata and I'll get them sorted ASAP.

Pulled, thanks.

--D

> 
> Cheers,
> 
> Dave.
> 
> ---
> 
> The following changes since commit dd07bb8b6baf2389caff221f043d9188ce6bab8c:
> 
>   xfs: revert commit 8954c44ff477 (2023-02-10 09:06:06 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-alloc-perag-conversion
> 
> for you to fetch changes up to bd4f5d09cc93c8ca51e4efea86ac90a4bb553d6e:
> 
>   xfs: refactor the filestreams allocator pick functions (2023-02-13 09:14:56 +1100)
> 
> ----------------------------------------------------------------
> xfs: per-ag centric allocation alogrithms
> 
> This series continues the work towards making shrinking a filesystem
> possible.  We need to be able to stop operations from taking place
> on AGs that need to be removed by a shrink, so before shrink can be
> implemented we need to have the infrastructure in place to prevent
> incursion into AGs that are going to be, or are in the process, of
> being removed from active duty.
> 
> The focus of this is making operations that depend on access to AGs
> use the perag to access and pin the AG in active use, thereby
> creating a barrier we can use to delay shrink until all active uses
> of an AG have been drained and new uses are prevented.
> 
> This series starts by fixing some existing issues that are exposed
> by changes later in the series. They stand alone, so can be picked
> up independently of the rest of this patchset.
> 
> The most complex of these fixes is cleaning up the mess that is the
> AGF deadlock avoidance algorithm. This algorithm stores the first
> block that is allocated in a transaction in tp->t_firstblock, then
> uses this to try to limit future allocations within the transaction
> to AGs at or higher than the filesystem block stored in
> tp->t_firstblock. This depends on one of the initial bug fixes in
> the series to move the deadlock avoidance checks to
> xfs_alloc_vextent(), and then builds on it to relax the constraints
> of the avoidance algorithm to only be active when a deadlock is
> possible.
> 
> We also update the algorithm to record allocations from higher AGs
> that are allocated from, because we when we need to lock more than
> two AGs we still have to ensure lock order is correct. Therefore we
> can't lock AGs in the order 1, 3, 2, even though tp->t_firstblock
> indicates that we've allocated from AG 1 and so AG is valid to lock.
> It's not valid, because we already hold AG 3 locked, and so
> tp->t-first_block should actually point at AG 3, not AG 1 in this
> situation.
> 
> It should now be obvious that the deadlock avoidance algorithm
> should record AGs, not filesystem blocks. So the series then changes
> the transaction to store the highest AG we've allocated in rather
> than a filesystem block we allocated.  This makes it obvious what
> the constraints are, and trivial to update as we lock and allocate
> from various AGs.
> 
> With all the bug fixes out of the way, the series then starts
> converting the code to use active references. Active reference
> counts are used by high level code that needs to prevent the AG from
> being taken out from under it by a shrink operation. The high level
> code needs to be able to handle not getting an active reference
> gracefully, and the shrink code will need to wait for active
> references to drain before continuing.
> 
> Active references are implemented just as reference counts right now
> - an active reference is taken at perag init during mount, and all
> other active references are dependent on the active reference count
> being greater than zero. This gives us an initial method of stopping
> new active references without needing other infrastructure; just
> drop the reference taken at filesystem mount time and when the
> refcount then falls to zero no new references can be taken.
> 
> In future, this will need to take into account AG control state
> (e.g. offline, no alloc, etc) as well as the reference count, but
> right now we can implement a basic barrier for shrink with just
> reference count manipulations. As such, patches to convert the perag
> state to atomic opstate fields similar to the xfs_mount and xlog
> opstate fields follow the initial active perag reference counting
> patches.
> 
> The first target for active reference conversion is the
> for_each_perag*() iterators. This captures a lot of high level code
> that should skip offline AGs, and introduces the ability to
> differentiate between a lookup that didn't have an online AG and the
> end of the AG iteration range.
> 
> From there, the inode allocation AG selection is converted to active
> references, and the perag is driven deeper into the inode allocation
> and btree code to replace the xfs_mount. Most of the inode
> allocation code operates on a single AG once it is selected, hence
> it should pass the perag as the primary referenced object around for
> allocation, not the xfs_mount. There is a bit of churn here, but it
> emphasises that inode allocation is inherently an allocation group
> based operation.
> 
> Next the bmap/alloc interface undergoes a major untangling,
> reworking xfs_bmap_btalloc() into separate allocation operations for
> different contexts and failure handling behaviours. This then allows
> us to completely remove the xfs_alloc_vextent() layer via
> restructuring the xfs_alloc_vextent/xfs_alloc_ag_vextent() into a
> set of realtively simple helper function that describe the
> allocation that they are doing. e.g.  xfs_alloc_vextent_exact_bno().
> 
> This allows the requirements for accessing AGs to be allocation
> context dependent. The allocations that require operation on a
> single AG generally can't tolerate failure after the allocation
> method and AG has been decided on, and hence the caller needs to
> manage the active references to ensure the allocation does not race
> with shrink removing the selected AG for the duration of the
> operation that requires access to that allocation group.
> 
> Other allocations iterate AGs and so the first AG is just a hint -
> these do not need to pin a perag first as they can tolerate not
> being able to access an AG by simply skipping over it. These require
> new perag iteration functions that can start at arbitrary AGs and
> wrap around at arbitrary AGs, hence a new set for
> for_each_perag_wrap*() helpers to do this.
> 
> Next is the rework of the filestreams allocator. This doesn't change
> any functionality, but gets rid of the unnecessary multi-pass
> selection algorithm when the selected AG is not available. It
> currently does a lookup pass which might iterate all AGs to select
> an AG, then checks if the AG is acceptible and if not does a "new
> AG" pass that is essentially identical to the lookup pass. Both of
> these scans also do the same "longest extent in AG" check before
> selecting an AG as is done after the AG is selected.
> 
> IOWs, the filestreams algorithm can be greatly simplified into a
> single new AG selection pass if the there is no current association
> or the currently associated AG doesn't have enough contiguous free
> space for the allocation to proceed.  With this simplification of
> the filestreams allocator, it's then trivial to convert it to use
> for_each_perag_wrap() for the AG scan algorithm.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> ----------------------------------------------------------------
> Dave Chinner (42):
>       xfs: fix low space alloc deadlock
>       xfs: prefer free inodes at ENOSPC over chunk allocation
>       xfs: block reservation too large for minleft allocation
>       xfs: drop firstblock constraints from allocation setup
>       xfs: t_firstblock is tracking AGs not blocks
>       xfs: don't assert fail on transaction cancel with deferred ops
>       xfs: active perag reference counting
>       xfs: rework the perag trace points to be perag centric
>       xfs: convert xfs_imap() to take a perag
>       xfs: use active perag references for inode allocation
>       xfs: inobt can use perags in many more places than it does
>       xfs: convert xfs_ialloc_next_ag() to an atomic
>       xfs: perags need atomic operational state
>       xfs: introduce xfs_for_each_perag_wrap()
>       xfs: rework xfs_alloc_vextent()
>       xfs: factor xfs_alloc_vextent_this_ag() for  _iterate_ags()
>       xfs: combine __xfs_alloc_vextent_this_ag and  xfs_alloc_ag_vextent
>       xfs: use xfs_alloc_vextent_this_ag() where appropriate
>       xfs: factor xfs_bmap_btalloc()
>       xfs: use xfs_alloc_vextent_first_ag() where appropriate
>       xfs: use xfs_alloc_vextent_start_bno() where appropriate
>       xfs: introduce xfs_alloc_vextent_near_bno()
>       xfs: introduce xfs_alloc_vextent_exact_bno()
>       xfs: introduce xfs_alloc_vextent_prepare()
>       xfs: move allocation accounting to xfs_alloc_vextent_set_fsbno()
>       xfs: fold xfs_alloc_ag_vextent() into callers
>       xfs: move the minimum agno checks into xfs_alloc_vextent_check_args
>       xfs: convert xfs_alloc_vextent_iterate_ags() to use perag walker
>       xfs: convert trim to use for_each_perag_range
>       xfs: factor out filestreams from xfs_bmap_btalloc_nullfb
>       xfs: get rid of notinit from xfs_bmap_longest_free_extent
>       xfs: use xfs_bmap_longest_free_extent() in filestreams
>       xfs: move xfs_bmap_btalloc_filestreams() to xfs_filestreams.c
>       xfs: merge filestream AG lookup into xfs_filestream_select_ag()
>       xfs: merge new filestream AG selection into xfs_filestream_select_ag()
>       xfs: remove xfs_filestream_select_ag() longest extent check
>       xfs: factor out MRU hit case in xfs_filestream_select_ag
>       xfs: track an active perag reference in filestreams
>       xfs: use for_each_perag_wrap in xfs_filestream_pick_ag
>       xfs: pass perag to filestreams tracing
>       xfs: return a referenced perag from filestreams allocator
>       xfs: refactor the filestreams allocator pick functions
> 
>  fs/xfs/libxfs/xfs_ag.c             |  93 ++++-
>  fs/xfs/libxfs/xfs_ag.h             | 111 +++++-
>  fs/xfs/libxfs/xfs_ag_resv.c        |   2 +-
>  fs/xfs/libxfs/xfs_alloc.c          | 683 +++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_alloc.h          |  61 ++--
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   2 +-
>  fs/xfs/libxfs/xfs_bmap.c           | 664 +++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_bmap.h           |   7 +
>  fs/xfs/libxfs/xfs_bmap_btree.c     |  64 ++--
>  fs/xfs/libxfs/xfs_btree.c          |   2 +-
>  fs/xfs/libxfs/xfs_ialloc.c         | 241 ++++++-------
>  fs/xfs/libxfs/xfs_ialloc.h         |   5 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  47 ++-
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |  20 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c |  10 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   2 +-
>  fs/xfs/libxfs/xfs_sb.c             |   3 +-
>  fs/xfs/scrub/agheader_repair.c     |  35 +-
>  fs/xfs/scrub/bmap.c                |   2 +-
>  fs/xfs/scrub/common.c              |  21 +-
>  fs/xfs/scrub/fscounters.c          |  13 +-
>  fs/xfs/scrub/repair.c              |   7 +-
>  fs/xfs/xfs_bmap_util.c             |   2 +-
>  fs/xfs/xfs_discard.c               |  50 ++-
>  fs/xfs/xfs_filestream.c            | 455 ++++++++++++------------
>  fs/xfs/xfs_filestream.h            |   6 +-
>  fs/xfs/xfs_fsmap.c                 |   4 +-
>  fs/xfs/xfs_icache.c                |   8 +-
>  fs/xfs/xfs_inode.c                 |   2 +-
>  fs/xfs/xfs_iwalk.c                 |  10 +-
>  fs/xfs/xfs_mount.h                 |   3 +-
>  fs/xfs/xfs_reflink.c               |   4 +-
>  fs/xfs/xfs_super.c                 |  47 +--
>  fs/xfs/xfs_trace.h                 |  81 ++---
>  fs/xfs/xfs_trans.c                 |   8 +-
>  fs/xfs/xfs_trans.h                 |   2 +-
>  36 files changed, 1534 insertions(+), 1243 deletions(-)
> -- 
> Dave Chinner
> david@fromorbit.com
