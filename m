Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47ECAC43462
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C0B56139A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhESBWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:22:25 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58762 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231820AbhESBWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:24 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id BC3DF80B225
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-002bNq-5c
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtS-001tJl-Sa
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/23] xfs: initial agnumber -> perag conversions for shrink
Date:   Wed, 19 May 2021 11:20:39 +1000
Message-Id: <20210519012102.450926-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=bSj046LXVP3Y7hs3GGYA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Version 2:
- remove xfs_trace.h from xfs_sb.c
- fixed error handling in xfs_initialize_perag()
- fixed extra _put() in xchk_fscount_aggregate_agcounts()
- fixed missing _put in xchk_bmap_check_rmaps()
- updated commit message for passing perags to  reservation callouts
- added comment to libxfs/xfs_btree.h explaining the use of
  XFS_BTREE_LONG_PTRS when determining whether the cursor has a
  perag it needs to drop the reference to.
- fixed incorrect okalloc logic when selecting an AG to allocate
  from.
- updated comment about inode AG selection needspace calculation.
- made xfs_dialloc_ag() static (thanks Kernel Test Robot!)
- remove xfs_perag_t typedef (new patch).

----

Hi folks,

After I proposed that we use active references to the perag to be
able to gate shrink removing AGs and hence perags safely, it was
obvious that we've got a fair bit of work to do actually use perags
in all the places we need to.

There's a lot of code right now that iterates ag numbers and then
looks up perags from that, often multiple times for the same perag
in the one operation. IF we want to use reference counted perags for
access control, then we nee dto convert all these uses to perag
iterators, not agno iterators.

This patchset does not include any of the active/passive reference
counting needed for shrink gating - we have to get perags in use in
all the palces we need first before that will work effectively, and
that's what this patchset starts to address.

It's also been clear as I've been doing these conversions that
having a perag available in places that are doing AG specific work
allows for significant cleanups and optimisations to be made. One
such example is fleshed out in this patch (inode allocation), but
there are many more if we do things like start moving AG geometry
information into the perag. This means we no longer need to run a
calculation to determine what the size of the AG is, which is
important because the verify functions consume a large amount
of CPU doing exactly this sort of check on block and inode numbers
throughout the code.

It also leads to repeated patterns where we have a perag in hand
before we have to read an AGI or AGF buffer to lock the AG for the
operation we are about to perform. There are many optimisations on
both the buffer caching and AG locking strategies that we can build
on from this. e.g. moving AGI/AGF locking into the pag rather than
using the buffer lock, doing pag+agbno based buffer cache lookups
instead of daddr based lookups that then have to look up the pag,
etc.

IOWs, this turns a lot of the code we have on it's head and there's
significant potential for code simplification and algorithmic
optimisations to be made as a result. A lot of this sort of thing
will be medium term work rather than done up front - shrink is the
initial priority, so widespread conversion comes first.

[Patches 1-4]

The first step of this is consolidating all the perag management -
init, free, get, put, etc into a common location. THis is spread all
over the place right now, so move it all into libxfs/xfs_ag.[ch].
This does expose kernel only bits of the perag to libxfs and hence
userspace, so the structures and code is rearranged to minimise the
number of ifdefs that need to be added to the userspace codebase.
The perag iterator in xfs_icache.c is promoted to a first class API
and expanded to the needs of the code as required.

[Patches 5-10]

These are the first basic perag iterator conversions and changes to
pass the perag down the stack from those iterators where
appropriate. A lot of this is obvious, simple changes, though in
some places we stop passing the perag down the stack because the
code enters into an as yet unconverted subsystem that still uses raw
AGs.

[Patches 11-16]

These replace the agno passed in the btree cursor for per-ag btree
operations with a perag that is passed to the cursor init function.
The cursor takes it's own reference to the perag, and the reference
is dropped when the cursor is deleted. Hence we get reference
coverage for the entire time the cursor is active, even if the code
that initialised the cursor drops it's reference before the cursor
or any of it's children (duplicates) have been deleted.

The first patch adds the perag infrastructure for the cursor, the
next four patches convert a btree cursor at a time, and the last
removes the agno from the cursor once it is unused.

[Patches 17-21]

These patches are a demonstration of the simplifications and
cleanups that come from plumbing the perag through interfaces that
select and then operate on a specific AG. In this case the inode
allocation algorithm does up to three walks across all AGs before it
either allocates an inode or fails. Two of these walks are purely
just to select the AG, and even then it doesn't guarantee inode
allocation success so there's a third walk if the selected AG
allocation fails.

These patches collapse the selection and allocation into a single
loop, simplifies the error handling because xfs_dir_ialloc() always
returns ENOSPC if no AG was selected for inode allocation or we fail
to allocate an inode in any AG, gets rid of xfs_dir_ialloc()
wrapper, converts inode allocation to run entirely from a single
perag instance, and then factors xfs_dialloc() into a much, much
simpler loop which is easy to understand.

Hence we end up with the same inode allocation logic, but it only
needs two complete iterations at worst, makes AG selection and
allocation atomic w.r.t. shrink and chops out out over 100 lines of
code from this hot code path.

[Patch 22]

Converts the unlink path to pass perags through it.

There's more conversion work to be done, but this patchset gets
through a large chunk of it in one hit. Most of the iterators are
converted, so once this is solidified we can move on to converting
these to active references for being able to free perags while the
fs is still active.

