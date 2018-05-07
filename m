Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35629 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752051AbeEGSLj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 14:11:39 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D0E66C03D46E
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 18:11:39 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B161231320A2
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 18:11:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfs: skip unnecessary discards
Date: Mon,  7 May 2018 14:11:34 -0400
Message-Id: <20180507181138.43250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series allows XFS to skip discards in a couple cases where they are
spurious as the associated blocks have not been written to (e.g.,
eofblocks and unwritten extents). This v1 series incorporates Dave's
feedback on the previously posted RFC.

Patch 1 defines a new bmapi flag, patch 2 uses the flag for eofblocks
trim operations, patch 3 skips discards of unwritten extents and patch 4
is an rfc based on the discussion in the original rfc. While the rfc
mostly works, it's not suitable for merge from a code standpoint (and
while I've worked out some kinks, I still think there are lingering
issues) and so is included only for informational purposes.

Otherwise, patches 1-3 survive xfstests using a couple thin provisioned
volumes with '-o discard.' More '-o discard' test runs with alternate
configurations are in progress, but it hasn't spontaneously combusted to
this point so I'm posting for review.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Define and use bmapi flag for eofblocks trims.
- Separate patch to skip discards of unwritten extents.
- Various factoring cleanups.
rfc: https://marc.info/?l=linux-xfs&m=152476598825563&w=2

Brian Foster (4):
  xfs: add bmapi nodiscard flag
  xfs: skip online discard during eofblocks trims
  xfs: don't discard on free of unwritten extents
  xfs: convert speculative preallocation to unwritten extents

 fs/xfs/libxfs/xfs_alloc.c  | 10 +++++---
 fs/xfs/libxfs/xfs_alloc.h  | 27 ++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c   | 17 ++++++++++---
 fs/xfs/libxfs/xfs_bmap.h   | 30 ++++++++++++++++++++--
 fs/xfs/xfs_aops.c          |  3 +++
 fs/xfs/xfs_attr_inactive.c |  3 ++-
 fs/xfs/xfs_bmap_util.c     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_inode.c         | 11 +++++---
 fs/xfs/xfs_inode.h         |  2 +-
 fs/xfs/xfs_iomap.c         | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iops.c          |  3 ++-
 fs/xfs/xfs_qm_syscalls.c   |  2 +-
 fs/xfs/xfs_trans.h         |  3 ++-
 fs/xfs/xfs_trans_extfree.c | 13 +++++++---
 15 files changed, 165 insertions(+), 25 deletions(-)

-- 
2.14.3

