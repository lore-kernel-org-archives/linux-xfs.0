Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfAKMad (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 07:30:33 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2642AA4287
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jan 2019 12:30:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF36E5C8BC
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jan 2019 12:30:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfs: properly invalidate cached writeback mapping
Date: Fri, 11 Jan 2019 07:30:28 -0500
Message-Id: <20190111123032.31538-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series attempts to fix the stale writepage mapping problem in XFS.
The problem is essentially that ->writepages() caches the current extent
across multiple writepage instances and in certain circumstances the
cached mapping can be made invalid by concurrent filesystem operations.
For example, even with the current EOF trim band-aid for dealing with
post-eof speculative preallocation, a truncate+append sequence that
happens to race with background writeback can lead to a writepage to an
incorrect location.

Since we already have an xfs_ifork change/sequence number mechanism in
place, we reuse that to invalidate cached writeback mappings any time
the associated data fork has changed. Note that while certain workloads
might lead to a high frequency of spurious invalidations (i.e.,
with allocsize=4k mounts, files with a predetermined size such as vdisk
images, etc.), I've not been able to reproduce any noticeable effects at
a user level. See the patch 3 commit log description for further
discussion.

If we do run into use cases and workloads for which this is a problem, I
think there are options to further restrict seqno changing events (or
use multiple counters for subsets of change events) for less frequent
invalidations. For example, a sequence count that only tracks block
removals may still be sufficient to preserve coherency of cached
writeback mappings. Since this is all handwavy and theoretical, I opted
to keep the code simple and only deal with this should the need arise.

Patch 1 is a stable fix for the initial EOF trim patch. Patches 2-4
tweak the fork seqno mechanism to work for data forks, use it to
invalidate the cached writeback map and remove the EOF trim mechanism.
This has been tested via xfstests on multiple FSB sizes and fsx without
any explosions.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (4):
  xfs: eof trim writeback mapping as soon as it is cached
  xfs: update fork seq counter on data fork changes
  xfs: validate writeback mapping using data fork seq counter
  xfs: remove superfluous writeback mapping eof trimming

 fs/xfs/libxfs/xfs_bmap.c       | 11 -----------
 fs/xfs/libxfs/xfs_bmap.h       |  1 -
 fs/xfs/libxfs/xfs_iext_tree.c  | 13 ++++++-------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 fs/xfs/xfs_aops.c              | 21 ++++++---------------
 fs/xfs/xfs_iomap.c             |  4 ++--
 6 files changed, 15 insertions(+), 37 deletions(-)

-- 
2.17.2
