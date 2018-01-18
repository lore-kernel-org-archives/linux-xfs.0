Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39424 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeARIJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jan 2018 03:09:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I89Zp5091106
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 08:09:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fjq8ar3dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 08:09:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0I88pXB022223
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 08:08:51 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0I88pAp030965
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 08:08:51 GMT
Date: Thu, 18 Jan 2018 00:08:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.16-merge updated to 75d4a13
Message-ID: <20180118080850.GG25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfs-4.16-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

I still have my eye on Christoph's patch removing EXPERIMENTAL from
reflink, but I'm testing a fix for a quota accounting cow bug so it's
not in here yet.

The new head of the xfs-4.16-merge branch is commit:

75d4a13 xfs: fix non-debug build compiler warnings

New Commits:

Brian Foster (9):
      [2c8f626] xfs: print transaction log reservation on overrun
      [a6f4859] xfs: include inobt buffers in ifree tx log reservation
      [e8341d9] xfs: fix up agi unlinked list reservations
      [a606ebd] xfs: truncate transaction does not modify the inobt
      [f03c78f] xfs: include an allocfree res for inobt modifications
      [57af33e] xfs: refactor inode chunk alloc/free tx reservation
      [c017cb5] xfs: eliminate duplicate icreate tx reservation functions
      [ad90bb5] xfs: account finobt blocks properly in perag reservation
      [c468562] xfs: cancel tx on xfs_defer_finish() error during xattr set/remove

Colin Ian King (1):
      [a8789a5] xfs: fix check on struct_version for versions 4 or greater

Darrick J. Wong (59):
      [29c1c12] xfs: scrub inode nsec fields
      [5a9d929] iomap: report collisions between directio and buffered writes to userspace
      [5a0f433] xfs: ignore agfl read errors when not scrubbing agfl
      [e5b37fa] xfs: catch a few more error codes when scrubbing secondary sb
      [2b9e9b5] xfs: xfs_scrub_bmap should use for_each_xfs_iext
      [1ad1205] xfs: always grab transaction when scrubbing inode
      [d658e72] xfs: distinguish between corrupt inode and invalid inum in xfs_scrub_get_inode
      [59f6fec] xfs: remove XFS_FSB_SANITY_CHECK
      [8368a60] xfs: refactor long-format btree header verification routines
      [e1e55aa] xfs: refactor short form btree pointer verification
      [9101d37] xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3 data verifiers
      [31ca03c] xfs: refactor xfs_verifier_error and xfs_buf_ioerror
      [a6a781a] xfs: have buffer verifier functions report failing address
      [bc1a09b] xfs: refactor verifier callers to print address of failing check
      [50aa90e] xfs: verify dinode header first
      [71493b8] xfs: move inode fork verifiers to xfs_dinode_verify
      [1e1bbd8] xfs: create structure verifier function for shortform xattrs
      [0795e00] xfs: create structure verifier function for short form symlinks
      [dc042c2] xfs: refactor short form directory structure verifier function
      [9cfb9b4] xfs: provide a centralized method for verifying inline fork data
      [8ba92d4] xfs: fail out of xfs_attr3_leaf_lookup_int if it looks corrupt
      [b557259] xfs: create a new buf_ops pointer to verify structure metadata
      [eeea798] xfs: separate dquot repair into a separate function
      [eebf3ca] xfs: standardize quota verification function outputs
      [d9418ed] xfs: teach error reporting functions to take xfs_failaddr_t
      [9c712a1] xfs: dump the first 128 bytes of any corrupt buffer
      [b872af2] xfs: trace log reservations at mount time
      [c368ebc] xfs: hoist xfs_fs_geometry to libxfs
      [ac503a4] xfs: refactor the geometry structure filling function
      [46c5973] xfs: harden directory integrity checks some more
      [c219b01] xfs: clarify units in the failed metadata io message
      [3d170aa] xfs: change 0x%p -> %p in print messages
      [aff68a5] xfs: use %pS printk format for direct instruction addresses
      [c969004] xfs: use %px for data pointers when debugging
      [ce1d802] xfs: add scrub cross-referencing helpers for the free space btrees
      [2e00126] xfs: add scrub cross-referencing helpers for the inode btrees
      [ed7c52d] xfs: add scrub cross-referencing helpers for the rmap btrees
      [49db55e] xfs: add scrub cross-referencing helpers for the refcount btrees
      [64b1256] xfs: set up scrub cross-referencing helpers
      [9a7e269] xfs: fix a few erroneous process_error calls in the scrubbers
      [858333d] xfs: check btree block ownership with bnobt/rmapbt when scrubbing btree
      [166d764] xfs: introduce scrubber cross-referencing stubs
      [52dc4b4] xfs: cross-reference with the bnobt
      [e1134b1] xfs: cross-reference bnobt records with cntbt
      [2e6f275] xfs: cross-reference inode btrees during scrub
      [d852657] xfs: cross-reference reverse-mapping btree
      [dbde19d] xfs: cross-reference the rmapbt data with the refcountbt
      [f6d5fc2] xfs: cross-reference refcount btree during scrub
      [46d9bfb] xfs: cross-reference the realtime bitmap
      [561f648] xfs: cross-reference the block mappings when possible
      [cf1b0b8] xfs: scrub in-core metadata
      [638a717] xfs: don't iunlock unlocked inodes
      [ce92d29] xfs: directory scrubber must walk through data block to offset
      [79a69bf] xfs: attr leaf verifier needs to check for obviously bad count
      [55e4542] xfs: btree format ifork loader should check for zero numrecs
      [a5f460b] xfs: check that br_blockcount doesn't overflow
      [be78ff0] xfs: recheck reflink / dirty page status before freeing CoW reservations
      [4bb73d0] xfs: check sb_agblocks and sb_agblklog when validating superblock
      [75d4a13] xfs: fix non-debug build compiler warnings

