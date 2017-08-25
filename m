Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933204AbdHYPF7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 11:05:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A7D681236
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 15:05:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DEC36C434
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 15:05:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/9] xfs: xfs: refactor ordered buffer logging code
Date: Fri, 25 Aug 2017 11:05:48 -0400
Message-Id: <20170825150557.43010-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a first non-rfc of the ordered buffer refactoring series. The
original motivation is to provide a function that deferred operations
can use to relog buffers. As such, the initial refactoring patches are
mostly the same as the rfc. This work became a bit more involved than
originally anticipated because the refactoring that implemented more
strict buffer ordering rules also teased out the fact that the extent
swap code wasn't using ordered buffers quite correctly.

The primary differences in this version are the addition of some new
cleanup/bugfix patches and an update to make buffer ordering conditional
on the blf dirty state of the buffer. This is driven by the fact that
the existing bmbt owner change algorithm misuses ordered buffers by not
considering the dirty state of such buffers before they are relogged as
ordered. After some refactoring, the final patch updates the the bmbt
owner change mechanism to physically relog such buffers and updates
extent swap to use a rolling transaction to deal with this case.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Drop unnecessary buffer type set in xfs_btree_block_change_owner().
- Several new cleanup patches.
- Fix bmbt owner change (extent swap) log recovery.
- Update buffer ordering to fail on previously dirty buffers.
- Rework bmbt owner change to use ordered buffers correctly.
rfc: https://marc.info/?l=linux-xfs&m=150272969407981&w=2

Brian Foster (9):
  xfs: open-code xfs_buf_item_dirty()
  xfs: remove unnecessary dirty bli format check for ordered bufs
  xfs: ordered buffer log items are never formatted
  xfs: refactor buffer logging into buffer dirtying helper
  xfs: don't log dirty ranges for ordered buffers
  xfs: skip bmbt block ino validation during owner change
  xfs: move bmbt owner change to last step of extent swap
  xfs: disallow marking previously dirty buffers as ordered
  xfs: relog dirty buffers during swapext bmbt owner change

 fs/xfs/libxfs/xfs_bmap_btree.c |  1 +
 fs/xfs/libxfs/xfs_btree.c      | 27 ++++++++----
 fs/xfs/libxfs/xfs_btree.h      |  3 +-
 fs/xfs/libxfs/xfs_ialloc.c     |  2 -
 fs/xfs/xfs_bmap_util.c         | 93 +++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_buf_item.c          | 59 +++++++++++++--------------
 fs/xfs/xfs_buf_item.h          |  2 +-
 fs/xfs/xfs_trace.h             |  1 -
 fs/xfs/xfs_trans.h             |  6 ++-
 fs/xfs/xfs_trans_buf.c         | 79 +++++++++++++++++++++--------------
 10 files changed, 172 insertions(+), 101 deletions(-)

-- 
2.9.5

