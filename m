Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389216AbeHAPFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75D2A7DAC7
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:52 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 617752026D68
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/15] xfs: condense dfops and automatic relogging
Date: Wed,  1 Aug 2018 09:19:37 -0400
Message-Id: <20180801131952.60250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the condense dfops patches. This has mostly minor changes
such as extra error checks, comments and cleanups.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Add Reviewed-by tags.
- Rename container transaction for intent log recovery, add comment.
- More error checks in automatic dfops relogging.
- Assert and warn checks for permanent transaction with deferred ops.
- Function renames/refactors for on-stack pending dfops list patch.
- Drop unnecessary xfs_mount param from tracepoints with transaction.
v1: https://marc.info/?l=linux-xfs&m=153296912912425&w=2

Brian Foster (15):
  xfs: refactor internal dfops initialization
  xfs: use transaction for intent recovery instead of raw dfops
  xfs: remove unused __xfs_defer_cancel() internal helper
  xfs: pass transaction to dfops reset/move helpers
  xfs: replace dop_low with transaction flag
  xfs: add missing defer ijoins for held inodes
  xfs: automatic dfops buffer relogging
  xfs: automatic dfops inode relogging
  xfs: drop dop param from xfs_defer_op_type ->finish_item() callback
  xfs: clean out superfluous dfops dop params/vars
  xfs: cancel dfops on xfs_defer_finish() error
  xfs: replace xfs_defer_ops ->dop_pending with on-stack list
  xfs: pass transaction to xfs_defer_add()
  xfs: always defer agfl block frees
  xfs: fold dfops into the transaction

 fs/xfs/libxfs/xfs_alloc.c       |  18 +-
 fs/xfs/libxfs/xfs_attr.c        |  26 +--
 fs/xfs/libxfs/xfs_attr_remote.c |   6 +-
 fs/xfs/libxfs/xfs_bmap.c        |  93 ++++-----
 fs/xfs/libxfs/xfs_bmap.h        |  25 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c  |   6 +-
 fs/xfs/libxfs/xfs_btree.h       |   1 -
 fs/xfs/libxfs/xfs_da_btree.h    |   1 -
 fs/xfs/libxfs/xfs_defer.c       | 322 ++++++++++++++------------------
 fs/xfs/libxfs/xfs_defer.h       |  26 +--
 fs/xfs/libxfs/xfs_dir2.c        |   2 -
 fs/xfs/libxfs/xfs_dir2.h        |   1 -
 fs/xfs/libxfs/xfs_ialloc.c      |  25 +--
 fs/xfs/libxfs/xfs_refcount.c    |  76 ++++----
 fs/xfs/libxfs/xfs_refcount.h    |  25 ++-
 fs/xfs/libxfs/xfs_rmap.c        |  53 +++---
 fs/xfs/libxfs/xfs_rmap.h        |  22 +--
 fs/xfs/libxfs/xfs_shared.h      |  12 ++
 fs/xfs/xfs_bmap_item.c          |  20 +-
 fs/xfs/xfs_bmap_item.h          |   3 +-
 fs/xfs/xfs_bmap_util.c          |  18 +-
 fs/xfs/xfs_dquot.c              |   3 +-
 fs/xfs/xfs_filestream.c         |   3 +-
 fs/xfs/xfs_inode.c              |   3 +-
 fs/xfs/xfs_inode.h              |   1 -
 fs/xfs/xfs_log_recover.c        |  51 ++---
 fs/xfs/xfs_refcount_item.c      |  30 ++-
 fs/xfs/xfs_refcount_item.h      |   3 +-
 fs/xfs/xfs_reflink.c            |  33 ++--
 fs/xfs/xfs_symlink.c            |   1 -
 fs/xfs/xfs_trace.h              |  51 ++---
 fs/xfs/xfs_trans.c              |  39 ++--
 fs/xfs/xfs_trans.h              |  28 +--
 fs/xfs/xfs_trans_bmap.c         |   6 +-
 fs/xfs/xfs_trans_extfree.c      |   2 -
 fs/xfs/xfs_trans_refcount.c     |   6 +-
 fs/xfs/xfs_trans_rmap.c         |   1 -
 37 files changed, 434 insertions(+), 608 deletions(-)

-- 
2.17.1

