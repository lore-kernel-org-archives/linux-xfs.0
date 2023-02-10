Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C8CC61DA4
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 03:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBJDKA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 22:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBJDKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 22:10:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970152597A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 19:09:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2371761C61
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 03:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C06C433EF;
        Fri, 10 Feb 2023 03:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675998597;
        bh=TF3mtiKBmAhnhKNcG0ZT9cucY7UybHgg6vVy1lpxUBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FgqsZpMamvi/KI8/R2B2te6+yniLRzzBYYoWalFnVxV8os4GH6aG1ou1UKeBxeYxj
         uTAapZKYvIjASFLUYV/k8XIfYBmKpJnv9xwjBz05vsghFtNdAb8aeyB5V0pKS90Dht
         dkrO4fa2nn7rCKbsR2CeJ0hoqDiYsLqcOWoHPNEaJ/vYNecxQQaDruNrmqX+QTZ5J/
         TbaqqdNag1jNu4T/pQsTWn+9J4JVSEPwxddM/RausosSeJr5mfE1TqjsbGUgSqt/do
         Bw0UsWdJPKAPcTYvPb2LqMs3fE9Rrl9foKCfMbFdRDZsT00hePAO6BIB/UCfUgN/hx
         wEEcxNqO1FKTQ==
Date:   Thu, 9 Feb 2023 19:09:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 00/42] xfs: per-ag centric allocation alogrithms
Message-ID: <Y+W1hDsoWiaCVqlB@magnolia>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 10, 2023 at 09:17:43AM +1100, Dave Chinner wrote:
> This series continues the work towards making shrinking a filesystem possible.
> We need to be able to stop operations from taking place on AGs that need to be
> removed by a shrink, so before shrink can be implemented we need to have the
> infrastructure in place to prevent incursion into AGs that are going to be, or
> are in the process, of being removed from active duty.

From a quick glance, it looks like all the random things I had comments
about were fixed, so for patches 14, 20-23, 28, and 42:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I'm leaving off patch #7 until tomorrow so that I can think about it
with a non-tired brain.  I didn't see anything obviously wrong in the
diff itself -- but I still need to adjust my mental model per what Dave
said in his previously reply (active perag refs are for user-facing
online operations, passive refs are for internal operations) and
(re)examine how that relates to scrub and repair.

Mostly I tripped over "but repair needs to use passive references once
the AG has had it's state changed to "offline" -- currently, repair uses
the same perag reference that scrub _gets.  If scrub now gets an
"active" reference and something needs repair, do we mark the AG offline
and keep the active reference?  Or downgrade it to a passive reference?

I've (tried to) design scrub & repair as if they were just another pile
of higher level code that uses libxfs to manipulate metadata, just like
fallocate and reflink and all those types of things.  But then, I was
designing for a world where there's only one type of AG reference. :)

Ok, hungry now, wandering off in search of dinner...

--D

