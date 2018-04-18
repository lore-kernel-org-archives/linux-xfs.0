Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753170AbeDRNbU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 09:31:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7983489
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B823D805C5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 13:31:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/6] xfs: defer agfl block frees
Date: Wed, 18 Apr 2018 09:31:13 -0400
Message-Id: <20180418133119.21775-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This version drops all refactoring and cleanup changes related to the tp
pointer to avoid confusion between functional fixes and cleanup work
that was somewhat intertwined in the previous versions. Hence, the
purpose of this series is now purely to enable deferred AGFL block
frees. Because this behavior is enabled at transaction granularity,
carry the dfops to the allocator via the transaction.

This avoids the need for the extra plumbing that was implemented in
rfcv1 (and removed in rfcv2) and facilitates cleanups like those
demonstrated in the previous version. I'll rename ->t_agfl_dfops to
->t_dfops and do the broader cleanup work in a separate series once this
series is complete.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Drop all refactoring/cleanup bits.
- Rename dfops pointer to ->t_agfl_dfops for explicit use by AGFL fixup
  code.
v1: https://marc.info/?l=linux-xfs&m=152338240213442&w=2
- Rebased to for-next.
- Attach dfops to tp via xfs_defer_init().
- Fix up xfs_defer_finish() to restore original pointer.
- Dropped debug/test patches.
rfcv2: https://marc.info/?l=linux-xfs&m=151681946702093&w=2
- Use transaction to carry deferred ops struct to allocation context.
- Remove dfops param from dir interfaces where possible.
- Defer AGFL block frees from more contexts.
- Define runtime stat for transaction regrant and logcount patch (to be
  potentially removed).
rfcv1: https://marc.info/?l=linux-xfs&m=151267309423883&w=2

Brian Foster (6):
  xfs: create agfl block free helper function
  xfs: defer agfl block frees when dfops is available
  xfs: defer agfl block frees from deferred ops processing context
  xfs: defer agfl frees from inode inactivation
  xfs: defer frees from common inode allocation paths
  xfs: defer agfl frees from directory op transactions

 fs/xfs/libxfs/xfs_alloc.c  | 82 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_alloc.h  |  2 ++
 fs/xfs/libxfs/xfs_defer.c  | 12 +++++++
 fs/xfs/libxfs/xfs_defer.h  |  1 +
 fs/xfs/xfs_inode.c         |  5 +++
 fs/xfs/xfs_symlink.c       |  1 +
 fs/xfs/xfs_trace.h         |  2 ++
 fs/xfs/xfs_trans.c         | 11 +++++--
 fs/xfs/xfs_trans.h         |  1 +
 fs/xfs/xfs_trans_extfree.c | 70 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 173 insertions(+), 14 deletions(-)

-- 
2.13.6

