Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737E4C433B4
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Apr 2021 00:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413A161105
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Apr 2021 00:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhDJAN3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235230AbhDJAN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Apr 2021 20:13:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B73061007
        for <linux-xfs@vger.kernel.org>; Sat, 10 Apr 2021 00:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618013593;
        bh=4saPZkVs9i5G6S4gRRluouj2dy2MZ+RB7CsYAbsx6kI=;
        h=Date:From:To:Subject:From;
        b=qlpHkTidcOQ+BVYC2O+GPhlxYMEk9E+/4+iRo5pxvQ2EnfOEzB7nkexJDPENV0pPt
         91/hP5b0qPcs5tYTjSEm55Uz5mBvrEFDU3v8fmIun3nMy9dyG19otXRBAZtx67CTKa
         ya2Nc6ITdTXIuB4+4jejiWIOrO7eFbsgK5oVdR8x7CkUeWHuKuLd5tm4xe+fYbCBPb
         Xeor29Bpzeyrfa97KHZiYm5H8/02rDspWPNRUNk9i95jeW4LXJEBw5T4s0TO4gaJHY
         jz1loOr+C0/8pyXoO9kgv+VnygWFARpLfA+aTpKPYaRAUaoUdAVH3K0A+A9aaz49sU
         D0WjVPy4h2dpA==
Date:   Fri, 9 Apr 2021 17:13:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to e7a3d7e792a5
Message-ID: <20210410001313.GI3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Still waiting on my list is Brian Foster's patchset to
exclude the space used by free space btrees when deciding if it's time
to throw ENOSPC at users.

The new head of the for-next branch is commit:

e7a3d7e792a5 xfs: drop unnecessary setfilesize helper

New Commits:

Anthony Iliopoulos (2):
      [25dfa65f8149] xfs: fix xfs_trans slab cache name
      [fcb62c28031e] xfs: deprecate BMV_IF_NO_DMAPI_READ flag

Bhaskar Chowdhury (3):
      [bd24a4f5f7fd] xfs: Rudimentary typo fixes
      [0145225e353e] xfs: Rudimentary spelling fix
      [f9dd7ba4308c] xfs: Fix a typo

Brian Foster (4):
      [7cd3099f4925] xfs: drop submit side trans alloc for append ioends
      [7adb8f14e134] xfs: open code ioend needs workqueue helper
      [044c6449f18f] xfs: drop unused ioend private merge and setfilesize code
      [e7a3d7e792a5] xfs: drop unnecessary setfilesize helper

Chandan Babu R (5):
      [5147ef30f2cd] xfs: Fix dax inode extent calculation when direct write is performed on an unwritten extent
      [6e8bd39d7227] xfs: Initialize xfs_alloc_arg->total correctly when allocating minlen extents
      [e773f88029b1] xfs: scrub: Remove incorrect check executed on block format directories
      [b6785e279d53] xfs: Use struct xfs_bmdr_block instead of struct xfs_btree_block to calculate root node size
      [ae7bae68ea49] xfs: scrub: Disable check for unoptimized data fork bmbt node

Christoph Hellwig (20):
      [af9dcddef662] xfs: split xfs_imap_to_bp
      [4cb6f2e8c2c7] xfs: consistently initialize di_flags2
      [582a73440bf5] xfs: handle crtime more carefully in xfs_bulkstat_one_int
      [55f773380e92] xfs: remove the unused xfs_icdinode_has_bigtime helper
      [9b3beb028ff5] xfs: remove the di_dmevmask and di_dmstate fields from struct xfs_icdinode
      [7e2a8af52839] xfs: don't clear the "dinode core" in xfs_inode_alloc
      [ceaf603c7024] xfs: move the di_projid field to struct xfs_inode
      [13d2c10b05d8] xfs: move the di_size field to struct xfs_inode
      [6e73a545f91e] xfs: move the di_nblocks field to struct xfs_inode
      [031474c28a3a] xfs: move the di_extsize field to struct xfs_inode
      [b33ce57d3e61] xfs: move the di_cowextsize field to struct xfs_inode
      [965e0a1ad273] xfs: move the di_flushiter field to struct xfs_inode
      [4800887b4574] xfs: cleanup xfs_fill_fsxattr
      [b231b1221b39] xfs: use XFS_B_TO_FSB in xfs_ioctl_setattr
      [ee7b83fd365e] xfs: use a union for i_cowextsize and i_flushiter
      [7821ea302dca] xfs: move the di_forkoff field to struct xfs_inode
      [db07349da2f5] xfs: move the di_flags field to struct xfs_inode
      [3e09ab8fdc4d] xfs: move the di_flags2 field to struct xfs_inode
      [e98d5e882b3c] xfs: move the di_crtime field to struct xfs_inode
      [4422501da6b3] xfs: merge _xfs_dic2xflags into xfs_ip2xflags

