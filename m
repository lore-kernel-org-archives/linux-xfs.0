Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751966AbeDJRqd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 13:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2ABBB47E36
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AD3E8E3FE
        for <linux-xfs@vger.kernel.org>; Tue, 10 Apr 2018 17:46:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/7] xfs: defer agfl block frees
Date: Tue, 10 Apr 2018 13:46:24 -0400
Message-Id: <20180410174631.4915-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a non-rfc version of the defer AGFL frees patches. As a quick
summary, the purpose of this series is to reduce per-tx log reservation
consumption of the block allocation code. Under certain conditions, the
pre-allocation AGFL fix up code can end up performing multiple block
free operations that can result in multiple btree shape changes before
the originally requested allocation even begins. This leads to log
reservation overrun problems because the number of AGFL block frees
required for a particular transaction cannot be determined in advance.
Therefore, process frees of AGFL blocks using deferred operations in the
same way that data blocks are freed.

In conjunction, clean up some of the disparate dfops callchain plumbing
by allowing a transaction to carry a pointer to an associated dop
structure. This eliminates the need to plumb xfs_defer_ops through yet
another callchain for the purpose of deferring AGFL frees. It also
facilitates cleanups of similar codepaths where dfops is already passed
around separately from the transaction that will ultimately log the
associated intents.

There aren't that many code changes since rfcv2. The series has been
rebased to for-next and the assignment of ->t_dfops occurs within
xfs_defer_init() rather than being open-coded. Also, the series has seen
more testing and drops some of the related test code from the rfc.

Thoughts, reviews, flames appreciated.

Brian

v1:
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

Brian Foster (7):
  xfs: create agfl block free helper function
  xfs: allow attach of dfops to transaction
  xfs: defer agfl block frees when dfops is available
  xfs: defer agfl block frees from deferred ops processing context
  xfs: defer agfl frees from inode inactivation
  xfs: defer frees from common inode allocation paths
  xfs: defer agfl frees from directory op transactions

 fs/xfs/libxfs/xfs_alloc.c       | 82 +++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc.h       |  2 +
 fs/xfs/libxfs/xfs_attr.c        | 18 ++++-----
 fs/xfs/libxfs/xfs_attr_remote.c |  6 +--
 fs/xfs/libxfs/xfs_bmap.c        |  4 +-
 fs/xfs/libxfs/xfs_defer.c       | 17 ++++++++-
 fs/xfs/libxfs/xfs_defer.h       |  4 +-
 fs/xfs/libxfs/xfs_dir2.c        | 16 ++++----
 fs/xfs/libxfs/xfs_dir2.h        |  9 ++---
 fs/xfs/libxfs/xfs_ialloc.c      |  6 +--
 fs/xfs/libxfs/xfs_ialloc.h      |  1 -
 fs/xfs/libxfs/xfs_refcount.c    |  2 +-
 fs/xfs/xfs_bmap_util.c          | 12 +++---
 fs/xfs/xfs_dquot.c              |  2 +-
 fs/xfs/xfs_inode.c              | 76 +++++++++++++++++++-------------------
 fs/xfs/xfs_inode.h              |  3 +-
 fs/xfs/xfs_iomap.c              |  6 +--
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  8 ++--
 fs/xfs/xfs_rtalloc.c            |  2 +-
 fs/xfs/xfs_symlink.c            |  6 +--
 fs/xfs/xfs_trace.h              |  2 +
 fs/xfs/xfs_trans.c              | 11 ++++--
 fs/xfs/xfs_trans.h              |  1 +
 fs/xfs/xfs_trans_extfree.c      | 70 +++++++++++++++++++++++++++++++++++
 25 files changed, 259 insertions(+), 109 deletions(-)

-- 
2.13.6

