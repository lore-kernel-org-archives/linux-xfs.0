Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932834AbeGCRXT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:19 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6FBF77264C
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 585891117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/25] xfs: embed firstblock in xfs_trans
Date: Tue,  3 Jul 2018 13:22:54 -0400
Message-Id: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is a quick refactor of firstblock usage thoughout XFS. A firstblock
variable is used to track the first allocation of a transaction to help
maintain AG lock order, but it has historically been passed all over the
place independent from the associated transaction (similar to dfops).
This makes sense in some cases where the transaction is rolled, but even
with that case, this can all be handled with a bit less code by pushing
firstblock directly into the transaction.

These are mostly simple, mechanical refactoring patches. The whole thing
could probably be squashed into half the patch count, but I opted to
keep smaller patches as it is easier to squash them later than take them
apart depending on preference. The series applies on top of the recent
->t_dfops refactoring series [1].

Patch 1 is a simple prepatory patch. Patch 2 adds the new ->t_firstblock
field to xfs_trans. Patches 3-24 are a sequence of replacing on-stack
firstblock usage with ->t_firstblock and removing unnecessary firstblock
function parameters and args passing struct fields. Once every
transaction that requires it is converted over to ->t_firstblock, patch
25 eliminates the unnecessary parameter and initialization from
xfs_defer_init().

This all survives a couple rounds of xfstests (with KASAN enabled)
without any explosions. Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=153020380302037&w=2

Brian Foster (25):
  xfs: allow null firstblock in xfs_bmapi_write() when tp is null
  xfs: add firstblock field to xfs_trans
  xfs: use ->t_firstblock in dir ops
  xfs: remove firstblock param from xfs dir ops
  xfs: use ->t_firstblock in attrfork add
  xfs: use ->t_firstblock in xattr ops
  xfs: use ->t_firstblock for all xfs_bmapi_write() callers
  xfs: use ->t_firstblock for all xfs_bunmapi() callers
  xfs: use ->t_firstblock in xfs_bmapi_remap()
  xfs: use ->t_firstblock in insert/collapse range
  xfs: remove xfs_bmapi_write() firstblock param
  xfs: remove xfs_bunmapi() firstblock param
  xfs: remove bmap insert/collapse firstblock param
  xfs: use ->t_firstblock in bmap extent split
  xfs: remove xfs_bmalloca firstblock field
  xfs: remove bmap extent add helper firstblock params
  xfs: remove bmap format helpers firstblock params
  xfs: remove xfs_btree_cur private firstblock field
  xfs: remove xfs_alloc_arg firstblock field
  xfs: use ->t_firstblock in dq alloc
  xfs: replace no-op firstblock init with ->t_firstblock
  xfs: use ->t_firstblock in reflink cow block cancel
  xfs: use ->t_firstblock in extent swap
  xfs: use ->t_firstblock in inode inactivate
  xfs: remove xfs_defer_init() firstblock param

 fs/xfs/libxfs/xfs_alloc.c          |  20 ++--
 fs/xfs/libxfs/xfs_alloc.h          |   1 -
 fs/xfs/libxfs/xfs_attr.c           |  29 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c      |   2 -
 fs/xfs/libxfs/xfs_attr_remote.c    |  13 +--
 fs/xfs/libxfs/xfs_bmap.c           | 181 +++++++++--------------------
 fs/xfs/libxfs/xfs_bmap.h           |  13 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  11 +-
 fs/xfs/libxfs/xfs_btree.h          |   1 -
 fs/xfs/libxfs/xfs_da_btree.c       |   9 +-
 fs/xfs/libxfs/xfs_da_btree.h       |   1 -
 fs/xfs/libxfs/xfs_defer.c          |   5 +-
 fs/xfs/libxfs/xfs_defer.h          |   3 +-
 fs/xfs/libxfs/xfs_dir2.c           |  12 +-
 fs/xfs/libxfs/xfs_dir2.h           |   6 +-
 fs/xfs/libxfs/xfs_refcount.c       |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   1 -
 fs/xfs/xfs_bmap_util.c             |  29 ++---
 fs/xfs/xfs_dquot.c                 |   9 +-
 fs/xfs/xfs_inode.c                 |  55 ++++-----
 fs/xfs/xfs_iomap.c                 |  20 ++--
 fs/xfs/xfs_log_recover.c           |   3 +-
 fs/xfs/xfs_reflink.c               |  28 ++---
 fs/xfs/xfs_rtalloc.c               |   7 +-
 fs/xfs/xfs_symlink.c               |  14 +--
 fs/xfs/xfs_trace.h                 |   2 +-
 fs/xfs/xfs_trans.c                 |   2 +
 fs/xfs/xfs_trans.h                 |   1 +
 28 files changed, 170 insertions(+), 310 deletions(-)

-- 
2.17.1