Colin Ian King (1):
      [3b6dd9a9aeea] xfs: fix return of uninitialized value in variable error

Darrick J. Wong (14):
      [e424aa5f547d] xfs: drop freeze protection when running GETFSMAP
      [1aa26707ebd6] xfs: fix uninitialized variables in xrep_calc_ag_resblks
      [05237032fdec] xfs: fix dquot scrub loop cancellation
      [7716ee54cb88] xfs: bail out of scrub immediately if scan incomplete
      [9de4b514494a] xfs: mark a data structure sick if there are cross-referencing errors
      [de9d2a78add1] xfs: set the scrub AG number in xchk_ag_read_headers
      [f53acface7a9] xfs: remove return value from xchk_ag_btcur_init
      [973975b72a36] xfs: validate ag btree levels using the precomputed values
      [383e32b0d0db] xfs: prevent metadata files from being inactivated
      [3fef46fc43ca] xfs: rename the blockgc workqueue
      [2b156ff8c82e] xfs: move the xfs_can_free_eofblocks call under the IOLOCK
      [7d88329e5b0f] xfs: move the check for post-EOF mappings into xfs_can_free_eofblocks
      [71bddbccab43] xfs: fix scrub and remount-ro protection when running scrub
      [026f57ebe1be] xfs: get rid of the ip parameter to xchk_setup_*

Dave Chinner (12):
      [e6a688c33238] xfs: initialise attr fork on inode create
      [accc661bf99a] xfs: reduce buffer log item shadow allocations
      [c81ea11e0332] xfs: xfs_buf_item_size_segment() needs to pass segment offset
      [929f8b0deb83] xfs: optimise xfs_buf_item_size/format for contiguous regions
      [ec08c14ba28c] xfs: type verification is expensive
      [39d3c0b5968b] xfs: No need for inode number error injection in __xfs_dir3_data_check
      [1fea323ff005] xfs: reduce debug overhead of dir leaf/node checks
      [5825bea05265] xfs: __percpu_counter_compare() inode count debug too expensive
      [2442ee15bb1e] xfs: eager inode attr fork init needs attr feature awareness
      [8de1cb003802] xfs: inode fork allocation depends on XFS_IFEXTENT flag
      [683ec9ba887d] xfs: default attr fork size does not handle device inodes
      [b2941046ea85] xfs: precalculate default inode attribute offset

Gao Xiang (6):
      [b2c2974b8cdf] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
      [014695c0a78e] xfs: update lazy sb counters immediately for resizefs
      [c789c83c7ef8] xfs: hoist out xfs_resizefs_init_new_ags()
      [46141dc891f7] xfs: introduce xfs_ag_shrink_space()
      [fb2fc1720185] xfs: support shrinking unused space in the last AG
      [2b92faed5511] xfs: add error injection for per-AG resv failure

Pavel Reichl (2):
      [0f98b4ece18d] xfs: rename variable mp to parsing_mp
      [92cf7d36384b] xfs: Skip repetitive warnings about mount options


