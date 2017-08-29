Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753155AbdH2Oh7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:37:59 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C4277E42F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61D8B6FEF1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/9] xfs: refactor ordered buffer logging code
Date: Tue, 29 Aug 2017 10:37:49 -0400
Message-Id: <20170829143758.58990-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the ordered buffer / buffer relogging refactoring series.
Only minor updates in this version. I've also tagged patch 6 for stable
as it fixes a log recovery regression for bmbt owner change operations.

Brian

v2:
- Various cleanups.
- Rename bmbt scan invalid owner flag.
- Added stable CC for bmbt owner change log recovery fix (6/9).
v1: https://marc.info/?l=linux-xfs&m=150367356112090&w=2
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
 fs/xfs/xfs_buf_item.c          | 75 +++++++++++++---------------------
 fs/xfs/xfs_buf_item.h          |  2 +-
 fs/xfs/xfs_trace.h             |  1 -
 fs/xfs/xfs_trans.h             |  6 ++-
 fs/xfs/xfs_trans_buf.c         | 79 +++++++++++++++++++++--------------
 10 files changed, 173 insertions(+), 116 deletions(-)

-- 
2.9.5

