Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbeGSOcf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86BF6406E971
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 715911C5B0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 13:49:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/14] xfs: embed dfops in the transaction
Date: Thu, 19 Jul 2018 09:49:05 -0400
Message-Id: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's the last dfops refactoring series. The objective is to embed
dfops in the transaction. In doing so, the boilerplate xfs_trans_alloc()
-> xfs_defer_init() -> xfs_defer_finish() -> xfs_trans_commit() pattern
is reduced to a transaction allocation and commit.

Patches 1-7 are various preparatory, cleanup and/or bug fix patches.
Patch 8 adds an internal dfops field to xfs_trans with some supporting
mechanism bits. Patches 9-11 convert the various deferred op using paths
over to use the internal transaction dfops instead of the on-stack
variant. Patches 12-13 remove a bunch of the boilerplate dfops code that
is made superfluous by the previous changes. Finally, patch 14 drops the
no longer necessary dfops param to xfs_defer_finish().

I think most of this is relatively straightforward and survives my
testing so far. FWIW, I think there are still a couple more related
cleanups that could be made on top of this series. For one, I need to
optimize on top of Darrick's recently posted xfs_defer_finish() patch to
return a clean transaction. Other things to consider might be to do away
with support for external dfops and the ->t_dfops pointer indirection,
or perhaps even consider going the other direction: allocate dfops from
a separate zone to save some memory on non-permanent transactions (note
that 16 of 28 transactions use a permanent log res. last I looked, so it
may not be worth it atm).

I know Christoph also had thoughts around condensing some of the items
joined to the dfops to those with the transaction. I have yet to think
about that one, but I do have an RFC quality patch laying around that
replaces the ->dop_low flag with a transaction flag (->t_flags),
eliminating the need for that extra byte in xfs_defer_ops. The one quirk
associated with that is the question of whether we want to preserve the
behavior where low mode remains active across the series of transactions
associated with the traditional (on-stack) dfops or is reset on
transaction roll (a la firstblock). I'll post that RFC separately for a
more proper discussion..

Brian

Brian Foster (14):
  xfs: pull up dfops from xfs_itruncate_extents()
  xfs: use ->t_dfops in log recovery intent processing
  xfs: fix transaction leak on remote attr set/remove failure
  xfs: make deferred processing safe for embedded dfops
  xfs: remove unused deferred ops committed field
  xfs: reset dfops to initial state after finish
  xfs: pack holes in xfs_defer_ops and xfs_trans
  xfs: support embedded dfops in transaction
  xfs: use internal dfops in cow blocks cancel
  xfs: use internal dfops in attr code
  xfs: use internal dfops during [b|c]ui recovery
  xfs: remove all boilerplate defer init/finish code
  xfs: remove unnecessary dfops init calls in xattr code
  xfs: drop unnecessary xfs_defer_finish() dfops parameter

 fs/xfs/libxfs/xfs_alloc_btree.c    |  1 +
 fs/xfs/libxfs/xfs_attr.c           | 49 ++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.c      |  1 +
 fs/xfs/libxfs/xfs_attr_remote.c    | 13 ++--
 fs/xfs/libxfs/xfs_bmap.c           | 16 +----
 fs/xfs/libxfs/xfs_da_btree.c       |  1 +
 fs/xfs/libxfs/xfs_defer.c          | 95 +++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_defer.h          |  9 +--
 fs/xfs/libxfs/xfs_dir2_block.c     |  1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c        |  1 +
 fs/xfs/libxfs/xfs_dquot_buf.c      |  1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  1 +
 fs/xfs/libxfs/xfs_inode_fork.c     |  1 +
 fs/xfs/libxfs/xfs_refcount.c       | 10 +---
 fs/xfs/libxfs/xfs_refcount_btree.c |  1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |  1 +
 fs/xfs/libxfs/xfs_trans_resv.c     |  1 +
 fs/xfs/xfs_aops.c                  |  1 +
 fs/xfs/xfs_attr_inactive.c         |  1 +
 fs/xfs/xfs_attr_list.c             |  1 +
 fs/xfs/xfs_bmap_item.c             | 21 +++----
 fs/xfs/xfs_bmap_util.c             | 45 +++-----------
 fs/xfs/xfs_buf_item.c              |  1 +
 fs/xfs/xfs_dir2_readdir.c          |  1 +
 fs/xfs/xfs_dquot.c                 |  8 +--
 fs/xfs/xfs_dquot_item.c            |  1 +
 fs/xfs/xfs_export.c                |  1 +
 fs/xfs/xfs_extent_busy.c           |  1 +
 fs/xfs/xfs_extfree_item.c          |  1 +
 fs/xfs/xfs_file.c                  |  1 +
 fs/xfs/xfs_icache.c                |  1 +
 fs/xfs/xfs_icreate_item.c          |  1 +
 fs/xfs/xfs_inode.c                 | 87 +++++----------------------
 fs/xfs/xfs_inode_item.c            |  1 +
 fs/xfs/xfs_ioctl.c                 |  1 +
 fs/xfs/xfs_iomap.c                 | 26 +-------
 fs/xfs/xfs_iops.c                  |  1 +
 fs/xfs/xfs_log.c                   |  1 +
 fs/xfs/xfs_log_cil.c               |  1 +
 fs/xfs/xfs_log_recover.c           | 12 +---
 fs/xfs/xfs_pnfs.c                  |  1 +
 fs/xfs/xfs_qm.c                    |  1 +
 fs/xfs/xfs_qm_bhv.c                |  1 +
 fs/xfs/xfs_qm_syscalls.c           |  1 +
 fs/xfs/xfs_quotaops.c              |  1 +
 fs/xfs/xfs_refcount_item.c         | 30 +++++-----
 fs/xfs/xfs_reflink.c               | 51 ++++++----------
 fs/xfs/xfs_rtalloc.c               |  9 +--
 fs/xfs/xfs_super.c                 |  1 +
 fs/xfs/xfs_symlink.c               | 38 +++---------
 fs/xfs/xfs_trace.h                 |  8 +--
 fs/xfs/xfs_trans.c                 | 32 ++++++++--
 fs/xfs/xfs_trans.h                 | 12 +++-
 fs/xfs/xfs_trans_ail.c             |  1 +
 fs/xfs/xfs_trans_buf.c             |  1 +
 fs/xfs/xfs_trans_dquot.c           |  1 +
 fs/xfs/xfs_trans_inode.c           |  1 +
 60 files changed, 266 insertions(+), 346 deletions(-)

-- 
2.17.1

