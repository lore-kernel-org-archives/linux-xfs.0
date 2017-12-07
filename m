Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752506AbdLGS6L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 13:58:11 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89D5676525
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EF5E7C564
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 0/4] xfs: defer agfl block frees
Date: Thu,  7 Dec 2017 13:58:06 -0500
Message-Id: <20171207185810.48757-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is an experiment I've been hacking on based on some of the recent
discussions around log reservation deficiences due to unpredictable AGFL
fixup behavior[1] and a previous attempt to address the problem[2].

This RFC series introduces the ability to defer AGFL block frees much
like the way we already defer frees of file-mapped extents. The intent
is to disconnect freeing of surplus AGFL blocks from making those free
AGFL slots available for an impending allocation. In turn, this creates
conditions where AGFL fixups have more consistent and predictable log
reservation consumption. AGFL block allocation behavior does not change
since most AGFL deficiences can be satisfied by a single allocation
request (whereas AGFL blocks are generally freed one at a time,
requiring multiple cycles through the allocator).

This series survives the overrun reproducer associated with [1], even
without the transaction fixups in [3] (that also work around the
overrun). It also survives an xfstests run without any obvious problems.

This is RFC for a few reasons. First, this is obviously a sensitive area
of code that requires thorough analysis. This also requires more
thorough stress testing than it has seen so far. Finally, the behavior
changes are intentionally limited to target the reproducer workload. A
proper series should probably include updates to consistently defer AGFL
block frees from all possible inobt contexts, for example. I'm not so
sure that is necessary/appropriate for other allocator callers, however,
but is worth consideration.

Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=151127676203410&w=2
[2] https://marc.info/?l=linux-xfs&m=151181428131889&w=2
[3] https://marc.info/?l=linux-xfs&m=151206831911206&w=2

Brian Foster (4):
  xfs: create agfl block free helper function
  xfs: defer agfl block frees when dfops is available
  xfs: defer agfl block frees on extent frees
  xfs: defer agfl frees on inobt allocs during chunk removal

 fs/xfs/libxfs/xfs_alloc.c          | 91 ++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc.h          |  8 +++-
 fs/xfs/libxfs/xfs_defer.h          |  1 +
 fs/xfs/libxfs/xfs_ialloc.c         | 16 +++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 11 +++--
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  4 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap.c           |  2 +-
 fs/xfs/scrub/common.c              |  8 ++--
 fs/xfs/xfs_extfree_item.c          |  2 +-
 fs/xfs/xfs_fsops.c                 |  2 +-
 fs/xfs/xfs_itable.c                |  4 +-
 fs/xfs/xfs_trace.h                 |  2 +
 fs/xfs/xfs_trans.h                 |  3 +-
 fs/xfs/xfs_trans_extfree.c         | 77 ++++++++++++++++++++++++++++++--
 15 files changed, 189 insertions(+), 44 deletions(-)

-- 
2.13.6