Code Diffstat:

 Documentation/admin-guide/xfs.rst |   2 +-
 fs/xfs/libxfs/xfs_ag.c            | 115 +++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h            |   2 +
 fs/xfs/libxfs/xfs_ag_resv.c       |   6 +-
 fs/xfs/libxfs/xfs_alloc.c         |   8 +-
 fs/xfs/libxfs/xfs_attr.c          |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c     |  22 ++--
 fs/xfs/libxfs/xfs_bmap.c          |  88 +++++++------
 fs/xfs/libxfs/xfs_bmap.h          |   1 +
 fs/xfs/libxfs/xfs_bmap_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.c      |   4 +-
 fs/xfs/libxfs/xfs_dir2.c          |  14 +--
 fs/xfs/libxfs/xfs_dir2_block.c    |  10 +-
 fs/xfs/libxfs/xfs_dir2_data.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c     |  12 +-
 fs/xfs/libxfs/xfs_dir2_node.c     |   4 +-
 fs/xfs/libxfs/xfs_dir2_priv.h     |   3 +-
 fs/xfs/libxfs/xfs_dir2_sf.c       |  46 +++----
 fs/xfs/libxfs/xfs_errortag.h      |   4 +-
 fs/xfs/libxfs/xfs_format.h        |   5 +-
 fs/xfs/libxfs/xfs_fs.h            |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c        |   4 +-
 fs/xfs/libxfs/xfs_iext_tree.c     |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c     |  81 +++++-------
 fs/xfs/libxfs/xfs_inode_buf.h     |  33 +----
 fs/xfs/libxfs/xfs_inode_fork.c    |  26 ++--
 fs/xfs/libxfs/xfs_inode_fork.h    |   6 +-
 fs/xfs/libxfs/xfs_rtbitmap.c      |   4 +-
 fs/xfs/libxfs/xfs_shared.h        |   4 +
 fs/xfs/libxfs/xfs_trans_inode.c   |   7 +-
 fs/xfs/libxfs/xfs_types.c         |  18 +--
 fs/xfs/scrub/agheader.c           |  33 ++---
 fs/xfs/scrub/alloc.c              |   5 +-
 fs/xfs/scrub/attr.c               |   5 +-
 fs/xfs/scrub/bmap.c               |   5 +-
 fs/xfs/scrub/btree.c              |  30 ++++-
 fs/xfs/scrub/common.c             |  38 +++---
 fs/xfs/scrub/common.h             |  58 ++++-----
 fs/xfs/scrub/dir.c                |  20 +--
 fs/xfs/scrub/fscounters.c         |   3 +-
 fs/xfs/scrub/health.c             |   3 +-
 fs/xfs/scrub/ialloc.c             |   8 +-
 fs/xfs/scrub/inode.c              |   5 +-
 fs/xfs/scrub/parent.c             |   7 +-
 fs/xfs/scrub/quota.c              |  11 +-
 fs/xfs/scrub/refcount.c           |   5 +-
 fs/xfs/scrub/repair.c             |  11 +-
 fs/xfs/scrub/repair.h             |   6 +-
 fs/xfs/scrub/rmap.c               |   5 +-
 fs/xfs/scrub/rtbitmap.c           |   7 +-
 fs/xfs/scrub/scrub.c              |  42 ++++---
 fs/xfs/scrub/scrub.h              |  14 ++-
 fs/xfs/scrub/symlink.c            |   7 +-
 fs/xfs/scrub/xfs_scrub.h          |   4 +-
 fs/xfs/xfs_aops.c                 | 135 +++-----------------
 fs/xfs/xfs_bmap_util.c            | 199 +++++++++++++++--------------
 fs/xfs/xfs_buf_item.c             | 141 ++++++++++++++++-----
 fs/xfs/xfs_dir2_readdir.c         |   2 +-
 fs/xfs/xfs_dquot.c                |   2 +-
 fs/xfs/xfs_error.c                |   5 +
 fs/xfs/xfs_file.c                 |  12 +-
 fs/xfs/xfs_filestream.h           |   2 +-
 fs/xfs/xfs_fsmap.c                |  14 +--
 fs/xfs/xfs_fsops.c                | 195 ++++++++++++++++++-----------
 fs/xfs/xfs_icache.c               |  35 +++---
 fs/xfs/xfs_inode.c                | 254 ++++++++++++++++++++------------------
 fs/xfs/xfs_inode.h                |  42 +++++--
 fs/xfs/xfs_inode_item.c           |  56 ++++++---
 fs/xfs/xfs_ioctl.c                |  69 ++++++-----
 fs/xfs/xfs_iomap.c                |   7 +-
 fs/xfs/xfs_iops.c                 |  61 ++++++---
 fs/xfs/xfs_itable.c               |  19 ++-
 fs/xfs/xfs_linux.h                |   2 +-
 fs/xfs/xfs_log_recover.c          |  13 +-
 fs/xfs/xfs_mount.c                |  14 ++-
 fs/xfs/xfs_mount.h                |   2 +-
 fs/xfs/xfs_pnfs.c                 |   2 +-
 fs/xfs/xfs_qm.c                   |  14 +--
 fs/xfs/xfs_qm_bhv.c               |   2 +-
 fs/xfs/xfs_qm_syscalls.c          |   2 +-
 fs/xfs/xfs_quotaops.c             |   2 +-
 fs/xfs/xfs_reflink.c              |  14 +--
 fs/xfs/xfs_rtalloc.c              |  16 +--
 fs/xfs/xfs_super.c                | 132 +++++++++++---------
 fs/xfs/xfs_symlink.c              |  22 ++--
 fs/xfs/xfs_trace.h                |  16 +--
 fs/xfs/xfs_trans.c                |  14 +--
 fs/xfs/xfs_xattr.c                |   2 +
 88 files changed, 1323 insertions(+), 1070 deletions(-)