Eric Sandeen (3):
      [bfb3e9b] xfs: explicitly initialize meta_scrub_ops array by type
      [0a085dd] xfs: factor out scrub input checking
      [8e63083] xfs: move all scrub input checking to xfs_scrub_validate

Richard Wareing (1):
      [a015831] xfs: Show realtime device stats on statfs calls if realtime flags set

Xiongwei Song (1):
      [1da0618] xfs: destroy mutex pag_ici_reclaim_lock before free


Code Diffstat:

 fs/direct-io.c                     |  24 ++-
 fs/iomap.c                         |  12 +-
 fs/xfs/libxfs/xfs_alloc.c          | 116 ++++++----
 fs/xfs/libxfs/xfs_alloc.h          |  10 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |  47 +++--
 fs/xfs/libxfs/xfs_attr.c           |   4 -
 fs/xfs/libxfs/xfs_attr_leaf.c      | 146 ++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h      |   1 +
 fs/xfs/libxfs/xfs_attr_remote.c    | 104 +++++----
 fs/xfs/libxfs/xfs_bmap.c           |  14 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  58 +++--
 fs/xfs/libxfs/xfs_btree.c          | 113 ++++++++--
 fs/xfs/libxfs/xfs_btree.h          |  16 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  68 ++++--
 fs/xfs/libxfs/xfs_da_format.h      |   6 +
 fs/xfs/libxfs/xfs_dir2.c           |   5 +-
 fs/xfs/libxfs/xfs_dir2.h           |   2 +
 fs/xfs/libxfs/xfs_dir2_block.c     |  37 ++--
 fs/xfs/libxfs/xfs_dir2_data.c      | 206 ++++++++++--------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  87 +++++---
 fs/xfs/libxfs/xfs_dir2_node.c      |  87 ++++----
 fs/xfs/libxfs/xfs_dir2_priv.h      |  12 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  30 ++-
 fs/xfs/libxfs/xfs_dquot_buf.c      | 174 +++++++--------
 fs/xfs/libxfs/xfs_fs.h             |   7 +
 fs/xfs/libxfs/xfs_ialloc.c         | 139 ++++++++++--
 fs/xfs/libxfs/xfs_ialloc.h         |   6 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  65 ++++--
 fs/xfs/libxfs/xfs_inode_buf.c      | 126 ++++++++---
 fs/xfs/libxfs/xfs_inode_buf.h      |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c     | 152 ++++----------
 fs/xfs/libxfs/xfs_inode_fork.h     |  14 ++
 fs/xfs/libxfs/xfs_log_rlimit.c     |   2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |   9 +-
 fs/xfs/libxfs/xfs_refcount.c       |  19 ++
 fs/xfs/libxfs/xfs_refcount.h       |   3 +
 fs/xfs/libxfs/xfs_refcount_btree.c |  40 ++--
 fs/xfs/libxfs/xfs_rmap.c           |  67 ++++++
 fs/xfs/libxfs/xfs_rmap.h           |   5 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |  40 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c       |  21 ++
 fs/xfs/libxfs/xfs_sb.c             | 111 +++++++++-
 fs/xfs/libxfs/xfs_sb.h             |   4 +
 fs/xfs/libxfs/xfs_shared.h         |   4 +
 fs/xfs/libxfs/xfs_symlink_remote.c |  73 +++++--
 fs/xfs/libxfs/xfs_trans_resv.c     | 199 ++++++++----------
 fs/xfs/scrub/agheader.c            | 340 ++++++++++++++++++++++++++++--
 fs/xfs/scrub/alloc.c               |  81 +++++++
 fs/xfs/scrub/bmap.c                | 219 ++++++++++++++++++-
 fs/xfs/scrub/btree.c               | 184 ++++++++++++++--
 fs/xfs/scrub/btree.h               |   9 +
 fs/xfs/scrub/common.c              | 255 +++++++++++++++++++---
 fs/xfs/scrub/common.h              |  23 +-
 fs/xfs/scrub/dabtree.c             |  22 ++
 fs/xfs/scrub/dir.c                 |  44 +++-
 fs/xfs/scrub/ialloc.c              | 194 ++++++++++++++++-
 fs/xfs/scrub/inode.c               | 178 ++++++++++++++--
 fs/xfs/scrub/parent.c              |   8 +-
 fs/xfs/scrub/quota.c               |   7 -
 fs/xfs/scrub/refcount.c            | 420 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/rmap.c                | 123 +++++++++++
 fs/xfs/scrub/rtbitmap.c            |  35 +++-
 fs/xfs/scrub/scrub.c               | 203 ++++++++++++------
 fs/xfs/scrub/scrub.h               |  37 ++++
 fs/xfs/scrub/trace.h               |  42 +++-
 fs/xfs/xfs_aops.c                  |   2 +-
 fs/xfs/xfs_buf.c                   |  21 +-
 fs/xfs/xfs_buf.h                   |   5 +-
 fs/xfs/xfs_dir2_readdir.c          |   4 +-
 fs/xfs/xfs_dquot.c                 |  62 +-----
 fs/xfs/xfs_dquot_item.c            |   7 +-
 fs/xfs/xfs_error.c                 |  27 ++-
 fs/xfs/xfs_error.h                 |  11 +-
 fs/xfs/xfs_fsops.c                 |  79 +------
 fs/xfs/xfs_fsops.h                 |   1 -
 fs/xfs/xfs_icache.c                |  68 ++++--
 fs/xfs/xfs_inode.c                 |  44 +++-
 fs/xfs/xfs_inode.h                 |   2 +
 fs/xfs/xfs_ioctl.c                 |   5 +-
 fs/xfs/xfs_ioctl32.c               |   3 +-
 fs/xfs/xfs_linux.h                 |  14 ++
 fs/xfs/xfs_log.c                   |   8 +-
 fs/xfs/xfs_log_recover.c           |  52 +++--
 fs/xfs/xfs_mount.c                 |   3 +
 fs/xfs/xfs_qm.c                    |  33 ++-
 fs/xfs/xfs_rtalloc.h               |   4 +
 fs/xfs/xfs_super.c                 |   8 +
 fs/xfs/xfs_trace.h                 |  68 ++++--
 fs/xfs/xfs_trans.c                 |  22 ++
 include/linux/fs.h                 |   1 +
 90 files changed, 4169 insertions(+), 1298 deletions(-)
