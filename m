Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfAWSlb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:41:31 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C0392C05D3E1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jan 2019 18:41:31 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BCBC1001F3D
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jan 2019 18:41:31 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/6] xfs: properly invalidate cached writeback mapping
Date: Wed, 23 Jan 2019 13:41:25 -0500
Message-Id: <20190123184131.46188-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v3 of the imap cache invalidation series. To recap from v2, patch
5 of that series added a lookup and extent trim to
xfs_iomap_write_allocate() to ensure delalloc conversion always had a
correct range. Christoph didn't like this approach and has an alternate
proposal to modify XFS_BMAPI_DELALLOC behavior to always skip holes.
That approach is problematic because it can potentially convert blocks
that have nothing to do with the current extent (i.e., still racy with
hole punch).

As a compromise, this version implements an xfs_bmapi_delalloc() wrapper
with an interface that allocates the underlying extent of a particular
block. This ensures that writeback always uses the correct range without
adding an extra extent lookup. There is still a bit of hackiness and
probably opportunity for broader refactoring, but that can be done once
we've established correctness.

Patches 1-4 are mostly unchanged from v2. Patch 5 introduces the
xfs_bmapi_delalloc() helper. Patch 6 modifies xfs_iomap_write_allocate()
to use xfs_bmapi_delalloc() instead of xfs_bmapi_write(). This series
survives fstests (including repeated cycles of generic/524 and xfs/442)
on 4k and 1k block sizes with reflink enabled without any regressions.
It also survives several million fsx operations.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Move comment in xfs_imap_valid().
- Replace lookup+trim in xfs_iomap_write_allocate() with
  xfs_bmapi_delalloc() wrapper mechanism.
v2: https://marc.info/?l=linux-xfs&m=154775280823464&w=2
- Refactor validation logic into xfs_imap_valid() helper.
- Revalidate seqno after the lock cycle in xfs_map_blocks().
- Update *seq in xfs_iomap_write_allocate() regardless of fork type.
- Add patch 5 for seqno revalidation on xfs_iomap_write_allocate() lock
  cycles.
v1: https://marc.info/?l=linux-xfs&m=154721212321112&w=2

Brian Foster (6):
  xfs: eof trim writeback mapping as soon as it is cached
  xfs: update fork seq counter on data fork changes
  xfs: validate writeback mapping using data fork seq counter
  xfs: remove superfluous writeback mapping eof trimming
  xfs: create delalloc bmapi wrapper for full extent allocation
  xfs: use the latest extent at writeback delalloc conversion time

 fs/xfs/libxfs/xfs_bmap.c       |  58 ++++++++---
 fs/xfs/libxfs/xfs_bmap.h       |   3 +-
 fs/xfs/libxfs/xfs_iext_tree.c  |  13 ++-
 fs/xfs/libxfs/xfs_inode_fork.h |   2 +-
 fs/xfs/xfs_aops.c              |  71 ++++++++-----
 fs/xfs/xfs_iomap.c             | 175 ++++++++++++---------------------
 6 files changed, 162 insertions(+), 160 deletions(-)

-- 
2.17.2
