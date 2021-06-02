Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03619C47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 06:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D681D61396
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 06:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhFBGMx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 02:12:53 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:46691 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhFBGMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 02:12:53 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 4AF581AFE61;
        Wed,  2 Jun 2021 16:11:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loK5r-00800R-0g; Wed, 02 Jun 2021 16:11:07 +1000
Date:   Wed, 2 Jun 2021 16:11:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: initial agnumber -> perag conversions for shrink
Message-ID: <20210602061106.GU664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=zhmD0uWJP6qvLnBEAgcA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the perag conversion changes inot the next
for-next compose from the tag below? I pulled most of the original
patchset description into the tag itself, so I won't repeat any of
it here.....

Cheers,

Dave.

The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-perag-conv-tag

for you to fetch changes up to 509201163fca3d4d906bd50a5320115d42818748:

  xfs: remove xfs_perag_t (2021-06-02 10:48:51 +1000)

----------------------------------------------------------------
xfs: initial agnumber -> perag conversions for shrink

If we want to use active references to the perag to be able to gate
shrink removing AGs and hence perags safely, we've got a fair bit of
work to do actually use perags in all the places we need to.

There's a lot of code that iterates ag numbers and then
looks up perags from that, often multiple times for the same perag
in the one operation. If we want to use reference counted perags for
access control, then we need to convert all these uses to perag
iterators, not agno iterators.

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

----------------------------------------------------------------
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

 fs/xfs/libxfs/xfs_ag.c             | 272 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_ag.h             | 136 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag_resv.c        |  11 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |  15 +++
 fs/xfs/libxfs/xfs_alloc.c          | 110 ++++++++++----------
 fs/xfs/libxfs/xfs_alloc.h          |   2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  31 +++---
 fs/xfs/libxfs/xfs_alloc_btree.h    |   9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   1 +
 fs/xfs/libxfs/xfs_bmap.c           |   1 +
 fs/xfs/libxfs/xfs_btree.c          |  15 +--
 fs/xfs/libxfs/xfs_btree.h          |  10 +-
 fs/xfs/libxfs/xfs_ialloc.c         | 608 ++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------
 fs/xfs/libxfs/xfs_ialloc.h         |  40 ++------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  46 +++++----
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  13 +--
 fs/xfs/libxfs/xfs_refcount.c       | 122 +++++++++++-----------
 fs/xfs/libxfs/xfs_refcount.h       |   9 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  39 +++----
 fs/xfs/libxfs/xfs_refcount_btree.h |   7 +-
 fs/xfs/libxfs/xfs_rmap.c           | 147 +++++++++++++-------------
 fs/xfs/libxfs/xfs_rmap.h           |   6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  46 ++++-----
 fs/xfs/libxfs/xfs_rmap_btree.h     |   6 +-
 fs/xfs/libxfs/xfs_sb.c             | 146 ++------------------------
 fs/xfs/libxfs/xfs_sb.h             |   9 --
 fs/xfs/libxfs/xfs_types.c          |   4 +-
 fs/xfs/scrub/agheader.c            |   1 +
 fs/xfs/scrub/agheader_repair.c     |  33 +++---
 fs/xfs/scrub/alloc.c               |   3 +-
 fs/xfs/scrub/bmap.c                |  21 ++--
 fs/xfs/scrub/common.c              |  15 ++-
 fs/xfs/scrub/fscounters.c          |  42 +++-----
 fs/xfs/scrub/health.c              |   2 +-
 fs/xfs/scrub/ialloc.c              |   9 +-
 fs/xfs/scrub/refcount.c            |   3 +-
 fs/xfs/scrub/repair.c              |  14 +--
 fs/xfs/scrub/rmap.c                |   3 +-
 fs/xfs/scrub/trace.c               |   3 +-
 fs/xfs/xfs_buf.c                   |   2 +-
 fs/xfs/xfs_discard.c               |   6 +-
 fs/xfs/xfs_extent_busy.c           |  33 ++----
 fs/xfs/xfs_extent_busy.h           |   7 +-
 fs/xfs/xfs_filestream.c            |   2 +-
 fs/xfs/xfs_fsmap.c                 |  80 +++++++++------
 fs/xfs/xfs_fsops.c                 |   8 +-
 fs/xfs/xfs_health.c                |   6 +-
 fs/xfs/xfs_icache.c                |  17 +--
 fs/xfs/xfs_inode.c                 | 202 ++++++++++++++++--------------------
 fs/xfs/xfs_inode.h                 |   9 +-
 fs/xfs/xfs_iwalk.c                 |  84 +++++++++------
 fs/xfs/xfs_log_recover.c           |  56 +++++-----
 fs/xfs/xfs_mount.c                 | 126 +----------------------
 fs/xfs/xfs_mount.h                 | 110 +-------------------
 fs/xfs/xfs_qm.c                    |  10 +-
 fs/xfs/xfs_reflink.c               |  13 ++-
 fs/xfs/xfs_super.c                 |   1 +
 fs/xfs/xfs_symlink.c               |   9 +-
 fs/xfs/xfs_trace.c                 |   2 +
 fs/xfs/xfs_trace.h                 |   4 +-
 60 files changed, 1408 insertions(+), 1389 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