Indeed, this allows more than just shrink - if we can safely detect
a perag is unreferenced and take it out of service, we have the
infrastructure we need to be able to implement a memory shrinker for
perags. That is a big step towards supporting extremely large
numbers of AGs in the filesystem - we can't really support millions
of AGs in a filesystem if they must all be loading into memory at
all times. We can already do demand based initialisation of perags,
but we cannot do memory pressure based reclaim. Reference counting
for shrink gives us the necessary capability for demand based
reclaim of perags....

This approach solves more than one problem we really need to solve,
and hence I think it's worth making this scope of changes now to
support shrink operations....

Signed-off-by: Dave Chinner <dchinner@redhat.com>


Dave Chinner (23):
  xfs: move xfs_perag_get/put to xfs_ag.[ch]
  xfs: prepare for moving perag definitions and support to libxfs
  xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
  xfs: make for_each_perag... a first class citizen
  xfs: convert raw ag walks to use for_each_perag
  xfs: convert xfs_iwalk to use perag references
  xfs: convert secondary superblock walk to use perags
  xfs: pass perags through to the busy extent code
  xfs: push perags through the ag reservation callouts
  xfs: pass perags around in fsmap data dev functions
  xfs: add a perag to the btree cursor
  xfs: convert rmap btree cursor to using a perag
  xfs: convert refcount btree cursor to use perags
  xfs: convert allocbt cursors to use perags
  xfs: use perag for ialloc btree cursors
  xfs: remove agno from btree cursor
  xfs: simplify xfs_dialloc_select_ag() return values
  xfs: collapse AG selection for inode allocation
  xfs: get rid of xfs_dir_ialloc()
  xfs: inode allocation can use a single perag instance
  xfs: clean up and simplify xfs_dialloc()
  xfs: use perag through unlink processing
  xfs: remove xfs_perag_t

 fs/xfs/libxfs/xfs_ag.c             | 272 ++++++++++++-
 fs/xfs/libxfs/xfs_ag.h             | 135 +++++++
 fs/xfs/libxfs/xfs_ag_resv.c        |  11 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |  15 +
 fs/xfs/libxfs/xfs_alloc.c          | 110 +++---
 fs/xfs/libxfs/xfs_alloc.h          |   2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  31 +-
 fs/xfs/libxfs/xfs_alloc_btree.h    |   9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   1 +
 fs/xfs/libxfs/xfs_bmap.c           |   1 +
 fs/xfs/libxfs/xfs_btree.c          |  15 +-
 fs/xfs/libxfs/xfs_btree.h          |  10 +-
 fs/xfs/libxfs/xfs_ialloc.c         | 608 ++++++++++++++---------------
 fs/xfs/libxfs/xfs_ialloc.h         |  40 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  46 +--
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  13 +-
 fs/xfs/libxfs/xfs_refcount.c       | 122 +++---
 fs/xfs/libxfs/xfs_refcount.h       |   9 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  39 +-
 fs/xfs/libxfs/xfs_refcount_btree.h |   7 +-
 fs/xfs/libxfs/xfs_rmap.c           | 147 +++----
 fs/xfs/libxfs/xfs_rmap.h           |   6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  46 +--
 fs/xfs/libxfs/xfs_rmap_btree.h     |   6 +-
 fs/xfs/libxfs/xfs_sb.c             | 146 +------
 fs/xfs/libxfs/xfs_sb.h             |   9 -
 fs/xfs/libxfs/xfs_types.c          |   4 +-
 fs/xfs/scrub/agheader.c            |   1 +
 fs/xfs/scrub/agheader_repair.c     |  33 +-
 fs/xfs/scrub/alloc.c               |   3 +-
 fs/xfs/scrub/bmap.c                |  21 +-
 fs/xfs/scrub/common.c              |  15 +-
 fs/xfs/scrub/fscounters.c          |  42 +-
 fs/xfs/scrub/health.c              |   2 +-
 fs/xfs/scrub/ialloc.c              |   9 +-
 fs/xfs/scrub/refcount.c            |   3 +-
 fs/xfs/scrub/repair.c              |  14 +-
 fs/xfs/scrub/rmap.c                |   3 +-
 fs/xfs/scrub/trace.c               |   3 +-
 fs/xfs/xfs_buf.c                   |   2 +-
 fs/xfs/xfs_discard.c               |   6 +-
 fs/xfs/xfs_extent_busy.c           |  33 +-
 fs/xfs/xfs_extent_busy.h           |   7 +-
 fs/xfs/xfs_filestream.c            |   2 +-
 fs/xfs/xfs_fsmap.c                 |  80 ++--
 fs/xfs/xfs_fsops.c                 |   8 +-
 fs/xfs/xfs_health.c                |   6 +-
 fs/xfs/xfs_icache.c                |  17 +-
 fs/xfs/xfs_inode.c                 | 202 +++++-----
 fs/xfs/xfs_inode.h                 |   9 +-
 fs/xfs/xfs_iwalk.c                 |  84 ++--
 fs/xfs/xfs_log_recover.c           |  56 ++-
 fs/xfs/xfs_mount.c                 | 126 +-----
 fs/xfs/xfs_mount.h                 | 110 +-----
 fs/xfs/xfs_qm.c                    |  10 +-
 fs/xfs/xfs_reflink.c               |  13 +-
 fs/xfs/xfs_super.c                 |   1 +
 fs/xfs/xfs_symlink.c               |   9 +-
 fs/xfs/xfs_trace.c                 |   2 +
 fs/xfs/xfs_trace.h                 |   4 +-
 60 files changed, 1407 insertions(+), 1389 deletions(-)

-- 
2.31.1

