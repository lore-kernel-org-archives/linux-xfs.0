Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932280AbeF1Qgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7E974075740
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:36 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FF9510FD2A4
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/24] xfs: broad enablement of deferred agfl frees
Date: Thu, 28 Jun 2018 12:36:12 -0400
Message-Id: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's the next wave of dfops/xfs_trans related cleanups. This was split
off the original series that introduced ->t_agfl_dfops to separate
fixing the log reservation problems in those particular codepaths from
broader cleanups and generalization of deferred agfl block frees.

The purpose of this series is to 1.) enable deferred AGFL frees for the
broader codebase (wherever a dfops is already used) and 2.) clean up the
various places dfops is carried through on the stack or via interface
structures as the transaction reference is populated.

This work does expose a few warts with how dfops are used in relation to
transactions. For example, log recovery uses a dfops as a primary
structure and transactions are allocated/committed further down the
callchain. In that case, we don't want the transaction to commit the
caller's dfops. A few other places receive a transaction and then
locally init/finish a dfops on the stack. We have to be careful in these
places to not return a transaction to the caller with a dfops reference
that points to freed or reused stack memory by the time the tx is
committed.

I think these issues can be mostly resolved by the end goal of a
combined xfs_trans/xfs_defer_ops structure. Boilerplate code that
allocates a transaction, inits a dfops, finishes a dfops and commits the
transaction can then reduce to allocating and committing the transaction
(where the former and latter respectively init/finish an internal
dfops). There are other patterns and issues to consider, however, so
that will be a matter for a subsequent patch series. (I'm actually
thinking of cleaning up all of the firstblock stuff as a next step in
that direction.)

In this series: Patch 1 has been previously posted/reviewed. It is
included just as a dependency. Patch 2 renames ->t_agfl_dfops back to
->t_dfops for general purpose use. Patches 3-4 reintroduce some cleanups
dropped from the original series (where ->t_dfops is already used).
Patches 5-23 enable the use of ->t_dfops for transactions in various
subsystems, remove any subsequently unnecessary stack/data structure
dfops references and repeat until pretty much every transaction has a
dfops reference. Patch 24 refactors xfs_defer_init() to do the
transaction association, cleaning up all of the manual assignments added
by the previous patches.

I moved the final patch from the beginning to the end because it seemed
controversial in the previous posting, for whatever reason. This order
more explicitly documents the associated cleanup. Personally, I think
the patch should be a requirement for the broad use of ->t_dfops
implemented in this series, otherwise it's not clear to the developer
that an association needs to be made with the transaction in many
codepaths.

Finally, this has so far survived a couple rounds of xfstests with and
without rmapbt and reflink enabled. Further testing is ongoing.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (24):
  xfs: cow unwritten conversion uses uninitialized dfops
  xfs: rename xfs_trans ->t_agfl_dfops to ->t_dfops
  xfs: remove dfops parameter from ifree call stack
  xfs: remove dfops param from high level dirname calls
  xfs: use ->t_dfops for recovery of [b|c]ui log items
  xfs: use ->t_dfops for attr set/remove operations
  xfs: remove dfops param in attr fork add path
  xfs: use ->t_dfops in extent split tx and remove param
  xfs: replace xfs_da_args->dfops accesses with ->t_dfops and remove
  xfs: use ->t_dfops in dqalloc transaction
  xfs: use ->t_dfops for all xfs_bmapi_write() callers
  xfs: remove xfs_bmapi_write() dfops param
  xfs: use ->t_dfops for all xfs_bunmapi() callers
  xfs: remove xfs_bunmapi() dfops param
  xfs: remove xfs_bmapi_remap() dfops param
  xfs: remove struct xfs_bmalloca dfops field
  xfs: use ->t_dfops for collapse/insert range operations
  xfs: remove dfops param from internal bmap extent helpers
  xfs: remove xfs_btree_cur bmbt dfops field
  xfs: remove unused btree cursor bc_private.a.dfops field
  xfs: use ->t_dfops for rmap extent swap operations
  xfs: use ->t_dfops in cancel cow blocks operation
  xfs: use ->t_dfops in reflink cow recover path
  xfs: refactor dfops init to attach to transaction

 fs/xfs/libxfs/xfs_alloc.c          |   4 +-
 fs/xfs/libxfs/xfs_attr.c           | 116 ++++++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.c      |  24 ++--
 fs/xfs/libxfs/xfs_attr_remote.c    |  22 ++--
 fs/xfs/libxfs/xfs_bmap.c           | 178 +++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap.h           |  17 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     |   9 +-
 fs/xfs/libxfs/xfs_btree.h          |   2 -
 fs/xfs/libxfs/xfs_da_btree.c       |  19 ++-
 fs/xfs/libxfs/xfs_da_btree.h       |   1 -
 fs/xfs/libxfs/xfs_defer.c          |  17 ++-
 fs/xfs/libxfs/xfs_defer.h          |   3 +-
 fs/xfs/libxfs/xfs_dir2.c           |  75 ++++++------
 fs/xfs/libxfs/xfs_dir2.h           |   9 +-
 fs/xfs/libxfs/xfs_ialloc.c         |   6 +-
 fs/xfs/libxfs/xfs_ialloc.h         |   1 -
 fs/xfs/libxfs/xfs_refcount.c       |  14 +--
 fs/xfs/libxfs/xfs_refcount_btree.c |   7 +-
 fs/xfs/libxfs/xfs_refcount_btree.h |   4 +-
 fs/xfs/scrub/common.c              |   2 +-
 fs/xfs/xfs_bmap_item.c             |   3 +
 fs/xfs/xfs_bmap_util.c             |  63 +++++-----
 fs/xfs/xfs_dquot.c                 |  33 +++---
 fs/xfs/xfs_filestream.c            |   3 +-
 fs/xfs/xfs_fsmap.c                 |   2 +-
 fs/xfs/xfs_inode.c                 |  87 +++++++-------
 fs/xfs/xfs_inode.h                 |   3 +-
 fs/xfs/xfs_iomap.c                 |  25 ++--
 fs/xfs/xfs_log_recover.c           |   2 +-
 fs/xfs/xfs_refcount_item.c         |   3 +
 fs/xfs/xfs_reflink.c               |  68 ++++++-----
 fs/xfs/xfs_rtalloc.c               |   8 +-
 fs/xfs/xfs_symlink.c               |  22 ++--
 fs/xfs/xfs_trans.c                 |   6 +-
 fs/xfs/xfs_trans.h                 |   2 +-
 35 files changed, 415 insertions(+), 445 deletions(-)

-- 
2.17.1