> The focus of this is making operations that depend on access to AGs use the
> perag to access and pin the AG in active use, thereby creating a barrier we can
> use to delay shrink until all active uses of an AG have been drained and new
> uses are prevented.
> 
> This series starts by fixing some existing issues that are exposed by changes
> later in the series. They stand alone, so can be picked up independently of the
> rest of this patchset.
> 
> The most complex of these fixes is cleaning up the mess that is the AGF deadlock
> avoidance algorithm. This algorithm stores the first block that is allocated in
> a transaction in tp->t_firstblock, then uses this to try to limit future
> allocations within the transaction to AGs at or higher than the filesystem block
> stored in tp->t_firstblock. This depends on one of the initial bug fixes in the
> series to move the deadlock avoidance checks to xfs_alloc_vextent(), and then
> builds on it to relax the constraints of the avoidance algorithm to only be
> active when a deadlock is possible.
> 
> We also update the algorithm to record allocations from higher AGs that are
> allocated from, because we when we need to lock more than two AGs we still have
> to ensure lock order is correct. Therefore we can't lock AGs in the order 1, 3,
> 2, even though tp->t_firstblock indicates that we've allocated from AG 1 and so
> AG is valid to lock. It's not valid, because we already hold AG 3 locked, and so
> tp->t-first_block should actually point at AG 3, not AG 1 in this situation.
> 
> It should now be obvious that the deadlock avoidance algorithm should record
> AGs, not filesystem blocks. So the series then changes the transaction to store
> the highest AG we've allocated in rather than a filesystem block we allocated.
> This makes it obvious what the constraints are, and trivial to update as we
> lock and allocate from various AGs.
> 
> With all the bug fixes out of the way, the series then starts converting the
> code to use active references. Active reference counts are used by high level
> code that needs to prevent the AG from being taken out from under it by a shrink
> operation. The high level code needs to be able to handle not getting an active
> reference gracefully, and the shrink code will need to wait for active
> references to drain before continuing.
> 
> Active references are implemented just as reference counts right now - an active
> reference is taken at perag init during mount, and all other active references
> are dependent on the active reference count being greater than zero. This gives
> us an initial method of stopping new active references without needing other
> infrastructure; just drop the reference taken at filesystem mount time and when
> the refcount then falls to zero no new references can be taken.
> 
> In future, this will need to take into account AG control state (e.g. offline,
> no alloc, etc) as well as the reference count, but right now we can implement
> a basic barrier for shrink with just reference count manipulations. As such,
> patches to convert the perag state to atomic opstate fields similar to the
> xfs_mount and xlog opstate fields follow the initial active perag reference
> counting patches.
> 
> The first target for active reference conversion is the for_each_perag*()
> iterators. This captures a lot of high level code that should skip offline AGs,
> and introduces the ability to differentiate between a lookup that didn't have an
> online AG and the end of the AG iteration range.
> 
> From there, the inode allocation AG selection is converted to active references,
> and the perag is driven deeper into the inode allocation and btree code to
> replace the xfs_mount. Most of the inode allocation code operates on a single AG
> once it is selected, hence it should pass the perag as the primary referenced
> object around for allocation, not the xfs_mount. There is a bit of churn here,
> but it emphasises that inode allocation is inherently an allocation group based
> operation.
> 
> Next the bmap/alloc interface undergoes a major untangling, reworking
> xfs_bmap_btalloc() into separate allocation operations for different contexts
> and failure handling behaviours. This then allows us to completely remove
> the xfs_alloc_vextent() layer via restructuring the
> xfs_alloc_vextent/xfs_alloc_ag_vextent() into a set of realtively simple helper
> function that describe the allocation that they are doing. e.g.
> xfs_alloc_vextent_exact_bno().
> 
> This allows the requirements for accessing AGs to be allocation context
> dependent. The allocations that require operation on a single AG generally can't
> tolerate failure after the allocation method and AG has been decided on, and
> hence the caller needs to manage the active references to ensure the allocation
> does not race with shrink removing the selected AG for the duration of the
> operation that requires access to that allocation group.
> 
> Other allocations iterate AGs and so the first AG is just a hint - these do
> not need to pin a perag first as they can tolerate not being able to access an
> AG by simply skipping over it. These require new perag iteration functions that
> can start at arbitrary AGs and wrap around at arbitrary AGs, hence a new set for
> for_each_perag_wrap*() helpers to do this.
> 
> Next is the rework of the filestreams allocator. This doesn't change any
> functionality, but gets rid of the unnecessary multi-pass selection algorithm
> when the selected AG is not available. It currently does a lookup pass which might
> iterate all AGs to select an AG, then checks if the AG is acceptible and if not
> does a "new AG" pass that is essentially identical to the lookup pass. Both of
> these scans also do the same "longest extent in AG" check before selecting an AG
> as is done after the AG is selected.
> 
> IOWs, the filestreams algorithm can be greatly simplified into a single new AG
> selection pass if the there is no current association or the currently
> associated AG doesn't have enough contiguous free space for the allocation to
> proceed.  With this simplification of the filestreams allocator, it's then
> trivial to convert it to use for_each_perag_wrap() for the AG scan algorithm.
> 
> This series passes auto group fstests with rmapbt=1 on both 1kB and 4kB block
> size configurations without functional or performance regressions. In some cases
> ENOSPC behaviour is improved, but fstests does not capture those improvements as
> it only tests for regressions in behaviour.
> 
> Version 3:
> - rebased on current linux-xfs/for-next
> - various whitespace and typo cleanups.
> - fixed missing error return from xfs_bmap_btalloc_select_lengths().
> - changed git diff algorithm to "patience" for better readability.
> - replaced xfs_rfsblock_t with xfs_fsblock_t.
> - removed stray trace_printk() debugging code.
> - Added assert to ensure we don't leak perag references out of the
>   xfs_alloc_vextent_start_ag() iterator.
> - changed trylock flag in xfs_filestream_pick_ag() to a boolean to reflect the way
>   it is used now.
> 
> Version 2:
> - https://lore.kernel.org/linux-xfs/20230118224505.1964941-1-david@fromorbit.com/
> - AGI, AGF and AGFL access conversion patches removed due to being merged.
> - AG geometry conversion patches removed due to being merged
> - Rebase on 6.2-rc4
> - fixed "firstblock" AGF deadlock avoidance algorithm
> - lots of cleanups and bug fixes.
> 
> Version 1 [RFC]:
> - https://lore.kernel.org/linux-xfs/20220611012659.3418072-1-david@fromorbit.com/
> 
