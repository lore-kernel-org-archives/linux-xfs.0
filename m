Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBDCEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 23:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiGGX7i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbiGGX7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:59:37 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A89131AD8A
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:59:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C861010E7BBC
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:59:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9bPD-00FooR-7K
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:59:35 +1000
Date:   Fri, 8 Jul 2022 09:59:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: per-ag conversions for 5.20
Message-ID: <20220707235935.GA3600936@dread.disaster.area>
References: <20220707233717.GP227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707233717.GP227878@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c77368
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=guj_5oDO9UgXj0Wye-sA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the perag conversion changes from the tag listed
below? This branchis based on the linux-xfs/for-next tree as of two
days ago, so should merge cleanly with this. It also merges cleanly
with the xfs-cil-scalability-5.20 branch that I just posted a pull
request for, so you should be able to merge them in either order.

Cheers,

Dave.

The following changes since commit 7561cea5dbb97fecb952548a0fb74fb105bf4664:

  xfs: prevent a UAF when log IO errors race with unmount (2022-07-01 09:09:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-perag-conv-5.20

for you to fetch changes up to 36029dee382a20cf515494376ce9f0d5949944eb:

  xfs: make is_log_ag() a first class helper (2022-07-07 19:13:21 +1000)

----------------------------------------------------------------
xfs: per-ag conversions for 5.20

This series drives the perag down into the AGI, AGF and AGFL access
routines and unifies the perag structure initialisation with the
high level AG header read functions. This largely replaces the
xfs_mount/agno pair that is passed to all these functions with a
perag, and in most places we already have a perag ready to pass in.
There are a few places where perags need to be grabbed before
reading the AG header buffers - some of these will need to be driven
to higher layers to ensure we can run operations on AGs without
getting stuck part way through waiting on a perag reference.

The latter section of this patchset moves some of the AG geometry
information from the xfs_mount to the xfs_perag, and starts
converting code that requires geometry validation to use a perag
instead of a mount and having to extract the AGNO from the object
location. This also allows us to store the AG size in the perag and
then we can stop having to compare the agno against sb_agcount to
determine if the AG is the last AG and so has a runt size.  This
greatly simplifies some of the type validity checking we do and
substantially reduces the CPU overhead of type validity checking. It
also cuts over 1.2kB out of the binary size.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

----------------------------------------------------------------
Dave Chinner (14):
      xfs: make last AG grow/shrink perag centric
      xfs: kill xfs_ialloc_pagi_init()
      xfs: pass perag to xfs_ialloc_read_agi()
      xfs: kill xfs_alloc_pagf_init()
      xfs: pass perag to xfs_alloc_read_agf()
      xfs: pass perag to xfs_read_agi
      xfs: pass perag to xfs_read_agf
      xfs: pass perag to xfs_alloc_get_freelist
      xfs: pass perag to xfs_alloc_put_freelist
      xfs: pass perag to xfs_alloc_read_agfl
      xfs: Pre-calculate per-AG agbno geometry
      xfs: Pre-calculate per-AG agino geometry
      xfs: replace xfs_ag_block_count() with perag accesses
      xfs: make is_log_ag() a first class helper

 fs/xfs/libxfs/xfs_ag.c             | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_ag.h             |  69 +++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ag_resv.c        |   2 +-
 fs/xfs/libxfs/xfs_alloc.c          | 143 ++++++++++++++++++++++++++++++++++++--------------------------------------------
 fs/xfs/libxfs/xfs_alloc.h          |  58 +++++++--------------------------
 fs/xfs/libxfs/xfs_alloc_btree.c    |   9 +++---
 fs/xfs/libxfs/xfs_bmap.c           |   3 +-
 fs/xfs/libxfs/xfs_btree.c          |  25 ++++++--------
 fs/xfs/libxfs/xfs_ialloc.c         |  86 ++++++++++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_ialloc.h         |  25 +++-----------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  20 ++++++------
 fs/xfs/libxfs/xfs_inode_buf.c      |   5 ++-
 fs/xfs/libxfs/xfs_refcount.c       |  19 ++++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |   5 ++-
 fs/xfs/libxfs/xfs_rmap.c           |   8 ++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |   9 +++---
 fs/xfs/libxfs/xfs_types.c          |  73 +++++------------------------------------
 fs/xfs/libxfs/xfs_types.h          |   9 ------
 fs/xfs/scrub/agheader.c            |  25 +++++++-------
 fs/xfs/scrub/agheader_repair.c     |  21 ++++--------
 fs/xfs/scrub/alloc.c               |   7 ++--
 fs/xfs/scrub/bmap.c                |   2 +-
 fs/xfs/scrub/common.c              |   6 ++--
 fs/xfs/scrub/fscounters.c          |   4 +--
 fs/xfs/scrub/health.c              |   2 ++
 fs/xfs/scrub/ialloc.c              |  12 +++----
 fs/xfs/scrub/refcount.c            |   9 +++---
 fs/xfs/scrub/repair.c              |  32 +++++++++---------
 fs/xfs/scrub/rmap.c                |   6 ++--
 fs/xfs/xfs_discard.c               |   2 +-
 fs/xfs/xfs_extfree_item.c          |   6 +++-
 fs/xfs/xfs_filestream.c            |   4 +--
 fs/xfs/xfs_fsmap.c                 |   3 +-
 fs/xfs/xfs_fsops.c                 |  13 +++++---
 fs/xfs/xfs_inode.c                 |  28 ++++++++--------
 fs/xfs/xfs_ioctl.c                 |   8 ++++-
 fs/xfs/xfs_log_recover.c           |  41 +++++++++++------------
 fs/xfs/xfs_mount.c                 |   3 +-
 fs/xfs/xfs_reflink.c               |  40 ++++++++++++-----------
 fs/xfs/xfs_reflink.h               |   3 --
 40 files changed, 486 insertions(+), 522 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
