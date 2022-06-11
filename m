Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA09CCA47C
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbiFKB1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347415AbiFKB1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:13 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4AFC3A4823
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 447CA5EC7E1
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu2-005AO5-U4
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:02 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu2-00ELKc-RR
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC] [PATCH 00/50] xfs: per-ag centric allocation alogrithms
Date:   Sat, 11 Jun 2022 11:26:09 +1000
Message-Id: <20220611012659.3418072-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=oILfHP3yiyU2vDmXYkEA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is "heads up" at this point so that people can see what is
coming down the line and make early comments, not a request to
consider these for merging soon. I may cherry pick some of the
initial AGI/AGF cleanup patches patches for this cycle, but I'll
send them separately if I do. The patch series is based on a
5.19-rc1 kernel.

This series continues the work towards making shrinking a filesystem
possible.  We need to be able to stop operations from taking place
on AGs that need to be removed by a shrink, so before shrink can be
implemented we need to have the infrastructure in place to prevent
incursion into AGs that are going to be, or are in the process, of
being removed from active duty.

The focus of this is making operations that depend on access to AGs
use the perag to access and pin the AG in active use, thereby
creating a barrier we can use to delay shrink until all active uses
have been drained and new uses are prevented.

This series starts by driving the perag down into the AGI, AGF and
AGFL access routines and unifies the perag structure initialisation
with the high level AG header read functions. This largely replaces
the xfs_mount/agno pair that is passed to all these functions with a
perag, and in most places we already have a perag ready to pass in.
There are a few places where perags need to be grabbed before
reading the AG header buffers - some of these will need to be driven
to higher layers to ensure we can run operations on AGs without
getting stuck part way through waiting on a perag reference.

The next section of this patchset moves some of the AG geometry
information from the xfs_mount to the xfs_perag, and starts
converting code that requires geometry validation to use a perag
instead of a mount and having to extract the AGNO from the object
location. This also allows us to store the AG size in the perag and
then we can stop having to compare the agno against sb_agcount to
determine if the AG is the last AG and so has a runt size.  This
greatly simplifies some of the type validity checking we do and
substantially reduces the CPU overhead of type validity checking. It
also cuts over 1.2kB out of the binary size.

The series then starts converting the code to use active references.
Active reference counts are used by high level code that needs to
prevent the AG from being taken out from under it by a shrink
operation. The high level code needs to be able to handle not
getting an active reference gracefully, and the shrink code will
need to wait for active references to drain before continuing.

Active references are implemented just as reference counts right now
- an active reference is taken at perag init during mount, and all
other active references are dependent on the active reference count
being greater than zero. This gives us an initial method of stopping
new active references without needing other infrastructure; just
drop the reference taken at filesystem mount time and when the
refcount then falls to zero no new references can be taken.

In future, this will need to take into account AG control state
(e.g. offline, no alloc, etc) as well as the reference count, but
right now we can implement a basic barrier for shrink with just
reference count manipulations. There are patches to convert the
perag state to atomic opstate fields similar to the xfs_mount and
xlog opstate fields in preparation for this.

The first target for active reference conversion is the
for_each_perag*() iterators. This captures a lot of high level code
that should skip offline AGs, and introduces the ability to
differentiate between a lookup that didn't have an online AG and the
end of the AG iteration range.

From there, the inode allocation AG selection is converted to active
references, and the perag is driven deeper into the inode allocation
and btree code to replace the xfs_mount. Most of the inode
allocation code operates on a single AG once it is selected, hence
it should pass the perag as the primary referenced object around for
allocation, not the xfs_mount. There is a bit of churn here, but it
emphasises that inode allocation is inherently an allocation group
based operation.

Next the bmap/alloc interface undergoes a major untangling,
reworking xfs_bmap_btalloc() into separate allocation operations for
different contexts and failure handling behaviours. This then allows
us to completely remove the xfs_alloc_vextent() layer via
restructuring the xfs_alloc_vextent/xfs_alloc_ag_vextent() into a
set of realtively simple helper function that describe the
allocation that they are doing. e.g.  xfs_alloc_vextent_exact_bno().

This allows the requirements for accessing AGs to be allocation
context dependent. The allocations that require operation on a
single AG generally can't tolerate failure after the allocation
method and AG has been decided on, and hence the caller needs to
manage the active references to ensure the allocation does not race
with shrink removing the selected AG for the duration of the
operation that requires access to that allocation group.

Other allocations iterate AGs and so the first AG is just a hint -
these do not need to pin a perag first as they can tolerate not
being able to access an AG by simply skipping over it. These require
new perag iteration functions that can start at arbitrary AGs and
wrap around at arbitrary AGs, hence a new set for
for_each_perag_wrap*() helpers to do this.

Next is the rework of the filestreams allocator. This doesn't change
any functionality, but gets rid of the unnecessary multi-pass
selection algorithm when the selected AG is not available. It
currently does a lookup pass which might iterate all AGs to select
an AG, then checks if the AG is acceptible and if not does a "new
AG" pass that is essentially identical to the lookup pass. Both of
these scans also do the same "longest extent in AG" check before
selecting an AG as is done after the AG is selected.

IOWs, the filestreams algorithm can be greatly simplified into a
single new AG selection pass if the there is no current association
or the currently associated AG doesn't have enough contiguous free
space for the allocation to proceed.  With this simplification of
the filestreams allocator, it's then trivial to convert it to use
for_each_ag_wrap() for the AG scan algorithm. 

This actually passes auto group fstests with rmapbt=1 with only one
regression - xfs/294 gets ENOSPC earlier and that makes unexpected
output noise. The last patch in the series is needed to fix a AGF
ABBA locking deadlock in g/476 - I only just worked this one out,
and I strongly suspect that it's a pre-existing bug that leaves an
AGF locked after failing to allocate anything from the AG.

This series currently ends at the xfs_bmap_btalloc ->allocator
conversion. There still more to be done here before we can start
disabling AGs for shrink:
- the bmapi layer needs to handle active AG references for exact and
  near allocation
- converting the allocation "firstblock" restrictions to hold an
  actively referenced perag, not a filesystem block address.
- inode cache lookups need to converted to active references
- audits needed to find and convert all the places that we use
  bp->b_pag instead of active references passed from high level
  code.
- addition of a "going offline" opstate and state machine to use for
  rejecting new active references as well as blocking shrink from
  making progress until all active references are gone
- ioctls for changing AG state from userspace
- audit of the freeing code to determine whether it can use passive
  references to allow freeing of blocks (which may require
  allocation!) whilst new allocations are prevented from being run
  on "going offline" AGs. This will allow userspace to stop new
  allocations in AGs to be shrunk before it starts emptying them and
  freeing the space that they have in use.

Cheers,

Dave.

