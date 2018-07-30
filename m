Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729057AbeG3SVL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 14:21:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F261140216FC
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D79B9112D179
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 16:45:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/15] xfs: condense dfops and automatic relogging
Date: Mon, 30 Jul 2018 12:45:05 -0400
Message-Id: <20180730164520.36882-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here is the (actual) final dfops cleanup series. ;P This essentially
pares down xfs_defer_ops to a single list_head for queued deferred ops
and folds said list into the transaction, eliminating the need for the
xfs_defer_ops structure.

To facilitate this, the low free space mode flag is converted into a
transaction flag and carried across tx rolls to preserve current
behavior. The pending list is converted to an on-stack list with the
help of a change to cancel pending ops on xfs_defer_finish() failure.
The joined inode/buffer lists are also converted to on-stack lists once
said items are automatically relogged across dfops transaction rolls via
item hold/lock state.

The only real behavior change here should be patch 6 which adds the
missing xfs_defer_ijoin() calls that would, in absence of patch 6, be
implied by the automatic inode relogging patch. In other words, these
are the inodes that patch 8 would start to relog that weren't relogged
before. Technically patch 6 is unnecessary, but I had already identified
these sites as part of the initial investigation and so figured it would
be more clear to add them explicitly.

This survives xfstests and a weekend long fsstress run so far. I have
some fsx testing in progress now.

Thoughts, reviews, flames appreciated.

Brian

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

 fs/xfs/libxfs/xfs_alloc.c       |  18 +--
 fs/xfs/libxfs/xfs_attr.c        |  26 +--
 fs/xfs/libxfs/xfs_attr_remote.c |   6 +-
 fs/xfs/libxfs/xfs_bmap.c        |  93 +++++------
 fs/xfs/libxfs/xfs_bmap.h        |  25 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c  |   6 +-
 fs/xfs/libxfs/xfs_btree.h       |   1 -
 fs/xfs/libxfs/xfs_da_btree.h    |   1 -
 fs/xfs/libxfs/xfs_defer.c       | 273 ++++++++++++++------------------
 fs/xfs/libxfs/xfs_defer.h       |  28 +---
 fs/xfs/libxfs/xfs_dir2.c        |   2 -
 fs/xfs/libxfs/xfs_dir2.h        |   1 -
 fs/xfs/libxfs/xfs_ialloc.c      |  25 +--
 fs/xfs/libxfs/xfs_refcount.c    |  76 ++++-----
 fs/xfs/libxfs/xfs_refcount.h    |  25 ++-
 fs/xfs/libxfs/xfs_rmap.c        |  53 +++----
 fs/xfs/libxfs/xfs_rmap.h        |  22 ++-
 fs/xfs/libxfs/xfs_shared.h      |  12 ++
 fs/xfs/xfs_bmap_item.c          |  20 ++-
 fs/xfs/xfs_bmap_item.h          |   3 +-
 fs/xfs/xfs_bmap_util.c          |  18 +--
 fs/xfs/xfs_dquot.c              |   3 +-
 fs/xfs/xfs_filestream.c         |   3 +-
 fs/xfs/xfs_inode.c              |   3 +-
 fs/xfs/xfs_inode.h              |   1 -
 fs/xfs/xfs_log_recover.c        |  42 +++--
 fs/xfs/xfs_refcount_item.c      |  30 ++--
 fs/xfs/xfs_refcount_item.h      |   3 +-
 fs/xfs/xfs_reflink.c            |  33 ++--
 fs/xfs/xfs_symlink.c            |   1 -
 fs/xfs/xfs_trace.h              |  40 ++---
 fs/xfs/xfs_trans.c              |  32 +---
 fs/xfs/xfs_trans.h              |  28 +---
 fs/xfs/xfs_trans_bmap.c         |   6 +-
 fs/xfs/xfs_trans_extfree.c      |   2 -
 fs/xfs/xfs_trans_refcount.c     |   6 +-
 fs/xfs/xfs_trans_rmap.c         |   1 -
 37 files changed, 394 insertions(+), 574 deletions(-)

-- 
2.17.1

