Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45126 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdHAOhk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 10:37:40 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8459180CA43
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2017 09:36:50 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 15a8bcc
Message-ID: <a065b637-5527-4a48-7264-8472da919cd1@sandeen.net>
Date: Tue, 1 Aug 2017 09:37:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the libxfs sync to 4.13-rc3.  I'll get started
on functional patches to xfsprogs next.

The new head of the for-next branch is commit:

15a8bcc xfs: fix multi-AG deadlock in xfs_bunmapi

New Commits:

Christoph Hellwig (4):
      [a9d26e4] xfs: remove XFS_HSIZE
      [baebed8] xfs: fixup xfs_attr_get_ilocked
      [7fb34b5] Revert "xfs: grab dquots without taking the ilock"
      [15a8bcc] xfs: fix multi-AG deadlock in xfs_bunmapi

Darrick J. Wong (18):
      [594956f] xfs: try to avoid blowing out the transaction reservation when b
      [f296858] xfs: optimize _btree_query_all
      [4a492e7] xfs: remove double-underscore integer types
      [e493253] xfs: always compile the btree inorder check functions
      [50bb67d] xfs: export various function for the online scrubber
      [4e388bc] xfs: plumb in needed functions for range querying of various btr
      [b5f6747] xfs: export _inobt_btrec_to_irec and _ialloc_cluster_alignment f
      [94ffb80] xfs: return the hash value of a leaf1 directory block
      [581ce8a] xfs: pass along transaction context when reading directory block
      [b2d5ffd] xfs: pass along transaction context when reading xattr block buf
      [e2a190d] xfs: remove unneeded parameter from XFS_TEST_ERROR
      [cb0dc9b] xfs: grab dquots without taking the ilock
      [b8fb8c9] xfs: rename MAXPATHLEN to XFS_SYMLINK_MAXLEN
      [a6c6b1b] xfs: don't crash on unexpected holes in dir/attr btrees
      [c3d6d07] xfs: check _btree_check_block value
      [66d19ae] xfs: set firstfsb to NULLFSBLOCK before feeding it to _bmapi_wri
      [d705962] xfs: check _alloc_read_agf buffer pointer before using
      [f9f5e90] xfs: check that dir block entries don't off the end of the buffe


Code Diffstat:

 libxfs/defer_item.c         |   9 +-
 libxfs/libxfs_priv.h        |   3 +-
 libxfs/xfs_ag_resv.c        |   3 +-
 libxfs/xfs_alloc.c          |   8 +-
 libxfs/xfs_alloc.h          |   2 +
 libxfs/xfs_alloc_btree.c    |  26 ++---
 libxfs/xfs_attr.c           |  28 +++--
 libxfs/xfs_attr_leaf.c      |   2 +-
 libxfs/xfs_attr_remote.c    |  13 +--
 libxfs/xfs_attr_sf.h        |  10 +-
 libxfs/xfs_bit.h            |  24 ++---
 libxfs/xfs_bmap.c           |  72 ++++++++++---
 libxfs/xfs_bmap.h           |   2 +-
 libxfs/xfs_bmap_btree.c     |  34 ++++--
 libxfs/xfs_btree.c          |  58 +++++-----
 libxfs/xfs_btree.h          |  33 ++++--
 libxfs/xfs_cksum.h          |  16 +--
 libxfs/xfs_da_btree.c       |  14 +--
 libxfs/xfs_da_btree.h       |   8 +-
 libxfs/xfs_da_format.c      |  28 ++---
 libxfs/xfs_da_format.h      |  64 +++++------
 libxfs/xfs_dir2.c           |   3 +-
 libxfs/xfs_dir2.h           |   8 +-
 libxfs/xfs_dir2_block.c     |   2 +-
 libxfs/xfs_dir2_data.c      |   4 +
 libxfs/xfs_dir2_leaf.c      |  18 ++--
 libxfs/xfs_dir2_node.c      |  10 +-
 libxfs/xfs_dir2_priv.h      |  10 +-
 libxfs/xfs_dir2_sf.c        |   4 +-
 libxfs/xfs_format.h         | 113 +++++++++----------
 libxfs/xfs_fs.h             |  16 ++-
 libxfs/xfs_ialloc.c         |  53 +++++----
 libxfs/xfs_ialloc.h         |   5 +
 libxfs/xfs_ialloc_btree.c   |  36 +++++--
 libxfs/xfs_inode_buf.c      |   7 +-
 libxfs/xfs_inode_buf.h      |  31 +++---
 libxfs/xfs_log_format.h     | 256 ++++++++++++++++++++++----------------------
 libxfs/xfs_quota_defs.h     |   4 +-
 libxfs/xfs_refcount.c       |  20 ++--
 libxfs/xfs_refcount.h       |  16 +++
 libxfs/xfs_refcount_btree.c |  12 +--
 libxfs/xfs_rmap.c           |  14 +--
 libxfs/xfs_rmap.h           |  11 +-
 libxfs/xfs_rmap_btree.c     |  34 +++---
 libxfs/xfs_rtbitmap.c       |   4 +-
 libxfs/xfs_sb.c             |   4 +-
 libxfs/xfs_symlink_remote.c |   2 +-
 libxfs/xfs_trans_resv.c     |   4 +-
 libxfs/xfs_types.h          |  46 ++++----
 49 files changed, 668 insertions(+), 536 deletions(-)
