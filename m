Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdEKTkh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 15:40:37 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AEEF6C059742
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 19:40:36 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85C37183D1
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 19:40:36 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [ANNOUNCE] xfsprogs: for-next updated to b455713
Message-ID: <b9f3dc7c-a7f8-a339-0867-426298ad3198@redhat.com>
Date: Thu, 11 May 2017 14:40:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just a merge of the latest libxfs commits from the
pending linux-2.6 4.12 release, with a new topic branch for that,
and merged into for-next.

(this reduces the libxfs-diff result by just a little, yay \o/)

The new head of the for-next branch is commit:

b455713 xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS

New Commits:

Christoph Hellwig (10):
      [ef0b177] xfs: remove the ISUNWRITTEN macro
      [57add91] xfs: fix integer truncation in xfs_bmap_remap_alloc
      [95855a2] xfs: remove attr fork handling in xfs_bmap_finish_one
      [972432f] xfs: pass individual arguments to xfs_bmap_add_extent_hole_real
      [0b44aa8] xfs: introduce xfs_bmapi_remap
      [05422db] xfs: remove xfs_bmap_remap_alloc
      [52bff94] xfs: remove bmap block allocation retries
      [838db3c] xfs: remove the unused XFS_MAXLINK_1 define
      [c6e1bd2] xfs: remove unused values from xfs_exntst_t
      [1f2a447] xfs: simplify validation of the unwritten extent bit

Darrick J. Wong (6):
      [46a1586] xfs: plumb in needed functions for range querying of the freespace btrees
      [b3d83fa] xfs: provide a query_range function for freespace btrees
      [7e05e85] xfs: create a function to query all records in a btree
      [0b10a7f] xfs: add a couple of queries to iterate free extents in the rtbitmap
      [9282c50] xfs: implement the GETFSMAP ioctl
      [4726325] xfs: reserve enough blocks to handle btree splits when remapping

Eric Sandeen (3):
      [18f2e04] xfs: fix up inode validation failure message
      [2db39f3] xfs: simplify xfs_calc_dquots_per_chunk
      [f1e0bd8] xfs: more do_div cleanups

Michal Hocko (1):
      [b455713] xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS


Code Diffstat:

 libxfs/libxfs_priv.h     |  10 ++
 libxfs/xfs_alloc.c       |  57 ++++++++
 libxfs/xfs_alloc.h       |  12 ++
 libxfs/xfs_alloc_btree.c | 172 ++++++++++++++++------
 libxfs/xfs_bmap.c        | 354 +++++++++++++++++++++-------------------------
 libxfs/xfs_bmap.h        |   2 -
 libxfs/xfs_bmap_btree.c  |  43 ------
 libxfs/xfs_bmap_btree.h  |  22 +--
 libxfs/xfs_btree.c       |  17 ++-
 libxfs/xfs_btree.h       |   2 +
 libxfs/xfs_dquot_buf.c   |  15 --
 libxfs/xfs_format.h      |  11 --
 libxfs/xfs_fs.h          |  13 ++
 libxfs/xfs_inode_buf.c   |   2 +-
 libxfs/xfs_inode_fork.c  |  90 ++++--------
 libxfs/xfs_rmap.c        |  56 +++++++-
 libxfs/xfs_rmap.h        |   4 +
 libxfs/xfs_rtbitmap.c    |  70 +++++++++
 libxfs/xfs_trans_space.h |  23 ++-
 19 files changed, 582 insertions(+), 393 deletions(-)
